# Tri alphabétique — Guide technique

**Service** : Collection Management  
**Date** : 2026-04-25  
**Fichier concerné** : `internal/infrastructure/postgres/card_repository.go`

---

## Vue d'ensemble

Le tri des cartes est effectué côté serveur (PostgreSQL). Il est obligatoire car la pagination par scroll infini ne permet pas un tri fiable côté client. L'endpoint `GET /api/v1/cards` accepte deux paramètres de tri.

---

## Paramètres API

| Paramètre  | Valeurs acceptées      | Défaut    | Comportement si invalide     |
|------------|------------------------|-----------|------------------------------|
| `sort_by`  | `name_fr`, `name_en`   | `name_fr` | Retombe sur `name_fr` silencieusement |
| `sort_dir` | `asc`, `desc`          | `asc`     | Retombe sur `asc` silencieusement     |

La validation est effectuée dans le handler (`catalog_handler.go`) avant transmission au repository. Aucune erreur HTTP n'est retournée pour une valeur invalide : on applique le défaut silencieusement.

---

## Whitelist de sécurité (protection SQL injection)

Dans `card_repository.go`, la colonne de tri est résolue via une whitelist stricte, jamais par interpolation directe de l'input :

```go
var sortColumnWhitelist = map[string]string{
    "name_fr": "c.name_fr",
    "name_en": "c.name_en",
}

sortCol, ok := sortColumnWhitelist[filter.SortBy]
if !ok {
    sortCol = "c.name_fr" // fallback si SortBy absent ou invalide
}
```

La direction est construite par comparaison stricte :

```go
sortDir := "ASC"
if strings.ToLower(filter.SortDir) == "desc" {
    sortDir = "DESC"
}
```

Ces deux patterns garantissent qu'aucune valeur contrôlée par l'utilisateur n'est interpolée directement dans le SQL.

---

## Normalisation du tri

Les données MECCG contiennent des noms avec accents (`é`, `è`, `à`, `œ`) et des guillemets typographiques (`"`). Sans normalisation, ces caractères provoquent un ordre alphabétique incorrect.

### Clause ORDER BY finale

```sql
ORDER BY unaccent(REPLACE(col, '"', '')) ASC|DESC NULLS FIRST
```

### Règle 1 — Guillemets ignorés

`REPLACE(col, '"', '')` supprime les guillemets typographiques avant le tri.

**Exemple** : `"Bert" (Bûrat)` trie avec les **B** et non avant la lettre A.

### Règle 2 — Accents normalisés

`unaccent(...)` supprime les diacritiques : `é` → `e`, `è` → `e`, `à` → `a`.

**Exemple** : `Éowyn` trie avec les **E** et non en fin de liste.

### Règle 3 — Ligature `œ`

`unaccent` normalise automatiquement `œ` en `oe`.

**Exemple** : `L'Œil` trie comme `L'OEil`, parmi les **O**.

### Construction en Go

```go
// unaccent : normalise accents (é→e, à→a) et œ→oe
// REPLACE : ignore les guillemets " dans l'ordre alphabétique
orderClause := fmt.Sprintf(
    "ORDER BY unaccent(REPLACE(%s, '\"', '')) %s NULLS FIRST",
    sortCol, sortDir,
)
```

### NULLS FIRST

Les cartes dont le champ trié est NULL apparaissent en début de liste. Cela concerne principalement `name_fr` qui peut être absent sur certaines cartes non encore traduites.

---

## Prérequis PostgreSQL

L'extension `unaccent` doit être activée dans la base de données. Elle est fournie par défaut avec PostgreSQL mais doit être activée explicitement :

```sql
CREATE EXTENSION IF NOT EXISTS unaccent;
```

Cette commande est idempotente. Elle doit être exécutée une fois par base de données, via une migration dédiée ou le script d'initialisation du conteneur.

**Vérifier que l'extension est active** :

```sql
SELECT * FROM pg_extension WHERE extname = 'unaccent';
```

---

## Exemples de requêtes curl

```bash
# Tri par défaut : nom français, ordre croissant
curl -H "Authorization: Bearer <token>" \
  "http://localhost:8080/api/v1/cards?page=1&limit=50"

# Tri par nom anglais, ordre croissant
curl -H "Authorization: Bearer <token>" \
  "http://localhost:8080/api/v1/cards?page=1&limit=50&sort_by=name_en&sort_dir=asc"

# Tri par nom français, ordre décroissant
curl -H "Authorization: Bearer <token>" \
  "http://localhost:8080/api/v1/cards?page=1&limit=50&sort_by=name_fr&sort_dir=desc"

# Tri par nom anglais, ordre décroissant
curl -H "Authorization: Bearer <token>" \
  "http://localhost:8080/api/v1/cards?page=1&limit=50&sort_by=name_en&sort_dir=desc"

# Valeur invalide → retombe sur défaut (name_fr ASC), HTTP 200
curl -H "Authorization: Bearer <token>" \
  "http://localhost:8080/api/v1/cards?page=1&limit=50&sort_by=invalid_col&sort_dir=invalid_dir"
```

---

## Étendre le tri à un nouvel endpoint

Pour appliquer ce pattern sur un futur endpoint de tri alphabétique :

1. Ajouter `SortBy` et `SortDir` dans le struct de filtre du domaine concerné.
2. Lire et valider les query params dans le handler, avec défaut silencieux.
3. Définir une whitelist des colonnes autorisées dans le repository.
4. Construire `orderClause` avec `unaccent(REPLACE(...))` si les données peuvent contenir des accents ou guillemets.
5. Vérifier que l'extension `unaccent` est activée dans la base de données cible.

Voir la spec complète : `Specifications/technical/cards-sort-feature-v1.md`
