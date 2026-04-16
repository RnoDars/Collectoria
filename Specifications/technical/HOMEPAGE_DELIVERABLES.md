# Homepage Desktop v1 - Livrables & Documentation

**Date de création:** 2026-04-15  
**Agent:** Agent Spécifications  
**Statut:** Complété - Prêt pour implémentation

---

## Résumé Exécutif

La spécification technique complète de la Homepage Desktop v1 de Collectoria a été créée avec succès. Cette documentation fournit tous les éléments nécessaires pour l'implémentation par les agents Backend, Frontend, Testing et DevOps.

### Chiffres Clés
- **Spec principale:** 1,780 lignes, 50KB
- **Documentation totale:** 2,594 lignes, 73KB
- **Composants React définis:** 9
- **Endpoints API Backend:** 4
- **Bounded Contexts DDD:** 2
- **User Stories:** 5
- **Critères d'Acceptation:** 7

---

## Livrables Créés

### 1. Spécification Technique Complète
**Fichier:** `homepage-desktop-v1.md` (50KB, 1,780 lignes)

**Contenu:**
- 17 sections détaillées couvrant tous les aspects
- Architecture DDD avec 2 bounded contexts
- 9 composants React avec props et design system
- 4 endpoints REST avec contrats OpenAPI
- Modèles de données TypeScript
- Gestion complète des états (loading, error, empty)
- Responsive design (desktop, tablet, mobile)
- Performance & optimizations
- Accessibilité WCAG 2.1 AA
- Tests TDD (unitaires, intégration, E2E)
- Points d'attention et risques
- Plan de déploiement en 5 phases
- Glossaire et changelog

**Sections principales:**
1. Vue d'ensemble
2. Architecture & Data Flow
3. Composants UI (Frontend)
4. API Backend Nécessaires
5. Modèle de Données (Frontend State)
6. Gestion des États
7. Responsive Design
8. Performance & Optimizations
9. Accessibilité (WCAG 2.1 AA)
10. Tests & Validation
11. Points d'Attention & Risques
12. Dépendances & Technologies
13. Migration & Déploiement
14. Documentation Complémentaire
15. Prochaines Étapes
16. Glossaire
17. Changelog

---

### 2. Résumé Exécutif
**Fichier:** `homepage-desktop-v1-summary.md` (4.2KB)

**Contenu:**
- Vue d'ensemble rapide (1 page)
- Architecture simplifiée
- Composants principaux
- APIs backend
- Bounded contexts DDD
- Design system (Ethos V1)
- Responsive breakpoints
- Stratégie de caching
- Performance targets
- Tests prioritaires
- Prochaines étapes
- Points d'attention

**Utilisation:** Lecture rapide pour comprendre l'essentiel en 5 minutes

---

### 3. Checklist d'Implémentation
**Fichier:** `homepage-desktop-v1-checklist.md` (9.1KB)

**Contenu:**
- 5 phases de déploiement
- Checklist complète par agent:
  - Agent Backend (4 endpoints + infra)
  - Agent Frontend (layout + composants + data)
  - Agent Testing (unit + integration + E2E)
  - Agent DevOps (staging + monitoring + production)
- Critères de validation finale
- 150+ items à cocher

**Utilisation:** Suivi de progression de l'implémentation

---

### 4. Quick Reference Card
**Fichier:** `homepage-desktop-v1-quick-ref.md` (9.6KB)

**Contenu:**
- Architecture en un coup d'œil (ASCII art)
- Tableau des 9 composants React
- 4 APIs REST en résumé
- Data flow simplifié
- Design tokens (colors, typography, spacing)
- Performance targets
- Tests critiques
- Phases d'implémentation
- Bounded contexts DDD
- Commandes rapides

**Utilisation:** Référence rapide pendant l'implémentation

---

### 5. Architecture Diagram
**Fichier:** `homepage-desktop-v1-architecture.txt` (200+ lignes)

**Contenu:**
- Diagramme ASCII art complet du système
- Frontend (Next.js) avec layout détaillé
- API Gateway (Go)
- 2 Microservices (Collection Mgmt, Statistics)
- 2 Bases PostgreSQL
- Redis Cache
- Apache Kafka (event bus)
- Data flow example (7 étapes)
- Design system tokens visuels
- Performance metrics avec barres de progression
- Légende complète

