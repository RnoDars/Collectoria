#!/bin/bash
#
# validate-script.sh - Automated Bash Script Validation
#
# Description:
#   Validates Bash scripts automatically by checking syntax, references,
#   and conformity to Collectoria standards. Used by Agent Code Review
#   and manually before commits.
#
# Usage:
#   ./validate-script.sh <script-path> [OPTIONS]
#
# Options:
#   --verbose         Show detailed validation output
#   --no-shellcheck   Skip shellcheck validation
#   --json            Output results in JSON format
#
# Examples:
#   ./validate-script.sh scripts/deploy/deploy-backend.sh
#   ./validate-script.sh scripts/deploy/deploy-backend.sh --verbose
#   ./validate-script.sh scripts/deploy/deploy-backend.sh --json
#
# Exit Codes:
#   0 - All validations passed
#   1 - Validation errors found
#   2 - Script file not found
#   3 - Invalid arguments
#

set -e

# Script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

# Source common functions
source "$SCRIPT_DIR/common.sh"

# Configuration
VERBOSE=false
SKIP_SHELLCHECK=false
JSON_OUTPUT=false
SCRIPT_PATH=""

# Validation results
declare -a ERRORS=()
declare -a WARNINGS=()
declare -a INFO=()

# Parse arguments
if [[ $# -eq 0 ]]; then
    log_error "Missing script path argument"
    echo "Usage: $0 <script-path> [--verbose] [--no-shellcheck] [--json]"
    exit 3
fi

SCRIPT_PATH="$1"
shift

while [[ $# -gt 0 ]]; do
    case $1 in
        --verbose)
            VERBOSE=true
            shift
            ;;
        --no-shellcheck)
            SKIP_SHELLCHECK=true
            shift
            ;;
        --json)
            JSON_OUTPUT=true
            shift
            ;;
        *)
            log_error "Unknown option: $1"
            exit 3
            ;;
    esac
done

# Validation functions

add_error() {
    ERRORS+=("$1")
}

add_warning() {
    WARNINGS+=("$1")
}

add_info() {
    INFO+=("$1")
}

# Check if script file exists
validate_file_exists() {
    if [[ ! -f "$SCRIPT_PATH" ]]; then
        add_error "File not found: $SCRIPT_PATH"
        return 1
    fi
    add_info "File exists: $SCRIPT_PATH"
}

# Validate Bash syntax
validate_syntax() {
    if [[ "$JSON_OUTPUT" == "false" ]]; then
        log_step "Validating syntax..."
    fi

    if ! bash -n "$SCRIPT_PATH" 2>&1; then
        add_error "Bash syntax check failed (bash -n)"
        return 1
    fi
    add_info "Bash syntax valid"
}

# Validate with shellcheck
validate_shellcheck() {
    if [[ "$SKIP_SHELLCHECK" == "true" ]]; then
        add_warning "shellcheck validation skipped"
        return 0
    fi

    if [[ "$JSON_OUTPUT" == "false" ]]; then
        log_step "Running shellcheck..."
    fi

    if ! command -v shellcheck &>/dev/null; then
        add_warning "shellcheck not installed (install: apt install shellcheck)"
        return 0
    fi

    local shellcheck_output
    if ! shellcheck_output=$(shellcheck -f gcc "$SCRIPT_PATH" 2>&1); then
        add_error "shellcheck found issues:\n$shellcheck_output"
        return 1
    fi
    add_info "shellcheck passed"
}

# Validate Docker Compose service references
validate_compose_services() {
    if [[ "$JSON_OUTPUT" == "false" ]]; then
        log_step "Validating Docker Compose service references..."
    fi

    local compose_file="$PROJECT_ROOT/docker-compose.prod.yml"

    if [[ ! -f "$compose_file" ]]; then
        add_warning "docker-compose.prod.yml not found, skipping service validation"
        return 0
    fi

    # Extract service names from docker-compose.prod.yml
    local valid_services=$(grep -E "^  [a-z-]+:" "$compose_file" | sed 's/://g' | tr -d ' ')

    # Find service references in script (docker compose ... <service>)
    local service_refs=$(grep -oP 'docker compose.*?(?:up|stop|restart|build)\s+-[a-z\s]*\K[a-z-]+(?=\s|$|;)' "$SCRIPT_PATH" 2>/dev/null || true)

    if [[ -n "$service_refs" ]]; then
        while IFS= read -r service; do
            if ! echo "$valid_services" | grep -qx "$service"; then
                add_error "Invalid service reference: '$service' (not in docker-compose.prod.yml)\nValid services: $(echo $valid_services | tr '\n' ' ')"
            else
                add_info "Valid service reference: $service"
            fi
        done <<< "$service_refs"
    fi
}

