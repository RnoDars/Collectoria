# Recommandation : Automatisation Variables NEXT_PUBLIC_* Build-Time

**Date** : 2026-05-04  
**Agent** : Amélioration Continue  
**Priorité** : HAUTE  
**Impact** : Prévention bugs configuration Frontend production

---

## Contexte

**Problème rencontré (session 2026-05-04)** :
- Frontend appelait `localhost:8080` au lieu de `https://api.darsling.fr` en production
- **Cause** : Variable `NEXT_PUBLIC_API_URL` définie uniquement en `environment`, pas en `build.args`
- **Diagnostic** : 1h perdue pour identifier la cause
- **Impact** : Frontend non fonctionnel en production

**Root cause** : Next.js injecte les variables `NEXT_PUBLIC_*` au moment du BUILD, pas au runtime. Définir ces variables uniquement dans `environment` est insuffisant.

---

## Règle Critique : Variables Next.js Build-Time

### Principe

**Les variables `NEXT_PUBLIC_*` DOIVENT être passées via `build.args` dans docker-compose, PAS uniquement via `environment`.**

### Pourquoi

Next.js effectue un remplacement statique des variables `NEXT_PUBLIC_*` au moment du build :
- Le code source `process.env.NEXT_PUBLIC_API_URL` est remplacé par la valeur littérale
- Une fois l'image Docker buildée, la valeur est figée dans le JavaScript compilé
- Définir la variable en runtime (via `environment`) n'a AUCUN effet

**Exemple** :
```typescript
// Code source
const API_URL = process.env.NEXT_PUBLIC_API_URL;

// Après build (si NEXT_PUBLIC_API_URL=https://api.darsling.fr au build)
const API_URL = "https://api.darsling.fr";

// Si variable définie APRÈS build → reste undefined
const API_URL = undefined;
```

---

## Solution : Configuration docker-compose

### Template Correct

**Fichier** : `docker-compose.prod.yml`

```yaml
frontend:
  build:
    context: ./frontend
    dockerfile: Dockerfile
    args:
      # ✅ CRITIQUE : Variables NEXT_PUBLIC_* passées au BUILD
      - NEXT_PUBLIC_API_URL=https://api.darsling.fr
  environment:
    # Variables runtime standard
    NODE_ENV: production
    NEXT_TELEMETRY_DISABLED: 1
    # ⚠️ Redondance OK pour cohérence, mais build.args est critique
    NEXT_PUBLIC_API_URL: https://api.darsling.fr
```

### Dockerfile Frontend

**Fichier** : `frontend/Dockerfile`

```dockerfile
FROM node:20-alpine AS builder

WORKDIR /app

# ✅ Déclarer ARG pour recevoir build.args
ARG NEXT_PUBLIC_API_URL
ENV NEXT_PUBLIC_API_URL=$NEXT_PUBLIC_API_URL

COPY package*.json ./
RUN npm ci

COPY . .

# Build avec variables injectées
RUN npm run build

FROM node:20-alpine AS runner
WORKDIR /app

ENV NODE_ENV=production
ENV NEXT_TELEMETRY_DISABLED=1

COPY --from=builder /app/.next ./.next
COPY --from=builder /app/public ./public
COPY --from=builder /app/package*.json ./
COPY --from=builder /app/node_modules ./node_modules

EXPOSE 3000

CMD ["npm", "start"]
```

---

## Procédure de Vérification

### 1. Vérification Avant Build

**Checklist** :
- [ ] Variable `NEXT_PUBLIC_*` présente dans `docker-compose.prod.yml` section `frontend.build.args`
- [ ] Variable `NEXT_PUBLIC_*` déclarée comme `ARG` dans `frontend/Dockerfile`
- [ ] Variable `ARG` convertie en `ENV` dans Dockerfile

### 2. Vérification Après Build

**Commande** : Inspecter l'image buildée
```bash
docker compose -f docker-compose.prod.yml build frontend
docker run --rm collectoria-frontend-prod env | grep NEXT_PUBLIC
```

**Résultat attendu** :
```
NEXT_PUBLIC_API_URL=https://api.darsling.fr
```

### 3. Vérification en Runtime

**Commande** : Vérifier variable dans container running
```bash
docker compose -f docker-compose.prod.yml up -d frontend
docker compose -f docker-compose.prod.yml exec frontend env | grep NEXT_PUBLIC
```

**Résultat attendu** :
```
NEXT_PUBLIC_API_URL=https://api.darsling.fr
```

### 4. Vérification dans le Code Compilé

**Commande** : Inspecter le JavaScript compilé
```bash
docker compose -f docker-compose.prod.yml exec frontend grep -r "api.darsling.fr" .next/
```

**Résultat attendu** : Plusieurs occurrences de `api.darsling.fr` dans les bundles JavaScript

---

## Script de Vérification Automatique

**Fichier** : `DevOps/scripts/verify-nextjs-build-args.sh`

