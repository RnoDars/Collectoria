# Guide de Test - Support D&D 5e

Ce guide explique comment tester manuellement les nouvelles fonctionnalités D&D 5e.

## Prérequis

1. **Backend démarré** sur `http://localhost:8080`
2. **Base de données PostgreSQL** avec migration 010 appliquée
3. **Utilisateur de test** : `test@collectoria.com` / `test123`
4. **jq** installé pour parser le JSON (optionnel mais recommandé)

## Démarrage Rapide

### 1. Démarrer l'environnement

```bash
# Dans terminal 1: PostgreSQL
cd /home/arnaud.dars/git/Collectoria/backend/collection-management
docker compose up -d

# Dans terminal 2: Backend
export DB_HOST=localhost DB_PORT=5432 DB_USER=collectoria DB_PASSWORD=collectoria DB_NAME=collection_management SERVER_PORT=8080
export JWT_SECRET=collectoria-super-secret-jwt-key-64-chars-minimum-for-security-ok JWT_EXPIRATION_HOURS=24 JWT_ISSUER=collectoria-api
go run cmd/api/main.go
```

### 2. Lancer le script de test automatique

```bash
cd /home/arnaud.dars/git/Collectoria/backend/collection-management
chmod +x test_dnd5_endpoints.sh
./test_dnd5_endpoints.sh
```

Le script teste automatiquement :
- ✅ Login et récupération du token
- ✅ GET tous les livres (sans filtre)
- ✅ GET livres Royaumes Oubliés (avec collection_id)
- ✅ GET livres D&D 5e (avec collection_id)
- ✅ PATCH possession D&D 5e (owned_en, owned_fr)
- ✅ PATCH possession Royaumes Oubliés (is_owned)
- ✅ Validation des champs (rejet des combinaisons invalides)

**Résultat attendu** : Tous les tests doivent afficher ✅

---

## Tests Manuels avec curl

### Étape 1: Login et récupération du token

```bash
# Login
TOKEN=$(curl -s -X POST "http://localhost:8080/api/v1/auth/login" \
  -H "Content-Type: application/json" \
  -d '{"email":"test@collectoria.com","password":"test123"}' | jq -r '.token')

echo "Token: $TOKEN"
```

### Étape 2: Tester GET /books sans filtre

```bash
curl -s -X GET "http://localhost:8080/api/v1/books?limit=10" \
  -H "Authorization: Bearer $TOKEN" | jq .
```

**Attendu** :
- Réponse avec mélange de livres Royaumes Oubliés ET D&D 5e
- Total ≈ 147 livres (94 RO + 53 D&D)

### Étape 3: Tester GET /books avec filtre Royaumes Oubliés

```bash
curl -s -X GET "http://localhost:8080/api/v1/books?collection_id=22222222-2222-2222-2222-222222222222&limit=10" \
  -H "Authorization: Bearer $TOKEN" | jq .
```

**Attendu** :
- Uniquement des livres Royaumes Oubliés
- Champs `edition`, `name_en`, `name_fr` = `null`
- Champs `owned_en`, `owned_fr` = `null`
- Champ `is_owned` = `true` ou `false`

**Exemple de livre RO** :
```json
{
  "id": "uuid",
  "collection_id": "22222222-2222-2222-2222-222222222222",
  "number": "1",
  "title": "Les Émeraudes Brisées",
  "name_en": null,
  "name_fr": null,
  "edition": null,
  "book_type": "roman",
  "is_owned": true,
  "owned_en": null,
  "owned_fr": null
}
```

### Étape 4: Tester GET /books avec filtre D&D 5e

```bash
curl -s -X GET "http://localhost:8080/api/v1/books?collection_id=33333333-3333-3333-3333-333333333333&limit=10" \
  -H "Authorization: Bearer $TOKEN" | jq .
```

**Attendu** :
- Uniquement des livres D&D 5e
- Champ `edition` = `"D&D 5"`
- Champs `name_en`, `name_fr` présents
- Champs `owned_en`, `owned_fr` = `true`, `false`, ou `null`
- Champ `is_owned` = `false` (toujours false pour D&D 5e)

**Exemple de livre D&D 5e** :
```json
{
  "id": "uuid",
  "collection_id": "33333333-3333-3333-3333-333333333333",
  "number": "PHB2014",
  "title": "Player's Handbook - 2014",
  "name_en": "Player's Handbook - 2014",
  "name_fr": "Manuel des joueurs - 2014",
  "edition": "D&D 5",
  "book_type": "Core Rules",
  "is_owned": false,
  "owned_en": true,
  "owned_fr": false
}
```

### Étape 5: Récupérer un livre D&D 5e pour test PATCH

```bash
# Récupérer l'ID du premier livre D&D 5e
BOOK_DND_ID=$(curl -s -X GET "http://localhost:8080/api/v1/books?collection_id=33333333-3333-3333-3333-333333333333&limit=1" \
  -H "Authorization: Bearer $TOKEN" | jq -r '.books[0].id')

echo "Book D&D ID: $BOOK_DND_ID"
```

### Étape 6: Tester PATCH livre D&D 5e avec owned_en et owned_fr

```bash
curl -s -X PATCH "http://localhost:8080/api/v1/books/$BOOK_DND_ID/possession" \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"owned_en": true, "owned_fr": false}' | jq .
```

**Attendu** :
- HTTP 200
- Réponse avec `owned_en: true` et `owned_fr: false`
- `is_owned` reste `false`

### Étape 7: Tester PATCH livre Royaumes Oubliés avec is_owned

