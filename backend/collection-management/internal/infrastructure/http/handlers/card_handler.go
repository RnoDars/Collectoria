package handlers

import (
	"context"
	"encoding/json"
	"net/http"
	"strings"

	"collectoria/collection-management/internal/domain"

	"github.com/go-chi/chi/v5"
	"github.com/google/uuid"
	"github.com/rs/zerolog"
)

func contains(s, substr string) bool {
	return strings.Contains(s, substr)
}

type CardServiceInterface interface {
	ToggleCardPossession(ctx context.Context, userID, cardID uuid.UUID, isOwned bool) (*domain.CardWithOwnership, error)
}

type CardHandler struct {
	service CardServiceInterface
	logger  zerolog.Logger
}

func NewCardHandler(service CardServiceInterface, logger zerolog.Logger) *CardHandler {
	return &CardHandler{service: service, logger: logger}
}

type UpdatePossessionRequest struct {
	IsOwned bool `json:"is_owned"`
}

type UpdatePossessionResponse struct {
	Success bool         `json:"success"`
	Card    CardResponse `json:"card"`
}

func (h *CardHandler) UpdateCardPossession(w http.ResponseWriter, r *http.Request) {
	ctx := r.Context()

	// 1. Parse card ID from URL param
	cardIDStr := chi.URLParam(r, "id")
	cardID, err := uuid.Parse(cardIDStr)
	if err != nil {
		writeJSONError(w, h.logger, http.StatusBadRequest, "INVALID_CARD_ID", "Invalid card ID format")
		return
	}

	// 2. Parse request body
	var req UpdatePossessionRequest
	if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
		writeJSONError(w, h.logger, http.StatusBadRequest, "INVALID_BODY", "Invalid request body")
		return
	}

	// 3. Get userID (hardcodé pour l'instant)
	userID := uuid.MustParse("00000000-0000-0000-0000-000000000001")

	// 4. Call service
	result, err := h.service.ToggleCardPossession(ctx, userID, cardID, req.IsOwned)
	if err != nil {
		h.logger.Error().Err(err).Str("card_id", cardID.String()).Bool("is_owned", req.IsOwned).Msg("Failed to toggle card possession")

		// Vérifier si c'est une erreur "carte non trouvée"
		errMsg := err.Error()
		if errMsg == "card not found: sql: no rows in result set" ||
		   errMsg == "sql: no rows in result set" ||
		   contains(errMsg, "no rows in result set") {
			writeJSONError(w, h.logger, http.StatusNotFound, "CARD_NOT_FOUND", "Card not found")
			return
		}

		writeJSONError(w, h.logger, http.StatusInternalServerError, "INTERNAL_ERROR", "Failed to update card possession")
		return
	}

	// 5. Return response
	response := UpdatePossessionResponse{
		Success: true,
		Card: CardResponse{
			ID:       result.Card.ID.String(),
			NameEN:   result.Card.NameEN,
			NameFR:   result.Card.NameFR,
			CardType: result.Card.CardType,
			Series:   result.Card.Series,
			Rarity:   result.Card.Rarity,
			IsOwned:  result.IsOwned,
		},
	}

	h.logger.Info().Str("card_id", cardID.String()).Bool("is_owned", req.IsOwned).Msg("Card possession updated successfully")
	writeJSON(w, h.logger, http.StatusOK, response)
}
