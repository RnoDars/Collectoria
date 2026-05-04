# Scripts de Déploiement Automatisés

**Date de création** : 2026-05-04
**Priorité** : HAUTE
**Effort estimé** : 3-4h
**Agent(s) responsable(s)** : Agent DevOps
**Status** : 📋 TODO

---

## Contexte

Actuellement, le déploiement en production est manuel et non standardisé. Cela pose plusieurs problèmes :

1. **Processus non reproductible** : Chaque déploiement est différent
2. **Risque d'oubli** : Étapes importantes peuvent être oubliées (migrations, restart, cleanup)
3. **Pas de rollback** : Pas de procédure en cas d'échec
4. **Temps perdu** : Commandes à exécuter manuellement à chaque fois
5. **Erreurs humaines** : Typos, mauvais ordre d'exécution

**Impact** :
- Déploiements stressants et longs
- Downtime imprévisible
- Difficile de revenir en arrière en cas de problème

---

## Objectif

Créer des scripts de déploiement automatisés, reproductibles et sécurisés pour :
1. **Frontend uniquement** (changements UI/UX)
2. **Backend uniquement** (changements API/business logic)
3. **Full stack** (changements frontend + backend)
4. **Rollback** (retour à la version précédente)

**Principes** :
- ✅ Idempotent (peut être réexécuté sans danger)
- ✅ Atomique (tout ou rien)
- ✅ Traçable (logs de chaque déploiement)
- ✅ Réversible (rollback automatique si échec)
- ✅ Rapide (minimiser le downtime)

---

## Architecture Cible

```
Collectoria/
├── scripts/
│   ├── deploy/
│   │   ├── deploy-frontend.sh          # Déploiement frontend uniquement
│   │   ├── deploy-backend.sh           # Déploiement backend uniquement
│   │   ├── deploy-full.sh              # Déploiement complet
│   │   ├── rollback.sh                 # Rollback à version précédente
│   │   ├── health-check.sh             # Vérification état services
│   │   └── cleanup-images.sh           # Nettoyage images Docker anciennes
│   │
│   └── deploy/lib/
│       ├── common.sh                   # Fonctions communes
│       ├── docker-utils.sh             # Fonctions Docker
│       └── notification.sh             # Notifications (optionnel)
│
└── .deployment/
    └── history/
        └── YYYY-MM-DD_HH-MM-SS.log     # Logs de déploiement
```

---

## Plan d'Action

### Phase 1 : Fonctions Communes (1h)

**Agent DevOps** :
- [ ] Créer `scripts/deploy/lib/common.sh` :
  ```bash
  #!/bin/bash
  
  # Couleurs pour output
  RED='\033[0;31m'
  GREEN='\033[0;32m'
  YELLOW='\033[1;33m'
  NC='\033[0m' # No Color
  
  # Logging
  log() {
    echo -e "${GREEN}[$(date +'%Y-%m-%d %H:%M:%S')]${NC} $1"
  }
  
  log_error() {
    echo -e "${RED}[$(date +'%Y-%m-%d %H:%M:%S')] ERROR:${NC} $1"
  }
  
  log_warning() {
    echo -e "${YELLOW}[$(date +'%Y-%m-%d %H:%M:%S')] WARNING:${NC} $1"
  }
  
  # Check if running as root or with sudo
  check_permissions() {
    if [[ $EUID -ne 0 ]] && ! groups | grep -q docker; then
      log_error "Ce script nécessite sudo ou appartenance au groupe docker"
      exit 1
    fi
  }
  
  # Backup current state
  backup_state() {
    local backup_dir=".deployment/backups/$(date +'%Y-%m-%d_%H-%M-%S')"
    mkdir -p "$backup_dir"
    
    # Backup docker-compose.yml
    cp docker-compose.prod.yml "$backup_dir/"
    
    # Backup .env files
    cp .env.production "$backup_dir/" 2>/dev/null || true
    
    # Save current image tags
    docker compose -f docker-compose.prod.yml images > "$backup_dir/images.txt"
    
    log "Backup créé : $backup_dir"
    echo "$backup_dir"
  }
  
  # Health check
  health_check() {
    local service=$1
    local url=$2
    local max_attempts=30
    local attempt=1
    
    log "Health check $service..."
    
    while [ $attempt -le $max_attempts ]; do
      if curl -sf "$url" > /dev/null; then
        log "✅ $service : OK"
        return 0
      fi
      
      log_warning "Tentative $attempt/$max_attempts..."
      sleep 2
      attempt=$((attempt + 1))
    done
    
    log_error "❌ $service : Health check échoué après $max_attempts tentatives"
    return 1
  }
  ```

