# Architecture Locale de Développement - Collectoria

**Date** : 2026-04-14  
**Version** : 1.0  
**Usage** : Développement sur laptop/desktop

---

## Vue d'Ensemble

Architecture complète pour développer Collectoria en local sur votre machine (laptop ou desktop).

**Objectif** : Pouvoir développer, tester et debugger tous les services localement sans infrastructure cloud.

---

## Architecture Locale

```
┌─────────────────────────────────────────────────────────────┐
│                    Machine Locale (Dev)                      │
├─────────────────────────────────────────────────────────────┤
│                                                               │
│  ┌──────────────────────────────────────────────────────┐   │
│  │              Frontend (Next.js)                       │   │
│  │  Port: 3000 (dev server)                             │   │
│  │  npm run dev                                          │   │
│  └──────────────────────────────────────────────────────┘   │
│                          │                                    │
│                          ▼ HTTP REST                          │
│  ┌────────────────────┐   ┌────────────────────┐            │
│  │  catalog-service   │   │ collection-service │            │
│  │  (Go)              │   │  (Go)              │            │
│  │  Port: 8081        │   │  Port: 8082        │            │
│  │  go run .          │   │  go run .          │            │
│  └────────────────────┘   └────────────────────┘            │
│           │                         │                         │
│           └────────┬────────────────┘                         │
│                    ▼                                          │
│  ┌─────────────────────────────────────────────────────┐    │
│  │           Docker Compose (Services)                  │    │
│  │  ┌─────────────────┐  ┌─────────────────┐          │    │
│  │  │  PostgreSQL     │  │  Kafka          │          │    │
│  │  │  catalog-db     │  │  (Optionnel)    │          │    │
│  │  │  Port: 5432     │  │  Port: 9092     │          │    │
│  │  └─────────────────┘  └─────────────────┘          │    │
│  │  ┌─────────────────┐                                │    │
│  │  │  PostgreSQL     │                                │    │
│  │  │  collection-db  │                                │    │
│  │  │  Port: 5433     │                                │    │
│  │  └─────────────────┘                                │    │
│  └─────────────────────────────────────────────────────┘    │
│                                                               │
└─────────────────────────────────────────────────────────────┘
```

---

## Prérequis

### Logiciels à Installer

1. **Docker Desktop**
   - Windows : https://docs.docker.com/desktop/install/windows-install/
   - Mac : https://docs.docker.com/desktop/install/mac-install/
   - Linux : https://docs.docker.com/engine/install/
   - Vérifier : `docker --version` et `docker compose version`

2. **Go 1.21+**
   - https://go.dev/dl/
   - Vérifier : `go version`

3. **Node.js 20+ (LTS)**
   - https://nodejs.org/
   - Vérifier : `node --version` et `npm --version`

4. **Git**
   - Déjà installé sur votre machine ✅

5. **IDE / Éditeur**
   - VS Code (recommandé) avec extensions :
     - Go (officielle)
     - ESLint
     - Prettier
     - Docker
   - Ou GoLand + WebStorm

### Ressources Machine Recommandées

- **RAM** : Minimum 8 GB (16 GB recommandé)
- **CPU** : 4 cores minimum
- **Disque** : 10 GB disponibles
- **OS** : Windows 10+, macOS 11+, Linux (Ubuntu 20.04+)

---

## Structure du Projet

```
collectoria/
├── docker-compose.yml              # Services infrastructure (PostgreSQL, Kafka)
├── docker-compose.override.yml     # Overrides pour dev local
├── .env.example                    # Variables d'environnement template
├── .env                            # Variables d'environnement (gitignored)
│
├── services/                       # Microservices backend
│   ├── catalog-service/
│   │   ├── cmd/
│   │   │   └── server/
│   │   │       └── main.go
│   │   ├── internal/
│   │   │   ├── domain/
│   │   │   ├── application/
│   │   │   ├── infrastructure/
│   │   │   └── interfaces/
│   │   ├── go.mod
│   │   ├── go.sum
│   │   ├── Dockerfile
│   │   └── README.md
│   │
│   └── collection-service/
│       ├── cmd/
│       ├── internal/
│       ├── go.mod
│       ├── Dockerfile
│       └── README.md
│
├── frontend/                       # Application Next.js
│   ├── src/
│   ├── public/
│   ├── package.json
│   ├── next.config.js
│   ├── tsconfig.json
│   └── README.md
│
├── scripts/                        # Scripts utilitaires
│   ├── init-db.sh
│   ├── import-data.sh
│   └── reset-local.sh
│
└── docs/                          # Documentation
    └── ...
```

