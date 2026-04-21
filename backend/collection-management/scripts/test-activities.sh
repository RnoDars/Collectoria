#!/bin/bash
# Script de validation manuelle du système d'activités Phase 1
# Usage: ./scripts/test-activities.sh

set -e

API_BASE="http://localhost:8080/api/v1"
CARD_ID="97be4771-8b01-453f-92d1-56c04a4a4456"  # Gros Bolger

echo "=== Test 1: Ajouter une carte à la collection ==="
curl -s -X PATCH "${API_BASE}/cards/${CARD_ID}/possession" \
  -H "Content-Type: application/json" \
  -d '{"is_owned": true}' | jq -r '"✅ Carte possédée: " + .card.name_fr'

echo ""
echo "=== Test 2: Vérifier l'activité créée ==="
sleep 1
curl -s "${API_BASE}/activities/recent?limit=1" | \
  jq -r '.activities[0] | "✅ Activité: " + .type + " - " + .title'

echo ""
echo "=== Test 3: Retirer une carte de la collection ==="
curl -s -X PATCH "${API_BASE}/cards/${CARD_ID}/possession" \
  -H "Content-Type: application/json" \
  -d '{"is_owned": false}' | jq -r '"✅ Carte retirée: " + .card.name_fr'

echo ""
echo "=== Test 4: Vérifier la nouvelle activité ==="
sleep 1
curl -s "${API_BASE}/activities/recent?limit=1" | \
  jq -r '.activities[0] | "✅ Activité: " + .type + " - " + .title'

echo ""
echo "=== Test 5: Lister les 5 dernières activités ==="
curl -s "${API_BASE}/activities/recent?limit=5" | \
  jq -r '.activities[] | "  - " + .timestamp + " | " + .type + " | " + .title'

echo ""
echo "=== ✅ Tous les tests sont passés ==="
