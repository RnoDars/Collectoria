package security_test

import (
	"context"
	"database/sql"
	"fmt"
	"os"
	"testing"
	"time"

	"collectoria/collection-management/internal/infrastructure/postgres"

	"github.com/google/uuid"
	_ "github.com/lib/pq"
	"github.com/stretchr/testify/require"
)

// TestDatabaseConfig holds test database configuration
type TestDatabaseConfig struct {
	Host     string
	Port     string
	User     string
	Password string
	Database string
}

// getTestDatabaseConfig reads configuration from environment variables
func getTestDatabaseConfig() TestDatabaseConfig {
	return TestDatabaseConfig{
		Host:     getEnv("TEST_DB_HOST", "localhost"),
		Port:     getEnv("TEST_DB_PORT", "5432"),
		User:     getEnv("TEST_DB_USER", "collectoria_test"),
		Password: getEnv("TEST_DB_PASSWORD", "collectoria_test"),
		Database: getEnv("TEST_DB_NAME", "collection_management_test"),
	}
}

func getEnv(key, defaultValue string) string {
	value := os.Getenv(key)
	if value == "" {
		return defaultValue
	}
	return value
}

// setupTestDatabase creates a connection to the test database
// If TEST_DB_HOST is not set, tests will be skipped
func setupTestDatabase(t *testing.T) *sql.DB {
	t.Helper()

	// Check if test database is configured
	if os.Getenv("TEST_DB_HOST") == "" {
		t.Skip("Test database not configured (set TEST_DB_HOST to enable integration tests)")
	}

	config := getTestDatabaseConfig()

	// Build connection string
	connStr := fmt.Sprintf(
		"host=%s port=%s user=%s password=%s dbname=%s sslmode=disable",
		config.Host,
		config.Port,
		config.User,
		config.Password,
		config.Database,
	)

	// Open database connection
	db, err := sql.Open("postgres", connStr)
	require.NoError(t, err, "Failed to open test database connection")

	// Verify connection
	ctx, cancel := context.WithTimeout(context.Background(), 5*time.Second)
	defer cancel()

	err = db.PingContext(ctx)
	require.NoError(t, err, "Failed to ping test database")

	// Clean database before tests
	cleanTestDatabase(t, db)

	return db
}

// cleanTestDatabase removes all test data
func cleanTestDatabase(t *testing.T, db *sql.DB) {
	t.Helper()

	ctx := context.Background()

	// Delete in reverse order of foreign key dependencies
	queries := []string{
		"DELETE FROM activities",
		"DELETE FROM user_cards",
		"DELETE FROM user_collections",
		"DELETE FROM cards",
		"DELETE FROM collections",
	}

	for _, query := range queries {
		_, err := db.ExecContext(ctx, query)
		if err != nil {
			t.Logf("Warning: Failed to clean table: %v", err)
		}
	}
}

// setupTestUser creates a test user and returns its ID
func setupTestUser(t *testing.T, db *sql.DB) uuid.UUID {
	t.Helper()

	userID := uuid.New()

	// Note: Assuming users table exists or user_id can be any UUID
	// If users table exists, insert test user here
	// For now, we just return a valid UUID that will be used in foreign keys

	return userID
}

// setupTestCollection creates a test collection and returns its ID
func setupTestCollection(t *testing.T, db *sql.DB) uuid.UUID {
	t.Helper()

	collectionID := uuid.New()
	ctx := context.Background()

	query := `
		INSERT INTO collections (id, name, slug, category, total_cards, description, created_at, updated_at)
		VALUES ($1, $2, $3, $4, $5, $6, NOW(), NOW())
	`

	_, err := db.ExecContext(
		ctx,
		query,
		collectionID,
		"Test Collection",
		"test-collection",
		"test-category",
		0,
		"Test collection for security testing",
	)
	require.NoError(t, err, "Failed to create test collection")

	return collectionID
}

// setupTestCards creates test cards and returns their IDs
func setupTestCards(t *testing.T, db *sql.DB, collectionID uuid.UUID, count int) []uuid.UUID {
	t.Helper()

	cardIDs := make([]uuid.UUID, count)
	ctx := context.Background()

	query := `
		INSERT INTO cards (id, collection_id, name_en, name_fr, card_type, series, rarity, created_at, updated_at)
		VALUES ($1, $2, $3, $4, $5, $6, $7, NOW(), NOW())
	`

	for i := 0; i < count; i++ {
		cardID := uuid.New()
		cardIDs[i] = cardID

		_, err := db.ExecContext(
			ctx,
			query,
			cardID,
			collectionID,
			fmt.Sprintf("Test Card EN %d", i+1),
			fmt.Sprintf("Carte de Test FR %d", i+1),
			"Character",
			"Test Series",
			"Common",
		)
		require.NoError(t, err, "Failed to create test card %d", i+1)
	}

	return cardIDs
}

// setupUserCollection associates a user with a collection
func setupUserCollection(t *testing.T, db *sql.DB, userID, collectionID uuid.UUID) {
	t.Helper()

	ctx := context.Background()

	query := `
		INSERT INTO user_collections (user_id, collection_id, created_at)
		VALUES ($1, $2, NOW())
		ON CONFLICT (user_id, collection_id) DO NOTHING
	`

	_, err := db.ExecContext(ctx, query, userID, collectionID)
	require.NoError(t, err, "Failed to create user_collection association")
}

// setupUserCard associates a card with a user
func setupUserCard(t *testing.T, db *sql.DB, userID, cardID uuid.UUID, isOwned bool) {
	t.Helper()

	ctx := context.Background()

	query := `
		INSERT INTO user_cards (user_id, card_id, is_owned, created_at, updated_at)
		VALUES ($1, $2, $3, NOW(), NOW())
		ON CONFLICT (user_id, card_id) DO UPDATE SET is_owned = $3, updated_at = NOW()
	`

	_, err := db.ExecContext(ctx, query, userID, cardID, isOwned)
	require.NoError(t, err, "Failed to create user_card association")
}

// wrapWithPostgresRepository wraps a sql.DB into sqlx.DB for repository usage
func wrapWithPostgresRepository(db *sql.DB) *postgres.CardRepository {
	// This is a simplified wrapper - in production you'd use sqlx.NewDb()
	// For now, we test directly with sql.DB to avoid importing sqlx in tests
	return nil
}
