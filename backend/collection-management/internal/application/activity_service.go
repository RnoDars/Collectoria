package application

import (
	"context"
	"time"

	"collectoria/collection-management/internal/domain"

	"github.com/google/uuid"
)

type ActivityService struct{}

func NewActivityService() *ActivityService {
	return &ActivityService{}
}

func (s *ActivityService) GetRecentActivities(ctx context.Context, userID uuid.UUID, limit, offset int) (*domain.ActivityFeed, error) {
	meccgID := uuid.MustParse("00000000-0000-0000-0000-000000000010")

	all := []domain.Activity{
		{
			ID:                    uuid.New(),
			Type:                  domain.ActivityCardAdded,
			Title:                 "Gandalf le Gris ajouté",
			Description:           "Carte ajoutée à la collection Middle-earth CCG",
			Timestamp:             time.Now().Add(-2 * time.Hour),
			Icon:                  "plus-circle",
			RelatedCollectionID:   &meccgID,
			RelatedCollectionName: "Middle-earth CCG",
			Metadata:              map[string]string{"card_name": "Gandalf le Gris"},
		},
		{
			ID:                    uuid.New(),
			Type:                  domain.ActivityMilestoneReached,
			Title:                 "60% de complétion atteint",
			Description:           "Vous avez atteint 60% de complétion sur Middle-earth CCG",
			Timestamp:             time.Now().Add(-24 * time.Hour),
			Icon:                  "trophy",
			RelatedCollectionID:   &meccgID,
			RelatedCollectionName: "Middle-earth CCG",
			Metadata:              map[string]string{"percentage": "60"},
		},
		{
			ID:                    uuid.New(),
			Type:                  domain.ActivityCardAdded,
			Title:                 "Gripoil ajouté",
			Description:           "Carte ajoutée à la collection Middle-earth CCG",
			Timestamp:             time.Now().Add(-48 * time.Hour),
			Icon:                  "plus-circle",
			RelatedCollectionID:   &meccgID,
			RelatedCollectionName: "Middle-earth CCG",
			Metadata:              map[string]string{"card_name": "Gripoil"},
		},
		{
			ID:                    uuid.New(),
			Type:                  domain.ActivityImportCompleted,
			Title:                 "Import MECCG terminé",
			Description:           "40 cartes importées dans Middle-earth CCG",
			Timestamp:             time.Now().Add(-72 * time.Hour),
			Icon:                  "download",
			RelatedCollectionID:   &meccgID,
			RelatedCollectionName: "Middle-earth CCG",
			Metadata:              map[string]string{"count": "40"},
		},
		{
			ID:                    uuid.New(),
			Type:                  domain.ActivityCardAdded,
			Title:                 "L'Anneau Unique ajouté",
			Description:           "Carte ajoutée à la collection Middle-earth CCG",
			Timestamp:             time.Now().Add(-96 * time.Hour),
			Icon:                  "plus-circle",
			RelatedCollectionID:   &meccgID,
			RelatedCollectionName: "Middle-earth CCG",
			Metadata:              map[string]string{"card_name": "L'Anneau Unique"},
		},
	}

	start := offset
	if start >= len(all) {
		return &domain.ActivityFeed{Activities: []domain.Activity{}, TotalCount: len(all), HasMore: false}, nil
	}
	end := start + limit
	if end > len(all) {
		end = len(all)
	}

	page := all[start:end]
	return &domain.ActivityFeed{
		Activities: page,
		TotalCount: len(all),
		HasMore:    end < len(all),
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
