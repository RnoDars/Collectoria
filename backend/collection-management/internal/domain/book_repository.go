package domain

import (
	"context"

	"github.com/google/uuid"
)

// BookRepository interface pour la persistance des livres
type BookRepository interface {
	// GetBookByID récupère un livre par son ID
	GetBookByID(ctx context.Context, id uuid.UUID) (*Book, error)

	// GetUserBook récupère la relation utilisateur-livre
	GetUserBook(ctx context.Context, userID, bookID uuid.UUID) (*UserBook, error)

	// UpdateUserBook met à jour ou crée la possession d'un livre (UPSERT)
	UpdateUserBook(ctx context.Context, userID, bookID uuid.UUID, isOwned bool) error

	// GetBooksCatalog récupère le catalogue de livres avec filtres et pagination
	GetBooksCatalog(ctx context.Context, userID uuid.UUID, filter BookFilter) (*BookPage, error)
}
