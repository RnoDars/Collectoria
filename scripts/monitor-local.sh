#!/bin/bash
# Affiche le statut et les logs des services locaux
# Utilise `sg docker` car le groupe docker peut ne pas être actif en session courante

echo "======================================"
echo "Collectoria - Statut des services"
echo "======================================"
echo ""

# PostgreSQL
if sg docker -c "docker ps -q -f name=collectoria-collection-db" 2>/dev/null | grep -q .; then
    echo "[OK]  PostgreSQL (collectoria-collection-db) : Running (port 5432)"
else
    echo "[--]  PostgreSQL (collectoria-collection-db) : Stopped"
fi

# Backend collection-management
if lsof -i :8080 >/dev/null 2>&1; then
    pid=$(lsof -ti :8080 2>/dev/null | head -1)
    echo "[OK]  Collection Management : Running (port 8080, PID $pid)"
else
    echo "[--]  Collection Management : Stopped (port 8080)"
fi

# Frontend Next.js
if lsof -i :3000 >/dev/null 2>&1; then
    pid=$(lsof -ti :3000 2>/dev/null | head -1)
    echo "[OK]  Frontend Next.js : Running (port 3000, PID $pid)"
else
    echo "[--]  Frontend Next.js : Stopped (port 3000)"
fi

echo ""
echo "Ports en écoute (résumé) :"
ss -tlnp 2>/dev/null | grep -E ':3000|:8080|:5432' || echo "  Aucun port collectoria détecté"

echo ""
echo "Derniers logs PostgreSQL (10 lignes) :"
sg docker -c "docker logs --tail 10 collectoria-collection-db 2>/dev/null" || echo "  Pas de logs (container arrêté ou inexistant)"
echo "======================================"
