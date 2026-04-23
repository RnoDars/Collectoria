# Phase 2 Sécurité - Rate Limiting + SQL Injection Audit

**Date de création** : 2026-04-23  
**Priorité** : HAUTE  
**Effort estimé** : 1.5 jours (12h)  
**Status** : À faire  
**Score actuel** : 8.0/10  
**Score cible** : 9.0/10 (+1.0 point, production-ready)

---

## 📋 Vue d'ensemble

Compléter la sécurisation de l'application Collectoria avec les 2 dernières corrections de la Phase 2 :
1. **Rate Limiting** - Protection contre brute force et DoS (4h)
2. **Audit SQL Injection** - Vérification et sécurisation de toutes les requêtes SQL (8h)

**Contexte** : 
- Phase 1 Quick Wins complétée (21/04) : 4.5/10 → 7.0/10
- JWT Authentication complétée (22/04) : 7.0/10 → 8.0/10
- Application déjà sécurisée pour développement, Phase 2 pour production-ready

---

## 🎯 Objectifs de la Phase 2

### Score de Sécurité
- **Avant Phase 2** : 8.0/10
- **Après Rate Limiting** : 8.3/10 (+0.3)
- **Après SQL Injection Audit** : 9.0/10 (+0.7 cumulé)

### Vulnérabilités Restantes
- 🟠 **HAUTE-007** : Rate Limiting absent (endpoints API vulnérables à brute force)
- 🟠 **HAUTE-006** : SQL Injection potentielle (audit complet nécessaire)

---

## 📊 Tâche 1 : Rate Limiting (4 heures)

### Priorité : HAUTE
**Impact sécurité** : +0.3 point → Score 8.3/10  
**CVSS** : HAUTE  
**CWE** : CWE-307 (Improper Restriction of Excessive Authentication Attempts)

### Contexte
L'endpoint `/api/v1/auth/login` et autres endpoints API n'ont aucune protection contre :
- **Brute force** : Attaquant peut tenter des milliers de mots de passe
- **DoS** : Attaquant peut surcharger le serveur avec des requêtes massives
- **Credential stuffing** : Test automatisé de combinaisons email/password volées

### Solution : Middleware Rate Limiting

#### Architecture
```
Client → Rate Limiter Middleware → Auth Middleware → Handler
         ↓ (si limite dépassée)
         429 Too Many Requests
```

#### Stratégie de Rate Limiting

**Par endpoint et par IP** :
- `/api/v1/auth/login` : **5 tentatives / 15 minutes** (strict, sensible)
- Endpoints GET (lecture) : **100 requêtes / minute** (normal)
- Endpoints POST/PATCH/DELETE (écriture) : **30 requêtes / minute** (modéré)

**Headers de réponse** :
```
X-RateLimit-Limit: 5
X-RateLimit-Remaining: 2
X-RateLimit-Reset: 1682345678 (Unix timestamp)
```

**Réponse 429 Too Many Requests** :
```json
{
  "error": "Rate limit exceeded",
  "retry_after": 900 // secondes
}
```

---

### Implémentation Détaillée

#### Étape 1 : Choisir la librairie (30 min)

**Options évaluées** :
1. `github.com/didip/tollbooth` - Simple, en mémoire
2. `github.com/ulule/limiter` - Redis support, distribué
3. `golang.org/x/time/rate` - Standard Go, basique

**Choix recommandé** : `github.com/ulule/limiter/v3`
- Support in-memory (développement)
- Support Redis (production distribuée)
- Middleware Chi intégré
- Headers X-RateLimit-* automatiques

#### Étape 2 : Middleware Rate Limiter (1h)

**Fichier** : `backend/collection-management/internal/infrastructure/http/middleware/rate_limiter.go`

