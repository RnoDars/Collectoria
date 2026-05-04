# Recommandation : Variables NEXT_PUBLIC_* Doivent Être Passées au Build-Time

**Date** : 2026-05-04  
**Agent** : Amélioration Continue  
**Priorité** : Haute  
**Effort** : Faible  
**ROI** : Élevé

---

## Problème Identifié

### Incident Production (2026-05-04)

Après déploiement des correctifs du 30 avril, le frontend en production appelait `http://localhost:8080` au lieu de `https://api.darsling.fr` pour se connecter au backend.

**Symptôme** :
- Utilisateur clique sur "Se connecter" → Erreur de connexion
- Console navigateur : `Failed to fetch` sur `http://localhost:8080/api/v1/auth/login`

**Cause racine** :
Les variables `NEXT_PUBLIC_*` en Next.js sont injectées dans le code JavaScript **au moment du BUILD**, pas au runtime. Le fichier `docker-compose.prod.yml` définissait la variable en `environment:` (runtime) mais pas en `build.args:` (build-time).

**Résultat** :
Le build Next.js ne voyait pas la variable → utilisait la valeur par défaut du `.env.development` local → `http://localhost:8080` était hardcodé dans le bundle JavaScript.

**Temps perdu** : 45 minutes (diagnostic + correction + rebuild + test)

---

## Analyse Technique

### Comportement Next.js : NEXT_PUBLIC_* Variables

Next.js a un comportement particulier pour les variables préfixées par `NEXT_PUBLIC_*` :

**1. Injection au Build-Time**
```javascript
// Dans le code React
const apiUrl = process.env.NEXT_PUBLIC_API_URL;
// ↓ (après build Next.js)
const apiUrl = "https://api.darsling.fr"; // VALEUR INJECTÉE DIRECTEMENT
```

**2. Variables Non-Public**
```javascript
// Variables serveur (pas NEXT_PUBLIC_*)
const secret = process.env.SECRET_KEY;
// ↓ (après build, côté serveur uniquement)
const secret = process.env.SECRET_KEY; // LECTURE DYNAMIQUE AU RUNTIME
```

**Conséquence critique** :
- Variables normales → disponibles au runtime (serveur Next.js)
- Variables `NEXT_PUBLIC_*` → injectées dans le bundle au **moment du `npm run build`**

### Dockerfile Multi-Stage : Moment du Build

Le `frontend/Dockerfile` utilise un build multi-stage :

```dockerfile
# Stage 1: dependencies
FROM node:20-alpine AS dependencies
# ...

# Stage 2: builder (BUILD HAPPENS HERE!)
FROM node:20-alpine AS builder
COPY --from=dependencies /app/node_modules ./node_modules
COPY . .
ARG NEXT_PUBLIC_API_URL  # ← DOIT ÊTRE ICI
ENV NEXT_PUBLIC_API_URL=${NEXT_PUBLIC_API_URL}  # ← ET ICI
RUN npm run build  # ← NEXT.JS BUILD : injection des NEXT_PUBLIC_*

# Stage 3: runner (RUNTIME)
FROM node:20-alpine AS runner
COPY --from=builder /app/.next/standalone ./
# Les NEXT_PUBLIC_* sont DÉJÀ dans le bundle .next
```

**Point critique** : La variable doit être définie **dans le stage builder**, avant `npm run build`.

### Docker Compose : Build Args vs Environment

```yaml
# ❌ INCORRECT (ce qui causait le bug)
frontend:
  build:
    context: ./frontend
  environment:
    NEXT_PUBLIC_API_URL: https://api.darsling.fr  # Runtime seulement!

# ✅ CORRECT (correctif appliqué)
frontend:
  build:
    context: ./frontend
    args:  # ← Passé au DOCKERFILE pendant le build
      - NEXT_PUBLIC_API_URL=https://api.darsling.fr
  environment:
    NEXT_PUBLIC_API_URL: https://api.darsling.fr  # Optionnel, pour SSR
```

**Différence** :
- `environment:` → disponible au **runtime** (quand le container tourne)
- `build.args:` → disponible au **build-time** (quand `docker build` exécute `RUN npm run build`)

---

## Solution Implémentée

### Correctif Appliqué (Commit 61bccfc)

**Fichier 1** : `frontend/Dockerfile`
```dockerfile
# Builder stage
FROM node:20-alpine AS builder

WORKDIR /app
COPY --from=dependencies /app/node_modules ./node_modules
COPY . .

ENV NODE_ENV=production
ENV NEXT_TELEMETRY_DISABLED=1

# Pass NEXT_PUBLIC_API_URL build arg
ARG NEXT_PUBLIC_API_URL  # ← NOUVEAU
ENV NEXT_PUBLIC_API_URL=${NEXT_PUBLIC_API_URL}  # ← NOUVEAU

RUN npm run build
```

