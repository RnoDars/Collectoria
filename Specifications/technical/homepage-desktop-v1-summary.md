# Homepage Desktop v1 - Résumé Exécutif

**Date:** 2026-04-15  
**Spec complète:** `homepage-desktop-v1.md`

## Vue d'Ensemble Rapide

La homepage desktop de Collectoria est la page d'accueil principale après authentification, offrant une vue consolidée de la collection de l'utilisateur.

### Données Réelles du Projet
- **Total cartes:** 2,733 cartes
- **MECCG:** 1,678 cartes
- **Doomtrooper:** 1,055 cartes
- **Complétion:** 100% (toutes les cartes possédées)

## Architecture Simplifiée

```
Frontend (Next.js)
     │
     ├─ 4 API Calls en parallèle
     │
     ▼
API Gateway (Go)
     │
     ├─ Collection Management Service → PostgreSQL
     └─ Statistics & Analytics Service → PostgreSQL
```

## Composants Principaux

### 1. HeroCard
- Affichage de la progression globale (68% dans mockup → 100% en réel)
- Progress bar avec gradient violet
- 3 CTAs : Add Cards, View Premium, Import Data

### 2. CollectionsGrid
- 2 cartes (MECCG + Doomtrooper)
- Hero images 16:9
- Stats individuelles par collection
- Badge catégorie (Fantasy, Sci-Fi)

### 3. RecentActivityWidget
- 5 dernières activités
- Icônes colorées par type
- Timestamps relatifs
- "View All" link

### 4. GrowthInsightWidget
- Graphique barres (6 derniers mois)
- Badge croissance (+24%)
- Tooltip sur hover

## APIs Backend

| Endpoint | Microservice | Priorité |
|----------|--------------|----------|
| `GET /api/v1/collections/summary` | Collection Mgmt | P0 |
| `GET /api/v1/collections` | Collection Mgmt | P0 |
| `GET /api/v1/activities/recent` | Statistics | P1 |
| `GET /api/v1/statistics/growth` | Statistics | P2 |

## Bounded Contexts DDD

### Collection Management
- **Responsabilité:** Collections, cartes, possession utilisateur
- **Entités:** Collection, Card, UserCollection, UserCard
- **APIs:** `/collections/*`

### Statistics & Analytics
- **Responsabilité:** Métriques, activités, historique
- **Entités:** Activity, GrowthMetric, CollectionSnapshot
- **APIs:** `/activities/*`, `/statistics/*`

## Design System (Ethos V1)

### Principes Clés
- **No-Line Rule:** Pas de bordures 1px, utiliser tonal layering
- **Dual-Type System:** Manrope (headlines) + Inter (body)
- **Gradient violet:** #667eea → #764ba2
- **Border radius:** lg (16px) ou xl (24px)

### Couleurs Principales
- `surface`: #f8f9fa (fond principal)
- `surface-container-low`: #f3f4f5 (sidebar)
- `surface-container-lowest`: #ffffff (cartes)
- `primary`: #667eea (violet)
- `on-surface`: #191c1d (texte)

## Responsive Breakpoints

- **Desktop (≥1024px):** Sidebar 240px + 2 col grid
- **Tablet (768-1023px):** Sidebar collapsible + 2 col grid
- **Mobile (<768px):** Bottom nav + 1 col grid

## Stratégie de Caching

### Frontend (React Query)
- Summary: 5 min
- Collections: 10 min
- Activities: 1 min
- Growth: 30 min

### Backend (Redis)
- Mêmes TTL que frontend
- Invalidation sur mutation

## Performance Targets

- **Lighthouse Score:** > 90
- **LCP:** < 2.5s
- **API P95:** < 500ms
- **Cache Hit Rate:** > 80%

## Tests Prioritaires

### Frontend
1. HeroCard: Affichage + calculs
2. CollectionCard: Navigation + hover
3. ActivityWidget: Liste + empty state
4. GrowthWidget: Graphique + tooltip
5. Data hooks: Fetch + error handling

### Backend
1. Summary endpoint: Calcul complétion
2. Collections endpoint: Stats correctes
3. Activities endpoint: Tri + pagination
4. Growth endpoint: Agrégation temporelle

### E2E
1. Login → Homepage → Toutes sections chargées
2. Click MECCG → Navigate vers détail
3. Responsive: Desktop/Tablet/Mobile

## Prochaines Étapes

1. **Agent Backend:** Implémenter les 4 endpoints + OpenAPI specs
2. **Agent Frontend:** Setup Next.js + composants + intégration APIs
3. **Agent Testing:** Tests unitaires + E2E + CI/CD
4. **Agent DevOps:** Déploiement staging + monitoring

## Points d'Attention

- Les chiffres dans la maquette (2,400/1,800) sont incorrects → utiliser les vrais chiffres (2,733/1,678/1,055)
- Toutes les données sont dynamiques (pas de hardcoding)
- Synchronisation Collection/Statistics via Kafka events
- Images hero optimisées (WebP + lazy loading)
- Accessibilité WCAG 2.1 AA

---

**Pour plus de détails, consulter la spécification complète: `homepage-desktop-v1.md`**
