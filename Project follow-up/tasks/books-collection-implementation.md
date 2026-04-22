# Implémentation Collection Romans "Royaumes oubliés"

**Date de création** : 2026-04-22  
**Priorité** : MEDIUM  
**Effort estimé** : 1-1.5 jours  
**Status** : À faire

---

## 📋 Vue d'ensemble

Ajouter une nouvelle collection de romans "Royaumes oubliés" (Forgotten Realms) à l'application Collectoria avec une UI/UX cohérente avec la collection MECCG existante.

---

## 📊 Données de la collection

### Informations générales
- **94 romans au total**
  - Série principale : 84 romans (numérotés 1-84)
  - Hors Série : 10 romans (numérotés HS1-HS10)
- **Source** : https://www.noosfere.org/livres/collection.asp?numcollection=-775388216&NumEditeur=3527

### Collection personnelle
- **41 romans possédés** (43.6% de complétion)
- **53 romans non possédés**

**Romans possédés (41) :**
```
Série principale (41):
1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 13, 14, 15, 16, 17, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 34, 36, 37, 38, 43, 44, 45, 49, 58, 59, 65, 70, 74

Hors Série (0):
(aucun)
```

**Romans NON possédés (53) :**
```
Série principale (43):
11, 12, 18, 32, 33, 35, 39, 40, 41, 42, 46, 47, 48, 50, 51, 52, 53, 54, 55, 56, 57, 60, 61, 62, 63, 64, 66, 67, 68, 69, 71, 72, 73, 75, 76, 77, 78, 79, 80, 81, 82, 83, 84

Hors Série (10):
HS1, HS2, HS3, HS4, HS5, HS6, HS7, HS8, HS9, HS10
```

---

## 🗄️ Modèle de données

### Table `books`

```sql
CREATE TABLE books (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    collection_id UUID NOT NULL REFERENCES collections(id),
    number VARCHAR(10) NOT NULL,  -- "1", "84", "HS1", "HS10"
    title VARCHAR(255) NOT NULL,
    author VARCHAR(255) NOT NULL,
    publication_date DATE NOT NULL,
    book_type VARCHAR(50) NOT NULL, -- "roman" ou "recueil de romans"
    created_at TIMESTAMP NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMP NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_books_collection_id ON books(collection_id);
CREATE INDEX idx_books_number ON books(number);
CREATE INDEX idx_books_author ON books(author);
CREATE INDEX idx_books_title ON books(title);
```

### Table `user_books`

```sql
CREATE TABLE user_books (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL,
    book_id UUID NOT NULL REFERENCES books(id),
    is_owned BOOLEAN NOT NULL DEFAULT false,
    created_at TIMESTAMP NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMP NOT NULL DEFAULT NOW(),
    
    UNIQUE(user_id, book_id)
);

CREATE INDEX idx_user_books_user_id ON user_books(user_id);
CREATE INDEX idx_user_books_book_id ON user_books(book_id);
CREATE INDEX idx_user_books_is_owned ON user_books(user_id, is_owned);
```

---

## 🎯 Plan d'implémentation détaillé

### Phase 1 : Migration SQL et données (1-2h)

**Fichier** : `backend/collection-management/migrations/003_add_books_collection.sql`

**Contenu** :
1. Création table `books`
2. Création table `user_books`
3. Indexes optimisés
4. Insert collection "Royaumes oubliés" dans `collections`
5. Insert des 94 romans dans `books`
6. Insert des associations `user_books` pour le userID `00000000-0000-0000-0000-000000000001` (41 possédés)

**Données à insérer** : Voir section "Liste complète des 94 romans" ci-dessous

---

### Phase 2 : Backend Go (2-3h)

#### 2.1 Domain Layer

**Fichier** : `internal/domain/book.go`

```go
package domain

import (
    "time"
    "github.com/google/uuid"
)

// Book représente un roman de la collection
type Book struct {
    ID              uuid.UUID
    CollectionID    uuid.UUID
    Number          string
    Title           string
    Author          string
    PublicationDate time.Time
    BookType        string
    CreatedAt       time.Time
    UpdatedAt       time.Time
}

// UserBook représente la possession d'un roman par un utilisateur
type UserBook struct {
    ID        uuid.UUID
    UserID    uuid.UUID
    BookID    uuid.UUID
    IsOwned   bool
    CreatedAt time.Time
    UpdatedAt time.Time
}

// BookWithOwnership représente un roman avec son statut de possession
type BookWithOwnership struct {
    Book
    IsOwned bool
}

// BookFilter représente les filtres pour la recherche de romans
type BookFilter struct {
    Search   string // Recherche dans le titre
    Author   string // Filtrer par auteur
    BookType string // "roman" ou "recueil de romans"
    Series   string // "principal" (1-84) ou "hors-serie" (HS)
    IsOwned  *bool  // nil = tous, true = possédés, false = non possédés
    Page     int
    Limit    int
}

// BookPage représente une page de résultats
type BookPage struct {
    Books      []BookWithOwnership
    Total      int
    Page       int
    Limit      int
    TotalPages int
}
```