**Fichier 2** : `docker-compose.prod.yml`
```yaml
frontend:
  build:
    context: ./frontend
    dockerfile: Dockerfile
    args:  # ← NOUVEAU
      - NEXT_PUBLIC_API_URL=https://api.darsling.fr
  environment:
    NODE_ENV: production
    NEXT_TELEMETRY_DISABLED: 1
    NEXT_PUBLIC_API_URL: https://api.darsling.fr  # Garde pour SSR
```

**Résultat** : Frontend en production appelle désormais correctement `https://api.darsling.fr`.

---

## Recommandation Procédurale

### Règle à Ajouter : DevOps/CLAUDE.md

Ajouter une nouvelle règle dans la section des "Bonnes Pratiques Docker" :

```markdown
### N. Variables NEXT_PUBLIC_* en Next.js : Build Args Obligatoires

**Règle** : Toute variable d'environnement préfixée `NEXT_PUBLIC_*` en Next.js DOIT être passée via `build.args:` dans `docker-compose.yml`.

**Pourquoi** :
- Next.js injecte ces variables directement dans le bundle JavaScript au moment du **build**
- Les passer uniquement en `environment:` ne fonctionne pas : le build utilise la valeur par défaut locale
- Résultat : API appelée avec mauvaise URL (souvent `http://localhost:...`)

**Comment** :

1. **Dockerfile** : Déclarer ARG + ENV avant `npm run build`
```dockerfile
FROM node:20-alpine AS builder
WORKDIR /app
COPY . .

ARG NEXT_PUBLIC_API_URL
ENV NEXT_PUBLIC_API_URL=${NEXT_PUBLIC_API_URL}

RUN npm run build  # ← Variables NEXT_PUBLIC_* injectées ici
```

2. **docker-compose.yml** : Passer via `build.args:`
```yaml
frontend:
  build:
    context: ./frontend
    args:
      - NEXT_PUBLIC_API_URL=${NEXT_PUBLIC_API_URL}  # Depuis .env
  environment:
    NEXT_PUBLIC_API_URL: ${NEXT_PUBLIC_API_URL}  # Optionnel pour SSR
```

3. **Fichier .env** : Définir la valeur
```bash
# .env (sur serveur production)
NEXT_PUBLIC_API_URL=https://api.darsling.fr
```

**Validation** :
```bash
# Vérifier que la variable est bien injectée dans le bundle
docker compose exec frontend sh
cat .next/standalone/.env  # Ne contient PAS les NEXT_PUBLIC_*
grep -r "NEXT_PUBLIC_API_URL" .next/static/chunks/*.js  # Doit afficher l'URL
```

**Référence** : Incident production 2026-05-04 — Frontend appelait localhost au lieu de api.darsling.fr
```

---

### Règle à Ajouter : Frontend/CLAUDE.md

Ajouter une note dans la section "Déploiement Docker" :

```markdown
### ⚠️ Variables d'Environnement Publiques (NEXT_PUBLIC_*)

**Règle critique** : Toute variable préfixée `NEXT_PUBLIC_*` est injectée dans le bundle au **build-time**, pas au runtime.

**Conséquence** :
- Ces variables doivent être passées via `ARG` dans le Dockerfile
- Et via `build.args:` dans docker-compose.yml
- Passer uniquement via `environment:` ne suffit PAS

**Exemple** :
```dockerfile
# Dockerfile
ARG NEXT_PUBLIC_API_URL
ENV NEXT_PUBLIC_API_URL=${NEXT_PUBLIC_API_URL}
RUN npm run build  # Variable injectée ici
```

```yaml
# docker-compose.yml
build:
  args:
    - NEXT_PUBLIC_API_URL=https://api.darsling.fr
```

**Pourquoi** : Next.js remplace `process.env.NEXT_PUBLIC_*` par la valeur littérale dans le code JavaScript au moment du build.

**Référence** : DevOps/CLAUDE.md — Règle Variables NEXT_PUBLIC_*
```

---

## Checklist Déploiement Frontend

Ajouter à `DevOps/checklists/frontend-deployment.md` (ou créer si inexistant) :

```markdown
## Checklist Déploiement Frontend Next.js

### Avant le Build

- [ ] Toutes les variables `NEXT_PUBLIC_*` sont définies dans `.env` (production)
- [ ] `docker-compose.prod.yml` passe ces variables via `build.args:`
- [ ] `frontend/Dockerfile` déclare les `ARG` correspondants avant `npm run build`

### Après le Build

- [ ] Vérifier le bundle contient les bonnes valeurs :
  ```bash
  docker compose exec frontend sh
  grep -r "api\.darsling\.fr" .next/static/chunks/*.js
  ```

