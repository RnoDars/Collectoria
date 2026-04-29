# Recommandation : Convention Fichier .env Production

**Date** : 2026-04-29  
**Agent** : Amélioration Continue  
**Priorité** : Moyenne  
**Effort** : Faible  
**ROI** : Moyen

---

## Problème Identifié

### Incident Phase 4

Lors du déploiement, Docker Compose ne chargeait pas automatiquement les variables d'environnement :
- Fichier créé : `.env.production`
- Fichier attendu par Docker Compose : `.env`

**Conséquence** :
- Toutes les commandes docker compose nécessitaient `--env-file .env.production`
- Oubli du flag → variables non chargées → comportement imprévisible
- Complexité ajoutée à chaque commande

**Temps perdu** : 15 minutes (multiples redémarrages pour comprendre le problème)

---

## Analyse

### Comportement Docker Compose

Docker Compose charge automatiquement un fichier `.env` à la racine du projet (même répertoire que docker-compose.yml) **SI et SEULEMENT SI** il est nommé exactement `.env`.

Tout autre nom (`.env.production`, `.env.prod`, `.env.server`) nécessite le flag `--env-file` explicite.

### Convention Standard de l'Industrie

**Approche A : Un seul fichier .env par environnement**
```
# Local (dev)
.env  (chargé automatiquement)

# Production (sur serveur)
.env  (chargé automatiquement)
```

**Approche B : Multiples fichiers avec sélection**
```
# Local (dev)
.env.development
docker compose --env-file .env.development up

# Production
.env.production
docker compose --env-file .env.production up
```

**Approche C : Fichiers multiples + .env par défaut**
```
# Local (dev)
.env  (pointe vers .env.development ou contient directement les valeurs)

# Production
.env  (pointe vers .env.production ou contient directement les valeurs)
```

---

## Solutions Proposées

### Option 1 : Renommer en .env (RECOMMANDÉ)

**Description** :
- En production, utiliser simplement `.env` (pas `.env.production`)
- En développement local, utiliser `.env` également
- Pas de flag `--env-file` nécessaire

**Avantages** :
- ✅ Convention standard Docker Compose
- ✅ Commandes plus simples (pas de flag)
- ✅ Moins d'erreurs (chargement automatique)
- ✅ Documentation plus claire

**Inconvénients** :
- ⚠️ Risque de commit du .env production (mais `.env` déjà dans `.gitignore`)
- ⚠️ Pas de distinction visuelle dev/prod dans le nom

**Implémentation** :
```bash
# Sur serveur production
mv .env.production .env

# Commandes simplifiées
docker compose up -d
docker compose ps
docker compose logs backend
```

---

### Option 2 : Script Wrapper deploy.sh

**Description** :
- Garder `.env.production`
- Créer un script `deploy.sh` qui wrappe les commandes docker compose

**Avantages** :
- ✅ Distinction visuelle dev/prod
- ✅ Commandes simplifiées une fois le script créé
- ✅ Possibilité d'ajouter d'autres logiques (backup, validation, etc.)

**Inconvénients** :
- ⚠️ Complexité ajoutée (un fichier de plus)
- ⚠️ Nécessite de maintenir le script
- ⚠️ Commandes docker compose natives ne fonctionnent plus directement

**Implémentation** :
```bash
#!/bin/bash
# deploy.sh - Wrapper pour docker compose en production

set -e

ENV_FILE=".env.production"
COMPOSE_FILE="docker-compose.prod.yml"

# Toutes les commandes passent le flag --env-file
docker compose -f $COMPOSE_FILE --env-file $ENV_FILE "$@"
```

**Usage** :
```bash
./deploy.sh up -d
./deploy.sh ps
./deploy.sh logs backend
```

---

### Option 3 : Variable d'environnement COMPOSE_FILE

**Description** :
- Définir `COMPOSE_ENV_FILES` dans le shell
- Docker Compose charge automatiquement

**Avantages** :
- ✅ Distinction visuelle dev/prod
- ✅ Pas de flag dans chaque commande

**Inconvénients** :
- ⚠️ Variable doit être exportée dans chaque session
- ⚠️ Peut être oubliée → erreurs silencieuses
- ⚠️ Moins standard

**Implémentation** :
```bash
# Dans ~/.bashrc ou session SSH
export COMPOSE_ENV_FILES=.env.production

# Commandes normales
docker compose up -d
```

---

## Recommandation Finale

### Choix : Option 1 (Renommer en .env)

**Justification** :
1. **Simplicité** : Convention standard, pas de complexité ajoutée
2. **Ergonomie** : Commandes docker compose natives fonctionnent directement
3. **Moins d'erreurs** : Chargement automatique, pas d'oubli de flag
4. **Documentation** : Toutes les documentations Docker Compose utilisent `.env`

**Risque** : Confusion dev/prod si les deux utilisent `.env`
**Mitigation** : 
- En local, `.env` est dans `.gitignore` (jamais commité)
- En production, `.env` est créé manuellement sur le serveur
- Distinction claire par le fait que chaque environnement a son propre serveur/machine

---

## Plan d'Action

### Étape 1 : Mise à Jour Documentation DevOps

**Fichier** : `DevOps/CLAUDE.md`

**Ajout Règle 8** :
```markdown
### 8. Convention Fichier .env Production

**Règle** : En production, utiliser `.env` (pas `.env.production`)

**Pourquoi** :
- Docker Compose charge automatiquement `.env`
- Simplifie toutes les commandes (pas de `--env-file` nécessaire)
- Convention standard de l'industrie

**Implémentation** :
```bash
# Sur serveur production
cat > .env << EOF
# Variables d'environnement production
POSTGRES_USER=collectoria_prod
POSTGRES_PASSWORD=xxx
...
EOF

