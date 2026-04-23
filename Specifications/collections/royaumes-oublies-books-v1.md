# Spécification Technique : Royaumes Oubliés (Forgotten Realms) - Collection de Livres

**Date** : 2026-04-23  
**Version** : 1.0  
**Statut** : Draft  
**Auteur** : Agent Spécifications

---

## Vue d'ensemble

Cette spécification définit le modèle de données et l'architecture pour une nouvelle collection type : **Livres** (Books), spécifiquement les romans de l'univers **Forgotten Realms** (Royaumes oubliés). 

Le système permettra de :
- Cataloguer les livres Forgotten Realms
- Suivre la possession (livres possédés vs wishlist)
- Suivre le statut de lecture (à lire, en cours, lu)
- Noter les livres (rating 1-5 étoiles)
- Organiser par séries/sagas
- Afficher des statistiques de lecture

---

## Contexte Métier

### Ubiquitous Language (DDD)

- **Book** (Livre) : Livre de référence du catalogue Forgotten Realms
- **Author** (Auteur) : Auteur d'un livre
- **BookSeries** (Série) : Regroupement de livres (trilogie, saga, cycle)
- **Publisher** (Éditeur) : Maison d'édition
- **ISBN** : Identifiant unique international du livre
- **Cover** (Couverture) : Image de couverture du livre
- **Possession** : Fait de posséder ou non un livre
- **ReadingStatus** (Statut de lecture) : à lire / en cours / lu
- **Rating** (Note) : Évaluation personnelle (1-5 étoiles)
- **ReadingProgress** (Progression) : Avancement de lecture d'un utilisateur
- **UserBook** : Relation utilisateur-livre (possession + lecture)
- **PublicationYear** (Année de publication) : Année de sortie du livre

### Bounded Contexts

1. **Books Catalog** : Catalogue de référence des livres Forgotten Realms
2. **Reading Management** : Gestion de la bibliothèque personnelle et progression de lecture

---

## Modèle de Données - Books Catalog Bounded Context

### Aggregate : Book

**Description** : Un livre de référence dans le catalogue Forgotten Realms.

#### Attributs

| Attribut | Type | Obligatoire | Description |
|----------|------|-------------|-------------|
| `id` | UUID | Oui | Identifiant unique du livre |
| `title` | String | Oui | Titre du livre (français ou anglais) |
| `titleOriginal` | String | Optionnel | Titre original si traduit |
| `author` | String | Oui | Auteur principal |
| `coAuthors` | String[] | Optionnel | Co-auteurs éventuels |
| `seriesId` | UUID | Optionnel | Référence à une série/saga |
| `seriesOrder` | Integer | Optionnel | Position dans la série |
| `isbn` | String | Optionnel | ISBN-10 ou ISBN-13 |
| `publicationYear` | Integer | Optionnel | Année de publication |
| `publisher` | String | Optionnel | Éditeur |
| `pageCount` | Integer | Optionnel | Nombre de pages |
| `coverImageUrl` | String | Optionnel | URL de l'image de couverture |
| `description` | Text | Optionnel | Résumé/synopsis du livre |
| `language` | Enum | Oui | Langue (FR, EN) |
| `createdAt` | Timestamp | Oui | Date de création dans le système |
| `updatedAt` | Timestamp | Oui | Date de dernière mise à jour |

#### Invariants (Business Rules)

- `title` ne peut pas être vide
- `author` ne peut pas être vide
- Si `seriesOrder` est renseigné, `seriesId` doit l'être aussi
- `isbn` doit être valide (format ISBN-10 ou ISBN-13) si renseigné
- `publicationYear` doit être entre 1900 et année courante + 2
- `pageCount` doit être positif si renseigné
- La combinaison (`title`, `author`, `publicationYear`) devrait être unique

### Entity : BookSeries

**Description** : Une série, saga ou cycle de livres.

| Attribut | Type | Obligatoire | Description |
|----------|------|-------------|-------------|
| `id` | UUID | Oui | Identifiant unique |
| `name` | String | Oui | Nom de la série (ex: "The Legend of Drizzt") |
| `nameTranslated` | String | Optionnel | Nom traduit |
| `description` | Text | Optionnel | Description de la série |
| `bookCount` | Integer | Oui | Nombre de livres dans la série |
| `coverImageUrl` | String | Optionnel | Image représentant la série |
| `createdAt` | Timestamp | Oui | Date de création |

#### Invariants

- `name` ne peut pas être vide
- `bookCount` doit être >= 1
- `name` doit être unique

### Value Objects

#### Language
```go
type Language string

const (
    LanguageFR Language = "FR"
    LanguageEN Language = "EN"
)
```

