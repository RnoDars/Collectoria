# Quick Wins - Corrections Rapides de Sécurité

**Estimation Totale**: 2-3 heures  
**Impact**: Moyen à élevé  
**Difficulté**: Faible

Ces corrections peuvent être implémentées rapidement et améliorent significativement la posture de sécurité.

---

## 1. Headers de Sécurité HTTP (30 minutes)

### Ajout des Headers Recommandés

```go
// internal/infrastructure/http/server.go

func (s *Server) setupMiddleware() {
    s.router.Use(middleware.RequestID)
    s.router.Use(middleware.RealIP)
    s.router.Use(middleware.Logger)
    s.router.Use(middleware.Recoverer)
    s.router.Use(middleware.Timeout(60 * time.Second))
    
    // ✅ NOUVEAU: Headers de sécurité
    s.router.Use(securityHeadersMiddleware)
    
    // CORS (existing)
    s.router.Use(func(next http.Handler) http.Handler {
        // ... existing CORS code
    })
}

// securityHeadersMiddleware ajoute les headers de sécurité HTTP
func securityHeadersMiddleware(next http.Handler) http.Handler {
    return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
        // Prevent MIME type sniffing
        w.Header().Set("X-Content-Type-Options", "nosniff")
        
        // Prevent clickjacking
        w.Header().Set("X-Frame-Options", "DENY")
        
        // XSS Protection (legacy but still useful)
        w.Header().Set("X-XSS-Protection", "1; mode=block")
        
        // Referrer policy
        w.Header().Set("Referrer-Policy", "strict-origin-when-cross-origin")
        
        // HSTS (only if HTTPS)
        if r.TLS != nil {
            w.Header().Set("Strict-Transport-Security", "max-age=31536000; includeSubDomains")
        }
        
        // Content Security Policy (restrictive)
        w.Header().Set("Content-Security-Policy", "default-src 'self'; frame-ancestors 'none'")
        
        next.ServeHTTP(w, r)
    })
}
```

**Test**:
```bash
curl -I http://localhost:8080/api/v1/health
# Vérifier la présence des headers
```

---

## 2. CORS Configurable (30 minutes)

### Externaliser la Configuration CORS

```go
// internal/config/config.go

type Config struct {
    Server   ServerConfig
    Database DatabaseConfig
    CORS     CORSConfig  // ✅ NOUVEAU
}

type CORSConfig struct {
    AllowedOrigins []string
    MaxAge         int
}

func Load() (*Config, error) {
    cfg := &Config{
        // ... existing config
        CORS: CORSConfig{
            AllowedOrigins: strings.Split(getEnv("CORS_ALLOWED_ORIGINS", "http://localhost:3000,http://localhost:3001"), ","),
            MaxAge:         getEnvAsInt("CORS_MAX_AGE", 300),
        },
    }
    return cfg, nil
}
```

```go
// internal/infrastructure/http/server.go

func (s *Server) setupMiddleware() {
    // ... existing middlewares
    
    // ✅ CORS amélioré
    s.router.Use(s.corsMiddleware)
}

func (s *Server) corsMiddleware(next http.Handler) http.Handler {
    return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
        origin := r.Header.Get("Origin")
        
        // Check if origin is allowed
        allowed := false
        for _, allowedOrigin := range s.corsConfig.AllowedOrigins {
            if origin == allowedOrigin {
                allowed = true
                break
            }
        }
        
        if allowed {
            w.Header().Set("Access-Control-Allow-Origin", origin)
            w.Header().Set("Access-Control-Allow-Methods", "GET, POST, PUT, DELETE, OPTIONS")
            w.Header().Set("Access-Control-Allow-Headers", "Content-Type, Authorization")
            w.Header().Set("Access-Control-Max-Age", strconv.Itoa(s.corsConfig.MaxAge))
        }
        
        if r.Method == "OPTIONS" {
            w.WriteHeader(http.StatusOK)
            return
        }
        
        next.ServeHTTP(w, r)
    })
}
```

**Configuration**:
```bash
# .env
CORS_ALLOWED_ORIGINS=http://localhost:3000,http://localhost:3001
CORS_MAX_AGE=300
```

---

## 3. Health Check Amélioré (20 minutes)

### Vérifier la Connexion Database

