# Homepage Desktop v1 - Implementation Checklist

**Date:** 2026-04-15  
**Spec:** `homepage-desktop-v1.md`  
**Statut:** A implémenter

---

## Phase 1: Backend APIs (Sprint 1)

### Collection Management Service

- [ ] **Endpoint: GET /api/v1/collections/summary**
  - [ ] Handler HTTP avec authentification JWT
  - [ ] Service layer: calcul completion_percentage
  - [ ] Repository: agrégation user_cards
  - [ ] Tests unitaires (calculs)
  - [ ] Tests intégration (API)
  - [ ] Cache Redis (TTL 5 min)
  - [ ] Documentation OpenAPI

- [ ] **Endpoint: GET /api/v1/collections**
  - [ ] Handler HTTP avec query params (include_stats)
  - [ ] Service layer: récupération collections + stats
  - [ ] Repository: jointure collections/user_cards
  - [ ] Tests unitaires
  - [ ] Tests intégration
  - [ ] Cache Redis (TTL 10 min)
  - [ ] Documentation OpenAPI

### Statistics & Analytics Service

- [ ] **Endpoint: GET /api/v1/activities/recent**
  - [ ] Handler HTTP avec pagination (limit, offset)
  - [ ] Service layer: récupération activities
  - [ ] Repository: query avec ORDER BY timestamp DESC
  - [ ] Tests unitaires
  - [ ] Tests intégration
  - [ ] Cache Redis (TTL 1 min)
  - [ ] Documentation OpenAPI

- [ ] **Endpoint: GET /api/v1/statistics/growth**
  - [ ] Handler HTTP avec query params (period, granularity)
  - [ ] Service layer: agrégation temporelle
  - [ ] Repository: GROUP BY mois
  - [ ] Calcul growth_rate_percentage
  - [ ] Tests unitaires
  - [ ] Tests intégration
  - [ ] Cache Redis (TTL 30 min)
  - [ ] Documentation OpenAPI

### Infrastructure Backend

- [ ] PostgreSQL schemas (migrations)
  - [ ] Table: collections
  - [ ] Table: cards
  - [ ] Table: user_collections
  - [ ] Table: user_cards
  - [ ] Table: activities
  - [ ] Table: growth_snapshots
  - [ ] Indexes appropriés

- [ ] Redis setup
  - [ ] Configuration cache layers
  - [ ] TTL par endpoint
  - [ ] Invalidation strategy

- [ ] Kafka events (pour synchronisation)
  - [ ] Event: CollectionUpdated
  - [ ] Event: CardAdded
  - [ ] Consumer dans Statistics service

---

## Phase 2: Frontend Components (Sprint 2)

### Setup Project

- [ ] Next.js 14+ project setup
- [ ] Tailwind CSS configuration
- [ ] Design system tokens (couleurs, typography)
- [ ] React Query setup
- [ ] TypeScript configuration
- [ ] ESLint + Prettier

### Layout Components

- [ ] **Sidebar Component**
  - [ ] Navigation items (Home, Activity, Collections, etc.)
  - [ ] Active state styling
  - [ ] User profile section
  - [ ] Responsive (collapsible tablet)
  - [ ] Tests unitaires

- [ ] **TopBar Component**
  - [ ] Breadcrumb navigation
  - [ ] Search bar (pill shape)
  - [ ] Notifications icon
  - [ ] Theme toggle
  - [ ] User avatar
  - [ ] Tests unitaires

### Homepage Components

- [ ] **HeroCard Component**
  - [ ] Gradient background (violet)
  - [ ] Percentage display (display-xl)
  - [ ] Progress bar avec inner glow
  - [ ] Stats (cards owned, cards to go)
  - [ ] 3 CTA buttons
  - [ ] Loading skeleton
  - [ ] Error state
  - [ ] Tests unitaires

- [ ] **CollectionsGrid Component**
  - [ ] Grid responsive (2 col desktop, 1 col mobile)
  - [ ] Map sur collections array
  - [ ] Loading skeletons
  - [ ] Tests unitaires

