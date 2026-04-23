package application

import (
	"context"
	"fmt"

	"collectoria/collection-management/internal/domain"

	"github.com/google/uuid"
	"github.com/rs/zerolog/log"
)

type BookService struct {
	bookRepo        domain.BookRepository
	activityService *ActivityService
}

func NewBookService(bookRepo domain.BookRepository, activityService *ActivityService) *BookService {
	return &BookService{
		bookRepo:        bookRepo,
		activityService: activityService,
	}
}

// GetBooksCatalog récupère le catalogue de livres avec filtres et pagination
func (s *BookService) GetBooksCatalog(
	ctx context.Context,
	userID uuid.UUID,
	filter domain.BookFilter,
) (*domain.BookPage, error) {
	return s.bookRepo.GetBooksCatalog(ctx, userID, filter)
}

// ToggleBookPossession met à jour le statut de possession d'un livre pour un utilisateur
func (s *BookService) ToggleBookPossession(
	ctx context.Context,
	userID uuid.UUID,
	bookID uuid.UUID,
	isOwned bool,
) (*domain.BookWithOwnership, error) {
	// 1. Vérifier que le livre existe
	book, err := s.bookRepo.GetBookByID(ctx, bookID)
	if err != nil {
		return nil, fmt.Errorf("book not found: %w", err)
	}

	// 2. Mettre à jour le statut de possession (UPSERT)
	if err := s.bookRepo.UpdateUserBook(ctx, userID, bookID, isOwned); err != nil {
		return nil, fmt.Errorf("failed to update possession: %w", err)
	}

	// 3. Enregistrer l'activité (best effort - ne doit pas bloquer le toggle)
	activityType := string(domain.ActivityBookAdded)
	description := fmt.Sprintf("Ajout du roman: %s", book.Title)
	if !isOwned {
		activityType = string(domain.ActivityBookRemoved)
		description = fmt.Sprintf("Retrait du roman: %s", book.Title)
	}

	metadata := map[string]interface{}{
		"book_id":     bookID.String(),
		"book_title":  book.Title,
		"book_author": book.Author,
		"is_owned":    isOwned,
		"description": description,
	}

	if s.activityService != nil {
		if err := s.activityService.RecordBookActivity(ctx, userID, activityType, bookID, metadata); err != nil {
			// Log l'erreur mais ne fail pas le toggle (best effort)
			log.Error().Err(err).Str("book_id", bookID.String()).Msg("Failed to record activity")
		}
	}

	// 4. Retourner le livre avec le nouveau statut
	return &domain.BookWithOwnership{
		Book:    *book,
		IsOwned: isOwned,
	}, nil
}
