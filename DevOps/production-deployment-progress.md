# Collectoria - Progression du Déploiement Production Scaleway

**Serveur** : Scaleway - 51.159.161.31  
**Date de démarrage** : 2026-04-28  
**Statut global** : EN COURS

---

## Vue d'Ensemble

| Phase | Statut | Durée | Complétion |
|-------|--------|-------|------------|
| **Phase 1 : Provisioning** | ✅ TERMINÉE | ~25 min | 100% |
| **Phase 2 : Docker** | ✅ TERMINÉE | ~18 min | 100% |
| **Phase 3 : Traefik** | ⏸️ EN ATTENTE | - | 0% |
| **Phase 4 : Application** | ⏸️ EN ATTENTE | - | 0% |

**Temps total écoulé** : ~43 minutes

---

## Phase 1 : Provisioning Serveur (✅ TERMINÉE)

**Date** : 2026-04-28  
**Durée** : ~25 minutes  
**Statut** : ✅ 100% complétée

### Tâches Effectuées

#### 1.1 Configuration Système de Base
- ✅ Connexion SSH root établie (`ssh root@51.159.161.31`)
- ✅ Système Debian 13 (trixie) mis à jour (`apt update && apt upgrade`)
- ✅ Bash root coloré (prompt rouge configuré via `.bashrc`)

#### 1.2 Création Utilisateur Non-Root
- ✅ Utilisateur `collectoria` créé avec sudo
- ✅ Clé SSH publique configurée : `ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIO4MwvpoBlmtLk0G27sT/yyjHUOu6AzzDM44iJ2aMT/P`
- ✅ Permissions SSH correctement configurées (700 .ssh/, 600 authorized_keys)

#### 1.3 Sécurisation SSH
- ✅ PermitRootLogin → no
- ✅ PasswordAuthentication → no
- ✅ PubkeyAuthentication → yes
- ✅ X11Forwarding → no
- ✅ AllowTcpForwarding → no
- ✅ Timeout sessions inactives (ClientAliveInterval 300)

#### 1.4 Firewall UFW
- ✅ UFW configuré et activé
- ✅ Ports autorisés :
  - 22/tcp (SSH)
  - 80/tcp (HTTP)
  - 443/tcp (HTTPS)

#### 1.5 fail2ban
- ✅ fail2ban installé et configuré
- ✅ Jail SSH actif (3 tentatives max, ban 24h)
- ✅ Performance dès la première heure :
  - 46 tentatives de connexion détectées
  - 1 IP bannie automatiquement

#### 1.6 Mises à Jour Automatiques
- ✅ unattended-upgrades activé (patches de sécurité uniquement)
- ✅ Configuration : 
  - Update quotidienne
  - Cleanup hebdomadaire (7 jours)
  - Pas de reboot automatique

### Problèmes Rencontrés et Solutions

#### Problème 1 : apt-get déprécié
**Symptôme** : Commandes suggèrent d'utiliser `apt` au lieu de `apt-get`  
**Solution** : Utilisation de `apt` à la place de `apt-get` pour toutes les commandes  
**Impact** : Aucun - Cosmétique uniquement

#### Problème 2 : Commande longue Bloc 3 coupée
**Symptôme** : Commande multi-ligne non exécutée correctement lors du copier-coller  
**Solution** : Séparation en 4 commandes distinctes :
```bash
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
```
**Impact** : Résolu - Installation Docker réussie

#### Problème 3 : Fichier docker.list non créé
**Symptôme** : Fichier `docker.list` pas créé automatiquement  
**Solution** : Utilisation de `echo | sudo tee` pour forcer la création  
**Impact** : Résolu - Dépôt Docker ajouté avec succès

---

## Phase 2 : Installation Docker (✅ TERMINÉE)

**Date** : 2026-04-28  
**Durée** : ~18 minutes  
**Statut** : ✅ 100% complétée

### Tâches Effectuées

