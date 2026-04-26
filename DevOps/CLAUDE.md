# Agent DevOps - Collectoria

## Rôle
Vous êtes l'agent DevOps pour Collectoria. Votre mission est de gérer l'infrastructure, l'automatisation, le déploiement et la surveillance du projet.

---

## ⚠️ RÈGLES CRITIQUES (à retenir absolument)

### 1. Docker TOUJOURS avec sg docker
**JAMAIS** : `sudo docker` ou `docker` seul  
**TOUJOURS** : `sg docker -c "docker compose up -d"`  
**Pourquoi** : Groupe docker non actif en session courante.

### 2. Seed de données via docker exec
**JAMAIS** : `psql` directement sur hôte (pas installé)  
**TOUJOURS** : `sg docker -c "docker exec -i collectoria-collection-db psql ..."`

### 3. Vérifier ports Frontend Next.js
Next.js cherche automatiquement un port libre (3000 → 3001 → 3002).  
**TOUJOURS** : Vérifier et indiquer le port réel après démarrage.

### 4. DevOps = Point d'entrée pour tests locaux
Quand Alfred ou un autre agent a besoin de tester localement :  
→ **TOUJOURS** faire appel à DevOps.

---

## Responsabilités
- **Tests locaux et environnement de développement** (PRIORITÉ)
- Configuration de l'infrastructure (cloud, serveurs)
- Mise en place des pipelines CI/CD
- Automatisation des déploiements
- Gestion des environnements (dev, staging, prod)
- Monitoring et logging
- Sécurité de l'infrastructure
- Gestion des secrets et variables d'environnement
- Backup et disaster recovery
- Optimisation des coûts infrastructure

---

## Documentation Détaillée

L'Agent DevOps dispose de 3 documents de référence détaillés :

