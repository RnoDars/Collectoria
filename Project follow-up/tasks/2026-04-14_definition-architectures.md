# Tâches : Définition des Architectures (Locale & Cloud)

**Date de création** : 2026-04-14  
**Statut** : Terminé  
**Priorité** : Haute

## Objectif
Définir deux architectures pour Collectoria :
1. **Architecture Locale** : Développement sur laptop/desktop
2. **Architecture Cible Cloud** : Production/Staging

## Contexte

L'utilisateur dispose d'un NAS Synology DS411J mais celui-ci est trop limité :
- RAM : 128 MB (non extensible)
- CPU : ARM Marvell 88F6281 800MHz (2010)
- Pas de support Docker moderne

**Décision** : Travailler en local pour le développement, déployer sur cloud pour la production.

## Architecture Locale de Développement

**Fichier** : `Documentation/development/local-development-setup.md`

### Vue d'Ensemble

```
Machine Locale (Laptop/Desktop)
├── Frontend (Next.js) - Port 3000
├── Catalog Service (Go) - Port 8081
├── Collection Service (Go) - Port 8082
└── Docker Compose
    ├── PostgreSQL catalog-db - Port 5432
    ├── PostgreSQL collection-db - Port 5433
    ├── Kafka (optionnel)
    └── PgAdmin (optionnel)
```

### Prérequis

**Logiciels** :
- Docker Desktop
- Go 1.21+
- Node.js 20+ (LTS)
- Git ✅
- IDE (VS Code recommandé)

**Ressources** :
- RAM : 8 GB minimum (16 GB recommandé)
- CPU : 4 cores minimum
- Disque : 10 GB

### Configuration Créée

**docker-compose.yml** :
- 2 instances PostgreSQL (ports 5432 et 5433)
- Kafka + Zookeeper (commenté, optionnel)
- PgAdmin (profile tools)
- Networks et volumes configurés
- Health checks inclus

**.env.example** :
- Variables d'environnement pour tous les services
- Ports configurables
- Connexions databases
- URLs API

### Commandes Clés

```bash
# Infrastructure
docker compose up -d catalog-db collection-db

# Services Go
cd services/catalog-service && go run cmd/server/main.go
cd services/collection-service && go run cmd/server/main.go

# Frontend
cd frontend && npm run dev

# Import données
scripts/import-data.sh
```

### Debugging

- VS Code launch.json fournie
- Logs structurés (zerolog)
- Hot reload avec Air (Go)
- Fast refresh Next.js (Turbopack)

### Ressources Typiques

- Docker (PostgreSQL x2) : 300-500 MB RAM
- Catalog Service : 50-100 MB RAM
- Collection Service : 50-100 MB RAM
- Frontend dev : 200-400 MB RAM
- **Total : 600 MB - 1 GB RAM**

### Avantages

✅ Développement local complet
✅ Pas de dépendance cloud
✅ Tests rapides
✅ Debugging facile
✅ Gratuit
✅ Code identique à la prod

## Architecture Cible Cloud

**Fichier** : `Documentation/architecture/target-cloud-architecture.md`

### Options Évaluées

#### 1. AWS (Amazon Web Services)
- **Services** : ECS Fargate, RDS, S3, CloudFront, ALB
- **Coût MVP** : ~$85-100/mois
- **Avantages** : Écosystème complet, mature
- **Inconvénients** : Complexité, coûts élevés

#### 2. GCP (Google Cloud Platform)
- **Services** : Cloud Run, Cloud SQL, Cloud Storage, CDN
- **Coût MVP** : ~$35-50/mois
- **Avantages** : Cloud Run économique, simple
- **Inconvénients** : Moins de features qu'AWS

#### 3. Azure
- **Services** : Container Instances, PostgreSQL, Static Web Apps
- **Coût MVP** : ~$60-80/mois
- **Avantages** : Intégration Microsoft
- **Inconvénients** : Plus cher que GCP

#### 4. Fly.io ⭐ (Recommandé)
- **Services** : Fly Machines, Fly Postgres, Global CDN
- **Coût MVP** : ~$5-10/mois
- **Avantages** : 
  - Très économique (3 VM gratuites)
  - Simple (flyctl)
  - Scale facilement
  - Parfait pour MVP
