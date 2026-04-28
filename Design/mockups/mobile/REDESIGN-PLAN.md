# Plan de Redesign - Mobile Variante 1

**Date**: 2026-04-28  
**Objectif**: Aligner l'implémentation actuelle sur la maquette Stitch Variante 1  
**Référence**: `VISUAL-GAPS-ANALYSIS.md`  

---

## Vue d'Ensemble

Ce plan structure les modifications visuelles en **6 sections prioritaires** pour transformer l'implémentation actuelle en une version fidèle à la maquette premium "The Digital Curator".

**Stratégie d'exécution** : Attaquer les écarts **CRITIQUES** en premier (impact visuel immédiat), puis les améliorations progressives.

**Durée estimée** : 3-4 heures de développement + tests

---

## Section 1 : Colors & Global Background

### 1.1 Background Body - CRITIQUE

**Actuel** :
```css
/* globals.css ligne 56 */
body {
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
}
```

**Maquette** :
```css
body {
  background: var(--surface); /* #f8f9fa - solid neutral */
}
```

**Changement requis** :
- Remplacer le gradient violet par un background solid `--surface`
- Le gradient violet doit être réservé aux CTAs, progress bars, badges (parcimonie)

**Priorité** : 🔴 **HAUTE - CRITIQUE**  
**Impact visuel** : ⚡ **FORT** - Change complètement l'identité visuelle  
**Difficulté** : ✅ Très facile (1 ligne CSS)

**Fichier** : `/home/arnaud.dars/git/Collectoria/frontend/src/app/globals.css`

---

### 1.2 Tonal Layering - Ajustement Mineur

**Actuel** : Globalement correct ✅

**Changement requis** :
```css
/* Ajuster la couleur hero image placeholder */
--surface-container-low: #e8eaed; /* Au lieu de #f3f4f5 */
```

**Priorité** : 🟡 **BASSE**  
**Impact visuel** : 🔹 **FAIBLE** - Ajustement subtil  
**Difficulté** : ✅ Facile

**Fichier** : `/home/arnaud.dars/git/Collectoria/frontend/src/app/globals.css`

---

## Section 2 : Typography & Hierarchy

### 2.1 Titre Collection Card - CRITIQUE

**Actuel** :
```tsx
fontSize: '1.5rem' // = 24px
fontWeight: '700'
```

**Maquette** :
```tsx
fontSize: '1.25rem' // = 20px
fontWeight: '700'
letterSpacing: '-0.01em' // Compression typographique premium
```

**Changement requis** :
- Réduire font size de 24px à 20px (réduction de 16.7%)
- Ajouter letter-spacing négatif léger

**Priorité** : 🔴 **HAUTE**  
**Impact visuel** : ⚡ **FORT** - Rééquilibre la hiérarchie  
**Difficulté** : ✅ Facile

**Fichier** : `/home/arnaud.dars/git/Collectoria/frontend/src/components/homepage/CollectionCard.tsx` (lignes 124-130)

---

### 2.2 Percentage Stat - CRITIQUE (Hiérarchie Inversée)

**Actuel** :
```tsx
fontSize: '1.25rem' // = 20px
fontWeight: '700'
```

**Maquette** :
```tsx
fontSize: '0.75rem' // = 12px
fontWeight: '700'
```

**Changement requis** :
- **RÉDUIRE DRASTIQUEMENT** de 20px à 12px (réduction de 40% !)
- Le percentage doit être un **accent subtil**, pas l'élément dominant
- Il doit être **PLUS PETIT** que le count "232 / 480 cards" (14px)

**Priorité** : 🔴 **HAUTE - CRITIQUE**  
**Impact visuel** : ⚡ **FORT** - Corrige hiérarchie inversée  
**Difficulté** : ✅ Facile

**Fichier** : `/home/arnaud.dars/git/Collectoria/frontend/src/components/homepage/CollectionCard.tsx` (lignes 209-216)

---

### 2.3 Description Card

**Actuel** :
```tsx
fontSize: '0.875rem' // = 14px
color: '#43474e'
lineHeight: '1.5'
```

**Maquette** :
```tsx
fontSize: '0.8125rem' // = 13px
color: '#5f6368' // Plus clair pour moins de contraste
lineHeight: '1.4'
```

