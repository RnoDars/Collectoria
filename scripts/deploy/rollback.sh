#!/bin/bash
#
# rollback.sh - Rollback Collectoria Services to Previous Versions
#
# Description:
#   Rollback backend and/or frontend to a previous Docker image version
#   with health checks and confirmation prompts
#
# Usage:
#   ./rollback.sh [OPTIONS]
#
# Options:
#   --backend         Rollback backend only
#   --frontend        Rollback frontend only
#   --both            Rollback both services (default)
#   --to-tag TAG      Rollback to specific tag (skip interactive selection)
#   --yes             Skip confirmation prompts
#
# Examples:
#   ./rollback.sh                         # Interactive rollback (both services)
#   ./rollback.sh --backend               # Rollback backend only
#   ./rollback.sh --frontend --to-tag v1.2.3  # Rollback frontend to specific version
#
# Environment:
#   PROJECT_DIR       Path to Collectoria project (default: /home/collectoria/Collectoria)
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

# Parse command line arguments
ROLLBACK_BACKEND=false
ROLLBACK_FRONTEND=false
TARGET_TAG=""
SKIP_CONFIRM=false

while [[ $# -gt 0 ]]; do
    case $1 in
        --backend)
            ROLLBACK_BACKEND=true
            shift
            ;;
        --frontend)
            ROLLBACK_FRONTEND=true
            shift
            ;;
        --both)
            ROLLBACK_BACKEND=true
            ROLLBACK_FRONTEND=true
            shift
            ;;
        --to-tag)
            TARGET_TAG="$2"
            shift 2
            ;;
        --yes)
            SKIP_CONFIRM=true
            shift
            ;;
        *)
            log_error "Unknown option: $1"
            echo "Usage: $0 [--backend] [--frontend] [--both] [--to-tag TAG] [--yes]"
            exit 1
            ;;
    esac
done

# Default to both if neither specified
if [[ "$ROLLBACK_BACKEND" == "false" && "$ROLLBACK_FRONTEND" == "false" ]]; then
    ROLLBACK_BACKEND=true
    ROLLBACK_FRONTEND=true
fi

print_header "Rollback - Collectoria"

log_warning "This will rollback services to previous versions"
echo ""
log_info "Rollback plan:"
echo "  Backend: $([ "$ROLLBACK_BACKEND" == "true" ] && echo "YES" || echo "NO")"
echo "  Frontend: $([ "$ROLLBACK_FRONTEND" == "true" ] && echo "YES" || echo "NO")"
echo ""

# Preflight checks
check_permissions

if [[ ! -d "$PROJECT_DIR" ]]; then
    log_error "Project directory not found: $PROJECT_DIR"
    exit 1
fi

check_compose_file "$COMPOSE_FILE"

cd "$PROJECT_DIR"

