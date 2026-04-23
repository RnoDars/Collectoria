# SQL Security Best Practices - Collection Management

## Vue d'ensemble

Ce document établit les règles de sécurité obligatoires pour toutes les requêtes SQL dans le microservice Collection Management. Ces pratiques ont été auditées et validées lors de l'audit sécurité du 2026-04-23.

**Score de sécurité actuel** : 9.0/10 (production-ready)  
**Vulnérabilités SQL Injection** : 0 (ZERO)

---

## Règles Obligatoires

### 1. TOUJOURS utiliser des requêtes paramétrées

**✅ BON** :
```go
query := `SELECT * FROM cards WHERE id = $1`
err := db.GetContext(ctx, &card, query, cardID)
```

**❌ MAUVAIS** :
```go
query := fmt.Sprintf("SELECT * FROM cards WHERE id = '%s'", cardID)
err := db.GetContext(ctx, &card, query)
```

**Pourquoi** : Les paramètres sont automatiquement échappés par le driver PostgreSQL, empêchant l'injection SQL.

---

### 2. JAMAIS de concaténation de strings pour construire du SQL

**✅ BON** :
```go
args := []interface{}{userID}
if filter.Search != "" {
    like := "%" + strings.ToLower(filter.Search) + "%"  // Concaténation en Go
    args = append(args, like)                            // Passé comme paramètre
}
query := `SELECT * FROM cards WHERE name LIKE $2`
db.SelectContext(ctx, &cards, query, args...)
```

**❌ MAUVAIS** :
```go
query := `SELECT * FROM cards WHERE name LIKE '%` + filter.Search + `%'`
db.SelectContext(ctx, &cards, query)
```

**Pourquoi** : La concaténation directe dans la requête SQL permet l'injection. La concaténation en Go suivie d'une paramètrisation est sûre.

---

### 3. TOUJOURS valider les types avant d'atteindre SQL

**✅ BON** :
```go
cardID, err := uuid.Parse(cardIDStr)
if err != nil {
    return nil, fmt.Errorf("invalid card ID: %w", err)
}
query := `SELECT * FROM cards WHERE id = $1`
db.GetContext(ctx, &card, query, cardID)
```

**❌ MAUVAIS** :
```go
query := `SELECT * FROM cards WHERE id = $1`
db.GetContext(ctx, &card, query, cardIDStr)  // String non validé
```

**Pourquoi** : La validation de type (UUID, int, etc.) rejette les inputs malformés AVANT qu'ils n'atteignent la base de données.

---

### 4. Requêtes dynamiques : séparer structure et données

Pour les requêtes avec filtres optionnels (WHERE dynamique), utiliser la technique de séparation structure/données :

**✅ BON** :
```go
args := []interface{}{userID}
idx := 2
where := []string{}

if filter.Series != "" {
    where = append(where, fmt.Sprintf("c.series = $%d", idx))  // Structure
    args = append(args, filter.Series)                          // Données
    idx++
}

whereClause := ""
if len(where) > 0 {
    whereClause = "AND " + strings.Join(where, " AND ")
}

query := fmt.Sprintf(`SELECT * FROM cards c WHERE c.user_id = $1 %s`, whereClause)
db.SelectContext(ctx, &cards, query, args...)
```

**Explication** :
1. `fmt.Sprintf` construit la **structure** SQL avec des placeholders (`$2`, `$3`)
2. Les **valeurs** utilisateur sont ajoutées à `args`
3. Le driver PostgreSQL lie `args` aux placeholders à l'exécution
4. Injection impossible car les valeurs n'apparaissent jamais dans la string SQL

**❌ MAUVAIS** :
```go
whereClause := ""
if filter.Series != "" {
    whereClause = fmt.Sprintf("AND c.series = '%s'", filter.Series)  // Injection possible !
}
query := fmt.Sprintf(`SELECT * FROM cards c WHERE c.user_id = $1 %s`, whereClause)
db.SelectContext(ctx, &cards, query, userID)
```

---

### 5. Clauses ORDER BY : TOUJOURS hardcodées

**✅ BON** :
```go
orderBy := "created_at DESC"  // Par défaut
if filter.SortBy == "name" {
    orderBy = "name ASC"       // Whitelist explicite
} else if filter.SortBy == "date" {
    orderBy = "created_at DESC"
}
query := fmt.Sprintf(`SELECT * FROM cards ORDER BY %s`, orderBy)
```

**❌ MAUVAIS** :
```go
query := fmt.Sprintf(`SELECT * FROM cards ORDER BY %s`, filter.SortBy)
```

