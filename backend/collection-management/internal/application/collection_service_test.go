package application

import (
	"context"
	"errors"
	"testing"

	"collectoria/collection-management/internal/domain"

	"github.com/google/uuid"
	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/mock"
)

// Mock CollectionRepository
type MockCollectionRepository struct {
	mock.Mock
}

func (m *MockCollectionRepository) GetAllCollections(ctx context.Context) ([]domain.Collection, error) {
	args := m.Called(ctx)
	return args.Get(0).([]domain.Collection), args.Error(1)
}

func (m *MockCollectionRepository) GetCollectionByID(ctx context.Context, id uuid.UUID) (*domain.Collection, error) {
	args := m.Called(ctx, id)
	if args.Get(0) == nil {
		return nil, args.Error(1)
	}
	return args.Get(0).(*domain.Collection), args.Error(1)
}

func (m *MockCollectionRepository) GetUserCollections(ctx context.Context, userID uuid.UUID) ([]domain.Collection, error) {
	args := m.Called(ctx, userID)
	return args.Get(0).([]domain.Collection), args.Error(1)
}

func (m *MockCollectionRepository) GetCollectionSummary(ctx context.Context, userID uuid.UUID) (*domain.CollectionSummary, error) {
	args := m.Called(ctx, userID)
	if args.Get(0) == nil {
		return nil, args.Error(1)
	}
	return args.Get(0).(*domain.CollectionSummary), args.Error(1)
}

func (m *MockCollectionRepository) GetTotalCardsAvailable(ctx context.Context) (int, error) {
	args := m.Called(ctx)
	return args.Int(0), args.Error(1)
}

func (m *MockCollectionRepository) GetTotalCardsOwned(ctx context.Context, userID uuid.UUID) (int, error) {
	args := m.Called(ctx, userID)
	return args.Int(0), args.Error(1)
}

func (m *MockCollectionRepository) GetAllWithStats(ctx context.Context, userID uuid.UUID) ([]domain.CollectionWithStats, error) {
	args := m.Called(ctx, userID)
	return args.Get(0).([]domain.CollectionWithStats), args.Error(1)
}

// Mock CardRepository
type MockCardRepository struct {
	mock.Mock
}

func (m *MockCardRepository) GetAllCards(ctx context.Context) ([]domain.Card, error) {
	args := m.Called(ctx)
	return args.Get(0).([]domain.Card), args.Error(1)
}

func (m *MockCardRepository) GetCardByID(ctx context.Context, id uuid.UUID) (*domain.Card, error) {
	args := m.Called(ctx, id)
	if args.Get(0) == nil {
		return nil, args.Error(1)
	}
	return args.Get(0).(*domain.Card), args.Error(1)
}

func (m *MockCardRepository) GetCardsByCollectionID(ctx context.Context, collectionID uuid.UUID) ([]domain.Card, error) {
	args := m.Called(ctx, collectionID)
	return args.Get(0).([]domain.Card), args.Error(1)
}

func (m *MockCardRepository) GetUserCards(ctx context.Context, userID uuid.UUID) ([]domain.UserCard, error) {
	args := m.Called(ctx, userID)
	return args.Get(0).([]domain.UserCard), args.Error(1)
}

func (m *MockCardRepository) GetUserCardsOwned(ctx context.Context, userID uuid.UUID) ([]domain.Card, error) {
	args := m.Called(ctx, userID)
	return args.Get(0).([]domain.Card), args.Error(1)
}

func (m *MockCardRepository) IsCardOwned(ctx context.Context, userID, cardID uuid.UUID) (bool, error) {
	args := m.Called(ctx, userID, cardID)
	return args.Bool(0), args.Error(1)
}

func (m *MockCardRepository) GetCardsCatalog(ctx context.Context, userID uuid.UUID, filter domain.CardFilter) (*domain.CardPage, error) {
	return &domain.CardPage{Cards: []domain.CardWithOwnership{}, Total: 0, Page: 1, HasMore: false}, nil
}

