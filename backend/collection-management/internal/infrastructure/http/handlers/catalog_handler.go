package handlers

import (
	"context"
	"net/http"
	"strconv"
	"time"

	"collectoria/collection-management/internal/domain"
	"collectoria/collection-management/internal/infrastructure/http/middleware"
	"collectoria/collection-management/internal/infrastructure/http/validators"

	"github.com/google/uuid"
	"github.com/rs/zerolog"
)

type CatalogServiceInterface interface {
	GetCatalog(ctx context.Context, userID uuid.UUID, filter domain.CardFilter) (*domain.CardPage, error)
}

type CatalogHandler struct {
	service CatalogServiceInterface
	logger  zerolog.Logger
}

func NewCatalogHandler(service CatalogServiceInterface, logger zerolog.Logger) *CatalogHandler {
	return &CatalogHandler{service: service, logger: logger}
}

type CardResponse struct {
	ID       string `json:"id"`
	NameEN   string `json:"name_en"`
	NameFR   string `json:"name_fr"`
	CardType string `json:"card_type"`
	Series   string `json:"series"`
	Rarity   string `json:"rarity"`
	IsOwned  bool   `json:"is_owned"`
}

type CardPageResponse struct {
	Cards     []CardResponse `json:"cards"`
	Total     int            `json:"total"`
	Page      int            `json:"page"`
	HasMore   bool           `json:"has_more"`
	Timestamp time.Time      `json:"timestamp"`
}

func (h *CatalogHandler) GetCards(w http.ResponseWriter, r *http.Request) {
	ctx := r.Context()

	// Extract userID from context (injected by auth middleware)
	userID, err := middleware.GetUserID(ctx)
	if err != nil {
		h.logger.Error().Err(err).Msg("Failed to get user ID from context")
		writeJSONError(w, h.logger, http.StatusUnauthorized, "UNAUTHORIZED", "User not authenticated")
		return
	}

	q := r.URL.Query()

	// Validation des paramètres de pagination
	page := 1
	limit := 50
	if p := q.Get("page"); p != "" {
		if v, err := strconv.Atoi(p); err == nil && v > 0 {
			page = v
		} else {
			writeJSONError(w, h.logger, http.StatusBadRequest, "INVALID_PARAM", "Invalid page parameter")
			return
		}
	}
	if l := q.Get("limit"); l != "" {
		if v, err := strconv.Atoi(l); err == nil && v > 0 && v <= 200 {
			limit = v
		} else {
			writeJSONError(w, h.logger, http.StatusBadRequest, "INVALID_PARAM", "Invalid limit parameter (must be 1-200)")
			return
		}
	}

	// Validation des paramètres de recherche
	search := q.Get("search")
	if search != "" {
		if err := validators.ValidateStringParam(search, 100); err != nil {
			writeJSONError(w, h.logger, http.StatusBadRequest, "INVALID_PARAM", err.Error())
			return
		}
	}

	series := q.Get("series")
	if series != "" {
		if err := validators.ValidateStringParam(series, 50); err != nil {
			writeJSONError(w, h.logger, http.StatusBadRequest, "INVALID_PARAM", err.Error())
			return
		}
	}

	filter := domain.CardFilter{
		Search: search,
		Series: series,
		Type:   q.Get("type"),
		Rarity: q.Get("rarity"),
		Owned:  q.Get("owned"),
		Page:   page,
		Limit:  limit,
	}

	result, err := h.service.GetCatalog(ctx, userID, filter)
	if err != nil {
		h.logger.Error().Err(err).Msg("Failed to get cards catalog")
		writeJSONError(w, h.logger, http.StatusInternalServerError, "INTERNAL_ERROR", "Failed to fetch cards")
		return
	}

	cards := make([]CardResponse, len(result.Cards))
	for i, c := range result.Cards {
		cards[i] = CardResponse{
			ID:       c.Card.ID.String(),
			NameEN:   c.Card.NameEN,
			NameFR:   c.Card.NameFR,
			CardType: c.Card.CardType,
			Series:   c.Card.Series,
			Rarity:   c.Card.Rarity,
			IsOwned:  c.IsOwned,
		}
	}

	writeJSON(w, h.logger, http.StatusOK, CardPageResponse{
		Cards:     cards,
		Total:     result.Total,
		Page:      result.Page,
		HasMore:   result.HasMore,
		Timestamp: time.Now(),
	})
}
