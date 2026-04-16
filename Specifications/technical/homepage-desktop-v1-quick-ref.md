# Homepage Desktop v1 - Quick Reference

## En un coup d'œil

```
┌────────────────────────────────────────────────────────────┐
│  HOMEPAGE DESKTOP - Architecture Simplifiée                │
└────────────────────────────────────────────────────────────┘

FRONTEND (Next.js)
├─ Layout
│  ├─ Sidebar (240px) ──────────────┐
│  └─ TopBar (search, notif) ───────┤
│                                    ├─ 🎨 Design System
├─ Content                           │   • No-Line Rule
│  ├─ HeroCard ─────────────────────┤   • Tonal Layering
│  │  • 100% completion             │   • Gradient violet
│  │  • 2,733 cards owned            │   • Border radius xl
│  │  • Progress bar                 │
│  │                                 │
│  ├─ CollectionsGrid ───────────────┤
│  │  ├─ MECCG (1,678 cards) ────────┤
│  │  └─ Doomtrooper (1,055 cards) ─┤
│  │                                 │
│  └─ DashboardWidgets ──────────────┤
│     ├─ RecentActivity (5 items) ───┤
│     └─ GrowthChart (6 months) ─────┘

                ↓ 4 API Calls (parallel)

BACKEND (Go Microservices)
├─ Collection Management Service
│  ├─ GET /api/v1/collections/summary ─→ 🔢 Stats globales
│  └─ GET /api/v1/collections ─────────→ 📦 Liste collections
│
└─ Statistics & Analytics Service
   ├─ GET /api/v1/activities/recent ──→ 📋 Activités (10)
   └─ GET /api/v1/statistics/growth ──→ 📊 Croissance (6m)

                ↓

DATABASE (PostgreSQL)
├─ collections_db
│  ├─ collections
│  ├─ cards
│  ├─ user_collections
│  └─ user_cards
│
└─ analytics_db
   ├─ activities
   └─ growth_snapshots

CACHE (Redis)
├─ summary: 5min TTL
├─ collections: 10min TTL
├─ activities: 1min TTL
└─ growth: 30min TTL
```

---

## Composants React (9)

| Composant | Props | Responsabilité |
|-----------|-------|----------------|
| **Sidebar** | currentPath, userAvatar | Navigation principale |
| **TopBar** | breadcrumbs, onSearch | Search + notifs |
| **HeroCard** | totalCards, percentage | Stats globales |
| **CollectionsGrid** | collections[] | Grid 2 colonnes |
| **CollectionCard** | collection, onClick | Carte individuelle |
| **DashboardWidgets** | children | Container widgets |
| **RecentActivityWidget** | activities[] | 5 dernières activités |
| **GrowthInsightWidget** | growthData[] | Graphique 6 mois |
| **ErrorState** | title, message, onRetry | Gestion erreurs |

---

## APIs REST (4)

```typescript
// 1. Summary
GET /api/v1/collections/summary
→ { total_cards_owned: 2733, completion_percentage: 100.0 }

// 2. Collections
GET /api/v1/collections?include_stats=true
→ { collections: [MECCG, Doomtrooper] }

// 3. Activities
GET /api/v1/activities/recent?limit=10
→ { activities: [...], has_more: true }

// 4. Growth
GET /api/v1/statistics/growth?period=6m
→ { data_points: [Nov, Dec, Jan, Feb, Mar, Apr] }
```

---

## Data Flow

```
User opens homepage
    ↓
Next.js SSR (prefetch)
    ↓
4 API calls (Promise.all)
    ↓
┌─────────────┬─────────────┬─────────────┬─────────────┐
│  Summary    │ Collections │  Activities │   Growth    │
└─────────────┴─────────────┴─────────────┴─────────────┘
    ↓             ↓             ↓             ↓
React Query cache (staleTime)
    ↓
Progressive rendering
    ↓
┌─────────────────────────────────────┐
│  1. HeroCard appears               │
│  2. Collections grid appears        │
│  3. Activity widget appears         │
│  4. Growth chart appears            │
└─────────────────────────────────────┘
```

---

