package domain

import (
	"context"
	"time"

	"github.com/google/uuid"
)

type ActivityType string

const (
	ActivityCardAdded              ActivityType = "card_added"
	ActivityCardRemoved            ActivityType = "card_removed"
	ActivityCardPossessionChanged  ActivityType = "card_possession_changed"
	ActivityMilestoneReached       ActivityType = "milestone_reached"
	ActivityImportCompleted        ActivityType = "import_completed"
)

type EntityType string

const (
	EntityTypeCard       EntityType = "card"
	EntityTypeCollection EntityType = "collection"
)

type Activity struct {
	ID                    uuid.UUID
	Type                  ActivityType
	Title                 string
	Description           string
	Timestamp             time.Time
	Icon                  string
	RelatedCollectionID   *uuid.UUID
	RelatedCollectionName string
	Metadata              map[string]string
}

type ActivityFeed struct {
	Activities  []Activity
	TotalCount  int
	HasMore     bool
}

type GrowthDataPoint struct {
	Period    string
	Label     string
	CardsAdded int
	TotalCards int
}

type GrowthStats struct {
	Period             string
	Granularity        string
	DataPoints         []GrowthDataPoint
	GrowthRatePercentage float64
	Trend              string
}

// ActivityRepository defines the interface for activity persistence
type ActivityRepository interface {
	Create(ctx context.Context, activity *Activity) error
	GetRecentByUserID(ctx context.Context, userID uuid.UUID, limit int) ([]*Activity, error)
}
