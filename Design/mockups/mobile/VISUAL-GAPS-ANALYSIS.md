# Analyse des Écarts Visuels - Maquette Variante 1 vs Implémentation Actuelle

**Date**: 2026-04-28  
**Maquette de référence**: `/home/arnaud.dars/git/Collectoria/Design/mockups/mobile/variante1/screen.png`  
**Implémentation**: http://localhost:3000 (mode mobile)

---

## Vue d'Ensemble

L'implémentation actuelle est **fonctionnelle** mais manque du **polish visuel** et de la **sophistication esthétique** présents dans la maquette Stitch Variante 1. La maquette dégage une impression de **galerie muséale premium** avec un équilibre parfait entre densité d'information et respiration visuelle.

**Score de fidélité globale**: 65/100

---

## 1. Layout & Spacing

### 1.1 Marges Générales du Container

#### Maquette
- **Padding latéral**: ~20px (uniforme left/right)
- **Padding top**: ~24px sous le header
- **Padding bottom**: ~100px au-dessus de la bottom nav
- **Gap entre cards**: ~20px vertical

#### Implémentation Actuelle
```tsx
// page.tsx ligne 16
padding: '2rem 1.5rem' // = 32px 24px
```

#### Écart Identifié
- **Padding latéral trop grand** : 24px actuel vs ~20px maquette
- **Padding top trop grand** : 32px actuel vs ~24px maquette
- **Espacement section trop grand** : `marginBottom: '2.5rem'` (40px) entre "Mes Collections" et "Activité Récente" vs ~28px maquette

#### Impact
**Moyen** : Réduit l'espace disponible pour le contenu, moins de breathing room vertical

---

### 1.2 Titre de Section "Mes Collections"

#### Maquette
- **Font size**: ~18px (entre 1rem et 1.125rem)
- **Font weight**: 700 (Bold)
- **Margin bottom**: ~16px
- **Letter spacing**: Normal (0)
- **Color**: #191c1d (on-surface)

#### Implémentation Actuelle
```tsx
// page.tsx lignes 25-31
fontSize: '1.25rem' // = 20px
fontWeight: '700'
margin: '0 0 1.25rem' // = 0 0 20px
```

#### Écart Identifié
- **Font size trop grand** : 20px actuel vs ~18px maquette
- **Margin bottom trop grand** : 20px actuel vs ~16px maquette

#### Impact
**Faible** : Hiérarchie visuelle légèrement moins équilibrée

---

### 1.3 Spacing Interne des Collection Cards

#### Maquette
- **Padding**: ~20px uniforme
- **Gap image → titre**: ~12px
- **Gap titre → description**: ~6px
- **Gap description → progress bar**: ~12px
- **Gap progress bar → stats**: ~10px

#### Implémentation Actuelle
```tsx
// CollectionCard.tsx ligne 46
padding: '24px' // Desktop
// Mobile: 16px via CSS

marginBottom entre éléments :
- Image → Titre: 16px (ligne 66)
- Titre → Description: 8px (ligne 128)
- Description → Progress bar: 16px (ligne 142)
- Progress bar → Stats: 12px (ligne 151)
```

#### Écart Identifié
- **Padding desktop trop grand** : 24px actuel vs ~20px maquette
- **Gap image → titre trop grand** : 16px actuel vs ~12px maquette
- **Gap description → progress bar trop grand** : 16px actuel vs ~12px maquette

#### Impact
**Moyen** : Cards moins denses visuellement, moins d'informations visible à l'écran

---

## 2. Typography & Hierarchy

### 2.1 Titre de Collection Card

#### Maquette
- **Font family**: Manrope (Editorial)
- **Font size**: ~20px (1.25rem)
- **Font weight**: 700 (Bold)
- **Line height**: ~1.2
- **Color**: #191c1d
- **Letter spacing**: -0.01em (légèrement resserré pour premium feel)

#### Implémentation Actuelle
```tsx
// CollectionCard.tsx lignes 124-130
fontFamily: 'Manrope, sans-serif' ✅
fontSize: '1.5rem' // = 24px ❌
fontWeight: '700' ✅
lineHeight: '1.2' ✅
color: '#191c1d' ✅
// Letter spacing: non défini (default = 0)
```

