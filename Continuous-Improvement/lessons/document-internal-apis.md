# Lesson Learned : Documenter les APIs Internes

**Date** : 2026-05-05  
**Session** : Commits #186-#196  
**Contexte** : Fonction appelée mais non définie, pas de documentation

---

## Problème Observé

Le script `deploy-backend.sh` appelait la fonction `check_service_health()` qui **n'existait pas** dans les libraries `common.sh` ni `docker-utils.sh`.

```bash
# deploy-backend.sh ligne 221
if ! check_service_health "$CONTAINER_NAME" "$HEALTH_URL" 30 2; then
    log_error "Health check failed"
fi

# Résultat
bash: check_service_health: command not found
```

**Cause** : Aucune documentation des fonctions disponibles dans les libraries.

---

## Incident Typique

### Workflow Dysfonctionnel

```
1. Agent DevOps écrit deploy-backend.sh
2. Agent DevOps pense : "Il doit bien y avoir une fonction health check"
3. Agent DevOps suppose : "Elle s'appelle probablement check_service_health"
4. Agent DevOps appelle : check_service_health(...)
5. Commit sans vérification
6. Exécution production
7. ❌ ÉCHEC : "command not found"
8. Debug : Fonction n'existe pas
9. Correction : Implémenter fonction dans docker-utils.sh
10. Commit correction #6
```

**Temps perdu** : 15 minutes pour découvrir qu'une fonction n'existe pas.

### Workflow Idéal (Avec Documentation)

```
1. Agent DevOps écrit deploy-backend.sh
2. Agent DevOps consulte : scripts/lib/README.md
3. Agent DevOps trouve : check_service_health existe dans docker-utils.sh
4. Agent DevOps lit : Signature, paramètres, comportement
5. Agent DevOps appelle : check_service_health avec bons paramètres
6. Commit
7. Exécution production
8. ✅ SUCCÈS
```

**Temps économisé** : 15 minutes de debug évitées.

---

## Lesson

### Les libraries sont des APIs internes

**common.sh et docker-utils.sh = API interne du projet**

Comme toute API, elles DOIVENT être documentées :
- Fonctions disponibles
- Signatures (paramètres, types, ordre)
- Comportement (return codes, output, side effects)
- Exemples d'usage
- Cas d'erreur

### Pas de documentation = Pas d'API

**Sans documentation** :
- Impossible de savoir quelles fonctions existent
- Impossible de savoir comment les utiliser
- Impossible de savoir ce qu'elles retournent
- Duplication code (réimplémentation fonction existante)
- Erreurs (mauvais paramètres, mauvaise interprétation)

**Conséquence** : Libraries inutilisables, chacun réinvente la roue.

---

## Application Pratique

### Règle 1 : Créer scripts/lib/README.md

**Documentation complète de l'API interne** :

```markdown
# Scripts Libraries - API Reference

## common.sh

### Logging Functions

#### log(message)
Logs a timestamped info message.

**Parameters:**
- `message` : String - Message to log

**Returns:** None

**Example:**
```bash
log "Deployment started"
# Output: [2026-05-05 14:30:00] Deployment started
```

#### check_service_health(service_name, health_url, max_retries, retry_interval)
Checks service health via HTTP endpoint.

**Parameters:**
- `service_name` : String - Display name for logging
- `health_url` : String - HTTP URL to check (e.g., http://localhost:8080/health)
- `max_retries` : Integer - Maximum attempts (default: 30)
- `retry_interval` : Integer - Seconds between retries (default: 2)

**Returns:**
- `0` : Service is healthy
- `1` : Service failed health check

**Side Effects:**
- Logs progress dots to stdout
- Logs success/error message

**Example:**
```bash
if check_service_health "Backend" "http://localhost:8080/api/v1/health" 30 2; then
    log_success "Backend is ready"
else
    log_error "Backend failed to start"
    exit 1
