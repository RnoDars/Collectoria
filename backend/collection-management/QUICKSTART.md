# Quick Start - Collection Management Microservice

Démarrage rapide en 3 minutes.

---

## Option 1: Script Automatique (Recommandé)

```bash
# Tout en une seule commande
./setup.sh
```

Ensuite:
```bash
# Démarrer le service
go run cmd/api/main.go
```

---

## Option 2: Makefile

```bash
# Setup complet
make setup

# Démarrer le service
make run
```

---

## Option 3: Commandes Manuelles

```bash
# 1. Démarrer PostgreSQL
docker-compose up -d

# 2. Attendre 5 secondes
sleep 5

# 3. Appliquer les migrations
PGPASSWORD=collectoria psql -h localhost -U collectoria \
  -d collection_management \
  -f migrations/001_create_collections_schema.sql

# 4. Charger les données mock (40 cartes)
PGPASSWORD=collectoria psql -h localhost -U collectoria \
  -d collection_management \
  -f testdata/seed_meccg_mock.sql

# 5. Installer les dépendances
go mod download

# 6. Démarrer le service
go run cmd/api/main.go
```

---

## Validation

### 1. Tester l'endpoint

```bash
curl http://localhost:8080/api/v1/collections/summary | jq
```

**Résultat attendu**:
```json
{
  "user_id": "00000000-0000-0000-0000-000000000001",
  "total_cards_owned": 24,
  "total_cards_available": 40,
  "completion_percentage": 60.0,
  "last_updated": "2026-04-16T12:00:00Z"
}
```

### 2. Tester la santé du service

```bash
curl http://localhost:8080/api/v1/health
```

**Résultat attendu**:
```json
{
  "status": "ok"
}
```

### 3. Vérifier la base de données

```bash
# Nombre total de cartes
PGPASSWORD=collectoria psql -h localhost -U collectoria \
  -d collection_management \
  -c "SELECT COUNT(*) FROM cards;"

# Résultat attendu: 40
```

```bash
# Nombre de cartes possédées
PGPASSWORD=collectoria psql -h localhost -U collectoria \
  -d collection_management \
  -c "SELECT COUNT(*) FROM user_cards WHERE is_owned = true;"

# Résultat attendu: 24
```

---

## Tests

### Tests unitaires
```bash
make test
# ou
go test ./...
```

### Tests avec couverture
```bash
make test-coverage
# ou
go test ./... -cover
```

**Couverture attendue**: 91.7%

---

## Commandes Utiles

### Redémarrer PostgreSQL
```bash
make docker-down
make docker-up
```

### Réappliquer les données
```bash
make migrate
make seed
```

### Build
```bash
make build
./main
```

### Logs PostgreSQL
```bash
docker-compose logs -f postgres
```

---

## Variables d'Environnement (optionnel)

Si vous voulez changer la configuration:

```bash
export SERVER_PORT=8081
export DB_HOST=localhost
export DB_PORT=5432
export DB_USER=collectoria
export DB_PASSWORD=collectoria
export DB_NAME=collection_management
export DB_SSLMODE=disable

go run cmd/api/main.go
```

---

## Troubleshooting

### Port 5432 déjà utilisé
```bash
# Arrêter le PostgreSQL local
sudo systemctl stop postgresql

# Ou changer le port dans docker-compose.yml
ports:
  - "5433:5432"
```

### Port 8080 déjà utilisé
```bash
export SERVER_PORT=8081
go run cmd/api/main.go
```

### Erreur de connexion PostgreSQL
```bash
# Vérifier que PostgreSQL est démarré
docker-compose ps

# Redémarrer si nécessaire
docker-compose restart postgres
```

### Tests échouent
```bash
# Réappliquer tout
make docker-down
make docker-up
sleep 5
make migrate
make seed
make test
```

---

## Documentation Complète

- [README.md](./README.md) - Documentation complète
- [IMPLEMENTATION_REPORT.md](./IMPLEMENTATION_REPORT.md) - Rapport d'implémentation
- [testdata/MOCK_CARDS_VALIDATION.md](./testdata/MOCK_CARDS_VALIDATION.md) - Validation des données mock

---

**Ready to go!** 🚀
