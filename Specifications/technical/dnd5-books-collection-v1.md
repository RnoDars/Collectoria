# Spécification Technique — Collection Livres D&D 5e

**Version** : 1.2  
**Date** : 2026-04-26  
**Auteur** : Agent Spécifications  
**Statut** : Brouillon v1.2 — possession bilingue (EN/FR) intégrée

---

## Changelog

| Version | Date | Auteur | Modifications |
|---|---|---|---|
| 1.0 | 2026-04-26 | Agent Spécifications | Version initiale |
| 1.1 | 2026-04-26 | Agent Spécifications | Modèle de données simplifié (données réelles disponibles) |
| 1.2 | 2026-04-26 | Agent Spécifications | Possession bilingue : `owned_en` / `owned_fr` remplace `is_owned` pour D&D 5 |

---

## Table des matières

1. [Vue d'ensemble](#1-vue-densemble)
2. [Modèle de données](#2-modèle-de-données)
3. [Migrations SQL](#3-migrations-sql)
4. [Backend — Endpoints REST](#4-backend--endpoints-rest)
5. [Frontend — Pages et composants](#5-frontend--pages-et-composants)
6. [Seed de données](#6-seed-de-données)
7. [Critères d'acceptation](#7-critères-dacceptation)

---

## 1. Vue d'ensemble

### Objectif

Ajouter une deuxième collection de livres dans Collectoria : les **livres officiels de Dungeons & Dragons 5ème édition** publiés par Wizards of the Coast. Un utilisateur pourra consulter le catalogue, filtrer par catégorie, et marquer les ouvrages qu'il possède — en version anglaise, française, ou les deux.

### Périmètre de la v1

- Catalogue statique des livres D&D 5e (données de seed)
- Suivi de possession bilingue par livre (toggle EN / FR indépendants)
- Filtrage par catégorie et par statut de possession
- Statistiques de complétion globale

Hors périmètre v1 : images de couverture, comparaison d'éditions, listes de souhaits, notes personnelles.

### Différences clés avec la collection Royaumes Oubliés

| Dimension | Royaumes Oubliés | D&D 5e |
|---|---|---|
| Nature du contenu | Romans de fiction | Livres de règles, aventures, suppléments |
| Champ auteur | Auteur individuel ou duo | Toujours "Wizards of the Coast" (collectif) |
| Champ numéro | Séquentiel (1–84, HS1–HS10) | Absent — pas de numérotation officielle |
| Organisation | Série principale + hors-série | 6 types : Core Rules / Supplément de règles / Setting / Campagnes / Recueil d'aventures / Starter Set |
| Édition | Unique (collection Fleuve Noir) | Fixe `"D&D 5"` pour tous les livres |
| Nombre de pages | Non stocké | Non disponible dans les données sources |
| ISBN | Non stocké | Non disponible dans les données sources |
| **Possession** | **`is_owned` (booléen simple)** | **`owned_en` + `owned_fr` (deux booléens)** |

---

## 2. Modèle de données

### 2.1 Décision architecturale : extension du modèle Book existant

**Choix retenu : réutiliser la table `books` avec des colonnes supplémentaires.**

**Justification :**

La table `books` et les tables `user_books`, ainsi que toute la couche applicative (repository, service, handler, frontend), sont déjà opérationnels. La distinction entre les deux collections se fait via le champ `collection_id` (UUID), qui existe déjà. Les livres D&D ont simplement des métadonnées supplémentaires que les romans Royaumes Oubliés n'ont pas.

Créer une table `dnd_books` séparée impliquerait de dupliquer le handler, le service, le repository et les composants React, ce qui viole le principe DRY et alourdit la maintenance. Les colonnes supplémentaires (`book_type`, `edition`, `name_en`, `name_fr`) peuvent être `NULL` pour les entrées Royaumes Oubliés sans impacter leur fonctionnement.

**Alternative rejetée : table séparée `dnd_books`.**  
Rejetée car elle double le code sans apporter de valeur : même logique de possession, mêmes patterns d'accès, même interface utilisateur de base.

### 2.2 Champs ajoutés à la table `books`

Les données disponibles pour les livres D&D 5 sont uniquement : `name_fr`, `name_en`, `edition` (fixe `"D&D 5"`) et `book_type` (enum 6 valeurs). Les champs `isbn`, `page_count` et `cover_url` ne sont pas disponibles et ne sont pas ajoutés.

> **Note sur le modèle actuel** : La table `books` existante (migration 005) possède un champ `title` utilisé pour Royaumes Oubliés. Les livres D&D 5 ont deux titres (`name_en` et `name_fr`). La migration 010 ajoute `name_en` et `name_fr` comme colonnes distinctes et conserve `title` pour Royaumes Oubliés. Pour les livres D&D, `title` sera renseigné avec `name_en` pour satisfaire la contrainte NOT NULL sans modification de schéma destructive.

```sql
ALTER TABLE books
  ADD COLUMN name_en    VARCHAR(255) NULL,
  ADD COLUMN name_fr    VARCHAR(255) NULL,
  ADD COLUMN edition    VARCHAR(50)  NULL,
  ADD COLUMN book_type  VARCHAR(60)  NULL;
```

| Colonne | Type | Nullable | Description |
|---|---|---|---|
| `name_en` | VARCHAR(255) | OUI | Titre anglais. Utilisé pour D&D 5. NULL pour Royaumes Oubliés (qui utilise `title`). |
| `name_fr` | VARCHAR(255) | OUI | Titre français. Utilisé pour D&D 5. NULL pour Royaumes Oubliés. |
| `edition` | VARCHAR(50) | OUI | Vaut toujours `"D&D 5"` pour les livres D&D. NULL pour Royaumes Oubliés. |
| `book_type` | VARCHAR(60) | OUI | Type de livre D&D : voir section 2.4 pour les 6 valeurs. NULL pour Royaumes Oubliés. |

> **Note** : Pour Royaumes Oubliés, le champ `book_type` existant (`roman` / `recueil de romans`) reste utilisé. Pour D&D 5, la colonne `book_type` prend les 6 nouvelles valeurs.

### 2.3 Décision architecturale : possession bilingue

#### Analyse des options

**Option A — 2 colonnes dans `user_books`**

Ajouter `owned_en BOOLEAN DEFAULT FALSE` et `owned_fr BOOLEAN DEFAULT FALSE` à la table `user_books`.

- Avantage : simple, rétrocompatible. Les livres Royaumes Oubliés gardent `is_owned`. Les colonnes `owned_en` / `owned_fr` sont `NULL` pour eux — leur sémantique reste exacte.
- Avantage : un seul endpoint `PATCH /api/v1/books/{id}/possession` suffit avec un body enrichi.
- Inconvénient : la table `user_books` mélange deux sémantiques (`is_owned` pour Royaumes Oubliés, `owned_en` / `owned_fr` pour D&D 5). Acceptable car distingué par `collection_id`.

**Option B — Valeur enum dans `user_books`**

Remplacer `is_owned` par `possession_type ENUM('none', 'en_only', 'fr_only', 'both')`.

- Avantage : sémantique claire et non ambiguë.
- Inconvénient : migration **breaking** sur les 41 possessions Royaumes Oubliés existantes. Requiert une transformation de données (`is_owned = true` → `'both'` ? ou autre ?). Logique de migration peu claire.
- Inconvénient : PostgreSQL ne supporte pas nativement les enums sans CREATE TYPE, et leur modification ultérieure est coûteuse (`ALTER TYPE`).

**Option C — Conserver `is_owned` + ajouter `owned_en` et `owned_fr`**

`is_owned` = true si au moins une version est possédée. `owned_en` et `owned_fr` donnent le détail.

- Avantage : rétrocompatible totale avec l'API existante (les clients qui lisent `is_owned` continuent à fonctionner).
- Inconvénient : redondance à maintenir — `is_owned` doit rester synchronisé avec `(owned_en OR owned_fr)`. Source potentielle de bugs d'incohérence.

#### Décision retenue : **Option A**

**Raison :** C'est l'option la plus propre architecturalement et la moins risquée opérationnellement.

- Elle n'introduit pas de redondance (Option C rejetée pour ce motif).
- Elle ne casse pas les données existantes (Option B rejetée pour ce motif).
- La cohabitation de `is_owned` (Royaumes Oubliés) et `owned_en` / `owned_fr` (D&D 5) est acceptable : les colonnes non pertinentes sont explicitement `NULL`, ce qui est sémantiquement correct et facile à documenter.
- La règle métier est simple : pour un livre D&D 5, une ligne `user_books` est créée dès qu'une version est possédée (EN ou FR), avec `is_owned = NULL`, `owned_en` et `owned_fr` reflétant l'état réel.

#### Gestion des livres Royaumes Oubliés existants

Les 41 lignes `user_books` existantes pour Royaumes Oubliés **ne sont pas touchées**. Elles conservent :

- `is_owned = true` (inchangé)
- `owned_en = NULL` (colonne ajoutée, NULL par défaut)
- `owned_fr = NULL` (colonne ajoutée, NULL par défaut)

Le backend lit `is_owned` pour Royaumes Oubliés et lit `owned_en` / `owned_fr` pour D&D 5. La discrimination se fait via le `collection_id` du livre joint. Aucune régression sur la page `/books`.

### 2.4 Modification de la table `user_books`

```sql
ALTER TABLE user_books
  ADD COLUMN owned_en BOOLEAN NULL,
  ADD COLUMN owned_fr BOOLEAN NULL;
```

| Colonne | Type | Nullable | Valeur par défaut | Description |
|---|---|---|---|---|
| `is_owned` | BOOLEAN | NON | false | Possession simple — utilisée pour Royaumes Oubliés. NULL sémantiquement non applicable pour D&D 5. |
| `owned_en` | BOOLEAN | OUI | NULL | Version anglaise possédée. `NULL` pour Royaumes Oubliés. `false` par défaut pour D&D 5. |
| `owned_fr` | BOOLEAN | OUI | NULL | Version française possédée. `NULL` pour Royaumes Oubliés. `false` par défaut pour D&D 5. |

> **Règle d'intégrité métier** : Pour les livres D&D 5, une ligne dans `user_books` est créée avec `owned_en = false, owned_fr = false` lors du premier toggle. Elle n'est jamais supprimée. `is_owned` reste à `false` (sa valeur initiale) et n'est pas utilisé pour D&D 5.

### 2.5 Champs ajoutés à la table `books`

Voir section 2.2 — récapitulatif complet ci-dessus.

### 2.6 Valeurs des énumérateurs

**`edition`** :
- `D&D 5` — Valeur fixe et unique pour tous les livres de cette collection. NULL pour les autres collections.

**`book_type`** (filtrage côté frontend) — 6 valeurs exactes :
- `Core Rules` — Livres de règles fondamentaux (PHB, DMG, MM)
- `Supplément de règles` — Suppléments de règles (XGtE, TCoE, MToF, etc.)
- `Setting` — Livres d'univers et de lore (SCAG, MoT, GGtR, etc.)
- `Campagnes` — Aventures longues et campagnes complètes (CoS, ToA, BgDiA, etc.)
- `Recueil d'aventures` — Recueils de courtes aventures (TftYP, CM, KotM, etc.)
- `Starter Set` — Boîtes d'initiation (LMoP, DoSI, etc.)

> **Attention** : Ces valeurs sont en français avec majuscules et accents. Les utiliser telles quelles dans la base de données, les filtres et les validations backend.

### 2.7 Champ `number` pour D&D

Le champ `number` (VARCHAR(10), NOT NULL dans le schéma actuel) n'a pas de sens pour D&D 5e. Il sera renseigné avec une **abréviation officielle** du livre (ex. : `PHB`, `DMG`, `MM`, `XGtE`, `CoS`) qui servira à la fois d'identifiant court et d'affichage dans le badge de la `BookCard`. Ce choix est compatible avec la contrainte NOT NULL sans modifier le schéma.

### 2.8 Modèle Go — structures mises à jour

Le fichier `/home/rno/git/Collectoria/backend/collection-management/internal/domain/book.go` doit être mis à jour :

```go
// Book représente un livre dans le catalogue
type Book struct {
    ID              uuid.UUID  `db:"id"`
    CollectionID    uuid.UUID  `db:"collection_id"`
    Number          string     `db:"number"`
    Title           string     `db:"title"`      // Utilisé pour Royaumes Oubliés
    Author          string     `db:"author"`
    PublicationDate time.Time  `db:"publication_date"`
    BookType        string     `db:"book_type"`  // "roman"/"recueil" pour RO ; 6 valeurs D&D pour D&D 5
    // Champs D&D 5e (NULL pour les autres collections)
    NameFr          *string    `db:"name_fr"`    // Titre français D&D 5
    NameEn          *string    `db:"name_en"`    // Titre anglais D&D 5
    Edition         *string    `db:"edition"`    // "D&D 5" pour tous les livres D&D
    CreatedAt       time.Time  `db:"created_at"`
    UpdatedAt       time.Time  `db:"updated_at"`
}

// BookWithOwnership représente un livre avec son statut de possession
// Pour Royaumes Oubliés : IsOwned est utilisé, OwnedEn/OwnedFr sont nil
// Pour D&D 5 : OwnedEn et OwnedFr sont utilisés, IsOwned est ignoré
type BookWithOwnership struct {
    Book
    IsOwned  bool  // Possession simple — Royaumes Oubliés uniquement
    OwnedEn  *bool // Version EN possédée — D&D 5 uniquement (nil pour Royaumes Oubliés)
    OwnedFr  *bool // Version FR possédée — D&D 5 uniquement (nil pour Royaumes Oubliés)
}

// UserBook représente la possession d'un livre par un utilisateur
type UserBook struct {
    ID        uuid.UUID `db:"id"`
    UserID    uuid.UUID `db:"user_id"`
    BookID    uuid.UUID `db:"book_id"`
    IsOwned   bool      `db:"is_owned"`  // Royaumes Oubliés uniquement
    OwnedEn   *bool     `db:"owned_en"`  // D&D 5 uniquement
    OwnedFr   *bool     `db:"owned_fr"`  // D&D 5 uniquement
    CreatedAt time.Time `db:"created_at"`
    UpdatedAt time.Time `db:"updated_at"`
}
```

Utiliser des pointeurs (`*bool`, `*string`) pour les champs nullables : les clients JSON recevront `null` plutôt que des valeurs zero-value non significatives.

### 2.9 TypeScript — interface `Book` mise à jour

```typescript
export interface Book {
  id: string
  collectionId: string
  number: string           // Abréviation pour D&D (PHB, DMG…), numéro pour Royaumes Oubliés
  title: string            // Titre principal — Royaumes Oubliés
  nameFr: string | null    // Titre français D&D 5 (null pour Royaumes Oubliés)
  nameEn: string | null    // Titre anglais D&D 5 (null pour Royaumes Oubliés)
  author: string
  publicationDate: string
  // Champs D&D 5e (null pour autres collections)
  edition: 'D&D 5' | null
  bookType: string         // "roman"/"recueil de romans" pour RO ; 6 valeurs D&D pour D&D 5
  // Possession
  isOwned: boolean         // Royaumes Oubliés uniquement
  ownedEn: boolean | null  // D&D 5 uniquement (null pour Royaumes Oubliés)
  ownedFr: boolean | null  // D&D 5 uniquement (null pour Royaumes Oubliés)
  createdAt: string
  updatedAt: string
}
```

### 2.10 Séparation des collections

La séparation entre Royaumes Oubliés et D&D 5e repose sur le `collection_id` :

- Collection Royaumes Oubliés : `22222222-2222-2222-2222-222222222222` (existant)
- Collection D&D 5e : `33333333-3333-3333-3333-333333333333` (à créer via migration)

Le frontend utilise des routes distinctes (`/books` vs `/dnd5`) qui passent chacune un `collection_id` différent à l'API. Aucun nouveau champ `collection_type` n'est nécessaire dans la table `books` : le `collection_id` seul suffit à identifier la collection.

---

## 3. Migrations SQL

### 3.1 Migration 010 — Ajout des colonnes D&D et création de la collection

Fichier : `migrations/010_add_dnd5_collection.sql`

```sql
-- Migration 010: Add D&D 5e book collection with bilingual possession
-- Description: Extends books and user_books tables for D&D 5e support
-- Date: 2026-04-26

-- ============================================================================
-- 1. EXTEND books TABLE
-- ============================================================================

ALTER TABLE books
  ADD COLUMN IF NOT EXISTS name_en   VARCHAR(255) NULL,
  ADD COLUMN IF NOT EXISTS name_fr   VARCHAR(255) NULL,
  ADD COLUMN IF NOT EXISTS edition   VARCHAR(50)  NULL,
  ADD COLUMN IF NOT EXISTS book_type VARCHAR(60)  NULL;

-- NOTE: la colonne book_type existe déjà (VARCHAR(50) NOT NULL) dans migration 005
-- pour Royaumes Oubliés (valeurs "roman" / "recueil de romans").
-- Pour D&D 5, elle prend les 6 nouvelles valeurs via la nouvelle colonne NULL séparée.
-- Si la colonne book_type est déjà VARCHAR et NOT NULL, utiliser une migration alternative :
-- ALTER TABLE books ADD COLUMN IF NOT EXISTS dnd_book_type VARCHAR(60) NULL;
-- (voir note en section 3.4)

-- Index sur book_type D&D pour filtrage frontend
CREATE INDEX IF NOT EXISTS idx_books_book_type_dnd ON books(book_type) WHERE edition = 'D&D 5';
-- Index sur edition
CREATE INDEX IF NOT EXISTS idx_books_edition ON books(edition);

-- Comments
COMMENT ON COLUMN books.name_en IS 'English title for D&D 5 books. NULL for non-D&D collections.';
COMMENT ON COLUMN books.name_fr IS 'French title for D&D 5 books. NULL for non-D&D collections.';
COMMENT ON COLUMN books.edition IS 'Fixed value "D&D 5" for D&D books. NULL for non-D&D collections.';

-- ============================================================================
-- 2. EXTEND user_books TABLE — possession bilingue
-- ============================================================================

ALTER TABLE user_books
  ADD COLUMN IF NOT EXISTS owned_en BOOLEAN NULL,
  ADD COLUMN IF NOT EXISTS owned_fr BOOLEAN NULL;

-- Index pour filtrage "possédé EN" et "possédé FR"
CREATE INDEX IF NOT EXISTS idx_user_books_owned_en ON user_books(user_id, owned_en);
CREATE INDEX IF NOT EXISTS idx_user_books_owned_fr ON user_books(user_id, owned_fr);

-- Comments
COMMENT ON COLUMN user_books.owned_en IS 'English version owned — D&D 5 only. NULL for non-D&D collections.';
COMMENT ON COLUMN user_books.owned_fr IS 'French version owned — D&D 5 only. NULL for non-D&D collections.';

-- ============================================================================
-- 3. INSERT D&D 5e COLLECTION
-- ============================================================================

INSERT INTO collections (id, name, slug, category, total_cards, description, created_at, updated_at)
VALUES (
    '33333333-3333-3333-3333-333333333333',
    'D&D 5e — Livres Officiels',
    'dnd5-books',
    'jeux-de-role',
    0,   -- Sera mis à jour après insertion des livres
    'Catalogue officiel des livres Dungeons & Dragons 5ème édition publiés par Wizards of the Coast',
    NOW(),
    NOW()
) ON CONFLICT (id) DO NOTHING;

-- ============================================================================
-- 4. INSERT D&D 5e BOOKS (seed initial — voir section 6 pour la liste complète)
-- ============================================================================

-- [Voir section 6 pour les INSERT statements complets]

-- ============================================================================
-- 5. UPDATE total_cards COUNT
-- ============================================================================

UPDATE collections
SET total_cards = (SELECT COUNT(*) FROM books WHERE collection_id = '33333333-3333-3333-3333-333333333333')
WHERE id = '33333333-3333-3333-3333-333333333333';
```

### 3.2 Impact sur les migrations existantes

Aucun impact. La migration 010 utilise `ALTER TABLE ... ADD COLUMN IF NOT EXISTS`, qui est idempotente. Les livres Royaumes Oubliés existants conservent `NULL` dans les nouvelles colonnes, ce qui est attendu et sémantiquement correct. Les 41 lignes `user_books` existantes conservent `is_owned = true`, `owned_en = NULL`, `owned_fr = NULL`.

### 3.3 Note sur le conflit `book_type`

La table `books` (migration 005) définit `book_type VARCHAR(50) NOT NULL`. La migration 010 tente d'ajouter `book_type VARCHAR(60) NULL`.

**Résolution** : `ADD COLUMN IF NOT EXISTS` ne modifie pas la colonne si elle existe déjà. La colonne existante `book_type` NOT NULL sera utilisée pour les deux collections avec des valeurs distinctes :

- Royaumes Oubliés : `"roman"`, `"recueil de romans"` (existant)
- D&D 5 : `"Core Rules"`, `"Supplément de règles"`, `"Setting"`, `"Campagnes"`, `"Recueil d'aventures"`, `"Starter Set"` (nouveau)

La validation backend doit distinguer les valeurs valides par `collection_id`. Aucun conflit de données n'est possible car les collections sont séparées.

### 3.4 Rollback

```sql
-- Rollback migration 010
DELETE FROM books WHERE collection_id = '33333333-3333-3333-3333-333333333333';
DELETE FROM collections WHERE id = '33333333-3333-3333-3333-333333333333';
DROP INDEX IF EXISTS idx_books_book_type_dnd;
DROP INDEX IF EXISTS idx_books_edition;
DROP INDEX IF EXISTS idx_user_books_owned_en;
DROP INDEX IF EXISTS idx_user_books_owned_fr;
ALTER TABLE books
  DROP COLUMN IF EXISTS name_en,
  DROP COLUMN IF EXISTS name_fr,
  DROP COLUMN IF EXISTS edition;
ALTER TABLE user_books
  DROP COLUMN IF EXISTS owned_en,
  DROP COLUMN IF EXISTS owned_fr;
-- NOTE: ne pas supprimer book_type — elle existait avant la migration 010
```

---

## 4. Backend — Endpoints REST

### 4.1 Stratégie de réutilisation

L'endpoint `GET /api/v1/books` existant accepte déjà un filtre par `collection_id` implicitement (via la query). **Aucun nouvel endpoint GET n'est nécessaire pour la v1** : on réutilise les routes existantes avec un paramètre `collection_id` ajouté.

Pour la possession, l'endpoint existant `PATCH /api/v1/books/{id}/possession` est **adapté** pour accueillir le nouveau body bilingue, tout en restant rétrocompatible pour Royaumes Oubliés.

### 4.2 Modifications du BookFilter

Ajouter `CollectionID` et les nouveaux filtres D&D dans `domain/book_filter.go` :

```go
type BookFilter struct {
    CollectionID string  // UUID de la collection (obligatoire pour séparer les deux collections)
    Search       string  // Recherche dans title (RO) ou name_fr/name_en (D&D 5)
    Author       string  // Filtrage par auteur (non utilisé pour D&D — auteur toujours WotC)
    Series       string  // "principal" ou "hors-serie" (Royaumes Oubliés uniquement)
    BookType     string  // Type de livre : valeurs RO ou D&D 5 selon collection_id
    Edition      string  // D&D uniquement : "D&D 5"
    IsOwned      *bool   // nil = tous, true = possédé (RO), false = non possédé (RO)
    OwnedEn      *bool   // nil = tous, true/false = filtre version EN (D&D 5 uniquement)
    OwnedFr      *bool   // nil = tous, true/false = filtre version FR (D&D 5 uniquement)
    Page         int
    Limit        int
}
```

### 4.3 Endpoint `PATCH /api/v1/books/{id}/possession` — nouveau body

#### Signature actuelle (Royaumes Oubliés)

```json
{ "is_owned": true }
```

#### Nouvelle signature unifiée (rétrocompatible)

```json
{
  "is_owned": true
}
```

**Pour D&D 5 :**

```json
{
  "owned_en": true,
  "owned_fr": false
}
```

Le handler détecte la collection du livre (via le `book_id`) et applique la logique correspondante :

- Si le livre appartient à Royaumes Oubliés (`collection_id = 22222222-...`) → utilise `is_owned`.
- Si le livre appartient à D&D 5 (`collection_id = 33333333-...`) → utilise `owned_en` et/ou `owned_fr`.

**Stratégie de dispatch : un seul endpoint, pas deux.**

**Justification du choix endpoint unique vs endpoints séparés :**

| Critère | Endpoint unique `PATCH /possession` | Deux endpoints `/possession/en` + `/possession/fr` |
|---|---|---|
| Cohérence API | Cohérent avec l'existant | Rompt le pattern existant |
| Atomicité | Peut toggler EN et FR en un appel | Requiert 2 appels pour changer les deux |
| Rétrocompatibilité | Totale | Casse les clients existants |
| Clarté du body | Body self-describing avec les deux champs | Intention claire dans l'URL |

**Décision : endpoint unique** avec body enrichi. La séparation EN/FR dans l'URL n'est pas justifiée pour une collection de livres où les deux états sont souvent mis à jour ensemble (ex. : acquisition d'un coffret bilingue).

#### Request body complet spécifié

```typescript
// Pour Royaumes Oubliés
interface UpdatePossessionRequestRO {
  is_owned: boolean
}

// Pour D&D 5 — les deux champs sont requis, pas d'ambiguïté
interface UpdatePossessionRequestDnD5 {
  owned_en: boolean
  owned_fr: boolean
}
```

Le backend valide que le body contient les bons champs selon la collection détectée. Si un body D&D 5 est envoyé pour un livre Royaumes Oubliés (ou inversement), retourner `400 BAD_REQUEST` avec un message explicite.

#### Règle métier : ligne `user_books` pour D&D 5

Pour D&D 5, une ligne `user_books` est créée (ou mise à jour) lors du premier appel `PATCH /possession`, avec `owned_en` et `owned_fr` définis par le body. L'upsert SQL est :

```sql
INSERT INTO user_books (id, user_id, book_id, is_owned, owned_en, owned_fr, created_at, updated_at)
VALUES (gen_random_uuid(), $1, $2, false, $3, $4, NOW(), NOW())
ON CONFLICT (user_id, book_id)
DO UPDATE SET owned_en = EXCLUDED.owned_en,
              owned_fr = EXCLUDED.owned_fr,
              updated_at = NOW();
```

### 4.4 Modifications du BookRepository

Dans `infrastructure/postgres/book_repository.go`, la méthode `GetBooksCatalog` doit :

1. Ajouter le filtre `collection_id` dans la clause WHERE (obligatoire) :
   ```sql
   WHERE b.collection_id = $1
   ```
   Modifier l'index des paramètres en conséquence (`$2`, `$3`, etc.).

2. Ajouter les filtres optionnels `book_type`, `edition`, `owned_en`, `owned_fr` :
   ```go
   if filter.OwnedEn != nil {
       where = append(where, fmt.Sprintf("ub.owned_en = $%d", idx))
       args = append(args, *filter.OwnedEn)
       idx++
   }
   if filter.OwnedFr != nil {
       where = append(where, fmt.Sprintf("ub.owned_fr = $%d", idx))
       args = append(args, *filter.OwnedFr)
       idx++
   }
   ```

3. Ajouter les nouvelles colonnes dans le SELECT :
   ```sql
   b.name_en, b.name_fr, b.edition, ub.owned_en, ub.owned_fr
   ```

4. Adapter l'ordre de tri pour D&D 5e : trier par `book_type` puis `name_en` (alphabétique). Pour Royaumes Oubliés, conserver le tri numérique existant. Utiliser un paramètre `SortBy` dans `BookFilter`.

### 4.5 Modifications du BookHandler

Dans `infrastructure/http/handlers/book_handler.go`, extraire les nouveaux query params :

```go
collectionID := r.URL.Query().Get("collection_id")
bookType     := r.URL.Query().Get("book_type")
edition      := r.URL.Query().Get("edition")
ownedEn      := r.URL.Query().Get("owned_en")
ownedFr      := r.URL.Query().Get("owned_fr")
```

Valider `collection_id` (non vide, UUID valide). Valider `book_type` avec une whitelist dépendant de la collection :

```go
// Royaumes Oubliés
validBookTypesRO := []string{"roman", "recueil de romans"}
// D&D 5
validBookTypesDnD5 := []string{
    "Core Rules",
    "Supplément de règles",
    "Setting",
    "Campagnes",
    "Recueil d'aventures",
    "Starter Set",
}
```

Ajouter `UpdateBookPossessionRequest` étendu :

```go
type UpdateBookPossessionRequest struct {
    // Royaumes Oubliés
    IsOwned *bool `json:"is_owned,omitempty"`
    // D&D 5
    OwnedEn *bool `json:"owned_en,omitempty"`
    OwnedFr *bool `json:"owned_fr,omitempty"`
}
```

### 4.6 Récapitulatif des endpoints

| Endpoint | Modification |
|---|---|
| `GET /api/v1/books` | Nouveau param `collection_id` (obligatoire), `book_type`, `edition`, `owned_en`, `owned_fr` |
| `PATCH /api/v1/books/{id}/possession` | Body étendu : `owned_en`/`owned_fr` pour D&D 5 ; `is_owned` inchangé pour Royaumes Oubliés |

### 4.7 Réponse JSON — nouveaux champs

```json
{
  "books": [
    {
      "id": "uuid",
      "collection_id": "33333333-3333-3333-3333-333333333333",
      "number": "PHB",
      "title": "Player's Handbook",
      "name_fr": "Manuel des joueurs",
      "name_en": "Player's Handbook",
      "author": "Wizards of the Coast",
      "publication_date": "2014-08-19",
      "edition": "D&D 5",
      "book_type": "Core Rules",
      "is_owned": false,
      "owned_en": false,
      "owned_fr": false,
      "created_at": "...",
      "updated_at": "..."
    }
  ],
  "pagination": {
    "total": 50,
    "page": 1,
    "limit": 100,
    "total_pages": 1
  }
}
```

> **Note** : Pour les livres Royaumes Oubliés, `owned_en` et `owned_fr` sont `null` dans la réponse. Pour les livres D&D 5, `owned_en` et `owned_fr` sont `boolean` et `is_owned` vaut toujours `false` (non utilisé).

### 4.8 Filtre "Possédés / Manquants" pour D&D 5

Le filtre de possession pour D&D 5 utilise la logique "au moins une version possédée" :

- **"Possédés"** = livres où `owned_en = true OR owned_fr = true`
- **"Manquants"** = livres où `owned_en = false AND owned_fr = false` (ou ligne absente)
- **"Possédés EN"** = livres où `owned_en = true` (filtre avancé, optionnel en v1)
- **"Possédés FR"** = livres où `owned_fr = true` (filtre avancé, optionnel en v1)

En v1, seuls les filtres "Tous / Possédés / Manquants" sont exposés dans l'UI. La sémantique "possédé" = au moins une version. Les filtres par version (EN seul, FR seul) sont hors périmètre v1.

Le backend expose un paramètre `is_owned_dnd` (calculé côté SQL) :

```sql
-- "Possédés" : au moins une version
(ub.owned_en = true OR ub.owned_fr = true)

-- "Manquants" : aucune version
(ub.owned_en = false AND ub.owned_fr = false)
  OR ub.id IS NULL  -- livre sans ligne user_books
```

---

## 5. Frontend — Pages et composants

### 5.1 URL et routage

Route dédiée : `/dnd5`

Justification du choix `/dnd5` plutôt que `/dnd` :
- Plus spécifique : laisse la place à `/dnd4`, `/dnd3` etc. si d'autres éditions sont ajoutées
- Cohérent avec la nomenclature du projet ("D&D 5e")
- `/dnd` reste disponible comme future page d'accueil de toutes les collections D&D

Fichier à créer : `frontend/src/app/dnd5/page.tsx`

### 5.2 Composant `DnD5BookCard` — possession bilingue

**Recommandation : créer un composant `DnD5BookCard.tsx`** distinct de `BookCard.tsx`. Cela préserve la séparation des collections et évite les régressions sur la page Royaumes Oubliés.

#### Affichage des titres

- Titre principal : `book.nameFr` (en gras)
- Sous-titre : `book.nameEn` (en italique, discret)
- Badge d'abréviation : `book.number` (PHB, DMG…)
- Badge de type : `book.bookType`
- Ne pas afficher l'auteur (toujours "Wizards of the Coast", information redondante)

#### UI de possession bilingue — pattern retenu : deux toggles indépendants EN / FR

**Option retenue : deux toggles séparés EN / FR.**

| Option | Description | Avantage | Inconvénient |
|---|---|---|---|
| **Deux toggles EN / FR** (retenu) | Deux boutons/checkboxes côte à côte "EN" et "FR" | Interaction directe, visuel compact, standard pour les collectors | Prend plus de place que 1 bouton |
| Sélecteur 4 états | Menu déroulant ou bouton-cycle "Aucun → EN → FR → Les deux → Aucun" | Compact | Peu intuitif, ordre des états arbitraire, difficile à corriger (ex: passer de "FR" à "EN+FR" nécessite 2 cycles) |

**Justification du choix deux toggles :** Un collectionneur qui possède la version EN d'un livre peut ultérieurement acquérir la version FR (ou inversement). Ces deux états sont indépendants et doivent être togglables indépendamment. Deux toggles sont la représentation la plus directe et la moins ambiguë.

**Maquette de la zone possession (texte)** :

```
┌─────────────────────────────────┐
│ PHB  [Core Rules]               │
│ Manuel des joueurs              │
│ Player's Handbook               │
│                                 │
│  [ EN ]  [ FR ]                 │  ← deux toggles
└─────────────────────────────────┘

États visuels :
  [ EN ] gris  = non possédé
  [ EN ] bleu  = possédé
  [ FR ] gris  = non possédé
  [ FR ] bleu  = possédé
```

**Props `DnD5BookCard`** :

```typescript
interface DnD5BookCardProps {
  book: Book
  onToggleEn: (bookId: string, value: boolean) => void
  onToggleFr: (bookId: string, value: boolean) => void
  isTogglingId: string | null
}
```

#### Modale de confirmation

Réutiliser `BookConfirmModal` existant avec un message adapté :

- Toggle EN activé : "Marquer la version anglaise de [titre] comme possédée ?"
- Toggle FR activé : "Marquer la version française de [titre] comme possédée ?"
- Toggle EN désactivé : "Retirer la version anglaise de [titre] de votre collection ?"
- Toggle FR désactivé : "Retirer la version française de [titre] de votre collection ?"

**Attributs accessibilité** :

```tsx
<button
  aria-label={`Version anglaise de ${book.nameFr} : ${book.ownedEn ? 'possédée' : 'non possédée'}`}
  aria-pressed={book.ownedEn ?? false}
  onClick={() => onToggleEn(book.id, !book.ownedEn)}
>
  EN
</button>
<button
  aria-label={`Version française de ${book.nameFr} : ${book.ownedFr ? 'possédée' : 'non possédée'}`}
  aria-pressed={book.ownedFr ?? false}
  onClick={() => onToggleFr(book.id, !book.ownedFr)}
>
  FR
</button>
```

### 5.3 Filtres de la page `/dnd5`

La page `/dnd5` n'a pas besoin des filtres "auteur" et "série (principal/hors-série)" de la page `/books`. Elle propose :

| Filtre | Type UI | Valeurs |
|---|---|---|
| Recherche | Input texte | Recherche dans `name_fr` et `name_en` |
| Type | ToggleGroup | Tous / Core Rules / Supplément de règles / Setting / Campagnes / Recueil d'aventures / Starter Set |
| Possession | ToggleGroup | Tous / Possédés (au moins une version) / Manquants |

> **Note** : "Possédé" = `owned_en = true OR owned_fr = true`. Le filtre par version (EN seul, FR seul) est hors périmètre v1.

> **Note** : Le filtre "Édition" est supprimé — `edition` est fixe (`"D&D 5"`) pour toute la collection, il n'apporte pas de valeur de filtrage en v1.

### 5.4 Statistiques de la page

Afficher dans le header de la page :

```
Collection D&D 5e — Livres Officiels
Total: 50 livres  |  Affichés: X livres  |  Possédés EN: Y  |  Possédés FR: Z  |  Les deux: W
```

Optionnellement, une barre de progression "complétion globale" basée sur "au moins une version possédée".

### 5.5 Navigation — TopNav

Ajouter un lien "D&D 5e" dans la `TopNav`. La navigation actuelle comporte déjà les liens vers les principales pages. Suivre le pattern exact des liens existants dans `frontend/src/components/layout/TopNav.tsx`.

Proposition de structure des liens de navigation :

```
Dashboard | Cartes MECCG | Royaumes Oubliés | D&D 5e
```

### 5.6 Hooks et API client

Créer les fichiers suivants (en suivant les patterns existants) :

**`frontend/src/lib/api/dnd5books.ts`** (ou étendre `books.ts`) :
- Réutiliser `fetchBooks` en passant `collection_id=33333333-3333-3333-3333-333333333333`
- Ajouter les types `DnD5BookFilters` avec `book_type` (l'une des 6 valeurs)
- Ajouter la conversion snake_case → camelCase pour les nouveaux champs (`name_fr` → `nameFr`, `name_en` → `nameEn`, `book_type` → `bookType`, `owned_en` → `ownedEn`, `owned_fr` → `ownedFr`)
- Exposer `toggleDnD5Possession(bookId: string, ownedEn: boolean, ownedFr: boolean)`

**`frontend/src/hooks/useDnD5Books.ts`** :
- Pattern identique à `useBooks.ts`
- staleTime : 5 minutes (données quasi-statiques)
- Mutation `useToggleDnD5Possession` : envoie `{ owned_en, owned_fr }` au `PATCH /api/v1/books/{id}/possession`

Alternativement, étendre `useBooks` et `fetchBooks` pour accepter un `collectionId` générique. Cette option est préférable à long terme si d'autres collections de livres sont ajoutées.

### 5.7 Modale de confirmation

Étendre `BookConfirmModal` existant (`frontend/src/components/books/BookConfirmModal.tsx`) pour accepter un message personnalisé. Alternativement, passer le message comme prop `message` depuis `DnD5BookCard`.

---

## 6. Seed de données

### 6.1 Liste des livres à inclure

Les colonnes disponibles pour chaque livre sont : `number` (abréviation), `name_en`, `name_fr`, `edition` (fixe `D&D 5`), `book_type` (l'une des 6 valeurs).

#### Core Rules (3)

| Abréviation | name_en | name_fr | book_type |
|---|---|---|---|
| PHB | Player's Handbook | Manuel des joueurs | Core Rules |
| DMG | Dungeon Master's Guide | Guide du Maître du Donjon | Core Rules |
| MM | Monster Manual | Manuel des monstres | Core Rules |

#### Suppléments de règles (exemples)

| Abréviation | name_en | name_fr | book_type |
|---|---|---|---|
| XGtE | Xanathar's Guide to Everything | Le Guide de Xanathar | Supplément de règles |
| TCoE | Tasha's Cauldron of Everything | Le Chaudron de tout de Tasha | Supplément de règles |
| MToF | Mordenkainen's Tome of Foes | Tome des ennemis de Mordenkainen | Supplément de règles |
| VGtM | Volo's Guide to Monsters | Guide des monstres de Volo | Supplément de règles |
| FToD | Fizban's Treasury of Dragons | Trésor des dragons de Fizban | Supplément de règles |
| BGG | Bigby Presents: Glory of the Giants | Bigby : La Gloire des géants | Supplément de règles |

#### Setting (exemples)

| Abréviation | name_en | name_fr | book_type |
|---|---|---|---|
| SCAG | Sword Coast Adventurer's Guide | Guide de l'aventurier de la Côte des Épées | Setting |
| MoT | Mythic Odysseys of Theros | Odyssées mythiques de Theros | Setting |
| GGtR | Guildmasters' Guide to Ravnica | Guide des maîtres de guilde de Ravnica | Setting |
| VRGtR | Van Richten's Guide to Ravenloft | Guide de Van Richten sur Ravenloft | Setting |
| EGtW | Explorer's Guide to Wildemount | Guide de l'explorateur de Wildemount | Setting |

#### Campagnes (exemples)

| Abréviation | name_en | name_fr | book_type |
|---|---|---|---|
| CoS | Curse of Strahd | La Malédiction de Strahd | Campagnes |
| ToA | Tomb of Annihilation | Tombeau de l'Annihilation | Campagnes |
| BgDiA | Baldur's Gate: Descent into Avernus | Porte de Baldur : La Descente en Averne | Campagnes |
| IDRotF | Icewind Dale: Rime of the Frostmaiden | Icewind Dale : Le Rime de la Reine des Glaces | Campagnes |
| WBtW | The Wild Beyond the Witchlight | Les Étendues sauvages et Féevasse | Campagnes |
| SKT | Storm King's Thunder | Le Tonnerre du Roi des tempêtes | Campagnes |
| OotA | Out of the Abyss | Hors de l'Abîme | Campagnes |
| PotA | Princes of the Apocalypse | Les Princes de l'Apocalypse | Campagnes |
| WDH | Waterdeep: Dragon Heist | Waterdeep : Le Vol du dragon | Campagnes |
| WDotMM | Waterdeep: Dungeon of the Mad Mage | Waterdeep : Le Donjon du mage dément | Campagnes |
| HotDQ | Hoard of the Dragon Queen | Le Trésor de la Reine des dragons | Campagnes |
| RoT | The Rise of Tiamat | L'Ascension de Tiamat | Campagnes |
| CR | Critical Role: Call of the Netherdeep | Critical Role : L'Appel des profondeurs | Campagnes |
| PaBTSO | Phandelver and Below: The Shattered Obelisk | Phandelver et les Profondeurs | Campagnes |

#### Recueil d'aventures (exemples)

| Abréviation | name_en | name_fr | book_type |
|---|---|---|---|
| TftYP | Tales from the Yawning Portal | Contes du Portail baillant | Recueil d'aventures |
| CM | Candlekeep Mysteries | Les Mystères de Châteauclairbec | Recueil d'aventures |
| KotM | Keys from the Golden Vault | Les Clés du Coffre d'or | Recueil d'aventures |
| SLW | Ghosts of Saltmarsh | Les Fantômes de Saltmarsh | Recueil d'aventures |

#### Starter Set (exemples)

| Abréviation | name_en | name_fr | book_type |
|---|---|---|---|
| LMoP | Starter Set: Lost Mine of Phandelver | Boîte d'initiation : La Mine perdue de Phandelver | Starter Set |
| DoSI | Starter Set: Dragons of Stormwreck Isle | Boîte d'initiation : Les Dragons de l'Île Brisée | Starter Set |

> **Note** : La liste complète des livres sera fournie par l'utilisateur sous forme de données source avant implémentation. Les exemples ci-dessus illustrent la structure et la correspondance entre `name_en`, `name_fr` et `book_type`.

### 6.2 INSERT SQL (migration 010, section 4)

Structure de chaque INSERT — colonnes disponibles, avec `title` = `name_en` pour satisfaire la contrainte NOT NULL :

```sql
-- Colonnes : id, collection_id, number, title, name_en, name_fr, author, publication_date, edition, book_type
INSERT INTO books (id, collection_id, number, title, name_en, name_fr, author, publication_date, edition, book_type) VALUES

-- Core Rules
(gen_random_uuid(), '33333333-3333-3333-3333-333333333333', 'PHB',
 'Player''s Handbook', 'Player''s Handbook', 'Manuel des joueurs',
 'Wizards of the Coast', '2014-08-19', 'D&D 5', 'Core Rules'),

(gen_random_uuid(), '33333333-3333-3333-3333-333333333333', 'DMG',
 'Dungeon Master''s Guide', 'Dungeon Master''s Guide', 'Guide du Maître du Donjon',
 'Wizards of the Coast', '2014-12-09', 'D&D 5', 'Core Rules'),

(gen_random_uuid(), '33333333-3333-3333-3333-333333333333', 'MM',
 'Monster Manual', 'Monster Manual', 'Manuel des monstres',
 'Wizards of the Coast', '2014-09-30', 'D&D 5', 'Core Rules'),

-- Suppléments de règles
(gen_random_uuid(), '33333333-3333-3333-3333-333333333333', 'XGtE',
 'Xanathar''s Guide to Everything', 'Xanathar''s Guide to Everything', 'Le Guide de Xanathar',
 'Wizards of the Coast', '2017-11-21', 'D&D 5', 'Supplément de règles'),

(gen_random_uuid(), '33333333-3333-3333-3333-333333333333', 'TCoE',
 'Tasha''s Cauldron of Everything', 'Tasha''s Cauldron of Everything', 'Le Chaudron de tout de Tasha',
 'Wizards of the Coast', '2020-11-17', 'D&D 5', 'Supplément de règles'),

-- Campagnes
(gen_random_uuid(), '33333333-3333-3333-3333-333333333333', 'CoS',
 'Curse of Strahd', 'Curse of Strahd', 'La Malédiction de Strahd',
 'Wizards of the Coast', '2016-03-15', 'D&D 5', 'Campagnes'),

(gen_random_uuid(), '33333333-3333-3333-3333-333333333333', 'ToA',
 'Tomb of Annihilation', 'Tomb of Annihilation', 'Tombeau de l''Annihilation',
 'Wizards of the Coast', '2017-09-19', 'D&D 5', 'Campagnes'),

-- Recueil d'aventures
(gen_random_uuid(), '33333333-3333-3333-3333-333333333333', 'TftYP',
 'Tales from the Yawning Portal', 'Tales from the Yawning Portal', 'Contes du Portail baillant',
 'Wizards of the Coast', '2017-04-04', 'D&D 5', 'Recueil d''aventures'),

-- Starter Set
(gen_random_uuid(), '33333333-3333-3333-3333-333333333333', 'LMoP',
 'Starter Set: Lost Mine of Phandelver', 'Starter Set: Lost Mine of Phandelver',
 'Boîte d''initiation : La Mine perdue de Phandelver',
 'Wizards of the Coast', '2014-07-15', 'D&D 5', 'Starter Set');

-- [... liste complète à compléter avec les données fournies par l'utilisateur]
```

> **Champs absents** : `page_count`, `isbn`, `cover_url` ne sont pas dans la seed — ces données ne sont pas disponibles.

### 6.3 Seed de possession initiale

Contrairement aux collections MECCG et Royaumes Oubliés (données réelles de l'utilisateur), la possession D&D 5e démarre à zéro. **Aucun INSERT dans `user_books` pour cette collection au seed initial.** L'utilisateur renseignera sa possession via les toggles EN / FR.

Lors du premier toggle, le backend crée la ligne `user_books` avec `owned_en = false, owned_fr = false` puis applique le PATCH, résultant en `owned_en = <valeur>` et `owned_fr = <valeur>`.

---

## 7. Critères d'acceptation

### CA-DND5-001 — Catalogue visible

- Donné un utilisateur authentifié
- Quand il accède à `/dnd5`
- Alors il voit la liste des livres D&D 5e (au moins les 50 du seed)
- Et il ne voit pas les livres Royaumes Oubliés
- Et les livres sont groupés visuellement par catégorie ou filtrables par catégorie

### CA-DND5-002 — Filtre par type

- Quand l'utilisateur sélectionne le filtre "Core Rules"
- Alors seuls les livres avec `book_type = 'Core Rules'` sont affichés (PHB, DMG, MM)
- Et le compteur de résultats se met à jour
- Quand l'utilisateur sélectionne "Campagnes"
- Alors seuls les livres avec `book_type = 'Campagnes'` sont affichés
- Les 6 valeurs du filtre correspondent exactement aux 6 valeurs de `book_type` en base

### CA-DND5-003 — Pas de filtre par édition

- La page `/dnd5` n'expose pas de filtre "Édition" (`edition` étant fixe à `"D&D 5"` pour toute la collection)
- L'absence de ce filtre est un choix de conception v1 documenté

### CA-DND5-004 — Toggle de possession version anglaise

- Quand l'utilisateur clique sur le toggle "EN" d'un livre D&D
- Alors une modale de confirmation apparaît avec le message "Marquer la version anglaise de [titre] comme possédée ?"
- Quand il confirme
- Alors `owned_en = true` en base de données (et `owned_fr` reste inchangé)
- Et le toggle EN reste dans l'état "possédé" après rechargement de la page
- Et le toggle FR reste dans son état précédent

### CA-DND5-005 — Toggle de possession version française

- Quand l'utilisateur clique sur le toggle "FR" d'un livre D&D
- Alors une modale de confirmation apparaît avec le message "Marquer la version française de [titre] comme possédée ?"
- Quand il confirme
- Alors `owned_fr = true` en base de données (et `owned_en` reste inchangé)
- Et le toggle FR reste dans l'état "possédé" après rechargement de la page

### CA-DND5-006 — Les 4 états de possession

- État "Aucune version" : `owned_en = false, owned_fr = false` → les deux toggles EN et FR sont dans l'état "non possédé" (gris)
- État "Version EN uniquement" : `owned_en = true, owned_fr = false` → toggle EN actif (bleu), toggle FR inactif (gris)
- État "Version FR uniquement" : `owned_en = false, owned_fr = true` → toggle EN inactif (gris), toggle FR actif (bleu)
- État "Les deux versions" : `owned_en = true, owned_fr = true` → les deux toggles actifs (bleus)
- Les transitions entre les 4 états sont possibles par combinaison des deux toggles indépendants

### CA-DND5-007 — Désactivation d'un toggle déjà actif

- Quand l'utilisateur clique sur le toggle "EN" d'un livre où `owned_en = true`
- Alors une modale de confirmation apparaît avec le message "Retirer la version anglaise de [titre] de votre collection ?"
- Quand il confirme
- Alors `owned_en = false` en base de données
- Et `owned_fr` reste inchangé

### CA-DND5-008 — Filtre "Possédés / Manquants"

- Quand l'utilisateur sélectionne "Possédés"
- Alors seuls les livres avec `owned_en = true OR owned_fr = true` sont affichés
- Quand il sélectionne "Manquants"
- Alors seuls les livres sans aucune version possédée sont affichés (`owned_en = false AND owned_fr = false`)
- Un livre avec uniquement la version EN est considéré "possédé" dans ce filtre
- Un livre avec uniquement la version FR est considéré "possédé" dans ce filtre

### CA-DND5-009 — Isolation des collections

- La page `/books` (Royaumes Oubliés) n'affiche aucun livre D&D
- La page `/dnd5` n'affiche aucun livre Royaumes Oubliés
- Un toggle sur un livre D&D n'affecte pas les statistiques de la collection Royaumes Oubliés
- Un toggle sur un livre D&D modifie uniquement `owned_en` ou `owned_fr`, jamais `is_owned`

### CA-DND5-010 — Rétrocompatibilité (sans régression)

- La page `/books` (Royaumes Oubliés) continue de fonctionner sans changement visible
- Les 94 livres Royaumes Oubliés sont toujours affichés avec leurs métadonnées
- Les 41 possessions Royaumes Oubliés existantes ne sont pas modifiées
- Les filtres "auteur" et "série (principal/hors-série)" continuent de fonctionner sur `/books`
- L'endpoint `PATCH /api/v1/books/{id}/possession` avec le body `{"is_owned": true}` continue de fonctionner pour Royaumes Oubliés

### CA-DND5-011 — Navigation

- Un lien "D&D 5e" est visible dans la TopNav
- Le lien est actif (visuellement mis en avant) quand l'utilisateur est sur `/dnd5`
- Retour au dashboard via le lien "← Retour au dashboard"

### CA-DND5-012 — Performance

- La page `/dnd5` charge en moins de 2 secondes
- Le squelette de chargement (skeleton) est affiché pendant le fetch
- Les filtres sont réactifs (debounce 300ms sur la recherche textuelle)

### CA-DND5-013 — Recherche textuelle bilingue

- Quand l'utilisateur tape "Strahd" dans le champ de recherche
- Alors "Curse of Strahd" (name_en) et "La Malédiction de Strahd" (name_fr) sont trouvés
- La recherche porte sur `name_en` ET `name_fr`
- La recherche est insensible à la casse

### CA-DND5-014 — Accessibilité des toggles bilingues

- Les toggles EN et FR ont chacun un `aria-label` distinct mentionnant le titre du livre et la langue
- Chaque toggle a un attribut `aria-pressed` reflétant son état réel
- Les toggles EN et FR sont distincts et navigables au clavier indépendamment
- Les groupes de filtres ont un `role="group"` avec `aria-label`

### CA-DND5-015 — Migration

- La migration 010 s'applique sans erreur sur une base vierge
- La migration 010 s'applique sans erreur sur une base existante (avec MECCG + Royaumes Oubliés)
- Après migration, les 41 lignes `user_books` Royaumes Oubliés ont `owned_en = NULL, owned_fr = NULL`
- Le rollback de la migration 010 est propre et ne corrompt pas les données existantes

### CA-DND5-016 — Body de possession invalide

- Quand un client envoie `{"is_owned": true}` pour un livre D&D 5
- Alors l'API retourne `400 BAD_REQUEST` avec un message explicite
- Quand un client envoie `{"owned_en": true, "owned_fr": false}` pour un livre Royaumes Oubliés
- Alors l'API retourne `400 BAD_REQUEST` avec un message explicite

---

## Annexe A — Décisions techniques résumées

| Décision | Choix retenu | Raison |
|---|---|---|
| Schéma de données | Extension de `books` avec 4 colonnes nullables (`name_en`, `name_fr`, `edition`, `book_type`) | Réutilisation de la couche existante, DRY |
| Possession bilingue | Option A : `owned_en` + `owned_fr` dans `user_books` | Rétrocompatible, pas de redondance, sémantique claire |
| `is_owned` Royaumes Oubliés | Conservé tel quel, `owned_en`/`owned_fr` = NULL pour RO | Aucune migration breaking |
| Endpoint possession | Un seul `PATCH /possession` avec body enrichi | Cohérence API, atomicité, rétrocompatibilité |
| Endpoints séparés EN/FR | Rejeté | Rompt le pattern existant, 2 appels pour 1 action |
| UI possession D&D 5 | Deux toggles indépendants EN / FR | Indépendance des états, clarté, standard UX collectors |
| Sélecteur 4 états | Rejeté | Navigation non intuitive entre états, ambiguïté |
| Sémantique "possédé" dans les filtres | Au moins une version (EN ou FR) | Logique collector : posséder une version = posséder le livre |
| Séparation des collections | Par `collection_id` | Déjà en place, aucun nouveau champ nécessaire |
| Composant BookCard | Nouveau `DnD5BookCard` dérivé | Évite les régressions sur Royaumes Oubliés |
| Route frontend | `/dnd5` | Spécifique, extensible pour futures éditions |
| Possession initiale seed | 0 livre possédé (aucun INSERT dans user_books) | Données réelles inconnues |
| Champ `number` pour D&D | Abréviation officielle (PHB, DMG…) | Compatible NOT NULL, utile comme badge |
| Tri par défaut D&D 5 | Par `book_type` puis `name_en` | Logique pour D&D (grouper Core Rules / Campagnes…) |
| Valeurs `book_type` D&D | En français avec accents | Correspond aux données sources fournies |
| Filtre édition frontend | Absent en v1 | `edition` fixe `"D&D 5"` — pas de valeur de filtrage |

## Annexe B — Fichiers à créer ou modifier

### Backend

| Fichier | Action |
|---|---|
| `migrations/010_add_dnd5_collection.sql` | Créer (colonnes `name_en`, `name_fr`, `edition` sur `books` ; `owned_en`, `owned_fr` sur `user_books`) |
| `internal/domain/book.go` | Modifier (`NameFr *string`, `NameEn *string`, `Edition *string` sur `Book` ; `OwnedEn *bool`, `OwnedFr *bool` sur `BookWithOwnership` et `UserBook`) |
| `internal/domain/book_filter.go` | Modifier (CollectionID, OwnedEn, OwnedFr) |
| `internal/domain/book_repository.go` | Aucune modification (interface inchangée) |
| `internal/infrastructure/postgres/book_repository.go` | Modifier (filtre collection_id, owned_en, owned_fr ; nouveaux champs SELECT ; upsert bilingue) |
| `internal/infrastructure/http/handlers/book_handler.go` | Modifier (`UpdateBookPossessionRequest` étendu ; dispatch selon collection_id ; validation whitelist par collection) |

### Frontend

| Fichier | Action |
|---|---|
| `src/app/dnd5/page.tsx` | Créer |
| `src/components/books/DnD5BookCard.tsx` | Créer (deux toggles EN/FR indépendants) |
| `src/lib/api/books.ts` | Modifier (interface `Book` avec `ownedEn`, `ownedFr` ; fonction `toggleDnD5Possession`) |
| `src/hooks/useDnD5Books.ts` | Créer (avec mutation `useToggleDnD5Possession`) |
| `src/components/layout/TopNav.tsx` | Modifier (ajout lien D&D 5e) |
| `src/components/books/BookConfirmModal.tsx` | Modifier (prop `message` personnalisable) ou créer `DnD5PossessionModal.tsx` |
