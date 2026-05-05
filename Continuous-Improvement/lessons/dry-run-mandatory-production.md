# Lesson Learned : Dry-run Obligatoire en Production

**Date** : 2026-05-05  
**Session** : Commits #186-#196  
**Contexte** : Scripts exécutés directement en production sans preview

---

## Problème Observé

Les scripts de déploiement (`deploy-backend.sh`, `cleanup.sh`, health checks) ont été **exécutés directement en production** lors de leur première utilisation, sans prévisualisation.

**Résultat** : Échecs multiples, corrections en urgence, stress, temps perdu.

---

## Incident Typique

### Timeline Session 2026-05-05

```
14:30 - Script deploy-backend.sh créé et commitié
14:31 - Première exécution sur serveur production
14:31 - ❌ ÉCHEC : "go: command not found"
14:35 - Correction commit #1 : Retirer go test
14:36 - ❌ ÉCHEC : "docker-compose: command not found"
14:40 - Correction commit #2 : Remplacer par docker compose
14:41 - ❌ ÉCHEC : "No such file or directory: docker compose.prod.yml"
14:45 - Correction commit #3 : Corriger nom fichier
14:46 - ❌ ÉCHEC : "service backend not found"
14:50 - Correction commit #4 : Corriger nom service
14:51 - ❌ ÉCHEC : "container collectoria-backend not found"
14:55 - Correction commit #5 : Corriger nom container
14:56 - ❌ ÉCHEC : "check_service_health: command not found"
15:00 - Correction commit #6 : Implémenter fonction
15:01 - ❌ ÉCHEC : Health check timeout
15:10 - Correction commit #7 : Utiliser docker exec
15:11 - ✅ SUCCÈS (enfin)

Temps total : 41 minutes d'échecs successifs
```

### Analyse

**Cause racine** : Aucune prévisualisation avant exécution réelle.

**Conséquence** : Chaque erreur découverte en production nécessite :
1. Analyser logs production
2. Comprendre erreur
3. Corriger localement
4. Commiter
5. Git pull sur prod
6. Re-exécuter
7. Espérer que ça marche cette fois

**Si dry-run avait été utilisé** :
```
14:30 - Script créé et commitié
14:31 - Dry-run sur production
14:32 - Review output : 8 erreurs détectées
14:50 - Corrections locales (toutes en une fois)
15:00 - Git pull sur prod
15:01 - Dry-run : OK
15:02 - Exécution réelle : ✅ SUCCÈS

Temps total : 32 minutes (dont 30 min corrections locale)
Échecs production : 0
Commits corrections : 1 (au lieu de 8)
```

---

## Lesson

### Dry-run OBLIGATOIRE avant toute exécution production

**Règle absolue** : JAMAIS de première exécution directe en production.

**Workflow obligatoire** :
```bash
# 1. Dry-run (prévisualisation)
./script.sh --dry-run

# 2. Review manuelle output
# - Toutes actions listées sont correctes ?
# - Noms services/containers corrects ?
# - Chemins fichiers valides ?
# - Commandes valides ?

# 3. Si output OK → Exécution réelle
./script.sh

# 4. Si output NOK → Corriger et retour étape 1
```

### Pourquoi c'est critique

**En production** :
- Pas de undo facile
- Impact utilisateurs réels
- Données réelles manipulées
- Downtime = perte business
- Corrections sous pression

**Dry-run permet** :
- Détection erreurs AVANT impact
- Review calme et posée
- Corrections réfléchies
- Validation complète workflow
- Confiance avant exécution

---

## Application Pratique

### Règle 1 : Tous Scripts DOIVENT Implémenter --dry-run

**Implémentation obligatoire** :

```bash
#!/bin/bash
set -e

# Parse arguments
DRY_RUN=false

while [[ $# -gt 0 ]]; do
    case $1 in
        --dry-run)
            DRY_RUN=true
            shift
            ;;
        *)
            # Other options
            shift
            ;;
    esac
done

# Dans chaque action
if [[ "$DRY_RUN" == "true" ]]; then
    log_info "[DRY-RUN] Would execute: docker compose up -d backend"
else
    docker compose up -d backend
fi
```

**Pattern réutilisable** : Function `execute()`

```bash
# Dans scripts/lib/common.sh
execute() {
    local command="$*"
    
    if [[ "$DRY_RUN" == "true" ]]; then
        log_info "[DRY-RUN] Would execute: $command"
        return 0
    else
        eval "$command"
        return $?
    fi
}

# Usage dans script
execute docker compose up -d backend
execute docker exec backend wget -q http://localhost:8080/health
```

