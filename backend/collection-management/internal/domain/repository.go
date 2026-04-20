package domain

import (
	"context"

	"github.com/google/uuid"
)

// CollectionRepository interface pour la persistance des collections
type CollectionRepository interface {
	// Collections
	GetAllCollections(ctx context.Context) ([]Collection, error)
	GetCollectionByID(ctx context.Context, id uuid.UUID) (*Collection, error)

	// User Collections
	GetUserCollections(ctx context.Context, userID uuid.UUID) ([]Collection, error)

	// Summary & Stats
	GetCollectionSummary(ctx context.Context, userID uuid.UUID) (*CollectionSummary, error)
	GetTotalCardsAvailable(ctx context.Context) (int, error)
	GetTotalCardsOwned(ctx context.Context, userID uuid.UUID) (int, error)
	GetAllWithStats(ctx context.Context, userID uuid.UUID) ([]CollectionWithStats, error)
}

// CardRepository interface pour la persistance des cartes
type CardRepository interface {
	GetAllCards(ctx context.Context) ([]Card, error)
	GetCardByID(ctx context.Context, id uuid.UUID) (*Card, error)
	GetCardsByCollectionID(ctx context.Context, collectionID uuid.UUID) ([]Card, error)

	// User Cards
	GetUserCards(ctx context.Context, userID uuid.UUID) ([]UserCard, error)
	GetUserCardsOwned(ctx context.Context, userID uuid.UUID) ([]Card, error)
	IsCardOwned(ctx context.Context, userID, cardID uuid.UUID) (bool, error)

	// Catalogue filtré avec pagination
	GetCardsCatalog(ctx context.Context, userID uuid.UUID, filter CardFilter) (*CardPage, error)
}
