# Collectoria Deployment Scripts

This directory contains automated deployment and maintenance scripts for Collectoria production infrastructure.

## Overview

```
scripts/
├── deploy/               # Deployment scripts
│   ├── deploy-backend.sh       # Deploy backend service
│   ├── deploy-frontend.sh      # Deploy frontend service
│   ├── deploy-full.sh          # Full deployment (both services)
│   └── rollback.sh             # Rollback to previous versions
│
├── infrastructure/       # Infrastructure management
│   ├── health-check.sh         # Comprehensive health checks
│   ├── restart-traefik.sh      # Restart Traefik proxy
│   └── restart-postgres.sh     # Restart PostgreSQL (DANGEROUS)
│
├── database/            # Database operations
│   ├── backup-db.sh            # Create database backups
│   ├── restore-db.sh           # Restore from backup
│   └── migrate-db.sh           # Apply SQL migrations
│
├── maintenance/         # Maintenance and cleanup
│   └── cleanup.sh              # Docker cleanup and optimization
│
└── lib/                 # Shared libraries
    ├── common.sh               # Common functions (logging, checks)
    └── docker-utils.sh         # Docker utilities
```

## Quick Start

### Standard Deployment

```bash
# Deploy both frontend and backend
./scripts/deploy/deploy-full.sh

# Deploy backend only
./scripts/deploy/deploy-backend.sh

# Deploy frontend only
./scripts/deploy/deploy-frontend.sh
```

### Health Check

```bash
# Run comprehensive health check
./scripts/infrastructure/health-check.sh

# Detailed health check
./scripts/infrastructure/health-check.sh --verbose

# JSON output for monitoring
./scripts/infrastructure/health-check.sh --json
```

### Database Backup

```bash
# Create backup
./scripts/database/backup-db.sh

# Create backup with verification
./scripts/database/backup-db.sh --verify

# List available backups
./scripts/database/restore-db.sh --list
```

### Cleanup

```bash
# Standard cleanup
./scripts/maintenance/cleanup.sh

# Preview cleanup (dry-run)
./scripts/maintenance/cleanup.sh --dry-run

# Aggressive cleanup (frees more space)
./scripts/maintenance/cleanup.sh --aggressive
```

## Deployment Scripts

### deploy-backend.sh

Deploys the Go backend service with automatic health checks and rollback.

**Options:**
- `--no-cache` - Force Docker build without cache
- `--skip-tests` - Skip Go tests (not recommended)
- `--skip-pull` - Skip git pull (use current code)
- `--dry-run` - Preview actions without executing
- `--keep-images N` - Keep N latest images (default: 2)

**Examples:**
```bash
# Standard deployment
./deploy-backend.sh

# Force rebuild without cache
./deploy-backend.sh --no-cache

# Quick deployment (skip tests and git pull)
./deploy-backend.sh --skip-tests --skip-pull

# Preview deployment
./deploy-backend.sh --dry-run
```

**Features:**
- Git pull from main branch
- Run Go tests before deployment
- Build Docker image
- Stop old container
- Start new container
- Health check with automatic rollback on failure
- Cleanup old images (keeps 2 latest)
- Deployment logging

### deploy-frontend.sh

Deploys the Next.js frontend service with health checks.

**Options:**
- `--no-cache` - Force Docker build without cache
- `--clean-cache` - Clean .next cache before build
- `--skip-pull` - Skip git pull
- `--dry-run` - Preview actions
- `--keep-images N` - Keep N latest images (default: 2)

**Examples:**
```bash
# Standard deployment
./deploy-frontend.sh

# Clean cache and rebuild
./deploy-frontend.sh --clean-cache

# Force complete rebuild
./deploy-frontend.sh --no-cache --clean-cache
```

### deploy-full.sh

Orchestrates full deployment of both services with coordinated health checks.

**Options:**
- `--no-cache` - Force rebuild for both services
- `--skip-tests` - Skip backend tests
- `--skip-pull` - Skip git pull
- `--dry-run` - Preview actions
- `--backend-only` - Deploy only backend
- `--frontend-only` - Deploy only frontend

**Examples:**
```bash
# Full deployment
./deploy-full.sh

# Deploy with fresh rebuild
./deploy-full.sh --no-cache

# Backend only
./deploy-full.sh --backend-only
```

### rollback.sh

Rollback services to previous Docker image versions.

**Options:**
- `--backend` - Rollback backend only
- `--frontend` - Rollback frontend only
- `--both` - Rollback both services (default)
- `--to-tag TAG` - Rollback to specific tag
- `--yes` - Skip confirmation prompts

