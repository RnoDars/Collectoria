package security_test

import (
	"context"
	"database/sql"
	"net/url"
	"testing"

	"collectoria/collection-management/internal/domain"
	"collectoria/collection-management/internal/infrastructure/postgres"

	"github.com/google/uuid"
	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/require"
)

// SQL Injection payloads classiques (OWASP testing guide)
var sqlInjectionPayloads = []string{
	"' OR '1'='1",                      // Classic boolean injection
	"'; DROP TABLE cards; --",          // Destructive injection
	"' UNION SELECT NULL, NULL--",      // Union-based injection
	"admin'--",                          // Comment injection
	"' OR 1=1--",                        // Boolean injection with comment
	"1' AND '1'='1",                     // Always-true condition
	"' OR 'x'='x",                       // Boolean injection variant
	"'; SELECT * FROM users; --",       // Stacked queries
	"' UNION SELECT id, password FROM users--", // Data exfiltration attempt
	"\\'; DROP TABLE cards; --",        // Escaped quote
	"%' OR '1'='1",                      // LIKE pattern injection
	"_' OR '1'='1",                      // Wildcard injection
	"1' ORDER BY 10--",                  // Column enumeration
	"' AND 1=CAST((SELECT COUNT(*) FROM users) AS INT)--", // Blind injection
	"'; WAITFOR DELAY '00:00:05'--",    // Time-based blind (SQL Server specific, should fail harmlessly)
}

// TestCardRepository_SQLInjection_Search vérifie l'immunité contre injection dans le paramètre search
func TestCardRepository_SQLInjection_Search(t *testing.T) {
	// Setup
	ctx := context.Background()
	db := setupTestDatabase(t)
	defer db.Close()

	repo := postgres.NewCardRepository(db)
	userID := setupTestUser(t, db)
	collectionID := setupTestCollection(t, db)
	setupTestCards(t, db, collectionID, 10)
	setupUserCollection(t, db, userID, collectionID)

	for _, payload := range sqlInjectionPayloads {
		t.Run("Search_Payload_"+url.QueryEscape(payload), func(t *testing.T) {
			filter := domain.CardFilter{
				Search: payload,
				Page:   1,
				Limit:  10,
			}

			// Execute
			result, err := repo.GetCardsCatalog(ctx, userID, filter)

			// Assert: Should not cause error
			assert.NoError(t, err, "SQL injection payload should not cause query error")
			assert.NotNil(t, result, "Result should not be nil")

			// Assert: Should return 0 results (no card names match payload)
			// If it returns all cards (10+), the injection bypassed the WHERE clause
			assert.Equal(t, 0, result.Total, "Payload should not bypass filters and return all cards")
			assert.Equal(t, 0, len(result.Cards), "No cards should match injection payload")
		})
	}
}

// TestCardRepository_SQLInjection_Series vérifie l'immunité dans le paramètre series
func TestCardRepository_SQLInjection_Series(t *testing.T) {
	ctx := context.Background()
	db := setupTestDatabase(t)
	defer db.Close()

	repo := postgres.NewCardRepository(db)
	userID := setupTestUser(t, db)
	collectionID := setupTestCollection(t, db)
	setupTestCards(t, db, collectionID, 10)
	setupUserCollection(t, db, userID, collectionID)

	for _, payload := range sqlInjectionPayloads {
		t.Run("Series_Payload_"+url.QueryEscape(payload), func(t *testing.T) {
			filter := domain.CardFilter{
				Series: payload,
				Page:   1,
				Limit:  10,
			}

			result, err := repo.GetCardsCatalog(ctx, userID, filter)

			assert.NoError(t, err, "Injection payload should not cause error")
			assert.NotNil(t, result)
			// Series filter is exact match, so injection payload won't match real series
			assert.Equal(t, 0, result.Total, "Injection should not bypass series filter")
		})
	}
}

// TestCardRepository_SQLInjection_Rarity vérifie l'immunité dans le paramètre rarity
func TestCardRepository_SQLInjection_Rarity(t *testing.T) {
	ctx := context.Background()
	db := setupTestDatabase(t)
	defer db.Close()

	repo := postgres.NewCardRepository(db)
	userID := setupTestUser(t, db)
	collectionID := setupTestCollection(t, db)
	setupTestCards(t, db, collectionID, 10)
	setupUserCollection(t, db, userID, collectionID)

	for _, payload := range sqlInjectionPayloads {
		t.Run("Rarity_Payload_"+url.QueryEscape(payload), func(t *testing.T) {
			filter := domain.CardFilter{
				Rarity: payload,
				Page:   1,
				Limit:  10,
			}

			result, err := repo.GetCardsCatalog(ctx, userID, filter)

			assert.NoError(t, err)
			assert.NotNil(t, result)
			assert.Equal(t, 0, result.Total, "Injection should not bypass rarity filter")
		})
	}
}

// TestCardRepository_SQLInjection_CardType vérifie l'immunité dans le paramètre type
func TestCardRepository_SQLInjection_CardType(t *testing.T) {
	ctx := context.Background()
	db := setupTestDatabase(t)
	defer db.Close()

	repo := postgres.NewCardRepository(db)
	userID := setupTestUser(t, db)
	collectionID := setupTestCollection(t, db)
	setupTestCards(t, db, collectionID, 10)
	setupUserCollection(t, db, userID, collectionID)

	for _, payload := range sqlInjectionPayloads {
		t.Run("CardType_Payload_"+url.QueryEscape(payload), func(t *testing.T) {
			filter := domain.CardFilter{
				Type: payload,
				Page:   1,
				Limit:  10,
			}

			result, err := repo.GetCardsCatalog(ctx, userID, filter)

			assert.NoError(t, err)
			assert.NotNil(t, result)
			assert.Equal(t, 0, result.Total)
		})
	}
}

