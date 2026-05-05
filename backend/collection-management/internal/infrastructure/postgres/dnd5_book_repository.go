package postgres

import (
	"context"
	"database/sql"
	"fmt"
	"strings"

	"collectoria/collection-management/internal/domain"

	"github.com/google/uuid"
	"github.com/jmoiron/sqlx"
)

type DnD5BookRepository struct {
	db *sqlx.DB
}

func NewDnD5BookRepository(db *sqlx.DB) *DnD5BookRepository {
	return &DnD5BookRepository{db: db}
}

// GetBookByID récupère un livre par son ID
func (r *DnD5BookRepository) GetBookByID(ctx context.Context, id uuid.UUID) (*domain.DnD5Book, error) {
	query := `
		SELECT id, number, name_en, name_fr, book_type, created_at, updated_at
		FROM dnd5_books
		WHERE id = $1`

	var book domain.DnD5Book
	err := r.db.GetContext(ctx, &book, query, id)
	if err != nil {
		return nil, err
	}

	return &book, nil
}

// GetUserBook récupère la relation utilisateur-livre
func (r *DnD5BookRepository) GetUserBook(ctx context.Context, userID, bookID uuid.UUID) (*domain.UserDnD5Book, error) {
	query := `
		SELECT id, user_id, book_id, owned_en, owned_fr, created_at, updated_at
		FROM user_dnd5_books
		WHERE user_id = $1 AND book_id = $2`

	var userBook domain.UserDnD5Book
	err := r.db.GetContext(ctx, &userBook, query, userID, bookID)
	if err != nil {
		return nil, err
	}

	return &userBook, nil
}

// UpdateBookOwnership met à jour ou crée la possession d'un livre (UPSERT)
// Option A: SELECT état actuel + merge + UPDATE
// Cette implémentation garantit qu'une mise à jour partielle (par ex. owned_en seulement)
// ne réinitialise pas la valeur non fournie (owned_fr dans cet exemple).
func (r *DnD5BookRepository) UpdateBookOwnership(ctx context.Context, userID, bookID uuid.UUID, ownedEn, ownedFr *bool) error {
	// Étape 1 : Récupérer l'état actuel (si existe)
	var currentOwnedEn, currentOwnedFr *bool
	selectQuery := `SELECT owned_en, owned_fr FROM user_dnd5_books WHERE user_id = $1 AND book_id = $2`

	var current struct {
		OwnedEn *bool `db:"owned_en"`
		OwnedFr *bool `db:"owned_fr"`
	}

	err := r.db.GetContext(ctx, &current, selectQuery, userID, bookID)
	if err == nil {
		// L'enregistrement existe, on récupère les valeurs actuelles
		currentOwnedEn = current.OwnedEn
		currentOwnedFr = current.OwnedFr
	} else if err != sql.ErrNoRows {
		// Une erreur autre que "pas de ligne" est une vraie erreur
		return err
	}
	// Si err == sql.ErrNoRows (pas d'enregistrement), currentOwnedEn et currentOwnedFr restent nil

	// Étape 2 : Merge - ne remplacer que les valeurs non-nil fournies
	finalOwnedEn := ownedEn
	if finalOwnedEn == nil {
		finalOwnedEn = currentOwnedEn
	}

	finalOwnedFr := ownedFr
	if finalOwnedFr == nil {
		finalOwnedFr = currentOwnedFr
	}

	// Étape 3 : UPSERT avec les valeurs finales
	upsertQuery := `
		INSERT INTO user_dnd5_books (user_id, book_id, owned_en, owned_fr, created_at, updated_at)
		VALUES ($1, $2, $3, $4, NOW(), NOW())
		ON CONFLICT (user_id, book_id)
		DO UPDATE SET owned_en = $3, owned_fr = $4, updated_at = NOW()`

	_, err = r.db.ExecContext(ctx, upsertQuery, userID, bookID, finalOwnedEn, finalOwnedFr)
	return err
}