**Examples:**
```bash
# Interactive rollback (both services)
./rollback.sh

# Rollback backend to specific version
./rollback.sh --backend --to-tag v1.2.3

# Rollback frontend without confirmation
./rollback.sh --frontend --yes
```

## Infrastructure Scripts

### health-check.sh

Comprehensive health check for all services.

**Options:**
- `--verbose` - Show detailed information
- `--json` - Output results in JSON format
- `--fail-fast` - Exit on first failure

**Examples:**
```bash
# Standard health check
./health-check.sh

# Detailed check
./health-check.sh --verbose

# For monitoring systems
./health-check.sh --json
```

**Checks:**
- Traefik (HTTP/HTTPS)
- Backend (container + health endpoint)
- Frontend (container + HTTP)
- PostgreSQL (container + pg_isready)
- SSL certificate expiration
- Disk space
- External endpoints (darsling.fr, api.darsling.fr)

### restart-traefik.sh

Restarts Traefik reverse proxy with health checks.

**Options:**
- `--skip-pull` - Skip git pull
- `--force` - Skip confirmation

**Examples:**
```bash
# Standard restart
./restart-traefik.sh

# Restart without updating config
./restart-traefik.sh --skip-pull
```

### restart-postgres.sh

Restarts PostgreSQL database (DANGEROUS - causes downtime).

**Options:**
- `--force` - Skip confirmation prompts
- `--backup` - Create backup before restart

**Examples:**
```bash
# Restart with confirmation
./restart-postgres.sh

# Restart with backup
./restart-postgres.sh --backup
```

**WARNING:** This causes downtime for all services. Use only when absolutely necessary.

## Database Scripts

### backup-db.sh

Creates compressed database backups with rotation policy.

**Options:**
- `--output DIR` - Custom output directory
- `--skip-confirm` - Skip confirmation
- `--no-rotation` - Keep all backups
- `--verify` - Verify backup integrity
- `--remote-sync` - Sync to remote (if configured)

**Examples:**
```bash
# Standard backup
./backup-db.sh

# Backup with verification
./backup-db.sh --verify

# Custom output location
./backup-db.sh --output /tmp/backups
```

**Rotation Policy:**
- Daily: Keep 7 days
- Weekly: Keep 4 weeks
- Monthly: Keep 3 months

### restore-db.sh

Restores database from backup (DESTRUCTIVE).

**Options:**
- `--file FILE` - Specific backup file to restore
- `--force` - Skip all confirmations (DANGEROUS)
- `--no-backup` - Skip safety backup before restore
- `--list` - List available backups

**Examples:**
```bash
# Interactive restore
./restore-db.sh

# List available backups
./restore-db.sh --list

# Restore specific backup
./restore-db.sh --file /path/to/backup.sql.gz
```

**WARNING:** This replaces ALL database data. Creates safety backup by default.

### migrate-db.sh

Applies SQL migrations from migrations directory.

**Options:**
- `--dry-run` - Preview migrations
- `--force` - Apply even if already applied
- `--single FILE` - Apply specific migration
- `--rollback` - Rollback last migration

**Examples:**
```bash
# Apply pending migrations
./migrate-db.sh

# Preview migrations
./migrate-db.sh --dry-run

# Apply specific migration
./migrate-db.sh --single 003_add_rarity.sql

# Rollback last migration
./migrate-db.sh --rollback
```

**Migration Files:**
- Format: `NNN_description.sql` (e.g., `001_initial_schema.sql`)
- Optional rollback: `NNN_description.down.sql`
- Applied in numerical order

## Maintenance Scripts

### cleanup.sh

Cleans up Docker resources and logs to free disk space.

**Options:**
- `--aggressive` - Remove unused images (more space freed)
- `--dry-run` - Preview cleanup
- `--force` - Skip confirmations
- `--logs-only` - Clean only logs (safest)
- `--images-only` - Clean only images

**Examples:**
```bash
# Standard cleanup
./cleanup.sh

# Preview what would be cleaned
./cleanup.sh --dry-run

# Aggressive cleanup (more space)
./cleanup.sh --aggressive

# Safe cleanup (logs only)
./cleanup.sh --logs-only
```

**Cleanup Policy:**
- Dangling images: Always removed
- Stopped containers >48h: Removed
- Logs >7 days: Removed
- Unused volumes: Requires confirmation
- Unused images: Only with `--aggressive`
- Deployment logs >30 days: Removed
- Database backups >90 days: Removed

