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

// MockActivityRepository est un mock du ActivityRepository
type MockActivityRepository struct {
	mock.Mock
}

func (m *MockActivityRepository) Create(ctx context.Context, activity *domain.Activity) error {
	args := m.Called(ctx, activity)
	return args.Error(0)
}

func (m *MockActivityRepository) GetRecentByUserID(ctx context.Context, userID uuid.UUID, limit int) ([]*domain.Activity, error) {
	args := m.Called(ctx, userID, limit)
	if args.Get(0) == nil {
		return nil, args.Error(1)
	}
	return args.Get(0).([]*domain.Activity), args.Error(1)
}

func TestToggleCardPossession_Success_SetOwned(t *testing.T) {
	// Arrange
	mockRepo := new(MockCardRepository)
	mockActivityRepo := new(MockActivityRepository)
	activityService := NewActivityService(mockActivityRepo)
	service := NewCardService(mockRepo, activityService)

	// Mock activity recording (best effort - can fail silently)
	mockActivityRepo.On("Create", mock.Anything, mock.Anything).Return(nil)

	ctx := context.Background()
	userID := uuid.MustParse("00000000-0000-0000-0000-000000000001")
	cardID := uuid.New()
	collectionID := uuid.New()

	existingCard := &domain.Card{
		ID:           cardID,
		CollectionID: collectionID,
		NameEN:       "Gandalf the Grey",
		NameFR:       "Gandalf le Gris",
		CardType:     "Hero",
		Series:       "The Wizards",
		Rarity:       "R1",
	}

	mockRepo.On("GetCardByID", ctx, cardID).Return(existingCard, nil)
	mockRepo.On("UpdateUserCardPossession", ctx, userID, cardID, true).Return(nil)

	// Act
	result, err := service.ToggleCardPossession(ctx, userID, cardID, true)

	// Assert
	assert.NoError(t, err)
	assert.NotNil(t, result)
	assert.Equal(t, cardID, result.Card.ID)
	assert.Equal(t, "Gandalf the Grey", result.Card.NameEN)
	assert.True(t, result.IsOwned)
	mockRepo.AssertExpectations(t)
}

func TestToggleCardPossession_Success_SetNotOwned(t *testing.T) {
	// Arrange
	mockRepo := new(MockCardRepository)
	mockActivityRepo := new(MockActivityRepository)
	activityService := NewActivityService(mockActivityRepo)
	service := NewCardService(mockRepo, activityService)

	// Mock activity recording (best effort - can fail silently)
	mockActivityRepo.On("Create", mock.Anything, mock.Anything).Return(nil)

	ctx := context.Background()
	userID := uuid.MustParse("00000000-0000-0000-0000-000000000001")
	cardID := uuid.New()
	collectionID := uuid.New()

	existingCard := &domain.Card{
		ID:           cardID,
		CollectionID: collectionID,
		NameEN:       "Gandalf the Grey",
		NameFR:       "Gandalf le Gris",
		CardType:     "Hero",
		Series:       "The Wizards",
		Rarity:       "R1",
	}

	mockRepo.On("GetCardByID", ctx, cardID).Return(existingCard, nil)
	mockRepo.On("UpdateUserCardPossession", ctx, userID, cardID, false).Return(nil)

	// Act
	result, err := service.ToggleCardPossession(ctx, userID, cardID, false)

	// Assert
	assert.NoError(t, err)
	assert.NotNil(t, result)
	assert.Equal(t, cardID, result.Card.ID)
	assert.False(t, result.IsOwned)
	mockRepo.AssertExpectations(t)
}

func TestToggleCardPossession_CardNotFound(t *testing.T) {
	// Arrange
	mockRepo := new(MockCardRepository)
	mockActivityRepo := new(MockActivityRepository)
	activityService := NewActivityService(mockActivityRepo)
	service := NewCardService(mockRepo, activityService)

	ctx := context.Background()
	userID := uuid.MustParse("00000000-0000-0000-0000-000000000001")
	cardID := uuid.New()

	mockRepo.On("GetCardByID", ctx, cardID).Return(nil, errors.New("card not found"))

	// Act
	result, err := service.ToggleCardPossession(ctx, userID, cardID, true)

	// Assert
	assert.Error(t, err)
	assert.Nil(t, result)
	assert.Contains(t, err.Error(), "card not found")
	mockRepo.AssertExpectations(t)
}

func TestToggleCardPossession_Idempotent(t *testing.T) {
	// Arrange
	mockRepo := new(MockCardRepository)
	mockActivityRepo := new(MockActivityRepository)
	activityService := NewActivityService(mockActivityRepo)
	service := NewCardService(mockRepo, activityService)

	// Mock activity recording (best effort - can fail silently)
	mockActivityRepo.On("Create", mock.Anything, mock.Anything).Return(nil)

	ctx := context.Background()
	userID := uuid.MustParse("00000000-0000-0000-0000-000000000001")
	cardID := uuid.New()
	collectionID := uuid.New()

	existingCard := &domain.Card{
		ID:           cardID,
		CollectionID: collectionID,
		NameEN:       "Gandalf the Grey",
		NameFR:       "Gandalf le Gris",
		CardType:     "Hero",
		Series:       "The Wizards",
		Rarity:       "R1",
	}

	mockRepo.On("GetCardByID", ctx, cardID).Return(existingCard, nil)
	mockRepo.On("UpdateUserCardPossession", ctx, userID, cardID, true).Return(nil)

	// Act - appeler deux fois avec la même valeur
	result1, err1 := service.ToggleCardPossession(ctx, userID, cardID, true)
	result2, err2 := service.ToggleCardPossession(ctx, userID, cardID, true)

	// Assert - les deux appels doivent réussir
	assert.NoError(t, err1)
	assert.NoError(t, err2)
	assert.NotNil(t, result1)
	assert.NotNil(t, result2)
	assert.Equal(t, result1.Card.ID, result2.Card.ID)
	assert.True(t, result1.IsOwned)
	assert.True(t, result2.IsOwned)
	mockRepo.AssertExpectations(t)
}

func TestToggleCardPossession_RepositoryError(t *testing.T) {
	// Arrange
	mockRepo := new(MockCardRepository)
	mockActivityRepo := new(MockActivityRepository)
	activityService := NewActivityService(mockActivityRepo)
	service := NewCardService(mockRepo, activityService)

	ctx := context.Background()
	userID := uuid.MustParse("00000000-0000-0000-0000-000000000001")
	cardID := uuid.New()
	collectionID := uuid.New()

	existingCard := &domain.Card{
		ID:           cardID,
		CollectionID: collectionID,
		NameEN:       "Gandalf the Grey",
		NameFR:       "Gandalf le Gris",
		CardType:     "Hero",
		Series:       "The Wizards",
		Rarity:       "R1",
	}

	mockRepo.On("GetCardByID", ctx, cardID).Return(existingCard, nil)
	mockRepo.On("UpdateUserCardPossession", ctx, userID, cardID, true).Return(errors.New("database error"))

	// Act
	result, err := service.ToggleCardPossession(ctx, userID, cardID, true)

	// Assert
	assert.Error(t, err)
	assert.Nil(t, result)
	assert.Contains(t, err.Error(), "database error")
	mockRepo.AssertExpectations(t)
}