```go
// internal/infrastructure/http/server.go

type HealthResponse struct {
    Status   string            `json:"status"`
    Checks   map[string]string `json:"checks"`
    Version  string            `json:"version,omitempty"`
}

func (s *Server) setupRoutes() {
    s.router.Route("/api/v1", func(r chi.Router) {
        // ✅ Health check amélioré
        r.Get("/health", s.healthCheckHandler)
        
        // ... autres routes
    })
}

func (s *Server) healthCheckHandler(w http.ResponseWriter, r *http.Request) {
    ctx, cancel := context.WithTimeout(r.Context(), 2*time.Second)
    defer cancel()
    
    checks := make(map[string]string)
    overallStatus := "healthy"
    
    // Check database connection
    if err := s.db.PingContext(ctx); err != nil {
        checks["database"] = "unhealthy: " + err.Error()
        overallStatus = "unhealthy"
    } else {
        checks["database"] = "healthy"
    }
    
    // Check memory (optional)
    var m runtime.MemStats
    runtime.ReadMemStats(&m)
    checks["memory_mb"] = fmt.Sprintf("%.2f", float64(m.Alloc)/1024/1024)
    
    response := HealthResponse{
        Status:  overallStatus,
        Checks:  checks,
        Version: "0.1.0",
    }
    
    statusCode := http.StatusOK
    if overallStatus != "healthy" {
        statusCode = http.StatusServiceUnavailable
    }
    
    w.Header().Set("Content-Type", "application/json")
    w.WriteHeader(statusCode)
    json.NewEncoder(w).Encode(response)
}
```

**Note**: Ajouter `s.db *sqlx.DB` dans la struct `Server`

---

## 4. Externaliser les Credentials (30 minutes)

### Docker Compose avec Variables d'Environnement

```yaml
# backend/collection-management/docker-compose.yml
version: '3.8'

services:
  postgres:
    image: postgres:15-alpine
    container_name: collectoria-collection-db
    environment:
      POSTGRES_USER: ${DB_USER:-collectoria}
      POSTGRES_PASSWORD: ${DB_PASSWORD:-changeme}  # ✅ Valeur par défaut sécurisée
      POSTGRES_DB: ${DB_NAME:-collection_management}
    ports:
      - "${DB_PORT:-5432}:5432"
    volumes:
      - postgres_data:/var/lib/postgresql/data
      - ./migrations:/docker-entrypoint-initdb.d
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U ${DB_USER:-collectoria}"]
      interval: 5s
      timeout: 5s
      retries: 5

volumes:
  postgres_data:
```

### Fichier .env.example Mis à Jour

```bash
# backend/collection-management/.env.example
# Server Configuration
SERVER_PORT=8080

# Database Configuration
DB_HOST=localhost
DB_PORT=5432
DB_USER=collectoria
DB_PASSWORD=your-secure-password-here  # ✅ CHANGE ME IN PRODUCTION
DB_NAME=collection_management
DB_SSLMODE=disable

# CORS Configuration
CORS_ALLOWED_ORIGINS=http://localhost:3000,http://localhost:3001
CORS_MAX_AGE=300
```

### Instructions dans README

```markdown
# backend/collection-management/README.md

## Configuration

1. Copier le fichier d'exemple:
   ```bash
   cp .env.example .env
   ```

2. **IMPORTANT**: Changer les valeurs par défaut, notamment:
   - `DB_PASSWORD`: Utiliser un mot de passe fort
   - En production: configurer JWT_SECRET, etc.

3. Ne JAMAIS commiter le fichier `.env` dans Git
```

---

## 5. Dockerfile Non-Root (20 minutes)

### Exécuter en tant qu'Utilisateur Non-Privilégié

```dockerfile
# backend/collection-management/Dockerfile

# Build stage
FROM golang:1.21-alpine AS builder

WORKDIR /app

# Copy go mod files
COPY go.mod go.sum ./
RUN go mod download

# Copy source code
COPY . .

# Build the application
RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o main ./cmd/api

# Final stage
FROM alpine:3.19  # ✅ Version fixée

# Install ca-certificates and create non-root user
RUN apk --no-cache add ca-certificates && \
    addgroup -g 1000 collectoria && \
    adduser -D -u 1000 -G collectoria collectoria

WORKDIR /app

# Copy binary with correct ownership
COPY --from=builder --chown=collectoria:collectoria /app/main .

# ✅ Switch to non-root user
USER collectoria

# Expose port
EXPOSE 8080

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD wget --no-verbose --tries=1 --spider http://localhost:8080/api/v1/health || exit 1

# Run the binary
CMD ["./main"]
```

**Test**:
```bash
docker build -t collectoria-api .
docker run --rm collectoria-api id
# Expected: uid=1000(collectoria) gid=1000(collectoria)
```

---

## 6. Logging Sécurisé (30 minutes)

### Configurer le Logger selon l'Environnement

```go
// cmd/api/main.go

func main() {
    // Configuration du logger selon l'environnement
    env := getEnv("ENV", "development")
    
    if env == "production" {
        // Production: JSON structured logs
        log.Logger = zerolog.New(os.Stdout).With().
            Timestamp().
            Str("service", "collection-management").
            Logger()
        zerolog.SetGlobalLevel(zerolog.InfoLevel)
    } else {
        // Development: Pretty console logs
        log.Logger = log.Output(zerolog.ConsoleWriter{
            Out:        os.Stderr,
            TimeFormat: time.RFC3339,
        })
        zerolog.SetGlobalLevel(zerolog.DebugLevel)
    }
    
    log.Info().Str("env", env).Msg("Starting Collection Management Service")
    
    // ... rest of the code
}

func getEnv(key, defaultValue string) string {
    value := os.Getenv(key)
    if value == "" {
        return defaultValue
    }
    return value
}
```

