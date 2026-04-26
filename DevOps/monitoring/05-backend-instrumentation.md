# Instrumentation Prometheus du backend Go

**Destinataire** : Agent Backend  
**Dernière mise à jour** : 2026-04-26  
**Contexte** : Ce document décrit ce que le microservice `collection-management` (Go/Chi) doit implémenter pour exposer ses métriques à Prometheus. L'infrastructure Prometheus est déjà configurée et attend un endpoint `/metrics` sur le port 8080 — voir [02-prometheus.md](02-prometheus.md).

---

## Table des matières

1. [Dépendance Go à ajouter](#1-dépendance-go-à-ajouter)
2. [Endpoint /metrics](#2-endpoint-metrics)
3. [Métriques custom recommandées](#3-métriques-custom-recommandées)
4. [Middleware Chi d'instrumentation automatique](#4-middleware-chi-dinstrumentation-automatique)
5. [Intégration dans le router Chi](#5-intégration-dans-le-router-chi)
6. [Format attendu par Prometheus](#6-format-attendu-par-prometheus)
7. [Vérification](#7-vérification)

---

## 1. Dépendance Go à ajouter

Dans `backend/collection-management/` :

```bash
go get github.com/prometheus/client_golang@latest
go mod tidy
```

Packages importés dans le code :

```go
import (
    "github.com/prometheus/client_golang/prometheus"
    "github.com/prometheus/client_golang/prometheus/promauto"
    "github.com/prometheus/client_golang/prometheus/promhttp"
)
```

---

## 2. Endpoint /metrics

L'endpoint `/metrics` expose toutes les métriques collectées au format text/plain Prometheus.

### 2.1 Handler HTTP

Créer `backend/collection-management/internal/metrics/metrics.go` :

```go
package metrics

import (
    "github.com/go-chi/chi/v5"
    "github.com/prometheus/client_golang/prometheus/promhttp"
)

// RegisterRoutes enregistre l'endpoint /metrics sur le router Chi.
// Cet endpoint ne doit pas être protégé par le middleware d'authentification JWT,
// mais doit rester inaccessible publiquement (filtré par Traefik — voir note ci-dessous).
func RegisterRoutes(r chi.Router) {
    r.Handle("/metrics", promhttp.Handler())
}
```

**Note de sécurité** : L'endpoint `/metrics` expose des informations sur l'état interne de l'application. Il ne doit pas être accessible depuis Internet. Deux options :

- **Option A (recommandée)** : Prometheus scrape le container directement via le réseau Docker interne, sans passer par Traefik. Traefik n'a aucune route vers `/metrics` — l'endpoint est donc naturellement inaccessible depuis l'extérieur.
- **Option B** : Ajouter un middleware IP whitelist sur la route `/metrics` pour n'accepter que les requêtes depuis le réseau `monitoring` (`172.18.0.0/16` ou similaire).

### 2.2 Enregistrement dans le router principal

Dans le fichier principal du router (ex. `internal/server/router.go` ou `cmd/api/main.go`) :

```go
import "github.com/votre-org/collectoria/internal/metrics"

// Dans la fonction de configuration du router, AVANT les routes API :
metrics.RegisterRoutes(r)

// Exemple avec Chi :
r := chi.NewRouter()

// Routes publiques
metrics.RegisterRoutes(r) // /metrics — accessible uniquement en interne

// Routes API (avec middlewares auth, rate limiting, etc.)
r.Route("/api/v1", func(r chi.Router) {
    // ... vos routes existantes
})
```

---

## 3. Métriques custom recommandées

### 3.1 Déclaration des métriques

Créer `backend/collection-management/internal/metrics/collectors.go` :

```go
package metrics

import (
    "github.com/prometheus/client_golang/prometheus"
    "github.com/prometheus/client_golang/prometheus/promauto"
)

var (
    // HTTPRequestsTotal compte le nombre total de requêtes HTTP par endpoint, méthode et code de statut.
    // Utile pour calculer les taux d'erreurs et identifier les endpoints les plus sollicités.
    HTTPRequestsTotal = promauto.NewCounterVec(
        prometheus.CounterOpts{
            Namespace: "collectoria",
            Subsystem: "http",
            Name:      "requests_total",
            Help:      "Total number of HTTP requests by endpoint, method, and status code.",
        },
        []string{"method", "path", "status_code"},
    )

    // HTTPRequestDuration mesure la distribution des temps de réponse des requêtes HTTP.
    // Les buckets sont définis pour capturer les latences typiques d'une API REST.
    HTTPRequestDuration = promauto.NewHistogramVec(
        prometheus.HistogramOpts{
            Namespace: "collectoria",
            Subsystem: "http",
            Name:      "request_duration_seconds",
            Help:      "HTTP request duration in seconds.",
            Buckets:   []float64{.005, .01, .025, .05, .1, .25, .5, 1, 2.5, 5, 10},
        },
        []string{"method", "path"},
    )

    // HTTPRequestsInFlight mesure le nombre de requêtes HTTP actuellement en cours de traitement.
    // Utile pour détecter des pics de charge.
    HTTPRequestsInFlight = promauto.NewGauge(
        prometheus.GaugeOpts{
            Namespace: "collectoria",
            Subsystem: "http",
            Name:      "requests_in_flight",
            Help:      "Current number of HTTP requests being processed.",
        },
    )

    // DBQueryDuration mesure la distribution des temps d'exécution des requêtes SQL.
    DBQueryDuration = promauto.NewHistogramVec(
        prometheus.HistogramOpts{
            Namespace: "collectoria",
            Subsystem: "db",
            Name:      "query_duration_seconds",
            Help:      "Database query duration in seconds.",
            Buckets:   []float64{.001, .005, .01, .025, .05, .1, .25, .5, 1},
        },
        []string{"operation", "table"},
    )
)
```

**Note** : `promauto.NewCounterVec` enregistre automatiquement les métriques dans le registre Prometheus par défaut. Il n'est pas nécessaire d'appeler `prometheus.MustRegister()` séparément.

---

## 4. Middleware Chi d'instrumentation automatique

Créer `backend/collection-management/internal/metrics/middleware.go` :

```go
package metrics

import (
    "net/http"
    "strconv"
    "time"

    "github.com/go-chi/chi/v5"
)

// Middleware instrumente automatiquement toutes les requêtes HTTP qui passent par le router Chi.
// Il enregistre :
//   - le nombre de requêtes (HTTPRequestsTotal)
//   - la durée de chaque requête (HTTPRequestDuration)
//   - le nombre de requêtes en cours (HTTPRequestsInFlight)
//
// Le label "path" utilise le pattern de route Chi (ex: "/api/v1/cards/{id}")
// plutôt que l'URL réelle (ex: "/api/v1/cards/abc123") pour éviter
// l'explosion de cardinalité des métriques.
func Middleware(next http.Handler) http.Handler {
    return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
        // Ne pas instrumenter l'endpoint /metrics lui-même (évite la récursion)
        if r.URL.Path == "/metrics" {
            next.ServeHTTP(w, r)
            return
        }

        start := time.Now()
        HTTPRequestsInFlight.Inc()
        defer HTTPRequestsInFlight.Dec()

        // Wrapper pour capturer le code de statut HTTP
        ww := &responseWriter{ResponseWriter: w, statusCode: http.StatusOK}

        next.ServeHTTP(ww, r)

        // Récupérer le pattern de route Chi (ex: /api/v1/cards/{id})
        // plutôt que l'URL réelle (ex: /api/v1/cards/abc123-def456)
        routePattern := chi.RouteContext(r.Context()).RoutePattern()
        if routePattern == "" {
            routePattern = r.URL.Path
        }

        duration := time.Since(start).Seconds()
        statusCode := strconv.Itoa(ww.statusCode)

        HTTPRequestsTotal.WithLabelValues(r.Method, routePattern, statusCode).Inc()
        HTTPRequestDuration.WithLabelValues(r.Method, routePattern).Observe(duration)
    })
}

// responseWriter est un wrapper de http.ResponseWriter qui capture le code de statut HTTP.
type responseWriter struct {
    http.ResponseWriter
    statusCode int
}

func (rw *responseWriter) WriteHeader(code int) {
    rw.statusCode = code
    rw.ResponseWriter.WriteHeader(code)
}
```

**Pourquoi utiliser le pattern de route Chi** : Si l'on utilisait `r.URL.Path` directement, chaque UUID ou ID différent créerait une nouvelle série temporelle dans Prometheus (`/api/v1/cards/abc123`, `/api/v1/cards/def456`, etc.). Avec des milliers d'entrées, cela provoquerait une "cardinality explosion" qui dégraderait les performances de Prometheus. Le pattern Chi (`/api/v1/cards/{id}`) regroupe toutes ces requêtes sous un seul label.

---

## 5. Intégration dans le router Chi

Dans le fichier principal de configuration du router :

```go
package server

import (
    "github.com/go-chi/chi/v5"
    "github.com/go-chi/chi/v5/middleware"
    // ... autres imports

    appmetrics "github.com/votre-org/collectoria/internal/metrics"
)

func NewRouter() chi.Router {
    r := chi.NewRouter()

    // Middlewares globaux (ordre important)
    r.Use(middleware.RequestID)
    r.Use(middleware.RealIP)
    r.Use(middleware.Recoverer)

    // Middleware Prometheus — doit être appliqué APRÈS les middlewares de base
    // mais AVANT les middlewares métier (auth, rate limit)
    r.Use(appmetrics.Middleware)

    // Endpoint /metrics — sans authentification, sans rate limiting
    appmetrics.RegisterRoutes(r)

    // Routes API avec leurs middlewares spécifiques
    r.Route("/api/v1", func(r chi.Router) {
        // Middlewares JWT, rate limiting, etc.
        // ... vos routes existantes
    })

    return r
}
```

---

## 6. Format attendu par Prometheus

L'endpoint `/metrics` doit retourner un contenu au format `text/plain; version=0.0.4` (format Prometheus exposition format).

Exemple de sortie attendue :

```
# HELP collectoria_http_requests_total Total number of HTTP requests by endpoint, method, and status code.
# TYPE collectoria_http_requests_total counter
collectoria_http_requests_total{method="GET",path="/api/v1/cards",status_code="200"} 142
collectoria_http_requests_total{method="GET",path="/api/v1/collections",status_code="200"} 37
collectoria_http_requests_total{method="POST",path="/api/v1/auth/login",status_code="200"} 5
collectoria_http_requests_total{method="POST",path="/api/v1/auth/login",status_code="401"} 2
collectoria_http_requests_total{method="PATCH",path="/api/v1/cards/{id}/possession",status_code="200"} 18

# HELP collectoria_http_request_duration_seconds HTTP request duration in seconds.
# TYPE collectoria_http_request_duration_seconds histogram
collectoria_http_request_duration_seconds_bucket{method="GET",path="/api/v1/cards",le="0.005"} 0
collectoria_http_request_duration_seconds_bucket{method="GET",path="/api/v1/cards",le="0.01"} 3
collectoria_http_request_duration_seconds_bucket{method="GET",path="/api/v1/cards",le="0.025"} 28
collectoria_http_request_duration_seconds_bucket{method="GET",path="/api/v1/cards",le="0.05"} 95
collectoria_http_request_duration_seconds_bucket{method="GET",path="/api/v1/cards",le="+Inf"} 142
collectoria_http_request_duration_seconds_sum{method="GET",path="/api/v1/cards"} 2.847
collectoria_http_request_duration_seconds_count{method="GET",path="/api/v1/cards"} 142

# HELP collectoria_http_requests_in_flight Current number of HTTP requests being processed.
# TYPE collectoria_http_requests_in_flight gauge
collectoria_http_requests_in_flight 1

# HELP go_goroutines Number of goroutines that currently exist.
# TYPE go_goroutines gauge
go_goroutines 12

# HELP go_memstats_alloc_bytes Number of bytes allocated and still in use.
# TYPE go_memstats_alloc_bytes gauge
go_memstats_alloc_bytes 3.825664e+06

# HELP process_cpu_seconds_total Total user and system CPU time spent in seconds.
# TYPE process_cpu_seconds_total counter
process_cpu_seconds_total 0.47
```

Les métriques Go runtime (`go_goroutines`, `go_memstats_*`, `process_*`) sont automatiquement incluses par `prometheus/client_golang` sans configuration supplémentaire.

---

## 7. Vérification

### 7.1 Vérification locale (développement)

```bash
# Démarrer le backend localement
cd backend/collection-management
go run cmd/api/main.go

# Dans un autre terminal, vérifier que /metrics répond
curl http://localhost:8080/metrics | head -30
# Attendu : texte commençant par "# HELP go_gc_duration_seconds ..."

# Vérifier les métriques custom après quelques requêtes
curl http://localhost:8080/api/v1/health
curl http://localhost:8080/metrics | grep collectoria_http
# Attendu : lignes "collectoria_http_requests_total{...} 1"

# Vérifier le Content-Type
curl -I http://localhost:8080/metrics
# Attendu : Content-Type: text/plain; version=0.0.4; charset=utf-8
```

### 7.2 Vérification en production (via Prometheus)

Une fois déployé sur le VPS, Prometheus scrape automatiquement `/metrics` toutes les 15 secondes.

Vérifier via tunnel SSH :

```bash
# Tunnel SSH
ssh -L 9090:localhost:9090 collectoria@<IP_DU_VPS>

# Dans le navigateur : http://localhost:9090/targets
# Le target "backend-collection" doit être "UP"

# Requête PromQL de test
# http://localhost:9090/graph
# Saisir : collectoria_http_requests_total
# Des métriques doivent apparaître
```

### 7.3 Vérification que /metrics n'est pas accessible publiquement

```bash
# Depuis Internet (votre machine locale)
curl -I https://mondomaine.com/metrics
# Attendu : HTTP 404 (Traefik ne route pas /metrics)

# L'accès ne doit être possible que depuis le réseau Docker interne (Prometheus)
```