**Fichier** : `internal/domain/book_repository.go`

```go
package domain

import (
    "context"
    "github.com/google/uuid"
)

type BookRepository interface {
    // GetBooksCatalog récupère la liste des romans avec filtres
    GetBooksCatalog(ctx context.Context, userID uuid.UUID, filter BookFilter) (*BookPage, error)
    
    // GetBookByID récupère un roman par son ID
    GetBookByID(ctx context.Context, id uuid.UUID) (*Book, error)
    
    // GetUserBook récupère le statut de possession d'un roman
    GetUserBook(ctx context.Context, userID, bookID uuid.UUID) (*UserBook, error)
    
    // UpdateUserBook met à jour le statut de possession
    UpdateUserBook(ctx context.Context, userBook *UserBook) error
}
```

#### 2.2 Application Layer

**Fichier** : `internal/application/book_service.go`

```go
package application

import (
    "context"
    "collectoria/collection-management/internal/domain"
    "github.com/google/uuid"
)

type BookService struct {
    bookRepo     domain.BookRepository
    activityRepo domain.ActivityRepository
}

func NewBookService(bookRepo domain.BookRepository, activityRepo domain.ActivityRepository) *BookService {
    return &BookService{
        bookRepo:     bookRepo,
        activityRepo: activityRepo,
    }
}

// GetBooksCatalog récupère la liste des romans avec filtres
func (s *BookService) GetBooksCatalog(ctx context.Context, userID uuid.UUID, filter domain.BookFilter) (*domain.BookPage, error) {
    return s.bookRepo.GetBooksCatalog(ctx, userID, filter)
}

// ToggleBookPossession toggle le statut de possession d'un roman
func (s *BookService) ToggleBookPossession(ctx context.Context, userID, bookID uuid.UUID, isOwned bool) (*domain.BookWithOwnership, error) {
    // 1. Récupérer le roman
    book, err := s.bookRepo.GetBookByID(ctx, bookID)
    if err != nil {
        return nil, err
    }
    
    // 2. Récupérer ou créer UserBook
    userBook, err := s.bookRepo.GetUserBook(ctx, userID, bookID)
    if err != nil {
        // Créer si n'existe pas
        userBook = &domain.UserBook{
            ID:      uuid.New(),
            UserID:  userID,
            BookID:  bookID,
            IsOwned: isOwned,
        }
    } else {
        userBook.IsOwned = isOwned
    }
    
    // 3. Mettre à jour
    if err := s.bookRepo.UpdateUserBook(ctx, userBook); err != nil {
        return nil, err
    }
    
    // 4. Enregistrer l'activité (best-effort)
    action := "book_added"
    if !isOwned {
        action = "book_removed"
    }
    
    _ = s.activityRepo.RecordActivity(ctx, &domain.Activity{
        ID:         uuid.New(),
        UserID:     userID,
        ActionType: action,
        Metadata: map[string]interface{}{
            "book_id":    bookID.String(),
            "book_title": book.Title,
        },
    })
    
    return &domain.BookWithOwnership{
        Book:    *book,
        IsOwned: isOwned,
    }, nil
}
```

#### 2.3 Infrastructure Layer

**Fichier** : `internal/infrastructure/postgres/book_repository.go`

- Implémentation de `BookRepository`
- Requêtes SQL avec filtres dynamiques
- Gestion des jointures books + user_books
- Pagination

**Fichier** : `internal/infrastructure/http/handlers/book_handler.go`

```go
// GET /api/v1/books
func (h *BookHandler) GetBooks(w http.ResponseWriter, r *http.Request)

// PATCH /api/v1/books/:id/possession
func (h *BookHandler) UpdateBookPossession(w http.ResponseWriter, r *http.Request)
```

#### 2.4 Tests TDD

**Fichiers de tests** :
- `internal/domain/book_test.go`
- `internal/application/book_service_test.go`
- `internal/infrastructure/postgres/book_repository_test.go`
- `internal/infrastructure/http/handlers/book_handler_test.go`

**Couverture cible** : >90%

---

### Phase 3 : Frontend React (2-3h)

#### 3.1 API Client et Types

**Fichier** : `frontend/src/lib/api/books.ts`

