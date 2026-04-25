# Tri alphabétique — Page /cards

**Version** : 1.0  
**Date** : 2026-04-25  
**Statut** : Prêt à implémenter  
**Bounded Context** : Collection Management  
**Microservice** : `backend/collection-management`

---

## Résumé

Ajouter deux contrôles de tri alphabétique dans la barre de filtres de la page `/cards`. Le tri est effectué côté serveur (obligatoire, scroll infini). Par défaut : nom français, ordre croissant. Aucune persistance entre sessions.

---

## User Story

En tant que collectionneur, je veux trier les cartes par nom français ou anglais, en ordre croissant ou décroissant, afin de retrouver facilement une carte en naviguant alphabétiquement dans ma collection.

---

## Comportement attendu

### État par défaut

À l'ouverture de `/cards` : **FR A→Z** (colonne `name_fr`, ordre `ASC`).  
Réinitialisé à chaque nouvelle session (pas de persistance `localStorage`).

### Contrôles UI

Deux `toggleGroup` indépendants ajoutés dans la `filtersBarStyle` existante :

**Toggle 1 — Langue de tri** :
| État | Valeur | Comportement |
|------|--------|--------------|
| FR (défaut) | `name_fr` | Trie par `name_fr`, affiche nom FR en gras |
| EN | `name_en` | Trie par `name_en`, affiche nom EN en gras |

**Toggle 2 — Ordre de tri** :
| État | Valeur | Comportement |
|------|--------|--------------|
| A→Z (défaut) | `asc` | Ordre croissant |
| Z→A | `desc` | Ordre décroissant |

Les deux toggles sont indépendants : toutes les combinaisons (FR+Z→A, EN+A→Z, etc.) fonctionnent.

### Affichage conditionnel des noms dans chaque carte

**Langue FR active** :
- Ligne 1 : `card.nameFr || card.nameEn` — style `nameStyle` (gras, Manrope 700, 1rem)
- Ligne 2 : `card.nameEn` — style `metaStyle` (Inter, 0.8125rem, `on-surface-variant`)

**Langue EN active** :
- Ligne 1 : `card.nameEn` — style `nameStyle`
- Ligne 2 : `card.nameFr` — style `metaStyle` (si présent)

### Cas `name_fr` NULL

Si une carte n'a pas de `name_fr` (cas défensif) :
- En tri FR : carte placée **en début de liste** (`NULLS FIRST`)
- Affichage : `card.nameEn` promu en ligne 1 (fallback déjà présent dans `CardItem`)

### Impact sur le scroll infini

Quand `sortBy` ou `sortDir` change, React Query réinitialise automatiquement la pagination car les deux valeurs font partie de la clé de cache `['cards', filters]`. La page revient à 1 sans code supplémentaire.

---

## Spécification Backend

### 1. Domaine — `internal/domain/card.go`

Ajouter deux champs dans `CardFilter` :

```go
// Avant
type CardFilter struct {
    Search string
    Series string
    Type   string
    Rarity string
    Owned  string // "true", "false", ou "" pour tout
    Page   int
    Limit  int
}

// Après
type CardFilter struct {
    Search  string
    Series  string
    Type    string
    Rarity  string
    Owned   string // "true", "false", ou "" pour tout
    Page    int
    Limit   int
    SortBy  string // "name_fr" | "name_en" — défaut : "name_fr"
    SortDir string // "asc" | "desc" — défaut : "asc"
}
```

Aucune autre modification dans ce fichier.

### 2. Repository — `internal/infrastructure/postgres/card_repository.go`

#### 2a. Whitelist des colonnes (sécurité SQL — injection impossible)

Ajouter juste avant la construction de `orderClause` dans `GetCardsCatalog` :

```go
// Whitelist stricte des colonnes de tri autorisées
var sortColumnWhitelist = map[string]string{
    "name_fr": "c.name_fr",
    "name_en": "c.name_en",
}
```

#### 2b. Remplacement de la clause ORDER BY hardcodée

Remplacer la ligne fixe dans `dataQuery` :

```go
// Avant (ligne 121 de card_repository.go)
ORDER BY c.series, c.name_fr

// Après — construction dynamique
sortCol, ok := sortColumnWhitelist[filter.SortBy]
if !ok {
    sortCol = "c.name_fr" // valeur par défaut si SortBy absent ou invalide
}
sortDir := "ASC"
if strings.ToLower(filter.SortDir) == "desc" {
    sortDir = "DESC"
}
orderClause := fmt.Sprintf("ORDER BY %s %s NULLS FIRST", sortCol, sortDir)
```