#### ISBN
```go
type ISBN struct {
    Value string
    Type  ISBNType  // ISBN10 or ISBN13
}

type ISBNType string

const (
    ISBN10 ISBNType = "ISBN10"
    ISBN13 ISBNType = "ISBN13"
)

func (isbn ISBN) IsValid() bool {
    // Validation logic for ISBN-10 and ISBN-13 checksums
}
```

#### ReadingStatus
```go
type ReadingStatus string

const (
    ReadingStatusToRead     ReadingStatus = "TO_READ"
    ReadingStatusReading    ReadingStatus = "READING"
    ReadingStatusCompleted  ReadingStatus = "COMPLETED"
)
```

#### Rating
```go
type Rating int

const (
    MinRating Rating = 1
    MaxRating Rating = 5
)

func (r Rating) IsValid() bool {
    return r >= MinRating && r <= MaxRating
}
```

### Repository Interface

```go
type BookRepository interface {
    // Création
    Create(ctx context.Context, book *Book) error
    CreateBulk(ctx context.Context, books []*Book) error
    
    // Lecture
    FindByID(ctx context.Context, id uuid.UUID) (*Book, error)
    FindByISBN(ctx context.Context, isbn string) (*Book, error)
    FindBySeries(ctx context.Context, seriesID uuid.UUID) ([]*Book, error)
    FindAll(ctx context.Context) ([]*Book, error)
    
    // Recherche et filtres
    Search(ctx context.Context, query SearchQuery) ([]*Book, error)
    
    // Statistiques catalogue
    Count(ctx context.Context) (int, error)
    CountBySeries(ctx context.Context) (map[uuid.UUID]int, error)
    CountByAuthor(ctx context.Context) (map[string]int, error)
    
    // Mise à jour
    Update(ctx context.Context, book *Book) error
    
    // Suppression (rare)
    Delete(ctx context.Context, id uuid.UUID) error
}

type SearchQuery struct {
    // Recherche full-text
    SearchText    *string  // Recherche dans title, author, description
    
    // Filtres
    Title         *string  // Recherche partielle
    Author        *string  // Recherche partielle
    SeriesID      *uuid.UUID
    Language      *Language
    YearFrom      *int
    YearTo        *int
    
    // Pagination et tri
    Limit         int
    Offset        int
    OrderBy       string   // "title", "author", "year", "series"
    OrderDir      string   // "ASC", "DESC"
}
```

```go
type BookSeriesRepository interface {
    // Création
    Create(ctx context.Context, series *BookSeries) error
    
    // Lecture
    FindByID(ctx context.Context, id uuid.UUID) (*BookSeries, error)
    FindByName(ctx context.Context, name string) (*BookSeries, error)
    FindAll(ctx context.Context) ([]*BookSeries, error)
    
    // Mise à jour
    Update(ctx context.Context, series *BookSeries) error
    UpdateBookCount(ctx context.Context, seriesID uuid.UUID) error
    
    // Suppression
    Delete(ctx context.Context, id uuid.UUID) error
}
```

---

## Modèle de Données - Reading Management Bounded Context

### Aggregate : UserBookCollection

**Description** : Bibliothèque personnelle d'un utilisateur avec statuts de lecture.

### Entity : UserBook

**Description** : Relation entre un utilisateur et un livre (possession + progression).

| Attribut | Type | Obligatoire | Description |
|----------|------|-------------|-------------|
| `userId` | UUID | Oui | ID de l'utilisateur |
| `bookId` | UUID | Oui | ID du livre (référence Catalog) |
| `owned` | Boolean | Oui | true = possédé, false = wishlist |
| `readingStatus` | Enum | Oui | TO_READ / READING / COMPLETED |
| `rating` | Integer | Optionnel | Note 1-5 (null si pas noté) |
| `notes` | Text | Optionnel | Notes personnelles |
| `startedAt` | Timestamp | Optionnel | Date de début de lecture |
| `completedAt` | Timestamp | Optionnel | Date de fin de lecture |
| `addedAt` | Timestamp | Oui | Date d'ajout à la collection |
| `updatedAt` | Timestamp | Oui | Date de dernière mise à jour |

#### Invariants (Business Rules)

- Un livre ne peut être lié qu'une seule fois à un utilisateur (clé primaire composite)
- `rating` doit être entre 1 et 5 si renseigné
- Si `readingStatus = COMPLETED`, `completedAt` devrait être renseigné
- Si `readingStatus = READING`, `startedAt` devrait être renseigné
- `completedAt` doit être postérieur à `startedAt` si les deux sont renseignés
- `bookId` doit exister dans le Catalog bounded context

### Domain Events

