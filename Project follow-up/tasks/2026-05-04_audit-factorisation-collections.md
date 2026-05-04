# Audit et Factorisation des 3 Collections

**Date de création** : 2026-05-04
**Priorité** : MEDIUM
**Effort estimé** : 6-8h (2 sessions de 3-4h)
**Agent(s) responsable(s)** : Agent Backend + Agent Frontend
**Status** : 📋 TODO

---

## Contexte

Le projet Collectoria gère actuellement 3 collections de nature différente :

1. **MECCG (Middle-earth CCG)** : Jeu de cartes à collectionner
2. **Books (Royaumes Oubliés)** : Livres de fantasy
3. **DnD5** : Items de jeu de rôle Dungeons & Dragons 5e

Chaque collection a été implémentée de manière indépendante, ce qui a créé de la duplication de code et des patterns inconsistants entre elles.

**Problème** :
- Code dupliqué (handlers, services, repositories similaires)
- Patterns différents entre collections
- Maintenance difficile (changement = 3x le travail)
- Ajout de nouvelles collections coûteux

**Objectif** :
L'utilisateur possède une liste mentale des duplications, mais veut que les **agents techniques identifient les factorisations possibles** pour créer une architecture générique + système d'extension/override.

---

## Objectif

Auditer le code Backend et Frontend pour identifier :
1. **Code dupliqué** entre les 3 collections
2. **Patterns factorisables** (handlers, services, repositories, composants React)
3. **Architecture générique** possible (collection abstraite + spécialisations)
4. **Système d'extension/override** pour les spécificités de chaque collection

**Livrable** :
- Rapport d'audit Backend (Agent Backend)
- Rapport d'audit Frontend (Agent Frontend)
- Plan de factorisation progressif (priorités, phases)
- Architecture cible (générique + extensions)

---

## Plan d'Action

### Phase 1 : Audit Backend (3-4h) — Agent Backend

#### Étape 1.1 : Inventaire des Structures (1h)

**Agent Backend** analyse et documente :

**Collections MECCG** :
- [ ] Table : `meccg_cards`
- [ ] Handler : `/backend/collection-management/internal/handlers/cards.go`
- [ ] Service : `/backend/collection-management/internal/services/cards_service.go`
- [ ] Repository : `/backend/collection-management/internal/repositories/cards_repository.go`
- [ ] Domaine : `/backend/collection-management/internal/domain/card.go`
- [ ] Migration : `/backend/collection-management/migrations/002_create_meccg_cards.up.sql`

**Collections Books** :
- [ ] Table : `books_forgotten_realms`
- [ ] Handler : `/backend/collection-management/internal/handlers/books.go`
- [ ] Service : `/backend/collection-management/internal/services/books_service.go`
- [ ] Repository : `/backend/collection-management/internal/repositories/books_repository.go`
- [ ] Domaine : `/backend/collection-management/internal/domain/book.go`
- [ ] Migration : `/backend/collection-management/migrations/00X_create_books.up.sql`

**Collections DnD5** :
- [ ] Table : `dnd5_items`
- [ ] Handler : `/backend/collection-management/internal/handlers/dnd5.go`
- [ ] Service : `/backend/collection-management/internal/services/dnd5_service.go`
- [ ] Repository : `/backend/collection-management/internal/repositories/dnd5_repository.go`
- [ ] Domaine : `/backend/collection-management/internal/domain/dnd5_item.go`
- [ ] Migration : `/backend/collection-management/migrations/00X_create_dnd5.up.sql`

#### Étape 1.2 : Analyse des Patterns Communs (1h)

**Agent Backend** identifie les patterns communs :

**Handlers (exemple)** :
```go
// cards.go
func (h *CardsHandler) GetCards(c *gin.Context) {
    // 1. Parse query params (filters, sort, pagination)
    // 2. Call service.GetCards()
    // 3. Return JSON response
}

// books.go
func (h *BooksHandler) GetBooks(c *gin.Context) {
    // 1. Parse query params (filters, sort, pagination)
    // 2. Call service.GetBooks()
    // 3. Return JSON response
}

// dnd5.go
func (h *DnD5Handler) GetItems(c *gin.Context) {
    // 1. Parse query params (filters, sort, pagination)
    // 2. Call service.GetItems()
    // 3. Return JSON response
}
```