**Code** :
```go
package middleware

import (
    "net/http"
    "github.com/ulule/limiter/v3"
    "github.com/ulule/limiter/v3/drivers/store/memory"
)

// RateLimitConfig configuration du rate limiter
type RateLimitConfig struct {
    Requests int64         // Nombre de requêtes autorisées
    Window   time.Duration // Fenêtre de temps
}

// NewRateLimiter crée un middleware de rate limiting
func NewRateLimiter(config RateLimitConfig) func(http.Handler) http.Handler {
    rate := limiter.Rate{
        Period: config.Window,
        Limit:  config.Requests,
    }
    
    store := memory.NewStore()
    instance := limiter.New(store, rate)
    
    return func(next http.Handler) http.Handler {
        return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
            // Extraire IP client
            ip := getClientIP(r)
            
            // Créer contexte de limite
            limiterCtx, err := instance.Get(r.Context(), ip)
            if err != nil {
                http.Error(w, "Rate limiter error", http.StatusInternalServerError)
                return
            }
            
            // Ajouter headers
            w.Header().Set("X-RateLimit-Limit", strconv.FormatInt(limiterCtx.Limit, 10))
            w.Header().Set("X-RateLimit-Remaining", strconv.FormatInt(limiterCtx.Remaining, 10))
            w.Header().Set("X-RateLimit-Reset", strconv.FormatInt(limiterCtx.Reset, 10))
            
            // Vérifier limite
            if limiterCtx.Reached {
                w.Header().Set("Retry-After", strconv.FormatInt(limiterCtx.Reset-time.Now().Unix(), 10))
                http.Error(w, "Rate limit exceeded", http.StatusTooManyRequests)
                return
            }
            
            next.ServeHTTP(w, r)
        })
    }
}

// getClientIP extrait l'IP du client
func getClientIP(r *http.Request) string {
    // Vérifier headers proxy
    if ip := r.Header.Get("X-Forwarded-For"); ip != "" {
        return strings.Split(ip, ",")[0]
    }
    if ip := r.Header.Get("X-Real-IP"); ip != "" {
        return ip
    }
    return r.RemoteAddr
}
```

#### Étape 3 : Configuration par endpoint (30 min)

**Fichier** : `backend/collection-management/internal/infrastructure/http/server.go`

```go
// Créer rate limiters spécifiques
loginRateLimiter := middleware.NewRateLimiter(middleware.RateLimitConfig{
    Requests: 5,
    Window:   15 * time.Minute,
})

readRateLimiter := middleware.NewRateLimiter(middleware.RateLimitConfig{
    Requests: 100,
    Window:   1 * time.Minute,
})

writeRateLimiter := middleware.NewRateLimiter(middleware.RateLimitConfig{
    Requests: 30,
    Window:   1 * time.Minute,
})

// Appliquer aux routes
r.Route("/api/v1", func(r chi.Router) {
    // Auth endpoint (très strict)
    r.Group(func(r chi.Router) {
        r.Use(loginRateLimiter)
        r.Post("/auth/login", authHandler.HandleLogin)
    })
    
    // Protected routes avec rate limiting modéré
    r.Group(func(r chi.Router) {
        r.Use(middleware.RequireAuth(jwtService))
        
        // Lecture (permissif)
        r.Group(func(r chi.Router) {
            r.Use(readRateLimiter)
            r.Get("/collections", collectionsHandler.HandleGetCollections)
            r.Get("/collections/summary", collectionsHandler.HandleGetSummary)
            r.Get("/cards", cardsHandler.HandleGetCards)
            r.Get("/activities/recent", activitiesHandler.HandleGetRecentActivities)
            r.Get("/statistics/growth", statisticsHandler.HandleGetGrowthStats)
        })
        
        // Écriture (modéré)
        r.Group(func(r chi.Router) {
            r.Use(writeRateLimiter)
            r.Patch("/cards/{id}/possession", cardsHandler.HandleTogglePossession)
        })
    })
})
```

#### Étape 4 : Variables d'environnement (15 min)

**Fichier** : `backend/collection-management/internal/config/config.go`

```go
type Config struct {
    // ... existing fields
    
    // Rate Limiting
    RateLimitLoginRequests   int64         `env:"RATE_LIMIT_LOGIN_REQUESTS" envDefault:"5"`
    RateLimitLoginWindow     time.Duration `env:"RATE_LIMIT_LOGIN_WINDOW" envDefault:"15m"`
    RateLimitReadRequests    int64         `env:"RATE_LIMIT_READ_REQUESTS" envDefault:"100"`
    RateLimitReadWindow      time.Duration `env:"RATE_LIMIT_READ_WINDOW" envDefault:"1m"`
    RateLimitWriteRequests   int64         `env:"RATE_LIMIT_WRITE_REQUESTS" envDefault:"30"`
    RateLimitWriteWindow     time.Duration `env:"RATE_LIMIT_WRITE_WINDOW" envDefault:"1m"`
}
```

#### Étape 5 : Tests TDD (1h)

**Fichier** : `backend/collection-management/internal/infrastructure/http/middleware/rate_limiter_test.go`

**Tests à créer** :
```go
func TestRateLimiter_AllowsWithinLimit(t *testing.T)
func TestRateLimiter_Blocks429AfterLimit(t *testing.T)
func TestRateLimiter_ResetsAfterWindow(t *testing.T)
func TestRateLimiter_Headers(t *testing.T)
func TestRateLimiter_RetryAfter(t *testing.T)
func TestGetClientIP_XForwardedFor(t *testing.T)
func TestGetClientIP_XRealIP(t *testing.T)
func TestGetClientIP_RemoteAddr(t *testing.T)
```

