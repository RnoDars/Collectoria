package http

import (
	"fmt"
	"net/http"
	"time"

	"collectoria/collection-management/internal/application"
	"collectoria/collection-management/internal/infrastructure/http/handlers"

	"github.com/go-chi/chi/v5"
	"github.com/go-chi/chi/v5/middleware"
	"github.com/rs/zerolog"
)

// Server représente le serveur HTTP
type Server struct {
	router            *chi.Mux
	collectionService *application.CollectionService
	logger            zerolog.Logger
	port              int
}

// NewServer crée un nouveau serveur HTTP
func NewServer(collectionService *application.CollectionService, logger zerolog.Logger, port int) *Server {
	s := &Server{
		router:            chi.NewRouter(),
		collectionService: collectionService,
		logger:            logger,
		port:              port,
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

	// CORS pour localhost:3000 (frontend Next.js)
	s.router.Use(func(next http.Handler) http.Handler {
		return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
			w.Header().Set("Access-Control-Allow-Origin", "http://localhost:3000")
			w.Header().Set("Access-Control-Allow-Methods", "GET, POST, PUT, DELETE, OPTIONS")
			w.Header().Set("Access-Control-Allow-Headers", "Content-Type, Authorization")

			if r.Method == "OPTIONS" {
				w.WriteHeader(http.StatusOK)
				return
			}

			next.ServeHTTP(w, r)
		})
	})
}

// setupRoutes configure les routes
func (s *Server) setupRoutes() {
	s.router.Route("/api/v1", func(r chi.Router) {
		// Health check
		r.Get("/health", func(w http.ResponseWriter, r *http.Request) {
			w.WriteHeader(http.StatusOK)
			w.Write([]byte(`{"status":"ok"}`))
		})

		// Collections routes
		collectionHandler := handlers.NewCollectionHandler(s.collectionService, s.logger)
		r.Route("/collections", func(r chi.Router) {
			r.Get("/summary", collectionHandler.GetSummary)
			r.Get("/", collectionHandler.GetAllCollections)
		})
	})
}

// Start démarre le serveur
func (s *Server) Start() error {
	addr := fmt.Sprintf(":%d", s.port)
	s.logger.Info().Msgf("Starting server on %s", addr)
	return http.ListenAndServe(addr, s.router)
}