#### Écart Identifié
- **Font size TROP GRAND** : 24px actuel vs ~20px maquette (écart de 20%)
- **Letter spacing manquant** : Pas de légère compression typographique premium

#### Impact
**Fort** : Le titre domine trop visuellement, déséquilibre la hiérarchie

---

### 2.2 Description de Collection Card

#### Maquette
- **Font family**: Inter (Utility)
- **Font size**: ~13px (0.8125rem)
- **Font weight**: 400 (Regular)
- **Line height**: ~1.4
- **Color**: #5f6368 (légèrement plus clair que on-surface-variant)

#### Implémentation Actuelle
```tsx
// CollectionCard.tsx lignes 138-145
fontFamily: 'Inter, sans-serif' ✅
fontSize: '0.875rem' // = 14px ❌
color: '#43474e' ❌ (trop foncé)
lineHeight: '1.5' ❌
```

#### Écart Identifié
- **Font size légèrement trop grand** : 14px actuel vs ~13px maquette
- **Couleur trop foncée** : #43474e actuel vs ~#5f6368 maquette (moins de contraste avec le titre)
- **Line height trop grand** : 1.5 actuel vs ~1.4 maquette

#### Impact
**Moyen** : Description trop présente, manque de distinction visuelle avec le titre

---

### 2.3 Stats (Completion Count)

#### Maquette
- **Font size principal** : ~14px (0.875rem) pour "232 / 480 cards"
- **Font weight principal** : 600 (Semibold)
- **Font size secondaire** : ~12px (0.75rem) pour "62%"
- **Font weight secondaire** : 700 (Bold)
- **Color stats** : #191c1d
- **Color percentage** : Gradient violet (text gradient)

#### Implémentation Actuelle
```tsx
// CollectionCard.tsx lignes 186-190 (count)
fontSize: '0.875rem' ✅
fontWeight: '600' ✅

// lignes 209-216 (percentage)
fontSize: '1.25rem' ❌ (trop grand)
fontWeight: '700' ✅
gradient violet ✅
```

#### Écart Identifié
- **Percentage font size TROP GRAND** : 20px (1.25rem) actuel vs ~12px maquette
- Le percentage devrait être **PLUS PETIT** que le count, pas l'inverse !

#### Impact
**Fort** : Hiérarchie inversée, le percentage domine alors qu'il devrait être un accent subtil

---

### 2.4 Badge "Complete"

#### Maquette
- **Font size**: ~11px (0.6875rem)
- **Font weight**: 700 (Bold)
- **Text transform**: UPPERCASE
- **Letter spacing**: 0.08em (bien espacé)
- **Padding**: 4px 10px (compact)
- **Border radius**: ~12px (pill compact)

#### Implémentation Actuelle
```tsx
// CollectionCard.tsx lignes 88-95
fontSize: '0.75rem' // = 12px ❌
fontWeight: '700' ✅
textTransform: 'uppercase' ✅
letterSpacing: '0.05em' ❌ (trop serré)
padding: '6px 12px' ❌ (trop grand)
borderRadius: '16px' ❌ (trop rond)
```

#### Écart Identifié
- **Font size légèrement trop grand** : 12px actuel vs ~11px maquette
- **Letter spacing insuffisant** : 0.05em actuel vs ~0.08em maquette
- **Padding trop généreux** : 6px 12px actuel vs ~4px 10px maquette
- **Border radius trop grand** : 16px actuel vs ~12px maquette

#### Impact
**Faible-Moyen** : Badge moins compact et premium

---

## 3. Collection Cards - Design & Depth

### 3.1 Card Shadow / Elevation

#### Maquette
- **État par défaut** : Shadow subtile visible, profondeur douce
  - Estimation : `0px 8px 24px rgba(25, 28, 29, 0.08)`
  - Effet : Élévation naturelle, cards "flottent" légèrement sur le fond
- **État hover** : Shadow plus prononcée, élévation accentuée
  - Estimation : `0px 12px 32px rgba(25, 28, 29, 0.12), 0px 4px 16px rgba(25, 28, 29, 0.06)`

