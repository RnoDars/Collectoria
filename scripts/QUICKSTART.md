# Collectoria Deployment Scripts - Quick Start Guide

## First Time Setup

### 1. On Production Server (collectoria@51.159.161.31)

```bash
# Clone or update repository
cd /home/collectoria
git clone <repo-url> Collectoria
# OR
cd Collectoria && git pull

# Make scripts executable (if not already)
chmod +x scripts/**/*.sh

# Verify Docker permissions
docker ps
# If error, add user to docker group:
# sudo usermod -aG docker collectoria
# Then logout/login
```

### 2. Create Backup Directory

```bash
mkdir -p /home/collectoria/backups
```

### 3. Test Health Check

```bash
cd /home/collectoria/Collectoria
./scripts/infrastructure/health-check.sh --verbose
```

## Common Operations

### Deploy Updates

```bash
cd /home/collectoria/Collectoria

# Full deployment (frontend + backend)
./scripts/deploy/deploy-full.sh

# Backend only
./scripts/deploy/deploy-backend.sh

# Frontend only
./scripts/deploy/deploy-frontend.sh
```

### Create Backup

```bash
# Standard backup with verification
./scripts/database/backup-db.sh --verify

# Quick backup (no verification)
./scripts/database/backup-db.sh --skip-confirm
```

### Check System Health

```bash
# Quick check
./scripts/infrastructure/health-check.sh

# Detailed check with all information
./scripts/infrastructure/health-check.sh --verbose

# JSON output for monitoring
./scripts/infrastructure/health-check.sh --json
```

### Emergency Rollback

```bash
# Interactive rollback (select version)
./scripts/deploy/rollback.sh

# Rollback backend to specific version
./scripts/deploy/rollback.sh --backend --to-tag <version>

# Rollback both services
./scripts/deploy/rollback.sh --both
```

### Cleanup Disk Space

```bash
# Standard cleanup
./scripts/maintenance/cleanup.sh

# Preview cleanup (safe)
./scripts/maintenance/cleanup.sh --dry-run

# Aggressive cleanup (frees more space)
./scripts/maintenance/cleanup.sh --aggressive
```

## Recommended Workflows

### Standard Deployment Workflow

```bash
# 1. Check current health
./scripts/infrastructure/health-check.sh --verbose

# 2. Create backup (safety)
./scripts/database/backup-db.sh --verify

# 3. Deploy
./scripts/deploy/deploy-full.sh

# 4. Verify deployment
./scripts/infrastructure/health-check.sh --verbose

# 5. Check application
curl https://api.darsling.fr/api/v1/health
curl https://darsling.fr
```

### If Deployment Fails

```bash
# 1. Check what went wrong
./scripts/infrastructure/health-check.sh --verbose

# 2. Rollback to previous version
./scripts/deploy/rollback.sh

# 3. Check health again
./scripts/infrastructure/health-check.sh

# 4. If still broken, restore database
./scripts/database/restore-db.sh --list
./scripts/database/restore-db.sh --file <backup_file>
```

### Weekly Maintenance

```bash
# Run every Sunday at 3 AM (via cron)

# 1. Create backup
./scripts/database/backup-db.sh --verify --skip-confirm

# 2. Cleanup old resources
./scripts/maintenance/cleanup.sh --force

# 3. Health check
./scripts/infrastructure/health-check.sh --verbose
```

## Setup Automation

### Cron Jobs

Add to crontab (`crontab -e`):

```cron
# Daily backup at 2 AM
0 2 * * * /home/collectoria/Collectoria/scripts/database/backup-db.sh --skip-confirm --verify >> /var/log/collectoria-backup.log 2>&1

# Weekly cleanup on Sunday at 3 AM
0 3 * * 0 /home/collectoria/Collectoria/scripts/maintenance/cleanup.sh --force >> /var/log/collectoria-cleanup.log 2>&1

# Health check every 5 minutes
*/5 * * * * /home/collectoria/Collectoria/scripts/infrastructure/health-check.sh --json > /tmp/collectoria-health.json 2>&1
```

