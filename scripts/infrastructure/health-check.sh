#!/bin/bash
#
# health-check.sh - Comprehensive Health Check for Collectoria Services
#
# Description:
#   Checks the health of all Collectoria services including Traefik, Backend,
#   Frontend, PostgreSQL, and SSL certificates
#
# Usage:
#   ./health-check.sh [OPTIONS]
#
# Options:
#   --verbose         Show detailed information
#   --json            Output results in JSON format
#   --fail-fast       Exit on first failure
#
# Examples:
#   ./health-check.sh                    # Standard health check
#   ./health-check.sh --verbose          # Detailed information
#   ./health-check.sh --json             # JSON output for monitoring
#
# Exit Codes:
#   0 - All services healthy
#   1 - One or more services unhealthy
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
VERBOSE=false
JSON_OUTPUT=false
FAIL_FAST=false

while [[ $# -gt 0 ]]; do
    case $1 in
        --verbose)
            VERBOSE=true
            shift
            ;;
        --json)
            JSON_OUTPUT=true
            shift
            ;;
        --fail-fast)
            FAIL_FAST=true
            shift
            ;;
        *)
            log_error "Unknown option: $1"
            echo "Usage: $0 [--verbose] [--json] [--fail-fast]"
            exit 1
            ;;
    esac
done

# Results tracking
ALL_HEALTHY=true
RESULTS=()

# Check function
check_component() {
    local name="$1"
    local check_command="$2"
    local is_critical="${3:-true}"

    if [[ "$JSON_OUTPUT" == "false" ]]; then
        log_step "Checking $name..."
    fi

    if eval "$check_command"; then
        if [[ "$JSON_OUTPUT" == "false" ]]; then
            log_success "$name: HEALTHY"
        fi
        RESULTS+=("$name:OK")
        return 0
    else
        if [[ "$JSON_OUTPUT" == "false" ]]; then
            if [[ "$is_critical" == "true" ]]; then
                log_error "$name: UNHEALTHY"
            else
                log_warning "$name: UNHEALTHY (non-critical)"
            fi
        fi
        RESULTS+=("$name:FAIL")

        if [[ "$is_critical" == "true" ]]; then
            ALL_HEALTHY=false
        fi

        if [[ "$FAIL_FAST" == "true" && "$is_critical" == "true" ]]; then
            exit 1
        fi

        return 1
    fi
}

# Start health checks
if [[ "$JSON_OUTPUT" == "false" ]]; then
    print_header "Collectoria Health Check"
    log_info "Timestamp: $(date +'%Y-%m-%d %H:%M:%S')"
    echo ""
fi

# 1. Check Traefik
check_component "Traefik (HTTP)" "curl -sf http://localhost:80 >/dev/null 2>&1" false
check_component "Traefik (HTTPS)" "curl -sf -k https://localhost:443 >/dev/null 2>&1" false

if [[ "$VERBOSE" == "true" && "$JSON_OUTPUT" == "false" ]]; then
    if check_container_running "traefik"; then
        log_info "Traefik container status: RUNNING"
        docker ps --filter name=traefik --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"
    fi
fi

# 2. Check Backend
check_component "Backend (Container)" "check_container_running 'collectoria-backend'" true

if check_container_running "collectoria-backend"; then
    check_component "Backend (Health Endpoint)" "curl -sf http://localhost:8080/api/v1/health >/dev/null 2>&1" true

    if [[ "$VERBOSE" == "true" && "$JSON_OUTPUT" == "false" ]]; then
        log_info "Backend health response:"
        curl -s http://localhost:8080/api/v1/health | jq . 2>/dev/null || curl -s http://localhost:8080/api/v1/health
        echo ""
    fi
fi

# 3. Check Frontend
check_component "Frontend (Container)" "check_container_running 'collectoria-frontend'" true

if check_container_running "collectoria-frontend"; then
    check_component "Frontend (HTTP)" "curl -sf http://localhost:3000 >/dev/null 2>&1" true

    if [[ "$VERBOSE" == "true" && "$JSON_OUTPUT" == "false" ]]; then
        log_info "Frontend responding on port 3000"
    fi
fi

# 4. Check PostgreSQL
check_component "PostgreSQL (Container)" "check_container_running 'collectoria-postgres'" true

if check_container_running "collectoria-postgres"; then
    check_component "PostgreSQL (Ready)" "docker exec collectoria-postgres pg_isready -U collectoria >/dev/null 2>&1" true

    if [[ "$VERBOSE" == "true" && "$JSON_OUTPUT" == "false" ]]; then
        log_info "Database connection details:"
        docker exec collectoria-postgres psql -U collectoria -c "SELECT version();" 2>/dev/null | head -3 || echo "  Could not retrieve version"
    fi
fi

