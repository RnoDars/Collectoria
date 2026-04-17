#!/bin/bash
# Script principal pour tester tous les services localement
# Usage: ./scripts/test-local.sh [service-name]
# Utilise `sg docker` car le groupe docker peut ne pas être actif en session courante

set -e

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SERVICE=${1:-all}

echo "======================================"
echo "Collectoria - Tests Locaux"
echo "======================================"

# 1. Vérifier les prérequis
check_prerequisites() {
    echo "Vérification des prérequis..."
    command -v docker >/dev/null 2>&1 || { echo "Docker requis"; exit 1; }
    command -v go >/dev/null 2>&1 || { echo "Go requis"; exit 1; }
    command -v jq >/dev/null 2>&1 || { echo "jq requis (sudo apt install jq)"; exit 1; }
    command -v curl >/dev/null 2>&1 || { echo "curl requis"; exit 1; }
}

# 2. Setup PostgreSQL via docker-compose du microservice
setup_postgres() {
    local compose_file="$REPO_ROOT/backend/collection-management/docker-compose.yml"
    echo "Setup PostgreSQL (collectoria-collection-db)..."
    if sg docker -c "docker ps -q -f name=collectoria-collection-db" | grep -q .; then
        echo "PostgreSQL déjà lancé"
        return 0
    fi
    sg docker -c "docker compose -f '$compose_file' up -d"
    echo "Attente que PostgreSQL soit prêt..."
    local retries=0
    until sg docker -c "docker exec collectoria-collection-db pg_isready -U collectoria" >/dev/null 2>&1; do
        retries=$((retries + 1))
        [ $retries -ge 12 ] && { echo "PostgreSQL n'est pas prêt après 60s"; exit 1; }
        sleep 5
    done
    echo "PostgreSQL prêt !"
}

# 3. Seed les données de test
seed_data() {
    local service_path="$REPO_ROOT/backend/collection-management"
    echo "Seed des données de test..."
    sg docker -c "docker exec -i collectoria-collection-db psql -U collectoria -d collection_management" \
        < "$service_path/testdata/seed_meccg_mock.sql"
    echo "Seed terminé !"
}

# 4. Lancer le service Go
start_service() {
    local service_path="$REPO_ROOT/backend/collection-management"
    echo "Démarrage du service collection-management..."
    (cd "$service_path" && go run cmd/api/main.go) &
    SERVICE_PID=$!
    echo "Attente du démarrage du service (PID $SERVICE_PID)..."
    sleep 5
}

# 5. Tester les endpoints
test_endpoints() {
    echo "Test des endpoints..."

    local base_url="http://localhost:8080"

    # Test /api/v1/collections
    echo "  -> GET /api/v1/collections"
    response=$(curl -s "$base_url/api/v1/collections")
    if echo "$response" | jq . >/dev/null 2>&1; then
        echo "  OK : /api/v1/collections"
        echo "$response" | jq '{total_items: .total_items, total_collections: (.collections | length)}'
    else
        echo "  ECHEC : /api/v1/collections"
        echo "  Réponse brute : $response"
        exit 1
    fi

    # Test /api/v1/collections/summary
    echo "  -> GET /api/v1/collections/summary"
    response=$(curl -s "$base_url/api/v1/collections/summary")
    if echo "$response" | jq . >/dev/null 2>&1; then
        echo "  OK : /api/v1/collections/summary"
        echo "$response" | jq .
    else
        echo "  ECHEC : /api/v1/collections/summary"
        echo "  Réponse brute : $response"
        exit 1
    fi
}

# 6. Cleanup
cleanup() {
    echo "Nettoyage..."
    [ -n "$SERVICE_PID" ] && kill "$SERVICE_PID" 2>/dev/null || true
    # Ne pas arrêter le conteneur postgres ici — laisser make cleanup le faire
}

# Trap pour cleanup automatique en cas d'erreur ou CTRL+C
trap cleanup EXIT INT TERM

# Exécution principale
check_prerequisites
setup_postgres

case $SERVICE in
    "collection-management"|"all")
        seed_data
        start_service
        test_endpoints
        ;;
    *)
        echo "Service inconnu: $SERVICE"
        echo "Services disponibles: collection-management, all"
        exit 1
        ;;
esac

echo "======================================"
echo "Tests locaux terminés avec succès !"
echo "======================================"