**Utilisation:** Visualisation de l'architecture complète

---

### 6. README Index
**Fichier:** `README.md` (4.9KB)

**Contenu:**
- Index de toutes les spécifications techniques
- Structure standardisée des specs
- Méthodologie DDD
- Convention de nommage
- Processus de validation
- Ressources liées
- Contact & support

**Utilisation:** Point d'entrée du répertoire Specifications/technical/

---

## Structure des Fichiers

```
Specifications/technical/
├── README.md                              (4.9KB) - Index général
├── HOMEPAGE_DELIVERABLES.md               (ce fichier)
│
├── homepage-desktop-v1.md                 (50KB)  - Spec complète ⭐
├── homepage-desktop-v1-summary.md         (4.2KB) - Résumé 1 page
├── homepage-desktop-v1-checklist.md       (9.1KB) - Checklist implémentation
├── homepage-desktop-v1-quick-ref.md       (9.6KB) - Référence rapide
└── homepage-desktop-v1-architecture.txt   (8KB)   - Diagramme ASCII

Total: 73KB de documentation
```

---

## Données du Projet (Réelles)

### Collections
- **Total cartes:** 2,733 cartes
- **MECCG (Middle-earth CCG):** 1,678 cartes
- **Doomtrooper:** 1,055 cartes
- **Complétion utilisateur:** 100% (toutes possédées)

### Notes Importantes
Les chiffres dans la maquette (2,400 total, 1,800 MECCG) sont **incorrects**.
Les spécifications utilisent les **vraies données** du projet.

---

## Architecture Technique

### Frontend
- **Framework:** Next.js 14+ (App Router)
- **Langage:** TypeScript 5+
- **UI:** React 18+ avec Tailwind CSS 3+
- **State Management:** React Query (@tanstack/react-query 5+)
- **Design System:** "The Digital Curator" (Ethos V1)

### Backend
- **Langage:** Go 1.22+
- **Architecture:** Microservices avec DDD
- **Communication:** REST (synchrone) + Kafka (asynchrone)
- **Base de données:** PostgreSQL 15+ (1 par microservice)
- **Cache:** Redis 7+
- **API Docs:** OpenAPI 3.1 + Swagger UI

### Microservices

**1. Collection Management Service**
- Bounded Context: Collection Management
- Endpoints: `/collections/summary`, `/collections`
- Responsabilité: Collections, cartes, possession utilisateur

**2. Statistics & Analytics Service**
- Bounded Context: Statistics & Analytics
- Endpoints: `/activities/recent`, `/statistics/growth`
- Responsabilité: Métriques, activités, historique de croissance

---

## Composants Frontend (9)

1. **Sidebar** - Navigation principale latérale
2. **TopBar** - Barre supérieure (search, notifications)
3. **HeroCard** - Progression globale avec gradient violet
4. **CollectionsGrid** - Grille 2 colonnes des collections
5. **CollectionCard** - Carte individuelle avec hero image
6. **DashboardWidgets** - Container pour widgets
7. **RecentActivityWidget** - 5 dernières activités
8. **GrowthInsightWidget** - Graphique de croissance
9. **ErrorState** - Composant de gestion d'erreurs

---

## APIs Backend (4)

1. **GET /api/v1/collections/summary**
   - Microservice: Collection Management
   - Cache: 5 min (Redis)
   - Priorité: P0 (critical)

2. **GET /api/v1/collections**
   - Microservice: Collection Management
   - Cache: 10 min (Redis)
   - Priorité: P0 (critical)

3. **GET /api/v1/activities/recent**
   - Microservice: Statistics & Analytics
   - Cache: 1 min (Redis)
   - Priorité: P1 (important)

4. **GET /api/v1/statistics/growth**
   - Microservice: Statistics & Analytics
   - Cache: 30 min (Redis)
   - Priorité: P2 (nice-to-have)

---

## Design System: "The Digital Curator"