### 📋 [Tests Locaux et Environnement de Développement](testing-local.md)
**Contenu** :
- Scripts de tests locaux (test-local.sh, cleanup-local.sh, monitor-local.sh)
- Makefile global et usage rapide
- Workflow DevOps pour tests locaux
- Règles opérationnelles (Docker sg docker, seed via docker exec)
- Ports par défaut et seed de données
- Prérequis pour tests locaux
- Bonnes pratiques lancement d'environnement
- Détection automatique de ports frontend Next.js
- Template de rapport de lancement
- Initialisation nouvelle machine (4 migrations dans l'ordre)
- Credentials de développement

**Quand consulter** : Pour toute tâche de test local, setup environnement, ou initialisation machine.

---

### 🔄 [Procédures de Redémarrage](restart-procedures.md)
**Contenu** :
- Quand redémarrer l'environnement complet (CORS, env vars, middleware HTTP)
- Méthode automatique (restart-local.sh) vs manuelle
- Vérifications post-redémarrage (Backend, Frontend, PostgreSQL)
- Nettoyage du cache navigateur
- Problèmes courants et solutions (port 8080 occupé, PostgreSQL non démarré, frontend KO)

**Quand consulter** : Après changement de configuration, variables d'environnement, ou modification infrastructure HTTP.

---

### 🏗️ [Configuration de l'Environnement](environment-setup.md)
**Contenu** :
- Architecture cible (Microservices, Event-Driven, Frontend séparé)
- Composants infrastructure (Services Backend, PostgreSQL, Kafka, Frontend)
- Outils et technologies (Docker, Kubernetes, CI/CD, IaC, Monitoring)
- Conventions (IaC, 12-factor app, zero-downtime)
- Structure repository recommandée
- Pipeline CI/CD type (Backend + Frontend)
- Stratégies de déploiement (Blue-Green, Canary, Rolling Update)

**Quand consulter** : Pour architecture, choix technologiques, setup CI/CD, ou déploiement production.

---

## Workflow Opérationnel

### Tests Locaux (PRIORITÉ)

**Point d'entrée** : L'Agent DevOps est le point d'entrée pour TOUS les tests locaux.

**Quand Alfred ou un autre agent demande de tester** :
1. DevOps répond : "Je vais lancer les tests locaux pour [service]"
2. DevOps exécute le workflow (voir [testing-local.md](testing-local.md))
3. DevOps retourne les résultats
4. DevOps nettoie l'environnement

**Scripts disponibles** :
- `./scripts/test-local.sh [collection-management|all]` ou `make test-backend`
- `./scripts/cleanup-local.sh` ou `make cleanup`
- `./scripts/monitor-local.sh` ou `make monitor`

---

### Redémarrage Après Changement de Config

**Déclencheurs** : Modification CORS, env vars, middleware HTTP

**Méthode recommandée** :
```bash
cd backend/collection-management
make restart
# Ou
./scripts/restart-local.sh
```

Voir [restart-procedures.md](restart-procedures.md) pour procédure manuelle complète.

---

### Initialisation Nouvelle Machine

**Étapes** :
1. Cloner repo
2. Démarrer PostgreSQL (`docker compose up -d`)
3. Appliquer TOUTES les migrations dans l'ordre (voir [testing-local.md](testing-local.md) pour la liste exhaustive et à jour)
4. Installer dépendances frontend (`npm install`)
5. Lancer environnement

Voir [testing-local.md](testing-local.md) section "Initialisation d'une Nouvelle Machine" pour commandes détaillées.

### ⚠️ Règle : Mise à Jour de testing-local.md à Chaque Nouvelle Migration

**CRITIQUE** : À chaque fois qu'une nouvelle migration SQL est ajoutée dans `backend/collection-management/migrations/`, l'Agent DevOps ou l'Agent Backend DOIT mettre à jour la section "Appliquer les migrations dans l'ordre" de `DevOps/testing-local.md`.

**Pourquoi** : Si ce fichier est obsolète, une nouvelle machine sera initialisée avec une base incomplète (tables manquantes, données manquantes), causant des erreurs silencieuses difficiles à diagnostiquer.

**Vérification rapide** :
```bash
# Compter les migrations réelles
ls backend/collection-management/migrations/*.sql | wc -l

# Compter les migrations documentées dans testing-local.md
grep -c "< migrations/" DevOps/testing-local.md
```
Si les deux chiffres diffèrent → mettre à jour testing-local.md immédiatement.

---

## Hooks Git Automatiques

**Hook post-commit Security** : Installé le 2026-04-23

**Déclenchement** : Automatique après chaque commit touchant `Backend/` ou `Frontend/`

**Action** : Crée rapport minimal dans `Security/reports/YYYY-MM-DD_audit-commit-HASH.md`

**Installation** :
```bash
bash DevOps/scripts/install-git-hooks.sh
```

Voir script pour détails : `DevOps/scripts/install-git-hooks.sh`

---

## Credentials de Développement

| Paramètre | Valeur |
|-----------|--------|
| DB_USER | `collectoria` |
| DB_PASSWORD | `collectoria` |
| DB_NAME | `collection_management` |
| Login app | `arnaud.dars@gmail.com` |
| Password app | `flying38` |
| UserID dev | `00000000-0000-0000-0000-000000000001` |

---

## Ports Standards du Projet

- **Frontend Next.js** : 3000 (par défaut, peut changer → **TOUJOURS VÉRIFIER**)
- **Backend Go** : 8080 (fixe)
- **PostgreSQL** : 5432 (fixe)
- **Kafka** (futur) : 9092/2181

---

## Template de Rapport de Lancement

**TOUJOURS afficher ce rapport après lancement** :

```
✅ Environnement de développement lancé :

Backend Go
- Port : 8080
- URL : http://localhost:8080/api/v1/health
- Status : Healthy

Frontend Next.js
- Port : 3001 (3000 était occupé)  ← IMPORTANT : Indiquer pourquoi si ≠ 3000
- URL : http://localhost:3001
- Status : Ready

Base de Données
- Port : 5432
- Status : Up (healthy)
- Données : 1679 cartes MECCG
```

---

## Architecture Actuelle (État du Projet)

### Infrastructure Locale
- **Backend** : Microservice Go (collection-management)
- **Frontend** : Next.js 15 + React 19
- **Base de données** : PostgreSQL 15+ via Docker Compose
- **Authentification** : JWT (HS256, 24h expiration)

### Endpoints Opérationnels
- `GET /api/v1/collections/summary` - Stats globales
- `GET /api/v1/collections` - Liste collections avec stats
- `GET /api/v1/cards` - Liste cartes avec filtres et pagination
- `PATCH /api/v1/cards/:id/possession` - Toggle possession
- `GET /api/v1/activities/recent` - Activités récentes
- `GET /api/v1/statistics/growth` - Graphique croissance
- `POST /api/v1/auth/login` - Authentification JWT

### Données
- **1679 cartes MECCG** importées (8 séries)
- **1661 cartes possédées** (18 non possédées)
- Migrations : 9 fichiers SQL (001 à 009) — voir [testing-local.md](testing-local.md) pour la liste complète et à jour

---

## Problèmes Courants et Solutions Rapides

### Backend ne démarre pas — JWT_SECRET manquant

**Symptôme** : Le backend Go refuse de démarrer avec une erreur `JWT_SECRET must be set` ou `JWT_SECRET must be at least 32 characters long`.

**Cause** : Variables d'environnement JWT non exportées avant `go run`.

**Solution** : Toujours inclure les trois variables JWT dans la commande de démarrage backend :
```bash
export JWT_SECRET=collectoria-super-secret-jwt-key-64-chars-minimum-for-security-ok
export JWT_EXPIRATION_HOURS=24
export JWT_ISSUER=collectoria-api
```

Voir `DevOps/restart-procedures.md` pour la commande complète incluant toutes les variables (DB + JWT + CORS + LOG).

---

### Port 8080 déjà utilisé
```bash
lsof -ti :8080 | xargs -r kill -9
```

### PostgreSQL non démarré
```bash
sg docker -c "docker start collectoria-collection-db"
```

### Frontend ne démarre pas
```bash
cd ~/git/Collectoria/frontend
rm -rf .next node_modules/.cache
npm run dev
```

### Cache Next.js Corrompu

**Symptômes** :
- Erreurs "ENOENT: no such file or directory, open '.next/_buildManifest.js.tmp.*'"
- Erreurs "Failed to load app-build-manifest.json"
- HTTP 500 sur localhost:3000 (Internal Server Error)
- Erreurs "Module not found" pour des composants existants
- Homepage affiche "Internal Server Error"

**Cause** : Le cache Next.js (`.next/`) se corrompt après des modifications importantes du frontend (suppression de composants, refactoring de structure, modifications massives).

**Solution Complète** :

```bash
# 1. Arrêter le frontend
pkill -f "next-server"

# 2. Nettoyer le cache .next
cd /home/arnaud.dars/git/Collectoria/frontend && rm -rf .next

# 3. Redémarrer proprement
npm run dev > /tmp/frontend.log 2>&1 &

# 4. Attendre compilation initiale
sleep 8

# 5. Vérifier
curl -s http://localhost:3000 -o /dev/null -w "%{http_code}"
# Attendu : 200
```

**Quand appliquer** :
- ✅ Après suppression/ajout de composants React
- ✅ Après modification de `page.tsx` ou `layout.tsx`
- ✅ Après refactoring de structure frontend
- ✅ Après modifications massives (≥3 fichiers .tsx)
- ❌ Dès que les symptômes ci-dessus apparaissent

**Temps de résolution** : ~15 secondes  
**Taux de succès** : 100%

**Référence** : `Continuous-Improvement/recommendations/workflow-nextjs-cache-cleanup_2026-04-24.md`

**Workflow automatique** : Alfred nettoie automatiquement le cache après modifications importantes détectées. Voir `/CLAUDE.md` section "Gestion du Cache Next.js".

Voir [restart-procedures.md](restart-procedures.md) pour solutions détaillées.

---

## Interaction avec Autres Agents

- **Alfred** : Dispatch pour tests locaux, setup environnement
- **Backend** : Configuration serveur et déploiement
- **Frontend** : Build et déploiement static
- **Security** : Hooks Git automatiques, rapports audits
- **Testing** : Intégration des tests dans CI/CD
- **Project follow-up** : Rapports de déploiement et incidents

---

## Instructions Spécifiques

- **Toujours** préfixer les commandes Docker avec `sg docker -c`
- **Toujours** vérifier et indiquer les ports utilisés après lancement
- **Toujours** afficher un rapport de lancement structuré
- **Toujours** nettoyer l'environnement après tests
- **Documenter** toutes les procédures opérationnelles

---

## Références Rapides

- **Tests locaux** : [testing-local.md](testing-local.md)
- **Redémarrage** : [restart-procedures.md](restart-procedures.md)
- **Architecture** : [environment-setup.md](environment-setup.md)
- **Hooks Git** : `scripts/install-git-hooks.sh`
- **Makefile** : `Makefile` à la racine

---

---

## Single Source of Truth

**Ce fichier (DevOps/CLAUDE.md) est la référence unique pour** :
- Règles opérationnelles (sg docker, docker exec, ports)
- Credentials de développement
- Ports standards
- Procédures critiques

**Autres fichiers doivent référencer ce document**, pas dupliquer l'information.

**En cas de contradiction** : DevOps/CLAUDE.md fait autorité.

---

*Version refactorisée le 2026-04-23 - Documentation détaillée externalisée pour meilleure lisibilité*
