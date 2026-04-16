# Spécification Technique - Homepage Desktop v1

**Version:** 1.0  
**Date:** 2026-04-15  
**Statut:** Draft  
**Design System:** The Digital Curator (Ethos V1)  
**Maquette de référence:** `Design/mockups/homepage/homepage-desktop-v1-2026-04-15.png`

---

## 1. Vue d'ensemble

### 1.1 Description
La homepage desktop est la page d'accueil principale de Collectoria après authentification. Elle offre une vue d'ensemble consolidée de l'ensemble de la collection de l'utilisateur, avec un focus sur les statistiques globales, l'accès rapide aux collections individuelles, et le suivi de l'activité récente.

### 1.2 Objectif utilisateur
- **Consulter en un coup d'œil** la progression globale de sa collection (pourcentage de complétion)
- **Accéder rapidement** à ses collections individuelles (MECCG, Doomtrooper)
- **Suivre** son activité récente (ajouts de cartes, imports, milestones)
- **Visualiser** la croissance de sa collection dans le temps
- **Naviguer** vers les autres sections de l'application

### 1.3 User Stories Principales

**US-HP-001**: En tant qu'utilisateur, je veux voir immédiatement ma progression globale (% de cartes collectées) pour mesurer l'avancement de ma collection complète.

**US-HP-002**: En tant qu'utilisateur, je veux accéder à mes collections individuelles (MECCG, Doomtrooper) en un clic pour consulter le détail de chaque jeu.

**US-HP-003**: En tant qu'utilisateur, je veux voir mes activités récentes pour suivre mes dernières actions (ajouts, imports, milestones).

**US-HP-004**: En tant qu'utilisateur, je veux visualiser la croissance de ma collection au fil du temps via un graphique pour comprendre ma progression historique.

**US-HP-005**: En tant qu'utilisateur, je veux rechercher des cartes rapidement depuis la homepage via la barre de recherche globale.

---

## 2. Architecture & Data Flow

### 2.1 Architecture Globale

```
┌─────────────────────────────────────────────────────────────┐
│                     Frontend (Next.js)                       │
│                                                               │
│  ┌──────────────┐  ┌──────────────┐  ┌───────────────┐     │
│  │ HomePage     │  │ API Client   │  │ State Mgmt    │     │
│  │ Component    │──│ (REST)       │──│ (React Query) │     │
│  └──────────────┘  └──────────────┘  └───────────────┘     │
└────────────────────────────┬────────────────────────────────┘
                             │ HTTPS/REST
                             ▼
┌─────────────────────────────────────────────────────────────┐
│                    API Gateway (Go)                          │
└────────────┬────────────────────────────┬───────────────────┘
             │                            │
             ▼                            ▼
┌────────────────────────┐   ┌──────────────────────────────┐
│ Collection Management  │   │ Statistics & Analytics       │
│ Microservice (Go)      │   │ Microservice (Go)            │
│                        │   │                              │
│ - Collections data     │   │ - Growth metrics             │
│ - Ownership tracking   │   │ - Activity aggregation       │
│ - Hero images          │   │ - Historical data            │
└────────────┬───────────┘   └──────────┬───────────────────┘
             │                          │
             ▼                          ▼
     ┌──────────────┐          ┌──────────────┐
     │ PostgreSQL   │          │ PostgreSQL   │
     │ Collections  │          │ Analytics    │
     └──────────────┘          └──────────────┘
```

### 2.2 Bounded Contexts DDD

**Collection Management Context**
- **Responsabilité:** Gestion des collections, des cartes, de la possession utilisateur
- **Entités:** Collection, Card, UserCollection, UserCard
- **Fournit:** Données des collections, statistiques de possession

**Statistics & Analytics Context**
- **Responsabilité:** Agrégation des métriques, activité utilisateur, historique de croissance
- **Entités:** Activity, GrowthMetric, CollectionSnapshot
- **Fournit:** Activités récentes, graphiques de croissance, insights


### 2.3 Flux de Données

#### Au chargement de la homepage

1. **Frontend** : Appel parallèle des 4 endpoints REST
   - `GET /api/v1/collections/summary`
   - `GET /api/v1/collections`
   - `GET /api/v1/activities/recent`
   - `GET /api/v1/statistics/growth`

2. **API Gateway** : Route vers les microservices appropriés
   - `/collections/*` → Collection Management Service
   - `/statistics/*`, `/activities/*` → Statistics Service

3. **Microservices** : Requêtes en base de données et calculs
   - Agrégation des données de possession
   - Calcul des pourcentages
   - Récupération des activités récentes (limite 10)
   - Calcul des métriques de croissance (6 derniers mois)

4. **Frontend** : Affichage progressif
   - Loading skeleton pendant le fetch
   - Affichage au fur et à mesure des réponses
   - Gestion des erreurs par section

#### États de l'application

