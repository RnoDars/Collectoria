# Spécification Technique : Gestion des Traductions sur la Page D&D 5e

**Date** : 2026-04-27  
**Auteur** : Agent Spécifications  
**Version** : 1.1  
**Statut** : Ready for Implementation

---

## 1. Vue d'ensemble

### 1.1 Résumé du besoin

La page `/dnd5` affiche actuellement 53 livres D&D 5e avec des noms en anglais et français (quand disponible). Cette spec couvre 5 améliorations pour une meilleure gestion des traductions et de l'affichage.

**Problèmes identifiés** :
1. Les livres non traduits (`name_fr = null`) affichent un espace vide pour le nom français
2. Le toggle "Version FR" reste visible même si le livre n'existe pas en français
3. Aucun filtre par langue disponible
4. L'ordre d'affichage des noms (FR/EN) est fixe
5. Badge "Non traduit" redondant avec les types d'ouvrage
6. Pas de carte D&D 5e sur la homepage (contrairement à MECCG et Royaumes Oubliés)

### 1.2 Objectifs

1. **Affichage conditionnel** : Masquer les éléments FR pour les livres non traduits
2. **Switch langue** : Permettre à l'utilisateur de choisir FR ou EN comme langue principale
3. **Filtrage intelligent** : En mode FR, masquer les livres non traduits
4. **Simplification badges** : Retirer le badge "Non traduit" des chips de types
5. **Visibilité homepage** : Ajouter une carte collection D&D 5e sur la homepage
6. **Cohérence UI** : Aligner le comportement avec la page `/cards` (référence)

### 1.3 Référence existante

La page `/cards` implémente déjà un système similaire :
- Switch FR/EN dans les filtres
- Ordre d'affichage dynamique basé sur `sortBy`
- Pas de filtrage par traduction (toutes les cartes ont name_fr)

---

## 2. Comportements attendus

### 2.1 Affichage des noms

#### Cas 1 : Livre traduit (`name_fr !== null`)

**Mode Français activé** :
```
┌─────────────────────────────────┐
│ #PHB                            │
│ Le Manuel du Joueur             │ ← name_fr (grand, bold)
│ Player's Handbook               │ ← name_en (petit, italic)
│ [Core Rules]                    │
│ [Toggle FR] [Toggle EN]         │
└─────────────────────────────────┘
```

**Mode Anglais activé** :
```
┌─────────────────────────────────┐
│ #PHB                            │
│ Player's Handbook               │ ← name_en (grand, bold)
│ Le Manuel du Joueur             │ ← name_fr (petit, italic)
│ [Core Rules]                    │
│ [Toggle FR] [Toggle EN]         │
└─────────────────────────────────┘
```

#### Cas 2 : Livre non traduit (`name_fr === null`)

**Mode Français activé** :
```
LIVRE NON AFFICHÉ (filtré)
```

**Mode Anglais activé** :
```
┌─────────────────────────────────┐
│ #SCAG                           │
│ Sword Coast Adventurer's Guide  │ ← name_en (grand, bold)
│ [Setting]                       │
│ [Toggle EN]                     │ ← UN SEUL toggle
└─────────────────────────────────┘
```

### 2.2 Toggles de possession

| Traduction | Mode FR | Mode EN |
|------------|---------|---------|
| `name_fr` présent | Toggle FR + Toggle EN | Toggle EN + Toggle FR |
| `name_fr` null | Livre filtré | Toggle EN uniquement |

**Règle** : Le toggle FR n'apparaît QUE si `name_fr !== null`

### 2.3 Switch langue

**Position** : Dans la barre de filtres, après le filtre "Type d'ouvrage"

**Design** :
```
┌─────────────────────────────────────────────────────────┐
│ [Recherche...] [Type ▼] [🇫🇷 Français] [🇬🇧 Anglais]    │
└─────────────────────────────────────────────────────────┘
```

**Comportement** :
- Toggle group (un seul sélectionné à la fois)
- Par défaut : Français
- Change l'ordre d'affichage + applique le filtrage

### 2.4 Filtrage

| Mode | Comportement |
|------|--------------|
| **Français** | Exclure les livres avec `name_fr === null` |
| **Anglais** | Afficher TOUS les livres |

**Exemple** :
- Total 53 livres D&D 5e
- ~15 livres non traduits (`name_fr === null`)
- Mode FR → Affiche ~38 livres
- Mode EN → Affiche 53 livres

### 2.5 Badge "Non traduit" (À SUPPRIMER)

