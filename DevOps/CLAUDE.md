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

### 5. Création Fichiers Configuration Multilignes en SSH

**RÈGLE PAR DÉFAUT** : Pour les fichiers >5 lignes en SSH, TOUJOURS utiliser nano ou scp, PAS heredoc.

**Pourquoi** :
- Heredoc échoue régulièrement en copier-coller web → SSH
- Caractères invisibles, EOF non reconnu
- Perte de temps, confusion utilisateur

**Méthode RECOMMANDÉE (nano)** :
```bash
# 1. Créer/ouvrir fichier avec nano
nano /path/to/file

# 2. Coller contenu (Ctrl+Shift+V ou clic droit)

# 3. Sauvegarder : Ctrl+O, Enter

# 4. Quitter : Ctrl+X

# 5. Vérifier
cat /path/to/file
```

**Avantages** :
- Fonctionne toujours (pas de problème encodage)
- Vérifiable immédiatement
- Éditable après création
- Familier pour tous les utilisateurs

**Méthode ALTERNATIVE (fichier local + scp)** :
```bash
# 1. Créer fichier localement
cat > /tmp/fichier << EOF
contenu multilignes
EOF

# 2. Vérifier contenu local
cat /tmp/fichier

# 3. Envoyer vers serveur
scp /tmp/fichier user@server:/path/to/file

# 4. Vérifier sur serveur
ssh user@server "cat /path/to/file"
```

**Méthode À ÉVITER (heredoc direct en SSH)** :
```bash
# ❌ NE PAS UTILISER en SSH (copier-coller web → terminal)
cat > /path/to/file << EOF
contenu
EOF
```
**Problèmes** : EOF non reconnu, caractères invisibles, commande jamais terminée

**Exception** : Heredoc OK si commande tapée manuellement dans terminal (pas copier-coller web).

**Référence** : Incident Phase 4 (2026-04-29) - Heredoc échec en SSH

### 6. Validation Prérequis Production

**Règle critique** : AVANT Phase 3 (Traefik HTTPS), TOUJOURS valider :
1. Domaine acheté → demander nom exact
2. DNS propagé → valider avec dig/ping MAINTENANT
3. Email fourni → demander email Let's Encrypt

**Si un prérequis manque** : NE PAS DÉMARRER PHASE 3.
Proposer de configurer le prérequis ou reporter la phase.

**Référence** : `Continuous-Improvement/recommendations/devops-prereq-checklist_2026-04-28.md`

### 7. Cohérence Healthcheck Dockerfile ↔ docker-compose

**Règle critique** : Les healthchecks doivent être cohérents ET compatibles avec les endpoints backend.

**Piège docker-compose** : 
- docker-compose.prod.yml OVERRIDE le healthcheck du Dockerfile
- Modifier uniquement le Dockerfile est INSUFFISANT si docker-compose définit aussi un healthcheck

**Méthode HTTP** :
- ❌ `wget --spider` → Requête HTTP HEAD
- ✅ `wget -O /dev/null` → Requête HTTP GET
- Les endpoints Go `router.GET(...)` n'acceptent QUE GET

**Validation OBLIGATOIRE** :
```bash
# Avant Phase 4
bash DevOps/scripts/validate-healthchecks.sh
```

**Référence** : Incident Phase 4 (2026-04-29) - 1h de debug healthcheck

### 8. Validation Fichiers Production AVANT Phase 4

**Règle critique** : Les fichiers Docker de production (Dockerfiles, docker-compose.prod.yml) doivent être créés, validés et testés LOCALEMENT avant d'aller sur le serveur.

**Workflow** :
Phase 3 → **Phase 3.5 (Validation fichiers)** → Phase 4 (Déploiement)

**Checklist obligatoire** :
- [ ] Dockerfiles créés et buildables localement
- [ ] docker-compose.prod.yml créé et testable localement
- [ ] Healthchecks validés (script validate-healthchecks.sh)
- [ ] Versions cohérentes (go.mod ↔ Dockerfile)
- [ ] Tous containers healthy en local

**Pourquoi** :
- Découverte d'erreurs en local (pas en production)
- Temps de correction serein (pas de stress)
- Phase 4 rapide et fiable

**Documentation Phase 3.5** : `DevOps/phase3.5-production-files-validation.md`

**Référence** : Incident Phase 4 (2026-04-29) - Fichiers créés tardivement

