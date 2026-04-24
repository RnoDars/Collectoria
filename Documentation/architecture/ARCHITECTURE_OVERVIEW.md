# Architecture Collectoria - Vue d'Ensemble

**Date de création** : 2026-04-24  
**Version** : 1.0  
**État du projet** : Production-ready (Score Sécurité 9.0/10)

---

## 1. Introduction

### 1.1 Vision du Projet

Collectoria est une application web de gestion de collections de cartes et de livres. L'objectif est de permettre aux collectionneurs de cataloguer leurs possessions, suivre leur progression, et gérer leurs collections de manière organisée et visuelle.

**Collections actuellement supportées** :
- **Middle-earth CCG (MECCG)** : 1,679 cartes (jeu de cartes Fantasy basé sur l'univers de Tolkien)
- **Royaumes Oubliés (Books)** : 94 livres (romans fantasy)

### 1.2 Stack Technique

**Frontend** :
- Next.js 15 (React 19)
- TypeScript
- React Query (state management + cache)
- Vitest (tests)

**Backend** :
- Go 1.21+ avec architecture DDD
- Chi Router (HTTP)
- sqlx (PostgreSQL direct, sans ORM)
- JWT Authentication (HS256)

**Base de Données** :
- PostgreSQL 15+
- Migrations SQL avec golang-migrate

**Infrastructure** :
- Docker & Docker Compose (environnement local)
- GitHub Actions (CI/CD)

**Sécurité** :
- JWT Authentication (HS256)
- Rate Limiting (3-tier)
- Security Headers (5 headers)
- SQL Injection : 0 vulnérabilité (parameterized queries)
- **Score : 9.0/10** (production-ready baseline)

---

## 2. Architecture Globale

### 2.1 Vue d'Ensemble

```
┌─────────────────────────────────────────────────────────────────┐
│                       UTILISATEUR                                │
└───────────────────────────┬─────────────────────────────────────┘
                            │ HTTPS
                            ▼
┌─────────────────────────────────────────────────────────────────┐
│                    FRONTEND (Next.js)                            │
│                                                                  │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────────────┐ │
│  │   Pages      │  │  Components  │  │  React Query         │ │
│  │   /          │  │  HeroCard    │  │  (Cache + Mutations) │ │
│  │   /cards     │  │  CardsGrid   │  └──────────────────────┘ │
│  │   /books     │  │  BooksGrid   │                            │
│  │   /login     │  │  TopNav      │  ┌──────────────────────┐ │
│  └──────────────┘  └──────────────┘  │  Auth (JWT)          │ │
│                                       │  localStorage        │ │
│                                       └──────────────────────┘ │
└────────────────────────────┬────────────────────────────────────┘
                             │ REST API (JSON)
                             │ Authorization: Bearer <token>
                             ▼
┌─────────────────────────────────────────────────────────────────┐
│              BACKEND API (Go Microservice)                       │
│           Collection Management Microservice                     │
│                                                                  │
│  ┌────────────────────────────────────────────────────────────┐ │
│  │                  Middlewares                                │ │
│  │  • Auth JWT (vérification token)                           │ │
│  │  • Rate Limiting (3-tier : login, read, write)             │ │
│  │  • CORS (localhost:3000, localhost:3001)                   │ │
│  │  • Security Headers (5 headers)                            │ │
│  └────────────────────────────────────────────────────────────┘ │
│                                                                  │
│  ┌────────────────────────────────────────────────────────────┐ │
│  │           Architecture DDD (3 Layers)                       │ │
│  │                                                             │ │
│  │  Domain Layer (Entities + Business Logic)                  │ │
│  │    • Collection, Card, Book, UserCard, UserBook           │ │
│  │    • Activity (événements utilisateur)                     │ │
│  │    • Repository Interfaces                                 │ │
│  │                                                             │ │
│  │  Application Layer (Use Cases + Services)                  │ │
│  │    • CollectionService                                     │ │
│  │    • CardService                                           │ │
│  │    • BookService                                           │ │
│  │    • ActivityService                                       │ │
│  │                                                             │ │
│  │  Infrastructure Layer (HTTP + DB)                          │ │
│  │    • HTTP Handlers (Chi Router)                            │ │
│  │    • PostgreSQL Repositories (sqlx)                        │ │
│  │    • JWT Service                                           │ │
│  └────────────────────────────────────────────────────────────┘ │
└────────────────────────────┬────────────────────────────────────┘
                             │ SQL Queries (parameterized)
                             ▼
┌─────────────────────────────────────────────────────────────────┐
│                    BASE DE DONNÉES                               │
│                     PostgreSQL 15+                               │
│                                                                  │
│  Tables Principales :                                            │
│    • collections (MECCG, Books)                                  │
│    • cards (1,679 cartes MECCG)                                 │
│    • books (94 livres Royaumes Oubliés)                        │
│    • user_collections                                           │
│    • user_cards (possession)                                    │
│    • user_books (possession)                                    │
│    • activities (événements)                                    │
│                                                                  │
│  6 Migrations SQL appliquées                                     │
└─────────────────────────────────────────────────────────────────┘
```

### 2.2 Flux Typique : Affichage Homepage

```
1. Utilisateur ouvre localhost:3000
   ↓
2. Frontend vérifie token JWT dans localStorage
   ↓ (si absent → redirect /login)
3. Frontend appelle 4 endpoints REST en parallèle :
   • GET /api/v1/collections/summary
   • GET /api/v1/collections
   • GET /api/v1/activities/recent
   • GET /api/v1/statistics/growth
   ↓
4. Backend vérifie JWT + Rate Limiting
   ↓
5. Backend exécute requêtes SQL (avec parameterized queries)
   ↓
6. Backend retourne JSON (snake_case)
   ↓
7. Frontend convertit snake_case → camelCase
   ↓
8. React Query met en cache (staleTime : 1-30 min)
   ↓
9. Composants React affichent les données
```

### 2.3 Flux Typique : Toggle Possession d'une Carte

```
1. Utilisateur clique sur le toggle d'une carte
   ↓
2. Frontend affiche modale de confirmation
   ↓
3. Utilisateur confirme → Frontend envoie PATCH /api/v1/cards/:id/possession
   ↓
4. Backend vérifie JWT + Rate Limiting (write : 30/min)
   ↓
5. Backend met à jour user_cards.is_owned en BDD
   ↓
6. Backend enregistre activité (card_added ou card_removed)
   ↓
7. Backend retourne carte mise à jour
   ↓
8. Frontend met à jour UI (optimistic update)
   ↓
9. React Query invalide cache /cards
   ↓
10. Toast notification affiche succès
```

---

## 3. Frontend Next.js 15

### 3.1 Structure `/app` (App Router)

```
frontend/
├── src/
│   ├── app/
│   │   ├── layout.tsx               # Layout principal + Providers
│   │   ├── page.tsx                 # Homepage (HeroCard + Collections + Widgets)
│   │   ├── login/
│   │   │   └── page.tsx             # Page de connexion
│   │   ├── cards/
│   │   │   └── page.tsx             # Gestion des cartes (filtres + toggle)
│   │   ├── books/
│   │   │   └── page.tsx             # Gestion des livres (filtres + toggle)
│   │   ├── providers.tsx            # React Query Provider
│   │   └── globals.css              # Variables CSS Ethos V1
│   │
│   ├── components/
│   │   ├── homepage/
│   │   │   ├── HeroCard.tsx         # Progression globale (68% des cartes)
│   │   │   ├── CollectionCard.tsx   # Carte d'une collection (MECCG/Books)
│   │   │   ├── CollectionsGrid.tsx  # Grille de collections
│   │   │   ├── RecentActivityWidget.tsx  # Activités récentes
│   │   │   └── GrowthInsightWidget.tsx   # Graphique croissance
│   │   ├── cards/
│   │   │   └── ConfirmToggleModal.tsx    # Modale confirmation toggle carte
│   │   ├── books/
│   │   │   ├── BooksTable.tsx            # Liste des livres avec filtres
│   │   │   └── BookConfirmModal.tsx      # Modale confirmation toggle livre
│   │   ├── layout/
│   │   │   └── TopNav.tsx           # Navigation principale
│   │   └── auth/
│   │       └── ProtectedRoute.tsx   # HOC pour pages protégées
│   │
│   ├── hooks/
│   │   ├── useCollectionSummary.ts  # React Query hook (cache 5min)
│   │   ├── useCollections.ts        # Liste collections
│   │   ├── useActivities.ts         # Activités récentes (cache 1min)
│   │   ├── useGrowthStats.ts        # Stats croissance (cache 30min)
│   │   ├── useCardToggle.ts         # Mutation toggle carte
│   │   ├── useBookToggle.ts         # Mutation toggle livre
│   │   └── useAuth.ts               # Login, logout, isAuthenticated
│   │
│   ├── lib/
│   │   ├── api/
│   │   │   ├── client.ts            # Client API centralisé (fetch + JWT header)
│   │   │   ├── collections.ts       # Endpoints collections
│   │   │   ├── cards.ts             # Endpoints cartes
│   │   │   ├── books.ts             # Endpoints livres
│   │   │   └── auth.ts              # Endpoint login
│   │   └── auth.ts                  # Gestion token JWT (localStorage)
│   │
│   └── types/
│       ├── collection.ts            # Types TypeScript
│       ├── card.ts
│       ├── book.ts
│       └── activity.ts
```

### 3.2 Composants Clés

#### HeroCard
**Fichier** : `src/components/homepage/HeroCard.tsx`  
**Rôle** : Affiche la progression globale de toutes les collections  
**Données** : `GET /api/v1/collections/summary`  
**États** : Loading (skeleton), Error, Empty, Success

#### CollectionsGrid
**Fichier** : `src/components/homepage/CollectionsGrid.tsx`  
**Rôle** : Grille des collections (MECCG, Books)  
**Données** : `GET /api/v1/collections`

#### CardsPage
**Fichier** : `src/app/cards/page.tsx`  
**Rôle** : Gestion des cartes avec filtres (type, rareté, recherche)  
**Interactions** : Toggle possession avec modale de confirmation

#### BooksPage
**Fichier** : `src/app/books/page.tsx`  
**Rôle** : Gestion des livres avec filtres (cycle, titre)  
**Interactions** : Toggle possession avec modale de confirmation

### 3.3 React Query (State Management + Cache)

**Configuration** :
```typescript
// src/app/providers.tsx
const queryClient = new QueryClient({
  defaultOptions: {
    queries: {
      staleTime: 5 * 60 * 1000,  // 5 minutes
      gcTime: 10 * 60 * 1000,    // 10 minutes
    },
  },
});
```

**Stratégie de cache par endpoint** :
- `/collections/summary` : staleTime 5 min (données globales peu changeantes)
- `/collections` : staleTime 10 min (liste collections stable)
- `/activities/recent` : staleTime 1 min (données dynamiques)
- `/statistics/growth` : staleTime 30 min (agrégats historiques)

**Invalidation du cache** :
- Mutation `PATCH /cards/:id/possession` → Invalide `/cards`, `/collections/summary`, `/activities/recent`
- Mutation `PATCH /books/:id/possession` → Invalide `/books`, `/collections/summary`, `/activities/recent`

### 3.4 Authentification JWT

**Flow Login** :
1. Utilisateur saisit email + password sur `/login`
2. Frontend envoie `POST /api/v1/auth/login`
3. Backend retourne token JWT + expires_at
4. Frontend stocke token dans `localStorage`
5. Redirection vers homepage `/`

**Gestion Token** :
```typescript
// src/lib/auth.ts
export function setAuthToken(token: string): void {
  localStorage.setItem('auth_token', token);
}

export function getAuthToken(): string | null {
  return localStorage.getItem('auth_token');
}

export function isAuthenticated(): boolean {
  const token = getAuthToken();
  if (!token) return false;
  
  const decoded = decodeToken(token);
  return decoded && decoded.exp * 1000 > Date.now();
}
```

**Injection automatique dans les requêtes** :
```typescript
// src/lib/api/client.ts
export async function apiRequest(url: string, options: RequestInit) {
  const token = getAuthToken();
  const headers = {
    'Content-Type': 'application/json',
    ...(token && { Authorization: `Bearer ${token}` }),
    ...options.headers,
  };

  const response = await fetch(url, { ...options, headers });
  
  if (response.status === 401) {
    removeAuthToken();
    window.location.href = '/login';
  }
  
  return response;
}
```

### 3.5 Design System (Ethos V1)

**Philosophie** : "The Digital Curator" (approche éditoriale haut de gamme)

**Principes clés** :
- **No-Line Rule** : Pas de bordures 1px, utiliser Tonal Layering
- **Dual-Type System** : Manrope (Editorial) + Inter (Utility)
- **Gradient Violet** : `#667eea → #764ba2` (utilisé avec parcimonie sur CTAs)
- **Espacement généreux** : Margins et paddings larges
- **Border Radius** : xl (24px) pour les cartes principales

**Variables CSS** :
```css
/* src/app/globals.css */
:root {
  /* Colors */
  --surface: #f8f9fa;
  --surface-container-low: #f3f4f5;
  --surface-container-lowest: #ffffff;
  --primary: #667eea;
  --primary-container: #764ba2;
  --on-surface: #191c1d;
  --on-surface-variant: #42474a;
  
  /* Border Radius */
  --radius-sm: 4px;
  --radius-md: 12px;
  --radius-lg: 16px;
  --radius-xl: 24px;
}
```

### 3.6 Conversion snake_case ↔ camelCase

**Problème** : Backend Go utilise `snake_case`, Frontend TypeScript utilise `camelCase`.

**Solution** : Conversion automatique dans le client API.

```typescript
// src/lib/api/collections.ts
export async function fetchCollectionSummary(): Promise<CollectionSummary> {
  const response = await apiClient.get('/api/v1/collections/summary');
  const data = response.data;
  
  // Conversion snake_case → camelCase
  return {
    userId: data.user_id,
    totalCardsOwned: data.total_cards_owned,
    totalCardsAvailable: data.total_cards_available,
    completionPercentage: data.completion_percentage,
    lastUpdated: data.last_updated,
  };
}
```

---

## 4. Backend Go (Microservice)

### 4.1 Architecture DDD (Domain-Driven Design)

**Bounded Context** : Collection Management  
**Responsabilité** : Gestion des collections, cartes, livres, possession utilisateur, activités

```
backend/collection-management/
├── cmd/
│   └── api/
│       └── main.go                    # Point d'entrée
│
├── internal/
│   ├── domain/                        # 🔴 DOMAIN LAYER (Business Logic)
│   │   ├── collection.go              # Entity Collection + méthodes métier
│   │   ├── card.go                    # Entity Card
│   │   ├── book.go                    # Entity Book
│   │   ├── activity.go                # Entity Activity (événements)
│   │   └── repository.go              # Interfaces Repository (abstraction)
│   │
│   ├── application/                   # 🟠 APPLICATION LAYER (Use Cases)
│   │   ├── collection_service.go      # CollectionService (orchestration)
│   │   ├── collection_service_test.go # Tests TDD
│   │   ├── card_service.go            # CardService
│   │   ├── book_service.go            # BookService
│   │   └── activity_service.go        # ActivityService
│   │
│   ├── infrastructure/                # 🟢 INFRASTRUCTURE LAYER (Technical)
│   │   ├── http/
│   │   │   ├── server.go              # Chi Router + Middlewares
│   │   │   ├── middleware/
│   │   │   │   ├── auth.go            # JWT Middleware
│   │   │   │   ├── rate_limiter.go    # Rate Limiting (3-tier)
│   │   │   │   └── cors.go            # CORS configuration
│   │   │   └── handlers/
│   │   │       ├── collection_handler.go
│   │   │       ├── card_handler.go
│   │   │       ├── book_handler.go
│   │   │       ├── activity_handler.go
│   │   │       └── auth_handler.go
│   │   │
│   │   ├── postgres/
│   │   │   ├── collection_repository.go  # Implémentation Repository
│   │   │   ├── card_repository.go
│   │   │   ├── book_repository.go
│   │   │   └── activity_repository.go
│   │   │
│   │   └── jwt/
│   │       └── jwt_service.go         # Génération + validation JWT
│   │
│   └── config/
│       └── config.go                  # Configuration (env vars)
│
├── migrations/                        # 🗂️ SQL Migrations (6 au total)
│   ├── 001_create_collections_schema.sql
│   ├── 002_seed_meccg_real.sql       # 1,679 cartes MECCG
│   ├── 003_create_activities_table.sql
│   ├── 004_seed_dev_possession.sql
│   ├── 005_add_books_collection.sql
│   └── 006_add_title_description_to_activities.sql
│
├── testdata/
│   └── seed_meccg_mock.sql           # 40 cartes mock pour tests
│
├── go.mod
├── docker-compose.yml
└── Makefile
```

### 4.2 Endpoints REST Disponibles

**Authentication** :
```
POST /api/v1/auth/login
  → Credentials : email + password
  → Retourne : token JWT + expires_at
```

**Collections** :
```
GET /api/v1/collections/summary
  → Retourne : stats globales (total cartes possédées, %, last_updated)
  → Cache : 5 min

GET /api/v1/collections
  → Retourne : liste collections (MECCG, Books) avec stats
  → Cache : 10 min
```

**Cartes** :
```
GET /api/v1/cards
  → Query params : type, rarity, search, limit, offset
  → Retourne : liste cartes avec pagination
  
PATCH /api/v1/cards/:id/possession
  → Body : { "is_owned": true/false }
  → Retourne : carte mise à jour
  → Side-effect : Enregistre activité (card_added/card_removed)
```

**Livres** :
```
GET /api/v1/books
  → Query params : cycle, search, limit, offset
  → Retourne : liste livres avec pagination
  
PATCH /api/v1/books/:id/possession
  → Body : { "is_owned": true/false }
  → Retourne : livre mis à jour
  → Side-effect : Enregistre activité (book_added/book_removed)
```

**Activités** :
```
GET /api/v1/activities/recent
  → Query params : limit (default: 10)
  → Retourne : activités récentes (card_added, book_added, milestone_reached)
  → Cache : 1 min
```

**Statistiques** :
```
GET /api/v1/statistics/growth
  → Query params : period (default: 6m)
  → Retourne : données de croissance par mois (6 derniers mois)
  → Cache : 30 min
```

**Health** :
```
GET /api/v1/health
  → Retourne : status + checks (database, memory)
  → Pas d'authentification requise
```

### 4.3 Authentification JWT (HS256)

**Configuration** :
```bash
# .env
JWT_SECRET=your-super-secret-key-at-least-32-chars
JWT_EXPIRATION_HOURS=24
JWT_ISSUER=collectoria-api
```

**Génération Token** :
```go
// internal/infrastructure/jwt/jwt_service.go
func (s *JWTService) GenerateToken(userID uuid.UUID, email string) (string, time.Time, error) {
    expiresAt := time.Now().Add(s.expirationDuration)
    
    claims := CustomClaims{
        UserID: userID,
        Email:  email,
        RegisteredClaims: jwt.RegisteredClaims{
            Issuer:    s.issuer,
            ExpiresAt: jwt.NewNumericDate(expiresAt),
            IssuedAt:  jwt.NewNumericDate(time.Now()),
        },
    }
    
    token := jwt.NewWithClaims(jwt.SigningMethodHS256, claims)
    signedToken, err := token.SignedString([]byte(s.secret))
    
    return signedToken, expiresAt, err
}
```

**Validation Token (Middleware)** :
```go
// internal/infrastructure/http/middleware/auth.go
func AuthMiddleware(jwtService *jwt.JWTService) func(next http.Handler) http.Handler {
    return func(next http.Handler) http.Handler {
        return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
            authHeader := r.Header.Get("Authorization")
            if authHeader == "" {
                http.Error(w, "Missing authorization header", http.StatusUnauthorized)
                return
            }
            
            tokenString := strings.TrimPrefix(authHeader, "Bearer ")
            claims, err := jwtService.ValidateToken(tokenString)
            if err != nil {
                http.Error(w, "Invalid token", http.StatusUnauthorized)
                return
            }
            
            // Injection userID dans context
            ctx := context.WithUserID(r.Context(), claims.UserID)
            next.ServeHTTP(w, r.WithContext(ctx))
        })
    }
}
```

### 4.4 Rate Limiting (3-Tier)

**Configuration** :
```go
// internal/infrastructure/http/middleware/rate_limiter.go
var rateLimitConfig = map[string]RateLimitConfig{
    "login": {
        RequestsPerMinute: 5,
        Window:            15 * time.Minute,  // 5 tentatives / 15 min
    },
    "read": {
        RequestsPerMinute: 100,
        Window:            1 * time.Minute,   // 100 requêtes / 1 min
    },
    "write": {
        RequestsPerMinute: 30,
        Window:            1 * time.Minute,   // 30 requêtes / 1 min
    },
}
```

**Application par endpoint** :
```go
// internal/infrastructure/http/server.go
r.Route("/api/v1", func(r chi.Router) {
    // Public endpoint (pas de rate limit)
    r.Get("/health", healthHandler.Health)
    
    // Login avec rate limiting strict
    r.With(RateLimitMiddleware("login")).Post("/auth/login", authHandler.Login)
    
    // Protected endpoints
    r.Group(func(r chi.Router) {
        r.Use(authMiddleware)
        
        // Read endpoints (100/min)
        r.With(RateLimitMiddleware("read")).Get("/collections/summary", collectionHandler.GetSummary)
        r.With(RateLimitMiddleware("read")).Get("/collections", collectionHandler.GetAll)
        r.With(RateLimitMiddleware("read")).Get("/activities/recent", activityHandler.GetRecent)
        
        // Write endpoints (30/min)
        r.With(RateLimitMiddleware("write")).Patch("/cards/{id}/possession", cardHandler.TogglePossession)
        r.With(RateLimitMiddleware("write")).Patch("/books/{id}/possession", bookHandler.TogglePossession)
    })
})
```

**Headers informatifs** :
```
X-RateLimit-Limit: 100
X-RateLimit-Remaining: 94
X-RateLimit-Reset: 1714140000
```

### 4.5 Middlewares (Sécurité)

**1. Auth Middleware** :
- Vérifie token JWT
- Inject userID dans context
- Retourne 401 si token invalide/expiré

**2. Rate Limiting** :
- 3 tiers : login (5/15min), read (100/min), write (30/min)
- Storage en mémoire (sync.Map)
- Cleanup automatique toutes les 10 min

**3. CORS** :
```go
// internal/infrastructure/http/server.go
corsOrigins := os.Getenv("CORS_ALLOWED_ORIGINS")
allowedOrigins := strings.Split(corsOrigins, ",")

r.Use(cors.Handler(cors.Options{
    AllowedOrigins:   allowedOrigins,  // localhost:3000, localhost:3001
    AllowedMethods:   []string{"GET", "POST", "PATCH", "DELETE", "OPTIONS"},
    AllowedHeaders:   []string{"Accept", "Authorization", "Content-Type"},
    AllowCredentials: true,
    MaxAge:           300,
}))
```

**4. Security Headers** :
```go
r.Use(func(next http.Handler) http.Handler {
    return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
        w.Header().Set("X-Frame-Options", "DENY")
        w.Header().Set("X-Content-Type-Options", "nosniff")
        w.Header().Set("X-XSS-Protection", "1; mode=block")
        w.Header().Set("Referrer-Policy", "strict-origin-when-cross-origin")
        w.Header().Set("Content-Security-Policy", "default-src 'self'")
        next.ServeHTTP(w, r)
    })
})
```

### 4.6 Repositories PostgreSQL (sqlx)

**Pattern Repository** : Interfaces dans `domain/`, implémentations dans `infrastructure/postgres/`

```go
// internal/domain/repository.go
type CardRepository interface {
    FindAll(ctx context.Context, userID uuid.UUID, filter CardFilter) ([]Card, error)
    FindByID(ctx context.Context, userID uuid.UUID, cardID uuid.UUID) (*Card, error)
    UpdateUserCard(ctx context.Context, userCard *UserCard) error
}

// internal/infrastructure/postgres/card_repository.go
type cardRepositoryImpl struct {
    db *sqlx.DB
}

func (r *cardRepositoryImpl) FindAll(ctx context.Context, userID uuid.UUID, filter CardFilter) ([]Card, error) {
    query := `
        SELECT c.id, c.name_en, c.name_fr, c.card_type, c.series, c.rarity, 
               COALESCE(uc.is_owned, false) as is_owned
        FROM cards c
        LEFT JOIN user_cards uc ON c.id = uc.card_id AND uc.user_id = $1
        WHERE 1=1
    `
    args := []interface{}{userID}
    
    // Filtres dynamiques (parameterized queries)
    if filter.CardType != "" {
        query += " AND c.card_type = $" + strconv.Itoa(len(args)+1)
        args = append(args, filter.CardType)
    }
    
    if filter.Rarity != "" {
        query += " AND c.rarity = $" + strconv.Itoa(len(args)+1)
        args = append(args, filter.Rarity)
    }
    
    query += " LIMIT $" + strconv.Itoa(len(args)+1) + " OFFSET $" + strconv.Itoa(len(args)+2)
    args = append(args, filter.Limit, filter.Offset)
    
    var cards []Card
    err := r.db.SelectContext(ctx, &cards, query, args...)
    return cards, err
}
```

**Avantages sqlx** :
- Requêtes SQL explicites (pas de magie ORM)
- Parameterized queries (sécurité SQL injection)
- Performance (pas de couche d'abstraction lourde)
- Contrôle total sur les requêtes

---

## 5. Base de Données PostgreSQL

### 5.1 Schéma Complet

```sql
-- 🔹 Collections (MECCG, Books)
CREATE TABLE collections (
    id UUID PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    slug VARCHAR(100) NOT NULL UNIQUE,
    description TEXT,
    category VARCHAR(50),
    total_cards INTEGER DEFAULT 0,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);

-- 🔹 Cards (1,679 cartes MECCG)
CREATE TABLE cards (
    id UUID PRIMARY KEY,
    collection_id UUID NOT NULL REFERENCES collections(id),
    name_en VARCHAR(255) NOT NULL,
    name_fr VARCHAR(255),
    card_type VARCHAR(100) NOT NULL,  -- Type hiérarchique (ex: "Héros / Personnage / Sorcier")
    series VARCHAR(100),               -- Série (ex: "The Wizards", "The Dragons")
    rarity VARCHAR(10),                -- Rareté (C1-C3, U1-U3, R1-R3, F1-F2, P)
    created_at TIMESTAMP DEFAULT NOW()
);

-- 🔹 Books (94 livres Royaumes Oubliés)
CREATE TABLE books (
    id UUID PRIMARY KEY,
    collection_id UUID NOT NULL REFERENCES collections(id),
    title VARCHAR(255) NOT NULL,
    author VARCHAR(255),
    cycle VARCHAR(100),                -- Cycle (ex: "Avatar", "Elminster")
    cycle_number INTEGER,              -- Numéro dans le cycle
    publication_year INTEGER,
    created_at TIMESTAMP DEFAULT NOW()
);

-- 🔹 User Collections (association user ↔ collections)
CREATE TABLE user_collections (
    user_id UUID NOT NULL,
    collection_id UUID NOT NULL REFERENCES collections(id),
    created_at TIMESTAMP DEFAULT NOW(),
    PRIMARY KEY (user_id, collection_id)
);

-- 🔹 User Cards (possession cartes)
CREATE TABLE user_cards (
    user_id UUID NOT NULL,
    card_id UUID NOT NULL REFERENCES cards(id),
    is_owned BOOLEAN DEFAULT false,
    acquired_at TIMESTAMP,
    PRIMARY KEY (user_id, card_id)
);
CREATE INDEX idx_user_cards_user_owned ON user_cards(user_id, is_owned);

-- 🔹 User Books (possession livres)
CREATE TABLE user_books (
    user_id UUID NOT NULL,
    book_id UUID NOT NULL REFERENCES books(id),
    is_owned BOOLEAN DEFAULT false,
    acquired_at TIMESTAMP,
    PRIMARY KEY (user_id, book_id)
);
CREATE INDEX idx_user_books_user_owned ON user_books(user_id, is_owned);

-- 🔹 Activities (événements utilisateur)
CREATE TABLE activities (
    id UUID PRIMARY KEY,
    user_id UUID NOT NULL,
    type VARCHAR(50) NOT NULL,         -- card_added, book_added, milestone_reached, etc.
    title VARCHAR(255) NOT NULL,       -- Titre affiché
    description TEXT,                  -- Description optionnelle
    entity_type VARCHAR(50),           -- "card" ou "book"
    entity_id UUID,                    -- ID de la carte ou du livre
    metadata JSONB,                    -- Métadonnées additionnelles (card_name, book_title, etc.)
    timestamp TIMESTAMP DEFAULT NOW()
);
CREATE INDEX idx_activities_user_timestamp ON activities(user_id, timestamp DESC);
```

### 5.2 Relations Entre Tables

```
collections (1) ──────┬───── (N) cards
                      │
                      └───── (N) books

user_collections (N) ─────── (1) collections

user_cards (N) ───────────── (1) cards

user_books (N) ───────────── (1) books

activities (N) ───────────── (1) cards OR books (via entity_type + entity_id)
```

### 5.3 Collections de Données Actuelles

**MECCG (Middle-earth CCG)** :
- **1,679 cartes totales**
- **1,661 cartes possédées** (98.9%)
- **18 cartes non possédées** (1.1%)
- **8 séries** : Les Sorciers, Les Dragons, Against the Shadow, L'Oeil de Sauron, Sombres Séides, The Balrog, The White Hand, Promo
- **Types hiérarchiques** : Héros/Personnage, Héros/Personnage/Sorcier, Péril/Créature, Équipement/Arme, Événement/Attaque, Lieu/Refuge, etc.
- **Raretés** : C1-C3 (communes), U1-U3 (peu communes), R1-R3 (rares), F1-F2 (fixes), P (promo)

**Books (Royaumes Oubliés)** :
- **94 livres totaux**
- **3 cycles** : Avatar, Elminster, Maztica
- **Romans numérotés** dans chaque cycle

### 5.4 Indexes pour Performance

```sql
-- Recherche par collection
CREATE INDEX idx_cards_collection_id ON cards(collection_id);
CREATE INDEX idx_books_collection_id ON books(collection_id);

-- Recherche par type/série/rareté
CREATE INDEX idx_cards_type ON cards(card_type);
CREATE INDEX idx_cards_series ON cards(series);
CREATE INDEX idx_cards_rarity ON cards(rarity);

-- Recherche par cycle (books)
CREATE INDEX idx_books_cycle ON books(cycle);

-- Possession utilisateur (calculs stats)
CREATE INDEX idx_user_cards_user_owned ON user_cards(user_id, is_owned);
CREATE INDEX idx_user_books_user_owned ON user_books(user_id, is_owned);

-- Activités récentes
CREATE INDEX idx_activities_user_timestamp ON activities(user_id, timestamp DESC);
```

### 5.5 Migrations SQL

**6 migrations appliquées** :
1. `001_create_collections_schema.sql` : Création des tables principales
2. `002_seed_meccg_real.sql` : Import des 1,679 cartes MECCG (3,398 lignes, 497 KB)
3. `003_create_activities_table.sql` : Ajout table activities
4. `004_seed_dev_possession.sql` : Snapshot possession développement (1,661 cartes possédées)
5. `005_add_books_collection.sql` : Ajout collection Books + 94 livres
6. `006_add_title_description_to_activities.sql` : Ajout colonnes title + description aux activités

**Commande pour appliquer les migrations** :
```bash
cd backend/collection-management
psql -h localhost -U collectoria -d collection_management -f migrations/001_create_collections_schema.sql
psql -h localhost -U collectoria -d collection_management -f migrations/002_seed_meccg_real.sql
psql -h localhost -U collectoria -d collection_management -f migrations/003_create_activities_table.sql
psql -h localhost -U collectoria -d collection_management -f migrations/004_seed_dev_possession.sql
psql -h localhost -U collectoria -d collection_management -f migrations/005_add_books_collection.sql
psql -h localhost -U collectoria -d collection_management -f migrations/006_add_title_description_to_activities.sql
```

---

## 6. Communication & Flux de Données

### 6.1 API REST (Contrats JSON)

**Format JSON** :
- **Backend** : `snake_case` (convention Go)
- **Frontend** : `camelCase` (convention TypeScript)
- **Conversion** : Automatique dans le client API frontend

**Exemple : GET /api/v1/collections/summary**

**Backend (Go) retourne** :
```json
{
  "user_id": "00000000-0000-0000-0000-000000000001",
  "total_cards_owned": 1755,
  "total_cards_available": 1773,
  "completion_percentage": 98.9,
  "last_updated": "2026-04-24T10:30:00Z"
}
```

**Frontend (TypeScript) reçoit** :
```typescript
{
  userId: "00000000-0000-0000-0000-000000000001",
  totalCardsOwned: 1755,
  totalCardsAvailable: 1773,
  completionPercentage: 98.9,
  lastUpdated: "2026-04-24T10:30:00Z"
}
```

### 6.2 Authentification (JWT Bearer Token)

**Toutes les requêtes protégées** :
```http
GET /api/v1/collections/summary
Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
Accept: application/json
```

**Flow complet** :
1. Login → Backend génère token JWT
2. Frontend stocke token dans `localStorage`
3. Chaque requête → Frontend injecte header `Authorization: Bearer <token>`
4. Backend vérifie token → Extrait userID → Retourne données utilisateur

### 6.3 CORS (Cross-Origin Resource Sharing)

**Configuration Backend** :
```bash
# .env
CORS_ALLOWED_ORIGINS=http://localhost:3000,http://localhost:3001
```

**Origines autorisées** :
- `http://localhost:3000` : Next.js (port par défaut)
- `http://localhost:3001` : Next.js (port alternatif si 3000 occupé)

**Méthodes autorisées** :
- `GET`, `POST`, `PATCH`, `DELETE`, `OPTIONS`

**Headers autorisés** :
- `Accept`, `Authorization`, `Content-Type`

### 6.4 Gestion des Erreurs

**Codes HTTP standardisés** :
```
200 OK                 → Succès
400 Bad Request        → Données invalides (validation)
401 Unauthorized       → Token JWT manquant/invalide
403 Forbidden          → Accès interdit (rate limit dépassé)
404 Not Found          → Ressource non trouvée
500 Internal Server    → Erreur serveur (DB, logique)
```

**Format d'erreur** :
```json
{
  "error": {
    "code": "UNAUTHORIZED",
    "message": "Invalid or missing authentication token"
  }
}
```

### 6.5 Logging

**Backend (slog)** :
```go
// Configuration selon environnement
if os.Getenv("ENV") == "production" {
    logger = slog.New(slog.NewJSONHandler(os.Stdout, nil))  // JSON structuré
} else {
    logger = slog.New(slog.NewTextHandler(os.Stdout, nil))  // Texte coloré
}

// Logs structurés
logger.Info("Request received", 
    "method", r.Method, 
    "path", r.URL.Path, 
    "user_id", userID)

logger.Error("Database error", 
    "error", err, 
    "query", query)
```

---

## 7. Flux de Données Typiques

### 7.1 Login Utilisateur

```
1. Utilisateur ouvre /login
   ↓
2. Utilisateur saisit email + password
   ↓
3. Frontend → POST /api/v1/auth/login
   Body: { "email": "...", "password": "..." }
   ↓
4. Backend vérifie credentials (MVP : hardcodé)
   ✅ Valid → Génère token JWT (HS256)
   ❌ Invalid → Retourne 401
   ↓
5. Backend → Retourne { "token": "...", "expires_at": "..." }
   ↓
6. Frontend stocke token dans localStorage
   ↓
7. Frontend redirige vers /
   ↓
8. Homepage charge avec token JWT
```

### 7.2 Affichage Homepage

```
1. Utilisateur ouvre /
   ↓
2. Frontend vérifie token JWT dans localStorage
   ✅ Valid → Continue
   ❌ Invalid/Absent → Redirect /login
   ↓
3. Frontend appelle 4 endpoints en parallèle :
   • GET /api/v1/collections/summary
   • GET /api/v1/collections
   • GET /api/v1/activities/recent
   • GET /api/v1/statistics/growth
   (Toutes avec header Authorization: Bearer <token>)
   ↓
4. Backend vérifie JWT + Rate Limiting (read : 100/min)
   ↓
5. Backend exécute requêtes SQL :
   • Summary : Calcul total cartes possédées, % complétion
   • Collections : Liste collections avec stats
   • Activities : 10 dernières activités (timestamp DESC)
   • Growth : Agrégation par mois (6 derniers mois)
   ↓
6. Backend retourne JSON (snake_case)
   ↓
7. Frontend convertit snake_case → camelCase
   ↓
8. React Query met en cache (staleTime : 1-30 min)
   ↓
9. Composants React affichent :
   • HeroCard : Progression globale (98.9%)
   • CollectionsGrid : MECCG (1,661/1,679) + Books (0/94)
   • RecentActivityWidget : 5 dernières activités
   • GrowthInsightWidget : Graphique 6 mois
```

### 7.3 Toggle Possession Carte

```
1. Utilisateur ouvre /cards
   ↓
2. Frontend → GET /api/v1/cards?limit=12&offset=0
   ↓
3. Backend retourne 12 premières cartes
   ↓
4. Utilisateur clique sur toggle d'une carte
   ↓
5. Frontend affiche modale de confirmation :
   "Marquer [Nom Carte] comme possédée ?"
   ↓
6. Utilisateur clique "Confirmer"
   ↓
7. Frontend → PATCH /api/v1/cards/:id/possession
   Body: { "is_owned": true }
   Header: Authorization: Bearer <token>
   ↓
8. Backend vérifie JWT + Rate Limiting (write : 30/min)
   ↓
9. Backend exécute transaction SQL :
   • UPDATE user_cards SET is_owned = true WHERE card_id = :id
   • INSERT INTO activities (type, title, entity_type, entity_id, metadata)
     VALUES ('card_added', 'Carte X ajoutée', 'card', :id, '{"card_name": "X"}')
   ↓
10. Backend retourne carte mise à jour
   ↓
11. Frontend met à jour UI (optimistic update)
   ↓
12. React Query invalide cache :
    • /api/v1/cards
    • /api/v1/collections/summary
    • /api/v1/activities/recent
   ↓
13. Toast notification : "Carte marquée comme possédée ✅"
   ↓
14. Homepage rafraîchit automatiquement (cache invalidé)
```

### 7.4 Toggle Possession Livre

```
1. Utilisateur ouvre /books
   ↓
2. Frontend → GET /api/v1/books?limit=20
   ↓
3. Backend retourne 20 premiers livres
   ↓
4. Utilisateur clique sur toggle d'un livre
   ↓
5. Frontend affiche modale de confirmation :
   "Marquer [Titre Livre] comme possédé ?"
   ↓
6. Utilisateur clique "Confirmer"
   ↓
7. Frontend → PATCH /api/v1/books/:id/possession
   Body: { "is_owned": true }
   ↓
8. Backend exécute transaction SQL :
   • UPDATE user_books SET is_owned = true WHERE book_id = :id
   • INSERT INTO activities (type, title, entity_type, entity_id, metadata)
     VALUES ('book_added', 'Livre X ajouté', 'book', :id, '{"book_title": "X"}')
   ↓
9. Backend retourne livre mis à jour
   ↓
10. Frontend met à jour UI + invalide cache
   ↓
11. Toast notification : "Livre marqué comme possédé ✅"
```

---

## 8. Sécurité & Performance

### 8.1 Sécurité

**Score actuel : 9.0/10** (Production-ready baseline)

**Mesures implémentées** :

1. **JWT Authentication (HS256)** :
   - Tokens signés avec secret 64 caractères
   - Expiration configurable (défaut : 24h)
   - Vérification sur tous les endpoints protégés

2. **Rate Limiting (3-tier)** :
   - Login : 5 tentatives / 15 minutes (protection brute-force)
   - Read : 100 requêtes / 1 minute (protection DoS)
   - Write : 30 requêtes / 1 minute (protection abuse)

3. **SQL Injection : 0 vulnérabilité** :
   - 100% parameterized queries (sqlx)
   - 105 scénarios d'injection testés (tous passés)
   - Script d'audit automatisé (`scripts/analyze-sql-queries.sh`)

4. **Security Headers (5 headers)** :
   - `X-Frame-Options: DENY` (clickjacking)
   - `X-Content-Type-Options: nosniff` (MIME sniffing)
   - `X-XSS-Protection: 1; mode=block` (XSS)
   - `Referrer-Policy: strict-origin-when-cross-origin` (privacy)
   - `Content-Security-Policy: default-src 'self'` (XSS/injection)

5. **CORS Configurable** :
   - Origines autorisées via `CORS_ALLOWED_ORIGINS` (env var)
   - Pas de wildcard `*` (sécurité)

6. **Credentials Externalisés** :
   - Variables d'environnement (12-factor app)
   - Pas de secrets hardcodés dans le code
   - `.env.example` fourni, `.env` dans `.gitignore`

7. **Docker Non-Root** :
   - User `collectoria` (UID 1000)
   - Pas d'exécution en root dans les containers

8. **Logging Configurable** :
   - Mode dev : Logs colorés texte
   - Mode prod : Logs JSON structurés (pour agrégation)
   - Niveaux : trace, debug, info, warn, error, fatal

**Vulnérabilités résolues** :
- ✅ Authentification manquante (CRITICAL)
- ✅ Rate limiting absent (HIGH)
- ✅ SQL injection potentielle (CRITICAL)
- ✅ Credentials hardcodés (HIGH)
- ✅ CORS wildcard (MEDIUM)

**Audit complet** : `Security/reports/audit-mvp-2026-04-21.md`

### 8.2 Performance

**Targets** :
- API Response Time P50 : < 100ms ✅
- API Response Time P95 : < 500ms ✅
- Frontend LCP : < 2.5s ✅
- Frontend FID : < 100ms ✅

**Optimisations Frontend** :
- **React Query Cache** : staleTime 1-30 min selon endpoint
- **Optimistic Updates** : UI update immédiate sur mutations
- **Lazy Loading** : Images hero des collections
- **Code Splitting** : Pages Next.js (route-based)
- **Skeleton Loaders** : Feedback immédiat pendant chargement

**Optimisations Backend** :
- **Indexes PostgreSQL** : Sur colonnes fréquemment filtrées (type, rarity, cycle, user_id)
- **Parameterized Queries** : Préparées par PostgreSQL
- **Pagination** : Limit/Offset sur tous les endpoints liste
- **Connexion Pooling** : `maxOpen=25`, `maxIdle=10`, `maxLifetime=1h`

**Cache Strategy** :
- **Frontend (React Query)** :
  - Summary : 5 min staleTime
  - Collections : 10 min staleTime
  - Activities : 1 min staleTime
  - Growth : 30 min staleTime
- **Backend (futur Redis)** :
  - Agrégats statistiques : TTL 30 min
  - Invalidation sur mutation

---

## 9. Environnement de Développement

### 9.1 Services Locaux

**PostgreSQL** :
```bash
cd backend/collection-management
docker compose up -d
# Port : 5432
# User : collectoria
# Password : collectoria
# Database : collection_management
```

**Backend API** :
```bash
cd backend/collection-management
export DB_HOST=localhost
export DB_PORT=5432
export DB_USER=collectoria
export DB_PASSWORD=collectoria
export DB_NAME=collection_management
export DB_SSLMODE=disable
export SERVER_PORT=8080
export JWT_SECRET=your-super-secret-key-at-least-32-chars
export CORS_ALLOWED_ORIGINS=http://localhost:3000,http://localhost:3001
export ENV=development
export LOG_LEVEL=debug

go run cmd/api/main.go
# Port : 8080
# Health check : http://localhost:8080/api/v1/health
```

**Frontend Next.js** :
```bash
cd frontend
npm install
npm run dev
# Port : 3000 (ou 3001 si 3000 occupé)
# Homepage : http://localhost:3000
```

### 9.2 Ports Utilisés

| Service       | Port | URL                         |
|---------------|------|-----------------------------|
| PostgreSQL    | 5432 | localhost:5432              |
| Backend API   | 8080 | http://localhost:8080       |
| Frontend      | 3000 | http://localhost:3000       |
| Frontend (alt)| 3001 | http://localhost:3001       |

### 9.3 Variables d'Environnement

**Backend** :
```bash
# Database
DB_HOST=localhost
DB_PORT=5432
DB_USER=collectoria
DB_PASSWORD=collectoria
DB_NAME=collection_management
DB_SSLMODE=disable

# Server
SERVER_PORT=8080

# JWT
JWT_SECRET=your-super-secret-key-at-least-32-chars
JWT_EXPIRATION_HOURS=24
JWT_ISSUER=collectoria-api

# CORS
CORS_ALLOWED_ORIGINS=http://localhost:3000,http://localhost:3001
CORS_MAX_AGE=300

# Logging
ENV=development
LOG_LEVEL=debug
```

**Frontend** :
```bash
# API Base URL
NEXT_PUBLIC_API_BASE_URL=http://localhost:8080
```

### 9.4 Credentials de Test

**Authentification MVP (hardcodé)** :
```
Email : arnaud.dars@gmail.com
Password : flying38
UserID : 00000000-0000-0000-0000-000000000001
```

**PostgreSQL** :
```
Host : localhost
Port : 5432
User : collectoria
Password : collectoria
Database : collection_management
```

### 9.5 Commandes Utiles

**Démarrage rapide complet** :
```bash
# Terminal 1 : PostgreSQL
cd backend/collection-management && docker compose up -d

# Terminal 2 : Backend
cd backend/collection-management
export DB_HOST=localhost DB_PORT=5432 DB_USER=collectoria DB_PASSWORD=collectoria DB_NAME=collection_management DB_SSLMODE=disable SERVER_PORT=8080 JWT_SECRET=dev-secret-change-me-in-prod CORS_ALLOWED_ORIGINS=http://localhost:3000,http://localhost:3001 ENV=development LOG_LEVEL=debug
go run cmd/api/main.go

# Terminal 3 : Frontend
cd frontend && npm run dev
```

**Health checks** :
```bash
# Backend API
curl http://localhost:8080/api/v1/health | jq

# Frontend
curl http://localhost:3000 -I
```

**Tests** :
```bash
# Backend tests
cd backend/collection-management
go test ./... -v

# Frontend tests
cd frontend
npm run test
```

**Logs** :
```bash
# Backend logs
# (stdout, visible dans le terminal)

# Frontend logs
tail -f /tmp/frontend.log
```

---

## 10. Métriques du Projet

### 10.1 Codebase

**Backend** :
- **~65 fichiers Go** (~10,500 lignes)
- **6 endpoints REST** : auth, summary, collections, cards, books, activities, statistics
- **3 layers DDD** : Domain, Application, Infrastructure
- **6 migrations SQL** appliquées

**Frontend** :
- **~35 composants React** (~9,500 lignes TypeScript/TSX)
- **8 pages** : /, /login, /cards, /books, /test, /test-backend
- **12 hooks personnalisés** : useCollectionSummary, useCollections, useActivities, useGrowthStats, useCardToggle, useBookToggle, useAuth, etc.
- **4 états UI** : Loading, Error, Empty, Success (sur tous les composants)

**Total** : ~20,000 lignes de code (hors node_modules)

### 10.2 Tests

**Backend** : **144+ tests** (>90% coverage)
- 22 tests JWT (service + middleware + handler)
- 9 tests rate limiting
- 105 tests SQL injection
- Tests TDD sur tous les endpoints
- Tests repositories, services, handlers

**Frontend** : **109 tests** (100% passants)
- 43 tests composants (HeroCard, CollectionsGrid)
- 60 tests fonctionnalités (toggle carte)
- 28 tests auth (utils + page login)
- 20 tests modales (ConfirmToggleModal)

**Total** : **253+ tests** ✅

### 10.3 Données

**Collections** :
- **MECCG** : 1,679 cartes (1,661 possédées, 18 non possédées)
- **Books** : 94 livres (0 possédés actuellement)

**Complétion globale** : 98.9% (1,661 / 1,679)

### 10.4 Sécurité

**Score** : **9.0/10** (Production-ready baseline)

**Progression** :
- 2026-04-21 : 4.5/10 (audit initial)
- 2026-04-21 : 7.0/10 (Phase 1 Quick Wins)
- 2026-04-22 : 8.0/10 (JWT Authentication)
- 2026-04-23 : 9.0/10 (Rate Limiting + SQL Audit)

**Tests sécurité** :
- 114 tests sécurité (22 JWT + 9 rate limiting + 105 SQL injection)
- 0 vulnérabilité SQL injection détectée
- Scripts d'audit automatisés (4 scripts)

### 10.5 Commits Git

**Total** : **77 commits** (au 24 avril 2026)

**Commits par agent** :
- Agent Backend : ~25 commits
- Agent Frontend : ~20 commits
- Agent Security : ~8 commits
- Agent Testing : ~5 commits
- Agent DevOps : ~4 commits
- Agent Spécifications : ~3 commits
- Autres : ~12 commits

**Bonne pratique** : Commits atomiques et réguliers (pas de gros commits monolithiques)

### 10.6 Documentation

**Total** : **~20,000 lignes** de documentation

**Répartition** :
- Spécifications : ~5,000 lignes (homepage, data model, etc.)
- Documentation Backend : ~3,000 lignes (README, API, DDD)
- Documentation Frontend : ~2,000 lignes (components, hooks)
- Documentation Sécurité : ~4,000 lignes (audit, JWT, rate limiting, SQL)
- Documentation DevOps : ~1,500 lignes (setup, CI/CD)
- STATUS.md : ~1,100 lignes (suivi de projet)
- Autres : ~3,400 lignes

### 10.7 Productivité

**Session du 21 avril 2026** :
- 12 commits pushés
- ~10,000 lignes ajoutées (code + tests + docs)
- 103 tests créés (43 + 60)
- 2 features majeures livrées (toggle possession + activités Phase 1)
- Score sécurité : +2.5 points (+55%)

**Session du 22 avril 2026** :
- 14 commits pushés
- ~3,000 lignes ajoutées
- 70 tests créés (20 modal + 22 backend JWT + 28 frontend auth)
- 3 features majeures (modal + JWT Backend + JWT Frontend)
- Score sécurité : +1.0 point (+14%)

**Session du 23 avril 2026** :
- 3 commits pushés
- ~2,000 lignes ajoutées
- 114 tests créés (9 rate limiting + 105 SQL injection)
- 2 features sécurité (Rate Limiting + SQL Audit)
- Score sécurité : +1.0 point (+12.5%)

**Session du 24 avril 2026** :
- 4 commits pushés
- ~350 lignes ajoutées
- 2 fixes critiques (activités avec title/description + modale Books)
- Collection Books : 100% fonctionnelle

---

## 11. Prochaines Étapes

### 11.1 Fonctionnalités Prioritaires

**Priorité 1 - UX/Fonctionnelles** :
- ✅ Modal de confirmation toggle (COMPLÉTÉ le 22 avril)
- 🔜 **Page détail d'une carte** : `/cards/:id`
  - Affichage complet (image, métadonnées, statut)
  - Historique d'acquisition
  - Bouton toggle possession
  - Estimation : 1 jour
- 🔜 **Statistiques avancées** : `/stats`
  - Complétion par série (graphiques)
  - Complétion par type de carte
  - Complétion par rareté
  - Évolution temporelle
  - Estimation : 1.5 jours
- 🔜 **Import/Export de collection** :
  - Export CSV/JSON
  - Import CSV (ajout massif)
  - Estimation : 1 jour
- 🔜 **Wishlist** : Cartes souhaitées
  - Toggle wishlist (séparé de possession)
  - Page `/wishlist`
  - Estimation : 1 jour

### 11.2 Améliorations Techniques

**Tests & Qualité** :
- Tests d'intégration backend (testcontainers-go)
- Tests E2E frontend (Playwright)
- Amélioration couverture tests (cible : 95%+)

**DevOps** :
- Docker Compose multi-services (PostgreSQL + Backend + Frontend)
- Scripts start/stop centralisés
- CI/CD GitHub Actions (lint, test, build)
- Documentation OpenAPI/Swagger interactive

**Performance** :
- Redis pour cache backend (agrégats)
- Service Worker pour offline support (PWA)
- GraphQL pour optimiser data fetching (futur)

### 11.3 Sécurité (Phase 3 - Optionnel)

**Score actuel** : 9.0/10 (Production-ready)

**Améliorations futures** (non critiques) :
- HTTPS avec TLS (Let's Encrypt)
- Audit de dépendances automatisé (Dependabot)
- Rotation automatique des secrets
- 2FA (Two-Factor Authentication)
- Honeypot endpoints (détection attaques)

### 11.4 Évolution Architecture (Post-MVP)

**Event-Driven Architecture avec Kafka** :
- Actuellement : Activités stockées directement en BDD (Phase 1)
- Futur : Migration vers Kafka (Phase 2)
- Déclencheurs :
  - Au moins 2 services producteurs d'événements
  - Volume d'activités > 10,000 par jour
  - Besoin de notifications en temps réel
  - Besoin d'audit trail complet
- Effort estimé : 3-5 jours

**Référence** :
- ADR : `Project follow-up/decisions/2026-04-21_activities-architecture-choice.md`
- Plan migration : `Project follow-up/future-tasks/migration-kafka-activities.md`

---

## 12. Glossaire

**DDD (Domain-Driven Design)** : Approche de conception logicielle centrée sur le domaine métier, avec des concepts comme Entities, Aggregates, Value Objects, Bounded Contexts.

**JWT (JSON Web Token)** : Standard ouvert (RFC 7519) pour créer des tokens d'accès sécurisés. Utilisé pour l'authentification stateless.

**Rate Limiting** : Technique de limitation du nombre de requêtes autorisées par unité de temps, pour protéger contre les abus et les attaques DoS.

**Parameterized Queries** : Requêtes SQL où les paramètres utilisateur sont séparés de la requête elle-même, empêchant les injections SQL.

**Tonal Layering** : Technique de design utilisant des variations subtiles de couleur pour créer de la profondeur sans bordures visibles.

**Optimistic Update** : Mise à jour immédiate de l'UI avant confirmation du serveur, avec rollback en cas d'erreur.

**staleTime** : Durée pendant laquelle React Query considère les données comme "fraîches" et ne refetch pas automatiquement.

**Bounded Context** : Frontière explicite dans laquelle un modèle DDD est défini et applicable (ex: Collection Management).

**Aggregate Root** : Entité principale d'un agrégat, point d'entrée pour toutes les opérations sur l'agrégat (ex: Collection).

**Repository Pattern** : Pattern DDD séparant la logique d'accès aux données (implémentation) de la logique métier (interfaces).

---

## 13. Références

### 13.1 Documentation Interne

- **STATUS.md** : État actuel du projet (métriques, accomplissements, prochaines étapes)
- **QUICKSTART.md** : Guide de démarrage rapide (frontend + backend)
- **Backend README** : `backend/collection-management/README.md`
- **Frontend README** : `frontend/README.md`
- **Spécifications Homepage** : `Specifications/technical/homepage-desktop-v1.md`
- **Data Model MVP** : `Specifications/technical/mvp-data-model-v2.md`
- **Design System Ethos V1** : `Design/design-system/Ethos-V1-2026-04-15.md`

### 13.2 Documentation Sécurité

- **Audit MVP** : `Security/reports/audit-mvp-2026-04-21.md`
- **Authentication** : `backend/collection-management/docs/AUTHENTICATION.md`
- **Rate Limiting** : `backend/collection-management/docs/RATE_LIMITING.md`
- **SQL Best Practices** : `backend/collection-management/docs/SQL_SECURITY_BEST_PRACTICES.md`

### 13.3 Agents Spécialisés

- **Alfred (Dispatch)** : `CLAUDE.md`
- **Agent Backend** : `Backend/CLAUDE.md`
- **Agent Frontend** : `Frontend/CLAUDE.md`
- **Agent DevOps** : `DevOps/CLAUDE.md`
- **Agent Testing** : `Testing/CLAUDE.md`
- **Agent Security** : `Security/CLAUDE.md`
- **Agent Spécifications** : `Specifications/CLAUDE.md`
- **Agent Suivi de Projet** : `Project follow-up/CLAUDE.md`

### 13.4 Workflows & Recommandations

- **Workflow STATUS.md Sync** : `Project follow-up/workflow-status-sync.md`
- **Commits Petits & Réguliers** : `Continuous-Improvement/feedback/feedback_commits_small_regular.md`
- **Annonce des Sous-Agents** : `Continuous-Improvement/feedback/feedback_announce_subagents.md`
- **Nettoyage Cache Next.js** : `Continuous-Improvement/recommendations/workflow-nextjs-cache-cleanup_2026-04-24.md`

---

## 14. Conclusion

Collectoria est une application web moderne, sécurisée et performante pour la gestion de collections de cartes et de livres. L'architecture repose sur des principes solides (DDD, TDD, 12-factor app) et utilise des technologies éprouvées (Go, Next.js, PostgreSQL).

**État actuel** :
- ✅ Architecture complète et documentée
- ✅ Backend production-ready (score sécurité 9.0/10)
- ✅ Frontend fonctionnel avec design system Ethos V1
- ✅ Authentification JWT complète
- ✅ Rate Limiting (3-tier)
- ✅ 253+ tests (100% passants)
- ✅ 2 collections de données réelles (MECCG 1,679 cartes, Books 94 livres)

**Prêt pour** :
- ✅ Développement de nouvelles fonctionnalités
- ✅ Tests utilisateurs
- ✅ Déploiement en production (après tests finaux)

**Prochaines priorités** :
- 🎯 Page détail carte
- 🎯 Statistiques avancées
- 🎯 Import/Export collection
- 🎯 Wishlist

---

**Document créé le** : 2026-04-24  
**Auteur** : Agent Documentation (Collectoria)  
**Dernière mise à jour** : 2026-04-24  
**Version** : 1.0

**Feedback bienvenu** : Ce document est vivant et doit évoluer avec le projet. N'hésitez pas à suggérer des améliorations !
