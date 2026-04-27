# Migration 010 - Collection D&D 5e

**Date de création** : 2026-04-27  
**Auteur** : Agent Backend  
**Statut** : ✅ Testé et validé

---

## Description

Cette migration ajoute la collection **D&D 5e** (Livres officiels de Dungeons & Dragons 5ème édition) au système Collectoria. Elle étend le modèle de données existant pour supporter la **possession bilingue** (versions EN/FR distinctes) tout en maintenant la rétrocompatibilité avec la collection Royaumes Oubliés.

---

## Contenu de la Migration

### 1. Extensions de Tables

#### Table `books`
- **Nouvelles colonnes** :
  - `name_en VARCHAR(255) NULL` : Titre anglais (pour D&D 5e)
  - `name_fr VARCHAR(255) NULL` : Titre français (pour D&D 5e)
  - `edition VARCHAR(50) NULL` : Édition (fixe `'D&D 5'` pour D&D 5e)

- **Index créés** :
  - `idx_books_edition` : Filtrage par édition
  - `idx_books_book_type` : Filtrage par type de livre

#### Table `user_books`
- **Nouvelles colonnes** :
  - `owned_en BOOLEAN NULL` : Possession version anglaise
  - `owned_fr BOOLEAN NULL` : Possession version française

- **Index créés** :
  - `idx_user_books_owned_en` : Filtrage possessions EN
  - `idx_user_books_owned_fr` : Filtrage possessions FR

### 2. Données Importées

- **1 collection** : D&D 5e (UUID: `33333333-3333-3333-3333-333333333333`)
- **53 livres** officiels D&D 5e répartis en 6 types :
  - Core Rules : 6 livres
  - Starter Set : 4 livres
  - Supplément de règles : 8 livres
  - Setting : 11 livres
  - Campagnes : 17 livres
  - Recueil d'aventures : 7 livres
- **36 possessions initiales** :
  - 19 versions françaises
  - 17 versions anglaises

---

## Fichiers Inclus

| Fichier | Description |
|---------|-------------|
| `010_add_dnd5_collection.sql` | Migration principale à appliquer |
| `010_validation.sql` | Script de validation complet (8 sections) |
| `010_quick_check.sql` | Vérification rapide post-migration |
| `010_test_report.md` | Rapport de test détaillé avec résultats |
| `010_README.md` | Ce fichier (documentation) |

---

## Application de la Migration

### Prérequis

- PostgreSQL 15+ en cours d'exécution
- Base de données `collection_management` créée
- Migrations 001-009 déjà appliquées

### Commande

```bash
# Via Docker Compose (recommandé)
cd /home/arnaud.dars/git/Collectoria/backend/collection-management
docker compose exec -T postgres psql -U collectoria -d collection_management < migrations/010_add_dnd5_collection.sql

# Via psql direct (si installé)
psql -h localhost -p 5432 -U collectoria -d collection_management -f migrations/010_add_dnd5_collection.sql
```

### Vérification Rapide

```bash
# Vérification en 30 secondes
docker compose exec -T postgres psql -U collectoria -d collection_management < migrations/010_quick_check.sql
```

**Résultats attendus** :
```
Collection: D&D 5e | dnd5 | 53
Books: 53
Possessions: 36 total (19 FR, 17 EN)
Royaumes Oubliés: 94 books, 41 possessions
```

### Validation Complète

```bash
# Test complet avec 8 sections de validation
docker compose exec -T postgres psql -U collectoria -d collection_management < migrations/010_validation.sql
```

Voir `010_test_report.md` pour les résultats attendus détaillés.

---

## Structure des Données

### Collection D&D 5e

```sql
id: '33333333-3333-3333-3333-333333333333'
name: 'D&D 5e'
slug: 'dnd5'
category: 'jeux-de-role'
total_cards: 53
description: 'Livres officiels de Dungeons & Dragons 5ème édition publiés par Wizards of the Coast'
```

### Types de Livres D&D 5e

La colonne `book_type` pour D&D 5e prend 6 valeurs distinctes :