#### Implémentation Actuelle
```tsx
// CollectionCard.tsx lignes 51-53
boxShadow: isHovered
  ? '0 20px 40px rgba(0, 0, 0, 0.08), 0 8px 16px rgba(0, 0, 0, 0.04)' ✅ (bon)
  : '0 4px 8px rgba(0, 0, 0, 0.02)' ❌ (TROP SUBTIL)
```

#### Écart Identifié
- **Shadow par défaut BEAUCOUP TROP SUBTILE** : 
  - Actuel : `rgba(0,0,0,0.02)` → Quasi invisible
  - Maquette : `rgba(25,28,29,0.08)` → 4x plus prononcée
- **Opacity insuffisante** : Les cards ne se détachent pas assez du fond `--surface`

#### Impact
**FORT** : **Écart visuel majeur**. Les cards manquent de profondeur et de présence. Elles semblent "plates" sur le fond au lieu de "flotter" comme une galerie premium.

---

### 3.2 Card Border Radius

#### Maquette
- **Border radius**: ~20px (entre lg et xl)
- **Effet** : Arrondi doux et premium, pas trop rond

#### Implémentation Actuelle
```tsx
// CollectionCard.tsx ligne 45
borderRadius: '24px' // = xl
```

#### Écart Identifié
- **Border radius légèrement trop grand** : 24px actuel vs ~20px maquette

#### Impact
**Faible** : Différence subtile, style légèrement moins raffiné

---

### 3.3 Hero Image Background

#### Maquette
- **Background color** : #e8eaed (légèrement plus froid)
- **Border radius** : ~12px
- **Height mobile** : ~140px

#### Implémentation Actuelle
```tsx
// CollectionCard.tsx lignes 64-65
borderRadius: '16px' ❌
background: '#eaebec' ❌ (légèrement trop chaud)
// Height mobile : 120px (ligne 215 CSS)
```

#### Écart Identifié
- **Border radius trop grand** : 16px actuel vs ~12px maquette
- **Background trop chaud** : #eaebec actuel vs #e8eaed maquette (différence subtile mais perceptible)
- **Height trop petit sur mobile** : 120px actuel vs ~140px maquette

#### Impact
**Moyen** : Hero image moins présente sur mobile, ratio image/texte déséquilibré

---

### 3.4 Progress Bar

#### Maquette
- **Track height** : ~10px (entre 8px et 12px)
- **Track background** : #e8e9ea (surface-container-high) ✅
- **Indicator gradient** : #667eea → #764ba2 ✅
- **Border radius** : 9999px (pill) ✅
- **Inner glow/shadow** : Effet subtil mais présent
  - Estimation : `inset 0 1px 2px rgba(0,0,0,0.08), 0 0 8px rgba(102,126,234,0.4)`
- **Outer glow** : Effet "énergie liquide" plus prononcé qu'actuel

#### Implémentation Actuelle
```tsx
// CollectionCard.tsx lignes 154-171
height: '8px' ❌ (trop fine)
background: '#e8e9ea' ✅
gradient: 'linear-gradient(90deg, #667eea 0%, #764ba2 100%)' ✅
borderRadius: '9999px' ✅
boxShadow: '0 0 8px rgba(102, 126, 234, 0.5)' ⚠️ (manque inner shadow)
```

#### Écart Identifié
- **Height trop petite** : 8px actuel vs ~10px maquette (écart de 25%)
- **Inner shadow manquant** : Pas d'effet de profondeur interne
- **Outer glow insuffisant** : Effect "énergie liquide" moins prononcé

#### Impact
**Moyen-Fort** : Progress bar moins visible et premium, manque l'effet "liquide brillant" signature

---

## 4. Bottom Navigation

### 4.1 Style Général

#### Maquette
- **Height** : ~72px (plus haute que actuel)
- **Background** : Glassmorphism subtil
  - Base : `rgba(255, 255, 255, 0.85)`
  - Backdrop blur : ~16px
- **Shadow** : Plus prononcée que actuel
  - Estimation : `0 -6px 20px rgba(25, 28, 29, 0.10)`
- **Séparateur top** : Ligne 1px très subtile `rgba(0,0,0,0.05)` (optionnel, probablement via shadow)

