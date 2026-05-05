#!/bin/bash
#
# cleanup.sh - Cleanup Docker Resources and Logs
#
# Description:
#   Cleans up Docker images, containers, volumes, networks, and logs
#   to free up disk space on production server
#
# Usage:
#   ./cleanup.sh [OPTIONS]
#
# Options:
#   --aggressive      More aggressive cleanup (removes unused images)
#   --dry-run         Show what would be cleaned without executing
#   --force           Skip confirmations for dangerous operations
#   --logs-only       Clean only logs (safer option)
#   --images-only     Clean only images
#
# Examples:
#   ./cleanup.sh                          # Standard cleanup
#   ./cleanup.sh --aggressive             # Deep cleanup
#   ./cleanup.sh --dry-run                # Preview cleanup
#   ./cleanup.sh --logs-only              # Safe logs cleanup only
#
# Cleanup Policy:
#   - Dangling images: Always removed
#   - Stopped containers >48h: Removed
#   - Logs >7 days: Removed
#   - Unused volumes: Requires confirmation
#   - Unused images: Only with --aggressive
#

set -e

# Script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Source libraries
source "$SCRIPT_DIR/../lib/common.sh"
source "$SCRIPT_DIR/../lib/docker-utils.sh"

# Parse command line arguments
AGGRESSIVE=false
DRY_RUN=false
FORCE=false
LOGS_ONLY=false
IMAGES_ONLY=false

while [[ $# -gt 0 ]]; do
    case $1 in
        --aggressive)
            AGGRESSIVE=true
            shift
            ;;
        --dry-run)
            DRY_RUN=true
            shift
            ;;
        --force)
            FORCE=true
            shift
            ;;
        --logs-only)
            LOGS_ONLY=true
            shift
            ;;
        --images-only)
            IMAGES_ONLY=true
            shift
            ;;
        *)
            log_error "Unknown option: $1"
            echo "Usage: $0 [--aggressive] [--dry-run] [--force] [--logs-only] [--images-only]"
            exit 1
            ;;
    esac
done

print_header "Docker Cleanup - Collectoria"

if [[ "$AGGRESSIVE" == "true" ]]; then
    log_warning "Running in AGGRESSIVE mode - will remove unused images"
fi

if [[ "$DRY_RUN" == "true" ]]; then
    log_info "Running in DRY-RUN mode - no changes will be made"
fi

echo ""

# Preflight checks
check_permissions

# Step 0: Show disk usage before cleanup
log_step "Disk usage before cleanup:"
echo ""
df -h / | head -2
echo ""
check_docker_disk_usage

# Track space freed
INITIAL_SPACE=$(df / | awk 'NR==2 {print $3}')

# Step 1: Cleanup dangling images (safe)
if [[ "$LOGS_ONLY" == "false" ]]; then
    print_header "Cleaning Dangling Images"

    if [[ "$DRY_RUN" == "false" ]]; then
        cleanup_dangling_images
    else
        DANGLING_COUNT=$(docker images -f "dangling=true" -q | wc -l)
        log_info "[DRY-RUN] Would remove $DANGLING_COUNT dangling image(s)"
    fi

    echo ""
fi

# Step 2: Cleanup stopped containers (>48h)
if [[ "$LOGS_ONLY" == "false" ]]; then
    print_header "Cleaning Stopped Containers"

    if [[ "$DRY_RUN" == "false" ]]; then
        cleanup_stopped_containers 48
    else
        STOPPED_COUNT=$(docker ps -a --filter "status=exited" -q | wc -l)
        log_info "[DRY-RUN] Would check and remove stopped containers (>48h)"
        log_info "Total stopped containers: $STOPPED_COUNT"
    fi

    echo ""
fi

# Step 3: Cleanup old logs
if [[ "$IMAGES_ONLY" == "false" ]]; then
    print_header "Cleaning Old Logs"

    LOG_DIRS=(
        "/var/lib/docker/containers"
        "/home/collectoria/Collectoria/.deployment/history"
    )

    for log_dir in "${LOG_DIRS[@]}"; do
        if [[ -d "$log_dir" ]]; then
            if [[ "$DRY_RUN" == "false" ]]; then
                cleanup_old_logs "$log_dir" 7
            else
                OLD_LOGS=$(find "$log_dir" -name "*.log" -mtime +7 -type f 2>/dev/null | wc -l)
                log_info "[DRY-RUN] Would remove $OLD_LOGS log file(s) from $log_dir"
            fi
        fi
    done

    echo ""
