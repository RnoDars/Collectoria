# Tests Locaux et Environnement de Développement - DevOps

**Référence** : Ce document est extrait de `DevOps/CLAUDE.md` pour améliorer la lisibilité.

---

## IMPORTANT : DevOps est le point d'entrée pour TOUS les tests locaux

Quand Alfred ou un autre agent a besoin de tester un service localement, **DevOps doit être appelé** pour :
- Setup de l'infrastructure locale (PostgreSQL, Kafka, etc.)
- Lancement des services
- Exécution des tests
- Nettoyage après tests

---

## Scripts de Tests Locaux

### Script Principal : `scripts/test-local.sh`

Lance PostgreSQL via le docker-compose du microservice (`sg docker`), seed les données de test et teste les endpoints `/api/v1/collections` et `/api/v1/collections/summary`.

**Usage** : 
```bash
./scripts/test-local.sh [collection-management|all]
# Ou via Makefile
make test-backend
```

---

### Script de Nettoyage : `scripts/cleanup-local.sh`

Arrête le container `collectoria-collection-db` via docker-compose, supprime les containers collectoria restants et kill les processus `go run cmd/api/main.go`.

**Usage** : 
```bash
./scripts/cleanup-local.sh
# Ou via Makefile
make cleanup
```

---

### Script de Monitoring : `scripts/monitor-local.sh`

Affiche le statut de chaque service (PostgreSQL port 5432, backend port 8080, frontend port 3000) et les 10 dernières lignes de logs PostgreSQL.

**Usage** : 
```bash
./scripts/monitor-local.sh
# Ou via Makefile
make monitor
```

---

## Makefile Global

**Fichier** : `Makefile` à la racine du projet

**Cibles disponibles** :
- `make help` - Afficher l'aide
- `make test-backend` - Tester collection-management
- `make test-local` - Tester tous les services
- `make test-frontend` - Tester le frontend
- `make cleanup` - Nettoyer containers et processus
- `make monitor` - Voir le statut des services
- `make setup` - Rendre les scripts exécutables (à faire une seule fois)

---

## Usage Rapide pour les Développeurs

```bash
make setup        # Rendre les scripts exécutables (à faire une seule fois)
make test-backend # Tester collection-management
make test-local   # Tester tous les services
make monitor      # Voir le statut des services
make cleanup      # Nettoyer containers et processus
```

---

## Workflow DevOps pour Tests Locaux

Quand Alfred demande "teste le microservice X" :

1. **DevOps répond** : "Je vais lancer les tests locaux pour X"
2. **DevOps exécute** :
   - Vérifie les prérequis (Docker, Go, etc.)
   - Lance PostgreSQL via Docker
   - Applique les migrations
   - Seed les données de test
   - Lance le service
   - Test l'endpoint avec curl
   - Retourne les résultats
3. **DevOps nettoie** : Arrête les services et containers

---

## Règles Opérationnelles Locales

### Docker sans sudo — utiliser `sg docker`

L'utilisateur n'est pas forcément dans le groupe docker actif en session courante. Ne jamais utiliser `sudo docker`. Toujours préfixer avec `sg docker` :

```bash
# ✅ Correct
sg docker -c "docker compose up -d"
sg docker -c "docker exec -i collectoria-collection-db psql -U collectoria -d collection_management < seed.sql"

# ❌ Incorrect
sudo docker compose up -d
docker compose up -d  # échoue si groupe pas actif
```

---

### Charger les données de seed via docker exec

`psql` n'est pas forcément installé sur la machine hôte. Utiliser `docker exec` pour exécuter les commandes SQL :

```bash
sg docker -c "docker exec -i collectoria-collection-db psql -U collectoria -d collection_management" < testdata/seed_meccg_mock.sql
```

---

### Lancer les services localement

```bash
# 1. PostgreSQL (via docker-compose du microservice)
sg docker -c "docker compose -f backend/collection-management/docker-compose.yml up -d"

# 2. Backend Go
cd backend/collection-management && go run cmd/api/main.go &

# 3. Frontend Next.js
cd frontend && npm run dev
```

---

### Ports par défaut

- **Frontend** : http://localhost:3000 (peut changer → **TOUJOURS VÉRIFIER**)
- **Backend API** : http://localhost:8080
- **PostgreSQL** : localhost:5432

---

### Seed de données

Le fichier `backend/collection-management/testdata/seed_meccg_mock.sql` contient 40 cartes MECCG (1 collection, 60% de complétion).

---

## Prérequis pour Tests Locaux

Les développeurs doivent avoir installé :
- Docker
- Go 1.21+
- Node.js 18+ (pour frontend)
- make
- jq (pour parser JSON)
- curl

---

## Lancement d'Environnement - Bonnes Pratiques

Quand tu lances l'environnement de développement, **toujours indiquer clairement les ports utilisés** :

### Frontend Next.js - Détection Automatique du Port

**Contexte** : Next.js cherche automatiquement un port disponible (3000 → 3001 → 3002...)

**TOUJOURS vérifier et indiquer le port réel** après démarrage :

