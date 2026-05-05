#!/bin/bash
#
# test-scripts.sh - Test all deployment scripts in dry-run mode
#
# Description:
#   Validates all deployment scripts by running them in dry-run mode
#   to ensure they work correctly without making actual changes
#
# Usage:
#   ./test-scripts.sh
#

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

source "$SCRIPT_DIR/lib/common.sh"

print_header "Testing Collectoria Deployment Scripts"

log_info "Running all scripts in dry-run mode..."
echo ""

TOTAL_TESTS=0
PASSED_TESTS=0
FAILED_TESTS=0

# Test function
test_script() {
    local script_path="$1"
    local script_name=$(basename "$script_path")
    local test_args="${2:-}"

    TOTAL_TESTS=$((TOTAL_TESTS + 1))

    log_step "Testing: $script_name"

    if [[ ! -x "$script_path" ]]; then
        log_error "Script not executable: $script_path"
        FAILED_TESTS=$((FAILED_TESTS + 1))
        return 1
    fi

    # Run script with dry-run if it supports it
    if grep -q "\-\-dry-run" "$script_path"; then
        if "$script_path" --dry-run $test_args >/dev/null 2>&1; then
            log_success "$script_name: PASSED"
            PASSED_TESTS=$((PASSED_TESTS + 1))
            return 0
        else
            log_error "$script_name: FAILED"
            FAILED_TESTS=$((FAILED_TESTS + 1))
            return 1
        fi
    else
        log_info "$script_name: No dry-run support (skipping execution test)"
        PASSED_TESTS=$((PASSED_TESTS + 1))
        return 0
    fi
}

# Test library scripts (check syntax)
print_header "Testing Library Scripts"

for lib_script in "$SCRIPT_DIR/lib"/*.sh; do
    TOTAL_TESTS=$((TOTAL_TESTS + 1))
    script_name=$(basename "$lib_script")

    log_step "Checking: $script_name"

    if bash -n "$lib_script"; then
        log_success "$script_name: Syntax OK"
        PASSED_TESTS=$((PASSED_TESTS + 1))
    else
        log_error "$script_name: Syntax ERROR"
        FAILED_TESTS=$((FAILED_TESTS + 1))
    fi
done

echo ""

# Test deployment scripts
print_header "Testing Deployment Scripts"

# Note: These tests will fail if not on production server
# That's expected - we're just checking if scripts run without errors

test_script "$SCRIPT_DIR/deploy/deploy-backend.sh" "--skip-pull --skip-tests" || true
test_script "$SCRIPT_DIR/deploy/deploy-frontend.sh" "--skip-pull" || true
test_script "$SCRIPT_DIR/deploy/deploy-full.sh" "--skip-pull --skip-tests" || true

echo ""

# Test infrastructure scripts
print_header "Testing Infrastructure Scripts"

# Health check can run anywhere
if [[ -f "$SCRIPT_DIR/infrastructure/health-check.sh" ]]; then
    log_step "Testing: health-check.sh"
    # Just check syntax, don't run (requires Docker)
    if bash -n "$SCRIPT_DIR/infrastructure/health-check.sh"; then
        log_success "health-check.sh: Syntax OK"
        PASSED_TESTS=$((PASSED_TESTS + 1))
    else
        log_error "health-check.sh: Syntax ERROR"
        FAILED_TESTS=$((FAILED_TESTS + 1))
    fi
    TOTAL_TESTS=$((TOTAL_TESTS + 1))
fi

echo ""

# Test database scripts
print_header "Testing Database Scripts"

for db_script in "$SCRIPT_DIR/database"/*.sh; do
    TOTAL_TESTS=$((TOTAL_TESTS + 1))
    script_name=$(basename "$db_script")

    log_step "Checking: $script_name"

    if bash -n "$db_script"; then
        log_success "$script_name: Syntax OK"
        PASSED_TESTS=$((PASSED_TESTS + 1))
    else
        log_error "$script_name: Syntax ERROR"
        FAILED_TESTS=$((FAILED_TESTS + 1))
    fi
done

echo ""

# Test maintenance scripts
print_header "Testing Maintenance Scripts"

test_script "$SCRIPT_DIR/maintenance/cleanup.sh" "" || true

echo ""

# Summary
print_header "Test Summary"

echo "Total tests: $TOTAL_TESTS"
echo "Passed: ${GREEN}$PASSED_TESTS${NC}"
echo "Failed: ${RED}$FAILED_TESTS${NC}"
echo ""

if [[ $FAILED_TESTS -eq 0 ]]; then
    log_success "All tests passed!"
    exit 0
else
    log_error "Some tests failed"
    exit 1
fi
