# Tâches : Intégration du Stack Technique dans les Skills des Agents

**Date de création** : 2026-04-14
**Statut** : Terminé
**Priorité** : Haute

## Objectif
Intégrer les choix techniques du projet dans les skills (CLAUDE.md) de tous les agents concernés pour qu'ils disposent du contexte nécessaire à leurs tâches.

## Contexte Technique Défini

### Stack Technique
- **Backend** : Golang (microservices)
- **Frontend** : Next.js (React + TypeScript)
- **Base de données** : PostgreSQL
- **Communication synchrone** : API REST avec contrats OpenAPI
- **Communication asynchrone** : Apache Kafka
- **Méthodologie** : Test Driven Development (TDD)
- **Architecture** : Domain Driven Design (DDD)

## Agents Mis à Jour

### 1. Alfred (Agent Principal) ✅
**Fichier** : `CLAUDE.md` (racine)
**Ajouts** :
- Section "Contexte Technique du Projet" avec stack complet
- Principes architecturaux (Microservices, DDD, Clean Architecture, TDD)
- Mise à jour des descriptions des agents avec technologies spécifiques

### 2. Agent Backend ✅
**Fichier** : `Backend/CLAUDE.md`
**Ajouts majeurs** :
- Stack technique détaillé (Go, PostgreSQL, Kafka)
- Principes DDD complets (Bounded Contexts, Entities, Value Objects, Aggregates, Domain Events, Repositories, Services)
- Structure d'un microservice Go (architecture en couches)
- Conventions Go (gofmt, golint, idiomes Go)
- Architecture Clean Architecture et Hexagonal
- Pratiques TDD (Red-Green-Refactor)
- Stratégie de tests (unitaires, intégration, E2E, mocks)
- Guidelines API REST (versioning, OpenAPI, codes HTTP)
- Best practices PostgreSQL (migrations, transactions, indexes)
- Best practices Kafka (schémas, idempotence, DLQ, monitoring)
- Outils et bibliothèques recommandés (Gin/Echo, pgx, sarama, testify, gomock, testcontainers)

### 3. Agent Frontend ✅
**Fichier** : `Frontend/CLAUDE.md`
**Ajouts majeurs** :
- Stack technique (Next.js, TypeScript)
- Communication backend (API REST, génération types depuis OpenAPI)
- Méthodologie TDD et Component-Driven Development
- Structure Next.js complète (App Router, app/, components/, lib/, types/)
- Outils recommandés :
  - Génération code : openapi-typescript, openapi-fetch
  - Data fetching : SWR/React Query
  - Formulaires : React Hook Form, Zod
  - Testing : Vitest, Testing Library, Playwright, MSW
  - Styling options : Tailwind CSS, CSS Modules, styled-components
  - Storybook pour composants isolés

### 4. Agent Testing ✅
**Fichier** : `Testing/CLAUDE.md`
**Ajouts majeurs** :
- **TDD comme méthodologie OBLIGATOIRE**
- Cycle TDD détaillé (Red-Green-Refactor)
- Frameworks par couche :
  - Backend Go : testing natif, testify, gomock, httptest, testcontainers-go
  - Frontend : Vitest, Testing Library, Playwright, MSW
  - Integration/E2E : Playwright, Postman, K6
- Stratégie pour architecture microservices :
  - Tests unitaires (~70%)
  - Tests d'intégration (~20%)
  - Tests E2E (~10%)
- Détails par type :
  - Backend : domaine, services, repositories avec PostgreSQL/Kafka réels
  - Frontend : hooks, composants, E2E
- Conventions : AAA pattern, isolation, déterminisme, 80% couverture
- Tests spécifiques microservices : contract testing, tests d'isolation
- Structure de tests par microservice et globale

### 5. Agent DevOps ✅
**Fichier** : `DevOps/CLAUDE.md`
**Ajouts majeurs** :
- Architecture cible (Microservices, Event-Driven)
- Composants infrastructure détaillés :
  - Multiple microservices Go indépendants
  - PostgreSQL (database per service)
  - Apache Kafka (topics, consumer groups)
  - Next.js séparé
