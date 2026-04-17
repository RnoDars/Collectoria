#!/bin/bash
# Nettoie tous les containers et processus de test locaux
# Utilise `sg docker` car le groupe docker peut ne pas être actif en session courante

set -e

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

echo "Nettoyage de l'environnement local..."

# Stop et remove PostgreSQL (via docker-compose du microservice)
compose_file="$REPO_ROOT/backend/collection-management/docker-compose.yml"
if sg docker -c "docker ps -q -f name=collectoria-collection-db" | grep -q .; then
    echo "Arrêt de collectoria-collection-db..."
    sg docker -c "docker compose -f '$compose_file' down -v"
else
    echo "collectoria-collection-db déjà arrêté"
fi

# Stop et remove tous les containers collectoria restants
remaining=$(sg docker -c "docker ps -a --format '{{.Names}}' | grep collectoria" 2>/dev/null || true)
if [ -n "$remaining" ]; then
    echo "Suppression des containers collectoria restants : $remaining"
    sg docker -c "docker ps -a -q --filter name=collectoria | xargs docker rm -f" 2>/dev/null || true
fi

# Kill les processus Go en cours (go run cmd/api/main.go)
if pgrep -f "go run cmd/api/main.go" >/dev/null 2>&1; then
    echo "Arrêt des processus Go (go run cmd/api/main.go)..."
    pkill -f "go run cmd/api/main.go" 2>/dev/null || true
else
    echo "Aucun processus Go en cours"
fi

echo "Nettoyage terminé !"
