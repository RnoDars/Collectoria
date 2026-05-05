#!/bin/bash
#
# common.sh - Shared functions for Collectoria deployment scripts
#
# Description:
#   Common utilities for logging, error handling, health checks, and confirmations
#
# Usage:
#   source "$(dirname "$0")/../lib/common.sh"
#

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Logging functions with timestamps
log() {
    echo -e "${GREEN}[$(date +'%Y-%m-%d %H:%M:%S')]${NC} $1";
}

log_error() {
    echo -e "${RED}[$(date +'%Y-%m-%d %H:%M:%S')] ERROR:${NC} $1" >&2;
}

log_warning() {
    echo -e "${YELLOW}[$(date +'%Y-%m-%d %H:%M:%S')] WARNING:${NC} $1";
}

log_info() {
    echo -e "${BLUE}[$(date +'%Y-%m-%d %H:%M:%S')] INFO:${NC} $1";
}

log_success() {
    echo -e "${GREEN}[$(date +'%Y-%m-%d %H:%M:%S')] SUCCESS:${NC} $1";
}

log_step() {
    echo -e "${CYAN}[$(date +'%Y-%m-%d %H:%M:%S')] STEP:${NC} $1";
}

# Print section header
print_header() {
    local title="$1"
    echo ""
    echo -e "${MAGENTA}========================================${NC}"
    echo -e "${MAGENTA}  $title${NC}"
    echo -e "${MAGENTA}========================================${NC}"
    echo ""
}

# Check if running with proper permissions (docker group or root)
check_permissions() {
    if [[ $EUID -ne 0 ]] && ! groups | grep -q docker; then
        log_error "Must run as root or be in docker group"
        log_info "Add user to docker group: sudo usermod -aG docker \$USER"
        exit 1
    fi
}

# Check if docker-compose file exists
check_compose_file() {
    local compose_file="${1:-/home/collectoria/Collectoria/docker-compose.prod.yml}"
    if [[ ! -f "$compose_file" ]]; then
        log_error "Docker compose file not found: $compose_file"
        exit 1
    fi
}

# Confirmation prompt before destructive actions
confirm() {
    local message="$1"
    local default="${2:-N}"

    if [[ "$default" == "Y" ]]; then
        read -p "$(echo -e ${YELLOW}${message}${NC} [Y/n]: )" -n 1 -r
        echo
        [[ -z $REPLY ]] || [[ $REPLY =~ ^[Yy]$ ]]
    else
        read -p "$(echo -e ${YELLOW}${message}${NC} [y/N]: )" -n 1 -r
        echo
        [[ $REPLY =~ ^[Yy]$ ]]
    fi
}

# Check if service is healthy via HTTP endpoint
check_service_health() {
    local service_name="$1"
    local health_url="$2"
    local max_retries="${3:-30}"
    local retry_interval="${4:-2}"

    log_info "Checking health of $service_name..."
    log_info "URL: $health_url"

    for i in $(seq 1 $max_retries); do
        if curl -sf "$health_url" >/dev/null 2>&1; then
            log_success "$service_name is healthy"
            return 0
        fi

        if [[ $i -eq $max_retries ]]; then
            log_error "$service_name failed health check after $max_retries attempts"
            return 1
        fi

        echo -n "."
        sleep $retry_interval
    done
}

# Check if Docker container is running
check_container_running() {
    local container_name="$1"

    if docker ps --format '{{.Names}}' | grep -q "^${container_name}$"; then
        return 0
    else
        return 1
    fi
}

# Check if Docker container exists (running or stopped)
check_container_exists() {
    local container_name="$1"

    if docker ps -a --format '{{.Names}}' | grep -q "^${container_name}$"; then
        return 0
    else
        return 1
    fi
}

# Wait for container to be healthy
wait_for_container_healthy() {
    local container_name="$1"
    local max_retries="${2:-30}"
    local retry_interval="${3:-2}"

    log_info "Waiting for $container_name to be healthy..."

    for i in $(seq 1 $max_retries); do
        local health_status=$(docker inspect --format='{{.State.Health.Status}}' "$container_name" 2>/dev/null)

        if [[ "$health_status" == "healthy" ]]; then
            log_success "$container_name is healthy"
            return 0
        fi

        if [[ -z "$health_status" ]]; then
            # Container has no health check defined, check if it's running
            if check_container_running "$container_name"; then
                log_success "$container_name is running (no health check)"
                return 0
            fi
        fi

        if [[ $i -eq $max_retries ]]; then
            log_error "$container_name failed to become healthy after $max_retries attempts"
            return 1
        fi

        echo -n "."
        sleep $retry_interval
    done
}

