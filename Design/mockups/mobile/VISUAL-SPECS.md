# Spécifications Visuelles Détaillées - Redesign Mobile Variante 1

**Date**: 2026-04-28  
**Format**: Prêt à copier-coller pour implémentation  
**Référence**: `REDESIGN-PLAN.md`

---

## Instructions d'Utilisation

Ce document contient les **valeurs CSS exactes** pour chaque modification. Chaque section indique :
- **Élément concerné** : Composant + ligne de code
- **Actuel** : Code existant
- **Nouveau** : Code à appliquer
- **Priorité** : Haute / Moyenne / Basse
- **Impact** : Fort / Moyen / Faible

**Format** : Ready to copy-paste. Les blocs "Nouveau" peuvent être directement intégrés.

---

## 1. GLOBALS.CSS - Variables & Background

### 1.1 Background Body

**Élément** : `body` background  
**Fichier** : `/home/arnaud.dars/git/Collectoria/frontend/src/app/globals.css`  
**Ligne** : 56

**Actuel** :
```css
body {
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  min-height: 100vh;
  color: var(--on-surface);
}
```

**Nouveau** :
```css
body {
  background: var(--surface); /* #f8f9fa - solid neutral */
  min-height: 100vh;
  color: var(--on-surface);
}
```

**Priorité** : 🔴 HAUTE - CRITIQUE  
**Impact** : ⚡ FORT

---

### 1.2 Variables CSS - Shadows & Glassmorphism

**Élément** : Ajout de nouvelles variables `:root`  
**Fichier** : `/home/arnaud.dars/git/Collectoria/frontend/src/app/globals.css`  
**Ligne** : Ajouter après ligne 38 (après variables existantes)

**Nouveau** :
```css
:root {
  /* ... variables existantes ... */
  
  /* Shadows - Collection Cards */
  --shadow-card-default: 0 8px 24px rgba(25, 28, 29, 0.08);
  --shadow-card-hover: 0 12px 32px rgba(25, 28, 29, 0.12), 0 4px 16px rgba(25, 28, 29, 0.06);
  
  /* Shadows - Navigation */
  --shadow-nav-bottom: 0 -6px 20px rgba(25, 28, 29, 0.10);
  --shadow-header: 0 2px 12px rgba(25, 28, 29, 0.08);
  
  /* Glassmorphism */
  --glass-background: rgba(255, 255, 255, 0.85);
  --glass-blur: 16px;
  
  /* Active state */
  --nav-active-bg: rgba(102, 126, 234, 0.08);
  
  /* Progress bar effects */
  --progress-inner-shadow: inset 0 1px 2px rgba(0, 0, 0, 0.08);
  --progress-outer-glow: 0 0 12px rgba(102, 126, 234, 0.6);
}
```

**Priorité** : 🔴 HAUTE  
**Impact** : ⚡ FORT - Facilite la maintenance

---

### 1.3 Tonal Layering - Surface Container Low

**Élément** : Variable `--surface-container-low`  
**Fichier** : `/home/arnaud.dars/git/Collectoria/frontend/src/app/globals.css`  
**Ligne** : 7

**Actuel** :
```css
--surface-container-low: #f3f4f5;
```

**Nouveau** :
```css
--surface-container-low: #e8eaed; /* Ton plus froid pour hero images */
```

**Priorité** : 🟡 BASSE  
**Impact** : 🔹 FAIBLE

---

### 1.4 Padding Mobile - Main Content Wrapper

**Élément** : `.main-content-wrapper` mobile padding  
**Fichier** : `/home/arnaud.dars/git/Collectoria/frontend/src/app/globals.css`  
**Ligne** : 129

**Actuel** :
```css
@media (max-width: 767px) {
  .main-content-wrapper {
    margin-left: 0;
    padding-top: 56px; /* Header mobile */
    padding-bottom: 80px; /* Bottom nav */
  }
}
```

**Nouveau** :
```css
@media (max-width: 767px) {
  .main-content-wrapper {
    margin-left: 0;
    padding-top: 60px; /* Header mobile ajusté */
    padding-bottom: 88px; /* Bottom nav ajusté (72px height + 16px gap) */
  }
}
```

**Priorité** : 🟠 MOYENNE  
**Impact** : 🔸 MOYEN

---

### 1.5 Hero Image Height Mobile

**Élément** : `.collection-card-hero` height mobile  
**Fichier** : `/home/arnaud.dars/git/Collectoria/frontend/src/app/globals.css`  
**Ligne** : 215