fi

# Step 4: Cleanup unused networks (safe)
if [[ "$LOGS_ONLY" == "false" && "$IMAGES_ONLY" == "false" ]]; then
    print_header "Cleaning Unused Networks"

    if [[ "$DRY_RUN" == "false" ]]; then
        cleanup_unused_networks
    else
        log_info "[DRY-RUN] Would remove unused Docker networks"
    fi

    echo ""
fi

# Step 5: Cleanup unused volumes (requires confirmation unless forced)
if [[ "$LOGS_ONLY" == "false" && "$IMAGES_ONLY" == "false" ]]; then
    print_header "Cleaning Unused Volumes"

    UNUSED_VOLUMES=$(docker volume ls -qf dangling=true | wc -l)

    if [[ $UNUSED_VOLUMES -gt 0 ]]; then
        log_warning "Found $UNUSED_VOLUMES unused volume(s)"

        DO_CLEANUP=false

        if [[ "$FORCE" == "true" ]]; then
            DO_CLEANUP=true
        elif [[ "$DRY_RUN" == "false" ]]; then
            if confirm "Remove unused volumes? This cannot be undone"; then
                DO_CLEANUP=true
            fi
        fi

        if [[ "$DO_CLEANUP" == "true" ]]; then
            if [[ "$DRY_RUN" == "false" ]]; then
                cleanup_unused_volumes true
            else
                log_info "[DRY-RUN] Would remove $UNUSED_VOLUMES unused volume(s)"
            fi
        else
            log_info "Skipping volume cleanup"
        fi
    else
        log_info "No unused volumes to clean"
    fi

    echo ""
fi

# Step 6: Aggressive cleanup (unused images)
if [[ "$AGGRESSIVE" == "true" && "$LOGS_ONLY" == "false" ]]; then
    print_header "Aggressive Cleanup - Unused Images"

    log_warning "This will remove ALL unused images (not just dangling ones)"
    log_warning "This may remove images needed for quick rollback"

    DO_AGGRESSIVE=false

    if [[ "$FORCE" == "true" ]]; then
        DO_AGGRESSIVE=true
    elif [[ "$DRY_RUN" == "false" ]]; then
        if confirm "Proceed with aggressive image cleanup?"; then
            DO_AGGRESSIVE=true
        fi
    fi

    if [[ "$DO_AGGRESSIVE" == "true" ]]; then
        if [[ "$DRY_RUN" == "false" ]]; then
            log_step "Removing unused images..."
            docker image prune -a -f
            log_success "Unused images removed"
        else
            log_info "[DRY-RUN] Would remove all unused images"
        fi
    else
        log_info "Skipping aggressive image cleanup"
    fi

    echo ""
fi

# Step 6.5: Aggressive cleanup (build cache)
if [[ "$AGGRESSIVE" == "true" && "$LOGS_ONLY" == "false" ]]; then
    print_header "Aggressive Cleanup - Build Cache"

    # Check build cache size
    BUILD_CACHE_SIZE=$(docker system df --format "{{.Reclaimable}}" | sed -n '4p' | sed 's/[^0-9.]//g' 2>/dev/null || echo "0")

    if [[ -n "$BUILD_CACHE_SIZE" && $(echo "$BUILD_CACHE_SIZE > 0" | bc 2>/dev/null || echo 0) -eq 1 ]]; then
        log_warning "Build cache can be cleaned (may slow down next builds)"

        DO_CACHE_CLEANUP=false

        if [[ "$FORCE" == "true" ]]; then
            DO_CACHE_CLEANUP=true
        elif [[ "$DRY_RUN" == "false" ]]; then
            if confirm "Clean Docker build cache?"; then
                DO_CACHE_CLEANUP=true
            fi
        fi

        if [[ "$DO_CACHE_CLEANUP" == "true" ]]; then
            if [[ "$DRY_RUN" == "false" ]]; then
                log_step "Removing build cache..."
                docker builder prune -a -f
                log_success "Build cache cleaned"
            else
                log_info "[DRY-RUN] Would remove build cache"
            fi
        else
            log_info "Skipping build cache cleanup"
        fi
    else
        log_info "No build cache to clean"
    fi

    echo ""
fi