### 9. Convention Fichier .env Production

**Règle** : En production, utiliser `.env` (pas `.env.production`)

**Pourquoi** :
- Docker Compose charge automatiquement `.env`
- Simplifie toutes les commandes (pas de `--env-file` nécessaire)
- Convention standard de l'industrie

**Implémentation** :
```bash
# Sur serveur production
cat > .env << EOF
# Variables d'environnement production
POSTGRES_USER=collectoria_prod
POSTGRES_PASSWORD=xxx
...
EOF

# Commandes simplifiées
docker compose up -d
docker compose ps
```

**Alternative** : Si distinction visuelle dev/prod nécessaire, utiliser un script wrapper `deploy.sh`

**Référence** : Incident Phase 4 (2026-04-29) - Confusion .env.production

### 10. Scripts Bash = Code Production

**Règle critique** : Les scripts Bash (`scripts/deploy/`, `scripts/database/`, `scripts/maintenance/`) sont du code de production et requièrent la même rigueur que Go/React.

**Workflow OBLIGATOIRE avant commit** :
1. **Validation syntaxe** : `shellcheck script.sh` + `bash -n script.sh`
2. **Validation références** : Services, containers, fonctions existent
3. **Tests locaux** : `--help`, `--dry-run`, cas nominal
4. **Tests production** : `--dry-run` OBLIGATOIRE avant exécution réelle
5. **Documentation** : Header complet, commentaires appropriés
6. **Review** : Lecture du diff, validation manuelle

**Checklist complète** : `Meta-Agent/checklists/bash-scripts-pre-commit.md`

**API Reference** : `scripts/lib/README.md` (liste toutes les fonctions disponibles dans common.sh et docker-utils.sh)

**Pourquoi** :
- Session 2026-05-05 : 10 commits corrections pour 1 script non testé
- Erreurs évitables : noms services/containers incorrects, fonctions inexistantes, ports non exposés
- Coût : 45 min debug/script vs 5 min checklist

**Métriques cibles** :
- Scripts testés avant commit : 100%
- Commits corrections : <10%
- Temps debug : <2 min/script

**Références** :
- `Continuous-Improvement/recommendations/workflow-bash-scripts-testing_2026-05-05.md`
- `Continuous-Improvement/lessons/bash-scripts-are-code.md`
- `Continuous-Improvement/lessons/dry-run-mandatory-production.md`

---

### 10. Extensions PostgreSQL Obligatoires

**Règle** : Les extensions PostgreSQL requises DOIVENT être installées via la migration `000_extensions.sql` AVANT toutes autres migrations.

**Extensions actuelles** :
- `unaccent` : Normalisation texte pour recherche (CRITIQUE)

**Vérification** :
```bash
bash DevOps/scripts/verify-postgres-extensions.sh
```

**Installation manuelle** :
```bash
docker compose exec postgres-collection psql -U $DB_USER -d $DB_NAME -c "CREATE EXTENSION IF NOT EXISTS unaccent;"
```

**Ordre migrations** :
```
000_extensions.sql  ← TOUJOURS EN PREMIER
001_init_schema.sql
002_seed_meccg_cards.sql
...
```

**Référence** : Incident 2026-05-04 - Extension unaccent manquante causant HTTP 500

---

### 11. Variables Next.js Build-Time (NEXT_PUBLIC_*)

**Règle** : Les variables `NEXT_PUBLIC_*` DOIVENT être passées via `build.args` dans docker-compose, PAS uniquement via `environment`.

**Pourquoi** : Next.js injecte ces variables au moment du BUILD, pas au runtime.

**Comment** :
```yaml
frontend:
  build:
    context: ./frontend
    args:
      - NEXT_PUBLIC_API_URL=https://api.darsling.fr
```

**Vérification** :
```bash
bash DevOps/scripts/verify-nextjs-build-args.sh
```

**Référence** : Incident 2026-05-04 - Frontend appelait localhost:8080 en production

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

## Checklist Déploiement Production

### AVANT Déploiement
- [ ] `git pull` sur le serveur
- [ ] Variables `.env` complètes (aucun placeholder)
- [ ] Espace disque > 2 GB : `df -h`
- [ ] Extensions PostgreSQL documentées
- [ ] Build args NEXT_PUBLIC_* définis dans docker-compose.prod.yml

