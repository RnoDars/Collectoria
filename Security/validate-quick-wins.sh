#!/bin/bash
# Script de validation des 7 Quick Wins de sécurité

set -e

echo "========================================"
echo "  Validation des Quick Wins Sécurité"
echo "========================================"
echo ""

BACKEND_DIR="/home/arnaud.dars/git/Collectoria/backend/collection-management"
BACKEND_URL="http://localhost:8080"

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Test counter
PASSED=0
FAILED=0

# Function to print test result
test_result() {
    if [ $1 -eq 0 ]; then
        echo -e "${GREEN}✓ $2${NC}"
        ((PASSED++))
    else
        echo -e "${RED}✗ $2${NC}"
        ((FAILED++))
    fi
}

echo "=== Quick Win #1: Headers de Sécurité HTTP ==="
echo "Vérification de la présence des headers de sécurité..."

if curl -sI ${BACKEND_URL}/api/v1/health 2>/dev/null | grep -q "X-Content-Type-Options"; then
    test_result 0 "Header X-Content-Type-Options présent"
else
    test_result 1 "Header X-Content-Type-Options manquant"
fi

if curl -sI ${BACKEND_URL}/api/v1/health 2>/dev/null | grep -q "X-Frame-Options"; then
    test_result 0 "Header X-Frame-Options présent"
else
    test_result 1 "Header X-Frame-Options manquant"
fi

if curl -sI ${BACKEND_URL}/api/v1/health 2>/dev/null | grep -q "X-XSS-Protection"; then
    test_result 0 "Header X-XSS-Protection présent"
else
    test_result 1 "Header X-XSS-Protection manquant"
fi

if curl -sI ${BACKEND_URL}/api/v1/health 2>/dev/null | grep -q "Referrer-Policy"; then
    test_result 0 "Header Referrer-Policy présent"
else
    test_result 1 "Header Referrer-Policy manquant"
fi

if curl -sI ${BACKEND_URL}/api/v1/health 2>/dev/null | grep -q "Content-Security-Policy"; then
    test_result 0 "Header Content-Security-Policy présent"
else
    test_result 1 "Header Content-Security-Policy manquant"
fi

echo ""
echo "=== Quick Win #2: CORS Configurable ==="
echo "Vérification de la configuration CORS..."

if grep -q "CORS_ALLOWED_ORIGINS" ${BACKEND_DIR}/.env.example; then
    test_result 0 "CORS_ALLOWED_ORIGINS présent dans .env.example"
else
    test_result 1 "CORS_ALLOWED_ORIGINS manquant dans .env.example"
fi

if grep -q "CORSConfig" ${BACKEND_DIR}/internal/config/config.go; then
    test_result 0 "CORSConfig défini dans config.go"
else
    test_result 1 "CORSConfig manquant dans config.go"
fi

echo ""
echo "=== Quick Win #3: Health Check Amélioré ==="
echo "Vérification du health check avec status DB..."

HEALTH_RESPONSE=$(curl -s ${BACKEND_URL}/api/v1/health 2>/dev/null || echo "{}")
if echo "$HEALTH_RESPONSE" | grep -q "database"; then
    test_result 0 "Health check inclut le status de la base de données"

    if echo "$HEALTH_RESPONSE" | grep -q "healthy"; then
        test_result 0 "Base de données reportée comme saine"
    else
        test_result 1 "Base de données non saine ou status manquant"
    fi
else
    test_result 1 "Health check ne vérifie pas la base de données"
fi

if echo "$HEALTH_RESPONSE" | grep -q "version"; then
    test_result 0 "Version incluse dans le health check"
else
    test_result 1 "Version manquante dans le health check"
fi

echo ""
echo "=== Quick Win #4: Credentials Docker Externalisés ==="
echo "Vérification des credentials dans docker-compose..."

if grep -q '\${DB_PASSWORD' ${BACKEND_DIR}/docker-compose.yml; then
    test_result 0 "Mot de passe PostgreSQL externalisé dans docker-compose.yml"
else
    test_result 1 "Mot de passe PostgreSQL hardcodé dans docker-compose.yml"
fi

if grep -q '\${DB_USER' ${BACKEND_DIR}/docker-compose.yml; then
    test_result 0 "Utilisateur PostgreSQL externalisé dans docker-compose.yml"
else
    test_result 1 "Utilisateur PostgreSQL hardcodé dans docker-compose.yml"
fi

if grep -q "DB_PASSWORD=your-secure-password-here" ${BACKEND_DIR}/.env.example; then
    test_result 0 ".env.example contient un placeholder pour DB_PASSWORD"
else
    test_result 1 ".env.example manque le placeholder DB_PASSWORD"
fi

echo ""
echo "=== Quick Win #5: Dockerfile Non-Root ==="
echo "Vérification de l'utilisateur Docker..."

if grep -q "USER collectoria" ${BACKEND_DIR}/Dockerfile; then
    test_result 0 "Dockerfile utilise un utilisateur non-root"