- **Inconvénients** : Moins de services que AWS/GCP

#### 5. Render.com
- **Services** : Web Services, PostgreSQL, Static Sites
- **Coût MVP** : ~$20-25/mois
- **Avantages** : Interface simple, SSL automatique
- **Free Tier** : Limité (sleep après inactivité)

#### 6. Railway
- **Services** : Docker services, PostgreSQL
- **Coût MVP** : ~$5-10/mois
- **Avantages** : $5 crédit/mois gratuit, simple

### Architecture Recommandée (Fly.io)

```
Internet
  ↓
CDN (Cloudflare/Vercel)
  ↓
Frontend (Next.js static - Vercel gratuit)
  ↓
API Gateway / Load Balancer (Fly.io)
  ↓
┌────────────────┬────────────────┐
│ Catalog Service│Collection Svc  │
│ (Fly.io VM)    │ (Fly.io VM)    │
└────────┬───────┴────────┬───────┘
         │                │
    PostgreSQL        PostgreSQL
    (Fly Postgres)    (Fly Postgres)
         │                │
    Object Storage (S3/R2)
```

### Configuration Déploiement

**Fly.io** :
- `fly.toml` par service
- Secrets management intégré
- SSL/TLS automatique
- Multi-region facile
- Metrics et logs inclus

**CI/CD** :
- GitHub Actions workflows
- Deploy automatique sur push main
- Tests avant deploy
- Rollback facile

### Sécurité

- TLS/SSL automatique
- Private networking entre services
- Secrets management (Fly.io secrets)
- CORS configuré
- Rate limiting
- Database SSL required

### Monitoring

**Logs** :
- `flyctl logs` en temps réel
- Agrégation Logflare
- Export vers Loki/Datadog possibles

**Métriques** :
- Prometheus `/metrics` exposés
- Grafana dashboards
- Fly.io metrics intégrés (CPU, RAM, Network)

**Tracing** :
- OpenTelemetry instrumenté
- Export vers Jaeger/Honeycomb

### Scalabilité

**Horizontal** :
```bash
flyctl scale count 3 -a collectoria-catalog
```

**Vertical** :
```bash
flyctl scale vm shared-cpu-2x -a collectoria-catalog
flyctl scale memory 512 -a collectoria-catalog
```

**Multi-region** :
```bash
flyctl scale count 2 --region cdg
flyctl scale count 1 --region ams
```

### Backups

- PostgreSQL : Daily automated backups (30 jours)
- Code : Git (GitHub)
- Secrets : Documented
- Images : Object storage avec versioning

### Coûts Optimisés

**Phase 1 : MVP Mono-Utilisateur** ($5-10/mois)
- Frontend : Vercel (gratuit)
- Backend : Fly.io (3 VM gratuites)
- Database : Fly PostgreSQL shared ($5/mois)

**Phase 2 : Multi-Utilisateurs** ($50-100/mois)
- Frontend : Vercel Pro ($20/mois)
- Backend : Fly.io VM scaled
- Database : Dedicated PostgreSQL
- Kafka si nécessaire

**Phase 3 : Production Scalée** ($200-500/mois)
- Migration vers AWS/GCP/Azure
- Multi-region
- Load balancing
- CDN premium
- Monitoring avancé

## Migration Path

### Étape 1 : Local → Fly.io (MVP) - MAINTENANT

1. ✅ Développer en local (docker-compose)
2. 🔜 Tester localement
3. 🔜 Deploy sur Fly.io
4. 🔜 Tester en production

### Étape 2 : Fly.io → AWS/GCP - SI NÉCESSAIRE (100+ users)

1. Conteneuriser (déjà fait)
2. Setup Kubernetes/ECS
3. Migrer databases
4. Switch DNS progressivement
5. Monitoring et validation

## Recommandation Finale

### Pour Commencer (Maintenant)

**Stack recommandé** :
1. **Local Development** : Docker Compose (gratuit)
2. **MVP Deployment** : Fly.io ($5-10/mois)
3. **Frontend** : Vercel (gratuit)
4. **Monitoring** : Grafana Cloud (gratuit tier)

**Pourquoi ?**
- Coût minimal ($5-10/mois vs $100+/mois)
- Setup simple et rapide
- Scale facilement plus tard
- Bon pour apprendre et itérer
- Code portable (Docker)

