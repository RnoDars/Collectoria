#!/bin/bash
# Script de diagnostic production Collectoria
# Vérifie l'état de santé complet de l'infrastructure production

set -e

COMPOSE_FILE="${COMPOSE_FILE:-docker-compose.prod.yml}"
DB_USER="${DB_USER:-}"
DB_NAME="${DB_NAME:-}"

# Couleurs pour affichage
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo "============================================"
echo "  Diagnostic Production Collectoria"
echo "============================================"
echo ""

# Fonction d'affichage des résultats
print_check() {
  local status=$1
  local message=$2
  if [ "$status" = "OK" ]; then
    echo -e "${GREEN}✅ $message${NC}"
  elif [ "$status" = "WARN" ]; then
    echo -e "${YELLOW}⚠️  $message${NC}"
  else
    echo -e "${RED}❌ $message${NC}"
  fi
}

# 1. Vérification Espace Disque
echo "1️⃣  Vérification Espace Disque"
echo "────────────────────────────────────────"
DISK_AVAILABLE=$(df -h / | awk 'NR==2 {print $4}')
DISK_AVAILABLE_GB=$(df / | awk 'NR==2 {print $4}')
DISK_USED_PERCENT=$(df / | awk 'NR==2 {print $5}')

echo "Espace disponible : $DISK_AVAILABLE"
echo "Utilisation disque : $DISK_USED_PERCENT"

if [ "$DISK_AVAILABLE_GB" -lt 2097152 ]; then  # < 2GB
  print_check "ERROR" "Espace disque insuffisant (< 2 GB)"
  echo "  Conseil : docker builder prune -f"
elif [ "$DISK_AVAILABLE_GB" -lt 5242880 ]; then  # < 5GB
  print_check "WARN" "Espace disque limité (< 5 GB)"
else
  print_check "OK" "Espace disque suffisant"
fi

echo ""

# 2. Vérification Variables d'Environnement
echo "2️⃣  Vérification Variables d'Environnement"
echo "────────────────────────────────────────"

if [ ! -f .env ]; then
  print_check "ERROR" "Fichier .env manquant"
else
  print_check "OK" "Fichier .env présent"

  # Vérifier placeholders vides
  EMPTY_VARS=$(grep -E "^[A-Z_]+=$" .env || true)
  if [ -n "$EMPTY_VARS" ]; then
    print_check "ERROR" "Variables vides détectées :"
    echo "$EMPTY_VARS" | sed 's/^/    /'
  else
    print_check "OK" "Aucune variable vide"
  fi

  # Vérifier variables critiques
  source .env 2>/dev/null || true

  [ -n "$DB_USER" ] && print_check "OK" "DB_USER défini" || print_check "ERROR" "DB_USER manquant"
  [ -n "$DB_PASSWORD" ] && print_check "OK" "DB_PASSWORD défini" || print_check "ERROR" "DB_PASSWORD manquant"
  [ -n "$DB_NAME" ] && print_check "OK" "DB_NAME défini" || print_check "ERROR" "DB_NAME manquant"
  [ -n "$JWT_SECRET" ] && print_check "OK" "JWT_SECRET défini" || print_check "ERROR" "JWT_SECRET manquant"
fi

echo ""

# 3. Vérification État des Containers
echo "3️⃣  Vérification État des Containers"
echo "────────────────────────────────────────"

CONTAINERS=$(docker compose -f "$COMPOSE_FILE" ps --format "table {{.Service}}\t{{.Status}}" 2>/dev/null || echo "")

if [ -z "$CONTAINERS" ]; then
  print_check "ERROR" "Aucun container en cours d'exécution"
else
  echo "$CONTAINERS"
  echo ""

  # Vérifier chaque service
  for service in postgres-collection backend-collection frontend; do
    STATUS=$(docker compose -f "$COMPOSE_FILE" ps "$service" --format "{{.Status}}" 2>/dev/null || echo "not found")

    if [[ "$STATUS" =~ "Up" ]] && [[ "$STATUS" =~ "healthy" ]]; then
      print_check "OK" "$service : healthy"
    elif [[ "$STATUS" =~ "Up" ]]; then
      print_check "WARN" "$service : up mais pas healthy"
    else
      print_check "ERROR" "$service : $STATUS"
    fi
  done
fi

echo ""

# 4. Health Checks Endpoints
echo "4️⃣  Health Checks Endpoints"
echo "────────────────────────────────────────"