La `dataQuery` devient :

```go
dataQuery := fmt.Sprintf(`
    SELECT
        c.id, c.collection_id, c.name_en, c.name_fr, c.card_type, c.series, c.rarity,
        c.created_at, c.updated_at,
        COALESCE(uc.is_owned, false) AS is_owned
    FROM cards c
    LEFT JOIN user_cards uc ON c.id = uc.card_id AND uc.user_id = $1
    WHERE c.collection_id IN (
        SELECT collection_id FROM user_collections WHERE user_id = $1
    ) %s
    %s
    LIMIT $%d OFFSET $%d`, whereClause, orderClause, idx, idx+1)
```

Note : `strings` est déjà importé dans ce fichier.

### 3. Handler — `internal/infrastructure/http/handlers/catalog_handler.go`

#### 3a. Nouveaux query params lus dans `GetCards`

Ajouter après la lecture de `q.Get("owned")` dans la construction de `filter` :

```go
// Lecture et validation des paramètres de tri
sortBy := q.Get("sort_by")
if sortBy != "name_fr" && sortBy != "name_en" {
    sortBy = "name_fr" // défaut silencieux
}

sortDir := q.Get("sort_dir")
if sortDir != "asc" && sortDir != "desc" {
    sortDir = "asc" // défaut silencieux
}

filter := domain.CardFilter{
    Search:  search,
    Series:  series,
    Type:    q.Get("type"),
    Rarity:  q.Get("rarity"),
    Owned:   q.Get("owned"),
    Page:    page,
    Limit:   limit,
    SortBy:  sortBy,
    SortDir: sortDir,
}
```

#### 3b. Contrat API mis à jour

`GET /api/v1/cards` accepte deux nouveaux query params :

| Paramètre | Valeurs | Défaut | Comportement si invalide |
|-----------|---------|--------|--------------------------|
| `sort_by` | `name_fr`, `name_en` | `name_fr` | Retombe sur défaut silencieusement |
| `sort_dir` | `asc`, `desc` | `asc` | Retombe sur défaut silencieusement |

Exemple : `GET /api/v1/cards?page=1&limit=50&sort_by=name_en&sort_dir=desc`

---

## Spécification Frontend

### 1. Types — `frontend/src/lib/api/collections.ts`

#### 1a. Mise à jour de `CardFilters`

```typescript
// Avant
export interface CardFilters {
  search?: string
  series?: string
  type?: string
  rarity?: string
  owned?: 'true' | 'false'
}

// Après
export type SortBy  = 'name_fr' | 'name_en'
export type SortDir = 'asc' | 'desc'

export interface CardFilters {
  search?: string
  series?: string
  type?: string
  rarity?: string
  owned?: 'true' | 'false'
  sort_by?:  SortBy
  sort_dir?: SortDir
}
```

#### 1b. Mise à jour de `fetchCards`

Ajouter les deux paramètres dans la construction de l'URL :

```typescript
// Après les params existants (owned)
if (filters.sort_by)  params.set('sort_by',  filters.sort_by)
if (filters.sort_dir) params.set('sort_dir', filters.sort_dir)
```

Bloc complet mis à jour :

```typescript
export async function fetchCards(filters: CardFilters, page: number): Promise<CardPage> {
  const params = new URLSearchParams()
  params.set('page', String(page))
  params.set('limit', '50')
  if (filters.search)   params.set('search',   filters.search)
  if (filters.series)   params.set('series',   filters.series)
  if (filters.type)     params.set('type',     filters.type)
  if (filters.rarity)   params.set('rarity',   filters.rarity)
  if (filters.owned)    params.set('owned',    filters.owned)
  if (filters.sort_by)  params.set('sort_by',  filters.sort_by)
  if (filters.sort_dir) params.set('sort_dir', filters.sort_dir)

  const response = await apiClient.get(`/api/v1/cards?${params.toString()}`)
  // ... reste inchangé
}
```

### 2. Page — `frontend/src/app/cards/page.tsx`

#### 2a. Import des types

Ajouter `SortBy` et `SortDir` à l'import existant :

```typescript
// Avant
import { CardFilters, Card } from '@/lib/api/collections'

// Après
import { CardFilters, Card, SortBy, SortDir } from '@/lib/api/collections'
```

#### 2b. Nouveaux états dans `AddCardsPage`

Ajouter après la déclaration de l'état `owned` existant :

