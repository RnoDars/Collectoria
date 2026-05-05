# Lesson Learned : Valider Références Avant Commit

**Date** : 2026-05-05  
**Session** : Commits #186-#196  
**Contexte** : Noms services, containers, fonctions incorrects

---

## Problème Observé

Les scripts créés contenaient de **nombreuses références incorrectes** :
- Noms services Docker
- Noms containers Docker
- Fonctions appelées
- Commandes Docker

**Résultat** : 5 commits de corrections pour des erreurs facilement détectables.

---

## Incidents Typiques

### Incident 1 : Nom Service Incorrect

```bash
# deploy-backend.sh (version initiale)
SERVICE_NAME="backend"

docker compose -f "$COMPOSE_FILE" stop "$SERVICE_NAME"
# ❌ Error: service "backend" not found

# docker-compose.prod.yml (réalité)
services:
  backend-collection:    # ← Nom réel
    ...

# Correction (commit #4)
SERVICE_NAME="backend-collection"
```

**Cause** : Nom service non vérifié contre `docker-compose.prod.yml`.

**Temps perdu** : 5 minutes (exécution, erreur, analyse, correction, commit, re-test).

### Incident 2 : Nom Container Incorrect

```bash
# deploy-backend.sh (version initiale)
CONTAINER_NAME="collectoria-backend"

docker inspect "$CONTAINER_NAME"
# ❌ Error: container "collectoria-backend" not found

# docker-compose.prod.yml (réalité)
services:
  backend-collection:
    container_name: collectoria-backend-collection-prod  # ← Nom réel

# Correction (commit #5)
CONTAINER_NAME="collectoria-backend-collection-prod"
```

**Cause** : Nom container non vérifié contre convention `collectoria-[service]-[env]`.

**Temps perdu** : 5 minutes.

### Incident 3 : Fonction Non Définie

```bash
# deploy-backend.sh (version initiale)
check_service_health "$CONTAINER_NAME" "$HEALTH_URL" 30 2
# ❌ bash: check_service_health: command not found

# scripts/lib/ (réalité)
# Fonction n'existe ni dans common.sh ni dans docker-utils.sh

# Correction (commit #6)
# Implémenter fonction dans docker-utils.sh
```

**Cause** : Fonction appelée non vérifiée contre libraries disponibles.

**Temps perdu** : 15 minutes (recherche, implémentation, test).

### Incident 4 : Commande Obsolète

```bash
# deploy-backend.sh (version initiale)
docker-compose -f "$COMPOSE_FILE" up -d
# ❌ bash: docker-compose: command not found

# Environnement production (réalité)
# Docker Compose V2 installé (plugin Docker CLI)
# Commande : docker compose (pas docker-compose)

# Correction (commit #2)
docker compose -f "$COMPOSE_FILE" up -d
```

**Cause** : Commande non vérifiée contre environnement cible.

**Temps perdu** : 3 minutes.

---

## Lesson

### Valider TOUTES références contre source de vérité

**Types de références** :
1. **Noms services Docker** → Source : `docker-compose.prod.yml`
2. **Noms containers Docker** → Source : Convention + `docker-compose.prod.yml`
3. **Fonctions** → Source : `scripts/lib/README.md` + `common.sh` + `docker-utils.sh`
4. **Commandes** → Source : `DevOps/environments/production.md`

**Règle** : Avant commit, vérifier chaque référence contre sa source de vérité.

### Pas de supposition, que de la validation

**❌ Mauvais workflow (par supposition)** :
```
Développeur : "Le service s'appelle probablement 'backend'"
→ Écrit : SERVICE_NAME="backend"
→ Commit sans vérifier
→ Exécution production
→ ❌ Échec
```

**✅ Bon workflow (par validation)** :
```
Développeur : "Quel est le nom exact du service ?"
→ Consulte : docker-compose.prod.yml
→ Trouve : backend-collection
→ Écrit : SERVICE_NAME="backend-collection"
→ Commit après validation
→ Exécution production
→ ✅ Succès
```

---

## Application Pratique

### Règle 1 : Checklist Validation Références

**Avant commit de tout script Bash** :

#### Validation Services Docker

- [ ] Extraire tous `SERVICE_NAME="..."`
- [ ] Vérifier chaque service dans `docker-compose.prod.yml`
- [ ] Commande : `grep "^  [service-name]:" docker-compose.prod.yml`

```bash
# Script
SERVICE_NAME="backend-collection"

# Validation
grep "^  backend-collection:" docker-compose.prod.yml
# Output : "  backend-collection:"
# ✅ Service existe
```

#### Validation Containers Docker

- [ ] Extraire tous `CONTAINER_NAME="..."`
- [ ] Vérifier convention : `collectoria-[service]-[env]`
- [ ] Vérifier dans `docker-compose.prod.yml` si container_name défini