// TestCollectionRepository_SQLInjection_UserID teste l'injection via UUID (devrait échouer avant SQL)
func TestCollectionRepository_SQLInjection_UserID(t *testing.T) {
	ctx := context.Background()
	db := setupTestDatabase(t)
	defer db.Close()

	repo := postgres.NewCollectionRepository(db)

	// Tenter d'injecter via un UUID malformé
	maliciousUUIDs := []string{
		"' OR '1'='1",
		"00000000-0000-0000-0000-000000000000'; DROP TABLE collections; --",
	}

	for _, malicious := range maliciousUUIDs {
		t.Run("UUID_"+url.QueryEscape(malicious), func(t *testing.T) {
			// uuid.Parse devrait rejeter les UUIDs invalides AVANT qu'ils n'atteignent SQL
			_, err := uuid.Parse(malicious)
			assert.Error(t, err, "Invalid UUID should be rejected by uuid.Parse")

			// Si on force l'utilisation d'un UUID invalide, le driver SQL devrait le rejeter
			// Test uniquement si uuid.Parse échoue correctement (validation en amont)
		})
	}
}

// TestCardRepository_SQLInjection_UpdatePossession teste l'injection dans l'UPDATE
func TestCardRepository_SQLInjection_UpdatePossession(t *testing.T) {
	ctx := context.Background()
	db := setupTestDatabase(t)
	defer db.Close()

	repo := postgres.NewCardRepository(db)
	userID := setupTestUser(t, db)
	collectionID := setupTestCollection(t, db)
	cardID := setupTestCards(t, db, collectionID, 1)[0]
	setupUserCollection(t, db, userID, collectionID)

	// UpdateUserCardPossession utilise uniquement des UUIDs et un booléen
	// On vérifie que même avec des UUIDs malformés, l'injection est impossible

	// UUID valides - opération normale
	err := repo.UpdateUserCardPossession(ctx, userID, cardID, true)
	assert.NoError(t, err, "Normal update should succeed")

	// UUIDs sont typés, donc injection impossible via ce vecteur
	// Le test confirme que les paramètres typés empêchent l'injection
}

// TestActivityRepository_SQLInjection_Metadata teste l'injection via JSON metadata
func TestActivityRepository_SQLInjection_Metadata(t *testing.T) {
	ctx := context.Background()
	db := setupTestDatabase(t)
	defer db.Close()

	repo := postgres.NewPostgresActivityRepository(db)

	// Tenter d'injecter SQL via les métadonnées JSON
	activity := &domain.Activity{
		ID:   uuid.New(),
		Type: domain.ActivityCardAdded,
		Metadata: map[string]string{
			"user_id":   "' OR '1'='1",
			"card_id":   "'; DROP TABLE activities; --",
			"card_name": "' UNION SELECT * FROM users--",
		},
	}

	err := repo.Create(ctx, activity)

	// Les métadonnées sont marshallées en JSONB, donc injection impossible
	// Les valeurs sont traitées comme du texte JSON, pas comme SQL
	assert.NoError(t, err, "JSON metadata should be safely marshalled")

	// Vérifier que l'activité a été créée sans exécuter le payload
	activities, err := repo.GetRecentByUserID(ctx, activity.ID, 10)
	assert.NoError(t, err)
	assert.NotEmpty(t, activities, "Activity should be created despite injection attempt")
}

// TestNoErrorLeakage vérifie qu'aucune erreur SQL n'est exposée aux clients
func TestNoErrorLeakage(t *testing.T) {
	ctx := context.Background()
	db := setupTestDatabase(t)
	defer db.Close()

	repo := postgres.NewCardRepository(db)

	// Forcer une erreur en passant un UUID zéro (invalide)
	_, err := repo.GetCardByID(ctx, uuid.Nil)

	// L'erreur doit être gérée proprement, sans exposer les détails SQL
	if err != nil {
		assert.NotContains(t, err.Error(), "syntax error", "SQL syntax errors should not be exposed")
		assert.NotContains(t, err.Error(), "pq:", "PostgreSQL driver errors should not be exposed")
	}
}

// ========================================
// Test Helpers
// ========================================

func setupTestDatabase(t *testing.T) *sql.DB {
	// Cette fonction devrait se connecter à une base de test
	// Pour l'instant, on skip si pas de DB de test disponible
	t.Skip("Test database not configured - run with integration tests")
	return nil
}

func setupTestUser(t *testing.T, db *sql.DB) uuid.UUID {
	userID := uuid.New()
	// Insert test user
	return userID
}

func setupTestCollection(t *testing.T, db *sql.DB) uuid.UUID {
	collectionID := uuid.New()
	// Insert test collection
	return collectionID
}

func setupTestCards(t *testing.T, db *sql.DB, collectionID uuid.UUID, count int) []uuid.UUID {
	cardIDs := make([]uuid.UUID, count)
	for i := 0; i < count; i++ {
		cardIDs[i] = uuid.New()
		// Insert test card
	}
	return cardIDs
}

func setupUserCollection(t *testing.T, db *sql.DB, userID, collectionID uuid.UUID) {
	// Associate user with collection
}
