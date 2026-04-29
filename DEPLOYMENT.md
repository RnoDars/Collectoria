# Déploiement Production Collectoria

## Prérequis

- Serveur avec Docker et Docker Compose installés
- Traefik configuré avec réseau `collectoria_proxy`
- Domaines DNS configurés :
  - `darsling.fr` → IP serveur
  - `api.darsling.fr` → IP serveur

## Étapes de Déploiement

### 1. Préparer le serveur

```bash
# Vérifier que Traefik est opérationnel
docker ps | grep traefik

# Vérifier que le réseau proxy existe
docker network ls | grep collectoria_proxy

# Si le réseau n'existe pas, le créer
docker network create collectoria_proxy
```

### 2. Cloner le projet

```bash
cd /home/arnaud.dars/git
git clone https://github.com/votre-repo/Collectoria.git
cd Collectoria
```

Ou mettre à jour :

```bash
cd /home/arnaud.dars/git/Collectoria
git pull origin main
```

### 3. Configurer les variables d'environnement

```bash
# Copier le template
cp .env.production.template .env.production

# Éditer avec les vraies valeurs
nano .env.production
```

Variables à configurer :

```bash
DB_USER=collectoria
DB_PASSWORD=<génerer-mot-de-passe-fort>
DB_NAME=collection_management

# Générer un secret JWT fort
JWT_SECRET=$(openssl rand -base64 64)
JWT_EXPIRATION_HOURS=24
JWT_ISSUER=collectoria-api
```

### 4. Construire et démarrer les services

```bash
# Build les images (première fois ou après changements)
docker-compose -f docker-compose.prod.yml build

# Démarrer tous les services
docker-compose -f docker-compose.prod.yml up -d

# Suivre les logs
docker-compose -f docker-compose.prod.yml logs -f
```

### 5. Vérifier le déploiement

```bash
# Vérifier l'état des conteneurs
docker-compose -f docker-compose.prod.yml ps

# Health check backend
curl https://api.darsling.fr/api/v1/health

# Health check frontend
curl https://darsling.fr/api/health

# Vérifier les logs
docker-compose -f docker-compose.prod.yml logs backend-collection
docker-compose -f docker-compose.prod.yml logs frontend
```

### 6. Tester dans le navigateur

- Frontend : https://darsling.fr
- Backend API : https://api.darsling.fr/api/v1/health

## Commandes Utiles

### Arrêter les services

```bash
docker-compose -f docker-compose.prod.yml down
```

### Arrêter et supprimer les volumes (⚠️ supprime les données PostgreSQL)

```bash
docker-compose -f docker-compose.prod.yml down -v
```

### Redémarrer un service spécifique

```bash
docker-compose -f docker-compose.prod.yml restart backend-collection
docker-compose -f docker-compose.prod.yml restart frontend
```

### Voir les logs d'un service

```bash
docker-compose -f docker-compose.prod.yml logs -f backend-collection
docker-compose -f docker-compose.prod.yml logs -f frontend
docker-compose -f docker-compose.prod.yml logs -f postgres-collection
```

### Reconstruire une image après changements

```bash
# Rebuild backend
docker-compose -f docker-compose.prod.yml build backend-collection
docker-compose -f docker-compose.prod.yml up -d backend-collection

# Rebuild frontend
docker-compose -f docker-compose.prod.yml build frontend
docker-compose -f docker-compose.prod.yml up -d frontend
```

### Accéder à PostgreSQL

```bash
docker exec -it collectoria-collection-db-prod psql -U collectoria -d collection_management
```

### Exécuter des migrations SQL

```bash
# Copier une migration dans le conteneur
docker cp backend/collection-management/migrations/xxx.sql collectoria-collection-db-prod:/tmp/

# Exécuter la migration
docker exec -it collectoria-collection-db-prod psql -U collectoria -d collection_management -f /tmp/xxx.sql
```

## Architecture Réseau

```
Internet
  |
  ├─> darsling.fr (HTTPS:443)
  |     └─> Traefik
  |           └─> collectoria-frontend-prod:3000
  |
  └─> api.darsling.fr (HTTPS:443)
        └─> Traefik
              └─> collectoria-backend-collection-prod:8080
                    └─> postgres-collection:5432
```

## Réseaux Docker

- **collectoria_proxy** (externe) : Communication avec Traefik
- **collectoria_internal** (bridge) : Communication backend ↔ PostgreSQL

## Volumes

- **postgres_collection_data** : Données persistantes PostgreSQL

## Sécurité

- Tous les secrets dans `.env.production` (non commité)
- User non-root dans les conteneurs
- HTTPS via Let's Encrypt (Traefik)
- Headers de sécurité configurés
- CORS configuré pour frontend uniquement

## Troubleshooting

### Le backend ne démarre pas

```bash
# Vérifier les variables d'environnement
docker-compose -f docker-compose.prod.yml config

# Vérifier les logs
docker-compose -f docker-compose.prod.yml logs backend-collection
```

### Le frontend affiche une erreur

```bash
# Vérifier que NEXT_PUBLIC_API_URL est correct
docker-compose -f docker-compose.prod.yml exec frontend env | grep NEXT_PUBLIC

# Vérifier les logs
docker-compose -f docker-compose.prod.yml logs frontend
```

### PostgreSQL ne se connecte pas

```bash
# Vérifier que PostgreSQL est healthy
docker-compose -f docker-compose.prod.yml ps

# Se connecter manuellement
docker exec -it collectoria-collection-db-prod psql -U collectoria -d collection_management
```

### Certificats SSL non générés

```bash
# Vérifier les logs Traefik
docker logs traefik

# Vérifier la configuration DNS
nslookup darsling.fr
nslookup api.darsling.fr
```

## Mise à jour de l'application

```bash
# 1. Pull les derniers changements
git pull origin main

# 2. Rebuild les images
docker-compose -f docker-compose.prod.yml build

# 3. Redémarrer avec zero-downtime
docker-compose -f docker-compose.prod.yml up -d --no-deps --build backend-collection
docker-compose -f docker-compose.prod.yml up -d --no-deps --build frontend

# 4. Vérifier
curl https://api.darsling.fr/api/v1/health
curl https://darsling.fr/api/health
```

## Backup PostgreSQL

```bash
# Backup
docker exec collectoria-collection-db-prod pg_dump -U collectoria collection_management > backup_$(date +%Y%m%d_%H%M%S).sql

# Restore
docker exec -i collectoria-collection-db-prod psql -U collectoria collection_management < backup_20260429_120000.sql
```