**Changement requis** :
- Réduire font size de 14px à 13px
- Éclaircir la couleur pour moins de compétition avec le titre
- Réduire line-height pour plus de densité

**Priorité** : 🟠 **MOYENNE**  
**Impact visuel** : 🔸 **MOYEN** - Améliore distinction titre/description  
**Difficulté** : ✅ Facile

**Fichier** : `/home/arnaud.dars/git/Collectoria/frontend/src/components/homepage/CollectionCard.tsx` (lignes 138-145)

---

### 2.4 Titre Section "Mes Collections"

**Actuel** :
```tsx
fontSize: '1.25rem' // = 20px
margin: '0 0 1.25rem' // = 20px
```

**Maquette** :
```tsx
fontSize: '1.125rem' // = 18px
margin: '0 0 1rem' // = 16px
```

**Changement requis** :
- Réduire font size de 20px à 18px
- Réduire margin bottom de 20px à 16px

**Priorité** : 🟡 **BASSE**  
**Impact visuel** : 🔹 **FAIBLE**  
**Difficulté** : ✅ Facile

**Fichier** : `/home/arnaud.dars/git/Collectoria/frontend/src/app/page.tsx` (lignes 25-31)

---

### 2.5 Badge "Complete"

**Actuel** :
```tsx
fontSize: '0.75rem' // = 12px
letterSpacing: '0.05em'
padding: '6px 12px'
borderRadius: '16px'
```

**Maquette** :
```tsx
fontSize: '0.6875rem' // = 11px
letterSpacing: '0.08em' // Plus espacé
padding: '4px 10px' // Plus compact
borderRadius: '12px' // Moins rond
```

**Changement requis** :
- Réduire légèrement la font size
- Augmenter letter-spacing pour plus de lisibilité uppercase
- Compacter le padding
- Réduire border radius

**Priorité** : 🟡 **BASSE**  
**Impact visuel** : 🔹 **FAIBLE** - Badge plus raffiné  
**Difficulté** : ✅ Facile

**Fichier** : `/home/arnaud.dars/git/Collectoria/frontend/src/components/homepage/CollectionCard.tsx` (lignes 88-95)

---

## Section 3 : Collection Cards - Shadow & Depth

### 3.1 Card Shadow Default - CRITIQUE

**Actuel** :
```tsx
boxShadow: '0 4px 8px rgba(0, 0, 0, 0.02)' // Quasi invisible
```

**Maquette** :
```tsx
boxShadow: '0 8px 24px rgba(25, 28, 29, 0.08)'
```

**Changement requis** :
- **Augmenter drastiquement** l'opacity de 0.02 à 0.08 (4x plus visible)
- Augmenter blur radius de 8px à 24px
- Augmenter offset-y de 4px à 8px
- Utiliser `rgba(25, 28, 29, ...)` au lieu de `rgba(0, 0, 0, ...)` pour couleur plus naturelle

**Priorité** : 🔴 **HAUTE - CRITIQUE**  
**Impact visuel** : ⚡ **FORT** - Les cards gagnent en profondeur et présence  
**Difficulté** : ✅ Facile

**Fichier** : `/home/arnaud.dars/git/Collectoria/frontend/src/components/homepage/CollectionCard.tsx` (ligne 53)

---

### 3.2 Card Shadow Hover

**Actuel** :
```tsx
boxShadow: '0 20px 40px rgba(0, 0, 0, 0.08), 0 8px 16px rgba(0, 0, 0, 0.04)'
```

**Maquette** :
```tsx
boxShadow: '0 12px 32px rgba(25, 28, 29, 0.12), 0 4px 16px rgba(25, 28, 29, 0.06)'
```

**Changement requis** :
- Ajuster légèrement les valeurs pour cohérence avec maquette
- Remplacer `rgba(0,0,0,...)` par `rgba(25,28,29,...)`

**Priorité** : 🟠 **MOYENNE**  
**Impact visuel** : 🔸 **MOYEN** - Cohérence visuelle  
**Difficulté** : ✅ Facile