- [ ] Créer `scripts/deploy/lib/docker-utils.sh` :
  ```bash
  #!/bin/bash
  
  # Pull latest images
  pull_images() {
    local services=$1
    log "Pulling images pour $services..."
    docker compose -f docker-compose.prod.yml pull $services
  }
  
  # Stop services gracefully
  stop_services() {
    local services=$1
    log "Arrêt des services : $services..."
    docker compose -f docker-compose.prod.yml stop $services
  }
  
  # Start services
  start_services() {
    local services=$1
    log "Démarrage des services : $services..."
    docker compose -f docker-compose.prod.yml up -d $services
  }
  
  # Restart services
  restart_services() {
    local services=$1
    stop_services "$services"
    start_services "$services"
  }
  
  # Cleanup old images
  cleanup_old_images() {
    log "Nettoyage des images Docker inutilisées..."
    docker image prune -f
    
    # Remove dangling images
    local dangling=$(docker images -f "dangling=true" -q)
    if [ -n "$dangling" ]; then
      log "Suppression de $(echo $dangling | wc -w) images orphelines..."
      docker rmi $dangling 2>/dev/null || true
    fi
    
    log "✅ Cleanup terminé"
  }
  
  # Get current image tag
  get_image_tag() {
    local service=$1
    docker compose -f docker-compose.prod.yml images $service | tail -n 1 | awk '{print $4}'
  }
  ```

### Phase 2 : Script Déploiement Frontend (30min)

- [ ] Créer `scripts/deploy/deploy-frontend.sh` :
  ```bash
  #!/bin/bash
  set -e
  
  SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
  source "$SCRIPT_DIR/lib/common.sh"
  source "$SCRIPT_DIR/lib/docker-utils.sh"
  
  log "=========================================="
  log "DÉPLOIEMENT FRONTEND"
  log "=========================================="
  
  # Check permissions
  check_permissions
  
  # Backup current state
  BACKUP_DIR=$(backup_state)
  
  # Save current frontend image
  PREVIOUS_IMAGE=$(get_image_tag frontend)
  log "Image actuelle : $PREVIOUS_IMAGE"
  
  # Pull new frontend image
  pull_images "frontend"
  
  # Stop frontend
  stop_services "frontend"
  
  # Clean .next cache (important!)
  log "Nettoyage du cache .next..."
  docker compose -f docker-compose.prod.yml run --rm frontend rm -rf .next || true
  
  # Start frontend
  start_services "frontend"
  
  # Health check
  if health_check "Frontend" "https://collectoria.example.com"; then
    log "=========================================="
    log "✅ DÉPLOIEMENT FRONTEND RÉUSSI"
    log "=========================================="
    
    # Cleanup old images
    cleanup_old_images
    
    exit 0
  else
    log_error "=========================================="
    log_error "❌ DÉPLOIEMENT FRONTEND ÉCHOUÉ"
    log_error "=========================================="
    log_error "Rollback recommandé : ./rollback.sh frontend $BACKUP_DIR"
    exit 1
  fi
  ```

### Phase 3 : Script Déploiement Backend (30min)

