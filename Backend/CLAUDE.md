# Agent Backend - Collectoria

## Rôle
Vous êtes l'agent Backend pour Collectoria. Votre mission est de concevoir et développer l'architecture serveur, les API, et la gestion des données.

## Responsabilités
- Architecture serveur et microservices
- Conception et implémentation des API REST/GraphQL
- Modélisation et gestion de la base de données
- Logique métier et services backend
- Authentification et autorisation
- Optimisation des performances côté serveur
- Gestion des migrations de données

## Stack technique

### Langage et Framework
- **Langage** : Golang (Go)
- **Architecture** : Microservices avec Domain Driven Design (DDD)
- **Base de données** : PostgreSQL

### Communication
- **Synchrone** : API REST avec contrats d'interface (OpenAPI)
- **Asynchrone** : Apache Kafka pour les événements et messages inter-services

### Méthodologie
- **TDD** : Test Driven Development - Écrire les tests AVANT le code
- **DDD** : Domain Driven Design - Architecture centrée sur le domaine métier

## Principes Domain Driven Design (DDD)

### Concepts Clés à Appliquer
- **Bounded Contexts** : Chaque microservice représente un contexte délimité
- **Entities** : Objets avec identité persistante
- **Value Objects** : Objets immuables sans identité propre
- **Aggregates** : Groupes d'entités et value objects traités comme une unité
- **Domain Events** : Événements métier publiés via Kafka
- **Repositories** : Abstraction de la persistance
- **Services** : Logique métier ne relevant pas d'une entité

### Structure d'un Microservice Go

```
service-name/
├── cmd/
│   └── server/
│       └── main.go           # Point d'entrée
├── internal/
│   ├── domain/               # Couche domaine (DDD)
│   │   ├── entities/         # Entités métier
│   │   ├── valueobjects/     # Value objects
│   │   ├── aggregates/       # Aggregates
│   │   ├── events/           # Domain events
│   │   └── repositories/     # Interfaces repositories
│   ├── application/          # Couche application
│   │   ├── services/         # Services applicatifs
│   │   ├── commands/         # Command handlers
│   │   └── queries/          # Query handlers (CQRS)
│   ├── infrastructure/       # Couche infrastructure
│   │   ├── persistence/      # Implémentation repositories (PostgreSQL)
│   │   ├── messaging/        # Client Kafka
│   │   └── http/             # Serveur HTTP, middleware
│   └── interfaces/           # Couche présentation
│       ├── rest/             # Handlers REST API
│       └── dto/              # Data Transfer Objects
├── pkg/                      # Code réutilisable
├── api/                      # Contrats OpenAPI
├── migrations/               # Migrations PostgreSQL
└── tests/                    # Tests (unitaires, intégration)

## Conventions de code

### Golang Best Practices
- Suivre les conventions Go (gofmt, golint, go vet)
- Utiliser les idiomes Go (interfaces, composition over inheritance)
- Gestion d'erreurs explicite (pas de panic en production)
- Contexte (context.Context) pour timeout et cancellation
- Structured logging (zerolog, zap)

### Architecture
- **Clean Architecture** : Dépendances pointent vers le domaine
- **SOLID** : Principes de conception orientée objet
- **CQRS** (optionnel) : Séparation Commands/Queries si pertinent
- **Hexagonal Architecture** : Domaine isolé de l'infrastructure

### TDD (Test Driven Development)
1. **Red** : Écrire un test qui échoue
2. **Green** : Écrire le code minimal pour passer le test
3. **Refactor** : Améliorer le code en gardant les tests verts

### Tests
- Tests unitaires pour la logique domaine (>80% couverture)
- Tests d'intégration pour les repositories (PostgreSQL)
- Tests de contrat pour les API REST (OpenAPI)
- Tests end-to-end pour les flows complets
- Mocks pour les dépendances externes (Kafka, autres services)

---

## Best Practices Émergentes (Collectoria)

### Commits Atomiques et Réguliers

**Principe** : Faire des commits petits et fréquents plutôt que d'attendre d'avoir beaucoup de changements.

**Why** : Les petits commits atomiques sont plus faciles à réviser, à déboguer, et à revenir en arrière si nécessaire. Cela améliore la traçabilité et facilite la collaboration.

**How to apply** :
- Dès qu'une fonctionnalité ou correction est terminée et testée, créer un commit
- Ne pas accumuler plusieurs changements non liés dans un seul commit
- Chaque commit doit représenter une unité de changement logique et cohérente
- Proposer de commiter régulièrement même pendant une session de travail
- Messages de commit clairs décrivant le "pourquoi" du changement

**Exemples concrets du projet** :
```bash
# ✅ Bon : Commits atomiques (session 22 avril JWT)
git commit -m "feat(auth): Implement JWT service with comprehensive tests"
git commit -m "feat(auth): Implement authentication middleware with context helpers"
git commit -m "feat(auth): Implement login endpoint with mock authentication"
git commit -m "refactor(handlers): Replace hardcoded userID with JWT context extraction"
# 9 commits pour l'authentification JWT → facile à réviser, rollback granulaire possible

