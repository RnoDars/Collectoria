package application

import (
	"context"
	"fmt"
	"time"

	"collectoria/collection-management/internal/domain"

	"github.com/google/uuid"
)

type ActivityService struct {
	activityRepo domain.ActivityRepository
}

func NewActivityService(activityRepo domain.ActivityRepository) *ActivityService {
	return &ActivityService{
		activityRepo: activityRepo,
	}
}

// RecordCardActivity enregistre une activité liée à une carte
func (s *ActivityService) RecordCardActivity(
	ctx context.Context,
	userID uuid.UUID,
	activityType string,
	cardID uuid.UUID,
	metadata map[string]interface{},
) error {
	// Convert metadata from map[string]interface{} to map[string]string for domain.Activity
	stringMetadata := make(map[string]string)
	for k, v := range metadata {
		stringMetadata[k] = fmt.Sprintf("%v", v)
	}

	// Add user_id and card_id to metadata so repository can extract them
	stringMetadata["user_id"] = userID.String()
	stringMetadata["card_id"] = cardID.String()

	activity := &domain.Activity{
		ID:        uuid.New(),
		Type:      domain.ActivityType(activityType),
		Timestamp: time.Now(),
		Metadata:  stringMetadata,
	}

	return s.activityRepo.Create(ctx, activity)
}

// RecordBookActivity enregistre une activité liée à un livre
func (s *ActivityService) RecordBookActivity(
	ctx context.Context,
	userID uuid.UUID,
	activityType string,
	bookID uuid.UUID,
	metadata map[string]interface{},
) error {
	// Convert metadata from map[string]interface{} to map[string]string for domain.Activity
	stringMetadata := make(map[string]string)
	for k, v := range metadata {
		stringMetadata[k] = fmt.Sprintf("%v", v)
	}

	// Add user_id and book_id to metadata so repository can extract them
	stringMetadata["user_id"] = userID.String()
	stringMetadata["book_id"] = bookID.String()

	// Extract description from metadata
	description := ""
	if desc, ok := metadata["description"]; ok {
		description = fmt.Sprintf("%v", desc)
	}

	// Use the book title as the activity title, fall back to generic label
	bookTitle := ""
	if bt, ok := metadata["book_title"]; ok {
		bookTitle = fmt.Sprintf("%v", bt)
	}
	title := bookTitle
	if title == "" {
		switch activityType {
		case string(domain.ActivityBookAdded):
			title = "Ajout d'un roman"
		case string(domain.ActivityBookRemoved):
			title = "Retrait d'un roman"
		default:
			title = "Activité livre"
		}
	}

	activity := &domain.Activity{
		ID:          uuid.New(),
		Type:        domain.ActivityType(activityType),
		Title:       title,
		Description: description,
		Timestamp:   time.Now(),
		Metadata:    stringMetadata,
	}

	return s.activityRepo.Create(ctx, activity)
}

func (s *ActivityService) GetRecentActivities(ctx context.Context, userID uuid.UUID, limit, offset int) (*domain.ActivityFeed, error) {
	// For now, we don't support offset with the repository implementation
	// We'll implement pagination in Phase 2 if needed
	if limit <= 0 || limit > 100 {
		limit = 10
	}

	activities, err := s.activityRepo.GetRecentByUserID(ctx, userID, limit)
	if err != nil {
		return nil, fmt.Errorf("failed to get recent activities: %w", err)
	}

	// Convert []*Activity to []Activity for the feed
	activityList := make([]domain.Activity, len(activities))
	for i, a := range activities {
		activityList[i] = *a
	}

	return &domain.ActivityFeed{
		Activities: activityList,
		TotalCount: len(activityList),
		HasMore:    false, // We don't support pagination yet
	}, nil
}

func (s *ActivityService) GetGrowthStats(ctx context.Context, userID uuid.UUID, period, granularity string) (*domain.GrowthStats, error) {
	now := time.Now()
	dataPoints := make([]domain.GrowthDataPoint, 6)
	cardsPerMonth := []int{0, 5, 8, 4, 3, 4}
	total := 0

	for i := 0; i < 6; i++ {
		month := now.AddDate(0, -(5 - i), 0)
		total += cardsPerMonth[i]
		dataPoints[i] = domain.GrowthDataPoint{
			Period:     month.Format("2006-01"),
			Label:      month.Format("Jan"),
			CardsAdded: cardsPerMonth[i],
			TotalCards: total,
		}
	}

	lastMonth := float64(cardsPerMonth[5])
	avg := float64(cardsPerMonth[0]+cardsPerMonth[1]+cardsPerMonth[2]+cardsPerMonth[3]+cardsPerMonth[4]) / 5.0
	growthRate := 0.0
	if avg > 0 {
		growthRate = ((lastMonth - avg) / avg) * 100
	}

	trend := "stable"
	if growthRate > 5 {
		trend = "increasing"
	} else if growthRate < -5 {
		trend = "decreasing"
	}

	return &domain.GrowthStats{
		Period:               period,
		Granularity:          granularity,
		DataPoints:           dataPoints,
		GrowthRatePercentage: growthRate,
		Trend:                trend,
	}, nil
}
