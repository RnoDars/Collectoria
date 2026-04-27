package application

import (
	"context"
	"fmt"

	"collectoria/collection-management/internal/domain"
	"collectoria/collection-management/internal/infrastructure/postgres"

	"github.com/google/uuid"
	"github.com/rs/zerolog/log"
)

type DnD5BookService struct {
	bookRepo        *postgres.DnD5BookRepository
	activityService *ActivityService
}

func NewDnD5BookService(bookRepo *postgres.DnD5BookRepository, activityService *ActivityService) *DnD5BookService {
	return &DnD5BookService{
		bookRepo:        bookRepo,
		activityService: activityService,
	}
}

// GetBooksCatalog récupère le catalogue de livres avec filtres et pagination
func (s *DnD5BookService) GetBooksCatalog(
	ctx context.Context,
	userID uuid.UUID,
	filter domain.DnD5BookFilter,
) (*domain.DnD5BookPage, error) {
	return s.bookRepo.GetBooksCatalog(ctx, userID, filter)
}

// UpdateBookOwnership met à jour la possession d'un livre D&D 5e (versions EN/FR)
func (s *DnD5BookService) UpdateBookOwnership(
	ctx context.Context,
	userID uuid.UUID,
	bookID uuid.UUID,
	ownedEn *bool,
	ownedFr *bool,
) (*domain.DnD5BookWithOwnership, error) {
	// 1. Vérifier que le livre existe
	book, err := s.bookRepo.GetBookByID(ctx, bookID)
	if err != nil {
		return nil, fmt.Errorf("book not found: %w", err)
	}

	// 2. Valider qu'au moins une version est fournie
	if ownedEn == nil && ownedFr == nil {
		return nil, fmt.Errorf("owned_en or owned_fr required")
	}

	// 3. Mettre à jour la possession
	if err := s.bookRepo.UpdateBookOwnership(ctx, userID, bookID, ownedEn, ownedFr); err != nil {
		return nil, fmt.Errorf("failed to update ownership: %w", err)
	}

	// 4. Enregistrer l'activité (best effort - ne doit pas bloquer la mise à jour)
	activityType := string(domain.ActivityBookAdded)
	description := fmt.Sprintf("Mise à jour de la possession: %s", book.NameEn)

	metadata := map[string]interface{}{
		"book_id":     bookID.String(),
		"book_title":  book.NameEn,
		"description": description,
	}

	if ownedEn != nil {
		metadata["owned_en"] = *ownedEn
	}
	if ownedFr != nil {
		metadata["owned_fr"] = *ownedFr
	}

	if s.activityService != nil {
		if err := s.activityService.RecordBookActivity(ctx, userID, activityType, bookID, metadata); err != nil {
			// Log l'erreur mais ne fail pas la mise à jour (best effort)
			log.Error().Err(err).Str("book_id", bookID.String()).Msg("Failed to record activity")
		}
	}

	// 5. Récupérer et retourner l'état mis à jour
	userBook, err := s.bookRepo.GetUserBook(ctx, userID, bookID)
	if err != nil {
		// Si la relation n'existe pas encore, retourner les valeurs par défaut
		return &domain.DnD5BookWithOwnership{
			DnD5Book: *book,
			OwnedEn:  ownedEn,
			OwnedFr:  ownedFr,
		}, nil
	}

	return &domain.DnD5BookWithOwnership{
		DnD5Book: *book,
		OwnedEn:  userBook.OwnedEn,
		OwnedFr:  userBook.OwnedFr,
	}, nil
}