### En Cas d'Erreur "localhost:8080" en Production

**Symptôme** : Frontend appelle `http://localhost:8080` au lieu de `https://api.darsling.fr`

**Cause probable** : `NEXT_PUBLIC_API_URL` non passée via `build.args:`

**Diagnostic** :
```bash
# Vérifier la valeur dans le bundle
docker compose exec frontend sh
grep -r "NEXT_PUBLIC_API_URL\|localhost:8080" .next/static/chunks/*.js
```

**Correction** :
1. Ajouter `build.args:` dans docker-compose.yml
2. Ajouter `ARG` + `ENV` dans Dockerfile (stage builder)
3. Rebuild complet : `docker compose build --no-cache frontend`
4. Redémarrer : `docker compose up -d frontend`
```

---

## Plan d'Action

### Étape 1 : Mise à Jour Documentation (Agent DevOps)

1. **DevOps/CLAUDE.md** :
   - Ajouter règle "Variables NEXT_PUBLIC_* : Build Args Obligatoires"
   - Inclure exemples Dockerfile + docker-compose.yml
   - Référencer l'incident 2026-05-04

2. **Frontend/CLAUDE.md** :
   - Ajouter note dans section "Déploiement Docker"
   - Expliquer le comportement build-time vs runtime

### Étape 2 : Création Checklist (Agent DevOps)

Créer `DevOps/checklists/frontend-deployment.md` avec :
- Checklist variables NEXT_PUBLIC_*
- Procédure de validation post-build
- Diagnostic erreur "localhost" en production

### Étape 3 : Validation Template Dockerfile (Agent Frontend)

Vérifier que le template de base `frontend/Dockerfile` inclut bien :
```dockerfile
ARG NEXT_PUBLIC_API_URL
ENV NEXT_PUBLIC_API_URL=${NEXT_PUBLIC_API_URL}
```

---

## Agents Impactés

- **Agent DevOps** : Documentation, procédures déploiement, checklists
- **Agent Frontend** : Template Dockerfile, compréhension build Next.js
- **Alfred** : Workflow déploiement frontend, détection erreur "localhost" en production

---

## Bénéfices Attendus

### Avant (Situation qui a causé le bug)

```yaml
# docker-compose.prod.yml
frontend:
  build:
    context: ./frontend
  environment:  # ❌ Variables NEXT_PUBLIC_* ignorées au build
    NEXT_PUBLIC_API_URL: https://api.darsling.fr

# Résultat : Bundle contient http://localhost:8080
```

### Après (Correctif appliqué)

```yaml
# docker-compose.prod.yml
frontend:
  build:
    context: ./frontend
    args:  # ✅ Variables injectées au build
      - NEXT_PUBLIC_API_URL=https://api.darsling.fr
  environment:
    NEXT_PUBLIC_API_URL: https://api.darsling.fr

# Résultat : Bundle contient https://api.darsling.fr
```

### Gains

- **Fiabilité** : Frontend appelle toujours la bonne URL en production
- **Diagnostic** : Checklist permet de détecter rapidement ce type d'erreur
- **Prévention** : Documentation claire évite la répétition du bug
- **Temps** : Évite 45 minutes de debug par incident

---

## Validation

### Critères de Succès

1. ✅ DevOps/CLAUDE.md contient règle "Variables NEXT_PUBLIC_*"
2. ✅ Frontend/CLAUDE.md contient note build-time vs runtime
3. ✅ Checklist `DevOps/checklists/frontend-deployment.md` créée
4. ✅ Template Dockerfile frontend inclut ARG/ENV pour NEXT_PUBLIC_API_URL

### Test de Non-Régression

```bash
# Vérifier que le correctif est bien présent
grep -A5 "ARG NEXT_PUBLIC_API_URL" frontend/Dockerfile
grep -A5 "build:" docker-compose.prod.yml | grep -A3 "args:"

# Tester en production (après prochain déploiement)
curl -s https://darsling.fr | grep -o "api\.darsling\.fr"  # Doit trouver l'URL
```

---

## Références

- **Incident** : Session 2026-05-04 — Frontend production appelait localhost
- **Commit correctif** : `61bccfc` — fix(frontend): pass NEXT_PUBLIC_API_URL as build arg
- **Temps perdu** : 45 minutes (diagnostic + correction + rebuild)
- **Documentation Next.js** : https://nextjs.org/docs/pages/building-your-application/configuring/environment-variables#bundling-environment-variables-for-the-browser
- **Documentation Docker Compose** : https://docs.docker.com/compose/compose-file/build/#args

---

**Statut** : Correctif Appliqué, Documentation À Mettre À Jour  
**Responsables** : Agent DevOps (documentation), Agent Frontend (template)  
**Deadline** : Avant prochain déploiement frontend
