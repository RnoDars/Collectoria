#!/bin/bash
#
# docker-utils.sh - Docker utilities for Collectoria deployment scripts
#
# Description:
#   Docker-specific utilities for image management, container operations, and cleanup
#
# Usage:
#   source "$(dirname "$0")/../lib/docker-utils.sh"
#

# Source common functions
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/common.sh"

# Cleanup dangling images (images with <none> tag)
cleanup_dangling_images() {
    log_info "Cleaning up dangling images..."

    local dangling_count=$(docker images -f "dangling=true" -q | wc -l)

    if [[ $dangling_count -eq 0 ]]; then
        log_info "No dangling images to clean up"
        return 0
    fi

    log_info "Found $dangling_count dangling images"

    docker image prune -f

    log_success "Dangling images cleaned up"
}

# Keep only N latest versions of an image
keep_latest_images() {
    local image_pattern="$1"
    local keep_count="${2:-2}"

    log_info "Keeping only $keep_count latest versions of $image_pattern..."

    # Get list of image IDs sorted by creation date (newest first)
    local images=$(docker images "$image_pattern" --format "{{.ID}} {{.CreatedAt}}" | \
        sort -k2 -r | \
        tail -n +$((keep_count + 1)) | \
        awk '{print $1}')

    if [[ -z "$images" ]]; then
        log_info "No old images to remove (keeping $keep_count latest)"
        return 0
    fi

    local count=$(echo "$images" | wc -l)
    log_info "Removing $count old image(s) of $image_pattern"

    echo "$images" | xargs -r docker rmi -f 2>/dev/null || true

    log_success "Old images cleaned up"
}

# Stop and remove container
stop_and_remove_container() {
    local container_name="$1"
    local timeout="${2:-10}"

    if ! check_container_exists "$container_name"; then
        log_info "Container $container_name does not exist, skipping"
        return 0
    fi

    log_info "Stopping and removing container: $container_name"

    if check_container_running "$container_name"; then
        docker stop -t "$timeout" "$container_name" 2>/dev/null || true
    fi

    docker rm "$container_name" 2>/dev/null || true

    log_success "Container $container_name removed"
}

# Get container logs (last N lines)
get_container_logs() {
    local container_name="$1"
    local lines="${2:-50}"

    if ! check_container_exists "$container_name"; then
        log_error "Container $container_name does not exist"
        return 1
    fi

    log_info "Last $lines lines of logs for $container_name:"
    echo ""
    docker logs --tail "$lines" "$container_name" 2>&1
    echo ""
}

# Check Docker disk usage
check_docker_disk_usage() {
    log_info "Docker disk usage:"
    echo ""
    docker system df
    echo ""
}

# Show detailed Docker disk usage
check_docker_disk_usage_verbose() {
    log_info "Docker disk usage (detailed):"
    echo ""
    docker system df -v
    echo ""
}

# Cleanup old container logs (>7 days)
cleanup_old_logs() {
    local log_dir="${1:-/var/lib/docker/containers}"
    local days="${2:-7}"

    log_info "Cleaning up logs older than $days days in $log_dir..."

    if [[ ! -d "$log_dir" ]]; then
        log_warning "Log directory $log_dir does not exist"
        return 0
    fi

    local deleted_count=$(find "$log_dir" -name "*.log" -mtime +$days -type f 2>/dev/null | wc -l)

    if [[ $deleted_count -eq 0 ]]; then
        log_info "No old logs to clean up"
        return 0
    fi

    log_info "Found $deleted_count log file(s) to remove"

    find "$log_dir" -name "*.log" -mtime +$days -type f -exec rm -f {} \; 2>/dev/null || true

    log_success "Old logs cleaned up"
}

