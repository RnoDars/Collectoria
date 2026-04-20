package application

import (
	"context"

	"collectoria/collection-management/internal/domain"

	"github.com/google/uuid"
)

type CatalogService struct {
	cardRepo domain.CardRepository
}

func NewCatalogService(cardRepo domain.CardRepository) *CatalogService {
	return &CatalogService{cardRepo: cardRepo}
}

func (s *CatalogService) GetCatalog(ctx context.Context, userID uuid.UUID, filter domain.CardFilter) (*domain.CardPage, error) {
	if filter.Page < 1 {
		filter.Page = 1
	}
	if filter.Limit < 1 {
		filter.Limit = 50
	}
	return s.cardRepo.GetCardsCatalog(ctx, userID, filter)
}
