# Changelog - Support D&D 5e avec Possession Bilingue

**Date**: 2026-04-27  
**Migration**: 010  
**Implémentation**: Backend Collection Management

## Résumé

Adaptation du backend pour supporter la collection D&D 5e avec possession bilingue (owned_en, owned_fr) en plus de la collection Royaumes Oubliés existante (is_owned).

## Modifications

### 1. Domain Layer (internal/domain/)

#### book.go
- **Book struct** : Ajout des champs nullable pour D&D 5e
  - `NameEn *string` : Titre en anglais
  - `NameFr *string` : Titre en français
  - `Edition *string` : Edition (ex: "D&D 5")

- **BookWithOwnership struct** : Ajout des champs de possession bilingue
  - `OwnedEn *bool` : Possession version anglaise
  - `OwnedFr *bool` : Possession version française

- **UserBook struct** : Ajout des champs de possession bilingue
  - `OwnedEn *bool` : Possession version anglaise
  - `OwnedFr *bool` : Possession version française

- **Nouvelle structure OwnershipUpdate** : Pour dispatcher les mises à jour selon la collection
  ```go
  type OwnershipUpdate struct {
      IsOwned *bool // Pour Royaumes Oubliés
      OwnedEn *bool // Pour D&D 5e
      OwnedFr *bool // Pour D&D 5e
  }
  ```

#### book_filter.go
- **BookFilter struct** : Ajout du filtre par collection
  - `CollectionID *string` : UUID de la collection à filtrer

#### book_repository.go
- **Nouvelle méthode** : `UpdateBookOwnership(ctx, userID, bookID, ownership)` avec dispatch automatique selon la collection
- **Deprecated** : `UpdateUserBook()` conservée pour rétro-compatibilité

### 2. Infrastructure Layer - Postgres (internal/infrastructure/postgres/)

#### book_repository.go

**GetBookByID()**
- Ajout des champs `name_en`, `name_fr`, `edition` dans le SELECT

**GetUserBook()**
- Ajout des champs `owned_en`, `owned_fr` dans le SELECT

**UpdateBookOwnership()** (nouvelle méthode)
- Détecte automatiquement la collection du livre
- Dispatch selon la collection :
  - **Royaumes Oubliés** (`22222222-2222-2222-2222-222222222222`) : UPDATE `is_owned`
  - **D&D 5e** (`33333333-3333-3333-3333-333333333333`) : UPDATE `owned_en` et `owned_fr`
- Validation : rejette les champs incompatibles avec la collection

**GetBooksCatalog()**
- **Nouveau filtre** : `WHERE collection_id = $X` si `filter.CollectionID` fourni
- Ajout des champs `name_en`, `name_fr`, `edition`, `owned_en`, `owned_fr` dans le SELECT
- Gestion des NULL pour les champs nullable

### 3. Application Layer (internal/application/)

#### book_service.go

**UpdateBookOwnership()** (nouvelle méthode)
- Récupère les infos du livre et détecte sa collection
- Valide que les champs fournis correspondent à la collection :
  - **Royaumes Oubliés** : `is_owned` requis, `owned_en`/`owned_fr` interdits
  - **D&D 5e** : `owned_en` ou `owned_fr` requis, `is_owned` interdit
- Appelle `bookRepo.UpdateBookOwnership()` avec dispatch automatique
- Enregistre l'activité (best effort)
- Retourne l'état mis à jour

**ToggleBookPossession()** : Marquée DEPRECATED mais conservée pour rétro-compatibilité

### 4. HTTP Layer (internal/infrastructure/http/)

#### handlers/book_handler.go

**BookResponse struct**
- Ajout des champs optionnels pour D&D 5e :
  - `NameEn *string`
  - `NameFr *string`
  - `Edition *string`
  - `OwnedEn *bool`
  - `OwnedFr *bool`

**UpdateBookOwnershipRequest struct** (nouvelle)
```go
type UpdateBookOwnershipRequest struct {
    IsOwned *bool // Pour Royaumes Oubliés
    OwnedEn *bool // Pour D&D 5e
    OwnedFr *bool // Pour D&D 5e
}
```

**GetBooks()**
- **Nouveau query param** : `collection_id` (UUID)
- Validation UUID
- Passe le filtre au service
- Retourne les nouveaux champs dans la réponse

**UpdateBookOwnership()** (nouveau handler)
- Parse le body avec les 3 champs optionnels
- Valide qu'au moins un champ est fourni
- Appelle `service.UpdateBookOwnership()`
- Gère les erreurs de validation (HTTP 400)
- Retourne le livre mis à jour avec tous les champs

#### server.go
- **Route modifiée** : `PATCH /books/{id}/possession` pointe maintenant vers `UpdateBookOwnership()`