#### Étape 6 : Tests manuels (30 min)

**Script de test** : `Security/scripts/test-rate-limiting.sh`

```bash
#!/bin/bash
# Test Rate Limiting sur /auth/login

echo "🔒 Test Rate Limiting - /auth/login (5 tentatives / 15 min)"
echo ""

for i in {1..7}; do
    echo "Tentative #$i"
    RESPONSE=$(curl -s -w "\nHTTP_CODE:%{http_code}" \
        -X POST http://localhost:8080/api/v1/auth/login \
        -H "Content-Type: application/json" \
        -d '{"email":"test@test.com","password":"wrong"}')
    
    HTTP_CODE=$(echo "$RESPONSE" | grep "HTTP_CODE" | cut -d: -f2)
    HEADERS=$(curl -s -I -X POST http://localhost:8080/api/v1/auth/login \
        -H "Content-Type: application/json" \
        -d '{"email":"test@test.com","password":"wrong"}')
    
    echo "  → HTTP $HTTP_CODE"
    echo "$HEADERS" | grep -E "X-RateLimit-|Retry-After"
    echo ""
    
    if [ "$HTTP_CODE" == "429" ]; then
        echo "✅ Rate limiting fonctionne ! 429 après 5 tentatives"
        break
    fi
    
    sleep 0.5
done
```

#### Étape 7 : Documentation (30 min)

**Fichier** : `backend/collection-management/docs/RATE_LIMITING.md`

Documenter :
- Configuration par endpoint
- Headers de réponse
- Variables d'environnement
- Stratégie de déploiement (in-memory vs Redis)
- Monitoring recommandé

---

### Critères d'Acceptation (Rate Limiting)

- [ ] Middleware rate limiter créé avec tests (8 tests minimum)
- [ ] Configuration par endpoint (login 5/15m, read 100/1m, write 30/1m)
- [ ] Headers X-RateLimit-* présents dans toutes les réponses
- [ ] Réponse 429 avec Retry-After quand limite dépassée
- [ ] Variables d'environnement configurables
- [ ] Tests manuels validés (script test-rate-limiting.sh)
- [ ] Documentation complète (RATE_LIMITING.md)
- [ ] Log d'audit créé dans Security/audit-logs/
- [ ] Commit atomique avec message clair

---

## 📊 Tâche 2 : Audit SQL Injection (8 heures)

### Priorité : HAUTE
**Impact sécurité** : +0.7 point → Score 9.0/10  
**CVSS** : HAUTE  
**CWE** : CWE-89 (SQL Injection)

### Contexte
Le projet utilise **sqlx avec requêtes paramétrées**, ce qui offre une protection de base contre l'injection SQL. Cependant, un audit complet est nécessaire pour :
- Vérifier que TOUTES les requêtes utilisent des paramètres
- Détecter les concaténations de chaînes (vulnérabilité)
- Tester les inputs utilisateur avec payloads d'injection
- Documenter les bonnes pratiques

### Périmètre de l'Audit

**Repositories à auditer** (6 fichiers) :
1. `internal/infrastructure/postgres/collection_repository.go`
2. `internal/infrastructure/postgres/card_repository.go`
3. `internal/infrastructure/postgres/activity_repository.go`
4. `internal/infrastructure/postgres/statistics_repository.go`
5. Future : `internal/infrastructure/postgres/user_repository.go` (si créé)
6. Migrations SQL (vérification)

---

### Méthodologie d'Audit

#### Étape 1 : Analyse statique du code (2h)

**Objectif** : Identifier toutes les requêtes SQL et vérifier leur sécurité.

**Checklist par repository** :
- [ ] Toutes les requêtes utilisent `?` pour les paramètres (sqlx)
- [ ] Aucune concaténation de strings pour construire SQL
- [ ] Aucun `fmt.Sprintf()` avec input utilisateur
- [ ] Aucun `strings.Replace()` ou manipulation de query string
- [ ] Les clauses `WHERE`, `LIKE`, `ORDER BY` sont sécurisées
- [ ] Les clauses `LIMIT`, `OFFSET` utilisent des paramètres

**Script d'analyse** : `Security/scripts/analyze-sql-queries.sh`