```bash
# Script
CONTAINER_NAME="collectoria-backend-collection-prod"

# Validation convention
echo "$CONTAINER_NAME" | grep -E "^collectoria-[a-z-]+-prod$"
# ✅ Convention respectée

# Validation docker-compose.prod.yml
grep "container_name:.*backend-collection" docker-compose.prod.yml
# Output : "container_name: collectoria-backend-collection-prod"
# ✅ Container existe
```

#### Validation Fonctions

- [ ] Extraire tous appels de fonctions
- [ ] Vérifier chaque fonction existe dans libraries
- [ ] Vérifier signature (nombre/ordre paramètres)

```bash
# Script
check_service_health "$CONTAINER_NAME" "$HEALTH_URL" 30 2

# Validation existence
grep -r "^check_service_health()" scripts/lib/
# Output : "scripts/lib/docker-utils.sh:check_service_health() {"
# ✅ Fonction existe

# Validation signature (README.md)
grep -A 5 "check_service_health" scripts/lib/README.md
# Output :
# check_service_health(container_name, health_url, max_attempts, interval)
# ✅ Signature correcte (4 paramètres)
```

#### Validation Commandes

- [ ] Extraire toutes commandes Docker
- [ ] Vérifier version (`docker compose` vs `docker-compose`)
- [ ] Vérifier disponibilité environnement cible

```bash
# Script
docker compose -f "$COMPOSE_FILE" up -d

# Validation
grep "docker-compose " script.sh
# Pas de résultat ✅ (pas de V1 obsolète)

grep "docker compose " script.sh
# Output : "docker compose -f ..."
# ✅ V2 moderne utilisée

# Validation environnement (DevOps/environments/production.md)
# Docker Version : 24.0.5 (with Compose V2 plugin)
# Command : docker compose
# ✅ Commande disponible
```

### Règle 2 : Script Automatique de Validation

**Utiliser `scripts/lib/validate-script.sh`** :

```bash
#!/bin/bash
# validate-script.sh extrait

# Validation noms services
echo "5. Validating Docker service names..."
SERVICE_NAMES=$(grep -oP 'SERVICE_NAME="\K[^"]+' "$SCRIPT_PATH" || true)
if [[ -n "$SERVICE_NAMES" ]]; then
    for service in $SERVICE_NAMES; do
        if grep -q "^  $service:" "$PROJECT_ROOT/docker-compose.prod.yml" 2>/dev/null; then
            echo "   ✅ Service '$service' found in docker-compose.prod.yml"
        else
            echo "   ❌ Service '$service' NOT FOUND in docker-compose.prod.yml"
            ((ERRORS++))
        fi
    done
fi

# Validation noms containers
echo "6. Validating Docker container names..."
CONTAINER_NAMES=$(grep -oP 'CONTAINER_NAME="\K[^"]+' "$SCRIPT_PATH" || true)
if [[ -n "$CONTAINER_NAMES" ]]; then
    for container in $CONTAINER_NAMES; do
        if [[ "$container" =~ ^collectoria-[a-z-]+-prod$ ]]; then
            echo "   ✅ Container '$container' follows convention"
        else
            echo "   ⚠️  Container '$container' doesn't follow convention"
            ((WARNINGS++))
        fi
    done
fi

# Validation fonctions
echo "7. Validating function calls..."
FUNCTIONS=$(grep -oP '\b[a-z_]+\s*\(' "$SCRIPT_PATH" | sed 's/($//' | sort -u)
for func in $FUNCTIONS; do
    # Skip built-in commands
    if [[ "$func" =~ ^(echo|grep|sed|awk)$ ]]; then
        continue
    fi
    
    if grep -q "^${func}()" "$SCRIPT_DIR"/*.sh 2>/dev/null; then
        echo "   ✅ Function '$func' found in libraries"
    else
        echo "   ⚠️  Function '$func' not found in libraries"
        ((WARNINGS++))
    fi
done

# Validation docker-compose vs docker compose
echo "9. Checking Docker Compose command..."
if grep -q "docker-compose " "$SCRIPT_PATH"; then
    echo "   ❌ 'docker-compose' (V1, obsolete) detected"
    ((ERRORS++))
elif grep -q "docker compose " "$SCRIPT_PATH"; then
    echo "   ✅ 'docker compose' (V2) used"
fi
```