```typescript
// Après : const [owned, setOwned] = useState<OwnedFilter>('all')
const [sortBy,  setSortBy]  = useState<SortBy>('name_fr')
const [sortDir, setSortDir] = useState<SortDir>('asc')
```

#### 2c. Ajout des valeurs de tri dans l'objet `filters`

```typescript
// Avant
const filters: CardFilters = {
  ...(debouncedSearch && { search: debouncedSearch }),
  ...(series && { series }),
  ...(type && { type }),
  ...(rarity && { rarity }),
  ...(owned !== 'all' && { owned: owned as 'true' | 'false' }),
}

// Après
const filters: CardFilters = {
  ...(debouncedSearch && { search: debouncedSearch }),
  ...(series && { series }),
  ...(type && { type }),
  ...(rarity && { rarity }),
  ...(owned !== 'all' && { owned: owned as 'true' | 'false' }),
  sort_by:  sortBy,
  sort_dir: sortDir,
}
```

#### 2d. Deux nouveaux toggleGroups dans la `filtersBarStyle`

Ajouter après le `toggleGroup` de possession existant (lignes 517-528 actuelles), en réutilisant `toggleGroupStyle` et `toggleBtnStyle` sans aucune modification de ces styles :

```tsx
{/* Toggle langue de tri */}
<div style={toggleGroupStyle} role="group" aria-label="Langue de tri">
  <button
    onClick={() => setSortBy('name_fr')}
    style={toggleBtnStyle(sortBy === 'name_fr')}
    aria-pressed={sortBy === 'name_fr'}
  >
    FR
  </button>
  <button
    onClick={() => setSortBy('name_en')}
    style={toggleBtnStyle(sortBy === 'name_en')}
    aria-pressed={sortBy === 'name_en'}
  >
    EN
  </button>
</div>

{/* Toggle ordre de tri */}
<div style={toggleGroupStyle} role="group" aria-label="Ordre de tri">
  <button
    onClick={() => setSortDir('asc')}
    style={toggleBtnStyle(sortDir === 'asc')}
    aria-pressed={sortDir === 'asc'}
  >
    A→Z
  </button>
  <button
    onClick={() => setSortDir('desc')}
    style={toggleBtnStyle(sortDir === 'desc')}
    aria-pressed={sortDir === 'desc'}
  >
    Z→A
  </button>
</div>
```

#### 2e. Mise à jour de `CardItemProps` et `CardItem`

Ajouter `sortBy` comme prop et rendre l'affichage des noms conditionnel :

```typescript
// Props mise à jour
interface CardItemProps {
  card: Card
  sortBy: SortBy          // ← nouveau
  onToggle: (cardId: string, isOwned: boolean) => void
  isTogglingId?: string
}
```

Remplacer le bloc de noms dans `CardItem` (actuellement lignes 171-174) :

```tsx
// Avant
<div style={nameStyle}>{card.nameFr || card.nameEn}</div>
{card.nameFr && card.nameEn && (
  <div style={{ ...metaStyle, marginBottom: '0.5rem', opacity: 0.8 }}>
    {card.nameEn}
  </div>
)}

// Après
{sortBy === 'name_fr' ? (
  <>
    <div style={nameStyle}>{card.nameFr || card.nameEn}</div>
    {card.nameFr && card.nameEn && (
      <div style={{ ...metaStyle, marginBottom: '0.5rem', opacity: 0.8 }}>
        {card.nameEn}
      </div>
    )}
  </>
) : (
  <>
    <div style={nameStyle}>{card.nameEn}</div>
    {card.nameFr && (
      <div style={{ ...metaStyle, marginBottom: '0.5rem', opacity: 0.8 }}>
        {card.nameFr}
      </div>
    )}
  </>
)}
```

#### 2f. Transmission de `sortBy` à `CardItem`

Dans le rendu de la grille (actuellement `allCards.map`) :

```tsx
// Avant
<CardItem
  key={card.id}
  card={card}
  onToggle={handleToggle}
  isTogglingId={togglingCardId}
/>

// Après
<CardItem
  key={card.id}
  card={card}
  sortBy={sortBy}         // ← nouveau
  onToggle={handleToggle}
  isTogglingId={togglingCardId}
/>
```

---

## Fichiers à modifier (récapitulatif)

