package postgres

import (
	"context"
	"fmt"
	"strings"

	"collectoria/collection-management/internal/domain"

	"github.com/google/uuid"
	"github.com/jmoiron/sqlx"
)

type ForgottenRealmsNovelRepository struct {
	db *sqlx.DB
}

func NewForgottenRealmsNovelRepository(db *sqlx.DB) *ForgottenRealmsNovelRepository {
	return &ForgottenRealmsNovelRepository{db: db}
}

// GetNovelByID récupère un roman par son ID
func (r *ForgottenRealmsNovelRepository) GetNovelByID(ctx context.Context, id uuid.UUID) (*domain.ForgottenRealmsNovel, error) {
	query := `
		SELECT id, number, title, author, publication_date, book_type, created_at, updated_at
		FROM forgottenrealms_novels
		WHERE id = $1`

	var novel domain.ForgottenRealmsNovel
	err := r.db.GetContext(ctx, &novel, query, id)
	if err != nil {
		return nil, err
	}

	return &novel, nil
}

// GetUserNovel récupère la relation utilisateur-roman
func (r *ForgottenRealmsNovelRepository) GetUserNovel(ctx context.Context, userID, novelID uuid.UUID) (*domain.UserForgottenRealmsNovel, error) {
	query := `
		SELECT id, user_id, novel_id, is_owned, created_at, updated_at
		FROM user_forgottenrealms_novels
		WHERE user_id = $1 AND novel_id = $2`

	var userNovel domain.UserForgottenRealmsNovel
	err := r.db.GetContext(ctx, &userNovel, query, userID, novelID)
	if err != nil {
		return nil, err
	}

	return &userNovel, nil
}

// UpdateUserNovel met à jour ou crée la possession d'un roman (UPSERT)
func (r *ForgottenRealmsNovelRepository) UpdateUserNovel(ctx context.Context, userID, novelID uuid.UUID, isOwned bool) error {
	query := `
		INSERT INTO user_forgottenrealms_novels (user_id, novel_id, is_owned, created_at, updated_at)
		VALUES ($1, $2, $3, NOW(), NOW())
		ON CONFLICT (user_id, novel_id)
		DO UPDATE SET is_owned = $3, updated_at = NOW()`

	_, err := r.db.ExecContext(ctx, query, userID, novelID, isOwned)
	return err
}

// GetNovelsCatalog récupère le catalogue de romans avec filtres et pagination
func (r *ForgottenRealmsNovelRepository) GetNovelsCatalog(ctx context.Context, userID uuid.UUID, filter domain.ForgottenRealmsNovelFilter) (*domain.ForgottenRealmsNovelPage, error) {
	args := []interface{}{userID}
	idx := 2

	where := []string{}

	// Filtre de recherche dans le titre
	if filter.Search != "" {
		where = append(where, fmt.Sprintf("LOWER(n.title) LIKE LOWER($%d)", idx))
		like := "%" + strings.ToLower(filter.Search) + "%"
		args = append(args, like)
		idx++
	}

	// Filtre par auteur
	if filter.Author != "" {
		where = append(where, fmt.Sprintf("n.author = $%d", idx))
		args = append(args, filter.Author)
		idx++
	}

	// Filtre par type de livre
	if filter.BookType != "" {
		where = append(where, fmt.Sprintf("n.book_type = $%d", idx))
		args = append(args, filter.BookType)
		idx++
	}

	// Filtre par série (principal: 1-84, hors-serie: HS*)
	if filter.Series != "" {
		if filter.Series == "principal" {
			// Série principale: numéros 1-84 (pas de préfixe HS)
			where = append(where, "n.number !~ '^HS'")
		} else if filter.Series == "hors-serie" {
			// Hors série: numéros avec préfixe HS
			where = append(where, "n.number ~ '^HS'")
		}
	}

	// Filtre par possession
	if filter.IsOwned != nil {
		if *filter.IsOwned {
			where = append(where, "un.is_owned = true")
		} else {
			where = append(where, "(un.is_owned = false OR un.novel_id IS NULL)")
		}
	}

	whereClause := ""
	if len(where) > 0 {
		whereClause = "AND " + strings.Join(where, " AND ")
	}

	// Requête de comptage
	countQuery := fmt.Sprintf(`
		SELECT COUNT(*)
		FROM forgottenrealms_novels n
		LEFT JOIN user_forgottenrealms_novels un ON n.id = un.novel_id AND un.user_id = $1
		WHERE 1=1 %s`, whereClause)

	var total int
	if err := r.db.GetContext(ctx, &total, countQuery, args...); err != nil {
		return nil, err
	}

	// Calcul de l'offset et ajout des paramètres de pagination
	offset := (filter.Page - 1) * filter.Limit
	args = append(args, filter.Limit, offset)

	// Requête pour récupérer les romans
	// Ordre par numéro avec tri naturel (1, 2, 3... 10, 11... 84, HS1, HS2...)
	dataQuery := fmt.Sprintf(`
		SELECT
			n.id, n.number, n.title, n.author,
			n.publication_date, n.book_type,
			n.created_at, n.updated_at,
			COALESCE(un.is_owned, false) AS is_owned
		FROM forgottenrealms_novels n
		LEFT JOIN user_forgottenrealms_novels un ON n.id = un.novel_id AND un.user_id = $1
		WHERE 1=1 %s
		ORDER BY
			CASE
				WHEN n.number ~ '^HS' THEN 1
				ELSE 0
			END,
			CASE
				WHEN n.number ~ '^\d+$' THEN CAST(n.number AS INTEGER)
				ELSE 0
			END,
			n.number
		LIMIT $%d OFFSET $%d`, whereClause, idx, idx+1)

	type row struct {
		ID              uuid.UUID   `db:"id"`
		Number          string      `db:"number"`
		Title           string      `db:"title"`
		Author          string      `db:"author"`
		PublicationDate interface{} `db:"publication_date"`
		BookType        string      `db:"book_type"`
		CreatedAt       interface{} `db:"created_at"`
		UpdatedAt       interface{} `db:"updated_at"`
		IsOwned         bool        `db:"is_owned"`
	}

	var rows []row
	if err := r.db.SelectContext(ctx, &rows, dataQuery, args...); err != nil {
		return nil, err
	}

	novels := make([]domain.ForgottenRealmsNovelWithOwnership, len(rows))
	for i, r := range rows {
		novels[i] = domain.ForgottenRealmsNovelWithOwnership{
			ForgottenRealmsNovel: domain.ForgottenRealmsNovel{
				ID:       r.ID,
				Number:   r.Number,
				Title:    r.Title,
				Author:   r.Author,
				BookType: r.BookType,
			},
			IsOwned: r.IsOwned,
		}
	}

	return &domain.ForgottenRealmsNovelPage{
		Novels:  novels,
		Total:   total,
		Page:    filter.Page,
		HasMore: offset+len(rows) < total,
	}, nil
}
