# Feature: Card Possession Toggle

## Overview

Fonctionnalité permettant aux utilisateurs de gérer leur collection de cartes via une interface de toggle sur la page `/cards/add`.

## Implementation

### 1. API Client

**Fichier**: `frontend/src/lib/api/collections.ts`

Fonction ajoutée:
- `updateCardPossession(cardId: string, isOwned: boolean): Promise<Card>`

Appelle l'endpoint backend `PATCH /api/v1/cards/:id/possession` et convertit la réponse en camelCase.

### 2. Hook Custom

**Fichier**: `frontend/src/hooks/useCardToggle.ts`

Hook React Query pour gérer le toggle de possession:
- Utilise `useMutation` de React Query
- Invalide automatiquement les queries `cards` et `collectionSummary` après succès
- Affiche des toasts de succès/erreur
- Retourne `toggleCard` (fonction de mutation) et `isLoading` (état de chargement)

### 3. Page `/cards/add`

**Fichier**: `frontend/src/app/cards/add/page.tsx`

Page complète avec:
- **Header**: Titre "Gérer ma Collection" + lien retour vers le dashboard
- **Filtres**:
  - Recherche par nom (debounced 300ms)
  - Série (dropdown)
  - Type (dropdown)
  - Rareté (dropdown)
  - Statut de possession (toggle buttons: Toutes/Possédées/Non possédées)
- **Grid de cartes**: Layout responsive avec infinite scroll
- **Composant CardToggle**: Switch visuel avec gradient violet Ethos V1

### 4. Composant CardToggle

Intégré dans `page.tsx`:
- Toggle switch animé
- Couleur: Gradient violet (#667eea → #764ba2) quand possédée, gris sinon
- Loading state pendant la requête
- Accessible (ARIA labels, role="switch")

### 5. Toast Notifications

**Package**: `react-hot-toast`

Configuration dans `app/layout.tsx`:
- Position: bottom-right
- Toaster global ajouté au layout
- Messages personnalisés selon l'action (ajout/retrait)

## Tests

### Tests de la page `/cards/add`

**Fichier**: `frontend/src/app/cards/add/__tests__/page.test.tsx`

Tests couvrant:
- Rendu du header et navigation
- Affichage des filtres
- Rendu de la grid de cartes
- Interaction avec le toggle
- États de chargement et d'erreur
- État vide (aucune carte)
- Debounce de la recherche
- Mise à jour des filtres

### Tests du hook `useCardToggle`

**Fichier**: `frontend/src/hooks/__tests__/useCardToggle.test.tsx`

Tests couvrant:
- Toggle vers "possédée"
- Toggle vers "non possédée"
- Gestion des erreurs
- Invalidation des queries
- Affichage des toasts

### Configuration de test

**Fichier**: `frontend/src/tests/setup.ts`

Mock de `IntersectionObserver` pour les tests d'infinite scroll.

## Design System - Ethos V1

### Couleurs
- Gradient primaire: `linear-gradient(135deg, #667eea 0%, #764ba2 100%)`
- Surface: CSS variables (`var(--surface)`, `var(--surface-container-low)`, etc.)
- Texte: `var(--on-surface)`, `var(--on-surface-variant)`

### Typography
- Titres: Manrope (700-800)
- Corps: Inter (400-600)

### Composants
- Border radius: 12-16px (cards), 10px (inputs)
- Spacing: Généreux (1rem-2rem)
- Shadows: Subtiles avec low opacity
- No-Line Rule: Utilisation de tonal layering au lieu de lignes

### Interactions
- Transitions: 0.2-0.3s ease
- Hover states: scale(1.05) sur les boutons
- Box shadows animées sur les toggles actifs

## Usage

1. Depuis le dashboard, cliquer sur "Add Card" dans le HeroCard
2. Naviguer vers `/cards/add`
3. Utiliser les filtres pour trouver des cartes
4. Cliquer sur le toggle pour ajouter/retirer une carte
5. Un toast confirme l'action
6. Les statistiques du dashboard sont automatiquement mises à jour

## Architecture

```
frontend/src/
├── app/
│   ├── cards/
│   │   └── add/
│   │       ├── page.tsx              # Page principale
│   │       └── __tests__/
│   │           └── page.test.tsx     # Tests de la page
│   └── layout.tsx                    # Ajout du Toaster
├── hooks/
│   ├── useCardToggle.ts              # Hook de toggle
│   └── __tests__/
│       └── useCardToggle.test.tsx    # Tests du hook
├── lib/
│   └── api/
│       └── collections.ts            # Client API (updateCardPossession)
└── tests/
    └── setup.ts                      # Config tests (IntersectionObserver mock)
```

## Performance

- **Debounce**: Recherche debounced à 300ms pour limiter les requêtes API
- **Infinite Scroll**: Chargement progressif via IntersectionObserver
- **Query Invalidation**: Invalidation ciblée des queries concernées
- **Optimistic Updates**: Possible d'ajouter si besoin (non implémenté actuellement)

## Améliorations futures

- [ ] Optimistic updates pour une UI plus réactive
- [ ] Bulk toggle (sélectionner plusieurs cartes)
- [ ] Filtre sauvegardé dans localStorage
- [ ] Animation de transition lors du toggle
- [ ] Indicateur de synchronisation
- [ ] Mode offline avec sync queue
