package application

import (
	"context"
	"errors"
	"testing"
	"time"

	"collectoria/collection-management/internal/domain"

	"github.com/google/uuid"
	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/mock"
)

// MockBookRepository est un mock du BookRepository
type MockBookRepository struct {
	mock.Mock
}

func (m *MockBookRepository) GetBookByID(ctx context.Context, id uuid.UUID) (*domain.Book, error) {
	args := m.Called(ctx, id)
	if args.Get(0) == nil {
		return nil, args.Error(1)
	}
	return args.Get(0).(*domain.Book), args.Error(1)
}

func (m *MockBookRepository) GetUserBook(ctx context.Context, userID, bookID uuid.UUID) (*domain.UserBook, error) {
	args := m.Called(ctx, userID, bookID)
	if args.Get(0) == nil {
		return nil, args.Error(1)
	}
	return args.Get(0).(*domain.UserBook), args.Error(1)
}

func (m *MockBookRepository) UpdateUserBook(ctx context.Context, userID, bookID uuid.UUID, isOwned bool) error {
	args := m.Called(ctx, userID, bookID, isOwned)
	return args.Error(0)
}

func (m *MockBookRepository) GetBooksCatalog(ctx context.Context, userID uuid.UUID, filter domain.BookFilter) (*domain.BookPage, error) {
	args := m.Called(ctx, userID, filter)
	if args.Get(0) == nil {
		return nil, args.Error(1)
	}
	return args.Get(0).(*domain.BookPage), args.Error(1)
}

func TestToggleBookPossession_Success_SetOwned(t *testing.T) {
	// Arrange
	mockRepo := new(MockBookRepository)
	mockActivityRepo := new(MockActivityRepository)
	activityService := NewActivityService(mockActivityRepo)
	service := NewBookService(mockRepo, activityService)

	// Mock activity recording (best effort - can fail silently)
	mockActivityRepo.On("Create", mock.Anything, mock.Anything).Return(nil)

	ctx := context.Background()
	userID := uuid.MustParse("00000000-0000-0000-0000-000000000001")
	bookID := uuid.New()
	collectionID := uuid.MustParse("22222222-2222-2222-2222-222222222222")

	existingBook := &domain.Book{
		ID:              bookID,
		CollectionID:    collectionID,
		Number:          "1",
		Title:           "Valombre",
		Author:          "Richard AWLINSON",
		PublicationDate: time.Date(1994, 3, 1, 0, 0, 0, 0, time.UTC),
		BookType:        "roman",
	}

	mockRepo.On("GetBookByID", ctx, bookID).Return(existingBook, nil)
	mockRepo.On("UpdateUserBook", ctx, userID, bookID, true).Return(nil)

	// Act
	result, err := service.ToggleBookPossession(ctx, userID, bookID, true)

	// Assert
	assert.NoError(t, err)
	assert.NotNil(t, result)
	assert.Equal(t, bookID, result.Book.ID)
	assert.Equal(t, "Valombre", result.Book.Title)
	assert.Equal(t, "Richard AWLINSON", result.Book.Author)
	assert.True(t, result.IsOwned)
	mockRepo.AssertExpectations(t)
}

func TestToggleBookPossession_Success_SetNotOwned(t *testing.T) {
	// Arrange
	mockRepo := new(MockBookRepository)
	mockActivityRepo := new(MockActivityRepository)
	activityService := NewActivityService(mockActivityRepo)
	service := NewBookService(mockRepo, activityService)

	// Mock activity recording (best effort - can fail silently)
	mockActivityRepo.On("Create", mock.Anything, mock.Anything).Return(nil)

	ctx := context.Background()
	userID := uuid.MustParse("00000000-0000-0000-0000-000000000001")
	bookID := uuid.New()
	collectionID := uuid.MustParse("22222222-2222-2222-2222-222222222222")

	existingBook := &domain.Book{
		ID:              bookID,
		CollectionID:    collectionID,
		Number:          "1",
		Title:           "Valombre",
		Author:          "Richard AWLINSON",
		PublicationDate: time.Date(1994, 3, 1, 0, 0, 0, 0, time.UTC),
		BookType:        "roman",
	}

	mockRepo.On("GetBookByID", ctx, bookID).Return(existingBook, nil)
	mockRepo.On("UpdateUserBook", ctx, userID, bookID, false).Return(nil)

	// Act
	result, err := service.ToggleBookPossession(ctx, userID, bookID, false)

	// Assert
	assert.NoError(t, err)
	assert.NotNil(t, result)
	assert.Equal(t, bookID, result.Book.ID)
	assert.False(t, result.IsOwned)
	mockRepo.AssertExpectations(t)
}

func TestToggleBookPossession_BookNotFound(t *testing.T) {
	// Arrange
	mockRepo := new(MockBookRepository)
	mockActivityRepo := new(MockActivityRepository)
	activityService := NewActivityService(mockActivityRepo)
	service := NewBookService(mockRepo, activityService)

	ctx := context.Background()
	userID := uuid.MustParse("00000000-0000-0000-0000-000000000001")
	bookID := uuid.New()

	mockRepo.On("GetBookByID", ctx, bookID).Return(nil, errors.New("book not found"))

	// Act
	result, err := service.ToggleBookPossession(ctx, userID, bookID, true)

	// Assert
	assert.Error(t, err)
	assert.Nil(t, result)
	assert.Contains(t, err.Error(), "book not found")
	mockRepo.AssertExpectations(t)
}