## Environment Variables

All scripts support environment variable configuration:

```bash
# Project configuration
export PROJECT_DIR="/home/collectoria/Collectoria"
export COMPOSE_FILE="$PROJECT_DIR/docker-compose.prod.yml"

# Database configuration
export DB_CONTAINER="collectoria-postgres"
export DB_USER="collectoria"
export DB_NAME="collectoria"

# Backup configuration
export BACKUP_DIR="/home/collectoria/backups"

# Run script with custom config
PROJECT_DIR=/custom/path ./deploy-full.sh
```

## Common Workflows

### Complete Deployment

```bash
# 1. Check current health
./scripts/infrastructure/health-check.sh --verbose

# 2. Create backup (safety)
./scripts/database/backup-db.sh --verify

# 3. Deploy both services
./scripts/deploy/deploy-full.sh

# 4. Verify deployment
./scripts/infrastructure/health-check.sh --verbose
```

### Emergency Rollback

```bash
# 1. Rollback to previous version
./scripts/deploy/rollback.sh

# 2. Check health
./scripts/infrastructure/health-check.sh

# 3. If still broken, restore database
./scripts/database/restore-db.sh --list
./scripts/database/restore-db.sh --file <backup_file>
```

### Weekly Maintenance

```bash
# 1. Create backup
./scripts/database/backup-db.sh --verify

# 2. Cleanup old resources
./scripts/maintenance/cleanup.sh

# 3. Health check
./scripts/infrastructure/health-check.sh --verbose
```

### Database Migration

```bash
# 1. Backup database
./scripts/database/backup-db.sh --verify

# 2. Preview migrations
./scripts/database/migrate-db.sh --dry-run

# 3. Apply migrations
./scripts/database/migrate-db.sh

# 4. Verify backend still works
./scripts/infrastructure/health-check.sh
```

## Monitoring Integration

### Cron Jobs

Example cron configuration for automated operations:

```cron
# Daily backup at 2 AM
0 2 * * * /home/collectoria/Collectoria/scripts/database/backup-db.sh --skip-confirm --verify >> /var/log/collectoria-backup.log 2>&1

# Weekly cleanup on Sunday at 3 AM
0 3 * * 0 /home/collectoria/Collectoria/scripts/maintenance/cleanup.sh --force >> /var/log/collectoria-cleanup.log 2>&1

# Health check every 5 minutes (for monitoring)
*/5 * * * * /home/collectoria/Collectoria/scripts/infrastructure/health-check.sh --json > /tmp/collectoria-health.json 2>&1
```

### Prometheus/Grafana

Use health-check.sh with `--json` output for metrics collection:

```bash
./scripts/infrastructure/health-check.sh --json | jq .
```

## Troubleshooting

### Deployment Failed

```bash
# 1. Check logs
docker logs collectoria-backend
docker logs collectoria-frontend

# 2. Check health
./scripts/infrastructure/health-check.sh --verbose

# 3. Rollback if needed
./scripts/deploy/rollback.sh
```

### Low Disk Space

```bash
# 1. Check current usage
./scripts/maintenance/cleanup.sh --dry-run

# 2. Aggressive cleanup
./scripts/maintenance/cleanup.sh --aggressive

# 3. Manual check
docker system df
df -h
```

### Database Issues

```bash
# 1. Check PostgreSQL is running
docker ps | grep postgres

# 2. Check logs
docker logs collectoria-postgres

# 3. Test connection
docker exec collectoria-postgres pg_isready -U collectoria

# 4. Restore from backup if needed
./scripts/database/restore-db.sh --list
```

## Safety Features

All scripts include:

- **Permission checks** - Ensures proper Docker permissions
- **Confirmation prompts** - For destructive operations
- **Dry-run mode** - Preview actions without executing
- **Health checks** - Verify services after changes
- **Automatic rollback** - On deployment failures
- **Detailed logging** - All operations logged with timestamps
- **Deployment history** - Track all deployments in `.deployment/history/`

## Security

- No hardcoded credentials
- Environment variable configuration
- Confirmation for dangerous operations
- Deployment logs saved securely
- Backup verification available

## Support

For issues or questions:

1. Check logs in `.deployment/history/`
2. Run health check: `./scripts/infrastructure/health-check.sh --verbose`
3. Review Docker logs: `docker logs <container_name>`
4. Check project documentation: `/home/arnaud.dars/git/Collectoria/DEPLOYMENT.md`

## Version

Scripts version: 1.0.0
Last updated: 2026-05-05