**Avant** :
```
[Core Rules] [Non traduit]
```

**Après** :
```
[Core Rules]
```

**Raison** : L'information est redondante car :
1. En mode FR, les livres non traduits sont filtrés (pas affichés)
2. En mode EN, l'absence du nom français suffit comme indicateur
3. Simplifie l'UI

### 2.6 Carte Homepage D&D 5e (À AJOUTER)

**Position** : Après la carte "Royaumes oubliés" sur `/`

**Design** : Similaire aux cartes existantes MECCG et Royaumes Oubliés

```tsx
<Link href="/dnd5">
  <CollectionCard
    title="D&D 5e"
    description="Livres officiels Dungeons & Dragons 5e"
    icon="🎲"
    stats={{
      total: 53,
      owned: ownedCount
    }}
  />
</Link>
```

---

## 3. Modifications techniques

### 3.1 Frontend

#### 3.1.1 `/app/dnd5/page.tsx`

**Nouveau state** :
```typescript
const [language, setLanguage] = useState<'fr' | 'en'>('fr')
```

**Switch langue dans les filtres** :
```tsx
<div style={toggleGroupStyle} role="group" aria-label="Langue">
  <button
    onClick={() => setLanguage('fr')}
    style={toggleBtnStyle(language === 'fr')}
    aria-pressed={language === 'fr'}
  >
    🇫🇷 Français
  </button>
  <button
    onClick={() => setLanguage('en')}
    style={toggleBtnStyle(language === 'en')}
    aria-pressed={language === 'en'}
  >
    🇬🇧 Anglais
  </button>
</div>
```

**Filtrage client-side** :
```typescript
// Après avoir récupéré les livres
let filteredBooks = data?.books ?? []

// Filtre par langue (si mode FR, exclure les non traduits)
if (language === 'fr') {
  filteredBooks = filteredBooks.filter(book => book.nameFr !== null)
}

// Autres filtres (search, bookType, etc.)
// ...
```

**Passage de la prop language** :
```tsx
<DnD5BookCard
  key={book.id}
  book={book}
  language={language}  // NEW
  onToggleFr={handleToggleFr}
  onToggleEn={handleToggleEn}
  isTogglingId={togglingBookId}
/>
```

#### 3.1.2 `/components/books/DnD5BookCard.tsx`

**Interface modifiée** :
```typescript
interface DnD5BookCardProps {
  book: DnD5Book
  language: 'fr' | 'en'  // NEW
  onToggleFr: (book: DnD5Book) => void
  onToggleEn: (book: DnD5Book) => void
  isTogglingId?: string
}
```

**Affichage des noms conditionnel** :
```tsx
// Déterminer quel nom afficher en premier
const primaryName = language === 'fr' 
  ? (book.nameFr || book.nameEn)  // FR mode: FR d'abord, sinon EN
  : book.nameEn                    // EN mode: EN toujours

const secondaryName = language === 'fr'
  ? (book.nameFr ? book.nameEn : null)  // FR mode: EN en second si FR existe
  : book.nameFr                          // EN mode: FR en second si existe

return (
  <div style={cardStyle}>
    {/* Primary name */}
    <div style={titlePrimaryStyle}>{primaryName}</div>
    
    {/* Secondary name (si différent) */}
    {secondaryName && secondaryName !== primaryName && (
      <div style={titleSecondaryStyle}>{secondaryName}</div>
    )}
    
    {/* Badges (SANS "Non traduit") */}
    <div style={badgesStyle}>
      <span style={badgeStyle}>{book.bookType}</span>
    </div>
    
    {/* Toggles conditionnels */}
    <div style={toggleSectionStyle}>
      {/* FR toggle: SEULEMENT si traduit */}
      {book.nameFr && (
        <button onClick={() => onToggleFr(book)}>
          {book.ownedFr ? '✓' : '○'} Version FR
        </button>
      )}
      
      {/* EN toggle: TOUJOURS affiché */}
      <button onClick={() => onToggleEn(book)}>
        {book.ownedEn ? '✓' : '○'} Version EN
      </button>
    </div>
  </div>
)
```

**Suppression du badge "Non traduit"** :
```tsx
// AVANT
{!book.nameFr && <span style={badgeUntranslatedStyle}>Non traduit</span>}

// APRÈS
// (supprimé complètement)
```

#### 3.1.3 `/app/page.tsx` (Homepage)

**Ajout de la carte D&D 5e** :