**Actuel** :
```css
@media (max-width: 767px) {
  .collection-card-hero {
    height: 120px !important;
  }
}
```

**Nouveau** :
```css
@media (max-width: 767px) {
  .collection-card-hero {
    height: 140px !important; /* Ratio image/texte plus équilibré */
  }
}
```

**Priorité** : 🟠 MOYENNE  
**Impact** : 🔸 MOYEN

---

## 2. PAGE.TSX - Layout & Spacing

### 2.1 Main Container Padding

**Élément** : `<main>` padding  
**Fichier** : `/home/arnaud.dars/git/Collectoria/frontend/src/app/page.tsx`  
**Ligne** : 16

**Actuel** :
```tsx
<main style={{
  minHeight: '100vh',
  background: 'var(--surface)',
  padding: '2rem 1.5rem', // 32px 24px
}}>
```

**Nouveau** :
```tsx
<main style={{
  minHeight: '100vh',
  background: 'var(--surface)',
  padding: '1.5rem 1.25rem', // 24px 20px - Plus d'espace pour contenu
}}>
```

**Priorité** : 🟠 MOYENNE  
**Impact** : 🔸 MOYEN

---

### 2.2 Section Gap (Collections → Activité)

**Élément** : `<section>` marginBottom  
**Fichier** : `/home/arnaud.dars/git/Collectoria/frontend/src/app/page.tsx`  
**Ligne** : 24

**Actuel** :
```tsx
<section style={{ marginBottom: '2.5rem' }}> {/* 40px */}
```

**Nouveau** :
```tsx
<section style={{ marginBottom: '1.75rem' }}> {/* 28px - Sections plus connectées */}
```

**Priorité** : 🟠 MOYENNE  
**Impact** : 🔸 MOYEN

---

### 2.3 Titre Section "Mes Collections"

**Élément** : `<h2>` styles  
**Fichier** : `/home/arnaud.dars/git/Collectoria/frontend/src/app/page.tsx`  
**Lignes** : 25-31

**Actuel** :
```tsx
<h2 style={{
  fontFamily: 'Manrope, sans-serif',
  fontSize: '1.25rem', // 20px
  fontWeight: '700',
  color: 'var(--on-surface)',
  margin: '0 0 1.25rem', // 0 0 20px
}}>
```

**Nouveau** :
```tsx
<h2 style={{
  fontFamily: 'Manrope, sans-serif',
  fontSize: '1.125rem', // 18px - Moins dominant
  fontWeight: '700',
  color: 'var(--on-surface)',
  margin: '0 0 1rem', // 0 0 16px
}}>
```

**Priorité** : 🟡 BASSE  
**Impact** : 🔹 FAIBLE

---

## 3. COLLECTIONCARD.TSX - Typography

### 3.1 Titre Collection - CRITIQUE

**Élément** : Card title `<h3>`  
**Fichier** : `/home/arnaud.dars/git/Collectoria/frontend/src/components/homepage/CollectionCard.tsx`  
**Lignes** : 124-130

**Actuel** :
```tsx
<h3
  className="collection-card-title"
  style={{
    fontFamily: 'Manrope, sans-serif',
    fontSize: '1.5rem', // 24px
    fontWeight: '700',
    color: '#191c1d',
    marginBottom: '8px',
    lineHeight: '1.2',
  }}
>
```

**Nouveau** :
```tsx
<h3
  className="collection-card-title"
  style={{
    fontFamily: 'Manrope, sans-serif',
    fontSize: '1.25rem', // 20px - Rééquilibre hiérarchie
    fontWeight: '700',
    color: '#191c1d',
    marginBottom: '6px', // Réduit de 8px
    lineHeight: '1.2',
    letterSpacing: '-0.01em', // Compression typographique premium
  }}
>
```

**Priorité** : 🔴 HAUTE - CRITIQUE  
**Impact** : ⚡ FORT

---

### 3.2 Description

**Élément** : Card description `<p>`  
**Fichier** : `/home/arnaud.dars/git/Collectoria/frontend/src/components/homepage/CollectionCard.tsx`  
**Lignes** : 136-145

**Actuel** :
```tsx
<p
  className="collection-card-description"
  style={{
    fontFamily: 'Inter, sans-serif',
    fontSize: '0.875rem', // 14px
    color: '#43474e',
    marginBottom: '16px',
    lineHeight: '1.5',
    minHeight: '42px',
  }}
>
```

