# Changelog - Card Possession Toggle Feature

## Version: 2024-04-21

### Features Added

#### 1. Page `/cards/add` - Gestion de Collection
- Nouvelle page complète pour gérer les cartes de la collection
- Grid responsive avec infinite scroll
- 5 filtres disponibles: recherche, série, type, rareté, statut de possession
- Design Ethos V1 avec tonal layering
- États de chargement, erreur et vide gérés

#### 2. Toggle de Possession Interactive
- Composant CardToggle avec animation fluide
- Gradient violet (#667eea → #764ba2) pour les cartes possédées
- Switch accessible (ARIA, role="switch")
- Loading state pendant l'appel API
- Transition animée du knob

#### 3. Notifications Toast
- Package `react-hot-toast` installé
- Toasts de succès/erreur après chaque action
- Position: bottom-right
- Messages personnalisés avec icônes
- Durée: 3s (succès), 4s (erreur)

#### 4. Hook Custom `useCardToggle`
- Encapsulation de la logique de toggle
- Invalidation automatique des queries React Query
- Gestion centralisée des toasts
- Retour simple: `{ toggleCard, isLoading }`

#### 5. Client API
- Fonction `updateCardPossession(cardId, isOwned)`
- Appelle `PATCH /api/v1/cards/:id/possession`
- Conversion automatique snake_case → camelCase
- Gestion des erreurs HTTP

### Tests

#### Tests Ajoutés (17 nouveaux tests)
- `useCardToggle.test.tsx`: 5 tests
  - Toggle vers possédée
  - Toggle vers non possédée
  - Gestion d'erreur
  - Invalidation de queries
  - Affichage de toasts

- `page.test.tsx`: 12 tests
  - Rendu du header et filtres
  - Affichage des cartes
  - Interaction avec les toggles
  - États de chargement/erreur/vide
  - Debounce de recherche
  - Mise à jour des filtres

#### Tests Modifiés
- `HeroCard.test.tsx`: Mis à jour pour tester le lien vers `/cards/add`

#### Configuration de Test
- Mock de `IntersectionObserver` ajouté dans `setup.ts`

### Build & Quality

- ✅ Build TypeScript: SUCCESS (0 erreurs)
- ✅ Tests: 60/60 passing
- ✅ Bundle size: 126 kB pour `/cards/add`
- ✅ Accessibility: ARIA labels et roles conformes
- ✅ Responsive: Grid adaptative (280px min width)
- ✅ Performance: Debounce (300ms), infinite scroll

### Files Summary

**Created (5 files):**
- `frontend/src/app/cards/add/page.tsx` (579 lines)
- `frontend/src/app/cards/add/__tests__/page.test.tsx` (268 lines)
- `frontend/src/hooks/useCardToggle.ts` (37 lines)
- `frontend/src/hooks/__tests__/useCardToggle.test.tsx` (177 lines)
- `frontend/docs/cards-toggle-feature.md` (documentation complète)

**Modified (5 files):**
- `frontend/src/lib/api/collections.ts` (+30 lines)
- `frontend/src/app/layout.tsx` (+2 lines)
- `frontend/src/tests/setup.ts` (+12 lines)
- `frontend/src/components/homepage/__tests__/HeroCard.test.tsx` (~8 lines)
- `frontend/package.json` (+1 dependency)

**Total:** +1113 lines of code (including tests and docs)

### Dependencies

**New:**
- `react-hot-toast` ^2.4.1

### Breaking Changes

Aucun. Cette feature est entièrement additive.

### Migration Notes

Aucune migration nécessaire. Le bouton "Add Card" du HeroCard pointe maintenant vers la nouvelle page `/cards/add` au lieu d'une action vide.

### Next Steps

Améliorations futures recommandées:
- [ ] Optimistic updates pour une UI encore plus réactive
- [ ] Bulk toggle (sélection multiple)
- [ ] Persistance des filtres dans localStorage
- [ ] Animation de transition lors du toggle
- [ ] Mode offline avec queue de synchronisation
- [ ] Export CSV de la collection

### Backend Requirements

Cette feature nécessite que l'endpoint backend suivant soit opérationnel:
- `PATCH /api/v1/cards/:id/possession`
- Request body: `{ "is_owned": boolean }`
- Response: `{ "success": true, "card": { ... } }`

Status: ✅ Backend ready (commit 4474394)