```bash
#!/bin/bash
# Analyse statique des requêtes SQL

echo "🔍 Analyse SQL Injection - Recherche de patterns dangereux"
echo ""

cd backend/collection-management

# Pattern 1 : Concaténation de strings
echo "❌ Recherche de concaténations dangereuses (+ sur query strings)"
grep -rn "query.*+.*" internal/infrastructure/postgres/ || echo "  ✅ Aucune trouvée"
echo ""

# Pattern 2 : fmt.Sprintf dans query
echo "❌ Recherche de fmt.Sprintf dans queries"
grep -rn "fmt.Sprintf.*SELECT\|INSERT\|UPDATE\|DELETE" internal/infrastructure/postgres/ || echo "  ✅ Aucune trouvée"
echo ""

# Pattern 3 : Toutes les queries (pour revue manuelle)
echo "📋 Liste de toutes les queries SQL (revue manuelle requise)"
grep -rn "db.Query\|db.Exec\|db.Get\|db.Select" internal/infrastructure/postgres/ | head -20
echo ""

echo "✅ Analyse terminée. Revue manuelle nécessaire pour chaque query."
```

#### Étape 2 : Tests d'injection automatisés (3h)

**Objectif** : Tester tous les endpoints avec des payloads d'injection SQL.

**Payloads de test** (classiques) :
```
' OR '1'='1
'; DROP TABLE users; --
' UNION SELECT NULL, NULL, NULL--
admin'--
' OR 1=1--
```

**Tests à créer** : `backend/collection-management/tests/security/sql_injection_test.go`

```go
package security_test

import (
    "testing"
    "github.com/stretchr/testify/assert"
)

// Payloads d'injection SQL classiques
var sqlInjectionPayloads = []string{
    "' OR '1'='1",
    "'; DROP TABLE collections; --",
    "' UNION SELECT NULL, NULL--",
    "admin'--",
    "' OR 1=1--",
    "1' AND '1'='1",
}

func TestGetCards_SQLInjection_SearchParam(t *testing.T) {
    // Setup
    db := setupTestDB(t)
    defer db.Close()
    
    for _, payload := range sqlInjectionPayloads {
        t.Run("Payload: "+payload, func(t *testing.T) {
            // Appeler endpoint avec payload
            req := httptest.NewRequest("GET", "/api/v1/cards?search="+url.QueryEscape(payload), nil)
            w := httptest.NewRecorder()
            
            handler.ServeHTTP(w, req)
            
            // Vérifier : pas de 500, pas de données exposées
            assert.NotEqual(t, 500, w.Code, "Payload ne doit pas causer 500")
            assert.NotContains(t, w.Body.String(), "syntax error", "Pas d'erreur SQL exposée")
            
            // Vérifier : requête retourne résultats vides ou normaux
            // Ne doit PAS retourner toutes les cartes (bypass auth)
            var response map[string]interface{}
            json.Unmarshal(w.Body.Bytes(), &response)
            cards := response["cards"].([]interface{})
            assert.LessOrEqual(t, len(cards), 10, "Pas de fuite massive de données")
        })
    }
}

func TestGetCards_SQLInjection_OrderByParam(t *testing.T)
func TestGetCollections_SQLInjection_FilterParam(t *testing.T)
func TestTogglePossession_SQLInjection_CardID(t *testing.T)
// ... tous les endpoints avec inputs utilisateur
```

**Estimation** : 15-20 tests d'injection à créer

#### Étape 3 : Revue manuelle de chaque repository (2h)

**Fichier par fichier**, vérifier ligne par ligne :

**Template de revue** :
```markdown
### Repository: collection_repository.go

#### Méthode: GetCollectionByID()
- Query: `SELECT * FROM collections WHERE id = ?`
- Paramètres: ✅ id (UUID)
- Sécurité: ✅ Paramètre positionnel
- Risque: AUCUN

#### Méthode: GetCollections()
- Query: `SELECT * FROM collections WHERE user_id = ?`
- Paramètres: ✅ userID (UUID)
- Sécurité: ✅ Paramètre positionnel
- Risque: AUCUN

...
```

#### Étape 4 : Migration vers Query Builder (si nécessaire) (2h)

**Si vulnérabilités détectées** : Refactoriser vers `github.com/Masterminds/squirrel`

**Avant (potentiellement dangereux)** :
```go
query := fmt.Sprintf("SELECT * FROM cards WHERE name LIKE '%%%s%%'", searchTerm)
db.Query(query)
```

**Après (sécurisé)** :
```go
query := squirrel.Select("*").From("cards").
    Where(squirrel.Like{"name": "%" + searchTerm + "%"}).
    PlaceholderFormat(squirrel.Dollar)
sql, args, _ := query.ToSql()
db.Query(sql, args...)
```

**Note** : Si code actuel est déjà propre (paramètres partout), cette étape peut être SKIPPED.