**Nouveau** :
```tsx
<p
  className="collection-card-description"
  style={{
    fontFamily: 'Inter, sans-serif',
    fontSize: '0.8125rem', // 13px - Moins compétitif avec titre
    color: '#5f6368', // Plus clair pour distinction
    marginBottom: '12px', // Réduit de 16px
    lineHeight: '1.4', // Plus dense
    minHeight: '42px',
  }}
>
```

**Priorité** : 🟠 MOYENNE  
**Impact** : 🔸 MOYEN

---

### 3.3 Percentage Stat - CRITIQUE (Hiérarchie Inversée)

**Élément** : Percentage display  
**Fichier** : `/home/arnaud.dars/git/Collectoria/frontend/src/components/homepage/CollectionCard.tsx`  
**Lignes** : 208-216

**Actuel** :
```tsx
<div style={{
  fontFamily: 'Inter, sans-serif',
  fontSize: '1.25rem', // 20px - TROP GRAND
  fontWeight: '700',
  background: 'linear-gradient(135deg, #667eea 0%, #764ba2 100%)',
  WebkitBackgroundClip: 'text',
  WebkitTextFillColor: 'transparent',
  backgroundClip: 'text',
}}>
  {percentage}%
</div>
```

**Nouveau** :
```tsx
<div style={{
  fontFamily: 'Inter, sans-serif',
  fontSize: '0.75rem', // 12px - Accent subtil, pas dominant
  fontWeight: '700',
  background: 'linear-gradient(135deg, #667eea 0%, #764ba2 100%)',
  WebkitBackgroundClip: 'text',
  WebkitTextFillColor: 'transparent',
  backgroundClip: 'text',
}}>
  {percentage}%
</div>
```

**Priorité** : 🔴 HAUTE - CRITIQUE  
**Impact** : ⚡ FORT - Corrige hiérarchie inversée

---

### 3.4 Badge "Complete"

**Élément** : Complete badge  
**Fichier** : `/home/arnaud.dars/git/Collectoria/frontend/src/components/homepage/CollectionCard.tsx`  
**Lignes** : 82-95

**Actuel** :
```tsx
<div style={{
  position: 'absolute',
  top: '12px',
  right: '12px',
  background: 'linear-gradient(135deg, #10b981 0%, #059669 100%)',
  color: '#ffffff',
  padding: '6px 12px',
  borderRadius: '16px',
  fontFamily: 'Inter, sans-serif',
  fontSize: '0.75rem', // 12px
  fontWeight: '700',
  textTransform: 'uppercase',
  letterSpacing: '0.05em',
  boxShadow: '0 4px 12px rgba(16, 185, 129, 0.4)',
}}>
  Complete
</div>
```

**Nouveau** :
```tsx
<div style={{
  position: 'absolute',
  top: '12px',
  right: '12px',
  background: 'linear-gradient(135deg, #10b981 0%, #059669 100%)',
  color: '#ffffff',
  padding: '4px 10px', // Plus compact
  borderRadius: '12px', // Moins rond
  fontFamily: 'Inter, sans-serif',
  fontSize: '0.6875rem', // 11px
  fontWeight: '700',
  textTransform: 'uppercase',
  letterSpacing: '0.08em', // Plus espacé pour lisibilité
  boxShadow: '0 4px 12px rgba(16, 185, 129, 0.4)',
}}>
  Complete
</div>
```

**Priorité** : 🟡 BASSE  
**Impact** : 🔹 FAIBLE

---

## 4. COLLECTIONCARD.TSX - Card Structure

### 4.1 Card Container - Shadow & Border Radius

**Élément** : Card container `<div>`  
**Fichier** : `/home/arnaud.dars/git/Collectoria/frontend/src/components/homepage/CollectionCard.tsx`  
**Lignes** : 38-55

**Actuel** :
```tsx
<div
  className="collection-card-container"
  onClick={() => router.push(getCollectionRoute(collection.slug))}
  onMouseEnter={() => setIsHovered(true)}
  onMouseLeave={() => setIsHovered(false)}
  style={{
    background: '#ffffff',
    borderRadius: '24px',
    padding: '24px',
    position: 'relative',
    overflow: 'hidden',
    transition: 'all 0.3s cubic-bezier(0.4, 0, 0.2, 1)',
    transform: isHovered ? 'scale(1.02)' : 'scale(1)',
    boxShadow: isHovered
      ? '0 20px 40px rgba(0, 0, 0, 0.08), 0 8px 16px rgba(0, 0, 0, 0.04)'
      : '0 4px 8px rgba(0, 0, 0, 0.02)', // TROP SUBTIL
    cursor: 'pointer',
  }}
>
```

