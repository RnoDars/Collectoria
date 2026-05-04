# Recommandation : Checklist de Déploiement Production

**Date** : 2026-05-04  
**Agent** : Amélioration Continue  
**Priorité** : HAUTE  
**Impact** : Réduction 70% temps diagnostic déploiement

---

## Contexte

**Problèmes rencontrés (session 2026-05-04)** :
1. Variables NEXT_PUBLIC_* non injectées au build (1h perdue)
2. Espace disque saturé pendant rebuild (15 min perdues)
3. Extension PostgreSQL `unaccent` manquante en production (1h perdue)
4. Fichier .env avec placeholders vides (30 min perdues)
5. Container frontend pas redémarré après rebuild (10 min perdues)

**Total temps perdu** : ~3h de diagnostic évitable

---

## Checklist de Déploiement Production

### AVANT Déploiement

#### 1. Synchronisation Code
- [ ] `git pull origin main` sur le serveur
- [ ] Vérifier aucun conflit : `git status`
- [ ] Vérifier branche correcte : `git branch`

#### 2. Variables d'Environnement
- [ ] Fichier `.env` présent à la racine
- [ ] **AUCUN placeholder** vide (DB_USER, DB_PASSWORD, JWT_SECRET)
- [ ] Variables NEXT_PUBLIC_* définies dans docker-compose.prod.yml `build.args`
- [ ] Vérification rapide :
  ```bash
  grep -E "^[A-Z_]+=$" .env
  # Doit retourner 0 résultat (aucune variable vide)
  ```

#### 3. Ressources Système
- [ ] Espace disque > 2 GB disponible :
  ```bash
  df -h /
  # Vérifier Available > 2.0G
  ```
- [ ] Nettoyage cache Docker si nécessaire :
  ```bash
  docker system df
  docker builder prune -f  # Si Build Cache > 2GB
  ```

#### 4. Extensions PostgreSQL
- [ ] Fichier `backend/collection-management/migrations/000_extensions.sql` présent
- [ ] Extensions requises documentées (voir recommandation dédiée)

#### 5. Build Args Next.js
- [ ] Variables NEXT_PUBLIC_* présentes dans `docker-compose.prod.yml` section `frontend.build.args`
- [ ] Valeurs cohérentes entre `build.args` et `environment`

---

### PENDANT Déploiement

#### 1. Build des Images
- [ ] Backend :
  ```bash
  docker compose -f docker-compose.prod.yml build --no-cache backend-collection
  ```
- [ ] Frontend :
  ```bash
  docker compose -f docker-compose.prod.yml build --no-cache frontend
  ```
- [ ] Vérifier aucune erreur de build dans les logs

#### 2. Démarrage des Services
- [ ] Ordre de démarrage respecté :
  ```bash
  # 1. Base de données
  docker compose -f docker-compose.prod.yml up -d postgres-collection
  
  # 2. Backend (attend DB healthy)
  docker compose -f docker-compose.prod.yml up -d backend-collection
  
  # 3. Frontend (attend Backend healthy)
  docker compose -f docker-compose.prod.yml up -d frontend
  ```

#### 3. Suivi des Logs
- [ ] Suivre les logs en temps réel :
  ```bash
  docker compose -f docker-compose.prod.yml logs -f
  ```
- [ ] Vérifier démarrage sans erreur critique
- [ ] Attendre healthchecks verts (30-60 secondes)

---

### APRÈS Déploiement

#### 1. Health Checks Automatiques
- [ ] Backend API :
  ```bash
  curl -f https://api.darsling.fr/api/v1/health
  # Attendu : {"status":"ok"}
  ```
- [ ] Frontend :
  ```bash
  curl -f https://darsling.fr
  # Attendu : HTTP 200
  ```

#### 2. Extensions PostgreSQL
- [ ] Vérifier extensions installées :
  ```bash
  docker compose -f docker-compose.prod.yml exec postgres-collection psql -U $DB_USER -d $DB_NAME -c "SELECT extname FROM pg_extension WHERE extname IN ('unaccent');"
  ```
- [ ] Attendu : Ligne `unaccent` présente