# Backend API
BACKEND_HEALTH=$(curl -s -o /dev/null -w "%{http_code}" https://api.darsling.fr/api/v1/health 2>/dev/null || echo "000")
if [ "$BACKEND_HEALTH" = "200" ]; then
  print_check "OK" "Backend API : HTTP $BACKEND_HEALTH"
else
  print_check "ERROR" "Backend API : HTTP $BACKEND_HEALTH (attendu 200)"
fi

# Frontend
FRONTEND_HEALTH=$(curl -s -o /dev/null -w "%{http_code}" https://darsling.fr 2>/dev/null || echo "000")
if [ "$FRONTEND_HEALTH" = "200" ]; then
  print_check "OK" "Frontend : HTTP $FRONTEND_HEALTH"
else
  print_check "ERROR" "Frontend : HTTP $FRONTEND_HEALTH (attendu 200)"
fi

echo ""

# 5. Vérification Extensions PostgreSQL
echo "5️⃣  Vérification Extensions PostgreSQL"
echo "────────────────────────────────────────"

if [ -n "$DB_USER" ] && [ -n "$DB_NAME" ]; then
  UNACCENT_INSTALLED=$(docker compose -f "$COMPOSE_FILE" exec -T postgres-collection psql -U "$DB_USER" -d "$DB_NAME" -t -c "SELECT extname FROM pg_extension WHERE extname = 'unaccent';" 2>/dev/null || echo "")

  if [[ "$UNACCENT_INSTALLED" =~ "unaccent" ]]; then
    print_check "OK" "Extension unaccent installée"
  else
    print_check "ERROR" "Extension unaccent MANQUANTE"
    echo "  Correction : docker compose -f $COMPOSE_FILE exec postgres-collection psql -U $DB_USER -d $DB_NAME -c \"CREATE EXTENSION IF NOT EXISTS unaccent;\""
  fi
else
  print_check "WARN" "DB_USER ou DB_NAME non défini, skip vérification extensions"
fi

echo ""

# 6. Vérification Logs Récents (Erreurs)
echo "6️⃣  Vérification Logs Récents (Erreurs)"
echo "────────────────────────────────────────"

# Backend errors
BACKEND_ERRORS=$(docker compose -f "$COMPOSE_FILE" logs --tail=50 backend-collection 2>/dev/null | grep -iE "(error|fatal|panic)" | wc -l || echo "0")
if [ "$BACKEND_ERRORS" -eq 0 ]; then
  print_check "OK" "Backend : aucune erreur récente"
else
  print_check "WARN" "Backend : $BACKEND_ERRORS erreur(s) dans les 50 dernières lignes"
  echo "  Voir logs : docker compose -f $COMPOSE_FILE logs --tail=100 backend-collection"
fi

# Frontend errors
FRONTEND_ERRORS=$(docker compose -f "$COMPOSE_FILE" logs --tail=50 frontend 2>/dev/null | grep -iE "(error|fatal)" | wc -l || echo "0")
if [ "$FRONTEND_ERRORS" -eq 0 ]; then
  print_check "OK" "Frontend : aucune erreur récente"
else
  print_check "WARN" "Frontend : $FRONTEND_ERRORS erreur(s) dans les 50 dernières lignes"
  echo "  Voir logs : docker compose -f $COMPOSE_FILE logs --tail=100 frontend"
fi

echo ""

# 7. Vérification Cache Docker
echo "7️⃣  Vérification Cache Docker"
echo "────────────────────────────────────────"

DOCKER_SYSTEM=$(docker system df 2>/dev/null || echo "")
if [ -n "$DOCKER_SYSTEM" ]; then
  echo "$DOCKER_SYSTEM"

  BUILD_CACHE_SIZE=$(echo "$DOCKER_SYSTEM" | grep "Build Cache" | awk '{print $4}')
  if [ -n "$BUILD_CACHE_SIZE" ]; then
    # Extraire valeur numérique (ex: "2.5GB" -> 2.5)
    BUILD_CACHE_NUM=$(echo "$BUILD_CACHE_SIZE" | sed 's/GB//;s/MB//' | awk '{print $1}')

    if (( $(echo "$BUILD_CACHE_NUM > 2" | bc -l 2>/dev/null || echo "0") )); then
      print_check "WARN" "Build Cache volumineux ($BUILD_CACHE_SIZE), recommandation : docker builder prune -f"
    else
      print_check "OK" "Build Cache raisonnable ($BUILD_CACHE_SIZE)"
    fi
  fi
else
  print_check "WARN" "Impossible de récupérer docker system df"
fi

echo ""

# 8. Résumé Final
echo "============================================"
echo "  Résumé du Diagnostic"
echo "============================================"
echo ""
echo "Si des erreurs sont détectées :"
echo "  1. Vérifier logs détaillés (section 6)"
echo "  2. Consulter DevOps/CLAUDE.md section 'Problèmes Courants'"
echo "  3. Consulter Continuous-Improvement/recommendations/devops-production-deployment-checklist_2026-05-04.md"
echo ""
echo "Commandes utiles :"
echo "  Logs détaillés : docker compose -f $COMPOSE_FILE logs -f [service]"
echo "  Redémarrage : docker compose -f $COMPOSE_FILE restart [service]"
echo "  Rebuild : docker compose -f $COMPOSE_FILE build --no-cache [service] && docker compose -f $COMPOSE_FILE up -d --no-deps [service]"
echo ""