- [ ] Créer `scripts/deploy/deploy-backend.sh` :
  ```bash
  #!/bin/bash
  set -e
  
  SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
  source "$SCRIPT_DIR/lib/common.sh"
  source "$SCRIPT_DIR/lib/docker-utils.sh"
  
  log "=========================================="
  log "DÉPLOIEMENT BACKEND"
  log "=========================================="
  
  # Check permissions
  check_permissions
  
  # Backup current state
  BACKUP_DIR=$(backup_state)
  
  # Backup database
  log "Backup de la base de données..."
  docker exec collectoria-postgres pg_dump -U collectoria collection_management > "$BACKUP_DIR/db_backup.sql"
  log "✅ DB backup : $BACKUP_DIR/db_backup.sql"
  
  # Save current backend image
  PREVIOUS_IMAGE=$(get_image_tag backend-collection-management)
  log "Image actuelle : $PREVIOUS_IMAGE"
  
  # Pull new backend image
  pull_images "backend-collection-management"
  
  # Stop backend
  stop_services "backend-collection-management"
  
  # Apply migrations
  log "Application des migrations..."
  docker compose -f docker-compose.prod.yml run --rm backend-collection-management ./scripts/migrate.sh
  
  # Start backend
  start_services "backend-collection-management"
  
  # Health check
  if health_check "Backend" "https://api.collectoria.example.com/api/v1/health"; then
    log "=========================================="
    log "✅ DÉPLOIEMENT BACKEND RÉUSSI"
    log "=========================================="
    
    # Cleanup old images
    cleanup_old_images
    
    exit 0
  else
    log_error "=========================================="
    log_error "❌ DÉPLOIEMENT BACKEND ÉCHOUÉ"
    log_error "=========================================="
    log_error "Rollback recommandé : ./rollback.sh backend $BACKUP_DIR"
    log_error "DB backup disponible : $BACKUP_DIR/db_backup.sql"
    exit 1
  fi
  ```

### Phase 4 : Script Déploiement Full Stack (30min)

- [ ] Créer `scripts/deploy/deploy-full.sh` :
  ```bash
  #!/bin/bash
  set -e
  
  SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
  source "$SCRIPT_DIR/lib/common.sh"
  
  log "=========================================="
  log "DÉPLOIEMENT FULL STACK"
  log "=========================================="
  
  # Deploy backend first
  log "Étape 1/2 : Déploiement Backend..."
  if ! "$SCRIPT_DIR/deploy-backend.sh"; then
    log_error "Échec du déploiement backend. Arrêt."
    exit 1
  fi
  
  # Deploy frontend
  log "Étape 2/2 : Déploiement Frontend..."
  if ! "$SCRIPT_DIR/deploy-frontend.sh"; then
    log_error "Échec du déploiement frontend. Rollback recommandé."
    exit 1
  fi
  
  log "=========================================="
  log "✅ DÉPLOIEMENT FULL STACK RÉUSSI"
  log "=========================================="
  ```

### Phase 5 : Script Rollback (1h)

- [ ] Créer `scripts/deploy/rollback.sh` :
  ```bash
  #!/bin/bash
  set -e
  
  SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
  source "$SCRIPT_DIR/lib/common.sh"
  source "$SCRIPT_DIR/lib/docker-utils.sh"
  
  SERVICE=$1
  BACKUP_DIR=$2
  
  if [ -z "$SERVICE" ] || [ -z "$BACKUP_DIR" ]; then
    log_error "Usage: ./rollback.sh <frontend|backend|full> <backup_dir>"
    exit 1
  fi
  
  if [ ! -d "$BACKUP_DIR" ]; then
    log_error "Backup directory not found: $BACKUP_DIR"
    exit 1
  fi
  
  log "=========================================="
  log "ROLLBACK : $SERVICE"
  log "Backup : $BACKUP_DIR"
  log "=========================================="
  
  # Restore docker-compose.yml
  log "Restauration docker-compose.prod.yml..."
  cp "$BACKUP_DIR/docker-compose.prod.yml" docker-compose.prod.yml
  
  # Restore .env
  if [ -f "$BACKUP_DIR/.env.production" ]; then
    log "Restauration .env.production..."
    cp "$BACKUP_DIR/.env.production" .env.production
  fi
  
  case $SERVICE in
    frontend)
      log "Rollback frontend..."
      stop_services "frontend"
      pull_images "frontend"  # Pull l'ancienne version
      start_services "frontend"
      health_check "Frontend" "https://collectoria.example.com"
      ;;
      
    backend)
      log "Rollback backend..."
      
      # Ask for DB restore
      read -p "Restaurer la base de données depuis $BACKUP_DIR/db_backup.sql ? (y/N) " -n 1 -r
      echo
      if [[ $REPLY =~ ^[Yy]$ ]]; then
        log "Restauration de la base de données..."
        cat "$BACKUP_DIR/db_backup.sql" | docker exec -i collectoria-postgres psql -U collectoria collection_management
        log "✅ DB restaurée"
      fi
      
      stop_services "backend-collection-management"
      pull_images "backend-collection-management"
      start_services "backend-collection-management"
      health_check "Backend" "https://api.collectoria.example.com/api/v1/health"
      ;;
      
    full)
      log "Rollback full stack..."
      "$SCRIPT_DIR/rollback.sh" backend "$BACKUP_DIR"
      "$SCRIPT_DIR/rollback.sh" frontend "$BACKUP_DIR"
      ;;
      
    *)
      log_error "Service invalide: $SERVICE (frontend|backend|full)"
      exit 1
      ;;
  esac
  
  log "=========================================="
  log "✅ ROLLBACK RÉUSSI"
  log "=========================================="
  ```

