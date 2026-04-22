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

### Fichier de Configuration

1. Copier le fichier d'exemple:
   ```bash
   cp .env.example .env
   ```

2. **IMPORTANT**: Modifier les valeurs sensibles, notamment:
   - `JWT_SECRET`: Générer un secret sécurisé (minimum 32 caractères)
   - `DB_PASSWORD`: Utiliser un mot de passe fort en production
   - `CORS_ALLOWED_ORIGINS`: Configurer les origines autorisées pour votre environnement
   - `ENV`: Passer à `production` en prod pour des logs JSON structurés

3. Ne JAMAIS commiter le fichier `.env` dans Git (déjà dans .gitignore)

### Variables d'Environnement

```bash
# Serveur
SERVER_PORT=8080

# Base de données
DB_HOST=localhost
DB_PORT=5432
DB_USER=collectoria
DB_PASSWORD=your-secure-password-here    # ⚠️ CHANGE ME IN PRODUCTION
DB_NAME=collection_management
DB_SSLMODE=disable                        # Use 'require' in production

# CORS (Cross-Origin Resource Sharing)
CORS_ALLOWED_ORIGINS=http://localhost:3000,http://localhost:3001
CORS_MAX_AGE=300                         # Préflight cache duration (seconds)

# JWT Authentication
JWT_SECRET=your-super-secret-key-at-least-32-chars  # ⚠️ REQUIRED - Generate with: openssl rand -base64 48
JWT_EXPIRATION_HOURS=24                  # Token validity duration (hours)
JWT_ISSUER=collectoria-api               # Token issuer identifier

# Logging
ENV=development                          # development | production
LOG_LEVEL=debug                          # trace | debug | info | warn | error | fatal | panic
```

### Différences Development vs Production

**Development** (`ENV=development`):
- Logs colorés et formatés pour la console
- Niveau de log par défaut: `debug`
- SSL désactivé pour PostgreSQL

**Production** (`ENV=production`):
- Logs JSON structurés (pour agrégation)
- Niveau de log par défaut: `info`
- SSL recommandé pour PostgreSQL (`DB_SSLMODE=require`)
- CORS strictement configuré

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

### Authentication

All endpoints except `/health` and `/auth/login` require JWT authentication.

**Include the token in the Authorization header**:
```bash
Authorization: Bearer <token>
```

See [Authentication Documentation](docs/AUTHENTICATION.md) for complete details.

**Quick Start**:
```bash
# 1. Login to get token
TOKEN=$(curl -s -X POST http://localhost:8080/api/v1/auth/login \
  -H "Content-Type: application/json" \
  -d '{"email":"test@collectoria.com","password":"test123"}' | jq -r '.token')

# 2. Use token for authenticated requests
curl -X GET http://localhost:8080/api/v1/collections/summary \
  -H "Authorization: Bearer $TOKEN"
```

---

### Public Endpoints

#### GET /api/v1/health

Health check endpoint (no authentication required).

**Response**:
```json
{
  "status": "healthy",
  "checks": {
    "database": "healthy",
    "memory_mb": "12.45"
  },
  "version": "0.1.0"
}
```

#### POST /api/v1/auth/login

Login endpoint to obtain JWT token (MVP: mock authentication).

**Request**:
```json
{
  "email": "test@collectoria.com",
  "password": "password123"
}
```

**Response**:
```json
{
  "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "expires_at": "2026-04-23T15:00:00Z"
}
```

---

### Protected Endpoints

All endpoints below require authentication.

#### GET /api/v1/collections/summary

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

### GET /api/v1/activities/recent

Retourne les activités récentes de l'utilisateur (Phase 1 : BDD locale).

**Query Parameters**:
- `limit` (optional): Nombre maximum d'activités à retourner (default: 10, max: 100)

**Response**:
```json
{
  "activities": [
    {
      "id": "uuid",
      "type": "card_added",
      "title": "Carte Gandalf ajoutée",
      "description": "Carte ajoutée à votre collection",
      "timestamp": "2026-04-21T15:57:14.670833Z",
      "icon": "plus-circle",
      "related_collection_name": "Middle-earth CCG",
      "metadata": {
        "card_id": "uuid",
        "card_name": "Gandalf",
        "is_owned": "true"
      }
    }
  ],
  "total_count": 1,
  "has_more": false
}
```

**Activity Types**:
- `card_added`: Carte ajoutée à la collection
- `card_removed`: Carte retirée de la collection
- `card_possession_changed`: Changement de statut de possession

**Statuts**:
- `200 OK` - Succès
- `500 Internal Server Error` - Erreur serveur

### PATCH /api/v1/cards/{id}/possession

Met à jour le statut de possession d'une carte et enregistre l'activité.

**Request Body**:
```json
{
  "is_owned": true
}
```

**Response**:
```json
{
  "success": true,
  "card": {
    "id": "uuid",
    "name_en": "Gandalf",
    "name_fr": "Gandalf",
    "card_type": "Character",
    "series": "Limited",
    "rarity": "Rare",
    "is_owned": true
  }
}
```

**Statuts**:
- `200 OK` - Succès
- `400 Bad Request` - ID de carte invalide
- `404 Not Found` - Carte non trouvée
- `500 Internal Server Error` - Erreur serveur

**Note**: L'enregistrement de l'activité est effectué en "best effort" - une erreur lors de l'enregistrement de l'activité ne fait pas échouer la mise à jour de possession.

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

## Future Improvements

### Event-Driven Architecture avec Kafka

**Statut** : Planifié pour Phase 2 (après MVP)

Actuellement, les activités sont stockées directement dans la table `activities`
du microservice Collection Management. À terme, nous migrerons vers une architecture
Kafka event-driven pour :
- Découpler les services
- Améliorer la scalabilité
- Créer un audit trail durable
- Permettre de multiples consumers (notifications, analytics)

**Déclencheurs de migration** :
- Au moins 2 services producteurs d'événements
- Volume d'activités > 10,000 par jour
- Besoin de notifications en temps réel
- Besoin d'audit trail complet

**Voir** :
- ADR : `../../Project follow-up/decisions/2026-04-21_activities-architecture-choice.md`
- Plan de migration : `../../Project follow-up/future-tasks/migration-kafka-activities.md`

**Effort estimé** : 3-5 jours de développement

---

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
