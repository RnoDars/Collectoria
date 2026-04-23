# Rate Limiting - Collection Management Service

## Vue d'ensemble

Le service Collection Management implémente un système de rate limiting à trois niveaux pour protéger l'API contre les abus tout en garantissant une expérience utilisateur fluide pour les usages légitimes.

**Bibliothèque utilisée** : [github.com/ulule/limiter/v3](https://github.com/ulule/limiter)

**Mécanisme** : Rate limiting basé sur l'IP client avec fenêtres glissantes (sliding window).

## Stratégie à Trois Niveaux

### 1. Login Rate Limiting (Strict)

**Configuration par défaut** : 5 requêtes / 15 minutes

**Endpoints protégés** :
- `POST /api/v1/auth/login`

**Objectif** : Prévenir les attaques par force brute sur les comptes utilisateurs (OWASP CWE-307).

**Raison du choix** : Le login est le point d'entrée critique pour la sécurité. Une limite stricte est acceptable car les utilisateurs légitimes se connectent rarement plus de 5 fois en 15 minutes.

### 2. Read Rate Limiting (Permissif)

**Configuration par défaut** : 100 requêtes / 1 minute

**Endpoints protégés** :
- `GET /api/v1/collections`
- `GET /api/v1/collections/summary`
- `GET /api/v1/cards`
- `GET /api/v1/activities/recent`
- `GET /api/v1/statistics/growth`

**Objectif** : Permettre une utilisation normale tout en protégeant contre les scrapers et les clients mal configurés.

**Raison du choix** : Les opérations de lecture sont peu coûteuses et nécessitent une limite permissive pour une bonne UX. 100 req/min permet une navigation fluide même avec des rechargements fréquents.

### 3. Write Rate Limiting (Modéré)

**Configuration par défaut** : 30 requêtes / 1 minute

**Endpoints protégés** :
- `PATCH /api/v1/cards/{id}/possession`

**Objectif** : Protéger contre les modifications abusives tout en permettant des mises à jour légitimes (ajout de plusieurs cartes).

**Raison du choix** : Les opérations d'écriture sont plus coûteuses (BDD + événements Kafka). 30 req/min est suffisant pour un usage normal (ajout en lot) tout en évitant les abus.

### 4. Endpoints Exclus

**Aucun rate limiting** :
- `GET /api/v1/health`

**Raison** : Le health check doit toujours être accessible pour le monitoring et les load balancers.

## Configuration

### Variables d'environnement

```bash
# Login Rate Limiting
RATE_LIMIT_LOGIN_REQUESTS=5           # Nombre de requêtes autorisées
RATE_LIMIT_LOGIN_WINDOW=15m           # Fenêtre de temps (format Go duration)

# Read Rate Limiting
RATE_LIMIT_READ_REQUESTS=100
RATE_LIMIT_READ_WINDOW=1m

# Write Rate Limiting
RATE_LIMIT_WRITE_REQUESTS=30
RATE_LIMIT_WRITE_WINDOW=1m
```

### Format des durées

Les fenêtres de temps utilisent le format Go duration :
- `s` : secondes (exemple : `30s`)
- `m` : minutes (exemple : `15m`)
- `h` : heures (exemple : `2h`)

Combinaisons possibles : `1h30m`, `90s`, etc.

### Modification des limites

**Environnement de développement** :
```bash
# .env.development
RATE_LIMIT_LOGIN_REQUESTS=10
RATE_LIMIT_LOGIN_WINDOW=5m
```

**Environnement de production** :
```bash
# .env.production
RATE_LIMIT_LOGIN_REQUESTS=3
RATE_LIMIT_LOGIN_WINDOW=30m
```

**Important** : Après modification, redémarrer le service pour appliquer les changements.

## Headers HTTP

### Requêtes Autorisées

Toutes les réponses incluent les headers suivants :

```http
X-RateLimit-Limit: 100           # Limite totale pour cette fenêtre
X-RateLimit-Remaining: 87        # Requêtes restantes
X-RateLimit-Reset: 1714751820    # Timestamp Unix de reset
```

**Utilisation client** : Les clients peuvent utiliser ces headers pour implémenter un retry intelligent ou afficher des alertes à l'utilisateur.

### Requêtes Bloquées (429)

Lorsque la limite est atteinte :

```http
HTTP/1.1 429 Too Many Requests
X-RateLimit-Limit: 5
X-RateLimit-Remaining: 0
X-RateLimit-Reset: 1714752720
Retry-After: 847                 # Secondes avant de réessayer
Content-Type: application/json

{
  "error": "Rate limit exceeded"
}
```

**Retry-After** : Indique le nombre de secondes à attendre avant de réessayer. Les clients doivent respecter ce header.

## Identification Client

### Extraction de l'IP

Le rate limiter extrait l'IP client dans l'ordre de priorité suivant :

1. **X-Forwarded-For** : Utilisé en présence d'un proxy/load balancer
   - Prend la première IP de la liste (client original)
   - Format : `203.0.113.1, 198.51.100.1, 192.0.2.1` → `203.0.113.1`

2. **X-Real-IP** : Header alternatif pour les proxies
   - Format : `203.0.113.50`

3. **RemoteAddr** : IP directe de la connexion TCP
   - Format : `192.168.1.100:54321` → `192.168.1.100` (supprime le port)

### Configuration Proxy/Load Balancer

**Nginx** :
```nginx
proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
proxy_set_header X-Real-IP $remote_addr;
```

**Traefik** :
Configure automatiquement ces headers si `trustedIPs` est défini.

### Isolation par IP

- Chaque IP a son propre compteur indépendant
- IP1 bloquée n'affecte pas IP2
- Fenêtres de temps par IP (sliding window)

## Monitoring

### Métriques à surveiller

1. **Nombre de 429 par endpoint** : Indicateur de rate limiting actif
2. **Ratio 429/total requêtes** : Permet de détecter :
   - Attaques (ratio élevé sur /auth/login)
   - Limites trop strictes (ratio élevé sur endpoints légitimes)
3. **Top IPs bloquées** : Identifier les sources d'abus

### Logs

Les requêtes bloquées sont loggées automatiquement par le middleware chi :

```json
{
  "level": "info",
  "method": "POST",
  "path": "/api/v1/auth/login",
  "status": 429,
  "ip": "203.0.113.1",
  "message": "request completed"
}
```

### Alertes Recommandées

- **Alerte critique** : >50 requêtes 429 sur /auth/login en 5 minutes (attaque potentielle)
- **Alerte warning** : >10% de 429 sur endpoints read/write (limites trop strictes?)

## Tests

### Tests Automatisés

9 tests unitaires couvrent le middleware :

```bash
cd backend/collection-management
go test -v ./internal/infrastructure/http/middleware/...
```

**Couverture** :
- ✅ Requêtes dans la limite
- ✅ Blocage après limite atteinte
- ✅ Reset après fenêtre expirée
- ✅ Headers X-RateLimit-*
- ✅ Header Retry-After
- ✅ Extraction IP (X-Forwarded-For, X-Real-IP, RemoteAddr)
- ✅ Isolation entre IPs différentes

### Tests Manuels

Script de test fourni :

```bash
cd Security/scripts
./test-rate-limiting.sh http://localhost:8080
```

Ce script teste :
- Login endpoint (7 requêtes, attendu : 5 OK + 2×429)
- Read endpoints (vérification headers)
- Health endpoint (aucun rate limiting)

## Architecture Technique

### Implémentation

**Middleware** : `internal/infrastructure/http/middleware/rate_limiter.go`

**Storage** : En mémoire (non persistant entre redémarrages)
- Léger et performant
- Adapté pour des services stateless derrière load balancer
- Chaque instance maintient son propre état

**Algorithme** : Sliding window (ulule/limiter)
- Plus précis que fixed window
- Évite les "burst" à la limite de fenêtre

### Intégration Server

**Fichier** : `internal/infrastructure/http/server.go`

**Routing** :
```go
// Trois rate limiters indépendants
loginRateLimiter := customMiddleware.NewRateLimiter(config)
readRateLimiter := customMiddleware.NewRateLimiter(config)
writeRateLimiter := customMiddleware.NewRateLimiter(config)

// Application par groupe de routes
r.Group(func(r chi.Router) {
    r.Use(loginRateLimiter)
    r.Post("/auth/login", authHandler.Login)
})
```

### Configuration Centralisée

**Fichier** : `internal/config/config.go`

```go
type RateLimitConfig struct {
    LoginRequests  int64
    LoginWindow    time.Duration
    ReadRequests   int64
    ReadWindow     time.Duration
    WriteRequests  int64
    WriteWindow    time.Duration
}
```

Chargement depuis variables d'environnement avec valeurs par défaut.

## Troubleshooting

### Problème : "Rate limit exceeded" pour utilisateur légitime

**Causes possibles** :
1. IP partagée (NAT d'entreprise, VPN)
2. Limites trop strictes
3. Client qui fait trop de requêtes (polling agressif)

**Solutions** :
1. Augmenter les limites pour l'endpoint concerné
2. Implémenter un système de whitelist d'IPs (feature future)
3. Corriger le comportement du client (caching, debouncing)

### Problème : Rate limiting ne fonctionne pas

**Vérifications** :
1. Middleware appliqué sur la route ? (vérifier `server.go` setupRoutes)
2. Headers proxy correctement configurés ? (X-Forwarded-For)
3. Tests passent ? (`go test ./internal/infrastructure/http/middleware/...`)

### Problème : Tous les utilisateurs derrière un proxy sont bloqués ensemble

**Cause** : IP extraite est celle du proxy, pas du client final.

**Solution** : Configurer le proxy pour envoyer `X-Forwarded-For` ou `X-Real-IP`.

## Évolutions Futures

### Priorité Moyenne
- [ ] Storage Redis partagé (rate limiting cross-instances)
- [ ] Whitelist d'IPs (partenaires, monitoring)
- [ ] Rate limiting par user ID (authentifié)

### Priorité Basse
- [ ] Burst allowance (permet pics temporaires)
- [] Métriques Prometheus natives
- [ ] Configuration dynamique (hot reload)

## Références

- **CWE-307** : Improper Restriction of Excessive Authentication Attempts
- **RFC 6585** : Additional HTTP Status Codes (429 Too Many Requests)
- **OWASP** : API Security Top 10 - API4:2023 Unrestricted Resource Consumption

## Support

Pour toute question ou modification des limites, consulter :
- Cette documentation
- Tests : `internal/infrastructure/http/middleware/rate_limiter_test.go`
- Configuration : `internal/config/config.go`
