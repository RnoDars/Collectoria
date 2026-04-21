package application

import (
	"context"
	"fmt"

	"collectoria/collection-management/internal/domain"

	"github.com/google/uuid"
)

type CardService struct {
	cardRepo domain.CardRepository
}

func NewCardService(cardRepo domain.CardRepository) *CardService {
	return &CardService{cardRepo: cardRepo}
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

	// 3. Retourner la carte avec le nouveau statut
	return &domain.CardWithOwnership{
		Card:    *card,
		IsOwned: isOwned,
	}, nil
}
