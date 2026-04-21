-- Migration: Create activities table for activity feed
-- Description: Stores user activities for the recent activity feed (Phase 1 implementation)
-- Date: 2026-04-21

CREATE TABLE IF NOT EXISTS activities (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL,
    activity_type VARCHAR(50) NOT NULL,
    entity_type VARCHAR(50) NOT NULL,
    entity_id UUID NOT NULL,
    metadata JSONB DEFAULT '{}'::jsonb,
    created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW()
);

-- Index for efficient querying by user and time (most recent first)
CREATE INDEX idx_activities_user_id_created_at ON activities(user_id, created_at DESC);

-- Index for querying by entity (e.g., all activities for a specific card)
CREATE INDEX idx_activities_entity ON activities(entity_type, entity_id);

-- Comments for documentation
COMMENT ON TABLE activities IS 'User activities for recent activity feed (Phase 1)';
COMMENT ON COLUMN activities.id IS 'Unique identifier for the activity';
COMMENT ON COLUMN activities.user_id IS 'User who performed the activity';
COMMENT ON COLUMN activities.activity_type IS 'Type of activity: card_possession_changed, card_added, card_removed, etc.';
COMMENT ON COLUMN activities.entity_type IS 'Type of entity involved: card, collection, etc.';
COMMENT ON COLUMN activities.entity_id IS 'ID of the entity involved';
COMMENT ON COLUMN activities.metadata IS 'Additional context (card_name, collection_name, is_owned, etc.)';
COMMENT ON COLUMN activities.created_at IS 'Timestamp when the activity occurred';