**Fichier** : `/home/arnaud.dars/git/Collectoria/frontend/src/components/homepage/CollectionCard.tsx` (ligne 52)

---

### 3.3 Card Border Radius

**Actuel** :
```tsx
borderRadius: '24px'
```

**Maquette** :
```tsx
borderRadius: '20px'
```

**Changement requis** :
- Réduire de 24px à 20px pour style plus raffiné

**Priorité** : 🟡 **BASSE**  
**Impact visuel** : 🔹 **FAIBLE**  
**Difficulté** : ✅ Facile

**Fichier** : `/home/arnaud.dars/git/Collectoria/frontend/src/components/homepage/CollectionCard.tsx` (ligne 45)

---

### 3.4 Progress Bar Height & Effects - CRITIQUE

**Actuel** :
```tsx
height: '8px'
boxShadow: '0 0 8px rgba(102, 126, 234, 0.5)' // Outer glow seulement
```

**Maquette** :
```tsx
height: '10px'
boxShadow: 
  'inset 0 1px 2px rgba(0, 0, 0, 0.08)' + // Inner shadow pour profondeur
  ', 0 0 12px rgba(102, 126, 234, 0.6)' // Outer glow plus prononcé
```

**Changement requis** :
- Augmenter height de 8px à 10px (25% plus haute)
- Ajouter **inner shadow** pour effet de profondeur interne
- Augmenter **outer glow** blur de 8px à 12px et opacity de 0.5 à 0.6

**Priorité** : 🔴 **HAUTE**  
**Impact visuel** : ⚡ **FORT** - Progress bar plus visible et premium "énergie liquide"  
**Difficulté** : ✅ Facile

**Fichier** : `/home/arnaud.dars/git/Collectoria/frontend/src/components/homepage/CollectionCard.tsx` (lignes 154-171)

---

### 3.5 Hero Image Background & Height Mobile

**Actuel** :
```tsx
background: '#eaebec'
borderRadius: '16px'
// Height mobile : 120px (CSS ligne 215)
```

**Maquette** :
```tsx
background: '#e8eaed' // Légèrement plus froid
borderRadius: '12px'
// Height mobile : 140px
```

**Changement requis** :
- Ajuster background color pour ton plus froid
- Réduire border radius de 16px à 12px
- Augmenter height mobile de 120px à 140px

**Priorité** : 🟠 **MOYENNE**  
**Impact visuel** : 🔸 **MOYEN** - Ratio image/texte plus équilibré sur mobile  
**Difficulté** : ✅ Facile

**Fichiers** :
- `/home/arnaud.dars/git/Collectoria/frontend/src/components/homepage/CollectionCard.tsx` (lignes 64-65)
- `/home/arnaud.dars/git/Collectoria/frontend/src/app/globals.css` (ligne 215)

---

## Section 4 : Bottom Navigation

### 4.1 Glassmorphism Effect - IMPORTANT

**Actuel** :
```tsx
background: 'var(--surface-container-lowest)' // Opaque blanc
boxShadow: '0 -4px 16px rgba(25, 28, 29, 0.06)'
```

**Maquette** :
```tsx
background: 'rgba(255, 255, 255, 0.85)' // Semi-transparent
backdropFilter: 'blur(16px)' // Glassmorphism
WebkitBackdropFilter: 'blur(16px)' // Safari
boxShadow: '0 -6px 20px rgba(25, 28, 29, 0.10)' // Plus prononcée
```

**Changement requis** :
- Remplacer background opaque par semi-transparent
- Ajouter `backdrop-filter: blur(16px)` pour effet glassmorphism
- Augmenter shadow opacity de 0.06 à 0.10
- Augmenter shadow blur de 16px à 20px

**Priorité** : 🔴 **HAUTE**  
**Impact visuel** : ⚡ **FORT** - Effet premium "flottant"  
**Difficulté** : 🔸 Moyenne (support Safari backdrop-filter)

**Fichier** : `/home/arnaud.dars/git/Collectoria/frontend/src/components/layout/BottomNav.tsx` (lignes 25-26)

---

### 4.2 Height & Spacing

**Actuel** :
```tsx
height: '64px'
```

**Maquette** :
```tsx
height: '72px'
```

