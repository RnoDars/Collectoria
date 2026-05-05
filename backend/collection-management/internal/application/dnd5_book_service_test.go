package application

import (
	"context"
	"testing"
	"time"

	"collectoria/collection-management/internal/infrastructure/postgres"

	"github.com/google/uuid"
	"github.com/jmoiron/sqlx"
	_ "github.com/lib/pq"
	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/require"
	"github.com/testcontainers/testcontainers-go"
	"github.com/testcontainers/testcontainers-go/wait"
)

// setupServiceTestDB crée une base de données PostgreSQL de test avec testcontainers
func setupServiceTestDB(t *testing.T) (*sqlx.DB, func()) {
	t.Helper()

	ctx := context.Background()

	// Démarrer un container PostgreSQL
	req := testcontainers.ContainerRequest{
		Image:        "postgres:15-alpine",
		ExposedPorts: []string{"5432/tcp"},
		Env: map[string]string{
			"POSTGRES_USER":     "testuser",
			"POSTGRES_PASSWORD": "testpass",
			"POSTGRES_DB":       "testdb",
		},
		WaitingFor: wait.ForLog("database system is ready to accept connections").WithOccurrence(2).WithStartupTimeout(60 * time.Second),
	}

	postgresC, err := testcontainers.GenericContainer(ctx, testcontainers.GenericContainerRequest{
		ContainerRequest: req,
		Started:          true,
	})
	require.NoError(t, err)

	// Obtenir l'hôte et le port du container
	host, err := postgresC.Host(ctx)
	require.NoError(t, err)

	port, err := postgresC.MappedPort(ctx, "5432")
	require.NoError(t, err)

	// Construire le DSN
	dsn := "host=" + host + " port=" + port.Port() + " user=testuser password=testpass dbname=testdb sslmode=disable"

	// Ouvrir la connexion
	db, err := sqlx.Connect("postgres", dsn)
	require.NoError(t, err)

	// Créer le schéma
	createServiceTestSchema(t, db)

	// Fonction de nettoyage
	cleanup := func() {
		db.Close()
		postgresC.Terminate(ctx)
	}

	return db, cleanup
}

// createServiceTestSchema crée les tables nécessaires pour les tests
func createServiceTestSchema(t *testing.T, db *sqlx.DB) {
	t.Helper()

	// Table dnd5_books
	_, err := db.Exec(`
		CREATE TABLE IF NOT EXISTS dnd5_books (
			id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
			number VARCHAR(10) NOT NULL,
			name_en VARCHAR(255) NOT NULL,
			name_fr VARCHAR(255) NULL,
			book_type VARCHAR(50) NOT NULL,
			created_at TIMESTAMP NOT NULL DEFAULT NOW(),
			updated_at TIMESTAMP NOT NULL DEFAULT NOW()
		)
	`)
	require.NoError(t, err)

	// Table user_dnd5_books
	_, err = db.Exec(`
		CREATE TABLE IF NOT EXISTS user_dnd5_books (
			id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
			user_id UUID NOT NULL,
			book_id UUID NOT NULL REFERENCES dnd5_books(id) ON DELETE CASCADE,
			owned_en BOOLEAN NULL,
			owned_fr BOOLEAN NULL,
			created_at TIMESTAMP NOT NULL DEFAULT NOW(),
			updated_at TIMESTAMP NOT NULL DEFAULT NOW(),
			UNIQUE(user_id, book_id)
		)
	`)
	require.NoError(t, err)
}

// insertServiceTestBook insère un livre de test et retourne son ID
func insertServiceTestBook(t *testing.T, db *sqlx.DB) uuid.UUID {
	t.Helper()

	bookID := uuid.New()
	_, err := db.Exec(`
		INSERT INTO dnd5_books (id, number, name_en, name_fr, book_type)
		VALUES ($1, $2, $3, $4, $5)
	`, bookID, "PHB2014", "Player's Handbook", "Manuel des Joueurs", "Core Rules")
	require.NoError(t, err)

	return bookID
}

// boolServicePtr helper pour créer des pointeurs de bool
func boolServicePtr(b bool) *bool {
	return &b
}

// TestDnD5BookService_UpdateBookOwnership_IntegrationScenario teste un scénario complet d'intégration
func TestDnD5BookService_UpdateBookOwnership_IntegrationScenario(t *testing.T) {
	db, cleanup := setupServiceTestDB(t)
	defer cleanup()

	ctx := context.Background()
	userID := uuid.New()
	bookID := insertServiceTestBook(t, db)

	// Créer le service (sans ActivityService pour ce test)
	repo := postgres.NewDnD5BookRepository(db)
	service := NewDnD5BookService(repo, nil)

	// Scénario 1 : Acheter version EN
	result, err := service.UpdateBookOwnership(ctx, userID, bookID, boolServicePtr(true), nil)
	require.NoError(t, err)
	require.NotNil(t, result)
	assert.NotNil(t, result.OwnedEn)
	assert.True(t, *result.OwnedEn)
	assert.Nil(t, result.OwnedFr, "FR should remain nil after only updating EN")

	// Scénario 2 : Acheter version FR (EN doit rester true)
	result, err = service.UpdateBookOwnership(ctx, userID, bookID, nil, boolServicePtr(true))
	require.NoError(t, err)
	require.NotNil(t, result)
	assert.NotNil(t, result.OwnedEn)
	assert.True(t, *result.OwnedEn, "EN should remain true after updating FR")
	assert.NotNil(t, result.OwnedFr)
	assert.True(t, *result.OwnedFr)

	// Scénario 3 : Vendre version EN (FR doit rester true)
	result, err = service.UpdateBookOwnership(ctx, userID, bookID, boolServicePtr(false), nil)
	require.NoError(t, err)
	require.NotNil(t, result)
	assert.NotNil(t, result.OwnedEn)
	assert.False(t, *result.OwnedEn)
	assert.NotNil(t, result.OwnedFr)
	assert.True(t, *result.OwnedFr, "FR should remain true after updating EN to false")
}

// TestDnD5BookService_UpdateBookOwnership_BothNilShouldFail teste la validation
func TestDnD5BookService_UpdateBookOwnership_BothNilShouldFail(t *testing.T) {
	db, cleanup := setupServiceTestDB(t)
	defer cleanup()

	ctx := context.Background()
	userID := uuid.New()
	bookID := insertServiceTestBook(t, db)

	repo := postgres.NewDnD5BookRepository(db)
	service := NewDnD5BookService(repo, nil)

	// Tenter de mettre à jour avec les deux valeurs nil
	_, err := service.UpdateBookOwnership(ctx, userID, bookID, nil, nil)
	require.Error(t, err)
	assert.Contains(t, err.Error(), "owned_en or owned_fr required")
}

// TestDnD5BookService_UpdateBookOwnership_BookNotFound teste le cas d'un livre inexistant
func TestDnD5BookService_UpdateBookOwnership_BookNotFound(t *testing.T) {
	db, cleanup := setupServiceTestDB(t)
	defer cleanup()

	ctx := context.Background()
	userID := uuid.New()
	fakeBookID := uuid.New() // Livre qui n'existe pas

	repo := postgres.NewDnD5BookRepository(db)
	service := NewDnD5BookService(repo, nil)

	// Tenter de mettre à jour un livre inexistant
	_, err := service.UpdateBookOwnership(ctx, userID, fakeBookID, boolServicePtr(true), nil)
	require.Error(t, err)
	assert.Contains(t, err.Error(), "book not found")
}