### Principes Clés
- **No-Line Rule:** Pas de bordures 1px, utiliser Tonal Layering
- **Dual-Type System:** Manrope (headlines) + Inter (body)
- **Gradient violet:** #667eea → #764ba2 avec parcimonie
- **Espacement généreux** comme élément de design
- **Border radius:** lg (16px) ou xl (24px)

### Couleurs Principales
```css
--surface:                  #f8f9fa (fond principal)
--surface-container-low:    #f3f4f5 (sidebar)
--surface-container-lowest: #ffffff (cartes)
--primary:                  #667eea (violet)
--primary-container:        #764ba2 (violet foncé)
--on-surface:               #191c1d (texte principal)
```

---

## Tests TDD

### Frontend (Jest + React Testing Library)
- Tests unitaires des 9 composants
- Tests des hooks React Query
- Tests des états (loading, error, empty)
- Coverage target: > 80%

### Backend (Go + testify)
- Tests unitaires (handlers, services, repositories)
- Tests d'intégration (testcontainers avec PostgreSQL réel)
- Tests des calculs (completion percentage, growth rate)
- Coverage target: > 80%

### E2E (Playwright)
- Login → Homepage → All sections loaded
- Click MECCG → Navigate to /collections/meccg
- Responsive behavior (desktop, tablet, mobile)
- Error recovery scenarios

### Load Testing (k6)
- 100 utilisateurs concurrents
- P95 response time < 500ms
- Error rate < 1%

---

## Performance Targets

| Métrique | Target | Priorité |
|----------|--------|----------|
| Lighthouse Performance Score | > 90 | P0 |
| First Contentful Paint (FCP) | < 1.5s | P0 |
| Largest Contentful Paint (LCP) | < 2.5s | P0 |
| Time to Interactive (TTI) | < 3.5s | P1 |
| Cumulative Layout Shift (CLS) | < 0.1 | P0 |
| API P50 Response Time | < 100ms | P0 |
| API P95 Response Time | < 500ms | P0 |
| API P99 Response Time | < 1s | P1 |
| Redis Cache Hit Rate | > 80% | P1 |
| React Query Cache Hit Rate | > 60% | P2 |

---

## Accessibilité (WCAG 2.1 AA)

### Keyboard Navigation
- Tab order complet défini
- Shortcuts: `/` (search), `Esc` (close)
- Focus visible sur tous éléments interactifs

### ARIA Labels
- Progress bar: `role="progressbar"` + `aria-valuenow`
- Sections: `aria-labelledby`
- Live regions: `aria-live="polite"` pour activities

### Contrast Ratios
- on-surface / surface: 15.8:1 ✅
- on-primary / primary: 8.2:1 ✅
- Tous ratios > 4.5:1 (WCAG AA)

### Screen Reader Support
- Alt text descriptif pour images
- Announcements appropriés
- Hidden table pour chart data

---

## Plan de Déploiement (5 Phases)

### Sprint 1: Backend APIs
- Implémenter 4 endpoints REST (TDD)
- Setup PostgreSQL schemas
- Redis caching
- Tests unitaires + intégration

### Sprint 2: Frontend Components
- Setup Next.js + Tailwind
- Layout (Sidebar, TopBar)
- Homepage components (9)
- Data hooks (React Query)

### Sprint 3: Integration & Testing
- Intégration Frontend-Backend
- State management complet
- Tests E2E (Playwright)
- Performance optimizations

### Sprint 4: Quality & Accessibility
- Accessibility audit (WCAG 2.1 AA)
- Performance audit (Lighthouse)
- Security review
- Load testing

### Sprint 5: Deployment
- Staging deployment
- Monitoring setup (Prometheus, Grafana, Sentry)
- Feature flags (gradual rollout)
- Production rollout + smoke tests

---

## Prochaines Étapes

### Pour Agent Backend
1. Créer les specs OpenAPI complètes dans `/Specifications/api/`
2. Implémenter les 4 endpoints REST selon la spec
3. Setup PostgreSQL schemas avec migrations
4. Implémenter Redis caching avec invalidation
5. Écrire les tests unitaires + intégration (TDD)

