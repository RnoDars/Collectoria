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

type BookServiceInterface interface {
	GetBooksCatalog(ctx context.Context, userID uuid.UUID, filter domain.BookFilter) (*domain.BookPage, error)
	ToggleBookPossession(ctx context.Context, userID, bookID uuid.UUID, isOwned bool) (*domain.BookWithOwnership, error)
}

type BookHandler struct {
	service BookServiceInterface
	logger  zerolog.Logger
}

func NewBookHandler(service BookServiceInterface, logger zerolog.Logger) *BookHandler {
	return &BookHandler{service: service, logger: logger}
}

type BookResponse struct {
	ID              string    `json:"id"`
	CollectionID    string    `json:"collection_id"`
	Number          string    `json:"number"`
	Title           string    `json:"title"`
	Author          string    `json:"author"`
	PublicationDate time.Time `json:"publication_date"`
	BookType        string    `json:"book_type"`
	IsOwned         bool      `json:"is_owned"`
	CreatedAt       time.Time `json:"created_at"`
	UpdatedAt       time.Time `json:"updated_at"`
}

type BookPageResponse struct {
	Books      []BookResponse     `json:"books"`
	Pagination PaginationResponse `json:"pagination"`
}

type PaginationResponse struct {
	Total      int `json:"total"`
	Page       int `json:"page"`
	Limit      int `json:"limit"`
	TotalPages int `json:"total_pages"`
}

type UpdateBookPossessionRequest struct {
	IsOwned bool `json:"is_owned"`
}

// GetBooks récupère le catalogue de livres avec filtres et pagination
func (h *BookHandler) GetBooks(w http.ResponseWriter, r *http.Request) {
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
		if bookType != "roman" && bookType != "recueil de romans" {
			writeJSONError(w, h.logger, http.StatusBadRequest, "INVALID_PARAM", "Invalid book_type parameter (must be 'roman' or 'recueil de romans')")
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

	filter := domain.BookFilter{
		Search:   search,
		Author:   author,
		BookType: bookType,
		Series:   series,
		IsOwned:  isOwned,
		Page:     page,
		Limit:    limit,
	}

	result, err := h.service.GetBooksCatalog(ctx, userID, filter)
	if err != nil {
		h.logger.Error().Err(err).Msg("Failed to get books catalog")
		writeJSONError(w, h.logger, http.StatusInternalServerError, "INTERNAL_ERROR", "Failed to fetch books")
		return
	}

	books := make([]BookResponse, len(result.Books))
	for i, b := range result.Books {
		books[i] = BookResponse{
			ID:              b.Book.ID.String(),
			CollectionID:    b.Book.CollectionID.String(),
			Number:          b.Book.Number,
			Title:           b.Book.Title,
			Author:          b.Book.Author,
			PublicationDate: b.Book.PublicationDate,
			BookType:        b.Book.BookType,
			IsOwned:         b.IsOwned,
			CreatedAt:       b.Book.CreatedAt,
			UpdatedAt:       b.Book.UpdatedAt,
		}
	}

	totalPages := (result.Total + limit - 1) / limit // Ceiling division

	writeJSON(w, h.logger, http.StatusOK, BookPageResponse{
		Books: books,
		Pagination: PaginationResponse{
			Total:      result.Total,
			Page:       result.Page,
			Limit:      limit,
			TotalPages: totalPages,
		},
	})
}

// UpdateBookPossession met à jour le statut de possession d'un livre
func (h *BookHandler) UpdateBookPossession(w http.ResponseWriter, r *http.Request) {
	ctx := r.Context()

	// 1. Parse book ID from URL param
	bookIDStr := chi.URLParam(r, "id")
	bookID, err := uuid.Parse(bookIDStr)
	if err != nil {
		writeJSONError(w, h.logger, http.StatusBadRequest, "INVALID_BOOK_ID", "Invalid book ID format")
		return
	}

	// 2. Parse request body
	var req UpdateBookPossessionRequest
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
	result, err := h.service.ToggleBookPossession(ctx, userID, bookID, req.IsOwned)
	if err != nil {
		h.logger.Error().Err(err).Str("book_id", bookID.String()).Bool("is_owned", req.IsOwned).Msg("Failed to toggle book possession")

		// Vérifier si c'est une erreur "livre non trouvé"
		errMsg := err.Error()
		if errMsg == "book not found: sql: no rows in result set" ||
			errMsg == "sql: no rows in result set" ||
			strings.Contains(errMsg, "no rows in result set") {
			writeJSONError(w, h.logger, http.StatusNotFound, "BOOK_NOT_FOUND", "Book not found")
			return
		}

		writeJSONError(w, h.logger, http.StatusInternalServerError, "INTERNAL_ERROR", "Failed to update book possession")
		return
	}

	// 5. Return response
	response := BookResponse{
		ID:              result.Book.ID.String(),
		CollectionID:    result.Book.CollectionID.String(),
		Number:          result.Book.Number,
		Title:           result.Book.Title,
		Author:          result.Book.Author,
		PublicationDate: result.Book.PublicationDate,
		BookType:        result.Book.BookType,
		IsOwned:         result.IsOwned,
		CreatedAt:       result.Book.CreatedAt,
		UpdatedAt:       result.Book.UpdatedAt,
	}

	h.logger.Info().Str("book_id", bookID.String()).Bool("is_owned", req.IsOwned).Msg("Book possession updated successfully")
	writeJSON(w, h.logger, http.StatusOK, response)
}
