#!/bin/bash
#
# restart-postgres.sh - Restart PostgreSQL Database (DANGEROUS)
#
# Description:
#   Restarts PostgreSQL container with proper shutdown of dependent services
#   WARNING: This causes downtime! Use with extreme caution.
#
# Usage:
#   ./restart-postgres.sh [OPTIONS]
#
# Options:
#   --force           Skip confirmation prompts (USE WITH CAUTION)
#   --backup          Create backup before restart (recommended)
#
# Examples:
#   ./restart-postgres.sh                 # Standard restart with confirmation
#   ./restart-postgres.sh --backup        # Backup database before restart
#
# WARNING:
#   - This will cause downtime for all services
#   - Backend will be stopped during PostgreSQL restart
#   - Use only when absolutely necessary (e.g., config changes, maintenance)
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
SERVICE_NAME="postgres"
CONTAINER_NAME="collectoria-postgres"
BACKEND_SERVICE="backend"
BACKEND_CONTAINER="collectoria-backend"

# Parse command line arguments
FORCE=false
CREATE_BACKUP=false

while [[ $# -gt 0 ]]; do
    case $1 in
        --force)
            FORCE=true
            shift
            ;;
        --backup)
            CREATE_BACKUP=true
            shift
            ;;
        *)
            log_error "Unknown option: $1"
            echo "Usage: $0 [--force] [--backup]"
            exit 1
            ;;
    esac
done

print_header "Restart PostgreSQL - Collectoria"

# CRITICAL WARNING
echo ""
echo -e "${RED}╔════════════════════════════════════════════════════════════╗${NC}"
echo -e "${RED}║                     ⚠️  WARNING  ⚠️                         ║${NC}"
echo -e "${RED}║                                                            ║${NC}"
echo -e "${RED}║  This operation will restart the PostgreSQL database      ║${NC}"
echo -e "${RED}║  and cause DOWNTIME for all services!                     ║${NC}"
echo -e "${RED}║                                                            ║${NC}"
echo -e "${RED}║  Impact:                                                   ║${NC}"
echo -e "${RED}║    - Backend will be stopped                               ║${NC}"
echo -e "${RED}║    - Database connections will be terminated               ║${NC}"
echo -e "${RED}║    - Users cannot access the application                   ║${NC}"
echo -e "${RED}║                                                            ║${NC}"
echo -e "${RED}║  Only proceed if absolutely necessary!                     ║${NC}"
echo -e "${RED}╚════════════════════════════════════════════════════════════╝${NC}"
echo ""

# Preflight checks
check_permissions

if [[ ! -d "$PROJECT_DIR" ]]; then
    log_error "Project directory not found: $PROJECT_DIR"
    exit 1
fi

check_compose_file "$COMPOSE_FILE"

cd "$PROJECT_DIR"

# Double confirmation (unless forced)
if [[ "$FORCE" == "false" ]]; then
    if ! confirm "Do you understand this will cause downtime?"; then
        log_info "Operation cancelled"
        exit 0
    fi

    echo ""
    if ! confirm "Are you absolutely sure you want to restart PostgreSQL?"; then
        log_info "Operation cancelled"
        exit 0
    fi

    echo ""
fi

# Optional backup
if [[ "$CREATE_BACKUP" == "true" ]]; then
    log_step "Creating database backup before restart..."

    if [[ -x "$SCRIPT_DIR/../database/backup-db.sh" ]]; then
        if "$SCRIPT_DIR/../database/backup-db.sh" --skip-confirm; then
            log_success "Backup created successfully"
        else
            log_error "Backup failed"

            if ! confirm "Continue without backup?"; then
                exit 1
            fi
        fi
    else
        log_warning "Backup script not found, skipping backup"
    fi

    echo ""
fi

# Step 1: Check current status
log_step "Checking current status..."

POSTGRES_RUNNING=false
BACKEND_RUNNING=false

if check_container_running "$CONTAINER_NAME"; then
    POSTGRES_RUNNING=true
    log_info "PostgreSQL is running"

    # Show uptime
    UPTIME=$(docker inspect --format='{{.State.StartedAt}}' "$CONTAINER_NAME" 2>/dev/null)
    log_info "PostgreSQL started: $UPTIME"

    # Show connections
    CONNECTIONS=$(docker exec "$CONTAINER_NAME" psql -U collectoria -t -c "SELECT count(*) FROM pg_stat_activity WHERE datname='collectoria';" 2>/dev/null | xargs || echo "0")
    log_info "Active connections: $CONNECTIONS"