| Fichier | Nature de la modification |
|---------|--------------------------|
| `internal/domain/card.go` | Ajouter `SortBy`, `SortDir` dans `CardFilter` |
| `internal/infrastructure/postgres/card_repository.go` | Whitelist + ORDER BY dynamique avec NULLS FIRST |
| `internal/infrastructure/http/handlers/catalog_handler.go` | Lire `sort_by`, `sort_dir` depuis query params, valeurs par défaut |
| `frontend/src/lib/api/collections.ts` | Exporter `SortBy`, `SortDir`, mettre à jour `CardFilters` et `fetchCards` |
| `frontend/src/app/cards/page.tsx` | États `sortBy`/`sortDir`, deux toggleGroups, prop `sortBy` vers `CardItem`, affichage conditionnel des noms |

**Aucun fichier créé** (ni hook, ni composant, ni migration SQL).

---

## Tests TDD

### Backend — Repository (`card_repository_test.go`)

Tests d'intégration à écrire (pattern testcontainers ou DB de test existante) :

```go
// TestGetCardsCatalog_DefaultSort_NameFR_ASC
// Vérifie que sans paramètre de tri, les cartes arrivent en FR A→Z
func TestGetCardsCatalog_DefaultSort_NameFR_ASC(t *testing.T) {
    filter := domain.CardFilter{Page: 1, Limit: 50}
    // SortBy et SortDir vides → le repository applique les défauts
    result, err := repo.GetCardsCatalog(ctx, userID, filter)
    assert.NoError(t, err)
    assert.True(t, isSortedByNameFR_ASC(result.Cards))
}

// TestGetCardsCatalog_SortByNameFR_DESC
func TestGetCardsCatalog_SortByNameFR_DESC(t *testing.T) {
    filter := domain.CardFilter{Page: 1, Limit: 50, SortBy: "name_fr", SortDir: "desc"}
    result, err := repo.GetCardsCatalog(ctx, userID, filter)
    assert.NoError(t, err)
    assert.True(t, isSortedByNameFR_DESC(result.Cards))
}

// TestGetCardsCatalog_SortByNameEN_ASC
func TestGetCardsCatalog_SortByNameEN_ASC(t *testing.T) {
    filter := domain.CardFilter{Page: 1, Limit: 50, SortBy: "name_en", SortDir: "asc"}
    result, err := repo.GetCardsCatalog(ctx, userID, filter)
    assert.NoError(t, err)
    assert.True(t, isSortedByNameEN_ASC(result.Cards))
}

// TestGetCardsCatalog_SortByNameEN_DESC
func TestGetCardsCatalog_SortByNameEN_DESC(t *testing.T) {
    filter := domain.CardFilter{Page: 1, Limit: 50, SortBy: "name_en", SortDir: "desc"}
    result, err := repo.GetCardsCatalog(ctx, userID, filter)
    assert.NoError(t, err)
    assert.True(t, isSortedByNameEN_DESC(result.Cards))
}

// TestGetCardsCatalog_InvalidSortBy_FallsBackToNameFR
// Valeur invalide → défaut name_fr ASC, pas d'erreur
func TestGetCardsCatalog_InvalidSortBy_FallsBackToNameFR(t *testing.T) {
    filter := domain.CardFilter{Page: 1, Limit: 50, SortBy: "name_fr; DROP TABLE cards;--"}
    result, err := repo.GetCardsCatalog(ctx, userID, filter)
    assert.NoError(t, err)
    assert.True(t, isSortedByNameFR_ASC(result.Cards))
}

// TestGetCardsCatalog_NullNameFR_NULLS_FIRST
// Les cartes sans name_fr apparaissent en premier quand tri FR
func TestGetCardsCatalog_NullNameFR_NULLS_FIRST(t *testing.T) {
    // Insérer une carte avec name_fr = NULL en fixture
    filter := domain.CardFilter{Page: 1, Limit: 50, SortBy: "name_fr", SortDir: "asc"}
    result, err := repo.GetCardsCatalog(ctx, userID, filter)
    assert.NoError(t, err)
    assert.Equal(t, "", result.Cards[0].Card.NameFR) // NULL mappé en ""
}
```

### Backend — Handler (`catalog_handler_test.go`)

Tests unitaires avec mock du service (pattern existant dans `card_handler_test.go`) :