fi
```

**Note:** For internal container ports (not exposed to host), use `docker exec` variant from docker-utils.sh

## docker-utils.sh

### check_service_health(container_name, health_url, max_attempts, interval)
**IMPORTANT: This is the INTERNAL variant using docker exec**

Checks service health from inside the container (for unexposed ports).

**Parameters:**
- `container_name` : String - Docker container name
- `health_url` : String - Full URL (e.g., http://localhost:8080/health)
- `max_attempts` : Integer - Maximum attempts (default: 30)
- `interval` : Integer - Seconds between attempts (default: 2)

**Returns:**
- `0` : Service is healthy
- `1` : Service failed health check

**Technical:** Uses `docker exec [container] wget -q -O- [url]` internally.

**Example:**
```bash
# For internal container port (not exposed to host)
if check_service_health "collectoria-backend-collection-prod" \
                        "http://localhost:8080/api/v1/health" 30 2; then
    log_success "Backend is healthy"
fi
```
```

**Voir fichier complet** : `Continuous-Improvement/recommendations/workflow-bash-scripts-testing_2026-05-05.md` (section Documentation API)

### Règle 2 : Commenter Functions Style JSDoc

**Dans common.sh et docker-utils.sh** :

```bash
#
# check_service_health - Check service health via HTTP endpoint
#
# Polls an HTTP health endpoint until service responds or max retries reached.
#
# PARAMETERS:
#   $1 - service_name    : Display name for logging
#   $2 - health_url      : HTTP URL to check (http://host:port/path)
#   $3 - max_retries     : Maximum attempts (default: 30)
#   $4 - retry_interval  : Seconds between retries (default: 2)
#
# RETURNS:
#   0 - Service is healthy (HTTP 200 OK)
#   1 - Service failed health check after max retries
#
# SIDE EFFECTS:
#   - Prints progress dots to stdout
#   - Logs success/error message
#
# EXAMPLE:
#   if check_service_health "Backend" "http://localhost:8080/health" 30 2; then
#       log_success "Backend started successfully"
#   fi
#
check_service_health() {
    local service_name="$1"
    local health_url="$2"
    local max_retries="${3:-30}"
    local retry_interval="${4:-2}"
    
    log_info "Checking health of $service_name..."
    log_info "URL: $health_url"
    
    # Implementation...
}
```

**Format** :
- Description une ligne
- Description détaillée (optionnel)
- PARAMETERS : Liste paramètres avec types et descriptions
- RETURNS : Codes retour et signification
- SIDE EFFECTS : Effets de bord (logs, fichiers, etc.)
- EXAMPLE : Exemple d'usage concret

### Règle 3 : Conventions Nommage Claires

**Convention actuelle** : Inconsistante

```bash
# common.sh
check_service_health()    # check_*
check_container_running() # check_*
has_uncommitted_changes() # has_*
get_current_commit()      # get_*
save_deployment_log()     # action verb

# docker-utils.sh
cleanup_dangling_images() # action verb
get_container_logs()      # get_*
```

**Convention recommandée** :

| Préfixe | Usage | Retour | Exemple |
|---------|-------|--------|---------|
| `check_*` | Validation/test | 0=OK, 1=NOK | check_container_running |
| `get_*` | Récupération valeur | stdout | get_current_commit |
| `has_*` | Test booléen | 0=true, 1=false | has_uncommitted_changes |
| `is_*` | Test booléen | 0=true, 1=false | is_dry_run |
| `[verb]_*` | Action | 0=success, 1=error | cleanup_dangling_images |
| `log_*` | Logging | stdout | log_info |

**Documentation dans README.md** :
```markdown
## Naming Conventions

### Function Prefixes

- `check_*` : Validation or test functions. Return 0 if OK, 1 if NOK.
- `get_*` : Value retrieval functions. Output to stdout.
- `has_*` / `is_*` : Boolean test functions. Return 0 for true, 1 for false.
- `[verb]_*` : Action functions. Return 0 on success, 1 on error.
- `log_*` : Logging functions. Output to stdout/stderr.

### Examples

```bash
# check_* : Returns 0/1
if check_container_running "backend"; then
    echo "Running"
