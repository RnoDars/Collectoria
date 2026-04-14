# Architecture Cible Cloud - Collectoria

**Date** : 2026-04-14  
**Version** : 1.0  
**Usage** : Production / Staging

---

## Vue d'Ensemble

Architecture cloud scalable et production-ready pour Collectoria. Cette architecture est conçue pour :
- **Haute disponibilité**
- **Scalabilité horizontale**
- **Sécurité**
- **Coûts optimisés** (surtout pour MVP mono-utilisateur)

---

## Architecture Globale

```
                              ┌─────────────┐
                              │   Internet  │
                              └──────┬──────┘
                                     │
                              ┌──────▼──────┐
                              │     CDN     │
                              │  (Static)   │
                              └──────┬──────┘
                                     │
                    ┌────────────────┼────────────────┐
                    │                │                │
             ┌──────▼──────┐  ┌─────▼─────┐   ┌─────▼─────┐
             │   Frontend   │  │  Catalog  │   │Collection │
             │   (Next.js)  │  │  Service  │   │  Service  │
             │              │  │   (Go)    │   │   (Go)    │
             └──────────────┘  └─────┬─────┘   └─────┬─────┘
                                     │                │
                    ┌────────────────┼────────────────┘
                    │                │
             ┌──────▼──────┐  ┌─────▼─────┐   ┌──────────┐
             │  PostgreSQL  │  │PostgreSQL │   │  Kafka   │
             │  (Catalog)   │  │(Collection│   │(Optionnel│
             └──────────────┘  └───────────┘   └──────────┘
                    │                │
             ┌──────▼────────────────▼──────┐
             │       Object Storage         │
             │      (Backups, Images)       │
             └──────────────────────────────┘

                    Monitoring & Logs
             ┌────────────────────────────┐
             │  Prometheus + Grafana      │
             │  Logs (Loki / ELK)         │
             │  Tracing (Jaeger)          │
             └────────────────────────────┘
```

---

## Options Cloud Provider

### Option 1 : AWS (Amazon Web Services)

**Services** :
- **Compute** : ECS Fargate (microservices Go)
- **Frontend** : Amplify ou S3 + CloudFront
- **Database** : RDS PostgreSQL (2 instances)
- **Message Queue** : MSK (Managed Kafka) ou SQS
- **Storage** : S3 (images, backups)
- **Load Balancer** : ALB (Application Load Balancer)
- **Monitoring** : CloudWatch

**Coût Estimé MVP** (mono-utilisateur, trafic faible) :
- ECS Fargate (2 tasks 0.5 vCPU) : ~$30/mois
- RDS PostgreSQL t4g.micro x2 : ~$30/mois
- S3 + CloudFront : ~$5/mois
- ALB : ~$20/mois
- **Total : ~$85-100/mois**

**Avantages** :
- Écosystème complet
- Bonne documentation
- Free tier (12 mois pour nouveaux comptes)

**Inconvénients** :
- Complexité
- Coûts augmentent rapidement

---

### Option 2 : GCP (Google Cloud Platform)

**Services** :
- **Compute** : Cloud Run (microservices Go, serverless)
- **Frontend** : Firebase Hosting ou Cloud Storage + Cloud CDN
- **Database** : Cloud SQL PostgreSQL (2 instances)
- **Message Queue** : Pub/Sub ou Managed Kafka
- **Storage** : Cloud Storage (images, backups)
- **Load Balancer** : Cloud Load Balancing
- **Monitoring** : Cloud Monitoring

**Coût Estimé MVP** :
- Cloud Run (2 services) : ~$10-20/mois (pay per request)
- Cloud SQL db-f1-micro x2 : ~$20/mois
- Cloud Storage : ~$3/mois
- **Total : ~$35-50/mois**

**Avantages** :
- Cloud Run très économique pour faible trafic
- Free tier généreux
- Simplicité

**Inconvénients** :
- Moins de features que AWS

---

### Option 3 : Azure

**Services** :
- **Compute** : Container Instances ou App Service
- **Frontend** : Static Web Apps
- **Database** : Azure Database for PostgreSQL (2 instances)
- **Message Queue** : Event Hubs ou Service Bus
- **Storage** : Blob Storage
- **Monitoring** : Azure Monitor

**Coût Estimé MVP** :
- Container Instances : ~$30/mois
- PostgreSQL Basic : ~$30/mois
- Static Web Apps : Gratuit
- **Total : ~$60-80/mois**

---

### Option 4 : Solutions Low-Cost (Recommandé pour MVP)

#### Fly.io (Recommandé ⭐)

**Services** :
- **Compute** : Fly Machines (microservices Go)
- **Database** : Fly Postgres (managed PostgreSQL)
- **Storage** : Fly Volumes
- **Global deployment**

**Coût Estimé MVP** :
- 2 VM shared-cpu-1x (256MB) : Gratuit (3 VM)
- PostgreSQL shared : ~$5/mois
- **Total : ~$5-10/mois**

**Free Tier** :
- 3 machines shared-cpu-1x
- 3 GB volumes
- 160 GB transfer/mois