**Nouveau** :
```tsx
<div
  className="collection-card-container"
  onClick={() => router.push(getCollectionRoute(collection.slug))}
  onMouseEnter={() => setIsHovered(true)}
  onMouseLeave={() => setIsHovered(false)}
  style={{
    background: '#ffffff',
    borderRadius: '20px', // Réduit de 24px - Plus raffiné
    padding: '20px', // Réduit de 24px - Plus dense
    position: 'relative',
    overflow: 'hidden',
    transition: 'all 0.3s cubic-bezier(0.4, 0, 0.2, 1)',
    transform: isHovered ? 'scale(1.02)' : 'scale(1)',
    boxShadow: isHovered
      ? '0 12px 32px rgba(25, 28, 29, 0.12), 0 4px 16px rgba(25, 28, 29, 0.06)' // Ajusté
      : '0 8px 24px rgba(25, 28, 29, 0.08)', // BEAUCOUP PLUS VISIBLE - 4x opacity
    cursor: 'pointer',
  }}
>
```

**Alternative avec variables CSS** :
```tsx
boxShadow: isHovered
  ? 'var(--shadow-card-hover)'
  : 'var(--shadow-card-default)',
```

**Priorité** : 🔴 HAUTE - CRITIQUE  
**Impact** : ⚡ FORT - Cards gagnent profondeur et présence

---

### 4.2 Hero Image Background

**Élément** : Hero image container  
**Fichier** : `/home/arnaud.dars/git/Collectoria/frontend/src/components/homepage/CollectionCard.tsx`  
**Lignes** : 58-68

**Actuel** :
```tsx
<div
  className="collection-card-hero"
  style={{
    position: 'relative',
    width: '100%',
    height: '160px',
    borderRadius: '16px',
    background: '#eaebec',
    marginBottom: '16px',
    overflow: 'hidden',
  }}
>
```

**Nouveau** :
```tsx
<div
  className="collection-card-hero"
  style={{
    position: 'relative',
    width: '100%',
    height: '160px',
    borderRadius: '12px', // Réduit de 16px
    background: '#e8eaed', // Ton plus froid (ou var(--surface-container-low))
    marginBottom: '12px', // Réduit de 16px
    overflow: 'hidden',
  }}
>
```

**Priorité** : 🟠 MOYENNE  
**Impact** : 🔸 MOYEN

---

### 4.3 Progress Bar - CRITIQUE

**Élément** : Progress bar track & indicator  
**Fichier** : `/home/arnaud.dars/git/Collectoria/frontend/src/components/homepage/CollectionCard.tsx`  
**Lignes** : 150-171

**Actuel** :
```tsx
{/* Progress Bar */}
<div style={{
  width: '100%',
  height: '8px', // TROP FIN
  background: '#e8e9ea',
  borderRadius: '9999px',
  overflow: 'hidden',
  marginBottom: '12px',
  position: 'relative',
}}>
  <div
    className="collection-card-progress-bar"
    style={{
      width: `${percentage}%`,
      height: '100%',
      background: 'linear-gradient(90deg, #667eea 0%, #764ba2 100%)',
      borderRadius: '9999px',
      position: 'relative',
      boxShadow: percentage > 0 ? '0 0 8px rgba(102, 126, 234, 0.5)' : 'none', // Manque inner shadow
      transition: 'width 0.6s ease-in-out',
    }}
  />
</div>
```

**Nouveau** :
```tsx
{/* Progress Bar */}
<div style={{
  width: '100%',
  height: '10px', // Augmenté de 8px - 25% plus haute
  background: '#e8e9ea',
  borderRadius: '9999px',
  overflow: 'hidden',
  marginBottom: '10px', // Réduit de 12px
  position: 'relative',
}}>
  <div
    className="collection-card-progress-bar"
    style={{
      width: `${percentage}%`,
      height: '100%',
      background: 'linear-gradient(90deg, #667eea 0%, #764ba2 100%)',
      borderRadius: '9999px',
      position: 'relative',
      boxShadow: percentage > 0 
        ? 'inset 0 1px 2px rgba(0, 0, 0, 0.08), 0 0 12px rgba(102, 126, 234, 0.6)' 
        : 'none', // Inner shadow + outer glow prononcé
      transition: 'width 0.6s ease-in-out',
    }}
  />
</div>
```

