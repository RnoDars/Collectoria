package handlers

import (
	"encoding/json"
	"net/http"
	"time"

	"collectoria/collection-management/internal/application"

	"github.com/google/uuid"
	"github.com/rs/zerolog"
)

// CollectionHandler gère les requêtes HTTP pour les collections
type CollectionHandler struct {
	service *application.CollectionService
	logger  zerolog.Logger
}

// NewCollectionHandler crée un nouveau handler
func NewCollectionHandler(service *application.CollectionService, logger zerolog.Logger) *CollectionHandler {
	return &CollectionHandler{
		service: service,
		logger:  logger,
	}
}

// SummaryResponse représente la réponse JSON pour le summary
type SummaryResponse struct {
	UserID               string    `json:"user_id"`
	TotalCardsOwned      int       `json:"total_cards_owned"`
	TotalCardsAvailable  int       `json:"total_cards_available"`
	CompletionPercentage float64   `json:"completion_percentage"`
	LastUpdated          time.Time `json:"last_updated"`
}

// ErrorResponse représente une réponse d'erreur
type ErrorResponse struct {
	Error ErrorDetail `json:"error"`
}

// ErrorDetail représente les détails d'une erreur
type ErrorDetail struct {
	Code    string `json:"code"`
	Message string `json:"message"`
}

// GetSummary retourne les statistiques globales de toutes les collections
func (h *CollectionHandler) GetSummary(w http.ResponseWriter, r *http.Request) {
	ctx := r.Context()

	// Pour l'instant, utiliser un userID fictif hardcodé
	// TODO: Récupérer depuis le JWT token une fois l'authentification implémentée
	userID := uuid.MustParse("00000000-0000-0000-0000-000000000001")

	summary, err := h.service.GetSummary(ctx, userID)
	if err != nil {
		h.logger.Error().Err(err).Msg("Failed to get collection summary")
		h.writeError(w, http.StatusInternalServerError, "INTERNAL_ERROR", "Failed to fetch collection summary")
		return
	}

	response := SummaryResponse{
		UserID:               summary.UserID.String(),
		TotalCardsOwned:      summary.TotalCardsOwned,
		TotalCardsAvailable:  summary.TotalCardsAvailable,
		CompletionPercentage: summary.CompletionPercentage,
		LastUpdated:          summary.LastUpdated,
	}

	h.writeJSON(w, http.StatusOK, response)
}

// GetAllCollections retourne toutes les collections
func (h *CollectionHandler) GetAllCollections(w http.ResponseWriter, r *http.Request) {
	ctx := r.Context()

	collections, err := h.service.GetAllCollections(ctx)
	if err != nil {
		h.logger.Error().Err(err).Msg("Failed to get collections")
		h.writeError(w, http.StatusInternalServerError, "INTERNAL_ERROR", "Failed to fetch collections")
		return
	}

	h.writeJSON(w, http.StatusOK, collections)
}

// writeJSON écrit une réponse JSON
func (h *CollectionHandler) writeJSON(w http.ResponseWriter, status int, data interface{}) {
	w.Header().Set("Content-Type", "application/json")
	w.WriteHeader(status)
	if err := json.NewEncoder(w).Encode(data); err != nil {
		h.logger.Error().Err(err).Msg("Failed to encode JSON response")
	}
}

// writeError écrit une réponse d'erreur
func (h *CollectionHandler) writeError(w http.ResponseWriter, status int, code, message string) {
	response := ErrorResponse{
		Error: ErrorDetail{
			Code:    code,
			Message: message,
		},
	}
	h.writeJSON(w, status, response)
}
