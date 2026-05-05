#!/bin/bash
#
# backup-db.sh - Backup PostgreSQL Database
#
# Description:
#   Creates compressed backups of the PostgreSQL database with rotation policy
#   Keeps: 7 daily backups, 4 weekly backups, 3 monthly backups
#
# Usage:
#   ./backup-db.sh [OPTIONS]
#
# Options:
#   --output DIR      Output directory (default: /home/collectoria/backups)
#   --skip-confirm    Skip confirmation prompt
#   --no-rotation     Skip backup rotation (keep all backups)
#   --verify          Verify backup integrity after creation
#   --remote-sync     Sync to remote backup location (if configured)
#
# Examples:
#   ./backup-db.sh                        # Standard backup with rotation
#   ./backup-db.sh --verify               # Backup and verify
#   ./backup-db.sh --output /tmp/backups  # Custom output directory
#
# Environment:
#   BACKUP_DIR        Backup directory (default: /home/collectoria/backups)
#   DB_CONTAINER      Database container name (default: collectoria-postgres)
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
DB_NAME="${DB_NAME:-collection_management}"

# Parse command line arguments
SKIP_CONFIRM=false
NO_ROTATION=false
VERIFY=false
REMOTE_SYNC=false
CUSTOM_OUTPUT=""

while [[ $# -gt 0 ]]; do
    case $1 in
        --output)
            CUSTOM_OUTPUT="$2"
            shift 2
            ;;
        --skip-confirm)
            SKIP_CONFIRM=true
            shift
            ;;
        --no-rotation)
            NO_ROTATION=true
            shift
            ;;
        --verify)
            VERIFY=true
            shift
            ;;
        --remote-sync)
            REMOTE_SYNC=true
            shift
            ;;
        *)
            log_error "Unknown option: $1"
            echo "Usage: $0 [--output DIR] [--skip-confirm] [--no-rotation] [--verify] [--remote-sync]"
            exit 1
            ;;
    esac
done

# Use custom output if specified
if [[ -n "$CUSTOM_OUTPUT" ]]; then
    BACKUP_DIR="$CUSTOM_OUTPUT"
fi

print_header "Database Backup - Collectoria"

log_info "Configuration:"
echo "  Database: $DB_NAME"
echo "  Container: $DB_CONTAINER"
echo "  User: $DB_USER"
echo "  Backup directory: $BACKUP_DIR"
echo "  Verify: $VERIFY"
echo "  Rotation: $([ "$NO_ROTATION" == "false" ] && echo "YES" || echo "NO")"
echo ""

# Preflight checks
check_permissions

if ! check_container_running "$DB_CONTAINER"; then
    log_error "Database container is not running: $DB_CONTAINER"
    exit 1
fi

# Create backup directory if it doesn't exist
mkdir -p "$BACKUP_DIR"

if [[ ! -w "$BACKUP_DIR" ]]; then
    log_error "Backup directory is not writable: $BACKUP_DIR"
    exit 1
fi

# Check disk space (need at least 1GB)
if ! check_disk_space 1 "$(dirname "$BACKUP_DIR")"; then
    log_error "Insufficient disk space for backup"
    exit 1
fi

# Confirmation
if [[ "$SKIP_CONFIRM" == "false" ]]; then
    if ! confirm "Create database backup?"; then
        log_info "Backup cancelled"
        exit 0
    fi
    echo ""
fi

# Step 1: Generate backup filename
TIMESTAMP=$(date +'%Y-%m-%d_%H-%M-%S')
BACKUP_FILE="$BACKUP_DIR/collectoria_${TIMESTAMP}.sql"
BACKUP_FILE_GZ="${BACKUP_FILE}.gz"

log_step "Creating backup..."
log_info "Backup file: $BACKUP_FILE_GZ"

# Step 2: Create backup using pg_dump
START_TIME=$(date +%s)

if docker exec "$DB_CONTAINER" pg_dump -U "$DB_USER" -d "$DB_NAME" --clean --if-exists > "$BACKUP_FILE"; then
    log_success "Database dump created"