**Alternative avec variables CSS** :
```tsx
boxShadow: percentage > 0 
  ? 'var(--progress-inner-shadow), var(--progress-outer-glow)' 
  : 'none',
```

**Priorité** : 🔴 HAUTE - CRITIQUE  
**Impact** : ⚡ FORT - Effet "énergie liquide" premium

---

### 4.4 Card Padding Mobile Override

**Élément** : `.collection-card-container` media query  
**Fichier** : `/home/arnaud.dars/git/Collectoria/frontend/src/app/globals.css`  
**Ligne** : 227

**Actuel** :
```css
@media (max-width: 767px) {
  .collection-card-container {
    padding: 16px !important;
  }
}
```

**Nouveau** :
```css
@media (max-width: 767px) {
  .collection-card-container {
    padding: 18px !important; /* Entre 16px et 20px pour mobile */
  }
}
```

**Priorité** : 🟡 BASSE  
**Impact** : 🔹 FAIBLE

---

## 5. BOTTOMNAV.TSX - Glassmorphism & Active State

### 5.1 Nav Container - Glassmorphism

**Élément** : `<nav>` styles  
**Fichier** : `/home/arnaud.dars/git/Collectoria/frontend/src/components/layout/BottomNav.tsx`  
**Lignes** : 17-30

**Actuel** :
```tsx
<nav
  className="bottom-nav-mobile"
  style={{
    position: 'fixed',
    bottom: 0,
    left: 0,
    right: 0,
    height: '64px',
    background: 'var(--surface-container-lowest)', // Opaque
    boxShadow: '0 -4px 16px rgba(25, 28, 29, 0.06)', // Trop subtil
    zIndex: 100,
    justifyContent: 'space-around',
    alignItems: 'center',
  }}
>
```

**Nouveau** :
```tsx
<nav
  className="bottom-nav-mobile"
  style={{
    position: 'fixed',
    bottom: 0,
    left: 0,
    right: 0,
    height: '72px', // Augmenté de 64px - Plus confortable
    background: 'rgba(255, 255, 255, 0.85)', // Semi-transparent
    backdropFilter: 'blur(16px)', // Glassmorphism
    WebkitBackdropFilter: 'blur(16px)', // Safari support
    boxShadow: '0 -6px 20px rgba(25, 28, 29, 0.10)', // Plus prononcée
    zIndex: 100,
    display: 'flex', // Ajouté pour cohérence
    justifyContent: 'space-around',
    alignItems: 'center',
  }}
>
```

**Alternative avec variables CSS** :
```tsx
background: 'var(--glass-background)',
backdropFilter: `blur(var(--glass-blur))`,
WebkitBackdropFilter: `blur(var(--glass-blur))`,
boxShadow: 'var(--shadow-nav-bottom)',
```

**Priorité** : 🔴 HAUTE  
**Impact** : ⚡ FORT - Effet premium flottant

---

### 5.2 Nav Link - Active State Background Indicator

**Élément** : `<Link>` styles  
**Fichier** : `/home/arnaud.dars/git/Collectoria/frontend/src/components/layout/BottomNav.tsx`  
**Lignes** : 35-54

**Actuel** :
```tsx
<Link
  key={href}
  href={href}
  style={{
    display: 'flex',
    flexDirection: 'column',
    alignItems: 'center',
    justifyContent: 'center',
    gap: '2px',
    fontFamily: 'Inter, sans-serif',
    fontSize: '0.625rem', // 10px
    fontWeight: active ? '600' : '500',
    color: active ? '#667eea' : 'var(--on-surface-variant)',
    padding: '8px 4px',
    textDecoration: 'none',
    transition: 'all 0.15s ease-in-out',
    flex: 1,
    textAlign: 'center',
  }}
>
```

**Nouveau** :
```tsx
<Link
  key={href}
  href={href}
  style={{
    display: 'flex',
    flexDirection: 'column',
    alignItems: 'center',
    justifyContent: 'center',
    gap: '4px', // Augmenté de 2px pour accommoder background
    fontFamily: 'Inter, sans-serif',
    fontSize: '0.6875rem', // 11px - Plus lisible
    fontWeight: active ? '600' : '500',
    color: active ? '#667eea' : '#5f6368', // Couleur inactive plus claire
    padding: active ? '8px 12px' : '8px 4px', // Padding accru pour état actif
    textDecoration: 'none',
    transition: 'all 0.2s cubic-bezier(0.4, 0, 0.2, 1)', // Transition plus smooth
    flex: 1,
    textAlign: 'center',
    background: active ? 'rgba(102, 126, 234, 0.08)' : 'transparent', // Background pill
    borderRadius: '16px', // Forme pill
  }}
>
```

