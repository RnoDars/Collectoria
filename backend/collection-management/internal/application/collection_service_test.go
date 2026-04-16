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
