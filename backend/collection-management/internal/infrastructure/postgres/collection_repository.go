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
