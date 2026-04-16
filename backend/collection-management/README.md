# Collection Management Microservice

Microservice de gestion des collections de cartes pour Collectoria.

## Architecture

### Domain Driven Design (DDD)

**Bounded Context**: Collection Management

**Responsabilité**: Gestion des collections, des cartes, et de la possession utilisateur.

**Aggregates & Entities**:
- **Collection** (Aggregate Root) - Représente une collection de cartes (ex: MECCG)
- **Card** (Entity) - Représente une carte dans le catalogue
- **UserCollection** (Entity) - Association utilisateur-collection
- **UserCard** (Entity) - Possession d'une carte par un utilisateur

### Structure du Projet

```
collection-management/
├── cmd/
│   └── api/
│       └── main.go                    # Point d'entrée
├── internal/
│   ├── domain/                        # Couche domaine (DDD)
│   │   ├── collection.go              # Aggregate Collection
│   │   ├── card.go                    # Entity Card
│   │   └── repository.go              # Interfaces Repository
│   ├── application/                   # Couche application (use cases)
│   │   ├── collection_service.go
│   │   └── collection_service_test.go
│   ├── infrastructure/                # Couche infrastructure
│   │   ├── postgres/
│   │   │   ├── connection.go
│   │   │   └── collection_repository.go
│   │   └── http/
│   │       ├── server.go
│   │       └── handlers/
│   │           └── collection_handler.go
│   └── config/
│       └── config.go
├── migrations/                        # Migrations PostgreSQL
│   └── 001_create_collections_schema.sql
├── testdata/                          # Données de test
│   └── seed_meccg_mock.sql            # 40 cartes MECCG mock
├── go.mod
├── go.sum
├── Dockerfile
└── README.md
```

## Prérequis

- Go 1.21+
- PostgreSQL 15+
- Docker & Docker Compose (optionnel)

## Configuration

Variables d'environnement:

```bash
# Serveur
SERVER_PORT=8080

# Base de données
DB_HOST=localhost
DB_PORT=5432
DB_USER=collectoria
DB_PASSWORD=collectoria
DB_NAME=collection_management
DB_SSLMODE=disable
```

## Installation

### 1. Avec Docker Compose (recommandé)

```bash
# Démarrer PostgreSQL
docker-compose up -d

# Attendre que PostgreSQL soit prêt
sleep 5

# Appliquer les migrations
psql -h localhost -U collectoria -d collection_management -f migrations/001_create_collections_schema.sql

# Charger les données de test (40 cartes MECCG mock)
psql -h localhost -U collectoria -d collection_management -f testdata/seed_meccg_mock.sql

# Installer les dépendances
go mod download

# Démarrer le service
go run cmd/api/main.go
```

### 2. Installation manuelle

```bash
# Créer la base de données
createdb -U postgres collection_management

# Appliquer les migrations
psql -U postgres -d collection_management -f migrations/001_create_collections_schema.sql

# Charger les données de test
psql -U postgres -d collection_management -f testdata/seed_meccg_mock.sql

# Installer les dépendances
go mod download

# Démarrer le service
go run cmd/api/main.go
```

## API Endpoints

### GET /api/v1/collections/summary

Retourne les statistiques globales de toutes les collections.

**Response**:
```json
{
  "user_id": "00000000-0000-0000-0000-000000000001",
  "total_cards_owned": 24,
  "total_cards_available": 40,
  "completion_percentage": 60.0,
  "last_updated": "2026-04-16T10:30:00Z"
}
```

**Statuts**:
- `200 OK` - Succès
- `500 Internal Server Error` - Erreur serveur

### GET /api/v1/collections

Retourne la liste de toutes les collections.

**Response**:
```json
[
  {
    "id": "11111111-1111-1111-1111-111111111111",
    "name": "Middle-earth CCG",
    "slug": "meccg",
    "category": "Fantasy",
    "total_cards": 40,
    "description": "The definitive Middle-earth trading card game",
    "created_at": "2026-04-16T10:00:00Z",
    "updated_at": "2026-04-16T10:00:00Z"
  }
]
```

### GET /api/v1/health

Health check endpoint.

**Response**:
```json
{
  "status": "ok"
}
```

## Tests

### Tests unitaires

```bash
# Tous les tests
go test ./...

# Tests avec coverage
go test -cover ./...

# Tests verbose
go test -v ./...

# Tests d'un package spécifique
go test ./internal/domain/
go test ./internal/application/
```

