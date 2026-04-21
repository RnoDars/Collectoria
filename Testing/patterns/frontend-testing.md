# Frontend Testing Patterns - Collectoria

## Vue d'ensemble

Ce document décrit les patterns de tests frontend établis pour Collectoria. Notre infrastructure de tests utilise **Vitest** et **React Testing Library** pour tester les composants React de manière maintenable et efficace.

## Stack de Tests

- **Vitest** : Framework de test rapide, compatible avec Vite et Next.js
- **@testing-library/react** : Utilitaires pour tester les composants React
- **@testing-library/jest-dom** : Matchers personnalisés pour améliorer la lisibilité
- **@testing-library/user-event** : Simulation d'interactions utilisateur
- **jsdom** : Environnement DOM pour les tests

## Configuration

### Fichier `vitest.config.ts`

```typescript
import { defineConfig } from 'vitest/config'
import react from '@vitejs/plugin-react'
import path from 'path'

export default defineConfig({
  plugins: [react()],
  test: {
    environment: 'jsdom',
    globals: true,
    setupFiles: ['./src/tests/setup.ts'],
    css: true,
    coverage: {
      provider: 'v8',
      reporter: ['text', 'json', 'html'],
    },
  },
  resolve: {
    alias: {
      '@': path.resolve(__dirname, './src'),
    },
  },
})
```

### Fichier de setup (`src/tests/setup.ts`)

```typescript
import '@testing-library/jest-dom'
import { expect, afterEach } from 'vitest'
import { cleanup } from '@testing-library/react'

// Cleanup après chaque test
afterEach(() => {
  cleanup()
})
```

## Pattern de Test pour Composants React

### Structure de Base

Chaque composant doit être testé selon ses **4 états principaux** :

1. **Loading** - Affichage des skeletons/loaders
2. **Error** - Gestion des erreurs
3. **Empty** - Aucune donnée disponible
4. **Success** - Données affichées correctement

### Exemple : Test d'un Composant

```typescript
import { describe, it, expect, vi } from 'vitest'
import { render, screen } from '@testing-library/react'
import userEvent from '@testing-library/user-event'
import MyComponent from '../MyComponent'
import { createMockData } from '@/tests/helpers'

describe('MyComponent', () => {
  describe('Loading State', () => {
    it('should display skeleton when isLoading is true', () => {
      render(<MyComponent isLoading={true} />)
      
      const skeletons = document.querySelectorAll('.skeleton')
      expect(skeletons.length).toBeGreaterThan(0)
    })
  })

  describe('Error State', () => {
    it('should display error message when error prop is provided', () => {
      const error = new Error('Network error')
      render(<MyComponent error={error} />)
      
      expect(screen.getByText(/error message/i)).toBeInTheDocument()
    })
  })

  describe('Empty State', () => {
    it('should display empty message when no data', () => {
      render(<MyComponent data={[]} />)
      
      expect(screen.getByText(/no data/i)).toBeInTheDocument()
    })
  })

  describe('Success State', () => {
    it('should display data correctly', () => {
      const data = createMockData()
      render(<MyComponent data={data} />)
      
      expect(screen.getByText(data.title)).toBeInTheDocument()
    })
  })
})
```

## Helpers et Mocks

### Factory Functions

Créer des fonctions factory pour générer des données de test cohérentes :

```typescript
// src/tests/helpers.ts
export function createMockCollection(overrides?: Partial<Collection>): Collection {
  return {
    id: 'collection-1',
    name: 'Default Collection',
    slug: 'default-collection',
    totalCardsOwned: 10,
    totalCardsAvailable: 50,
    completionPercentage: 20,
    ...overrides,
  }
}

export function createMockCollections(count: number): Collection[] {
  return Array.from({ length: count }, (_, i) =>
    createMockCollection({
      id: `collection-${i + 1}`,
      name: `Collection ${i + 1}`,
    })
  )
}
```

### Mocking de Next.js

Pour les tests de composants utilisant Next.js :

```typescript
// Mock next/navigation
vi.mock('next/navigation', () => ({
  useRouter: () => ({
    push: vi.fn(),
  }),
}))

// Mock next/image
vi.mock('next/image', () => ({
  default: ({ src, alt }: { src: string; alt: string }) => (
    <img src={src} alt={alt} />
  ),
}))
```

## Bonnes Pratiques

### 1. Tester le Comportement, Pas l'Implémentation

❌ **Mauvais** : Tester les détails d'implémentation
```typescript
expect(component.state.isLoading).toBe(true)
```

✅ **Bon** : Tester ce que l'utilisateur voit
```typescript
expect(screen.getByText(/loading/i)).toBeInTheDocument()
```

### 2. Utiliser les Queries Appropriées

Ordre de priorité pour sélectionner les éléments :

1. `getByRole` - Meilleur pour l'accessibilité
2. `getByLabelText` - Pour les formulaires
3. `getByPlaceholderText` - Pour les inputs
4. `getByText` - Pour le contenu textuel
5. `getByTestId` - En dernier recours

