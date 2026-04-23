package http

import (
	"context"
	"encoding/json"
	"fmt"
	"net/http"
	"runtime"
	"strconv"
	"time"

	"collectoria/collection-management/internal/application"
	"collectoria/collection-management/internal/config"
	"collectoria/collection-management/internal/infrastructure/auth"
	"collectoria/collection-management/internal/infrastructure/http/handlers"
	customMiddleware "collectoria/collection-management/internal/infrastructure/http/middleware"

	"github.com/go-chi/chi/v5"
	"github.com/go-chi/chi/v5/middleware"
	"github.com/jmoiron/sqlx"
	"github.com/rs/zerolog"
)

// Server représente le serveur HTTP
type Server struct {
	router            *chi.Mux
	collectionService *application.CollectionService
	catalogService    *application.CatalogService
	cardService       *application.CardService
	bookService       *application.BookService
	activityService   *application.ActivityService
	jwtService        *auth.JWTService
	logger            zerolog.Logger
	port              int
	corsConfig        config.CORSConfig
	rateLimitConfig   config.RateLimitConfig
	db                *sqlx.DB
}

// NewServer crée un nouveau serveur HTTP
func NewServer(collectionService *application.CollectionService, catalogService *application.CatalogService, cardService *application.CardService, bookService *application.BookService, activityService *application.ActivityService, jwtService *auth.JWTService, logger zerolog.Logger, port int, corsConfig config.CORSConfig, rateLimitConfig config.RateLimitConfig, db *sqlx.DB) *Server {
	s := &Server{
		router:            chi.NewRouter(),
		collectionService: collectionService,
		catalogService:    catalogService,
		cardService:       cardService,
		bookService:       bookService,
		activityService:   activityService,
		jwtService:        jwtService,
		logger:            logger,
		port:              port,
		corsConfig:        corsConfig,
		rateLimitConfig:   rateLimitConfig,
		db:                db,
	}

	s.setupMiddleware()
	s.setupRoutes()

	return s
}

// setupMiddleware configure les middlewares
func (s *Server) setupMiddleware() {
	s.router.Use(middleware.RequestID)
	s.router.Use(middleware.RealIP)
	s.router.Use(middleware.Logger)
	s.router.Use(middleware.Recoverer)
	s.router.Use(middleware.Timeout(60 * time.Second))

	// Security headers
	s.router.Use(securityHeadersMiddleware)

	// CORS configurable
	s.router.Use(s.corsMiddleware)
}

// corsMiddleware configure CORS avec les origines autorisées
func (s *Server) corsMiddleware(next http.Handler) http.Handler {
	return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		origin := r.Header.Get("Origin")

		// Check if origin is allowed
		allowed := false
		for _, allowedOrigin := range s.corsConfig.AllowedOrigins {
			if origin == allowedOrigin {
				allowed = true
				break
			}
		}

		if allowed {
			w.Header().Set("Access-Control-Allow-Origin", origin)
			w.Header().Set("Access-Control-Allow-Methods", "GET, POST, PUT, PATCH, DELETE, OPTIONS")
			w.Header().Set("Access-Control-Allow-Headers", "Content-Type, Authorization")
			w.Header().Set("Access-Control-Max-Age", strconv.Itoa(s.corsConfig.MaxAge))
		}

		if r.Method == "OPTIONS" {
			w.WriteHeader(http.StatusOK)
			return
		}

		next.ServeHTTP(w, r)
	})
}

// securityHeadersMiddleware ajoute les headers de sécurité HTTP recommandés
func securityHeadersMiddleware(next http.Handler) http.Handler {
	return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		// Prevent MIME type sniffing
		w.Header().Set("X-Content-Type-Options", "nosniff")

		// Prevent clickjacking
		w.Header().Set("X-Frame-Options", "DENY")

		// XSS Protection (legacy but still useful)
		w.Header().Set("X-XSS-Protection", "1; mode=block")

		// Referrer policy
		w.Header().Set("Referrer-Policy", "strict-origin-when-cross-origin")

		// HSTS (only if HTTPS)
		if r.TLS != nil {
			w.Header().Set("Strict-Transport-Security", "max-age=31536000; includeSubDomains")
		}

		// Content Security Policy (restrictive)
		w.Header().Set("Content-Security-Policy", "default-src 'self'; frame-ancestors 'none'")

		next.ServeHTTP(w, r)
	})
}