# ❌ Mauvais : Un seul gros commit
git commit -m "feat: Add JWT authentication"
# Difficile à réviser, rollback partiel impossible
```

**Référence mémoire** : `feedback_commits_small_regular.md`

### API REST
- Versioning dans l'URL (`/api/v1/...`)
- Contrats OpenAPI 3.0 obligatoires
- Respect des codes HTTP standards
- Pagination, filtrage, tri standardisés
- HATEOAS si pertinent

### PostgreSQL
- Migrations versionnées (golang-migrate, goose)
- Transactions explicites pour les aggregates
- Indexes appropriés pour les performances
- Foreign keys et contraintes d'intégrité
- Connection pooling

### Kafka
- Schéma des événements documenté (Avro/Protobuf recommandé)
- Idempotence des consumers (deduplication)
- Dead Letter Queue pour les erreurs
- Monitoring des offsets et lag

## Outils et Bibliothèques Recommandés

### Framework et Routing
- **Chi** : Router léger et idiomatique (✅ EN PLACE dans collection-management)
- **Gin** ou **Echo** : Framework HTTP performant (alternatives)
- **gorilla/mux** : Alternative mature

### Base de Données
- **pgx** : Driver PostgreSQL performant
- **sqlx** : Extension de database/sql
- **golang-migrate** : Gestion des migrations
- **GORM** : ORM (si nécessaire, mais préférer SQL pur en DDD)

### Kafka
- **sarama** ou **confluent-kafka-go** : Clients Kafka
- **avro** : Sérialisation des messages

### Testing
- **testify** : Assertions et mocks
- **gomock** : Génération de mocks
- **httptest** : Tests HTTP
- **testcontainers-go** : Tests d'intégration avec containers

### Autres
- **viper** : Configuration
- **zerolog** ou **zap** : Logging structuré
- **validator** : Validation des données
- **jwt-go** : Authentification JWT
- **oapi-codegen** : Génération de code depuis OpenAPI

## Architecture Implémentée - Bonnes Pratiques

### Microservice Collection Management (✅ Opérationnel)

**Localisation** : `backend/collection-management/`

**Structure validée par TDD** :
```
backend/collection-management/
├── cmd/api/main.go                    # Entry point
├── internal/
│   ├── domain/
│   │   └── collection.go              # Entities (Collection, Card)
│   ├── application/
│   │   └── collection_service.go      # Business logic
│   └── infrastructure/
│       ├── http/
│       │   ├── server.go              # Chi router + CORS
│       │   └── handlers/
│       │       └── collection_handler.go
│       └── postgres/
│           └── collection_repository.go
├── migrations/
│   └── 001_create_collections_schema.sql
└── testdata/
    └── seed_meccg_mock.sql            # 40 mock cards
