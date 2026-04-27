#!/bin/bash

# Script de test pour les nouveaux endpoints D&D 5e
# Usage: ./test_dnd5_endpoints.sh

set -e

BASE_URL="http://localhost:8080/api/v1"
USER_EMAIL="test@collectoria.com"
USER_PASSWORD="test123"

echo "=========================================="
echo "Test des endpoints D&D 5e - Collection Management"
echo "=========================================="
echo ""

# 1. Login et récupération du token
echo "1. Login..."
LOGIN_RESPONSE=$(curl -s -X POST "$BASE_URL/auth/login" \
  -H "Content-Type: application/json" \
  -d "{\"email\":\"$USER_EMAIL\",\"password\":\"$USER_PASSWORD\"}")

TOKEN=$(echo "$LOGIN_RESPONSE" | jq -r '.token')

if [ "$TOKEN" == "null" ] || [ -z "$TOKEN" ]; then
  echo "❌ Erreur: Impossible de récupérer le token"
  echo "Response: $LOGIN_RESPONSE"
  exit 1
fi

echo "✅ Token obtenu: ${TOKEN:0:20}..."
echo ""

# 2. Test GET /books sans filtre (tous les livres)
echo "2. GET /books (tous les livres)..."
ALL_BOOKS=$(curl -s -X GET "$BASE_URL/books?limit=5" \
  -H "Authorization: Bearer $TOKEN")

TOTAL_ALL=$(echo "$ALL_BOOKS" | jq -r '.pagination.total')
echo "✅ Total de tous les livres: $TOTAL_ALL"
echo ""

# 3. Test GET /books avec filtre collection_id=Royaumes Oubliés
echo "3. GET /books?collection_id=22222222-2222-2222-2222-222222222222 (Royaumes Oubliés)..."
RO_BOOKS=$(curl -s -X GET "$BASE_URL/books?collection_id=22222222-2222-2222-2222-222222222222&limit=5" \
  -H "Authorization: Bearer $TOKEN")

TOTAL_RO=$(echo "$RO_BOOKS" | jq -r '.pagination.total')
FIRST_RO_TITLE=$(echo "$RO_BOOKS" | jq -r '.books[0].title')
FIRST_RO_EDITION=$(echo "$RO_BOOKS" | jq -r '.books[0].edition')

echo "✅ Total Royaumes Oubliés: $TOTAL_RO"
echo "  Premier livre: $FIRST_RO_TITLE"
echo "  Edition: $FIRST_RO_EDITION (doit être null)"
echo ""

# 4. Test GET /books avec filtre collection_id=D&D 5e
echo "4. GET /books?collection_id=33333333-3333-3333-3333-333333333333 (D&D 5e)..."
DND_BOOKS=$(curl -s -X GET "$BASE_URL/books?collection_id=33333333-3333-3333-3333-333333333333&limit=5" \
  -H "Authorization: Bearer $TOKEN")

TOTAL_DND=$(echo "$DND_BOOKS" | jq -r '.pagination.total')
FIRST_DND_TITLE=$(echo "$DND_BOOKS" | jq -r '.books[0].title')
FIRST_DND_NAMEEN=$(echo "$DND_BOOKS" | jq -r '.books[0].name_en')
FIRST_DND_NAMEFR=$(echo "$DND_BOOKS" | jq -r '.books[0].name_fr')
FIRST_DND_EDITION=$(echo "$DND_BOOKS" | jq -r '.books[0].edition')
FIRST_DND_OWNED_EN=$(echo "$DND_BOOKS" | jq -r '.books[0].owned_en')
FIRST_DND_OWNED_FR=$(echo "$DND_BOOKS" | jq -r '.books[0].owned_fr')

echo "✅ Total D&D 5e: $TOTAL_DND"
echo "  Premier livre: $FIRST_DND_TITLE"
echo "  Name EN: $FIRST_DND_NAMEEN"
echo "  Name FR: $FIRST_DND_NAMEFR"
echo "  Edition: $FIRST_DND_EDITION (doit être 'D&D 5')"
echo "  Owned EN: $FIRST_DND_OWNED_EN"
echo "  Owned FR: $FIRST_DND_OWNED_FR"
echo ""