```bash
#!/bin/bash
# Script de vérification des build args Next.js

set -e

COMPOSE_FILE="${COMPOSE_FILE:-docker-compose.prod.yml}"

echo "🔍 Vérification des build args Next.js..."

# 1. Vérifier présence dans docker-compose.yml
echo ""
echo "1️⃣  Vérification docker-compose.yml"
if grep -A 5 "frontend:" "$COMPOSE_FILE" | grep -q "NEXT_PUBLIC_API_URL"; then
  echo "✅ NEXT_PUBLIC_API_URL présent dans frontend.build.args"
else
  echo "❌ NEXT_PUBLIC_API_URL MANQUANT dans frontend.build.args"
  echo "   Ajouter dans $COMPOSE_FILE :"
  echo "   frontend:"
  echo "     build:"
  echo "       args:"
  echo "         - NEXT_PUBLIC_API_URL=https://api.darsling.fr"
  exit 1
fi

# 2. Vérifier présence dans Dockerfile
echo ""
echo "2️⃣  Vérification Dockerfile"
if grep -q "ARG NEXT_PUBLIC_API_URL" frontend/Dockerfile; then
  echo "✅ ARG NEXT_PUBLIC_API_URL présent dans Dockerfile"
else
  echo "❌ ARG NEXT_PUBLIC_API_URL MANQUANT dans Dockerfile"
  echo "   Ajouter dans frontend/Dockerfile :"
  echo "   ARG NEXT_PUBLIC_API_URL"
  echo "   ENV NEXT_PUBLIC_API_URL=\$NEXT_PUBLIC_API_URL"
  exit 1
fi

# 3. Tester build
echo ""
echo "3️⃣  Test build image"
docker compose -f "$COMPOSE_FILE" build --no-cache frontend > /tmp/nextjs-build.log 2>&1

if [ $? -eq 0 ]; then
  echo "✅ Build réussi"
else
  echo "❌ Build échoué, voir /tmp/nextjs-build.log"
  exit 1
fi

# 4. Vérifier variable dans image
echo ""
echo "4️⃣  Vérification variable dans image buildée"
ENV_VALUE=$(docker run --rm collectoria-frontend-prod env | grep NEXT_PUBLIC_API_URL || echo "")

if [ -n "$ENV_VALUE" ]; then
  echo "✅ Variable présente : $ENV_VALUE"
else
  echo "❌ Variable ABSENTE dans l'image buildée"
  exit 1
fi

echo ""
echo "✅ Toutes les vérifications passées !"
```

**Utilisation** :
```bash
bash DevOps/scripts/verify-nextjs-build-args.sh
```

---

## Intégration dans les Workflows

### 1. Workflow DevOps : Checklist Déploiement Production

**Fichier** : `Continuous-Improvement/recommendations/devops-production-deployment-checklist_2026-05-04.md`  
**Section** : "AVANT Déploiement - 5. Build Args Next.js"

**Ajout** :
- [ ] Exécuter `bash DevOps/scripts/verify-nextjs-build-args.sh`
- [ ] Vérifier script retourne OK

### 2. Workflow DevOps : Script de Diagnostic Production

**Fichier** : `DevOps/scripts/diagnose-production.sh`  
**Section** : "Vérifications Frontend"

**Ajout** :
```bash
# Vérifier variables NEXT_PUBLIC_* dans container
NEXT_PUBLIC_VARS=$(docker compose -f "$COMPOSE_FILE" exec frontend env | grep NEXT_PUBLIC || echo "")
if [ -n "$NEXT_PUBLIC_VARS" ]; then
  print_check "OK" "Variables NEXT_PUBLIC_* définies"
  echo "$NEXT_PUBLIC_VARS" | sed 's/^/    /'
else
  print_check "ERROR" "Variables NEXT_PUBLIC_* MANQUANTES"
fi
```

---

## Documentation dans DevOps/CLAUDE.md

### Nouvelle Règle Critique #11

**Titre** : "11. Variables Next.js Build-Time (NEXT_PUBLIC_*)"

**Contenu** :
```markdown
### 11. Variables Next.js Build-Time (NEXT_PUBLIC_*)

**Règle** : Les variables `NEXT_PUBLIC_*` DOIVENT être passées via `build.args` dans docker-compose, PAS uniquement via `environment`.

**Pourquoi** : Next.js injecte ces variables au moment du BUILD, pas au runtime.

**Comment** :
```yaml
frontend:
  build:
    context: ./frontend
    args:
      - NEXT_PUBLIC_API_URL=https://api.darsling.fr
```

**Vérification** :
```bash
bash DevOps/scripts/verify-nextjs-build-args.sh
```

**Référence** : Incident 2026-05-04 - Frontend appelait localhost:8080 en production
```

---

## Liste des Variables NEXT_PUBLIC_* Connues

| Variable | Valeur Production | Utilisé Pour |
|----------|-------------------|--------------|
| NEXT_PUBLIC_API_URL | https://api.darsling.fr | URL Backend API |

**Ajout futur** : Mettre à jour cette liste si nouvelles variables `NEXT_PUBLIC_*` ajoutées

---

## Impact Attendu

**Avant** (session 2026-05-04) :
- Variables mal configurées
- Frontend appelait localhost en production
- 1h de diagnostic

**Après** (avec cette recommandation) :
- Variables vérifiées automatiquement
- Configuration correcte garantie
- Détection immédiate si problème

**Gain** : Prévention totale de ce type de bug

---

## Prochaines Étapes

1. Créer script `verify-nextjs-build-args.sh`
2. Mettre à jour `DevOps/CLAUDE.md` (règle #11)
3. Intégrer vérification dans checklist déploiement
4. Intégrer vérification dans script diagnostic
5. Tester workflow complet en local

---

**Référence** : Session 2026-05-04 - Variables NEXT_PUBLIC_* non injectées au build-time