### Log Rotation

Create `/etc/logrotate.d/collectoria`:

```
/var/log/collectoria-*.log {
    weekly
    rotate 4
    compress
    delaycompress
    missingok
    notifempty
}
```

## Troubleshooting

### "Permission denied" Error

```bash
# Check Docker group membership
groups

# If not in docker group, add yourself
sudo usermod -aG docker $USER

# Logout and login again, or:
newgrp docker
```

### Scripts Not Executable

```bash
chmod +x scripts/**/*.sh
# OR
find scripts -name "*.sh" -exec chmod +x {} \;
```

### "Container not found" Error

```bash
# Check running containers
docker ps

# Check all containers (including stopped)
docker ps -a

# Check docker-compose services
cd /home/collectoria/Collectoria
docker-compose -f docker-compose.prod.yml ps
```

### Health Check Fails

```bash
# Check individual services
docker logs collectoria-backend
docker logs collectoria-frontend
docker logs collectoria-postgres

# Check ports
netstat -tulpn | grep -E ':(80|443|3000|8080|5432)'

# Restart services if needed
docker-compose -f docker-compose.prod.yml restart
```

### Low Disk Space

```bash
# Check disk usage
df -h
docker system df

# Cleanup
./scripts/maintenance/cleanup.sh --aggressive

# Check Docker volumes
docker volume ls
docker volume prune
```

## Safety Tips

1. **Always create backups before major changes**
   ```bash
   ./scripts/database/backup-db.sh --verify
   ```

2. **Use dry-run to preview actions**
   ```bash
   ./scripts/deploy/deploy-full.sh --dry-run
   ./scripts/maintenance/cleanup.sh --dry-run
   ```

3. **Check health before and after deployments**
   ```bash
   ./scripts/infrastructure/health-check.sh --verbose
   ```

4. **Keep deployment logs**
   - Logs are automatically saved in `.deployment/history/`
   - Review logs: `ls -lh .deployment/history/`

5. **Test rollback procedure regularly**
   ```bash
   # In a maintenance window:
   ./scripts/deploy/rollback.sh
   # Then redeploy
   ./scripts/deploy/deploy-full.sh
   ```

## Getting Help

### Check Script Documentation

```bash
# All scripts support --help or show usage on error
./scripts/deploy/deploy-full.sh --help

# Read detailed README
cat scripts/README.md
```

### Check Logs

```bash
# Deployment history
ls -lh .deployment/history/
cat .deployment/history/<latest>.log

# Docker logs
docker logs collectoria-backend --tail 100
docker logs collectoria-frontend --tail 100
docker logs collectoria-postgres --tail 100
```

### Verify Configuration

```bash
# Check Docker Compose config
docker-compose -f docker-compose.prod.yml config

# Check environment
cat .env.production
```

## Quick Reference

| Task | Command |
|------|---------|
| Deploy everything | `./scripts/deploy/deploy-full.sh` |
| Deploy backend only | `./scripts/deploy/deploy-backend.sh` |
| Deploy frontend only | `./scripts/deploy/deploy-frontend.sh` |
| Rollback | `./scripts/deploy/rollback.sh` |
| Health check | `./scripts/infrastructure/health-check.sh` |
| Create backup | `./scripts/database/backup-db.sh --verify` |
| Restore backup | `./scripts/database/restore-db.sh --list` |
| Cleanup disk | `./scripts/maintenance/cleanup.sh` |
| Apply migrations | `./scripts/database/migrate-db.sh` |
| Restart Traefik | `./scripts/infrastructure/restart-traefik.sh` |

## Next Steps

1. Set up automated backups (cron)
2. Configure monitoring (health-check.sh with Prometheus)
3. Test rollback procedure
4. Review and customize scripts for your needs
5. Set up alerting for failed deployments

For detailed documentation, see [scripts/README.md](README.md)