**Alternative avec variables CSS** :
```tsx
background: active ? 'var(--nav-active-bg)' : 'transparent',
```

**Priorité** : 🟠 MOYENNE  
**Impact** : 🔸 MOYEN - État actif beaucoup plus clair

---

## 6. MOBILEHEADER.TSX - Glassmorphism & Height

### 6.1 Header Container

**Élément** : `<header>` styles  
**Fichier** : `/home/arnaud.dars/git/Collectoria/frontend/src/components/layout/MobileHeader.tsx`  
**Lignes** : 5-22

**Actuel** :
```tsx
<header
  className="mobile-header"
  style={{
    position: 'fixed',
    top: 0,
    left: 0,
    right: 0,
    width: '100%',
    height: '56px',
    background: 'var(--surface-container-lowest)', // Opaque
    boxShadow: '0 2px 8px rgba(25, 28, 29, 0.06)', // Trop subtil
    zIndex: 100,
    display: 'flex',
    alignItems: 'center',
    justifyContent: 'space-between',
    paddingLeft: '16px',
    paddingRight: '16px',
  }}
>
```

**Nouveau** :
```tsx
<header
  className="mobile-header"
  style={{
    position: 'fixed',
    top: 0,
    left: 0,
    right: 0,
    width: '100%',
    height: '60px', // Augmenté de 56px
    background: 'rgba(255, 255, 255, 0.85)', // Semi-transparent - Cohérence avec nav
    backdropFilter: 'blur(16px)', // Glassmorphism
    WebkitBackdropFilter: 'blur(16px)', // Safari support
    boxShadow: '0 2px 12px rgba(25, 28, 29, 0.08)', // Plus prononcée
    zIndex: 100,
    display: 'flex',
    alignItems: 'center',
    justifyContent: 'space-between',
    paddingLeft: '20px', // Augmenté de 16px pour cohérence avec page padding
    paddingRight: '20px',
  }}
>
```

**Alternative avec variables CSS** :
```tsx
background: 'var(--glass-background)',
backdropFilter: `blur(var(--glass-blur))`,
WebkitBackdropFilter: `blur(var(--glass-blur))`,
boxShadow: 'var(--shadow-header)',
```

**Priorité** : 🔴 HAUTE  
**Impact** : ⚡ FORT - Cohérence glassmorphism

---

### 6.2 Logo

**Élément** : Logo `<div>`  
**Fichier** : `/home/arnaud.dars/git/Collectoria/frontend/src/components/layout/MobileHeader.tsx`  
**Lignes** : 25-35

**Actuel** :
```tsx
<div
  style={{
    fontFamily: 'Manrope, sans-serif',
    fontSize: '1.25rem', // 20px
    fontWeight: 800,
    background: 'linear-gradient(135deg, #667eea 0%, #764ba2 100%)',
    WebkitBackgroundClip: 'text',
    WebkitTextFillColor: 'transparent',
    backgroundClip: 'text',
  }}
>
  Collectoria
</div>
```

**Nouveau** :
```tsx
<div
  style={{
    fontFamily: 'Manrope, sans-serif',
    fontSize: '1.375rem', // 22px - Plus présent
    fontWeight: 800,
    background: 'linear-gradient(135deg, #667eea 0%, #764ba2 100%)',
    WebkitBackgroundClip: 'text',
    WebkitTextFillColor: 'transparent',
    backgroundClip: 'text',
  }}
>
  Collectoria
</div>
```

**Priorité** : 🟠 MOYENNE  
**Impact** : 🔸 MOYEN

---

## 7. Récapitulatif des Modifications par Fichier

### globals.css (8 modifications)

1. ✅ Body background : gradient → solid surface
2. ✅ Variables CSS : Ajout shadow/glassmorphism variables
3. ✅ --surface-container-low : #f3f4f5 → #e8eaed
4. ✅ .main-content-wrapper padding-top : 56px → 60px
5. ✅ .main-content-wrapper padding-bottom : 80px → 88px
6. ✅ .collection-card-hero height mobile : 120px → 140px
7. ✅ .collection-card-container padding mobile : 16px → 18px
8. ⚠️ (Optionnel) Ajuster .collection-card-title CSS pour letter-spacing

