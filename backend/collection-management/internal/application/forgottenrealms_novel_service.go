package application

import (
	"context"
	"fmt"

	"collectoria/collection-management/internal/domain"
	"collectoria/collection-management/internal/infrastructure/postgres"

	"github.com/google/uuid"
	"github.com/rs/zerolog/log"
)

type ForgottenRealmsNovelService struct {
	novelRepo       *postgres.ForgottenRealmsNovelRepository
	activityService *ActivityService
}

func NewForgottenRealmsNovelService(novelRepo *postgres.ForgottenRealmsNovelRepository, activityService *ActivityService) *ForgottenRealmsNovelService {
	return &ForgottenRealmsNovelService{
		novelRepo:       novelRepo,
		activityService: activityService,
	}
}

// GetNovelsCatalog récupère le catalogue de romans avec filtres et pagination
func (s *ForgottenRealmsNovelService) GetNovelsCatalog(
	ctx context.Context,
	userID uuid.UUID,
	filter domain.ForgottenRealmsNovelFilter,
) (*domain.ForgottenRealmsNovelPage, error) {
	return s.novelRepo.GetNovelsCatalog(ctx, userID, filter)
}

// ToggleNovelPossession met à jour le statut de possession d'un roman pour un utilisateur
func (s *ForgottenRealmsNovelService) ToggleNovelPossession(
	ctx context.Context,
	userID uuid.UUID,
	novelID uuid.UUID,
	isOwned bool,
) (*domain.ForgottenRealmsNovelWithOwnership, error) {
	// 1. Vérifier que le roman existe
	novel, err := s.novelRepo.GetNovelByID(ctx, novelID)
	if err != nil {
		return nil, fmt.Errorf("novel not found: %w", err)
	}

	// 2. Mettre à jour le statut de possession (UPSERT)
	if err := s.novelRepo.UpdateUserNovel(ctx, userID, novelID, isOwned); err != nil {
		return nil, fmt.Errorf("failed to update possession: %w", err)
	}

	// 3. Enregistrer l'activité (best effort - ne doit pas bloquer le toggle)
	activityType := string(domain.ActivityBookAdded)
	description := fmt.Sprintf("Ajout du roman: %s", novel.Title)
	if !isOwned {
		activityType = string(domain.ActivityBookRemoved)
		description = fmt.Sprintf("Retrait du roman: %s", novel.Title)
	}

	metadata := map[string]interface{}{
		"book_id":     novelID.String(),
		"book_title":  novel.Title,
		"book_author": novel.Author,
		"is_owned":    isOwned,
		"description": description,
	}

	if s.activityService != nil {
		if err := s.activityService.RecordBookActivity(ctx, userID, activityType, novelID, metadata); err != nil {
			// Log l'erreur mais ne fail pas le toggle (best effort)
			log.Error().Err(err).Str("novel_id", novelID.String()).Msg("Failed to record activity")
		}
	}

	// 4. Retourner le roman avec le nouveau statut
	return &domain.ForgottenRealmsNovelWithOwnership{
		ForgottenRealmsNovel: *novel,
		IsOwned:              isOwned,
	}, nil
}
