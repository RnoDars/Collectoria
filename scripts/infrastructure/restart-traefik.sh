#!/bin/bash
#
# restart-traefik.sh - Restart Traefik Reverse Proxy
#
# Description:
#   Restarts Traefik container after configuration changes with health checks
#   and SSL certificate verification
#
# Usage:
#   ./restart-traefik.sh [OPTIONS]
#
# Options:
#   --skip-pull       Skip git pull (use current config)
#   --force           Force restart without confirmation
#
# Examples:
#   ./restart-traefik.sh                  # Standard restart with git pull
#   ./restart-traefik.sh --skip-pull      # Restart without updating config
#   ./restart-traefik.sh --force          # Force restart without confirmation
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
SERVICE_NAME="traefik"
CONTAINER_NAME="traefik"

# Parse command line arguments
SKIP_PULL=false
FORCE=false

while [[ $# -gt 0 ]]; do
    case $1 in
        --skip-pull)
            SKIP_PULL=true
            shift
            ;;
        --force)
            FORCE=true
            shift
            ;;
        *)
            log_error "Unknown option: $1"
            echo "Usage: $0 [--skip-pull] [--force]"
            exit 1
            ;;
    esac
done

print_header "Restart Traefik - Collectoria"

log_info "This will restart the Traefik reverse proxy"
log_warning "There may be brief downtime during restart"
echo ""

# Preflight checks
check_permissions

if [[ ! -d "$PROJECT_DIR" ]]; then
    log_error "Project directory not found: $PROJECT_DIR"
    exit 1
fi

check_compose_file "$COMPOSE_FILE"

cd "$PROJECT_DIR"

# Confirmation
if [[ "$FORCE" == "false" ]]; then
    if ! confirm "Proceed with Traefik restart?"; then
        log_info "Restart cancelled"
        exit 0
    fi
    echo ""
fi

# Step 1: Git pull for config updates (unless skipped)
if [[ "$SKIP_PULL" == "false" ]]; then
    log_step "Updating configuration from Git repository..."

    CURRENT_COMMIT=$(get_current_commit)
    log_info "Current commit: $CURRENT_COMMIT"

    git pull origin main

    NEW_COMMIT=$(get_current_commit)
    log_info "New commit: $NEW_COMMIT"

    if [[ "$CURRENT_COMMIT" == "$NEW_COMMIT" ]]; then
        log_info "No configuration changes"
    else
        log_success "Configuration updated"
    fi
else
    log_info "Skipping git pull (--skip-pull flag)"
fi

# Step 2: Check current Traefik status
log_step "Checking current Traefik status..."

if check_container_running "$CONTAINER_NAME"; then
    log_info "Traefik is currently running"

    # Show current uptime
    UPTIME=$(docker inspect --format='{{.State.StartedAt}}' "$CONTAINER_NAME" 2>/dev/null)
    log_info "Container started: $UPTIME"
else
    log_warning "Traefik is not running"
fi

# Step 3: Restart Traefik
log_step "Restarting Traefik..."

docker-compose -f "$COMPOSE_FILE" restart "$SERVICE_NAME"

log_success "Traefik restarted"

# Step 4: Wait for Traefik to start
log_step "Waiting for Traefik to be ready..."

sleep 5

if ! check_container_running "$CONTAINER_NAME"; then
    log_error "Traefik container is not running after restart"
    get_container_logs "$CONTAINER_NAME" 50
    exit 1
fi

log_success "Traefik container is running"

# Step 5: Health checks
log_step "Running health checks..."

ALL_HEALTHY=true

# Check HTTP port (80)
if check_service_health "Traefik HTTP" "http://localhost:80" 10 1; then
    echo ""
else
    log_error "Traefik HTTP port not responding"
    ALL_HEALTHY=false
fi

# Check HTTPS port (443)
if check_service_health "Traefik HTTPS" "https://localhost:443" 10 1; then
    echo ""
else
    log_error "Traefik HTTPS port not responding"
    ALL_HEALTHY=false
fi

# Check dashboard (if enabled)
if curl -sf http://localhost:8080/dashboard/ >/dev/null 2>&1; then
    log_success "Traefik dashboard accessible"
else
    log_info "Traefik dashboard not accessible (may be disabled)"
fi

# Step 6: Verify SSL certificates
log_step "Checking SSL certificates..."

# Check if certificate files exist
if [[ -f "/etc/letsencrypt/live/darsling.fr/cert.pem" ]]; then
    CERT_EXPIRY=$(openssl x509 -enddate -noout -in /etc/letsencrypt/live/darsling.fr/cert.pem 2>/dev/null | cut -d= -f2)
    CERT_EXPIRY_EPOCH=$(date -d "$CERT_EXPIRY" +%s 2>/dev/null || echo 0)
    NOW_EPOCH=$(date +%s)
    DAYS_UNTIL_EXPIRY=$(( ($CERT_EXPIRY_EPOCH - $NOW_EPOCH) / 86400 ))

    log_info "SSL certificate expires in $DAYS_UNTIL_EXPIRY days"

    if [[ $DAYS_UNTIL_EXPIRY -lt 30 ]]; then
        log_warning "SSL certificate expiring soon (less than 30 days)"
    else
        log_success "SSL certificate valid"
    fi
else
    log_warning "SSL certificate not found at /etc/letsencrypt/live/darsling.fr/"
    log_info "Certificates may be managed differently on this host"
fi

# Step 7: Test external endpoints
log_step "Testing external endpoints..."

# Test frontend through Traefik
if curl -sf -L https://darsling.fr >/dev/null 2>&1; then
    log_success "Frontend accessible: https://darsling.fr"
else
    log_error "Frontend not accessible through Traefik"
    ALL_HEALTHY=false
fi

# Test backend through Traefik
if curl -sf https://api.darsling.fr/api/v1/health >/dev/null 2>&1; then
    log_success "Backend API accessible: https://api.darsling.fr"
else
    log_error "Backend API not accessible through Traefik"
    ALL_HEALTHY=false
fi

# Step 8: Show recent logs
log_step "Recent Traefik logs:"
echo ""
get_container_logs "$CONTAINER_NAME" 20

# Summary
print_header "Restart Summary"

if [[ "$ALL_HEALTHY" == "true" ]]; then
    log_success "Traefik restart completed successfully"
    log_info "All endpoints are accessible"

    SUMMARY="Traefik restarted successfully
All health checks passed
Timestamp: $(date +'%Y-%m-%d %H:%M:%S')"

    save_deployment_log "$SUMMARY" "traefik-restart"

    exit 0
else
    log_error "Traefik restarted but some health checks failed"
    log_warning "Check logs above for details"
    exit 1
fi