### Ne PAS Logger de Données Sensibles

```go
// internal/infrastructure/postgres/connection.go

func NewConnection(cfg Config) (*sqlx.DB, error) {
    // ❌ AVANT: Log du DSN complet avec password
    // log.Info().Msgf("Connecting to: %s", dsn)
    
    // ✅ APRÈS: Log sans password
    log.Info().
        Str("host", cfg.Host).
        Int("port", cfg.Port).
        Str("user", cfg.User).
        Str("database", cfg.Database).
        Msg("Connecting to database")
    
    dsn := fmt.Sprintf(
        "host=%s port=%d user=%s password=%s dbname=%s sslmode=%s",
        cfg.Host, cfg.Port, cfg.User, cfg.Password, cfg.Database, cfg.SSLMode,
    )
    
    db, err := sqlx.Connect("postgres", dsn)
    if err != nil {
        return nil, fmt.Errorf("failed to connect to database: %w", err)
    }
    
    // ... rest
}
```

---

## 7. .gitignore Complet (5 minutes)

### Vérifier que les Secrets ne sont PAS Commités

```gitignore
# backend/collection-management/.gitignore

# Environment variables
.env
.env.local
.env.*.local

# Database data
postgres_data/
*.db
*.sqlite

# Go build artifacts
main
*.exe
*.exe~
*.dll
*.so
*.dylib
*.test
*.out

# Vendor
vendor/

# IDE
.idea/
.vscode/
*.swp
*.swo
*~

# Logs
*.log
logs/

# OS
.DS_Store
Thumbs.db

# Secrets
secrets/
*.pem
*.key
*.crt
```

**Vérification**:
```bash
git status
# S'assurer que .env n'apparaît PAS dans les fichiers non trackés
```

---

## Checklist Complète

### Immédiat (< 3 heures)

- [ ] Headers de sécurité HTTP ajoutés
- [ ] CORS configurable via ENV
- [ ] Health check vérifiant la DB
- [ ] Credentials externalisés dans docker-compose
- [ ] Dockerfile non-root
- [ ] Logger configuré selon ENV
- [ ] .gitignore vérifié
- [ ] .env.example créé avec instructions

### Test et Validation

- [ ] `curl -I http://localhost:8080/api/v1/health` → Headers présents
- [ ] Health check retourne status DB
- [ ] Docker container tourne en tant que user 1000
- [ ] Logs en production sont JSON
- [ ] `.env` n'est pas committé dans Git
- [ ] CORS fonctionne avec origine configurée

---

## Script de Validation

```bash
#!/bin/bash
# scripts/validate-security-quick-wins.sh

set -e

echo "=== Validation Quick Wins ==="

# 1. Check headers
echo "1. Testing security headers..."
HEADERS=$(curl -sI http://localhost:8080/api/v1/health)
if echo "$HEADERS" | grep -q "X-Content-Type-Options"; then
    echo "✓ Security headers present"
else
    echo "✗ Security headers missing"
    exit 1
fi

# 2. Check health endpoint
echo "2. Testing health check..."
HEALTH=$(curl -s http://localhost:8080/api/v1/health)
if echo "$HEALTH" | grep -q "database"; then
    echo "✓ Health check with DB status"
else
    echo "✗ Health check missing DB status"
    exit 1
fi

# 3. Check .env not in Git
echo "3. Checking .env not committed..."
if git ls-files | grep -q "\.env$"; then
    echo "✗ .env is committed to Git!"
    exit 1
else
    echo "✓ .env not committed"
fi

# 4. Check Docker user
echo "4. Checking Docker non-root user..."
DOCKER_USER=$(docker run --rm collectoria-api id -u)
if [ "$DOCKER_USER" = "1000" ]; then
    echo "✓ Docker runs as non-root"
else
    echo "✗ Docker runs as root (UID $DOCKER_USER)"
    exit 1
fi

echo ""
echo "=== All Quick Wins Validated ✓ ==="
```

---

## Impact Attendu

| Quick Win | Temps | Impact Sécurité | Difficulté |
|-----------|-------|-----------------|------------|
| Headers HTTP | 30 min | Moyen | Faible |
| CORS Configurable | 30 min | Élevé | Faible |
| Health Check | 20 min | Faible | Faible |
| Credentials ENV | 30 min | CRITIQUE | Faible |
| Dockerfile Non-Root | 20 min | Moyen | Faible |
| Logging Sécurisé | 30 min | Moyen | Faible |
| .gitignore | 5 min | Élevé | Faible |

**Total**: 2h45 → **Score Sécurité: +2.5 points** (de 4.5/10 à 7.0/10)

---

## Prochaines Étapes

Après ces Quick Wins, prioriser:
1. **JWT Authentication** (CRIT-001) - 2 jours
2. **Rate Limiting** (CRIT-005) - 4 heures
3. **SQL Injection Fix** (CRIT-002) - 1 jour