### page.tsx (3 modifications)

1. ✅ Main padding : 2rem 1.5rem → 1.5rem 1.25rem
2. ✅ Section marginBottom : 2.5rem → 1.75rem
3. ✅ h2 fontSize : 1.25rem → 1.125rem + margin : 1.25rem → 1rem

### CollectionCard.tsx (10 modifications)

1. ✅ **CRITIQUE** Card boxShadow default : rgba(0,0,0,0.02) → rgba(25,28,29,0.08)
2. ✅ Card boxShadow hover : Ajuster rgba values
3. ✅ Card borderRadius : 24px → 20px
4. ✅ Card padding : 24px → 20px
5. ✅ **CRITIQUE** Title fontSize : 1.5rem → 1.25rem + letterSpacing : -0.01em
6. ✅ Title marginBottom : 8px → 6px
7. ✅ Description fontSize : 0.875rem → 0.8125rem, color : #43474e → #5f6368, lineHeight : 1.5 → 1.4
8. ✅ Description marginBottom : 16px → 12px
9. ✅ **CRITIQUE** Progress bar height : 8px → 10px + boxShadow : Ajouter inner shadow
10. ✅ Progress bar marginBottom : 12px → 10px
11. ✅ **CRITIQUE** Percentage fontSize : 1.25rem → 0.75rem
12. ✅ Hero background : #eaebec → #e8eaed
13. ✅ Hero borderRadius : 16px → 12px
14. ✅ Hero marginBottom : 16px → 12px
15. ✅ Badge fontSize : 0.75rem → 0.6875rem, letterSpacing : 0.05em → 0.08em
16. ✅ Badge padding : 6px 12px → 4px 10px, borderRadius : 16px → 12px

### BottomNav.tsx (4 modifications)

1. ✅ **CRITIQUE** Nav height : 64px → 72px
2. ✅ **CRITIQUE** Nav background : opaque → rgba(255,255,255,0.85) + backdrop-filter
3. ✅ Nav boxShadow : 0.06 opacity → 0.10 opacity, blur 16px → 20px
4. ✅ Link fontSize : 0.625rem → 0.6875rem
5. ✅ Link color inactive : var(--on-surface-variant) → #5f6368
6. ✅ **CRITIQUE** Link background active : transparent → rgba(102,126,234,0.08)
7. ✅ Link borderRadius : Ajouter 16px
8. ✅ Link padding active : 8px 4px → 8px 12px
9. ✅ Link gap : 2px → 4px

### MobileHeader.tsx (4 modifications)

1. ✅ **CRITIQUE** Header height : 56px → 60px
2. ✅ **CRITIQUE** Header background : opaque → rgba(255,255,255,0.85) + backdrop-filter
3. ✅ Header boxShadow : blur 8px → 12px, opacity 0.06 → 0.08
4. ✅ Header padding : 16px → 20px
5. ✅ Logo fontSize : 1.25rem → 1.375rem

---

## 8. Checklist de Validation Pré-Commit

Avant de committer les modifications, vérifier :

### Visuel
- [ ] Background body est solid `--surface`, pas de gradient ✅
- [ ] Cards ont shadows visibles (pas quasi-invisibles) ✅
- [ ] Progress bar est 10px height avec inner + outer shadow ✅
- [ ] Titre collection 20px, description 13px, percentage 12px ✅
- [ ] Bottom nav + header ont effet glassmorphism (semi-transparent + blur) ✅
- [ ] Active state bottom nav a background pill violet clair ✅

### Responsive
- [ ] Mobile header height 60px, bottom nav 72px ✅
- [ ] Hero image mobile 140px height ✅
- [ ] Card padding mobile ajusté proportionnellement ✅
- [ ] Glassmorphism fonctionne sur mobile ✅

### Cross-browser
- [ ] Glassmorphism backdrop-filter fonctionne Chrome ✅
- [ ] Glassmorphism `-webkit-backdrop-filter` fonctionne Safari ✅
- [ ] Text gradient fonctionne (logo, percentage) ✅
- [ ] Box shadows rendus correctement ✅

### Performance
- [ ] Pas de lag au scroll (backdrop-filter optimisé) ✅
- [ ] Transitions smooth (cubic-bezier) ✅
- [ ] Images Next.js optimisées ✅