### 5. Tests

#### test_dnd5_endpoints.sh
Script de test manuel avec curl pour valider :
1. Login et récupération du token
2. GET /books sans filtre (tous les livres)
3. GET /books avec `collection_id=22222222...` (Royaumes Oubliés)
4. GET /books avec `collection_id=33333333...` (D&D 5e)
5. PATCH livre D&D 5e avec `{"owned_en": true, "owned_fr": false}`
6. PATCH livre Royaumes Oubliés avec `{"is_owned": true}`
7. Validation : PATCH owned_en sur livre RO (doit échouer HTTP 400)
8. Validation : PATCH is_owned sur livre D&D (doit échouer HTTP 400)

#### book_repository_test.go
Tests unitaires pour :
- `TestUpdateBookOwnership_RoyaumesOublies` : Validation logique RO
- `TestUpdateBookOwnership_DnD5e` : Validation logique D&D 5e
- `TestGetBooksCatalog_CollectionFilter` : Filtre par collection_id

## API Changes

### GET /api/v1/books

**Nouveau query parameter** :
- `collection_id` (string, optional) : UUID de la collection à filtrer

**Exemple** :
```bash
GET /api/v1/books?collection_id=33333333-3333-3333-3333-333333333333&limit=10
```

**Réponse** (nouveaux champs) :
```json
{
  "books": [
    {
      "id": "uuid",
      "collection_id": "33333333-3333-3333-3333-333333333333",
      "number": "PHB2014",
      "title": "Player's Handbook - 2014",
      "name_en": "Player's Handbook - 2014",
      "name_fr": "Manuel des joueurs - 2014",
      "author": "Wizards of the Coast",
      "edition": "D&D 5",
      "book_type": "Core Rules",
      "is_owned": false,
      "owned_en": true,
      "owned_fr": false,
      "created_at": "...",
      "updated_at": "..."
    }
  ]
}
```

### PATCH /api/v1/books/:id/possession

**Body pour Royaumes Oubliés** :
```json
{
  "is_owned": true
}
```

**Body pour D&D 5e** :
```json
{
  "owned_en": true,
  "owned_fr": false
}
```

**Validation** :
- Royaumes Oubliés : `is_owned` requis, `owned_en`/`owned_fr` interdits → HTTP 400
- D&D 5e : `owned_en` ou `owned_fr` requis, `is_owned` interdit → HTTP 400

## Compatibilité

### Rétro-compatibilité
✅ Les endpoints existants continuent de fonctionner pour Royaumes Oubliés
✅ Le frontend existant n'est pas impacté (nouveaux champs omis si null)

### Breaking Changes
❌ Aucun - le nouveau champ `collection_id` est optionnel

## Migration Database

**Fichier** : `migrations/010_add_dnd5_collection.sql`

- Ajout des colonnes `name_en`, `name_fr`, `edition` dans `books`
- Ajout des colonnes `owned_en`, `owned_fr` dans `user_books`
- Création de la collection D&D 5e avec UUID `33333333-3333-3333-3333-333333333333`
- Import de 53 livres D&D 5e officiels
- Insertion de 36 possessions bilingues pour l'utilisateur de dev

## Testing

### Tests manuels
```bash
# 1. Démarrer le backend
cd backend/collection-management
go run cmd/api/main.go

# 2. Lancer le script de test
./test_dnd5_endpoints.sh
```

### Tests unitaires
```bash
cd backend/collection-management
go test ./internal/infrastructure/postgres -v
```

### Tests d'intégration
```bash
# Avec PostgreSQL en cours d'exécution
go test ./internal/infrastructure/postgres -v -short=false
```

## Métriques

- **Livres Royaumes Oubliés** : 94
- **Livres D&D 5e** : 53
- **Total** : 147
- **Collections actives** : 2

## Prochaines Étapes

1. ✅ Backend adapté avec support bilingue
2. ⏳ Frontend : Adapter l'UI pour afficher les champs D&D 5e
3. ⏳ Frontend : Composant de toggle bilingue (FR/EN) pour D&D 5e
4. ⏳ Tests E2E : Scénarios complets utilisateur

## Notes Techniques

- Les pointeurs (`*bool`, `*string`) sont utilisés pour gérer les NULL en base
- Le dispatch collection est fait via UUID hardcodé (pattern acceptable pour 2 collections fixes)
- L'activité est enregistrée en "best effort" (ne bloque pas la mise à jour)
- Les indexes sur `edition`, `book_type`, `owned_en`, `owned_fr` optimisent les requêtes de filtrage

## Auteur

Agent Backend - Collectoria  
Date: 2026-04-27