```tsx
// Après la carte Royaumes Oubliés
<Link href="/dnd5" style={cardLinkStyle}>
  <div style={cardStyle}>
    <div style={iconStyle}>🎲</div>
    <h2 style={titleStyle}>D&D 5e</h2>
    <p style={descStyle}>Livres officiels Dungeons & Dragons 5e</p>
    <div style={statsStyle}>
      <span>53 livres</span>
      <span>•</span>
      <span>{dnd5Owned} possédés</span>
    </div>
  </div>
</Link>
```

**Fetch des stats D&D 5e** :
```typescript
const { data: dnd5Data } = useDnD5Books({ limit: 1 })
const dnd5Owned = dnd5Data?.books.filter(b => b.ownedFr || b.ownedEn).length || 0
```

### 3.2 Backend

**Aucune modification nécessaire**

Le filtrage par traduction est fait côté client (53 livres, pas de problème de performance).

---

## 4. Plan d'implémentation

### Phase 1 : Analyse de référence (15 min)
1. Lire `/cards/page.tsx` pour comprendre le pattern du switch langue
2. Identifier les styles et composants réutilisables

### Phase 2 : DnD5BookCard - Affichage conditionnel (30 min)
1. Ajouter la prop `language: 'fr' | 'en'`
2. Implémenter l'affichage conditionnel des noms (primaryName / secondaryName)
3. Rendre le toggle FR conditionnel (`{book.nameFr && ...}`)
4. **Supprimer** le badge "Non traduit"
5. Tester avec un livre traduit + un livre non traduit

### Phase 3 : Page dnd5 - Switch langue (30 min)
1. Ajouter `useState<'fr' | 'en'>('fr')`
2. Créer le toggle group FR/EN dans les filtres
3. Passer la prop `language` à `DnD5BookCard`
4. Tester le switch entre FR et EN

### Phase 4 : Filtrage par langue (15 min)
1. Implémenter le filtre client-side : `if (language === 'fr') filter(b => b.nameFr !== null)`
2. Mettre à jour les stats affichées (nombre de livres)
3. Tester le filtrage en mode FR (doit exclure ~15 livres)

### Phase 5 : Homepage - Carte D&D 5e (20 min)
1. Ajouter `useDnD5Books({ limit: 1 })` pour fetch les stats
2. Créer la carte D&D 5e après Royaumes Oubliés
3. Calculer le nombre de livres possédés
4. Tester la navigation vers `/dnd5`

### Phase 6 : Tests manuels complets (20 min)
1. Vérifier les 4 cas d'usage (traduit FR/EN, non traduit FR/EN)
2. Vérifier les toggles conditionnels
3. Vérifier le filtrage
4. Vérifier la carte homepage
5. Vérifier l'absence du badge "Non traduit"

**Durée totale estimée** : ~2h

---

## 5. Exemples visuels

### Exemple 1 : Livre traduit, mode FR
```
┌──────────────────────────────────────┐
│ #PHB                                 │
│                                      │
│ Le Manuel du Joueur              📘 │ ← name_fr (18px, bold)
│ Player's Handbook                    │ ← name_en (14px, italic, gris)
│                                      │
│ [Core Rules]                         │ ← Badge type (PAS de "Non traduit")
│                                      │
│ [✓ Version FR]  [○ Version EN]      │ ← 2 toggles
└──────────────────────────────────────┘
```

### Exemple 2 : Livre traduit, mode EN
```
┌──────────────────────────────────────┐
│ #PHB                                 │
│                                      │
│ Player's Handbook                📘 │ ← name_en (18px, bold)
│ Le Manuel du Joueur                  │ ← name_fr (14px, italic, gris)
│                                      │
│ [Core Rules]                         │
│                                      │
│ [○ Version EN]  [✓ Version FR]      │ ← 2 toggles (ordre inversé)
└──────────────────────────────────────┘
```

### Exemple 3 : Livre non traduit, mode FR
```
LIVRE FILTRÉ - NON AFFICHÉ
```

### Exemple 4 : Livre non traduit, mode EN
```
┌──────────────────────────────────────┐
│ #SCAG                                │
│                                      │
│ Sword Coast Adventurer's Guide   📘 │ ← name_en uniquement (18px, bold)
│                                      │
│ [Setting]                            │ ← Badge type uniquement
│                                      │
│ [○ Version EN]                       │ ← 1 seul toggle
└──────────────────────────────────────┘
```