#### 2.1 Docker Engine
- ✅ Dépendances installées (`ca-certificates`, `curl`, `gnupg`, `lsb-release`)
- ✅ Clé GPG Docker officielle ajoutée
- ✅ Dépôt Docker stable configuré pour Debian
- ✅ Docker Engine 29.4.1 installé
- ✅ Docker Compose v5.1.3 installé

#### 2.2 Configuration Utilisateur
- ✅ Utilisateur `collectoria` ajouté au groupe `docker`
- ✅ Test sans sudo validé (peut exécuter Docker sans privilèges root)

#### 2.3 Services Docker
- ✅ Docker service activé (auto-start au boot)
- ✅ Docker service démarré
- ✅ Test hello-world validé avec succès

### Versions Installées

| Composant | Version |
|-----------|---------|
| Docker Engine | 29.4.1 |
| Docker Compose | v5.1.3 |
| containerd | 1.7.29 |
| runc | 2.0.1 |
| Docker Buildx | v0.20.4 |

---

## Phase 3 : Traefik (⏸️ EN ATTENTE)

**Statut** : Pas encore démarrée  
**Durée estimée** : ~20 minutes

### Tâches Prévues

#### 3.1 Répertoire de Déploiement
- [ ] Créer `/home/collectoria/collectoria`
- [ ] Créer structure `traefik/`

#### 3.2 Configuration Traefik
- [ ] Créer `traefik/traefik.yml` (config statique)
- [ ] Créer `traefik/dynamic.yml` (middlewares sécurité)
- [ ] Configurer email Let's Encrypt
- [ ] Créer `letsencrypt/acme.json` (chmod 600)

#### 3.3 Réseau Docker Proxy
- [ ] Créer réseau `collectoria_proxy`
- [ ] Valider réseau bridge

#### 3.4 Démarrage Traefik
- [ ] Lancer conteneur Traefik
- [ ] Vérifier acquisition certificat Let's Encrypt (après config DNS)
- [ ] Vérifier dashboard Traefik (temporairement)

**Prérequis** : Nom de domaine avec DNS configuré pointant vers 51.159.161.31

---

## Phase 4 : Application Collectoria (⏸️ EN ATTENTE)

**Statut** : Pas encore démarrée  
**Durée estimée** : ~30 minutes

### Tâches Prévues

#### 4.1 Clonage du Dépôt
- [ ] Cloner depuis GitHub
- [ ] Checkout branche main
- [ ] Vérifier fichiers `docker-compose.prod.yml`

#### 4.2 Variables d'Environnement
- [ ] Créer `.env.production`
- [ ] Générer JWT_SECRET (64 chars)
- [ ] Générer POSTGRES_COLLECTION_PASSWORD
- [ ] Configurer DOMAIN
- [ ] Configurer CORS_ALLOWED_ORIGINS
- [ ] chmod 600 .env.production

#### 4.3 Déploiement Base de Données
- [ ] Lancer conteneur PostgreSQL 15
- [ ] Attendre healthcheck
- [ ] Appliquer migrations SQL (001 à 009)
- [ ] Vérifier nombre de cartes (1679 attendues)

#### 4.4 Déploiement Backend
- [ ] Pull image ghcr.io backend
- [ ] Lancer conteneur backend
- [ ] Attendre healthcheck
- [ ] Tester `/api/v1/health`

#### 4.5 Déploiement Frontend
- [ ] Pull image ghcr.io frontend
- [ ] Lancer conteneur frontend
- [ ] Attendre healthcheck
- [ ] Tester page d'accueil