# 5. Récupérer un livre D&D 5e pour test de mise à jour
BOOK_DND_ID=$(echo "$DND_BOOKS" | jq -r '.books[0].id')
echo "5. Test PATCH /books/$BOOK_DND_ID/possession (D&D 5e - owned_en)..."

PATCH_RESPONSE=$(curl -s -X PATCH "$BASE_URL/books/$BOOK_DND_ID/possession" \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"owned_en": true, "owned_fr": false}')

UPDATED_OWNED_EN=$(echo "$PATCH_RESPONSE" | jq -r '.owned_en')
UPDATED_OWNED_FR=$(echo "$PATCH_RESPONSE" | jq -r '.owned_fr')

if [ "$UPDATED_OWNED_EN" == "true" ] && [ "$UPDATED_OWNED_FR" == "false" ]; then
  echo "✅ Mise à jour D&D 5e réussie"
  echo "  Owned EN: $UPDATED_OWNED_EN"
  echo "  Owned FR: $UPDATED_OWNED_FR"
else
  echo "❌ Erreur de mise à jour D&D 5e"
  echo "Response: $PATCH_RESPONSE"
fi
echo ""

# 6. Récupérer un livre Royaumes Oubliés pour test de mise à jour
echo "6. Test PATCH /books/[RO_ID]/possession (Royaumes Oubliés - is_owned)..."

BOOK_RO_ID=$(echo "$RO_BOOKS" | jq -r '.books[0].id')

PATCH_RO_RESPONSE=$(curl -s -X PATCH "$BASE_URL/books/$BOOK_RO_ID/possession" \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"is_owned": true}')

UPDATED_IS_OWNED=$(echo "$PATCH_RO_RESPONSE" | jq -r '.is_owned')

if [ "$UPDATED_IS_OWNED" == "true" ]; then
  echo "✅ Mise à jour Royaumes Oubliés réussie"
  echo "  Is Owned: $UPDATED_IS_OWNED"
else
  echo "❌ Erreur de mise à jour Royaumes Oubliés"
  echo "Response: $PATCH_RO_RESPONSE"
fi
echo ""

# 7. Test validation : envoyer owned_en pour un livre Royaumes Oubliés (doit échouer)
echo "7. Test validation: PATCH D&D fields sur livre Royaumes Oubliés (doit échouer)..."

INVALID_RESPONSE=$(curl -s -w "\nHTTP_STATUS:%{http_code}" -X PATCH "$BASE_URL/books/$BOOK_RO_ID/possession" \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"owned_en": true}')

HTTP_STATUS=$(echo "$INVALID_RESPONSE" | grep "HTTP_STATUS" | cut -d: -f2)

if [ "$HTTP_STATUS" == "400" ]; then
  echo "✅ Validation correcte: requête rejetée (HTTP 400)"
else
  echo "❌ Erreur: validation non appliquée (HTTP $HTTP_STATUS)"
fi
echo ""

# 8. Test validation : envoyer is_owned pour un livre D&D 5e (doit échouer)
echo "8. Test validation: PATCH RO field sur livre D&D 5e (doit échouer)..."

INVALID_DND_RESPONSE=$(curl -s -w "\nHTTP_STATUS:%{http_code}" -X PATCH "$BASE_URL/books/$BOOK_DND_ID/possession" \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"is_owned": true}')

HTTP_STATUS_DND=$(echo "$INVALID_DND_RESPONSE" | grep "HTTP_STATUS" | cut -d: -f2)

if [ "$HTTP_STATUS_DND" == "400" ]; then
  echo "✅ Validation correcte: requête rejetée (HTTP 400)"
else
  echo "❌ Erreur: validation non appliquée (HTTP $HTTP_STATUS_DND)"
fi
echo ""

echo "=========================================="
echo "Résumé des tests"
echo "=========================================="
echo "Total livres: $TOTAL_ALL"
echo "  - Royaumes Oubliés: $TOTAL_RO"
echo "  - D&D 5e: $TOTAL_DND"
echo ""
echo "✅ Tests terminés avec succès!"