- [ ] **CollectionCard Component**
  - [ ] Hero image (16:9, lazy loading)
  - [ ] Category badge
  - [ ] Title (headline-md)
  - [ ] Stats + progress bar
  - [ ] Link icon
  - [ ] Hover shadow effect
  - [ ] Click navigation
  - [ ] Tests unitaires

- [ ] **RecentActivityWidget Component**
  - [ ] Liste de 5 activités
  - [ ] Icônes colorées par type
  - [ ] Timestamps relatifs (date-fns)
  - [ ] "View All" link
  - [ ] Empty state
  - [ ] Loading skeleton
  - [ ] Tests unitaires

- [ ] **GrowthInsightWidget Component**
  - [ ] Graphique barres (recharts/visx)
  - [ ] 6 data points (mois)
  - [ ] Badge croissance
  - [ ] Hover tooltips
  - [ ] Empty state
  - [ ] Loading skeleton
  - [ ] Tests unitaires

### Data Layer (Frontend)

- [ ] API client configuration
  - [ ] Axios/fetch setup
  - [ ] Base URL configuration
  - [ ] JWT token interceptor
  - [ ] Error interceptor

- [ ] React Query hooks
  - [ ] useCollectionSummary (staleTime 5min)
  - [ ] useCollections (staleTime 10min)
  - [ ] useRecentActivities (staleTime 1min)
  - [ ] useGrowthStatistics (staleTime 30min)
  - [ ] Tests hooks

- [ ] TypeScript types
  - [ ] CollectionSummary interface
  - [ ] Collection interface
  - [ ] Activity interface
  - [ ] GrowthDataPoint interface
  - [ ] HomePageData interface

### States Management

- [ ] Loading states (skeletons)
  - [ ] HeroCardSkeleton
  - [ ] CollectionCardSkeleton
  - [ ] ActivityItemSkeleton
  - [ ] ChartSkeleton

- [ ] Error states
  - [ ] ErrorState component
  - [ ] Retry handlers
  - [ ] Error messages par type

- [ ] Empty states
  - [ ] Empty activity illustration
  - [ ] Empty chart placeholder
  - [ ] CTAs appropriés

---

## Phase 3: Integration & Testing (Sprint 3)

### Integration Frontend-Backend

- [ ] HomePage component complet
  - [ ] Appels parallèles des 4 endpoints
  - [ ] Progressive rendering
  - [ ] Error handling par section
  - [ ] Loading coordination

- [ ] Navigation
  - [ ] Routes Next.js
  - [ ] Click collection → /collections/{slug}
  - [ ] Search bar (future)

- [ ] Performance optimizations
  - [ ] Images: Next.js Image component
  - [ ] Code splitting (dynamic imports)
  - [ ] Server-side prefetch (getServerSideProps)

### Tests Frontend

- [ ] Tests unitaires (Jest + RTL)
  - [ ] Tous les composants
  - [ ] Tous les hooks
  - [ ] Coverage > 80%

- [ ] Tests E2E (Playwright)
  - [ ] Login → Homepage load
  - [ ] Toutes sections visibles
  - [ ] Click collection → Navigation
  - [ ] Responsive (desktop/tablet/mobile)
  - [ ] Error recovery

### Tests Backend

- [ ] Tests unitaires (Go + testify)
  - [ ] Handlers
  - [ ] Services
  - [ ] Repositories
  - [ ] Coverage > 80%

- [ ] Tests intégration (testcontainers)
  - [ ] Endpoints complets
  - [ ] PostgreSQL réel
  - [ ] Redis réel

- [ ] Load testing (k6)
  - [ ] 100 utilisateurs concurrent
  - [ ] P95 < 500ms
  - [ ] Error rate < 1%

---

## Phase 4: Quality & Accessibility (Sprint 4)

### Accessibilité (WCAG 2.1 AA)