#### Étape 5 : Documentation et rapport (1h)

**Fichier** : `Security/audit-logs/2026-04-23_sql-injection-audit.md`

**Contenu** :
- Périmètre audité (6 repositories)
- Méthodologie (analyse statique + tests automatisés + revue manuelle)
- Vulnérabilités trouvées (si aucune : documenter)
- Tests créés (15-20 tests)
- Recommandations
- Score avant/après

---

### Critères d'Acceptation (SQL Injection Audit)

- [ ] Analyse statique complétée (script analyze-sql-queries.sh exécuté)
- [ ] 6 repositories auditées ligne par ligne
- [ ] 15-20 tests d'injection créés (tous passants)
- [ ] Aucune vulnérabilité détectée OU toutes corrigées
- [ ] Documentation bonnes pratiques SQL (Backend/CLAUDE.md enrichi)
- [ ] Log d'audit complet créé (audit-logs/2026-04-23_sql-injection-audit.md)
- [ ] Score sécurité : 9.0/10 atteint
- [ ] Commit atomique avec message clair

---

## 📋 Ordre d'Exécution Recommandé

### Jour 1 (4-5h)
1. **Tâche 1 : Rate Limiting complet** (4h)
   - Middleware + Configuration + Tests + Documentation
2. **Commit Rate Limiting** (atomique)
3. **Pause / Revue**

### Jour 2 (7-8h)
4. **Tâche 2 : SQL Injection Audit**
   - Analyse statique (2h)
   - Tests automatisés (3h)
   - Revue manuelle (2h)
   - Documentation (1h)
5. **Commit SQL Audit** (atomique)
6. **Mise à jour STATUS.md** (score 9.0/10 atteint)

---

## 📊 Métriques de Succès

### Score de Sécurité
- **Avant Phase 2** : 8.0/10
- **Après Rate Limiting** : 8.3/10
- **Après SQL Injection Audit** : **9.0/10** ✅ (production-ready)

### Tests
- **Rate Limiting** : +8 tests minimum
- **SQL Injection** : +15-20 tests
- **Total nouveaux tests** : ~25 tests

### Documentation
- **Fichiers créés** :
  - RATE_LIMITING.md
  - 2 audit logs (rate-limiting, sql-injection)
  - Scripts de test (test-rate-limiting.sh, analyze-sql-queries.sh)

### Commits
- 2 commits atomiques (Rate Limiting, SQL Audit)
- Messages clairs avec Co-Authored-By

---

## 🎯 Validation Finale

### Checklist Complète Phase 2

- [ ] **Rate Limiting**
  - [ ] Middleware implémenté et testé
  - [ ] Configuration par endpoint (login, read, write)
  - [ ] Headers X-RateLimit-* présents
  - [ ] 429 Too Many Requests fonctionne
  - [ ] Variables d'environnement configurables
  - [ ] Tests automatisés (8 tests)
  - [ ] Tests manuels validés
  - [ ] Documentation complète

- [ ] **SQL Injection Audit**
  - [ ] Analyse statique complétée
  - [ ] 6 repositories auditées
  - [ ] 15-20 tests d'injection créés
  - [ ] Aucune vulnérabilité détectée
  - [ ] Documentation bonnes pratiques
  - [ ] Log d'audit complet

- [ ] **Documentation Globale**
  - [ ] Security/audit-logs/ mis à jour (2 nouveaux logs)
  - [ ] Backend/CLAUDE.md enrichi (SQL best practices)
  - [ ] STATUS.md mis à jour (score 9.0/10)

- [ ] **Commits et Push**
  - [ ] 2 commits atomiques poussés
  - [ ] Messages clairs et détaillés

---

## 🚀 Après Phase 2 : Application Production-Ready

**Score 9.0/10** = Application sécurisée pour production

**Vulnérabilités résolues** :
- ✅ JWT Authentication (Phase 2 début)
- ✅ Rate Limiting (Phase 2 fin)
- ✅ SQL Injection (Phase 2 fin)
- ✅ Headers Security (Phase 1)
- ✅ CORS configuré (Phase 1)
- ✅ Docker non-root (Phase 1)
- ✅ Credentials externalisés (Phase 1)

**Vulnérabilités restantes (mineures, score 10/10 si corrigées)** :
- Credentials hardcodées dans /auth/login (migration BDD + bcrypt)
- Refresh tokens absents (amélioration UX)
- LocalStorage JWT (migration cookies HttpOnly optionnelle)

---

**Document créé le** : 2026-04-23 12:00  
**Par** : Alfred (Agent de Dispatch Principal)  
**Validé par** : Agent Security (à valider après exécution)