---

## Configuration Docker Compose

### `docker-compose.yml`

```yaml
version: '3.9'

services:
  # PostgreSQL pour Catalog Service
  catalog-db:
    image: postgres:16-alpine
    container_name: collectoria-catalog-db
    environment:
      POSTGRES_DB: catalog
      POSTGRES_USER: catalog_user
      POSTGRES_PASSWORD: catalog_pass
      POSTGRES_INITDB_ARGS: "--encoding=UTF8 --locale=C"
    ports:
      - "5432:5432"
    volumes:
      - catalog-db-data:/var/lib/postgresql/data
      - ./scripts/init-catalog-db.sql:/docker-entrypoint-initdb.d/init.sql
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U catalog_user -d catalog"]
      interval: 10s
      timeout: 5s
      retries: 5
    networks:
      - collectoria-network

  # PostgreSQL pour Collection Service
  collection-db:
    image: postgres:16-alpine
    container_name: collectoria-collection-db
    environment:
      POSTGRES_DB: collection
      POSTGRES_USER: collection_user
      POSTGRES_PASSWORD: collection_pass
      POSTGRES_INITDB_ARGS: "--encoding=UTF8 --locale=C"
    ports:
      - "5433:5432"  # Port différent pour éviter conflit
    volumes:
      - collection-db-data:/var/lib/postgresql/data
      - ./scripts/init-collection-db.sql:/docker-entrypoint-initdb.d/init.sql
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U collection_user -d collection"]
      interval: 10s
      timeout: 5s
      retries: 5
    networks:
      - collectoria-network

  # Kafka (Optionnel pour MVP, décommenter si nécessaire)
  # zookeeper:
  #   image: confluentinc/cp-zookeeper:7.5.0
  #   container_name: collectoria-zookeeper
  #   environment:
  #     ZOOKEEPER_CLIENT_PORT: 2181
  #     ZOOKEEPER_TICK_TIME: 2000
  #   ports:
  #     - "2181:2181"
  #   networks:
  #     - collectoria-network

  # kafka:
  #   image: confluentinc/cp-kafka:7.5.0
  #   container_name: collectoria-kafka
  #   depends_on:
  #     - zookeeper
  #   environment:
  #     KAFKA_BROKER_ID: 1
  #     KAFKA_ZOOKEEPER_CONNECT: zookeeper:2181
  #     KAFKA_ADVERTISED_LISTENERS: PLAINTEXT://localhost:9092
  #     KAFKA_OFFSETS_TOPIC_REPLICATION_FACTOR: 1
  #   ports:
  #     - "9092:9092"
  #   networks:
  #     - collectoria-network

  # PgAdmin (Optionnel - Interface web pour PostgreSQL)
  pgadmin:
    image: dpage/pgadmin4:latest
    container_name: collectoria-pgadmin
    environment:
      PGADMIN_DEFAULT_EMAIL: admin@collectoria.local
      PGADMIN_DEFAULT_PASSWORD: admin
      PGADMIN_CONFIG_SERVER_MODE: 'False'
    ports:
      - "5050:80"
    volumes:
      - pgadmin-data:/var/lib/pgadmin
    networks:
      - collectoria-network
    profiles:
      - tools  # Lancer uniquement avec --profile tools

volumes:
  catalog-db-data:
  collection-db-data:
  pgadmin-data:

networks:
  collectoria-network:
    driver: bridge
```

### `.env.example`