**Questions à répondre** :
- [ ] Quelle partie du code est identique ? (parsing params, response format)
- [ ] Quelle partie est spécifique ? (filtres métier, validation)
- [ ] Peut-on créer un `GenericCollectionHandler` ?
- [ ] Si oui, comment gérer les spécificités (override, extension) ?

**Services** :
```go
// Analyser les méthodes communes
- GetAll(filters, sort, pagination)
- GetByID(id)
- Search(query)
- GetUserCollection(userID)
```

**Repositories** :
```go
// Analyser les requêtes SQL communes
- SELECT * FROM [table] WHERE ...
- SELECT * FROM [table] JOIN user_[table] ...
- INSERT INTO user_[table] ...
```

#### Étape 1.3 : Identification des Factorisations (1h)

**Agent Backend** produit un rapport structuré :

```markdown
# Rapport Audit Backend - Factorisation Collections

## 1. Patterns Identiques (100% factorisation possible)

### Handlers
- Parsing query params (filters, sort, pagination)
- Format de réponse JSON
- Gestion erreurs
- Middleware auth

**Factorisation** : `GenericCollectionHandler[T CollectionItem]`

### Services
- Méthode GetAll(filters, sort, pagination)
- Méthode GetByID(id)
- Méthode AddToUserCollection(userID, itemID)
- Méthode RemoveFromUserCollection(userID, itemID)

**Factorisation** : `GenericCollectionService[T CollectionItem]`

### Repositories
- Requête SELECT avec pagination
- Requête SELECT par ID
- Requête INSERT user_collection
- Requête DELETE user_collection

**Factorisation** : `GenericCollectionRepository[T CollectionItem]`

---

## 2. Patterns Similaires (80% factorisation, 20% spécifique)

### Filtres Métier
- Cards : filtrage par `type`, `rarity`, `alignment`
- Books : filtrage par `series`, `author`, `year`
- DnD5 : filtrage par `category`, `rarity`, `source_book`

**Factorisation** : Interface `Filterable` avec implémentation spécifique par collection

### Tri
- Cards : tri par `name`, `type`, `rarity`, `alignment`
- Books : tri par `title`, `series`, `year`, `author`
- DnD5 : tri par `name`, `category`, `rarity`

**Factorisation** : Interface `Sortable` avec configuration par collection

---

## 3. Patterns Spécifiques (pas de factorisation)

### Domaine Métier
- Cards : `alignment`, `type` (spécifiques MECCG)
- Books : `series`, `author`, `isbn` (spécifiques livres)
- DnD5 : `source_book`, `attunement` (spécifiques DnD)

**Décision** : Garder les structs de domaine séparées, utiliser interface commune

---

## 4. Architecture Cible Recommandée

### Option A : Generics + Interface (recommandé)

```go
// domain/collection.go
type CollectionItem interface {
    GetID() string
    GetName() string
    GetSearchableFields() map[string]string
}

// Card implémente CollectionItem
type Card struct { ... }
func (c *Card) GetID() string { return c.ID }

// Book implémente CollectionItem
type Book struct { ... }
func (b *Book) GetID() string { return b.ID }

// handlers/generic_collection_handler.go
type GenericCollectionHandler[T CollectionItem] struct {
    service GenericCollectionService[T]
}

func (h *GenericCollectionHandler[T]) GetAll(c *gin.Context) {
    // Code générique pour toutes les collections
}

// handlers/cards_handler.go (spécialisation)
type CardsHandler struct {
    *GenericCollectionHandler[Card]
}

// Méthodes spécifiques uniquement si nécessaire
func (h *CardsHandler) GetCardsByAlignment(c *gin.Context) {
    // Spécifique MECCG
}
```

### Option B : Composition (plus flexible)

```go
// handlers/base_collection_handler.go
type BaseCollectionHandler struct {
    service CollectionService
}

