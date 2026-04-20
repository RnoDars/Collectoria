package domain

import (
	"time"

	"github.com/google/uuid"
)

type ActivityType string

const (
	ActivityCardAdded       ActivityType = "card_added"
	ActivityMilestoneReached ActivityType = "milestone_reached"
	ActivityImportCompleted  ActivityType = "import_completed"
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