```typescript
export interface Book {
  id: string
  collectionId: string
  number: string
  title: string
  author: string
  publicationDate: string
  bookType: 'roman' | 'recueil de romans'
  isOwned: boolean
}

export interface BookFilters {
  search?: string
  author?: string
  bookType?: string
  series?: 'principal' | 'hors-serie'
  isOwned?: boolean
  page?: number
  limit?: number
}

export interface BookPage {
  books: Book[]
  total: number
  page: number
  limit: number
  totalPages: number
}

export const fetchBooks = async (filters: BookFilters): Promise<BookPage> => {
  const params = new URLSearchParams()
  // ... build params
  
  const response = await apiClient.fetch(`${API_BASE_URL}/books?${params}`)
  const data = await response.json()
  
  // Convert snake_case to camelCase
  return {
    books: data.books.map(snakeToCamel),
    total: data.total,
    page: data.page,
    limit: data.limit,
    totalPages: data.total_pages,
  }
}

export const toggleBookPossession = async (
  bookId: string,
  isOwned: boolean
): Promise<Book> => {
  const response = await apiClient.fetch(
    `${API_BASE_URL}/books/${bookId}/possession`,
    {
      method: 'PATCH',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ is_owned: isOwned }),
    }
  )
  return snakeToCamel(await response.json())
}
```

#### 3.2 Hooks React Query

**Fichier** : `frontend/src/hooks/useBooks.ts`

```typescript
export const useBooks = (filters: BookFilters) => {
  return useQuery({
    queryKey: ['books', filters],
    queryFn: () => fetchBooks(filters),
    staleTime: 5 * 60 * 1000, // 5 minutes
  })
}
```

**Fichier** : `frontend/src/hooks/useBookToggle.ts`

```typescript
export const useBookToggle = () => {
  const queryClient = useQueryClient()
  
  return useMutation({
    mutationFn: ({ bookId, isOwned }: { bookId: string; isOwned: boolean }) =>
      toggleBookPossession(bookId, isOwned),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['books'] })
      queryClient.invalidateQueries({ queryKey: ['collections'] })
    },
  })
}
```

#### 3.3 Page `/books`

**Fichier** : `frontend/src/app/books/page.tsx`

**Structure (similaire à `/cards/page.tsx`)** :
- Filtres en haut : Auteur, Type, Série, Recherche
- Liste de `BookCard` avec scroll infini
- Toggle possession avec modal confirmation
- Toast notifications
- États : loading, error, empty, success

**Design Ethos V1** :
- No-Line Rule (Tonal Layering)
- Dual-Type System (Manrope + Inter)
- Gradient violet sur boutons actifs
- Border radius, spacing généreux

#### 3.4 Composant `BookCard`

**Fichier** : `frontend/src/components/books/BookCard.tsx`

```tsx
interface BookCardProps {
  book: Book
  onToggle: (bookId: string, isOwned: boolean) => void
  isToggling: boolean
}

// UI:
// - Numéro (badge en haut à gauche)
// - Titre (Manrope, gras)
// - Auteur (Inter, normal)
// - Date publication (Inter, petit)
// - Type (badge)
// - Toggle switch (droite)
```

#### 3.5 Modal de confirmation

**Option 1** : Réutiliser `ConfirmToggleModal` existant (adapter texte)
**Option 2** : Créer `ConfirmBookToggleModal` spécifique

#### 3.6 Intégration Homepage

**Modifier** : `frontend/src/app/page.tsx`

- HeroCard : Inclure stats des romans dans le total
- CollectionsGrid : Ajouter carte "Royaumes oubliés"

**Modifier** : `frontend/src/components/layout/TopNav.tsx`

- Ajouter lien "Romans" dans la navigation

#### 3.7 Tests Vitest

**Fichiers de tests** :
- `frontend/src/app/books/__tests__/page.test.tsx`
- `frontend/src/components/books/__tests__/BookCard.test.tsx`
- `frontend/src/hooks/__tests__/useBooks.test.ts`
- `frontend/src/hooks/__tests__/useBookToggle.test.ts`

**Couverture cible** : Tous les tests passants

---

### Phase 4 : Documentation (30min)

**Fichiers à créer/mettre à jour** :
- `backend/collection-management/docs/BOOKS.md` - Documentation API books
- `frontend/BOOKS.md` - Guide utilisation frontend
- `STATUS.md` - Mise à jour avec nouvelle collection
- `README.md` - Mention collection Romans

---

## 📐 Données complètes des 94 romans

### Liste complète (à intégrer dans la migration SQL)

```sql
-- Voir fichier séparé: books-data.sql
-- Contient les 94 INSERT INTO books (...)
```

