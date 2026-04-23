package config

import (
	"fmt"
	"os"
	"strconv"
	"strings"
	"time"
)

// Config représente la configuration de l'application
type Config struct {
	Server      ServerConfig
	Database    DatabaseConfig
	CORS        CORSConfig
	JWT         JWTConfig
	RateLimit   RateLimitConfig
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

// CORSConfig représente la configuration CORS
type CORSConfig struct {
	AllowedOrigins []string
	MaxAge         int
}

// JWTConfig représente la configuration JWT
type JWTConfig struct {
	Secret          string
	ExpirationHours int
	Issuer          string
}

// RateLimitConfig représente la configuration du rate limiting
type RateLimitConfig struct {
	LoginRequests  int64
	LoginWindow    time.Duration
	ReadRequests   int64
	ReadWindow     time.Duration
	WriteRequests  int64
	WriteWindow    time.Duration
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
		CORS: CORSConfig{
			AllowedOrigins: strings.Split(getEnv("CORS_ALLOWED_ORIGINS", "http://localhost:3000,http://localhost:3001"), ","),
			MaxAge:         getEnvAsInt("CORS_MAX_AGE", 300),
		},
		JWT: JWTConfig{
			Secret:          getEnv("JWT_SECRET", ""),
			ExpirationHours: getEnvAsInt("JWT_EXPIRATION_HOURS", 24),
			Issuer:          getEnv("JWT_ISSUER", "collectoria-api"),
		},
		RateLimit: RateLimitConfig{
			LoginRequests: int64(getEnvAsInt("RATE_LIMIT_LOGIN_REQUESTS", 5)),
			LoginWindow:   getEnvAsDuration("RATE_LIMIT_LOGIN_WINDOW", 15*time.Minute),
			ReadRequests:  int64(getEnvAsInt("RATE_LIMIT_READ_REQUESTS", 100)),
			ReadWindow:    getEnvAsDuration("RATE_LIMIT_READ_WINDOW", 1*time.Minute),
			WriteRequests: int64(getEnvAsInt("RATE_LIMIT_WRITE_REQUESTS", 30)),
			WriteWindow:   getEnvAsDuration("RATE_LIMIT_WRITE_WINDOW", 1*time.Minute),
		},
	}

	// Validation: JWT Secret MUST be set and secure
	if cfg.JWT.Secret == "" {
		return nil, fmt.Errorf("JWT_SECRET must be set")
	}
	if len(cfg.JWT.Secret) < 32 {
		return nil, fmt.Errorf("JWT_SECRET must be at least 32 characters long for security")
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

// getEnvAsDuration récupère une variable d'environnement en tant que duration
func getEnvAsDuration(key string, defaultValue time.Duration) time.Duration {
	valueStr := os.Getenv(key)
	if valueStr == "" {
		return defaultValue
	}

	value, err := time.ParseDuration(valueStr)
	if err != nil {
		fmt.Printf("Warning: Invalid duration for %s, using default %s\n", key, defaultValue)
		return defaultValue
	}

	return value
}