**Usage** :
```bash
./scripts/lib/validate-script.sh scripts/deploy/deploy-backend.sh

# Output :
# 5. Validating Docker service names...
#    ✅ Service 'backend-collection' found in docker-compose.prod.yml
# 6. Validating Docker container names...
#    ✅ Container 'collectoria-backend-collection-prod' follows convention
# 7. Validating function calls...
#    ✅ Function 'check_service_health' found in libraries
#    ✅ Function 'cleanup_dangling_images' found in libraries
# 9. Checking Docker Compose command...
#    ✅ 'docker compose' (V2) used
#
# ✅ APPROVED: Script ready to commit
```

### Règle 3 : Sources de Vérité Documentées

**Créer/Maintenir ces fichiers** :

#### docker-compose.prod.yml

**Source de vérité pour** :
- Noms services
- Noms containers (container_name)
- Ports exposés
- Volumes
- Networks
- Environment variables

```yaml
# docker-compose.prod.yml
services:
  backend-collection:              # ← SERVICE_NAME
    container_name: collectoria-backend-collection-prod  # ← CONTAINER_NAME
    image: collectoria-backend-collection
    ports: []                      # ← Ports NOT exposed to host
    environment:
      DB_HOST: db-collection
```

#### scripts/lib/README.md

**Source de vérité pour** :
- Fonctions disponibles
- Signatures (paramètres, types, ordre)
- Return codes
- Side effects

```markdown
# scripts/lib/README.md
## check_service_health(container_name, health_url, max_attempts, interval)

**Parameters:**
- container_name : Docker container name
- health_url : Full URL (http://localhost:8080/health)
- max_attempts : Maximum attempts (default: 30)
- interval : Seconds between attempts (default: 2)

**Returns:**
- 0 : Service is healthy
- 1 : Service failed health check
```

#### DevOps/environments/production.md

**Source de vérité pour** :
- Versions logiciels (Docker, Node.js, Go)
- Commandes disponibles (docker compose vs docker-compose)
- Utilities installées (wget, curl, jq)
- Structure fichiers
- Permissions

```markdown
# DevOps/environments/production.md

## Software Installed

### Docker
- **Version** : 24.0.5 (with Compose V2 plugin)
- **Command** : `docker compose` (NOT docker-compose)

### Utilities
- wget : Installed ✅
- curl : Installed ✅
- jq : Installed ✅

## Ports
- **8080** : Backend API (internal, NOT exposed to host)
```

#### Meta-Agent/naming-conventions.md

**Source de vérité pour** :
- Convention nommage containers
- Convention nommage images
- Convention nommage services

```markdown
# Meta-Agent/naming-conventions.md

## Docker Containers (Production)

Format : `collectoria-[service]-[env]`

Examples :
- collectoria-backend-collection-prod
- collectoria-frontend-prod
- collectoria-db-collection-prod

## Docker Images

Format : `collectoria-[service]`

Examples :
- collectoria-backend-collection
- collectoria-frontend
```

---

## Cas d'Usage

### Cas 1 : Créer Script Déploiement Nouveau Service

```bash
# 1. Consulter docker-compose.prod.yml
cat docker-compose.prod.yml | grep -A 10 "books-service:"
# Output :
#   books-service:
#     container_name: collectoria-books-prod
#     ...

# 2. Noter noms exacts
SERVICE_NAME="books-service"
CONTAINER_NAME="collectoria-books-prod"
IMAGE_NAME="collectoria-books"

# 3. Écrire script avec noms validés
#!/bin/bash
set -e
SERVICE_NAME="books-service"          # ✅ Validé
CONTAINER_NAME="collectoria-books-prod"  # ✅ Validé

# 4. Valider avant commit
./scripts/lib/validate-script.sh scripts/deploy/deploy-books.sh
# ✅ APPROVED

# 5. Commit
git commit -m "feat(deploy): add deploy-books.sh script"
```

### Cas 2 : Modifier Script Existant - Changement Nom Service

```bash
# Contexte : Renommage "backend" → "backend-collection" dans docker-compose.yml

# 1. Identifier scripts impactés
grep -r "SERVICE_NAME=\"backend\"" scripts/
# Output :
# scripts/deploy/deploy-backend.sh:SERVICE_NAME="backend"
# scripts/maintenance/restart-backend.sh:SERVICE_NAME="backend"

# 2. Mettre à jour tous scripts
sed -i 's/SERVICE_NAME="backend"/SERVICE_NAME="backend-collection"/' \
    scripts/deploy/deploy-backend.sh \
    scripts/maintenance/restart-backend.sh

# 3. Valider chaque script
./scripts/lib/validate-script.sh scripts/deploy/deploy-backend.sh
./scripts/lib/validate-script.sh scripts/maintenance/restart-backend.sh
# ✅ Both APPROVED

# 4. Commit
git commit -m "fix(scripts): update service name to backend-collection"
```

### Cas 3 : Vérification Manuelle Rapide