### Pour Scale (6-12 mois)

Quand vous aurez :
- 100+ utilisateurs actifs
- Besoin multi-region
- SLA stricts (99.9%+)
- Trafic élevé

→ Migrer vers AWS/GCP avec Kubernetes

## Checklist Setup Local (Immédiat)

- [ ] Installer Docker Desktop
- [ ] Installer Go 1.21+
- [ ] Installer Node.js 20+
- [ ] Cloner repository
- [ ] Copier .env.example → .env
- [ ] Lancer `docker compose up -d`
- [ ] Vérifier PostgreSQL : `docker compose ps`
- [ ] Tester connexion databases
- [ ] Setup VS Code (extensions, launch.json)
- [ ] Lire documentation complète

## Checklist Setup Cloud (Plus tard)

- [ ] Créer compte Fly.io
- [ ] Installer flyctl
- [ ] Login : `flyctl auth login`
- [ ] Créer PostgreSQL : `flyctl postgres create`
- [ ] Deploy catalog-service
- [ ] Deploy collection-service
- [ ] Configurer secrets
- [ ] Setup GitHub Actions CI/CD
- [ ] Deploy frontend sur Vercel
- [ ] Configurer domaine custom
- [ ] Setup monitoring (Grafana)
- [ ] Tests end-to-end production
- [ ] Import données initiales

## Fichiers Créés

1. `Documentation/development/local-development-setup.md` (400+ lignes)
   - Architecture complète locale
   - docker-compose.yml complet
   - .env.example
   - Commandes de démarrage
   - Debugging configuration
   - Troubleshooting

2. `Documentation/architecture/target-cloud-architecture.md` (500+ lignes)
   - 6 options cloud évaluées
   - Architecture détaillée Fly.io
   - Coûts par phase
   - CI/CD configuration
   - Monitoring et observabilité
   - Scalabilité
   - Backups et DR
   - Migration path

## Décisions Architecturales

### Infrastructure
- ✅ NAS Synology DS411J : Trop limité, ne sera pas utilisé
- ✅ Dev Local : Docker Compose sur laptop/desktop
- ✅ Cloud MVP : Fly.io ($5-10/mois)
- ✅ Frontend : Vercel (gratuit)
- ✅ Monitoring : Grafana Cloud (gratuit tier)

### Base de Données
- ✅ PostgreSQL (2 instances séparées : database per service)
- ✅ Local : Docker containers
- ✅ Cloud : Fly Postgres managed

### Communication
- ✅ REST API (OpenAPI)
- ✅ Kafka : Optionnel pour MVP (peut être ajouté plus tard)

### Frontend
- ✅ Next.js static export pour MVP (économique)
- ✅ SSR peut être activé plus tard si nécessaire

## Prochaines Actions

### Immédiat (Sprint 1)
1. 🔜 Setup local development (suivre le guide)
2. 🔜 Vérifier que tout fonctionne
3. 🔜 Créer structure projet (services/, frontend/)
4. 🔜 Setup Go modules
5. 🔜 Setup Next.js project
6. 🔜 Créer premiers ADR

### Court Terme (Sprint 2-3)
1. Implémenter domain layer
2. Implémenter repositories
3. Implémenter API REST
4. Implémenter frontend basique
5. Tests E2E locaux

### Moyen Terme (Sprint 4+)
1. Deploy sur Fly.io
2. Import données production
3. Tests en production
4. Setup monitoring
5. Documentation utilisateur

## Notes

### Portabilité
Le code développé localement avec Docker Compose est **100% portable** vers Fly.io, AWS, GCP ou Azure. Les services sont conteneurisés et respectent les standards.

### Coûts
- **Local** : Gratuit (électricité uniquement)
- **MVP Cloud** : $5-10/mois (Fly.io + Vercel gratuit)
- **Production** : Selon usage, starting $50/mois

### Évolution
L'architecture peut évoluer progressivement :
- Phase 1 : Local dev
- Phase 2 : Fly.io MVP (1 utilisateur)
- Phase 3 : Fly.io scaled (10-100 utilisateurs)
- Phase 4 : AWS/GCP (100+ utilisateurs)

Chaque phase est compatible avec la précédente (pas de refonte).