**Changement requis** :
- Augmenter height de 64px à 72px (12.5% plus haut)
- Ajuster padding bottom du `main-content-wrapper` de 80px à 88px en conséquence

**Priorité** : 🟠 **MOYENNE**  
**Impact visuel** : 🔸 **MOYEN** - Bottom nav plus confortable  
**Difficulté** : ✅ Facile

**Fichiers** :
- `/home/arnaud.dars/git/Collectoria/frontend/src/components/layout/BottomNav.tsx` (ligne 24)
- `/home/arnaud.dars/git/Collectoria/frontend/src/app/globals.css` (ligne 129)

---

### 4.3 Active State Background Indicator - MANQUANT

**Actuel** :
```tsx
// Seulement couleur + weight changent
color: active ? '#667eea' : 'var(--on-surface-variant)'
fontWeight: active ? '600' : '500'
```

**Maquette** :
```tsx
// Background pill derrière l'item actif
background: active ? 'rgba(102, 126, 234, 0.08)' : 'transparent'
borderRadius: '16px'
padding: '8px 12px' // Augmenter le padding pour accommoder le background
```

**Changement requis** :
- Ajouter background pill semi-transparent violet pour état actif
- Augmenter padding pour créer un "bouton" visuel
- Border radius 16px pour forme pill douce

**Priorité** : 🟠 **MOYENNE**  
**Impact visuel** : 🔸 **MOYEN** - État actif beaucoup plus clair visuellement  
**Difficulté** : 🔸 Moyenne (restructuration layout Link)

**Fichier** : `/home/arnaud.dars/git/Collectoria/frontend/src/components/layout/BottomNav.tsx` (lignes 35-54)

---

### 4.4 Label Font Size & Color Inactive

**Actuel** :
```tsx
fontSize: '0.625rem' // = 10px
color: active ? '#667eea' : 'var(--on-surface-variant)' // #43474e trop foncé
```

**Maquette** :
```tsx
fontSize: '0.6875rem' // = 11px
color: active ? '#667eea' : '#5f6368' // Plus clair
```

**Changement requis** :
- Augmenter font size de 10px à 11px
- Éclaircir couleur inactive de #43474e à #5f6368

**Priorité** : 🟡 **BASSE**  
**Impact visuel** : 🔹 **FAIBLE** - Lisibilité légèrement améliorée  
**Difficulté** : ✅ Facile

**Fichier** : `/home/arnaud.dars/git/Collectoria/frontend/src/components/layout/BottomNav.tsx` (lignes 45-47)

---

## Section 5 : Mobile Header

### 5.1 Glassmorphism Effect - IMPORTANT

**Actuel** :
```tsx
background: 'var(--surface-container-lowest)' // Opaque
boxShadow: '0 2px 8px rgba(25, 28, 29, 0.06)'
```

**Maquette** :
```tsx
background: 'rgba(255, 255, 255, 0.85)' // Semi-transparent
backdropFilter: 'blur(16px)'
WebkitBackdropFilter: 'blur(16px)'
boxShadow: '0 2px 12px rgba(25, 28, 29, 0.08)' // Plus prononcée
```

**Changement requis** :
- Appliquer même glassmorphism que bottom nav pour cohérence
- Augmenter shadow blur de 8px à 12px
- Augmenter shadow opacity de 0.06 à 0.08

**Priorité** : 🔴 **HAUTE**  
**Impact visuel** : ⚡ **FORT** - Cohérence visuelle header/nav  
**Difficulté** : 🔸 Moyenne

**Fichier** : `/home/arnaud.dars/git/Collectoria/frontend/src/components/layout/MobileHeader.tsx` (lignes 14-15)

---

### 5.2 Height & Logo Size

**Actuel** :
```tsx
height: '56px'
// Logo
fontSize: '1.25rem' // = 20px
```

**Maquette** :
```tsx
height: '60px'
// Logo
fontSize: '1.375rem' // = 22px
```

**Changement requis** :
- Augmenter height de 56px à 60px
- Augmenter logo font size de 20px à 22px (10% plus grand)
- Ajuster padding-top du `main-content-wrapper` de 56px à 60px en conséquence

