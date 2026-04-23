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
		SELECT id, collection_id, number, title, author, publication_date, book_type, created_at, updated_at
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
		SELECT id, user_id, book_id, is_owned, created_at, updated_at
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
func (r *BookRepository) UpdateUserBook(ctx context.Context, userID, bookID uuid.UUID, isOwned bool) error {
	query := `
		INSERT INTO user_books (user_id, book_id, is_owned, created_at, updated_at)
		VALUES ($1, $2, $3, NOW(), NOW())
		ON CONFLICT (user_id, book_id)
		DO UPDATE SET is_owned = $3, updated_at = NOW()`

	_, err := r.db.ExecContext(ctx, query, userID, bookID, isOwned)
	return err
}

// GetBooksCatalog récupère le catalogue de livres avec filtres et pagination
func (r *BookRepository) GetBooksCatalog(ctx context.Context, userID uuid.UUID, filter domain.BookFilter) (*domain.BookPage, error) {
	args := []interface{}{userID}
	idx := 2

	where := []string{}

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
		WHERE b.collection_id IN (
			SELECT collection_id FROM user_collections WHERE user_id = $1
		) %s`, whereClause)

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
			b.id, b.collection_id, b.number, b.title, b.author, b.publication_date, b.book_type,
			b.created_at, b.updated_at,
			COALESCE(ub.is_owned, false) AS is_owned
		FROM books b
		LEFT JOIN user_books ub ON b.id = ub.book_id AND ub.user_id = $1
		WHERE b.collection_id IN (
			SELECT collection_id FROM user_collections WHERE user_id = $1
		) %s
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
		ID              uuid.UUID `db:"id"`
		CollectionID    uuid.UUID `db:"collection_id"`
		Number          string    `db:"number"`
		Title           string    `db:"title"`
		Author          string    `db:"author"`
		PublicationDate interface{} `db:"publication_date"`
		BookType        string    `db:"book_type"`
		CreatedAt       interface{} `db:"created_at"`
		UpdatedAt       interface{} `db:"updated_at"`
		IsOwned         bool      `db:"is_owned"`
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
				Author:       r.Author,
				BookType:     r.BookType,
			},
			IsOwned: r.IsOwned,
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
