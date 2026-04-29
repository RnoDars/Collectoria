# Phase 3.5 : Validation Fichiers Production

**Date de Création** : 2026-04-29  
**Agent** : Amélioration Continue  
**Objectif** : Valider TOUS les fichiers Docker de production AVANT déploiement Phase 4  
**Durée Estimée** : 30-45 minutes

---

## Vue d'Ensemble

**Pourquoi cette phase existe** :
- Phase 4 (déploiement) a révélé que les fichiers Docker étaient créés **pendant** le déploiement
- Erreurs découvertes en production (version Go, healthcheck, etc.)
- Stress élevé, multiples rebuilds, perte de temps

**Objectif Phase 3.5** :
- Créer et valider TOUS les fichiers Docker **localement**
- Détecter les erreurs AVANT d'aller sur le serveur
- Phase 4 devient rapide et fiable (fichiers déjà validés)

**Quand exécuter** : Entre Phase 3 (Scaleway setup) et Phase 4 (Déploiement)

---

## Prérequis

Avant de commencer Phase 3.5, vérifier :

- [ ] Phase 3 complétée (serveur Scaleway opérationnel)
- [ ] Docker installé localement
- [ ] Accès au repository Git Collectoria
- [ ] Go 1.23+ installé (pour build backend local)
- [ ] Node.js 20+ installé (pour build frontend local)

---

## Checklist Complète

### Étape 1 : Création Dockerfile Backend

**Fichier** : `Backend/collection-management/Dockerfile`

**Vérifications** :

- [ ] **Fichier existe** :
  ```bash
  ls -la Backend/collection-management/Dockerfile
  ```

- [ ] **Version Go cohérente avec go.mod** :
  ```bash
  # Vérifier version dans go.mod
  grep "^go " Backend/collection-management/go.mod
  # Exemple : go 1.23.0
  
  # Vérifier version dans Dockerfile
  grep "^FROM golang" Backend/collection-management/Dockerfile
  # Doit contenir : golang:1.23-alpine (ou supérieur)
  ```

- [ ] **Healthcheck utilise GET (pas HEAD)** :
  ```bash
  grep "HEALTHCHECK" Backend/collection-management/Dockerfile
  # Vérifier : PAS de --spider (qui = HEAD)
  # Attendu : wget -O /dev/null (qui = GET)
  ```

- [ ] **Variables d'environnement définies** :
  ```bash
  grep "ENV" Backend/collection-management/Dockerfile
  # Vérifier : DB_HOST, DB_PORT, SERVER_PORT, etc.
  ```

- [ ] **Build local réussit** :
  ```bash
  cd Backend/collection-management
  docker build -t collectoria-backend-test .
  # Doit réussir sans erreur
  ```

- [ ] **Image créée** :
  ```bash
  docker images | grep collectoria-backend-test
  # Doit apparaître dans la liste
  ```

**Exemple Dockerfile Backend** (référence) :
```dockerfile
# Build stage
FROM golang:1.23-alpine AS builder

WORKDIR /app

# Dépendances
COPY go.mod go.sum ./
RUN go mod download

# Code source
COPY . .

# Build
RUN CGO_ENABLED=0 GOOS=linux go build -o /app/api ./cmd/api

# Runtime stage
FROM alpine:latest

RUN apk --no-cache add ca-certificates wget

WORKDIR /root/

COPY --from=builder /app/api .
COPY --from=builder /app/migrations ./migrations

# Port
EXPOSE 8080

# Healthcheck (GET, pas HEAD)
HEALTHCHECK --interval=30s --timeout=5s --start-period=10s --retries=3 \
  CMD wget --quiet --tries=1 -O /dev/null http://localhost:8080/api/v1/health || exit 1

CMD ["./api"]
```

---

### Étape 2 : Création Dockerfile Frontend

**Fichier** : `Frontend/Dockerfile`

**Vérifications** :

- [ ] **Fichier existe** :
  ```bash
  ls -la Frontend/Dockerfile
  ```

- [ ] **Version Node cohérente avec package.json** :
  ```bash
  # Vérifier version dans package.json
  grep '"node":' Frontend/package.json
  
  # Vérifier version dans Dockerfile
  grep "^FROM node" Frontend/Dockerfile
  # Doit contenir : node:20-alpine (ou supérieur)
  ```

- [ ] **Healthcheck utilise GET** :
  ```bash
  grep "HEALTHCHECK" Frontend/Dockerfile
  # Vérifier : wget -O /dev/null http://localhost:3000
  ```

- [ ] **Build Next.js configuré** :
  ```bash
  grep "npm run build" Frontend/Dockerfile
  # Doit inclure étape de build Next.js
  ```

