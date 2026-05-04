# Recommandation : Gestion Extensions PostgreSQL en Production

**Date** : 2026-05-04  
**Agent** : Amélioration Continue  
**Priorité** : HAUTE  
**Impact** : Prévention bugs bloquants production

---

## Contexte

**Problème rencontré (session 2026-05-04)** :
- Page /cards retournait HTTP 500 "Internal Error" en production
- **Cause** : Extension PostgreSQL `unaccent` manquante en production
- **Diagnostic** : 1h perdue pour identifier la cause
- **Impact** : Bug bloquant en production, feature inutilisable

**Root cause** : Les extensions PostgreSQL ne sont pas installées automatiquement lors du déploiement. Les migrations SQL ne les créent pas systématiquement.

---

## Extensions PostgreSQL Requises

### Liste des Extensions Obligatoires

#### 1. unaccent
**Objectif** : Normalisation texte pour recherche (suppression accents)  
**Utilisé par** : Endpoint `GET /api/v1/cards` (filtre recherche texte)  
**Créé le** : 2026-05-04 (migration 009_add_card_search_index.sql)  
**Critique** : OUI — sans cette extension, la recherche cartes échoue

#### 2. pg_trgm (future)
**Objectif** : Recherche fuzzy, similarité texte  
**Utilisé par** : (prévu pour amélioration recherche)  
**Créé le** : À définir  
**Critique** : NON — pas encore utilisé

---

## Solution : Migration 000_extensions.sql

### Création du Fichier

**Fichier** : `backend/collection-management/migrations/000_extensions.sql`  
**Ordre** : DOIT être exécuté en PREMIER (avant toutes autres migrations)  
**Pourquoi** : Les autres migrations peuvent dépendre de ces extensions

**Contenu** :
```sql
-- Migration 000 : Installation des extensions PostgreSQL requises
-- Ordre : À exécuter en PREMIER

-- Extension unaccent : Normalisation texte pour recherche
-- Supprime les accents pour recherche insensible aux diacritiques
CREATE EXTENSION IF NOT EXISTS unaccent;

-- Extension pg_trgm : Recherche fuzzy et similarité texte
-- CREATE EXTENSION IF NOT EXISTS pg_trgm;  -- Décommenter si nécessaire

-- Vérification : Lister extensions installées
-- SELECT extname FROM pg_extension WHERE extname IN ('unaccent', 'pg_trgm');
```

### Intégration aux Migrations

#### Ordre d'Exécution

**Nouvelle machine / Nouvelle base** :
```bash
# 1. Extensions TOUJOURS en premier
docker compose exec postgres-collection psql -U $DB_USER -d $DB_NAME < backend/collection-management/migrations/000_extensions.sql

# 2. Puis schéma de base
docker compose exec postgres-collection psql -U $DB_USER -d $DB_NAME < backend/collection-management/migrations/001_init_schema.sql

# 3. Puis données et index
docker compose exec postgres-collection psql -U $DB_USER -d $DB_NAME < backend/collection-management/migrations/002_seed_meccg_cards.sql
# ...
```

#### Production (Base Existante)

**Si base déjà créée** : Exécuter uniquement la migration 000 :
```bash
docker compose -f docker-compose.prod.yml exec postgres-collection psql -U $DB_USER -d $DB_NAME -c "CREATE EXTENSION IF NOT EXISTS unaccent;"
```

---

## Script de Vérification Automatique

### Fichier : DevOps/scripts/verify-postgres-extensions.sh

**Objectif** : Vérifier que toutes les extensions requises sont installées

**Contenu** :
```bash
#!/bin/bash
# Script de vérification des extensions PostgreSQL requises

set -e

COMPOSE_FILE="${COMPOSE_FILE:-docker-compose.yml}"
DB_USER="${DB_USER:-collectoria}"
DB_NAME="${DB_NAME:-collection_management}"

echo "🔍 Vérification des extensions PostgreSQL..."

# Fonction de vérification d'une extension
check_extension() {
  local ext_name=$1
  local result=$(docker compose -f "$COMPOSE_FILE" exec -T postgres-collection psql -U "$DB_USER" -d "$DB_NAME" -t -c "SELECT extname FROM pg_extension WHERE extname = '$ext_name';")
  
  if [[ "$result" =~ "$ext_name" ]]; then
    echo "✅ Extension '$ext_name' installée"
    return 0
  else
    echo "❌ Extension '$ext_name' MANQUANTE"
    return 1
  fi
}

# Vérification de chaque extension requise
MISSING=0

check_extension "unaccent" || MISSING=$((MISSING + 1))
# check_extension "pg_trgm" || MISSING=$((MISSING + 1))  # Décommenter si requis

echo ""
if [ $MISSING -eq 0 ]; then
  echo "✅ Toutes les extensions requises sont installées."
  exit 0
else
  echo "❌ $MISSING extension(s) manquante(s)."
  echo ""
  echo "Pour installer les extensions manquantes :"
  echo "  docker compose -f $COMPOSE_FILE exec postgres-collection psql -U $DB_USER -d $DB_NAME < backend/collection-management/migrations/000_extensions.sql"
  exit 1
fi
```