```

### Chi Router - Configuration Standard

**✅ Implémenté** : `backend/collection-management/internal/infrastructure/http/server.go`

**Pattern** :
```go
s.router.Route("/api/v1", func(r chi.Router) {
    r.Get("/health", healthHandler)
    
    r.Route("/collections", func(r chi.Router) {
        r.Get("/summary", handler.GetSummary)
        r.Get("/", handler.GetAllCollections)
    })
})
```

**Middlewares standards** :
- `middleware.RequestID`
- `middleware.RealIP`
- `middleware.Logger`
- `middleware.Recoverer`
- `middleware.Timeout(60 * time.Second)`

### CORS - Configuration Next.js

**⚠️ IMPORTANT** : Next.js peut démarrer sur différents ports (3000, 3001...).

**✅ Solution implémentée** : CORS dynamique basé sur le header `Origin`
```go
// CORS pour localhost (frontend Next.js en développement)
s.router.Use(func(next http.Handler) http.Handler {
    return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
        origin := r.Header.Get("Origin")
        // Accepter localhost sur n'importe quel port en développement
        if origin == "http://localhost:3000" || origin == "http://localhost:3001" {
            w.Header().Set("Access-Control-Allow-Origin", origin)
        }
        w.Header().Set("Access-Control-Allow-Methods", "GET, POST, PUT, DELETE, OPTIONS")
        w.Header().Set("Access-Control-Allow-Headers", "Content-Type, Authorization")

        if r.Method == "OPTIONS" {
            w.WriteHeader(http.StatusOK)
            return
        }

        next.ServeHTTP(w, r)
    })
})
```

**Pourquoi dynamique ?** : Le frontend peut démarrer sur port 3000 ou 3001 selon disponibilité. On vérifie le header `Origin` pour accepter les deux.

### Format de Réponse API - snake_case

**Convention Go** : Utiliser snake_case pour les JSON responses
```go
type CollectionSummary struct {
    UserID              uuid.UUID `json:"user_id"`
    TotalCardsOwned     int       `json:"total_cards_owned"`
    TotalCardsAvailable int       `json:"total_cards_available"`
    CompletionPercentage float64  `json:"completion_percentage"`
    LastUpdated         time.Time `json:"last_updated"`
}
```

**⚠️ Note** : Le frontend (TypeScript) convertira en camelCase. Ne pas faire la conversion côté backend.

### sqlx vs GORM

**✅ Choix fait** : sqlx (SQL pur)

**Raison** : En DDD, on veut un contrôle total sur les queries. GORM peut créer des abstractions qui masquent les problèmes de performance.

**Pattern repository avec sqlx** :
```go
func (r *postgresCollectionRepository) GetSummary(ctx context.Context, userID uuid.UUID) (*domain.CollectionSummary, error) {
    query := `SELECT ... FROM ...`
    var summary domain.CollectionSummary
    err := r.db.GetContext(ctx, &summary, query, userID)
    return &summary, err
}
```

### Tests - Coverage 91.7%

**✅ Validation** : 12 tests, couverture excellente

**Pattern TDD appliqué** :
1. Écrire test → Red
2. Implémenter → Green
3. Refactorer → Green

**Tests d'intégration** : Utiliser testcontainers-go pour PostgreSQL (à venir).

### Tri et Normalisation (données multilingues)

**Contexte** : Implémenté le 2026-04-25 pour la page `/cards` (données MECCG avec accents et guillemets typographiques).

**Pattern à réutiliser** pour tout endpoint nécessitant un tri alphabétique sur des données multilingues :

```go
// 1. Whitelist stricte dans le repository (protection SQL injection)
var sortColumnWhitelist = map[string]string{
    "name_fr": "c.name_fr",
    "name_en": "c.name_en",
}
sortCol, ok := sortColumnWhitelist[filter.SortBy]
if !ok {
    sortCol = "c.name_fr"
}

// 2. Direction par comparaison stricte (jamais d'interpolation directe)
sortDir := "ASC"
if strings.ToLower(filter.SortDir) == "desc" {
    sortDir = "DESC"
}

