# Collectoria - Informations Serveur Scaleway Production

**Environnement** : Production  
**Provider** : Scaleway  
**Date de provisioning** : 2026-04-28  
**Statut** : ✅ Opérationnel (Phase 1+2 terminées)

---

## ⚠️ DOCUMENT CONFIDENTIEL

**Ce fichier contient des informations critiques pour l'accès au serveur de production.**

- Ne JAMAIS commiter ce fichier dans un dépôt public
- Stocker les credentials dans un gestionnaire de mots de passe
- Restreindre l'accès à ce fichier (chmod 600)

---

## Informations Serveur

### Accès Réseau

| Paramètre | Valeur |
|-----------|--------|
| **IP Publique** | `51.159.161.31` |
| **Hostname** | `scw-condescending-hodgkin` |
| **Provider** | Scaleway |
| **Région** | Europe (France) |

### Système d'Exploitation

| Paramètre | Valeur |
|-----------|--------|
| **Distribution** | Debian GNU/Linux 13 (trixie) |
| **Kernel** | 6.12.74+deb13+1-cloud-amd64 |
| **Architecture** | amd64 (x86_64) |

### Spécifications Matérielles

| Ressource | Valeur |
|-----------|--------|
| **CPU** | (À documenter après vérification) |
| **RAM** | (À documenter après vérification) |
| **Stockage** | (À documenter après vérification) |
| **Bande passante** | (À documenter après vérification) |

---

## Accès SSH

### Utilisateur Admin

| Paramètre | Valeur |
|-----------|--------|
| **Utilisateur** | `collectoria` |
| **Groupe sudo** | Oui |
| **Shell** | /bin/bash |
| **Home directory** | /home/collectoria |

### Configuration SSH

| Paramètre | Valeur |
|-----------|--------|
| **Port** | 22 |
| **Authentification** | Clé SSH uniquement |
| **PermitRootLogin** | no |
| **PasswordAuthentication** | no |
| **PubkeyAuthentication** | yes |

### Clé SSH Publique Autorisée

```
ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIO4MwvpoBlmtLk0G27sT/yyjHUOu6AzzDM44iJ2aMT/P
```

**Type** : ED25519  
**Emplacement** : `/home/collectoria/.ssh/authorized_keys`  
**Permissions** : 600 (collectoria:collectoria)

### Connexion SSH

```bash
# Depuis la machine locale (avec clé privée correspondante)
ssh collectoria@51.159.161.31

# Ou avec spécification de la clé privée
ssh -i ~/.ssh/id_ed25519 collectoria@51.159.161.31
```

---

## Versions Logicielles Installées

### Système de Base

| Logiciel | Version | Statut |
|----------|---------|--------|
| Debian | 13 (trixie) | ✅ À jour |
| Kernel | 6.12.74+deb13+1-cloud-amd64 | ✅ Stable |
| OpenSSH | 9.2p1 | ✅ Running |

### Docker

| Composant | Version | Statut |
|-----------|---------|--------|
| **Docker Engine** | 29.4.1 | ✅ Running |
| **Docker Compose** | v5.1.3 | ✅ Installé |
| **containerd** | 1.7.29 | ✅ Running |
| **runc** | 2.0.1 | ✅ Installé |
| **Docker Buildx** | v0.20.4 | ✅ Installé |

### Sécurité

| Logiciel | Version | Statut |
|----------|---------|--------|
| UFW | 0.36.2 | ✅ Active |
| fail2ban | 1.1.0 | ✅ Running |
| unattended-upgrades | (installé) | ✅ Active |

---

## Configuration Sécurité

### Firewall UFW

**Statut** : ✅ Active

| Port | Protocole | Service | Direction | Statut |
|------|-----------|---------|-----------|--------|
| 22 | TCP | SSH | IN | ✅ Autorisé |
| 80 | TCP | HTTP | IN | ✅ Autorisé |
| 443 | TCP | HTTPS | IN | ✅ Autorisé |
| * | * | * | OUT | ✅ Autorisé (par défaut) |

```bash
# Vérifier l'état du firewall
sudo ufw status verbose
```

### fail2ban

**Statut** : ✅ Running

| Paramètre | Valeur |
|-----------|--------|
| **Jail SSH** | Actif |
| **Max retry** | 3 tentatives |
| **Ban time** | 86400s (24h) |
| **Find time** | 600s (10min) |

**Métriques (1ère heure de production)** :
- Tentatives détectées : 46
- IPs bannies : 1
- Efficacité : ✅ Opérationnel

```bash
# Vérifier le statut de fail2ban
sudo fail2ban-client status sshd
```

### Mises à Jour Automatiques

**Statut** : ✅ Actif

| Paramètre | Valeur |
|-----------|--------|
| **Type** | Patches de sécurité uniquement |
| **Fréquence update** | Quotidienne |
| **Fréquence cleanup** | Hebdomadaire (7 jours) |
| **Reboot automatique** | Non |

---

## Variables d'Environnement Production

**⚠️ SECRETS - NE PAS COMMITER**

Ces variables seront créées dans le fichier `/home/collectoria/collectoria/.env.production` lors de la Phase 4 (déploiement application).

### Variables Requises

| Variable | Description | Statut |
|----------|-------------|--------|
| `DOMAIN` | Nom de domaine production | ⏸️ À définir |
| `POSTGRES_COLLECTION_USER` | User PostgreSQL | ⏸️ À définir |
| `POSTGRES_COLLECTION_PASSWORD` | Password PostgreSQL (généré) | ⏸️ À générer |
| `POSTGRES_COLLECTION_DB` | Nom BDD | `collection_management` |
| `JWT_SECRET` | Secret JWT (64 chars) | ⏸️ À générer |
| `JWT_EXPIRATION_HOURS` | Durée vie token | `24` |
| `JWT_ISSUER` | Émetteur JWT | `collectoria-api` |
| `CORS_ALLOWED_ORIGINS` | Origins CORS | ⏸️ À définir |
| `GITHUB_REPOSITORY_OWNER` | Owner GitHub | ⏸️ À définir |