fi

# get_* : Outputs value
commit=$(get_current_commit)

# has_* / is_* : Returns 0/1
if has_uncommitted_changes; then
    echo "Uncommitted changes"
fi

# [verb]_* : Action
cleanup_dangling_images  # Returns 0 on success

# log_* : Logging
log_info "Starting deployment"
```
```

### Règle 4 : Mise à Jour Documentation Obligatoire

**Quand ajouter/modifier fonction dans common.sh ou docker-utils.sh** :

1. ✅ Ajouter commentaire JSDoc-style dans .sh
2. ✅ Ajouter entrée dans scripts/lib/README.md
3. ✅ Ajouter exemple d'usage
4. ✅ Tester exemple (doit fonctionner)
5. ✅ Commiter .sh + README.md ensemble

**Checklist validation** :
- [ ] Fonction commentée avec format JSDoc
- [ ] Fonction documentée dans README.md
- [ ] Signature complète (paramètres, return)
- [ ] Exemple d'usage fourni et testé
- [ ] Convention nommage respectée

**Si UNE case non cochée** → NE PAS commiter.

---

## Cas d'Usage

### Cas 1 : Développement Nouveau Script

```bash
# Agent DevOps écrit deploy-backend.sh

# 1. Consulter README.md pour fonctions disponibles
cat scripts/lib/README.md | less

# 2. Chercher fonction health check
grep -A 10 "health" scripts/lib/README.md

# Output :
# check_service_health(service_name, health_url, max_retries, retry_interval)
# Checks service health via HTTP endpoint.
# ...

# 3. Lire signature et exemple
# 4. Utiliser fonction correctement
source "$SCRIPT_DIR/../lib/common.sh"
if check_service_health "Backend" "http://localhost:8080/api/v1/health" 30 2; then
    log_success "Backend healthy"
fi

# 5. Pas de surprise, fonctionne du premier coup ✅
```

### Cas 2 : Fonction Existe Mais Mal Utilisée

```bash
# Sans documentation
check_service_health "Backend" "http://localhost:8080/health"
# ❌ Erreur : Paramètres max_retries et interval manquants

# Avec documentation
# Consulter README.md
# Voir : check_service_health(service_name, health_url, max_retries, retry_interval)
# Utiliser avec tous paramètres
check_service_health "Backend" "http://localhost:8080/health" 30 2
# ✅ Succès
```

### Cas 3 : Fonction N'existe Pas → Créer

```bash
# Besoin fonction get_container_uptime

# 1. Vérifier si existe déjà
grep -r "get_container_uptime" scripts/lib/
# Résultat : Pas trouvée

# 2. Implémenter dans docker-utils.sh
#
# get_container_uptime - Get container uptime in seconds
#
# PARAMETERS:
#   $1 - container_name : Docker container name
#
# RETURNS:
#   Outputs uptime in seconds to stdout
#   Returns 1 if container not found
#
# EXAMPLE:
#   uptime=$(get_container_uptime "collectoria-backend-prod")
#   echo "Uptime: ${uptime}s"
#
get_container_uptime() {
    local container_name="$1"
    
    if ! check_container_running "$container_name"; then
        log_error "Container $container_name not running"
        return 1
    fi
    
    docker inspect --format='{{.State.StartedAt}}' "$container_name" | \
        xargs -I {} date -d {} +%s | \
        awk -v now=$(date +%s) '{print now - $1}'
}

# 3. Ajouter à README.md
# #### get_container_uptime(container_name)
# Get container uptime in seconds.
# ...

# 4. Tester
uptime=$(get_container_uptime "collectoria-backend-collection-prod")
echo "Uptime: ${uptime}s"
# Output : Uptime: 3600s

# 5. Commiter docker-utils.sh + README.md
git add scripts/lib/docker-utils.sh scripts/lib/README.md
git commit -m "feat(scripts): add get_container_uptime function"
```

---

