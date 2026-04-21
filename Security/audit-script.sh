#!/bin/bash
# Script d'Audit de Sécurité Automatisé - Collectoria MVP
# Version: 1.0
# Date: 2026-04-21

# Ne pas s'arrêter sur erreur pour continuer l'audit complet
set +e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Counters
CRITICAL=0
HIGH=0
MEDIUM=0
LOW=0
PASSED=0

echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}  Collectoria Security Audit Script${NC}"
echo -e "${BLUE}========================================${NC}"
echo ""

# Function to print status
print_check() {
    local status=$1
    local message=$2
    local severity=$3

    if [ "$status" = "PASS" ]; then
        echo -e "${GREEN}✓${NC} $message"
        ((PASSED++))
    elif [ "$status" = "FAIL" ]; then
        echo -e "${RED}✗${NC} $message"
        case $severity in
            CRITICAL) ((CRITICAL++));;
            HIGH) ((HIGH++));;
            MEDIUM) ((MEDIUM++));;
            LOW) ((LOW++));;
        esac
    elif [ "$status" = "WARN" ]; then
        echo -e "${YELLOW}⚠${NC} $message"
    else
        echo -e "  $message"
    fi
}

# ============================================================================
# BACKEND SECURITY CHECKS
# ============================================================================

echo -e "${BLUE}[1] Backend Security Checks${NC}"
echo ""

