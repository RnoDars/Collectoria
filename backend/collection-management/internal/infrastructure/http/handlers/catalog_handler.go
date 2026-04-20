package handlers

import (
	"context"
	"net/http"
	"strconv"
	"time"

	"collectoria/collection-management/internal/domain"

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
	userID := uuid.MustParse("00000000-0000-0000-0000-000000000001")

	q := r.URL.Query()
	page := 1
	limit := 50
	if p := q.Get("page"); p != "" {
		if v, err := strconv.Atoi(p); err == nil && v > 0 {
			page = v
		}
	}
	if l := q.Get("limit"); l != "" {
		if v, err := strconv.Atoi(l); err == nil && v > 0 && v <= 200 {
			limit = v
		}
	}

	filter := domain.CardFilter{
		Search: q.Get("search"),
		Series: q.Get("series"),
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
