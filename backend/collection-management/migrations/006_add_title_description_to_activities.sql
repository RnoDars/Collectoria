-- Migration: Add title and description columns to activities table
-- Description: Adds human-readable title and description fields for better activity display
-- Date: 2026-04-24
-- Issue: Activities were showing empty title/description in frontend

ALTER TABLE activities
    ADD COLUMN title VARCHAR(255),
    ADD COLUMN description TEXT;

-- Comments for documentation
COMMENT ON COLUMN activities.title IS 'Human-readable title of the activity (e.g., "Ajout d''un roman")';
COMMENT ON COLUMN activities.description IS 'Detailed description of the activity (e.g., "Ajout du roman: Valombre")';
