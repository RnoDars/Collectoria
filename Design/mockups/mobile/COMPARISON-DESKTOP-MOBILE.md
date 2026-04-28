# Comparaison Desktop vs Mobile - Collectoria

**Document de référence rapide** pour comprendre les différences d'implémentation.

---

## Vue d'ensemble

| Aspect | Desktop (≥ 768px) | Mobile (< 768px) |
|--------|-------------------|------------------|
| **Navigation principale** | Sidebar verticale gauche | Bottom navigation fixe (64px) |
| **Logo branding** | En haut de sidebar | ❌ Absent (à améliorer) |
| **Layout cards** | Grid 2 colonnes | 1 colonne verticale |
| **Content padding-bottom** | Standard | 80px (éviter overlap bottom nav) |

---

## Navigation

### Desktop : Sidebar Verticale

```
┌─────────────────┬──────────────────────────┐
│  Collectoria    │                          │
│                 │                          │
│  🏠 Home        │      Main Content        │
│  📊 Activity    │                          │
│  🎴 Collections │                          │
│  📥 Import      │                          │
│  ⚙️  Settings   │                          │
│                 │                          │
│                 │                          │
└─────────────────┴──────────────────────────┘
```

**Caractéristiques** :
- Position : Fixed left
- Width : ~240px
- Background : var(--surface-container-lowest)
- Items : Home, Activity, Collections, Import, Settings
- Logo "Collectoria" en haut (branding visible)

---

### Mobile : Bottom Navigation

```
┌──────────────────────────────────────────┐
│                                          │
│          Main Content                    │
│          (scroll vertical)               │
│                                          │
│          [Padding-bottom: 80px]          │
│                                          │
├──────────────────────────────────────────┤
│ 🏠     🎴      📚       🎲               │
│Accueil MECCG Royaumes  D&D 5e            │
└──────────────────────────────────────────┘
```

**Caractéristiques** :
- Position : Fixed bottom
- Height : 64px
- Background : var(--surface-container-lowest)
- Shadow : 0 -4px 16px rgba(25, 28, 29, 0.06) (vers le haut)
- Items : 4 onglets (Accueil, MECCG, Royaumes, D&D 5e)
- **Onglet actif** :
  - Color : #667eea (primary)
  - Background : rgba(102, 126, 234, 0.08)
  - Font-weight : 600
- **Onglet inactif** :
  - Color : #44474a (on-surface-variant)
  - Font-weight : 500

**Code implémenté** : `/frontend/src/components/layout/BottomNav.tsx`

**⚠️ Absence** : Logo "Collectoria" non visible sur mobile (perte de branding)

---

## TopNav (Header)

### Desktop

```
┌─────────────────────────────────────────────────────────┐
│ [Search]  📧 user@email.com  🔔  👤  Se déconnecter    │
└─────────────────────────────────────────────────────────┘
```

**Éléments** :
- Search bar (visible)
- Email complet visible
- Notifications icon
- User icon
- Bouton "Se déconnecter" complet

---

### Mobile

```
┌─────────────────────────────────────────┐
│ [Search]  🔔  👤  Déco                  │  (< 480px)
└─────────────────────────────────────────┘

┌─────────────────────────────────────────┐
│ [Search]  🔔  👤  Se déconnecter        │  (≥ 480px < 640px)
└─────────────────────────────────────────┘
```

**Breakpoints** :
- **< 640px** : Email caché (affiche seulement 👤)
- **< 480px** : Bouton "Se déconnecter" → "Déco"
- Padding réduit : 20px → 16px

---

## Collection Cards

### Desktop Card Structure

```
┌─────────────────────────────────┐
│                                 │
│     [Image Hero - 160px]        │
│                                 │
├─────────────────────────────────┤
│  Middle-earth CCG               │ ← Manrope, 1.5rem, bold
│  (padding: 24px)                │
│  The ultimate collectible...    │ ← Inter, 2 lignes (min-height: 42px)
│                                 │
│  1,234 / 5,400 cards  |  23%    │ ← Métadonnées
│  ▓▓▓▓░░░░░░░░░░░░░░░░           │ ← Progress bar (gradient)
│                                 │
└─────────────────────────────────┘
```