**Priorité** : 🟠 **MOYENNE**  
**Impact visuel** : 🔸 **MOYEN** - Logo plus présent  
**Difficulté** : ✅ Facile

**Fichiers** :
- `/home/arnaud.dars/git/Collectoria/frontend/src/components/layout/MobileHeader.tsx` (lignes 13, 29)
- `/home/arnaud.dars/git/Collectoria/frontend/src/app/globals.css` (ligne 129)

---

## Section 6 : Spacing & Layout

### 6.1 Page Padding

**Actuel** :
```tsx
// page.tsx ligne 16
padding: '2rem 1.5rem' // = 32px 24px
```

**Maquette** :
```tsx
padding: '1.5rem 1.25rem' // = 24px 20px
```

**Changement requis** :
- Réduire padding top de 32px à 24px
- Réduire padding latéral de 24px à 20px

**Priorité** : 🟠 **MOYENNE**  
**Impact visuel** : 🔸 **MOYEN** - Plus d'espace pour contenu  
**Difficulté** : ✅ Facile

**Fichier** : `/home/arnaud.dars/git/Collectoria/frontend/src/app/page.tsx` (ligne 16)

---

### 6.2 Section Gap (Collections → Activité)

**Actuel** :
```tsx
// page.tsx ligne 24
marginBottom: '2.5rem' // = 40px
```

**Maquette** :
```tsx
marginBottom: '1.75rem' // = 28px
```

**Changement requis** :
- Réduire gap de 40px à 28px

**Priorité** : 🟠 **MOYENNE**  
**Impact visuel** : 🔸 **MOYEN** - Sections plus connectées visuellement  
**Difficulté** : ✅ Facile

**Fichier** : `/home/arnaud.dars/git/Collectoria/frontend/src/app/page.tsx` (ligne 24)

---

### 6.3 Card Padding Desktop

**Actuel** :
```tsx
padding: '24px'
```

**Maquette** :
```tsx
padding: '20px'
```

**Changement requis** :
- Réduire de 24px à 20px

**Priorité** : 🟠 **MOYENNE**  
**Impact visuel** : 🔸 **MOYEN** - Cards plus denses  
**Difficulté** : ✅ Facile

**Fichier** : `/home/arnaud.dars/git/Collectoria/frontend/src/components/homepage/CollectionCard.tsx` (ligne 46)

---

### 6.4 Card Internal Spacing

**Actuel** :
```tsx
// Hero → Titre : 16px (ligne 66)
// Titre → Description : 8px (ligne 128)
// Description → Progress : 16px (ligne 142)
// Progress → Stats : 12px (ligne 151)
```

**Maquette** :
```tsx
// Hero → Titre : 12px
// Titre → Description : 6px
// Description → Progress : 12px
// Progress → Stats : 10px
```

**Changement requis** :
- Hero → Titre : Réduire de 16px à 12px
- Titre → Description : Réduire de 8px à 6px
- Description → Progress : Réduire de 16px à 12px
- Progress → Stats : Réduire de 12px à 10px

**Priorité** : 🟠 **MOYENNE**  
**Impact visuel** : 🔸 **MOYEN** - Rythme vertical plus harmonieux  
**Difficulté** : ✅ Facile

**Fichier** : `/home/arnaud.dars/git/Collectoria/frontend/src/components/homepage/CollectionCard.tsx` (lignes multiples)

---

## Roadmap d'Implémentation

### Phase 1 : Quick Wins Critiques (1h)

**Objectif** : Corriger les 5 écarts visuels les plus impactants

1. ✅ Background body : Supprimer gradient, utiliser solid surface
2. ✅ Card shadows default : Augmenter opacity 0.02 → 0.08
3. ✅ Progress bar height : 8px → 10px + inner shadow
4. ✅ Titre collection : 24px → 20px + letter-spacing
5. ✅ Percentage stat : 20px → 12px (correction hiérarchie)

**Résultat attendu** : +25 points au score de fidélité (60 → 85)

---

### Phase 2 : Polish Premium (1.5h)

**Objectif** : Ajouter les effets glassmorphism et affiner les détails

