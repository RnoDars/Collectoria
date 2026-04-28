# TODO : Custom Icons Design System

**Priorité** : MEDIUM  
**Effort estimé** : 2-4 heures  
**Dépendances** : Validation redesign mobile 2026-04-28  
**Contexte** : Session mobile redesign 2026-04-28

---

## Objectif

Remplacer les icônes emoji Unicode actuelles (🏠🎴📚🎲) par un jeu d'icônes custom SVG cohérent avec le design system "The Digital Curator" de Collectoria.

**But** : Améliorer la qualité visuelle, la cohérence du design, et l'expérience utilisateur globale.

---

## Problème Identifié

### Icônes Actuelles

**Type** : Emojis Unicode (🏠🎴📚🎲)

**Problèmes** :
1. **Rendu inconsistant** : Apparence différente selon OS/browser
   - iOS : Style Apple emoji
   - Android : Style Google emoji
   - Windows : Style Microsoft emoji
   - Linux : Style système ou fallback

2. **Pas de cohérence design system**
   - Style cartoon vs design moderne "The Digital Curator"
   - Impossible de matcher palette couleurs (Amber + Neutral)
   - Pas de contrôle sur poids visuel

3. **Qualité visuelle limitée**
   - Résolution variable (pixelated sur certains devices)
   - Pas de contrôle sur taille exacte
   - Anti-aliasing inconsistant

4. **Pas de customisation possible**
   - Couleurs fixes (pas de theming)
   - Pas de hover states
   - Pas de variantes (outline vs filled)

### Impact Utilisateur

- **Score design mobile** : Perte estimée de 5-10 points
- **Perception qualité** : Impression "amateur" vs "professionnel"
- **Cohérence visuelle** : Rupture avec reste de l'interface

---

## Déclencheurs

**Démarrer immédiatement après** validation redesign mobile 2026-04-28.

**Conditions** :
- [x] Redesign mobile validé visuellement
- [x] Score design mobile confirmé 95+/100
- [ ] Utilisateur approuve priorité custom icons
- [ ] Temps disponible : 2-4 heures

**Réévaluation** : Après validation du redesign mobile

---

## Architecture Actuelle

### Utilisation Emojis

**Locations dans le code** :

```typescript
// frontend/app/collections/[id]/page.tsx
<div className="text-4xl">{collection.icon || "🏠"}</div>

// frontend/app/collections/page.tsx
<span className="text-3xl">{collection.icon || "🎴"}</span>

// Database: collections table
icon TEXT DEFAULT '🏠'
```

**Propagation** :
- Collections list page (card preview)
- Collection detail page (header)
- Collection form (selector)
- API responses (JSON field)

---

## Architecture Cible

### Custom SVG Icons

**Component Structure** :

```typescript
// New: components/ui/CollectionIcon.tsx
interface CollectionIconProps {
  type: 'home' | 'cards' | 'books' | 'boardgames' | ...;
  size?: 'sm' | 'md' | 'lg' | 'xl';
  className?: string;
  variant?: 'outline' | 'filled';
}

export function CollectionIcon({ type, size = 'md', variant = 'filled' }: Props) {
  const IconComponent = ICON_MAP[type][variant];
  return <IconComponent className={sizeClasses[size]} />;
}
```

**Icon Library Structure** :

```
frontend/components/icons/
├── collections/
│   ├── HomeIcon.tsx            (🏠 → SVG)
│   ├── CardsIcon.tsx           (🎴 → SVG)
│   ├── BooksIcon.tsx           (📚 → SVG)
│   ├── BoardGamesIcon.tsx      (🎲 → SVG)
│   ├── VideogamesIcon.tsx      (new)
│   ├── ComicsIcon.tsx          (new)
│   ├── MoviesIcon.tsx          (new)
│   ├── MusicIcon.tsx           (new)
│   ├── SportsIcon.tsx          (new)
│   └── DefaultIcon.tsx         (fallback)
├── actions/
│   ├── AddIcon.tsx
│   ├── EditIcon.tsx
│   ├── DeleteIcon.tsx
│   ├── FilterIcon.tsx
│   └── SortIcon.tsx
└── stats/
    ├── OwnedIcon.tsx
    ├── MissingIcon.tsx
    └── ProgressIcon.tsx
```

**Database Migration** :

```sql
-- Migration: Pas nécessaire
-- Le champ `icon` reste TEXT
-- Mais contient 'home', 'cards', 'books' au lieu d'emojis
-- Frontend mapping: string → React component
```

**Backward Compatibility** :