### Génération des Secrets

```bash
# Générer JWT_SECRET (64 caractères hexadécimaux)
openssl rand -hex 32

# Générer mot de passe PostgreSQL fort
openssl rand -base64 24 | tr -d '=+/' | head -c 32
```

---

## Services Docker (État Actuel)

**Phase** : 2/4 (Docker installé, application pas encore déployée)

### Services Prévus

| Service | Container Name | Port(s) | Image | Statut |
|---------|----------------|---------|-------|--------|
| Traefik | collectoria-traefik | 80, 443 | traefik:v3.0 | ⏸️ À déployer |
| PostgreSQL | collectoria-postgres-collection | 5432 (interne) | postgres:15-alpine | ⏸️ À déployer |
| Backend | collectoria-backend-collection | 8080 (interne) | ghcr.io/.../backend | ⏸️ À déployer |
| Frontend | collectoria-frontend | 3000 (interne) | ghcr.io/.../frontend | ⏸️ À déployer |

### Réseaux Docker

| Réseau | Type | Statut |
|--------|------|--------|
| collectoria_proxy | bridge | ⏸️ À créer |
| backend_internal | internal | ⏸️ À créer |

### Volumes Docker

| Volume | Service | Statut |
|--------|---------|--------|
| collectoria_postgres_collection_data | PostgreSQL | ⏸️ À créer |
| collectoria_traefik_letsencrypt | Traefik | ⏸️ À créer |

---

## Chemins Importants

| Chemin | Description | Permissions |
|--------|-------------|-------------|
| `/home/collectoria` | Home directory utilisateur | 755 (collectoria:collectoria) |
| `/home/collectoria/.ssh` | Clés SSH | 700 (collectoria:collectoria) |
| `/home/collectoria/.ssh/authorized_keys` | Clés autorisées | 600 (collectoria:collectoria) |
| `/home/collectoria/collectoria` | ⏸️ Racine application (à créer) | 755 (collectoria:collectoria) |
| `/home/collectoria/collectoria/.env.production` | ⏸️ Secrets production (à créer) | 600 (collectoria:collectoria) |
| `/home/collectoria/scripts` | ⏸️ Scripts maintenance (à créer) | 755 (collectoria:collectoria) |
| `/home/collectoria/backups` | ⏸️ Backups PostgreSQL (à créer) | 700 (collectoria:collectoria) |

---

## Commandes de Diagnostic Rapide

### État Système

```bash
# Uptime et charge
uptime

# Espace disque
df -h

# Mémoire RAM
free -h

# Processus Docker
docker ps -a

# Logs système récents
sudo journalctl -n 50 --no-pager
```

### État Sécurité

```bash
# Firewall
sudo ufw status verbose

# fail2ban SSH
sudo fail2ban-client status sshd

# Dernières connexions SSH
sudo last -n 20
```

### État Docker

```bash
# Version
docker --version
docker compose version

# Containers actifs
docker ps

# Images disponibles
docker images

# Utilisation ressources
docker stats --no-stream

# Espace disque Docker
docker system df
```

---

## Historique des Changements

| Date | Phase | Changement | Auteur |
|------|-------|------------|--------|
| 2026-04-28 | Phase 1 | Provisioning initial complet | Agent DevOps |
| 2026-04-28 | Phase 2 | Installation Docker + Compose | Agent DevOps |

---

## Contacts et Support

| Rôle | Contact | Disponibilité |
|------|---------|---------------|
| Administrateur Principal | (À définir) | (À définir) |
| Support Scaleway | https://console.scaleway.com/support | 24/7 (tickets) |

---

## Procédures d'Urgence

### Serveur Non Accessible (SSH)

1. Vérifier connexion réseau locale
2. Ping `51.159.161.31`
3. Se connecter à la console Scaleway
4. Utiliser console web Scaleway pour accès direct
5. Vérifier logs système via console

### Service Docker Arrêté

```bash
# Redémarrer Docker
sudo systemctl restart docker

# Vérifier statut
sudo systemctl status docker
```

### Firewall Bloque Connexion

```bash
# Désactiver temporairement (UNIQUEMENT en cas d'urgence via console web)
sudo ufw disable

# Ré-activer après correction
sudo ufw enable
```

### Rollback Complet

Si nécessaire, snapshot Scaleway à créer AVANT déploiement Phase 3.

---

## Notes et Observations

### Points Positifs
- ✅ Provisioning rapide et sans problème majeur
- ✅ fail2ban déjà efficace (1 IP bannie en 1h)
- ✅ Sécurité SSH renforcée
- ✅ Docker fonctionnel

### Points d'Attention
- ⚠️ Nom de domaine à configurer avant Phase 3 (Traefik)
- ⚠️ Secrets à générer avant Phase 4 (Application)
- ⚠️ Snapshot à créer après Phase 2 (avant déploiement)

---

## Références

- **Progression déploiement** : `/home/arnaud.dars/git/Collectoria/DevOps/production-deployment-progress.md`
- **Guide provisioning** : `/home/arnaud.dars/git/Collectoria/DevOps/production-setup.md`
- **Console Scaleway** : https://console.scaleway.com/

---

*Document maintenu par l'Agent DevOps - Dernière mise à jour : 2026-04-28*
*Confidentialité : CRITIQUE - Ne pas partager publiquement*
