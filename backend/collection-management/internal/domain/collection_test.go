package domain

import (
	"testing"
	"time"

	"github.com/google/uuid"
	"github.com/stretchr/testify/assert"
)

func TestCollectionSummary_CalculateCompletionPercentage(t *testing.T) {
	tests := []struct {
		name                 string
		totalCardsOwned      int
		totalCardsAvailable  int
		expectedPercentage   float64
	}{
		{
			name:                 "60% completion",
			totalCardsOwned:      24,
			totalCardsAvailable:  40,
			expectedPercentage:   60.0,
		},
		{
			name:                 "100% completion",
			totalCardsOwned:      40,
			totalCardsAvailable:  40,
			expectedPercentage:   100.0,
		},
		{
			name:                 "0% completion",
			totalCardsOwned:      0,
			totalCardsAvailable:  40,
			expectedPercentage:   0.0,
		},
		{
			name:                 "Empty collection",
			totalCardsOwned:      0,
			totalCardsAvailable:  0,
			expectedPercentage:   0.0,
		},
		{
			name:                 "Partial completion",
			totalCardsOwned:      15,
			totalCardsAvailable:  40,
			expectedPercentage:   37.5,
		},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			summary := &CollectionSummary{
				UserID:              uuid.New(),
				TotalCardsOwned:     tt.totalCardsOwned,
				TotalCardsAvailable: tt.totalCardsAvailable,
				LastUpdated:         time.Now(),
			}

			summary.CalculateCompletionPercentage()

			assert.Equal(t, tt.expectedPercentage, summary.CompletionPercentage)
		})
	}
}

func TestCollectionSummary_TotalCardsOwned(t *testing.T) {
	summary := &CollectionSummary{
		UserID:              uuid.New(),
		TotalCardsOwned:     24,
		TotalCardsAvailable: 40,
		LastUpdated:         time.Now(),
	}

	assert.Equal(t, 24, summary.TotalCardsOwned)
	assert.Equal(t, 40, summary.TotalCardsAvailable)
}