#### 3. Pages Principales Accessibles
- [ ] Page d'accueil : https://darsling.fr/
- [ ] Page /cards : https://darsling.fr/cards
- [ ] Page /collections : https://darsling.fr/collections
- [ ] **Vérifier HTTP 200** (pas 500 Internal Error)

#### 4. Logs Sans Erreurs Critiques
- [ ] Backend logs :
  ```bash
  docker compose -f docker-compose.prod.yml logs backend-collection | grep -i error
  # Pas d'erreur critique
  ```
- [ ] Frontend logs :
  ```bash
  docker compose -f docker-compose.prod.yml logs frontend | grep -i error
  # Pas d'erreur critique
  ```

#### 5. État des Containers
- [ ] Tous containers `healthy` :
  ```bash
  docker compose -f docker-compose.prod.yml ps
  # Status : Up (healthy) pour tous
  ```

---

### EN CAS D'ERREUR

#### 1. Diagnostic Rapide
- [ ] Exécuter script de diagnostic :
  ```bash
  bash DevOps/scripts/diagnose-production.sh
  ```

#### 2. Logs Détaillés
- [ ] Backend :
  ```bash
  docker compose -f docker-compose.prod.yml logs --tail=100 backend-collection
  ```
- [ ] Frontend :
  ```bash
  docker compose -f docker-compose.prod.yml logs --tail=100 frontend
  ```
- [ ] PostgreSQL :
  ```bash
  docker compose -f docker-compose.prod.yml logs --tail=100 postgres-collection
  ```

#### 3. Rollback Rapide
- [ ] Retour version précédente :
  ```bash
  git checkout HEAD~1
  docker compose -f docker-compose.prod.yml up -d --no-deps [service]
  ```

#### 4. Redémarrage Propre
- [ ] Arrêt complet :
  ```bash
  docker compose -f docker-compose.prod.yml down
  ```
- [ ] Vérifier logs Docker : `docker system df`
- [ ] Redémarrage :
  ```bash
  docker compose -f docker-compose.prod.yml up -d
  ```

---

## Erreurs Fréquentes et Solutions

### Frontend appelle localhost:8080 au lieu de api.darsling.fr
**Symptôme** : Erreur CORS, API calls échouent  
**Cause** : Variable NEXT_PUBLIC_API_URL non injectée au build  
**Solution** : Vérifier `build.args` dans docker-compose.prod.yml (voir Règle #11)

### Extension PostgreSQL manquante
**Symptôme** : HTTP 500 sur /cards, erreur "extension unaccent does not exist"  
**Cause** : Migration 000_extensions.sql non appliquée  
**Solution** :
```bash
docker compose -f docker-compose.prod.yml exec postgres-collection psql -U $DB_USER -d $DB_NAME -c "CREATE EXTENSION IF NOT EXISTS unaccent;"
```

### Container pas redémarré après rebuild
**Symptôme** : Changements non pris en compte  
**Cause** : Image rebuilded mais container pas recréé  
**Solution** :
```bash
docker compose -f docker-compose.prod.yml up -d --no-deps [service]
```

### Espace disque saturé
**Symptôme** : "no space left on device" pendant build  
**Cause** : Build cache Docker volumineux  
**Solution** :
```bash
docker builder prune -f
docker system prune -a -f --volumes  # ⚠️ Destructif : supprime tout cache
```

---

## Estimation Temps

**Avec checklist** :
- Déploiement nominal : 5-10 minutes
- Déploiement avec problème : 15-20 minutes (diagnostic guidé)

**Sans checklist** (référence session 2026-05-04) :
- Déploiement avec problèmes : 3h (diagnostic à tâtons)

**Gain attendu** : 70% de réduction du temps de diagnostic

---

## Intégration dans DevOps/CLAUDE.md

Cette checklist doit être référencée dans la section "Déploiement Production" de `DevOps/CLAUDE.md`.

**Action recommandée** : Ajouter section "Checklist Déploiement Production" dans DevOps/CLAUDE.md avec lien vers ce fichier.

---

## Prochaine Étape

Automatiser cette checklist dans un script `DevOps/scripts/deploy-production.sh` avec :
- Vérifications automatiques pré-déploiement
- Arrêt si prérequis manquant
- Logs structurés
- Rollback automatique en cas d'échec

---

**Référence** : Session 2026-05-04 - Diagnostic déploiement production
