package postgres

import (
	"context"
	"testing"
	"time"

	"github.com/google/uuid"
	"github.com/jmoiron/sqlx"
	_ "github.com/lib/pq"
	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/require"
	"github.com/testcontainers/testcontainers-go"
	"github.com/testcontainers/testcontainers-go/wait"
)

// setupTestDB crée une base de données PostgreSQL de test avec testcontainers
func setupTestDB(t *testing.T) (*sqlx.DB, func()) {
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
	createSchema(t, db)

	// Fonction de nettoyage
	cleanup := func() {
		db.Close()
		postgresC.Terminate(ctx)
	}

	return db, cleanup
}

// createSchema crée les tables nécessaires pour les tests
func createSchema(t *testing.T, db *sqlx.DB) {
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

// insertTestBook insère un livre de test et retourne son ID
func insertTestBook(t *testing.T, db *sqlx.DB) uuid.UUID {
	t.Helper()

	bookID := uuid.New()
	_, err := db.Exec(`
		INSERT INTO dnd5_books (id, number, name_en, name_fr, book_type)
		VALUES ($1, $2, $3, $4, $5)
	`, bookID, "PHB2014", "Player's Handbook", "Manuel des Joueurs", "Core Rules")
	require.NoError(t, err)

	return bookID
}

// boolPtr helper pour créer des pointeurs de bool
func boolPtr(b bool) *bool {
	return &b
}

// getBookOwnership récupère l'état de possession d'un livre
func getBookOwnership(t *testing.T, db *sqlx.DB, userID, bookID uuid.UUID) (ownedEn *bool, ownedFr *bool, exists bool) {
	t.Helper()

	var result struct {
		OwnedEn *bool `db:"owned_en"`
		OwnedFr *bool `db:"owned_fr"`
	}

	err := db.Get(&result, "SELECT owned_en, owned_fr FROM user_dnd5_books WHERE user_id = $1 AND book_id = $2", userID, bookID)
	if err != nil {
		return nil, nil, false
	}

	return result.OwnedEn, result.OwnedFr, true
}

// TestUpdateBookOwnership_OnlyFR_DoesNotAffectEN vérifie que la mise à jour de owned_fr seul ne touche pas owned_en
func TestUpdateBookOwnership_OnlyFR_DoesNotAffectEN(t *testing.T) {
	db, cleanup := setupTestDB(t)
	defer cleanup()

	ctx := context.Background()
	repo := NewDnD5BookRepository(db)

	// Setup
	userID := uuid.New()
	bookID := insertTestBook(t, db)

	// Étape 1 : Créer l'enregistrement avec EN = true
	err := repo.UpdateBookOwnership(ctx, userID, bookID, boolPtr(true), nil)
	require.NoError(t, err)

	// Vérifier l'état initial
	ownedEn, ownedFr, exists := getBookOwnership(t, db, userID, bookID)
	require.True(t, exists)
	require.NotNil(t, ownedEn)
	assert.True(t, *ownedEn)
	assert.Nil(t, ownedFr) // FR doit rester NULL

	// Étape 2 : Mettre à jour FR seulement
	err = repo.UpdateBookOwnership(ctx, userID, bookID, nil, boolPtr(true))
	require.NoError(t, err)

	// Vérifier que EN n'a pas changé et FR est à true
	ownedEn, ownedFr, exists = getBookOwnership(t, db, userID, bookID)
	require.True(t, exists)
	require.NotNil(t, ownedEn)
	assert.True(t, *ownedEn, "owned_en should remain true")
	require.NotNil(t, ownedFr)
	assert.True(t, *ownedFr, "owned_fr should be true")
}

// TestUpdateBookOwnership_OnlyEN_DoesNotAffectFR vérifie que la mise à jour de owned_en seul ne touche pas owned_fr
func TestUpdateBookOwnership_OnlyEN_DoesNotAffectFR(t *testing.T) {
	db, cleanup := setupTestDB(t)
	defer cleanup()

	ctx := context.Background()
	repo := NewDnD5BookRepository(db)

	// Setup
	userID := uuid.New()
	bookID := insertTestBook(t, db)

	// Étape 1 : Créer l'enregistrement avec FR = true
	err := repo.UpdateBookOwnership(ctx, userID, bookID, nil, boolPtr(true))
	require.NoError(t, err)

	// Vérifier l'état initial
	ownedEn, ownedFr, exists := getBookOwnership(t, db, userID, bookID)
	require.True(t, exists)
	assert.Nil(t, ownedEn) // EN doit rester NULL
	require.NotNil(t, ownedFr)
	assert.True(t, *ownedFr)

	// Étape 2 : Mettre à jour EN seulement
	err = repo.UpdateBookOwnership(ctx, userID, bookID, boolPtr(true), nil)
	require.NoError(t, err)

	// Vérifier que FR n'a pas changé et EN est à true
	ownedEn, ownedFr, exists = getBookOwnership(t, db, userID, bookID)
	require.True(t, exists)
	require.NotNil(t, ownedEn)
	assert.True(t, *ownedEn, "owned_en should be true")
	require.NotNil(t, ownedFr)
	assert.True(t, *ownedFr, "owned_fr should remain true")
}

// TestUpdateBookOwnership_BothVersions vérifie que les deux versions peuvent être mises à jour simultanément
func TestUpdateBookOwnership_BothVersions(t *testing.T) {
	db, cleanup := setupTestDB(t)
	defer cleanup()

	ctx := context.Background()
	repo := NewDnD5BookRepository(db)

	// Setup
	userID := uuid.New()
	bookID := insertTestBook(t, db)

	// Mettre à jour les deux versions en même temps
	err := repo.UpdateBookOwnership(ctx, userID, bookID, boolPtr(true), boolPtr(false))
	require.NoError(t, err)

	// Vérifier les valeurs
	ownedEn, ownedFr, exists := getBookOwnership(t, db, userID, bookID)
	require.True(t, exists)
	require.NotNil(t, ownedEn)
	assert.True(t, *ownedEn)
	require.NotNil(t, ownedFr)
	assert.False(t, *ownedFr)
}

// TestUpdateBookOwnership_ToggleFR_MultipleTimesIndependent vérifie les toggles répétés de FR n'affectent pas EN
func TestUpdateBookOwnership_ToggleFR_MultipleTimesIndependent(t *testing.T) {
	db, cleanup := setupTestDB(t)
	defer cleanup()

	ctx := context.Background()
	repo := NewDnD5BookRepository(db)

	// Setup
	userID := uuid.New()
	bookID := insertTestBook(t, db)

	// Initialiser EN = true
	err := repo.UpdateBookOwnership(ctx, userID, bookID, boolPtr(true), nil)
	require.NoError(t, err)

	// Toggle FR: nil -> true
	err = repo.UpdateBookOwnership(ctx, userID, bookID, nil, boolPtr(true))
	require.NoError(t, err)

	ownedEn, ownedFr, exists := getBookOwnership(t, db, userID, bookID)
	require.True(t, exists)
	assert.True(t, *ownedEn)
	assert.True(t, *ownedFr)

	// Toggle FR: true -> false
	err = repo.UpdateBookOwnership(ctx, userID, bookID, nil, boolPtr(false))
	require.NoError(t, err)

	ownedEn, ownedFr, exists = getBookOwnership(t, db, userID, bookID)
	require.True(t, exists)
	assert.True(t, *ownedEn, "owned_en should remain true through FR toggles")
	assert.False(t, *ownedFr)

	// Toggle FR: false -> true
	err = repo.UpdateBookOwnership(ctx, userID, bookID, nil, boolPtr(true))
	require.NoError(t, err)

	ownedEn, ownedFr, exists = getBookOwnership(t, db, userID, bookID)
	require.True(t, exists)
	assert.True(t, *ownedEn, "owned_en should remain true through FR toggles")
	assert.True(t, *ownedFr)
}

// TestUpdateBookOwnership_ToggleEN_MultipleTimesIndependent vérifie les toggles répétés de EN n'affectent pas FR
func TestUpdateBookOwnership_ToggleEN_MultipleTimesIndependent(t *testing.T) {
	db, cleanup := setupTestDB(t)
	defer cleanup()

	ctx := context.Background()
	repo := NewDnD5BookRepository(db)

	// Setup
	userID := uuid.New()
	bookID := insertTestBook(t, db)

	// Initialiser FR = true
	err := repo.UpdateBookOwnership(ctx, userID, bookID, nil, boolPtr(true))
	require.NoError(t, err)

	// Toggle EN: nil -> true
	err = repo.UpdateBookOwnership(ctx, userID, bookID, boolPtr(true), nil)
	require.NoError(t, err)

	ownedEn, ownedFr, exists := getBookOwnership(t, db, userID, bookID)
	require.True(t, exists)
	assert.True(t, *ownedEn)
	assert.True(t, *ownedFr)

	// Toggle EN: true -> false
	err = repo.UpdateBookOwnership(ctx, userID, bookID, boolPtr(false), nil)
	require.NoError(t, err)

	ownedEn, ownedFr, exists = getBookOwnership(t, db, userID, bookID)
	require.True(t, exists)
	assert.False(t, *ownedEn)
	assert.True(t, *ownedFr, "owned_fr should remain true through EN toggles")

	// Toggle EN: false -> true
	err = repo.UpdateBookOwnership(ctx, userID, bookID, boolPtr(true), nil)
	require.NoError(t, err)

	ownedEn, ownedFr, exists = getBookOwnership(t, db, userID, bookID)
	require.True(t, exists)
	assert.True(t, *ownedEn)
	assert.True(t, *ownedFr, "owned_fr should remain true through EN toggles")
}

// TestUpdateBookOwnership_AllCombinations vérifie toutes les combinaisons possibles
func TestUpdateBookOwnership_AllCombinations(t *testing.T) {
	testCases := []struct {
		name          string
		initialEn     *bool
		initialFr     *bool
		updateEn      *bool
		updateFr      *bool
		expectedEn    *bool
		expectedFr    *bool
		description   string
	}{
		{
			name:        "nil,nil -> true,nil",
			initialEn:   nil,
			initialFr:   nil,
			updateEn:    boolPtr(true),
			updateFr:    nil,
			expectedEn:  boolPtr(true),
			expectedFr:  nil,
			description: "Create EN only",
		},
		{
			name:        "nil,nil -> nil,true",
			initialEn:   nil,
			initialFr:   nil,
			updateEn:    nil,
			updateFr:    boolPtr(true),
			expectedEn:  nil,
			expectedFr:  boolPtr(true),
			description: "Create FR only",
		},
		{
			name:        "true,nil -> true,true",
			initialEn:   boolPtr(true),
			initialFr:   nil,
			updateEn:    nil,
			updateFr:    boolPtr(true),
			expectedEn:  boolPtr(true),
			expectedFr:  boolPtr(true),
			description: "Add FR to existing EN",
		},
		{
			name:        "nil,true -> true,true",
			initialEn:   nil,
			initialFr:   boolPtr(true),
			updateEn:    boolPtr(true),
			updateFr:    nil,
			expectedEn:  boolPtr(true),
			expectedFr:  boolPtr(true),
			description: "Add EN to existing FR",
		},
		{
			name:        "true,true -> false,true",
			initialEn:   boolPtr(true),
			initialFr:   boolPtr(true),
			updateEn:    boolPtr(false),
			updateFr:    nil,
			expectedEn:  boolPtr(false),
			expectedFr:  boolPtr(true),
			description: "Update EN only, keep FR",
		},
		{
			name:        "true,true -> true,false",
			initialEn:   boolPtr(true),
			initialFr:   boolPtr(true),
			updateEn:    nil,
			updateFr:    boolPtr(false),
			expectedEn:  boolPtr(true),
			expectedFr:  boolPtr(false),
			description: "Update FR only, keep EN",
		},
	}

	for _, tc := range testCases {
		t.Run(tc.name, func(t *testing.T) {
			db, cleanup := setupTestDB(t)
			defer cleanup()

			ctx := context.Background()
			repo := NewDnD5BookRepository(db)

			userID := uuid.New()
			bookID := insertTestBook(t, db)

			// Initialiser l'état si nécessaire
			if tc.initialEn != nil || tc.initialFr != nil {
				err := repo.UpdateBookOwnership(ctx, userID, bookID, tc.initialEn, tc.initialFr)
				require.NoError(t, err)
			}

			// Effectuer la mise à jour
			err := repo.UpdateBookOwnership(ctx, userID, bookID, tc.updateEn, tc.updateFr)
			require.NoError(t, err)

			// Vérifier le résultat
			ownedEn, ownedFr, exists := getBookOwnership(t, db, userID, bookID)
			require.True(t, exists)

			if tc.expectedEn == nil {
				assert.Nil(t, ownedEn, tc.description)
			} else {
				require.NotNil(t, ownedEn, tc.description)
				assert.Equal(t, *tc.expectedEn, *ownedEn, tc.description)
			}

			if tc.expectedFr == nil {
				assert.Nil(t, ownedFr, tc.description)
			} else {
				require.NotNil(t, ownedFr, tc.description)
				assert.Equal(t, *tc.expectedFr, *ownedFr, tc.description)
			}
		})
	}
}

// TestUpdateBookOwnership_CreateNew vérifie la création d'un nouvel enregistrement
func TestUpdateBookOwnership_CreateNew(t *testing.T) {
	db, cleanup := setupTestDB(t)
	defer cleanup()

	ctx := context.Background()
	repo := NewDnD5BookRepository(db)

	userID := uuid.New()
	bookID := insertTestBook(t, db)

	// Vérifier qu'aucun enregistrement n'existe
	_, _, exists := getBookOwnership(t, db, userID, bookID)
	assert.False(t, exists)

	// Créer un nouvel enregistrement avec les deux versions
	err := repo.UpdateBookOwnership(ctx, userID, bookID, boolPtr(true), boolPtr(false))
	require.NoError(t, err)

	// Vérifier que l'enregistrement a été créé
	ownedEn, ownedFr, exists := getBookOwnership(t, db, userID, bookID)
	require.True(t, exists)
	require.NotNil(t, ownedEn)
	assert.True(t, *ownedEn)
	require.NotNil(t, ownedFr)
	assert.False(t, *ownedFr)
}
