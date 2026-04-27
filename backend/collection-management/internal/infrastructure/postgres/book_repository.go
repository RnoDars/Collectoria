package postgres

import (
	"context"
	"fmt"
	"strings"

	"collectoria/collection-management/internal/domain"

	"github.com/google/uuid"
	"github.com/jmoiron/sqlx"
)

type BookRepository struct {
	db *sqlx.DB
}

func NewBookRepository(db *sqlx.DB) *BookRepository {
	return &BookRepository{db: db}
}

// GetBookByID récupère un livre par son ID
func (r *BookRepository) GetBookByID(ctx context.Context, id uuid.UUID) (*domain.Book, error) {
	query := `
		SELECT id, collection_id, number, title, name_en, name_fr, author, publication_date, edition, book_type, created_at, updated_at
		FROM books
		WHERE id = $1`

	var book domain.Book
	err := r.db.GetContext(ctx, &book, query, id)
	if err != nil {
		return nil, err
	}

	return &book, nil
}

// GetUserBook récupère la relation utilisateur-livre
func (r *BookRepository) GetUserBook(ctx context.Context, userID, bookID uuid.UUID) (*domain.UserBook, error) {
	query := `
		SELECT id, user_id, book_id, is_owned, owned_en, owned_fr, created_at, updated_at
		FROM user_books
		WHERE user_id = $1 AND book_id = $2`

	var userBook domain.UserBook
	err := r.db.GetContext(ctx, &userBook, query, userID, bookID)
	if err != nil {
		return nil, err
	}

	return &userBook, nil
}

// UpdateUserBook met à jour ou crée la possession d'un livre (UPSERT)
// DEPRECATED: Utiliser UpdateBookOwnership à la place
func (r *BookRepository) UpdateUserBook(ctx context.Context, userID, bookID uuid.UUID, isOwned bool) error {
	query := `
		INSERT INTO user_books (user_id, book_id, is_owned, created_at, updated_at)
		VALUES ($1, $2, $3, NOW(), NOW())
		ON CONFLICT (user_id, book_id)
		DO UPDATE SET is_owned = $3, updated_at = NOW()`

	_, err := r.db.ExecContext(ctx, query, userID, bookID, isOwned)
	return err
}

// UpdateBookOwnership met à jour la possession selon la collection (dispatch automatique)
func (r *BookRepository) UpdateBookOwnership(ctx context.Context, userID, bookID uuid.UUID, ownership domain.OwnershipUpdate) error {
	// 1. Déterminer la collection du livre
	var collectionID uuid.UUID
	err := r.db.GetContext(ctx, &collectionID, "SELECT collection_id FROM books WHERE id = $1", bookID)
	if err != nil {
		return fmt.Errorf("failed to get book collection: %w", err)
	}

	// UUIDs des collections
	royaumesOubliesID := uuid.MustParse("22222222-2222-2222-2222-222222222222")
	dnd5eID := uuid.MustParse("33333333-3333-3333-3333-333333333333")

	// 2. Dispatch selon la collection
	if collectionID == royaumesOubliesID {
		// Royaumes Oubliés: UPDATE is_owned
		if ownership.IsOwned == nil {
			return fmt.Errorf("is_owned is required for Royaumes Oubliés collection")
		}
		query := `
			INSERT INTO user_books (user_id, book_id, is_owned, created_at, updated_at)
			VALUES ($1, $2, $3, NOW(), NOW())
			ON CONFLICT (user_id, book_id)
			DO UPDATE SET is_owned = $3, updated_at = NOW()`
		_, err = r.db.ExecContext(ctx, query, userID, bookID, *ownership.IsOwned)
		return err
	} else if collectionID == dnd5eID {
		// D&D 5e: UPDATE owned_en et owned_fr
		query := `
			INSERT INTO user_books (user_id, book_id, is_owned, owned_en, owned_fr, created_at, updated_at)
			VALUES ($1, $2, false, $3, $4, NOW(), NOW())
			ON CONFLICT (user_id, book_id)
			DO UPDATE SET owned_en = $3, owned_fr = $4, updated_at = NOW()`
		_, err = r.db.ExecContext(ctx, query, userID, bookID, ownership.OwnedEn, ownership.OwnedFr)
		return err
	}

	return fmt.Errorf("unsupported collection ID: %s", collectionID)
}

