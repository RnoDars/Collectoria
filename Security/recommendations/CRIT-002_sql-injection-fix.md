# CRIT-002: Correction des Vulnérabilités d'Injection SQL

**Sévérité**: CRITICAL  
**Priorité**: P0  
**Estimation**: 1 jour  
**Status**: À faire

---

## Contexte

La méthode `GetCardsCatalog` dans `CardRepository` utilise `fmt.Sprintf` pour construire dynamiquement des requêtes SQL, ce qui crée un risque d'injection SQL malgré l'utilisation de paramètres positionnels.

### Code Vulnérable

```go
// internal/infrastructure/postgres/card_repository.go:46-153
func (r *CardRepository) GetCardsCatalog(ctx context.Context, userID uuid.UUID, filter domain.CardFilter) (*domain.CardPage, error) {
    args := []interface{}{userID}
    idx := 2
    where := []string{}
    
    if filter.Search != "" {
        // ❌ Construction de chaîne avec fmt.Sprintf
        where = append(where, fmt.Sprintf("(LOWER(c.name_fr) LIKE LOWER($%d) OR LOWER(c.name_en) LIKE LOWER($%d))", idx, idx+1))
        like := "%" + strings.ToLower(filter.Search) + "%"  // ❌ Manipulation manuelle
        args = append(args, like, like)
        idx += 2
    }
    if filter.Series != "" {
        where = append(where, fmt.Sprintf("c.series = $%d", idx))
        args = append(args, filter.Series)
        idx++
    }
    // ... autres filtres
    
    whereClause := ""
    if len(where) > 0 {
        whereClause = "AND " + strings.Join(where, " AND ")
    }
    
    // ❌ Injection de whereClause directement dans la requête
    countQuery := fmt.Sprintf(`
        SELECT COUNT(*)
        FROM cards c
        LEFT JOIN user_cards uc ON c.id = uc.card_id AND uc.user_id = $1
        WHERE c.collection_id IN (
            SELECT collection_id FROM user_collections WHERE user_id = $1
        ) %s`, whereClause)
    
    // ... reste du code
}
```

---

## Problèmes Identifiés

1. **Construction dynamique avec fmt.Sprintf**: Risque d'injection si les placeholders sont mal gérés
2. **Manipulation de chaîne pour LIKE pattern**: Potentielle faille si caractères spéciaux
3. **whereClause injecté directement**: Pas de validation de la structure SQL finale
4. **Pas de sanitization des filtres**: `filter.Series`, `filter.Type`, etc. non validés

---

## Solution Proposée

### Approche 1: Query Builder Sécurisé (Recommandé)

Utiliser un Query Builder comme **squirrel** ou **goqu** pour construire les requêtes de manière sécurisée.

#### Installation

```bash
go get github.com/Masterminds/squirrel
```

#### Implémentation

