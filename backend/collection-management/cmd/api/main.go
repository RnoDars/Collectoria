package main

import (
	"os"
	"time"

	"collectoria/collection-management/internal/application"
	"collectoria/collection-management/internal/config"
	"collectoria/collection-management/internal/infrastructure/auth"
	"collectoria/collection-management/internal/infrastructure/http"
	"collectoria/collection-management/internal/infrastructure/postgres"

	"github.com/rs/zerolog"
	"github.com/rs/zerolog/log"
)

func main() {
	// Configuration du logger selon l'environnement
	env := getEnv("ENV", "development")
	logLevel := getEnv("LOG_LEVEL", "debug")

	if env == "production" {
		// Production: JSON structured logs
		log.Logger = zerolog.New(os.Stdout).With().
			Timestamp().
			Str("service", "collection-management").
			Logger()
		zerolog.SetGlobalLevel(parseLogLevel(logLevel, zerolog.InfoLevel))
	} else {
		// Development: Pretty console logs
		log.Logger = log.Output(zerolog.ConsoleWriter{
			Out:        os.Stderr,
			TimeFormat: time.RFC3339,
		})
		zerolog.SetGlobalLevel(parseLogLevel(logLevel, zerolog.DebugLevel))
	}

	log.Info().Str("env", env).Str("log_level", logLevel).Msg("Starting Collection Management Service")

	// Chargement de la configuration
	cfg, err := config.Load()
	if err != nil {
		log.Fatal().Err(err).Msg("Failed to load configuration")
	}

	// Connexion à la base de données
	dbConfig := postgres.Config{
		Host:     cfg.Database.Host,
		Port:     cfg.Database.Port,
		User:     cfg.Database.User,
		Password: cfg.Database.Password,
		Database: cfg.Database.Database,
		SSLMode:  cfg.Database.SSLMode,
	}

	db, err := postgres.NewConnection(dbConfig)
	if err != nil {
		log.Fatal().Err(err).Msg("Failed to connect to database")
	}
	defer db.Close()

	log.Info().Msg("Successfully connected to database")

	// Initialisation des repositories
	collectionRepo := postgres.NewCollectionRepository(db)
	cardRepo := postgres.NewCardRepository(db)
	activityRepo := postgres.NewPostgresActivityRepository(db)

	// Initialisation des services
	activityService := application.NewActivityService(activityRepo)
	collectionService := application.NewCollectionService(collectionRepo, cardRepo)
	catalogService := application.NewCatalogService(cardRepo)
	cardService := application.NewCardService(cardRepo, activityService)

	// Initialisation du JWT service
	jwtService := auth.NewJWTService(
		cfg.JWT.Secret,
		cfg.JWT.Issuer,
		cfg.JWT.ExpirationHours,
	)
	log.Info().Msg("JWT service initialized")

	// Initialisation du serveur HTTP
	server := http.NewServer(collectionService, catalogService, cardService, activityService, jwtService, log.Logger, cfg.Server.Port, cfg.CORS, db)

	// Démarrage du serveur
	log.Info().Msgf("Server ready on port %d", cfg.Server.Port)
	if err := server.Start(); err != nil {
		log.Fatal().Err(err).Msg("Server failed")
	}
}

// getEnv récupère une variable d'environnement avec une valeur par défaut
func getEnv(key, defaultValue string) string {
	value := os.Getenv(key)
	if value == "" {
		return defaultValue
	}
	return value
}

// parseLogLevel convertit une string en niveau de log zerolog
func parseLogLevel(level string, defaultLevel zerolog.Level) zerolog.Level {
	switch level {
	case "trace":
		return zerolog.TraceLevel
	case "debug":
		return zerolog.DebugLevel
	case "info":
		return zerolog.InfoLevel
	case "warn", "warning":
		return zerolog.WarnLevel
	case "error":
		return zerolog.ErrorLevel
	case "fatal":
		return zerolog.FatalLevel
	case "panic":
		return zerolog.PanicLevel
	default:
		return defaultLevel
	}
}
