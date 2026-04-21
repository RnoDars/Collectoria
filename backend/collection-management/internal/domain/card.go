package domain

import (
	"time"

	"github.com/google/uuid"
)

// Card représente une carte dans le catalogue
type Card struct {
	ID           uuid.UUID   `db:"id"`
	CollectionID uuid.UUID   `db:"collection_id"`
	NameEN       string      `db:"name_en"`
	NameFR       string      `db:"name_fr"`
	CardType     string      `db:"card_type"`
	Series       string      `db:"series"`
	Rarity       string      `db:"rarity"`
	CreatedAt    time.Time   `db:"created_at"`
	UpdatedAt    time.Time   `db:"updated_at"`
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