```typescript
// Fallback pour anciennes données avec emojis
const EMOJI_TO_TYPE_MAP = {
  '🏠': 'home',
  '🎴': 'cards',
  '📚': 'books',
  '🎲': 'boardgames',
};

function getIconType(iconValue: string): IconType {
  return EMOJI_TO_TYPE_MAP[iconValue] || iconValue || 'default';
}
```

---

## Tâches

### Phase 1 : Design & Génération (1-2h)

**Responsable** : Designer (Stitch) + Agent Frontend

- [ ] **Brief Designer** : Spécifications icônes custom
  - Style : Line icons ou filled (cohérent "The Digital Curator")
  - Format : SVG (optimisé, 24x24px base)
  - Couleurs : currentColor (theming support)
  - Variants : Outline + Filled
  - Nombre : 10+ icônes (collections + actions + stats)

- [ ] **Génération par Stitch**
  - Collections types : Home, Cards, Books, Board Games, Videogames, Comics, Movies, Music, Sports
  - Actions : Add, Edit, Delete, Filter, Sort
  - Stats : Owned, Missing, Progress
  - Export : SVG optimisé (SVGO)

- [ ] **Review Design**
  - Validation cohérence design system
  - Test rendu différentes tailles
  - Validation palette couleurs (Amber + Neutral)

### Phase 2 : Intégration Frontend (1h)

**Responsable** : Agent Frontend

- [ ] **Création Component Library**
  ```bash
  mkdir -p frontend/components/icons/{collections,actions,stats}
  ```

- [ ] **Conversion SVG → React Components**
  - Tool : SVGR ou manuel
  - Props : className, size support
  - currentColor pour theming

- [ ] **Création CollectionIcon Wrapper**
  - Mapping type → component
  - Size variants (sm, md, lg, xl)
  - Style variants (outline, filled)
  - Fallback pour types inconnus

- [ ] **Remplacement Emojis dans Code**
  - `app/collections/page.tsx` : List view
  - `app/collections/[id]/page.tsx` : Detail view
  - `app/collections/new/page.tsx` : Form (si existe)
  - Tests : Snapshots à mettre à jour

### Phase 3 : Tests & Validation (30min)

**Responsable** : Agent Frontend + Agent Testing

- [ ] **Tests Visuels**
  - Render correctement toutes tailles
  - Hover states fonctionnels
  - Theming (light/dark si applicable)
  - Responsive (mobile, tablet, desktop)

- [ ] **Tests Unitaires**
  - CollectionIcon component
  - Mapping type → component
  - Fallback pour type invalide
  - Props className, size, variant

- [ ] **Tests Integration**
  - Collections list affiche bonnes icônes
  - Collection detail affiche bonne icône
  - Backward compatibility emojis → types

- [ ] **Cross-browser Testing**
  - Chrome, Firefox, Safari, Edge
  - iOS Safari, Chrome Android

### Phase 4 : Documentation (30min)

**Responsable** : Agent Documentation

- [ ] **Component Documentation**
  - Storybook ou README (usage examples)
  - Props documentation
  - Variants examples (sizes, styles)

- [ ] **Design System Update**
  - Ajouter icons section
  - Guidelines usage icônes
  - DO's and DON'Ts

- [ ] **Migration Guide**
  - Pour futures collections
  - Mapping emoji → type
  - Ajout nouveaux types icônes

---

## Bénéfices Attendus

### Qualité Visuelle
- **Rendu consistent** : Identique sur tous OS/browsers
- **Haute qualité** : SVG scalable, antialiasing parfait
- **Cohérence design** : 100% aligné avec "The Digital Curator"

### Flexibilité
- **Theming support** : currentColor permet adaptation palette
- **Variants** : Outline vs Filled selon contexte
- **Sizes** : Scalable sans perte qualité

### Maintenabilité
- **Extensible** : Ajout nouveaux types facile
- **Testable** : Components React standards
- **Documenté** : Clear API et guidelines

### Impact Design Score
- **Score mobile** : +5-10 points (95/100 → 100/100 potentiel)
- **Perception qualité** : Amateur → Professionnel
- **Branding** : Identité visuelle forte et unique

---

## Risques

### Risque 1 : Temps de Design
**Impact** : MEDIUM  
**Probabilité** : LOW

**Description** : Génération icônes par designer prend plus de temps que prévu

**Mitigation** :
- Brief clair et détaillé dès départ
- Nombre d'icônes limité (10-15 prioritaires)
- Possibilité utiliser icon library existante (Heroicons, Lucide) comme base

**Plan B** : Utiliser Lucide Icons (MIT license) temporairement

---