6. ✅ Glassmorphism bottom nav + mobile header
7. ✅ Bottom nav active state background indicator
8. ✅ Ajuster heights (bottom nav 72px, header 60px)
9. ✅ Card shadow hover : Ajuster pour cohérence
10. ✅ Description card : Font size, color, line-height

**Résultat attendu** : +10 points (85 → 95)

---

### Phase 3 : Refinements Finaux (0.5-1h)

**Objectif** : Perfectionner les micro-détails

11. ✅ Spacing général : Page padding, section gaps, card internal spacing
12. ✅ Typography mineure : Titre section, badge complete, labels nav
13. ✅ Border radius adjustments : Cards, hero image
14. ✅ Hero image mobile height : 120px → 140px

**Résultat attendu** : Score final 95-98/100

---

### Phase 4 : QA & Polish (0.5h)

15. ✅ Test responsive mobile/desktop
16. ✅ Vérifier cohérence cross-browser (backdrop-filter Safari)
17. ✅ Test accessibilité (contraste WCAG)
18. ✅ Validation finale contre maquette

---

## Checklist de Validation Finale

Avant de considérer le redesign complet :

- [ ] **Background body** : Solid surface, pas de gradient ✅
- [ ] **Card shadows** : Visibles et créent profondeur ✅
- [ ] **Progress bar** : 10px height, inner shadow, outer glow prononcé ✅
- [ ] **Hiérarchie typo** : Titre 20px, description 13px, percentage 12px ✅
- [ ] **Glassmorphism** : Bottom nav + header semi-transparents avec backdrop-blur ✅
- [ ] **Active state nav** : Background pill visible ✅
- [ ] **Spacing cohérent** : Gaps réduits selon maquette ✅
- [ ] **Heights corrects** : Bottom nav 72px, header 60px ✅
- [ ] **Colors fidèles** : Tous les `rgba` et hex alignés maquette ✅
- [ ] **Border radius** : Cards 20px, hero 12px ✅
- [ ] **Mobile responsive** : Hero image 140px height ✅
- [ ] **Cross-browser** : Glassmorphism fonctionne Safari + Chrome ✅

---

## Notes pour l'Agent Frontend

### Variables CSS à Ajouter

```css
/* globals.css - Ajouter ces variables pour faciliter les ajustements */

:root {
  /* Shadows - Collection Cards */
  --shadow-card-default: 0 8px 24px rgba(25, 28, 29, 0.08);
  --shadow-card-hover: 0 12px 32px rgba(25, 28, 29, 0.12), 0 4px 16px rgba(25, 28, 29, 0.06);
  
  /* Shadows - Navigation */
  --shadow-nav: 0 -6px 20px rgba(25, 28, 29, 0.10);
  --shadow-header: 0 2px 12px rgba(25, 28, 29, 0.08);
  
  /* Glassmorphism */
  --glass-background: rgba(255, 255, 255, 0.85);
  --glass-blur: blur(16px);
  
  /* Active state */
  --nav-active-bg: rgba(102, 126, 234, 0.08);
}
```

### Ordre d'Exécution Recommandé

1. Commencer par `globals.css` (background body, variables)
2. Puis `CollectionCard.tsx` (shadows, typography, progress bar)
3. Puis `BottomNav.tsx` (glassmorphism, active state)
4. Puis `MobileHeader.tsx` (glassmorphism, height)
5. Finir par `page.tsx` (spacing)

### Tests Critiques

- **Safari** : Vérifier que `backdrop-filter` fonctionne (prefixer avec `-webkit-`)
- **Mobile viewport** : Tester sur vraie device ou Chrome DevTools
- **Performance** : `backdrop-filter` peut être coûteux, surveiller FPS scroll

---

## Conclusion

Ce plan de redesign transformera l'implémentation actuelle d'une version **fonctionnelle mais visuellement plate (60/100)** en une expérience **premium "The Digital Curator" (95+/100)**.

**3 changements clés** qui auront le plus d'impact :
1. Background solid + shadows prononcées → Profondeur architecturale
2. Glassmorphism nav/header → Effet premium flottant
3. Hiérarchie typo corrigée → Lisibilité et sophistication

**Prochaine étape** : `VISUAL-SPECS.md` avec les valeurs CSS exactes prêtes à copier-coller.
