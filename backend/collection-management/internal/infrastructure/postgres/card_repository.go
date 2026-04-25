package postgres

import (
	"context"
	"fmt"
	"strings"

	"collectoria/collection-management/internal/domain"

	"github.com/google/uuid"
	"github.com/jmoiron/sqlx"
)

type CardRepository struct {
	db *sqlx.DB
}

func NewCardRepository(db *sqlx.DB) *CardRepository {
	return &CardRepository{db: db}
}

func (r *CardRepository) GetAllCards(ctx context.Context) ([]domain.Card, error) {
	return nil, nil
}

func (r *CardRepository) GetCardByID(ctx context.Context, id uuid.UUID) (*domain.Card, error) {
	query := `
		SELECT id, collection_id, name_en, name_fr, card_type, series, rarity, created_at, updated_at
		FROM cards
		WHERE id = $1`

	var card domain.Card
	err := r.db.GetContext(ctx, &card, query, id)
	if err != nil {
		return nil, err
	}

	return &card, nil
}

func (r *CardRepository) GetCardsByCollectionID(ctx context.Context, collectionID uuid.UUID) ([]domain.Card, error) {
	return nil, nil
}

func (r *CardRepository) GetUserCards(ctx context.Context, userID uuid.UUID) ([]domain.UserCard, error) {
	return nil, nil
}

func (r *CardRepository) GetUserCardsOwned(ctx context.Context, userID uuid.UUID) ([]domain.Card, error) {
	return nil, nil
}

func (r *CardRepository) IsCardOwned(ctx context.Context, userID, cardID uuid.UUID) (bool, error) {
	return false, nil
}

func (r *CardRepository) GetCardsCatalog(ctx context.Context, userID uuid.UUID, filter domain.CardFilter) (*domain.CardPage, error) {
	args := []interface{}{userID}
	idx := 2

	where := []string{}

	if filter.Search != "" {
		where = append(where, fmt.Sprintf("(LOWER(c.name_fr) LIKE LOWER($%d) OR LOWER(c.name_en) LIKE LOWER($%d))", idx, idx+1))
		like := "%" + strings.ToLower(filter.Search) + "%"
		args = append(args, like, like)
		idx += 2
	}
	if filter.Series != "" {
		where = append(where, fmt.Sprintf("c.series = $%d", idx))
		args = append(args, filter.Series)
		idx++
	}
	if filter.Type != "" {
		where = append(where, fmt.Sprintf("c.card_type = $%d", idx))
		args = append(args, filter.Type)
		idx++
	}
	if filter.Rarity != "" {
		where = append(where, fmt.Sprintf("c.rarity LIKE $%d", idx))
		args = append(args, filter.Rarity+"%")
		idx++
	}
	if filter.Owned == "true" {
		where = append(where, "uc.is_owned = true")
	} else if filter.Owned == "false" {
		where = append(where, "(uc.is_owned = false OR uc.card_id IS NULL)")
	}

	whereClause := ""
	if len(where) > 0 {
		whereClause = "AND " + strings.Join(where, " AND ")
	}

	countQuery := fmt.Sprintf(`
		SELECT COUNT(*)
		FROM cards c
		LEFT JOIN user_cards uc ON c.id = uc.card_id AND uc.user_id = $1
		WHERE c.collection_id IN (
			SELECT collection_id FROM user_collections WHERE user_id = $1
		) %s`, whereClause)

	var total int
	if err := r.db.GetContext(ctx, &total, countQuery, args...); err != nil {
		return nil, err
	}

	// Whitelist stricte — protection SQL injection
	var sortColumnWhitelist = map[string]string{
		"name_fr": "c.name_fr",
		"name_en": "c.name_en",
	}

	sortCol, ok := sortColumnWhitelist[filter.SortBy]
	if !ok {
		sortCol = "c.name_fr"
	}
	sortDir := "ASC"
	if strings.ToLower(filter.SortDir) == "desc" {
		sortDir = "DESC"
	}
	// unaccent : normalise accents (é→e, à→a) et œ→oe
	// REPLACE : ignore les guillemets " dans l'ordre alphabétique
	orderClause := fmt.Sprintf("ORDER BY unaccent(REPLACE(%s, '\"', '')) %s NULLS FIRST", sortCol, sortDir)

	offset := (filter.Page - 1) * filter.Limit
	args = append(args, filter.Limit, offset)

	dataQuery := fmt.Sprintf(`
		SELECT
			c.id, c.collection_id, c.name_en, c.name_fr, c.card_type, c.series, c.rarity,
			c.created_at, c.updated_at,
			COALESCE(uc.is_owned, false) AS is_owned
		FROM cards c
		LEFT JOIN user_cards uc ON c.id = uc.card_id AND uc.user_id = $1
		WHERE c.collection_id IN (
			SELECT collection_id FROM user_collections WHERE user_id = $1
		) %s
		%s
		LIMIT $%d OFFSET $%d`, whereClause, orderClause, idx, idx+1)

	type row struct {
		ID           uuid.UUID `db:"id"`
		CollectionID uuid.UUID `db:"collection_id"`
		NameEN       string    `db:"name_en"`
		NameFR       string    `db:"name_fr"`
		CardType     string    `db:"card_type"`
		Series       string    `db:"series"`
		Rarity       string    `db:"rarity"`
		CreatedAt    interface{} `db:"created_at"`
		UpdatedAt    interface{} `db:"updated_at"`
		IsOwned      bool      `db:"is_owned"`
	}

	var rows []row
	if err := r.db.SelectContext(ctx, &rows, dataQuery, args...); err != nil {
		return nil, err
	}

	cards := make([]domain.CardWithOwnership, len(rows))
	for i, r := range rows {
		cards[i] = domain.CardWithOwnership{
			Card: domain.Card{
				ID:           r.ID,
				CollectionID: r.CollectionID,
				NameEN:       r.NameEN,
				NameFR:       r.NameFR,
				CardType:     r.CardType,
				Series:       r.Series,
				Rarity:       r.Rarity,
			},
			IsOwned: r.IsOwned,
		}
	}

	return &domain.CardPage{
		Cards:   cards,
		Total:   total,
		Page:    filter.Page,
		HasMore: offset+len(rows) < total,
	}, nil
}

// UpdateUserCardPossession met à jour le statut de possession d'une carte (UPSERT)
func (r *CardRepository) UpdateUserCardPossession(ctx context.Context, userID, cardID uuid.UUID, isOwned bool) error {
	query := `
		INSERT INTO user_cards (user_id, card_id, is_owned, created_at, updated_at)
		VALUES ($1, $2, $3, NOW(), NOW())
		ON CONFLICT (user_id, card_id)
		DO UPDATE SET is_owned = $3, updated_at = NOW()`

	_, err := r.db.ExecContext(ctx, query, userID, cardID, isOwned)
	return err
}

// Vérification statique que CardRepository implémente domain.CardRepository
var _ domain.CardRepository = (*CardRepository)(nil)