### Risque 2 : Performance SVG
**Impact** : LOW  
**Probabilité** : VERY LOW

**Description** : Trop de SVG inline dégrade performance

**Mitigation** :
- SVG optimisés (SVGO)
- Components React memoized
- Lazy loading si nécessaire
- Bundle size monitoring

**Metrics** : Impact < 10KB total bundle size

---

### Risque 3 : Backward Compatibility
**Impact** : LOW  
**Probabilité** : LOW

**Description** : Anciennes collections avec emojis cassent

**Mitigation** :
- Mapping emoji → type maintenu
- Fallback DefaultIcon pour valeurs inconnues
- Migration optionnelle (pas forcée)

**Tests** : Suite de tests backward compatibility

---

## Spécifications Icônes

### Style Visuel

**Référence Design System** : "The Digital Curator"

**Caractéristiques** :
- **Type** : Line icons (priorité) + Filled variant
- **Stroke width** : 2px (medium weight)
- **Border radius** : Subtle (2-4px corners)
- **Style** : Modern, minimal, geometric
- **Détails** : Simplifiés mais reconnaissables

### Spécifications Techniques

**Format** :
- SVG optimisé (SVGO)
- ViewBox : "0 0 24 24"
- Stroke : currentColor (theming)
- Fill : none (outline) ou currentColor (filled)

**Tailles** :
- Base : 24x24px
- Small : 16x16px
- Medium : 24x24px (default)
- Large : 32x32px
- XLarge : 48x48px

**Couleurs** :
- currentColor (inherit from parent)
- Hover : brightness adjust via Tailwind
- Active : Amber-500/600 via className

### Exemples Demandés

**Collections Types** :
1. **Home** : Maison stylisée (ligne simple)
2. **Cards** : Cartes à jouer (fan de 3 cartes)
3. **Books** : Livre ouvert (pages visibles)
4. **Board Games** : Dé 6 faces (ligne isométrique)
5. **Videogames** : Manette console (modern gamepad)
6. **Comics** : Bulle BD avec étoile
7. **Movies** : Pellicule film (3 frames)
8. **Music** : Note de musique (croche)
9. **Sports** : Ballon (soccer ball pattern)
10. **Default** : Collection générique (boîte)

**Actions** :
1. **Add** : Plus dans cercle
2. **Edit** : Crayon
3. **Delete** : Poubelle
4. **Filter** : Entonnoir
5. **Sort** : Flèches haut/bas

**Stats** :
1. **Owned** : Check dans cercle
2. **Missing** : Cercle vide (outline)
3. **Progress** : Graphique circulaire

---

## Stratégie d'Intégration

### Approche Incrémentale

**Phase 1 : Core Collections**
- Remplacer icônes principales (Home, Cards, Books, Board Games)
- Validation utilisateur
- Feedback et ajustements

**Phase 2 : Extensions**
- Ajouter types supplémentaires (Videogames, Comics, etc.)
- Actions icons
- Stats icons

**Phase 3 : Optimisations**
- Lazy loading si nécessaire
- Bundle size optimization
- Variants supplémentaires (colors, sizes)

### Rollout

**1. Development** :
- Feature branch : `feature/custom-icons-design-system`
- Tests complets avant merge
- Review UI/UX

**2. Staging** :
- Déploiement staging
- Tests utilisateurs internes
- Cross-browser validation

**3. Production** :
- Merge main
- Deploy production
- Monitor performance
- Recueillir feedback

---

## Exemples Code

### Before (Emoji)

```typescript
// app/collections/[id]/page.tsx
<div className="text-4xl">
  {collection.icon || "🏠"}
</div>
```

### After (Custom Icon)

```typescript
// app/collections/[id]/page.tsx
import { CollectionIcon } from '@/components/ui/CollectionIcon';

<CollectionIcon 
  type={getIconType(collection.icon)}
  size="xl"
  className="text-amber-500"
/>
```

### CollectionIcon Component

```typescript
// components/ui/CollectionIcon.tsx
import { HomeIcon, CardsIcon, BooksIcon, BoardGamesIcon, DefaultIcon } from '@/components/icons/collections';

const ICON_MAP = {
  home: HomeIcon,
  cards: CardsIcon,
  books: BooksIcon,
  boardgames: BoardGamesIcon,
  default: DefaultIcon,
};

const SIZE_CLASSES = {
  sm: 'w-4 h-4',
  md: 'w-6 h-6',
  lg: 'w-8 h-8',
  xl: 'w-12 h-12',
};

export function CollectionIcon({ 
  type = 'default', 
  size = 'md',
  className = '' 
}: CollectionIconProps) {
  const IconComponent = ICON_MAP[type] || ICON_MAP.default;
  
  return (
    <IconComponent 
      className={cn(SIZE_CLASSES[size], className)}
      aria-label={`${type} collection icon`}
    />
  );
}
```

