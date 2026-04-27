package handlers

import (
	"encoding/json"
	"net/http"

	"github.com/rs/zerolog"
)

// PaginationResponse représente les métadonnées de pagination pour les réponses API
type PaginationResponse struct {
	Total      int `json:"total"`
	Page       int `json:"page"`
	Limit      int `json:"limit"`
	TotalPages int `json:"total_pages"`
}

func writeJSON(w http.ResponseWriter, logger zerolog.Logger, status int, data interface{}) {
	w.Header().Set("Content-Type", "application/json")
	w.WriteHeader(status)
	if err := json.NewEncoder(w).Encode(data); err != nil {
		logger.Error().Err(err).Msg("Failed to encode JSON response")
	}
}

func writeJSONError(w http.ResponseWriter, logger zerolog.Logger, status int, code, message string) {
	writeJSON(w, logger, status, ErrorResponse{
		Error: ErrorDetail{Code: code, Message: message},
	})
}