- [ ] **Build local réussit** :
  ```bash
  cd Frontend
  docker build -t collectoria-frontend-test .
  # Doit réussir sans erreur
  # ⚠️ Peut prendre 5-10 minutes (npm install + build)
  ```

- [ ] **Image créée** :
  ```bash
  docker images | grep collectoria-frontend-test
  # Doit apparaître dans la liste
  ```

**Exemple Dockerfile Frontend** (référence) :
```dockerfile
# Dependencies stage
FROM node:20-alpine AS deps

WORKDIR /app

COPY package.json package-lock.json ./
RUN npm ci

# Builder stage
FROM node:20-alpine AS builder

WORKDIR /app

COPY --from=deps /app/node_modules ./node_modules
COPY . .

RUN npm run build

# Runner stage
FROM node:20-alpine AS runner

WORKDIR /app

ENV NODE_ENV production

RUN addgroup --system --gid 1001 nodejs
RUN adduser --system --uid 1001 nextjs

COPY --from=builder /app/public ./public
COPY --from=builder /app/.next/standalone ./
COPY --from=builder /app/.next/static ./.next/static

USER nextjs

EXPOSE 3000

ENV PORT 3000
ENV HOSTNAME "0.0.0.0"

# Healthcheck
HEALTHCHECK --interval=30s --timeout=5s --start-period=15s --retries=3 \
  CMD wget --quiet --tries=1 -O /dev/null http://localhost:3000/ || exit 1

CMD ["node", "server.js"]
```

---

### Étape 3 : Création docker-compose.prod.yml

**Fichier** : `docker-compose.prod.yml` (à la racine du projet)

**Vérifications** :

- [ ] **Fichier existe** :
  ```bash
  ls -la docker-compose.prod.yml
  ```

- [ ] **Services définis** :
  ```bash
  # Vérifier services présents
  grep "^  [a-z]*:" docker-compose.prod.yml
  # Attendu : postgres, backend, frontend (minimum)
  ```

- [ ] **Healthchecks cohérents avec Dockerfiles** :
  ```bash
  # Exécuter script de validation (si disponible)
  bash DevOps/scripts/validate-healthchecks.sh
  
  # OU vérifier manuellement
  grep -A 5 "healthcheck:" docker-compose.prod.yml
  # Vérifier : PAS de --spider, UTILISER -O /dev/null
  ```

- [ ] **Réseaux définis** :
  ```bash
  grep "^networks:" docker-compose.prod.yml
  # Au moins un réseau défini
  ```

- [ ] **Volumes définis** :
  ```bash
  grep "^volumes:" docker-compose.prod.yml
  # Au moins volume pour PostgreSQL
  ```

- [ ] **Variables d'environnement référencées** :
  ```bash
  grep "\${" docker-compose.prod.yml
  # Variables comme ${POSTGRES_USER}, ${DB_HOST}, etc.
  ```

**Exemple docker-compose.prod.yml** (référence) :
```yaml
version: '3.8'

services:
  postgres:
    image: postgres:15-alpine
    environment:
      POSTGRES_USER: ${POSTGRES_USER}
      POSTGRES_PASSWORD: ${POSTGRES_PASSWORD}
      POSTGRES_DB: ${POSTGRES_DB}
    volumes:
      - postgres_data:/var/lib/postgresql/data
    networks:
      - collectoria-network
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U ${POSTGRES_USER}"]
      interval: 10s
      timeout: 5s
      retries: 5

  backend:
    build:
      context: ./Backend/collection-management
      dockerfile: Dockerfile
    environment:
      DB_HOST: postgres
      DB_PORT: 5432
      DB_USER: ${POSTGRES_USER}
      DB_PASSWORD: ${POSTGRES_PASSWORD}
      DB_NAME: ${POSTGRES_DB}
      SERVER_PORT: 8080
      JWT_SECRET: ${JWT_SECRET}
      JWT_EXPIRATION_HOURS: 24
      JWT_ISSUER: collectoria-api
      LOG_LEVEL: info
    depends_on:
      postgres:
        condition: service_healthy
    networks:
      - collectoria-network
    healthcheck:
      test: ["CMD", "wget", "--quiet", "--tries=1", "-O", "/dev/null", "http://localhost:8080/api/v1/health"]
      interval: 30s
      timeout: 5s
      retries: 3
      start_period: 10s

  frontend:
    build:
      context: ./Frontend
      dockerfile: Dockerfile
    environment:
      NEXT_PUBLIC_API_URL: ${NEXT_PUBLIC_API_URL}
      NODE_ENV: production
    depends_on:
      backend:
        condition: service_healthy
    networks:
      - collectoria-network
    healthcheck:
      test: ["CMD", "wget", "--quiet", "--tries=1", "-O", "/dev/null", "http://localhost:3000/"]
      interval: 30s
      timeout: 5s
      retries: 3
      start_period: 15s

networks:
  collectoria-network:
    driver: bridge

volumes:
  postgres_data:
```

