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

type DnD5BookServiceInterface interface {
	GetBooksCatalog(ctx context.Context, userID uuid.UUID, filter domain.DnD5BookFilter) (*domain.DnD5BookPage, error)
	UpdateBookOwnership(ctx context.Context, userID, bookID uuid.UUID, ownedEn, ownedFr *bool) (*domain.DnD5BookWithOwnership, error)
}

type DnD5BookHandler struct {
	service DnD5BookServiceInterface
	logger  zerolog.Logger
}

func NewDnD5BookHandler(service DnD5BookServiceInterface, logger zerolog.Logger) *DnD5BookHandler {
	return &DnD5BookHandler{service: service, logger: logger}
}

type DnD5BookResponse struct {
	ID        string    `json:"id"`
	Number    string    `json:"number"`
	NameEn    string    `json:"name_en"`
	NameFr    *string   `json:"name_fr"`
	BookType  string    `json:"book_type"`
	OwnedEn   *bool     `json:"owned_en"`
	OwnedFr   *bool     `json:"owned_fr"`
	CreatedAt time.Time `json:"created_at"`
	UpdatedAt time.Time `json:"updated_at"`
}

type DnD5BookPageResponse struct {
	Books      []DnD5BookResponse `json:"books"`
	Pagination PaginationResponse `json:"pagination"`
}

type UpdateDnD5BookOwnershipRequest struct {
	OwnedEn *bool `json:"owned_en,omitempty"`
	OwnedFr *bool `json:"owned_fr,omitempty"`
}

// GetBooks récupère le catalogue de livres D&D 5e avec filtres et pagination
func (h *DnD5BookHandler) GetBooks(w http.ResponseWriter, r *http.Request) {
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

	bookType := q.Get("book_type")
	if bookType != "" {
		if err := validators.ValidateStringParam(bookType, 100); err != nil {
			writeJSONError(w, h.logger, http.StatusBadRequest, "INVALID_PARAM", err.Error())
			return
		}
	}

	// Parse owned_version parameter (en, fr, both, none, any)
	ownedVersion := q.Get("owned_version")
	if ownedVersion != "" {
		validVersions := map[string]bool{"en": true, "fr": true, "both": true, "none": true, "any": true}
		if !validVersions[ownedVersion] {
			writeJSONError(w, h.logger, http.StatusBadRequest, "INVALID_PARAM", "Invalid owned_version parameter (must be 'en', 'fr', 'both', 'none', or 'any')")
			return
		}
	}

	// Parse sort_by parameter (name_en, name_fr, number)
	sortBy := q.Get("sort_by")
	if sortBy != "" {
		validSorts := map[string]bool{"name_en": true, "name_fr": true, "number": true}
		if !validSorts[sortBy] {
			writeJSONError(w, h.logger, http.StatusBadRequest, "INVALID_PARAM", "Invalid sort_by parameter (must be 'name_en', 'name_fr', or 'number')")
			return
		}
	} else {
		sortBy = "name_en" // Default sort
	}

	filter := domain.DnD5BookFilter{
		Search:       search,
		BookType:     bookType,
		OwnedVersion: ownedVersion,
		SortBy:       sortBy,
		Page:         page,
		Limit:        limit,
	}

	result, err := h.service.GetBooksCatalog(ctx, userID, filter)
	if err != nil {
		h.logger.Error().Err(err).Msg("Failed to get D&D 5e books catalog")
		writeJSONError(w, h.logger, http.StatusInternalServerError, "INTERNAL_ERROR", "Failed to fetch books")
		return
	}

	books := make([]DnD5BookResponse, len(result.Books))
	for i, b := range result.Books {
		books[i] = DnD5BookResponse{
			ID:        b.DnD5Book.ID.String(),
			Number:    b.DnD5Book.Number,
			NameEn:    b.DnD5Book.NameEn,
			NameFr:    b.DnD5Book.NameFr,
			BookType:  b.DnD5Book.BookType,
			OwnedEn:   b.OwnedEn,
			OwnedFr:   b.OwnedFr,
			CreatedAt: b.DnD5Book.CreatedAt,
			UpdatedAt: b.DnD5Book.UpdatedAt,
		}
	}

	totalPages := (result.Total + limit - 1) / limit // Ceiling division

	writeJSON(w, h.logger, http.StatusOK, DnD5BookPageResponse{
		Books: books,
		Pagination: PaginationResponse{
			Total:      result.Total,
			Page:       result.Page,
			Limit:      limit,
			TotalPages: totalPages,
		},
	})
}

