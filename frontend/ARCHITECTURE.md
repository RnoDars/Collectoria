# Architecture Frontend - HeroCard Integration

## Vue d'Ensemble

```
┌─────────────────────────────────────────────────────────────────┐
│                      Browser (localhost:3000)                    │
│                                                                   │
│  ┌─────────────────────────────────────────────────────────┐   │
│  │             Page: /test-backend (Client Component)       │   │
│  │                                                           │   │
│  │  ┌─────────────────────────────────────────────────┐    │   │
│  │  │         useCollectionSummary Hook               │    │   │
│  │  │         (React Query)                           │    │   │
│  │  │                                                   │    │   │
│  │  │  ┌──────────────────────────────────────────┐  │    │   │
│  │  │  │    QueryClient                            │  │    │   │
│  │  │  │    - Cache (5min staleTime)              │  │    │   │
│  │  │  │    - Retry (3x with backoff)             │  │    │   │
│  │  │  └──────────────────────────────────────────┘  │    │   │
│  │  │                     │                            │    │   │
│  │  │                     ▼                            │    │   │
│  │  │  ┌──────────────────────────────────────────┐  │    │   │
│  │  │  │    fetchCollectionSummary()              │  │    │   │
│  │  │  │    /lib/api/collections.ts               │  │    │   │
│  │  │  └──────────────────────────────────────────┘  │    │   │
│  │  └─────────────────────────────────────────────────┘    │   │
│  │                     │                                      │   │
│  │                     ▼                                      │   │
│  │  ┌─────────────────────────────────────────────────┐    │   │
│  │  │              HeroCard Component                  │    │   │
│  │  │                                                   │    │   │
│  │  │  States:                                         │    │   │
│  │  │  - Loading    → HeroCardSkeleton                │    │   │
│  │  │  - Error      → Error message + Retry           │    │   │
│  │  │  - Empty      → No data message                 │    │   │
│  │  │  - Success    → Display stats (60%)             │    │   │
│  │  └─────────────────────────────────────────────────┘    │   │
│  └─────────────────────────────────────────────────────────┘   │
│                                                                   │
└────────────────────────────┬──────────────────────────────────┘
                             │
                             │ HTTP GET
                             │ (CORS: localhost:3000 allowed)
                             ▼
┌─────────────────────────────────────────────────────────────────┐
│                  Backend API (localhost:8080)                    │
│                                                                   │
│  ┌─────────────────────────────────────────────────────────┐   │
│  │         GET /api/v1/collections/summary                  │   │
│  │                                                           │   │
│  │  ┌──────────────────────────────────────────────────┐  │   │
│  │  │  Response:                                        │  │   │
│  │  │  {                                                │  │   │
│  │  │    "user_id": "...",                             │  │   │
│  │  │    "total_cards_owned": 24,                      │  │   │
│  │  │    "total_cards_available": 40,                  │  │   │
│  │  │    "completion_percentage": 60,                  │  │   │
│  │  │    "last_updated": "2026-04-16T15:13:39Z"       │  │   │
│  │  │  }                                                │  │   │
│  │  └──────────────────────────────────────────────────┘  │   │
│  └─────────────────────────────────────────────────────────┘   │
│                                                                   │
└─────────────────────────────────────────────────────────────────┘
```

## Structure des Fichiers

```
frontend/
├── src/
│   ├── app/
│   │   ├── layout.tsx                    # Root layout + Providers + Fonts
│   │   ├── providers.tsx                 # QueryClientProvider setup
│   │   ├── page.tsx                      # Homepage avec lien vers test
│   │   ├── globals.css                   # Design System CSS vars
│   │   └── test-backend/
│   │       └── page.tsx                  # Page de test interactive
│   │
│   ├── components/
│   │   └── homepage/
│   │       └── HeroCard.tsx              # Composant principal
│   │                                     # + HeroCardSkeleton
│   │
│   ├── hooks/
│   │   └── useCollectionSummary.ts       # React Query hook
│   │
│   └── lib/
│       └── api/
│           └── collections.ts            # API client + types
│
├── package.json                          # + @tanstack/react-query
├── tsconfig.json                         # Paths alias: @/*
├── .env.local.example                    # NEXT_PUBLIC_API_URL
├── README-HEROCARD.md                    # Documentation détaillée
├── INTEGRATION-CHECKLIST.md              # Checklist validation
└── ARCHITECTURE.md                       # Ce fichier
```