- [ ] Keyboard navigation
  - [ ] Tab order correct
  - [ ] Focus visible
  - [ ] Shortcuts (/, Esc)

- [ ] ARIA labels
  - [ ] Sections avec aria-labelledby
  - [ ] Progress bar avec role + aria-valuenow
  - [ ] Live regions (aria-live)

- [ ] Contrast ratios
  - [ ] Vérification automatique (axe)
  - [ ] Tous ratios > 4.5:1
  - [ ] Hero card gradient OK

- [ ] Screen readers
  - [ ] Alt text images
  - [ ] Announcements appropriés
  - [ ] Hidden table pour chart data

### Performance Audit

- [ ] Lighthouse audit
  - [ ] Performance > 90
  - [ ] FCP < 1.5s
  - [ ] LCP < 2.5s
  - [ ] CLS < 0.1

- [ ] Images optimization
  - [ ] WebP + fallback
  - [ ] Lazy loading
  - [ ] Blur placeholders
  - [ ] CDN configuration

- [ ] Caching verification
  - [ ] Redis hit rate > 80%
  - [ ] React Query working
  - [ ] Browser cache headers

### Security Review

- [ ] Authentication
  - [ ] JWT validation sur tous endpoints
  - [ ] User ID check
  - [ ] Token expiration

- [ ] Rate limiting
  - [ ] Par endpoint
  - [ ] Par user

- [ ] Input sanitization
  - [ ] XSS prevention
  - [ ] SQL injection prevention (ORM)

- [ ] CSP headers
  - [ ] Content Security Policy
  - [ ] CORS configuration

---

## Phase 5: Deployment (Sprint 5)

### Staging Deployment

- [ ] Backend services déployés
  - [ ] Collection Management service
  - [ ] Statistics service
  - [ ] API Gateway

- [ ] Frontend déployé
  - [ ] Next.js build
  - [ ] Environment variables
  - [ ] CDN configuration

- [ ] Infrastructure
  - [ ] PostgreSQL (par service)
  - [ ] Redis cluster
  - [ ] Kafka cluster

### Monitoring Setup

- [ ] Frontend monitoring
  - [ ] Sentry error tracking
  - [ ] Web Vitals monitoring
  - [ ] Analytics (Plausible)

- [ ] Backend monitoring
  - [ ] Prometheus metrics
  - [ ] Grafana dashboards
  - [ ] Jaeger tracing
  - [ ] ELK logs

- [ ] Alertes configurées
  - [ ] API response time > 1s (P95)
  - [ ] Error rate > 1%
  - [ ] Cache hit rate < 80%
  - [ ] DB connection pool

### Production Rollout

- [ ] Feature flags
  - [ ] homepage_v1 flag
  - [ ] Gradual rollout (10% → 50% → 100%)

- [ ] Smoke tests
  - [ ] Login flow
  - [ ] Homepage load
  - [ ] All sections
  - [ ] No errors

- [ ] Documentation
  - [ ] API docs (Swagger UI)
  - [ ] Component storybook
  - [ ] User guide

- [ ] Rollback plan
  - [ ] Feature flag toggle
  - [ ] Database migrations reversible
  - [ ] Backup restore procedure

---

## Critères de Validation Finale

### Fonctionnel
- [ ] Toutes les user stories (US-HP-001 à US-HP-005) complètes
- [ ] Tous les critères d'acceptation (AC-HP-001 à AC-HP-007) validés
- [ ] Données réelles (2,733 cartes) affichées correctement

### Technique
- [ ] 4 endpoints backend opérationnels
- [ ] Frontend Next.js déployé
- [ ] Tests coverage > 80%
- [ ] Performance targets atteints

### Qualité
- [ ] Accessibilité WCAG 2.1 AA
- [ ] Design system respecté (Ethos V1)
- [ ] Responsive (desktop/tablet/mobile)
- [ ] Monitoring en place

---

**Dernière mise à jour:** 2026-04-15  
**Statut:** Prêt pour implémentation
