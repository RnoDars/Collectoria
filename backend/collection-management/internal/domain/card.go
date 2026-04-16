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

// UserCard représente la possession d'une carte par un utilisateur
type UserCard struct {
	UserID     uuid.UUID
	CardID     uuid.UUID
	IsOwned    bool
	AcquiredAt *time.Time
	CreatedAt  time.Time
	UpdatedAt  time.Time
}