## Design Tokens

```css
/* Colors */
--surface: #f8f9fa;
--surface-container-low: #f3f4f5;
--surface-container-lowest: #ffffff;
--primary: #667eea;
--primary-container: #764ba2;
--on-surface: #191c1d;

/* Typography */
--font-display: Manrope;      /* Headlines */
--font-body: Inter;           /* Body text */

/* Spacing */
--radius-lg: 16px;
--radius-xl: 24px;
--gap-md: 12px;
--gap-lg: 24px;
```

---

## Performance Targets

| Métrique | Target | Actuel |
|----------|--------|--------|
| Lighthouse Score | > 90 | - |
| First Contentful Paint | < 1.5s | - |
| Largest Contentful Paint | < 2.5s | - |
| API P95 Response | < 500ms | - |
| Cache Hit Rate | > 80% | - |

---

## Tests Critiques

```
Frontend (Jest + RTL)
├─ HeroCard: affichage + calculs ✓
├─ CollectionCard: navigation ✓
├─ ActivityWidget: liste + empty ✓
└─ GrowthWidget: chart rendering ✓

Backend (Go + testify)
├─ Summary: calcul completion ✓
├─ Collections: stats correctes ✓
├─ Activities: tri + pagination ✓
└─ Growth: agrégation temporelle ✓

E2E (Playwright)
├─ Login → Homepage → All loaded ✓
├─ Click MECCG → Navigate ✓
└─ Responsive: Desktop/Tablet/Mobile ✓
```

---

## Phases d'Implémentation

```
Sprint 1 (Backend)      Sprint 2 (Frontend)    Sprint 3 (Integration)
├─ 4 endpoints REST     ├─ Layout components   ├─ API integration
├─ PostgreSQL schemas   ├─ Homepage components ├─ State management
├─ Redis caching        ├─ Data hooks          ├─ Error handling
└─ Tests unitaires      └─ Tests unitaires     └─ Tests E2E

Sprint 4 (Quality)      Sprint 5 (Deploy)
├─ Accessibilité        ├─ Staging deploy
├─ Performance audit    ├─ Monitoring setup
├─ Security review      ├─ Feature flags
└─ Load testing         └─ Production rollout
```

---

## Bounded Contexts DDD

```
┌──────────────────────────────────────────────────────────┐
│  Collection Management Context                           │
│                                                           │
│  Entities:                                               │
│  • Collection (aggregate root)                           │
│  • Card                                                   │
│  • UserCollection                                        │
│  • UserCard                                              │
│                                                           │
│  Services:                                               │
│  • CollectionService                                     │
│  • CardOwnershipService                                  │
│                                                           │
│  Events:                                                 │
│  • CollectionCreated                                     │
│  • CardAdded                                             │
│  • CollectionCompleted                                   │
└──────────────────────────────────────────────────────────┘

┌──────────────────────────────────────────────────────────┐
│  Statistics & Analytics Context                          │
│                                                           │
│  Entities:                                               │
│  • Activity                                              │
│  • GrowthMetric                                          │
│  • CollectionSnapshot                                    │
│                                                           │
│  Services:                                               │
│  • ActivityTrackingService                               │
│  • GrowthCalculationService                              │
│                                                           │
│  Events (consumed):                                      │
│  • CollectionUpdated → Update metrics                    │
│  • CardAdded → Log activity                              │
└──────────────────────────────────────────────────────────┘
```

---

## Commandes Rapides

```bash
# Lire la spec complète
cat Specifications/technical/homepage-desktop-v1.md

# Lire le résumé
cat Specifications/technical/homepage-desktop-v1-summary.md

# Voir la checklist
cat Specifications/technical/homepage-desktop-v1-checklist.md

# Voir les maquettes
open Design/mockups/homepage/homepage-desktop-v1-2026-04-15.png

# Voir le design system
cat Design/design-system/Ethos-V1-2026-04-15.md
```

---

**Spec complète:** `homepage-desktop-v1.md` (1,780 lignes, 50KB)  
**Date:** 2026-04-15  
**Statut:** Draft - Prêt pour implémentation
