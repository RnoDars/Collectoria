# CRIT-001: Implémentation de l'Authentification JWT

**Sévérité**: CRITICAL  
**Priorité**: P0  
**Estimation**: 2 jours  
**Status**: À faire

---

## Contexte

Actuellement, tous les endpoints sont publics et utilisent un UserID hardcodé:
```go
userID := uuid.MustParse("00000000-0000-0000-0000-000000000001")
```

Cela expose toutes les données utilisateur sans aucune protection.

---

## Solution Proposée

### 1. Architecture JWT

```
Client                    Backend                    Auth Service (Future)
  |                          |                              |
  |-- POST /auth/login ----->|                              |
  |<---- JWT Token ----------|                              |
  |                          |                              |
  |-- GET /api/v1/collections (avec JWT) -->               |
  |          |-- Validate JWT -->|                          |
  |          |-- Extract userID ->|                         |
  |          |<- Authorized -----|                          |
  |<---- Data ---------------|                              |
```

### 2. Dépendances

```bash
cd backend/collection-management
go get github.com/golang-jwt/jwt/v5
```

### 3. Implémentation

#### 3.1 JWT Configuration

```go
// internal/config/config.go
type Config struct {
    Server   ServerConfig
    Database DatabaseConfig
    JWT      JWTConfig  // NOUVEAU
}

type JWTConfig struct {
    Secret          string
    ExpirationHours int
    Issuer          string
}

func Load() (*Config, error) {
    cfg := &Config{
        // ...
        JWT: JWTConfig{
            Secret:          getEnv("JWT_SECRET", ""),
            ExpirationHours: getEnvAsInt("JWT_EXPIRATION_HOURS", 24),
            Issuer:          getEnv("JWT_ISSUER", "collectoria-api"),
        },
    }
    
    // Validation: JWT Secret MUST be set
    if cfg.JWT.Secret == "" {
        return nil, fmt.Errorf("JWT_SECRET must be set")
    }
    if len(cfg.JWT.Secret) < 32 {
        return nil, fmt.Errorf("JWT_SECRET must be at least 32 characters")
    }
    
    return cfg, nil
}
```

#### 3.2 JWT Service

```go
// internal/infrastructure/auth/jwt_service.go
package auth

import (
    "fmt"
    "time"
    
    "github.com/golang-jwt/jwt/v5"
    "github.com/google/uuid"
)

type Claims struct {
    UserID uuid.UUID `json:"user_id"`
    Email  string    `json:"email"`
    jwt.RegisteredClaims
}

type JWTService struct {
    secret []byte
    issuer string
    expiration time.Duration
}

func NewJWTService(secret string, issuer string, expirationHours int) *JWTService {
    return &JWTService{
        secret: []byte(secret),
        issuer: issuer,
        expiration: time.Duration(expirationHours) * time.Hour,
    }
}

func (s *JWTService) GenerateToken(userID uuid.UUID, email string) (string, error) {
    claims := Claims{
        UserID: userID,
        Email:  email,
        RegisteredClaims: jwt.RegisteredClaims{
            ExpiresAt: jwt.NewNumericDate(time.Now().Add(s.expiration)),
            IssuedAt:  jwt.NewNumericDate(time.Now()),
            Issuer:    s.issuer,
        },
    }
    
    token := jwt.NewWithClaims(jwt.SigningMethodHS256, claims)
    return token.SignedString(s.secret)
}

func (s *JWTService) ValidateToken(tokenString string) (*Claims, error) {
    token, err := jwt.ParseWithClaims(tokenString, &Claims{}, func(token *jwt.Token) (interface{}, error) {
        if _, ok := token.Method.(*jwt.SigningMethodHMAC); !ok {
            return nil, fmt.Errorf("unexpected signing method: %v", token.Header["alg"])
        }
        return s.secret, nil
    })
    
    if err != nil {
        return nil, err
    }
    
    if claims, ok := token.Claims.(*Claims); ok && token.Valid {
        return claims, nil
    }
    
    return nil, fmt.Errorf("invalid token")
}
```

#### 3.3 JWT Middleware