# Validate container name references
validate_container_names() {
    if [[ "$JSON_OUTPUT" == "false" ]]; then
        log_step "Validating container name references..."
    fi

    # Known valid container names
    local valid_containers=(
        "collectoria-backend-collection-prod"
        "collectoria-frontend-prod"
        "collectoria-collection-db-prod"
        "traefik"
    )

    # Find container references in script (docker exec/logs/inspect <container>)
    local container_refs=$(grep -oP 'docker\s+(?:exec|logs|inspect|stop|rm)\s+(?:-[a-z]+\s+)*\K[a-z0-9_-]+' "$SCRIPT_PATH" 2>/dev/null || true)

    if [[ -n "$container_refs" ]]; then
        while IFS= read -r container; do
            # Skip if it's a variable reference
            if [[ "$container" =~ ^\$ ]]; then
                continue
            fi

            local found=false
            for valid in "${valid_containers[@]}"; do
                if [[ "$container" == "$valid" ]]; then
                    found=true
                    add_info "Valid container reference: $container"
                    break
                fi
            done

            if [[ "$found" == "false" ]]; then
                add_warning "Potentially invalid container reference: '$container'\nValid containers: ${valid_containers[*]}"
            fi
        done <<< "$container_refs"
    fi
}

# Validate function calls
validate_function_calls() {
    if [[ "$JSON_OUTPUT" == "false" ]]; then
        log_step "Validating function calls..."
    fi

    # Extract function calls from script (function_name pattern)
    local function_calls=$(grep -oP '\b[a-z_]+(?=\s*\()' "$SCRIPT_PATH" | sort -u)

    # Get available functions from common.sh and docker-utils.sh
    local available_functions=""
    if [[ -f "$SCRIPT_DIR/common.sh" ]]; then
        available_functions+=$(grep -oP '^\K[a-z_]+(?=\(\))' "$SCRIPT_DIR/common.sh")
        available_functions+=$'\n'
    fi
    if [[ -f "$SCRIPT_DIR/docker-utils.sh" ]]; then
        available_functions+=$(grep -oP '^\K[a-z_]+(?=\(\))' "$SCRIPT_DIR/docker-utils.sh")
    fi

    # Check if functions are defined locally or in libraries
    while IFS= read -r func; do
        # Skip built-in bash functions and common commands
        if [[ "$func" =~ ^(echo|printf|read|grep|sed|awk|test|true|false|cd|mkdir|rm|cp|mv)$ ]]; then
            continue
        fi

        # Check if defined in script itself
        if grep -q "^$func()" "$SCRIPT_PATH"; then
            add_info "Function defined locally: $func()"
            continue
        fi

        # Check if available in libraries
        if echo "$available_functions" | grep -qx "$func"; then
            add_info "Function available in library: $func()"
            continue
        fi

        add_error "Function '$func()' called but not defined\nCheck: scripts/lib/README.md for available functions"
    done <<< "$function_calls"
}

# Validate environment variables have defaults
validate_env_variables() {
    if [[ "$JSON_OUTPUT" == "false" ]]; then
        log_step "Validating environment variables..."
    fi

    # Find variables used without defaults (simple heuristic)
    local vars_without_defaults=$(grep -oP '\$\{[A-Z_]+\}' "$SCRIPT_PATH" | grep -v ':-' || true)

    if [[ -n "$vars_without_defaults" ]]; then
        local unique_vars=$(echo "$vars_without_defaults" | sort -u)
        while IFS= read -r var; do
            add_warning "Variable $var used without default value\nRecommend: ${var}:-default_value}"
        done <<< "$unique_vars"
    fi

    # Check for variables with defaults (good practice)
    local vars_with_defaults=$(grep -oP '\$\{[A-Z_]+:-[^}]+\}' "$SCRIPT_PATH" | wc -l)
    if [[ $vars_with_defaults -gt 0 ]]; then
        add_info "Found $vars_with_defaults variable(s) with default values"
    fi
}

