# Scripts Library - API Reference

This directory contains shared utility functions for Collectoria deployment and maintenance scripts.

## Usage

```bash
# Source the libraries in your script
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../lib/common.sh"
source "$SCRIPT_DIR/../lib/docker-utils.sh"
```

---

## common.sh

General-purpose utilities for logging, error handling, validation, and user interaction.

### Logging Functions

#### `log_info <message>`
Print informational message with timestamp.
```bash
log_info "Starting deployment..."
```

#### `log_success <message>`
Print success message in green with timestamp.
```bash
log_success "Deployment completed"
```

#### `log_warning <message>`
Print warning message in yellow with timestamp.
```bash
log_warning "Disk space low"
```

#### `log_error <message>`
Print error message in red with timestamp.
```bash
log_error "Deployment failed"
```

#### `log_step <message>`
Print step header for major operations.
```bash
log_step "Building Docker image..."
```

#### `print_header <title>`
Print formatted section header.
```bash
print_header "Backend Deployment"
```

### Validation Functions

#### `check_permissions`
Check if script is running with appropriate permissions (Docker access).
```bash
check_permissions || exit 1
```

#### `check_disk_space <min_gb> [path]`
Check if at least `min_gb` GB of disk space is available.
```bash
check_disk_space 5 "/" || exit 1
```

#### `check_container_exists <container_name>`
Check if Docker container exists (running or stopped).
```bash
if check_container_exists "my-container"; then
    echo "Container exists"
fi
```

#### `check_container_running <container_name>`
Check if Docker container is currently running.
```bash
if check_container_running "my-container"; then
    echo "Container is running"
fi
```

#### `check_compose_file <file_path>`
Check if Docker Compose file exists and is readable.
```bash
check_compose_file "$COMPOSE_FILE" || exit 1
```

#### `has_uncommitted_changes`
Check if git repository has uncommitted changes.
```bash
if has_uncommitted_changes; then
    log_warning "Uncommitted changes detected"
fi
```

### User Interaction

#### `confirm <message>`
Prompt user for yes/no confirmation. Returns 0 for yes, 1 for no.
```bash
if confirm "Deploy to production?"; then
    # User confirmed
fi
```

### Git Functions

#### `get_current_commit`
Get current git commit hash (full).
```bash
COMMIT=$(get_current_commit)
```

#### `get_short_commit`
Get current git commit hash (short, 7 chars).
```bash
SHORT_COMMIT=$(get_short_commit)
```

#### `get_current_branch`
Get current git branch name.
```bash
BRANCH=$(get_current_branch)
```

### Deployment Tracking

#### `save_deployment_log <message> <type>`
Save deployment log entry to history.
```bash
save_deployment_log "Backend deployed" "deployment"
```

#### `display_deployment_summary <service> <status> <duration> <details>`
Display formatted deployment summary.
```bash
display_deployment_summary "backend" "SUCCESS" "45s" "All checks passed"
```

### Docker Image Functions

#### `get_current_image_tag <image_name>`
Get current tag of a Docker image.
```bash
TAG=$(get_current_image_tag "collectoria-backend")
```

### Error Handling

#### `setup_error_trap`
Set up error trap for script (calls `trap_error` on failure).
```bash
setup_error_trap
```

#### `trap_error <line_number> <command>`
Error handler function (called by trap).
```bash
# Automatically called by setup_error_trap
```

### Utility Functions

#### `execute <command> <description>`
Execute command with logging (respects dry-run mode).
```bash
execute "docker stop my-container" "Stopping container"
```

#### `is_dry_run`
Check if script is in dry-run mode.
```bash
if is_dry_run; then
    log_info "Dry-run mode active"
fi
```

#### `parse_boolean_option <value>`
Parse boolean option from string ("true", "yes", "1" → true).
```bash
ENABLED=$(parse_boolean_option "$USER_INPUT")
```

#### `wait_for_container_healthy <container_name> [timeout]`
Wait for container to become healthy (HEALTHCHECK must be defined).
```bash
wait_for_container_healthy "my-container" 60 || exit 1
```

---

## docker-utils.sh

Docker-specific utilities for image management, container operations, and cleanup.

### Service Health Checks

#### `check_service_health <container_name> <health_url> [max_attempts] [interval]`
Check service health using internal container health endpoint.
```bash
check_service_health "my-backend" "http://localhost:8080/health" 30 2
```

### Container Operations

#### `stop_and_remove_container <container_name> [timeout]`
Stop and remove a Docker container.
```bash
stop_and_remove_container "my-container" 10
```

#### `get_container_logs <container_name> [lines]`
Get last N lines of container logs.
```bash
get_container_logs "my-container" 50
```

#### `get_container_status <container_name>`
Get container status (running, exited, etc.).
```bash
STATUS=$(get_container_status "my-container")
```