// cards_handler.go
type CardsHandler struct {
    BaseCollectionHandler
    cardService *CardsService
}

// Override uniquement si nécessaire
func (h *CardsHandler) GetAll(c *gin.Context) {
    // Appelle base + logique spécifique
}
```

---

## 5. Plan de Migration

### Phase 1 : Factorisation Handlers (2h)
- Créer `GenericCollectionHandler[T]`
- Migrer Cards → hérite de Generic
- Migrer Books → hérite de Generic
- Migrer DnD5 → hérite de Generic

### Phase 2 : Factorisation Services (2h)
- Créer `GenericCollectionService[T]`
- Migrer les 3 services

### Phase 3 : Factorisation Repositories (2h)
- Créer `GenericCollectionRepository[T]`
- Migrer les 3 repositories

### Phase 4 : Tests et Validation (1h)
- Tests unitaires
- Tests intégration
- Validation API

---

## 6. Métriques

| Métrique | Avant | Après | Réduction |
|----------|-------|-------|-----------|
| Lignes de code Handlers | 450 | 200 | -55% |
| Lignes de code Services | 600 | 300 | -50% |
| Lignes de code Repositories | 700 | 350 | -50% |
| **TOTAL** | **1750** | **850** | **-51%** |

---

## 7. Risques

- Migration complexe (risque de régression)
- Generics Go 1.18+ (vérifier version)
- Tests exhaustifs nécessaires

---

## 8. Recommandations

1. ✅ Adopter Option A (Generics + Interface)
2. ✅ Migration progressive (1 collection à la fois)
3. ✅ Tests avant/après chaque migration
4. ✅ Documentation des patterns génériques
```

#### Étape 1.4 : Validation avec Utilisateur (15min)

**Agent Backend** présente le rapport et demande validation avant de passer à la phase d'implémentation.

---

### Phase 2 : Audit Frontend (3-4h) — Agent Frontend

#### Étape 2.1 : Inventaire des Composants (1h)

**Agent Frontend** analyse et documente :

**Pages** :
- [ ] `/frontend/app/cards/page.tsx`
- [ ] `/frontend/app/books/page.tsx`
- [ ] `/frontend/app/dnd5/page.tsx`

**Composants** :
- [ ] `/frontend/components/cards/CardsGrid.tsx`
- [ ] `/frontend/components/books/BooksGrid.tsx`
- [ ] `/frontend/components/dnd5/DnD5Grid.tsx`
- [ ] `/frontend/components/cards/CardItem.tsx`
- [ ] `/frontend/components/books/BookItem.tsx`
- [ ] `/frontend/components/dnd5/DnD5Item.tsx`

**Hooks** :
- [ ] `/frontend/hooks/useCards.ts`
- [ ] `/frontend/hooks/useBooks.ts`
- [ ] `/frontend/hooks/useDnD5.ts`

**API Clients** :
- [ ] `/frontend/lib/api/cards.ts`
- [ ] `/frontend/lib/api/books.ts`
- [ ] `/frontend/lib/api/dnd5.ts`

#### Étape 2.2 : Analyse des Patterns Communs (1h)

**Agent Frontend** identifie les patterns communs :

**Pages (exemple)** :
```tsx
// app/cards/page.tsx
export default function CardsPage() {
  const { cards, loading, error } = useCards();
  const [filters, setFilters] = useState({});
  const [sort, setSort] = useState("name");
  
  return (
    <div>
      <Header />
      <FiltersBar filters={filters} onChange={setFilters} />
      <SortDropdown value={sort} onChange={setSort} />
      <CardsGrid cards={cards} loading={loading} />
    </div>
  );
}

// app/books/page.tsx (identique)
// app/dnd5/page.tsx (identique)
```

**Questions à répondre** :
- [ ] Structure de la page identique ?
- [ ] Composants Layout identiques (Header, Filters, Sort) ?
- [ ] Logique de state management identique ?
- [ ] Peut-on créer un `CollectionPage<T>` générique ?

**Composants Grid** :
```tsx
// Analyser la structure
<Grid>
  {items.map(item => <ItemCard key={item.id} item={item} />)}
</Grid>
```