```typescript
// Préféré
const button = screen.getByRole('button', { name: /submit/i })

// Alternative
const input = screen.getByLabelText(/email/i)

// Dernier recours
const element = screen.getByTestId('custom-element')
```

### 3. Gérer les Éléments Multiples

Lorsque plusieurs éléments partagent le même texte :

```typescript
// Utiliser getAllBy* au lieu de getBy*
const items = screen.getAllByText('Same Text')
expect(items.length).toBe(2)
```

### 4. Tester les Interactions Utilisateur

```typescript
import userEvent from '@testing-library/user-event'

it('should call callback when button is clicked', async () => {
  const user = userEvent.setup()
  const handleClick = vi.fn()
  
  render(<Button onClick={handleClick} />)
  
  const button = screen.getByRole('button')
  await user.click(button)
  
  expect(handleClick).toHaveBeenCalledTimes(1)
})
```

### 5. Tester la Priorité des États

S'assurer que les états s'affichent dans le bon ordre de priorité :

```typescript
it('should prioritize loading state over error state', () => {
  const error = new Error('Some error')
  render(<MyComponent isLoading={true} error={error} />)
  
  // Should show loading, not error
  expect(screen.queryByText(/error/i)).not.toBeInTheDocument()
  expect(document.querySelectorAll('.skeleton').length).toBeGreaterThan(0)
})
```

## Couverture de Code

### Objectif

Viser une couverture de **>90%** pour maintenir la qualité et la maintenabilité.

### Commandes

```bash
# Exécuter les tests
npm test

# Exécuter les tests avec couverture
npm run test:coverage

# Exécuter les tests en mode UI
npm run test:ui
```

### Exclusions de Couverture

Fichiers exclus de la couverture (configurés dans `vitest.config.ts`) :
- `node_modules/`
- `src/tests/`
- `**/*.d.ts`
- `**/*.config.*`
- `**/mockData`
- `dist/`

## Organisation des Tests

### Structure de Dossiers

```
frontend/
├── src/
│   ├── components/
│   │   └── homepage/
│   │       ├── HeroCard.tsx
│   │       ├── CollectionsGrid.tsx
│   │       └── __tests__/
│   │           ├── HeroCard.test.tsx
│   │           └── CollectionsGrid.test.tsx
│   └── tests/
│       ├── setup.ts          # Configuration globale
│       └── helpers.ts        # Helpers et mocks réutilisables
└── vitest.config.ts
```

### Conventions de Nommage

- Fichiers de test : `ComponentName.test.tsx`
- Dossier de tests : `__tests__/` à côté du composant
- Mocks et helpers : Centralisés dans `src/tests/helpers.ts`

## Assertions Typiques

### Présence d'Éléments

```typescript
// Élément présent
expect(screen.getByText(/hello/i)).toBeInTheDocument()

// Élément absent
expect(screen.queryByText(/goodbye/i)).not.toBeInTheDocument()
```

### Comptage d'Éléments

```typescript
const skeletons = document.querySelectorAll('.skeleton')
expect(skeletons.length).toBeGreaterThan(0)
expect(skeletons.length).toBe(5)
```

### Appels de Fonction

```typescript
const mockFn = vi.fn()
expect(mockFn).toHaveBeenCalledTimes(1)
expect(mockFn).toHaveBeenCalledWith('arg1', 'arg2')
```

### Valeurs Numériques

```typescript
expect(screen.getByText('50%')).toBeInTheDocument()
expect(percentage).toBeGreaterThanOrEqual(0)
expect(percentage).toBeLessThanOrEqual(100)
```

## Exemples Complets

Les composants suivants servent de référence :

- **HeroCard** : `/frontend/src/components/homepage/__tests__/HeroCard.test.tsx`
  - 21 tests couvrant tous les états
  - Gestion des callbacks et interactions
  - Tests de priorité des états

- **CollectionsGrid** : `/frontend/src/components/homepage/__tests__/CollectionsGrid.test.tsx`
  - 22 tests couvrant tous les scénarios
  - Gestion de listes multiples
  - Tests de layouts et affichages conditionnels

## Checklist pour Nouveaux Tests

Avant de créer des tests pour un nouveau composant, vérifier :

- [ ] Configuration Vitest en place
- [ ] Helpers/mocks créés dans `src/tests/helpers.ts`
- [ ] Dossier `__tests__/` créé à côté du composant
- [ ] Tests pour les 4 états principaux (Loading, Error, Empty, Success)
- [ ] Tests de priorité des états
- [ ] Tests d'interactions utilisateur (si applicable)
- [ ] Mocks de Next.js configurés (si nécessaire)
- [ ] Au moins 3-5 assertions par test
- [ ] Tous les tests passent avec `npm test`
- [ ] Couverture >90% maintenue

## Ressources

- [Vitest Documentation](https://vitest.dev/)
- [React Testing Library](https://testing-library.com/react)
- [Testing Library Common Mistakes](https://kentcdodds.com/blog/common-mistakes-with-react-testing-library)
- [Guiding Principles](https://testing-library.com/docs/guiding-principles/)