### Phase 6 : Scripts Auxiliaires (30min)

- [ ] Créer `scripts/deploy/health-check.sh` :
  ```bash
  #!/bin/bash
  
  SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
  source "$SCRIPT_DIR/lib/common.sh"
  source "$SCRIPT_DIR/lib/docker-utils.sh"
  
  log "=========================================="
  log "HEALTH CHECK PRODUCTION"
  log "=========================================="
  
  # Check Docker services
  log "Services Docker..."
  docker compose -f docker-compose.prod.yml ps
  
  # Check backend
  health_check "Backend" "https://api.collectoria.example.com/api/v1/health"
  
  # Check frontend
  health_check "Frontend" "https://collectoria.example.com"
  
  # Check database
  log "PostgreSQL..."
  if docker exec collectoria-postgres pg_isready -U collectoria; then
    log "✅ PostgreSQL : OK"
  else
    log_error "❌ PostgreSQL : KO"
  fi
  
  log "=========================================="
  log "✅ HEALTH CHECK TERMINÉ"
  log "=========================================="
  ```

- [ ] Créer `scripts/deploy/cleanup-images.sh` :
  ```bash
  #!/bin/bash
  
  SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
  source "$SCRIPT_DIR/lib/docker-utils.sh"
  
  cleanup_old_images
  ```

### Phase 7 : Tests et Documentation (1h)

**Tests Locaux (sur environnement de staging si disponible)** :
- [ ] Tester `deploy-frontend.sh`
- [ ] Tester `deploy-backend.sh`
- [ ] Tester `deploy-full.sh`
- [ ] Tester `rollback.sh` (frontend, backend, full)
- [ ] Tester `health-check.sh`
- [ ] Vérifier création des backups
- [ ] Vérifier logs de déploiement

**Documentation** :
- [ ] Créer `/DevOps/DEPLOYMENT.md` :
  ```markdown
  # Guide de Déploiement Production
  
  ## Scripts Disponibles
  
  ### Déploiement Frontend Uniquement
  ```bash
  cd /path/to/Collectoria
  sudo ./scripts/deploy/deploy-frontend.sh
  ```
  
  ### Déploiement Backend Uniquement
  ```bash
  sudo ./scripts/deploy/deploy-backend.sh
  ```
  
  ### Déploiement Full Stack
  ```bash
  sudo ./scripts/deploy/deploy-full.sh
  ```
  
  ### Rollback
  ```bash
  sudo ./scripts/deploy/rollback.sh <frontend|backend|full> <backup_dir>
  ```
  
  ### Health Check
  ```bash
  ./scripts/deploy/health-check.sh
  ```
  
  ## Workflow Typique
  
  1. Vérifier état actuel
     ```bash
     ./scripts/deploy/health-check.sh
     ```
  
  2. Déployer
     ```bash
     sudo ./scripts/deploy/deploy-frontend.sh  # ou backend, ou full
     ```
  
  3. En cas d'échec, rollback
     ```bash
     sudo ./scripts/deploy/rollback.sh frontend .deployment/backups/<timestamp>
     ```
  
  ## Backups
  
  Chaque déploiement crée automatiquement un backup dans `.deployment/backups/`.
  
  Contenu :
  - `docker-compose.prod.yml`
  - `.env.production`
  - `images.txt` (tags Docker actuels)
  - `db_backup.sql` (si déploiement backend)
  ```