# Validate header documentation
validate_header() {
    if [[ "$JSON_OUTPUT" == "false" ]]; then
        log_step "Validating header documentation..."
    fi

    local has_description=$(grep -q "^# Description:" "$SCRIPT_PATH" && echo "yes" || echo "no")
    local has_usage=$(grep -q "^# Usage:" "$SCRIPT_PATH" && echo "yes" || echo "no")
    local has_options=$(grep -q "^# Options:" "$SCRIPT_PATH" && echo "yes" || echo "no")
    local has_examples=$(grep -q "^# Examples:" "$SCRIPT_PATH" && echo "yes" || echo "no")

    if [[ "$has_description" == "no" ]]; then
        add_error "Missing '# Description:' section in header"
    else
        add_info "Header has Description section"
    fi

    if [[ "$has_usage" == "no" ]]; then
        add_error "Missing '# Usage:' section in header"
    else
        add_info "Header has Usage section"
    fi

    if [[ "$has_options" == "no" ]]; then
        add_warning "Missing '# Options:' section in header"
    else
        add_info "Header has Options section"
    fi

    if [[ "$has_examples" == "no" ]]; then
        add_warning "Missing '# Examples:' section in header"
    else
        add_info "Header has Examples section"
    fi
}

# Validate shebang
validate_shebang() {
    if [[ "$JSON_OUTPUT" == "false" ]]; then
        log_step "Validating shebang..."
    fi

    local first_line=$(head -n 1 "$SCRIPT_PATH")

    if [[ ! "$first_line" =~ ^#!/bin/bash ]]; then
        add_error "Invalid or missing shebang. Expected: #!/bin/bash"
    else
        add_info "Valid shebang: $first_line"
    fi
}

# Run all validations
run_validations() {
    validate_file_exists || return 2
    validate_shebang
    validate_syntax || return 1
    validate_shellcheck
    validate_header
    validate_compose_services
    validate_container_names
    validate_function_calls
    validate_env_variables
}

# Output results
output_results() {
    local error_count=${#ERRORS[@]}
    local warning_count=${#WARNINGS[@]}
    local info_count=${#INFO[@]}

    if [[ "$JSON_OUTPUT" == "true" ]]; then
        # JSON output
        echo "{"
        echo "  \"script\": \"$SCRIPT_PATH\","
        echo "  \"timestamp\": \"$(date -u +%Y-%m-%dT%H:%M:%SZ)\","
        echo "  \"errors\": $error_count,"
        echo "  \"warnings\": $warning_count,"
        echo "  \"status\": \"$([ $error_count -eq 0 ] && echo "PASS" || echo "FAIL")\","
        echo "  \"details\": {"
        echo "    \"errors\": ["
        for i in "${!ERRORS[@]}"; do
            echo -n "      \"${ERRORS[$i]}\""
            [[ $i -lt $((error_count - 1)) ]] && echo "," || echo ""
        done
        echo "    ],"
        echo "    \"warnings\": ["
        for i in "${!WARNINGS[@]}"; do
            echo -n "      \"${WARNINGS[$i]}\""
            [[ $i -lt $((warning_count - 1)) ]] && echo "," || echo ""
        done
        echo "    ]"
        echo "  }"
        echo "}"
    else
        # Human-readable output
        print_header "Validation Results"

        echo "Script: $SCRIPT_PATH"
        echo ""

        if [[ $error_count -eq 0 && $warning_count -eq 0 ]]; then
            log_success "All validations passed!"
        else
            if [[ $error_count -gt 0 ]]; then
                log_error "$error_count error(s) found:"
                for error in "${ERRORS[@]}"; do
                    echo -e "  ❌ $error"
                done
                echo ""
            fi

            if [[ $warning_count -gt 0 ]]; then
                log_warning "$warning_count warning(s) found:"
                for warning in "${WARNINGS[@]}"; do
                    echo -e "  ⚠️  $warning"
                done
                echo ""
            fi
        fi

        if [[ "$VERBOSE" == "true" && $info_count -gt 0 ]]; then
            log_info "Details:"
            for info in "${INFO[@]}"; do
                echo "  ℹ️  $info"
            done
            echo ""
        fi

        # Summary
        print_header "Summary"
        echo "Errors:   $error_count"
        echo "Warnings: $warning_count"
        echo "Status:   $([ $error_count -eq 0 ] && echo "✅ PASS" || echo "❌ FAIL")"
        echo ""

        if [[ $error_count -gt 0 ]]; then
            log_error "Validation failed. Fix errors before committing."
        elif [[ $warning_count -gt 0 ]]; then
            log_warning "Validation passed with warnings. Consider fixing before commit."
        else
            log_success "Validation passed. Script is ready to commit."
        fi
    fi
}

# Main execution
main() {
    if [[ "$JSON_OUTPUT" == "false" ]]; then
        print_header "Script Validation - Collectoria"
        echo "Validating: $SCRIPT_PATH"
        echo ""
    fi

    run_validations
    local validation_result=$?

    output_results

    exit $validation_result
}

main
