package application

import (
	"context"
	"time"

	"collectoria/collection-management/internal/domain"

	"github.com/google/uuid"
)

// CollectionService gère la logique métier des collections
type CollectionService struct {
	collectionRepo domain.CollectionRepository
	cardRepo       domain.CardRepository
}

// NewCollectionService crée une nouvelle instance du service
func NewCollectionService(collectionRepo domain.CollectionRepository, cardRepo domain.CardRepository) *CollectionService {
	return &CollectionService{
		collectionRepo: collectionRepo,
		cardRepo:       cardRepo,
	}
}

// GetSummary retourne les statistiques globales de toutes les collections
func (s *CollectionService) GetSummary(ctx context.Context, userID uuid.UUID) (*domain.CollectionSummary, error) {
	// Récupérer le nombre total de cartes disponibles
	totalAvailable, err := s.collectionRepo.GetTotalCardsAvailable(ctx)
	if err != nil {
		return nil, err
	}

	// Récupérer le nombre total de cartes possédées par l'utilisateur
	totalOwned, err := s.collectionRepo.GetTotalCardsOwned(ctx, userID)
	if err != nil {
		return nil, err
	}

	// Créer le summary
	summary := &domain.CollectionSummary{
		UserID:              userID,
		TotalCardsOwned:     totalOwned,
		TotalCardsAvailable: totalAvailable,
		LastUpdated:         time.Now(),
	}

	// Calculer le pourcentage de complétion
	summary.CalculateCompletionPercentage()

	return summary, nil
}

// GetAllCollections retourne toutes les collections
func (s *CollectionService) GetAllCollections(ctx context.Context) ([]domain.Collection, error) {
	return s.collectionRepo.GetAllCollections(ctx)
}

// GetUserCollections retourne les collections d'un utilisateur
func (s *CollectionService) GetUserCollections(ctx context.Context, userID uuid.UUID) ([]domain.Collection, error) {
	return s.collectionRepo.GetUserCollections(ctx, userID)
}

// GetAllCollectionsWithStats retourne toutes les collections avec leurs statistiques
func (s *CollectionService) GetAllCollectionsWithStats(ctx context.Context, userID uuid.UUID) ([]domain.CollectionWithStats, error) {
	return s.collectionRepo.GetAllWithStats(ctx, userID)
}