## Metrics

### Baseline (Sans Documentation)

**Session 2026-05-05** :
- Fonctions appelées non définies : 1 (check_service_health)
- Temps debug "function not found" : 15 min
- Fonctions dupliquées : Non mesuré (mais probable)
- Documentation API interne : 0%

### Objectif (Avec Documentation)

**Prochaine session** :
- Fonctions appelées non définies : 0
- Temps debug "function not found" : 0 min
- Documentation API interne : 100% (toutes fonctions documentées)
- README.md maintenu à jour : Oui

**Impact** :
- Temps recherche fonction : -90%
- Erreurs "function not found" : -100%
- Duplication code : -80%
- Onboarding nouveaux développeurs : -60% temps

---

## Comparaison avec API Externes

### API REST (exemple)

**Documentation obligatoire** :
- Endpoints disponibles
- Méthodes HTTP
- Paramètres (query, body, headers)
- Responses (codes, formats)
- Exemples requests/responses
- Authentification

**Sans documentation** : API inutilisable.

### Library Bash (common.sh, docker-utils.sh)

**Documentation obligatoire** :
- Fonctions disponibles ✅
- Signatures (paramètres, types) ✅
- Returns (codes, output) ✅
- Exemples d'usage ✅
- Side effects ✅

**Sans documentation** : Library inutilisable.

### Conclusion

**APIs internes = Même rigueur que APIs externes**

---

## Enforcement

### Au Niveau Code

**Pre-commit hook** :
```bash
#!/bin/bash
# .git/hooks/pre-commit

# Si modification common.sh ou docker-utils.sh
if git diff --cached --name-only | grep -E "scripts/lib/(common|docker-utils)\.sh"; then
    # Vérifier que README.md est aussi modifié
    if ! git diff --cached --name-only | grep -q "scripts/lib/README.md"; then
        echo "❌ Error: common.sh or docker-utils.sh modified but README.md not updated"
        echo "   Update scripts/lib/README.md with new/modified functions"
        exit 1
    fi
fi
```

### Au Niveau Agent

**Agent DevOps** :
- Consulter README.md AVANT appeler fonction
- Vérifier signature et paramètres
- Si fonction manquante → Créer + documenter
- Commiter .sh + README.md ensemble

**Agent Code Review** :
- Vérifier fonctions appelées existent dans README.md
- Vérifier signature correspond documentation
- Si nouvelle fonction → Vérifier documentation ajoutée
- REJECT si fonction non documentée

**Alfred** :
- Vérifier README.md mis à jour si modification libs
- Rappeler documentation obligatoire

### Au Niveau Documentation

**scripts/lib/README.md** :
- Template section fonction obligatoire
- Convention nommage documentée
- Index fonctions alphabétique
- Version/date dernière mise à jour

---

## Conclusion

**Lesson apprise** : Libraries internes = API interne, documentation OBLIGATOIRE.

**Règle d'or** : 
```
Pas de fonction sans documentation
Pas de documentation sans exemple
Pas d'exemple non testé
```

**Impact attendu** :
- Erreurs "function not found" : -100%
- Temps recherche fonction : -90%
- Duplication code : -80%
- Qualité scripts : +50%

**Adoption** : Immédiate, starting with scripts/lib/README.md creation.

---

## Références

**Documentation à créer** :
- `scripts/lib/README.md` (API Reference complète)

**Workflows** :
- `Meta-Agent/workflows/bash-scripts-testing.md` (référence README.md)
- `Meta-Agent/checklists/bash-scripts-pre-commit.md` (validation références)

**Code** :
- `scripts/lib/common.sh` (à commenter JSDoc-style)
- `scripts/lib/docker-utils.sh` (à commenter JSDoc-style)

**Lessons** :
- `bash-scripts-are-code.md`
- `validate-references-before-commit.md`

---

**Créé par** : Agent Amélioration Continue  
**Date** : 2026-05-05  
**Session** : #186-#196  
**Impact** : -90% temps recherche fonctions
