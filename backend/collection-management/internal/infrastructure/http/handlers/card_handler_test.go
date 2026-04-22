package handlers

import (
	"bytes"
	"context"
	"encoding/json"
	"errors"
	"net/http"
	"net/http/httptest"
	"testing"

	"collectoria/collection-management/internal/domain"
	"collectoria/collection-management/internal/infrastructure/http/middleware"

	"github.com/go-chi/chi/v5"
	"github.com/google/uuid"
	"github.com/rs/zerolog"
	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/mock"
)

type MockCardService struct {
	mock.Mock
}

func (m *MockCardService) ToggleCardPossession(ctx context.Context, userID, cardID uuid.UUID, isOwned bool) (*domain.CardWithOwnership, error) {
	args := m.Called(ctx, userID, cardID, isOwned)
	if args.Get(0) == nil {
		return nil, args.Error(1)
	}
	return args.Get(0).(*domain.CardWithOwnership), args.Error(1)
}

func TestCardHandler_UpdateCardPossession_Success(t *testing.T) {
	// Arrange
	mockService := new(MockCardService)
	logger := zerolog.Nop()
	handler := NewCardHandler(mockService, logger)

	cardID := uuid.New()
	userID := uuid.MustParse("00000000-0000-0000-0000-000000000001")
	collectionID := uuid.New()

	expectedResult := &domain.CardWithOwnership{
		Card: domain.Card{
			ID:           cardID,
			CollectionID: collectionID,
			NameEN:       "Gandalf the Grey",
			NameFR:       "Gandalf le Gris",
			CardType:     "Hero",
			Series:       "The Wizards",
			Rarity:       "R1",
		},
		IsOwned: true,
	}

	mockService.On("ToggleCardPossession", mock.Anything, userID, cardID, true).Return(expectedResult, nil)

	reqBody := UpdatePossessionRequest{IsOwned: true}
	body, _ := json.Marshal(reqBody)
	req := httptest.NewRequest(http.MethodPatch, "/api/v1/cards/"+cardID.String()+"/possession", bytes.NewBuffer(body))

	// Setup chi context avec le paramètre d'URL
	rctx := chi.NewRouteContext()
	rctx.URLParams.Add("id", cardID.String())
	ctx := context.WithValue(req.Context(), chi.RouteCtxKey, rctx)
	// Inject userID into context (simulating auth middleware)
	ctx = middleware.WithUserID(ctx, userID)
	req = req.WithContext(ctx)

	rr := httptest.NewRecorder()

	// Act
	handler.UpdateCardPossession(rr, req)

	// Assert
	assert.Equal(t, http.StatusOK, rr.Code)

	var response UpdatePossessionResponse
	err := json.NewDecoder(rr.Body).Decode(&response)
	assert.NoError(t, err)
	assert.True(t, response.Success)
	assert.Equal(t, cardID.String(), response.Card.ID)
	assert.Equal(t, "Gandalf the Grey", response.Card.NameEN)
	assert.True(t, response.Card.IsOwned)

	mockService.AssertExpectations(t)
}

func TestCardHandler_UpdateCardPossession_InvalidCardID(t *testing.T) {
	// Arrange
	mockService := new(MockCardService)
	logger := zerolog.Nop()
	handler := NewCardHandler(mockService, logger)

	reqBody := UpdatePossessionRequest{IsOwned: true}
	body, _ := json.Marshal(reqBody)
	req := httptest.NewRequest(http.MethodPatch, "/api/v1/cards/invalid-uuid/possession", bytes.NewBuffer(body))

	// Setup chi context avec un ID invalide
	rctx := chi.NewRouteContext()
	rctx.URLParams.Add("id", "invalid-uuid")
	req = req.WithContext(context.WithValue(req.Context(), chi.RouteCtxKey, rctx))

	rr := httptest.NewRecorder()

	// Act
	handler.UpdateCardPossession(rr, req)

	// Assert
	assert.Equal(t, http.StatusBadRequest, rr.Code)

	var response ErrorResponse
	err := json.NewDecoder(rr.Body).Decode(&response)
	assert.NoError(t, err)
	assert.Equal(t, "INVALID_CARD_ID", response.Error.Code)
}

func TestCardHandler_UpdateCardPossession_InvalidBody(t *testing.T) {
	// Arrange
	mockService := new(MockCardService)
	logger := zerolog.Nop()
	handler := NewCardHandler(mockService, logger)

	cardID := uuid.New()

	req := httptest.NewRequest(http.MethodPatch, "/api/v1/cards/"+cardID.String()+"/possession", bytes.NewBufferString("invalid json"))

	// Setup chi context
	rctx := chi.NewRouteContext()
	rctx.URLParams.Add("id", cardID.String())
	req = req.WithContext(context.WithValue(req.Context(), chi.RouteCtxKey, rctx))

	rr := httptest.NewRecorder()

	// Act
	handler.UpdateCardPossession(rr, req)

	// Assert
	assert.Equal(t, http.StatusBadRequest, rr.Code)

	var response ErrorResponse
	err := json.NewDecoder(rr.Body).Decode(&response)
	assert.NoError(t, err)
	assert.Equal(t, "INVALID_BODY", response.Error.Code)
}

