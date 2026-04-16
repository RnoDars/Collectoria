# HeroCard Component - Backend Integration

## Vue d'ensemble

Le composant `HeroCard` est le premier composant frontend qui consomme l'API backend de Collectoria. Il affiche les statistiques globales de la collection de l'utilisateur en respectant strictement l'Ethos de design "The Digital Curator".

## Architecture

```
frontend/
├── src/
│   ├── app/
│   │   ├── providers.tsx          # React Query Provider
│   │   ├── layout.tsx             # Layout avec Providers et fonts
│   │   └── test-backend/          # Page de test
│   │       └── page.tsx
│   ├── components/
│   │   └── homepage/
│   │       └── HeroCard.tsx       # Composant principal
│   ├── hooks/
│   │   └── useCollectionSummary.ts # Hook React Query
│   └── lib/
│       └── api/
│           └── collections.ts      # Client API
```

## Installation

### 1. Dépendances

```bash
cd frontend
npm install @tanstack/react-query
```

### 2. Configuration

Créer `.env.local` (optionnel, par défaut `http://localhost:8080`) :

```bash
NEXT_PUBLIC_API_URL=http://localhost:8080
```

## Utilisation

### Page de Test

Accéder à la page de test : [http://localhost:3000/test-backend](http://localhost:3000/test-backend)

Cette page permet de :
- Tester la connexion au backend
- Visualiser le composant HeroCard
- Voir les données en temps réel
- Débugger avec les infos JSON

### Intégration dans une page

```tsx
'use client'

import HeroCard from '@/components/homepage/HeroCard'
import { useCollectionSummary } from '@/hooks/useCollectionSummary'

export default function HomePage() {
  const { data, isLoading, error, refetch } = useCollectionSummary()

  return (
    <HeroCard
      summary={data}
      isLoading={isLoading}
      error={error as Error | null}
      onRetry={() => refetch()}
    />
  )
}
```

## Design System - Respect de l'Ethos V1

### Principes appliqués

✅ **No-Line Rule** : Pas de bordures 1px, uniquement du tonal layering
✅ **Dual-Type System** : Manrope (headlines) + Inter (body/labels)
✅ **Gradient violet** : Utilisé avec parcimonie (progress bar, bouton primary)
✅ **Border radius** : `lg` (16px) pour la carte, `xl` (24px) pour les boutons
✅ **Tonal Layering** : Background `#ffffff` sur `#f8f9fa`

### Couleurs utilisées

- **Surface** : `#f8f9fa` (background page)
- **Surface Container Lowest** : `#ffffff` (background carte)
- **Surface Container Highest** : `#e1e3e4` (progress bar track)
- **Surface Container High** : `#e8e9ea` (boutons secondaires)
- **Primary** : `#667eea` → `#764ba2` (gradient)
- **On Surface** : `#191c1d` (texte principal)
- **On Surface Variant** : `#43474e` (texte secondaire)

### Typography

- **Dashboard Overview** : `label-sm` (Inter, 12px, uppercase)
- **Total Collection Progress** : `headline-lg` (Manrope, 30px, bold)
- **Pourcentage (60%)** : `display-xl` (Manrope, 64px, extra-bold)
- **"completed"** : `body-sm` (Inter, 14px)
- **Stats** : `body-md` (Inter, 14px)
- **Boutons** : `label-md` (Inter, 14px, semi-bold)

## États Gérés

### 1. Loading State

- Skeleton loader avec animation shimmer
- Même dimensions que le composant final
- Pas de spinners (conformément à l'Ethos)

### 2. Error State

- Message d'erreur clair
- Bouton "Retry" pour retenter
- Icône d'alerte visible

### 3. Success State

- Affichage des données
- Progress bar animée
- Statistiques détaillées
- Boutons d'action

## API Backend

### Endpoint

```
GET http://localhost:8080/api/v1/collections/summary
```

### Response

```json
{
  "user_id": "00000000-0000-0000-0000-000000000001",
  "total_cards_owned": 24,
  "total_cards_available": 40,
  "completion_percentage": 60,
  "last_updated": "2026-04-16T15:13:39Z"
}
```

### Transformation

Le client API transforme automatiquement `snake_case` en `camelCase` :

```typescript
{
  userId: "00000000-0000-0000-0000-000000000001",
  totalCardsOwned: 24,
  totalCardsAvailable: 40,
  completionPercentage: 60,
  lastUpdated: "2026-04-16T15:13:39Z"
}
```

## Configuration React Query

### Stratégie de cache

- **staleTime** : 5 minutes (les données sont considérées fraîches pendant 5 min)
- **gcTime** : 10 minutes (garbage collection après 10 min d'inactivité)
- **retry** : 3 tentatives avec backoff exponentiel
- **retryDelay** : 1s → 2s → 4s (max 30s)

### Provider Setup

Le `QueryClientProvider` est configuré dans `app/providers.tsx` et wrappé dans `layout.tsx`, ce qui permet à tous les composants de l'application d'accéder à React Query.

## Tests

### Test Manuel

1. Démarrer le backend :
```bash
cd backend/collection-management
go run cmd/api/main.go
```

2. Démarrer le frontend :
```bash
cd frontend
npm run dev
```

3. Accéder à : [http://localhost:3000/test-backend](http://localhost:3000/test-backend)

### Vérifications

- ✅ Le backend status est **vert** (Connected successfully)
- ✅ Le HeroCard affiche **24/40 cards = 60%**
- ✅ La progress bar est remplie à **60%**
- ✅ Le gradient violet est visible sur la barre et le bouton primary
- ✅ Les boutons ont des hover effects (scale + background change)
- ✅ Le Debug Info affiche les données JSON correctes

### Test d'Erreur

1. Arrêter le backend
2. Rafraîchir la page de test
3. Vérifier que :
   - Le status est **rouge** (Connection failed)
   - Un message d'erreur s'affiche
   - Le bouton "Retry" est présent
   - Cliquer sur "Retry" relance la requête

## Prochaines Étapes

### Composants à créer

1. **CollectionsGrid** : Affichage des collections individuelles (MECCG, Doomtrooper)
2. **RecentActivityWidget** : Liste des activités récentes
3. **GrowthInsightWidget** : Graphique de croissance

### Endpoints à intégrer

- `GET /api/v1/collections` - Liste des collections
- `GET /api/v1/activities/recent` - Activités récentes
- `GET /api/v1/statistics/growth` - Statistiques de croissance

## Troubleshooting

### Port 3000 déjà utilisé

Si Next.js utilise le port 3001 :
```bash
# Tuer le processus sur le port 3000
npx kill-port 3000
# Ou laisser Next.js utiliser 3001
```

### CORS Error

Si erreur CORS, vérifier que le backend a bien le middleware :
```go
// backend/collection-management/internal/infrastructure/http/server.go
w.Header().Set("Access-Control-Allow-Origin", "http://localhost:3000")
```

### Module not found

Si erreur `Cannot find module '@/...'` :
```bash
# Vérifier tsconfig.json
cat tsconfig.json | grep "paths"

# Doit contenir :
"paths": {
  "@/*": ["./src/*"]
}
```

## Ressources

- **Spécifications** : `/Specifications/technical/homepage-desktop-v1.md`
- **Design System** : `/Design/design-system/Ethos-V1-2026-04-15.md`
- **Backend README** : `/backend/collection-management/README.md`

## Auteur

**Agent Frontend** - Collectoria
Date : 2026-04-16
Version : 1.0