else
    log_warning "PostgreSQL is not running"
fi

if check_container_running "$BACKEND_CONTAINER"; then
    BACKEND_RUNNING=true
    log_info "Backend is running"
else
    log_info "Backend is not running"
fi

echo ""

# Step 2: Stop backend first (to prevent connection errors)
if [[ "$BACKEND_RUNNING" == "true" ]]; then
    log_step "Stopping backend service..."

    docker-compose -f "$COMPOSE_FILE" stop "$BACKEND_SERVICE"

    log_success "Backend stopped"

    # Wait a moment for connections to close
    sleep 2
fi

# Step 3: Restart PostgreSQL
log_step "Restarting PostgreSQL..."

docker-compose -f "$COMPOSE_FILE" restart "$SERVICE_NAME"

log_success "PostgreSQL restart command sent"

# Step 4: Wait for PostgreSQL to be ready
log_step "Waiting for PostgreSQL to be ready..."

sleep 5

MAX_RETRIES=30
RETRY_INTERVAL=2

for i in $(seq 1 $MAX_RETRIES); do
    if docker exec "$CONTAINER_NAME" pg_isready -U collectoria >/dev/null 2>&1; then
        log_success "PostgreSQL is ready"
        break
    fi

    if [[ $i -eq $MAX_RETRIES ]]; then
        log_error "PostgreSQL failed to become ready after $MAX_RETRIES attempts"
        log_error "Check logs:"
        get_container_logs "$CONTAINER_NAME" 50
        exit 1
    fi

    echo -n "."
    sleep $RETRY_INTERVAL
done

echo ""

# Verify database is accessible
log_step "Verifying database access..."

if docker exec "$CONTAINER_NAME" psql -U collectoria -c "SELECT 1;" >/dev/null 2>&1; then
    log_success "Database is accessible"
else
    log_error "Cannot access database"
    get_container_logs "$CONTAINER_NAME" 50
    exit 1
fi

# Step 5: Restart backend
if [[ "$BACKEND_RUNNING" == "true" ]]; then
    log_step "Restarting backend service..."

    docker-compose -f "$COMPOSE_FILE" up -d "$BACKEND_SERVICE"

    log_success "Backend started"

    # Wait for backend to be ready
    sleep 5

    # Health check backend
    if check_service_health "backend" "http://localhost:8080/api/v1/health" 30 2; then
        log_success "Backend is healthy"
    else
        log_error "Backend health check failed"
        get_container_logs "$BACKEND_CONTAINER" 50
        exit 1
    fi
else
    log_info "Backend was not running before restart, not starting it"
fi

# Step 6: Final verification
log_step "Running final verification..."

# Check PostgreSQL is still responding
if ! docker exec "$CONTAINER_NAME" pg_isready -U collectoria >/dev/null 2>&1; then
    log_error "PostgreSQL is not responding"
    exit 1
fi

# Test database query
if docker exec "$CONTAINER_NAME" psql -U collectoria -c "SELECT NOW();" >/dev/null 2>&1; then
    log_success "Database queries working"
else
    log_error "Database queries failing"
    exit 1
fi

# Show connection count
CONNECTIONS=$(docker exec "$CONTAINER_NAME" psql -U collectoria -t -c "SELECT count(*) FROM pg_stat_activity WHERE datname='collectoria';" 2>/dev/null | xargs || echo "0")
log_info "Active connections: $CONNECTIONS"

# Step 7: Show recent logs
echo ""
log_info "Recent PostgreSQL logs:"
get_container_logs "$CONTAINER_NAME" 20

# Summary
print_header "Restart Summary"

log_success "PostgreSQL restart completed successfully"
log_success "All services are operational"

SUMMARY="PostgreSQL restarted successfully
Backend restarted: $([ "$BACKEND_RUNNING" == "true" ] && echo "YES" || echo "NO")
Active connections: $CONNECTIONS
Timestamp: $(date +'%Y-%m-%d %H:%M:%S')"

echo ""
echo "$SUMMARY"

save_deployment_log "$SUMMARY" "postgres-restart"

log_info "System is fully operational"

exit 0
