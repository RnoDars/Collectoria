#!/bin/bash
#
# deploy-full.sh - Full Deployment of Collectoria (Backend + Frontend)
#
# Description:
#   Deploys both backend and frontend services with coordinated health checks
#   and comprehensive cleanup
#
# Usage:
#   ./deploy-full.sh [OPTIONS]
#
# Options:
#   --no-cache        Force Docker build without cache (both services)
#   --skip-tests      Skip Go tests before deployment
#   --skip-pull       Skip git pull (use current code)
#   --dry-run         Show what would be done without executing
#   --backend-only    Deploy only backend
#   --frontend-only   Deploy only frontend
#
# Examples:
#   ./deploy-full.sh                    # Deploy both services
#   ./deploy-full.sh --no-cache         # Full rebuild without cache
#   ./deploy-full.sh --backend-only     # Deploy only backend
#   ./deploy-full.sh --dry-run          # Preview actions
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

# Parse command line arguments
NO_CACHE_FLAG=""
SKIP_TESTS_FLAG=""
SKIP_PULL_FLAG=""
DRY_RUN_FLAG=""
DEPLOY_BACKEND=true
DEPLOY_FRONTEND=true

while [[ $# -gt 0 ]]; do
    case $1 in
        --no-cache)
            NO_CACHE_FLAG="--no-cache"
            shift
            ;;
        --skip-tests)
            SKIP_TESTS_FLAG="--skip-tests"
            shift
            ;;
        --skip-pull)
            SKIP_PULL_FLAG="--skip-pull"
            shift
            ;;
        --dry-run)
            DRY_RUN_FLAG="--dry-run"
            shift
            ;;
        --backend-only)
            DEPLOY_FRONTEND=false
            shift
            ;;
        --frontend-only)
            DEPLOY_BACKEND=false
            shift
            ;;
        *)
            log_error "Unknown option: $1"
            echo "Usage: $0 [--no-cache] [--skip-tests] [--skip-pull] [--dry-run] [--backend-only] [--frontend-only]"
            exit 1
            ;;
    esac
done

# Start deployment
START_TIME=$(date +%s)

print_header "Full Deployment - Collectoria"

log_info "Deployment plan:"
echo "  Backend: $([ "$DEPLOY_BACKEND" == "true" ] && echo "YES" || echo "NO")"
echo "  Frontend: $([ "$DEPLOY_FRONTEND" == "true" ] && echo "YES" || echo "NO")"
echo "  Options: $NO_CACHE_FLAG $SKIP_TESTS_FLAG $SKIP_PULL_FLAG $DRY_RUN_FLAG"
echo ""

if [[ "$DEPLOY_BACKEND" == "false" && "$DEPLOY_FRONTEND" == "false" ]]; then
    log_error "Cannot use both --backend-only and --frontend-only"
    exit 1
fi

# Preflight checks
log_step "Running preflight checks..."

check_permissions

if [[ ! -d "$PROJECT_DIR" ]]; then
    log_error "Project directory not found: $PROJECT_DIR"
    exit 1
fi

cd "$PROJECT_DIR"

# Check disk space
if ! check_disk_space 10 "/"; then
    log_warning "Low disk space detected. Consider running cleanup script first."
    if [[ -z "$DRY_RUN_FLAG" ]]; then
        if ! confirm "Continue anyway?"; then
            exit 1
        fi
    fi
fi

# Show current status before deployment
print_header "Current Status"

log_info "Docker disk usage before deployment:"
check_docker_disk_usage

if [[ -n "$(get_current_commit)" ]]; then
    log_info "Current commit: $(get_current_commit)"
    log_info "Current branch: $(get_current_branch)"
fi

# Deploy Backend
BACKEND_SUCCESS=false
if [[ "$DEPLOY_BACKEND" == "true" ]]; then
    print_header "Deploying Backend"

    if "$SCRIPT_DIR/deploy-backend.sh" $NO_CACHE_FLAG $SKIP_TESTS_FLAG $SKIP_PULL_FLAG $DRY_RUN_FLAG; then
        log_success "Backend deployment successful"
        BACKEND_SUCCESS=true
    else
        log_error "Backend deployment failed"

        if [[ "$DEPLOY_FRONTEND" == "true" ]]; then
            log_warning "Skipping frontend deployment due to backend failure"
        fi

        exit 1
    fi