```go
// Event publié lorsqu'un livre est ajouté à la collection
type BookAddedToCollection struct {
    EventID     uuid.UUID
    UserID      uuid.UUID
    BookID      uuid.UUID
    Owned       bool
    OccurredAt  time.Time
}

// Event publié lors d'un changement de statut de lecture
type ReadingStatusChanged struct {
    EventID       uuid.UUID
    UserID        uuid.UUID
    BookID        uuid.UUID
    PreviousStatus ReadingStatus
    NewStatus     ReadingStatus
    OccurredAt    time.Time
}

// Event publié lorsqu'un livre est terminé
type BookCompleted struct {
    EventID     uuid.UUID
    UserID      uuid.UUID
    BookID      uuid.UUID
    CompletedAt time.Time
    Rating      *int  // optionnel
    OccurredAt  time.Time
}

// Event publié lors d'une notation
type BookRated struct {
    EventID     uuid.UUID
    UserID      uuid.UUID
    BookID      uuid.UUID
    Rating      int
    OccurredAt  time.Time
}
```

### Repository Interface

```go
type UserBookRepository interface {
    // Possession et statuts
    AddBook(ctx context.Context, userID, bookID uuid.UUID, owned bool) error
    RemoveBook(ctx context.Context, userID, bookID uuid.UUID) error
    UpdateOwnership(ctx context.Context, userID, bookID uuid.UUID, owned bool) error
    UpdateReadingStatus(ctx context.Context, userID, bookID uuid.UUID, status ReadingStatus) error
    UpdateRating(ctx context.Context, userID, bookID uuid.UUID, rating int) error
    UpdateNotes(ctx context.Context, userID, bookID uuid.UUID, notes string) error
    
    // Lecture
    FindByUserAndBook(ctx context.Context, userID, bookID uuid.UUID) (*UserBook, error)
    GetUserBooks(ctx context.Context, userID uuid.UUID, filters UserBookFilters) ([]*UserBook, error)
    
    // Statistiques
    GetStats(ctx context.Context, userID uuid.UUID) (*ReadingStats, error)
}

type UserBookFilters struct {
    Owned         *bool
    ReadingStatus *ReadingStatus
    SeriesID      *uuid.UUID
    RatingMin     *int
    RatingMax     *int
    Limit         int
    Offset        int
    OrderBy       string  // "addedAt", "startedAt", "completedAt", "rating", "title"
    OrderDir      string  // "ASC", "DESC"
}

type ReadingStats struct {
    TotalBooks        int
    OwnedBooks        int
    WishlistBooks     int
    
    ToReadCount       int
    ReadingCount      int
    CompletedCount    int
    
    CompletionRate    float64  // Pourcentage (0-100)
    
    AverageRating     float64
    TotalPagesRead    int
    
    // Par série
    SeriesStats       map[uuid.UUID]SeriesReadingStats
    
    // Par année
    YearlyStats       map[int]YearlyReadingStats
}

type SeriesReadingStats struct {
    SeriesID          uuid.UUID
    SeriesName        string
    TotalBooks        int
    OwnedBooks        int
    CompletedBooks    int
    CompletionRate    float64
}

type YearlyReadingStats struct {
    Year              int
    BooksCompleted    int
    PagesRead         int
}
```

---

## Schema PostgreSQL - Books Catalog Service

```sql
-- Enum pour les langues
CREATE TYPE language_type AS ENUM ('FR', 'EN');

-- Table des séries de livres
CREATE TABLE book_series (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(500) NOT NULL,
    name_translated VARCHAR(500),
    description TEXT,
    book_count INTEGER NOT NULL DEFAULT 0,
    cover_image_url VARCHAR(1000),
    created_at TIMESTAMP NOT NULL DEFAULT NOW(),
    
    UNIQUE(name)
);

-- Index
CREATE INDEX idx_book_series_name ON book_series(name);

-- Table des livres (catalogue de référence)
CREATE TABLE books (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    
    -- Identification
    title VARCHAR(500) NOT NULL,
    title_original VARCHAR(500),
    author VARCHAR(500) NOT NULL,
    co_authors TEXT[],  -- Array PostgreSQL
    
    -- Série
    series_id UUID REFERENCES book_series(id) ON DELETE SET NULL,
    series_order INTEGER,
    
    -- Publication
    isbn VARCHAR(20),  -- ISBN-10 ou ISBN-13
    publication_year INTEGER,
    publisher VARCHAR(255),
    page_count INTEGER,
    language language_type NOT NULL,
    
    -- Contenu
    cover_image_url VARCHAR(1000),
    description TEXT,
    
    -- Métadonnées
    created_at TIMESTAMP NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMP NOT NULL DEFAULT NOW(),
    
    -- Contraintes
    CHECK (page_count IS NULL OR page_count > 0),
    CHECK (publication_year IS NULL OR (publication_year >= 1900 AND publication_year <= EXTRACT(YEAR FROM NOW()) + 2)),
    CHECK (series_order IS NULL OR series_id IS NOT NULL)
);

-- Indexes pour performances
CREATE INDEX idx_books_title ON books(title);
CREATE INDEX idx_books_author ON books(author);
CREATE INDEX idx_books_series ON books(series_id);
CREATE INDEX idx_books_isbn ON books(isbn) WHERE isbn IS NOT NULL;
CREATE INDEX idx_books_year ON books(publication_year) WHERE publication_year IS NOT NULL;
CREATE INDEX idx_books_language ON books(language);

-- Full-text search
CREATE INDEX idx_books_title_trgm ON books USING gin(title gin_trgm_ops);
CREATE INDEX idx_books_author_trgm ON books USING gin(author gin_trgm_ops);
CREATE INDEX idx_books_description_trgm ON books USING gin(description gin_trgm_ops);

-- Extension nécessaire pour full-text
CREATE EXTENSION IF NOT EXISTS pg_trgm;

-- Trigger pour mettre à jour updated_at
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ language 'plpgsql';

CREATE TRIGGER update_books_updated_at BEFORE UPDATE ON books
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
```

