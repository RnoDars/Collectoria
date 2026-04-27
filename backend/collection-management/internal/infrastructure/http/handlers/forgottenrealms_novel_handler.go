package handlers

import (
	"context"
	"encoding/json"
	"net/http"
	"strconv"
	"strings"
	"time"

	"collectoria/collection-management/internal/domain"
	"collectoria/collection-management/internal/infrastructure/http/middleware"
	"collectoria/collection-management/internal/infrastructure/http/validators"

	"github.com/go-chi/chi/v5"
	"github.com/google/uuid"
	"github.com/rs/zerolog"
)

type ForgottenRealmsNovelServiceInterface interface {
	GetNovelsCatalog(ctx context.Context, userID uuid.UUID, filter domain.ForgottenRealmsNovelFilter) (*domain.ForgottenRealmsNovelPage, error)
	ToggleNovelPossession(ctx context.Context, userID, novelID uuid.UUID, isOwned bool) (*domain.ForgottenRealmsNovelWithOwnership, error)
}

type ForgottenRealmsNovelHandler struct {
	service ForgottenRealmsNovelServiceInterface
	logger  zerolog.Logger
}

func NewForgottenRealmsNovelHandler(service ForgottenRealmsNovelServiceInterface, logger zerolog.Logger) *ForgottenRealmsNovelHandler {
	return &ForgottenRealmsNovelHandler{service: service, logger: logger}
}

type NovelResponse struct {
	ID              string    `json:"id"`
	Number          string    `json:"number"`
	Title           string    `json:"title"`
	Author          string    `json:"author"`
	PublicationDate time.Time `json:"publication_date"`
	BookType        string    `json:"book_type"`
	IsOwned         bool      `json:"is_owned"`
	CreatedAt       time.Time `json:"created_at"`
	UpdatedAt       time.Time `json:"updated_at"`
}

type NovelPageResponse struct {
	Novels     []NovelResponse    `json:"novels"`
	Pagination PaginationResponse `json:"pagination"`
}

type UpdateNovelPossessionRequest struct {
	IsOwned bool `json:"is_owned"`
}