#### 4.6 Tests de Bout en Bout
- [ ] Test HTTPS (certificat Let's Encrypt)
- [ ] Test authentification
- [ ] Test endpoints API
- [ ] Test possession toggle
- [ ] Test activités

---

## État Actuel du Serveur

**Date du snapshot** : 2026-04-28

### Informations Système

| Paramètre | Valeur |
|-----------|--------|
| IP Publique | 51.159.161.31 |
| Hostname | scw-condescending-hodgkin |
| OS | Debian GNU/Linux 13 (trixie) |
| Kernel | 6.12.74+deb13+1-cloud-amd64 |
| Architecture | amd64 (x86_64) |

### Configuration SSH

| Paramètre | Valeur |
|-----------|--------|
| Port | 22 |
| Authentification | Clé SSH uniquement (password désactivé) |
| Root login | Désactivé |
| Utilisateur admin | collectoria |
| Clé publique | ssh-ed25519 AAAAC3Nza...2aMT/P |

### Services Actifs

| Service | Port | Statut | Version |
|---------|------|--------|---------|
| SSH | 22 | ✅ Running | OpenSSH 9.2p1 |
| fail2ban | - | ✅ Running | 1.1.0 |
| Docker | unix socket | ✅ Running | 29.4.1 |
| UFW | - | ✅ Active | 0.36.2 |

### Sécurité

| Élément | Statut |
|---------|--------|
| Firewall UFW | ✅ Actif (22/80/443 autorisés) |
| fail2ban | ✅ Actif (SSH jail configuré) |
| Mises à jour auto | ✅ Actif (sécurité uniquement) |
| Root SSH | ❌ Désactivé |
| Password SSH | ❌ Désactivé |

### Métriques fail2ban (1ère heure)

| Métrique | Valeur |
|----------|--------|
| Tentatives détectées | 46 |
| IPs bannies | 1 |
| Temps de ban | 24h |
| Max retry | 3 |

---

## Prochaines Étapes

### Immédiat (Phase 3 - Traefik)

1. **Configurer le nom de domaine**
   - Acheter ou utiliser un domaine existant
   - Configurer enregistrement DNS A vers 51.159.161.31
   - Attendre propagation DNS (15-30 min)

2. **Installer Traefik**
   - Suivre section 3 de `production-setup.md`
   - Créer structure de fichiers
   - Démarrer conteneur Traefik
   - Vérifier acquisition certificat Let's Encrypt

3. **Valider reverse proxy**
   - Tester redirection HTTP → HTTPS
   - Vérifier headers de sécurité
   - Valider certificat TLS

### Court Terme (Phase 4 - Application)

4. **Déployer l'application**
   - Cloner dépôt
   - Configurer secrets
   - Démarrer stack complète (PostgreSQL + Backend + Frontend)
   - Appliquer migrations SQL

5. **Tests de production**
   - Valider tous les endpoints
   - Tester authentification
   - Vérifier fonctionnalités métier

### Moyen Terme (Post-Déploiement)

6. **Monitoring et backups**
   - Configurer backup quotidien PostgreSQL
   - Installer Uptime Kuma (optionnel)
   - Mettre en place alertes

7. **CI/CD**
   - Configurer secrets GitHub Actions
   - Tester pipeline de déploiement automatique
   - Valider stratégie de rollback

---

## Notes et Observations

### Points Positifs
- ✅ Provisioning initial rapide et sans accroc majeur
- ✅ fail2ban déjà efficace (1 IP bannie en 1h)
- ✅ Sécurité SSH renforcée
- ✅ Docker fonctionnel avec groupe docker correctement configuré
- ✅ Documentation suivie précisément (production-setup.md)

### Points d'Attention
- ⚠️ Commandes longues multi-lignes à séparer pour éviter problèmes copier-coller
- ⚠️ Utiliser `apt` au lieu de `apt-get` (dépréciation)
- ⚠️ Attendre propagation DNS avant Traefik (Let's Encrypt échouera sinon)

### Améliorations Futures
- Mettre à jour `production-setup.md` pour refléter les commandes exactes utilisées (apt, séparation commandes)
- Documenter les problèmes rencontrés et solutions dans une section "Troubleshooting"
- Ajouter checklist de vérification après chaque phase

---

## Références

- **Guide principal** : `/home/arnaud.dars/git/Collectoria/DevOps/production-setup.md`
- **Informations serveur** : `/home/arnaud.dars/git/Collectoria/DevOps/scaleway-server-info.md`
- **Session de travail** : 2026-04-28
- **Durée totale Phase 1+2** : ~43 minutes

---

*Document maintenu par l'Agent DevOps - Dernière mise à jour : 2026-04-28*