# Check 1.1: Hardcoded userID
echo "1.1 Checking for hardcoded userID..."
if grep -r "00000000-0000-0000-0000-000000000001" backend/collection-management/internal/infrastructure/http/handlers/*.go > /dev/null 2>&1; then
    print_check "FAIL" "Hardcoded userID found in handlers (CRIT-001)" "CRITICAL"
else
    print_check "PASS" "No hardcoded userID found"
fi

# Check 1.2: JWT implementation
echo "1.2 Checking JWT authentication..."
if grep -r "github.com/golang-jwt/jwt" backend/collection-management/go.mod > /dev/null 2>&1; then
    print_check "PASS" "JWT library detected"
else
    print_check "FAIL" "JWT authentication not implemented (CRIT-001)" "CRITICAL"
fi

# Check 1.3: SQL query construction
echo "1.3 Checking SQL query construction..."
if grep -r "fmt.Sprintf.*SELECT\|fmt.Sprintf.*WHERE" backend/collection-management/internal/infrastructure/postgres/*.go > /dev/null 2>&1; then
    print_check "FAIL" "Dynamic SQL construction with fmt.Sprintf detected (CRIT-002)" "CRITICAL"
else
    print_check "PASS" "No unsafe SQL construction detected"
fi

# Check 1.4: CORS configuration
echo "1.4 Checking CORS configuration..."
if grep -r "CORS_ALLOWED_ORIGINS" backend/collection-management/internal/config/config.go > /dev/null 2>&1; then
    print_check "PASS" "CORS is configurable via environment"
else
    print_check "FAIL" "CORS hardcoded in code (CRIT-003)" "CRITICAL"
fi

# Check 1.5: Rate limiting
echo "1.5 Checking rate limiting..."
if grep -r "tollbooth\|ratelimit" backend/collection-management/go.mod > /dev/null 2>&1; then
    print_check "PASS" "Rate limiting library detected"
else
    print_check "FAIL" "No rate limiting implemented (CRIT-005)" "CRITICAL"
fi

# Check 1.6: Security headers
echo "1.6 Checking security headers middleware..."
if grep -r "X-Content-Type-Options\|X-Frame-Options" backend/collection-management/internal/infrastructure/http/server.go > /dev/null 2>&1; then
    print_check "PASS" "Security headers configured"
else
    print_check "FAIL" "Security headers missing (MED-001)" "MEDIUM"
fi

# Check 1.7: Input validation
echo "1.7 Checking input validation..."
if grep -r "Validate()" backend/collection-management/internal/domain/*.go > /dev/null 2>&1; then
    print_check "PASS" "Input validation detected"
else
    print_check "FAIL" "Input validation not comprehensive (HIGH-001)" "HIGH"
fi

# Check 1.8: Environment-based logging
echo "1.8 Checking logger configuration..."
if grep -r "ENV.*production\|env.*production" backend/collection-management/cmd/api/main.go > /dev/null 2>&1; then
    print_check "PASS" "Environment-based logging configured"
else
    print_check "FAIL" "Logger always in development mode (HIGH-002)" "HIGH"
fi

echo ""

# ============================================================================
# INFRASTRUCTURE CHECKS
# ============================================================================

echo -e "${BLUE}[2] Infrastructure Security Checks${NC}"
echo ""

# Check 2.1: Hardcoded credentials in docker-compose
echo "2.1 Checking docker-compose credentials..."
if grep -E "POSTGRES_PASSWORD:.*collectoria" backend/collection-management/docker-compose.yml > /dev/null 2>&1; then
    print_check "FAIL" "Hardcoded weak password in docker-compose (CRIT-004)" "CRITICAL"
else
    print_check "PASS" "No hardcoded weak passwords detected"
fi

# Check 2.2: Dockerfile runs as root
echo "2.2 Checking Dockerfile user..."
if grep -q "USER.*root\|^CMD.*root" backend/collection-management/Dockerfile > /dev/null 2>&1; then
    print_check "FAIL" "Dockerfile runs as root (MED-006)" "MEDIUM"
elif grep -q "USER " backend/collection-management/Dockerfile > /dev/null 2>&1; then
    print_check "PASS" "Dockerfile uses non-root user"
else
    print_check "FAIL" "No USER directive in Dockerfile (MED-006)" "MEDIUM"
fi

# Check 2.3: .env file in Git
echo "2.3 Checking .env not committed..."
if git ls-files backend/collection-management/ | grep -q "\.env$"; then
    print_check "FAIL" "Environment file committed to Git (CRIT-004)" "CRITICAL"
else
    print_check "PASS" ".env not committed to Git"
fi

# Check 2.4: .env.example exists
echo "2.4 Checking .env.example exists..."
if [ -f "backend/collection-management/.env.example" ]; then
    print_check "PASS" ".env.example file exists"
else
    print_check "WARN" ".env.example missing"
fi

echo ""

# ============================================================================
# FRONTEND CHECKS
# ============================================================================

echo -e "${BLUE}[3] Frontend Security Checks${NC}"
echo ""

# Check 3.1: npm audit
echo "3.1 Running npm audit..."
cd frontend
NPM_AUDIT=$(npm audit --json 2>/dev/null || echo '{"error":true}')
VULN_COUNT=$(echo "$NPM_AUDIT" | grep -o '"total":[0-9]*' | head -1 | grep -o '[0-9]*' || echo "0")
cd ..

if [ "$VULN_COUNT" = "0" ]; then
    print_check "PASS" "No npm vulnerabilities detected"
else
    print_check "FAIL" "$VULN_COUNT npm vulnerabilities found (MED-005)" "MEDIUM"
fi

# Check 3.2: CSP headers in Next.js
echo "3.2 Checking Content Security Policy..."
if grep -r "Content-Security-Policy" frontend/next.config.js > /dev/null 2>&1; then
    print_check "PASS" "CSP configured in Next.js"
else
    print_check "FAIL" "No CSP configured (MED-004)" "MEDIUM"
fi

# Check 3.3: API URL hardcoded
echo "3.3 Checking API URL configuration..."
if grep -r "http://localhost:8080" frontend/src/lib/api/*.ts > /dev/null 2>&1; then
    if grep -r "process.env.NEXT_PUBLIC_API_URL" frontend/src/lib/api/*.ts > /dev/null 2>&1; then
        print_check "PASS" "API URL uses environment variable"
    else
        print_check "FAIL" "API URL partially hardcoded" "LOW"
    fi
else
    print_check "PASS" "No hardcoded API URLs detected"
fi

echo ""

# ============================================================================
# DEPENDENCY CHECKS
# ============================================================================

echo -e "${BLUE}[4] Dependency Security Checks${NC}"
echo ""

# Check 4.1: Go dependencies
echo "4.1 Checking Go dependencies..."
if command -v govulncheck &> /dev/null; then
    cd backend/collection-management
    if govulncheck ./... > /dev/null 2>&1; then
        print_check "PASS" "No Go vulnerabilities detected"
    else
        print_check "FAIL" "Go vulnerabilities found (HIGH-004)" "HIGH"
    fi
    cd ../..
else
    print_check "WARN" "govulncheck not installed (run: go install golang.org/x/vuln/cmd/govulncheck@latest)"
fi

# Check 4.2: Outdated Go version
echo "4.2 Checking Go version..."
GO_VERSION=$(grep "^go " backend/collection-management/go.mod | awk '{print $2}')
if [ "$GO_VERSION" = "1.21" ] || [ "$GO_VERSION" = "1.22" ]; then
    print_check "PASS" "Go version is recent ($GO_VERSION)"
else
    print_check "WARN" "Go version may be outdated ($GO_VERSION)"
fi

echo ""

# ============================================================================
# RUNTIME CHECKS (if server is running)
# ============================================================================

echo -e "${BLUE}[5] Runtime Security Checks${NC}"
echo ""

# Check 5.1: Server is running
echo "5.1 Checking if server is running..."
if curl -s http://localhost:8080/api/v1/health > /dev/null 2>&1; then
    print_check "PASS" "Server is running"

    # Check 5.2: Security headers in HTTP response
    echo "5.2 Checking HTTP security headers..."
    HEADERS=$(curl -sI http://localhost:8080/api/v1/health)

    if echo "$HEADERS" | grep -q "X-Content-Type-Options"; then
        print_check "PASS" "X-Content-Type-Options header present"
    else
        print_check "FAIL" "X-Content-Type-Options header missing (MED-001)" "MEDIUM"
    fi

    if echo "$HEADERS" | grep -q "X-Frame-Options"; then
        print_check "PASS" "X-Frame-Options header present"
    else
        print_check "FAIL" "X-Frame-Options header missing (MED-001)" "MEDIUM"
    fi

    # Check 5.3: CORS headers
    echo "5.3 Checking CORS configuration..."
    CORS=$(curl -sI -H "Origin: http://malicious.com" http://localhost:8080/api/v1/health | grep "Access-Control-Allow-Origin")
    if [ -z "$CORS" ]; then
        print_check "PASS" "CORS correctly restricts origins"
    else
        print_check "FAIL" "CORS may accept unauthorized origins (CRIT-003)" "CRITICAL"
    fi

    # Check 5.4: Test authentication
    echo "5.4 Testing authentication requirement..."
    AUTH_TEST=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:8080/api/v1/collections/summary)
    if [ "$AUTH_TEST" = "401" ]; then
        print_check "PASS" "Endpoints require authentication"
    elif [ "$AUTH_TEST" = "200" ]; then
        print_check "FAIL" "Endpoints accessible without authentication (CRIT-001)" "CRITICAL"
    else
        print_check "WARN" "Unexpected response code: $AUTH_TEST"
    fi

else
    print_check "WARN" "Server not running, skipping runtime checks"
    echo "  (Start server with: cd backend/collection-management && go run cmd/api/main.go)"
fi

echo ""

# ============================================================================
# SUMMARY
# ============================================================================

echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}  Audit Summary${NC}"
echo -e "${BLUE}========================================${NC}"
echo ""

TOTAL_ISSUES=$((CRITICAL + HIGH + MEDIUM + LOW))

echo -e "Checks Passed: ${GREEN}$PASSED${NC}"
echo -e "Issues Found:  ${RED}$TOTAL_ISSUES${NC}"
echo ""
echo -e "  ${RED}CRITICAL: $CRITICAL${NC}"
echo -e "  ${YELLOW}HIGH:     $HIGH${NC}"
echo -e "  ${YELLOW}MEDIUM:   $MEDIUM${NC}"
echo -e "  ${BLUE}LOW:      $LOW${NC}"
echo ""

# Calculate security score (0-10)
MAX_SCORE=10
DEDUCTIONS=$((CRITICAL * 2 + HIGH * 1 + MEDIUM * 0))
SECURITY_SCORE=$((MAX_SCORE - DEDUCTIONS))
if [ $SECURITY_SCORE -lt 0 ]; then
    SECURITY_SCORE=0
fi

echo -e "Security Score: ${YELLOW}$SECURITY_SCORE/10${NC}"
echo ""

# Recommendations
if [ $CRITICAL -gt 0 ]; then
    echo -e "${RED}⚠ CRITICAL issues detected! Address immediately before production.${NC}"
    echo "   Priority: CRIT-001 (Auth), CRIT-002 (SQL Injection), CRIT-003 (CORS), CRIT-004 (Credentials)"
    echo ""
fi

if [ $HIGH -gt 0 ]; then
    echo -e "${YELLOW}⚠ HIGH severity issues detected. Address before production.${NC}"
    echo ""
fi

# Report location
REPORT_FILE="Security/reports/2026-04-21_audit-mvp.md"
if [ -f "$REPORT_FILE" ]; then
    echo -e "Full audit report: ${BLUE}$REPORT_FILE${NC}"
fi

echo -e "Quick wins guide: ${BLUE}Security/recommendations/QUICK-WINS.md${NC}"
echo ""

# Exit code based on severity
if [ $CRITICAL -gt 0 ]; then
    exit 2  # Critical issues found
elif [ $HIGH -gt 0 ]; then
    exit 1  # High severity issues found
else
    exit 0  # All good
fi