**Hooks** :
```tsx
// useCards.ts
export function useCards() {
  const [cards, setCards] = useState<Card[]>([]);
  const [loading, setLoading] = useState(true);
  
  useEffect(() => {
    fetchCards().then(setCards).finally(() => setLoading(false));
  }, []);
  
  return { cards, loading };
}

// useBooks.ts (identique)
// useDnD5.ts (identique)
```

#### Étape 2.3 : Identification des Factorisations (1h)

**Agent Frontend** produit un rapport structuré :

```markdown
# Rapport Audit Frontend - Factorisation Collections

## 1. Patterns Identiques (100% factorisation possible)

### Pages
- Structure de layout (Header, Filters, Sort, Grid)
- State management (filters, sort, loading)
- Gestion erreurs

**Factorisation** : `CollectionPage<T>` générique

### Hooks
- useCollection(endpoint) générique
- Logique fetch/loading/error identique

**Factorisation** : `useCollection<T>(config)`

### API Clients
- fetch(), getById(), addToCollection(), removeFromCollection()

**Factorisation** : `createCollectionAPI<T>(baseUrl)`

---

## 2. Patterns Similaires (80% factorisation)

### Filtres
- Cards : Type, Rarity, Alignment
- Books : Series, Author, Year
- DnD5 : Category, Rarity, Source Book

**Factorisation** : `FilterBar<T>` avec configuration dynamique

### Composants Grid
- Layout identique
- Card wrapper différent

**Factorisation** : `CollectionGrid<T>` avec render prop pour ItemCard

---

## 3. Patterns Spécifiques (pas de factorisation)

### Item Cards
- CardItem : affichage spécifique MECCG (image, type, alignment)
- BookItem : affichage spécifique livre (cover, author, series)
- DnD5Item : affichage spécifique item (rarity, source_book)

**Décision** : Garder les composants Item séparés, passer comme prop

---

## 4. Architecture Cible Recommandée

### Option A : Composition + Render Props (recommandé)

```tsx
// components/collection/CollectionPage.tsx
interface CollectionPageProps<T> {
  title: string;
  endpoint: string;
  filters: FilterConfig[];
  sortOptions: SortOption[];
  renderItem: (item: T) => React.ReactNode;
}

export function CollectionPage<T>({
  title,
  endpoint,
  filters,
  sortOptions,
  renderItem
}: CollectionPageProps<T>) {
  const { items, loading, error, refetch } = useCollection<T>(endpoint);
  const [currentFilters, setFilters] = useState({});
  const [sort, setSort] = useState(sortOptions[0].value);
  
  return (
    <div>
      <Header title={title} />
      <FilterBar config={filters} value={currentFilters} onChange={setFilters} />
      <SortDropdown options={sortOptions} value={sort} onChange={setSort} />
      <CollectionGrid items={items} loading={loading} renderItem={renderItem} />
    </div>
  );
}

// app/cards/page.tsx (utilisation)
export default function CardsPage() {
  return (
    <CollectionPage<Card>
      title="MECCG Cards"
      endpoint="/api/v1/cards"
      filters={cardsFilters}
      sortOptions={cardsSortOptions}
      renderItem={(card) => <CardItem card={card} />}
    />
  );
}
```

### Option B : Higher-Order Component

```tsx
// hoc/withCollection.tsx
export function withCollection<T>(config: CollectionConfig) {
  return function(ItemComponent: React.ComponentType<{item: T}>) {
    return function CollectionPageHOC() {
      // Logique générique
      return <ItemComponent item={item} />;
    };
  };
}
```

---

## 5. Plan de Migration

### Phase 1 : Hooks Génériques (1h)
- Créer `useCollection<T>`
- Migrer useCards, useBooks, useDnD5

### Phase 2 : Composants Layout (1h)
- Créer `CollectionGrid<T>`
- Créer `FilterBar` dynamique
- Créer `SortDropdown` dynamique

### Phase 3 : Pages Génériques (1h)
- Créer `CollectionPage<T>`
- Migrer Cards page
- Migrer Books page
- Migrer DnD5 page

### Phase 4 : Tests et Validation (1h)
- Tests unitaires composants
- Tests intégration pages
- Validation UX

---

## 6. Métriques

| Métrique | Avant | Après | Réduction |
|----------|-------|-------|-----------|
| Lignes de code Pages | 300 | 100 | -66% |
| Lignes de code Hooks | 200 | 80 | -60% |
| Lignes de code API | 250 | 100 | -60% |
| **TOTAL** | **750** | **280** | **-62%** |

---

## 7. Risques

- TypeScript Generics (complexité)
- Perte de lisibilité si sur-abstraction
- Migration progressive pour éviter régressions

---

## 8. Recommandations

1. ✅ Adopter Option A (Composition + Render Props)
2. ✅ Migration progressive (1 collection à la fois)
3. ✅ Garder les ItemCard spécifiques (pas de sur-abstraction)
4. ✅ Tests avant/après chaque migration
```