func TestCollectionService_GetSummary(t *testing.T) {
	ctx := context.Background()
	userID := uuid.New()

	t.Run("Success with 60% completion", func(t *testing.T) {
		mockCollectionRepo := new(MockCollectionRepository)
		mockCardRepo := new(MockCardRepository)

		mockCollectionRepo.On("GetTotalCardsAvailable", ctx).Return(40, nil)
		mockCollectionRepo.On("GetTotalCardsOwned", ctx, userID).Return(24, nil)

		service := NewCollectionService(mockCollectionRepo, mockCardRepo)
		summary, err := service.GetSummary(ctx, userID)

		assert.NoError(t, err)
		assert.NotNil(t, summary)
		assert.Equal(t, userID, summary.UserID)
		assert.Equal(t, 24, summary.TotalCardsOwned)
		assert.Equal(t, 40, summary.TotalCardsAvailable)
		assert.Equal(t, 60.0, summary.CompletionPercentage)

		mockCollectionRepo.AssertExpectations(t)
	})

	t.Run("Success with 100% completion", func(t *testing.T) {
		mockCollectionRepo := new(MockCollectionRepository)
		mockCardRepo := new(MockCardRepository)

		mockCollectionRepo.On("GetTotalCardsAvailable", ctx).Return(40, nil)
		mockCollectionRepo.On("GetTotalCardsOwned", ctx, userID).Return(40, nil)

		service := NewCollectionService(mockCollectionRepo, mockCardRepo)
		summary, err := service.GetSummary(ctx, userID)

		assert.NoError(t, err)
		assert.NotNil(t, summary)
		assert.Equal(t, 40, summary.TotalCardsOwned)
		assert.Equal(t, 40, summary.TotalCardsAvailable)
		assert.Equal(t, 100.0, summary.CompletionPercentage)

		mockCollectionRepo.AssertExpectations(t)
	})

	t.Run("Empty collection", func(t *testing.T) {
		mockCollectionRepo := new(MockCollectionRepository)
		mockCardRepo := new(MockCardRepository)

		mockCollectionRepo.On("GetTotalCardsAvailable", ctx).Return(40, nil)
		mockCollectionRepo.On("GetTotalCardsOwned", ctx, userID).Return(0, nil)

		service := NewCollectionService(mockCollectionRepo, mockCardRepo)
		summary, err := service.GetSummary(ctx, userID)

		assert.NoError(t, err)
		assert.NotNil(t, summary)
		assert.Equal(t, 0, summary.TotalCardsOwned)
		assert.Equal(t, 40, summary.TotalCardsAvailable)
		assert.Equal(t, 0.0, summary.CompletionPercentage)

		mockCollectionRepo.AssertExpectations(t)
	})

	t.Run("Error getting total cards available", func(t *testing.T) {
		mockCollectionRepo := new(MockCollectionRepository)
		mockCardRepo := new(MockCardRepository)

		mockCollectionRepo.On("GetTotalCardsAvailable", ctx).Return(0, errors.New("database error"))

		service := NewCollectionService(mockCollectionRepo, mockCardRepo)
		summary, err := service.GetSummary(ctx, userID)

		assert.Error(t, err)
		assert.Nil(t, summary)
		assert.Equal(t, "database error", err.Error())

		mockCollectionRepo.AssertExpectations(t)
	})

	t.Run("Error getting total cards owned", func(t *testing.T) {
		mockCollectionRepo := new(MockCollectionRepository)
		mockCardRepo := new(MockCardRepository)

		mockCollectionRepo.On("GetTotalCardsAvailable", ctx).Return(40, nil)
		mockCollectionRepo.On("GetTotalCardsOwned", ctx, userID).Return(0, errors.New("database error"))

		service := NewCollectionService(mockCollectionRepo, mockCardRepo)
		summary, err := service.GetSummary(ctx, userID)

		assert.Error(t, err)
		assert.Nil(t, summary)
		assert.Equal(t, "database error", err.Error())

		mockCollectionRepo.AssertExpectations(t)
	})
}