---

## Critères d'Acceptation

- [ ] Scripts frontend, backend, full stack créés
- [ ] Script rollback créé et testé
- [ ] Fonctions communes factorisées dans `lib/`
- [ ] Health checks automatiques après déploiement
- [ ] Backups automatiques avant chaque déploiement
- [ ] Cleanup automatique des anciennes images Docker
- [ ] Gestion des erreurs (exit 1 si échec)
- [ ] Logs colorés et horodatés
- [ ] Documentation complète dans `/DevOps/DEPLOYMENT.md`
- [ ] Scripts testés en staging/local

---

## Workflow de Déploiement

```
┌─────────────────────────────────────────────────────┐
│                   DÉPLOIEMENT                       │
├─────────────────────────────────────────────────────┤
│                                                     │
│  1. Check permissions                               │
│  2. Backup state (docker-compose, .env, DB)         │
│  3. Pull new images                                 │
│  4. Stop services                                   │
│  5. Apply migrations (si backend)                   │
│  6. Clean cache (si frontend)                       │
│  7. Start services                                  │
│  8. Health check                                    │
│  9. Cleanup old images                              │
│                                                     │
│  ┌─────────────────────────────────────┐            │
│  │  SUCCÈS ?                           │            │
│  └─────────────────────────────────────┘            │
│         │                     │                     │
│         │ OUI                 │ NON                 │
│         ▼                     ▼                     │
│   ✅ Terminé            ❌ Rollback recommandé      │
│                                                     │
└─────────────────────────────────────────────────────┘
```

---

## Risques & Mitigations

**Risque 1** : Downtime prolongé si déploiement échoue
→ **Mitigation** : Rollback automatique, backup avant déploiement

**Risque 2** : Migration DB échoue, données corrompues
→ **Mitigation** : Backup DB automatique avant chaque déploiement backend

**Risque 3** : Health check passe mais service non fonctionnel
→ **Mitigation** : Health checks exhaustifs (backend, frontend, DB)

**Risque 4** : Script exécuté sans permissions suffisantes
→ **Mitigation** : Check permissions au démarrage

**Risque 5** : Anciennes images Docker saturent le disque
→ **Mitigation** : Cleanup automatique après déploiement réussi

---

## Références

- Docker Compose Prod : `/DevOps/docker-compose.prod.yml`
- Architecture Backend : `/Backend/ARCHITECTURE.md`
- Configuration Traefik : `/DevOps/traefik.yml`

---

## Notes

### Améliorations Futures

**Phase 2 (après stabilisation)** :
- [ ] Notifications Slack/Discord après déploiement
- [ ] Intégration CI/CD (GitHub Actions)
- [ ] Blue-Green deployment (zéro downtime)
- [ ] Smoke tests automatiques post-déploiement
- [ ] Monitoring Prometheus/Grafana
- [ ] Alerting si health check échoue

### Checklist Pré-Déploiement

Avant TOUT déploiement en production :
- [ ] Tests passés en local/staging
- [ ] Commit + push vers git (traçabilité)
- [ ] Health check production OK
- [ ] Backup DB récent disponible
- [ ] Temps de maintenance annoncé (si nécessaire)

### Checklist Post-Déploiement

Après TOUT déploiement en production :
- [ ] Health check production OK
- [ ] Tester manuellement les fonctionnalités principales
- [ ] Vérifier les logs (pas d'erreurs)
- [ ] Cleanup des anciennes images Docker
- [ ] Documenter le déploiement (changelog)

---

**Prochaines Actions** :
1. Phase 1-2 : Fonctions communes + frontend (Agent DevOps)
2. Phase 3-4 : Backend + full stack (Agent DevOps)
3. Phase 5-6 : Rollback + auxiliaires (Agent DevOps)
4. Phase 7 : Tests + documentation (Agent DevOps)