#### Implémentation Actuelle
```tsx
// BottomNav.tsx lignes 24-26
height: '64px' ❌
background: 'var(--surface-container-lowest)' ❌ (opaque, pas de blur)
boxShadow: '0 -4px 16px rgba(25, 28, 29, 0.06)' ❌ (trop subtil)
```

#### Écart Identifié
- **Height trop petite** : 64px actuel vs ~72px maquette (12.5% moins haut)
- **Background opaque** : Pas de glassmorphism, pas de blur
- **Shadow trop subtile** : 0.06 opacity actuel vs ~0.10 maquette

#### Impact
**Moyen-Fort** : Bottom nav moins premium, manque l'effet "flottant" glassmorphism

---

### 4.2 Icons + Labels

#### Maquette
- **Icon size** : ~24px (1.5rem) ✅
- **Label font size** : ~11px (0.6875rem)
- **Label font weight** : 600 (Semibold) pour état actif, 500 pour inactif ✅
- **Gap icon → label** : ~4px ✅
- **Couleur active** : #667eea (primary) ✅
- **Couleur inactive** : #5f6368 (plus clair que actuel)

#### Implémentation Actuelle
```tsx
// BottomNav.tsx lignes 45-46
fontSize: '0.625rem' // = 10px ❌
fontWeight: active ? '600' : '500' ✅
color: active ? '#667eea' : 'var(--on-surface-variant)' ⚠️
// --on-surface-variant = #43474e (trop foncé)
```

#### Écart Identifié
- **Label font size trop petite** : 10px actuel vs ~11px maquette
- **Couleur inactive trop foncée** : #43474e actuel vs #5f6368 maquette (moins de contraste nécessaire)

#### Impact
**Faible-Moyen** : Labels moins lisibles, contraste excessif pour état inactif

---

### 4.3 État Actif - Background Indicator

#### Maquette
- **Background actif** : Pill subtil derrière l'icône + label
  - Couleur : `rgba(102, 126, 234, 0.08)` (violet très clair)
  - Border radius : ~16px
  - Padding : ~8px 12px
  - Effet : Highlight doux, pas agressif

#### Implémentation Actuelle
```tsx
// BottomNav.tsx lignes 38-53
// ❌ PAS DE BACKGROUND INDICATOR POUR ÉTAT ACTIF
// Seulement changement de couleur texte + weight
```

#### Écart Identifié
- **Background indicator complètement manquant**
- Pas de différenciation visuelle forte de l'état actif (juste couleur)

#### Impact
**Moyen** : État actif moins évident visuellement, UX moins claire

---

## 5. Mobile Header

### 5.1 Style Général

#### Maquette
- **Height** : ~60px
- **Background** : Même glassmorphism que bottom nav
  - Base : `rgba(255, 255, 255, 0.85)`
  - Backdrop blur : ~16px
- **Shadow** : `0 2px 12px rgba(25, 28, 29, 0.08)`

#### Implémentation Actuelle
```tsx
// MobileHeader.tsx lignes 13-14
height: '56px' ❌
background: 'var(--surface-container-lowest)' ❌ (opaque)
boxShadow: '0 2px 8px rgba(25, 28, 29, 0.06)' ❌ (trop subtil)
```

#### Écart Identifié
- **Height trop petite** : 56px actuel vs ~60px maquette
- **Background opaque** : Pas de glassmorphism (cohérence avec bottom nav)
- **Shadow trop subtile** : blur 8px vs ~12px maquette

#### Impact
**Moyen** : Header moins premium, manque cohérence glassmorphism

---

### 5.2 Logo

#### Maquette
- **Font size** : ~22px (1.375rem)
- **Font weight** : 800 (Extrabold) ✅
- **Gradient** : #667eea → #764ba2 ✅

#### Implémentation Actuelle
```tsx
// MobileHeader.tsx lignes 29-30
fontSize: '1.25rem' // = 20px ❌
fontWeight: 800 ✅
gradient ✅
```

#### Écart Identifié
- **Font size trop petite** : 20px actuel vs ~22px maquette (10% moins grand)

#### Impact
**Faible** : Logo légèrement moins présent

---

## 6. Colors & Effects

### 6.1 Background Global