---

## Schema PostgreSQL - Reading Management Service

```sql
-- Enum pour les statuts de lecture
CREATE TYPE reading_status_type AS ENUM ('TO_READ', 'READING', 'COMPLETED');

-- Table des livres utilisateur
CREATE TABLE user_books (
    user_id UUID NOT NULL,
    book_id UUID NOT NULL,
    
    -- Possession
    owned BOOLEAN NOT NULL DEFAULT false,
    
    -- Progression de lecture
    reading_status reading_status_type NOT NULL DEFAULT 'TO_READ',
    rating INTEGER,
    notes TEXT,
    
    -- Dates
    started_at TIMESTAMP,
    completed_at TIMESTAMP,
    added_at TIMESTAMP NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMP NOT NULL DEFAULT NOW(),
    
    PRIMARY KEY (user_id, book_id),
    
    -- Contraintes
    CHECK (rating IS NULL OR (rating >= 1 AND rating <= 5)),
    CHECK (completed_at IS NULL OR started_at IS NULL OR completed_at >= started_at)
);

-- Indexes pour performances
CREATE INDEX idx_user_books_user ON user_books(user_id);
CREATE INDEX idx_user_books_owned ON user_books(user_id, owned);
CREATE INDEX idx_user_books_status ON user_books(user_id, reading_status);
CREATE INDEX idx_user_books_rating ON user_books(user_id, rating) WHERE rating IS NOT NULL;
CREATE INDEX idx_user_books_completed ON user_books(user_id, completed_at) WHERE completed_at IS NOT NULL;

-- Trigger pour mettre à jour updated_at
CREATE TRIGGER update_user_books_updated_at BEFORE UPDATE ON user_books
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- Note : book_id référence books-catalog-service.books mais pas de FK car microservices séparés
-- La cohérence est assurée au niveau applicatif
```

---

## API REST Contracts

### Books Catalog Service - `/api/v1/books`

#### GET `/api/v1/books`
Récupérer la liste des livres avec filtres

**Query Parameters** :
- `search` : Recherche full-text (titre, auteur, description)
- `title` : Recherche partielle sur le titre
- `author` : Recherche partielle sur l'auteur
- `seriesId` : UUID de la série
- `language` : FR | EN
- `yearFrom` : Année minimum
- `yearTo` : Année maximum
- `limit` : Nombre de résultats (default: 50, max: 200)
- `offset` : Pagination
- `orderBy` : title | author | year | series
- `orderDir` : ASC | DESC

**Response** :
```json
{
  "data": [
    {
      "id": "uuid",
      "title": "Homeland",
      "titleOriginal": null,
      "author": "R.A. Salvatore",
      "coAuthors": [],
      "series": {
        "id": "uuid",
        "name": "The Dark Elf Trilogy",
        "order": 1
      },
      "isbn": "978-0786939534",
      "publicationYear": 1990,
      "publisher": "Wizards of the Coast",
      "pageCount": 352,
      "language": "EN",
      "coverImageUrl": "https://example.com/covers/homeland.jpg",
      "description": "The legendary origin story of Drizzt Do'Urden...",
      "createdAt": "2026-04-23T10:00:00Z"
    }
  ],
  "pagination": {
    "total": 150,
    "limit": 50,
    "offset": 0
  }
}
```

#### GET `/api/v1/books/:id`
Récupérer un livre par ID

**Response** : Identique à l'objet dans `data[]` ci-dessus

#### GET `/api/v1/books/series`
Récupérer toutes les séries

**Response** :
```json
{
  "data": [
    {
      "id": "uuid",
      "name": "The Legend of Drizzt",
      "nameTranslated": "La Légende de Drizzt",
      "description": "The complete saga of Drizzt Do'Urden...",
      "bookCount": 39,
      "coverImageUrl": "https://example.com/series/drizzt.jpg",
      "createdAt": "2026-04-23T10:00:00Z"
    }
  ]
}
```

#### GET `/api/v1/books/series/:id`
Récupérer une série avec ses livres