// GetBooksCatalog récupère le catalogue de livres avec filtres et pagination
func (r *BookRepository) GetBooksCatalog(ctx context.Context, userID uuid.UUID, filter domain.BookFilter) (*domain.BookPage, error) {
	args := []interface{}{userID}
	idx := 2

	where := []string{}

	// Filtre par collection_id
	if filter.CollectionID != nil {
		where = append(where, fmt.Sprintf("b.collection_id = $%d", idx))
		collectionUUID, err := uuid.Parse(*filter.CollectionID)
		if err != nil {
			return nil, fmt.Errorf("invalid collection_id: %w", err)
		}
		args = append(args, collectionUUID)
		idx++
	}

	// Filtre de recherche dans le titre
	if filter.Search != "" {
		where = append(where, fmt.Sprintf("LOWER(b.title) LIKE LOWER($%d)", idx))
		like := "%" + strings.ToLower(filter.Search) + "%"
		args = append(args, like)
		idx++
	}

	// Filtre par auteur
	if filter.Author != "" {
		where = append(where, fmt.Sprintf("b.author = $%d", idx))
		args = append(args, filter.Author)
		idx++
	}

	// Filtre par type de livre
	if filter.BookType != "" {
		where = append(where, fmt.Sprintf("b.book_type = $%d", idx))
		args = append(args, filter.BookType)
		idx++
	}

	// Filtre par série (principal: 1-84, hors-serie: HS*)
	if filter.Series != "" {
		if filter.Series == "principal" {
			// Série principale: numéros 1-84 (pas de préfixe HS)
			where = append(where, "b.number !~ '^HS'")
		} else if filter.Series == "hors-serie" {
			// Hors série: numéros avec préfixe HS
			where = append(where, "b.number ~ '^HS'")
		}
	}

	// Filtre par possession
	if filter.IsOwned != nil {
		if *filter.IsOwned {
			where = append(where, "ub.is_owned = true")
		} else {
			where = append(where, "(ub.is_owned = false OR ub.book_id IS NULL)")
		}
	}

	whereClause := ""
	if len(where) > 0 {
		whereClause = "AND " + strings.Join(where, " AND ")
	}

	// Requête de comptage
	countQuery := fmt.Sprintf(`
		SELECT COUNT(*)
		FROM books b
		LEFT JOIN user_books ub ON b.id = ub.book_id AND ub.user_id = $1
		WHERE 1=1 %s`, whereClause)

	var total int
	if err := r.db.GetContext(ctx, &total, countQuery, args...); err != nil {
		return nil, err
	}

	// Calcul de l'offset et ajout des paramètres de pagination
	offset := (filter.Page - 1) * filter.Limit
	args = append(args, filter.Limit, offset)

	// Requête pour récupérer les livres
	// Ordre par numéro avec tri naturel (1, 2, 3... 10, 11... 84, HS1, HS2...)
	dataQuery := fmt.Sprintf(`
		SELECT
			b.id, b.collection_id, b.number, b.title, b.name_en, b.name_fr, b.author,
			b.publication_date, b.edition, b.book_type,
			b.created_at, b.updated_at,
			COALESCE(ub.is_owned, false) AS is_owned,
			ub.owned_en,
			ub.owned_fr
		FROM books b
		LEFT JOIN user_books ub ON b.id = ub.book_id AND ub.user_id = $1
		WHERE 1=1 %s
		ORDER BY
			CASE
				WHEN b.number ~ '^HS' THEN 1
				ELSE 0
			END,
			CASE
				WHEN b.number ~ '^\d+$' THEN CAST(b.number AS INTEGER)
				ELSE 0
			END,
			b.number
		LIMIT $%d OFFSET $%d`, whereClause, idx, idx+1)

	type row struct {
		ID              uuid.UUID   `db:"id"`
		CollectionID    uuid.UUID   `db:"collection_id"`
		Number          string      `db:"number"`
		Title           string      `db:"title"`
		NameEn          *string     `db:"name_en"`
		NameFr          *string     `db:"name_fr"`
		Author          string      `db:"author"`
		PublicationDate interface{} `db:"publication_date"`
		Edition         *string     `db:"edition"`
		BookType        string      `db:"book_type"`
		CreatedAt       interface{} `db:"created_at"`
		UpdatedAt       interface{} `db:"updated_at"`
		IsOwned         bool        `db:"is_owned"`
		OwnedEn         *bool       `db:"owned_en"`
		OwnedFr         *bool       `db:"owned_fr"`
	}

	var rows []row
	if err := r.db.SelectContext(ctx, &rows, dataQuery, args...); err != nil {
		return nil, err
	}

	books := make([]domain.BookWithOwnership, len(rows))
	for i, r := range rows {
		books[i] = domain.BookWithOwnership{
			Book: domain.Book{
				ID:           r.ID,
				CollectionID: r.CollectionID,
				Number:       r.Number,
				Title:        r.Title,
				NameEn:       r.NameEn,
				NameFr:       r.NameFr,
				Author:       r.Author,
				Edition:      r.Edition,
				BookType:     r.BookType,
			},
			IsOwned: r.IsOwned,
			OwnedEn: r.OwnedEn,
			OwnedFr: r.OwnedFr,
		}
	}

	return &domain.BookPage{
		Books:   books,
		Total:   total,
		Page:    filter.Page,
		HasMore: offset+len(rows) < total,
	}, nil
}

// Vérification statique que BookRepository implémente domain.BookRepository
var _ domain.BookRepository = (*BookRepository)(nil)