```go
// internal/infrastructure/postgres/card_repository.go
package postgres

import (
    "context"
    "fmt"
    
    "collectoria/collection-management/internal/domain"
    
    "github.com/google/uuid"
    "github.com/jmoiron/sqlx"
    "github.com/Masterminds/squirrel"
)

type CardRepository struct {
    db *sqlx.DB
}

func NewCardRepository(db *sqlx.DB) *CardRepository {
    return &CardRepository{db: db}
}

func (r *CardRepository) GetCardsCatalog(ctx context.Context, userID uuid.UUID, filter domain.CardFilter) (*domain.CardPage, error) {
    // Base query builder
    psql := squirrel.StatementBuilder.PlaceholderFormat(squirrel.Dollar)
    
    // Subquery for user collections
    userCollectionsSubquery := psql.
        Select("collection_id").
        From("user_collections").
        Where(squirrel.Eq{"user_id": userID})
    
    // Count query builder
    countBuilder := psql.
        Select("COUNT(*)").
        From("cards c").
        LeftJoin("user_cards uc ON c.id = uc.card_id AND uc.user_id = ?", userID).
        Where(squirrel.Expr("c.collection_id IN (?)", userCollectionsSubquery))
    
    // Apply filters
    countBuilder = r.applyFilters(countBuilder, filter)
    
    // Execute count query
    countSQL, countArgs, err := countBuilder.ToSql()
    if err != nil {
        return nil, fmt.Errorf("failed to build count query: %w", err)
    }
    
    var total int
    if err := r.db.GetContext(ctx, &total, countSQL, countArgs...); err != nil {
        return nil, fmt.Errorf("failed to count cards: %w", err)
    }
    
    // Data query builder
    offset := (filter.Page - 1) * filter.Limit
    
    dataBuilder := psql.
        Select(
            "c.id",
            "c.collection_id",
            "c.name_en",
            "c.name_fr",
            "c.card_type",
            "c.series",
            "c.rarity",
            "c.created_at",
            "c.updated_at",
            "COALESCE(uc.is_owned, false) AS is_owned",
        ).
        From("cards c").
        LeftJoin("user_cards uc ON c.id = uc.card_id AND uc.user_id = ?", userID).
        Where(squirrel.Expr("c.collection_id IN (?)", userCollectionsSubquery)).
        OrderBy("c.series", "c.name_fr").
        Limit(uint64(filter.Limit)).
        Offset(uint64(offset))
    
    // Apply filters
    dataBuilder = r.applyFilters(dataBuilder, filter)
    
    // Execute data query
    dataSQL, dataArgs, err := dataBuilder.ToSql()
    if err != nil {
        return nil, fmt.Errorf("failed to build data query: %w", err)
    }
    
    type row struct {
        ID           uuid.UUID   `db:"id"`
        CollectionID uuid.UUID   `db:"collection_id"`
        NameEN       string      `db:"name_en"`
        NameFR       string      `db:"name_fr"`
        CardType     string      `db:"card_type"`
        Series       string      `db:"series"`
        Rarity       string      `db:"rarity"`
        CreatedAt    interface{} `db:"created_at"`
        UpdatedAt    interface{} `db:"updated_at"`
        IsOwned      bool        `db:"is_owned"`
    }
    
    var rows []row
    if err := r.db.SelectContext(ctx, &rows, dataSQL, dataArgs...); err != nil {
        return nil, fmt.Errorf("failed to fetch cards: %w", err)
    }
    
    // Map to domain objects
    cards := make([]domain.CardWithOwnership, len(rows))
    for i, r := range rows {
        cards[i] = domain.CardWithOwnership{
            Card: domain.Card{
                ID:           r.ID,
                CollectionID: r.CollectionID,
                NameEN:       r.NameEN,
                NameFR:       r.NameFR,
                CardType:     r.CardType,
                Series:       r.Series,
                Rarity:       r.Rarity,
            },
            IsOwned: r.IsOwned,
        }
    }
    
    return &domain.CardPage{
        Cards:   cards,
        Total:   total,
        Page:    filter.Page,
        HasMore: offset+len(rows) < total,
    }, nil
}

// applyFilters applique les filtres de manière sécurisée
func (r *CardRepository) applyFilters(builder squirrel.SelectBuilder, filter domain.CardFilter) squirrel.SelectBuilder {
    // Search filter (case-insensitive LIKE on name_fr and name_en)
    if filter.Search != "" {
        searchPattern := "%" + filter.Search + "%"
        builder = builder.Where(
            squirrel.Or{
                squirrel.ILike{"c.name_fr": searchPattern},
                squirrel.ILike{"c.name_en": searchPattern},
            },
        )
    }
    
    // Series filter (exact match)
    if filter.Series != "" {
        builder = builder.Where(squirrel.Eq{"c.series": filter.Series})
    }
    
    // Type filter (exact match)
    if filter.Type != "" {
        builder = builder.Where(squirrel.Eq{"c.card_type": filter.Type})
    }
    
    // Rarity filter (prefix match with LIKE)
    if filter.Rarity != "" {
        builder = builder.Where(squirrel.Like{"c.rarity": filter.Rarity + "%"})
    }
    
    // Owned filter (boolean)
    if filter.Owned == "true" {
        builder = builder.Where(squirrel.Eq{"uc.is_owned": true})
    } else if filter.Owned == "false" {
        builder = builder.Where(
            squirrel.Or{
                squirrel.Eq{"uc.is_owned": false},
                squirrel.Eq{"uc.card_id": nil},
            },
        )
    }
    
    return builder
}

// Vérification statique que CardRepository implémente domain.CardRepository
var _ domain.CardRepository = (*CardRepository)(nil)
```

---

### Approche 2: Paramètres Stricts (Alternative sans dépendance)

Si vous ne voulez pas ajouter de dépendance, voici une version refactorisée avec paramètres stricts:

```go
func (r *CardRepository) GetCardsCatalog(ctx context.Context, userID uuid.UUID, filter domain.CardFilter) (*domain.CardPage, error) {
    // Validation des filtres
    if err := validateCardFilter(filter); err != nil {
        return nil, fmt.Errorf("invalid filter: %w", err)
    }
    
    // Construction sécurisée des clauses WHERE
    whereClauses := []string{}
    args := []interface{}{userID}  // $1
    paramIndex := 2
    
    // Base subquery for user collections
    baseWhere := "c.collection_id IN (SELECT collection_id FROM user_collections WHERE user_id = $1)"
    
    // Search filter
    if filter.Search != "" {
        whereClauses = append(whereClauses, 
            fmt.Sprintf("(LOWER(c.name_fr) LIKE LOWER($%d) OR LOWER(c.name_en) LIKE LOWER($%d))", 
            paramIndex, paramIndex+1))
        searchPattern := "%" + sanitizeSearchTerm(filter.Search) + "%"
        args = append(args, searchPattern, searchPattern)
        paramIndex += 2
    }
    
    // Series filter
    if filter.Series != "" {
        whereClauses = append(whereClauses, fmt.Sprintf("c.series = $%d", paramIndex))
        args = append(args, filter.Series)
        paramIndex++
    }
    
    // Type filter
    if filter.Type != "" {
        whereClauses = append(whereClauses, fmt.Sprintf("c.card_type = $%d", paramIndex))
        args = append(args, filter.Type)
        paramIndex++
    }
    
    // Rarity filter
    if filter.Rarity != "" {
        whereClauses = append(whereClauses, fmt.Sprintf("c.rarity LIKE $%d", paramIndex))
        args = append(args, filter.Rarity+"%")
        paramIndex++
    }
    
    // Owned filter
    if filter.Owned == "true" {
        whereClauses = append(whereClauses, "uc.is_owned = true")
    } else if filter.Owned == "false" {
        whereClauses = append(whereClauses, "(uc.is_owned = false OR uc.card_id IS NULL)")
    }
    
    // Combine WHERE clauses
    finalWhere := baseWhere
    if len(whereClauses) > 0 {
        finalWhere += " AND " + strings.Join(whereClauses, " AND ")
    }
    
    // Count query (immutable string template)
    countQuery := `
        SELECT COUNT(*)
        FROM cards c
        LEFT JOIN user_cards uc ON c.id = uc.card_id AND uc.user_id = $1
        WHERE ` + finalWhere
    
    var total int
    if err := r.db.GetContext(ctx, &total, countQuery, args...); err != nil {
        return nil, fmt.Errorf("failed to count cards: %w", err)
    }
    
    // Data query
    offset := (filter.Page - 1) * filter.Limit
    args = append(args, filter.Limit, offset)
    
    dataQuery := `
        SELECT
            c.id, c.collection_id, c.name_en, c.name_fr, c.card_type, c.series, c.rarity,
            c.created_at, c.updated_at,
            COALESCE(uc.is_owned, false) AS is_owned
        FROM cards c
        LEFT JOIN user_cards uc ON c.id = uc.card_id AND uc.user_id = $1
        WHERE ` + finalWhere + `
        ORDER BY c.series, c.name_fr
        LIMIT $` + fmt.Sprintf("%d", paramIndex) + ` OFFSET $` + fmt.Sprintf("%d", paramIndex+1)
    
    // ... reste du code (mapping rows)
}

// Validation des filtres
func validateCardFilter(filter domain.CardFilter) error {
    if filter.Page < 1 || filter.Page > 10000 {
        return fmt.Errorf("page must be between 1 and 10000")
    }
    if filter.Limit < 1 || filter.Limit > 200 {
        return fmt.Errorf("limit must be between 1 and 200")
    }
    if len(filter.Search) > 100 {
        return fmt.Errorf("search term too long (max 100 characters)")
    }
    return nil
}

// Sanitization du terme de recherche
func sanitizeSearchTerm(search string) string {
    // Échapper les caractères spéciaux de LIKE
    search = strings.ReplaceAll(search, "%", "\\%")
    search = strings.ReplaceAll(search, "_", "\\_")
    return search
}
```

---

## Validation des Filtres (Couche Domain)

### Ajouter Validation dans le Domain

```go
// internal/domain/card.go
package domain

import (
    "fmt"
    "strings"
)

type CardFilter struct {
    Search string
    Series string
    Type   string
    Rarity string
    Owned  string // "true", "false", or ""
    Page   int
    Limit  int
}

// Validate vérifie que le filtre est valide
func (f CardFilter) Validate() error {
    if f.Page < 1 || f.Page > 10000 {
        return fmt.Errorf("page must be between 1 and 10000")
    }
    if f.Limit < 1 || f.Limit > 200 {
        return fmt.Errorf("limit must be between 1 and 200")
    }
    if len(f.Search) > 100 {
        return fmt.Errorf("search term too long (max 100 characters)")
    }
    if f.Owned != "" && f.Owned != "true" && f.Owned != "false" {
        return fmt.Errorf("owned must be 'true', 'false', or empty")
    }
    // Vérifier les caractères interdits
    if strings.ContainsAny(f.Search, "<>{}[]|\\") {
        return fmt.Errorf("search contains invalid characters")
    }
    return nil
}
```

### Utiliser la Validation dans le Handler

