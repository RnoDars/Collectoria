# DevOps - Documentation Collectoria

**Agent responsable** : Agent DevOps  
**Dernière mise à jour** : 2026-04-28

---

## Vue d'Ensemble

Ce répertoire contient toute la documentation opérationnelle pour l'infrastructure, le déploiement et la maintenance de Collectoria.

---

## Index des Documents

### 🎯 Documents Principaux

#### [CLAUDE.md](CLAUDE.md)
**Description** : Instructions pour l'Agent DevOps  
**Contenu** :
- Règles critiques (sg docker, seed via docker exec, ports)
- Responsabilités de l'agent
- Workflow opérationnel
- Credentials de développement
- Problèmes courants et solutions

**Quand consulter** : Point d'entrée pour toute tâche DevOps

---

### 🏗️ Infrastructure et Configuration

#### [environment-setup.md](environment-setup.md)
**Description** : Architecture cible et configuration de l'environnement  
**Contenu** :
- Architecture microservices (Backend, Frontend, PostgreSQL, Kafka)
- Outils et technologies (Docker, Kubernetes, CI/CD, IaC, Monitoring)
- Conventions (IaC, 12-factor app, zero-downtime)
- Pipeline CI/CD type
- Stratégies de déploiement (Blue-Green, Canary, Rolling Update)

**Quand consulter** : Choix d'architecture, setup CI/CD, déploiement production

---

### 🧪 Tests et Développement Local