1. **Core Rules** : Livres de règles fondamentaux (PHB, DMG, MM)
2. **Supplément de règles** : Suppléments (XGtE, TCoE, FToD, etc.)
3. **Setting** : Univers et lore (SCAG, VRGtR, etc.)
4. **Campagnes** : Aventures longues (CoS, ToA, etc.)
5. **Recueil d'aventures** : Recueils d'aventures courtes (TftYP, CM, etc.)
6. **Starter Set** : Boîtes d'initiation (LMoP, DoSI, etc.)

### Modèle de Possession Bilingue

Pour les livres D&D 5e, la possession est gérée via deux colonnes indépendantes :

```sql
-- Exemple 1: Possède uniquement la version FR
owned_en = false, owned_fr = true

-- Exemple 2: Possède uniquement la version EN
owned_en = true, owned_fr = false

-- Exemple 3: Possède les deux versions
owned_en = true, owned_fr = true

-- Exemple 4: Ne possède aucune version
owned_en = false, owned_fr = false
```

**Important** : Pour D&D 5e, `is_owned` reste à `false` (non utilisé). Les colonnes `owned_en` et `owned_fr` sont source de vérité.

---

## Rétrocompatibilité

### Collection Royaumes Oubliés

**Aucune modification** des données existantes :

- Les 94 livres conservent leurs données initiales
- Les colonnes `name_en`, `name_fr`, `edition` restent à `NULL`
- Les 41 possessions conservent `is_owned = true`
- Les colonnes `owned_en`, `owned_fr` restent à `NULL`

### Distinction des Collections

La distinction se fait via le `collection_id` :

```sql
-- Royaumes Oubliés
collection_id = '22222222-2222-2222-2222-222222222222'
→ Utilise: title, is_owned

-- D&D 5e
collection_id = '33333333-3333-3333-3333-333333333333'
→ Utilise: name_en, name_fr, edition, owned_en, owned_fr
```

---

## Rollback (si nécessaire)

**⚠️ Attention** : Le rollback supprime définitivement toutes les données D&D 5e.

```sql
-- 1. Supprimer les données D&D 5e
DELETE FROM books WHERE collection_id = '33333333-3333-3333-3333-333333333333';
DELETE FROM collections WHERE id = '33333333-3333-3333-3333-333333333333';

-- 2. Supprimer les index
DROP INDEX IF EXISTS idx_books_edition;
DROP INDEX IF EXISTS idx_user_books_owned_en;
DROP INDEX IF EXISTS idx_user_books_owned_fr;

-- 3. Supprimer les colonnes
ALTER TABLE books DROP COLUMN IF EXISTS name_en, DROP COLUMN IF EXISTS name_fr, DROP COLUMN IF EXISTS edition;
ALTER TABLE user_books DROP COLUMN IF EXISTS owned_en, DROP COLUMN IF EXISTS owned_fr;
```

**Note** : Ne pas supprimer l'index `idx_books_book_type` car il existait avant cette migration.

---

## Prochaines Étapes

### Backend

1. **Adapter le repository** (`book_repository.go`) :
   - Support du filtre `collection_id`
   - Support des filtres `owned_en`, `owned_fr`
   - Sélection des nouveaux champs dans les queries

2. **Adapter le service** (`book_service.go`) :
   - Logique de possession bilingue
   - Dispatch selon `collection_id`

3. **Adapter le handler** (`book_handler.go`) :
   - Body request étendu pour `PATCH /possession`
   - Validation des inputs selon la collection

### Frontend

1. **Créer la page** `/dnd5`
2. **Créer le composant** `DnD5BookCard` avec toggles EN/FR
3. **Ajouter le lien** dans la navigation

### Tests

1. Tests d'intégration pour les nouveaux endpoints
2. Tests E2E pour la page D&D 5e

---

## Support

**Questions** : Consulter la spécification technique complète :  
`/home/arnaud.dars/git/Collectoria/Specifications/technical/dnd5-books-collection-v1.md`

**Problèmes** : Vérifier les logs de la migration et exécuter `010_validation.sql` pour diagnostiquer.

---

**Migration validée le** : 2026-04-27  
**Statut** : ✅ Production-ready  
**Backward compatible** : ✅ Oui