```bash
# Méthode 1 : Vérifier quel port est utilisé
lsof -i :3000 -i :3001 -i :3002 2>/dev/null | grep LISTEN

# Méthode 2 : Lire les logs de démarrage
tail -20 /tmp/frontend-dev.log | grep "Local:"

# Méthode 3 : Tester les ports
curl -s http://localhost:3000 > /dev/null && echo "Port 3000" || \
curl -s http://localhost:3001 > /dev/null && echo "Port 3001" || \
echo "Aucun port trouvé"
```

---

### Ports Standards du Projet

- **Frontend Next.js** : 3000 (par défaut, peut changer → **TOUJOURS VÉRIFIER**)
- **Backend Go** : 8080 (fixe)
- **PostgreSQL** : 5432 (fixe)
- **Kafka** (futur) : 9092/2181

---

### Template de Rapport de Lancement

**TOUJOURS afficher ce rapport après lancement** :

```
✅ Environnement de développement lancé :

Backend Go
- Port : 8080
- URL : http://localhost:8080/api/v1/health
- Status : Healthy

Frontend Next.js
- Port : 3001 (3000 était occupé)  ← IMPORTANT : Indiquer pourquoi si ≠ 3000
- URL : http://localhost:3001
- Status : Ready

Base de Données
- Port : 5432
- Status : Up (healthy)
- Données : 1679 cartes MECCG
```

**Si le port 3000 est occupé**, indiquer ce qui l'occupe :
```bash
lsof -i :3000 | grep LISTEN | awk '{print $1, $2}'
# Exemple : "node 12345" ou "python 67890"
```

---

## Initialisation d'une Nouvelle Machine

Quand on configure l'environnement sur une nouvelle machine, suivre ces étapes dans l'ordre :

### 1. Cloner le repo et démarrer PostgreSQL

```bash
git clone git@github.com:RnoDars/Collectoria.git ~/git/Collectoria
cd ~/git/Collectoria/backend/collection-management
docker compose up -d
```

---

### 2. Appliquer les migrations dans l'ordre

```bash
# Les migrations sont cumulatives et TOUTES nécessaires
sg docker -c "docker exec -i collectoria-collection-db psql -U collectoria -d collection_management" \
  < migrations/001_create_collections_schema.sql

sg docker -c "docker exec -i collectoria-collection-db psql -U collectoria -d collection_management" \
  < migrations/002_seed_meccg_real.sql          # 1679 cartes MECCG (catalogue)

sg docker -c "docker exec -i collectoria-collection-db psql -U collectoria -d collection_management" \
  < migrations/003_create_activities_table.sql  # Table activités

sg docker -c "docker exec -i collectoria-collection-db psql -U collectoria -d collection_management" \
  < migrations/004_seed_dev_possession.sql      # Possession initiale (1661/1679 possédées)

sg docker -c "docker exec -i collectoria-collection-db psql -U collectoria -d collection_management" \
  < migrations/005_add_books_collection.sql     # Table books + 94 livres (Royaumes Oubliés, Dragonlance...)

sg docker -c "docker exec -i collectoria-collection-db psql -U collectoria -d collection_management" \
  < migrations/006_add_title_description_to_activities.sql  # Colonnes title/description sur activities

sg docker -c "docker exec -i collectoria-collection-db psql -U collectoria -d collection_management" \
  < migrations/007_allow_null_name_fr.sql       # Autorise NULL sur name_fr (extensions non traduites)

sg docker -c "docker exec -i collectoria-collection-db psql -U collectoria -d collection_management" \
  < migrations/008_update_meccg_corrected_names.sql  # 385 corrections noms FR des cartes MECCG

sg docker -c "docker exec -i collectoria-collection-db psql -U collectoria -d collection_management" \
  < migrations/009_fix_all_meccg_names_from_csv.sql  # 1679 corrections complètes depuis meccg_all_cards_review.csv

sg docker -c "docker exec -i collectoria-collection-db psql -U collectoria -d collection_management" \
  < migrations/010_add_dnd5_collection.sql  # Table dnd5_books + 53 livres D&D 5e + possession initiale (19 FR + 17 EN)

sg docker -c "docker exec -i collectoria-collection-db psql -U collectoria -d collection_management" \
  < migrations/011_separate_collections.sql  # Refactoring : tables forgottenrealms_novels / dnd5_books séparées
```

**Note** : La migration 004 est idempotente (`ON CONFLICT DO NOTHING`). Elle peut être rejouée sans risque sur une base qui a déjà des données de possession.

---

### 3. Installer les dépendances frontend

```bash
cd ~/git/Collectoria/frontend
npm install
```

---

### 4. Lancer l'environnement

Suivre la procédure de démarrage manuel (voir `DevOps/restart-procedures.md`).

---

## Credentials de développement

| Paramètre | Valeur |
|-----------|--------|
| DB_USER | `collectoria` |
| DB_PASSWORD | `collectoria` |
| DB_NAME | `collection_management` |
| Login app | `arnaud.dars@gmail.com` |
| Password app | `flying38` |
| UserID dev | `00000000-0000-0000-0000-000000000001` |

---

*Document extrait de DevOps/CLAUDE.md le 2026-04-23*