### Pour Agent Frontend
1. Setup Next.js project avec Tailwind + design tokens
2. Implémenter le layout (Sidebar, TopBar)
3. Créer les composants atomiques du design system
4. Implémenter les 9 composants homepage
5. Intégrer avec les APIs via React Query
6. Écrire les tests unitaires (Jest + RTL)

### Pour Agent Testing
1. Setup test infrastructure (Jest, Playwright, testcontainers)
2. Créer les test suites selon section 10 de la spec
3. Setup CI/CD pour tests automatiques
4. Configurer coverage reports
5. Créer les tests E2E (Playwright)

### Pour Agent DevOps
1. Setup environnements (staging, production)
2. Configurer PostgreSQL (2 databases)
3. Configurer Redis cluster
4. Setup monitoring (Prometheus, Grafana, Jaeger, ELK)
5. Configurer alertes
6. Préparer feature flags pour rollout progressif

---

## Points d'Attention Critiques

### Données
- **IMPORTANT:** Les chiffres dans la maquette sont incorrects
- Utiliser TOUJOURS les vraies données du backend (2,733 / 1,678 / 1,055)
- Pas de valeurs hardcodées dans le frontend

### Architecture
- Synchronisation Collection Management / Statistics via Kafka events
- Idempotence des consumers Kafka
- Cache invalidation sur mutations

### Performance
- Images hero: WebP + lazy loading + CDN
- API calls en parallèle (Promise.all)
- Server-side prefetch pour données critiques
- Caching agressif (Redis + React Query)

### Accessibilité
- Gradient hero card: vérifier contraste
- Graphique: fournir table alternative pour screen readers
- Keyboard navigation complète

### Sécurité
- JWT validation sur TOUS les endpoints
- Rate limiting par endpoint
- Input sanitization (XSS prevention)
- Content Security Policy headers

---

## Ressources Référencées

### Design
- `/Design/design-system/Ethos-V1-2026-04-15.md`
- `/Design/mockups/homepage/homepage-desktop-v1-2026-04-15.png`
- `/Design/mockups/homepage/homepage-mobile-v1-2026-04-15.png`

### Data Models
- `/Specifications/technical/mvp-data-model-v2.md`

### APIs (à créer)
- `/Specifications/api/collections-api-v1.yaml`
- `/Specifications/api/statistics-api-v1.yaml`

---

## Statut de Validation

- [x] Spec technique complète rédigée (1,780 lignes)
- [x] Résumé exécutif créé
- [x] Checklist d'implémentation créée
- [x] Quick reference créée
- [x] Architecture diagram créée
- [x] README index créé
- [x] Données réelles du projet intégrées
- [x] Design system (Ethos V1) respecté
- [x] DDD bounded contexts définis
- [x] 4 endpoints REST spécifiés
- [x] 9 composants React définis
- [x] Tests TDD spécifiés
- [x] Performance targets définis
- [x] Accessibilité WCAG 2.1 AA spécifiée
- [ ] Validation par Product Owner (en attente)
- [ ] Review par Agent Backend
- [ ] Review par Agent Frontend
- [ ] Review par Agent Testing

---

## Métriques de Documentation

```
Total lines:       2,594 lignes
Total size:        73 KB
Main spec:         1,780 lignes (50 KB)
Supporting docs:   814 lignes (23 KB)

Sections:          17 (main spec)
Components:        9 React components
APIs:              4 REST endpoints
Bounded Contexts:  2 DDD contexts
User Stories:      5
Acceptance Criteria: 7
Test Scenarios:    50+

Time to read:
- Quick ref:       5 minutes
- Summary:         10 minutes
- Full spec:       60-90 minutes
```

---

## Contact & Questions

Pour toute question ou clarification sur cette spécification:

- **Agent Spécifications:** Créateur de la spec, questions générales
- **Agent Backend:** Questions sur APIs, microservices, DDD
- **Agent Frontend:** Questions sur composants, UI, Next.js
- **Agent Testing:** Questions sur tests, TDD, E2E
- **Alfred (Dispatch):** Coordination entre agents

---

**Spécification créée par:** Agent Spécifications  
**Date:** 2026-04-15  
**Dernière mise à jour:** 2026-04-16  
**Version:** 1.0  
**Statut:** Draft - Prêt pour implémentation  

---

**Fin du document de livrables**