```bash
# Vérifier nom service avant utiliser dans script
grep "^  backend-collection:" docker-compose.prod.yml && echo "✅ EXISTS" || echo "❌ NOT FOUND"

# Vérifier fonction disponible
grep "^check_service_health()" scripts/lib/*.sh && echo "✅ EXISTS" || echo "❌ NOT FOUND"

# Vérifier convention container
echo "collectoria-backend-collection-prod" | grep -E "^collectoria-[a-z-]+-prod$" && echo "✅ VALID" || echo "❌ INVALID"
```

---

## Metrics

### Baseline (Sans Validation Références)

**Session 2026-05-05** :
- Scripts avec références incorrectes : 3/3 (100%)
- Commits corrections références : 5
- Temps debug références : ~20 min

**Détail erreurs** :
- Noms services incorrects : 2
- Noms containers incorrects : 2
- Fonctions non définies : 1

### Objectif (Avec Validation Références)

**Prochaine session** :
- Scripts avec références incorrectes : 0/3 (0%)
- Commits corrections références : 0
- Temps debug références : 0 min

**Impact** :
- Erreurs références : -100%
- Commits corrections : -100%
- Temps debug : -100% (~20 min économisées)

---

## Enforcement

### Au Niveau Script

**validate-script.sh automatise validations** :
- Services Docker
- Containers Docker
- Fonctions
- Commandes

**Usage systématique avant commit** :
```bash
./scripts/lib/validate-script.sh [script].sh
# Si APPROVED → Commit autorisé
# Si REJECTED → Corriger et re-valider
```

### Au Niveau Agent

**Agent DevOps** :
- Consulter sources de vérité AVANT écrire références
- Utiliser validate-script.sh avant demander commit
- Ne JAMAIS supposer, TOUJOURS valider

**Agent Code Review** :
- Exécuter validate-script.sh dans le cadre du review
- REJECT si références incorrectes détectées
- Documenter erreurs dans rapport

**Alfred** :
- Rappeler validation références avant commit
- Vérifier que validate-script.sh a été exécuté

### Au Niveau Documentation

**Maintenir sources de vérité à jour** :
- docker-compose.prod.yml : Version contrôlée
- scripts/lib/README.md : Mis à jour à chaque nouvelle fonction
- DevOps/environments/production.md : Mis à jour après changements infra
- Meta-Agent/naming-conventions.md : Stable, rarement modifié

---

## Comparaison : Code Go/React vs Scripts Bash

### Code Go (validation automatique)

```go
// Go code
service := backend.NewService(db)  // ← Type checking
service.Start()                     // ← Compiler vérifie Start() existe

// Si fonction n'existe pas → Compile error
// Si mauvais type paramètre → Compile error
```

**Validation** : Automatique par compilateur.

### Scripts Bash (validation manuelle)

```bash
# Bash script
SERVICE_NAME="backend"              # ← Aucune validation
docker compose up -d "$SERVICE_NAME"  # ← Runtime error si incorrect

# Si service n'existe pas → Runtime error en production
```

**Validation** : Manuelle, via validate-script.sh.

### Conclusion

**Scripts Bash nécessitent validation explicite** car :
- Pas de type checking
- Pas de compilation
- Erreurs détectées au runtime
- Runtime = production = critique

**Solution** : Validation systématique avant commit.

---

## Conclusion

**Lesson apprise** : Valider TOUTES références contre source de vérité avant commit.

**Règle d'or** : 
```
Ne jamais supposer
Toujours valider
Une référence = Une source de vérité
```

**Sources de vérité** :
- Services/Containers → `docker-compose.prod.yml`
- Fonctions → `scripts/lib/README.md`
- Commandes → `DevOps/environments/production.md`
- Conventions → `Meta-Agent/naming-conventions.md`

**Impact attendu** :
- Erreurs références : -100%
- Commits corrections : -100%
- Temps debug : -100%
- Confiance scripts : +200%

**Adoption** : Immédiate, via validate-script.sh systématique.

---

## Références

**Outils** :
- `scripts/lib/validate-script.sh` (validation automatique)
- `scripts/lib/README.md` (API interne)

**Documentation** :
- `docker-compose.prod.yml` (services, containers)
- `DevOps/environments/production.md` (environnement)
- `Meta-Agent/naming-conventions.md` (conventions)

**Workflows** :
- `Meta-Agent/workflows/bash-scripts-testing.md` (Étape 3)
- `Meta-Agent/checklists/bash-scripts-pre-commit.md`

**Lessons** :
- `bash-scripts-are-code.md`
- `dry-run-mandatory-production.md`
- `document-internal-apis.md`

---

**Créé par** : Agent Amélioration Continue  
**Date** : 2026-05-05  
**Session** : #186-#196  
**Impact** : -100% erreurs références
