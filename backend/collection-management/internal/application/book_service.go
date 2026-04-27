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
// DEPRECATED: Utiliser UpdateBookOwnership à la place
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

// UpdateBookOwnership met à jour la possession d'un livre selon la collection
func (s *BookService) UpdateBookOwnership(
	ctx context.Context,
	userID uuid.UUID,
	bookID uuid.UUID,
	ownership domain.OwnershipUpdate,
) (*domain.BookWithOwnership, error) {
	// 1. Vérifier que le livre existe et récupérer ses informations
	book, err := s.bookRepo.GetBookByID(ctx, bookID)
	if err != nil {
		return nil, fmt.Errorf("book not found: %w", err)
	}

	// 2. Valider que la mise à jour correspond à la collection
	royaumesOubliesID := uuid.MustParse("22222222-2222-2222-2222-222222222222")
	dnd5eID := uuid.MustParse("33333333-3333-3333-3333-333333333333")

	if book.CollectionID == royaumesOubliesID {
		// Royaumes Oubliés: is_owned requis
		if ownership.IsOwned == nil {
			return nil, fmt.Errorf("is_owned is required for Royaumes Oubliés books")
		}
		if ownership.OwnedEn != nil || ownership.OwnedFr != nil {
			return nil, fmt.Errorf("owned_en/owned_fr not allowed for Royaumes Oubliés books")
		}
	} else if book.CollectionID == dnd5eID {
		// D&D 5e: owned_en ou owned_fr requis
		if ownership.OwnedEn == nil && ownership.OwnedFr == nil {
			return nil, fmt.Errorf("owned_en or owned_fr required for D&D 5e books")
		}
		if ownership.IsOwned != nil {
			return nil, fmt.Errorf("is_owned not allowed for D&D 5e books")
		}
	} else {
		return nil, fmt.Errorf("unsupported collection: %s", book.CollectionID)
	}

	// 3. Mettre à jour la possession (dispatch automatique dans le repository)
	if err := s.bookRepo.UpdateBookOwnership(ctx, userID, bookID, ownership); err != nil {
		return nil, fmt.Errorf("failed to update ownership: %w", err)
	}

	// 4. Enregistrer l'activité (best effort - ne doit pas bloquer la mise à jour)
	activityType := string(domain.ActivityBookAdded)
	description := fmt.Sprintf("Mise à jour de la possession: %s", book.Title)

	metadata := map[string]interface{}{
		"book_id":     bookID.String(),
		"book_title":  book.Title,
		"book_author": book.Author,
		"description": description,
	}

	if ownership.IsOwned != nil {
		metadata["is_owned"] = *ownership.IsOwned
		if !*ownership.IsOwned {
			activityType = string(domain.ActivityBookRemoved)
		}
	}
	if ownership.OwnedEn != nil {
		metadata["owned_en"] = *ownership.OwnedEn
	}
	if ownership.OwnedFr != nil {
		metadata["owned_fr"] = *ownership.OwnedFr
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
		return &domain.BookWithOwnership{
			Book:    *book,
			IsOwned: false,
			OwnedEn: ownership.OwnedEn,
			OwnedFr: ownership.OwnedFr,
		}, nil
	}

	return &domain.BookWithOwnership{
		Book:    *book,
		IsOwned: userBook.IsOwned,
		OwnedEn: userBook.OwnedEn,
		OwnedFr: userBook.OwnedFr,
	}, nil
}