# Commandes simplifiées
docker compose up -d
docker compose ps
```

**Alternative** : Si distinction visuelle dev/prod nécessaire, utiliser un script wrapper `deploy.sh`

**Référence** : Incident Phase 4 (2026-04-29) - Confusion .env.production
```

---

### Étape 2 : Template .env Production

**Fichier** : `DevOps/templates/.env.production.template`

```bash
# Template .env Production - Collectoria
# À renommer en .env sur le serveur de production

# PostgreSQL
POSTGRES_USER=collectoria_prod
POSTGRES_PASSWORD=<GÉNÉRER_MOT_DE_PASSE_SÉCURISÉ>
POSTGRES_DB=collection_management

# Backend
DB_HOST=postgres
DB_PORT=5432
DB_USER=collectoria_prod
DB_PASSWORD=<MÊME_MOT_DE_PASSE>
DB_NAME=collection_management
SERVER_PORT=8080
JWT_SECRET=<GÉNÉRER_SECRET_64_CARACTÈRES>
JWT_EXPIRATION_HOURS=24
JWT_ISSUER=collectoria-api
LOG_LEVEL=info

# Frontend
NEXT_PUBLIC_API_URL=https://api.collectoria.fr
NODE_ENV=production

# Traefik
DOMAIN=collectoria.fr
ACME_EMAIL=admin@collectoria.fr
```

**Instructions** :
```markdown
## Utilisation

1. Copier ce template sur le serveur :
   ```bash
   scp DevOps/templates/.env.production.template user@server:/opt/collectoria/.env.tmp
   ```

2. Éditer les valeurs sur le serveur :
   ```bash
   nano /opt/collectoria/.env.tmp
   # Remplacer tous les <PLACEHOLDER>
   ```

3. Renommer en .env :
   ```bash
   mv /opt/collectoria/.env.tmp /opt/collectoria/.env
   ```

4. Vérifier permissions :
   ```bash
   chmod 600 /opt/collectoria/.env
   ls -la /opt/collectoria/.env
   ```
```

---

### Étape 3 : Mise à Jour Procédures Phase 4

**Fichier** : `DevOps/phase4-*.md` (ou documentation déploiement)

**Avant** :
```bash
docker compose --env-file .env.production up -d
docker compose --env-file .env.production ps
```

**Après** :
```bash
# .env déjà créé à l'étape précédente
docker compose up -d
docker compose ps
```

---

### Étape 4 : Serveur Production (Si Déjà Déployé)

**Action** : Renommer le fichier existant
```bash
# Se connecter au serveur
ssh user@server

# Aller dans le répertoire du projet
cd /opt/collectoria

# Renommer
mv .env.production .env

# Redémarrer (sans flag)
docker compose down
docker compose up -d

# Vérifier
docker compose ps
```

---

## Agents Impactés

- **Agent DevOps** : Mise à jour documentation, templates, procédures
- **Alfred** : Workflow déploiement simplifié

---

## Bénéfices Attendus

### Avant (Situation Actuelle)
```bash
# Chaque commande nécessite --env-file
docker compose --env-file .env.production up -d
docker compose --env-file .env.production ps
docker compose --env-file .env.production logs backend
docker compose --env-file .env.production exec backend sh
```

### Après (Avec Recommandation)
```bash
# Commandes standard Docker Compose
docker compose up -d
docker compose ps
docker compose logs backend
docker compose exec backend sh
```

### Gains
- **Simplicité** : -50% de caractères par commande
- **Ergonomie** : Commandes standard (copier-coller doc officielle)
- **Erreurs** : Moins de risque d'oubli du flag
- **Temps** : -1 minute par session (15 min/an cumulé)

---

## Alternative : Script Wrapper

Si l'équipe préfère garder `.env.production` pour distinction visuelle, créer `DevOps/scripts/deploy.sh` :

```bash
#!/bin/bash
# deploy.sh - Wrapper docker compose production

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

cd "$PROJECT_ROOT"

ENV_FILE=".env.production"
COMPOSE_FILE="docker-compose.prod.yml"

if [ ! -f "$ENV_FILE" ]; then
  echo "❌ Erreur : $ENV_FILE introuvable"
  exit 1
fi

docker compose -f "$COMPOSE_FILE" --env-file "$ENV_FILE" "$@"
```

**Usage** :
```bash
./deploy.sh up -d
./deploy.sh ps
./deploy.sh logs backend
```

---

## Validation

### Critères de Succès
1. ✅ DevOps/CLAUDE.md contient règle 8
2. ✅ Template `.env.production.template` créé
3. ✅ Procédures Phase 4 mises à jour
4. ✅ Serveur production utilise `.env` (si applicable)

### Test
```bash
# Sur serveur production
cd /opt/collectoria
ls -la .env  # Fichier doit exister
docker compose ps  # Doit fonctionner SANS --env-file
docker compose config  # Affiche la config avec variables chargées
```

---

## Références

- **Incident** : Session Phase 4 (2026-04-29)
- **Rapport** : `Continuous-Improvement/reports/2026-04-29_phase4-deployment-issues.md`
- **Temps perdu** : 15 minutes
- **Documentation Docker Compose** : https://docs.docker.com/compose/environment-variables/set-environment-variables/

---

**Statut** : À Implémenter  
**Responsable** : Agent DevOps  
**Deadline** : Avant prochaine Phase 4