#### `get_container_health <container_name>`
Get container health status (healthy, unhealthy, no-healthcheck).
```bash
HEALTH=$(get_container_health "my-container")
```

### Docker Compose Operations

#### `start_service_compose <service_name> [compose_file]`
Start a Docker Compose service.
```bash
start_service_compose "backend" "/path/to/docker-compose.yml"
```

#### `stop_service_compose <service_name> [compose_file] [timeout]`
Stop a Docker Compose service.
```bash
stop_service_compose "backend" "/path/to/docker-compose.yml" 10
```

#### `restart_service_compose <service_name> [compose_file]`
Restart a Docker Compose service.
```bash
restart_service_compose "backend" "/path/to/docker-compose.yml"
```

#### `get_compose_container_name <service_name> [compose_file]`
Get container name for a Docker Compose service.
```bash
CONTAINER=$(get_compose_container_name "backend")
```

### Image Management

#### `pull_image <image_name>`
Pull latest Docker image.
```bash
pull_image "postgres:15-alpine"
```

#### `tag_image <source_image> <target_tag>`
Tag a Docker image.
```bash
tag_image "my-app:latest" "my-app:v1.2.3"
```

#### `image_exists <image_name>`
Check if Docker image exists locally.
```bash
if image_exists "my-app:latest"; then
    echo "Image found"
fi
```

#### `get_image_size <image_name>`
Get size of Docker image.
```bash
SIZE=$(get_image_size "my-app:latest")
```

#### `get_image_created_date <image_name>`
Get creation date of Docker image.
```bash
DATE=$(get_image_created_date "my-app:latest")
```

#### `list_repository_images <repository> [limit]`
List images for a repository.
```bash
list_repository_images "collectoria-backend" 10
```

#### `keep_latest_images <image_pattern> [keep_count]`
Keep only N latest versions of an image, remove older ones.
```bash
keep_latest_images "collectoria-backend" 2
```

### Cleanup Functions

#### `cleanup_dangling_images`
Remove dangling Docker images (tagged as <none>).
```bash
cleanup_dangling_images
```

#### `cleanup_stopped_containers <hours>`
Remove containers stopped for more than N hours.
```bash
cleanup_stopped_containers 48
```

#### `cleanup_unused_volumes [force]`
Remove unused Docker volumes (prompts for confirmation unless force=true).
```bash
cleanup_unused_volumes true
```

#### `cleanup_unused_networks`
Remove unused Docker networks.
```bash
cleanup_unused_networks
```

#### `cleanup_old_logs <log_dir> <days>`
Remove log files older than N days.
```bash
cleanup_old_logs "/var/lib/docker/containers" 7
```

#### `aggressive_cleanup [force]`
Full cleanup: images, containers, volumes, networks (prompts unless force=true).
```bash
aggressive_cleanup true
```

### Monitoring

#### `check_docker_disk_usage`
Display Docker disk usage summary.
```bash
check_docker_disk_usage
```

#### `check_docker_disk_usage_verbose`
Display detailed Docker disk usage.
```bash
check_docker_disk_usage_verbose
```

#### `show_container_stats [container_name]`
Show resource usage of containers.
```bash
show_container_stats "my-container"
```

---

## Validation Before Use

Before calling a function from these libraries:

1. **Check function exists** in this README
2. **Verify parameters** match the signature
3. **Test with dry-run** if available
4. **Check return codes** for validation functions

## Common Patterns

### Standard Script Template

```bash
#!/bin/bash
set -e

# Script directory and libraries
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../lib/common.sh"
source "$SCRIPT_DIR/../lib/docker-utils.sh"

# Configuration
PROJECT_DIR="${PROJECT_DIR:-/home/collectoria/Collectoria}"
COMPOSE_FILE="$PROJECT_DIR/docker-compose.prod.yml"

# Print header
print_header "My Script"

# Preflight checks
check_permissions
check_compose_file "$COMPOSE_FILE"
check_disk_space 1 "/"

# Main logic
log_step "Performing operation..."
if check_container_running "my-container"; then
    log_info "Container is running"
fi

log_success "Operation completed"
```

### Error Handling Pattern

```bash
#!/bin/bash
set -e
setup_error_trap

# Your script logic here
# On any error, trap_error will be called automatically
```

### Dry-Run Pattern

```bash
DRY_RUN=false

while [[ $# -gt 0 ]]; do
    case $1 in
        --dry-run)
            DRY_RUN=true
            shift
            ;;
    esac
done

if [[ "$DRY_RUN" == "false" ]]; then
    docker compose up -d
else
    log_info "[DRY-RUN] Would execute: docker compose up -d"
fi
```

---

## Notes

- All functions handle errors internally and log appropriately
- Functions prefixed with `check_` return 0 (success) or 1 (failure)
- Functions prefixed with `get_` output result to stdout
- Functions prefixed with `log_` print to stderr with color
- Color codes are stripped in non-TTY environments automatically