### PENDANT Déploiement
- [ ] `docker compose -f docker-compose.prod.yml build --no-cache [service]`
- [ ] `docker compose -f docker-compose.prod.yml up -d --no-deps [service]`
- [ ] Suivre les logs : `docker compose -f docker-compose.prod.yml logs -f [service]`

### APRÈS Déploiement
- [ ] Health checks : `curl https://api.darsling.fr/api/v1/health`
- [ ] Pages principales accessibles
- [ ] Vérifier logs : pas d'erreurs critiques
- [ ] Vérifier extensions PostgreSQL : `bash DevOps/scripts/verify-postgres-extensions.sh`

### EN CAS D'ERREUR
- [ ] Consulter `DevOps/scripts/diagnose-production.sh`
- [ ] Vérifier les logs détaillés
- [ ] Rollback si nécessaire

**Référence détaillée** : `Continuous-Improvement/recommendations/devops-production-deployment-checklist_2026-05-04.md`

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

---

## Checklist de Vérification Agent DevOps (Auto-Contrôle)

**Usage** : À consulter AVANT de terminer une tâche infrastructure ou déploiement.

**Référence complète** : `Meta-Agent/checklists/INDEX.md`

### TESTS LOCAUX ET DÉMARRAGE

- [ ] Utiliser TOUJOURS `sg docker -c "docker ..."`
- [ ] Seed données via `docker exec`, JAMAIS `psql` direct sur hôte
- [ ] Vérifier ports Frontend Next.js (3000/3001/3002)
- [ ] Rapport de lancement structuré fourni

**Template rapport** :
```
✅ Environnement de développement lancé :

Backend Go
- Port : 8080
- URL : http://localhost:8080/api/v1/health
- Status : Healthy

Frontend Next.js
- Port : 3001 (3000 était occupé) ← IMPORTANT : Indiquer pourquoi si ≠3000
- URL : http://localhost:3001
- Status : Ready

Base de Données
- Port : 5432
- Status : Up (healthy)
- Données : 1679 cartes MECCG
```

### DÉMARRAGE SERVICES

- [ ] PostgreSQL démarré : `sg docker -c "docker compose up -d"`
- [ ] Backend démarré avec TOUTES variables env (DB + JWT + CORS + LOG)
- [ ] Frontend démarré : `npm run dev`
- [ ] Health checks validés (Backend, Frontend, PostgreSQL)
- [ ] Ports indiqués clairement dans rapport

### AVANT DÉPLOIEMENT PRODUCTION

- [ ] Variables `.env` complètes (aucun placeholder)
- [ ] Espace disque >2 GB : `df -h`
- [ ] Extensions PostgreSQL documentées et installées
- [ ] Build args NEXT_PUBLIC_* définis dans docker-compose.prod.yml
- [ ] Healthchecks cohérents Dockerfile ↔ docker-compose
- [ ] Fichiers Docker testés LOCALEMENT avant production (Phase 3.5)

**Référence** : `DevOps/phase3.5-production-files-validation.md`

### PENDANT DÉPLOIEMENT

- [ ] Suivre checklist : `devops-production-deployment-checklist_2026-05-04.md`
- [ ] Logs surveillés pendant rebuild
- [ ] Backup créé avant changements critiques
- [ ] `git pull` exécuté sur serveur

### APRÈS DÉPLOIEMENT

- [ ] Health checks tous services : backend, frontend, DB
- [ ] Pages principales testées
- [ ] Aucune erreur critique dans logs
- [ ] Extensions PostgreSQL vérifiées : `bash DevOps/scripts/verify-postgres-extensions.sh`
- [ ] Rapport de déploiement fourni à Alfred

### INTERACTIONS AVEC AUTRES AGENTS

- [ ] Ai-je délégué à l'agent approprié si nécessaire ?
- [ ] Ai-je informé Alfred de mes résultats ?

### DOCUMENTATION & TRAÇABILITÉ

- [ ] Ai-je documenté mes actions ?
- [ ] Ai-je créé les fichiers requis ?
- [ ] Ai-je mis à jour les fichiers existants si nécessaire ?

### QUALITÉ & TESTS

- [ ] Ai-je vérifié que mon travail fonctionne ?
- [ ] Ai-je validé que tous services sont opérationnels ?

### RAPPORT FINAL

- [ ] Ai-je fourni un rapport clair à Alfred ?
- [ ] Ai-je indiqué les prochaines étapes si nécessaire ?

---