#### Maquette
- **Background** : Solid `--surface` (#f8f9fa)
- **Effet** : Flat, pas de gradient

#### Implémentation Actuelle
```css
/* globals.css ligne 56 */
body {
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); ❌
}
```

#### Écart Identifié
- **Background gradient INCORRECT** : 
  - Actuel : Gradient violet pleine page
  - Maquette : Solid surface (#f8f9fa)
- **Violation de l'Ethos** : Le gradient violet doit être utilisé avec PARCIMONIE (CTAs, progress bars), pas en full background

#### Impact
**CRITIQUE** : **Écart majeur**. L'identité visuelle est complètement faussée. Le fond devrait être neutre pour laisser les collections fournir la couleur.

---

### 6.2 Tonal Layering

#### Maquette
- **Page background** : `--surface` (#f8f9fa) ✅
- **Cards** : `--surface-container-lowest` (#ffffff) ✅
- **Hero image placeholder** : `--surface-container-low` (~#e8eaed) ⚠️
- **Progress bar track** : `--surface-container-high` (#e8e9ea) ✅

#### Implémentation Actuelle
Globalement respecté ✅, sauf :
- Hero image background légèrement off (#eaebec vs #e8eaed)

#### Impact
**Faible** : Tonal layering bien implémenté globalement

---

### 6.3 Shadows - Profondeur Générale

#### Maquette
**Philosophie** : Shadows visibles mais douces, créent une élévation architecturale

| Élément | Shadow Maquette | Shadow Actuelle | Écart |
|---------|----------------|-----------------|-------|
| **Cards (default)** | `0 8px 24px rgba(25,28,29,0.08)` | `0 4px 8px rgba(0,0,0,0.02)` | **Trop subtil** ❌ |
| **Cards (hover)** | `0 12px 32px rgba(25,28,29,0.12)` + `0 4px 16px rgba(25,28,29,0.06)` | `0 20px 40px rgba(0,0,0,0.08)` + `0 8px 16px rgba(0,0,0,0.04)` | **Bon** ✅ |
| **Bottom Nav** | `0 -6px 20px rgba(25,28,29,0.10)` | `0 -4px 16px rgba(25,28,29,0.06)` | **Trop subtil** ❌ |
| **Mobile Header** | `0 2px 12px rgba(25,28,29,0.08)` | `0 2px 8px rgba(25,28,29,0.06)` | **Trop subtil** ❌ |

#### Écart Identifié
- **Shadows systématiquement trop subtiles** (sauf hover)
- **Opacity insuffisante** : Moy. 0.08-0.10 maquette vs 0.02-0.06 actuel
- **Blur radius insuffisant** : Cards default blur 24px maquette vs 8px actuel

#### Impact
**FORT** : **Écart critique**. L'UI manque de profondeur et de "quiet authority". Tout semble plat.

---

## 7. Spacing & Whitespace

### 7.1 Philosophie Générale

#### Maquette
- **Breathing room généreux** : Espaces verticaux confortables
- **Asymétrie intentionnelle** : Pas d'espacement rigide mathématique
- **Approche galerie** : Le whitespace est un élément de design

#### Implémentation Actuelle
- Espaces **trop généreux** dans certains cas (padding page, gap sections)
- Espaces **trop serrés** dans d'autres (cards, progress bar height)
- **Manque de cohérence** dans l'échelle d'espacement

#### Impact
**Moyen** : Rythme visuel moins harmonieux

---

### 7.2 Gaps Spécifiques Identifiés

| Zone | Gap Maquette | Gap Actuel | Écart |
|------|-------------|------------|-------|
| **Padding page latéral** | ~20px | 24px | Trop grand ❌ |
| **Padding page top** | ~24px | 32px | Trop grand ❌ |
| **Section gap (Collections → Activité)** | ~28px | 40px | Trop grand ❌ |
| **Card padding** | ~20px | 24px (desktop), 16px (mobile) | Desktop trop grand ❌ |
| **Hero → Titre** | ~12px | 16px | Trop grand ❌ |
| **Titre → Description** | ~6px | 8px | Légèrement trop grand ⚠️ |
| **Description → Progress** | ~12px | 16px | Trop grand ❌ |
| **Progress → Stats** | ~10px | 12px | Légèrement trop grand ⚠️ |

---

## 8. Éléments Manquants ou Différents

### 8.1 Badge "Not Started" Style Différent

#### Maquette
- Style épuré, background blanc transparent
- Positioning : Top-left (comme implémenté) ✅

#### Implémentation Actuelle
```tsx
// CollectionCard.tsx lignes 106-116
background: 'rgba(255, 255, 255, 0.9)' ✅
color: '#43474e' ⚠️ (légèrement trop foncé)
```

#### Écart
**Faible** : Globalement fidèle

---

### 8.2 "X to go" Label Style

#### Maquette
- Emoji 🎯 présent ✅
- Font size ~12px ✅
- Position : Sous le count principal ✅

#### Implémentation Actuelle
Bien implémenté ✅

---

### 8.3 Micro-interactions / Animations

#### Maquette (suppositions basées sur best practices Ethos)
- **Card hover** : Scale + shadow (implémenté) ✅
- **Bottom nav tap** : Ripple effect ou scale down (manquant) ❌
- **Progress bar** : Shimmer effect (implémenté) ✅

#### Écart
**Faible** : Manque feedback tactile sur bottom nav

---

## 9. Récapitulatif des Écarts Majeurs

### Écarts CRITIQUES (Impact Fort - Priorité Haute)

1. **Background body gradient violet** → Doit être solid `--surface` (#f8f9fa)
2. **Card shadows trop subtiles** → Augmenter opacity de 0.02 à 0.08
3. **Progress bar trop fine** → Augmenter height de 8px à 10px
4. **Titre collection trop grand** → Réduire de 24px (1.5rem) à 20px (1.25rem)
5. **Percentage stat trop grand** → Réduire de 20px (1.25rem) à 12px (0.75rem) - Hiérarchie inversée !

### Écarts IMPORTANTS (Impact Moyen - Priorité Moyenne)

6. **Bottom nav & header : Pas de glassmorphism** → Ajouter backdrop-blur + background rgba
7. **Bottom nav height** → Augmenter de 64px à 72px
8. **Shadow bottom nav & header trop subtiles** → Augmenter opacity
9. **Hero image height mobile** → Augmenter de 120px à 140px
10. **Card padding desktop** → Réduire de 24px à 20px
11. **Progress bar : Manque inner shadow** → Ajouter effet profondeur interne
12. **Espacement général trop généreux** → Réduire padding page et gaps entre sections

### Écarts MINEURS (Impact Faible - Priorité Basse)

13. **Card border radius** → Réduire de 24px à 20px
14. **Logo header font size** → Augmenter de 20px à 22px
15. **Label bottom nav font size** → Augmenter de 10px à 11px
16. **Badge "Complete" letter spacing** → Augmenter de 0.05em à 0.08em
17. **Description color** → Éclaircir de #43474e à #5f6368
18. **Titre section "Mes Collections"** → Réduire font size de 20px à 18px

---

## 10. Score de Fidélité par Section

| Section | Score | Commentaire |
|---------|-------|-------------|
| **Layout général** | 70/100 | Padding et gaps trop généreux |
| **Typography** | 60/100 | Hiérarchie déséquilibrée (titre et percentage trop grands) |
| **Collection Cards** | 65/100 | Shadows trop subtiles, progress bar trop fine |
| **Bottom Nav** | 55/100 | Manque glassmorphism, height incorrecte, pas de background indicator |
| **Mobile Header** | 70/100 | Manque glassmorphism, height légèrement off |
| **Colors** | 40/100 | **Background gradient critique**, tonal layering OK |
| **Effects & Depth** | 50/100 | **Shadows systématiquement trop subtiles** |
| **Spacing** | 65/100 | Inconsistant, trop généreux dans certains cas |

**Score Global Moyen** : **60/100**

---

## Conclusion

L'implémentation actuelle capture **la structure fonctionnelle** de la maquette mais manque crucialement du **polish visuel** et de la **sophistication esthétique** qui font l'identité "The Digital Curator".

**Les 3 écarts les plus impactants visuellement** :
1. Background body gradient au lieu de surface neutre
2. Shadows beaucoup trop subtiles (cards, nav, header)
3. Hiérarchie typographique déséquilibrée (titre et percentage trop grands)

**Prochaine étape** : Plan de redesign structuré en 6 sections avec priorités et spécifications CSS précises.
