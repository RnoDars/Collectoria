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

type ActivityServiceInterface interface {
	GetRecentActivities(ctx context.Context, userID uuid.UUID, limit, offset int) (*domain.ActivityFeed, error)
	GetGrowthStats(ctx context.Context, userID uuid.UUID, period, granularity string) (*domain.GrowthStats, error)
}

type ActivityHandler struct {
	service ActivityServiceInterface
	logger  zerolog.Logger
}

func NewActivityHandler(service ActivityServiceInterface, logger zerolog.Logger) *ActivityHandler {
	return &ActivityHandler{service: service, logger: logger}
}

type ActivityResponse struct {
	ID                    string            `json:"id"`
	Type                  string            `json:"type"`
	Title                 string            `json:"title"`
	Description           string            `json:"description"`
	Timestamp             time.Time         `json:"timestamp"`
	Icon                  string            `json:"icon"`
	RelatedCollectionID   *string           `json:"related_collection_id,omitempty"`
	RelatedCollectionName string            `json:"related_collection_name,omitempty"`
	Metadata              map[string]string `json:"metadata,omitempty"`
}

type ActivityFeedResponse struct {
	Activities []ActivityResponse `json:"activities"`
	TotalCount int                `json:"total_count"`
	HasMore    bool               `json:"has_more"`
}

type GrowthDataPointResponse struct {
	Period     string `json:"period"`
	Label      string `json:"label"`
	CardsAdded int    `json:"cards_added"`
	TotalCards int    `json:"total_cards"`
}

type GrowthStatsResponse struct {
	Period               string                    `json:"period"`
	Granularity          string                    `json:"granularity"`
	DataPoints           []GrowthDataPointResponse `json:"data_points"`
	GrowthRatePercentage float64                   `json:"growth_rate_percentage"`
	Trend                string                    `json:"trend"`
}

func (h *ActivityHandler) GetRecentActivities(w http.ResponseWriter, r *http.Request) {
	ctx := r.Context()
	userID := uuid.MustParse("00000000-0000-0000-0000-000000000001")

	limit := 10
	offset := 0
	if l := r.URL.Query().Get("limit"); l != "" {
		if v, err := strconv.Atoi(l); err == nil && v > 0 && v <= 50 {
			limit = v
		}
	}
	if o := r.URL.Query().Get("offset"); o != "" {
		if v, err := strconv.Atoi(o); err == nil && v >= 0 {
			offset = v
		}
	}

	feed, err := h.service.GetRecentActivities(ctx, userID, limit, offset)
	if err != nil {
		h.logger.Error().Err(err).Msg("Failed to get recent activities")
		writeJSONError(w, h.logger, http.StatusInternalServerError, "INTERNAL_ERROR", "Failed to fetch activities")
		return
	}

	activities := make([]ActivityResponse, len(feed.Activities))
	for i, a := range feed.Activities {
		ar := ActivityResponse{
			ID:                    a.ID.String(),
			Type:                  string(a.Type),
			Title:                 a.Title,
			Description:           a.Description,
			Timestamp:             a.Timestamp,
			Icon:                  a.Icon,
			RelatedCollectionName: a.RelatedCollectionName,
			Metadata:              a.Metadata,
		}
		if a.RelatedCollectionID != nil {
			s := a.RelatedCollectionID.String()
			ar.RelatedCollectionID = &s
		}
		activities[i] = ar
	}

	writeJSON(w, h.logger, http.StatusOK, ActivityFeedResponse{
		Activities: activities,
		TotalCount: feed.TotalCount,
		HasMore:    feed.HasMore,
	})
}

func (h *ActivityHandler) GetGrowthStats(w http.ResponseWriter, r *http.Request) {
	ctx := r.Context()
	userID := uuid.MustParse("00000000-0000-0000-0000-000000000001")

	period := r.URL.Query().Get("period")
	if period == "" {
		period = "6m"
	}
	granularity := r.URL.Query().Get("granularity")
	if granularity == "" {
		granularity = "month"
	}

	stats, err := h.service.GetGrowthStats(ctx, userID, period, granularity)
	if err != nil {
		h.logger.Error().Err(err).Msg("Failed to get growth stats")
		writeJSONError(w, h.logger, http.StatusInternalServerError, "INTERNAL_ERROR", "Failed to fetch growth stats")
		return
	}

	dataPoints := make([]GrowthDataPointResponse, len(stats.DataPoints))
	for i, dp := range stats.DataPoints {
		dataPoints[i] = GrowthDataPointResponse{
			Period:     dp.Period,
			Label:      dp.Label,
			CardsAdded: dp.CardsAdded,
			TotalCards: dp.TotalCards,
		}
	}

	writeJSON(w, h.logger, http.StatusOK, GrowthStatsResponse{
		Period:               stats.Period,
		Granularity:          stats.Granularity,
		DataPoints:           dataPoints,
		GrowthRatePercentage: stats.GrowthRatePercentage,
		Trend:                stats.Trend,
	})
}