```go
// internal/infrastructure/http/middleware/auth_middleware.go
package middleware

import (
    "context"
    "net/http"
    "strings"
    
    "collectoria/collection-management/internal/infrastructure/auth"
    "github.com/google/uuid"
    "github.com/rs/zerolog"
)

type contextKey string

const UserIDKey contextKey = "user_id"

type AuthMiddleware struct {
    jwtService *auth.JWTService
    logger     zerolog.Logger
}

func NewAuthMiddleware(jwtService *auth.JWTService, logger zerolog.Logger) *AuthMiddleware {
    return &AuthMiddleware{
        jwtService: jwtService,
        logger:     logger,
    }
}

func (m *AuthMiddleware) RequireAuth(next http.Handler) http.Handler {
    return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
        // Extract token from Authorization header
        authHeader := r.Header.Get("Authorization")
        if authHeader == "" {
            m.logger.Warn().Msg("Missing Authorization header")
            http.Error(w, `{"error":{"code":"UNAUTHORIZED","message":"Missing authorization header"}}`, http.StatusUnauthorized)
            return
        }
        
        // Check Bearer format
        parts := strings.Split(authHeader, " ")
        if len(parts) != 2 || parts[0] != "Bearer" {
            m.logger.Warn().Msg("Invalid Authorization header format")
            http.Error(w, `{"error":{"code":"UNAUTHORIZED","message":"Invalid authorization format"}}`, http.StatusUnauthorized)
            return
        }
        
        tokenString := parts[1]
        
        // Validate token
        claims, err := m.jwtService.ValidateToken(tokenString)
        if err != nil {
            m.logger.Warn().Err(err).Msg("Invalid JWT token")
            http.Error(w, `{"error":{"code":"UNAUTHORIZED","message":"Invalid or expired token"}}`, http.StatusUnauthorized)
            return
        }
        
        // Add userID to context
        ctx := context.WithValue(r.Context(), UserIDKey, claims.UserID)
        next.ServeHTTP(w, r.WithContext(ctx))
    })
}

// Helper function to extract userID from context
func GetUserIDFromContext(ctx context.Context) (uuid.UUID, error) {
    userID, ok := ctx.Value(UserIDKey).(uuid.UUID)
    if !ok {
        return uuid.Nil, fmt.Errorf("user_id not found in context")
    }
    return userID, nil
}
```

#### 3.4 Mise à Jour des Handlers

```go
// internal/infrastructure/http/handlers/collection_handler.go
func (h *CollectionHandler) GetSummary(w http.ResponseWriter, r *http.Request) {
    ctx := r.Context()
    
    // AVANT (VULNÉRABLE):
    // userID := uuid.MustParse("00000000-0000-0000-0000-000000000001")
    
    // APRÈS (SÉCURISÉ):
    userID, err := middleware.GetUserIDFromContext(ctx)
    if err != nil {
        h.logger.Error().Err(err).Msg("Failed to get user ID from context")
        writeJSONError(w, h.logger, http.StatusUnauthorized, "UNAUTHORIZED", "User not authenticated")
        return
    }
    
    summary, err := h.service.GetSummary(ctx, userID)
    // ... rest of the code
}
```

#### 3.5 Mise à Jour du Server

```go
// internal/infrastructure/http/server.go
func NewServer(
    collectionService *application.CollectionService, 
    catalogService *application.CatalogService, 
    jwtService *auth.JWTService,  // NOUVEAU
    logger zerolog.Logger, 
    port int,
) *Server {
    s := &Server{
        router:            chi.NewRouter(),
        collectionService: collectionService,
        catalogService:    catalogService,
        activityService:   application.NewActivityService(),
        jwtService:        jwtService,  // NOUVEAU
        logger:            logger,
        port:              port,
    }
    
    s.setupMiddleware()
    s.setupRoutes()
    
    return s
}

func (s *Server) setupRoutes() {
    // Middleware d'authentification
    authMiddleware := middleware.NewAuthMiddleware(s.jwtService, s.logger)
    
    s.router.Route("/api/v1", func(r chi.Router) {
        // Endpoints publics (sans auth)
        r.Get("/health", func(w http.ResponseWriter, r *http.Request) {
            w.WriteHeader(http.StatusOK)
            w.Write([]byte(`{"status":"ok"}`))
        })
        
        // Endpoints protégés (avec auth)
        r.Group(func(r chi.Router) {
            r.Use(authMiddleware.RequireAuth)
            
            // Collections routes
            collectionHandler := handlers.NewCollectionHandler(s.collectionService, s.logger)
            r.Route("/collections", func(r chi.Router) {
                r.Get("/summary", collectionHandler.GetSummary)
                r.Get("/", collectionHandler.GetAllCollections)
            })
            
            // Activities & Statistics routes
            activityHandler := handlers.NewActivityHandler(s.activityService, s.logger)
            r.Get("/activities/recent", activityHandler.GetRecentActivities)
            r.Get("/statistics/growth", activityHandler.GetGrowthStats)
            
            // Catalog routes
            catalogHandler := handlers.NewCatalogHandler(s.catalogService, s.logger)
            r.Get("/cards", catalogHandler.GetCards)
        })
    })
}
```

#### 3.6 Mise à Jour de main.go

```go
// cmd/api/main.go
func main() {
    // ...
    cfg, err := config.Load()
    if err != nil {
        log.Fatal().Err(err).Msg("Failed to load configuration")
    }
    
    // ...
    collectionService := application.NewCollectionService(collectionRepo, cardRepo)
    catalogService := application.NewCatalogService(cardRepo)
    
    // Initialisation du service JWT
    jwtService := auth.NewJWTService(
        cfg.JWT.Secret,
        cfg.JWT.Issuer,
        cfg.JWT.ExpirationHours,
    )
    
    // Initialisation du serveur HTTP avec JWT
    server := http.NewServer(collectionService, catalogService, jwtService, log.Logger, cfg.Server.Port)
    
    // ...
}
```