```bash
# Environment: local | dev | staging | prod
ENVIRONMENT=local

# Catalog Service
CATALOG_SERVICE_PORT=8081
CATALOG_DB_HOST=localhost
CATALOG_DB_PORT=5432
CATALOG_DB_NAME=catalog
CATALOG_DB_USER=catalog_user
CATALOG_DB_PASSWORD=catalog_pass
CATALOG_DB_SSLMODE=disable

# Collection Service
COLLECTION_SERVICE_PORT=8082
COLLECTION_DB_HOST=localhost
COLLECTION_DB_PORT=5433
COLLECTION_DB_NAME=collection
COLLECTION_DB_USER=collection_user
COLLECTION_DB_PASSWORD=collection_pass
COLLECTION_DB_SSLMODE=disable

# Frontend
NEXT_PUBLIC_CATALOG_API_URL=http://localhost:8081/api/v1
NEXT_PUBLIC_COLLECTION_API_URL=http://localhost:8082/api/v1

# Kafka (optionnel)
# KAFKA_BROKERS=localhost:9092

# Logging
LOG_LEVEL=debug
```

---

## Démarrage Rapide

### 1. Cloner le Projet

```bash
cd ~/git
git clone <repo-url> collectoria
cd collectoria
```

### 2. Configuration

```bash
# Copier le fichier d'environnement
cp .env.example .env

# Éditer si nécessaire (les valeurs par défaut fonctionnent)
nano .env
```

### 3. Démarrer l'Infrastructure

```bash
# Démarrer PostgreSQL (sans Kafka pour MVP)
docker compose up -d catalog-db collection-db

# Vérifier que tout fonctionne
docker compose ps

# Voir les logs
docker compose logs -f

# (Optionnel) Démarrer PgAdmin pour explorer les BDD
docker compose --profile tools up -d pgadmin
# Accès : http://localhost:5050
```

### 4. Initialiser les Bases de Données

```bash
# Les schémas sont automatiquement créés au démarrage via init scripts
# Ou utiliser migrations Go

cd services/catalog-service
go run cmd/migrate/main.go up

cd ../collection-service
go run cmd/migrate/main.go up
```

### 5. Démarrer Catalog Service

```bash
cd services/catalog-service

# Installer dépendances
go mod download

# Lancer le service (mode dev avec hot reload)
# Option 1 : go run
go run cmd/server/main.go

# Option 2 : air (hot reload - à installer)
# go install github.com/cosmtrek/air@latest
air

# Le service écoute sur http://localhost:8081
# Health check : curl http://localhost:8081/health
```

### 6. Démarrer Collection Service

```bash
# Dans un nouveau terminal
cd services/collection-service

go mod download
go run cmd/server/main.go

# Le service écoute sur http://localhost:8082
# Health check : curl http://localhost:8082/health
```

### 7. Démarrer Frontend

```bash
# Dans un nouveau terminal
cd frontend

# Installer dépendances
npm install

# Lancer le dev server
npm run dev

# L'application est accessible sur http://localhost:3000
```

### 8. Importer les Données (Optionnel)

```bash
# Script d'import depuis Google Sheets (XLSX)
cd scripts
./import-data.sh ~/path/to/doomtrooper.xlsx ~/path/to/meccg.xlsx
```

---

## Commandes Utiles

### Docker Compose

```bash
# Démarrer tous les services
docker compose up -d

# Arrêter tous les services
docker compose down

# Voir les logs
docker compose logs -f [service-name]

# Redémarrer un service
docker compose restart catalog-db

# Supprimer volumes (ATTENTION : perte de données)
docker compose down -v

# Rebuild après changement Dockerfile
docker compose build [service-name]
```

### PostgreSQL

```bash
# Se connecter à catalog-db
docker exec -it collectoria-catalog-db psql -U catalog_user -d catalog

# Se connecter à collection-db
docker exec -it collectoria-collection-db psql -U collection_user -d collection

# Dump d'une base
docker exec collectoria-catalog-db pg_dump -U catalog_user catalog > catalog_backup.sql

# Restore
docker exec -i collectoria-catalog-db psql -U catalog_user catalog < catalog_backup.sql
```

### Go Services

```bash
# Tests
cd services/catalog-service
go test ./... -v

# Tests avec couverture
go test ./... -cover -coverprofile=coverage.out
go tool cover -html=coverage.out

# Linter
golangci-lint run

# Build
go build -o bin/catalog-service cmd/server/main.go
```

### Frontend

```bash
cd frontend

# Démarrage dev
npm run dev

# Build production
npm run build

# Lancer la build
npm start

# Linter
npm run lint

# Tests
npm test
```

---

## Debugging