```go
// TestCatalogHandler_GetCards_DefaultSort
// Vérifie que sans params, filter.SortBy = "name_fr" et filter.SortDir = "asc"
func TestCatalogHandler_GetCards_DefaultSort(t *testing.T) {
    mockService := new(MockCatalogService)
    expectedFilter := domain.CardFilter{Page: 1, Limit: 50, SortBy: "name_fr", SortDir: "asc"}
    mockService.On("GetCatalog", mock.Anything, userID, expectedFilter).Return(emptyPage, nil)
    // GET /api/v1/cards
    // Assert que mockService a reçu SortBy="name_fr", SortDir="asc"
    mockService.AssertExpectations(t)
}

// TestCatalogHandler_GetCards_SortByNameEN_DESC
func TestCatalogHandler_GetCards_SortByNameEN_DESC(t *testing.T) {
    // GET /api/v1/cards?sort_by=name_en&sort_dir=desc
    // Assert que filter.SortBy = "name_en" et filter.SortDir = "desc"
}

// TestCatalogHandler_GetCards_InvalidSortBy_UsesDefault
func TestCatalogHandler_GetCards_InvalidSortBy_UsesDefault(t *testing.T) {
    // GET /api/v1/cards?sort_by=malicious_injection&sort_dir=invalid
    // Assert que filter.SortBy = "name_fr" et filter.SortDir = "asc"
    // Assert HTTP 200 (pas de rejet, défaut silencieux)
}
```

### Frontend — Vitest (`page.test.tsx` ou `cards-sort.test.tsx`)

```typescript
describe('Cards page — contrôles de tri', () => {
  it('affiche le bouton FR actif par défaut', () => {
    render(<AddCardsPage />)
    expect(screen.getByRole('button', { name: 'FR' })).toHaveAttribute('aria-pressed', 'true')
    expect(screen.getByRole('button', { name: 'EN' })).toHaveAttribute('aria-pressed', 'false')
  })

  it('affiche le bouton A→Z actif par défaut', () => {
    render(<AddCardsPage />)
    expect(screen.getByRole('button', { name: 'A→Z' })).toHaveAttribute('aria-pressed', 'true')
    expect(screen.getByRole('button', { name: 'Z→A' })).toHaveAttribute('aria-pressed', 'false')
  })

  it('bascule vers EN quand on clique sur EN', async () => {
    render(<AddCardsPage />)
    await userEvent.click(screen.getByRole('button', { name: 'EN' }))
    expect(screen.getByRole('button', { name: 'EN' })).toHaveAttribute('aria-pressed', 'true')
    expect(screen.getByRole('button', { name: 'FR' })).toHaveAttribute('aria-pressed', 'false')
  })

  it('transmet sort_by=name_en à fetchCards après clic EN', async () => {
    const fetchCardsSpy = vi.spyOn(collectionsApi, 'fetchCards')
    render(<AddCardsPage />)
    await userEvent.click(screen.getByRole('button', { name: 'EN' }))
    expect(fetchCardsSpy).toHaveBeenCalledWith(
      expect.objectContaining({ sort_by: 'name_en' }),
      1
    )
  })

  it('transmet sort_dir=desc à fetchCards après clic Z→A', async () => {
    const fetchCardsSpy = vi.spyOn(collectionsApi, 'fetchCards')
    render(<AddCardsPage />)
    await userEvent.click(screen.getByRole('button', { name: 'Z→A' }))
    expect(fetchCardsSpy).toHaveBeenCalledWith(
      expect.objectContaining({ sort_dir: 'desc' }),
      1
    )
  })
})

describe('CardItem — affichage conditionnel des noms', () => {
  const card: Card = { id: '1', nameEn: 'Gandalf the Grey', nameFr: 'Gandalf le Gris', ... }

  it('affiche nameFr en gras quand sortBy=name_fr', () => {
    render(<CardItem card={card} sortBy="name_fr" onToggle={() => {}} />)
    const primaryName = screen.getAllByRole('heading')[0] // ou par test-id
    expect(primaryName).toHaveTextContent('Gandalf le Gris')
  })

  it('affiche nameEn en gras quand sortBy=name_en', () => {
    render(<CardItem card={card} sortBy="name_en" onToggle={() => {}} />)
    // Premier nom visible = EN
    expect(screen.getByText('Gandalf the Grey')).toBeVisible()
  })

  it('affiche nameEn en fallback quand nameFr est vide et sortBy=name_fr', () => {
    const cardNoFr: Card = { ...card, nameFr: '' }
    render(<CardItem card={cardNoFr} sortBy="name_fr" onToggle={() => {}} />)
    expect(screen.getByText('Gandalf the Grey')).toBeVisible()
  })
})
```

---

## Critères d'acceptation

