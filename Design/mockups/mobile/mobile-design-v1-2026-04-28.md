# Mobile Design Evolution - Collectoria v1

**Date de création** : 2026-04-28  
**Statut** : Prompt Stitch prêt - Maquettes à générer  
**Contexte** : Évolution responsive desktop → mobile avec nouvelles fonctionnalités

---

## 1. Contexte : Évolution depuis Desktop vers Responsive

### Maquettes Desktop Initiales (2026-04-15)

**Référence** : `/home/arnaud.dars/git/Collectoria/Design/mockups/homepage/homepage-desktop-v1-2026-04-15.png`

**Éléments présents** :
- Sidebar verticale gauche avec navigation (Home, Activity, Collections, Import, Settings)
- Logo "Collectoria" en haut de sidebar
- TopNav avec search bar, notifications, user menu
- Dashboard Overview avec "Total Collection Progress" (68%)
- Collection cards en grid (2 colonnes) :
  - Image hero haute qualité
  - Titre collection (Manrope headline)
  - Métadonnées : owned/total cards, progression %
  - Badge "NEW"
- Section "Recent Activity" et "Growth Insight"
- Bouton CTA "Add from Excel" (gradient violet)

**Design System observé** :
- Respect de l'Ethos "The Digital Curator"
- No-Line Rule appliquée (pas de bordures)
- Tonal Layering : Cards blanches (#ffffff) sur background #f8f9fa
- Gradient violet signature (#667eea → #764ba2) sur CTAs
- Border radius lg/xl
- Typography Dual-Type : Manrope (titres) + Inter (métadonnées)
- Spacing généreux entre éléments

---

## 2. Implémentation Mobile Actuelle (< 768px)

### Nouvelles Fonctionnalités Ajoutées

L'implémentation responsive a introduit ces éléments **non présents** dans les maquettes desktop initiales :

#### 2.1. Bottom Navigation (< 768px)

**Nouvelle contrainte UI** : Navigation fixe en bas d'écran.

**Spécifications techniques** :
- Position : Fixed bottom, largeur 100%, height 64px
- Background : `var(--surface-container-lowest)` (#ffffff)
- Shadow : `0 -4px 16px rgba(25, 28, 29, 0.06)` (ombre vers le haut)
- Layout : 4 onglets équidistants
- Structure onglet :
  ```
  [Icône (24px)]
     [Label]
  ```
  - Icône au-dessus (emoji ou icon font)
  - Label en dessous (Inter, ~10-11px)
  - Padding : 8px vertical, 12px horizontal

**Onglets** :
1. **Accueil** : Icône maison, label "Accueil"
2. **MECCG** : Icône cartes, label "MECCG"
3. **Royaumes** : Icône livre, label "Royaumes"
4. **D&D 5e** : Icône dé, label "D&D 5e"

**États** :
- **Actif** :
  - Couleur : #667eea (primary)
  - Background : rgba(102, 126, 234, 0.08) (tonal layer subtil)
  - Font weight : 600
- **Inactif** :
  - Couleur : #44474a (on-surface-variant)
  - Background : transparent
  - Font weight : 400

**Implications UX** :
- Content padding-bottom : 80px (éviter chevauchement avec bottom nav)
- Navigation principale cachée (sidebar desktop disparaît)
- Accès rapide aux 4 collections principales

---

#### 2.2. Sidebar Desktop Cachée sur Mobile

**Décision** : La sidebar verticale gauche disparaît complètement sur mobile.

**Conséquences** :
- Logo "Collectoria" n'apparaît plus (pas de header mobile distinct actuellement)
- Navigation déplacée vers bottom navigation (4 items principaux)
- Items secondaires (Activity, Import, Settings) : Accès via menu utilisateur ?

**Point d'attention** : Actuellement, pas de logo/branding visible sur mobile. Recommandation future : Considérer un mini-header avec logo Collectoria en version compacte.

---

#### 2.3. TopNav Adaptatif

**Modifications responsive** :
- Email caché sur < 640px (affiche seulement l'icône user)
- Bouton "Se déconnecter" → "Déco" sur < 480px
- Padding réduit : 20px → 16px sur < 640px
- Search bar : Largeur adaptative

**Conservé** :
- Notifications icon
- User menu

---

#### 2.4. Collection Cards Compactes (< 768px)

**Modifications pour économiser l'espace vertical** :

| Élément | Desktop | Mobile (< 768px) |
|---------|---------|------------------|
| **Image hero** | 160px height | 120px height |
| **Padding** | 24px | 16px |
| **Titre** | 1.5rem (24px) | 1.25rem (20px) |
| **Description min-height** | 42px (2 lignes) | 21px (1 ligne) |
| **Métadonnées spacing** | 12px | 8px |

**Layout mobile** :
- Grid : 1 colonne (au lieu de 2)
- Spacing vertical entre cards : 16px (réduit de 24px)

**Conservé** :
- No-Line Rule (pas de bordures)
- Tonal Layering (cards blanches sur background #f8f9fa)
- Border radius lg (16px)
- Gradient violet sur progress bars

---

## 3. Décisions de Design Mobile

### 3.1. Navigation Pattern : Bottom Nav

**Justification** :
- Standard mobile (iOS/Android)
- Accès rapide aux 4 collections principales (thumb-friendly)
- Libère espace vertical (pas de header lourd)

**Trade-off** :
- Items secondaires moins accessibles (Activity, Import, Settings)
- Solution : Menu hamburger ou user menu étendu

---

### 3.2. Cards Compactes

**Justification** :
- Viewport limité (375px width typique)
- Priorité : Voir plus de collections sans scroll excessif
- Garde l'essentiel : Image, titre, progression

**Trade-off** :
- Description tronquée (1 ligne au lieu de 2)
- Moins de "breathing room" (violates légèrement l'Ethos sur spacing généreux)

**Recommandation future** : Considérer un toggle view "compact/spacious" pour laisser choix à l'utilisateur.

---

### 3.3. Absence de Logo Mobile

**État actuel** : Pas de logo visible sur mobile.

**Implications** :
- Perte de branding visuel
- Moins de sentiment "premium gallery"

**Recommandation** :
- Ajouter mini-header fixe en haut (40-48px height) avec logo Collectoria compact
- OU intégrer logo dans bottom nav (onglet central ?)
- OU splash screen avec logo au démarrage app

---

## 4. Différences Desktop vs Mobile - Tableau Synthèse

| Élément | Desktop | Mobile (< 768px) |
|---------|---------|------------------|
| **Navigation primaire** | Sidebar verticale gauche | Bottom navigation fixe (4 onglets) |
| **Logo** | En haut sidebar | Absent (à ajouter) |
| **TopNav Email** | Visible | Caché sur < 640px |
| **Bouton déconnexion** | "Se déconnecter" | "Déco" sur < 480px |
| **Collection cards grid** | 2 colonnes | 1 colonne |
| **Card image hero** | 160px height | 120px height |
| **Card padding** | 24px | 16px |
| **Card titre** | 1.5rem | 1.25rem |
| **Card description** | 2 lignes (42px) | 1 ligne (21px) |
| **Spacing entre cards** | 24px | 16px |
| **Content padding-bottom** | Standard | 80px (éviter overlap bottom nav) |

---

## 5. Prompt Stitch pour Maquettes Mobile

### 5.1. Contexte Global

Copier/coller ce prompt dans Stitch pour générer les maquettes mobile :

---

**PROMPT STITCH - MOBILE HOMEPAGE COLLECTORIA**

```
Créer une maquette mobile (iPhone format, 375px width × 812px height, portrait) pour la page d'accueil de Collectoria, une application de gestion de collections de jeux (cartes, livres, figurines).

## Design System : "The Digital Curator"

### Creative North Star
Collectoria n'est pas une base de données, c'est une galerie d'exposition muséale haut de gamme. L'objectif est de fournir un sentiment d'**autorité tranquille** à travers :
- Espace de respiration (whitespace généreux, mais adapté mobile)
- Absence de lignes structurelles rigides (No-Line Rule)
- Profondeur tonale (Tonal Layering)
- Typographie haute contraste (Dual-Type)

### Palette de Couleurs

**Surfaces (Tonal Layering)** :
- Background principal : #f8f9fa (surface)
- Cards collection : #ffffff (surface-container-lowest)
- Bottom navigation : #ffffff (surface-container-lowest)
- Shadow bottom nav : 0 -4px 16px rgba(25, 28, 29, 0.06) (vers le haut)

**Primary (Violet signature)** :
- Gradient : #667eea → #764ba2 (angle 135deg)
- Usage : CTAs, progress bars, états actifs bottom nav

**Text** :
- Primary : #191c1d (on-surface)
- Secondary : #44474a (on-surface-variant)
- On primary : #ffffff

### Typography

**Dual-Type System** :
- **Headlines** : Manrope (bold, modern, premium) - Titres de collections
- **Body** : Inter (lisible, utility) - Métadonnées, labels, navigation

**Hierarchy mobile** :
- Titres collections : Manrope, 1.25rem (20px), weight 700
- Métadonnées : Inter, 0.875rem (14px), weight 400
- Labels bottom nav : Inter, 0.6875rem (11px), weight 400/600 (inactif/actif)

### Principes Fondamentaux

1. **No-Line Rule** : Aucune bordure 1px solide. Définir les frontières par changements de fond (Tonal Layering).
2. **Tonal Layering** : Cards blanches (#ffffff) sur background gris clair (#f8f9fa) = "soft lift" architectural.
3. **Border Radius** : lg (16px) minimum pour cards et bottom nav.
4. **Spacing** : Généreux mais adapté mobile (16px padding cards, 16px spacing vertical entre cards).
5. **Gradient** : Avec parcimonie (progress bars, onglet actif bottom nav).

---

## Layout Mobile

### Top Section (si présent)
**Option A : Sans header** (état actuel)
- Page commence directement par les collection cards
- Pas de logo visible

**Option B : Avec mini-header** (recommandation future)
- Height : 48px
- Logo "Collectoria" compact centré ou à gauche
- Background : #ffffff (surface-container-lowest)
- Shadow subtile : 0 2px 8px rgba(25, 28, 29, 0.04)

### Collection Cards Grid

**Layout** :
- 1 colonne verticale
- Spacing entre cards : 16px
- Padding horizontal container : 16px

**Structure d'une card** :
```
┌─────────────────────────────────┐
│  [Image Hero - 120px height]    │ ← Ratio ~16:9, border-radius-top 16px
├─────────────────────────────────┤
│  Titre Collection               │ ← Manrope, 1.25rem, #191c1d
│  1,234 / 5,400 cards  |  23%    │ ← Inter, 0.875rem, #44474a
│  ▓▓▓▓░░░░░░░░░░░░░░░░  NEW      │ ← Progress bar (gradient violet) + badge
└─────────────────────────────────┘
```

**Détails card** :
- Background : #ffffff (surface-container-lowest)
- Border radius : 16px (lg)
- Padding : 16px (sides + bottom), 0 (top - image full-width)
- **Image hero** :
  - Height : 120px
  - Width : 100% (full card width)
  - Border-radius : 16px 16px 0 0 (top corners only)
  - Object-fit : cover
  - Qualité visuelle haute (artwork de cartes/livres)
- **Titre** :
  - Manrope, 1.25rem (20px), weight 700
  - Color : #191c1d
  - Margin-top : 12px
  - Line-height : 1.3
- **Métadonnées** :
  - Inter, 0.875rem (14px), weight 400
  - Color : #44474a
  - Format : "X / Y cards  |  Z%"
  - Margin-top : 8px
- **Progress bar** :
  - Height : 6px
  - Border-radius : 3px
  - Track : #e1e3e4 (surface-container-highest)
  - Indicator : linear-gradient(90deg, #667eea, #764ba2)
  - Inner-glow : 0 0 6px rgba(118, 75, 162, 0.3) (effet énergie liquide)
  - Margin-top : 8px
- **Badge "NEW"** (optionnel) :
  - Position : Top-right de la card, overlay sur image
  - Background : #667eea
  - Color : #ffffff
  - Padding : 4px 8px
  - Border-radius : 12px
  - Font : Inter, 0.75rem, weight 600

**Exemples de collections à afficher** :
1. "Middle-earth CCG" (artwork fantastique sombre)
2. "Doomtrooper" (artwork sci-fi violet)
3. "Advanced Dungeons & Dragons" (artwork fantasy heroic)

### Bottom Navigation (Fixed)

**Position** :
- Fixed bottom
- Width : 100%
- Height : 64px
- Background : #ffffff (surface-container-lowest)
- Shadow : 0 -4px 16px rgba(25, 28, 29, 0.06) (vers le haut)
- Border-top : none (No-Line Rule)

**Layout** :
- 4 onglets équidistants (flex, space-around)
- Padding vertical : 8px
- Padding horizontal par onglet : 12px

**Structure onglet** :
```
  [Icône 24px]
     [Label]
```

**Onglets** :
1. **Accueil** (Actif) :
   - Icône : Maison (emoji 🏠 ou icon similaire)
   - Label : "Accueil"
   - Color : #667eea (primary)
   - Background : rgba(102, 126, 234, 0.08) (tonal layer subtil, border-radius 12px)
   - Font : Inter, 0.6875rem (11px), weight 600

2. **MECCG** (Inactif) :
   - Icône : Cartes (emoji 🎴 ou icon similaire)
   - Label : "MECCG"
   - Color : #44474a (on-surface-variant)
   - Background : transparent
   - Font : Inter, 0.6875rem (11px), weight 400

3. **Royaumes** (Inactif) :
   - Icône : Livre (emoji 📚 ou icon similaire)
   - Label : "Royaumes"
   - Color : #44474a
   - Background : transparent
   - Font : Inter, 0.6875rem (11px), weight 400

4. **D&D 5e** (Inactif) :
   - Icône : Dé (emoji 🎲 ou icon similaire)
   - Label : "D&D 5e"
   - Color : #44474a
   - Background : transparent
   - Font : Inter, 0.6875rem (11px), weight 400

**Padding content** :
- Le contenu principal (cards) doit avoir un padding-bottom de 80px pour éviter chevauchement avec bottom nav.

---

## Style et Ambiance

**Mood** : Galerie d'art contemporaine, sophistiquée, premium, tranquille.

**Imagery** : Les images des collection cards doivent évoquer :
- Qualité musée
- Artwork haute résolution
- Couleurs riches (fantasy, sci-fi)
- Détails visibles

**Whitespace** : Généreux mais adapté mobile. Éviter surcharge. Si ça ne rentre pas avec breathing room, simplifier.

**Pas de** :
- Bordures 1px solides
- Noir pur (#000000)
- Drop shadows standards (utiliser tonal layering)
- Overcrowding

---

## Variantes à Générer (Optionnel)

Si Stitch permet plusieurs versions, générer :

1. **Variante A** : Sans header (état actuel) - Page commence par cards
2. **Variante B** : Avec mini-header (48px) incluant logo "Collectoria" compact

---

## Format de Sortie

- **Résolution** : 375px × 812px (iPhone portrait standard)
- **Format** : PNG haute résolution (2x ou 3x pour netteté Retina)
- **Annotations** (si possible) : Indiquer spacing clés (16px padding, 64px bottom nav height)

---

**Références visuelles** :
- Maquette desktop existante : `/home/arnaud.dars/git/Collectoria/Design/mockups/homepage/homepage-desktop-v1-2026-04-15.png`
- Design System complet : `/home/arnaud.dars/git/Collectoria/Design/design-system/Ethos-V1-2026-04-15.md`

**Note finale** : Laisser la collection de l'utilisateur fournir les couleurs (images riches). Notre UI fournit le cadre élégant et discret.
```

---

### 5.2. Prompt Stitch pour Page Détail Collection (Optionnel)

Si besoin de maquette pour page détail d'une collection (ex: liste de cartes dans MECCG) :

```
Créer une maquette mobile (iPhone format, 375px × 812px) pour la page de détail de la collection "Middle-earth CCG" dans Collectoria.

## Design System : "The Digital Curator" (identique prompt précédent)

[Reprendre sections Couleurs, Typography, Principes]

## Layout Mobile Détail Collection

### Header Page

**Height** : 56px (fixed top)
**Background** : #ffffff (surface-container-lowest)
**Shadow** : 0 2px 8px rgba(25, 28, 29, 0.04)

**Contenu** :
- Bouton retour (←) à gauche : Icône 24px, color #667eea
- Titre collection : "Middle-earth CCG" (Manrope, 1.125rem, weight 700, centré ou après bouton)
- Bouton menu (⋮) à droite : Icône 24px, color #44474a

### Filter Chips (Horizontal Scroll)

**Position** : Sous header, sticky
**Background** : #f8f9fa (surface)
**Padding** : 12px horizontal

**Chips** :
- Background inactif : #ffffff (surface-container-lowest)
- Background actif : rgba(102, 126, 234, 0.12) (glassmorphism subtil)
- Border : none (No-Line Rule)
- Border-radius : 20px (pill)
- Padding : 8px 16px
- Font : Inter, 0.875rem, weight 500
- Color inactif : #44474a
- Color actif : #667eea

**Exemples** : "Toutes", "Possédées", "Manquantes", "Rares", "Par série"

### Liste de Cartes (Scroll Vertical)

**Layout** : 2 colonnes grid (optimiser espace)
**Gap** : 12px (horizontal + vertical)
**Padding container** : 16px

**Structure d'une card miniature** :
```
┌──────────────┐
│  [Image]     │ ← Ratio carte standard (63:88), height ~180px
│              │
│  Nom Carte   │ ← Manrope, 0.875rem, 1 ligne, ellipsis
│  #123  ✓     │ ← Inter, 0.75rem, numéro + check si possédée
└──────────────┘
```

**Détails card** :
- Background : #ffffff
- Border-radius : 12px
- Padding : 0 (image full-width) + 8px bottom
- Shadow : none (tonal layering via background shift)
- **Image** :
  - Height : ~180px (ajuster selon ratio carte)
  - Border-radius : 12px 12px 0 0
  - Object-fit : cover
- **Nom** :
  - Manrope, 0.875rem, weight 600
  - 1 ligne max, text-overflow: ellipsis
  - Padding : 8px horizontal
- **Métadonnées** :
  - Inter, 0.75rem, weight 400
  - Format : "#123  ✓" (numéro + check si possédée)
  - Check : Color #667eea si possédée, sinon gris

### Bottom Navigation (identique homepage)

[Reprendre section Bottom Navigation du prompt précédent]

---

**Note** : Cette page détail utilise un layout 2 colonnes pour cartes afin de maximiser densité visuelle tout en restant lisible.
```

---

## 6. Recommandations pour Améliorer l'Expérience Mobile

### 6.1. Branding Mobile

**Problème** : Absence de logo "Collectoria" sur mobile.

**Solutions** :
- **Option A** : Mini-header fixe (48px) avec logo compact en haut
- **Option B** : Logo intégré dans bottom nav (onglet central "Home" avec logo au lieu d'icône ?)
- **Option C** : Splash screen au démarrage avec logo + gradient violet

**Recommandation** : Option A (mini-header) pour maintenir brand visibility constante.

---

### 6.2. Accès aux Fonctions Secondaires

**Problème** : Items sidebar desktop (Activity, Import, Settings) moins accessibles sur mobile.

**Solutions** :
- **Menu hamburger** : Icon burger en mini-header → drawer latéral avec tous les items
- **User menu étendu** : Clic sur user icon → dropdown avec Activity, Import, Settings, Se déconnecter
- **Onglet "Plus"** : Remplacer un des 4 onglets bottom nav par "Plus" (grid d'actions)

**Recommandation** : User menu étendu (simple, standard mobile).

---

### 6.3. Toggle View Density

**Problème** : Cards compactes violent légèrement l'Ethos (moins de breathing room).

**Solution** :
- Toggle dans mini-header ou settings : "Vue compacte" vs "Vue spacieuse"
- **Compacte** : Image 120px, description 1 ligne (état actuel)
- **Spacieuse** : Image 160px, description 2 lignes (plus proche desktop)

**Recommandation** : Implémenter en phase 2 (user preference).

---

### 6.4. Gesture Navigation

**Opportunité** : Enrichir UX mobile avec gestures.

**Exemples** :
- **Swipe left/right sur card** : Marquer comme possédée/non possédée
- **Long press sur card** : Quick actions (Voir détails, Partager, Supprimer)
- **Pull to refresh** : Actualiser liste collections

**Recommandation** : Swipe sur card pour toggle possession (gain de temps).

---

### 6.5. Performance Mobile

**Attention** : Images haute qualité (hero 120px height) peuvent peser lourd.

**Best Practices** :
- Lazy loading pour cards hors viewport
- Image optimization (WebP, compression adaptative)
- Progressive loading (placeholder → low-res → high-res)
- Intersection Observer API pour détecter visibility

**Recommandation** : Implémenter lazy loading dès phase 1.

---

## 7. Prochaines Étapes

### Phase 1 : Maquettes Mobile
1. **Générer maquettes avec Stitch** :
   - Homepage mobile (avec/sans mini-header)
   - Page détail collection (optionnel)
2. **Valider avec utilisateur** : Choix entre variantes
3. **Versionner maquettes** : Sauvegarder dans `/Design/mockups/mobile/homepage-mobile-v1-2026-04-28.png`

### Phase 2 : Implémentation Frontend
1. **Agent Frontend** : Ajuster layout responsive selon maquettes validées
2. **Agent Design** : Valider implémentation (checklist Ethos)
3. **Itérations** : Corrections si nécessaire

### Phase 3 : Enrichissements UX
1. Mini-header avec logo (si validé)
2. User menu étendu (accès fonctions secondaires)
3. Gestures navigation (swipe, long press)
4. Toggle view density (compact/spacious)

---

## 8. Ressources Complémentaires

**Design System** :
- `/home/arnaud.dars/git/Collectoria/Design/design-system/Ethos-V1-2026-04-15.md`

**Maquettes Desktop** :
- `/home/arnaud.dars/git/Collectoria/Design/mockups/homepage/homepage-desktop-v1-2026-04-15.png`

**Agent Design Instructions** :
- `/home/arnaud.dars/git/Collectoria/Design/CLAUDE.md`

**Checklist Validation Composant** :
- Voir section "Checklist de Validation Composant" dans `/Design/CLAUDE.md`

---

## 9. Notes Techniques pour Agent Frontend

Lors de l'implémentation mobile :

### 9.1. Media Queries

```tsx
// Breakpoints Collectoria
const breakpoints = {
  mobile: '< 768px',
  tablet: '768px - 1024px',
  desktop: '> 1024px'
}

// Bottom Nav visible uniquement sur mobile
@media (max-width: 767px) {
  .bottom-navigation {
    display: flex; // visible
  }
  .sidebar {
    display: none; // cachée
  }
}

@media (min-width: 768px) {
  .bottom-navigation {
    display: none; // cachée
  }
  .sidebar {
    display: flex; // visible
  }
}
```

### 9.2. Collection Card Responsive

```tsx
// Collection Card Component
.collection-card {
  background: var(--surface-container-lowest);
  border-radius: 16px; // lg
  overflow: hidden; // pour border-radius image
  
  .hero-image {
    width: 100%;
    height: 160px; // desktop
    object-fit: cover;
    
    @media (max-width: 767px) {
      height: 120px; // mobile
    }
  }
  
  .content {
    padding: 24px; // desktop
    
    @media (max-width: 767px) {
      padding: 16px; // mobile
    }
  }
  
  .title {
    font-family: 'Manrope', sans-serif;
    font-size: 1.5rem; // desktop
    font-weight: 700;
    
    @media (max-width: 767px) {
      font-size: 1.25rem; // mobile
    }
  }
  
  .description {
    font-family: 'Inter', sans-serif;
    font-size: 0.875rem;
    min-height: 42px; // 2 lignes desktop
    
    @media (max-width: 767px) {
      min-height: 21px; // 1 ligne mobile
      overflow: hidden;
      text-overflow: ellipsis;
      white-space: nowrap;
    }
  }
}
```

### 9.3. Bottom Navigation Component

```tsx
// BottomNavigation.tsx
const BottomNavigation = () => {
  const [activeTab, setActiveTab] = useState('home')
  
  return (
    <nav className="bottom-navigation">
      {tabs.map(tab => (
        <button
          key={tab.id}
          className={`tab ${activeTab === tab.id ? 'active' : ''}`}
          onClick={() => setActiveTab(tab.id)}
        >
          <span className="icon">{tab.icon}</span>
          <span className="label">{tab.label}</span>
        </button>
      ))}
    </nav>
  )
}

// Styles
.bottom-navigation {
  position: fixed;
  bottom: 0;
  left: 0;
  right: 0;
  height: 64px;
  background: var(--surface-container-lowest);
  box-shadow: 0 -4px 16px rgba(25, 28, 29, 0.06);
  display: flex;
  justify-content: space-around;
  align-items: center;
  padding: 8px 0;
  z-index: 1000;
  
  @media (min-width: 768px) {
    display: none; // cachée sur desktop
  }
  
  .tab {
    display: flex;
    flex-direction: column;
    align-items: center;
    gap: 4px;
    padding: 4px 12px;
    background: transparent;
    border: none;
    cursor: pointer;
    transition: all 0.2s ease;
    
    .icon {
      font-size: 24px;
      color: var(--on-surface-variant);
    }
    
    .label {
      font-family: 'Inter', sans-serif;
      font-size: 0.6875rem;
      font-weight: 400;
      color: var(--on-surface-variant);
    }
    
    &.active {
      background: rgba(102, 126, 234, 0.08);
      border-radius: 12px;
      
      .icon, .label {
        color: var(--primary);
      }
      
      .label {
        font-weight: 600;
      }
    }
  }
}
```

### 9.4. Content Padding Bottom

```tsx
// Page Layout
.page-content {
  padding-bottom: 0; // desktop
  
  @media (max-width: 767px) {
    padding-bottom: 80px; // éviter chevauchement bottom nav (64px + 16px marge)
  }
}
```

---

## 10. Changelog Design Mobile

| Date | Version | Changements |
|------|---------|-------------|
| 2026-04-28 | v1 | Prompt Stitch initial + Documentation évolutions mobile |

---

**Document créé par** : Agent Design  
**Approuvé par** : [En attente validation utilisateur]  
**Statut** : Prêt pour génération maquettes Stitch

---

**Note Finale** : Cette documentation capture l'état actuel de l'implémentation mobile et fournit un prompt Stitch détaillé pour générer les maquettes inspirationnelles. Les maquettes générées serviront de référence visuelle pour valider et affiner l'implémentation responsive du Frontend.
