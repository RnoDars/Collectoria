# Changelog Design - Collectoria

Documentation des évolutions du design system et des maquettes au fil du temps.

---

## 2026-04-28 : Mobile Design v1 - Responsive Evolution

**Type** : Documentation + Prompt Stitch  
**Auteur** : Agent Design  
**Impact** : Mobile-first responsive implementation

### Contexte

L'implémentation frontend responsive a introduit des fonctionnalités mobile non présentes dans les maquettes desktop initiales. Ce travail documente ces évolutions et fournit un prompt Stitch pour générer des maquettes mobile inspirationnelles.

### Nouvelles Fonctionnalités Mobile

1. **Bottom Navigation** (< 768px)
   - Navigation fixe en bas (64px height)
   - 4 onglets : Accueil, MECCG, Royaumes, D&D 5e
   - État actif : #667eea avec background rgba(102, 126, 234, 0.08)
   - Shadow vers le haut : 0 -4px 16px rgba(25, 28, 29, 0.06)

2. **Sidebar Desktop Cachée**
   - Disparaît complètement sur mobile
   - Logo "Collectoria" non visible (gap identifié)

3. **Collection Cards Compactes**
   - Image hero : 160px → 120px (-25%)
   - Padding : 24px → 16px (-33%)
   - Titre : 1.5rem → 1.25rem (-17%)
   - Description : 2 lignes → 1 ligne (-50%)

### Fichiers Créés

**Documentation** :
- `/Design/mockups/mobile/mobile-design-v1-2026-04-28.md` (documentation complète)
- `/Design/mockups/mobile/COMPARISON-DESKTOP-MOBILE.md` (tableau comparatif)
- `/Design/mockups/mobile/README.md` (guide rapide)
- `/Design/mockups/mobile/STITCH-PROMPT.txt` (prompt copier/coller)

**Maquettes à générer** :
- `homepage-mobile-v1-2026-04-28.png` (sans header - état actuel)
- `homepage-mobile-with-header-v1-2026-04-28.png` (avec mini-header - recommandation)
- `collection-detail-mobile-v1-2026-04-28.png` (optionnel)

### Principes Ethos Conservés