func TestCollectionService_GetAllCollectionsWithStats(t *testing.T) {
	ctx := context.Background()
	userID := uuid.MustParse("00000000-0000-0000-0000-000000000001")
	meccgID := uuid.New()
	doomtrooperID := uuid.New()

	t.Run("Success with MECCG and Doomtrooper", func(t *testing.T) {
		mockCollectionRepo := new(MockCollectionRepository)
		mockCardRepo := new(MockCardRepository)

		lastUpdated := domain.ParseTime("2026-04-16T10:30:00Z")
		expectedCollections := []domain.CollectionWithStats{
			{
				ID:                   meccgID,
				Name:                 "Middle-Earth CCG",
				Slug:                 "meccg",
				Description:          "The card game based on Tolkien's Middle-earth",
				TotalCardsOwned:      24,
				TotalCardsAvailable:  40,
				CompletionPercentage: 60.0,
				HeroImageURL:         "/images/collections/meccg-hero.jpg",
				LastUpdated:          &lastUpdated,
			},
			{
				ID:                   doomtrooperID,
				Name:                 "Doomtrooper",
				Slug:                 "doomtrooper",
				Description:          "CCG based on the Mutant Chronicles universe",
				TotalCardsOwned:      0,
				TotalCardsAvailable:  0,
				CompletionPercentage: 0.0,
				HeroImageURL:         "/images/collections/doomtrooper-hero.jpg",
				LastUpdated:          nil,
			},
		}

		mockCollectionRepo.On("GetAllWithStats", ctx, userID).Return(expectedCollections, nil)

		service := NewCollectionService(mockCollectionRepo, mockCardRepo)
		collections, err := service.GetAllCollectionsWithStats(ctx, userID)

		assert.NoError(t, err)
		assert.NotNil(t, collections)
		assert.Len(t, collections, 2)

		// Vérifier MECCG
		assert.Equal(t, meccgID, collections[0].ID)
		assert.Equal(t, "Middle-Earth CCG", collections[0].Name)
		assert.Equal(t, "meccg", collections[0].Slug)
		assert.Equal(t, 24, collections[0].TotalCardsOwned)
		assert.Equal(t, 40, collections[0].TotalCardsAvailable)
		assert.Equal(t, 60.0, collections[0].CompletionPercentage)
		assert.NotNil(t, collections[0].LastUpdated)

		// Vérifier Doomtrooper
		assert.Equal(t, doomtrooperID, collections[1].ID)
		assert.Equal(t, "Doomtrooper", collections[1].Name)
		assert.Equal(t, "doomtrooper", collections[1].Slug)
		assert.Equal(t, 0, collections[1].TotalCardsOwned)
		assert.Equal(t, 0, collections[1].TotalCardsAvailable)
		assert.Equal(t, 0.0, collections[1].CompletionPercentage)
		assert.Nil(t, collections[1].LastUpdated)

		mockCollectionRepo.AssertExpectations(t)
	})

	t.Run("Error from repository", func(t *testing.T) {
		mockCollectionRepo := new(MockCollectionRepository)
		mockCardRepo := new(MockCardRepository)

		var nilCollections []domain.CollectionWithStats
		mockCollectionRepo.On("GetAllWithStats", ctx, userID).Return(nilCollections, errors.New("database error"))

		service := NewCollectionService(mockCollectionRepo, mockCardRepo)
		collections, err := service.GetAllCollectionsWithStats(ctx, userID)

		assert.Error(t, err)
		assert.Nil(t, collections)
		assert.Equal(t, "database error", err.Error())

		mockCollectionRepo.AssertExpectations(t)
	})

	t.Run("User without collections", func(t *testing.T) {
		mockCollectionRepo := new(MockCollectionRepository)
		mockCardRepo := new(MockCardRepository)

		mockCollectionRepo.On("GetAllWithStats", ctx, userID).Return([]domain.CollectionWithStats{}, nil)

		service := NewCollectionService(mockCollectionRepo, mockCardRepo)
		collections, err := service.GetAllCollectionsWithStats(ctx, userID)

		assert.NoError(t, err)
		assert.NotNil(t, collections)
		assert.Len(t, collections, 0)

		mockCollectionRepo.AssertExpectations(t)
	})
}