// GetBooksCatalog récupère le catalogue de livres avec filtres et pagination
func (r *DnD5BookRepository) GetBooksCatalog(ctx context.Context, userID uuid.UUID, filter domain.DnD5BookFilter) (*domain.DnD5BookPage, error) {
	args := []interface{}{userID}
	idx := 2

	where := []string{}

	// Filtre de recherche dans le titre (EN ou FR)
	if filter.Search != "" {
		where = append(where, fmt.Sprintf("(LOWER(b.name_en) LIKE LOWER($%d) OR LOWER(b.name_fr) LIKE LOWER($%d))", idx, idx))
		like := "%" + strings.ToLower(filter.Search) + "%"
		args = append(args, like)
		idx++
	}

	// Filtre par type de livre
	if filter.BookType != "" {
		where = append(where, fmt.Sprintf("b.book_type = $%d", idx))
		args = append(args, filter.BookType)
		idx++
	}

	// Filtre par version possédée (owned_en, owned_fr, both, none)
	if filter.OwnedVersion != "" {
		switch filter.OwnedVersion {
		case "en":
			where = append(where, "ub.owned_en = true")
		case "fr":
			where = append(where, "ub.owned_fr = true")
		case "both":
			where = append(where, "ub.owned_en = true AND ub.owned_fr = true")
		case "none":
			where = append(where, "(ub.owned_en = false OR ub.owned_en IS NULL) AND (ub.owned_fr = false OR ub.owned_fr IS NULL)")
		case "any":
			where = append(where, "(ub.owned_en = true OR ub.owned_fr = true)")
		}
	}

	whereClause := ""
	if len(where) > 0 {
		whereClause = "AND " + strings.Join(where, " AND ")
	}

	// Requête de comptage
	countQuery := fmt.Sprintf(`
		SELECT COUNT(*)
		FROM dnd5_books b
		LEFT JOIN user_dnd5_books ub ON b.id = ub.book_id AND ub.user_id = $1
		WHERE 1=1 %s`, whereClause)

	var total int
	if err := r.db.GetContext(ctx, &total, countQuery, args...); err != nil {
		return nil, err
	}

	// Calcul de l'offset et ajout des paramètres de pagination
	offset := (filter.Page - 1) * filter.Limit
	args = append(args, filter.Limit, offset)

	// Requête pour récupérer les livres
	// Ordre par name_en par défaut (tri alphabétique)
	orderBy := "b.name_en"
	if filter.SortBy == "name_fr" {
		orderBy = "COALESCE(b.name_fr, b.name_en)" // Fallback sur EN si FR est NULL
	} else if filter.SortBy == "number" {
		orderBy = "b.number"
	}

	dataQuery := fmt.Sprintf(`
		SELECT
			b.id, b.number, b.name_en, b.name_fr, b.book_type,
			b.created_at, b.updated_at,
			ub.owned_en,
			ub.owned_fr
		FROM dnd5_books b
		LEFT JOIN user_dnd5_books ub ON b.id = ub.book_id AND ub.user_id = $1
		WHERE 1=1 %s
		ORDER BY %s
		LIMIT $%d OFFSET $%d`, whereClause, orderBy, idx, idx+1)

	type row struct {
		ID        uuid.UUID   `db:"id"`
		Number    string      `db:"number"`
		NameEn    string      `db:"name_en"`
		NameFr    *string     `db:"name_fr"`
		BookType  string      `db:"book_type"`
		CreatedAt interface{} `db:"created_at"`
		UpdatedAt interface{} `db:"updated_at"`
		OwnedEn   *bool       `db:"owned_en"`
		OwnedFr   *bool       `db:"owned_fr"`
	}

	var rows []row
	if err := r.db.SelectContext(ctx, &rows, dataQuery, args...); err != nil {
		return nil, err
	}

	books := make([]domain.DnD5BookWithOwnership, len(rows))
	for i, r := range rows {
		books[i] = domain.DnD5BookWithOwnership{
			DnD5Book: domain.DnD5Book{
				ID:       r.ID,
				Number:   r.Number,
				NameEn:   r.NameEn,
				NameFr:   r.NameFr,
				BookType: r.BookType,
			},
			OwnedEn: r.OwnedEn,
			OwnedFr: r.OwnedFr,
		}
	}

	return &domain.DnD5BookPage{
		Books:   books,
		Total:   total,
		Page:    filter.Page,
		HasMore: offset+len(rows) < total,
	}, nil
}
