# Migration 011: Séparation des collections en tables dédiées

## Date
2026-04-27

## Contexte

Avant cette migration, les deux collections "Royaumes Oubliés" et "D&D 5e" étaient stockées dans une seule table `books` avec un filtre par `collection_id`. Cette architecture était inadéquate car :

1. **Schéma hybride** : Certaines colonnes (name_en, name_fr, edition) n'étaient utilisées que pour D&D 5e
2. **Logique conditionnelle** : Le code devait constamment vérifier la collection pour savoir quels champs utiliser
3. **Modèle de possession différent** : 
   - Royaumes Oubliés : possession simple (is_owned)
   - D&D 5e : possession bilingue (owned_en, owned_fr)

## Solution : Séparation en tables dédiées

### Nouvelles tables

#### 1. forgottenrealms_novels
```sql
- id UUID PRIMARY KEY
- number VARCHAR(10) NOT NULL
- title VARCHAR(255) NOT NULL
- author VARCHAR(255) NOT NULL
- publication_date DATE NOT NULL
- book_type VARCHAR(50) NOT NULL
- created_at TIMESTAMP NOT NULL
- updated_at TIMESTAMP NOT NULL
```

#### 2. user_forgottenrealms_novels
```sql
- id UUID PRIMARY KEY
- user_id UUID NOT NULL
- novel_id UUID NOT NULL REFERENCES forgottenrealms_novels(id)
- is_owned BOOLEAN NOT NULL DEFAULT false
- created_at TIMESTAMP NOT NULL
- updated_at TIMESTAMP NOT NULL
- UNIQUE(user_id, novel_id)
```

#### 3. dnd5_books
```sql
- id UUID PRIMARY KEY
- number VARCHAR(10) NOT NULL
- name_en VARCHAR(255) NOT NULL
- name_fr VARCHAR(255) NULL
- book_type VARCHAR(50) NOT NULL
- created_at TIMESTAMP NOT NULL
- updated_at TIMESTAMP NOT NULL
```

#### 4. user_dnd5_books
```sql
- id UUID PRIMARY KEY
- user_id UUID NOT NULL
- book_id UUID NOT NULL REFERENCES dnd5_books(id)
- owned_en BOOLEAN NULL
- owned_fr BOOLEAN NULL
- created_at TIMESTAMP NOT NULL
- updated_at TIMESTAMP NOT NULL
- UNIQUE(user_id, book_id)
```

### Migration des données

**Résultats** :
- ✅ 94 romans Royaumes Oubliés migrés
- ✅ 41 possessions Royaumes Oubliés migrées
- ✅ 53 livres D&D 5e migrés
- ✅ 36 possessions D&D 5e migrées

### Tables supprimées
- ❌ `books` (table générique)
- ❌ `user_books` (table générique)

## Modifications du code

### Domaines créés

1. **forgottenrealms_novel.go**
   - ForgottenRealmsNovel
   - UserForgottenRealmsNovel
   - ForgottenRealmsNovelWithOwnership

2. **dnd5_book.go**
   - DnD5Book
   - UserDnD5Book
   - DnD5BookWithOwnership

3. **forgottenrealms_novel_filter.go**
   - ForgottenRealmsNovelFilter
   - ForgottenRealmsNovelPage

4. **dnd5_book_filter.go**
   - DnD5BookFilter
   - DnD5BookPage

### Repositories créés

1. **ForgottenRealmsNovelRepository**
   - GetNovelByID(ctx, id)
   - GetUserNovel(ctx, userID, novelID)
   - UpdateUserNovel(ctx, userID, novelID, isOwned)
   - GetNovelsCatalog(ctx, userID, filter)

2. **DnD5BookRepository**
   - GetBookByID(ctx, id)
   - GetUserBook(ctx, userID, bookID)
   - UpdateBookOwnership(ctx, userID, bookID, ownedEn, ownedFr)
   - GetBooksCatalog(ctx, userID, filter)

### Services créés

1. **ForgottenRealmsNovelService**
   - GetNovelsCatalog(ctx, userID, filter)
   - ToggleNovelPossession(ctx, userID, novelID, isOwned)

2. **DnD5BookService**
   - GetBooksCatalog(ctx, userID, filter)
   - UpdateBookOwnership(ctx, userID, bookID, ownedEn, ownedFr)

### Handlers créés

1. **ForgottenRealmsNovelHandler**
   - GET /api/v1/forgottenrealms/novels
   - PATCH /api/v1/forgottenrealms/novels/:id/possession

2. **DnD5BookHandler**
   - GET /api/v1/dnd5/books
   - PATCH /api/v1/dnd5/books/:id/ownership

### Fichiers supprimés

- ❌ internal/domain/book.go
- ❌ internal/domain/book_filter.go
- ❌ internal/domain/book_repository.go
- ❌ internal/infrastructure/postgres/book_repository.go
- ❌ internal/infrastructure/postgres/book_repository_test.go
- ❌ internal/application/book_service.go
- ❌ internal/application/book_service_test.go
- ❌ internal/infrastructure/http/handlers/book_handler.go

## Nouvelles routes API

### Royaumes Oubliés

**GET /api/v1/forgottenrealms/novels**
- Query params : search, author, book_type, series (principal/hors-serie), is_owned, page, limit
- Response : { novels: [], pagination: {} }

**PATCH /api/v1/forgottenrealms/novels/:id/possession**
- Body : { is_owned: boolean }
- Response : { id, number, title, author, publication_date, book_type, is_owned, ... }

### D&D 5e

**GET /api/v1/dnd5/books**
- Query params : search, book_type, owned_version (en/fr/both/none/any), sort_by (name_en/name_fr/number), page, limit
- Response : { books: [], pagination: {} }

**PATCH /api/v1/dnd5/books/:id/ownership**
- Body : { owned_en?: boolean, owned_fr?: boolean }
- Response : { id, number, name_en, name_fr, book_type, owned_en, owned_fr, ... }

## Routes anciennes supprimées

- ❌ GET /api/v1/books
- ❌ PATCH /api/v1/books/:id/possession
- ❌ PATCH /api/v1/books/:id/ownership

## Tests

Tous les endpoints ont été testés avec succès :

1. ✅ GET /api/v1/forgottenrealms/novels (pagination, filtres)
2. ✅ PATCH /api/v1/forgottenrealms/novels/:id/possession
3. ✅ GET /api/v1/dnd5/books (pagination, filtres, tri)
4. ✅ PATCH /api/v1/dnd5/books/:id/ownership

## Bénéfices

1. **Clarté architecturale** : Chaque collection a sa propre table et son domaine dédié
2. **Type safety** : Plus de champs nullable inutiles
3. **Séparation des responsabilités** : Services, repositories et handlers spécialisés
4. **Filtres spécifiques** : Chaque collection peut avoir ses propres filtres (série pour Royaumes Oubliés, owned_version pour D&D 5e)
5. **Évolutivité** : Ajouter une nouvelle collection ne nécessite plus de modifier les tables existantes

## Migration Frontend nécessaire

Le frontend devra être mis à jour pour utiliser les nouvelles routes :

1. Page `/forgottenrealms` → appeler `/api/v1/forgottenrealms/novels`
2. Page `/dnd5` → appeler `/api/v1/dnd5/books`
3. Mettre à jour les hooks/services pour utiliser les nouveaux endpoints
4. Adapter les composants pour les nouvelles structures de réponse

## Rétrocompatibilité

⚠️ **BREAKING CHANGE** : Cette migration supprime les anciennes routes `/api/v1/books`. Le frontend devra être mis à jour en parallèle.
