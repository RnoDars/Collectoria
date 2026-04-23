package domain

import (
	"time"

	"github.com/google/uuid"
)

// Book représente un livre dans le catalogue
type Book struct {
	ID              uuid.UUID `db:"id"`
	CollectionID    uuid.UUID `db:"collection_id"`
	Number          string    `db:"number"`
	Title           string    `db:"title"`
	Author          string    `db:"author"`
	PublicationDate time.Time `db:"publication_date"`
	BookType        string    `db:"book_type"`
	CreatedAt       time.Time `db:"created_at"`
	UpdatedAt       time.Time `db:"updated_at"`
}

// BookWithOwnership représente un livre avec son statut de possession
type BookWithOwnership struct {
	Book
	IsOwned bool
}

// UserBook représente la possession d'un livre par un utilisateur
type UserBook struct {
	ID        uuid.UUID `db:"id"`
	UserID    uuid.UUID `db:"user_id"`
	BookID    uuid.UUID `db:"book_id"`
	IsOwned   bool      `db:"is_owned"`
	CreatedAt time.Time `db:"created_at"`
	UpdatedAt time.Time `db:"updated_at"`
}