**Response** :
```json
{
  "series": {
    "id": "uuid",
    "name": "The Dark Elf Trilogy",
    "bookCount": 3
  },
  "books": [
    {
      "id": "uuid",
      "title": "Homeland",
      "seriesOrder": 1
    },
    {
      "id": "uuid",
      "title": "Exile",
      "seriesOrder": 2
    },
    {
      "id": "uuid",
      "title": "Sojourn",
      "seriesOrder": 3
    }
  ]
}
```

#### GET `/api/v1/books/statistics`
Statistiques du catalogue

**Response** :
```json
{
  "totalBooks": 150,
  "totalSeries": 25,
  "totalAuthors": 30,
  "byLanguage": {
    "FR": 80,
    "EN": 70
  },
  "topAuthors": [
    {
      "name": "R.A. Salvatore",
      "bookCount": 50
    }
  ]
}
```

---

### Reading Management Service - `/api/v1/reading`

#### POST `/api/v1/reading/books/:bookId`
Ajouter un livre à la collection

**Request Body** :
```json
{
  "owned": true,
  "readingStatus": "TO_READ"
}
```

**Response** :
```json
{
  "bookId": "uuid",
  "owned": true,
  "readingStatus": "TO_READ",
  "addedAt": "2026-04-23T15:30:00Z"
}
```

#### DELETE `/api/v1/reading/books/:bookId`
Retirer un livre de la collection

**Response** : `204 No Content`

#### PATCH `/api/v1/reading/books/:bookId/ownership`
Mettre à jour la possession (owned/wishlist)

**Request Body** :
```json
{
  "owned": true
}
```

**Response** :
```json
{
  "bookId": "uuid",
  "owned": true,
  "updatedAt": "2026-04-23T15:35:00Z"
}
```

#### PATCH `/api/v1/reading/books/:bookId/status`
Mettre à jour le statut de lecture

**Request Body** :
```json
{
  "status": "READING",
  "startedAt": "2026-04-23T08:00:00Z"
}
```

**Response** :
```json
{
  "bookId": "uuid",
  "readingStatus": "READING",
  "startedAt": "2026-04-23T08:00:00Z",
  "updatedAt": "2026-04-23T15:40:00Z"
}
```

#### PATCH `/api/v1/reading/books/:bookId/rating`
Noter un livre

**Request Body** :
```json
{
  "rating": 5,
  "notes": "Excellent premier tome de la trilogie!"
}
```

**Response** :
```json
{
  "bookId": "uuid",
  "rating": 5,
  "notes": "Excellent premier tome de la trilogie!",
  "updatedAt": "2026-04-23T15:45:00Z"
}
```

#### GET `/api/v1/reading/books`
Récupérer les livres de l'utilisateur

**Query Parameters** :
- `owned` : true | false
- `status` : TO_READ | READING | COMPLETED
- `seriesId` : UUID
- `ratingMin` : 1-5
- `ratingMax` : 1-5
- `limit`, `offset`, `orderBy`, `orderDir`

**Response** :
```json
{
  "data": [
    {
      "book": {
        "id": "uuid",
        "title": "Homeland",
        "author": "R.A. Salvatore",
        "coverImageUrl": "https://example.com/covers/homeland.jpg",
        "series": {
          "id": "uuid",
          "name": "The Dark Elf Trilogy",
          "order": 1
        }
      },
      "userBook": {
        "owned": true,
        "readingStatus": "COMPLETED",
        "rating": 5,
        "notes": "Excellent!",
        "startedAt": "2026-03-01T00:00:00Z",
        "completedAt": "2026-03-15T00:00:00Z",
        "addedAt": "2026-02-28T10:00:00Z"
      }
    }
  ],
  "pagination": {
    "total": 25,
    "limit": 50,
    "offset": 0
  }
}
```

#### GET `/api/v1/reading/statistics`
Statistiques de lecture de l'utilisateur

**Response** :
```json
{
  "totalBooks": 50,
  "ownedBooks": 30,
  "wishlistBooks": 20,
  
  "toReadCount": 15,
  "readingCount": 3,
  "completedCount": 12,
  "completionRate": 24.0,
  
  "averageRating": 4.3,
  "totalPagesRead": 4250,
  
  "seriesStats": [
    {
      "seriesId": "uuid",
      "seriesName": "The Dark Elf Trilogy",
      "totalBooks": 3,
      "ownedBooks": 3,
      "completedBooks": 3,
      "completionRate": 100.0
    }
  ],
  
  "yearlyStats": [
    {
      "year": 2026,
      "booksCompleted": 8,
      "pagesRead": 2800
    },
    {
      "year": 2025,
      "booksCompleted": 4,
      "pagesRead": 1450
    }
  ]
}
```

---

## User Stories

### US-BK-001: Consulter le catalogue
**En tant qu'** utilisateur,  
**Je veux** consulter le catalogue des livres Forgotten Realms  
**Afin de** découvrir les livres disponibles et les ajouter à ma collection

