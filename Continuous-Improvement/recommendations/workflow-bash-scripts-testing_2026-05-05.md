# Recommendation : Workflow de Test pour Scripts Bash

**Date** : 2026-05-05  
**Auteur** : Agent Amélioration Continue  
**Statut** : ✅ APPROUVÉ - Implémentation immédiate  
**Priorité** : 🔴 CRITIQUE

---

## Problème

Les scripts Bash créés dans `scripts/` sont **commitiés sans aucun test préalable**, causant des erreurs évitables en production.

**Session 2026-05-05** : 8 commits de corrections pour `deploy-backend.sh` et 2 pour `cleanup.sh`.

**Erreurs détectées** :
- Noms de services incorrects
- Noms de containers incorrects
- Fonctions appelées mais non définies
- Commandes obsolètes (`docker-compose` au lieu de `docker compose`)
- Health checks inaccessibles (ports non exposés)
- Logique de parsing fragile non testée

**Conséquence** : Perte de confiance, temps perdu, risques production.

---

## Solution

Workflow de test obligatoire en **4 étapes** avant tout commit de script Bash.

---

## Workflow : Test Scripts Bash

### Vue d'Ensemble

```
Développement → Tests Locaux → Validation Références → Test Production → Commit
     ↓              ↓                  ↓                     ↓              ↓
  Écriture     Shellcheck       Noms services         Dry-run prod      Git
  du code    + Syntax check    + Containers         (prévisualisation)  commit
           + Exécution dry-run  + Fonctions
                + Cas nominaux   + Commandes
```

**Règle absolue** : AUCUN commit de script Bash sans avoir complété ces 4 étapes.

---

### Étape 1 : Développement Local

#### Objectif
Écrire le script avec les bonnes pratiques.

#### Actions
1. Créer script dans `scripts/[category]/[script-name].sh`
2. Ajouter header complet (description, usage, options, exemples)
3. Ajouter `set -e` en début de script (exit on error)
4. Source libraries : `source "$SCRIPT_DIR/../lib/common.sh"`
5. Implémenter logique métier
6. Implémenter flag `--dry-run` (preview actions sans exécution)
7. Implémenter flag `--help` ou documenter usage dans header

#### Template Script

```bash
#!/bin/bash
#
# script-name.sh - One-line Description
#
# Description:
#   Detailed description of what this script does
#
# Usage:
#   ./script-name.sh [OPTIONS]
#
# Options:
#   --option1         Description option 1
#   --option2 VALUE   Description option 2
#   --dry-run         Preview actions without executing
#   --help            Show this help message
#
# Examples:
#   ./script-name.sh                    # Standard execution
#   ./script-name.sh --option1          # With option
#   ./script-name.sh --dry-run          # Preview mode
#

set -e

# Script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Source libraries
source "$SCRIPT_DIR/../lib/common.sh"
source "$SCRIPT_DIR/../lib/docker-utils.sh"

# Configuration
OPTION1="${OPTION1:-default}"
DRY_RUN=false

# Parse arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --option1)
            OPTION1="value"
            shift
            ;;
        --dry-run)
            DRY_RUN=true
            shift
            ;;
        --help)
            head -30 "$0" | grep "^#" | sed 's/^# *//'
            exit 0
            ;;
        *)
            log_error "Unknown option: $1"
            exit 1
            ;;
    esac
done

# Main logic
print_header "Script Name - Collectoria"

log_step "Step 1: Doing something..."
if [[ "$DRY_RUN" == "true" ]]; then
    log_info "[DRY-RUN] Would execute: command"
else
    # Real execution
    log_success "Step 1 completed"
fi

exit 0
```

---

### Étape 2 : Tests Locaux (OBLIGATOIRE)

#### Objectif
Valider que le script fonctionne correctement **avant** de le tester en production.

#### Checklist Validation Locale

- [ ] **Shellcheck** : `shellcheck [script].sh` → PASSED
- [ ] **Syntax check** : `bash -n [script].sh` → OK
- [ ] **Dry-run** : `./[script].sh --dry-run` → Output correct
- [ ] **Cas nominal** : Exécution standard → Fonctionne comme attendu
- [ ] **Cas d'erreur** : Test gestion erreurs → Messages clairs, exit codes corrects

