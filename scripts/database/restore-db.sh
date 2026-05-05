#!/bin/bash
#
# restore-db.sh - Restore PostgreSQL Database from Backup
#
# Description:
#   Restores PostgreSQL database from a compressed backup file
#   WARNING: This is a destructive operation! All current data will be replaced.
#
# Usage:
#   ./restore-db.sh [OPTIONS]
#
# Options:
#   --file FILE       Backup file to restore (required if not interactive)
#   --force           Skip all confirmations (DANGEROUS)
#   --no-backup       Skip creating backup before restore
#   --list            List available backups and exit
#
# Examples:
#   ./restore-db.sh                                        # Interactive restore
#   ./restore-db.sh --list                                 # List available backups
#   ./restore-db.sh --file /path/to/backup.sql.gz          # Restore specific file
#
# Environment:
#   BACKUP_DIR        Backup directory (default: /home/collectoria/backups)
#   DB_CONTAINER      Database container name (default: collectoria-collection-db-prod)
#   DB_USER           Database user (default: collectoria)
#   DB_NAME           Database name (default: collectoria)
#

set -e

# Script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Source libraries
source "$SCRIPT_DIR/../lib/common.sh"
source "$SCRIPT_DIR/../lib/docker-utils.sh"

# Configuration
BACKUP_DIR="${BACKUP_DIR:-/home/collectoria/backups}"
DB_CONTAINER="${DB_CONTAINER:-collectoria-collection-db-prod}"
DB_USER="${DB_USER:-collectoria}"
DB_NAME="${DB_NAME:-collectoria}"
BACKEND_SERVICE="backend"
BACKEND_CONTAINER="collectoria-backend"
PROJECT_DIR="${PROJECT_DIR:-/home/collectoria/Collectoria}"
COMPOSE_FILE="${COMPOSE_FILE:-$PROJECT_DIR/docker-compose.prod.yml}"

# Parse command line arguments
RESTORE_FILE=""
FORCE=false
NO_BACKUP=false
LIST_ONLY=false

while [[ $# -gt 0 ]]; do
    case $1 in
        --file)
            RESTORE_FILE="$2"
            shift 2
            ;;
        --force)
            FORCE=true
            shift
            ;;
        --no-backup)
            NO_BACKUP=true
            shift
            ;;
        --list)
            LIST_ONLY=true
            shift
            ;;
        *)
            log_error "Unknown option: $1"
            echo "Usage: $0 [--file FILE] [--force] [--no-backup] [--list]"
            exit 1
            ;;
    esac
done

print_header "Database Restore - Collectoria"

# List backups and exit if requested
if [[ "$LIST_ONLY" == "true" ]]; then
    log_info "Available backups in $BACKUP_DIR:"
    echo ""

    if [[ ! -d "$BACKUP_DIR" ]]; then
        log_error "Backup directory not found: $BACKUP_DIR"
        exit 1
    fi

    BACKUPS=$(find "$BACKUP_DIR" -name "collectoria_*.sql.gz" -type f | sort -r)

    if [[ -z "$BACKUPS" ]]; then
        log_warning "No backups found"
        exit 0
    fi

    echo "File                                        Size      Date"
    echo "────────────────────────────────────────────────────────────────────"

    while IFS= read -r backup; do
        FILENAME=$(basename "$backup")
        SIZE=$(du -h "$backup" | cut -f1)
        DATE=$(stat -c %y "$backup" | cut -d'.' -f1)

        printf "%-45s %-9s %s\n" "$FILENAME" "$SIZE" "$DATE"
    done <<< "$BACKUPS"

    echo ""
    log_info "To restore a backup: ./restore-db.sh --file <backup_file>"
    exit 0
fi