// UpdateBookOwnership met à jour le statut de possession d'un livre D&D 5e
func (h *DnD5BookHandler) UpdateBookOwnership(w http.ResponseWriter, r *http.Request) {
	ctx := r.Context()

	// 1. Parse book ID from URL param
	bookIDStr := chi.URLParam(r, "id")
	bookID, err := uuid.Parse(bookIDStr)
	if err != nil {
		writeJSONError(w, h.logger, http.StatusBadRequest, "INVALID_BOOK_ID", "Invalid book ID format")
		return
	}

	// 2. Parse request body
	var req UpdateDnD5BookOwnershipRequest
	if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
		writeJSONError(w, h.logger, http.StatusBadRequest, "INVALID_BODY", "Invalid request body")
		return
	}

	// 3. Valider que le body n'est pas vide
	if req.OwnedEn == nil && req.OwnedFr == nil {
		writeJSONError(w, h.logger, http.StatusBadRequest, "INVALID_BODY", "At least one ownership field must be provided (owned_en or owned_fr)")
		return
	}

	// 4. Extract userID from context (injected by auth middleware)
	userID, err := middleware.GetUserID(ctx)
	if err != nil {
		h.logger.Error().Err(err).Msg("Failed to get user ID from context")
		writeJSONError(w, h.logger, http.StatusUnauthorized, "UNAUTHORIZED", "User not authenticated")
		return
	}

	// 5. Call service
	result, err := h.service.UpdateBookOwnership(ctx, userID, bookID, req.OwnedEn, req.OwnedFr)
	if err != nil {
		h.logger.Error().Err(err).Str("book_id", bookID.String()).Msg("Failed to update book ownership")

		// Vérifier si c'est une erreur "livre non trouvé"
		errMsg := err.Error()
		if errMsg == "book not found: sql: no rows in result set" ||
			errMsg == "sql: no rows in result set" ||
			strings.Contains(errMsg, "no rows in result set") {
			writeJSONError(w, h.logger, http.StatusNotFound, "BOOK_NOT_FOUND", "Book not found")
			return
		}

		// Vérifier si c'est une erreur de validation
		if strings.Contains(errMsg, "required") {
			writeJSONError(w, h.logger, http.StatusBadRequest, "INVALID_OWNERSHIP", errMsg)
			return
		}

		writeJSONError(w, h.logger, http.StatusInternalServerError, "INTERNAL_ERROR", "Failed to update book ownership")
		return
	}

	// 6. Return response
	response := DnD5BookResponse{
		ID:        result.DnD5Book.ID.String(),
		Number:    result.DnD5Book.Number,
		NameEn:    result.DnD5Book.NameEn,
		NameFr:    result.DnD5Book.NameFr,
		BookType:  result.DnD5Book.BookType,
		OwnedEn:   result.OwnedEn,
		OwnedFr:   result.OwnedFr,
		CreatedAt: result.DnD5Book.CreatedAt,
		UpdatedAt: result.DnD5Book.UpdatedAt,
	}

	h.logger.Info().Str("book_id", bookID.String()).Interface("owned_en", req.OwnedEn).Interface("owned_fr", req.OwnedFr).Msg("Book ownership updated successfully")
	writeJSON(w, h.logger, http.StatusOK, response)
}
