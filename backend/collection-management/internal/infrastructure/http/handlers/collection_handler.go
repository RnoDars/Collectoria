package handlers

import (
	"context"
	"net/http"
	"time"

	"collectoria/collection-management/internal/application"
	"collectoria/collection-management/internal/domain"

	"github.com/google/uuid"
	"github.com/rs/zerolog"
)

// CollectionServiceInterface définit les méthodes du service utilisées par le handler
type CollectionServiceInterface interface {
	GetSummary(ctx context.Context, userID uuid.UUID) (*domain.CollectionSummary, error)
	GetAllCollections(ctx context.Context) ([]domain.Collection, error)
	GetUserCollections(ctx context.Context, userID uuid.UUID) ([]domain.Collection, error)
	GetAllCollectionsWithStats(ctx context.Context, userID uuid.UUID) ([]domain.CollectionWithStats, error)
}

// CollectionHandler gère les requêtes HTTP pour les collections
type CollectionHandler struct {
	service CollectionServiceInterface
	logger  zerolog.Logger
}

// NewCollectionHandler crée un nouveau handler
func NewCollectionHandler(service CollectionServiceInterface, logger zerolog.Logger) *CollectionHandler {
	return &CollectionHandler{
		service: service,
		logger:  logger,
	}
}

// Ensure CollectionService implements CollectionServiceInterface
var _ CollectionServiceInterface = (*application.CollectionService)(nil)

// SummaryResponse représente la réponse JSON pour le summary
type SummaryResponse struct {
	UserID               string    `json:"user_id"`
	TotalCardsOwned      int       `json:"total_cards_owned"`
	TotalCardsAvailable  int       `json:"total_cards_available"`
	CompletionPercentage float64   `json:"completion_percentage"`
	LastUpdated          time.Time `json:"last_updated"`
}

// CollectionResponse représente une collection dans la réponse JSON
type CollectionResponse struct {
	ID                   string     `json:"id"`
	Name                 string     `json:"name"`
	Slug                 string     `json:"slug"`
	Description          string     `json:"description"`
	TotalCardsOwned      int        `json:"total_cards_owned"`
	TotalCardsAvailable  int        `json:"total_cards_available"`
	CompletionPercentage float64    `json:"completion_percentage"`
	HeroImageURL         string     `json:"hero_image_url"`
	LastUpdated          *time.Time `json:"last_updated"`
}

// CollectionsResponse représente la réponse JSON pour la liste des collections
type CollectionsResponse struct {
	Collections      []CollectionResponse `json:"collections"`
	TotalCollections int                  `json:"total_collections"`
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
		writeJSONError(w, h.logger, http.StatusInternalServerError, "INTERNAL_ERROR", "Failed to fetch collection summary")
		return
	}

	response := SummaryResponse{
		UserID:               summary.UserID.String(),
		TotalCardsOwned:      summary.TotalCardsOwned,
		TotalCardsAvailable:  summary.TotalCardsAvailable,
		CompletionPercentage: summary.CompletionPercentage,
		LastUpdated:          summary.LastUpdated,
	}

	writeJSON(w, h.logger, http.StatusOK, response)
}

// GetAllCollections retourne toutes les collections avec leurs statistiques
func (h *CollectionHandler) GetAllCollections(w http.ResponseWriter, r *http.Request) {
	ctx := r.Context()

	// TODO: Récupérer depuis le JWT token une fois l'authentification implémentée
	userID := uuid.MustParse("00000000-0000-0000-0000-000000000001")

	collections, err := h.service.GetAllCollectionsWithStats(ctx, userID)
	if err != nil {
		h.logger.Error().Err(err).Msg("Failed to get collections")
		writeJSONError(w, h.logger, http.StatusInternalServerError, "INTERNAL_ERROR", "Failed to fetch collections")
		return
	}

	collectionsResponse := make([]CollectionResponse, len(collections))
	for i, coll := range collections {
		collectionsResponse[i] = CollectionResponse{
			ID:                   coll.ID.String(),
			Name:                 coll.Name,
			Slug:                 coll.Slug,
			Description:          coll.Description,
			TotalCardsOwned:      coll.TotalCardsOwned,
			TotalCardsAvailable:  coll.TotalCardsAvailable,
			CompletionPercentage: coll.CompletionPercentage,
			HeroImageURL:         coll.HeroImageURL,
			LastUpdated:          coll.LastUpdated,
		}
	}

	writeJSON(w, h.logger, http.StatusOK, CollectionsResponse{
		Collections:      collectionsResponse,
		TotalCollections: len(collectionsResponse),
	})
}