// GetNovels récupère le catalogue de romans des Royaumes Oubliés avec filtres et pagination
func (h *ForgottenRealmsNovelHandler) GetNovels(w http.ResponseWriter, r *http.Request) {
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
		if v, err := strconv.Atoi(l); err == nil && v > 0 && v <= 500 {
			limit = v
		} else {
			writeJSONError(w, h.logger, http.StatusBadRequest, "INVALID_PARAM", "Invalid limit parameter (must be 1-500)")
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

	author := q.Get("author")
	if author != "" {
		if err := validators.ValidateStringParam(author, 100); err != nil {
			writeJSONError(w, h.logger, http.StatusBadRequest, "INVALID_PARAM", err.Error())
			return
		}
	}

	bookType := q.Get("book_type")
	if bookType != "" {
		if err := validators.ValidateStringParam(bookType, 100); err != nil {
			writeJSONError(w, h.logger, http.StatusBadRequest, "INVALID_PARAM", err.Error())
			return
		}
	}

	series := q.Get("series")
	if series != "" {
		if series != "principal" && series != "hors-serie" {
			writeJSONError(w, h.logger, http.StatusBadRequest, "INVALID_PARAM", "Invalid series parameter (must be 'principal' or 'hors-serie')")
			return
		}
	}

	// Parse is_owned parameter
	var isOwned *bool
	if isOwnedStr := q.Get("is_owned"); isOwnedStr != "" {
		if isOwnedStr == "true" {
			t := true
			isOwned = &t
		} else if isOwnedStr == "false" {
			f := false
			isOwned = &f
		} else {
			writeJSONError(w, h.logger, http.StatusBadRequest, "INVALID_PARAM", "Invalid is_owned parameter (must be 'true' or 'false')")
			return
		}
	}

	filter := domain.ForgottenRealmsNovelFilter{
		Search:   search,
		Author:   author,
		BookType: bookType,
		Series:   series,
		IsOwned:  isOwned,
		Page:     page,
		Limit:    limit,
	}

	result, err := h.service.GetNovelsCatalog(ctx, userID, filter)
	if err != nil {
		h.logger.Error().Err(err).Msg("Failed to get novels catalog")
		writeJSONError(w, h.logger, http.StatusInternalServerError, "INTERNAL_ERROR", "Failed to fetch novels")
		return
	}

	novels := make([]NovelResponse, len(result.Novels))
	for i, n := range result.Novels {
		novels[i] = NovelResponse{
			ID:              n.ForgottenRealmsNovel.ID.String(),
			Number:          n.ForgottenRealmsNovel.Number,
			Title:           n.ForgottenRealmsNovel.Title,
			Author:          n.ForgottenRealmsNovel.Author,
			PublicationDate: n.ForgottenRealmsNovel.PublicationDate,
			BookType:        n.ForgottenRealmsNovel.BookType,
			IsOwned:         n.IsOwned,
			CreatedAt:       n.ForgottenRealmsNovel.CreatedAt,
			UpdatedAt:       n.ForgottenRealmsNovel.UpdatedAt,
		}
	}

	totalPages := (result.Total + limit - 1) / limit // Ceiling division

	writeJSON(w, h.logger, http.StatusOK, NovelPageResponse{
		Novels: novels,
		Pagination: PaginationResponse{
			Total:      result.Total,
			Page:       result.Page,
			Limit:      limit,
			TotalPages: totalPages,
		},
	})
}

// UpdateNovelPossession met à jour le statut de possession d'un roman
func (h *ForgottenRealmsNovelHandler) UpdateNovelPossession(w http.ResponseWriter, r *http.Request) {
	ctx := r.Context()

	// 1. Parse novel ID from URL param
	novelIDStr := chi.URLParam(r, "id")
	novelID, err := uuid.Parse(novelIDStr)
	if err != nil {
		writeJSONError(w, h.logger, http.StatusBadRequest, "INVALID_NOVEL_ID", "Invalid novel ID format")
		return
	}

	// 2. Parse request body
	var req UpdateNovelPossessionRequest
	if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
		writeJSONError(w, h.logger, http.StatusBadRequest, "INVALID_BODY", "Invalid request body")
		return
	}

	// 3. Extract userID from context (injected by auth middleware)
	userID, err := middleware.GetUserID(ctx)
	if err != nil {
		h.logger.Error().Err(err).Msg("Failed to get user ID from context")
		writeJSONError(w, h.logger, http.StatusUnauthorized, "UNAUTHORIZED", "User not authenticated")
		return
	}

	// 4. Call service
	result, err := h.service.ToggleNovelPossession(ctx, userID, novelID, req.IsOwned)
	if err != nil {
		h.logger.Error().Err(err).Str("novel_id", novelID.String()).Bool("is_owned", req.IsOwned).Msg("Failed to toggle novel possession")

		// Vérifier si c'est une erreur "roman non trouvé"
		errMsg := err.Error()
		if errMsg == "novel not found: sql: no rows in result set" ||
			errMsg == "sql: no rows in result set" ||
			strings.Contains(errMsg, "no rows in result set") {
			writeJSONError(w, h.logger, http.StatusNotFound, "NOVEL_NOT_FOUND", "Novel not found")
			return
		}

		writeJSONError(w, h.logger, http.StatusInternalServerError, "INTERNAL_ERROR", "Failed to update novel possession")
		return
	}

	// 5. Return response
	response := NovelResponse{
		ID:              result.ForgottenRealmsNovel.ID.String(),
		Number:          result.ForgottenRealmsNovel.Number,
		Title:           result.ForgottenRealmsNovel.Title,
		Author:          result.ForgottenRealmsNovel.Author,
		PublicationDate: result.ForgottenRealmsNovel.PublicationDate,
		BookType:        result.ForgottenRealmsNovel.BookType,
		IsOwned:         result.IsOwned,
		CreatedAt:       result.ForgottenRealmsNovel.CreatedAt,
		UpdatedAt:       result.ForgottenRealmsNovel.UpdatedAt,
	}

	h.logger.Info().Str("novel_id", novelID.String()).Bool("is_owned", req.IsOwned).Msg("Novel possession updated successfully")
	writeJSON(w, h.logger, http.StatusOK, response)
}
