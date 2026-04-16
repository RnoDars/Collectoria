package config

import (
	"fmt"
	"os"
	"strconv"
)

// Config représente la configuration de l'application
type Config struct {
	Server   ServerConfig
	Database DatabaseConfig
}

// ServerConfig représente la configuration du serveur HTTP
type ServerConfig struct {
	Port int
}

// DatabaseConfig représente la configuration de la base de données
type DatabaseConfig struct {
	Host     string
	Port     int
	User     string
	Password string
	Database string
	SSLMode  string
}

// Load charge la configuration depuis les variables d'environnement
func Load() (*Config, error) {
	cfg := &Config{
		Server: ServerConfig{
			Port: getEnvAsInt("SERVER_PORT", 8080),
		},
		Database: DatabaseConfig{
			Host:     getEnv("DB_HOST", "localhost"),
			Port:     getEnvAsInt("DB_PORT", 5432),
			User:     getEnv("DB_USER", "collectoria"),
			Password: getEnv("DB_PASSWORD", "collectoria"),
			Database: getEnv("DB_NAME", "collection_management"),
			SSLMode:  getEnv("DB_SSLMODE", "disable"),
		},
	}

	return cfg, nil
}

// getEnv récupère une variable d'environnement avec une valeur par défaut
func getEnv(key, defaultValue string) string {
	value := os.Getenv(key)
	if value == "" {
		return defaultValue
	}
	return value
}

// getEnvAsInt récupère une variable d'environnement en tant qu'entier
func getEnvAsInt(key string, defaultValue int) int {
	valueStr := os.Getenv(key)
	if valueStr == "" {
		return defaultValue
	}

	value, err := strconv.Atoi(valueStr)
	if err != nil {
		fmt.Printf("Warning: Invalid integer for %s, using default %d\n", key, defaultValue)
		return defaultValue
	}

	return value
}