#### [testing-local.md](testing-local.md)
**Description** : Tests locaux et environnement de développement  
**Contenu** :
- Scripts de tests locaux (test-local.sh, cleanup-local.sh, monitor-local.sh)
- Makefile global et usage rapide
- Workflow DevOps pour tests locaux
- Règles opérationnelles (Docker sg docker, seed via docker exec)
- Ports par défaut et seed de données
- Initialisation nouvelle machine (migrations SQL dans l'ordre)
- Template de rapport de lancement

**Quand consulter** : Tests locaux, setup environnement, initialisation machine

---

#### [restart-procedures.md](restart-procedures.md)
**Description** : Procédures de redémarrage de l'environnement  
**Contenu** :
- Quand redémarrer l'environnement complet (CORS, env vars, middleware HTTP)
- Méthode automatique (restart-local.sh) vs manuelle
- Vérifications post-redémarrage (Backend, Frontend, PostgreSQL)
- Nettoyage du cache navigateur
- Problèmes courants et solutions (port 8080 occupé, PostgreSQL non démarré, frontend KO)

**Quand consulter** : Après changement de configuration, variables d'environnement, ou modification infrastructure HTTP

---

### 🚀 Déploiement Production

#### [production-setup.md](production-setup.md) ⭐ GUIDE PRINCIPAL
**Description** : Procédure complète de déploiement production  
**Taille** : 59 Ko (document exhaustif)  
**Contenu** :
1. Provisioning initial du serveur (SSH, utilisateurs, sécurité)
2. Installation Docker et Docker Compose
3. Configuration Traefik v3 (reverse proxy + TLS)
4. Architecture Docker Compose de production
5. Gestion des secrets (.env.production)
6. Configuration nom de domaine et DNS
7. Build des images Docker (backend Go, frontend Next.js)
8. Pipeline CI/CD GitHub Actions
9. Base de données en production (migrations, backups)
10. Monitoring léger (Uptime Kuma)
11. Procédure de premier déploiement (checklist complète)
12. Procédure de mise à jour (migrations, rollback)

**Quand consulter** : Déploiement initial, mise en production, mise à jour infrastructure

---

#### [production-deployment-progress.md](production-deployment-progress.md) 🔴 ÉTAT EN COURS
**Description** : Progression du déploiement production Scaleway  
**Dernière mise à jour** : 2026-04-28  
**Contenu** :
- Vue d'ensemble des phases (1: Provisioning ✅, 2: Docker ✅, 3: Traefik ⏸️, 4: Application ⏸️)
- Détails de chaque phase terminée
- Problèmes rencontrés et solutions
- État actuel du serveur (versions, services, sécurité)
- Prochaines étapes

**Quand consulter** : Reprise du déploiement Scaleway, suivi d'avancement

**⚠️ IMPORTANT** : Ce document doit être mis à jour après chaque phase complétée.

---

#### [scaleway-server-info.md](scaleway-server-info.md) 🔒 CONFIDENTIEL
**Description** : Informations serveur production Scaleway  
**⚠️ SENSIBLE** : Contient IP, credentials, configurations  
**Contenu** :
- Accès réseau (IP: 51.159.161.31, hostname)
- Système d'exploitation (Debian 13, kernel 6.12.74)
- Configuration SSH (utilisateur collectoria, clé publique)
- Versions logicielles (Docker 29.4.1, Compose v5.1.3)
- Sécurité (UFW, fail2ban, mises à jour auto)
- Services Docker prévus (Traefik, PostgreSQL, Backend, Frontend)
- Variables d'environnement production (à générer)
- Commandes de diagnostic rapide
- Procédures d'urgence

**Quand consulter** : Connexion au serveur, dépannage, maintenance

**⚠️ NE JAMAIS COMMITER DANS UN DÉPÔT PUBLIC**

---

#### [production-setup-corrections.md](production-setup-corrections.md)
**Description** : Corrections à apporter au guide production-setup.md  
**Contexte** : Retour d'expérience déploiement Scaleway Phase 1+2  
**Contenu** :
- Liste des 6 corrections identifiées
- Adaptation Debian vs Ubuntu (URLs Docker)
- Séparation des commandes multi-lignes (éviter problèmes copier-coller)
- Nouvelle section Troubleshooting
- Checklist pré-provisioning
- Généralisation du guide (multi-providers)

**Quand consulter** : Avant de mettre à jour production-setup.md

**Statut** : ⏸️ Corrections à appliquer

---

### 📜 Scripts

#### [scripts/](scripts/)
**Description** : Scripts d'automatisation DevOps  
**Contenu** :
- `test-local.sh` : Lancement tests locaux (backend ou all)
- `cleanup-local.sh` : Nettoyage environnement de développement
- `monitor-local.sh` : Monitoring temps réel des services
- `restart-local.sh` : Redémarrage complet backend + frontend + PostgreSQL
- `install-git-hooks.sh` : Installation hooks Git automatiques (security audit post-commit)

**Quand consulter** : Automatisation, scripts de maintenance

---

### 📊 Monitoring

#### [monitoring/](monitoring/)
**Description** : Configuration monitoring et alertes  
**Contenu** : (À documenter selon besoins futurs)

---

## Workflows Principaux

### 1. Initialisation Nouvelle Machine de Développement

**Documents** : [testing-local.md](testing-local.md)

```bash
# 1. Cloner le dépôt
git clone https://github.com/OWNER/Collectoria.git
cd Collectoria

# 2. Démarrer PostgreSQL
cd backend/collection-management
docker compose up -d

# 3. Appliquer les migrations (voir testing-local.md pour la liste complète)
# Toutes les migrations de 001 à 009

# 4. Installer dépendances frontend
cd ../../frontend
npm install

# 5. Lancer l'environnement
make test-backend  # ou ./scripts/test-local.sh
```

---

### 2. Tests Locaux Après Modification

**Documents** : [testing-local.md](testing-local.md), [restart-procedures.md](restart-procedures.md)

```bash
# Tests backend uniquement
make test-backend

# Tests complets (backend + frontend)
make test-all

# Redémarrage après config
make restart

# Nettoyage
make cleanup
```

---

### 3. Déploiement Production Initial

**Documents** : [production-setup.md](production-setup.md), [production-deployment-progress.md](production-deployment-progress.md)

**Étapes** :
1. Suivre checklist pré-provisioning (production-setup.md)
2. Exécuter Phase 1 : Provisioning (~25 min)
3. Exécuter Phase 2 : Docker (~18 min)
4. Exécuter Phase 3 : Traefik (~20 min)
5. Exécuter Phase 4 : Application (~30 min)
6. Valider déploiement (tests E2E)
7. Mettre à jour production-deployment-progress.md

**Durée totale estimée** : ~1h30

---

### 4. Maintenance et Dépannage

**Documents** : [scaleway-server-info.md](scaleway-server-info.md), [restart-procedures.md](restart-procedures.md)

**Commandes rapides** :
```bash
# État système
ssh collectoria@51.159.161.31
docker ps -a
docker compose -f docker-compose.prod.yml ps

# Logs
docker compose -f docker-compose.prod.yml logs -f --tail=50

# Redémarrage service
docker compose -f docker-compose.prod.yml restart backend-collection
```

---

## Conventions et Standards

### Règles Critiques DevOps

**TOUJOURS** :
- ✅ `sg docker -c "docker compose up -d"` (jamais `sudo docker` ou `docker` seul)
- ✅ Seed via `docker exec -i container psql` (jamais psql sur hôte)
- ✅ Vérifier et indiquer le port frontend réel après démarrage (Next.js cherche port libre)
- ✅ Afficher rapport de lancement structuré
- ✅ Nettoyer l'environnement après tests

**JAMAIS** :
- ❌ `sudo docker` ou `docker` sans sg docker
- ❌ psql directement sur hôte (pas installé)
- ❌ Commiter secrets ou .env.production dans git
- ❌ Oublier de redémarrer backend après modification code

---

### Ports Standards

| Service | Port | Fixe/Variable |
|---------|------|---------------|
| Backend Go | 8080 | Fixe |
| Frontend Next.js | 3000 | Variable (3000→3001→3002 si occupé) |
| PostgreSQL | 5432 | Fixe |
| Kafka (futur) | 9092/2181 | Fixe |

---

### Credentials de Développement

| Paramètre | Valeur |
|-----------|--------|
| DB_USER | `collectoria` |
| DB_PASSWORD | `collectoria` |
| DB_NAME | `collection_management` |
| Login app | `arnaud.dars@gmail.com` |
| Password app | `flying38` |
| UserID dev | `00000000-0000-0000-0000-000000000001` |

---

## État du Projet

### Infrastructure Locale (Développement)
- ✅ Backend Go (collection-management) opérationnel
- ✅ Frontend Next.js 15 + React 19 opérationnel
- ✅ PostgreSQL 15+ via Docker Compose opérationnel
- ✅ Authentification JWT (HS256, 24h expiration)
- ✅ 1679 cartes MECCG importées (8 séries)
- ✅ 9 migrations SQL appliquées (001 à 009)

### Infrastructure Production (Scaleway)
- ✅ Phase 1 : Provisioning (Debian 13, SSH sécurisé, UFW, fail2ban)
- ✅ Phase 2 : Docker (29.4.1) + Compose (v5.1.3)
- ⏸️ Phase 3 : Traefik (en attente nom de domaine + DNS)
- ⏸️ Phase 4 : Application (en attente Phase 3)

**Serveur** : 51.159.161.31 (Scaleway Debian 13)

---

## Références Rapides

### Commandes Docker

```bash
# Démarrer PostgreSQL
sg docker -c "docker compose up -d"

# Arrêter PostgreSQL
sg docker -c "docker compose down"

# Logs PostgreSQL
sg docker -c "docker compose logs -f postgres"

# Seed de données
sg docker -c "docker exec -i collectoria-collection-db psql -U collectoria -d collection_management < migrations/001_create_collections_schema.sql"
```

### Commandes Backend

```bash
# Démarrer backend (avec toutes les variables d'environnement)
export DB_HOST=localhost DB_PORT=5432 DB_USER=collectoria DB_PASSWORD=collectoria DB_NAME=collection_management SERVER_PORT=8080
export JWT_SECRET=collectoria-super-secret-jwt-key-64-chars-minimum-for-security-ok JWT_EXPIRATION_HOURS=24 JWT_ISSUER=collectoria-api
go run cmd/api/main.go

# Tuer backend
lsof -ti :8080 | xargs -r kill -9
```

### Commandes Frontend

```bash
# Démarrer frontend
npm run dev

# Nettoyer cache Next.js (si erreurs internes)
rm -rf .next
npm run dev
```

---

## Contacts et Support

| Rôle | Responsable |
|------|-------------|
| Agent DevOps | Claude (Agent spécialisé) |
| Admin Système | Arnaud Dars |
| Support Scaleway | https://console.scaleway.com/support |

---

## Historique des Modifications

| Date | Document | Changement |
|------|----------|------------|
| 2026-04-28 | production-deployment-progress.md | Création - Documentation Phase 1+2 Scaleway |
| 2026-04-28 | scaleway-server-info.md | Création - Informations serveur Scaleway |
| 2026-04-28 | production-setup-corrections.md | Création - Corrections à apporter au guide |
| 2026-04-28 | README.md | Création - Index de navigation DevOps |
| 2026-04-27 | CLAUDE.md | Mise à jour - Refactorisation |
| 2026-04-23 | testing-local.md | Création - Documentation tests locaux |
| 2026-04-23 | restart-procedures.md | Création - Procédures de redémarrage |

---

*Documentation maintenue par l'Agent DevOps - Dernière mise à jour : 2026-04-28*