**Critères d'acceptation** :
- [ ] Je peux voir la liste de tous les livres
- [ ] Je peux filtrer par auteur, série, année
- [ ] Je peux rechercher par titre ou auteur
- [ ] Chaque livre affiche : titre, auteur, couverture, série
- [ ] Les livres sont paginés (50 par page)

### US-BK-002: Ajouter à ma collection
**En tant qu'** utilisateur,  
**Je veux** ajouter un livre à ma collection (possédé ou wishlist)  
**Afin de** suivre les livres que je possède ou souhaite acquérir

**Critères d'acceptation** :
- [ ] Je peux marquer un livre comme "possédé"
- [ ] Je peux marquer un livre comme "wishlist"
- [ ] Je peux basculer entre possédé/wishlist
- [ ] Le statut est sauvegardé immédiatement

### US-BK-003: Suivre ma progression de lecture
**En tant qu'** utilisateur,  
**Je veux** marquer un livre comme "à lire", "en cours" ou "lu"  
**Afin de** suivre ma progression de lecture

**Critères d'acceptation** :
- [ ] Je peux définir le statut : TO_READ / READING / COMPLETED
- [ ] Quand je marque "en cours", la date de début est enregistrée
- [ ] Quand je marque "lu", la date de fin est enregistrée
- [ ] Je peux voir mes livres filtrés par statut

### US-BK-004: Noter les livres
**En tant qu'** utilisateur,  
**Je veux** noter un livre de 1 à 5 étoiles  
**Afin de** garder une trace de mon appréciation

**Critères d'acceptation** :
- [ ] Je peux donner une note de 1 à 5 étoiles
- [ ] Je peux ajouter des notes textuelles
- [ ] Je peux modifier ma note ultérieurement
- [ ] Ma note moyenne est calculée automatiquement

### US-BK-005: Suivre les séries
**En tant qu'** utilisateur,  
**Je veux** voir les livres organisés par série  
**Afin de** suivre ma progression dans chaque saga

**Critères d'acceptation** :
- [ ] Les livres d'une série sont groupés
- [ ] L'ordre dans la série est affiché
- [ ] Je vois le % de complétion par série
- [ ] Je peux filtrer par série

### US-BK-006: Voir mes statistiques
**En tant qu'** utilisateur,  
**Je veux** voir mes statistiques de lecture  
**Afin de** mesurer ma progression et mes habitudes de lecture

**Critères d'acceptation** :
- [ ] Nombre de livres possédés vs wishlist
- [ ] Nombre de livres lus / en cours / à lire
- [ ] Note moyenne de mes livres
- [ ] Progression par série
- [ ] Livres lus par année
- [ ] Total de pages lues

---

## Frontend Components

### Pages

#### `/books` - Catalogue de livres
**Composants** :
- `BookCatalogPage` : Page principale
- `BookGrid` : Grille de cartes de livres
- `BookCard` : Carte individuelle (couverture, titre, auteur)
- `BookFilters` : Filtres (auteur, série, année, langue)
- `SearchBar` : Recherche full-text
- `Pagination` : Pagination des résultats

#### `/books/:id` - Détail d'un livre
**Composants** :
- `BookDetailPage` : Page de détail
- `BookHeader` : Image de couverture + infos principales
- `BookInfo` : Métadonnées (ISBN, année, éditeur, pages)
- `BookDescription` : Synopsis
- `BookSeriesInfo` : Informations sur la série
- `BookActions` : Actions (ajouter, statut, note)
- `UserBookStatus` : Statut utilisateur (possession, lecture, note)

#### `/books/series/:id` - Détail d'une série
**Composants** :
- `SeriesDetailPage` : Page série
- `SeriesHeader` : Nom, description, image
- `SeriesBookList` : Liste ordonnée des livres de la série
- `SeriesProgress` : Barre de progression (% lu)

#### `/my-books` - Ma bibliothèque
**Composants** :
- `MyBooksPage` : Page personnelle
- `BookTabs` : Onglets (Possédés / Wishlist / À lire / En cours / Lus)
- `BookList` : Liste avec statuts et notes
- `BookListItem` : Item avec actions rapides
- `QuickActions` : Actions rapides (changer statut, noter)

#### `/my-books/statistics` - Statistiques de lecture
**Composants** :
- `ReadingStatsPage` : Page statistiques
- `StatsOverview` : Vue d'ensemble (cartes de KPIs)
- `SeriesProgressChart` : Graphique par série
- `YearlyReadingChart` : Graphique annuel
- `ReadingGoals` : Objectifs de lecture (optionnel v2)

### Composants Réutilisables

