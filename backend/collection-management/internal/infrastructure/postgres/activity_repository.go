package postgres

import (
	"context"
	"encoding/json"
	"fmt"

	"collectoria/collection-management/internal/domain"

	"github.com/google/uuid"
	"github.com/jmoiron/sqlx"
)

type PostgresActivityRepository struct {
	db *sqlx.DB
}

func NewPostgresActivityRepository(db *sqlx.DB) *PostgresActivityRepository {
	return &PostgresActivityRepository{db: db}
}

// Create inserts a new activity into the database
func (r *PostgresActivityRepository) Create(ctx context.Context, activity *domain.Activity) error {
	// Convert metadata map to JSONB
	metadataJSON, err := json.Marshal(activity.Metadata)
	if err != nil {
		return fmt.Errorf("failed to marshal metadata: %w", err)
	}

	query := `
		INSERT INTO activities (id, user_id, activity_type, entity_type, entity_id, title, description, metadata, created_at)
		VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9)
	`

	// Extract user_id and entity_id from metadata
	userIDStr, _ := activity.Metadata["user_id"]
	cardIDStr, _ := activity.Metadata["card_id"]
	bookIDStr, _ := activity.Metadata["book_id"]

	userID, err := uuid.Parse(userIDStr)
	if err != nil {
		userID = activity.ID // Fallback to activity ID
	}

	// Try card_id first, then book_id
	entityID, err := uuid.Parse(cardIDStr)
	if err != nil {
		entityID, err = uuid.Parse(bookIDStr)
		if err != nil {
			entityID = activity.ID // Fallback to activity ID
		}
	}

	// Determine entity_type from metadata or activity type
	entityType := domain.EntityTypeCard
	if bookIDStr != "" {
		entityType = domain.EntityTypeBook
	}

	_, err = r.db.ExecContext(
		ctx,
		query,
		activity.ID,
		userID,
		activity.Type,
		entityType,
		entityID,
		activity.Title,       // Now persisting title
		activity.Description, // Now persisting description
		metadataJSON,
		activity.Timestamp,
	)

	if err != nil {
		return fmt.Errorf("failed to create activity: %w", err)
	}

	return nil
}

// GetRecentByUserID retrieves the most recent activities for a user
func (r *PostgresActivityRepository) GetRecentByUserID(ctx context.Context, userID uuid.UUID, limit int) ([]*domain.Activity, error) {
	if limit <= 0 || limit > 100 {
		limit = 10 // Default limit
	}

	query := `
		SELECT id, user_id, activity_type, entity_type, entity_id, title, description, metadata, created_at
		FROM activities
		WHERE user_id = $1
		ORDER BY created_at DESC
		LIMIT $2
	`

	rows, err := r.db.QueryContext(ctx, query, userID, limit)
	if err != nil {
		return nil, fmt.Errorf("failed to query activities: %w", err)
	}
	defer rows.Close()

	activities := []*domain.Activity{}

	for rows.Next() {
		var a domain.Activity
		var activityType string
		var entityType string
		var scannedUserID uuid.UUID
		var scannedEntityID uuid.UUID
		var title, description *string // Use pointers to handle NULL values
		var metadataJSON []byte

		err := rows.Scan(
			&a.ID,
			&scannedUserID,
			&activityType,
			&entityType,
			&scannedEntityID,
			&title,
			&description,
			&metadataJSON,
			&a.Timestamp,
		)
		if err != nil {
			return nil, fmt.Errorf("failed to scan activity row: %w", err)
		}

		a.Type = domain.ActivityType(activityType)

		// Set title and description from database (NULL-safe)
		if title != nil {
			a.Title = *title
		}
		if description != nil {
			a.Description = *description
		}

		// Unmarshal metadata
		metadata := make(map[string]string)
		if len(metadataJSON) > 0 {
			if err := json.Unmarshal(metadataJSON, &metadata); err != nil {
				return nil, fmt.Errorf("failed to unmarshal metadata: %w", err)
			}
		}
		a.Metadata = metadata

		// Fallback: Build Title and Description from metadata if not in DB (for old records)
		if a.Title == "" {
			if cardName, ok := metadata["card_name"]; ok {
				if activityType == string(domain.ActivityCardAdded) {
					a.Title = fmt.Sprintf("Carte %s ajoutée", cardName)
					a.Description = fmt.Sprintf("Carte ajoutée à votre collection")
				} else if activityType == string(domain.ActivityCardRemoved) {
					a.Title = fmt.Sprintf("Carte %s retirée", cardName)
					a.Description = fmt.Sprintf("Carte retirée de votre collection")
				}
			}
			if bookTitle, ok := metadata["book_title"]; ok {
				if activityType == string(domain.ActivityBookAdded) {
					a.Title = "Ajout d'un roman"
					a.Description = fmt.Sprintf("Ajout du roman: %s", bookTitle)
				} else if activityType == string(domain.ActivityBookRemoved) {
					a.Title = "Retrait d'un roman"
					a.Description = fmt.Sprintf("Retrait du roman: %s", bookTitle)
				}
			}
		}

		// Set icon based on activity type
		switch domain.ActivityType(activityType) {
		case domain.ActivityCardAdded:
			a.Icon = "plus-circle"
		case domain.ActivityCardRemoved:
			a.Icon = "minus-circle"
		case domain.ActivityCardPossessionChanged:
			a.Icon = "check-circle"
		default:
			a.Icon = "info-circle"
		}

		// Set RelatedCollectionName if present in metadata
		if collectionName, ok := metadata["collection_name"]; ok {
			a.RelatedCollectionName = collectionName
		}

		activities = append(activities, &a)
	}

	if err = rows.Err(); err != nil {
		return nil, fmt.Errorf("error iterating activity rows: %w", err)
	}

	return activities, nil
}

// Ensure PostgresActivityRepository implements domain.ActivityRepository
var _ domain.ActivityRepository = (*PostgresActivityRepository)(nil)