func TestCardHandler_UpdateCardPossession_CardNotFound(t *testing.T) {
	// Arrange
	mockService := new(MockCardService)
	logger := zerolog.Nop()
	handler := NewCardHandler(mockService, logger)

	cardID := uuid.New()
	userID := uuid.MustParse("00000000-0000-0000-0000-000000000001")

	mockService.On("ToggleCardPossession", mock.Anything, userID, cardID, true).Return(nil, errors.New("card not found: sql: no rows in result set"))

	reqBody := UpdatePossessionRequest{IsOwned: true}
	body, _ := json.Marshal(reqBody)
	req := httptest.NewRequest(http.MethodPatch, "/api/v1/cards/"+cardID.String()+"/possession", bytes.NewBuffer(body))

	// Setup chi context
	rctx := chi.NewRouteContext()
	rctx.URLParams.Add("id", cardID.String())
	ctx := context.WithValue(req.Context(), chi.RouteCtxKey, rctx)
	// Inject userID into context (simulating auth middleware)
	ctx = middleware.WithUserID(ctx, userID)
	req = req.WithContext(ctx)

	rr := httptest.NewRecorder()

	// Act
	handler.UpdateCardPossession(rr, req)

	// Assert
	assert.Equal(t, http.StatusNotFound, rr.Code)

	var response ErrorResponse
	err := json.NewDecoder(rr.Body).Decode(&response)
	assert.NoError(t, err)
	assert.Equal(t, "CARD_NOT_FOUND", response.Error.Code)

	mockService.AssertExpectations(t)
}

func TestCardHandler_UpdateCardPossession_ServiceError(t *testing.T) {
	// Arrange
	mockService := new(MockCardService)
	logger := zerolog.Nop()
	handler := NewCardHandler(mockService, logger)

	cardID := uuid.New()
	userID := uuid.MustParse("00000000-0000-0000-0000-000000000001")

	mockService.On("ToggleCardPossession", mock.Anything, userID, cardID, true).Return(nil, errors.New("database error"))

	reqBody := UpdatePossessionRequest{IsOwned: true}
	body, _ := json.Marshal(reqBody)
	req := httptest.NewRequest(http.MethodPatch, "/api/v1/cards/"+cardID.String()+"/possession", bytes.NewBuffer(body))

	// Setup chi context
	rctx := chi.NewRouteContext()
	rctx.URLParams.Add("id", cardID.String())
	ctx := context.WithValue(req.Context(), chi.RouteCtxKey, rctx)
	// Inject userID into context (simulating auth middleware)
	ctx = middleware.WithUserID(ctx, userID)
	req = req.WithContext(ctx)

	rr := httptest.NewRecorder()

	// Act
	handler.UpdateCardPossession(rr, req)

	// Assert
	assert.Equal(t, http.StatusInternalServerError, rr.Code)

	var response ErrorResponse
	err := json.NewDecoder(rr.Body).Decode(&response)
	assert.NoError(t, err)
	assert.Equal(t, "INTERNAL_ERROR", response.Error.Code)

	mockService.AssertExpectations(t)
}

func TestCardHandler_UpdateCardPossession_SetNotOwned(t *testing.T) {
	// Arrange
	mockService := new(MockCardService)
	logger := zerolog.Nop()
	handler := NewCardHandler(mockService, logger)

	cardID := uuid.New()
	userID := uuid.MustParse("00000000-0000-0000-0000-000000000001")
	collectionID := uuid.New()

	expectedResult := &domain.CardWithOwnership{
		Card: domain.Card{
			ID:           cardID,
			CollectionID: collectionID,
			NameEN:       "Gandalf the Grey",
			NameFR:       "Gandalf le Gris",
			CardType:     "Hero",
			Series:       "The Wizards",
			Rarity:       "R1",
		},
		IsOwned: false,
	}

	mockService.On("ToggleCardPossession", mock.Anything, userID, cardID, false).Return(expectedResult, nil)

	reqBody := UpdatePossessionRequest{IsOwned: false}
	body, _ := json.Marshal(reqBody)
	req := httptest.NewRequest(http.MethodPatch, "/api/v1/cards/"+cardID.String()+"/possession", bytes.NewBuffer(body))

	// Setup chi context
	rctx := chi.NewRouteContext()
	rctx.URLParams.Add("id", cardID.String())
	ctx := context.WithValue(req.Context(), chi.RouteCtxKey, rctx)
	// Inject userID into context (simulating auth middleware)
	ctx = middleware.WithUserID(ctx, userID)
	req = req.WithContext(ctx)

	rr := httptest.NewRecorder()

	// Act
	handler.UpdateCardPossession(rr, req)

	// Assert
	assert.Equal(t, http.StatusOK, rr.Code)

	var response UpdatePossessionResponse
	err := json.NewDecoder(rr.Body).Decode(&response)
	assert.NoError(t, err)
	assert.True(t, response.Success)
	assert.False(t, response.Card.IsOwned)

	mockService.AssertExpectations(t)
}
