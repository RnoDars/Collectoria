#!/bin/bash

# Script de test manuel pour l'authentification JWT
# Usage: ./scripts/test_auth.sh

set -e

API_URL="http://localhost:8080/api/v1"

echo "========================================="
echo "JWT Authentication Test Script"
echo "========================================="
echo ""

# Test 1: Health check (public endpoint - no auth required)
echo "Test 1: Health Check (public endpoint)"
echo "---------------------------------------"
curl -s -X GET "$API_URL/health" | jq .
echo ""

# Test 2: Try to access protected endpoint without token (should fail)
echo "Test 2: Access protected endpoint WITHOUT token"
echo "---------------------------------------"
echo "Expected: 401 Unauthorized"
curl -s -X GET "$API_URL/collections/summary" | jq .
echo ""

# Test 3: Login to get a token
echo "Test 3: Login to get JWT token"
echo "---------------------------------------"
LOGIN_RESPONSE=$(curl -s -X POST "$API_URL/auth/login" \
  -H "Content-Type: application/json" \
  -d '{"email":"test@collectoria.com","password":"test123"}')

echo "$LOGIN_RESPONSE" | jq .
TOKEN=$(echo "$LOGIN_RESPONSE" | jq -r '.token')
echo ""

# Test 4: Access protected endpoint with valid token (should succeed)
echo "Test 4: Access protected endpoint WITH valid token"
echo "---------------------------------------"
echo "Expected: 200 OK with collection summary data"
curl -s -X GET "$API_URL/collections/summary" \
  -H "Authorization: Bearer $TOKEN" | jq .
echo ""

# Test 5: Access another protected endpoint
echo "Test 5: Access collections list WITH valid token"
echo "---------------------------------------"
curl -s -X GET "$API_URL/collections" \
  -H "Authorization: Bearer $TOKEN" | jq .
echo ""

# Test 6: Access with malformed token (should fail)
echo "Test 6: Access protected endpoint with INVALID token"
echo "---------------------------------------"
echo "Expected: 401 Unauthorized"
curl -s -X GET "$API_URL/collections/summary" \
  -H "Authorization: Bearer invalid.token.here" | jq .
echo ""

# Test 7: Access without Bearer prefix (should fail)
echo "Test 7: Access protected endpoint without Bearer prefix"
echo "---------------------------------------"
echo "Expected: 401 Unauthorized"
curl -s -X GET "$API_URL/collections/summary" \
  -H "Authorization: $TOKEN" | jq .
echo ""

echo "========================================="
echo "All tests completed!"
echo "========================================="