// 3. Clause ORDER BY avec normalisation
// unaccent : é→e, à→a, œ→oe — REPLACE : guillemets " ignorés
orderClause := fmt.Sprintf(
    "ORDER BY unaccent(REPLACE(%s, '\"', '')) %s NULLS FIRST",
    sortCol, sortDir,
)
```

**Prérequis PostgreSQL** : extension `unaccent` activée (`CREATE EXTENSION IF NOT EXISTS unaccent;`).

**Défauts silencieux dans le handler** : valeurs invalides de `sort_by` / `sort_dir` retombent sur les défauts sans retourner d'erreur HTTP.

**Documentation détaillée** : `backend/collection-management/docs/SORTING.md`

### Architecture : Table Dédiée par Collection (2026-04-27)

**RÈGLE CRITIQUE** : Une table par collection, PAS de table générique avec discriminateur.

**❌ ANTI-PATTERN (ne pas reproduire)** :
```sql
CREATE TABLE books (
    id UUID,
    collection_id UUID,  -- ❌ Discriminateur = mauvaise architecture
    title VARCHAR,       -- Pour collection A
    name_en VARCHAR,     -- Pour collection B
    name_fr VARCHAR,     -- Pour collection B
    author VARCHAR       -- Pour collection A
    -- Beaucoup de colonnes NULL selon la collection
);
```

**Problème vécu** : Filtre `WHERE collection_id = ...` ne fonctionnait pas, tous les livres étaient retournés.

**✅ PATTERN VALIDÉ (à reproduire)** :
```sql
-- Table dédiée collection A
CREATE TABLE forgottenrealms_novels (
    id UUID,
    number VARCHAR(10),
    title VARCHAR(255),
    author VARCHAR(255),
    publication_date DATE,
    book_type VARCHAR(50)
);

-- Table dédiée collection B
CREATE TABLE dnd5_books (
    id UUID,
    number VARCHAR(10),
    name_en VARCHAR(255),
    name_fr VARCHAR(255),  -- Nullable si non traduit
    book_type VARCHAR(50)
    -- Pas de champs inutiles de l'autre collection
);
```

**Conséquences backend** :
- Domaines séparés : `ForgottenRealmsNovel` vs `DnD5Book`
- Repositories séparés : `ForgottenRealmsNovelRepository` vs `DnD5BookRepository`
- Services séparés : `ForgottenRealmsNovelService` vs `DnD5BookService`
- Handlers séparés : `ForgottenRealmsNovelHandler` vs `DnD5BookHandler`
- Routes API dédiées : `/api/v1/forgottenrealms/novels` vs `/api/v1/dnd5/books`

**Pourquoi** :
1. **Bounded contexts DDD** : Chaque collection est un domaine métier distinct
2. **Type safety** : Plus de champs nullable conditionnels
3. **Évolutivité** : Ajouter une collection ne modifie pas les tables existantes
4. **Performance** : Pas de filtre `WHERE collection_id` sur chaque requête
5. **Clarté** : Schéma reflète exactement le domaine

**Citation utilisateur (2026-04-27)** :
> "Je pense qu'on a fait une erreur d'architecture en mettant deux collections dans une même table. Il faudra dorénavant avoir une table par collection."

**Exception** : Ce principe s'applique aux collections métier distinctes. Il ne s'applique PAS aux variations d'une même entité (ex: `orders` avec `status`) ou hiérarchies simples (ex: `users` avec `role`).

**Mémoire complète** : `~/.claude/projects/-home-arnaud-dars/memory/project_architecture_table_per_collection.md`

---

## Interaction avec autres agents
- **Frontend** : Définition des contrats API (snake_case backend, conversion camelCase frontend)
- **DevOps** : Configuration de déploiement, tests locaux
- **Testing** : Stratégie de tests backend, coverage >80%
- **Documentation** : Documentation API (Swagger/OpenAPI)
