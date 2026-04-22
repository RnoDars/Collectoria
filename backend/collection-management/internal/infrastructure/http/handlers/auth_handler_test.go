package handlers_test

import (
	"bytes"
	"encoding/json"
	"net/http"
	"net/http/httptest"
	"testing"
	"time"

	"collectoria/collection-management/internal/infrastructure/auth"
	"collectoria/collection-management/internal/infrastructure/http/handlers"
	"github.com/rs/zerolog"
	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/require"
)

func TestAuthHandler_Login_Success(t *testing.T) {
	// Arrange
	secret := "test-secret-at-least-32-chars-long-for-security"
	issuer := "test-issuer"
	expirationHours := 24
	jwtService := auth.NewJWTService(secret, issuer, expirationHours)
	logger := zerolog.Nop()
	authHandler := handlers.NewAuthHandler(jwtService, logger)

	requestBody := handlers.LoginRequest{
		Email:    "test@example.com",
		Password: "password123",
	}
	bodyBytes, err := json.Marshal(requestBody)
	require.NoError(t, err)

	req := httptest.NewRequest(http.MethodPost, "/auth/login", bytes.NewReader(bodyBytes))
	req.Header.Set("Content-Type", "application/json")
	rec := httptest.NewRecorder()

	// Act
	authHandler.Login(rec, req)

	// Assert
	assert.Equal(t, http.StatusOK, rec.Code)

	var response handlers.LoginResponse
	err = json.Unmarshal(rec.Body.Bytes(), &response)
	require.NoError(t, err)

	assert.NotEmpty(t, response.Token)
	assert.NotZero(t, response.ExpiresAt)

	// Verify token is valid
	claims, err := jwtService.ValidateToken(response.Token)
	require.NoError(t, err)
	assert.Equal(t, "test@example.com", claims.Email)

	// Verify expiration time
	expiresAt, err := time.Parse(time.RFC3339, response.ExpiresAt)
	require.NoError(t, err)
	expectedExpiration := time.Now().Add(time.Duration(expirationHours) * time.Hour)
	diff := expiresAt.Sub(expectedExpiration)
	assert.Less(t, diff, 5*time.Second) // Allow 5 seconds tolerance
}

func TestAuthHandler_Login_InvalidJSON(t *testing.T) {
	// Arrange
	secret := "test-secret-at-least-32-chars-long-for-security"
	issuer := "test-issuer"
	jwtService := auth.NewJWTService(secret, issuer, 24)
	logger := zerolog.Nop()
	authHandler := handlers.NewAuthHandler(jwtService, logger)

	req := httptest.NewRequest(http.MethodPost, "/auth/login", bytes.NewReader([]byte("invalid json")))
	req.Header.Set("Content-Type", "application/json")
	rec := httptest.NewRecorder()

	// Act
	authHandler.Login(rec, req)

	// Assert
	assert.Equal(t, http.StatusBadRequest, rec.Code)

	var response map[string]interface{}
	err := json.Unmarshal(rec.Body.Bytes(), &response)
	require.NoError(t, err)

	errorData := response["error"].(map[string]interface{})
	assert.Equal(t, "INVALID_REQUEST", errorData["code"])
	assert.Contains(t, errorData["message"], "Invalid request body")
}

func TestAuthHandler_Login_MissingEmail(t *testing.T) {
	// Arrange
	secret := "test-secret-at-least-32-chars-long-for-security"
	issuer := "test-issuer"
	jwtService := auth.NewJWTService(secret, issuer, 24)
	logger := zerolog.Nop()
	authHandler := handlers.NewAuthHandler(jwtService, logger)

	requestBody := handlers.LoginRequest{
		Email:    "",
		Password: "password123",
	}
	bodyBytes, err := json.Marshal(requestBody)
	require.NoError(t, err)

	req := httptest.NewRequest(http.MethodPost, "/auth/login", bytes.NewReader(bodyBytes))
	req.Header.Set("Content-Type", "application/json")
	rec := httptest.NewRecorder()

	// Act
	authHandler.Login(rec, req)

	// Assert
	assert.Equal(t, http.StatusBadRequest, rec.Code)

	var response map[string]interface{}
	err = json.Unmarshal(rec.Body.Bytes(), &response)
	require.NoError(t, err)

	errorData := response["error"].(map[string]interface{})
	assert.Equal(t, "INVALID_REQUEST", errorData["code"])
	assert.Contains(t, errorData["message"], "Email and password are required")
}

func TestAuthHandler_Login_MissingPassword(t *testing.T) {
	// Arrange
	secret := "test-secret-at-least-32-chars-long-for-security"
	issuer := "test-issuer"
	jwtService := auth.NewJWTService(secret, issuer, 24)
	logger := zerolog.Nop()
	authHandler := handlers.NewAuthHandler(jwtService, logger)

	requestBody := handlers.LoginRequest{
		Email:    "test@example.com",
		Password: "",
	}
	bodyBytes, err := json.Marshal(requestBody)
	require.NoError(t, err)

	req := httptest.NewRequest(http.MethodPost, "/auth/login", bytes.NewReader(bodyBytes))
	req.Header.Set("Content-Type", "application/json")
	rec := httptest.NewRecorder()

	// Act
	authHandler.Login(rec, req)

	// Assert
	assert.Equal(t, http.StatusBadRequest, rec.Code)

	var response map[string]interface{}
	err = json.Unmarshal(rec.Body.Bytes(), &response)
	require.NoError(t, err)

	errorData := response["error"].(map[string]interface{})
	assert.Equal(t, "INVALID_REQUEST", errorData["code"])
	assert.Contains(t, errorData["message"], "Email and password are required")
}

func TestAuthHandler_Login_MultipleRequests(t *testing.T) {
	// Arrange
	secret := "test-secret-at-least-32-chars-long-for-security"
	issuer := "test-issuer"
	jwtService := auth.NewJWTService(secret, issuer, 24)
	logger := zerolog.Nop()
	authHandler := handlers.NewAuthHandler(jwtService, logger)

	// Test that multiple login requests generate different tokens with different userIDs
	tokens := make(map[string]bool)

	for i := 0; i < 3; i++ {
		requestBody := handlers.LoginRequest{
			Email:    "test@example.com",
			Password: "password123",
		}
		bodyBytes, err := json.Marshal(requestBody)
		require.NoError(t, err)

		req := httptest.NewRequest(http.MethodPost, "/auth/login", bytes.NewReader(bodyBytes))
		req.Header.Set("Content-Type", "application/json")
		rec := httptest.NewRecorder()

		// Act
		authHandler.Login(rec, req)

		// Assert
		assert.Equal(t, http.StatusOK, rec.Code)

		var response handlers.LoginResponse
		err = json.Unmarshal(rec.Body.Bytes(), &response)
		require.NoError(t, err)

		// Verify token is unique
		assert.NotContains(t, tokens, response.Token)
		tokens[response.Token] = true
	}

	// All 3 tokens should be different
	assert.Equal(t, 3, len(tokens))
}