## Flux de Données

### 1. Initialization (App Start)

```
layout.tsx
  └─> <Providers> wraps children
        └─> QueryClientProvider initialized
              - staleTime: 5 minutes
              - gcTime: 10 minutes
              - retry: 3 with exponential backoff
```

### 2. Page Load (/test-backend)

```
TestBackendPage renders
  └─> useCollectionSummary() hook called
        └─> React Query checks cache
              │
              ├─> Cache HIT (data < 5min old)
              │     └─> Return cached data immediately
              │
              └─> Cache MISS or stale
                    └─> fetchCollectionSummary() called
                          └─> HTTP GET to backend
                                │
                                ├─> Success (200)
                                │     └─> Transform snake_case to camelCase
                                │           └─> Cache data
                                │                 └─> Return data
                                │
                                └─> Error (4xx/5xx)
                                      └─> Retry #1 (after 1s)
                                            └─> Retry #2 (after 2s)
                                                  └─> Retry #3 (after 4s)
                                                        └─> Return error
```

### 3. Component Rendering

```
HeroCard receives props
  │
  ├─> isLoading = true
  │     └─> Render HeroCardSkeleton (shimmer animation)
  │
  ├─> error != null
  │     └─> Render error state
  │           - ⚠️ icon
  │           - Error message
  │           - Retry button → calls refetch()
  │
  ├─> summary == null
  │     └─> Render empty state
  │
  └─> summary != null (SUCCESS)
        └─> Render full component
              - Calculate percentage
              - Calculate cardsToGo
              - Render progress bar (animated width)
              - Render stats
              - Render action buttons
```

## Design System Integration

### CSS Variables (globals.css)

```css
:root {
  /* Surfaces - Tonal Layering */
  --surface: #f8f9fa;
  --surface-container-lowest: #ffffff;
  --surface-container-high: #e8e9ea;
  --surface-container-highest: #e1e3e4;

  /* Primary */
  --primary: #667eea;
  --primary-container: #764ba2;
  --on-primary: #ffffff;

  /* Typography */
  --on-surface: #191c1d;
  --on-surface-variant: #43474e;

  /* Fonts */
  --font-editorial: 'Manrope', sans-serif;
  --font-utility: 'Inter', sans-serif;

  /* Border Radius */
  --radius-md: 8px;
  --radius-lg: 16px;
  --radius-xl: 24px;

  /* Spacing */
  --spacing-md: 12px;
  --spacing-xl: 24px;
  --spacing-2xl: 32px;
}
```

### Typography Scale

| Element | Family | Size | Weight | Color |
|---------|--------|------|--------|-------|
| Dashboard Overview | Inter | 12px | 600 | #43474e |
| Total Collection Progress | Manrope | 30px | 700 | #191c1d |
| 60% | Manrope | 64px | 800 | gradient |
| completed | Inter | 14px | 500 | #43474e |
| Stats | Inter | 14px | 400 | #43474e |
| Buttons | Inter | 14px | 600 | varies |

### Color Usage

```
Page Background: #f8f9fa (--surface)
  └─> HeroCard: #ffffff (--surface-container-lowest)
        ├─> Progress Track: #e1e3e4 (--surface-container-highest)
        ├─> Progress Fill: linear-gradient(#667eea → #764ba2)
        ├─> Primary Button: linear-gradient(#667eea → #764ba2)
        └─> Secondary Buttons: #e8e9ea (--surface-container-high)
```

## React Query Configuration

### QueryClient Options

```typescript
new QueryClient({
  defaultOptions: {
    queries: {
      staleTime: 5 * 60 * 1000,     // 5 minutes
      gcTime: 10 * 60 * 1000,        // 10 minutes (garbage collection)
    },
  },
})
```

### Hook Configuration

