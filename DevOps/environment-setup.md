# Configuration de l'Environnement - DevOps

**Référence** : Ce document est extrait de `DevOps/CLAUDE.md` pour améliorer la lisibilité.

---

## Architecture Cible

### Type d'Architecture
- **Microservices** : Architecture distribuée avec plusieurs services Go indépendants
- **Frontend** : Application Next.js séparée
- **Event-Driven** : Communication asynchrone via Kafka

---

### Composants Infrastructure

#### Services Backend
- Multiple microservices Go (un par bounded context DDD)
- Chaque service : indépendamment déployable et scalable

#### Base de Données
- **PostgreSQL** : Une instance par microservice (database per service pattern)
- Ou une instance PostgreSQL avec schémas séparés par service

#### Message Broker
- **Apache Kafka** : Communication asynchrone entre microservices
- Topics par type d'événement métier
- Consumer groups pour scalabilité

#### Frontend
- **Next.js** : Application React déployée séparément
- SSR/SSG selon les besoins

---

## Outils et Technologies

### Conteneurisation
- **Docker** : Conteneurisation des services
- **Docker Compose** : Développement local et tests

### Orchestration (à choisir selon contexte)
- **Kubernetes** : Production, scaling automatique
- **Docker Swarm** : Alternative plus simple
- **Cloud-native** : ECS, Cloud Run, App Engine

### CI/CD
- **GitHub Actions** : Pipeline CI/CD (recommandé)
- **GitLab CI** : Alternative

### Infrastructure as Code
- **Terraform** : Provisioning infrastructure cloud
- **Kubernetes manifests** : Configuration K8s
- **Helm** : Package manager pour K8s (optionnel)

### Cloud Provider (à choisir)
- **AWS** : EKS, RDS, MSK (Kafka)
- **GCP** : GKE, Cloud SQL, Pub/Sub
- **Azure** : AKS, Azure Database

### Monitoring & Observabilité
- **Prometheus** : Métriques
- **Grafana** : Dashboards
- **Loki** ou **ELK** : Logs centralisés
- **Jaeger** ou **Tempo** : Tracing distribué
- **OpenTelemetry** : Standard observabilité

---

## Conventions

- Infrastructure as Code (IaC)
- Principe du 12-factor app
- Déploiements zero-downtime
- Versioning des configurations
- Documentation des procédures

---

## Structure Recommandée

### Repository Root
```
collectoria/
├── .github/
│   └── workflows/
│       ├── backend-service-*.yml    # CI/CD par microservice
│       ├── frontend.yml             # CI/CD frontend
│       └── infra.yml                # Déploiement infrastructure
├── services/
│   ├── user-service/
│   │   ├── Dockerfile
│   │   └── ...
│   ├── order-service/
│   │   ├── Dockerfile
│   │   └── ...
│   └── ...
├── frontend/
│   ├── Dockerfile
│   └── ...
├── infra/
│   ├── terraform/                   # IaC Terraform
│   │   ├── modules/
│   │   ├── environments/
│   │   │   ├── dev/
│   │   │   ├── staging/
│   │   │   └── prod/
│   │   └── ...
│   ├── kubernetes/                  # Manifests K8s
│   │   ├── base/                    # Kustomize base
│   │   ├── overlays/
│   │   │   ├── dev/
│   │   │   ├── staging/
│   │   │   └── prod/
│   │   └── helm/                    # Charts Helm (optionnel)
│   └── monitoring/                  # Config Prometheus, Grafana
├── docker-compose.yml               # Développement local
├── docker-compose.test.yml          # Tests d'intégration
└── scripts/
    ├── deploy.sh
    ├── migrate.sh
    └── ...
```

---

## Pipeline CI/CD Type

### Backend (par microservice)
```yaml
1. Trigger: Push sur main ou PR
2. Lint: golangci-lint
3. Test: 
   - Tests unitaires (go test)
   - Tests d'intégration (testcontainers)
   - Coverage check (>80%)
4. Build: Docker image
5. Security: Scan vulnérabilités (Trivy)
6. Push: Registry Docker
7. Deploy:
   - Dev: Auto-deploy
   - Staging: Auto-deploy après tests
   - Prod: Manuel approval
```

---

### Frontend
```yaml
1. Trigger: Push sur main ou PR
2. Lint: ESLint, TypeScript
3. Test:
   - Tests unitaires (Vitest)
   - Tests composants (Testing Library)
4. Build: next build
5. Test E2E: Playwright (si staging)
6. Deploy:
   - Dev: Auto
   - Prod: Manuel approval
```

---

## Stratégies de Déploiement

### Microservices
- **Blue-Green** : Deux versions simultanées, switch instantané
- **Canary** : Déploiement progressif (5% → 50% → 100%)
- **Rolling Update** : Mise à jour progressive des instances

### Base de Données
- **Migrations** : Automatisées mais validées
- **Backward compatibility** : Migrations compatibles avec version N-1
- **Rollback plan** : Toujours prévoir un rollback

### Kafka
- **Schema Registry** : Versioning des schémas de messages
- **Backward compatibility** : Évolutions de schémas compatibles

---

*Document extrait de DevOps/CLAUDE.md le 2026-04-23*