### Tests d'intégration

Les tests d'intégration utilisent testcontainers-go pour démarrer une instance PostgreSQL temporaire:

```bash
go test -tags=integration ./internal/infrastructure/postgres/
```

## Données Mock

Le fichier `testdata/seed_meccg_mock.sql` contient **40 cartes MECCG** générées pour couvrir toutes les dimensions:

### Types hiérarchiques (exemples)
- `Héros / Personnage`
- `Héros / Personnage / Sorcier`
- `Héros / Ressource / Faction`
- `Héros / Ressource / Objet`
- `Héros / Ressource / Allié`
- `Héros / Site / Havre`
- `Péril / Créature`
- `Séide / Personnage / Agent`
- `Région`
- `Stage`

### Séries (6 différentes)
- The Wizards (10 cartes)
- The Dragons (10 cartes)
- Against the Shadow (10 cartes)
- Dark Minions (5 cartes)
- Promo (3 cartes)
- The Lidless Eye (2 cartes)

### Raretés variées
- C1, C2, C3 (Communes)
- U1, U2, U3 (Peu communes)
- R1, R2, R3 (Rares)
- F1, F2 (Fixed)
- P (Promo)

### Statut de possession
- **24 cartes possédées** (60%) - `is_owned = true`
- **16 cartes non possédées** (40%) - `is_owned = false`

**Résultat attendu**: `/api/v1/collections/summary` doit retourner `completion_percentage: 60.0`

## Développement

### Principes DDD appliqués

1. **Ubiquitous Language**: Les termes du domaine (Collection, Card, UserCard) sont utilisés partout
2. **Aggregate Root**: Collection est l'aggregate root
3. **Repository Pattern**: Interfaces dans `domain/`, implémentations dans `infrastructure/`
4. **Separation of Concerns**: Domain → Application → Infrastructure

### Test Driven Development (TDD)

Le développement suit le cycle Red → Green → Refactor:

1. Écrire un test qui échoue (Red)
2. Écrire le code minimal pour faire passer le test (Green)
3. Refactoriser si nécessaire (Refactor)

Tous les tests sont dans `*_test.go` à côté du code testé.

### Ajouter une nouvelle fonctionnalité

1. Créer les tests dans `internal/domain/*_test.go`
2. Implémenter la logique métier dans `internal/domain/`
3. Créer les tests de service dans `internal/application/*_test.go`
4. Implémenter le service dans `internal/application/`
5. Créer les tests d'intégration dans `internal/infrastructure/postgres/*_test.go`
6. Implémenter le repository dans `internal/infrastructure/postgres/`
7. Créer le handler HTTP dans `internal/infrastructure/http/handlers/`
8. Ajouter la route dans `internal/infrastructure/http/server.go`

## Troubleshooting

### Erreur de connexion à PostgreSQL

```bash
# Vérifier que PostgreSQL est démarré
docker-compose ps

# Vérifier les logs
docker-compose logs postgres

# Redémarrer PostgreSQL
docker-compose restart postgres
```

### Les tests échouent

```bash
# Vérifier que les migrations sont appliquées
psql -h localhost -U collectoria -d collection_management -c "\dt"

# Réappliquer les migrations
psql -h localhost -U collectoria -d collection_management -f migrations/001_create_collections_schema.sql

# Recharger les données de test
psql -h localhost -U collectoria -d collection_management -f testdata/seed_meccg_mock.sql
```

### Port 8080 déjà utilisé

```bash
# Changer le port via variable d'environnement
export SERVER_PORT=8081
go run cmd/api/main.go
```

## TODO

- [ ] Authentification JWT (récupération user_id depuis token)
- [ ] Endpoint GET /api/v1/collections/{id}
- [ ] Endpoint GET /api/v1/collections/{id}/cards
- [ ] Endpoint POST /api/v1/collections/{id}/cards/{cardId}/toggle
- [ ] Tests d'intégration avec testcontainers
- [ ] Logging structuré avec zerolog
- [ ] Métriques Prometheus
- [ ] Documentation OpenAPI/Swagger

## Références

- [Spécifications Homepage Desktop v1](../../Specifications/technical/homepage-desktop-v1.md)
- [Modèle de données MVP v2](../../Specifications/technical/mvp-data-model-v2.md)