# CRITICAL WARNING
echo ""
echo -e "${RED}╔════════════════════════════════════════════════════════════╗${NC}"
echo -e "${RED}║                     ⚠️  DANGER  ⚠️                          ║${NC}"
echo -e "${RED}║                                                            ║${NC}"
echo -e "${RED}║  This operation will REPLACE all database data!           ║${NC}"
echo -e "${RED}║                                                            ║${NC}"
echo -e "${RED}║  Impact:                                                   ║${NC}"
echo -e "${RED}║    - ALL CURRENT DATA WILL BE LOST                         ║${NC}"
echo -e "${RED}║    - Backend will be stopped during restore                ║${NC}"
echo -e "${RED}║    - This action CANNOT be undone                          ║${NC}"
echo -e "${RED}║                                                            ║${NC}"
echo -e "${RED}║  Ensure you have a recent backup before proceeding!        ║${NC}"
echo -e "${RED}╚════════════════════════════════════════════════════════════╝${NC}"
echo ""

# Preflight checks
check_permissions

if ! check_container_running "$DB_CONTAINER"; then
    log_error "Database container is not running: $DB_CONTAINER"
    exit 1
fi

# Select or verify restore file
if [[ -z "$RESTORE_FILE" ]]; then
    log_step "Available backups:"
    echo ""

    if [[ ! -d "$BACKUP_DIR" ]]; then
        log_error "Backup directory not found: $BACKUP_DIR"
        exit 1
    fi

    BACKUPS=($(find "$BACKUP_DIR" -name "collectoria_*.sql.gz" -type f | sort -r))

    if [[ ${#BACKUPS[@]} -eq 0 ]]; then
        log_error "No backups found in $BACKUP_DIR"
        exit 1
    fi

    # Show last 10 backups
    for i in "${!BACKUPS[@]}"; do
        if [[ $i -ge 10 ]]; then
            break
        fi

        BACKUP="${BACKUPS[$i]}"
        FILENAME=$(basename "$BACKUP")
        SIZE=$(du -h "$BACKUP" | cut -f1)
        DATE=$(stat -c %y "$BACKUP" | cut -d'.' -f1)

        echo "  [$i] $FILENAME ($SIZE) - $DATE"
    done

    echo ""
    read -p "Enter backup number to restore (or 'cancel'): " SELECTION

    if [[ "$SELECTION" == "cancel" ]]; then
        log_info "Restore cancelled"
        exit 0
    fi

    if [[ ! "$SELECTION" =~ ^[0-9]+$ ]] || [[ $SELECTION -ge ${#BACKUPS[@]} ]]; then
        log_error "Invalid selection"
        exit 1
    fi

    RESTORE_FILE="${BACKUPS[$SELECTION]}"
fi

# Verify restore file exists
if [[ ! -f "$RESTORE_FILE" ]]; then
    log_error "Restore file not found: $RESTORE_FILE"
    exit 1
fi

log_info "Restore file: $RESTORE_FILE"
log_info "File size: $(du -h "$RESTORE_FILE" | cut -f1)"

# Triple confirmation (unless forced)
if [[ "$FORCE" == "false" ]]; then
    if ! confirm "Do you understand that ALL CURRENT DATA will be lost?"; then
        log_info "Restore cancelled"
        exit 0
    fi

    echo ""
    if ! confirm "Have you verified this is the correct backup to restore?"; then
        log_info "Restore cancelled"
        exit 0
    fi

    echo ""
    if ! confirm "Are you ABSOLUTELY SURE you want to proceed?"; then
        log_info "Restore cancelled"
        exit 0
    fi

    echo ""
fi

# Step 1: Create backup before restore (unless skipped)
if [[ "$NO_BACKUP" == "false" ]]; then
    log_step "Creating safety backup before restore..."

    if [[ -x "$SCRIPT_DIR/backup-db.sh" ]]; then
        SAFETY_BACKUP_DIR="$BACKUP_DIR/pre-restore"
        mkdir -p "$SAFETY_BACKUP_DIR"

        if BACKUP_DIR="$SAFETY_BACKUP_DIR" "$SCRIPT_DIR/backup-db.sh" --skip-confirm --no-rotation; then
            log_success "Safety backup created"
        else
            log_error "Safety backup failed"

            if ! confirm "Continue without safety backup?"; then
                exit 1
            fi
        fi
    else
        log_warning "Backup script not found, skipping safety backup"
    fi

    echo ""
fi

# Step 2: Stop backend
BACKEND_WAS_RUNNING=false

if check_container_running "$BACKEND_CONTAINER"; then
    log_step "Stopping backend service..."

    docker-compose -f "$COMPOSE_FILE" stop "$BACKEND_SERVICE"

    BACKEND_WAS_RUNNING=true
    log_success "Backend stopped"

    sleep 2
fi

# Step 3: Verify backup file integrity
log_step "Verifying backup file integrity..."

if ! gzip -t "$RESTORE_FILE" 2>/dev/null; then
    log_error "Backup file is corrupted or invalid"
    exit 1
fi

log_success "Backup file integrity verified"

# Step 4: Restore database
log_step "Restoring database..."

START_TIME=$(date +%s)

# Drop existing connections
log_info "Terminating active connections..."
docker exec "$DB_CONTAINER" psql -U "$DB_USER" -d postgres -c \
    "SELECT pg_terminate_backend(pid) FROM pg_stat_activity WHERE datname='$DB_NAME' AND pid <> pg_backend_pid();" \
    >/dev/null 2>&1 || true

# Restore database
if zcat "$RESTORE_FILE" | docker exec -i "$DB_CONTAINER" psql -U "$DB_USER" -d "$DB_NAME"; then
    log_success "Database restored"
else
    log_error "Database restore failed"

    # Try to restore from safety backup
    if [[ "$NO_BACKUP" == "false" && -d "$SAFETY_BACKUP_DIR" ]]; then
        log_warning "Attempting to restore from safety backup..."

        LATEST_SAFETY=$(find "$SAFETY_BACKUP_DIR" -name "collectoria_*.sql.gz" -type f | sort -r | head -1)

        if [[ -n "$LATEST_SAFETY" ]]; then
            if zcat "$LATEST_SAFETY" | docker exec -i "$DB_CONTAINER" psql -U "$DB_USER" -d "$DB_NAME"; then
                log_success "Restored from safety backup"
            else
                log_error "Safety backup restore also failed. Database may be in inconsistent state!"
            fi
        fi
    fi

    exit 1
fi

END_TIME=$(date +%s)
DURATION=$((END_TIME - START_TIME))

log_info "Restore duration: ${DURATION}s"

# Step 5: Verify database is accessible
log_step "Verifying database..."

if docker exec "$DB_CONTAINER" psql -U "$DB_USER" -d "$DB_NAME" -c "SELECT COUNT(*) FROM collections;" >/dev/null 2>&1; then
    log_success "Database is accessible and responsive"
else
    log_error "Database verification failed"
    exit 1
fi

# Step 6: Restart backend
if [[ "$BACKEND_WAS_RUNNING" == "true" ]]; then
    log_step "Restarting backend service..."

    docker-compose -f "$COMPOSE_FILE" up -d "$BACKEND_SERVICE"

    log_success "Backend started"

    # Wait and health check
    sleep 5

    if check_service_health "backend" "http://localhost:8080/api/v1/health" 30 2; then
        log_success "Backend is healthy"
    else
        log_error "Backend health check failed after restore"
        get_container_logs "$BACKEND_CONTAINER" 50
        exit 1
    fi
fi

# Summary
print_header "Restore Summary"

log_success "Database restore completed successfully"

SUMMARY="Database restored from backup

Restore file: $(basename "$RESTORE_FILE")
Duration: ${DURATION}s
Backend restarted: $([ "$BACKEND_WAS_RUNNING" == "true" ] && echo "YES" || echo "NO")
Timestamp: $(date +'%Y-%m-%d %H:%M:%S')
"

echo "$SUMMARY"

save_deployment_log "$SUMMARY" "restore"

log_info "Database is fully operational"

exit 0