---

## Configuration

### Variables d'Environnement

```bash
# .env
JWT_SECRET=your-super-secret-key-min-32-characters-long-please-change-me
JWT_EXPIRATION_HOURS=24
JWT_ISSUER=collectoria-api
```

### Génération de JWT Secret Sécurisé

```bash
# Générer un secret aléatoire de 64 caractères
openssl rand -base64 48
```

---

## Tests

### Test Unitaire du JWT Service

```go
// internal/infrastructure/auth/jwt_service_test.go
package auth_test

import (
    "testing"
    "time"
    
    "collectoria/collection-management/internal/infrastructure/auth"
    "github.com/google/uuid"
    "github.com/stretchr/testify/assert"
    "github.com/stretchr/testify/require"
)

func TestJWTService_GenerateAndValidateToken(t *testing.T) {
    service := auth.NewJWTService("test-secret-at-least-32-chars-long", "test-issuer", 24)
    userID := uuid.New()
    email := "test@example.com"
    
    // Generate token
    token, err := service.GenerateToken(userID, email)
    require.NoError(t, err)
    assert.NotEmpty(t, token)
    
    // Validate token
    claims, err := service.ValidateToken(token)
    require.NoError(t, err)
    assert.Equal(t, userID, claims.UserID)
    assert.Equal(t, email, claims.Email)
}

func TestJWTService_ValidateToken_Invalid(t *testing.T) {
    service := auth.NewJWTService("test-secret-at-least-32-chars-long", "test-issuer", 24)
    
    // Invalid token
    _, err := service.ValidateToken("invalid.token.here")
    assert.Error(t, err)
}
```

### Test d'Intégration

```bash
# 1. Démarrer le serveur
go run cmd/api/main.go

# 2. Tester sans token (doit échouer)
curl -X GET http://localhost:8080/api/v1/collections/summary
# Expected: {"error":{"code":"UNAUTHORIZED","message":"Missing authorization header"}}

# 3. Générer un token de test (à implémenter un endpoint /auth/login plus tard)
# Pour l'instant, utiliser un script Go:
go run scripts/generate_test_token.go

# 4. Tester avec token
curl -X GET http://localhost:8080/api/v1/collections/summary \
  -H "Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
# Expected: {"user_id":"...", "total_cards_owned":...}
```

---

## Migration Progressive

### Phase 1: Implémentation (Jour 1)
1. Ajouter dépendance JWT
2. Créer JWTService et middleware
3. Mettre à jour configuration

### Phase 2: Intégration (Jour 1-2)
1. Mettre à jour tous les handlers pour extraire userID du context
2. Ajouter middleware auth aux routes
3. Tester en local

### Phase 3: Tests (Jour 2)
1. Tests unitaires du JWT service
2. Tests d'intégration des endpoints protégés
3. Tests de sécurité (token expiré, invalide, etc.)

---

## Notes Importantes

### Sécurité du Secret

- **NEVER commit JWT_SECRET to Git**
- Utiliser un gestionnaire de secrets (AWS Secrets Manager, HashiCorp Vault, etc.)
- Rotation régulière du secret (tous les 90 jours)

### Algorithme de Signature

- Utiliser **HS256** (HMAC SHA-256) pour simplicité
- Alternative: **RS256** (RSA) si besoin de clés publiques/privées

### Durée de Validité

- **Access Token**: 24h (configurable)
- **Refresh Token**: À implémenter plus tard (7 jours)

### Gestion des Tokens Expirés

Le client frontend devra:
1. Stocker le token dans localStorage ou cookie HttpOnly
2. Intercepter les erreurs 401
3. Rediriger vers /login

---

## Checklist de Validation

- [ ] Dépendance `github.com/golang-jwt/jwt/v5` ajoutée
- [ ] JWTService implémenté avec tests
- [ ] AuthMiddleware créé
- [ ] Tous les handlers mis à jour (plus de userID hardcodé)
- [ ] Routes protégées avec middleware
- [ ] Configuration JWT avec validation
- [ ] JWT_SECRET généré et sécurisé
- [ ] Tests unitaires passent
- [ ] Tests d'intégration passent
- [ ] Documentation mise à jour

---

## Références

- [JWT Best Practices](https://tools.ietf.org/html/rfc8725)
- [golang-jwt Documentation](https://github.com/golang-jwt/jwt)
- [OWASP JWT Cheat Sheet](https://cheatsheetseries.owasp.org/cheatsheets/JSON_Web_Token_for_Java_Cheat_Sheet.html)
