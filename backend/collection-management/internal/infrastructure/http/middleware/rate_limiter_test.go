package middleware

import (
	"net/http"
	"net/http/httptest"
	"testing"
	"time"

	"github.com/stretchr/testify/assert"
)

func TestRateLimiter_AllowsWithinLimit(t *testing.T) {
	// Arrange
	config := RateLimitConfig{
		Requests: 5,
		Window:   1 * time.Minute,
	}
	rateLimiter := NewRateLimiter(config)

	handler := rateLimiter(http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		w.WriteHeader(http.StatusOK)
		w.Write([]byte("OK"))
	}))

	// Act & Assert - 5 requêtes doivent passer
	for i := 0; i < 5; i++ {
		req := httptest.NewRequest("GET", "/test", nil)
		req.RemoteAddr = "192.168.1.1:12345"
		w := httptest.NewRecorder()

		handler.ServeHTTP(w, req)

		assert.Equal(t, http.StatusOK, w.Code, "Request %d should be allowed", i+1)
		assert.Equal(t, "OK", w.Body.String())

		// Vérifier headers
		assert.NotEmpty(t, w.Header().Get("X-RateLimit-Limit"))
		assert.NotEmpty(t, w.Header().Get("X-RateLimit-Remaining"))
		assert.NotEmpty(t, w.Header().Get("X-RateLimit-Reset"))
	}
}

func TestRateLimiter_Blocks429AfterLimit(t *testing.T) {
	// Arrange
	config := RateLimitConfig{
		Requests: 3,
		Window:   1 * time.Minute,
	}
	rateLimiter := NewRateLimiter(config)

	handler := rateLimiter(http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		w.WriteHeader(http.StatusOK)
		w.Write([]byte("OK"))
	}))

	// Act - Faire 3 requêtes (limite)
	for i := 0; i < 3; i++ {
		req := httptest.NewRequest("GET", "/test", nil)
		req.RemoteAddr = "192.168.1.100:12345"
		w := httptest.NewRecorder()

		handler.ServeHTTP(w, req)
		assert.Equal(t, http.StatusOK, w.Code)
	}

	// Act - 4ème requête doit être bloquée
	req := httptest.NewRequest("GET", "/test", nil)
	req.RemoteAddr = "192.168.1.100:12345"
	w := httptest.NewRecorder()

	handler.ServeHTTP(w, req)

	// Assert
	assert.Equal(t, http.StatusTooManyRequests, w.Code)
	assert.Contains(t, w.Body.String(), "Rate limit exceeded")

	// Vérifier header Retry-After présent
	assert.NotEmpty(t, w.Header().Get("Retry-After"))
	assert.NotEmpty(t, w.Header().Get("X-RateLimit-Limit"))
	assert.Equal(t, "0", w.Header().Get("X-RateLimit-Remaining"))
}

func TestRateLimiter_ResetsAfterWindow(t *testing.T) {
	// Arrange
	config := RateLimitConfig{
		Requests: 2,
		Window:   100 * time.Millisecond, // Fenêtre courte pour test
	}
	rateLimiter := NewRateLimiter(config)

	handler := rateLimiter(http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		w.WriteHeader(http.StatusOK)
	}))

	// Act - Consommer la limite (2 requêtes)
	for i := 0; i < 2; i++ {
		req := httptest.NewRequest("GET", "/test", nil)
		req.RemoteAddr = "192.168.1.200:12345"
		w := httptest.NewRecorder()

		handler.ServeHTTP(w, req)
		assert.Equal(t, http.StatusOK, w.Code)
	}

	// 3ème requête doit être bloquée
	req := httptest.NewRequest("GET", "/test", nil)
	req.RemoteAddr = "192.168.1.200:12345"
	w := httptest.NewRecorder()
	handler.ServeHTTP(w, req)
	assert.Equal(t, http.StatusTooManyRequests, w.Code)

	// Act - Attendre la fenêtre de reset
	time.Sleep(150 * time.Millisecond)

	// Nouvelle requête après reset doit passer
	req = httptest.NewRequest("GET", "/test", nil)
	req.RemoteAddr = "192.168.1.200:12345"
	w = httptest.NewRecorder()
	handler.ServeHTTP(w, req)

	// Assert
	assert.Equal(t, http.StatusOK, w.Code)
}