else
    test_result 1 "Dockerfile n'utilise pas d'utilisateur non-root"
fi

if grep -q "adduser.*collectoria" ${BACKEND_DIR}/Dockerfile; then
    test_result 0 "Utilisateur non-root créé dans le Dockerfile"
else
    test_result 1 "Utilisateur non-root non créé dans le Dockerfile"
fi

if grep -q "HEALTHCHECK" ${BACKEND_DIR}/Dockerfile; then
    test_result 0 "Healthcheck ajouté au Dockerfile"
else
    test_result 1 "Healthcheck manquant dans le Dockerfile"
fi

echo ""
echo "=== Quick Win #6: Logger Configurable ==="
echo "Vérification de la configuration du logger..."

if grep -q 'getEnv("ENV"' ${BACKEND_DIR}/cmd/api/main.go; then
    test_result 0 "Logger configurable selon l'environnement"
else
    test_result 1 "Logger non configurable selon l'environnement"
fi

if grep -q 'LOG_LEVEL' ${BACKEND_DIR}/.env.example; then
    test_result 0 "LOG_LEVEL présent dans .env.example"
else
    test_result 1 "LOG_LEVEL manquant dans .env.example"
fi

if grep -q "parseLogLevel" ${BACKEND_DIR}/cmd/api/main.go; then
    test_result 0 "Fonction parseLogLevel implémentée"
else
    test_result 1 "Fonction parseLogLevel manquante"
fi

# Vérifier que le password n'est pas loggué
if grep -q "Str(\"password\"" ${BACKEND_DIR}/internal/infrastructure/postgres/connection.go; then
    test_result 1 "⚠ ATTENTION: Password loggué dans connection.go"
else
    test_result 0 "Password non loggué dans connection.go"
fi

echo ""
echo "=== Quick Win #7: Validation des Entrées ==="
echo "Vérification de la validation des inputs..."

if [ -f "${BACKEND_DIR}/internal/infrastructure/http/validators/query_params.go" ]; then
    test_result 0 "Package validators créé"
else
    test_result 1 "Package validators manquant"
fi

if grep -q "ValidateQueryParams" ${BACKEND_DIR}/internal/infrastructure/http/validators/query_params.go 2>/dev/null; then
    test_result 0 "Fonction ValidateQueryParams implémentée"
else
    test_result 1 "Fonction ValidateQueryParams manquante"
fi

if grep -q "validators.ValidateStringParam" ${BACKEND_DIR}/internal/infrastructure/http/handlers/catalog_handler.go 2>/dev/null; then
    test_result 0 "Validation appliquée dans catalog_handler"
else
    test_result 1 "Validation non appliquée dans catalog_handler"
fi

echo ""
echo "=== Vérification .gitignore ==="
echo "S'assurer que les secrets ne sont pas commités..."

if grep -q "^\.env$" ${BACKEND_DIR}/.gitignore; then
    test_result 0 ".env dans .gitignore"
else
    test_result 1 ".env manquant dans .gitignore"
fi

if grep -q "secrets/" ${BACKEND_DIR}/.gitignore; then
    test_result 0 "secrets/ dans .gitignore"
else
    test_result 1 "secrets/ manquant dans .gitignore"
fi

if grep -q "\.pem" ${BACKEND_DIR}/.gitignore; then
    test_result 0 "Fichiers .pem dans .gitignore"
else
    test_result 1 "Fichiers .pem manquants dans .gitignore"
fi

# Vérifier que .env n'est pas tracké par Git
cd ${BACKEND_DIR}
if git ls-files --error-unmatch .env 2>/dev/null; then
    test_result 1 "⚠ ATTENTION: .env est tracké par Git!"
else
    test_result 0 ".env n'est pas tracké par Git"
fi

echo ""
echo "========================================"
echo "           RÉSULTAT FINAL"
echo "========================================"
echo -e "${GREEN}Tests réussis: ${PASSED}${NC}"
echo -e "${RED}Tests échoués: ${FAILED}${NC}"
echo ""

TOTAL=$((PASSED + FAILED))
SUCCESS_RATE=$((PASSED * 100 / TOTAL))

if [ $FAILED -eq 0 ]; then
    echo -e "${GREEN}✓ Tous les Quick Wins sont implémentés! (100%)${NC}"
    echo ""
    echo "Score de sécurité estimé: 7.0/10"
    exit 0
elif [ $SUCCESS_RATE -ge 80 ]; then
    echo -e "${YELLOW}⚠ La plupart des Quick Wins sont implémentés (${SUCCESS_RATE}%)${NC}"
    echo "Vérifiez les tests échoués ci-dessus."
    exit 1
else
    echo -e "${RED}✗ De nombreux Quick Wins ne sont pas implémentés (${SUCCESS_RATE}%)${NC}"
    echo "Implémentez les corrections manquantes."
    exit 1
fi
