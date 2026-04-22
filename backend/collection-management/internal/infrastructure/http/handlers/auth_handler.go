package handlers

import (
	"encoding/json"
	"net/http"
	"time"

	"collectoria/collection-management/internal/infrastructure/auth"
	"github.com/google/uuid"
	"github.com/rs/zerolog"
)

// AuthHandler gère les endpoints d'authentification
type AuthHandler struct {
	jwtService *auth.JWTService
	logger     zerolog.Logger
}

// NewAuthHandler crée une nouvelle instance de AuthHandler
func NewAuthHandler(jwtService *auth.JWTService, logger zerolog.Logger) *AuthHandler {
	return &AuthHandler{
		jwtService: jwtService,
		logger:     logger,
	}
}

// LoginRequest représente la requête de login
type LoginRequest struct {
	Email    string `json:"email"`
	Password string `json:"password"`
}

// LoginResponse représente la réponse de login
type LoginResponse struct {
	Token     string `json:"token"`
	ExpiresAt string `json:"expires_at"`
}

// Login gère le endpoint POST /auth/login
// Pour le MVP, ce endpoint génère un token sans vérifier les credentials (mock authentication)
func (h *AuthHandler) Login(w http.ResponseWriter, r *http.Request) {
	// Parse request body
	var req LoginRequest
	if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
		h.logger.Warn().Err(err).Msg("Failed to decode login request")
		writeJSONError(w, h.logger, http.StatusBadRequest, "INVALID_REQUEST", "Invalid request body")
		return
	}

	// Validate request
	if req.Email == "" || req.Password == "" {
		h.logger.Warn().Msg("Missing email or password in login request")
		writeJSONError(w, h.logger, http.StatusBadRequest, "INVALID_REQUEST", "Email and password are required")
		return
	}

	// MVP: Simple hardcoded authentication
	// TODO: In production, validate credentials against user database with hashed passwords
	var userID uuid.UUID

	// Validate credentials
	if req.Email == "arnaud.dars@gmail.com" && req.Password == "flying38" {
		// Valid credentials - use existing userID with all the data
		userID = uuid.MustParse("00000000-0000-0000-0000-000000000001")
	} else {
		// Invalid credentials
		h.logger.Warn().
			Str("email", req.Email).
			Msg("Invalid credentials")
		writeJSONError(w, h.logger, http.StatusUnauthorized, "INVALID_CREDENTIALS", "Invalid email or password")
		return
	}

	h.logger.Info().
		Str("email", req.Email).
		Str("user_id", userID.String()).
		Msg("Login successful")

	// Generate JWT token
	token, err := h.jwtService.GenerateToken(userID, req.Email)
	if err != nil {
		h.logger.Error().Err(err).Msg("Failed to generate JWT token")
		writeJSONError(w, h.logger, http.StatusInternalServerError, "INTERNAL_ERROR", "Failed to generate authentication token")
		return
	}

	// Calculate expiration time
	// Note: This assumes the JWT service uses the same expiration configuration
	expiresAt := time.Now().Add(24 * time.Hour).Format(time.RFC3339)

	// Return response
	response := LoginResponse{
		Token:     token,
		ExpiresAt: expiresAt,
	}

	h.logger.Info().
		Str("user_id", userID.String()).
		Str("expires_at", expiresAt).
		Msg("Login successful, token generated")

	w.Header().Set("Content-Type", "application/json")
	w.WriteHeader(http.StatusOK)
	if err := json.NewEncoder(w).Encode(response); err != nil {
		h.logger.Error().Err(err).Msg("Failed to encode login response")
	}
}