#### Étape 2.4 : Validation avec Utilisateur (15min)

**Agent Frontend** présente le rapport et demande validation.

---

### Phase 3 : Consolidation et Priorisation (1h)

**Agent Suivi de Projet** :
- [ ] Fusionner les 2 rapports (Backend + Frontend)
- [ ] Identifier les dépendances (Backend d'abord ou Frontend d'abord ?)
- [ ] Prioriser les phases de migration
- [ ] Estimer effort détaillé par phase
- [ ] Créer plan de migration global

---

## Critères d'Acceptation

- [ ] Rapport audit Backend complet (patterns identifiés, architecture cible)
- [ ] Rapport audit Frontend complet (patterns identifiés, architecture cible)
- [ ] Métriques de réduction de code estimées
- [ ] Architecture cible validée par l'utilisateur
- [ ] Plan de migration détaillé (phases, effort, ordre)
- [ ] Risques identifiés et mitigations proposées

---

## Risques & Mitigations

**Risque 1** : Sur-abstraction rendant le code illisible
→ **Mitigation** : Garder les spécificités (ItemCard, filtres métier) séparées

**Risque 2** : Régression lors de la migration
→ **Mitigation** : Tests exhaustifs avant/après, migration progressive

**Risque 3** : Effort sous-estimé
→ **Mitigation** : Découper en petites phases, valider à chaque étape

**Risque 4** : Architecture inadaptée aux futures collections
→ **Mitigation** : Valider avec un cas d'usage futur (ex: Magic The Gathering)

---

## Références

- Architecture Backend : `/Backend/ARCHITECTURE.md`
- Composants Frontend : `/Frontend/COMPONENTS.md`
- Page Cards (référence) : `/frontend/app/cards/page.tsx`
- Domain-Driven Design patterns

---

## Notes

### Collections Actuelles

**MECCG** :
- Nature : Jeu de cartes à collectionner
- Attributs spécifiques : `alignment`, `type`, `site`
- Filtres : Type, Rarity, Alignment
- Tri : Name, Type, Rarity

**Books** :
- Nature : Livres de fantasy
- Attributs spécifiques : `series`, `author`, `isbn`, `year`
- Filtres : Series, Author, Year
- Tri : Title, Author, Year, Series

**DnD5** :
- Nature : Items de jeu de rôle
- Attributs spécifiques : `category`, `source_book`, `attunement`
- Filtres : Category, Rarity, Source Book
- Tri : Name, Category, Rarity

### Futures Collections Possibles

Pour valider l'architecture générique, considérer :
- Magic The Gathering (cartes TCG)
- Comics Marvel/DC (bandes dessinées)
- Figurines Warhammer (miniatures)

L'architecture doit supporter facilement l'ajout de nouvelles collections sans duplication massive.

---

**Prochaines Actions** :
1. Phase 1 : Audit Backend (Agent Backend, 3-4h)
2. Phase 2 : Audit Frontend (Agent Frontend, 3-4h)
3. Phase 3 : Consolidation (Agent Suivi de Projet, 1h)
4. Validation Utilisateur avant implémentation