- `BookCoverImage` : Image de couverture avec fallback
- `StarRating` : Composant d'affichage/saisie de note
- `ReadingStatusBadge` : Badge coloré pour statut
- `OwnershipToggle` : Toggle possédé/wishlist
- `SeriesBadge` : Badge série avec ordre
- `ProgressBar` : Barre de progression générique
- `StatCard` : Carte de statistique (KPI)

---

## Technical Considerations

### ISBN Lookup (Future Enhancement)

**API externes pour enrichissement automatique** :
- Open Library API : `https://openlibrary.org/api/books?bibkeys=ISBN:xxx`
- Google Books API : `https://www.googleapis.com/books/v1/volumes?q=isbn:xxx`
- Goodreads API (nécessite clé)

**Données récupérables** :
- Titre, auteur, description
- Année de publication, éditeur
- Nombre de pages
- URL de couverture
- ISBN-10 et ISBN-13

**Workflow** :
1. Utilisateur saisit ISBN
2. Appel API externe
3. Pré-remplissage du formulaire
4. Validation et sauvegarde

### Cover Images

**Options** :
1. **Upload manuel** : Utilisateur upload l'image
2. **URL externe** : Stockage du lien vers API externe
3. **CDN local** : Téléchargement et stockage en CDN

**Recommandation** : Commencer avec URL externe (Open Library), migrer vers CDN si nécessaire.

**Fallback** : Image par défaut si couverture manquante.

### Series Ordering

**Approches** :
1. **Ordre numérique simple** : 1, 2, 3...
2. **Ordre décimal** : 1.0, 1.5, 2.0 (permet insertion)
3. **String avec convention** : "01", "02", "03"

**Recommandation** : Ordre numérique simple (INTEGER) avec possibilité de réordonnancement.

### Data Import

**Sources potentielles** :
- CSV export depuis Goodreads
- Excel personnel
- API scraping (avec permissions)

**Format CSV recommandé** :
```csv
title,author,series,series_order,isbn,year,publisher,pages,language
Homeland,R.A. Salvatore,The Dark Elf Trilogy,1,978-0786939534,1990,Wizards of the Coast,352,EN
```

---

## Tests TDD

### Tests Books Catalog Service

#### Tests Unitaires (Domain)
- ✅ Création d'un Book valide
- ✅ Validation ISBN-10 et ISBN-13
- ✅ Validation année de publication
- ✅ Validation rating (1-5)
- ✅ Value Objects (Language, ISBN, ReadingStatus, Rating)

#### Tests d'Intégration (Repository)
- ✅ CRUD books dans PostgreSQL
- ✅ CRUD book series
- ✅ Recherche full-text (titre, auteur, description)
- ✅ Filtres multiples (auteur, série, année, langue)
- ✅ Pagination et tri
- ✅ FindByISBN
- ✅ FindBySeries avec ordre

#### Tests API (Handlers)
- ✅ GET /books avec filtres
- ✅ GET /books/:id
- ✅ GET /books/series
- ✅ GET /books/series/:id
- ✅ GET /books/statistics
- ✅ Validation des paramètres
- ✅ Codes HTTP appropriés
- ✅ Gestion erreurs (404, 400, 500)

### Tests Reading Management Service

#### Tests Unitaires (Domain)
- ✅ Ajout d'un livre à la collection
- ✅ Changement de statut de lecture
- ✅ Notation d'un livre
- ✅ Validation contraintes (dates, rating)
- ✅ Domain Events (BookAdded, StatusChanged, BookCompleted, BookRated)

#### Tests d'Intégration (Repository)
- ✅ CRUD user_books
- ✅ Filtres (owned, status, rating)
- ✅ Calcul statistiques globales
- ✅ Calcul statistiques par série
- ✅ Calcul statistiques annuelles
- ✅ Mise à jour dates (startedAt, completedAt)

#### Tests API (Handlers)
- ✅ POST /reading/books/:id (add to collection)
- ✅ DELETE /reading/books/:id
- ✅ PATCH /reading/books/:id/ownership
- ✅ PATCH /reading/books/:id/status
- ✅ PATCH /reading/books/:id/rating
- ✅ GET /reading/books avec filtres
- ✅ GET /reading/statistics
- ✅ Validation des request bodies
- ✅ Gestion erreurs

#### Tests E2E
- ✅ Workflow complet : Ajouter livre → Marquer "en cours" → Noter → Marquer "lu" → Consulter stats
- ✅ Progression série : Ajouter livres d'une série → Marquer lus progressivement → Vérifier complétion série

---

## Integration Points

### Avec l'existant Collectoria

#### Authentication & Authorization
- **Réutilisation JWT** : Même système d'authentification que cards
- **User ID** : Même UUID utilisateur pour user_books
- **Middleware** : Réutiliser les middlewares d'auth existants