### Règle 2 : Dry-run Production AVANT Toute Modification

**Workflow déploiement** :

```bash
# Sur serveur production
cd /home/collectoria/Collectoria

# 1. Git pull nouveau script/modification
git pull origin main

# 2. DRY-RUN OBLIGATOIRE (première exécution)
./scripts/deploy/deploy-backend.sh --dry-run

# 3. Review output ligne par ligne
# - Services names OK ?
# - Containers names OK ?
# - File paths exist ?
# - Commands valid ?
# - Logic flow correct ?

# 4. Si moindre doute → STOP
# - Corriger localement
# - Re-push
# - Re-pull
# - Re-dry-run

# 5. Si output 100% conforme → Exécution réelle
./scripts/deploy/deploy-backend.sh

# 6. Monitor logs en temps réel
# Ctrl+C si problème détecté
```

### Règle 3 : Output Dry-run Doit Être Exploitable

**Output lisible et complet** :

```bash
# ❌ Mauvais : Output insuffisant
[DRY-RUN] Would deploy

# ✅ Bon : Output détaillé
[DRY-RUN] Would execute: git pull origin main
[DRY-RUN] Would execute: docker compose build --no-cache backend-collection
[DRY-RUN] Would execute: docker compose stop -t 10 backend-collection
[DRY-RUN] Would execute: docker compose up -d backend-collection
[DRY-RUN] Would execute: docker exec collectoria-backend-collection-prod wget -q http://localhost:8080/api/v1/health
[DRY-RUN] Would execute: docker image prune -f
[DRY-RUN] Would keep 2 latest images of collectoria-backend-collection
```

**Structure dry-run output** :

```bash
print_header "Deployment Preview (DRY-RUN)"

echo "Configuration:"
echo "  Service: $SERVICE_NAME"
echo "  Container: $CONTAINER_NAME"
echo "  Image: $IMAGE_NAME"
echo "  Compose file: $COMPOSE_FILE"
echo ""

echo "Actions to be performed:"
echo "1. Git pull origin main"
echo "2. Build Docker image (no cache: $NO_CACHE)"
echo "3. Stop current container (timeout: 10s)"
echo "4. Start new container"
echo "5. Health check: $HEALTH_URL (max attempts: 30)"
echo "6. Cleanup old images (keep: $KEEP_IMAGES)"
echo ""

echo "Resources affected:"
echo "  - Service: $SERVICE_NAME (will be restarted)"
echo "  - Container: $CONTAINER_NAME (will be replaced)"
echo "  - Images: Old versions will be pruned"
echo ""

echo "Estimated duration: ~2-3 minutes"
echo "Estimated downtime: ~10 seconds (during restart)"
echo ""

log_warning "Review this preview carefully before executing"
log_info "To execute: $0 (without --dry-run)"
```

### Règle 4 : Checklist Post-Dry-run

**Avant exécution réelle, valider** :

- [ ] Tous noms services corrects (vs docker-compose.yml)
- [ ] Tous noms containers corrects (vs convention)
- [ ] Tous chemins fichiers existent
- [ ] Toutes commandes sont valides
- [ ] Séquence d'actions logique
- [ ] Pas d'actions destructives non voulues
- [ ] Downtime estimé acceptable
- [ ] Backup récent disponible (si manipulation données)

**Si UNE SEULE case non cochée** → NE PAS exécuter, corriger d'abord.

---

## Cas d'Usage

### Cas 1 : Déploiement Backend

```bash
# Développement local : tests locaux OK
./deploy-backend.sh --dry-run  # Local

# Production : première exécution
ssh prod
./deploy-backend.sh --dry-run  # Preview
# Review output : OK
./deploy-backend.sh             # Execute
```

### Cas 2 : Cleanup Agressif

```bash
# Production : cleanup avec suppression images
./cleanup.sh --aggressive --dry-run

# Output montre :
# - 15 dangling images (500MB)
# - 3 stopped containers >48h
# - 2 unused volumes (1.2GB)
# - 45 unused images (2GB)      ← ATTENTION
# - Build cache (800MB)

# Review : 45 images unused = images rollback ?
# Vérifier lesquelles avant cleanup agressif

docker images | grep collectoria

# Decision : Garder 2 dernières versions
./cleanup.sh --aggressive --keep-images 2 --dry-run

# Output OK → Execute
./cleanup.sh --aggressive --keep-images 2
```

