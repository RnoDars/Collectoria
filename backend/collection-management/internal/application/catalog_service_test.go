package application_test

import (
	"context"
	"testing"

	"collectoria/collection-management/internal/application"
	"collectoria/collection-management/internal/domain"

	"github.com/google/uuid"
	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/require"
)

type mockCardRepository struct {
	cards []domain.CardWithOwnership
	total int
}

func (m *mockCardRepository) GetAllCards(ctx context.Context) ([]domain.Card, error) {
	return nil, nil
}
func (m *mockCardRepository) GetCardByID(ctx context.Context, id uuid.UUID) (*domain.Card, error) {
	return nil, nil
}
func (m *mockCardRepository) GetCardsByCollectionID(ctx context.Context, id uuid.UUID) ([]domain.Card, error) {
	return nil, nil
}
func (m *mockCardRepository) GetUserCards(ctx context.Context, id uuid.UUID) ([]domain.UserCard, error) {
	return nil, nil
}
func (m *mockCardRepository) GetUserCardsOwned(ctx context.Context, id uuid.UUID) ([]domain.Card, error) {
	return nil, nil
}
func (m *mockCardRepository) IsCardOwned(ctx context.Context, userID, cardID uuid.UUID) (bool, error) {
	return false, nil
}
func (m *mockCardRepository) GetCardsCatalog(ctx context.Context, userID uuid.UUID, filter domain.CardFilter) (*domain.CardPage, error) {
	end := filter.Page * filter.Limit
	start := end - filter.Limit
	if start >= len(m.cards) {
		return &domain.CardPage{Cards: []domain.CardWithOwnership{}, Total: m.total, Page: filter.Page, HasMore: false}, nil
	}
	if end > len(m.cards) {
		end = len(m.cards)
	}
	return &domain.CardPage{
		Cards:   m.cards[start:end],
		Total:   m.total,
		Page:    filter.Page,
		HasMore: end < len(m.cards),
	}, nil
}

func makeMockCards(n int) []domain.CardWithOwnership {
	cards := make([]domain.CardWithOwnership, n)
	for i := range cards {
		cards[i] = domain.CardWithOwnership{
			Card:    domain.Card{NameEN: "Card", NameFR: "Carte", Series: "Les Sorciers", Rarity: "R1", CardType: "Héros / Personnage"},
			IsOwned: i%2 == 0,
		}
	}
	return cards
}

func TestCatalogService_GetCatalog_ReturnsFirstPage(t *testing.T) {
	repo := &mockCardRepository{cards: makeMockCards(100), total: 100}
	service := application.NewCatalogService(repo)
	userID := uuid.MustParse("00000000-0000-0000-0000-000000000001")

	page, err := service.GetCatalog(context.Background(), userID, domain.CardFilter{Page: 1, Limit: 50})

	require.NoError(t, err)
	assert.Len(t, page.Cards, 50)
	assert.Equal(t, 100, page.Total)
	assert.Equal(t, 1, page.Page)
	assert.True(t, page.HasMore)
}

func TestCatalogService_GetCatalog_LastPageHasNoMore(t *testing.T) {
	repo := &mockCardRepository{cards: makeMockCards(75), total: 75}
	service := application.NewCatalogService(repo)
	userID := uuid.MustParse("00000000-0000-0000-0000-000000000001")

	page, err := service.GetCatalog(context.Background(), userID, domain.CardFilter{Page: 2, Limit: 50})

	require.NoError(t, err)
	assert.Len(t, page.Cards, 25)
	assert.False(t, page.HasMore)
}

func TestCatalogService_GetCatalog_DefaultsPageAndLimit(t *testing.T) {
	repo := &mockCardRepository{cards: makeMockCards(10), total: 10}
	service := application.NewCatalogService(repo)
	userID := uuid.MustParse("00000000-0000-0000-0000-000000000001")

	page, err := service.GetCatalog(context.Background(), userID, domain.CardFilter{})

	require.NoError(t, err)
	assert.Equal(t, 1, page.Page)
	assert.NotEmpty(t, page.Cards)
}
