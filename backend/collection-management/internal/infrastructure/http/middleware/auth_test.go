package middleware_test

import (
	"context"
	"encoding/json"
	"net/http"
	"net/http/httptest"
	"testing"

	"collectoria/collection-management/internal/infrastructure/auth"
	"collectoria/collection-management/internal/infrastructure/http/middleware"
	"github.com/google/uuid"
	"github.com/rs/zerolog"
	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/require"
)

func TestAuthMiddleware_Authenticate_Success(t *testing.T) {
	// Arrange
	secret := "test-secret-at-least-32-chars-long-for-security"
	issuer := "test-issuer"
	jwtService := auth.NewJWTService(secret, issuer, 24)
	logger := zerolog.Nop()
	authMiddleware := middleware.NewAuthMiddleware(jwtService, logger)

	userID := uuid.New()
	email := "test@example.com"
	token, err := jwtService.GenerateToken(userID, email)
	require.NoError(t, err)

	// Create a test handler that checks if userID is in context
	handlerCalled := false
	var extractedUserID uuid.UUID
	testHandler := http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		handlerCalled = true
		var err error
		extractedUserID, err = middleware.GetUserID(r.Context())
		require.NoError(t, err)
		w.WriteHeader(http.StatusOK)
		w.Write([]byte(`{"success": true}`))
	})

	// Wrap with auth middleware
	handler := authMiddleware.Authenticate(testHandler)

	// Create request with valid token
	req := httptest.NewRequest(http.MethodGet, "/test", nil)
	req.Header.Set("Authorization", "Bearer "+token)
	rec := httptest.NewRecorder()

	// Act
	handler.ServeHTTP(rec, req)

	// Assert
	assert.Equal(t, http.StatusOK, rec.Code)
	assert.True(t, handlerCalled)
	assert.Equal(t, userID, extractedUserID)
}

func TestAuthMiddleware_Authenticate_MissingAuthorizationHeader(t *testing.T) {
	// Arrange
	secret := "test-secret-at-least-32-chars-long-for-security"
	issuer := "test-issuer"
	jwtService := auth.NewJWTService(secret, issuer, 24)
	logger := zerolog.Nop()
	authMiddleware := middleware.NewAuthMiddleware(jwtService, logger)

	handlerCalled := false
	testHandler := http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		handlerCalled = true
	})

	handler := authMiddleware.Authenticate(testHandler)

	req := httptest.NewRequest(http.MethodGet, "/test", nil)
	// No Authorization header set
	rec := httptest.NewRecorder()

	// Act
	handler.ServeHTTP(rec, req)

	// Assert
	assert.Equal(t, http.StatusUnauthorized, rec.Code)
	assert.False(t, handlerCalled)

	var response map[string]interface{}
	err := json.Unmarshal(rec.Body.Bytes(), &response)
	require.NoError(t, err)

	errorData := response["error"].(map[string]interface{})
	assert.Equal(t, "UNAUTHORIZED", errorData["code"])
	assert.Contains(t, errorData["message"], "Missing authorization header")
}

func TestAuthMiddleware_Authenticate_InvalidAuthorizationFormat(t *testing.T) {
	// Arrange
	secret := "test-secret-at-least-32-chars-long-for-security"
	issuer := "test-issuer"
	jwtService := auth.NewJWTService(secret, issuer, 24)
	logger := zerolog.Nop()
	authMiddleware := middleware.NewAuthMiddleware(jwtService, logger)

	handlerCalled := false
	testHandler := http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		handlerCalled = true
	})

	handler := authMiddleware.Authenticate(testHandler)

	testCases := []struct {
		name              string
		authorizationValue string
	}{
		{"missing Bearer prefix", "token-without-bearer"},
		{"only Bearer", "Bearer"},
		{"wrong prefix", "Basic token"},
		{"multiple spaces", "Bearer  token  extra"},
	}

	for _, tc := range testCases {
		t.Run(tc.name, func(t *testing.T) {
			req := httptest.NewRequest(http.MethodGet, "/test", nil)
			req.Header.Set("Authorization", tc.authorizationValue)
			rec := httptest.NewRecorder()

			// Act
			handler.ServeHTTP(rec, req)

			// Assert
			assert.Equal(t, http.StatusUnauthorized, rec.Code)
			assert.False(t, handlerCalled)

			var response map[string]interface{}
			err := json.Unmarshal(rec.Body.Bytes(), &response)
			require.NoError(t, err)

			errorData := response["error"].(map[string]interface{})
			assert.Equal(t, "UNAUTHORIZED", errorData["code"])
		})
	}
}