```bash
# Récupérer l'ID du premier livre Royaumes Oubliés
BOOK_RO_ID=$(curl -s -X GET "http://localhost:8080/api/v1/books?collection_id=22222222-2222-2222-2222-222222222222&limit=1" \
  -H "Authorization: Bearer $TOKEN" | jq -r '.books[0].id')

echo "Book RO ID: $BOOK_RO_ID"

# Mettre à jour la possession
curl -s -X PATCH "http://localhost:8080/api/v1/books/$BOOK_RO_ID/possession" \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"is_owned": true}' | jq .
```

**Attendu** :
- HTTP 200
- Réponse avec `is_owned: true`
- `owned_en` et `owned_fr` restent `null`

### Étape 8: Tester validation - owned_en sur livre Royaumes Oubliés (doit échouer)

```bash
curl -i -X PATCH "http://localhost:8080/api/v1/books/$BOOK_RO_ID/possession" \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"owned_en": true}'
```

**Attendu** :
- HTTP 400 Bad Request
- Message d'erreur : `"owned_en/owned_fr not allowed for Royaumes Oubliés books"`

### Étape 9: Tester validation - is_owned sur livre D&D 5e (doit échouer)

```bash
curl -i -X PATCH "http://localhost:8080/api/v1/books/$BOOK_DND_ID/possession" \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"is_owned": true}'
```

**Attendu** :
- HTTP 400 Bad Request
- Message d'erreur : `"is_owned not allowed for D&D 5e books"`

---

## Tests Unitaires

### Lancer les tests Go

```bash
cd /home/arnaud.dars/git/Collectoria/backend/collection-management

# Tests unitaires (mocks)
go test ./internal/infrastructure/postgres -v -short

# Tests d'intégration (nécessite PostgreSQL)
go test ./internal/infrastructure/postgres -v
```

**Tests inclus** :
- `TestUpdateBookOwnership_RoyaumesOublies` : Validation logique RO
- `TestUpdateBookOwnership_DnD5e` : Validation logique D&D 5e
- `TestGetBooksCatalog_CollectionFilter` : Filtre par collection_id

---

## Cas de Test Détaillés

### Cas 1: Créer une possession bilingue D&D 5e

**Objectif** : Marquer un livre D&D 5e comme possédé en anglais uniquement

**Étapes** :
1. Récupérer un livre D&D 5e non possédé
2. PATCH avec `{"owned_en": true, "owned_fr": false}`
3. Vérifier la réponse

**Résultat attendu** :
- `owned_en: true`
- `owned_fr: false`
- `is_owned: false`

### Cas 2: Créer une possession simple Royaumes Oubliés

**Objectif** : Marquer un livre Royaumes Oubliés comme possédé

**Étapes** :
1. Récupérer un livre Royaumes Oubliés non possédé
2. PATCH avec `{"is_owned": true}`
3. Vérifier la réponse

**Résultat attendu** :
- `is_owned: true`
- `owned_en: null`
- `owned_fr: null`

### Cas 3: Mettre à jour une possession existante D&D 5e

**Objectif** : Changer la possession de EN → FR

**Étapes** :
1. Récupérer un livre D&D 5e possédé en EN
2. PATCH avec `{"owned_en": false, "owned_fr": true}`
3. Vérifier la réponse

**Résultat attendu** :
- `owned_en: false`
- `owned_fr: true`

### Cas 4: Filtrer par collection et par possession

**Objectif** : Récupérer uniquement les livres D&D 5e possédés en français

**Étapes** :
1. GET `/books?collection_id=33333333-3333-3333-3333-333333333333&is_owned=true`
2. Vérifier que tous les livres retournés ont `owned_fr: true` ou `owned_en: true`

**Note** : Le filtre `is_owned` actuel ne filtre pas encore par `owned_en`/`owned_fr`. Cela nécessite une évolution future.

---

## Problèmes Connus et Solutions

### Problème: Token expired (401)
**Solution** : Re-faire le login pour obtenir un nouveau token

### Problème: Book not found (404)
**Solution** : Vérifier que l'UUID du livre est correct et existe dans la base

### Problème: Invalid collection_id (400)
**Solution** : Vérifier le format UUID (avec tirets)

### Problème: Connection refused
**Solution** : Vérifier que le backend est démarré sur le port 8080

---

## Checklist de Validation Complète

- [ ] Backend démarre sans erreur
- [ ] Health check répond HTTP 200 : `curl http://localhost:8080/api/v1/health`
- [ ] Login réussit et retourne un token
- [ ] GET /books sans filtre retourne 147 livres
- [ ] GET /books avec `collection_id=RO` retourne 94 livres
- [ ] GET /books avec `collection_id=DND` retourne 53 livres
- [ ] Tous les livres RO ont `edition: null`
- [ ] Tous les livres D&D ont `edition: "D&D 5"`
- [ ] PATCH livre D&D avec `owned_en/owned_fr` réussit
- [ ] PATCH livre RO avec `is_owned` réussit
- [ ] PATCH livre RO avec `owned_en` échoue HTTP 400
- [ ] PATCH livre D&D avec `is_owned` échoue HTTP 400
- [ ] Tests unitaires passent tous (go test)

---

## Ressources

- **Migration SQL** : `migrations/010_add_dnd5_collection.sql`
- **Changelog** : `CHANGELOG_DND5E_SUPPORT.md`
- **Script de test automatique** : `test_dnd5_endpoints.sh`
- **Tests unitaires** : `internal/infrastructure/postgres/book_repository_test.go`

---

## Support

En cas de problème, vérifier :
1. Logs du backend : rechercher les erreurs HTTP 500
2. Logs PostgreSQL : vérifier les erreurs SQL
3. Migration appliquée : `SELECT * FROM schema_migrations WHERE version = 10;`
4. Données présentes : `SELECT COUNT(*) FROM books WHERE collection_id = '33333333-3333-3333-3333-333333333333';` (doit retourner 53)

Bonne validation ! 🎲📚
