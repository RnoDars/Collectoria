package domain

import (
	"time"

	"github.com/google/uuid"
)

// Collection représente une collection de cartes (Aggregate Root)
type Collection struct {
	ID          uuid.UUID
	Name        string
	Slug        string
	Category    string
	TotalCards  int
	Description string
	CreatedAt   time.Time
	UpdatedAt   time.Time
}

// UserCollection représente la collection d'un utilisateur
type UserCollection struct {
	UserID       uuid.UUID
	CollectionID uuid.UUID
	CreatedAt    time.Time
}

// CollectionSummary représente les statistiques globales de toutes les collections
type CollectionSummary struct {
	UserID               uuid.UUID
	TotalCardsOwned      int
	TotalCardsAvailable  int
	CompletionPercentage float64
	LastUpdated          time.Time
}

// CalculateCompletionPercentage calcule le pourcentage de complétion
func (cs *CollectionSummary) CalculateCompletionPercentage() {
	if cs.TotalCardsAvailable == 0 {
		cs.CompletionPercentage = 0
		return
	}
	cs.CompletionPercentage = (float64(cs.TotalCardsOwned) / float64(cs.TotalCardsAvailable)) * 100
}
