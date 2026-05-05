#!/bin/bash
#
# migrate-db.sh - Apply Database Migrations
#
# Description:
#   Applies SQL migrations from the migrations directory in order
#   Tracks applied migrations and supports rollback on failure
#
# Usage:
#   ./migrate-db.sh [OPTIONS]
#
# Options:
#   --dry-run         Show which migrations would be applied
#   --force           Apply migrations even if some were already applied
#   --single FILE     Apply only a specific migration file
#   --rollback        Rollback last migration (if rollback file exists)
#
# Examples:
#   ./migrate-db.sh                                  # Apply pending migrations
#   ./migrate-db.sh --dry-run                        # Preview migrations
#   ./migrate-db.sh --single 003_add_rarity.sql      # Apply specific migration
#
# Environment:
#   MIGRATIONS_DIR    Directory containing SQL migration files
#   DB_CONTAINER      Database container name (default: collectoria-collection-db-prod)
#   DB_USER           Database user (default: collectoria)
#   DB_NAME           Database name (default: collectoria)
#
# Migration Files:
#   - Must be named: NNN_description.sql (e.g., 001_initial_schema.sql)
#   - Optional rollback: NNN_description.down.sql
#   - Migrations are applied in numerical order
#

set -e

# Script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Source libraries
source "$SCRIPT_DIR/../lib/common.sh"
source "$SCRIPT_DIR/../lib/docker-utils.sh"

# Configuration
PROJECT_DIR="${PROJECT_DIR:-/home/collectoria/Collectoria}"
MIGRATIONS_DIR="${MIGRATIONS_DIR:-$PROJECT_DIR/backend/collection-management/migrations}"
DB_CONTAINER="${DB_CONTAINER:-collectoria-collection-db-prod}"
DB_USER="${DB_USER:-collectoria}"
DB_NAME="${DB_NAME:-collectoria}"

# Parse command line arguments
DRY_RUN=false
FORCE=false
SINGLE_FILE=""
ROLLBACK=false

while [[ $# -gt 0 ]]; do
    case $1 in
        --dry-run)
            DRY_RUN=true
            shift
            ;;
        --force)
            FORCE=true
            shift
            ;;
        --single)
            SINGLE_FILE="$2"
            shift 2
            ;;
        --rollback)
            ROLLBACK=true
            shift
            ;;
        *)
            log_error "Unknown option: $1"
            echo "Usage: $0 [--dry-run] [--force] [--single FILE] [--rollback]"
            exit 1
            ;;
    esac
done

print_header "Database Migrations - Collectoria"

# Preflight checks
check_permissions

if [[ ! -d "$MIGRATIONS_DIR" ]]; then
    log_error "Migrations directory not found: $MIGRATIONS_DIR"
    exit 1
fi

if ! check_container_running "$DB_CONTAINER"; then
    log_error "Database container is not running: $DB_CONTAINER"
    exit 1
fi

# Step 1: Create migrations tracking table if it doesn't exist
log_step "Initializing migrations tracking..."

INIT_SQL="
CREATE TABLE IF NOT EXISTS schema_migrations (
    id SERIAL PRIMARY KEY,
    version VARCHAR(255) UNIQUE NOT NULL,
    applied_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    description TEXT
);
"

if docker exec "$DB_CONTAINER" psql -U "$DB_USER" -d "$DB_NAME" -c "$INIT_SQL" >/dev/null 2>&1; then
    log_success "Migrations tracking initialized"
else
    log_error "Failed to initialize migrations tracking"
    exit 1
fi

# Step 2: Get list of applied migrations
APPLIED_MIGRATIONS=$(docker exec "$DB_CONTAINER" psql -U "$DB_USER" -d "$DB_NAME" -t -c "SELECT version FROM schema_migrations ORDER BY version;" 2>/dev/null | xargs || echo "")

log_info "Applied migrations:"
if [[ -z "$APPLIED_MIGRATIONS" ]]; then
    echo "  (none)"
else
    for migration in $APPLIED_MIGRATIONS; do
        echo "  - $migration"
    done
fi

echo ""

# Step 3: Handle rollback if requested
if [[ "$ROLLBACK" == "true" ]]; then
    log_step "Rolling back last migration..."

    LAST_MIGRATION=$(docker exec "$DB_CONTAINER" psql -U "$DB_USER" -d "$DB_NAME" -t -c "SELECT version FROM schema_migrations ORDER BY version DESC LIMIT 1;" 2>/dev/null | xargs || echo "")

    if [[ -z "$LAST_MIGRATION" ]]; then
        log_error "No migrations to rollback"
        exit 1
    fi

    log_info "Last migration: $LAST_MIGRATION"

    # Look for rollback file
    ROLLBACK_FILE=$(find "$MIGRATIONS_DIR" -name "${LAST_MIGRATION}*.down.sql" -type f | head -1)

    if [[ -z "$ROLLBACK_FILE" ]]; then
        log_error "Rollback file not found for migration: $LAST_MIGRATION"
        log_info "Expected: ${MIGRATIONS_DIR}/${LAST_MIGRATION}_*.down.sql"
        exit 1
    fi

    log_info "Rollback file: $(basename "$ROLLBACK_FILE")"

    if ! confirm "Rollback migration $LAST_MIGRATION?"; then
        log_info "Rollback cancelled"
        exit 0
    fi

    echo ""

    log_step "Applying rollback..."

    if cat "$ROLLBACK_FILE" | docker exec -i "$DB_CONTAINER" psql -U "$DB_USER" -d "$DB_NAME"; then
        # Remove from tracking table
        docker exec "$DB_CONTAINER" psql -U "$DB_USER" -d "$DB_NAME" -c "DELETE FROM schema_migrations WHERE version='$LAST_MIGRATION';" >/dev/null 2>&1

        log_success "Migration rolled back: $LAST_MIGRATION"
        exit 0
    else
        log_error "Rollback failed"
        exit 1
    fi