func TestToggleBookPossession_Idempotent(t *testing.T) {
	// Arrange
	mockRepo := new(MockBookRepository)
	mockActivityRepo := new(MockActivityRepository)
	activityService := NewActivityService(mockActivityRepo)
	service := NewBookService(mockRepo, activityService)

	// Mock activity recording (best effort - can fail silently)
	mockActivityRepo.On("Create", mock.Anything, mock.Anything).Return(nil)

	ctx := context.Background()
	userID := uuid.MustParse("00000000-0000-0000-0000-000000000001")
	bookID := uuid.New()
	collectionID := uuid.MustParse("22222222-2222-2222-2222-222222222222")

	existingBook := &domain.Book{
		ID:              bookID,
		CollectionID:    collectionID,
		Number:          "1",
		Title:           "Valombre",
		Author:          "Richard AWLINSON",
		PublicationDate: time.Date(1994, 3, 1, 0, 0, 0, 0, time.UTC),
		BookType:        "roman",
	}

	mockRepo.On("GetBookByID", ctx, bookID).Return(existingBook, nil)
	mockRepo.On("UpdateUserBook", ctx, userID, bookID, true).Return(nil)

	// Act - appeler deux fois avec la même valeur
	result1, err1 := service.ToggleBookPossession(ctx, userID, bookID, true)
	result2, err2 := service.ToggleBookPossession(ctx, userID, bookID, true)

	// Assert - les deux appels doivent réussir
	assert.NoError(t, err1)
	assert.NoError(t, err2)
	assert.NotNil(t, result1)
	assert.NotNil(t, result2)
	assert.Equal(t, result1.Book.ID, result2.Book.ID)
	assert.True(t, result1.IsOwned)
	assert.True(t, result2.IsOwned)
	mockRepo.AssertExpectations(t)
}

func TestToggleBookPossession_RepositoryError(t *testing.T) {
	// Arrange
	mockRepo := new(MockBookRepository)
	mockActivityRepo := new(MockActivityRepository)
	activityService := NewActivityService(mockActivityRepo)
	service := NewBookService(mockRepo, activityService)

	ctx := context.Background()
	userID := uuid.MustParse("00000000-0000-0000-0000-000000000001")
	bookID := uuid.New()
	collectionID := uuid.MustParse("22222222-2222-2222-2222-222222222222")

	existingBook := &domain.Book{
		ID:              bookID,
		CollectionID:    collectionID,
		Number:          "1",
		Title:           "Valombre",
		Author:          "Richard AWLINSON",
		PublicationDate: time.Date(1994, 3, 1, 0, 0, 0, 0, time.UTC),
		BookType:        "roman",
	}

	mockRepo.On("GetBookByID", ctx, bookID).Return(existingBook, nil)
	mockRepo.On("UpdateUserBook", ctx, userID, bookID, true).Return(errors.New("database error"))

	// Act
	result, err := service.ToggleBookPossession(ctx, userID, bookID, true)

	// Assert
	assert.Error(t, err)
	assert.Nil(t, result)
	assert.Contains(t, err.Error(), "database error")
	mockRepo.AssertExpectations(t)
}

func TestGetBooksCatalog_Success(t *testing.T) {
	// Arrange
	mockRepo := new(MockBookRepository)
	mockActivityRepo := new(MockActivityRepository)
	activityService := NewActivityService(mockActivityRepo)
	service := NewBookService(mockRepo, activityService)

	ctx := context.Background()
	userID := uuid.MustParse("00000000-0000-0000-0000-000000000001")
	collectionID := uuid.MustParse("22222222-2222-2222-2222-222222222222")

	filter := domain.BookFilter{
		Search: "Valombre",
		Page:   1,
		Limit:  10,
	}

	expectedBooks := []domain.BookWithOwnership{
		{
			Book: domain.Book{
				ID:           uuid.New(),
				CollectionID: collectionID,
				Number:       "1",
				Title:        "Valombre",
				Author:       "Richard AWLINSON",
				BookType:     "roman",
			},
			IsOwned: true,
		},
	}

	expectedPage := &domain.BookPage{
		Books:   expectedBooks,
		Total:   1,
		Page:    1,
		HasMore: false,
	}

	mockRepo.On("GetBooksCatalog", ctx, userID, filter).Return(expectedPage, nil)

	// Act
	result, err := service.GetBooksCatalog(ctx, userID, filter)

	// Assert
	assert.NoError(t, err)
	assert.NotNil(t, result)
	assert.Equal(t, 1, result.Total)
	assert.Equal(t, 1, len(result.Books))
	assert.Equal(t, "Valombre", result.Books[0].Book.Title)
	mockRepo.AssertExpectations(t)
}