✅ **Respectés sur mobile** :
- No-Line Rule (pas de bordures 1px)
- Tonal Layering (cards blanches sur #f8f9fa)
- Gradient violet signature (#667eea → #764ba2)
- Typography Dual-Type (Manrope + Inter)
- Border radius lg (16px)

⚠️ **Adaptations nécessaires** :
- Spacing réduit (24px → 16px) pour viewport limité
- Description tronquée (2 lignes → 1 ligne)
- Moins de "breathing room" (trade-off densité vs espace)

### Recommandations Futures

**Priorité Haute** :
1. Ajouter mini-header mobile avec logo "Collectoria" (branding)
2. User menu étendu pour accès fonctions secondaires (Activity, Import, Settings)

**Priorité Moyenne** :
3. Toggle view density (compact/spacious)
4. Gestures navigation (swipe, long press)

**Priorité Basse** :
5. Lazy loading images pour performance mobile

### Références

- Maquette desktop originale : `/Design/mockups/homepage/homepage-desktop-v1-2026-04-15.png`
- Design System : `/Design/design-system/Ethos-V1-2026-04-15.md`
- Implémentation Bottom Nav : `/frontend/src/components/layout/BottomNav.tsx`

---

## 2026-04-23 : Agent Design Creation

**Type** : Infrastructure  
**Auteur** : Agent Amélioration Continue  
**Impact** : Création de l'agent Design pour combler gap de couverture

### Contexte

Audit du 21 avril a identifié un gap : aucun agent responsable du design system et de la validation visuelle.

### Actions

1. **Création `/Design/CLAUDE.md`** : Instructions complètes Agent Design
2. **Responsabilités définies** :
   - Gardien de l'Ethos "The Digital Curator"
   - Validation composants React (checklist)
   - Création maquettes via Stitch
   - Collaboration Frontend/Spécifications

3. **Workflows établis** :
   - Frontend → Design (validation post-implémentation)
   - Design → Stitch (génération maquettes)
   - Design ↔ Spécifications (analyse maquettes)

### Références

- `/Design/CLAUDE.md`
- `/Continuous-Improvement/audits/audit-2026-04-21.md`

---

## 2026-04-15 : Ethos V1 + Maquettes Desktop Initiales

**Type** : Design System + Maquettes  
**Auteur** : User  
**Impact** : Fondation du design system Collectoria

### Design System : "The Digital Curator"

**Creative North Star** : Galerie d'exposition muséale haut de gamme, pas une base de données.

**Principes fondamentaux** :
1. **No-Line Rule** : Aucune bordure 1px solide → Tonal Layering
2. **Tonal Layering** : Surfaces (#f8f9fa, #f3f4f5, #ffffff, #e1e3e4)
3. **Gradient Violet** : #667eea → #764ba2 (avec parcimonie)
4. **Typography Dual-Type** :
   - Manrope (headlines, autorité)
   - Inter (body, utilité)
5. **Spacing Généreux** : Whitespace comme élément de design
6. **Border Radius** : lg (16px) minimum pour cards

### Maquettes Desktop

**Fichier** : `/Design/mockups/homepage/homepage-desktop-v1-2026-04-15.png`

**Éléments** :
- Sidebar verticale gauche avec logo "Collectoria"
- Navigation : Home, Activity, Collections, Import, Settings
- Dashboard Overview : "Total Collection Progress" 68%
- Collection cards grid (2 colonnes) :
  - Image hero 160px
  - Titre (Manrope), métadonnées (Inter)
  - Progress bar (gradient violet)
  - Badge "NEW"
- Sections : Recent Activity, Growth Insight
- CTA : "Add from Excel" (gradient violet)

### Références

- `/Design/design-system/Ethos-V1-2026-04-15.md`
- `/Design/mockups/homepage/homepage-desktop-v1-2026-04-15.png`

---

## Templates pour Futures Entrées

Utiliser ce template pour documenter les évolutions futures :

```markdown
## YYYY-MM-DD : Titre de l'évolution

**Type** : [Maquettes / Design System / Documentation / Infrastructure]  
**Auteur** : [Agent Design / User / Autre]  
**Impact** : [Description courte de l'impact]

### Contexte

[Pourquoi cette évolution ?]

### Actions

[Qu'est-ce qui a été fait ?]

### Fichiers Créés/Modifiés

[Liste des fichiers]

### Références

[Liens vers fichiers pertinents]
```

---

## Conventions de Nommage

### Maquettes

**Format** : `[page]-[device]-v[version]-YYYY-MM-DD.[ext]`

**Exemples** :
- `homepage-desktop-v1-2026-04-15.png`
- `homepage-mobile-v1-2026-04-28.png`
- `cards-detail-mobile-v2-2026-05-10.png`

### Documentation

**Format** : `[type]-[subject]-v[version]-YYYY-MM-DD.md`

**Exemples** :
- `mobile-design-v1-2026-04-28.md`
- `button-component-spec-v1-2026-05-01.md`

### Versions

- **v1** : Version initiale
- **v2** : Révision majeure (changements structurels)
- **v1.1** : Révision mineure (ajustements)

---

## Statistiques

| Date | Maquettes | Docs Design | Composants Validés |
|------|-----------|-------------|-------------------|
| 2026-04-15 | 1 (desktop) | 1 (Ethos V1) | 0 |
| 2026-04-23 | 0 | 1 (Agent Design) | 0 |
| 2026-04-28 | 0 (à générer) | 4 (mobile) | 1 (BottomNav) |
| **Total** | **1** | **6** | **1** |

---

**Dernière mise à jour** : 2026-04-28  
**Maintenu par** : Agent Design