### VS Code Launch Configuration

Créer `.vscode/launch.json` :

```json
{
  "version": "0.2.0",
  "configurations": [
    {
      "name": "Catalog Service",
      "type": "go",
      "request": "launch",
      "mode": "debug",
      "program": "${workspaceFolder}/services/catalog-service/cmd/server",
      "env": {
        "CATALOG_DB_HOST": "localhost",
        "CATALOG_DB_PORT": "5432"
      },
      "showLog": true
    },
    {
      "name": "Collection Service",
      "type": "go",
      "request": "launch",
      "mode": "debug",
      "program": "${workspaceFolder}/services/collection-service/cmd/server",
      "env": {
        "COLLECTION_DB_HOST": "localhost",
        "COLLECTION_DB_PORT": "5433"
      },
      "showLog": true
    }
  ]
}
```

### Logs

```bash
# Services Go : stdout avec structured logging (zerolog)
# Frontend : console dans le terminal npm run dev
# PostgreSQL : docker compose logs -f catalog-db
```

---

## Tests

### Tests Unitaires (Go)

```bash
cd services/catalog-service

# Tests du domaine
go test ./internal/domain/... -v

# Tests avec mocks
go test ./internal/application/... -v
```

### Tests d'Intégration (Go)

```bash
# Utilise testcontainers pour PostgreSQL réel
go test ./tests/integration/... -v

# Ou avec tag
go test -tags=integration ./... -v
```

### Tests E2E

```bash
cd frontend

# Playwright
npm run test:e2e

# Avec UI
npm run test:e2e:ui
```

---

## Réinitialisation Complète

```bash
# Script pour tout réinitialiser
#!/bin/bash
# scripts/reset-local.sh

# Arrêter tous les services
docker compose down -v

# Supprimer les binaires Go
rm -rf services/*/bin

# Supprimer node_modules
rm -rf frontend/node_modules

# Redémarrer
docker compose up -d catalog-db collection-db
cd services/catalog-service && go run cmd/server/main.go &
cd services/collection-service && go run cmd/server/main.go &
cd frontend && npm install && npm run dev
```

---

## Troubleshooting

### Port déjà utilisé

```bash
# Trouver le processus sur le port 8081
lsof -i :8081
# ou
netstat -tuln | grep 8081

# Tuer le processus
kill -9 <PID>

# Ou changer le port dans .env
```

### PostgreSQL ne démarre pas

```bash
# Voir les logs
docker compose logs catalog-db

# Vérifier les volumes
docker volume ls

# Supprimer et recréer
docker compose down -v
docker compose up -d catalog-db
```

### Go module errors

```bash
# Clean cache
go clean -modcache

# Re-download
go mod download

# Tidy
go mod tidy
```

---

## Performance Locale

### Ressources Typiques

Avec tout qui tourne :
- **Docker (PostgreSQL x2)** : ~300-500 MB RAM
- **Catalog Service** : ~50-100 MB RAM
- **Collection Service** : ~50-100 MB RAM
- **Frontend (dev)** : ~200-400 MB RAM
- **Total** : ~600 MB - 1 GB RAM

### Optimisations

1. **Kafka** : Désactivé par défaut (optionnel pour MVP)
2. **PgAdmin** : Uniquement avec `--profile tools`
3. **Hot Reload** : Utiliser Air pour Go (redémarrage rapide)
4. **Next.js** : Turbopack activé par défaut (fast refresh)

---

## Prochaines Étapes

Après avoir setup l'environnement local :

1. ✅ Tout fonctionne (sanity checks)
2. 🔜 Implémenter le domain layer (TDD)
3. 🔜 Implémenter les repositories
4. 🔜 Implémenter les API REST
5. 🔜 Implémenter le frontend
6. 🔜 Import des données depuis XLSX
7. 🔜 Tests E2E complets

---

## Ressources

- [Docker Compose Docs](https://docs.docker.com/compose/)
- [Go Documentation](https://go.dev/doc/)
- [Next.js Documentation](https://nextjs.org/docs)
- [PostgreSQL Docker](https://hub.docker.com/_/postgres)

---

**Note** : Cette architecture locale est **identique** à la production en termes de services, juste moins scalable. Le code développé localement fonctionnera en production sans changement.