**Avantages** :
- Très économique
- Simple à déployer (flyctl)
- Bon pour MVP
- Scale facilement plus tard

**Inconvénients** :
- Moins de services que AWS/GCP
- Communauté plus petite

---

#### Render.com

**Services** :
- **Compute** : Web Services (microservices Go)
- **Database** : Managed PostgreSQL
- **Frontend** : Static Sites
- **Automatic SSL**

**Coût Estimé MVP** :
- 2 Web Services (starter) : ~$14/mois
- PostgreSQL (starter) : ~$7/mois
- Static site : Gratuit
- **Total : ~$20-25/mois**

**Free Tier** :
- Web Services (limité, sleep après inactivité)
- PostgreSQL 90 jours gratuit puis $7/mois
- Static Sites illimités

---

#### Railway

**Services** :
- **Compute** : Services (Docker)
- **Database** : PostgreSQL
- **Simple deployment**

**Coût Estimé MVP** :
- $5 crédit/mois gratuit
- Usage-based au-delà
- **Total : ~$5-10/mois**

---

## Architecture Détaillée (Exemple avec Fly.io)

### Infrastructure

```yaml
# fly.toml - catalog-service
app = "collectoria-catalog"

[build]
  dockerfile = "./services/catalog-service/Dockerfile"

[[services]]
  internal_port = 8081
  protocol = "tcp"

  [[services.ports]]
    handlers = ["http"]
    port = 80

  [[services.ports]]
    handlers = ["tls", "http"]
    port = 443

[env]
  ENVIRONMENT = "production"
  LOG_LEVEL = "info"

[mounts]
  source = "catalog_data"
  destination = "/data"
```

### Bases de Données

**Option A : 2 PostgreSQL séparés** (Microservices pattern)
```bash
# Créer catalog-db
flyctl postgres create --name collectoria-catalog-db --region cdg

# Créer collection-db
flyctl postgres create --name collectoria-collection-db --region cdg

# Attacher aux apps
flyctl postgres attach collectoria-catalog-db -a collectoria-catalog
flyctl postgres attach collectoria-collection-db -a collectoria-collection
```

**Option B : 1 PostgreSQL avec 2 databases** (Économique pour MVP)
```bash
# Créer une instance
flyctl postgres create --name collectoria-db --region cdg

# Créer 2 databases
flyctl ssh console -a collectoria-db
psql -U postgres
CREATE DATABASE catalog;
CREATE DATABASE collection;
```

### Frontend Next.js

**Option A : SSR sur Fly.io**
```bash
# Deploy Next.js avec SSR
flyctl launch --dockerfile frontend/Dockerfile
```

**Option B : Static Export + CDN** (Recommandé pour MVP)
```bash
# Build static
cd frontend
npm run build
npm run export  # out/

# Deploy sur Vercel (gratuit)
vercel --prod

# Ou Cloudflare Pages (gratuit)
# Ou Netlify (gratuit)
```

---

## CI/CD Pipeline

### GitHub Actions

```yaml
# .github/workflows/deploy-catalog-service.yml
name: Deploy Catalog Service

on:
  push:
    branches: [main]
    paths:
      - 'services/catalog-service/**'

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      
      - name: Setup Flyctl
        uses: superfly/flyctl-actions/setup-flyctl@master
      
      - name: Deploy to Fly.io
        run: |
          cd services/catalog-service
          flyctl deploy --remote-only
        env:
          FLY_API_TOKEN: ${{ secrets.FLY_API_TOKEN }}
```

### Déploiement Manuel

```bash
# Catalog Service
cd services/catalog-service
flyctl deploy

# Collection Service
cd services/collection-service
flyctl deploy

# Frontend (Vercel)
cd frontend
vercel --prod
```

---

## Sécurité

### Secrets Management

```bash
# Fly.io secrets
flyctl secrets set DATABASE_URL="postgres://..." -a collectoria-catalog
flyctl secrets set JWT_SECRET="..." -a collectoria-catalog

# GitHub Secrets
# Via UI : Settings → Secrets → New repository secret
```

### Network Security

- **Private networking** : Services communiquent via réseau privé Fly.io
- **TLS/SSL** : Automatique avec Fly.io et Vercel
- **CORS** : Configuré dans les services Go
- **Rate Limiting** : Implémenté dans les services

### Database Security

- **SSL required** : Connections chiffrées
- **Passwords** : Secrets management
- **Backups** : Automatiques daily
- **IP Whitelist** : Si nécessaire

---

## Monitoring & Observabilité

### Logs

**Fly.io** :
```bash
# Logs en temps réel
flyctl logs -a collectoria-catalog

# Logs historiques
flyctl logs -a collectoria-catalog --since 1h
```

**Agrégation** :
- Fly.io → Logflare (intégration native)
- Ou export vers Loki, Datadog, etc.

### Métriques

**Prometheus + Grafana** :
- Exposer `/metrics` dans chaque service Go
- Scraping par Prometheus
- Dashboards Grafana

**Fly.io Metrics** :
- CPU, RAM, Network inclus
- Dashboard intégré

### Tracing