fi

# Step 4: Find migration files
if [[ -n "$SINGLE_FILE" ]]; then
    # Apply single migration
    MIGRATION_FILE="$MIGRATIONS_DIR/$SINGLE_FILE"

    if [[ ! -f "$MIGRATION_FILE" ]]; then
        log_error "Migration file not found: $MIGRATION_FILE"
        exit 1
    fi

    MIGRATION_FILES=("$MIGRATION_FILE")
else
    # Find all migration files (*.sql, excluding *.down.sql)
    MIGRATION_FILES=($(find "$MIGRATIONS_DIR" -name "[0-9][0-9][0-9]_*.sql" -not -name "*.down.sql" -type f | sort))
fi

if [[ ${#MIGRATION_FILES[@]} -eq 0 ]]; then
    log_info "No migration files found"
    exit 0
fi

log_info "Found ${#MIGRATION_FILES[@]} migration file(s)"

# Step 5: Determine which migrations to apply
PENDING_MIGRATIONS=()

for migration_file in "${MIGRATION_FILES[@]}"; do
    FILENAME=$(basename "$migration_file")

    # Extract version (first 3 digits)
    VERSION=$(echo "$FILENAME" | grep -oP '^\d{3}')

    if [[ -z "$VERSION" ]]; then
        log_warning "Skipping invalid migration filename: $FILENAME"
        continue
    fi

    # Check if already applied
    if echo "$APPLIED_MIGRATIONS" | grep -q "$VERSION"; then
        if [[ "$FORCE" == "true" ]]; then
            log_warning "Migration $VERSION already applied, but --force specified"
            PENDING_MIGRATIONS+=("$migration_file")
        else
            log_info "Migration $VERSION already applied, skipping"
        fi
    else
        PENDING_MIGRATIONS+=("$migration_file")
    fi
done

# Step 6: Show pending migrations
if [[ ${#PENDING_MIGRATIONS[@]} -eq 0 ]]; then
    log_success "No pending migrations"
    exit 0
fi

echo ""
log_info "Pending migrations:"
for migration_file in "${PENDING_MIGRATIONS[@]}"; do
    echo "  - $(basename "$migration_file")"
done

echo ""

if [[ "$DRY_RUN" == "true" ]]; then
    log_info "[DRY-RUN] Would apply ${#PENDING_MIGRATIONS[@]} migration(s)"
    exit 0
fi

# Confirmation
if ! confirm "Apply ${#PENDING_MIGRATIONS[@]} migration(s)?"; then
    log_info "Migration cancelled"
    exit 0
fi

echo ""

# Step 7: Apply migrations
APPLIED_COUNT=0
FAILED=false

for migration_file in "${PENDING_MIGRATIONS[@]}"; do
    FILENAME=$(basename "$migration_file")
    VERSION=$(echo "$FILENAME" | grep -oP '^\d{3}')
    DESCRIPTION=$(echo "$FILENAME" | sed 's/^[0-9]\{3\}_//; s/\.sql$//')

    log_step "Applying migration: $FILENAME"

    START_TIME=$(date +%s)

    # Apply migration
    if cat "$migration_file" | docker exec -i "$DB_CONTAINER" psql -U "$DB_USER" -d "$DB_NAME"; then
        END_TIME=$(date +%s)
        DURATION=$((END_TIME - START_TIME))

        # Record in tracking table
        docker exec "$DB_CONTAINER" psql -U "$DB_USER" -d "$DB_NAME" -c \
            "INSERT INTO schema_migrations (version, description) VALUES ('$VERSION', '$DESCRIPTION') ON CONFLICT (version) DO NOTHING;" \
            >/dev/null 2>&1

        log_success "Migration applied: $FILENAME (${DURATION}s)"
        APPLIED_COUNT=$((APPLIED_COUNT + 1))
    else
        log_error "Migration failed: $FILENAME"
        FAILED=true

        # Check if rollback file exists
        ROLLBACK_FILE=$(find "$MIGRATIONS_DIR" -name "${VERSION}_*.down.sql" -type f | head -1)

        if [[ -n "$ROLLBACK_FILE" ]]; then
            log_warning "Rollback file available: $(basename "$ROLLBACK_FILE")"

            if confirm "Rollback failed migration?"; then
                if cat "$ROLLBACK_FILE" | docker exec -i "$DB_CONTAINER" psql -U "$DB_USER" -d "$DB_NAME"; then
                    log_success "Migration rolled back"
                else
                    log_error "Rollback also failed. Manual intervention required!"
                fi
            fi
        fi

        break
    fi
done

# Summary
print_header "Migration Summary"

if [[ "$FAILED" == "true" ]]; then
    log_error "Migration failed after applying $APPLIED_COUNT migration(s)"
    log_warning "Database may be in inconsistent state. Review logs and consider rollback."
    exit 1
else
    log_success "Successfully applied $APPLIED_COUNT migration(s)"

    # Show current schema version
    LATEST_VERSION=$(docker exec "$DB_CONTAINER" psql -U "$DB_USER" -d "$DB_NAME" -t -c "SELECT version FROM schema_migrations ORDER BY version DESC LIMIT 1;" 2>/dev/null | xargs || echo "N/A")

    log_info "Current schema version: $LATEST_VERSION"

    SUMMARY="Database migrations applied

Applied: $APPLIED_COUNT migration(s)
Latest version: $LATEST_VERSION
Timestamp: $(date +'%Y-%m-%d %H:%M:%S')
"

    echo ""
    echo "$SUMMARY"

    save_deployment_log "$SUMMARY" "migration"

    exit 0
fi
