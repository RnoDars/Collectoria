# TODO : Modal de Confirmation pour Toggle de Possession

**Priorité** : HIGH (juste après activités Phase 1)
**Effort estimé** : 1-2 heures
**Complexité** : Faible

## Objectif

Ajouter une modale de confirmation avant de changer le statut de possession d'une carte
pour éviter les erreurs de manipulation.

## Contexte

Le toggle de possession est une action importante qui modifie l'état de la collection.
Actuellement, un simple clic change immédiatement le statut, ce qui peut conduire à
des erreurs involontaires (clic accidentel, mauvaise carte, etc.).

## User Story

**En tant qu'** utilisateur
**Je veux** confirmer mon intention avant de marquer une carte comme possédée/non possédée
**Afin de** éviter les erreurs de manipulation accidentelles

## Spécifications

### Comportement

1. **Click sur toggle** → Afficher modale de confirmation (pas de changement immédiat)
2. **Modale affiche** :
   - Nom de la carte (EN + FR)
   - Image/icône de la carte
   - Action à confirmer : "Marquer comme possédée" ou "Retirer de la collection"
   - 2 boutons : "Confirmer" et "Annuler"
3. **Click "Confirmer"** → Appel API PATCH → Toast de succès
4. **Click "Annuler"** ou **Click backdrop** → Fermer modale sans action

### UX Considerations

- Modale centrée, overlay semi-transparent
- Animation d'entrée/sortie fluide
- Échappement avec touche "Esc"
- Focus trap dans la modale
- Accessible (ARIA, keyboard navigation)

### Design (Ethos V1)

```
┌─────────────────────────────────────┐
│  Confirmer l'action                 │  ← Titre
├─────────────────────────────────────┤
│                                     │
│  📇 Gandalf the Grey                │  ← Icône + Nom
│     Gandalf le Gris                 │
│                                     │
│  Voulez-vous marquer cette carte    │  ← Message
│  comme possédée ?                   │
│                                     │
│  ┌─────────┐  ┌─────────────────┐  │
│  │ Annuler │  │ ✓ Confirmer     │  │  ← Actions
│  └─────────┘  └─────────────────┘  │
│                    (gradient)       │
└─────────────────────────────────────┘
```

- No-Line Rule (tonal layering)
- Gradient violet sur bouton "Confirmer"
- Border radius 16px
- Backdrop blur subtil

## Implémentation

### Frontend

**Nouveau composant** : `frontend/src/components/cards/ConfirmToggleModal.tsx`

```tsx
interface ConfirmToggleModalProps {
  card: Card;
  newState: boolean; // true = ajouter, false = retirer
  isOpen: boolean;
  onConfirm: () => void;
  onCancel: () => void;
}
```

**Modification** : `frontend/src/app/cards/add/page.tsx`

```tsx
// État
const [confirmModal, setConfirmModal] = useState<{
  card: Card;
  newState: boolean;
} | null>(null);

// Modifier handleToggle
const handleToggle = (cardId: string, isOwned: boolean) => {
  const card = allCards.find(c => c.id === cardId);
  setConfirmModal({ card, newState: isOwned });
};

// Callback confirmation
const handleConfirmToggle = () => {
  if (!confirmModal) return;
  setTogglingCardId(confirmModal.card.id);
  toggleCard(
    { cardId: confirmModal.card.id, isOwned: confirmModal.newState },
    { onSettled: () => setTogglingCardId(undefined) }
  );
  setConfirmModal(null);
};
```

**Library suggestion** : `@radix-ui/react-dialog` ou construire from scratch

### Backend

Aucun changement nécessaire (l'API reste identique).

### Tests

**Frontend tests** : `frontend/src/components/cards/__tests__/ConfirmToggleModal.test.tsx`

```tsx
- Affichage correct du nom de carte
- Message correct selon action (ajouter/retirer)
- Click "Confirmer" → appelle onConfirm
- Click "Annuler" → appelle onCancel
- Click backdrop → appelle onCancel
- Touche "Esc" → appelle onCancel
- Focus trap fonctionne
- Accessibilité (ARIA)
```

## Alternatives Considérées

### 1. Undo/Redo au lieu de confirmation
**Avantage** : Fluidité (pas de friction)
**Inconvénient** : Plus complexe à implémenter, nécessite historique

### 2. Confirmation optionnelle (préférence utilisateur)
**Avantage** : Utilisateurs expérimentés peuvent désactiver
**Inconvénient** : Complexité supplémentaire (settings)

### 3. Double-click pour confirmer
**Avantage** : Pas de modale
**Inconvénient** : Moins évident, problème d'accessibilité

**Choix retenu** : Modale simple pour tous les utilisateurs (meilleur rapport simplicité/sécurité)

## Critères d'Acceptation

- [ ] Modale s'affiche au click sur toggle
- [ ] Modale affiche le nom de la carte et l'action
- [ ] Bouton "Confirmer" déclenche l'appel API
- [ ] Bouton "Annuler" ferme sans action
- [ ] Click backdrop ferme sans action
- [ ] Touche "Esc" ferme sans action
- [ ] Design respecte Ethos V1
- [ ] Accessible (ARIA, keyboard)
- [ ] Tests passants (8+ tests)
- [ ] Animation fluide

## Références

- Design System: `/Design/design-system/Ethos-V1-2026-04-15.md`
- Toggle actuel: `/frontend/src/app/cards/add/page.tsx`
- Radix UI Dialog: https://www.radix-ui.com/primitives/docs/components/dialog

## Notes

Cette fonctionnalité améliore significativement l'UX en évitant les erreurs
de manipulation. À implémenter juste après les activités Phase 1.

Priorisation suggérée : HIGH (fait partie du MVP core)
