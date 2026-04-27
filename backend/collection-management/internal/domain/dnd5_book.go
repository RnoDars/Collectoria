package domain

import (
	"time"

	"github.com/google/uuid"
)

// DnD5Book représente un livre officiel de D&D 5e
type DnD5Book struct {
	ID        uuid.UUID `db:"id"`
	Number    string    `db:"number"`
	NameEn    string    `db:"name_en"`
	NameFr    *string   `db:"name_fr"` // Nullable
	BookType  string    `db:"book_type"`
	CreatedAt time.Time `db:"created_at"`
	UpdatedAt time.Time `db:"updated_at"`
}

// UserDnD5Book représente la possession d'un livre D&D 5e par un utilisateur
type UserDnD5Book struct {
	ID        uuid.UUID `db:"id"`
	UserID    uuid.UUID `db:"user_id"`
	BookID    uuid.UUID `db:"book_id"`
	OwnedEn   *bool     `db:"owned_en"` // Nullable
	OwnedFr   *bool     `db:"owned_fr"` // Nullable
	CreatedAt time.Time `db:"created_at"`
	UpdatedAt time.Time `db:"updated_at"`
}

// DnD5BookWithOwnership représente un livre D&D 5e avec son statut de possession
type DnD5BookWithOwnership struct {
	DnD5Book
	OwnedEn *bool // Nullable
	OwnedFr *bool // Nullable
}