- [ ] Tri FR A→Z actif à l'ouverture de `/cards` (aucune action utilisateur requise)
- [ ] Clic sur EN : la colonne de tri passe à `name_en` et le nom anglais apparaît en gras en premier dans chaque carte
- [ ] Clic sur FR depuis EN : retour au comportement par défaut
- [ ] Clic sur Z→A : l'ordre de tri s'inverse, scroll infini continue dans le bon ordre
- [ ] Les deux toggles sont indépendants : toutes les combinaisons (FR+Z→A, EN+ASC, EN+DESC) fonctionnent correctement
- [ ] Après changement de tri, le scroll infini recommence depuis la page 1 (pas de données mélangées)
- [ ] Les cartes avec `name_fr` NULL apparaissent en début de liste quand le tri est FR
- [ ] Valeur invalide dans `sort_by` ou `sort_dir` → défaut silencieux, HTTP 200
- [ ] Tentative d'injection SQL via `sort_by` → neutralisée par la whitelist, HTTP 200
- [ ] Les boutons utilisent exactement `toggleGroupStyle` et `toggleBtnStyle` existants (aucun nouveau style)
- [ ] Aucune bordure `1px solid` ajoutée sur les nouveaux toggleGroups
- [ ] Aucune persistance `localStorage` (réinitialisation à chaque session)

---

## Normalisation du tri

**Implémenté le 2026-04-25** dans `card_repository.go`.

La clause ORDER BY finale applique deux transformations de normalisation pour garantir un tri alphabétique correct sur des données multilingues (MECCG, noms FR/EN avec accents et guillemets typographiques).

### Clause ORDER BY finale

```sql
ORDER BY unaccent(REPLACE(col, '"', '')) ASC|DESC NULLS FIRST
```

### Règle 1 — Guillemets ignorés

```sql
REPLACE(col, '"', '')
```

Les noms de certaines cartes commencent par un guillemet typographique (`"`), par exemple `"Bert" (Bûrat)`. Sans ce remplacement, tous ces noms seraient triés avant la lettre A (car le guillemet `"` a un code ASCII inférieur aux lettres). Avec le `REPLACE`, `"Bert" (Bûrat)` trie avec les **B**.

### Règle 2 — Accents normalisés

```sql
unaccent(...)
```

La fonction PostgreSQL `unaccent` supprime les diacritiques avant le tri : `é` et `è` trient avec **e**, `à` trie avec **a**, etc. Le nom `Éowyn` est ainsi trié avec les **E** et non en fin de liste.

### Règle 3 — `œ` traité comme `oe`

`unaccent` gère automatiquement le ligature `œ` : `L'Œil` est normalisé en `L'OEil` avant le tri, ce qui le place correctement parmi les **O**.

### Prérequis PostgreSQL

L'extension `unaccent` doit être activée dans la base de données :

```sql
CREATE EXTENSION IF NOT EXISTS unaccent;
```

Cette extension est installée par défaut dans PostgreSQL et n'est pas activée automatiquement par migration. Elle doit être activée une fois par base de données (migration dédiée ou script d'initialisation).

---

## Points d'attention

### Sécurité SQL
La whitelist dans `card_repository.go` est la seule protection nécessaire. La colonne de tri n'est jamais construite à partir d'une interpolation directe de l'input utilisateur : elle passe par `sortColumnWhitelist[filter.SortBy]` avec un fallback sur `"c.name_fr"` si la clé est absente. La direction (`ASC`/`DESC`) est construite à partir d'une comparaison stricte, pas d'une interpolation.

### Pas de migration SQL requise
Le tri est appliqué au niveau de la requête `SELECT`. Aucune colonne ni index ne sont ajoutés (les colonnes `name_fr` et `name_en` existent déjà). Un index partiel `CREATE INDEX idx_cards_name_fr ON cards (name_fr NULLS FIRST)` pourrait être envisagé à terme pour des volumes importants, mais n'est pas requis pour le MVP.

### Scroll infini et cohérence du tri
Le changement de `sortBy` ou `sortDir` invalide la clé de cache React Query `['cards', filters]`. TanStack Query réinitialise automatiquement les pages accumulées et repart de `page=1`. Aucun `useEffect` de reset manuel n'est nécessaire.

### Ethos V1 — Pas de nouveaux styles
Les deux nouveaux toggleGroups réutilisent strictement `toggleGroupStyle` et `toggleBtnStyle(active)` définis dans `AddCardsPage`. Il est interdit d'ajouter de nouveaux objets de style CSS pour ces composants.