#### Commandes

```bash
# 1. Shellcheck (linter Bash)
shellcheck scripts/deploy/deploy-backend.sh

# Résolution si erreurs :
# - SC2086: Quote variables to prevent word splitting
# - SC2155: Declare and assign separately
# - SC2164: Use 'cd ... || exit' in case cd fails

# 2. Syntax check
bash -n scripts/deploy/deploy-backend.sh

# Si erreur : Corriger syntaxe avant continuer

# 3. Dry-run (prévisualisation)
./scripts/deploy/deploy-backend.sh --dry-run

# Valider output :
# - Toutes les actions listées sont correctes ?
# - Pas d'erreurs dans les messages ?
# - Noms services/containers corrects ?

# 4. Exécution réelle (environnement dev/local)
./scripts/deploy/deploy-backend.sh

# Valider :
# - Script termine sans erreur
# - Logs clairs et informatifs
# - Actions exécutées comme prévu

# 5. Test cas d'erreur (exemple : service déjà running)
./scripts/deploy/deploy-backend.sh
# Relancer immédiatement pour voir gestion "déjà démarré"

# Valider :
# - Script ne crash pas
# - Message d'erreur clair
# - Exit code approprié (non-zero si échec)
```

#### Outils Requis

**Shellcheck** : Linter Bash
```bash
# Installation Ubuntu/Debian
sudo apt-get install shellcheck

# Installation macOS
brew install shellcheck

# Usage
shellcheck script.sh
```

**Erreurs courantes détectées** :
- Variables non quotées (word splitting)
- Globbing non intentionnel
- Conditions fragiles
- Code mort
- Mauvaises pratiques Bash

---

### Étape 3 : Validation Références (OBLIGATOIRE)

#### Objectif
Vérifier que toutes les références (services, containers, fonctions, commandes) sont correctes.

#### Checklist Validation Références

- [ ] **Noms services Docker** : Vérifiés contre `docker-compose.prod.yml`
- [ ] **Noms containers** : Vérifiés contre convention `collectoria-[service]-[env]`
- [ ] **Fonctions appelées** : Vérifiées contre `scripts/lib/README.md`
- [ ] **Commandes Docker** : `docker compose` (V2) utilisé, PAS `docker-compose` (V1)
- [ ] **Health check URLs** : Accessibles (docker exec si port interne)

#### Validation Noms Services

```bash
# 1. Extraire SERVICE_NAME du script
grep -o 'SERVICE_NAME="[^"]*"' scripts/deploy/deploy-backend.sh

# Output exemple : SERVICE_NAME="backend-collection"

# 2. Vérifier dans docker-compose.prod.yml
grep "^  backend-collection:" docker-compose.prod.yml

# Si trouvé → ✅ OK
# Si non trouvé → ❌ ERREUR - Corriger nom service
```

#### Validation Noms Containers

```bash
# 1. Extraire CONTAINER_NAME du script
grep -o 'CONTAINER_NAME="[^"]*"' scripts/deploy/deploy-backend.sh

# Output exemple : CONTAINER_NAME="collectoria-backend-collection-prod"

# 2. Vérifier convention : collectoria-[service]-[env]
# Attendu : collectoria-backend-collection-prod ✅
# Incorrect : collectoria-backend ❌

# 3. Vérifier cohérence avec docker-compose.prod.yml
grep "container_name:" docker-compose.prod.yml | grep "backend-collection"

# Output : container_name: collectoria-backend-collection-prod
```

#### Validation Fonctions

```bash
# 1. Extraire fonctions appelées
grep -oP '\b[a-z_]+\s*\(' scripts/deploy/deploy-backend.sh | sed 's/($//' | sort -u

# Output exemple :
# check_service_health
# cleanup_dangling_images
# log_info

# 2. Vérifier existence dans scripts/lib/
grep -r "^check_service_health()" scripts/lib/

# Si trouvé → ✅ OK
# Si non trouvé → ❌ ERREUR - Fonction n'existe pas

# 3. Vérifier signature dans README.md
grep -A 5 "check_service_health" scripts/lib/README.md

# Valider :
# - Nombre de paramètres correct
# - Types de paramètres corrects
# - Comportement attendu (return 0/1, output, etc.)
```

