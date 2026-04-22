package middleware

import (
	"net/http"
	"strings"

	"collectoria/collection-management/internal/infrastructure/auth"
	"github.com/rs/zerolog"
)

// AuthMiddleware gère l'authentification JWT
type AuthMiddleware struct {
	jwtService *auth.JWTService
	logger     zerolog.Logger
}

// NewAuthMiddleware crée une nouvelle instance de AuthMiddleware
func NewAuthMiddleware(jwtService *auth.JWTService, logger zerolog.Logger) *AuthMiddleware {
	return &AuthMiddleware{
		jwtService: jwtService,
		logger:     logger,
	}
}

// Authenticate vérifie la présence et la validité du token JWT
func (m *AuthMiddleware) Authenticate(next http.Handler) http.Handler {
	return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		// Extract token from Authorization header
		authHeader := r.Header.Get("Authorization")
		if authHeader == "" {
			m.logger.Warn().Msg("Missing Authorization header")
			w.Header().Set("Content-Type", "application/json")
			w.WriteHeader(http.StatusUnauthorized)
			w.Write([]byte(`{"error":{"code":"UNAUTHORIZED","message":"Missing authorization header"}}`))
			return
		}

		// Check Bearer format
		parts := strings.Split(authHeader, " ")
		if len(parts) != 2 || parts[0] != "Bearer" {
			m.logger.Warn().Msg("Invalid Authorization header format")
			w.Header().Set("Content-Type", "application/json")
			w.WriteHeader(http.StatusUnauthorized)
			w.Write([]byte(`{"error":{"code":"UNAUTHORIZED","message":"Invalid authorization format"}}`))
			return
		}

		tokenString := parts[1]

		// Validate token
		claims, err := m.jwtService.ValidateToken(tokenString)
		if err != nil {
			m.logger.Warn().Err(err).Msg("Invalid JWT token")
			w.Header().Set("Content-Type", "application/json")
			w.WriteHeader(http.StatusUnauthorized)
			w.Write([]byte(`{"error":{"code":"UNAUTHORIZED","message":"Invalid or expired token"}}`))
			return
		}

		// Add userID to context
		ctx := WithUserID(r.Context(), claims.UserID)
		next.ServeHTTP(w, r.WithContext(ctx))
	})
}