// setupRoutes configure les routes
func (s *Server) setupRoutes() {
	// Auth middleware
	authMiddleware := customMiddleware.NewAuthMiddleware(s.jwtService, s.logger)

	// Rate limiters
	loginRateLimiter := customMiddleware.NewRateLimiter(customMiddleware.RateLimitConfig{
		Requests: s.rateLimitConfig.LoginRequests,
		Window:   s.rateLimitConfig.LoginWindow,
	})

	readRateLimiter := customMiddleware.NewRateLimiter(customMiddleware.RateLimitConfig{
		Requests: s.rateLimitConfig.ReadRequests,
		Window:   s.rateLimitConfig.ReadWindow,
	})

	writeRateLimiter := customMiddleware.NewRateLimiter(customMiddleware.RateLimitConfig{
		Requests: s.rateLimitConfig.WriteRequests,
		Window:   s.rateLimitConfig.WriteWindow,
	})

	s.router.Route("/api/v1", func(r chi.Router) {
		// Public routes (no authentication, no rate limiting)
		r.Get("/health", s.healthCheckHandler)

		// Auth routes (strict rate limiting)
		r.Group(func(r chi.Router) {
			r.Use(loginRateLimiter)

			authHandler := handlers.NewAuthHandler(s.jwtService, s.logger)
			r.Post("/auth/login", authHandler.Login)
		})

		// Protected routes (authentication required + rate limiting)
		r.Group(func(r chi.Router) {
			r.Use(authMiddleware.Authenticate)

			// Read routes (permissive rate limiting)
			r.Group(func(r chi.Router) {
				r.Use(readRateLimiter)

				// Collections routes
				collectionHandler := handlers.NewCollectionHandler(s.collectionService, s.logger)
				r.Route("/collections", func(r chi.Router) {
					r.Get("/summary", collectionHandler.GetSummary)
					r.Get("/", collectionHandler.GetAllCollections)
				})

				// Activities & Statistics routes
				activityHandler := handlers.NewActivityHandler(s.activityService, s.logger)
				r.Get("/activities/recent", activityHandler.GetRecentActivities)
				r.Get("/statistics/growth", activityHandler.GetGrowthStats)

				// Catalog routes
				catalogHandler := handlers.NewCatalogHandler(s.catalogService, s.logger)
				r.Get("/cards", catalogHandler.GetCards)

				// Book routes
				bookHandler := handlers.NewBookHandler(s.bookService, s.logger)
				r.Get("/books", bookHandler.GetBooks)
			})

			// Write routes (moderate rate limiting)
			r.Group(func(r chi.Router) {
				r.Use(writeRateLimiter)

				// Card possession routes
				cardHandler := handlers.NewCardHandler(s.cardService, s.logger)
				r.Patch("/cards/{id}/possession", cardHandler.UpdateCardPossession)

				// Book possession routes
				bookHandler := handlers.NewBookHandler(s.bookService, s.logger)
				r.Patch("/books/{id}/possession", bookHandler.UpdateBookPossession)
			})
		})
	})
}

// HealthResponse représente la réponse du health check
type HealthResponse struct {
	Status  string            `json:"status"`
	Checks  map[string]string `json:"checks"`
	Version string            `json:"version,omitempty"`
}

// healthCheckHandler gère le health check avec vérification de la base de données
func (s *Server) healthCheckHandler(w http.ResponseWriter, r *http.Request) {
	ctx, cancel := context.WithTimeout(r.Context(), 2*time.Second)
	defer cancel()

	checks := make(map[string]string)
	overallStatus := "healthy"

	// Check database connection
	if err := s.db.PingContext(ctx); err != nil {
		checks["database"] = "unhealthy: " + err.Error()
		overallStatus = "unhealthy"
		s.logger.Error().Err(err).Msg("Database health check failed")
	} else {
		checks["database"] = "healthy"
	}

	// Check memory (optional)
	var m runtime.MemStats
	runtime.ReadMemStats(&m)
	checks["memory_mb"] = fmt.Sprintf("%.2f", float64(m.Alloc)/1024/1024)

	response := HealthResponse{
		Status:  overallStatus,
		Checks:  checks,
		Version: "0.1.0",
	}

	statusCode := http.StatusOK
	if overallStatus != "healthy" {
		statusCode = http.StatusServiceUnavailable
	}

	w.Header().Set("Content-Type", "application/json")
	w.WriteHeader(statusCode)
	json.NewEncoder(w).Encode(response)
}

// Start démarre le serveur
func (s *Server) Start() error {
	addr := fmt.Sprintf(":%d", s.port)
	s.logger.Info().Msgf("Starting server on %s", addr)
	return http.ListenAndServe(addr, s.router)
}
