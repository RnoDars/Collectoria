package postgres

import (
	"context"
	"testing"
	"time"

	"collectoria/collection-management/internal/domain"

	"github.com/google/uuid"
	"github.com/jmoiron/sqlx"
	_ "github.com/lib/pq"
	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/require"
)

// TestUpdateBookOwnership_RoyaumesOublies teste la mise à jour pour Royaumes Oubliés
func TestUpdateBookOwnership_RoyaumesOublies(t *testing.T) {
	// Skip if not integration test
	if testing.Short() {
		t.Skip("Skipping integration test")
	}

	db := setupTestDB(t)
	defer db.Close()

	repo := NewBookRepository(db)
	ctx := context.Background()

	// Créer un livre Royaumes Oubliés
	royaumesOubliesID := uuid.MustParse("22222222-2222-2222-2222-222222222222")
	bookID := uuid.New()
	userID := uuid.New()

	_, err := db.ExecContext(ctx, `
		INSERT INTO books (id, collection_id, number, title, author, publication_date, book_type)
		VALUES ($1, $2, '1', 'Test Book RO', 'Test Author', NOW(), 'roman')
	`, bookID, royaumesOubliesID)
	require.NoError(t, err)

	// Test 1: Mise à jour avec is_owned (doit réussir)
	ownership := domain.OwnershipUpdate{
		IsOwned: boolPtr(true),
	}

	err = repo.UpdateBookOwnership(ctx, userID, bookID, ownership)
	assert.NoError(t, err)

	// Vérifier dans la base
	var userBook domain.UserBook
	err = db.GetContext(ctx, &userBook, "SELECT * FROM user_books WHERE user_id = $1 AND book_id = $2", userID, bookID)
	require.NoError(t, err)
	assert.True(t, userBook.IsOwned)
	assert.Nil(t, userBook.OwnedEn)
	assert.Nil(t, userBook.OwnedFr)

	// Test 2: Mise à jour avec owned_en (doit échouer)
	invalidOwnership := domain.OwnershipUpdate{
		OwnedEn: boolPtr(true),
	}

	err = repo.UpdateBookOwnership(ctx, userID, bookID, invalidOwnership)
	assert.Error(t, err)
	assert.Contains(t, err.Error(), "is_owned is required")

	// Cleanup
	_, _ = db.ExecContext(ctx, "DELETE FROM user_books WHERE book_id = $1", bookID)
	_, _ = db.ExecContext(ctx, "DELETE FROM books WHERE id = $1", bookID)
}

// TestUpdateBookOwnership_DnD5e teste la mise à jour pour D&D 5e
func TestUpdateBookOwnership_DnD5e(t *testing.T) {
	// Skip if not integration test
	if testing.Short() {
		t.Skip("Skipping integration test")
	}

	db := setupTestDB(t)
	defer db.Close()

	repo := NewBookRepository(db)
	ctx := context.Background()

	// Créer un livre D&D 5e
	dnd5eID := uuid.MustParse("33333333-3333-3333-3333-333333333333")
	bookID := uuid.New()
	userID := uuid.New()

	_, err := db.ExecContext(ctx, `
		INSERT INTO books (id, collection_id, number, title, name_en, name_fr, author, publication_date, edition, book_type)
		VALUES ($1, $2, 'PHB', 'Player Handbook', 'Player Handbook', 'Manuel des joueurs', 'WotC', NOW(), 'D&D 5', 'Core Rules')
	`, bookID, dnd5eID)
	require.NoError(t, err)

	// Test 1: Mise à jour avec owned_en et owned_fr (doit réussir)
	ownership := domain.OwnershipUpdate{
		OwnedEn: boolPtr(true),
		OwnedFr: boolPtr(false),
	}

	err = repo.UpdateBookOwnership(ctx, userID, bookID, ownership)
	assert.NoError(t, err)

	// Vérifier dans la base
	var userBook domain.UserBook
	err = db.GetContext(ctx, &userBook, "SELECT * FROM user_books WHERE user_id = $1 AND book_id = $2", userID, bookID)
	require.NoError(t, err)
	assert.False(t, userBook.IsOwned) // doit être false par défaut
	assert.NotNil(t, userBook.OwnedEn)
	assert.True(t, *userBook.OwnedEn)
	assert.NotNil(t, userBook.OwnedFr)
	assert.False(t, *userBook.OwnedFr)

	// Test 2: Mise à jour avec is_owned (doit échouer)
	invalidOwnership := domain.OwnershipUpdate{
		IsOwned: boolPtr(true),
	}

	err = repo.UpdateBookOwnership(ctx, userID, bookID, invalidOwnership)
	assert.Error(t, err)
	assert.Contains(t, err.Error(), "is_owned is required")

	// Cleanup
	_, _ = db.ExecContext(ctx, "DELETE FROM user_books WHERE book_id = $1", bookID)
	_, _ = db.ExecContext(ctx, "DELETE FROM books WHERE id = $1", bookID)
}

// TestGetBooksCatalog_CollectionFilter teste le filtre par collection_id
func TestGetBooksCatalog_CollectionFilter(t *testing.T) {
	// Skip if not integration test
	if testing.Short() {
		t.Skip("Skipping integration test")
	}

	db := setupTestDB(t)
	defer db.Close()

	repo := NewBookRepository(db)
	ctx := context.Background()

	userID := uuid.New()

	// Test 1: Filtrer par Royaumes Oubliés
	roID := "22222222-2222-2222-2222-222222222222"
	filter := domain.BookFilter{
		CollectionID: &roID,
		Page:         1,
		Limit:        10,
	}

	result, err := repo.GetBooksCatalog(ctx, userID, filter)
	require.NoError(t, err)
	assert.NotNil(t, result)

	// Tous les livres doivent être Royaumes Oubliés
	for _, book := range result.Books {
		assert.Equal(t, roID, book.Book.CollectionID.String())
		assert.Nil(t, book.Book.Edition) // RO n'a pas d'edition
	}

	// Test 2: Filtrer par D&D 5e
	dndID := "33333333-3333-3333-3333-333333333333"
	filter.CollectionID = &dndID

	result, err = repo.GetBooksCatalog(ctx, userID, filter)
	require.NoError(t, err)
	assert.NotNil(t, result)

	// Tous les livres doivent être D&D 5e
	for _, book := range result.Books {
		assert.Equal(t, dndID, book.Book.CollectionID.String())
		assert.NotNil(t, book.Book.Edition) // D&D 5e a une edition
		assert.Equal(t, "D&D 5", *book.Book.Edition)
	}
}

// Helpers

func boolPtr(b bool) *bool {
	return &b
}

func setupTestDB(t *testing.T) *sqlx.DB {
	dsn := "host=localhost port=5432 user=collectoria password=collectoria dbname=collection_management sslmode=disable"
	db, err := sqlx.Connect("postgres", dsn)
	require.NoError(t, err, "Failed to connect to test database")
	return db
}