**Pourquoi** : `ORDER BY` ne peut pas être paramétré (`$1`). Il faut utiliser une whitelist de colonnes autorisées.

---

### 6. LIMIT et OFFSET : toujours paramétrés

**✅ BON** :
```go
query := `SELECT * FROM cards LIMIT $1 OFFSET $2`
db.SelectContext(ctx, &cards, query, limit, offset)
```

**❌ MAUVAIS** :
```go
query := fmt.Sprintf(`SELECT * FROM cards LIMIT %d OFFSET %d`, limit, offset)
```

**Pourquoi** : Même si `limit` et `offset` sont des entiers, il faut rester cohérent et utiliser les paramètres.

---

### 7. JSON/JSONB : utiliser json.Marshal()

**✅ BON** :
```go
metadataJSON, err := json.Marshal(activity.Metadata)
if err != nil {
    return err
}
query := `INSERT INTO activities (metadata) VALUES ($1)`
db.ExecContext(ctx, query, metadataJSON)
```

**Pourquoi** : `json.Marshal()` échappe automatiquement tous les caractères spéciaux. Même si `Metadata` contient `'; DROP TABLE--`, il devient `"'; DROP TABLE--"` (string JSON sûr).

---

## Patterns Dangereux à Éviter

| Pattern | Risque | Exemple |
|---------|--------|---------|
| `query + userInput` | CRITIQUE | `"SELECT * FROM users WHERE name = '" + name + "'"` |
| `fmt.Sprintf` avec input utilisateur | CRITIQUE | `fmt.Sprintf("WHERE id = %s", userID)` |
| `strings.Replace` dans query | HAUTE | `strings.Replace(query, "{{ID}}", userID, -1)` |
| ORDER BY avec input utilisateur | HAUTE | `ORDER BY ` + userColumn |
| Interpolation de template | HAUTE | `template.Execute(&query, userInput)` |

---

## Checklist de Revue de Code

Avant de merger toute modification de requête SQL, vérifier :

- [ ] Tous les inputs utilisateur passent par des paramètres (`$1`, `$2`, etc.)
- [ ] Aucune concaténation de string dans la requête SQL finale
- [ ] Les UUIDs sont parsés avec `uuid.Parse()` avant utilisation
- [ ] Les clauses `ORDER BY` utilisent une whitelist de colonnes
- [ ] Les clauses `LIMIT` et `OFFSET` sont paramétrées
- [ ] Le code suit les exemples ✅ BON de ce document
- [ ] Le code ne contient aucun des patterns ❌ MAUVAIS

---

## Exemples Complets

### Exemple 1 : Requête Simple

```go
func (r *CardRepository) GetCardByID(ctx context.Context, id uuid.UUID) (*domain.Card, error) {
    query := `
        SELECT id, collection_id, name_en, name_fr, card_type, series, rarity
        FROM cards
        WHERE id = $1
    `
    
    var card domain.Card
    err := r.db.GetContext(ctx, &card, query, id)
    if err != nil {
        return nil, err
    }
    
    return &card, nil
}
```

**Sécurité** :
- ✅ Paramètre `$1` pour `id`
- ✅ Type `uuid.UUID` (validé en amont)
- ✅ Aucune concaténation

---

### Exemple 2 : Requête Dynamique Complexe

```go
func (r *CardRepository) GetCardsCatalog(ctx context.Context, userID uuid.UUID, filter domain.CardFilter) (*domain.CardPage, error) {
    args := []interface{}{userID}
    idx := 2
    where := []string{}
    
    // Filtre par recherche (nom)
    if filter.Search != "" {
        where = append(where, fmt.Sprintf("(LOWER(c.name_fr) LIKE LOWER($%d) OR LOWER(c.name_en) LIKE LOWER($%d))", idx, idx+1))
        like := "%" + strings.ToLower(filter.Search) + "%"  // Concaténation en Go (sûr)
        args = append(args, like, like)                      // Paramètres
        idx += 2
    }
    
    // Filtre par série
    if filter.Series != "" {
        where = append(where, fmt.Sprintf("c.series = $%d", idx))
        args = append(args, filter.Series)
        idx++
    }
    
    // Construction de la clause WHERE
    whereClause := ""
    if len(where) > 0 {
        whereClause = "AND " + strings.Join(where, " AND ")
    }
    
    // Requête avec clause WHERE dynamique
    query := fmt.Sprintf(`
        SELECT c.id, c.name_fr, c.name_en, c.series, c.rarity
        FROM cards c
        WHERE c.collection_id IN (
            SELECT collection_id FROM user_collections WHERE user_id = $1
        ) %s
        ORDER BY c.series, c.name_fr
        LIMIT $%d OFFSET $%d
    `, whereClause, idx, idx+1)
    
    offset := (filter.Page - 1) * filter.Limit
    args = append(args, filter.Limit, offset)
    
    var cards []domain.Card
    err := r.db.SelectContext(ctx, &cards, query, args...)
    if err != nil {
        return nil, err
    }
    
    return &domain.CardPage{Cards: cards}, nil
}
```

