# Procédures de Redémarrage - DevOps

**Référence** : Ce document est extrait de `DevOps/CLAUDE.md` pour améliorer la lisibilité.

---

## Redémarrage après Changement de Configuration

### Quand Redémarrer l'Environnement Complet

Un redémarrage complet (clean restart) est nécessaire après :

1. **Changements de configuration CORS**
   - Modification des `CORS_ALLOWED_ORIGINS`
   - Ajout/suppression de méthodes HTTP (GET, POST, PATCH, DELETE)
   - Modification des headers autorisés

2. **Changements de variables d'environnement**
   - Configuration de la base de données
   - Paramètres de logging
   - URLs de services externes

3. **Modifications de l'infrastructure HTTP**
   - Changements dans le middleware
   - Nouvelle configuration de routeur
   - Modifications de la gestion des sessions

---

## Procédure de Redémarrage Propre

### Méthode Automatique (Recommandée)

```bash
# Depuis le répertoire backend/collection-management
make restart

# Ou directement
./scripts/restart-local.sh
```

Le script `restart-local.sh` effectue automatiquement :
1. Arrêt propre de tous les services (frontend + backend)
2. Nettoyage du cache frontend (.next/)
3. Vérification de PostgreSQL
4. Redémarrage du backend avec les variables d'environnement
5. Redémarrage du frontend
6. Vérifications de santé (health checks)
7. Rapport détaillé avec les ports utilisés

---

### Méthode Manuelle (Pour Débogage)

```bash
# 1. Arrêt des services
pkill -f "next-server"
pkill -f "go run"
lsof -ti :8080 | xargs -r kill -9  # Force kill port 8080 si nécessaire

# 2. Nettoyage cache frontend
rm -rf ~/git/Collectoria/frontend/.next

# 3. Vérification PostgreSQL
docker ps | grep collectoria-collection-db
docker exec collectoria-collection-db pg_isready -U collectoria

# 4. Redémarrage backend
cd ~/git/Collectoria/backend/collection-management
DB_HOST=localhost \
DB_PORT=5432 \
DB_USER=collectoria \
DB_PASSWORD=collectoria \
DB_NAME=collection_management \
DB_SSLMODE=disable \
CORS_ALLOWED_ORIGINS="http://localhost:3000,http://localhost:3001" \
ENV=development \
LOG_LEVEL=info \
JWT_SECRET=collectoria-super-secret-jwt-key-64-chars-minimum-for-security-ok \
JWT_EXPIRATION_HOURS=24 \
JWT_ISSUER=collectoria-api \
nohup go run cmd/api/main.go > /tmp/backend-collectoria.log 2>&1 &

# Attendre que le backend compile et démarre (~10s)
sleep 10
curl http://localhost:8080/api/v1/health

# 5. Redémarrage frontend
cd ~/git/Collectoria/frontend
nohup npm run dev > /tmp/frontend-collectoria.log 2>&1 &

# Attendre 10 secondes puis vérifier
sleep 10
curl -s -o /dev/null -w "%{http_code}" http://localhost:3000
```

---

## Vérifications Post-Redémarrage

### Backend

```bash
# Health check
curl http://localhost:8080/api/v1/health

# Logs
tail -f /tmp/backend-collectoria.log
```

---

### Frontend

```bash
# Accessibilité
curl -I http://localhost:3000

# Port utilisé (si différent de 3000)
lsof -i :3000 -i :3001 | grep LISTEN

# Logs
tail -f /tmp/frontend-collectoria.log
```

---

### PostgreSQL

```bash
sg docker -c "docker ps | grep postgres"
sg docker -c "docker exec collectoria-collection-db pg_isready -U collectoria"
```

---

## Nettoyage du Cache Navigateur

Après un redémarrage, **toujours demander à l'utilisateur** de :
- **Chrome/Edge** : Ctrl+Shift+R (Windows/Linux) ou Cmd+Shift+R (Mac)
- **Firefox** : Ctrl+F5 (Windows/Linux) ou Cmd+Shift+R (Mac)

Le cache navigateur peut conserver les anciennes réponses CORS même après le redémarrage du backend.

---

## Problèmes Courants et Solutions

### Port 8080 déjà utilisé

```bash
# Identifier le processus
lsof -i :8080

# Tuer le processus
lsof -ti :8080 | xargs -r kill -9
```

---

### PostgreSQL non démarré

```bash
# Vérifier les containers
sg docker -c "docker ps -a | grep postgres"

# Redémarrer le bon container
sg docker -c "docker start collectoria-collection-db"
```

---

### Frontend ne démarre pas

```bash
# Vérifier les logs
tail -20 /tmp/frontend-collectoria.log

# Nettoyer et relancer
cd /home/arnaud.dars/git/Collectoria/frontend
rm -rf .next node_modules/.cache
npm run dev
```

---

### Cache Next.js Corrompu (Problème Récurrent)

**Symptômes** :
```
Error: ENOENT: no such file or directory, open '.next/_buildManifest.js.tmp.*'
Error: Failed to load app-build-manifest.json
Internal Server Error (HTTP 500) sur localhost:3000
Module not found: Can't resolve 'component/path'
```

**Cause** : Le cache Next.js se corrompt après des modifications importantes du frontend :
- Suppression/ajout de composants React
- Modification de pages (`page.tsx`, `layout.tsx`)
- Refactoring de structure
- Modifications massives (≥3 fichiers)

**Solution Complète** :

```bash
# 1. Arrêter le frontend
pkill -f "next-server"

# 2. Nettoyer le cache .next
cd /home/arnaud.dars/git/Collectoria/frontend
rm -rf .next

# 3. Optionnel : Nettoyer aussi node_modules cache
rm -rf node_modules/.cache

# 4. Redémarrer proprement
npm run dev > /tmp/frontend-collectoria.log 2>&1 &

# 5. Attendre compilation initiale (8s minimum)
sleep 8

# 6. Vérifier
curl -s http://localhost:3000 -o /dev/null -w "%{http_code}\n"
# Attendu : 200

# 7. Vérifier les logs si erreur
tail -f /tmp/frontend-collectoria.log
```

**Quand l'appliquer** :
- ✅ Après modifications structurelles du frontend
- ✅ Après suppression de composants
- ✅ Dès apparition des symptômes ci-dessus
- ✅ En cas de doute après refactoring

**Temps de résolution** : ~15 secondes  
**Taux de succès** : 100%

**Workflow automatique** : Alfred nettoie automatiquement le cache après modifications importantes. Voir `/CLAUDE.md` section "Gestion du Cache Next.js".

**Référence détaillée** : `Continuous-Improvement/recommendations/workflow-nextjs-cache-cleanup_2026-04-24.md`

---

*Document extrait de DevOps/CLAUDE.md le 2026-04-23*  
*Section Cache Next.js ajoutée le 2026-04-24*