**OpenTelemetry** :
- Instrumenter les services Go
- Export vers Jaeger ou Honeycomb

---

## Scalabilité

### Horizontal Scaling

```bash
# Scaler catalog-service
flyctl scale count 3 -a collectoria-catalog

# Scaler par région
flyctl scale count 2 --region cdg -a collectoria-catalog
flyctl scale count 1 --region ams -a collectoria-catalog
```

### Vertical Scaling

```bash
# Augmenter les ressources
flyctl scale vm shared-cpu-2x -a collectoria-catalog
flyctl scale memory 512 -a collectoria-catalog
```

### Database Scaling

```bash
# PostgreSQL read replicas
flyctl postgres create --name collectoria-catalog-db-replica \
  --fork-from collectoria-catalog-db
```

---

## Backups & Disaster Recovery

### Database Backups

**Automatiques** :
- Fly.io PostgreSQL : Daily backups (30 jours de rétention)
- Snapshots manuels possibles

**Manuels** :
```bash
# Backup
flyctl ssh console -a collectoria-catalog-db
pg_dump -U postgres catalog > backup.sql

# Ou via script automatisé
```

### Application Backups

- **Code** : Git (GitHub)
- **Configuration** : fly.toml dans Git
- **Secrets** : Documented (pas dans Git)
- **Images** : Object storage (S3/R2) avec versioning

### Disaster Recovery Plan

1. **Database restore** : Depuis backup (RTO : 1h)
2. **Service redeploy** : Depuis Git (RTO : 10 min)
3. **Frontend redeploy** : Depuis Vercel/Git (RTO : 5 min)

---

## Coûts Optimisés pour MVP

### Configuration Recommandée

**Phase 1 : MVP Mono-Utilisateur** (~$10-20/mois)

```
Frontend:
  - Vercel (gratuit) ou Cloudflare Pages (gratuit)
  
Backend:
  - Fly.io :
    * 2 services Go (shared-cpu-1x 256MB) : Gratuit (free tier)
    * 1 PostgreSQL shared : $5/mois
    * Total : $5-10/mois

Alternative: Render.com ($20-25/mois) si préférence interface web
```

**Phase 2 : Multi-Utilisateurs** (~$50-100/mois)

```
Frontend:
  - Vercel Pro ($20/mois) ou self-hosted
  
Backend:
  - Fly.io :
    * 2 services (shared-cpu-2x 512MB) : $15/mois
    * 2 PostgreSQL (small dedicated) : $30/mois
    * Kafka (si nécessaire) : $20/mois
    * Total : $65-85/mois
```

**Phase 3 : Production Scalée** (~$200-500/mois)

```
- Cloud provider majeur (AWS/GCP/Azure)
- Multi-region
- Load balancing
- CDN premium
- Monitoring avancé
```

---

## Migration Path

### Étape 1 : Local → Fly.io (MVP)
1. Développer en local (docker-compose)
2. Tester localement
3. Deploy sur Fly.io (flyctl deploy)
4. Tester en production

### Étape 2 : Fly.io → AWS/GCP (Scale)
1. Conteneuriser services (déjà fait avec Docker)
2. Setup Kubernetes ou ECS
3. Migrer databases avec downtime minimal
4. Switch DNS progressivement
5. Monitoring et validation

---

## Recommandation Finale

### Pour Commencer (Maintenant)

1. **Local Development** : docker-compose (gratuit)
2. **MVP Deployment** : Fly.io ($5-10/mois)
3. **Frontend** : Vercel (gratuit)

**Pourquoi ?**
- Coût minimal
- Setup simple
- Scale facilement plus tard
- Bon pour apprendre

### Pour Scale (Plus tard)

Quand vous aurez :
- 100+ utilisateurs actifs
- Besoin de multi-region
- SLA stricts

→ Migrer vers AWS/GCP avec Kubernetes

---

## Checklist Déploiement Initial

- [ ] Créer compte Fly.io
- [ ] Installer flyctl : `brew install flyctl` ou `curl -L https://fly.io/install.sh | sh`
- [ ] Login : `flyctl auth login`
- [ ] Créer PostgreSQL : `flyctl postgres create`
- [ ] Deploy catalog-service : `flyctl launch`
- [ ] Deploy collection-service : `flyctl launch`
- [ ] Configurer secrets
- [ ] Setup GitHub Actions CI/CD
- [ ] Deploy frontend sur Vercel
- [ ] Configurer domaine custom (optionnel)
- [ ] Setup monitoring (Grafana Cloud gratuit)
- [ ] Tester end-to-end
- [ ] Import données initiales

---

## Ressources

- [Fly.io Documentation](https://fly.io/docs/)
- [Vercel Documentation](https://vercel.com/docs)
- [AWS Free Tier](https://aws.amazon.com/free/)
- [GCP Free Tier](https://cloud.google.com/free)
- [Render Documentation](https://render.com/docs)
- [Railway Documentation](https://docs.railway.app/)

---

**Note** : Cette architecture est **évolutive**. Commencez simple (Fly.io), puis migrez vers des solutions plus robustes quand le besoin s'en fait sentir.