**Sécurité** :
- ✅ `filter.Search` : concaténé en Go puis paramétré (`$2`, `$3`)
- ✅ `filter.Series` : passé comme paramètre `$4`
- ✅ `whereClause` : contient la **structure** (`"c.series = $4"`) pas les valeurs
- ✅ `LIMIT` et `OFFSET` : paramétrés (`$5`, `$6`)
- ✅ `ORDER BY` : hardcodé (`c.series, c.name_fr`)

**Pourquoi c'est sûr** :
1. `fmt.Sprintf` construit la structure SQL avec les numéros de paramètres
2. Les valeurs utilisateur sont dans `args`
3. Le driver PostgreSQL lie `args` aux paramètres à l'exécution
4. Même avec `filter.Search = "'; DROP TABLE--"`, le payload devient un paramètre string

---

### Exemple 3 : UPSERT avec JSON

```go
func (r *ActivityRepository) Create(ctx context.Context, activity *domain.Activity) error {
    // Marshaller les métadonnées en JSONB (échappe automatiquement)
    metadataJSON, err := json.Marshal(activity.Metadata)
    if err != nil {
        return fmt.Errorf("failed to marshal metadata: %w", err)
    }
    
    query := `
        INSERT INTO activities (id, user_id, activity_type, metadata, created_at)
        VALUES ($1, $2, $3, $4, $5)
    `
    
    _, err = r.db.ExecContext(
        ctx,
        query,
        activity.ID,
        activity.UserID,
        activity.Type,
        metadataJSON,
        activity.Timestamp,
    )
    
    return err
}
```

**Sécurité** :
- ✅ `json.Marshal()` échappe tout caractère SQL spécial
- ✅ Tous les paramètres sont typés (UUID, string, []byte, time.Time)
- ✅ Même si `activity.Metadata["card_name"] = "'; DROP--"`, il devient `{"card_name": "'; DROP--"}` (JSON sûr)

---

## Outils et Tests

### Analyse Statique

Script : `Security/scripts/analyze-sql-queries.sh`

```bash
cd Security/scripts
./analyze-sql-queries.sh
```

Détecte automatiquement :
- Concaténations dangereuses
- `fmt.Sprintf` avec inputs utilisateur
- Clauses `ORDER BY` dynamiques
- String manipulation dans queries

### Tests d'Injection

Tests : `backend/collection-management/tests/security/sql_injection_test.go`

```bash
cd backend/collection-management
go test -v ./tests/security/... -tags=integration
```

105 scénarios d'injection testés couvrant :
- Injection booléenne (`' OR '1'='1`)
- Injection destructive (`'; DROP TABLE--`)
- UNION-based injection
- Blind SQL injection
- Time-based injection

---

## Références

### Internes
- Audit complet : `Security/audit-logs/2026-04-23_sql-injection-audit.md`
- Analyse statique : `Security/scripts/analyze-sql-queries.sh`
- Tests automatisés : `tests/security/sql_injection_test.go`

### Externes
- [OWASP SQL Injection Prevention](https://cheatsheetseries.owasp.org/cheatsheets/SQL_Injection_Prevention_Cheat_Sheet.html)
- [CWE-89: SQL Injection](https://cwe.mitre.org/data/definitions/89.html)
- [PostgreSQL Prepared Statements](https://www.postgresql.org/docs/current/sql-prepare.html)
- [Go database/sql Security](https://golang.org/pkg/database/sql/)

---

## Support

Pour toute question sur la sécurité SQL :
1. Consulter ce document
2. Lire l'audit complet (`Security/audit-logs/2026-04-23_sql-injection-audit.md`)
3. Exécuter l'analyse statique (`analyze-sql-queries.sh`)
4. Contacter l'équipe sécurité

**Dernière mise à jour** : 2026-04-23  
**Score de sécurité** : 9.0/10  
**Vulnérabilités connues** : 0