---

### Étape 4 : Test docker-compose Local

**Objectif** : Valider que docker-compose.prod.yml fonctionne localement AVANT de l'utiliser sur le serveur.

**Vérifications** :

- [ ] **Créer fichier .env local pour test** :
  ```bash
  cat > .env.test << EOF
  POSTGRES_USER=collectoria_test
  POSTGRES_PASSWORD=test123
  POSTGRES_DB=collection_management
  JWT_SECRET=collectoria-super-secret-jwt-key-64-chars-minimum-for-security-ok
  NEXT_PUBLIC_API_URL=http://localhost:8080
  EOF
  ```

- [ ] **Lancer docker-compose** :
  ```bash
  docker compose -f docker-compose.prod.yml --env-file .env.test up -d
  # Doit démarrer sans erreur
  ```

- [ ] **Vérifier tous les containers démarrés** :
  ```bash
  docker compose -f docker-compose.prod.yml ps
  # Tous les services doivent être "Up"
  ```

- [ ] **Attendre healthchecks (30-60 secondes)** :
  ```bash
  sleep 60
  docker compose -f docker-compose.prod.yml ps
  # Colonne STATUS doit afficher "healthy" pour tous les services
  ```

- [ ] **Tester healthcheck backend manuellement** :
  ```bash
  curl -s http://localhost:8080/api/v1/health
  # Doit retourner {"status":"healthy"} ou similaire
  ```

- [ ] **Tester healthcheck frontend manuellement** :
  ```bash
  curl -s http://localhost:3000/
  # Doit retourner HTML (pas d'erreur 500)
  ```