func TestAuthMiddleware_Authenticate_InvalidToken(t *testing.T) {
	// Arrange
	secret := "test-secret-at-least-32-chars-long-for-security"
	issuer := "test-issuer"
	jwtService := auth.NewJWTService(secret, issuer, 24)
	logger := zerolog.Nop()
	authMiddleware := middleware.NewAuthMiddleware(jwtService, logger)

	handlerCalled := false
	testHandler := http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		handlerCalled = true
	})

	handler := authMiddleware.Authenticate(testHandler)

	req := httptest.NewRequest(http.MethodGet, "/test", nil)
	req.Header.Set("Authorization", "Bearer invalid.token.here")
	rec := httptest.NewRecorder()

	// Act
	handler.ServeHTTP(rec, req)

	// Assert
	assert.Equal(t, http.StatusUnauthorized, rec.Code)
	assert.False(t, handlerCalled)

	var response map[string]interface{}
	err := json.Unmarshal(rec.Body.Bytes(), &response)
	require.NoError(t, err)

	errorData := response["error"].(map[string]interface{})
	assert.Equal(t, "UNAUTHORIZED", errorData["code"])
	assert.Contains(t, errorData["message"], "Invalid or expired token")
}

func TestAuthMiddleware_Authenticate_ExpiredToken(t *testing.T) {
	// Arrange
	secret := "test-secret-at-least-32-chars-long-for-security"
	issuer := "test-issuer"
	// Create service with -1 hour expiration to create an already expired token
	jwtService := auth.NewJWTService(secret, issuer, -1)
	logger := zerolog.Nop()
	authMiddleware := middleware.NewAuthMiddleware(jwtService, logger)

	userID := uuid.New()
	email := "test@example.com"
	token, err := jwtService.GenerateToken(userID, email)
	require.NoError(t, err)

	handlerCalled := false
	testHandler := http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		handlerCalled = true
	})

	handler := authMiddleware.Authenticate(testHandler)

	req := httptest.NewRequest(http.MethodGet, "/test", nil)
	req.Header.Set("Authorization", "Bearer "+token)
	rec := httptest.NewRecorder()

	// Act
	handler.ServeHTTP(rec, req)

	// Assert
	assert.Equal(t, http.StatusUnauthorized, rec.Code)
	assert.False(t, handlerCalled)

	var response map[string]interface{}
	err = json.Unmarshal(rec.Body.Bytes(), &response)
	require.NoError(t, err)

	errorData := response["error"].(map[string]interface{})
	assert.Equal(t, "UNAUTHORIZED", errorData["code"])
}

func TestAuthMiddleware_Authenticate_WrongSecret(t *testing.T) {
	// Arrange
	secret1 := "test-secret-at-least-32-chars-long-for-security"
	secret2 := "different-secret-at-least-32-chars-long-here"
	issuer := "test-issuer"

	// Generate token with secret1
	jwtService1 := auth.NewJWTService(secret1, issuer, 24)
	userID := uuid.New()
	email := "test@example.com"
	token, err := jwtService1.GenerateToken(userID, email)
	require.NoError(t, err)

	// Try to validate with secret2
	jwtService2 := auth.NewJWTService(secret2, issuer, 24)
	logger := zerolog.Nop()
	authMiddleware := middleware.NewAuthMiddleware(jwtService2, logger)

	handlerCalled := false
	testHandler := http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		handlerCalled = true
	})

	handler := authMiddleware.Authenticate(testHandler)

	req := httptest.NewRequest(http.MethodGet, "/test", nil)
	req.Header.Set("Authorization", "Bearer "+token)
	rec := httptest.NewRecorder()

	// Act
	handler.ServeHTTP(rec, req)

	// Assert
	assert.Equal(t, http.StatusUnauthorized, rec.Code)
	assert.False(t, handlerCalled)
}

func TestGetUserID_FromContext_Success(t *testing.T) {
	// Arrange
	userID := uuid.New()
	ctx := middleware.WithUserID(context.Background(), userID)

	// Act
	extractedUserID, err := middleware.GetUserID(ctx)

	// Assert
	require.NoError(t, err)
	assert.Equal(t, userID, extractedUserID)
}

func TestGetUserID_FromContext_NotFound(t *testing.T) {
	// Arrange
	ctx := context.Background()

	// Act
	extractedUserID, err := middleware.GetUserID(ctx)

	// Assert
	assert.Error(t, err)
	assert.Equal(t, uuid.Nil, extractedUserID)
	assert.Contains(t, err.Error(), "user_id not found in context")
}