**Format de chaque roman** :
```sql
INSERT INTO books (id, collection_id, number, title, author, publication_date, book_type)
VALUES (
    gen_random_uuid(),
    (SELECT id FROM collections WHERE slug = 'royaumes-oublies'),
    '1',
    'Valombre',
    'Richard AWLINSON',
    '1994-03-01',
    'roman'
);
```

*Note* : Liste complète des 94 romans à créer dans un fichier SQL séparé pour faciliter la maintenance.

---

## 🎨 Design System - Cohérence avec MECCG

### Palette de couleurs pour "Royaumes oubliés"

**Suggestion** : Palette différente de MECCG (vert) pour distinction visuelle
- **Couleur primaire** : Bleu/Indigo (thème fantasy/magie)
- **Gradient** : `#4F46E5 → #7C3AED` (indigo → violet)

### Composants à réutiliser
- ✅ ConfirmToggleModal (ou adapter)
- ✅ Pattern scroll infini
- ✅ Pattern filtres dynamiques
- ✅ Toast notifications
- ✅ Skeleton loaders
- ✅ États UI (loading, error, empty, success)

---

## ✅ Critères de succès

### Backend
- [ ] Migration SQL créée et testée
- [ ] 94 romans insérés en base
- [ ] 41 romans marqués comme possédés
- [ ] Tables books + user_books créées avec indexes
- [ ] Domain entities Book + UserBook
- [ ] BookRepository implémenté
- [ ] BookService implémenté
- [ ] 2 endpoints API fonctionnels (GET /books, PATCH /books/:id/possession)
- [ ] Tests backend >90% coverage
- [ ] Tous les tests passent

### Frontend
- [ ] Page /books fonctionnelle
- [ ] Filtres dynamiques (Auteur, Type, Série, Recherche)
- [ ] Scroll infini (12 romans par batch)
- [ ] Toggle possession avec modal
- [ ] Toast notifications
- [ ] Design Ethos V1 respecté
- [ ] Responsive (mobile + desktop)
- [ ] Tests frontend (15+ tests)
- [ ] Tous les tests passent

### Intégration
- [ ] Collection "Royaumes oubliés" visible dans homepage
- [ ] Stats correctes (41/94 romans, 43.6%)
- [ ] Navigation TopNav avec lien "Romans"
- [ ] API protégée par JWT
- [ ] Activités enregistrées (book_added, book_removed)

### Documentation
- [ ] STATUS.md mis à jour
- [ ] Documentation API books
- [ ] Guide frontend books
- [ ] README mentionnant la collection

---

## 📊 Métriques attendues

**Après implémentation** :
- **2 collections actives** : MECCG + Royaumes oubliés
- **Total items** : 1679 cartes + 94 romans = 1773 items
- **Commits** : 3-5 commits atomiques
- **Tests** : 15-20 nouveaux tests
- **Lignes de code** : ~2000 lignes (backend + frontend + tests)
- **Temps estimé** : 6-8 heures de développement

---

## 🔄 Ordre d'implémentation recommandé

1. ✅ **Documentation** (ce fichier) - FAIT
2. ⏳ Migration SQL + données (1-2h)
3. ⏳ Backend Domain + Application (1h)
4. ⏳ Backend Infrastructure (1h)
5. ⏳ Tests backend (30min)
6. ⏳ Frontend API + Hooks (1h)
7. ⏳ Frontend Page /books (1-2h)
8. ⏳ Frontend Intégration homepage (30min)
9. ⏳ Tests frontend (1h)
10. ⏳ Documentation finale (30min)
11. ⏳ Validation manuelle end-to-end (30min)

**Total estimé** : 8-10 heures

---

## 📝 Notes importantes

### Différences avec MECCG
- **Simplicité** : Pas de types hiérarchiques, raretés multiples, noms bilingues
- **Numérotation** : String (permet "HS1", "HS10") au lieu de integer
- **Filtres** : Adaptés aux romans (Auteur au lieu de Série/Type)
- **UI** : Plus épurée, moins d'informations par item

### Évolutions futures possibles
- Page détail roman (`/books/:id`)
- Image de couverture
- ISBN
- Résumé/Synopsis
- Note personnelle
- Date d'acquisition
- Prix payé
- État du livre (neuf, bon, moyen)

### Points d'attention
- **Performance** : 94 romans vs 1679 cartes → moins de données, pagination moins critique
- **Cohérence** : Réutiliser au maximum les patterns existants
- **Tests** : TDD strict, tous les tests doivent passer
- **Design** : Ethos V1 à 100%
- **Sécurité** : JWT sur tous les endpoints

---

**Date de création** : 2026-04-22  
**Prochaine mise à jour** : Lors du début de l'implémentation  
**Status** : Documentation complète, prêt pour implémentation