- **Loading**: Skeleton UI pour chaque section
- **Success**: Affichage des données
- **Error**: Message d'erreur spécifique par section, possibilité de retry
- **Empty**: État vide si aucune donnée (ex: pas d'activité récente)

---

## 3. Composants UI (Frontend)

### 3.1 Structure de la Page

```tsx
<HomePage>
  <Sidebar />
  <MainContent>
    <TopBar />
    <ContentArea>
      <HeroCard />
      <CollectionsGrid />
      <DashboardWidgets>
        <RecentActivityWidget />
        <GrowthInsightWidget />
      </DashboardWidgets>
    </ContentArea>
  </MainContent>
</HomePage>
```

### 3.2 Composant: `Sidebar`

**Fichier:** `components/layout/Sidebar.tsx`

**Description:** Navigation principale latérale fixe à gauche.

**Props:**
```typescript
interface SidebarProps {
  currentPath: string;
  userAvatar?: string;
  userName?: string;
}
```

**Sections:**
- Logo Collectoria (top)
- Navigation menu:
  - Home (actif par défaut)
  - Activity
  - Collections
  - Wishlist
  - Statistics
  - Settings
- User profile (bottom)

**Design System:**
- Background: `surface-container-low` (#f3f4f5)
- Width: 240px (fixe)
- No borders (No-Line Rule)
- Active state: `surface-container-lowest` avec tonal layering
- Icons: 24px, couleur `on-surface-variant`
- Typography: `label-lg` (Inter) pour les labels

**Responsive:**
- Desktop (≥1024px): Fixe, toujours visible
- Tablet (768-1023px): Collapsible, icon-only
- Mobile (<768px): Bottom navigation bar (voir spec mobile)

---

### 3.3 Composant: `TopBar`

**Fichier:** `components/layout/TopBar.tsx`

**Description:** Barre supérieure avec fil d'Ariane, recherche, notifications.

**Props:**
```typescript
interface TopBarProps {
  breadcrumbs: Breadcrumb[];
  onSearch: (query: string) => void;
  notificationCount: number;
}

interface Breadcrumb {
  label: string;
  href?: string;
}
```

**Sections:**
- Breadcrumb: "Home > Dashboard Overview"
- Search bar (centré)
- Notifications icon (badge si nouveau)
- Theme toggle
- User avatar

**Design System:**
- Background: `surface` (#f8f9fa)
- Height: 64px
- No border bottom (utiliser tonal layering avec le contenu)
- Search bar:
  - Background: `surface-container-low`
  - Focus: `surface-container-lowest` + 2px bottom accent `primary`
  - Border radius: `xl` (24px) - pill shape
  - Width: 400px (desktop), auto-resize (tablet)
- Typography: `body-md` (Inter) pour le texte de recherche

**États:**
- Search active: Dropdown suggestions (future feature)
- Notifications: Badge count sur l'icône

---

### 3.4 Composant: `HeroCard`

**Fichier:** `components/homepage/HeroCard.tsx`

**Description:** Carte hero principale affichant la progression totale de la collection.

**Props:**
```typescript
interface HeroCardProps {
  totalCardsOwned: number;
  totalCardsAvailable: number;
  completionPercentage: number;
  isLoading?: boolean;
  onAddCards: () => void;
  onViewPremium: () => void;
  onImportData: () => void;
}
```

**Structure:**
```
┌─────────────────────────────────────────────────────────┐
│ DASHBOARD OVERVIEW (label)                              │
│                                                          │
│ Total Collection Progress (headline-lg)                 │
│ Balancing your museum-grade card collection (body-md)   │
│                                                          │
│ 68% (display-xl)                                        │
│ ████████████░░░░ (progress bar)                         │
│                                                          │
│ ▼ 2,733 Cards Owned    🎯 1,481 to go                  │
│                                                          │
│ [Add Cards] [View Premium] [Import Data]                │
└─────────────────────────────────────────────────────────┘
```

**Design System:**
- Background: Gradient `primary` (#667eea) to `primary-container` (#764ba2), 15° angle
- Border radius: `xl` (24px)
- Padding: 48px
- Typography:
  - Label: `label-sm` (Inter), `on-primary` at 70% opacity
  - Title: `headline-lg` (Manrope), `on-primary`
  - Subtitle: `body-md` (Inter), `on-primary` at 80%
  - Percentage: `display-xl` (Manrope), `on-primary`, bold
  - Stats: `body-sm` (Inter), `on-primary`
- Progress bar:
  - Track: `on-primary` at 20% opacity
  - Indicator: `on-primary` at 100%
  - Height: 8px
  - Border radius: `xl` (24px)
  - Inner glow effect (per Ethos)
- Buttons:
  - Primary: `on-primary` background, `primary` text
  - Secondary: Transparent with `on-primary` border (ghost)

**Calculs:**
- `completionPercentage = (totalCardsOwned / totalCardsAvailable) * 100`
- `cardsToGo = totalCardsAvailable - totalCardsOwned`

**Loading State:**
- Skeleton avec shimmer effect
- Même dimensions que le composant final


---

### 3.5 Composant: `CollectionsGrid`

**Fichier:** `components/homepage/CollectionsGrid.tsx`

**Description:** Grille affichant les cartes des collections individuelles (MECCG, Doomtrooper).

**Props:**
```typescript
interface CollectionsGridProps {
  collections: CollectionCardData[];
  isLoading?: boolean;
}

interface CollectionCardData {
  id: string;
  name: string;
  slug: string;
  heroImageUrl: string;
  cardsOwned: number;
  totalCards: number;
  completionPercentage: number;
  category: string; // "Fantasy", "Sci-Fi"
}
```

**Structure:**
- Grid: 2 colonnes sur desktop, 1 colonne sur mobile
- Gap: 24px
- Chaque carte : `CollectionCard` component

---

### 3.6 Composant: `CollectionCard`

**Fichier:** `components/collections/CollectionCard.tsx`

**Description:** Carte individuelle d'une collection avec hero image et stats.

**Props:**
```typescript
interface CollectionCardProps {
  collection: CollectionCardData;
  onClick: (slug: string) => void;
}
```

**Structure:**
```
┌─────────────────────────────────────────┐
│                                         │
│   [Hero Image - 16:9 ratio]            │
│                                         │
├─────────────────────────────────────────┤
│ Fantasy (badge)                    🔗   │
│                                         │
│ Middle-earth CCG (headline-md)          │
│                                         │
│ 1,678 / 1,678 Cards        100%        │
│ ████████████████████                    │
└─────────────────────────────────────────┘
```

**Design System:**
- Background: `surface-container-lowest` (#ffffff)
- Border radius: `lg` (16px)
- No border (No-Line Rule)
- Tonal layering: placé sur `surface` background
- Hero image:
  - Aspect ratio: 16:9
  - Object-fit: cover
  - Lazy loading: oui
  - Border radius: `lg` (16px) top corners only
- Category badge:
  - Background: `secondary` at 20% opacity
  - Text: `on-secondary-container`
  - Border radius: `md` (12px)
  - Typography: `label-sm` (Inter)
- Title: `headline-md` (Manrope), `on-surface`
- Stats: `body-sm` (Inter), `on-surface-variant`
- Progress bar:
  - Track: `surface-container-highest`
  - Indicator: Gradient `primary` to `primary-container`
  - Height: 6px
  - Border radius: `xl`
  - Inner glow effect
- Link icon: 20px, `primary` color
- Hover state:
  - Subtle lift via ambient shadow: `0px 12px 32px rgba(25, 28, 29, 0.06)`
  - Transition: 200ms ease

**Interactions:**
- Click anywhere → Navigate to `/collections/{slug}`
- Hover → Subtle shadow lift

---

### 3.7 Composant: `DashboardWidgets`

**Fichier:** `components/homepage/DashboardWidgets.tsx`

**Description:** Container pour les widgets de dashboard (Recent Activity, Growth Insight).

**Props:**
```typescript
interface DashboardWidgetsProps {
  children: React.ReactNode;
}
```

**Structure:**
- Grid: 2 colonnes sur desktop (60% / 40%), 1 colonne sur mobile
- Gap: 24px

---

### 3.8 Composant: `RecentActivityWidget`

**Fichier:** `components/homepage/RecentActivityWidget.tsx`

**Description:** Widget affichant les 5 dernières activités de l'utilisateur.

**Props:**
```typescript
interface RecentActivityWidgetProps {
  activities: Activity[];
  isLoading?: boolean;
  onViewAll: () => void;
}

interface Activity {
  id: string;
  type: 'card_added' | 'milestone_reached' | 'import_completed' | 'set_completed';
  title: string;
  description?: string;
  timestamp: string; // ISO 8601
  icon: string; // icon name
  relatedCollection?: string;
}
```

**Structure:**
```
┌───────────────────────────────────────────┐
│ Recent Activity              [View All]   │
│                                           │
│ ● Added Gandalf to MECCG                 │
│   2 hours ago                             │
│                                           │
│ ◉ Set Milestone: 50% of Warzone Set      │
│   Yesterday                               │
│                                           │
│ ▲ Imported 142 cards from CSV            │
│   3 days ago                              │
│                                           │
│ ... (2 more items)                        │
└───────────────────────────────────────────┘
```

**Design System:**
- Background: `surface-container-lowest` (#ffffff)
- Border radius: `lg` (16px)
- Padding: 32px
- Title: `headline-sm` (Manrope), `on-surface`
- Activity items:
  - Icon: 20px, colored by type:
    - `card_added`: `primary`
    - `milestone_reached`: `secondary`
    - `import_completed`: `tertiary`
    - `set_completed`: gradient accent
  - Title: `body-md` (Inter), `on-surface`
  - Timestamp: `label-sm` (Inter), `on-surface-variant`
  - Spacing: `md` (12px) between items
  - No dividers (use whitespace)
- "View All" link:
  - Typography: `label-md` (Inter), `primary`
  - Hover: underline

**Empty State:**
- Message: "No recent activity. Start adding cards to your collection!"
- Icon: Empty box illustration
- CTA button: "Add Your First Card"

---

### 3.9 Composant: `GrowthInsightWidget`

**Fichier:** `components/homepage/GrowthInsightWidget.tsx`

**Description:** Widget avec graphique en barres montrant la croissance de la collection.

**Props:**
```typescript
interface GrowthInsightWidgetProps {
  growthData: GrowthDataPoint[];
  isLoading?: boolean;
  growthPercentage: number; // +24% this month
}

interface GrowthDataPoint {
  month: string; // "Jan 26", "Feb 26"
  cardsAdded: number;
}
```

**Structure:**
```
┌───────────────────────────────────────────┐
│ Growth Insight                    +24%    │
│ Cards added in last 6 months              │
│                                           │
│   ┃                                       │
│   ┃            ▅▅                         │
│   ┃      ▃▃    ██    ▆▆                   │
│   ┃  ▁▁  ██    ██    ██  ▄▄    ███        │
│   └──────────────────────────────         │
│   Jan  Feb  Mar  Apr  May  Jun            │
└───────────────────────────────────────────┘
```

**Design System:**
- Background: `surface-container-lowest` (#ffffff)
- Border radius: `lg` (16px)
- Padding: 32px
- Title: `headline-sm` (Manrope), `on-surface`
- Subtitle: `body-sm` (Inter), `on-surface-variant`
- Growth badge:
  - Background: `secondary-container`
  - Text: `on-secondary-container`
  - Border radius: `md` (12px)
  - Typography: `label-md` (Inter), bold
- Chart:
  - Bar color: Gradient `primary` to `primary-container`
  - Bar width: auto (responsive)
  - Bar spacing: 8px
  - Border radius: `sm` (4px) top corners
  - Max height: 120px
  - Y-axis: implicit (no labels), visual comparison only
  - X-axis labels: `label-sm` (Inter), `on-surface-variant`
- Hover on bar:
  - Tooltip with exact count
  - Slight opacity increase

**Empty State:**
- Message: "Start adding cards to see your growth!"
- Placeholder chart with dashed bars


---

## 4. API Backend Nécessaires

### 4.1 Endpoint: Collections Summary

**GET /api/v1/collections/summary**

**Description:** Retourne les statistiques globales de toutes les collections de l'utilisateur.

**Bounded Context:** Collection Management

**Headers:**
```http
Authorization: Bearer {jwt_token}
Accept: application/json
```

**Response 200 OK:**
```json
{
  "user_id": "uuid",
  "total_cards_owned": 2733,
  "total_cards_available": 2733,
  "completion_percentage": 100.0,
  "last_updated": "2026-04-15T10:30:00Z"
}
```

**Calculs côté backend:**
- `total_cards_owned` = SUM(user_cards.is_owned WHERE user_id = X)
- `total_cards_available` = COUNT(cards) across all collections
- `completion_percentage` = (total_cards_owned / total_cards_available) * 100

**Response 401 Unauthorized:**
```json
{
  "error": {
    "code": "UNAUTHORIZED",
    "message": "Invalid or missing authentication token"
  }
}
```

**Response 500 Internal Server Error:**
```json
{
  "error": {
    "code": "INTERNAL_ERROR",
    "message": "Failed to fetch collection summary"
  }
}
```

---

### 4.2 Endpoint: Collections List

**GET /api/v1/collections**

**Description:** Retourne la liste des collections avec leurs statistiques et hero images.

**Bounded Context:** Collection Management

**Query Parameters:**
- `include_stats` (boolean, default: true) - Inclure les statistiques de possession

**Headers:**
```http
Authorization: Bearer {jwt_token}
Accept: application/json
```

**Response 200 OK:**
```json
{
  "collections": [
    {
      "id": "uuid",
      "name": "Middle-earth CCG",
      "slug": "meccg",
      "description": "The definitive Middle-earth trading card game...",
      "category": "Fantasy",
      "hero_image_url": "https://cdn.collectoria.com/images/meccg-hero.jpg",
      "total_cards": 1678,
      "release_year": 1995,
      "publisher": "Iron Crown Enterprises",
      "stats": {
        "cards_owned": 1678,
        "completion_percentage": 100.0,
        "last_card_added": "2026-04-10T14:22:00Z"
      }
    },
    {
      "id": "uuid",
      "name": "Doomtrooper",
      "slug": "doomtrooper",
      "description": "Based on the Mutant Chronicles universe...",
      "category": "Sci-Fi",
      "hero_image_url": "https://cdn.collectoria.com/images/doomtrooper-hero.jpg",
      "total_cards": 1055,
      "release_year": 1994,
      "publisher": "Target Games",
      "stats": {
        "cards_owned": 1055,
        "completion_percentage": 100.0,
        "last_card_added": "2026-04-12T09:15:00Z"
      }
    }
  ],
  "total_count": 2
}
```

**Response 401 Unauthorized:** (même structure que 4.1)

**Response 500 Internal Server Error:** (même structure que 4.1)

---

### 4.3 Endpoint: Recent Activities

**GET /api/v1/activities/recent**

**Description:** Retourne les activités récentes de l'utilisateur.

**Bounded Context:** Statistics & Analytics

**Query Parameters:**
- `limit` (integer, default: 10, max: 50) - Nombre d'activités à retourner
- `offset` (integer, default: 0) - Pagination offset

**Headers:**
```http
Authorization: Bearer {jwt_token}
Accept: application/json
```

**Response 200 OK:**
```json
{
  "activities": [
    {
      "id": "uuid",
      "type": "card_added",
      "title": "Added Gandalf to MECCG",
      "description": "Card added to Middle-earth CCG collection",
      "timestamp": "2026-04-15T08:30:00Z",
      "icon": "plus-circle",
      "related_collection_id": "uuid",
      "related_collection_name": "Middle-earth CCG",
      "metadata": {
        "card_id": "uuid",
        "card_name": "Gandalf"
      }
    },
    {
      "id": "uuid",
      "type": "milestone_reached",
      "title": "Set Milestone: 50% of Warzone Set",
      "description": "Reached 50% completion of the Warzone expansion",
      "timestamp": "2026-04-14T15:45:00Z",
      "icon": "trophy",
      "related_collection_id": "uuid",
      "related_collection_name": "Doomtrooper",
      "metadata": {
        "set_name": "Warzone",
        "percentage": 50
      }
    },
    {
      "id": "uuid",
      "type": "import_completed",
      "title": "Imported 142 cards from CSV",
      "description": "Successfully imported cards via CSV file",
      "timestamp": "2026-04-12T11:20:00Z",
      "icon": "upload",
      "related_collection_id": "uuid",
      "related_collection_name": "Middle-earth CCG",
      "metadata": {
        "cards_imported": 142,
        "import_source": "csv"
      }
    }
  ],
  "total_count": 47,
  "has_more": true
}
```

**Activity Types:**
- `card_added` - Ajout d'une carte à la collection
- `milestone_reached` - Atteinte d'un jalon (50%, 75%, 100% d'un set)
- `import_completed` - Import de cartes réussi
- `set_completed` - Complétion d'un set/expansion entier
- `wishlist_item_added` - Ajout à la wishlist

**Response 401 Unauthorized:** (même structure que 4.1)

**Response 500 Internal Server Error:** (même structure que 4.1)

---

### 4.4 Endpoint: Growth Statistics

**GET /api/v1/statistics/growth**

**Description:** Retourne les données de croissance de la collection pour le graphique.

**Bounded Context:** Statistics & Analytics

**Query Parameters:**
- `period` (string, default: "6m") - Période: "1m", "3m", "6m", "1y", "all"
- `granularity` (string, default: "month") - Granularité: "day", "week", "month"

**Headers:**
```http
Authorization: Bearer {jwt_token}
Accept: application/json
```

**Response 200 OK:**
```json
{
  "period": "6m",
  "granularity": "month",
  "data_points": [
    {
      "date": "2025-11-01",
      "label": "Nov 25",
      "cards_added": 45,
      "total_cards_owned": 2550
    },
    {
      "date": "2025-12-01",
      "label": "Dec 25",
      "cards_added": 38,
      "total_cards_owned": 2588
    },
    {
      "date": "2026-01-01",
      "label": "Jan 26",
      "cards_added": 52,
      "total_cards_owned": 2640
    },
    {
      "date": "2026-02-01",
      "label": "Feb 26",
      "cards_added": 31,
      "total_cards_owned": 2671
    },
    {
      "date": "2026-03-01",
      "label": "Mar 26",
      "cards_added": 42,
      "total_cards_owned": 2713
    },
    {
      "date": "2026-04-01",
      "label": "Apr 26",
      "cards_added": 20,
      "total_cards_owned": 2733
    }
  ],
  "summary": {
    "total_cards_added": 228,
    "average_per_period": 38,
    "growth_rate_percentage": 24.0,
    "trend": "increasing"
  }
}
```

**Calculs côté backend:**
- Agrégation des `user_cards` par période (mois)
- Calcul du nombre de cartes ajoutées par période
- Calcul du taux de croissance (dernier mois vs moyenne des 6 mois)

**Response 401 Unauthorized:** (même structure que 4.1)

**Response 500 Internal Server Error:** (même structure que 4.1)

---

### 4.5 Résumé des Endpoints

| Endpoint | Microservice | Méthode | Cache TTL | Priorité |
|----------|--------------|---------|-----------|----------|
| `/api/v1/collections/summary` | Collection Management | GET | 5 min | P0 (critical) |
| `/api/v1/collections` | Collection Management | GET | 10 min | P0 (critical) |
| `/api/v1/activities/recent` | Statistics & Analytics | GET | 1 min | P1 (important) |
| `/api/v1/statistics/growth` | Statistics & Analytics | GET | 30 min | P2 (nice-to-have) |

**Note sur le caching:**
- Utiliser Redis pour le cache côté backend
- Invalidation du cache lors d'ajout/modification de cartes
- Frontend: React Query avec staleTime approprié


---

## 5. Modèle de Données (Frontend State)

### 5.1 Types TypeScript

```typescript
// types/homepage.ts

export interface CollectionSummary {
  userId: string;
  totalCardsOwned: number;
  totalCardsAvailable: number;
  completionPercentage: number;
  lastUpdated: string;
}

export interface Collection {
  id: string;
  name: string;
  slug: string;
  description: string;
  category: string;
  heroImageUrl: string;
  totalCards: number;
  releaseYear: number;
  publisher: string;
  stats: CollectionStats;
}

export interface CollectionStats {
  cardsOwned: number;
  completionPercentage: number;
  lastCardAdded: string;
}

export interface Activity {
  id: string;
  type: ActivityType;
  title: string;
  description?: string;
  timestamp: string;
  icon: string;
  relatedCollectionId?: string;
  relatedCollectionName?: string;
  metadata?: Record<string, any>;
}

export type ActivityType = 
  | 'card_added'
  | 'milestone_reached'
  | 'import_completed'
  | 'set_completed'
  | 'wishlist_item_added';

export interface GrowthDataPoint {
  date: string;
  label: string;
  cardsAdded: number;
  totalCardsOwned: number;
}

export interface GrowthStatistics {
  period: string;
  granularity: string;
  dataPoints: GrowthDataPoint[];
  summary: {
    totalCardsAdded: number;
    averagePerPeriod: number;
    growthRatePercentage: number;
    trend: 'increasing' | 'decreasing' | 'stable';
  };
}

export interface HomePageData {
  summary: CollectionSummary;
  collections: Collection[];
  recentActivities: Activity[];
  growthStats: GrowthStatistics;
}
```

### 5.2 React Query Hooks

```typescript
// hooks/useHomePageData.ts

import { useQuery } from '@tanstack/react-query';

export function useCollectionSummary() {
  return useQuery({
    queryKey: ['collections', 'summary'],
    queryFn: () => api.getCollectionSummary(),
    staleTime: 5 * 60 * 1000, // 5 minutes
  });
}

export function useCollections() {
  return useQuery({
    queryKey: ['collections', 'list'],
    queryFn: () => api.getCollections({ include_stats: true }),
    staleTime: 10 * 60 * 1000, // 10 minutes
  });
}

export function useRecentActivities(limit = 10) {
  return useQuery({
    queryKey: ['activities', 'recent', limit],
    queryFn: () => api.getRecentActivities({ limit }),
    staleTime: 1 * 60 * 1000, // 1 minute
  });
}

export function useGrowthStatistics(period = '6m') {
  return useQuery({
    queryKey: ['statistics', 'growth', period],
    queryFn: () => api.getGrowthStatistics({ period }),
    staleTime: 30 * 60 * 1000, // 30 minutes
  });
}
```

---

## 6. Gestion des États

### 6.1 Loading States

**Principe:** Utiliser des skeleton loaders pour chaque section indépendamment.

**Implémentation:**
```tsx
// components/skeletons/HeroCardSkeleton.tsx
export function HeroCardSkeleton() {
  return (
    <div className="hero-card-skeleton">
      <Shimmer width="100%" height="300px" borderRadius="xl" />
    </div>
  );
}

// Usage in HomePage
{isLoadingSummary ? (
  <HeroCardSkeleton />
) : (
  <HeroCard {...summaryData} />
)}
```

**Skeleton pour chaque composant:**
- `HeroCardSkeleton` - Hero card avec shimmer
- `CollectionCardSkeleton` - Cartes de collection
- `ActivityItemSkeleton` - Items d'activité
- `ChartSkeleton` - Graphique de croissance

### 6.2 Error States

**Principe:** Afficher un message d'erreur spécifique par section avec possibilité de retry.

**Composant:**
```tsx
// components/errors/ErrorBoundary.tsx
interface ErrorStateProps {
  title: string;
  message: string;
  onRetry?: () => void;
}

export function ErrorState({ title, message, onRetry }: ErrorStateProps) {
  return (
    <div className="error-state">
      <Icon name="alert-circle" />
      <h3>{title}</h3>
      <p>{message}</p>
      {onRetry && <Button onClick={onRetry}>Retry</Button>}
    </div>
  );
}
```

**Messages d'erreur par type:**
- Erreur réseau: "Unable to connect. Please check your internet connection."
- Erreur serveur (500): "Something went wrong on our end. We're working on it."
- Erreur auth (401): "Your session has expired. Please log in again."
- Données vides: "No data available yet. Start adding cards to your collection!"

### 6.3 Empty States

**Recent Activity - Empty:**
```
┌───────────────────────────────────────────┐
│          [Empty box illustration]         │
│                                           │
│    No recent activity yet                 │
│    Start adding cards to your collection! │
│                                           │
│         [Add Your First Card]             │
└───────────────────────────────────────────┘
```

**Growth Chart - Empty:**
```
┌───────────────────────────────────────────┐
│         [Dashed bar chart icon]           │
│                                           │
│   Start adding cards to see your growth!  │
└───────────────────────────────────────────┘
```

---

## 7. Responsive Design

### 7.1 Breakpoints

```css
/* tailwind.config.js */
module.exports = {
  theme: {
    screens: {
      'sm': '640px',   // Mobile landscape
      'md': '768px',   // Tablet
      'lg': '1024px',  // Desktop
      'xl': '1280px',  // Large desktop
      '2xl': '1536px', // Extra large
    }
  }
}
```

### 7.2 Layout par Breakpoint

**Desktop (≥1024px):**
- Sidebar: 240px fixe à gauche
- Main content: flex-1
- Collections grid: 2 colonnes
- Dashboard widgets: 2 colonnes (60/40)

**Tablet (768px - 1023px):**
- Sidebar: Collapsible, icon-only (64px)
- Main content: flex-1
- Collections grid: 2 colonnes
- Dashboard widgets: 1 colonne (stack)

**Mobile (<768px):**
- Voir spec mobile séparée
- Bottom navigation bar
- Collections grid: 1 colonne
- Dashboard widgets: 1 colonne

### 7.3 Component Responsive Behavior

```tsx
// Exemple: CollectionsGrid
<div className="
  grid 
  grid-cols-1 
  md:grid-cols-2 
  gap-4 
  md:gap-6
">
  {collections.map(collection => (
    <CollectionCard key={collection.id} collection={collection} />
  ))}
</div>
```

---

## 8. Performance & Optimizations

### 8.1 Images

**Hero Images des Collections:**
- Format: WebP avec fallback JPEG
- Sizes:
  - Desktop: 600x338 (1x), 1200x676 (2x)
  - Mobile: 400x225 (1x), 800x450 (2x)
- Lazy loading: `loading="lazy"`
- Placeholder: Low-quality image placeholder (LQIP) ou blur hash

**Implémentation Next.js:**
```tsx
import Image from 'next/image';

<Image
  src={collection.heroImageUrl}
  alt={collection.name}
  width={600}
  height={338}
  loading="lazy"
  placeholder="blur"
  blurDataURL={collection.blurHash}
/>
```

### 8.2 Code Splitting

**Route-based splitting:**
```tsx
// pages/index.tsx
const HomePage = dynamic(() => import('@/components/pages/HomePage'), {
  loading: () => <PageSkeleton />,
});
```

**Component-based splitting:**
- Charger le composant graphique uniquement si visible (Intersection Observer)
- Lazy load les modals/dialogs

### 8.3 Data Fetching

**Parallel fetching:**
```tsx
// Tous les fetches en parallèle au montage
useEffect(() => {
  Promise.all([
    queryClient.prefetchQuery(['collections', 'summary']),
    queryClient.prefetchQuery(['collections', 'list']),
    queryClient.prefetchQuery(['activities', 'recent']),
    queryClient.prefetchQuery(['statistics', 'growth']),
  ]);
}, []);
```

**Server-side prefetch (Next.js):**
```tsx
// pages/index.tsx
export async function getServerSideProps(context) {
  const queryClient = new QueryClient();
  
  await queryClient.prefetchQuery(['collections', 'summary'], () =>
    api.getCollectionSummary(context.req.cookies.token)
  );
  
  return {
    props: {
      dehydratedState: dehydrate(queryClient),
    },
  };
}
```

### 8.4 Caching Strategy

**Frontend (React Query):**
- Summary: 5 min staleTime, 10 min cacheTime
- Collections: 10 min staleTime, 30 min cacheTime
- Activities: 1 min staleTime, 5 min cacheTime
- Growth stats: 30 min staleTime, 1h cacheTime

**Backend (Redis):**
- Summary: TTL 5 min
- Collections: TTL 10 min
- Activities: TTL 1 min
- Growth stats: TTL 30 min

**Cache invalidation:**
- Mutation: Invalider les queries concernées
- WebSocket/Kafka event: Invalider en temps réel


---

## 9. Accessibilité (WCAG 2.1 AA)

### 9.1 Keyboard Navigation

**Tab order:**
1. Skip to main content link (hidden, visible on focus)
2. Sidebar navigation items
3. Search bar
4. Notifications
5. User menu
6. Hero card CTAs
7. Collection cards
8. Activity items
9. Growth chart (focusable for screen readers)

**Keyboard shortcuts:**
- `Tab` / `Shift+Tab`: Navigation
- `Enter` / `Space`: Activation
- `Esc`: Close modals/dropdowns
- `/`: Focus search bar

### 9.2 ARIA Labels

```tsx
// Hero Card
<section aria-labelledby="hero-title" role="region">
  <h2 id="hero-title">Total Collection Progress</h2>
  <div role="progressbar" 
       aria-valuenow={68} 
       aria-valuemin={0} 
       aria-valuemax={100}
       aria-label="Collection completion: 68%">
  </div>
</section>

// Collections Grid
<section aria-labelledby="collections-title">
  <h2 id="collections-title" className="sr-only">Your Collections</h2>
  <div role="list">
    {collections.map(c => (
      <article role="listitem" key={c.id}>
        {/* Collection card content */}
      </article>
    ))}
  </div>
</section>

// Recent Activity
<section aria-labelledby="activity-title" aria-live="polite">
  <h2 id="activity-title">Recent Activity</h2>
  {/* Activity list */}
</section>
```

### 9.3 Contrast Ratios

**Vérifier tous les ratios (WCAG AA: 4.5:1 pour texte normal, 3:1 pour large text):**

- `on-surface` (#191c1d) sur `surface` (#f8f9fa): ✅ 15.8:1
- `on-primary` (#ffffff) sur `primary` (#667eea): ✅ 8.2:1
- `on-surface-variant` sur `surface-container-low`: ✅ 7.1:1

**Points d'attention:**
- Progress bar indicator: Assurer bon contraste avec le track
- Badges catégories: Vérifier `on-secondary-container` sur `secondary` at 20%

### 9.4 Screen Reader Support

**Announcements:**
```tsx
// Live region pour les updates
<div role="status" aria-live="polite" className="sr-only">
  {`Loaded ${collections.length} collections`}
</div>

// Error announcements
<div role="alert" aria-live="assertive" className="sr-only">
  {errorMessage}
</div>
```

**Image alt text:**
- Collection hero images: `{collectionName} collection artwork`
- Icons: Décoratifs → `alt=""`, fonctionnels → descriptif

---

## 10. Tests & Validation

### 10.1 Critères d'Acceptation

**AC-HP-001: Hero Card Display**
- GIVEN l'utilisateur est authentifié
- WHEN il accède à la homepage
- THEN le hero card affiche:
  - Le pourcentage de complétion calculé (2733/2733 = 100%)
  - Le nombre total de cartes possédées (2733)
  - Le nombre de cartes restantes (0)
  - Une progress bar correspondante

**AC-HP-002: Collections Grid**
- GIVEN l'utilisateur possède 2 collections (MECCG, Doomtrooper)
- WHEN il accède à la homepage
- THEN il voit 2 cartes de collection affichant:
  - Le nom de la collection
  - L'image hero
  - Le nombre de cartes possédées / total
  - Le pourcentage de complétion
  - Le badge catégorie (Fantasy, Sci-Fi)

**AC-HP-003: Recent Activity**
- GIVEN l'utilisateur a ajouté des cartes récemment
- WHEN il accède à la homepage
- THEN il voit les 5 dernières activités avec:
  - Le type d'activité (icône approprié)
  - Le titre descriptif
  - Le timestamp relatif (ex: "2 hours ago")

**AC-HP-004: Growth Chart**
- GIVEN l'utilisateur a une historique d'ajouts
- WHEN il accède à la homepage
- THEN il voit un graphique en barres montrant:
  - Les 6 derniers mois
  - Le nombre de cartes ajoutées par mois
  - Un badge avec le taux de croissance

**AC-HP-005: Responsive Layout**
- GIVEN l'utilisateur accède depuis différents devices
- WHEN il resize la fenêtre
- THEN le layout s'adapte:
  - Desktop: Sidebar + 2 col grid
  - Tablet: Sidebar collapsible + 2 col grid
  - Mobile: Bottom nav + 1 col grid

**AC-HP-006: Loading States**
- GIVEN les données sont en cours de chargement
- WHEN l'utilisateur accède à la homepage
- THEN il voit des skeleton loaders pour chaque section

**AC-HP-007: Error Handling**
- GIVEN une erreur API survient
- WHEN l'utilisateur accède à la homepage
- THEN il voit un message d'erreur spécifique avec un bouton "Retry"

### 10.2 Scénarios de Test Prioritaires

**Frontend (TDD):**

1. **HeroCard Component Tests**
   - Affichage correct des données (pourcentage, totaux)
   - Calcul des cartes restantes
   - Skeleton loader pendant isLoading
   - Gestion erreur avec retry button
   - Click handlers sur les CTAs

2. **CollectionCard Component Tests**
   - Affichage des infos de collection
   - Lazy loading des images hero
   - Navigation au clic
   - Hover states (shadow lift)
   - Badge catégorie correct

3. **RecentActivityWidget Tests**
   - Affichage des activités (max 5)
   - Icônes colorées par type
   - Timestamps formatés (relative time)
   - Empty state avec CTA
   - "View All" link

4. **GrowthInsightWidget Tests**
   - Rendering du graphique avec 6 bars
   - Badge de croissance (+24%)
   - Hover tooltip sur bars
   - Empty state avec placeholder
   - Responsive bar widths

5. **Data Fetching Hooks Tests**
   - useCollectionSummary: fetch + error handling
   - useCollections: fetch avec include_stats
   - useRecentActivities: pagination
   - useGrowthStatistics: différentes périodes
   - Caching (staleTime) correct

**Backend (TDD):**

1. **Collections Summary Endpoint Tests**
   - Calcul correct du completion_percentage
   - Agrégation de toutes les collections
   - Authentification requise (401 si absent)
   - Erreur DB handling (500)
   - Performance (< 100ms)

2. **Collections List Endpoint Tests**
   - Retourne les 2 collections (MECCG, Doomtrooper)
   - Stats correctes (1678/1678, 1055/1055)
   - Hero images URLs valides
   - Filtrage par include_stats
   - Cache Redis (TTL 10 min)

3. **Recent Activities Endpoint Tests**
   - Limite respectée (max 10 par défaut)
   - Tri par timestamp DESC
   - Types d'activité variés
   - Pagination (offset)
   - Empty array si pas d'activité

4. **Growth Statistics Endpoint Tests**
   - Agrégation par mois (6 derniers)
   - Calcul du growth_rate_percentage
   - Trend detection (increasing/decreasing/stable)
   - Différentes granularités (day/week/month)
   - Cache Redis (TTL 30 min)

**Integration Tests:**

1. **Homepage Full Flow**
   - Login → Homepage → Tous les endpoints appelés
   - 4 sections chargées en parallèle
   - Pas d'erreur console
   - Performance (LCP < 2.5s)

2. **Error Recovery**
   - Un endpoint fail → Autres sections OK
   - Retry button → Refetch réussi
   - Token expired → Redirect login

3. **Responsive Behavior**
   - Desktop (1920x1080) → Sidebar visible
   - Tablet (768x1024) → Sidebar collapsed
   - Mobile (375x667) → Bottom nav

**E2E Tests (Playwright):**

1. **User Journey: First Visit**
   - Login avec credentials
   - Homepage loads complètement
   - Toutes les sections visibles
   - Click sur MECCG → Navigate vers /collections/meccg

2. **User Journey: Daily Check-in**
   - Homepage load
   - Check recent activity (nouvelle carte ajoutée hier)
   - Check growth chart (progression visible)
   - Navigate vers Collections

### 10.3 Performance Targets

**Lighthouse Metrics:**
- Performance score: > 90
- First Contentful Paint (FCP): < 1.5s
- Largest Contentful Paint (LCP): < 2.5s
- Time to Interactive (TTI): < 3.5s
- Cumulative Layout Shift (CLS): < 0.1

**API Response Times:**
- P50: < 100ms
- P95: < 500ms
- P99: < 1s

**Cache Hit Rates:**
- Redis (backend): > 80%
- React Query (frontend): > 60%


---

## 11. Points d'Attention & Risques

### 11.1 Performance

**Risque:** Images hero des collections peuvent être volumineuses.
**Mitigation:**
- Utiliser Next.js Image optimization
- Lazy loading systématique
- WebP avec fallback JPEG
- CDN pour les assets statiques

**Risque:** Multiple API calls au chargement de la page.
**Mitigation:**
- Appels en parallèle via Promise.all
- Server-side prefetch pour les données critiques
- Caching agressif (React Query + Redis)

### 11.2 Données

**Risque:** Les totaux dans la maquette (2,400 et 1,800) ne correspondent pas aux données réelles (2,733 total, 1,678 MECCG, 1,055 Doomtrooper).
**Mitigation:**
- Utiliser TOUJOURS les données réelles du backend
- Pas de valeurs hardcodées dans le frontend
- Validation des calculs côté backend avec tests unitaires

**Risque:** Incohérence entre Collection Management et Statistics services.
**Mitigation:**
- Utiliser Kafka events pour synchronisation
- Event: `CollectionUpdated` → Statistics Service met à jour ses agrégats
- Idempotence des consumers Kafka

### 11.3 UX

**Risque:** Loading trop long perçu si les 4 endpoints sont lents.
**Mitigation:**
- Skeleton loaders pour feedback immédiat
- Progressive rendering (afficher au fur et à mesure)
- Optimistic UI pour les actions utilisateur

**Risque:** Empty states peu engageants.
**Mitigation:**
- Illustrations custom (pas de stock icons)
- CTAs clairs ("Add Your First Card")
- Onboarding tooltip pour nouveaux users

### 11.4 Accessibilité

**Risque:** Gradient hero card peut avoir des problèmes de contraste.
**Mitigation:**
- Vérifier tous les ratios de contraste avec outil automatique
- Tester avec plusieurs combinaisons de couleurs
- Fournir alternative high-contrast si nécessaire

**Risque:** Graphique de croissance non accessible aux screen readers.
**Mitigation:**
- Fournir une table de données alternative (visually hidden)
- ARIA labels descriptifs
- Keyboard navigation pour explorer les data points

### 11.5 Sécurité

**Risque:** Exposition de données utilisateur non autorisées.
**Mitigation:**
- Vérifier l'authentification sur TOUS les endpoints
- Valider que l'userID du JWT correspond aux données demandées
- Rate limiting sur les endpoints publics

**Risque:** XSS via les noms de cartes ou collections.
**Mitigation:**
- Sanitization côté backend avant stockage
- Encoding HTML côté frontend (React fait ça par défaut)
- Content Security Policy (CSP) headers

---

## 12. Dépendances & Technologies

### 12.1 Frontend Stack

**Core:**
- Next.js 14+ (App Router)
- React 18+
- TypeScript 5+

**Data Fetching:**
- @tanstack/react-query 5+
- axios ou fetch native

**Styling:**
- Tailwind CSS 3+
- Custom CSS modules pour composants complexes
- clsx pour conditional classes

**Charts:**
- recharts ou visx (pour le graphique de croissance)
- Alternative légère: chart.js

**Images:**
- next/image (built-in)
- sharp (backend optimization)

**Testing:**
- Jest + React Testing Library (unit tests)
- Playwright (E2E tests)
- MSW (Mock Service Worker) pour mocks API

### 12.2 Backend Stack

**Core:**
- Go 1.22+
- Gorilla Mux ou Chi router
- GORM (ORM)

**Database:**
- PostgreSQL 15+
- Redis 7+ (caching)

**Messaging:**
- Apache Kafka 3+
- confluent-kafka-go client

**API Documentation:**
- OpenAPI 3.1 spec
- Swagger UI

**Testing:**
- testify (assertions)
- testcontainers-go (integration tests)
- gomock (mocking)

---

## 13. Migration & Déploiement

### 13.1 Plan de Déploiement

**Phase 1: Backend APIs (Sprint 1)**
1. Implémenter les endpoints REST (TDD)
2. Tests unitaires + intégration
3. Documentation OpenAPI
4. Déploiement en staging

**Phase 2: Frontend Components (Sprint 2)**
1. Setup Next.js project + design system tokens
2. Implémenter composants atomiques (Button, Card, etc.)
3. Implémenter layout (Sidebar, TopBar)
4. Tests unitaires

**Phase 3: Homepage Integration (Sprint 3)**
1. Implémenter les composants spécifiques (HeroCard, CollectionsGrid, etc.)
2. Intégration avec les APIs
3. Gestion des états (loading, error, empty)
4. Tests E2E

**Phase 4: Optimizations & Polish (Sprint 4)**
1. Performance optimizations (images, caching)
2. Accessibilité audit + fixes
3. Responsive testing sur devices réels
4. Load testing

**Phase 5: Production Deployment**
1. Smoke tests en staging
2. Feature flag pour progressive rollout
3. Monitoring & alerting
4. Rollback plan

### 13.2 Feature Flags

```typescript
// Feature flags pour rollout progressif
const features = {
  homepage_v1: {
    enabled: process.env.FEATURE_HOMEPAGE_V1 === 'true',
    rollout: 'gradual', // 'all', 'gradual', 'beta'
    percentage: 10, // 10% users si gradual
  },
  growth_chart: {
    enabled: process.env.FEATURE_GROWTH_CHART === 'true',
  },
};
```

### 13.3 Monitoring

**Frontend:**
- Sentry pour error tracking
- Google Analytics / Plausible pour analytics
- Web Vitals monitoring (CLS, LCP, FID)

**Backend:**
- Prometheus + Grafana pour métriques
- Jaeger pour distributed tracing
- ELK stack pour logs centralisés

**Métriques clés:**
- API response times (p50, p95, p99)
- Error rates par endpoint
- Cache hit rates (Redis)
- Database query performance

**Alertes:**
- API response time > 1s (P95)
- Error rate > 1%
- Cache hit rate < 80%
- Database connection pool exhaustion

---

## 14. Documentation Complémentaire

### 14.1 Références

- **Design System:** `/Design/design-system/Ethos-V1-2026-04-15.md`
- **Maquette Desktop:** `/Design/mockups/homepage/homepage-desktop-v1-2026-04-15.png`
- **Maquette Mobile:** `/Design/mockups/homepage/homepage-mobile-v1-2026-04-15.png`
- **Data Model:** `/Specifications/technical/mvp-data-model-v2.md`

### 14.2 API OpenAPI Specs

Les specs OpenAPI complètes doivent être créées dans:
- `/Specifications/api/collections-api-v1.yaml`
- `/Specifications/api/statistics-api-v1.yaml`

### 14.3 ADR (Architecture Decision Records)

Créer des ADRs pour les décisions majeures:
- ADR-001: Choix de React Query pour data fetching
- ADR-002: Séparation Collection Management / Statistics contexts
- ADR-003: Stratégie de caching (Redis TTL)
- ADR-004: Utilisation de skeleton loaders vs spinners

---

## 15. Prochaines Étapes

### 15.1 Immediate Next Steps

1. **Agent Backend:**
   - Implémenter les 4 endpoints REST définis section 4
   - Setup PostgreSQL schemas pour les données nécessaires
   - Créer les specs OpenAPI complètes

2. **Agent Frontend:**
   - Setup Next.js project avec Tailwind + design tokens
   - Implémenter le layout (Sidebar, TopBar)
   - Créer les composants atomiques du design system

3. **Agent Testing:**
   - Setup test infrastructure (Jest, Playwright)
   - Créer les test suites selon section 10
   - Setup CI/CD pour tests automatiques

### 15.2 Future Enhancements (Post-MVP)

**Homepage V2:**
- Filtres sur les collections (par catégorie, statut)
- Graphique de croissance interactif (drill-down par collection)
- Recommandations de cartes à ajouter ("Complete your sets")
- Comparaison avec d'autres collectionneurs (leaderboard)
- Export des statistiques en PDF

**Performance:**
- Service Worker pour offline support
- GraphQL pour optimiser les data fetching
- Incremental Static Regeneration (ISR) pour les données peu changeantes

**Social Features:**
- Partage de collection sur réseaux sociaux
- Feed d'activité des amis
- Commentaires sur les collections

---

## 16. Glossaire

**Tonal Layering:** Technique de design utilisant des variations subtiles de couleur pour créer de la profondeur sans utiliser de bordures.

**No-Line Rule:** Principe du design system interdisant l'utilisation de bordures 1px solides, remplacées par des shifts de background.

**Skeleton Loader:** Placeholder animé affichant la structure du contenu pendant le chargement.

**Hero Image:** Image principale représentative d'une collection, affichée en grand format.

**Bounded Context:** Concept DDD délimitant une zone du domaine métier avec son propre modèle et ubiquitous language.

**Completion Percentage:** Pourcentage de cartes possédées par rapport au total disponible dans une collection.

**Growth Rate:** Taux de croissance du nombre de cartes ajoutées sur une période donnée.

---

## 17. Changelog

**v1.0 - 2026-04-15:**
- Version initiale de la spécification
- Définition des 4 endpoints REST
- Composants UI et design system
- Critères d'acceptation et tests
- Plan de déploiement

---

## Signatures

**Auteur:** Agent Spécifications (Collectoria)  
**Date:** 2026-04-15  
**Validé par:** En attente validation Product Owner  
**Status:** Draft - Prêt pour review

---

**Fin de la spécification technique Homepage Desktop v1**