# 5. Check SSL Certificates
if [[ -f "/etc/letsencrypt/live/darsling.fr/cert.pem" ]]; then
    check_component "SSL Certificate (Exists)" "test -f /etc/letsencrypt/live/darsling.fr/cert.pem" false

    # Check expiration
    CERT_EXPIRY=$(openssl x509 -enddate -noout -in /etc/letsencrypt/live/darsling.fr/cert.pem 2>/dev/null | cut -d= -f2)
    CERT_EXPIRY_EPOCH=$(date -d "$CERT_EXPIRY" +%s 2>/dev/null || echo 0)
    NOW_EPOCH=$(date +%s)
    DAYS_UNTIL_EXPIRY=$(( ($CERT_EXPIRY_EPOCH - $NOW_EPOCH) / 86400 ))

    if [[ $DAYS_UNTIL_EXPIRY -gt 30 ]]; then
        check_component "SSL Certificate (Valid)" "true" false
        if [[ "$VERBOSE" == "true" && "$JSON_OUTPUT" == "false" ]]; then
            log_info "Certificate expires in $DAYS_UNTIL_EXPIRY days"
        fi
    elif [[ $DAYS_UNTIL_EXPIRY -gt 7 ]]; then
        if [[ "$JSON_OUTPUT" == "false" ]]; then
            log_warning "SSL Certificate expires in $DAYS_UNTIL_EXPIRY days (renewal recommended)"
        fi
        RESULTS+=("SSL_Expiry:WARNING")
    else
        if [[ "$JSON_OUTPUT" == "false" ]]; then
            log_error "SSL Certificate expires in $DAYS_UNTIL_EXPIRY days (URGENT)"
        fi
        RESULTS+=("SSL_Expiry:CRITICAL")
        ALL_HEALTHY=false
    fi
else
    if [[ "$JSON_OUTPUT" == "false" ]]; then
        log_warning "SSL certificate not found (may be on different host)"
    fi
    RESULTS+=("SSL_Certificate:NOTFOUND")
fi

# 6. Check external endpoints (public URLs)
if [[ "$VERBOSE" == "true" && "$JSON_OUTPUT" == "false" ]]; then
    echo ""
    log_step "Checking external endpoints..."

    check_component "Frontend (https://darsling.fr)" "curl -sf -L https://darsling.fr >/dev/null 2>&1" false
    check_component "Backend API (https://api.darsling.fr)" "curl -sf https://api.darsling.fr/api/v1/health >/dev/null 2>&1" false
fi

# 7. Check disk space
DISK_USAGE=$(df -h / | awk 'NR==2 {print $5}' | sed 's/%//')
if [[ $DISK_USAGE -gt 90 ]]; then
    if [[ "$JSON_OUTPUT" == "false" ]]; then
        log_error "Disk usage critical: ${DISK_USAGE}%"
    fi
    RESULTS+=("Disk_Space:CRITICAL")
    ALL_HEALTHY=false
elif [[ $DISK_USAGE -gt 80 ]]; then
    if [[ "$JSON_OUTPUT" == "false" ]]; then
        log_warning "Disk usage high: ${DISK_USAGE}%"
    fi
    RESULTS+=("Disk_Space:WARNING")
else
    if [[ "$VERBOSE" == "true" && "$JSON_OUTPUT" == "false" ]]; then
        log_info "Disk usage: ${DISK_USAGE}%"
    fi
    RESULTS+=("Disk_Space:OK")
fi

# 8. Check Docker disk usage
if [[ "$VERBOSE" == "true" && "$JSON_OUTPUT" == "false" ]]; then
    echo ""
    log_info "Docker disk usage:"
    check_docker_disk_usage
fi

# Output results
if [[ "$JSON_OUTPUT" == "true" ]]; then
    # JSON output
    echo "{"
    echo "  \"timestamp\": \"$(date -u +%Y-%m-%dT%H:%M:%SZ)\","
    echo "  \"overall_status\": \"$([ "$ALL_HEALTHY" == "true" ] && echo "healthy" || echo "unhealthy")\","
    echo "  \"checks\": {"

    FIRST=true
    for result in "${RESULTS[@]}"; do
        IFS=':' read -r name status <<< "$result"

        if [[ "$FIRST" == "false" ]]; then
            echo ","
        fi
        FIRST=false

        echo -n "    \"$name\": \"$status\""
    done

    echo ""
    echo "  }"
    echo "}"
else
    # Summary
    print_header "Health Check Summary"

    if [[ "$ALL_HEALTHY" == "true" ]]; then
        log_success "All critical services are healthy"
        echo ""
        echo "Status: OK"
    else
        log_error "One or more critical services are unhealthy"
        echo ""
        echo "Status: FAILED"
    fi

    echo ""
    echo "Results:"
    for result in "${RESULTS[@]}"; do
        IFS=':' read -r name status <<< "$result"
        case $status in
            OK)
                echo -e "  ${GREEN}✓${NC} $name"
                ;;
            WARNING)
                echo -e "  ${YELLOW}⚠${NC} $name"
                ;;
            FAIL|CRITICAL)
                echo -e "  ${RED}✗${NC} $name"
                ;;
            *)
                echo -e "  ${BLUE}?${NC} $name: $status"
                ;;
        esac
    done

    echo ""
fi

# Exit with appropriate code
if [[ "$ALL_HEALTHY" == "true" ]]; then
    exit 0
else
    exit 1
fi
