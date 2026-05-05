#!/bin/bash
#
# deploy-backend.sh - Deploy Collectoria Backend to Production
#
# Description:
#   Deploys the Go backend service with health checks, automatic rollback on failure,
#   and cleanup of old images
#
# Usage:
#   ./deploy-backend.sh [OPTIONS]
#
# Options:
#   --no-cache        Force Docker build without cache
#   --skip-tests      Skip Go tests before deployment
#   --skip-pull       Skip git pull (use current code)
#   --dry-run         Show what would be done without executing
#   --keep-images N   Keep N latest images (default: 2)
#
# Examples:
#   ./deploy-backend.sh                    # Standard deployment
#   ./deploy-backend.sh --no-cache         # Force rebuild without cache
#   ./deploy-backend.sh --skip-tests       # Skip tests (faster but risky)
#   ./deploy-backend.sh --dry-run          # Preview actions
#
# Environment:
#   PROJECT_DIR       Path to Collectoria project (default: /home/collectoria/Collectoria)
#   COMPOSE_FILE      Docker compose file (default: docker-compose.prod.yml)
#

set -e

# Script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Source libraries
source "$SCRIPT_DIR/../lib/common.sh"
source "$SCRIPT_DIR/../lib/docker-utils.sh"

# Configuration
PROJECT_DIR="${PROJECT_DIR:-/home/collectoria/Collectoria}"
COMPOSE_FILE="${COMPOSE_FILE:-$PROJECT_DIR/docker-compose.prod.yml}"
SERVICE_NAME="backend"
CONTAINER_NAME="collectoria-backend"
HEALTH_URL="http://localhost:8080/api/v1/health"
IMAGE_NAME="collectoria-backend"
KEEP_IMAGES=2

# Parse command line arguments
NO_CACHE=false
SKIP_TESTS=false
SKIP_PULL=false
DRY_RUN=false

while [[ $# -gt 0 ]]; do
    case $1 in
        --no-cache)
            NO_CACHE=true
            shift
            ;;
        --skip-tests)
            SKIP_TESTS=true
            shift
            ;;
        --skip-pull)
            SKIP_PULL=true
            shift
            ;;
        --dry-run)
            DRY_RUN=true
            shift
            ;;
        --keep-images)
            KEEP_IMAGES="$2"
            shift 2
            ;;
        *)
            log_error "Unknown option: $1"
            echo "Usage: $0 [--no-cache] [--skip-tests] [--skip-pull] [--dry-run] [--keep-images N]"
            exit 1
            ;;
    esac
done

# Start deployment
START_TIME=$(date +%s)

print_header "Backend Deployment - Collectoria"

log_info "Configuration:"
echo "  Project: $PROJECT_DIR"
echo "  Service: $SERVICE_NAME"
echo "  Container: $CONTAINER_NAME"
echo "  No Cache: $NO_CACHE"
echo "  Skip Tests: $SKIP_TESTS"
echo "  Skip Pull: $SKIP_PULL"
echo "  Dry Run: $DRY_RUN"
echo "  Keep Images: $KEEP_IMAGES"
echo ""

# Preflight checks
log_step "Running preflight checks..."

check_permissions

if [[ ! -d "$PROJECT_DIR" ]]; then
    log_error "Project directory not found: $PROJECT_DIR"
    exit 1
fi

check_compose_file "$COMPOSE_FILE"

cd "$PROJECT_DIR"

# Check disk space
if ! check_disk_space 5 "/"; then
    log_warning "Low disk space detected. Consider running cleanup script first."
    if ! confirm "Continue anyway?"; then
        exit 1
    fi
fi

# Save current image for rollback
if check_container_exists "$CONTAINER_NAME"; then
    CURRENT_IMAGE=$(docker inspect --format='{{.Config.Image}}' "$CONTAINER_NAME" 2>/dev/null || echo "")
    if [[ -n "$CURRENT_IMAGE" ]]; then
        log_info "Current image: $CURRENT_IMAGE"
    fi
fi

# Step 1: Git pull (unless skipped)
if [[ "$SKIP_PULL" == "false" ]]; then
    log_step "Updating code from Git repository..."

    if has_uncommitted_changes; then
        log_warning "Uncommitted changes detected in repository"
        git status -s
        echo ""
        if ! confirm "Continue with deployment?"; then
            exit 1
        fi
    fi

    CURRENT_COMMIT=$(get_current_commit)
    log_info "Current commit: $CURRENT_COMMIT"

    if [[ "$DRY_RUN" == "false" ]]; then
        git pull origin main
        NEW_COMMIT=$(get_current_commit)
        log_info "New commit: $NEW_COMMIT"

        if [[ "$CURRENT_COMMIT" == "$NEW_COMMIT" ]]; then
            log_info "No new commits. Code is up to date."
        fi
    else
        log_info "[DRY-RUN] Would execute: git pull origin main"
    fi