# Save deployment log to history
save_deployment_log() {
    local log_message="$1"
    local service="${2:-all}"
    local log_dir="/home/collectoria/Collectoria/.deployment/history"

    mkdir -p "$log_dir"

    local timestamp=$(date +'%Y-%m-%d_%H-%M-%S')
    local log_file="$log_dir/${timestamp}_${service}.log"

    {
        echo "========================================="
        echo "Deployment Log"
        echo "========================================="
        echo "Timestamp: $(date +'%Y-%m-%d %H:%M:%S')"
        echo "Service: $service"
        echo "User: $(whoami)"
        echo "Host: $(hostname)"
        echo ""
        echo "$log_message"
        echo ""
        echo "========================================="
    } >> "$log_file"

    log_info "Deployment log saved: $log_file"
}

# Get last deployed image tag for a service
get_current_image_tag() {
    local container_name="$1"

    docker inspect --format='{{.Config.Image}}' "$container_name" 2>/dev/null | cut -d: -f2
}

# Parse script options (helper for argument parsing)
parse_boolean_option() {
    local option_name="$1"
    shift

    for arg in "$@"; do
        if [[ "$arg" == "--${option_name}" ]]; then
            return 0
        fi
    done

    return 1
}

# Check if running in dry-run mode
is_dry_run() {
    parse_boolean_option "dry-run" "$@"
}

# Execute command (skip if dry-run)
execute() {
    local command="$*"

    if is_dry_run "$@"; then
        log_info "[DRY-RUN] Would execute: $command"
        return 0
    else
        eval "$command"
        return $?
    fi
}

# Check available disk space
check_disk_space() {
    local min_space_gb="${1:-5}"
    local path="${2:-/}"

    local available_space=$(df -BG "$path" | awk 'NR==2 {print $4}' | sed 's/G//')

    log_info "Available disk space on $path: ${available_space}GB"

    if [[ $available_space -lt $min_space_gb ]]; then
        log_warning "Low disk space: ${available_space}GB available (minimum: ${min_space_gb}GB)"
        return 1
    fi

    return 0
}

# Get current Git branch
get_current_branch() {
    git rev-parse --abbrev-ref HEAD 2>/dev/null
}

# Get current Git commit hash
get_current_commit() {
    git rev-parse HEAD 2>/dev/null
}

# Get short commit hash
get_short_commit() {
    git rev-parse --short HEAD 2>/dev/null
}

# Check if Git repo has uncommitted changes
has_uncommitted_changes() {
    [[ -n $(git status -s) ]]
}

# Display deployment summary
display_deployment_summary() {
    local service="$1"
    local status="$2"
    local duration="$3"
    local details="$4"

    print_header "Deployment Summary"

    echo -e "${BLUE}Service:${NC} $service"
    echo -e "${BLUE}Status:${NC} $status"
    echo -e "${BLUE}Duration:${NC} ${duration}s"

    if [[ -n "$details" ]]; then
        echo ""
        echo -e "${BLUE}Details:${NC}"
        echo "$details"
    fi

    echo ""
}

# Trap errors and log them
trap_error() {
    local script_name="$1"
    local line_number="$2"

    log_error "Script $script_name failed at line $line_number"
    exit 1
}

# Set up error trap
setup_error_trap() {
    local script_name="$1"
    trap 'trap_error "$script_name" $LINENO' ERR
}

# Export functions for use in subshells
export -f log log_error log_warning log_info log_success log_step
export -f print_header check_permissions confirm
export -f check_service_health check_container_running check_container_exists
export -f wait_for_container_healthy save_deployment_log
export -f get_current_image_tag parse_boolean_option is_dry_run execute
export -f check_disk_space get_current_branch get_current_commit get_short_commit
export -f has_uncommitted_changes display_deployment_summary