#### Validation Commandes Docker

```bash
# Vérifier version Docker Compose utilisée
grep -E "(docker-compose|docker compose)" scripts/deploy/deploy-backend.sh

# ✅ OK : docker compose (V2, moderne)
# ❌ ERREUR : docker-compose (V1, obsolète, EOL 2023)

# Si docker-compose détecté :
# Remplacer par : docker compose
```

#### Validation Health Checks

```bash
# 1. Extraire HEALTH_URL du script
grep -o 'HEALTH_URL="[^"]*"' scripts/deploy/deploy-backend.sh

# Output exemple : HEALTH_URL="http://localhost:8080/api/v1/health"

# 2. Vérifier si port exposé dans docker-compose.prod.yml
grep -A 10 "backend-collection:" docker-compose.prod.yml | grep "ports:"

# Si ports: [] ou absent → Port NON exposé à l'hôte

# 3. Si port non exposé → Utiliser docker exec
# ✅ Correct :
check_service_health "$CONTAINER_NAME" "$HEALTH_URL" 30 2
# Fonction docker-utils.sh utilise docker exec en interne

# ❌ Incorrect :
curl -sf "$HEALTH_URL"
# Échoue car port non accessible depuis hôte
```

---

### Étape 4 : Test Production (Dry-run OBLIGATOIRE)

#### Objectif
Tester le script sur l'environnement cible (production) **en mode prévisualisation** avant exécution réelle.

#### Prérequis

Avant de tester en production, vérifier :
- [ ] Accès SSH au serveur production
- [ ] Script transféré sur serveur (git pull)
- [ ] Permissions exécution : `chmod +x script.sh`
- [ ] Environnement prod documenté : `DevOps/environments/production.md`

#### Procédure Test Production

```bash
# 1. Connexion serveur production
ssh collectoria@collectoria-prod-01

# 2. Aller dans répertoire projet
cd /home/collectoria/Collectoria

# 3. Git pull pour récupérer nouveau script
git pull origin main

# 4. DRY-RUN (prévisualisation OBLIGATOIRE)
./scripts/deploy/deploy-backend.sh --dry-run

# Analyser output :
# - Toutes les actions listées sont correctes ?
# - Chemins fichiers corrects ?
# - Noms services/containers corrects ?
# - Commandes Docker valides ?
# - Pas d'erreurs affichées ?

# 5. Si output dry-run OK → Exécution réelle
./scripts/deploy/deploy-backend.sh

# 6. Vérifier résultat
# - Script termine sans erreur ?
# - Service déployé correctement ?
# - Health checks passent ?
# - Logs clairs ?

# 7. Si erreur détectée → ROLLBACK
# - Analyser logs
# - Corriger script en local
# - Recommencer depuis Étape 1
```

#### Règle Absolue

**JAMAIS de première exécution directe en production sans dry-run.**

```bash
# ❌ DANGEREUX
./deploy-backend.sh

# ✅ SÉCURISÉ
./deploy-backend.sh --dry-run   # Preview
# Review output
./deploy-backend.sh              # Execute
```

---

## Validation Automatique

### Script validate-script.sh

Pour automatiser les validations, utiliser `scripts/lib/validate-script.sh` :