else
    log_info "Skipping git pull (--skip-pull flag)"
fi

# Step 2: Run tests (unless skipped)
if [[ "$SKIP_TESTS" == "false" ]]; then
    log_step "Running Go tests..."

    if [[ "$DRY_RUN" == "false" ]]; then
        cd "$PROJECT_DIR/backend/collection-management"

        if ! go test ./... -v; then
            log_error "Tests failed. Deployment aborted."
            log_info "Use --skip-tests to bypass tests (not recommended)"
            exit 1
        fi

        cd "$PROJECT_DIR"
        log_success "All tests passed"
    else
        log_info "[DRY-RUN] Would execute: go test ./... -v"
    fi
else
    log_warning "Skipping tests (--skip-tests flag). This is risky!"
fi

# Step 3: Build new image
log_step "Building new Docker image..."

BUILD_ARGS=""
if [[ "$NO_CACHE" == "true" ]]; then
    BUILD_ARGS="--no-cache"
    log_info "Building without cache"
fi

if [[ "$DRY_RUN" == "false" ]]; then
    docker-compose -f "$COMPOSE_FILE" build $BUILD_ARGS "$SERVICE_NAME"
    log_success "Image built successfully"
else
    log_info "[DRY-RUN] Would execute: docker-compose build $BUILD_ARGS $SERVICE_NAME"
fi

# Step 4: Stop current container
log_step "Stopping current backend container..."

if [[ "$DRY_RUN" == "false" ]]; then
    if check_container_running "$CONTAINER_NAME"; then
        docker-compose -f "$COMPOSE_FILE" stop -t 10 "$SERVICE_NAME"
        log_success "Backend stopped"
    else
        log_info "Backend is not running"
    fi
else
    log_info "[DRY-RUN] Would execute: docker-compose stop backend"
fi

# Step 5: Start new container
log_step "Starting new backend container..."

if [[ "$DRY_RUN" == "false" ]]; then
    docker-compose -f "$COMPOSE_FILE" up -d "$SERVICE_NAME"
    log_success "Backend started"

    # Wait a few seconds for startup
    sleep 3
else
    log_info "[DRY-RUN] Would execute: docker-compose up -d backend"
fi

# Step 6: Health check
log_step "Checking backend health..."

if [[ "$DRY_RUN" == "false" ]]; then
    if ! check_service_health "$SERVICE_NAME" "$HEALTH_URL" 30 2; then
        log_error "Health check failed. Rolling back..."

        # Rollback: restore previous image if available
        if [[ -n "$CURRENT_IMAGE" ]]; then
            log_warning "Attempting rollback to: $CURRENT_IMAGE"

            docker-compose -f "$COMPOSE_FILE" stop "$SERVICE_NAME"
            docker tag "$CURRENT_IMAGE" "${IMAGE_NAME}:rollback"
            docker-compose -f "$COMPOSE_FILE" up -d "$SERVICE_NAME"

            if check_service_health "$SERVICE_NAME" "$HEALTH_URL" 20 2; then
                log_success "Rollback successful"
            else
                log_error "Rollback failed. Manual intervention required!"
                get_container_logs "$CONTAINER_NAME" 100
            fi
        else
            log_error "No previous image available for rollback"
            get_container_logs "$CONTAINER_NAME" 100
        fi

        exit 1
    fi

    log_success "Backend is healthy and responding"

    # Show recent logs
    log_info "Recent logs:"
    get_container_logs "$CONTAINER_NAME" 20
else
    log_info "[DRY-RUN] Would check health at: $HEALTH_URL"
fi

# Step 7: Cleanup old images
log_step "Cleaning up old images..."

if [[ "$DRY_RUN" == "false" ]]; then
    cleanup_dangling_images
    keep_latest_images "$IMAGE_NAME" "$KEEP_IMAGES"
    log_success "Cleanup completed"
else
    log_info "[DRY-RUN] Would cleanup old images (keep $KEEP_IMAGES latest)"
fi

# Deployment summary
END_TIME=$(date +%s)
DURATION=$((END_TIME - START_TIME))

COMMIT=$(get_short_commit)
DEPLOYMENT_LOG="Backend deployed successfully
Commit: $COMMIT
Duration: ${DURATION}s
Image: $(docker inspect --format='{{.Config.Image}}' "$CONTAINER_NAME" 2>/dev/null || echo "N/A")
Health: OK"

display_deployment_summary "$SERVICE_NAME" "SUCCESS" "$DURATION" "$DEPLOYMENT_LOG"

if [[ "$DRY_RUN" == "false" ]]; then
    save_deployment_log "$DEPLOYMENT_LOG" "$SERVICE_NAME"
fi

log_success "Backend deployment completed successfully in ${DURATION}s"

exit 0
