#!/bin/bash
set -e

# Script de redémarrage de l'environnement local Collectoria
# Usage: ./scripts/restart-local.sh

echo "========================================="
echo "Redémarrage de l'environnement Collectoria"
echo "========================================="
echo ""

# Définir les couleurs pour l'affichage
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Fonction pour afficher les messages
info() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# 1. Arrêt des services
echo "Étape 1/5 : Arrêt des services"
echo "--------------------------------"
info "Arrêt du frontend Next.js..."
pkill -f "next-server" 2>/dev/null || warn "Aucun processus Next.js trouvé"

info "Arrêt du backend Go..."
pkill -f "go run" 2>/dev/null || warn "Aucun processus Go trouvé"
lsof -ti :8080 2>/dev/null | xargs -r kill -9 || true

sleep 2
echo ""

# 2. Nettoyage des caches
echo "Étape 2/5 : Nettoyage des caches"
echo "--------------------------------"
FRONTEND_DIR="/home/arnaud.dars/git/Collectoria/frontend"
if [ -d "$FRONTEND_DIR/.next" ]; then
    info "Suppression du cache frontend (.next/)..."
    rm -rf "$FRONTEND_DIR/.next"
else
    warn "Pas de cache frontend à nettoyer"
fi
echo ""

# 3. Vérification de PostgreSQL
echo "Étape 3/5 : Vérification de PostgreSQL"
echo "---------------------------------------"
if sg docker -c "docker ps | grep collectoria-collection-db" > /dev/null 2>&1; then
    info "PostgreSQL est en cours d'exécution"
    if sg docker -c "docker exec collectoria-collection-db pg_isready -U collectoria" > /dev/null 2>&1; then
        info "PostgreSQL est prêt à accepter les connexions"
    else
        error "PostgreSQL ne répond pas"
        exit 1
    fi
else
    warn "PostgreSQL n'est pas démarré, tentative de démarrage..."
    if sg docker -c "docker start collectoria-collection-db" > /dev/null 2>&1; then
        info "PostgreSQL démarré avec succès"
        sleep 3
    else
        error "Impossible de démarrer PostgreSQL"
        exit 1
    fi
fi
echo ""

# 4. Démarrage des services
echo "Étape 4/5 : Démarrage des services"
echo "-----------------------------------"

# Démarrage du backend
info "Démarrage du backend Go sur le port 8080..."
cd /home/arnaud.dars/git/Collectoria/backend/collection-management
DB_HOST=localhost \
DB_PORT=5432 \
DB_USER=collectoria \
DB_PASSWORD=changeme \
DB_NAME=collection_management \
DB_SSLMODE=disable \
CORS_ALLOWED_ORIGINS="http://localhost:3000,http://localhost:3001" \
ENV=development \
LOG_LEVEL=info \
nohup go run cmd/api/main.go > /tmp/backend-collectoria.log 2>&1 &

sleep 3

# Vérification du backend
if curl -s http://localhost:8080/api/v1/health > /dev/null 2>&1; then
    info "Backend démarré avec succès"
else
    error "Échec du démarrage du backend"
    error "Logs: /tmp/backend-collectoria.log"
    tail -20 /tmp/backend-collectoria.log
    exit 1
fi

# Démarrage du frontend
info "Démarrage du frontend Next.js..."
cd "$FRONTEND_DIR"
nohup npm run dev > /tmp/frontend-collectoria.log 2>&1 &

sleep 5

# Vérification du frontend
if curl -s -o /dev/null -w "%{http_code}" http://localhost:3000 | grep -q "200\|304"; then
    info "Frontend démarré avec succès"
else
    warn "Frontend en cours de démarrage (peut prendre quelques secondes de plus)"
fi
echo ""

# 5. Rapport final
echo "Étape 5/5 : Rapport de démarrage"
echo "---------------------------------"
echo ""
echo "Services en cours d'exécution:"
echo ""
echo "  PostgreSQL:"
echo "    - Container: collectoria-collection-db"
echo "    - Port: 5432"
echo "    - Status: $(sg docker -c 'docker exec collectoria-collection-db pg_isready -U collectoria' 2>&1)"
echo ""
echo "  Backend Go:"
echo "    - Port: 8080"
echo "    - Health: http://localhost:8080/api/v1/health"
HEALTH_STATUS=$(curl -s http://localhost:8080/api/v1/health 2>&1 || echo '{"status":"error"}')
echo "    - Status: $(echo $HEALTH_STATUS | grep -o '"status":"[^"]*"' | cut -d'"' -f4)"
echo "    - Logs: /tmp/backend-collectoria.log"
echo ""
echo "  Frontend Next.js:"
FRONTEND_PORT=$(lsof -ti :3000 >/dev/null 2>&1 && echo "3000" || lsof -ti :3001 >/dev/null 2>&1 && echo "3001" || echo "N/A")
echo "    - Port: $FRONTEND_PORT"
echo "    - URL: http://localhost:$FRONTEND_PORT"
echo "    - Logs: /tmp/frontend-collectoria.log"
echo ""
echo "========================================="
echo -e "${GREEN}Environnement redémarré avec succès!${NC}"
echo "========================================="
echo ""
echo "Actions recommandées:"
echo "  1. Videz le cache de votre navigateur (Ctrl+Shift+R ou Cmd+Shift+R)"
echo "  2. Si les problèmes CORS persistent, vérifiez les en-têtes dans DevTools"
echo "  3. Consultez les logs en cas d'erreur:"
echo "     - Backend: tail -f /tmp/backend-collectoria.log"
echo "     - Frontend: tail -f /tmp/frontend-collectoria.log"
echo ""
