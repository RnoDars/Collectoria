package main

import (
	"os"

	"collectoria/collection-management/internal/application"
	"collectoria/collection-management/internal/config"
	"collectoria/collection-management/internal/infrastructure/http"
	"collectoria/collection-management/internal/infrastructure/postgres"

	"github.com/rs/zerolog"
	"github.com/rs/zerolog/log"
)

func main() {
	// Configuration du logger
	log.Logger = log.Output(zerolog.ConsoleWriter{Out: os.Stderr})

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

	// Initialisation des services
	collectionService := application.NewCollectionService(collectionRepo, nil)

	// Initialisation du serveur HTTP
	server := http.NewServer(collectionService, log.Logger, cfg.Server.Port)

	// Démarrage du serveur
	log.Info().Msgf("Starting Collection Management Service on port %d", cfg.Server.Port)
	if err := server.Start(); err != nil {
		log.Fatal().Err(err).Msg("Server failed")
	}
}
