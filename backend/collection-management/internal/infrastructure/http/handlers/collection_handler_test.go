package handlers

import (
	"context"
	"encoding/json"
	"errors"
	"net/http"
	"net/http/httptest"
	"testing"

	"collectoria/collection-management/internal/domain"

	"github.com/google/uuid"
	"github.com/rs/zerolog"
	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/mock"
)

// MockCollectionService est un mock du CollectionService
type MockCollectionService struct {
	mock.Mock
}

func (m *MockCollectionService) GetSummary(ctx context.Context, userID uuid.UUID) (*domain.CollectionSummary, error) {
	args := m.Called(ctx, userID)
	if args.Get(0) == nil {
		return nil, args.Error(1)
	}
	return args.Get(0).(*domain.CollectionSummary), args.Error(1)
}

func (m *MockCollectionService) GetAllCollections(ctx context.Context) ([]domain.Collection, error) {
	args := m.Called(ctx)
	return args.Get(0).([]domain.Collection), args.Error(1)
}

func (m *MockCollectionService) GetUserCollections(ctx context.Context, userID uuid.UUID) ([]domain.Collection, error) {
	args := m.Called(ctx, userID)
	return args.Get(0).([]domain.Collection), args.Error(1)
}

func (m *MockCollectionService) GetAllCollectionsWithStats(ctx context.Context, userID uuid.UUID) ([]domain.CollectionWithStats, error) {
	args := m.Called(ctx, userID)
	if args.Get(0) == nil {
		return nil, args.Error(1)
	}
	return args.Get(0).([]domain.CollectionWithStats), args.Error(1)
}

func TestCollectionHandler_GetAllCollections(t *testing.T) {
	logger := zerolog.Nop()
	userID := uuid.MustParse("00000000-0000-0000-0000-000000000001")
	meccgID := uuid.New()
	doomtrooperID := uuid.New()

	t.Run("Success with MECCG and Doomtrooper", func(t *testing.T) {
		mockService := new(MockCollectionService)
		handler := NewCollectionHandler(mockService, logger)

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

		mockService.On("GetAllCollectionsWithStats", mock.Anything, userID).Return(expectedCollections, nil)

		req := httptest.NewRequest(http.MethodGet, "/api/v1/collections", nil)
		w := httptest.NewRecorder()

		handler.GetAllCollections(w, req)

		assert.Equal(t, http.StatusOK, w.Code)
		assert.Equal(t, "application/json", w.Header().Get("Content-Type"))

		var response CollectionsResponse
		err := json.NewDecoder(w.Body).Decode(&response)
		assert.NoError(t, err)

		assert.Len(t, response.Collections, 2)
		assert.Equal(t, 2, response.TotalCollections)

		// Vérifier MECCG
		assert.Equal(t, meccgID.String(), response.Collections[0].ID)
		assert.Equal(t, "Middle-Earth CCG", response.Collections[0].Name)
		assert.Equal(t, "meccg", response.Collections[0].Slug)
		assert.Equal(t, 24, response.Collections[0].TotalCardsOwned)
		assert.Equal(t, 40, response.Collections[0].TotalCardsAvailable)
		assert.Equal(t, 60.0, response.Collections[0].CompletionPercentage)
		assert.NotNil(t, response.Collections[0].LastUpdated)

		// Vérifier Doomtrooper
		assert.Equal(t, doomtrooperID.String(), response.Collections[1].ID)
		assert.Equal(t, "Doomtrooper", response.Collections[1].Name)
		assert.Equal(t, "doomtrooper", response.Collections[1].Slug)
		assert.Equal(t, 0, response.Collections[1].TotalCardsOwned)
		assert.Equal(t, 0, response.Collections[1].TotalCardsAvailable)
		assert.Equal(t, 0.0, response.Collections[1].CompletionPercentage)
		assert.Nil(t, response.Collections[1].LastUpdated)

		mockService.AssertExpectations(t)
	})

	t.Run("Error from service", func(t *testing.T) {
		mockService := new(MockCollectionService)
		handler := NewCollectionHandler(mockService, logger)

		var nilCollections []domain.CollectionWithStats
		mockService.On("GetAllCollectionsWithStats", mock.Anything, userID).Return(nilCollections, errors.New("database error"))

		req := httptest.NewRequest(http.MethodGet, "/api/v1/collections", nil)
		w := httptest.NewRecorder()

		handler.GetAllCollections(w, req)

		assert.Equal(t, http.StatusInternalServerError, w.Code)

		var response ErrorResponse
		err := json.NewDecoder(w.Body).Decode(&response)
		assert.NoError(t, err)

		assert.Equal(t, "INTERNAL_ERROR", response.Error.Code)
		assert.Equal(t, "Failed to fetch collections", response.Error.Message)

		mockService.AssertExpectations(t)
	})

	t.Run("User without collections", func(t *testing.T) {
		mockService := new(MockCollectionService)
		handler := NewCollectionHandler(mockService, logger)

		mockService.On("GetAllCollectionsWithStats", mock.Anything, userID).Return([]domain.CollectionWithStats{}, nil)

		req := httptest.NewRequest(http.MethodGet, "/api/v1/collections", nil)
		w := httptest.NewRecorder()

		handler.GetAllCollections(w, req)

		assert.Equal(t, http.StatusOK, w.Code)

		var response CollectionsResponse
		err := json.NewDecoder(w.Body).Decode(&response)
		assert.NoError(t, err)

		assert.Len(t, response.Collections, 0)
		assert.Equal(t, 0, response.TotalCollections)

		mockService.AssertExpectations(t)
	})
}