# Step 7: Cleanup old deployment logs (>30 days)
if [[ "$IMAGES_ONLY" == "false" ]]; then
    print_header "Cleaning Old Deployment Logs"

    DEPLOYMENT_LOG_DIR="/home/collectoria/Collectoria/.deployment/history"

    if [[ -d "$DEPLOYMENT_LOG_DIR" ]]; then
        if [[ "$DRY_RUN" == "false" ]]; then
            OLD_DEPLOYMENTS=$(find "$DEPLOYMENT_LOG_DIR" -name "*.log" -mtime +30 -type f 2>/dev/null | wc -l)

            if [[ $OLD_DEPLOYMENTS -gt 0 ]]; then
                log_info "Removing $OLD_DEPLOYMENTS deployment log(s) older than 30 days"
                find "$DEPLOYMENT_LOG_DIR" -name "*.log" -mtime +30 -type f -delete 2>/dev/null || true
                log_success "Old deployment logs cleaned"
            else
                log_info "No old deployment logs to clean"
            fi
        else
            OLD_DEPLOYMENTS=$(find "$DEPLOYMENT_LOG_DIR" -name "*.log" -mtime +30 -type f 2>/dev/null | wc -l)
            log_info "[DRY-RUN] Would remove $OLD_DEPLOYMENTS deployment log(s)"
        fi
    fi

    echo ""
fi

# Step 8: Cleanup old database backups (>90 days, keeping monthly)
if [[ "$IMAGES_ONLY" == "false" ]]; then
    print_header "Cleaning Old Database Backups"

    BACKUP_DIR="/home/collectoria/backups"

    if [[ -d "$BACKUP_DIR" ]]; then
        if [[ "$DRY_RUN" == "false" ]]; then
            OLD_BACKUPS=$(find "$BACKUP_DIR" -name "collectoria_*.sql.gz" -mtime +90 -type f 2>/dev/null | wc -l)

            if [[ $OLD_BACKUPS -gt 0 ]]; then
                log_info "Removing $OLD_BACKUPS backup(s) older than 90 days"
                find "$BACKUP_DIR" -name "collectoria_*.sql.gz" -mtime +90 -type f -delete 2>/dev/null || true
                log_success "Old backups cleaned"
            else
                log_info "No old backups to clean"
            fi
        else
            OLD_BACKUPS=$(find "$BACKUP_DIR" -name "collectoria_*.sql.gz" -mtime +90 -type f 2>/dev/null | wc -l)
            log_info "[DRY-RUN] Would remove $OLD_BACKUPS backup(s)"
        fi
    fi

    echo ""
fi

# Step 9: Show disk usage after cleanup
print_header "Disk Usage After Cleanup"

echo ""
df -h / | head -2
echo ""

if [[ "$DRY_RUN" == "false" ]]; then
    check_docker_disk_usage
fi

# Calculate space freed
FINAL_SPACE=$(df / | awk 'NR==2 {print $3}')
SPACE_FREED=$((INITIAL_SPACE - FINAL_SPACE))
SPACE_FREED_MB=$((SPACE_FREED / 1024))

# Summary
print_header "Cleanup Summary"

if [[ "$DRY_RUN" == "false" ]]; then
    log_success "Cleanup completed successfully"

    if [[ $SPACE_FREED_MB -gt 0 ]]; then
        log_success "Space freed: ${SPACE_FREED_MB}MB"
    else
        SPACE_USED=$((-SPACE_FREED_MB))
        log_info "Space change: +${SPACE_USED}MB (temporary increase from cleanup operations)"
    fi

    SUMMARY="Docker cleanup completed

Space freed: ${SPACE_FREED_MB}MB
Aggressive mode: $([ "$AGGRESSIVE" == "true" ] && echo "YES" || echo "NO")
Timestamp: $(date +'%Y-%m-%d %H:%M:%S')
"

    echo ""
    echo "$SUMMARY"

    save_deployment_log "$SUMMARY" "cleanup"
else
    log_info "Dry-run completed - no changes were made"
    log_info "Run without --dry-run to perform actual cleanup"
fi

# Recommendations
if [[ $SPACE_FREED_MB -lt 500 && "$AGGRESSIVE" == "false" && "$DRY_RUN" == "false" ]]; then
    echo ""
    log_info "Tip: Run with --aggressive to free more space"
fi

exit 0
