package auth_test

import (
	"testing"
	"time"

	"collectoria/collection-management/internal/infrastructure/auth"
	"github.com/golang-jwt/jwt/v5"
	"github.com/google/uuid"
	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/require"
)

func TestJWTService_GenerateToken_Success(t *testing.T) {
	// Arrange
	secret := "test-secret-at-least-32-chars-long-for-security"
	issuer := "test-issuer"
	expirationHours := 24
	service := auth.NewJWTService(secret, issuer, expirationHours)

	userID := uuid.New()
	email := "test@example.com"

	// Act
	token, err := service.GenerateToken(userID, email)

	// Assert
	require.NoError(t, err)
	assert.NotEmpty(t, token)
}

func TestJWTService_ValidateToken_ValidToken(t *testing.T) {
	// Arrange
	secret := "test-secret-at-least-32-chars-long-for-security"
	issuer := "test-issuer"
	expirationHours := 24
	service := auth.NewJWTService(secret, issuer, expirationHours)

	userID := uuid.New()
	email := "test@example.com"

	token, err := service.GenerateToken(userID, email)
	require.NoError(t, err)

	// Act
	claims, err := service.ValidateToken(token)

	// Assert
	require.NoError(t, err)
	assert.Equal(t, userID, claims.UserID)
	assert.Equal(t, email, claims.Email)
	assert.Equal(t, issuer, claims.Issuer)
}

func TestJWTService_ValidateToken_InvalidToken(t *testing.T) {
	// Arrange
	secret := "test-secret-at-least-32-chars-long-for-security"
	issuer := "test-issuer"
	expirationHours := 24
	service := auth.NewJWTService(secret, issuer, expirationHours)

	invalidToken := "invalid.token.here"

	// Act
	claims, err := service.ValidateToken(invalidToken)

	// Assert
	assert.Error(t, err)
	assert.Nil(t, claims)
}

func TestJWTService_ValidateToken_ExpiredToken(t *testing.T) {
	// Arrange
	secret := "test-secret-at-least-32-chars-long-for-security"
	issuer := "test-issuer"
	expirationHours := -1 // Token already expired
	service := auth.NewJWTService(secret, issuer, expirationHours)

	userID := uuid.New()
	email := "test@example.com"

	token, err := service.GenerateToken(userID, email)
	require.NoError(t, err)

	// Act
	claims, err := service.ValidateToken(token)

	// Assert
	assert.Error(t, err)
	assert.Nil(t, claims)
	assert.Contains(t, err.Error(), "token is expired")
}

func TestJWTService_ValidateToken_WrongSignature(t *testing.T) {
	// Arrange
	secret1 := "test-secret-at-least-32-chars-long-for-security"
	secret2 := "different-secret-at-least-32-chars-long-here"
	issuer := "test-issuer"
	expirationHours := 24

	service1 := auth.NewJWTService(secret1, issuer, expirationHours)
	service2 := auth.NewJWTService(secret2, issuer, expirationHours)

	userID := uuid.New()
	email := "test@example.com"

	// Generate token with service1
	token, err := service1.GenerateToken(userID, email)
	require.NoError(t, err)

	// Act - Try to validate with service2 (different secret)
	claims, err := service2.ValidateToken(token)

	// Assert
	assert.Error(t, err)
	assert.Nil(t, claims)
}

func TestJWTService_ValidateToken_ClaimsExtraction(t *testing.T) {
	// Arrange
	secret := "test-secret-at-least-32-chars-long-for-security"
	issuer := "test-issuer"
	expirationHours := 24
	service := auth.NewJWTService(secret, issuer, expirationHours)

	userID := uuid.New()
	email := "test@example.com"

	token, err := service.GenerateToken(userID, email)
	require.NoError(t, err)

	// Act
	claims, err := service.ValidateToken(token)

	// Assert
	require.NoError(t, err)
	assert.NotNil(t, claims)

	// Verify all claims
	assert.Equal(t, userID, claims.UserID)
	assert.Equal(t, email, claims.Email)
	assert.Equal(t, issuer, claims.Issuer)

	// Verify timestamps
	assert.NotNil(t, claims.IssuedAt)
	assert.NotNil(t, claims.ExpiresAt)

	// Verify expiration is roughly expirationHours in the future
	expectedExpiration := time.Now().Add(time.Duration(expirationHours) * time.Hour)
	actualExpiration := claims.ExpiresAt.Time
	diff := actualExpiration.Sub(expectedExpiration)
	assert.Less(t, diff, 5*time.Second) // Allow 5 seconds tolerance
}

func TestJWTService_ValidateToken_MalformedToken(t *testing.T) {
	// Arrange
	secret := "test-secret-at-least-32-chars-long-for-security"
	issuer := "test-issuer"
	expirationHours := 24
	service := auth.NewJWTService(secret, issuer, expirationHours)

	testCases := []struct {
		name  string
		token string
	}{
		{"empty string", ""},
		{"random string", "random-string"},
		{"incomplete jwt", "header.payload"},
		{"invalid base64", "invalid!@#$.payload!@#$.signature!@#$"},
	}

	for _, tc := range testCases {
		t.Run(tc.name, func(t *testing.T) {
			// Act
			claims, err := service.ValidateToken(tc.token)

			// Assert
			assert.Error(t, err)
			assert.Nil(t, claims)
		})
	}
}

func TestJWTService_ValidateToken_WrongAlgorithm(t *testing.T) {
	// Arrange
	secret := "test-secret-at-least-32-chars-long-for-security"
	issuer := "test-issuer"
	expirationHours := 24
	service := auth.NewJWTService(secret, issuer, expirationHours)

	userID := uuid.New()
	email := "test@example.com"

	// Create a token with RSA algorithm (not HMAC)
	// Generate a simple RSA token manually (will fail signature verification)
	claims := auth.Claims{
		UserID: userID,
		Email:  email,
		RegisteredClaims: jwt.RegisteredClaims{
			ExpiresAt: jwt.NewNumericDate(time.Now().Add(time.Duration(expirationHours) * time.Hour)),
			IssuedAt:  jwt.NewNumericDate(time.Now()),
			Issuer:    issuer,
		},
	}

	// Use a different algorithm family (RS256 - RSA instead of HS256 - HMAC)
	token := jwt.NewWithClaims(jwt.SigningMethodNone, claims)
	tokenString, err := token.SignedString(jwt.UnsafeAllowNoneSignatureType)
	require.NoError(t, err)

	// Act
	validatedClaims, err := service.ValidateToken(tokenString)

	// Assert
	assert.Error(t, err)
	assert.Nil(t, validatedClaims)
}
