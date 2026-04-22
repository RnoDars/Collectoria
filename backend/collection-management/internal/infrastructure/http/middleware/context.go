package middleware

import (
	"context"
	"fmt"

	"github.com/google/uuid"
)

// contextKey est un type personnalisé pour les clés de context
type contextKey string

// UserIDKey est la clé pour stocker le userID dans le context
const UserIDKey contextKey = "user_id"

// WithUserID ajoute le userID au context
func WithUserID(ctx context.Context, userID uuid.UUID) context.Context {
	return context.WithValue(ctx, UserIDKey, userID)
}

// GetUserID extrait le userID du context
func GetUserID(ctx context.Context) (uuid.UUID, error) {
	userID, ok := ctx.Value(UserIDKey).(uuid.UUID)
	if !ok {
		return uuid.Nil, fmt.Errorf("user_id not found in context")
	}
	return userID, nil
}