**Utilisation** :
```bash
# Local
bash DevOps/scripts/verify-postgres-extensions.sh

# Production
COMPOSE_FILE=docker-compose.prod.yml bash DevOps/scripts/verify-postgres-extensions.sh
```

---

## Intégration dans les Workflows

### 1. Workflow DevOps : Initialisation Nouvelle Machine

**Fichier** : `DevOps/testing-local.md`  
**Section** : "Appliquer les migrations dans l'ordre"  
**Action** : Ajouter 000_extensions.sql EN PREMIER

**Avant** :
```bash
# 1. Schema
docker compose exec -T collectoria-collection-db psql -U collectoria -d collection_management < migrations/001_init_schema.sql
```

**Après** :
```bash
# 0. Extensions (TOUJOURS EN PREMIER)
docker compose exec -T collectoria-collection-db psql -U collectoria -d collection_management < migrations/000_extensions.sql

# 1. Schema
docker compose exec -T collectoria-collection-db psql -U collectoria -d collection_management < migrations/001_init_schema.sql
```

### 2. Workflow DevOps : Checklist Déploiement Production

**Fichier** : `Continuous-Improvement/recommendations/devops-production-deployment-checklist_2026-05-04.md`  
**Section** : "AVANT Déploiement"  
**Étape** : "4. Extensions PostgreSQL"

**Ajout** :
- [ ] Vérifier script `verify-postgres-extensions.sh` retourne OK
- [ ] Si KO, appliquer migration 000_extensions.sql AVANT déploiement

### 3. Workflow DevOps : Script de Diagnostic Production

**Fichier** : `DevOps/scripts/diagnose-production.sh`  
**Section** : "Vérifications PostgreSQL"  
**Action** : Appeler `verify-postgres-extensions.sh`

---

## Documentation dans DevOps/CLAUDE.md

### Section à Ajouter

**Titre** : "10. Extensions PostgreSQL Obligatoires"

**Contenu** :
```markdown
### 10. Extensions PostgreSQL Obligatoires

**Règle** : Les extensions PostgreSQL requises DOIVENT être installées via la migration `000_extensions.sql` AVANT toutes autres migrations.

**Extensions actuelles** :
- `unaccent` : Normalisation texte pour recherche (CRITIQUE)

**Vérification** :
```bash
bash DevOps/scripts/verify-postgres-extensions.sh
```

**Installation manuelle** :
```bash
docker compose exec postgres-collection psql -U $DB_USER -d $DB_NAME -c "CREATE EXTENSION IF NOT EXISTS unaccent;"
```

**Ordre migrations** :
```
000_extensions.sql  ← TOUJOURS EN PREMIER
001_init_schema.sql
002_seed_meccg_cards.sql
...
```

**Référence** : Incident 2026-05-04 - Extension unaccent manquante causant HTTP 500
```

---

## Procédure d'Ajout d'une Nouvelle Extension

**Checklist** :
1. [ ] Ajouter `CREATE EXTENSION IF NOT EXISTS [nom];` dans `000_extensions.sql`
2. [ ] Ajouter vérification dans `DevOps/scripts/verify-postgres-extensions.sh`
3. [ ] Mettre à jour liste extensions dans cette recommandation
4. [ ] Mettre à jour section DevOps/CLAUDE.md #10
5. [ ] Tester en local : `bash DevOps/scripts/verify-postgres-extensions.sh`
6. [ ] Appliquer en production : migration 000_extensions.sql

---

## Impact Attendu

**Avant** (session 2026-05-04) :
- Extension manquante détectée en production
- 1h de diagnostic
- Bug bloquant

**Après** (avec cette recommandation) :
- Extensions vérifiées automatiquement
- Détection immédiate si manquante
- Prévention bugs production

**Gain** : Prévention totale de ce type de bug

---

## Prochaines Étapes

1. Créer fichier `000_extensions.sql`
2. Créer script `verify-postgres-extensions.sh`
3. Mettre à jour `DevOps/testing-local.md`
4. Mettre à jour `DevOps/CLAUDE.md` (section #10)
5. Tester workflow complet en local
6. Appliquer en production

---

**Référence** : Session 2026-05-04 - Extension PostgreSQL unaccent manquante en production