### Accessibilité
- [ ] Contraste texte ≥ WCAG AA (4.5:1) ✅
- [ ] Active state nav suffisamment distinct visuellement ✅
- [ ] Touch targets ≥ 44px (bottom nav items) ✅

---

## 9. Notes Techniques Importantes

### Backdrop Filter Support

**Safari** : Nécessite prefix `-webkit-backdrop-filter`

```tsx
backdropFilter: 'blur(16px)',
WebkitBackdropFilter: 'blur(16px)', // OBLIGATOIRE pour Safari
```

**Performance** : `backdrop-filter` peut être coûteux. Si lag détecté au scroll :
- Réduire blur radius de 16px à 12px
- Utiliser `will-change: backdrop-filter` (avec précaution)
- Alternative : Utiliser un pseudo-element avec filter au lieu de backdrop-filter

### Text Gradient Clip

**Edge Case** : Sur certains navigateurs, `backgroundClip: 'text'` peut ne pas fonctionner.

**Fallback** :
```tsx
background: 'linear-gradient(135deg, #667eea 0%, #764ba2 100%)',
backgroundClip: 'text',
WebkitBackgroundClip: 'text',
WebkitTextFillColor: 'transparent',
color: '#667eea', // Fallback si gradient clip ne fonctionne pas
```

### Box Shadow Performance

**Optimization** : Pour éviter repaint coûteux, utiliser `transform` pour animations plutôt que `box-shadow`.

Cards hover : ✅ Utilise `transform: scale(1.02)` + `box-shadow` → Bon compromis.

### Mobile Padding Adjustments

**Math** :
- Bottom nav height : 72px
- Gap below nav : 16px
- Total padding-bottom : 88px

- Header height : 60px
- Padding-top : 60px (pour que contenu commence sous le header)

---

## 10. Variables CSS Complètes (Copy-Paste Ready)

```css
:root {
  /* Surface Colors - Tonal Layering */
  --surface: #f8f9fa;
  --surface-container-lowest: #ffffff;
  --surface-container-low: #e8eaed; /* Ajusté pour ton plus froid */
  --surface-container-high: #e8e9ea;
  --surface-container-highest: #e1e3e4;

  /* Primary Colors */
  --primary: #667eea;
  --primary-container: #764ba2;
  --on-primary: #ffffff;

  /* On Surface Colors */
  --on-surface: #191c1d;
  --on-surface-variant: #43474e;

  /* Typography */
  --font-editorial: 'Manrope', sans-serif;
  --font-utility: 'Inter', sans-serif;

  /* Border Radius */
  --radius-sm: 4px;
  --radius-md: 8px;
  --radius-lg: 16px;
  --radius-xl: 24px;

  /* Spacing */
  --spacing-xs: 4px;
  --spacing-sm: 8px;
  --spacing-md: 12px;
  --spacing-lg: 16px;
  --spacing-xl: 24px;
  --spacing-2xl: 32px;
  --spacing-3xl: 48px;

  /* Shadows - Collection Cards */
  --shadow-card-default: 0 8px 24px rgba(25, 28, 29, 0.08);
  --shadow-card-hover: 0 12px 32px rgba(25, 28, 29, 0.12), 0 4px 16px rgba(25, 28, 29, 0.06);
  
  /* Shadows - Navigation */
  --shadow-nav-bottom: 0 -6px 20px rgba(25, 28, 29, 0.10);
  --shadow-header: 0 2px 12px rgba(25, 28, 29, 0.08);
  
  /* Glassmorphism */
  --glass-background: rgba(255, 255, 255, 0.85);
  --glass-blur: 16px;
  
  /* Active state */
  --nav-active-bg: rgba(102, 126, 234, 0.08);
  
  /* Progress bar effects */
  --progress-inner-shadow: inset 0 1px 2px rgba(0, 0, 0, 0.08);
  --progress-outer-glow: 0 0 12px rgba(102, 126, 234, 0.6);
}
```

---

## Conclusion

Ce document fournit **toutes les valeurs CSS exactes** pour transformer l'implémentation actuelle en une version fidèle à la maquette Variante 1.

**Ordre d'implémentation recommandé** :
1. Phase 1 (Critiques) : globals.css background + CollectionCard shadows/typography + progress bar
2. Phase 2 (Premium) : BottomNav + MobileHeader glassmorphism
3. Phase 3 (Refinements) : Spacing ajustements finaux

**Durée estimée totale** : 3-4 heures

**Résultat attendu** : Score fidélité 95+/100 🎯