```typescript
useQuery({
  queryKey: ['collections', 'summary'],
  queryFn: fetchCollectionSummary,
  staleTime: 5 * 60 * 1000,
  retry: 3,
  retryDelay: (attemptIndex) => Math.min(1000 * 2 ** attemptIndex, 30000),
})
```

### Query States

| State | isLoading | error | data | UI Rendered |
|-------|-----------|-------|------|-------------|
| Initial | true | null | undefined | Skeleton |
| Loading | true | null | undefined | Skeleton |
| Error | false | Error | undefined | Error + Retry |
| Success | false | null | CollectionSummary | Full component |
| Refetching | false | null | CollectionSummary (stale) | Full component |

## API Contract

### Request

```http
GET http://localhost:8080/api/v1/collections/summary
Content-Type: application/json
```

### Response (Backend - snake_case)

```json
{
  "user_id": "00000000-0000-0000-0000-000000000001",
  "total_cards_owned": 24,
  "total_cards_available": 40,
  "completion_percentage": 60,
  "last_updated": "2026-04-16T15:13:39Z"
}
```

### Response (Frontend - camelCase)

```typescript
{
  userId: "00000000-0000-0000-0000-000000000001",
  totalCardsOwned: 24,
  totalCardsAvailable: 40,
  completionPercentage: 60,
  lastUpdated: "2026-04-16T15:13:39Z"
}
```

## Performance Considerations

### Caching Strategy

- **First Visit**: Network request → 5min fresh → 10min total retention
- **Subsequent Visits (< 5min)**: Instant from cache
- **Stale Data (5-10min)**: Shown immediately + background refetch
- **After 10min**: Removed from cache → new network request

### Bundle Size

```
Route (app)                Size    First Load JS
/test-backend              6.08 kB   117 kB
  ├─ React Query           ~46 kB
  ├─ React 19              ~54 kB
  └─ Page code             ~6 kB
```

### Network

- **Retry policy**: Prevents backend overload
- **CORS**: Pre-configured, no preflight issues
- **Error handling**: User-friendly messages

## Testing Strategy

### Manual Testing

1. **Happy Path**
   - Backend running
   - Page loads
   - Data displays correctly (60%)
   - Progress bar animated

2. **Error Path**
   - Backend stopped
   - Error message appears
   - Retry button works
   - Refetch succeeds when backend restarted

3. **Loading Path**
   - Slow network simulation
   - Skeleton loader visible
   - Smooth transition to data

### Future Automated Tests

```typescript
// Unit Tests (Jest + RTL)
describe('HeroCard', () => {
  it('renders skeleton when loading')
  it('renders error state with retry button')
  it('renders data correctly')
  it('calculates cardsToGo correctly')
})

// Integration Tests (Playwright)
describe('Backend Integration', () => {
  it('fetches and displays collection summary')
  it('handles backend errors gracefully')
  it('retries failed requests')
})
```

## CORS Configuration

### Backend (Go)

```go
// backend/collection-management/internal/infrastructure/http/server.go
s.router.Use(func(next http.Handler) http.Handler {
  return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
    w.Header().Set("Access-Control-Allow-Origin", "http://localhost:3000")
    w.Header().Set("Access-Control-Allow-Methods", "GET, POST, PUT, DELETE, OPTIONS")
    w.Header().Set("Access-Control-Allow-Headers", "Content-Type, Authorization")
    
    if r.Method == "OPTIONS" {
      w.WriteHeader(http.StatusOK)
      return
    }
    
    next.ServeHTTP(w, r)
  })
})
```

## Next Steps

### Immediate
1. Test manuel de l'intégration
2. Valider que le backend retourne bien les données attendues
3. Vérifier que tous les états (loading/error/success) s'affichent correctement

### Short Term
- Créer `CollectionsGrid` component
- Intégrer endpoint `/api/v1/collections`
- Ajouter tests unitaires

### Long Term
- Tests E2E automatisés
- Authentification (JWT)
- Responsive design (mobile)
- Dark mode
- Animations avancées

---

**Auteur**: Agent Frontend - Collectoria  
**Date**: 2026-04-16  
**Version**: 1.0