- Outils :
  - Conteneurisation : Docker, Docker Compose
  - Orchestration : Kubernetes, Docker Swarm
  - CI/CD : GitHub Actions, GitLab CI
  - IaC : Terraform, Kubernetes manifests, Helm
  - Cloud : AWS/GCP/Azure options
  - Monitoring : Prometheus, Grafana, Loki/ELK, Jaeger, OpenTelemetry
- Structure repository complète (services/, infra/terraform, infra/kubernetes)
- Pipelines CI/CD détaillés pour backend et frontend
- Stratégies de déploiement (Blue-Green, Canary, Rolling)
- Best practices migrations DB et Kafka Schema Registry

### 6. Agent Spécifications ✅
**Fichier** : `Specifications/CLAUDE.md`
**Ajouts majeurs** :
- Section "Contexte Technique du Projet"
- **Domain Driven Design dans les specs** :
  - Bounded Context identification
  - Ubiquitous Language
  - Building Blocks DDD (Entities, Value Objects, Aggregates, Domain Events, Services, Repositories)
  - Contrats entre Bounded Contexts (API REST, Events Kafka)
- Templates de specs par type :
  - **Spec Microservice (Backend)** : Bounded Context, Ubiquitous Language, Aggregates, Domain Events, API REST, Events Kafka, Repository, Tests TDD
  - **Spec Feature Frontend** : User Story, Composants UI, API REST consommées, États & Flows, Tests TDD
  - **Spec Communication Inter-Services** : Type (REST/Kafka), Contrat API, Events, Schémas, Gestion erreurs

### 7. Agent Documentation ✅
**Fichier** : `Documentation/CLAUDE.md`
**Ajouts majeurs** :
- Section "Contexte Technique du Projet"
- Implications pour la documentation (Microservices, DDD, Contrats, TDD)
- Structure complète :
  - `docs/architecture/` avec microservices/, ddd/, adr/, diagrams/
  - `docs/api/` avec openapi/, kafka/events/, rest-guidelines.md
  - `docs/development/` avec tdd-guidelines.md, conventions Go/Next.js
  - `docs/guides/`, `docs/deployment/`, `docs/operations/`
- **Documentation spécifique microservices** : Template standardisé avec Bounded Context, Ubiquitous Language, Architecture Interne, API REST, Events Kafka, Base de Données, Dépendances, Monitoring
- **Architecture Decision Records (ADR)** : Format standard

## Statistiques

- **7 agents mis à jour**
- **7 fichiers CLAUDE.md modifiés**
- **Concepts ajoutés** :
  - Domain Driven Design (DDD) : 6 concepts principaux
  - Test Driven Development (TDD) : Cycle complet
  - Microservices : Architecture complète
  - Technologies : Go, Next.js, PostgreSQL, Kafka, OpenAPI
  - Outils : ~20 outils et bibliothèques recommandés

## Bénéfices

### Pour les Agents
- Contexte technique complet dans leurs compétences
- Capacité à prendre des décisions architecturales alignées
- Connaissance des outils et best practices du projet
- Templates et structures standardisés

### Pour le Projet
- Cohérence technique entre tous les agents
- Décisions architecturales documentées dès le départ
- Standards de qualité définis (TDD, DDD, tests)
- Base solide pour le développement

## Prochaines Étapes

1. **Première spécification** : Créer une spec de fonctionnalité complète en utilisant les nouveaux templates DDD
2. **Premier microservice** : Implémenter un microservice de référence suivant l'architecture définie
3. **Documentation initiale** : Créer la structure de documentation et le premier ADR
4. **Setup DevOps** : Mettre en place le docker-compose local et les premières pipelines CI/CD
5. **Consultation Amélioration Continue** : Valider que les ajouts aux CLAUDE.md sont bien structurés

## Notes

- Tous les agents ont maintenant une compréhension commune de l'architecture
- Les templates de spécifications intègrent les concepts DDD
- La méthodologie TDD est clairement établie comme obligatoire
- Les outils recommandés sont cohérents entre les agents
- La documentation est structurée pour supporter l'architecture microservices/DDD
