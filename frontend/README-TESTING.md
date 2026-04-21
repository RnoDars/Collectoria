# Frontend Testing Guide - Collectoria

## Quick Start

### Exécuter les tests

```bash
# Lancer tous les tests
npm test

# Lancer les tests avec couverture
npm run test:coverage

# Lancer les tests en mode UI interactif
npm run test:ui
```

## Stack de Tests

- **Vitest** - Framework de test rapide et moderne
- **React Testing Library** - Tester les composants React
- **@testing-library/jest-dom** - Matchers pour améliorer la lisibilité
- **@testing-library/user-event** - Simuler les interactions utilisateur
- **jsdom** - Environnement DOM pour les tests

## Structure des Tests

Les tests sont organisés à côté des composants :

```
src/
├── components/
│   └── homepage/
│       ├── HeroCard.tsx
│       ├── CollectionsGrid.tsx
│       └── __tests__/
│           ├── HeroCard.test.tsx
│           └── CollectionsGrid.test.tsx
└── tests/
    ├── setup.ts          # Configuration globale
    └── helpers.ts        # Mocks et helpers réutilisables
```

## Pattern de Test : Les 4 États

Chaque composant doit être testé selon 4 états principaux :

### 1. Loading State

Test du skeleton loader pendant le chargement :

```typescript
it('should display skeleton when loading', () => {
  render(<MyComponent isLoading={true} />)
  
  const skeletons = document.querySelectorAll('.skeleton')
  expect(skeletons.length).toBeGreaterThan(0)
})
```

### 2. Error State

Test de l'affichage des erreurs :

```typescript
it('should display error message', () => {
  const error = new Error('Network error')
  render(<MyComponent error={error} />)
  
  expect(screen.getByText(/Unable to load/i)).toBeInTheDocument()
  expect(screen.getByText(/Network error/i)).toBeInTheDocument()
})
```

### 3. Empty State

Test de l'état vide (aucune donnée) :

```typescript
it('should display empty message', () => {
  render(<MyComponent data={[]} />)
  
  expect(screen.getByText(/No data available/i)).toBeInTheDocument()
})
```

### 4. Success State

Test de l'affichage des données :

```typescript
it('should display data correctly', () => {
  const data = createMockData()
  render(<MyComponent data={data} />)
  
  expect(screen.getByText(data.title)).toBeInTheDocument()
  expect(screen.getByText(/Complete/i)).toBeInTheDocument()
})
```

## Helpers et Mocks

### Factory Functions

Utilisez les helpers dans `src/tests/helpers.ts` pour créer des données de test :

```typescript
import { createMockCollection, createMockCollections } from '@/tests/helpers'

// Créer une collection avec valeurs par défaut
const collection = createMockCollection()

// Créer une collection avec overrides
const customCollection = createMockCollection({
  name: 'Custom Name',
  totalCardsOwned: 100,
})

// Créer plusieurs collections
const collections = createMockCollections(5)
```

### Mocking Next.js

Les mocks Next.js sont déjà configurés dans les tests :

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

### 1. Utiliser les Bonnes Queries

Ordre de priorité :

```typescript
// 1. Préféré : getByRole (meilleur pour l'accessibilité)
const button = screen.getByRole('button', { name: /submit/i })

// 2. getByLabelText pour les formulaires
const input = screen.getByLabelText(/email/i)

// 3. getByText pour le contenu
const heading = screen.getByText(/welcome/i)

// 4. getByTestId en dernier recours
const element = screen.getByTestId('custom-element')
```

### 2. Tester les Interactions

```typescript
import userEvent from '@testing-library/user-event'

it('should handle button click', async () => {
  const user = userEvent.setup()
  const handleClick = vi.fn()
  
  render(<Button onClick={handleClick}>Click me</Button>)
  
  await user.click(screen.getByRole('button'))
  
  expect(handleClick).toHaveBeenCalledTimes(1)
})
```

### 3. Gérer les Éléments Multiples

```typescript
// Utiliser getAllBy* quand plusieurs éléments ont le même texte
const items = screen.getAllByText('Same Text')
expect(items.length).toBe(3)

// Ou vérifier la quantité
expect(items.length).toBeGreaterThan(0)
```

### 4. Tester la Priorité des États

```typescript
it('should prioritize loading over error', () => {
  render(<MyComponent isLoading={true} error={new Error('error')} />)
  
  // Loading should be shown, not error
  expect(document.querySelectorAll('.skeleton').length).toBeGreaterThan(0)
  expect(screen.queryByText(/error/i)).not.toBeInTheDocument()
})
```

## Assertions Courantes

```typescript
// Élément présent
expect(screen.getByText(/hello/i)).toBeInTheDocument()

// Élément absent
expect(screen.queryByText(/goodbye/i)).not.toBeInTheDocument()

// Comptage
const elements = document.querySelectorAll('.skeleton')
expect(elements.length).toBe(5)
expect(elements.length).toBeGreaterThan(0)

// Appels de fonction
const mockFn = vi.fn()
expect(mockFn).toHaveBeenCalledTimes(1)
expect(mockFn).toHaveBeenCalledWith('arg')

// Valeurs
expect(percentage).toBeGreaterThanOrEqual(0)
expect(percentage).toBeLessThanOrEqual(100)
```

## Exemples de Référence

Consultez les tests existants comme exemples :

- **HeroCard.test.tsx** - 21 tests, tous les états, interactions utilisateur
- **CollectionsGrid.test.tsx** - 22 tests, gestion de listes, layouts conditionnels

## Objectif de Couverture

**>90%** de couverture de code pour maintenir la qualité.

```bash
# Vérifier la couverture
npm run test:coverage
```

## Workflow

1. **Créer le composant** dans `src/components/`
2. **Créer les helpers** dans `src/tests/helpers.ts` si nécessaire
3. **Créer les tests** dans `__tests__/` à côté du composant
4. **Tester les 4 états** : Loading, Error, Empty, Success
5. **Ajouter tests d'interactions** si applicable
6. **Vérifier la couverture** avec `npm run test:coverage`
7. **Valider** que tous les tests passent avec `npm test`

## Documentation Complète

Pour plus de détails, consultez :

📖 **[Testing/patterns/frontend-testing.md](/Testing/patterns/frontend-testing.md)**

## Ressources

- [Vitest Docs](https://vitest.dev/)
- [React Testing Library](https://testing-library.com/react)
- [Testing Playground](https://testing-playground.com/) - Aide à trouver les bonnes queries

## Support

En cas de problème :

1. Vérifier que toutes les dépendances sont installées : `npm install`
2. Vérifier la configuration dans `vitest.config.ts`
3. Consulter les tests existants comme référence
4. Consulter la documentation complète dans `Testing/patterns/`