# Cleanup stopped containers older than N hours
cleanup_stopped_containers() {
    local hours="${1:-48}"

    log_info "Cleaning up containers stopped for more than $hours hours..."

    # Get containers stopped longer than specified hours
    local stopped_containers=$(docker ps -a --filter "status=exited" --format "{{.ID}} {{.Status}}" | \
        awk -v hours="$hours" '
            /Exited/ {
                if ($3 == "days") {
                    if ($2 * 24 > hours) print $1
                } else if ($3 == "hours") {
                    if ($2 > hours) print $1
                }
            }
        ')

    if [[ -z "$stopped_containers" ]]; then
        log_info "No stopped containers to clean up"
        return 0
    fi

    local count=$(echo "$stopped_containers" | wc -l)
    log_info "Removing $count stopped container(s)"

    echo "$stopped_containers" | xargs -r docker rm 2>/dev/null || true

    log_success "Stopped containers cleaned up"
}

# Cleanup unused volumes
cleanup_unused_volumes() {
    local force="${1:-false}"

    log_info "Cleaning up unused volumes..."

    local unused_count=$(docker volume ls -qf dangling=true | wc -l)

    if [[ $unused_count -eq 0 ]]; then
        log_info "No unused volumes to clean up"
        return 0
    fi

    log_warning "Found $unused_count unused volume(s)"

    if [[ "$force" != "true" ]]; then
        if ! confirm "Remove unused volumes? This action cannot be undone"; then
            log_info "Volume cleanup cancelled"
            return 0
        fi
    fi

    docker volume prune -f

    log_success "Unused volumes cleaned up"
}

# Cleanup unused networks
cleanup_unused_networks() {
    log_info "Cleaning up unused networks..."

    docker network prune -f

    log_success "Unused networks cleaned up"
}

# Pull latest image for a service
pull_image() {
    local image_name="$1"

    log_info "Pulling latest image: $image_name"

    if docker pull "$image_name"; then
        log_success "Image pulled successfully"
        return 0
    else
        log_error "Failed to pull image: $image_name"
        return 1
    fi
}

# Tag image with new tag
tag_image() {
    local source_image="$1"
    local target_tag="$2"

    log_info "Tagging image: $source_image -> $target_tag"

    if docker tag "$source_image" "$target_tag"; then
        log_success "Image tagged successfully"
        return 0
    else
        log_error "Failed to tag image"
        return 1
    fi
}

# Get image creation date
get_image_created_date() {
    local image_name="$1"

    docker inspect --format='{{.Created}}' "$image_name" 2>/dev/null | cut -d'T' -f1
}

# List all images for a repository
list_repository_images() {
    local repository="$1"
    local limit="${2:-10}"

    log_info "Latest $limit images for repository: $repository"
    echo ""

    docker images "$repository" --format "table {{.Tag}}\t{{.ID}}\t{{.CreatedAt}}\t{{.Size}}" | head -n $((limit + 1))

    echo ""
}

# Get container status
get_container_status() {
    local container_name="$1"

    docker inspect --format='{{.State.Status}}' "$container_name" 2>/dev/null
}

# Get container health status
get_container_health() {
    local container_name="$1"

    local health=$(docker inspect --format='{{.State.Health.Status}}' "$container_name" 2>/dev/null)

    if [[ -z "$health" ]]; then
        echo "no-healthcheck"
    else
        echo "$health"
    fi
}

# Restart container with compose
restart_service_compose() {
    local service_name="$1"
    local compose_file="${2:-/home/collectoria/Collectoria/docker-compose.prod.yml}"

    log_info "Restarting service: $service_name"

    docker-compose -f "$compose_file" restart "$service_name"

    log_success "Service $service_name restarted"
}

# Start service with compose
start_service_compose() {
    local service_name="$1"
    local compose_file="${2:-/home/collectoria/Collectoria/docker-compose.prod.yml}"

    log_info "Starting service: $service_name"

    docker-compose -f "$compose_file" up -d "$service_name"

    log_success "Service $service_name started"
}

# Stop service with compose
stop_service_compose() {
    local service_name="$1"
    local compose_file="${2:-/home/collectoria/Collectoria/docker-compose.prod.yml}"
    local timeout="${3:-10}"

    log_info "Stopping service: $service_name"

    docker-compose -f "$compose_file" stop -t "$timeout" "$service_name"

    log_success "Service $service_name stopped"
}

# Get Docker Compose service container name
get_compose_container_name() {
    local service_name="$1"
    local compose_file="${2:-/home/collectoria/Collectoria/docker-compose.prod.yml}"

    docker-compose -f "$compose_file" ps -q "$service_name" | xargs docker inspect --format='{{.Name}}' | sed 's/^\///'
}

# Check if image exists
image_exists() {
    local image_name="$1"

    docker images -q "$image_name" 2>/dev/null | grep -q .
}

# Get image size
get_image_size() {
    local image_name="$1"

    docker images "$image_name" --format "{{.Size}}" 2>/dev/null
}

# Show resource usage of running containers
show_container_stats() {
    local container_name="$1"

    if [[ -n "$container_name" ]]; then
        docker stats --no-stream "$container_name"
    else
        docker stats --no-stream
    fi
}

# Aggressive cleanup (removes unused images, not just dangling)
aggressive_cleanup() {
    local force="${1:-false}"

    print_header "Aggressive Docker Cleanup"

    log_warning "This will remove ALL unused images, containers, networks, and volumes"

    if [[ "$force" != "true" ]]; then
        if ! confirm "Proceed with aggressive cleanup? This may remove images needed for rollback"; then
            log_info "Aggressive cleanup cancelled"
            return 0
        fi
    fi

    log_info "Running aggressive cleanup..."

    # Remove all stopped containers
    log_step "Removing stopped containers..."
    docker container prune -f

    # Remove all unused images (not just dangling)
    log_step "Removing unused images..."
    docker image prune -a -f

    # Remove unused volumes
    log_step "Removing unused volumes..."
    docker volume prune -f

    # Remove unused networks
    log_step "Removing unused networks..."
    docker network prune -f

    # Show disk space reclaimed
    echo ""
    log_success "Aggressive cleanup completed"
    check_docker_disk_usage
}

# Check service health using internal container health endpoint
check_service_health() {
    local container_name="$1"
    local health_url="$2"
    local max_attempts="${3:-30}"
    local interval="${4:-2}"

    log_info "Checking health of $container_name..."
    log_info "URL: $health_url"

    local attempt=1

    while [[ $attempt -le $max_attempts ]]; do
        # Use docker exec to check health from inside the container
        # Extract host and path from URL
        local host_port=$(echo "$health_url" | sed -n 's|http://\([^/]*\)\(/.*\)|\1|p')
        local path=$(echo "$health_url" | sed -n 's|http://\([^/]*\)\(/.*\)|\2|p')

        if docker exec "$container_name" wget -q -O- "http://${host_port}${path}" >/dev/null 2>&1; then
            echo ""  # New line after dots
            log_success "$container_name is healthy"
            return 0
        fi

        echo -n "."
        sleep "$interval"
        ((attempt++))
    done

    echo ""  # New line after dots
    log_error "$container_name failed health check after $max_attempts attempts"
    return 1
}

# Export functions for use in subshells
export -f cleanup_dangling_images keep_latest_images
export -f stop_and_remove_container get_container_logs
export -f check_docker_disk_usage check_docker_disk_usage_verbose
export -f cleanup_old_logs cleanup_stopped_containers
export -f cleanup_unused_volumes cleanup_unused_networks
export -f pull_image tag_image get_image_created_date list_repository_images
export -f get_container_status get_container_health
export -f restart_service_compose start_service_compose stop_service_compose
export -f get_compose_container_name image_exists get_image_size
export -f show_container_stats aggressive_cleanup check_service_health