### Exemple 5 : Homepage avec carte D&D 5e
```
┌─────────────────────────────────────────────┐
│                 HOMEPAGE                    │
│                                             │
│  ┌─────────────┐  ┌─────────────┐         │
│  │ 🃏 MECCG    │  │ 📚 Royaumes │         │
│  │ 547 cartes  │  │ 94 livres   │         │
│  └─────────────┘  └─────────────┘         │
│                                             │
│  ┌─────────────┐                           │
│  │ 🎲 D&D 5e   │  ← NOUVELLE CARTE         │
│  │ 53 livres   │                           │
│  └─────────────┘                           │
└─────────────────────────────────────────────┘
```

---

## 6. Edge cases

### 6.1 Tous les livres filtrés en mode FR
**Scénario** : Si tous les livres étaient non traduits (impossible ici, mais anticipons)

**Comportement** :
```
Aucun livre trouvé
Essayez de passer en mode Anglais pour voir tous les livres.
```

### 6.2 Switch langue pendant un toggle en cours
**Scénario** : L'utilisateur change de langue pendant qu'un toggle est en cours (isToggling)

**Comportement** : Le toggle continue normalement, la carte se met à jour avec le nouveau mode langue une fois terminé.

### 6.3 Livre avec name_fr vide ("") vs null
**Scénario** : Distinction entre `null` et `""`

**Règle** : On filtre sur `name_fr === null` uniquement. Si `name_fr === ""`, on le traite comme non traduit également.

**Code** :
```typescript
if (language === 'fr') {
  filteredBooks = filteredBooks.filter(book => book.nameFr)  // truthy check
}
```

### 6.4 Homepage sans données D&D 5e chargées
**Scénario** : L'API D&D 5e est en erreur ou ne répond pas

**Comportement** :
```tsx
<div style={statsStyle}>
  <span>53 livres</span>
  {dnd5Owned !== undefined && (
    <>
      <span>•</span>
      <span>{dnd5Owned} possédés</span>
    </>
  )}
</div>
```

---

## 7. Non-scope (Hors périmètre)

### 7.1 Tri alphabétique FR/EN
Le tri alphabétique par nom (FR ou EN) n'est PAS inclus dans cette spec. Il sera traité séparément.

### 7.2 Persistance du mode langue
Le choix de langue (FR/EN) n'est PAS persisté dans l'URL ou le localStorage. Il revient à "FR" à chaque chargement de page.

**Raison** : Simplifier l'implémentation initiale. Peut être ajouté plus tard.

### 7.3 Backend modifications
Aucune modification backend n'est nécessaire. Le filtrage se fait entièrement côté client.

### 7.4 Filtres de possession
Les filtres de possession (possédé FR/EN) restent inchangés pour cette version.

---

## 8. Checklist de validation

### Affichage des noms
- [ ] Livre traduit + mode FR → name_fr en premier
- [ ] Livre traduit + mode EN → name_en en premier
- [ ] Livre non traduit + mode FR → Livre filtré (non affiché)
- [ ] Livre non traduit + mode EN → name_en uniquement affiché

### Toggles
- [ ] Livre traduit → 2 toggles (FR + EN)
- [ ] Livre non traduit → 1 toggle (EN uniquement)
- [ ] Toggle FR fonctionne correctement quand cliqué
- [ ] Toggle EN fonctionne correctement quand cliqué

### Switch langue
- [ ] Switch FR/EN visible dans les filtres
- [ ] Par défaut sur "Français"
- [ ] Changement de FR → EN met à jour l'affichage
- [ ] Changement de EN → FR applique le filtrage

### Filtrage
- [ ] Mode FR filtre les livres avec name_fr === null
- [ ] Mode EN affiche tous les livres
- [ ] Compteur "X livres affichés" est correct

### Badges
- [ ] Badge "Non traduit" supprimé
- [ ] Seul le badge de type (Core Rules, Setting, etc.) est affiché

### Homepage
- [ ] Carte D&D 5e visible après Royaumes Oubliés
- [ ] Stats correctes (53 livres, X possédés)
- [ ] Clic sur la carte navigue vers `/dnd5`
- [ ] Design cohérent avec les autres cartes

### Général
- [ ] Aucune erreur console
- [ ] Performance acceptable (53 livres filtrés en < 100ms)
- [ ] Responsive (mobile + desktop)

---

## 9. Révisions

| Version | Date | Auteur | Changements |
|---------|------|--------|-------------|
| 1.0 | 2026-04-27 | Agent Spécifications | Création initiale (#2, #3, #4) |
| 1.1 | 2026-04-27 | Agent Spécifications | Ajout #5 (badge "Non traduit") et #6 (carte homepage) |

---

**Prêt pour implémentation** ✅