- [ ] **Vérifier logs (pas d'erreurs critiques)** :
  ```bash
  docker compose -f docker-compose.prod.yml logs backend | tail -20
  docker compose -f docker-compose.prod.yml logs frontend | tail -20
  # Pas d'erreurs rouges, panics, ou crashes
  ```

- [ ] **Arrêter environnement test** :
  ```bash
  docker compose -f docker-compose.prod.yml --env-file .env.test down
  # Nettoyage (volumes préservés si besoin)
  ```

**En cas d'erreur** :
1. Identifier le service en erreur : `docker compose -f docker-compose.prod.yml ps`
2. Consulter logs : `docker compose -f docker-compose.prod.yml logs [service]`
3. Corriger le problème (Dockerfile, docker-compose.yml, variables env)
4. Rebuild si nécessaire : `docker compose -f docker-compose.prod.yml build [service]`
5. Relancer : `docker compose -f docker-compose.prod.yml up -d`

---

### Étape 5 : Validation Finale

**Vérifications avant Phase 4** :

- [ ] **Script validate-healthchecks.sh OK** (si disponible) :
  ```bash
  bash DevOps/scripts/validate-healthchecks.sh
  # Doit retourner : ✅ Tous les healthchecks sont valides
  ```

- [ ] **Aucune erreur détectée dans les builds locaux** :
  ```bash
  # Vérifier images créées
  docker images | grep collectoria
  # Doit lister : collectoria-backend-test, collectoria-frontend-test
  ```

- [ ] **docker-compose.prod.yml testé et fonctionnel** :
  - Tous les containers healthy
  - Backend répond à /api/v1/health
  - Frontend répond sur port 3000

- [ ] **Fichiers commités dans Git** :
  ```bash
  git status
  # Vérifier que Dockerfiles et docker-compose.prod.yml sont trackés
  
  git add Backend/collection-management/Dockerfile
  git add Frontend/Dockerfile
  git add docker-compose.prod.yml
  
  git commit -m "Phase 3.5: Add production Dockerfiles and docker-compose
  
  - Backend Dockerfile with Go 1.23 and correct healthcheck (GET)
  - Frontend Dockerfile with Node 20 and Next.js build
  - docker-compose.prod.yml with postgres, backend, frontend
  - All healthchecks validated locally
  
  Co-Authored-By: Claude Sonnet 4.5 <noreply@anthropic.com>"
  
  git push origin main
  ```

- [ ] **Documentation mise à jour** (si nécessaire) :
  - README.md mentionne docker-compose.prod.yml
  - DevOps/CLAUDE.md référence Phase 3.5

- [ ] **Phase 4 peut maintenant commencer** :
  - Fichiers validés localement
  - Prêts à être utilisés sur le serveur
  - Risque d'erreur fortement réduit

---

## Résumé des Outputs

À la fin de Phase 3.5, vous devez avoir :

1. ✅ `Backend/collection-management/Dockerfile` (créé et testé)
2. ✅ `Frontend/Dockerfile` (créé et testé)
3. ✅ `docker-compose.prod.yml` (créé et testé)
4. ✅ Images Docker locales buildées avec succès
5. ✅ Test docker-compose local réussi (tous containers healthy)
6. ✅ Healthchecks validés (GET, pas HEAD)
7. ✅ Versions cohérentes (Go, Node)
8. ✅ Fichiers commités dans Git
9. ✅ Prêt pour Phase 4

---

## Template Checklist Rapide

Copier-coller ce template pour chaque déploiement :

```markdown
# Phase 3.5 Checklist - [Date]

## Dockerfile Backend
- [ ] Fichier existe
- [ ] Version Go cohérente (go.mod ↔ Dockerfile)
- [ ] Healthcheck GET (pas HEAD)
- [ ] Build local réussi

## Dockerfile Frontend
- [ ] Fichier existe
- [ ] Version Node cohérente
- [ ] Healthcheck GET
- [ ] Build local réussi

## docker-compose.prod.yml
- [ ] Fichier existe
- [ ] Services définis (postgres, backend, frontend)
- [ ] Healthchecks corrects
- [ ] Réseaux et volumes définis

## Tests Locaux
- [ ] docker-compose up réussi
- [ ] Tous containers healthy
- [ ] Backend /health répond 200
- [ ] Frontend répond 200

## Validation Finale
- [ ] validate-healthchecks.sh OK
- [ ] Fichiers commités Git
- [ ] Prêt pour Phase 4

Date validation : _______  
Validé par : _______
```

---

## Temps Estimés par Étape

| Étape | Temps | Notes |
|-------|-------|-------|
| Création Dockerfile Backend | 10 min | Si template disponible : 5 min |
| Build Backend Local | 3-5 min | Dépend connexion internet |
| Création Dockerfile Frontend | 10 min | Si template disponible : 5 min |
| Build Frontend Local | 5-10 min | npm install + Next.js build |
| Création docker-compose.prod.yml | 10 min | Si template disponible : 5 min |
| Test docker-compose Local | 5 min | + 2 min attente healthchecks |
| Validation Finale + Commit | 5 min | |
| **TOTAL** | **45-60 min** | **Investissement one-time** |

**Gain attendu** : Phase 4 réduite de 2h → 45-60 min (gain net : 60+ minutes)

---

## Problèmes Courants et Solutions

### Problème 1 : Build Backend échoue (version Go)

**Erreur** :
```
Error: go.mod requires go >= 1.23.0 (running go 1.21.13)
```

**Solution** :
```dockerfile
# Modifier Dockerfile
FROM golang:1.21-alpine  →  FROM golang:1.23-alpine
```

---

### Problème 2 : Healthcheck backend "unhealthy"

**Cause** : Endpoint n'accepte que GET, mais healthcheck utilise HEAD (`--spider`)

**Solution** :
```dockerfile
# Dockerfile et docker-compose.yml
HEALTHCHECK CMD wget --spider ...  ❌
HEALTHCHECK CMD wget -O /dev/null ... ✅
```

---

### Problème 3 : docker-compose ne trouve pas .env

**Cause** : Fichier nommé `.env.production` au lieu de `.env`

**Solution Option A** :
```bash
docker compose --env-file .env.production up -d
```

**Solution Option B (recommandée)** :
```bash
mv .env.production .env
docker compose up -d
```

---

### Problème 4 : Frontend build très lent

**Cause** : npm install télécharge toutes les dépendances

**Solution** :
- Normal lors du premier build (5-10 min)
- Builds suivants utilisent cache Docker (1-2 min)
- Optimisation : utiliser npm ci au lieu de npm install

---

## Références

- **Recommandation Complète** : `Continuous-Improvement/recommendations/devops-production-files-pre-deployment_2026-04-29.md`
- **Rapport Incident Phase 4** : `Continuous-Improvement/reports/2026-04-29_phase4-deployment-issues.md`
- **Script Validation Healthcheck** : `DevOps/scripts/validate-healthchecks.sh` (à créer)
- **Templates** : `DevOps/templates/` (Dockerfiles, docker-compose)

---

**Phase suivante** : Phase 4 - Déploiement Backend + Frontend (durée : 45-60 min si Phase 3.5 OK)
