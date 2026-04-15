# Design System - Collectoria

## Philosophy: "The Digital Curator"

Le Design System de Collectoria rejette l'esthétique "base de données" des applications de collection traditionnelles. Nous adoptons une approche éditoriale haut de gamme, traitant chaque collection comme une exposition de niveau musée.

**Philosophie centrale** : Autorité tranquille, respiration visuelle, élégance contenue.

## Documents Principaux

### [Ethos-V1-2026-04-15.md](./Ethos-V1-2026-04-15.md)
**Le document fondateur** - Contient :
- Creative North Star
- Système de couleurs complet
- Hiérarchie typographique
- Règles de composition ("No-Line Rule", "Tonal Layering")
- Specs de tous les composants
- Do's and Don'ts

**⚠️ À lire en premier** avant toute création de maquette ou composant.

## Structure

```
design-system/
├── README.md                 # Ce fichier
├── Ethos-V1-2026-04-15.md   # Document fondateur
├── tokens/                   # Design tokens
│   ├── colors.md
│   ├── typography.md
│   ├── spacing.md
│   └── elevation.md
└── components/               # Specs des composants
    ├── buttons.md
    ├── cards.md
    ├── inputs.md
    └── navigation.md
```

## Principes Clés

### 1. The "No-Line" Rule
❌ **Pas de bordures 1px solides** pour sectionner le contenu.
✅ Utiliser des **changements de surface** et des **transitions tonales**.

### 2. Tonal Layering
Créer de la profondeur par superposition de surfaces à différentes tonalités :
- `surface` (#f8f9fa) - Le sol de la galerie
- `surface-container-low` (#f3f4f5) - Groupes de catégories
- `surface-container-lowest` (#ffffff) - Cartes et éléments interactifs
- `surface-container-highest` (#e1e3e4) - États actifs/pressés

### 3. Glass & Gradient
Le gradient de marque (violet #667eea → #764ba2) est utilisé avec parcimonie :
- CTAs héros (angle 15°)
- Glassmorphism pour navigation/modals (70% opacité, 24px backdrop-blur)

### 4. Typography: Dual-Type System
- **Manrope** : Voice "Editorial" (titres, headlines)
- **Inter** : Voice "Utility" (body, labels, metadata)

### 5. Espacement Généreux
L'espace blanc est un élément de design à part entière. **"When in doubt, add more whitespace and remove a line."**

## Application

### Pour les Maquettes
1. Lire l'Ethos en entier
2. Appliquer les principes de surface layering
3. Respecter les règles typographiques
4. Éviter les bordures, privilégier les surfaces
5. Utiliser l'espacement comme séparateur principal

### Pour le Frontend
1. Implémenter les Design Tokens en premier
2. Créer les composants de base selon les specs
3. Valider chaque composant contre l'Ethos
4. Maintenir la cohérence du système

### Pour la Validation
Chaque design/composant doit répondre OUI à :
- [ ] Utilise-t-il Tonal Layering plutôt que des bordures ?
- [ ] Respecte-t-il le Dual-Type System ?
- [ ] A-t-il un espacement généreux ?
- [ ] Le gradient est-il utilisé avec parcimonie ?
- [ ] Évite-t-il le pure black (#000000) ?

## Évolution

Ce design system est versionnée. Chaque changement majeur = nouvelle version de l'Ethos.

### Historique
- **V1** (2026-04-15) : Document fondateur "The Digital Curator"

## Référence Rapide

**Gradient Principal** : `#667eea` → `#764ba2`  
**Radius Standard** : `lg` (1rem / 16px) ou `xl` (1.5rem / 24px)  
**Shadow Ambiant** : `0px 12px 32px rgba(25, 28, 29, 0.06)`  
**Ghost Border** : `#c5c5d5` à 15% opacité (si absolument nécessaire)

---

**Director's Final Note:**  
*"The beauty of this system lies in its restraint. Let the user's collection provide the color; our UI provides the elegant, quiet frame."*
