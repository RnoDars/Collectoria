package domain

import (
	"time"

	"github.com/google/uuid"
)

// Card représente une carte dans le catalogue
type Card struct {
	ID           uuid.UUID
	CollectionID uuid.UUID
	NameEN       string
	NameFR       string
	CardType     string
	Series       string
	Rarity       string
	CreatedAt    time.Time
	UpdatedAt    time.Time
}

// CardWithOwnership représente une carte avec son statut de possession
type CardWithOwnership struct {
	Card
	IsOwned bool
}

// CardFilter regroupe les critères de filtrage du catalogue
type CardFilter struct {
	Search string
	Series string
	Type   string
	Rarity string
	Owned  string // "true", "false", ou "" pour tout
	Page   int
	Limit  int
}

// CardPage représente une page de résultats du catalogue
type CardPage struct {
	Cards   []CardWithOwnership
	Total   int
	Page    int
	HasMore bool
}

// UserCard représente la possession d'une carte par un utilisateur
type UserCard struct {
	UserID     uuid.UUID
	CardID     uuid.UUID
	IsOwned    bool
	AcquiredAt *time.Time
	CreatedAt  time.Time
	UpdatedAt  time.Time
}