else
    log_info "Skipping backend deployment (--frontend-only)"
    BACKEND_SUCCESS=true
fi

# Deploy Frontend
FRONTEND_SUCCESS=false
if [[ "$DEPLOY_FRONTEND" == "true" ]]; then
    print_header "Deploying Frontend"

    # For frontend, we can skip pull since backend already did it
    FRONTEND_SKIP_PULL=""
    if [[ "$DEPLOY_BACKEND" == "true" ]]; then
        FRONTEND_SKIP_PULL="--skip-pull"
    fi

    if "$SCRIPT_DIR/deploy-frontend.sh" $NO_CACHE_FLAG $FRONTEND_SKIP_PULL $SKIP_PULL_FLAG $DRY_RUN_FLAG; then
        log_success "Frontend deployment successful"
        FRONTEND_SUCCESS=true
    else
        log_error "Frontend deployment failed"

        if [[ "$BACKEND_SUCCESS" == "true" ]]; then
            log_warning "Backend was deployed successfully, but frontend failed"
            log_info "System is partially deployed. Consider rolling back backend or fixing frontend."
        fi

        exit 1
    fi
else
    log_info "Skipping frontend deployment (--backend-only)"
    FRONTEND_SUCCESS=true
fi

# Global health check
if [[ -z "$DRY_RUN_FLAG" ]]; then
    print_header "Global Health Check"

    log_step "Verifying all services..."

    ALL_HEALTHY=true

    # Check backend
    if [[ "$DEPLOY_BACKEND" == "true" ]]; then
        if check_service_health "backend" "http://localhost:8080/api/v1/health" 10 1; then
            echo ""
        else
            ALL_HEALTHY=false
        fi
    fi

    # Check frontend
    if [[ "$DEPLOY_FRONTEND" == "true" ]]; then
        if check_service_health "frontend" "http://localhost:3000" 10 1; then
            echo ""
        else
            ALL_HEALTHY=false
        fi
    fi

    # Check Traefik
    if check_service_health "Traefik" "http://localhost:80" 5 1; then
        echo ""
    else
        log_warning "Traefik health check failed (non-critical)"
    fi

    if [[ "$ALL_HEALTHY" == "true" ]]; then
        log_success "All services are healthy"
    else
        log_error "Some services are not healthy"
        exit 1
    fi
fi

# Global cleanup
if [[ -z "$DRY_RUN_FLAG" ]]; then
    print_header "Global Cleanup"

    log_step "Cleaning up Docker resources..."

    cleanup_dangling_images
    cleanup_unused_networks

    log_info "Docker disk usage after deployment:"
    check_docker_disk_usage
fi

# Final summary
END_TIME=$(date +%s)
DURATION=$((END_TIME - START_TIME))

print_header "Deployment Complete"

COMMIT=$(get_short_commit)

SUMMARY="Full deployment completed successfully

Deployed Services:
"

if [[ "$DEPLOY_BACKEND" == "true" ]]; then
    SUMMARY+="  - Backend: SUCCESS
"
fi

if [[ "$DEPLOY_FRONTEND" == "true" ]]; then
    SUMMARY+="  - Frontend: SUCCESS
"
fi

SUMMARY+="
Commit: $COMMIT
Duration: ${DURATION}s
Timestamp: $(date +'%Y-%m-%d %H:%M:%S')
"

echo "$SUMMARY"

if [[ -z "$DRY_RUN_FLAG" ]]; then
    save_deployment_log "$SUMMARY" "full"
fi

log_success "Full deployment completed in ${DURATION}s"

# Show URLs
echo ""
log_info "Application URLs:"
echo "  Frontend: https://darsling.fr"
echo "  Backend API: https://api.darsling.fr"
echo "  Health Check: https://api.darsling.fr/api/v1/health"
echo ""

exit 0
