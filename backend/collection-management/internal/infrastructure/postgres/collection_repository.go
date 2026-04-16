package postgres

import (
	"context"
	"database/sql"
	"time"

	"collectoria/collection-management/internal/domain"

	"github.com/google/uuid"
	"github.com/jmoiron/sqlx"
)

// CollectionRepository implémente l'interface domain.CollectionRepository
type CollectionRepository struct {
	db *sqlx.DB
}

// NewCollectionRepository crée un nouveau repository
func NewCollectionRepository(db *sqlx.DB) *CollectionRepository {
	return &CollectionRepository{db: db}
}

// GetAllCollections récupère toutes les collections
func (r *CollectionRepository) GetAllCollections(ctx context.Context) ([]domain.Collection, error) {
	query := `
		SELECT id, name, slug, category, total_cards, description, created_at, updated_at
		FROM collections
		ORDER BY name
	`

	var collections []domain.Collection
	err := r.db.SelectContext(ctx, &collections, query)
	if err != nil {
		return nil, err
	}

	return collections, nil
}

// GetCollectionByID récupère une collection par son ID
func (r *CollectionRepository) GetCollectionByID(ctx context.Context, id uuid.UUID) (*domain.Collection, error) {
	query := `
		SELECT id, name, slug, category, total_cards, description, created_at, updated_at
		FROM collections
		WHERE id = $1
	`

	var collection domain.Collection
	err := r.db.GetContext(ctx, &collection, query, id)
	if err == sql.ErrNoRows {
		return nil, nil
	}
	if err != nil {
		return nil, err
	}

	return &collection, nil
}

// GetUserCollections récupère les collections d'un utilisateur
func (r *CollectionRepository) GetUserCollections(ctx context.Context, userID uuid.UUID) ([]domain.Collection, error) {
	query := `
		SELECT c.id, c.name, c.slug, c.category, c.total_cards, c.description, c.created_at, c.updated_at
		FROM collections c
		INNER JOIN user_collections uc ON c.id = uc.collection_id
		WHERE uc.user_id = $1
		ORDER BY c.name
	`

	var collections []domain.Collection
	err := r.db.SelectContext(ctx, &collections, query, userID)
	if err != nil {
		return nil, err
	}

	return collections, nil
}

// GetCollectionSummary récupère les statistiques d'une collection
func (r *CollectionRepository) GetCollectionSummary(ctx context.Context, userID uuid.UUID) (*domain.CollectionSummary, error) {
	totalAvailable, err := r.GetTotalCardsAvailable(ctx)
	if err != nil {
		return nil, err
	}

	totalOwned, err := r.GetTotalCardsOwned(ctx, userID)
	if err != nil {
		return nil, err
	}

	summary := &domain.CollectionSummary{
		UserID:              userID,
		TotalCardsOwned:     totalOwned,
		TotalCardsAvailable: totalAvailable,
		LastUpdated:         time.Now(),
	}

	summary.CalculateCompletionPercentage()

	return summary, nil
}

// GetTotalCardsAvailable retourne le nombre total de cartes disponibles
func (r *CollectionRepository) GetTotalCardsAvailable(ctx context.Context) (int, error) {
	query := `SELECT COUNT(*) FROM cards`

	var count int
	err := r.db.GetContext(ctx, &count, query)
	if err != nil {
		return 0, err
	}

	return count, nil
}

// GetTotalCardsOwned retourne le nombre total de cartes possédées par un utilisateur
func (r *CollectionRepository) GetTotalCardsOwned(ctx context.Context, userID uuid.UUID) (int, error) {
	query := `
		SELECT COUNT(*)
		FROM user_cards
		WHERE user_id = $1 AND is_owned = true
	`

	var count int
	err := r.db.GetContext(ctx, &count, query, userID)
	if err != nil {
		return 0, err
	}

	return count, nil
}

// GetAllWithStats retourne toutes les collections avec leurs statistiques pour un utilisateur
func (r *CollectionRepository) GetAllWithStats(ctx context.Context, userID uuid.UUID) ([]domain.CollectionWithStats, error) {
	query := `
		WITH collection_stats AS (
			SELECT
				c.id,
				c.name,
				c.slug,
				c.description,
				COALESCE(COUNT(DISTINCT cards.id), 0) AS total_cards_available,
				COALESCE(COUNT(DISTINCT CASE WHEN uc.is_owned = true THEN uc.card_id END), 0) AS total_cards_owned,
				MAX(uc.updated_at) AS last_updated
			FROM collections c
			INNER JOIN user_collections user_coll ON c.id = user_coll.collection_id
			LEFT JOIN cards ON c.id = cards.collection_id
			LEFT JOIN user_cards uc ON cards.id = uc.card_id AND uc.user_id = $1
			WHERE user_coll.user_id = $1
			GROUP BY c.id, c.name, c.slug, c.description
		)
		SELECT
			id,
			name,
			slug,
			description,
			total_cards_owned,
			total_cards_available,
			last_updated
		FROM collection_stats
		ORDER BY name
	`

	type queryResult struct {
		ID                  uuid.UUID  `db:"id"`
		Name                string     `db:"name"`
		Slug                string     `db:"slug"`
		Description         string     `db:"description"`
		TotalCardsOwned     int        `db:"total_cards_owned"`
		TotalCardsAvailable int        `db:"total_cards_available"`
		LastUpdated         *time.Time `db:"last_updated"`
	}

	var results []queryResult
	err := r.db.SelectContext(ctx, &results, query, userID)
	if err != nil {
		return nil, err
	}

	collections := make([]domain.CollectionWithStats, len(results))
	for i, result := range results {
		collections[i] = domain.CollectionWithStats{
			ID:                  result.ID,
			Name:                result.Name,
			Slug:                result.Slug,
			Description:         result.Description,
			TotalCardsOwned:     result.TotalCardsOwned,
			TotalCardsAvailable: result.TotalCardsAvailable,
			HeroImageURL:        "/images/collections/" + result.Slug + "-hero.jpg",
			LastUpdated:         result.LastUpdated,
		}
		collections[i].CalculateCompletionPercentage()
	}

	return collections, nil
}