**Dimensions** :
- Background : #ffffff (surface-container-lowest)
- Border-radius : 16px (lg)
- Padding : 24px (content section)
- Image hero : 160px height
- Titre : 1.5rem (24px), Manrope, weight 700
- Description : min-height 42px (2 lignes), Inter
- Spacing entre cards : 24px

---

### Mobile Card Structure

```
┌───────────────────────────┐
│   [Image Hero - 120px]    │ ← Réduit 160px → 120px
├───────────────────────────┤
│ Middle-earth CCG          │ ← Manrope, 1.25rem (réduit)
│ (padding: 16px)           │
│ The ultimate coll...      │ ← 1 ligne (min-height: 21px)
│                           │
│ 1,234 / 5,400  |  23%     │
│ ▓▓▓░░░░░░░░░░░            │
└───────────────────────────┘
```

**Dimensions (< 768px)** :
- Padding : 16px (réduit de 24px)
- Image hero : 120px height (réduit de 160px)
- Titre : 1.25rem (20px) (réduit de 1.5rem)
- Description : min-height 21px (1 ligne, réduit de 42px/2 lignes)
- Spacing entre cards : 16px (réduit de 24px)

**Trade-off** :
- ✅ Gain d'espace vertical → Voir plus de collections
- ⚠️ Moins de "breathing room" (viole légèrement l'Ethos)
- ⚠️ Description tronquée (ellipsis)

---

## Tableau Récapitulatif - Dimensions

| Élément | Desktop | Mobile | Différence |
|---------|---------|--------|------------|
| **Navigation** | Sidebar left | Bottom nav | Pattern différent |
| **Card image hero** | 160px | 120px | -40px (-25%) |
| **Card padding** | 24px | 16px | -8px (-33%) |
| **Card titre size** | 1.5rem (24px) | 1.25rem (20px) | -4px (-17%) |
| **Card description** | 2 lignes (42px) | 1 ligne (21px) | -50% |
| **Spacing entre cards** | 24px | 16px | -8px (-33%) |
| **TopNav email** | Visible | Caché < 640px | N/A |
| **Bouton déconnexion** | "Se déconnecter" | "Déco" < 480px | Abrégé |
| **Logo branding** | Visible (sidebar) | ❌ Absent | À ajouter |

---

## Principes Ethos Conservés sur Mobile

### ✅ Respectés

1. **No-Line Rule** : Aucune bordure 1px solide (desktop + mobile)
2. **Tonal Layering** : Cards blanches (#ffffff) sur background #f8f9fa
3. **Gradient Violet** : #667eea → #764ba2 (progress bars, onglet actif)
4. **Typography Dual-Type** : Manrope (titres) + Inter (body/nav)
5. **Border Radius** : lg (16px) minimum pour cards
6. **Variables CSS** : Utilisation systématique (pas de hardcoded values)

### ⚠️ Adaptations Mobile

1. **Spacing réduit** : De 24px → 16px (trade-off viewport limité)
2. **Description tronquée** : 2 lignes → 1 ligne (ellipsis)
3. **Titre plus petit** : 1.5rem → 1.25rem (économie d'espace)

**Justification** : Viewport mobile limité (375px width typique) nécessite compromis entre "breathing room" (Ethos) et densité d'information.

---

## Responsive Breakpoints

| Breakpoint | Largeur | Changements |
|------------|---------|-------------|
| **Mobile** | < 480px | Bouton "Se déconnecter" → "Déco" |
| **Mobile** | < 640px | Email TopNav caché |
| **Mobile** | < 768px | Sidebar → Bottom Nav, Cards 2 col → 1 col, Dimensions réduites |
| **Desktop** | ≥ 768px | Layout complet, Sidebar visible, Bottom Nav cachée |

---

## Média Queries Implémentées

```css
/* Bottom Navigation */
.bottom-nav-mobile {
  display: none; /* Caché par défaut (desktop) */
}

@media (max-width: 767px) {
  .bottom-nav-mobile {
    display: flex; /* Visible sur mobile */
  }
  
  .sidebar {
    display: none; /* Sidebar cachée sur mobile */
  }
}

/* Collection Cards */
.collection-card {
  .hero-image {
    height: 160px; /* Desktop */
  }
  
  .content {
    padding: 24px; /* Desktop */
  }
  
  .title {
    font-size: 1.5rem; /* Desktop */
  }
  
  .description {
    min-height: 42px; /* 2 lignes */
  }
}

@media (max-width: 767px) {
  .collection-card {
    .hero-image {
      height: 120px; /* Mobile -40px */
    }
    
    .content {
      padding: 16px; /* Mobile -8px */
    }
    
    .title {
      font-size: 1.25rem; /* Mobile -0.25rem */
    }
    
    .description {
      min-height: 21px; /* 1 ligne */
      overflow: hidden;
      text-overflow: ellipsis;
      white-space: nowrap;
    }
  }
}

/* TopNav */
@media (max-width: 639px) {
  .topnav-email {
    display: none; /* Email caché */
  }
}

@media (max-width: 479px) {
  .logout-button {
    content: "Déco"; /* Texte abrégé */
  }
}
```

---

## Fichiers Source Implémentés

| Composant | Fichier | Status |
|-----------|---------|--------|
| Bottom Navigation | `/frontend/src/components/layout/BottomNav.tsx` | ✅ Implémenté |
| Sidebar (Desktop) | `/frontend/src/components/layout/Sidebar.tsx` | ✅ Implémenté |
| TopNav | `/frontend/src/components/layout/TopNav.tsx` | ✅ Implémenté |
| Collection Card | `/frontend/src/components/cards/...` | ✅ Responsive |
| Homepage Layout | `/frontend/src/app/page.tsx` | ✅ Responsive |
| Cards Page | `/frontend/src/app/cards/page.tsx` | ✅ Responsive (référence) |

---

## Recommandations d'Amélioration Mobile

### Priorité Haute

1. **Ajouter logo mobile** :
   - Option A : Mini-header fixe (48px) avec logo "Collectoria" compact
   - Option B : Logo intégré dans bottom nav (onglet central ?)
   - **Impact** : Restaure le branding visuel sur mobile

2. **Accès fonctions secondaires** :
   - Sidebar items (Activity, Import, Settings) moins accessibles
   - Solution : User menu étendu (clic 👤 → dropdown avec tous les items)
   - **Impact** : Restaure accès complet aux fonctionnalités

### Priorité Moyenne

3. **Toggle view density** :
   - Permettre à l'utilisateur de choisir : "Vue compacte" vs "Vue spacieuse"
   - Compacte (actuel) : Image 120px, description 1 ligne
   - Spacieuse : Image 160px, description 2 lignes (plus proche desktop)
   - **Impact** : Respecte mieux l'Ethos "breathing room" pour utilisateurs qui le souhaitent

4. **Gestures navigation** :
   - Swipe left/right sur card → Toggle possession
   - Long press → Quick actions menu
   - Pull to refresh → Actualiser liste
   - **Impact** : UX mobile native, gain de temps

### Priorité Basse

5. **Performance optimizations** :
   - Lazy loading images (Intersection Observer)
   - WebP format pour images
   - Progressive loading (placeholder → low-res → high-res)
   - **Impact** : Temps de chargement réduit sur mobile

---

## Maquettes à Générer

### Maquette 1 : Homepage Mobile (Sans Header)
**Fichier** : `homepage-mobile-v1-2026-04-28.png`

**État actuel implémenté** :
- Pas de header
- Collection cards 1 colonne (image 120px, padding 16px)
- Bottom navigation fixe (4 onglets)

---

### Maquette 2 : Homepage Mobile (Avec Mini-Header)
**Fichier** : `homepage-mobile-with-header-v1-2026-04-28.png`

**Recommandation future** :
- Mini-header 48px avec logo "Collectoria" compact
- Collection cards identiques
- Bottom navigation fixe

---

### Maquette 3 : Page Détail Collection (Optionnel)
**Fichier** : `collection-detail-mobile-v1-2026-04-28.png`

**Nouveau layout** :
- Header page avec bouton retour
- Filter chips (horizontal scroll)
- Liste cartes 2 colonnes (optimiser densité)
- Bottom navigation fixe

---

## Workflow de Validation

```
1. Générer maquettes Stitch
   ↓
2. Validation utilisateur (choix variantes)
   ↓
3. Agent Frontend : Ajustements implémentation
   ↓
4. Agent Design : Validation Ethos (checklist)
   ↓
5. Itérations si nécessaire
   ↓
6. Documentation finale + Screenshots
```

---

**Dernière mise à jour** : 2026-04-28  
**Auteur** : Agent Design  
**Status** : Documentation complète - Prêt pour génération maquettes