### Icon SVG Component Example

```typescript
// components/icons/collections/CardsIcon.tsx
export function CardsIcon({ className = '' }: { className?: string }) {
  return (
    <svg
      viewBox="0 0 24 24"
      fill="none"
      stroke="currentColor"
      strokeWidth="2"
      strokeLinecap="round"
      strokeLinejoin="round"
      className={className}
      aria-hidden="true"
    >
      <rect x="2" y="6" width="7" height="11" rx="2" />
      <rect x="9" y="4" width="7" height="11" rx="2" />
      <rect x="15" y="6" width="7" height="11" rx="2" />
    </svg>
  );
}
```

---

## Références

### Design Inspiration

**Icon Libraries** :
- [Heroicons](https://heroicons.com/) - Tailwind official icons (MIT)
- [Lucide Icons](https://lucide.dev/) - Beautiful consistent icons (ISC)
- [Phosphor Icons](https://phosphoricons.com/) - Flexible icon family (MIT)
- [Tabler Icons](https://tabler-icons.io/) - 4500+ SVG icons (MIT)

**Design Systems** :
- [Apple SF Symbols](https://developer.apple.com/sf-symbols/)
- [Material Design Icons](https://fonts.google.com/icons)
- [IBM Carbon Icons](https://carbondesignsystem.com/guidelines/icons/library/)

### Technical Resources

**SVG Optimization** :
- [SVGO](https://github.com/svg/svgo) - SVG optimizer
- [SVGR](https://react-svgr.com/) - SVG to React components

**React Icons** :
- [React Icons](https://react-icons.github.io/react-icons/) - Popular icons as React components
- [Iconify](https://iconify.design/) - Unified icon framework

**Best Practices** :
- [SVG Best Practices](https://css-tricks.com/svg-properties-and-css/)
- [Accessible Icon Buttons](https://www.sarasoueidan.com/blog/accessible-icon-buttons/)
- [Icon Design Guidelines](https://www.nngroup.com/articles/icon-usability/)

### Internal Documentation

**Collectoria Design** :
- Maquettes Stitch (session 2026-04-28)
- "The Digital Curator" design system
- `Project follow-up/reports/2026-04-28_mobile-redesign-session.md`

---

## Métriques de Succès

### Qualité
- [ ] Rendu identique sur 4+ browsers
- [ ] Score Lighthouse Accessibility 100/100 maintenu
- [ ] Validation design system (review Stitch)

### Performance
- [ ] Bundle size increase < 10KB
- [ ] First Contentful Paint unchanged (±50ms)
- [ ] No layout shift (CLS = 0)

### UX
- [ ] Feedback utilisateurs positif (5/5)
- [ ] Score design mobile maintenu ou amélioré (95+/100)
- [ ] Reconnaissance types collections immédiate

---

## Notes

### Pourquoi Maintenant ?

**Timing idéal** après redesign mobile 2026-04-28 :
- Base design solide établie (95/100)
- Amélioration incrémentale logique
- Impact visuel fort avec effort limité (2-4h)
- Complète transformation design mobile

### Alternatives Considérées

**Option 1 : Garder Emojis**
- ❌ Problèmes actuels persistent
- ❌ Score design plafonné

**Option 2 : Utiliser Icon Library Existante**
- ✅ Rapide (0 design time)
- ⚠️ Moins unique
- ⚠️ Pas 100% aligné design system
- 💡 Possible comme Plan B ou temporaire

**Option 3 : Custom Icons (CHOIX)**
- ✅ Qualité maximale
- ✅ 100% cohérent design system
- ✅ Unique et mémorable
- ⚠️ Effort design requis (justifié)

---

## Checklist Pre-Start

Avant de démarrer cette tâche, vérifier :

- [ ] Redesign mobile 2026-04-28 validé visuellement
- [ ] Score design mobile confirmé 95+/100
- [ ] Budget temps disponible : 2-4 heures
- [ ] Designer (Stitch) disponible pour génération
- [ ] Agent Frontend disponible pour intégration
- [ ] Aucun blocker critique en cours

---

**Document créé le** : 2026-04-28  
**Par** : Agent Suivi de Projet  
**Contexte** : Session mobile redesign  
**Priorité** : MEDIUM  
**Status** : 📋 PLANIFIÉ  
**Prochaine action** : Attendre validation redesign mobile
