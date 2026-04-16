package domain

import (
	"time"

	"github.com/google/uuid"
)

// ParseTime parse une chaîne de caractères en time.Time (helper pour les tests)
func ParseTime(s string) time.Time {
	t, err := time.Parse(time.RFC3339, s)
	if err != nil {
		panic(err)
	}
	return t
}

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

// CollectionWithStats représente une collection avec ses statistiques
type CollectionWithStats struct {
	ID                   uuid.UUID
	Name                 string
	Slug                 string
	Description          string
	TotalCardsOwned      int
	TotalCardsAvailable  int
	CompletionPercentage float64
	HeroImageURL         string
	LastUpdated          *time.Time
}

// CalculateCompletionPercentage calcule le pourcentage de complétion pour une collection
func (cws *CollectionWithStats) CalculateCompletionPercentage() {
	if cws.TotalCardsAvailable == 0 {
		cws.CompletionPercentage = 0
		return
	}
	cws.CompletionPercentage = (float64(cws.TotalCardsOwned) / float64(cws.TotalCardsAvailable)) * 100
}