func TestRateLimiter_Headers(t *testing.T) {
	// Arrange
	config := RateLimitConfig{
		Requests: 10,
		Window:   1 * time.Minute,
	}
	rateLimiter := NewRateLimiter(config)

	handler := rateLimiter(http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		w.WriteHeader(http.StatusOK)
	}))

	// Act - Première requête
	req := httptest.NewRequest("GET", "/test", nil)
	req.RemoteAddr = "192.168.1.50:12345"
	w := httptest.NewRecorder()

	handler.ServeHTTP(w, req)

	// Assert - Vérifier tous les headers
	assert.Equal(t, "10", w.Header().Get("X-RateLimit-Limit"), "Limit header")
	assert.Equal(t, "9", w.Header().Get("X-RateLimit-Remaining"), "Remaining après 1 requête")
	assert.NotEmpty(t, w.Header().Get("X-RateLimit-Reset"), "Reset header")

	// Act - Deuxième requête
	req = httptest.NewRequest("GET", "/test", nil)
	req.RemoteAddr = "192.168.1.50:12345"
	w = httptest.NewRecorder()

	handler.ServeHTTP(w, req)

	// Assert
	assert.Equal(t, "8", w.Header().Get("X-RateLimit-Remaining"), "Remaining après 2 requêtes")
}

func TestRateLimiter_RetryAfter(t *testing.T) {
	// Arrange
	config := RateLimitConfig{
		Requests: 1,
		Window:   1 * time.Minute,
	}
	rateLimiter := NewRateLimiter(config)

	handler := rateLimiter(http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		w.WriteHeader(http.StatusOK)
	}))

	// Act - Consommer la limite
	req := httptest.NewRequest("GET", "/test", nil)
	req.RemoteAddr = "192.168.1.75:12345"
	w := httptest.NewRecorder()
	handler.ServeHTTP(w, req)
	assert.Equal(t, http.StatusOK, w.Code)

	// Act - Requête bloquée
	req = httptest.NewRequest("GET", "/test", nil)
	req.RemoteAddr = "192.168.1.75:12345"
	w = httptest.NewRecorder()
	handler.ServeHTTP(w, req)

	// Assert
	assert.Equal(t, http.StatusTooManyRequests, w.Code)

	retryAfter := w.Header().Get("Retry-After")
	assert.NotEmpty(t, retryAfter, "Retry-After header doit être présent")

	// Retry-After doit être un nombre de secondes positif
	seconds, err := time.ParseDuration(retryAfter + "s")
	assert.NoError(t, err)
	assert.True(t, seconds >= 0, "Retry-After doit être >= 0")
}

func TestGetClientIP_XForwardedFor(t *testing.T) {
	// Arrange
	req := httptest.NewRequest("GET", "/test", nil)
	req.Header.Set("X-Forwarded-For", "203.0.113.1, 198.51.100.1, 192.0.2.1")
	req.RemoteAddr = "192.168.1.1:12345"

	// Act
	ip := getClientIP(req)

	// Assert - Doit prendre la première IP
	assert.Equal(t, "203.0.113.1", ip)
}

func TestGetClientIP_XRealIP(t *testing.T) {
	// Arrange
	req := httptest.NewRequest("GET", "/test", nil)
	req.Header.Set("X-Real-IP", "203.0.113.50")
	req.RemoteAddr = "192.168.1.1:12345"

	// Act
	ip := getClientIP(req)

	// Assert
	assert.Equal(t, "203.0.113.50", ip)
}

func TestGetClientIP_RemoteAddr(t *testing.T) {
	// Arrange
	req := httptest.NewRequest("GET", "/test", nil)
	req.RemoteAddr = "192.168.1.100:54321"

	// Act
	ip := getClientIP(req)

	// Assert - Doit extraire l'IP sans le port
	assert.Equal(t, "192.168.1.100", ip)
}

func TestRateLimiter_DifferentIPsIndependent(t *testing.T) {
	// Arrange
	config := RateLimitConfig{
		Requests: 2,
		Window:   1 * time.Minute,
	}
	rateLimiter := NewRateLimiter(config)

	handler := rateLimiter(http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		w.WriteHeader(http.StatusOK)
	}))

	// Act - IP1 consomme sa limite
	for i := 0; i < 2; i++ {
		req := httptest.NewRequest("GET", "/test", nil)
		req.RemoteAddr = "192.168.1.10:12345"
		w := httptest.NewRecorder()
		handler.ServeHTTP(w, req)
		assert.Equal(t, http.StatusOK, w.Code)
	}

	// IP1 bloquée
	req := httptest.NewRequest("GET", "/test", nil)
	req.RemoteAddr = "192.168.1.10:12345"
	w := httptest.NewRecorder()
	handler.ServeHTTP(w, req)
	assert.Equal(t, http.StatusTooManyRequests, w.Code)

	// Act - IP2 doit encore avoir ses requêtes disponibles
	req = httptest.NewRequest("GET", "/test", nil)
	req.RemoteAddr = "192.168.1.20:12345"
	w = httptest.NewRecorder()
	handler.ServeHTTP(w, req)

	// Assert - IP2 ne doit pas être bloquée
	assert.Equal(t, http.StatusOK, w.Code)
}
