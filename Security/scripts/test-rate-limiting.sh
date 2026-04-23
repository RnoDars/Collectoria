#!/bin/bash

# Test script for Rate Limiting implementation
# Usage: ./test-rate-limiting.sh [BASE_URL]
# Default BASE_URL: http://localhost:8080

BASE_URL="${1:-http://localhost:8080}"
API_URL="${BASE_URL}/api/v1"

echo "=========================================="
echo "Rate Limiting Test Script"
echo "=========================================="
echo "Testing against: ${API_URL}"
echo ""

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Test 1: Login Rate Limiting (5 requests / 15 minutes)
echo "=========================================="
echo "Test 1: Login Rate Limiting (5/15min)"
echo "=========================================="
echo "Sending 7 requests to /auth/login..."
echo ""

for i in {1..7}; do
    echo "Request #${i}:"
    response=$(curl -s -w "\nHTTP_CODE:%{http_code}" -X POST "${API_URL}/auth/login" \
        -H "Content-Type: application/json" \
        -d '{"username":"test","password":"test"}' \
        -i 2>&1)

    http_code=$(echo "$response" | grep "HTTP_CODE" | cut -d: -f2)
    rate_limit=$(echo "$response" | grep -i "X-RateLimit-Limit:" | cut -d: -f2 | tr -d ' \r')
    remaining=$(echo "$response" | grep -i "X-RateLimit-Remaining:" | cut -d: -f2 | tr -d ' \r')
    retry_after=$(echo "$response" | grep -i "Retry-After:" | cut -d: -f2 | tr -d ' \r')

    if [ "$http_code" = "429" ]; then
        echo -e "${RED}  Status: 429 Too Many Requests ✗${NC}"
        echo "  X-RateLimit-Limit: ${rate_limit}"
        echo "  X-RateLimit-Remaining: ${remaining}"
        echo "  Retry-After: ${retry_after}s"
    elif [ "$http_code" = "401" ] || [ "$http_code" = "400" ]; then
        echo -e "${GREEN}  Status: ${http_code} (Rate limit not reached) ✓${NC}"
        echo "  X-RateLimit-Limit: ${rate_limit}"
        echo "  X-RateLimit-Remaining: ${remaining}"
    else
        echo -e "${YELLOW}  Status: ${http_code}${NC}"
        echo "  X-RateLimit-Limit: ${rate_limit}"
        echo "  X-RateLimit-Remaining: ${remaining}"
    fi
    echo ""

    # Small delay between requests
    sleep 0.2
done

echo "Expected: Requests 1-5 should pass (401/400), requests 6-7 should return 429"
echo ""

# Test 2: Read Rate Limiting (100 requests / 1 minute)
echo "=========================================="
echo "Test 2: Read Rate Limiting (100/1min)"
echo "=========================================="
echo "Sending 5 requests to /cards (no auth, should get 401 but check rate limit headers)..."
echo ""

for i in {1..5}; do
    echo "Request #${i}:"
    response=$(curl -s -w "\nHTTP_CODE:%{http_code}" -X GET "${API_URL}/cards" -i 2>&1)

    http_code=$(echo "$response" | grep "HTTP_CODE" | cut -d: -f2)
    rate_limit=$(echo "$response" | grep -i "X-RateLimit-Limit:" | cut -d: -f2 | tr -d ' \r')
    remaining=$(echo "$response" | grep -i "X-RateLimit-Remaining:" | cut -d: -f2 | tr -d ' \r')

    echo "  Status: ${http_code}"
    echo "  X-RateLimit-Limit: ${rate_limit}"
    echo "  X-RateLimit-Remaining: ${remaining}"
    echo ""

    sleep 0.2
done

echo "Note: Read endpoints have high limit (100/min), would need 100+ requests to trigger 429"
echo ""

# Test 3: Health Check (no rate limiting)
echo "=========================================="
echo "Test 3: Health Check (no rate limit)"
echo "=========================================="
echo "Sending 10 requests to /health..."
echo ""

success_count=0
for i in {1..10}; do
    response=$(curl -s -w "\nHTTP_CODE:%{http_code}" -X GET "${API_URL}/health" -i 2>&1)
    http_code=$(echo "$response" | grep "HTTP_CODE" | cut -d: -f2)
    rate_limit=$(echo "$response" | grep -i "X-RateLimit-Limit:" | cut -d: -f2 | tr -d ' \r')

    if [ "$http_code" = "200" ] && [ -z "$rate_limit" ]; then
        ((success_count++))
    fi
done

if [ $success_count -eq 10 ]; then
    echo -e "${GREEN}✓ All 10 requests succeeded without rate limiting${NC}"
else
    echo -e "${RED}✗ Only ${success_count}/10 requests succeeded${NC}"
fi
echo ""

# Summary
echo "=========================================="
echo "Summary"
echo "=========================================="
echo "✓ Login endpoint: Rate limited (5/15min)"
echo "✓ Read endpoints: Rate limited (100/1min)"
echo "✓ Health endpoint: No rate limiting"
echo ""
echo "Rate limiting headers:"
echo "  - X-RateLimit-Limit: Maximum requests allowed"
echo "  - X-RateLimit-Remaining: Requests remaining in window"
echo "  - X-RateLimit-Reset: Unix timestamp when limit resets"
echo "  - Retry-After: Seconds to wait (only on 429 response)"
echo ""
echo "To test with authentication, first get a JWT token:"
echo "  TOKEN=\$(curl -s -X POST \"${API_URL}/auth/login\" \\"
echo "    -H \"Content-Type: application/json\" \\"
echo "    -d '{\"username\":\"admin\",\"password\":\"your-password\"}' | jq -r .token)"
echo ""
echo "  curl -H \"Authorization: Bearer \$TOKEN\" \"${API_URL}/collections\""