# Function to rollback a service
rollback_service() {
    local service_name="$1"
    local container_name="$2"
    local image_repository="$3"
    local health_url="$4"

    print_header "Rollback $service_name"

    # Get current image
    CURRENT_IMAGE=""
    if check_container_exists "$container_name"; then
        CURRENT_IMAGE=$(docker inspect --format='{{.Config.Image}}' "$container_name" 2>/dev/null || echo "")
        log_info "Current image: $CURRENT_IMAGE"
    else
        log_warning "Container $container_name does not exist"
    fi

    echo ""

    # List available images
    log_info "Available images for $service_name (showing last 5):"
    echo ""

    list_repository_images "$image_repository" 5

    # Select target image
    local selected_tag=""

    if [[ -n "$TARGET_TAG" ]]; then
        selected_tag="$TARGET_TAG"
        log_info "Using specified tag: $selected_tag"
    else
        echo ""
        read -p "Enter tag to rollback to (or 'cancel'): " selected_tag

        if [[ "$selected_tag" == "cancel" || -z "$selected_tag" ]]; then
            log_info "Rollback cancelled"
            return 0
        fi
    fi

    local target_image="${image_repository}:${selected_tag}"

    # Verify image exists
    if ! image_exists "$target_image"; then
        log_error "Image not found: $target_image"
        return 1
    fi

    log_info "Target image: $target_image"

    # Confirmation
    if [[ "$SKIP_CONFIRM" == "false" ]]; then
        echo ""
        if ! confirm "Rollback $service_name to $selected_tag?"; then
            log_info "Rollback cancelled"
            return 0
        fi
    fi

    echo ""
    log_step "Stopping current $service_name container..."

    if check_container_running "$container_name"; then
        docker-compose -f "$COMPOSE_FILE" stop "$service_name"
        log_success "Container stopped"
    fi

    log_step "Tagging target image..."
    docker tag "$target_image" "${image_repository}:latest"

    log_step "Starting $service_name with rollback image..."
    docker-compose -f "$COMPOSE_FILE" up -d "$service_name"

    sleep 3

    log_step "Checking health..."
    if check_service_health "$service_name" "$health_url" 30 2; then
        log_success "$service_name rollback successful"

        # Show logs
        echo ""
        log_info "Recent logs:"
        get_container_logs "$container_name" 15

        return 0
    else
        log_error "$service_name rollback failed health check"

        # Attempt to restore current image if available
        if [[ -n "$CURRENT_IMAGE" ]]; then
            log_warning "Attempting to restore original image: $CURRENT_IMAGE"
            docker-compose -f "$COMPOSE_FILE" stop "$service_name"
            docker tag "$CURRENT_IMAGE" "${image_repository}:latest"
            docker-compose -f "$COMPOSE_FILE" up -d "$service_name"

            if check_service_health "$service_name" "$health_url" 20 2; then
                log_success "Original image restored"
            else
                log_error "Failed to restore original image. Manual intervention required!"
            fi
        fi

        get_container_logs "$container_name" 50
        return 1
    fi
}

# Rollback backend
if [[ "$ROLLBACK_BACKEND" == "true" ]]; then
    if ! rollback_service "backend" "collectoria-backend" "collectoria-backend" "http://localhost:8080/api/v1/health"; then
        log_error "Backend rollback failed"
        exit 1
    fi

    # Reset target tag for frontend (if different versions needed)
    if [[ "$ROLLBACK_FRONTEND" == "true" ]]; then
        TARGET_TAG=""
    fi
fi

# Rollback frontend
if [[ "$ROLLBACK_FRONTEND" == "true" ]]; then
    if ! rollback_service "frontend" "collectoria-frontend" "collectoria-frontend" "http://localhost:3000"; then
        log_error "Frontend rollback failed"
        exit 1
    fi
fi

# Final health check
print_header "Final Health Check"

ALL_HEALTHY=true

if [[ "$ROLLBACK_BACKEND" == "true" ]]; then
    if ! check_service_health "backend" "http://localhost:8080/api/v1/health" 10 1; then
        ALL_HEALTHY=false
    fi
    echo ""
fi

if [[ "$ROLLBACK_FRONTEND" == "true" ]]; then
    if ! check_service_health "frontend" "http://localhost:3000" 10 1; then
        ALL_HEALTHY=false
    fi
    echo ""
fi

# Summary
print_header "Rollback Summary"

if [[ "$ALL_HEALTHY" == "true" ]]; then
    log_success "Rollback completed successfully"

    SUMMARY="Rollback completed
Services rolled back:
"
    if [[ "$ROLLBACK_BACKEND" == "true" ]]; then
        BACKEND_IMAGE=$(docker inspect --format='{{.Config.Image}}' "collectoria-backend" 2>/dev/null || echo "N/A")
        SUMMARY+="  - Backend: $BACKEND_IMAGE
"
    fi

    if [[ "$ROLLBACK_FRONTEND" == "true" ]]; then
        FRONTEND_IMAGE=$(docker inspect --format='{{.Config.Image}}' "collectoria-frontend" 2>/dev/null || echo "N/A")
        SUMMARY+="  - Frontend: $FRONTEND_IMAGE
"
    fi

    SUMMARY+="
Timestamp: $(date +'%Y-%m-%d %H:%M:%S')
"

    echo "$SUMMARY"

    save_deployment_log "$SUMMARY" "rollback"

    exit 0
else
    log_error "Rollback completed but some services are unhealthy"
    exit 1
fi
