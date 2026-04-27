package domain

import (
	"time"

	"github.com/google/uuid"
)

// ForgottenRealmsNovel représente un roman des Royaumes Oubliés
type ForgottenRealmsNovel struct {
	ID              uuid.UUID `db:"id"`
	Number          string    `db:"number"`
	Title           string    `db:"title"`
	Author          string    `db:"author"`
	PublicationDate time.Time `db:"publication_date"`
	BookType        string    `db:"book_type"`
	CreatedAt       time.Time `db:"created_at"`
	UpdatedAt       time.Time `db:"updated_at"`
}

// UserForgottenRealmsNovel représente la possession d'un roman par un utilisateur
type UserForgottenRealmsNovel struct {
	ID        uuid.UUID `db:"id"`
	UserID    uuid.UUID `db:"user_id"`
	NovelID   uuid.UUID `db:"novel_id"`
	IsOwned   bool      `db:"is_owned"`
	CreatedAt time.Time `db:"created_at"`
	UpdatedAt time.Time `db:"updated_at"`
}

// ForgottenRealmsNovelWithOwnership représente un roman avec son statut de possession
type ForgottenRealmsNovelWithOwnership struct {
	ForgottenRealmsNovel
	IsOwned bool
}