### Cas 3 : Migration Base de Données

```bash
# Migration destructive (drop column)
./migrate-db.sh --version 042 --dry-run

# Output montre :
# [DRY-RUN] Would connect to: postgresql://collectoria:***@localhost:5432/collection_management
# [DRY-RUN] Would execute migration: 042_drop_unused_column.sql
# [DRY-RUN] SQL preview:
#   ALTER TABLE books DROP COLUMN IF EXISTS old_field;
# [DRY-RUN] Affected rows estimation: ~50,000
# [DRY-RUN] Backup recommended: YES

# Actions AVANT exécution :
# 1. Backup base
./backup-db.sh

# 2. Vérifier backup OK
ls -lh /home/collectoria/backups/

# 3. Re-dry-run pour confirmer
./migrate-db.sh --version 042 --dry-run

# 4. Execute
./migrate-db.sh --version 042
```

---

## Metrics

### Baseline (Sans Dry-run)

**Session 2026-05-05** :
- Scripts exécutés sans dry-run : 3/3 (100%)
- Échecs première exécution : 3/3 (100%)
- Commits corrections : 10
- Temps debug production : 41 min

### Objectif (Avec Dry-run)

**Prochaine session** :
- Scripts exécutés avec dry-run : 3/3 (100%)
- Échecs première exécution : 0/3 (0%)
- Commits corrections : <1
- Temps debug production : <5 min

**Impact** :
- Échecs production : -100%
- Commits corrections : -90%
- Temps debug : -88%
- Stress équipe : -95%

---

## Exceptions

### Quand Dry-run Peut Être Optionnel

**Aucune exception en production**.

**En développement local** :
- Script déjà testé plusieurs fois
- Environnement dev jetable (facile reset)
- Pas de données réelles
- Seul développeur impacté

**Mais même en dev, dry-run reste recommandé** pour :
- Valider workflow après modification
- Comprendre séquence actions
- Documenter comportement

### Quand Dry-run Est Insuffisant

**Dry-run NE remplace PAS** :
- Tests unitaires (logique script)
- Tests locaux (exécution réelle en dev)
- Code review (Agent Code Review)
- Validation références (validate-script.sh)

**Dry-run EST** :
- Dernière vérification avant exécution production
- Validation environnement cible
- Prévisualisation actions réelles
- Checklist manuelle finale

---

## Enforcement

### Au Niveau Script

**Checklist création script** :
- [ ] Flag --dry-run implémenté
- [ ] Output dry-run détaillé et lisible
- [ ] Toutes actions destructives loggées en dry-run
- [ ] Header mentionne --dry-run dans usage

### Au Niveau Agent

**Agent DevOps** :
- Toujours tester avec --dry-run avant de dire "terminé"
- Mentionner dry-run dans rapport de test
- Documenter output dry-run si actions critiques

**Agent Code Review** :
- Vérifier présence flag --dry-run
- Warning si absent
- Valider output dry-run exploitable

**Alfred** :
- Rappeler dry-run avant commit script
- Rappeler dry-run avant déploiement production

### Au Niveau Documentation

**README.md scripts** :
- Section "Dry-run Mode" obligatoire
- Exemples dry-run pour chaque script
- Checklist post-dry-run

**DevOps/environments/production.md** :
- Workflow déploiement mentionne dry-run obligatoire
- Exemples complets avec dry-run

---

## Conclusion

**Lesson apprise** : Dry-run obligatoire en production, SANS EXCEPTION.

**Règle d'or** : 
```
dry-run → review → execute
(jamais execute direct)
```

**Impact attendu** :
- Échecs production : 100% → 0%
- Commits corrections : -90%
- Temps debug : -88%
- Confiance : +200%

**Adoption** : Immédiate, à partir de cette session.

---

## Références

**Workflows** :
- `Meta-Agent/workflows/bash-scripts-testing.md` (Étape 4 : Test Production)
- `Meta-Agent/checklists/bash-scripts-pre-commit.md` (Checklist dry-run)

**Scripts** :
- `scripts/lib/common.sh` (function execute)
- `scripts/deploy/*.sh` (tous implémentent --dry-run)

**Lessons** :
- `bash-scripts-are-code.md`
- `validate-references-before-commit.md`

---

**Créé par** : Agent Amélioration Continue  
**Date** : 2026-05-05  
**Session** : #186-#196  
**Impact** : -88% temps debug production
