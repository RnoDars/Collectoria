package application

import (
	"context"
	"fmt"

	"collectoria/collection-management/internal/domain"

	"github.com/google/uuid"
	"github.com/rs/zerolog/log"
)

type CardService struct {
	cardRepo        domain.CardRepository
	activityService *ActivityService
}

func NewCardService(cardRepo domain.CardRepository, activityService *ActivityService) *CardService {
	return &CardService{
		cardRepo:        cardRepo,
		activityService: activityService,
	}
}

// ToggleCardPossession met à jour le statut de possession d'une carte pour un utilisateur
func (s *CardService) ToggleCardPossession(
	ctx context.Context,
	userID uuid.UUID,
	cardID uuid.UUID,
	isOwned bool,
) (*domain.CardWithOwnership, error) {
	// 1. Vérifier que la carte existe
	card, err := s.cardRepo.GetCardByID(ctx, cardID)
	if err != nil {
		return nil, fmt.Errorf("card not found: %w", err)
	}

	// 2. Mettre à jour le statut de possession (UPSERT)
	if err := s.cardRepo.UpdateUserCardPossession(ctx, userID, cardID, isOwned); err != nil {
		return nil, fmt.Errorf("failed to update possession: %w", err)
	}

	// 3. Enregistrer l'activité (best effort - ne doit pas bloquer le toggle)
	activityType := string(domain.ActivityCardAdded)
	if !isOwned {
		activityType = string(domain.ActivityCardRemoved)
	}

	// Utiliser le nom français si disponible, sinon anglais
	cardName := card.NameFR
	if cardName == "" {
		cardName = card.NameEN
	}

	metadata := map[string]interface{}{
		"card_id":   cardID.String(),
		"card_name": cardName,
		"is_owned":  isOwned,
	}

	if s.activityService != nil {
		if err := s.activityService.RecordCardActivity(ctx, userID, activityType, cardID, metadata); err != nil {
			// Log l'erreur mais ne fail pas le toggle (best effort)
			log.Error().Err(err).Str("card_id", cardID.String()).Msg("Failed to record activity")
		}
	}

	// 4. Retourner la carte avec le nouveau statut
	return &domain.CardWithOwnership{
		Card:    *card,
		IsOwned: isOwned,
	}, nil
}