```go
// internal/infrastructure/http/handlers/catalog_handler.go
func (h *CatalogHandler) GetCards(w http.ResponseWriter, r *http.Request) {
    ctx := r.Context()
    userID, _ := middleware.GetUserIDFromContext(ctx)
    
    q := r.URL.Query()
    page := parseIntParam(q.Get("page"), 1, 1, 10000)
    limit := parseIntParam(q.Get("limit"), 50, 1, 200)
    
    filter := domain.CardFilter{
        Search: q.Get("search"),
        Series: q.Get("series"),
        Type:   q.Get("type"),
        Rarity: q.Get("rarity"),
        Owned:  q.Get("owned"),
        Page:   page,
        Limit:  limit,
    }
    
    // ✅ Validation avant appel au service
    if err := filter.Validate(); err != nil {
        h.logger.Warn().Err(err).Msg("Invalid filter parameters")
        writeJSONError(w, h.logger, http.StatusBadRequest, "VALIDATION_ERROR", err.Error())
        return
    }
    
    result, err := h.service.GetCatalog(ctx, userID, filter)
    // ... rest of the code
}

// Helper pour parser les entiers avec bornes
func parseIntParam(s string, defaultVal, min, max int) int {
    if s == "" {
        return defaultVal
    }
    v, err := strconv.Atoi(s)
    if err != nil || v < min || v > max {
        return defaultVal
    }
    return v
}
```

---

## Tests de Sécurité

### Tests Unitaires

```go
// internal/infrastructure/postgres/card_repository_test.go
package postgres_test

import (
    "testing"
    
    "collectoria/collection-management/internal/domain"
    "github.com/stretchr/testify/assert"
)

func TestCardFilter_Validate(t *testing.T) {
    tests := []struct {
        name    string
        filter  domain.CardFilter
        wantErr bool
    }{
        {
            name: "valid filter",
            filter: domain.CardFilter{
                Search: "Gandalf",
                Page:   1,
                Limit:  50,
            },
            wantErr: false,
        },
        {
            name: "invalid page (too high)",
            filter: domain.CardFilter{
                Page:  999999,
                Limit: 50,
            },
            wantErr: true,
        },
        {
            name: "search too long",
            filter: domain.CardFilter{
                Search: strings.Repeat("a", 101),
                Page:   1,
                Limit:  50,
            },
            wantErr: true,
        },
        {
            name: "search with invalid characters",
            filter: domain.CardFilter{
                Search: "test<script>alert(1)</script>",
                Page:   1,
                Limit:  50,
            },
            wantErr: true,
        },
    }
    
    for _, tt := range tests {
        t.Run(tt.name, func(t *testing.T) {
            err := tt.filter.Validate()
            if tt.wantErr {
                assert.Error(t, err)
            } else {
                assert.NoError(t, err)
            }
        })
    }
}
```

### Tests d'Injection SQL

```bash
# Test avec caractères spéciaux SQL
curl "http://localhost:8080/api/v1/cards?search=%27%20OR%20%271%27=%271"
# Expected: Validation error ou résultats sans injection

# Test avec UNION injection
curl "http://localhost:8080/api/v1/cards?search=test%27%20UNION%20SELECT%20*%20FROM%20users--"
# Expected: Validation error ou résultats sans injection

# Test avec caractères échappés
curl "http://localhost:8080/api/v1/cards?search=test%25"
# Expected: Recherche littérale de "test%"
```

---

## Migration

### Étape 1: Choisir l'Approche
- **Recommandé**: Approche 1 (Query Builder Squirrel)
- **Alternative**: Approche 2 (Paramètres stricts)

### Étape 2: Implémentation
1. Installer dépendance si nécessaire
2. Refactorer `GetCardsCatalog`
3. Ajouter validation `CardFilter.Validate()`
4. Mettre à jour le handler pour valider les inputs

### Étape 3: Tests
1. Tests unitaires de validation
2. Tests d'injection SQL (manual + automated)
3. Tests de régression fonctionnels

### Étape 4: Déploiement
1. Backup de la base de données
2. Déployer la nouvelle version
3. Monitorer les logs pour erreurs

---

## Checklist de Validation

- [ ] Approche choisie (Query Builder ou Paramètres stricts)
- [ ] Dépendances installées
- [ ] `GetCardsCatalog` refactoré
- [ ] `CardFilter.Validate()` implémenté
- [ ] Handler mis à jour avec validation
- [ ] Tests unitaires ajoutés
- [ ] Tests d'injection SQL passent
- [ ] Tests de régression passent
- [ ] Code review effectué
- [ ] Documentation mise à jour

---

## Références

- [OWASP SQL Injection Prevention Cheat Sheet](https://cheatsheetseries.owasp.org/cheatsheets/SQL_Injection_Prevention_Cheat_Sheet.html)
- [Squirrel Query Builder](https://github.com/Masterminds/squirrel)
- [Go Database SQL Tutorial](https://go.dev/doc/database/sql-injection)