#### Rate Limiting
- **Configuration identique** : Même rate limiter que catalog/collection services
- **Endpoints à limiter** :
  - POST /reading/books (100 req/min)
  - PATCH /reading/* (200 req/min)
  - GET /books (500 req/min)

#### Activity Tracking
- **Events Kafka** : Publier sur mêmes topics `user.activity`
- **Events spécifiques** :
  - `book.added`
  - `book.reading_started`
  - `book.completed`
  - `book.rated`

#### Statistics & Analytics
- **Agrégation globale** : Intégrer stats books dans dashboard global
- **Homepage** : Ajouter widget "Lectures en cours" et "Livres lus cette année"

---

## Effort Estimation

### Backend (Go)

**Books Catalog Service** :
- Domain layer (entities, value objects) : 4h
- Repository layer (PostgreSQL) : 6h
- API handlers (REST endpoints) : 4h
- Tests (unit + integration) : 6h
- **Total** : 20h (2,5 jours)

**Reading Management Service** :
- Domain layer + events : 4h
- Repository layer : 6h
- API handlers : 4h
- Tests : 6h
- **Total** : 20h (2,5 jours)

**Database & Migrations** :
- Schemas PostgreSQL : 2h
- Migrations : 1h
- Seed data (livres exemple) : 2h
- **Total** : 5h (0,5 jour)

**Kafka Integration** :
- Event producers : 2h
- Tests : 2h
- **Total** : 4h (0,5 jour)

**Backend Total** : 49h (~6 jours)

### Frontend (Next.js)

**Pages** :
- `/books` (catalog) : 6h
- `/books/:id` (detail) : 4h
- `/books/series/:id` : 3h
- `/my-books` (library) : 6h
- `/my-books/statistics` : 5h
- **Total pages** : 24h (3 jours)

**Components** :
- Réutilisables (BookCard, StarRating, StatusBadge, etc.) : 8h
- Forms & Actions : 4h
- **Total components** : 12h (1,5 jour)

**API Integration** :
- API client setup : 2h
- React Query hooks : 4h
- Error handling : 2h
- **Total integration** : 8h (1 jour)

**Tests** :
- Component tests : 6h
- E2E tests : 4h
- **Total tests** : 10h (1,25 jour)

**Frontend Total** : 54h (~7 jours)

### DevOps & Documentation

**DevOps** :
- Docker setup : 2h
- CI/CD pipelines : 2h
- **Total** : 4h (0,5 jour)

**Documentation** :
- API documentation : 3h
- User guide : 2h
- **Total** : 5h (0,5 jour)

---

## Grand Total Estimation

**Backend** : 6 jours  
**Frontend** : 7 jours  
**DevOps & Docs** : 1 jour

**Total** : **14 jours** (avec buffer)

**Estimation initiale demandée** : 2-3 jours → **Sous-estimé**

**Estimation réaliste** : **2-3 semaines** pour implémentation complète avec tests et documentation.

---

## Prochaines Étapes

1. ✅ Validation de la spécification (actuelle)
2. 🔜 Validation des user stories avec l'utilisateur
3. 🔜 Seed data : Créer un catalogue initial de livres FR (50-100 livres)
4. 🔜 Setup PostgreSQL schemas (Books Catalog + Reading Management)
5. 🔜 Backend : Implémentation TDD (Books Catalog Service)
6. 🔜 Backend : Implémentation TDD (Reading Management Service)
7. 🔜 Frontend : Pages catalog + detail
8. 🔜 Frontend : Ma bibliothèque + statistiques
9. 🔜 Integration Kafka (events)
10. 🔜 Tests E2E complets
11. 🔜 Documentation API (OpenAPI/Swagger)

---

## Annexes

### Exemples de Séries Forgotten Realms

**Populaires** :
- The Legend of Drizzt (39 livres) - R.A. Salvatore
- The Dark Elf Trilogy (3 livres) - R.A. Salvatore
- The Icewind Dale Trilogy (3 livres) - R.A. Salvatore
- The Cleric Quintet (5 livres) - R.A. Salvatore
- The Harpers (14 livres) - Auteurs variés
- The Avatar Series (3 livres) - Auteurs variés
- Elminster Series (7 livres) - Ed Greenwood

### Exemple de Seed Data (JSON)

```json
[
  {
    "title": "Homeland",
    "author": "R.A. Salvatore",
    "series": "The Dark Elf Trilogy",
    "seriesOrder": 1,
    "isbn": "978-0786939534",
    "publicationYear": 1990,
    "publisher": "Wizards of the Coast",
    "pageCount": 352,
    "language": "EN",
    "description": "Drizzt Do'Urden's origin story in the dark city of Menzoberranzan."
  },
  {
    "title": "Exile",
    "author": "R.A. Salvatore",
    "series": "The Dark Elf Trilogy",
    "seriesOrder": 2,
    "isbn": "978-0786939541",
    "publicationYear": 1990,
    "publisher": "Wizards of the Coast",
    "pageCount": 320,
    "language": "EN"
  }
]
```

---

**Fin de la spécification**