```bash
# Valider script avant commit
./scripts/lib/validate-script.sh scripts/deploy/deploy-backend.sh

# Output :
# =========================================
# Validating Script: deploy-backend.sh
# =========================================
#
# 1. Running shellcheck...
#    ✅ Shellcheck passed
#
# 2. Syntax check...
#    ✅ Syntax OK
#
# 3. Checking 'set -e'...
#    ✅ 'set -e' present
#
# 4. Checking --dry-run support...
#    ✅ --dry-run support detected
#
# 5. Validating Docker service names...
#    ✅ Service 'backend-collection' found in docker-compose.prod.yml
#
# 6. Validating Docker container names...
#    ✅ Container 'collectoria-backend-collection-prod' follows convention
#
# 7. Validating function calls...
#    ✅ Function 'check_service_health' found in libraries
#    ✅ Function 'cleanup_dangling_images' found in libraries
#
# 8. Checking header documentation...
#    ✅ Header description present
#    ✅ Usage documentation present
#
# 9. Checking Docker Compose command...
#    ✅ 'docker compose' (V2) used
#
# =========================================
# Validation Summary
# =========================================
# Errors:   0
# Warnings: 0
#
# ✅ APPROVED: Script ready to commit
```

**Voir** : `Continuous-Improvement/recommendations/script-validation-tool_2026-05-05.md`

---

## Intégration Workflow Agents

### Agent DevOps

Quand Agent DevOps crée ou modifie un script Bash :

1. **Développement** : Écrire script avec template
2. **Tests locaux** : Exécuter shellcheck, dry-run, cas nominaux
3. **Validation** : Utiliser `validate-script.sh`
4. **Test production** : Dry-run sur serveur prod
5. **Review** : Appeler Agent Code Review (si disponible)
6. **Commit** : Demander commit à Alfred si ✅ APPROVED

### Alfred

Quand Alfred reçoit demande commit d'un script Bash :

1. Vérifier que Agent DevOps a mentionné les tests
2. Vérifier que `validate-script.sh` a été exécuté
3. Vérifier que Agent Code Review a approuvé (si disponible)
4. Si une étape manque → Demander à Agent DevOps de compléter
5. Si toutes étapes OK → Commiter

### Agent Code Review

Quand Agent Code Review audite un script Bash :

1. Exécuter `validate-script.sh`
2. Vérifier checklist pré-commit complétée
3. Vérifier tests mentionnés ont été exécutés
4. Produire rapport : ✅ APPROVED / ⚠️ WARNINGS / ❌ REJECTED
5. Si REJECTED → Agent DevOps doit corriger et re-soumettre

---

## Métriques de Succès

### Baseline (Session 2026-05-05)

- Scripts testés avant commit : **0/3 (0%)**
- Scripts avec shellcheck : **0/3 (0%)**
- Commits corrections après déploiement : **10/10 (100%)**

### Objectif (Prochaine session)

- Scripts testés avant commit : **3/3 (100%)**
- Scripts avec shellcheck passing : **3/3 (100%)**
- Commits corrections après déploiement : **<2/10 (<20%)**

### Objectif (1 mois)

- Scripts testés avant commit : **100%**
- Scripts avec shellcheck passing : **100%**
- Commits corrections après déploiement : **<1/10 (<10%)**
- Agent Code Review opérationnel : **100% scripts reviewiés**

---

## Références

- **Checklist pré-commit** : `Meta-Agent/checklists/bash-scripts-pre-commit.md`
- **Validation tool** : `scripts/lib/validate-script.sh`
- **API interne** : `scripts/lib/README.md`
- **Agent Code Review** : `Code-Review/CLAUDE.md`
- **Environnement prod** : `DevOps/environments/production.md`

---

## Implémentation

### Prochaines Étapes

1. ✅ Créer `Meta-Agent/workflows/bash-scripts-testing.md` (ce fichier)
2. ⏳ Créer `scripts/lib/README.md` (documentation API interne)
3. ⏳ Créer `scripts/lib/validate-script.sh` (outil validation)
4. ⏳ Créer `Meta-Agent/checklists/bash-scripts-pre-commit.md`
5. ⏳ Mettre à jour `DevOps/CLAUDE.md` (référence workflow)
6. ⏳ Créer Agent Code Review (optionnel mais recommandé)

### Adoption

Ce workflow devient **obligatoire** pour tous les scripts Bash créés ou modifiés dans `scripts/`.

**Agent Meta** audite le respect de ce workflow tous les 10 commits.

---

**Créé par** : Agent Amélioration Continue  
**Date** : 2026-05-05  
**Statut** : APPROUVÉ  
**Impact** : Réduction attendue de 100% → <10% commits corrections