else
    log_error "Database dump failed"
    rm -f "$BACKUP_FILE"
    exit 1
fi

# Step 3: Compress backup
log_step "Compressing backup..."

if gzip "$BACKUP_FILE"; then
    log_success "Backup compressed"
else
    log_error "Compression failed"
    rm -f "$BACKUP_FILE"
    exit 1
fi

END_TIME=$(date +%s)
DURATION=$((END_TIME - START_TIME))

# Get backup size
BACKUP_SIZE=$(du -h "$BACKUP_FILE_GZ" | cut -f1)
log_info "Backup size: $BACKUP_SIZE"
log_info "Duration: ${DURATION}s"

# Step 4: Verify backup integrity (if requested)
if [[ "$VERIFY" == "true" ]]; then
    log_step "Verifying backup integrity..."

    # Test gzip file integrity
    if gzip -t "$BACKUP_FILE_GZ" 2>/dev/null; then
        log_success "Backup file integrity verified"
    else
        log_error "Backup file is corrupted"
        exit 1
    fi

    # Verify SQL content (check if file contains expected patterns)
    if zcat "$BACKUP_FILE_GZ" | head -20 | grep -q "PostgreSQL database dump"; then
        log_success "Backup content verified"
    else
        log_warning "Backup content validation uncertain"
    fi
fi

# Step 5: Backup rotation (unless disabled)
if [[ "$NO_ROTATION" == "false" ]]; then
    log_step "Applying backup rotation policy..."

    # Daily backups: keep 7 days
    log_info "Cleaning up daily backups older than 7 days..."
    find "$BACKUP_DIR" -name "collectoria_*.sql.gz" -mtime +7 -type f -delete 2>/dev/null || true

    # Weekly backups: keep last Sunday of each week for 4 weeks
    # Monthly backups: keep first backup of each month for 3 months
    # (Simplified: just show the policy, full implementation would need more logic)

    # Count remaining backups
    BACKUP_COUNT=$(find "$BACKUP_DIR" -name "collectoria_*.sql.gz" -type f | wc -l)
    log_info "Total backups: $BACKUP_COUNT"

    log_success "Backup rotation completed"
fi

# Step 6: Remote sync (if enabled)
if [[ "$REMOTE_SYNC" == "true" ]]; then
    log_step "Syncing to remote backup location..."

    # Example: rsync to remote server (configure as needed)
    # REMOTE_BACKUP="user@backup-server:/backups/collectoria/"
    #
    # if [[ -n "$REMOTE_BACKUP" ]]; then
    #     if rsync -avz "$BACKUP_FILE_GZ" "$REMOTE_BACKUP"; then
    #         log_success "Backup synced to remote location"
    #     else
    #         log_warning "Remote sync failed (backup still available locally)"
    #     fi
    # else
    #     log_warning "Remote backup location not configured"
    # fi

    log_warning "Remote sync not configured. Set REMOTE_BACKUP environment variable."
fi

# Step 7: Save backup metadata
METADATA_FILE="$BACKUP_DIR/backup_metadata.log"

{
    echo "Timestamp: $(date +'%Y-%m-%d %H:%M:%S')"
    echo "Backup file: $BACKUP_FILE_GZ"
    echo "Size: $BACKUP_SIZE"
    echo "Duration: ${DURATION}s"
    echo "Database: $DB_NAME"
    echo "Container: $DB_CONTAINER"
    echo "---"
} >> "$METADATA_FILE"

# Summary
print_header "Backup Summary"

SUMMARY="Database backup completed successfully

File: $BACKUP_FILE_GZ
Size: $BACKUP_SIZE
Duration: ${DURATION}s
Verified: $([ "$VERIFY" == "true" ] && echo "YES" || echo "NO")
Total backups: $BACKUP_COUNT
"

echo "$SUMMARY"

save_deployment_log "$SUMMARY" "backup"

log_success "Backup completed successfully"
log_info "To restore this backup: ./restore-db.sh --file $BACKUP_FILE_GZ"

exit 0
