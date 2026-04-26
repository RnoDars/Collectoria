# Collectoria — Procédure de Déploiement Production

**Serveur cible** : OVH VPS-1 · Ubuntu 24.10 · 4 vCore · 8 Go RAM · 75 Go SSD NVMe  
**Dernière mise à jour** : 2026-04-26  
**Stack** : Go (microservices) + Next.js + PostgreSQL + Docker Compose + Traefik v3

---

## Table des matières

1. [Provisioning initial du serveur](#1-provisioning-initial-du-serveur)
2. [Installation du runtime Docker](#2-installation-du-runtime-docker)
3. [Reverse proxy et TLS (Traefik v3)](#3-reverse-proxy-et-tls-traefik-v3)
4. [Architecture Docker Compose de production](#4-architecture-docker-compose-de-production)
5. [Gestion des secrets](#5-gestion-des-secrets)
6. [Nom de domaine](#6-nom-de-domaine)
7. [Build des images Docker](#7-build-des-images-docker)
8. [Pipeline CI/CD GitHub Actions](#8-pipeline-cicd-github-actions)
9. [Base de données en production](#9-base-de-données-en-production)
10. [Monitoring léger](#10-monitoring-léger)
11. [Procédure de premier déploiement](#11-procédure-de-premier-déploiement)
12. [Procédure de mise à jour](#12-procédure-de-mise-à-jour)

---

## 1. Provisioning initial du serveur

### 1.1 Première connexion SSH (root)

Après réception de l'email OVH avec l'IP et le mot de passe root :

```bash
ssh root@<IP_DU_VPS>
```

Mettre à jour le système en premier :

```bash
apt update && apt upgrade -y
apt install -y curl wget git ufw fail2ban unattended-upgrades apt-listchanges
```

### 1.2 Création d'un utilisateur non-root avec sudo

```bash
# Créer l'utilisateur (remplacer "collectoria" par votre prénom si préféré)
adduser collectoria

# Ajouter au groupe sudo
usermod -aG sudo collectoria

# Créer le répertoire SSH pour le nouvel utilisateur
mkdir -p /home/collectoria/.ssh
chmod 700 /home/collectoria/.ssh
```

Depuis votre machine locale, copier votre clé publique :

```bash
# Sur votre machine locale
ssh-copy-id collectoria@<IP_DU_VPS>

# Ou manuellement : copier le contenu de ~/.ssh/id_ed25519.pub
# et le coller dans /home/collectoria/.ssh/authorized_keys sur le VPS
```

Sur le VPS, fixer les permissions :

```bash
chmod 600 /home/collectoria/.ssh/authorized_keys
chown -R collectoria:collectoria /home/collectoria/.ssh
```

### 1.3 Sécurisation SSH

Éditer `/etc/ssh/sshd_config` :

```bash
nano /etc/ssh/sshd_config
```

Modifier ou ajouter ces lignes :

```
# Désactiver login root
PermitRootLogin no

# Désactiver authentification par mot de passe (clé SSH uniquement)
PasswordAuthentication no
PubkeyAuthentication yes

# Désactiver tunneling inutile
X11Forwarding no
AllowTcpForwarding no

# Timeout sessions inactives
ClientAliveInterval 300
ClientAliveCountMax 2

# Port SSH (optionnel : changer le port par défaut pour réduire le bruit dans les logs)
# Port 2222   <- décommentez et adaptez si souhaité
```

Redémarrer SSH (ne pas fermer la session root courante avant de tester) :

```bash
systemctl restart sshd

# Tester depuis un NOUVEAU terminal avant de fermer la session root
ssh collectoria@<IP_DU_VPS>
```

### 1.4 Firewall UFW

```bash
# Réinitialiser et configurer UFW
ufw default deny incoming
ufw default allow outgoing

# Autoriser SSH (si vous avez changé le port, adaptez ici)
ufw allow 22/tcp

# Autoriser HTTP et HTTPS (gérés par Traefik)
ufw allow 80/tcp
ufw allow 443/tcp

# Activer le firewall
ufw enable

# Vérifier l'état
ufw status verbose
```

Résultat attendu :

```
Status: active
To                         Action      From
--                         ------      ----
22/tcp                     ALLOW IN    Anywhere
80/tcp                     ALLOW IN    Anywhere
443/tcp                    ALLOW IN    Anywhere
```

### 1.5 fail2ban

fail2ban protège contre les attaques brute force sur SSH.

Créer `/etc/fail2ban/jail.local` :

```bash
cat > /etc/fail2ban/jail.local << 'EOF'
[DEFAULT]
bantime  = 3600
findtime = 600
maxretry = 5
backend  = systemd

[sshd]
enabled  = true
port     = ssh
filter   = sshd
logpath  = /var/log/auth.log
maxretry = 3
bantime  = 86400
EOF
```

```bash
systemctl enable fail2ban
systemctl start fail2ban

# Vérifier le statut
fail2ban-client status sshd
```

### 1.6 Mises à jour automatiques de sécurité

```bash
# Configurer unattended-upgrades pour les patches de sécurité uniquement
cat > /etc/apt/apt.conf.d/50unattended-upgrades << 'EOF'
Unattended-Upgrade::Allowed-Origins {
    "${distro_id}:${distro_codename}-security";
};
Unattended-Upgrade::AutoFixInterruptedDpkg "true";
Unattended-Upgrade::MinimalSteps "true";
Unattended-Upgrade::Remove-Unused-Dependencies "true";
Unattended-Upgrade::Automatic-Reboot "false";
EOF

cat > /etc/apt/apt.conf.d/20auto-upgrades << 'EOF'
APT::Periodic::Update-Package-Lists "1";
APT::Periodic::Unattended-Upgrade "1";
APT::Periodic::AutocleanInterval "7";
EOF

systemctl enable unattended-upgrades
systemctl start unattended-upgrades
```

---

## 2. Installation du runtime Docker

Toutes les commandes suivantes sont exécutées en tant qu'utilisateur `collectoria` (avec sudo si nécessaire).

```bash
# Se connecter en tant que collectoria
su - collectoria
```

### 2.1 Docker Engine (version stable officielle)

```bash
# Supprimer les éventuelles versions précédentes
sudo apt remove -y docker docker-engine docker.io containerd runc 2>/dev/null || true

# Dépendances
sudo apt install -y ca-certificates curl gnupg lsb-release

# Clé GPG Docker officielle
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | \
  sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg

# Dépôt Docker stable
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] \
  https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Installer Docker Engine + Docker Compose v2
sudo apt update
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
```

### 2.2 Permettre à l'utilisateur d'utiliser Docker sans sudo

```bash
sudo usermod -aG docker collectoria

# Appliquer le changement de groupe sans reconnexion
newgrp docker

# Vérifier
docker --version
docker compose version
```

### 2.3 Démarrage automatique de Docker

```bash
sudo systemctl enable docker
sudo systemctl start docker

# Test rapide
docker run --rm hello-world
```

---

## 3. Reverse proxy et TLS (Traefik v3)

Traefik v3 est le choix recommandé pour ce projet : il s'intègre nativement avec Docker, gère automatiquement les certificats Let's Encrypt, et est léger (30 Mo en mémoire).

### 3.1 Répertoire de déploiement

```bash
mkdir -p /home/collectoria/collectoria
cd /home/collectoria/collectoria
```

### 3.2 Configuration Traefik

Créer le fichier `traefik/traefik.yml` :

```bash
mkdir -p traefik
cat > traefik/traefik.yml << 'EOF'
# Configuration statique Traefik v3
api:
  dashboard: false  # Mettre true temporairement pour debug, puis false en prod

log:
  level: INFO
  format: json

accessLog:
  format: json

entryPoints:
  web:
    address: ":80"
    http:
      redirections:
        entryPoint:
          to: websecure
          scheme: https
          permanent: true
  websecure:
    address: ":443"
    http:
      tls:
        certResolver: letsencrypt

certificatesResolvers:
  letsencrypt:
    acme:
      email: "votre-email@example.com"   # REMPLACER par votre vraie adresse email
      storage: /letsencrypt/acme.json
      tlsChallenge: {}

providers:
  docker:
    endpoint: "unix:///var/run/docker.sock"
    exposedByDefault: false
    network: collectoria_proxy
EOF
```

Créer le fichier de stockage ACME (certificats Let's Encrypt) :

```bash
mkdir -p letsencrypt
touch letsencrypt/acme.json
chmod 600 letsencrypt/acme.json
```

### 3.3 Middleware de sécurité Traefik

Créer `traefik/dynamic.yml` pour les headers de sécurité :

```bash
cat > traefik/dynamic.yml << 'EOF'
http:
  middlewares:
    security-headers:
      headers:
        # HSTS : forcer HTTPS pendant 1 an
        stsSeconds: 31536000
        stsIncludeSubdomains: true
        stsPreload: true
        # Empêcher le clickjacking
        frameDeny: true
        customFrameOptionsValue: "SAMEORIGIN"
        # Empêcher le MIME sniffing
        contentTypeNosniff: true
        # XSS protection navigateurs anciens
        browserXssFilter: true
        # Politique referrer
        referrerPolicy: "strict-origin-when-cross-origin"
        # Content Security Policy (adapter selon besoins)
        contentSecurityPolicy: "default-src 'self'; script-src 'self' 'unsafe-inline' 'unsafe-eval'; style-src 'self' 'unsafe-inline' https://fonts.googleapis.com; font-src 'self' https://fonts.gstatic.com; img-src 'self' data: https:; connect-src 'self'"
        # Permissions Policy
        permissionsPolicy: "camera=(), microphone=(), geolocation=()"
EOF
```

---

## 4. Architecture Docker Compose de production

### 4.1 Fichier `docker-compose.prod.yml`

Ce fichier est placé à la racine du projet Collectoria et remplace le docker-compose.yml de développement.

```yaml
# docker-compose.prod.yml
# Placer à la racine : /home/collectoria/collectoria/docker-compose.prod.yml

version: '3.9'

networks:
  # Réseau exposé au monde via Traefik
  proxy:
    name: collectoria_proxy
    external: true
  # Réseau interne : backend <-> postgres (jamais exposé)
  backend_internal:
    internal: true

volumes:
  postgres_collection_data:
    name: collectoria_postgres_collection_data
  traefik_letsencrypt:
    name: collectoria_traefik_letsencrypt

services:

  # ─────────────────────────────────────────────
  # TRAEFIK — Reverse proxy + TLS
  # ─────────────────────────────────────────────
  traefik:
    image: traefik:v3.0
    container_name: collectoria-traefik
    restart: unless-stopped
    security_opt:
      - no-new-privileges:true
    ports:
      - "80:80"
      - "443:443"
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock:ro
      - ./traefik/traefik.yml:/etc/traefik/traefik.yml:ro
      - ./traefik/dynamic.yml:/etc/traefik/dynamic.yml:ro
      - traefik_letsencrypt:/letsencrypt
    networks:
      - proxy
    labels:
      - "traefik.enable=false"

  # ─────────────────────────────────────────────
  # POSTGRESQL — Base de données collection-management
  # ─────────────────────────────────────────────
  postgres-collection:
    image: postgres:15-alpine
    container_name: collectoria-postgres-collection
    restart: unless-stopped
    environment:
      POSTGRES_USER: ${POSTGRES_COLLECTION_USER}
      POSTGRES_PASSWORD: ${POSTGRES_COLLECTION_PASSWORD}
      POSTGRES_DB: ${POSTGRES_COLLECTION_DB}
    volumes:
      - postgres_collection_data:/var/lib/postgresql/data
    networks:
      - backend_internal
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U ${POSTGRES_COLLECTION_USER} -d ${POSTGRES_COLLECTION_DB}"]
      interval: 10s
      timeout: 5s
      retries: 5
      start_period: 30s
    # Pas de ports exposés : accessible uniquement depuis backend_internal

  # ─────────────────────────────────────────────
  # BACKEND — Microservice collection-management
  # ─────────────────────────────────────────────
  backend-collection:
    image: ghcr.io/${GITHUB_REPOSITORY_OWNER}/collectoria-backend:${BACKEND_IMAGE_TAG:-latest}
    container_name: collectoria-backend-collection
    restart: unless-stopped
    depends_on:
      postgres-collection:
        condition: service_healthy
    environment:
      ENV: production
      LOG_LEVEL: info
      SERVER_PORT: 8080
      DB_HOST: postgres-collection
      DB_PORT: 5432
      DB_USER: ${POSTGRES_COLLECTION_USER}
      DB_PASSWORD: ${POSTGRES_COLLECTION_PASSWORD}
      DB_NAME: ${POSTGRES_COLLECTION_DB}
      DB_SSLMODE: disable
      JWT_SECRET: ${JWT_SECRET}
      JWT_EXPIRATION_HOURS: ${JWT_EXPIRATION_HOURS:-24}
      JWT_ISSUER: ${JWT_ISSUER:-collectoria-api}
      CORS_ALLOWED_ORIGINS: ${CORS_ALLOWED_ORIGINS}
      RATE_LIMIT_LOGIN_REQUESTS: ${RATE_LIMIT_LOGIN_REQUESTS:-5}
      RATE_LIMIT_LOGIN_WINDOW: ${RATE_LIMIT_LOGIN_WINDOW:-15m}
      RATE_LIMIT_READ_REQUESTS: ${RATE_LIMIT_READ_REQUESTS:-100}
      RATE_LIMIT_READ_WINDOW: ${RATE_LIMIT_READ_WINDOW:-1m}
      RATE_LIMIT_WRITE_REQUESTS: ${RATE_LIMIT_WRITE_REQUESTS:-30}
      RATE_LIMIT_WRITE_WINDOW: ${RATE_LIMIT_WRITE_WINDOW:-1m}
    networks:
      - proxy
      - backend_internal
    labels:
      - "traefik.enable=true"
      - "traefik.http.routers.backend.rule=Host(`${DOMAIN}`) && PathPrefix(`/api`)"
      - "traefik.http.routers.backend.entrypoints=websecure"
      - "traefik.http.routers.backend.tls.certresolver=letsencrypt"
      - "traefik.http.routers.backend.middlewares=security-headers@file"
      - "traefik.http.services.backend.loadbalancer.server.port=8080"
    healthcheck:
      test: ["CMD", "wget", "--no-verbose", "--tries=1", "--spider", "http://localhost:8080/api/v1/health"]
      interval: 30s
      timeout: 10s
      retries: 3
      start_period: 40s

  # ─────────────────────────────────────────────
  # FRONTEND — Next.js
  # ─────────────────────────────────────────────
  frontend:
    image: ghcr.io/${GITHUB_REPOSITORY_OWNER}/collectoria-frontend:${FRONTEND_IMAGE_TAG:-latest}
    container_name: collectoria-frontend
    restart: unless-stopped
    depends_on:
      - backend-collection
    environment:
      NODE_ENV: production
      NEXT_PUBLIC_API_BASE_URL: https://${DOMAIN}/api/v1
    networks:
      - proxy
    labels:
      - "traefik.enable=true"
      - "traefik.http.routers.frontend.rule=Host(`${DOMAIN}`)"
      - "traefik.http.routers.frontend.entrypoints=websecure"
      - "traefik.http.routers.frontend.tls.certresolver=letsencrypt"
      - "traefik.http.routers.frontend.middlewares=security-headers@file"
      - "traefik.http.services.frontend.loadbalancer.server.port=3000"
    healthcheck:
      test: ["CMD", "wget", "--no-verbose", "--tries=1", "--spider", "http://localhost:3000"]
      interval: 30s
      timeout: 10s
      retries: 3
      start_period: 60s
```

### 4.2 Créer le réseau Docker proxy (une seule fois)

```bash
docker network create collectoria_proxy
```

---

## 5. Gestion des secrets

### 5.1 Règle absolue

**Aucun secret ne doit jamais apparaître dans git.** Les fichiers `.env` de production n'existent que sur le serveur.

### 5.2 Liste exhaustive des secrets nécessaires

Ces secrets sont identifiés en lisant `backend/collection-management/internal/config/config.go` :

| Variable | Description | Obligatoire | Valeur exemple |
|---|---|---|---|
| `POSTGRES_COLLECTION_USER` | Utilisateur PostgreSQL | Oui | `collectoria_prod` |
| `POSTGRES_COLLECTION_PASSWORD` | Mot de passe PostgreSQL | Oui | *(généré)* |
| `POSTGRES_COLLECTION_DB` | Nom de la base de données | Oui | `collection_management` |
| `JWT_SECRET` | Secret de signature JWT (min 32 chars, recommandé 64) | Oui | *(généré)* |
| `JWT_EXPIRATION_HOURS` | Durée de vie du token en heures | Non | `24` |
| `JWT_ISSUER` | Émetteur JWT | Non | `collectoria-api` |
| `DOMAIN` | Nom de domaine production | Oui | `collectoria.example.com` |
| `CORS_ALLOWED_ORIGINS` | Origins CORS autorisées | Oui | `https://collectoria.example.com` |
| `GITHUB_REPOSITORY_OWNER` | Owner GitHub (pour ghcr.io) | Oui | `votre-username` |
| `BACKEND_IMAGE_TAG` | Tag image backend Docker | Non | `latest` |
| `FRONTEND_IMAGE_TAG` | Tag image frontend Docker | Non | `latest` |
| `RATE_LIMIT_LOGIN_REQUESTS` | Seuil rate limit login | Non | `5` |
| `RATE_LIMIT_READ_REQUESTS` | Seuil rate limit read | Non | `100` |
| `RATE_LIMIT_WRITE_REQUESTS` | Seuil rate limit write | Non | `30` |

### 5.3 Génération des secrets forts

Sur le VPS (ou en local avant de copier) :

```bash
# Générer JWT_SECRET (64 caractères hexadécimaux = 256 bits d'entropie)
openssl rand -hex 32

# Générer un mot de passe PostgreSQL fort
openssl rand -base64 24 | tr -d '=+/' | head -c 32

# Exemple de sortie :
# JWT_SECRET     = "a3f9d2e1c8b4a7f0e2d5c9b3a6f1e4d7a2c5b8e0f3d6c9b2a5e8d1f4c7b0a3e6"
# PG_PASSWORD    = "Kd9mP2nR7vX4qL1w"
```

### 5.4 Fichier `.env.production` sur le serveur

Ce fichier est créé **uniquement sur le serveur**, jamais commité dans git.

```bash
# Sur le VPS, en tant que collectoria
cat > /home/collectoria/collectoria/.env.production << 'EOF'
# =====================================================
# COLLECTORIA — Variables d'environnement production
# Fichier confidentiel — NE JAMAIS COMMITER DANS GIT
# Créé le : $(date +%Y-%m-%d)
# =====================================================

# --- Domaine ---
DOMAIN=collectoria.example.com

# --- PostgreSQL collection-management ---
POSTGRES_COLLECTION_USER=collectoria_prod
POSTGRES_COLLECTION_PASSWORD=REMPLACER_PAR_MOT_DE_PASSE_GENERE
POSTGRES_COLLECTION_DB=collection_management

# --- JWT ---
JWT_SECRET=REMPLACER_PAR_SECRET_64_CHARS_GENERE_AVEC_OPENSSL
JWT_EXPIRATION_HOURS=24
JWT_ISSUER=collectoria-api

# --- CORS ---
CORS_ALLOWED_ORIGINS=https://collectoria.example.com

# --- GitHub Container Registry ---
GITHUB_REPOSITORY_OWNER=VOTRE_USERNAME_GITHUB
BACKEND_IMAGE_TAG=latest
FRONTEND_IMAGE_TAG=latest

# --- Rate Limiting (valeurs production recommandées) ---
RATE_LIMIT_LOGIN_REQUESTS=5
RATE_LIMIT_LOGIN_WINDOW=15m
RATE_LIMIT_READ_REQUESTS=100
RATE_LIMIT_READ_WINDOW=1m
RATE_LIMIT_WRITE_REQUESTS=30
RATE_LIMIT_WRITE_WINDOW=1m
EOF

# Permissions restrictives : lecture uniquement par le propriétaire
chmod 600 /home/collectoria/collectoria/.env.production
```

### 5.5 Template `.env.production.example` (à commiter dans git)

Ce fichier contient les clés mais pas les valeurs. Il sert de documentation.

Créer `DevOps/.env.production.example` dans le dépôt git :

```bash
# =====================================================
# COLLECTORIA — Template variables d'environnement production
# Copier ce fichier en .env.production sur le serveur
# Remplir toutes les valeurs avant déploiement
# =====================================================

# --- Domaine ---
DOMAIN=

# --- PostgreSQL collection-management ---
POSTGRES_COLLECTION_USER=collectoria_prod
POSTGRES_COLLECTION_PASSWORD=
POSTGRES_COLLECTION_DB=collection_management

# --- JWT (générer avec : openssl rand -hex 32) ---
JWT_SECRET=
JWT_EXPIRATION_HOURS=24
JWT_ISSUER=collectoria-api

# --- CORS (adapter au domaine réel) ---
CORS_ALLOWED_ORIGINS=

# --- GitHub Container Registry ---
GITHUB_REPOSITORY_OWNER=
BACKEND_IMAGE_TAG=latest
FRONTEND_IMAGE_TAG=latest

# --- Rate Limiting ---
RATE_LIMIT_LOGIN_REQUESTS=5
RATE_LIMIT_LOGIN_WINDOW=15m
RATE_LIMIT_READ_REQUESTS=100
RATE_LIMIT_READ_WINDOW=1m
RATE_LIMIT_WRITE_REQUESTS=30
RATE_LIMIT_WRITE_WINDOW=1m
```

### 5.6 Vérification du `.gitignore` racine

Créer ou compléter le `.gitignore` à la racine du projet :

```
# Secrets et variables d'environnement
.env
.env.local
.env.production
.env.*.local
*.env

# Données sensibles
secrets/
*.pem
*.key
*.crt

# Traefik certificats
letsencrypt/acme.json

# Fichiers temporaires
*.log
```

---

## 6. Nom de domaine

### 6.1 Achat du domaine chez OVH

1. Se connecter sur [ovh.com](https://www.ovh.com/fr/)
2. Rechercher le domaine souhaité (ex. `collectoria.fr` ou `collectoria.app`)
3. Recommandation : prendre le domaine chez OVH pour éviter les transferts DNS entre prestataires
4. Prix indicatif : 5–15 €/an pour un `.fr` ou `.com`

### 6.2 Configuration DNS

Depuis l'espace client OVH > Noms de domaine > [votre domaine] > Zone DNS :

Ajouter un enregistrement de type A :

| Champ | Valeur |
|---|---|
| Type | `A` |
| Sous-domaine | *(vide pour l'apex, ou `www` si sous-domaine)* |
| TTL | 300 (5 minutes — permet de corriger rapidement si besoin) |
| Cible | `<IP_DU_VPS>` (l'IP v4 fournie par OVH) |

Si vous souhaitez que `www.collectoria.example.com` fonctionne aussi :

| Type | Sous-domaine | TTL | Cible |
|---|---|---|---|
| `A` | `www` | 300 | `<IP_DU_VPS>` |

### 6.3 Délai de propagation DNS

- **Minimum** : 5–10 minutes (si TTL = 300)
- **Maximum** : 24–48 heures (sur les résolveurs DNS qui ignorent le TTL)
- **En pratique** : 15–30 minutes pour la majorité des requêtes mondiales

Vérifier la propagation :

```bash
# Depuis votre machine locale
dig +short collectoria.example.com A
nslookup collectoria.example.com 8.8.8.8

# Depuis le VPS
curl -v https://collectoria.example.com
```

### 6.4 Vérification avant obtention des certificats

Let's Encrypt refuse de délivrer un certificat si le DNS ne résout pas encore. Attendre que `dig collectoria.example.com` retourne l'IP du VPS avant de lancer Traefik.

---

## 7. Build des images Docker

### 7.1 Dockerfile backend Go (multi-stage)

Le Dockerfile existant dans `backend/collection-management/Dockerfile` est déjà en multi-stage et production-ready. Voici la version complète avec les améliorations recommandées :

```dockerfile
# backend/collection-management/Dockerfile

# ─── Stage 1 : Build ───────────────────────────────────────────────────────────
FROM golang:1.21-alpine AS builder

# Installer les dépendances système nécessaires (ca-certificates pour HTTPS)
RUN apk --no-cache add ca-certificates tzdata

WORKDIR /app

# Copier les fichiers de dépendances en premier pour profiter du cache Docker
COPY go.mod go.sum ./
RUN go mod download && go mod verify

# Copier le code source
COPY . .

# Build optimisé pour la production
# -ldflags="-w -s" : strip debug info (réduction taille ~30%)
# CGO_ENABLED=0    : binaire statique (pas besoin de libc)
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 \
    go build \
    -ldflags="-w -s" \
    -a -installsuffix cgo \
    -o main \
    ./cmd/api

# ─── Stage 2 : Image finale minimale ──────────────────────────────────────────
FROM alpine:3.19

# Sécurité : certificats TLS + timezone
RUN apk --no-cache add ca-certificates tzdata wget && \
    addgroup -g 1000 collectoria && \
    adduser -D -u 1000 -G collectoria collectoria

WORKDIR /app

# Copier uniquement le binaire depuis le stage builder
COPY --from=builder --chown=collectoria:collectoria /app/main .

# Utilisateur non-root (déjà en place dans le Dockerfile existant)
USER collectoria

EXPOSE 8080

HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD wget --no-verbose --tries=1 --spider http://localhost:8080/api/v1/health || exit 1

CMD ["./main"]
```

### 7.2 `.dockerignore` backend

Créer `backend/collection-management/.dockerignore` :

```
# Dépendances et outils locaux
vendor/
.git/
.gitignore

# Binaires de build
main
*.exe
*.out

# Fichiers de test et coverage
**/*_test.go
coverage.txt
coverage.html
*.coverprofile

# Secrets et variables d'environnement
.env
.env.*
secrets/

# Documentation et données
*.md
data/
migrations/README.md

# Logs et temporaires
*.log
logs/

# IDE
.idea/
.vscode/
*.swp
```

### 7.3 Dockerfile frontend Next.js (multi-stage)

Créer `frontend/Dockerfile` :

```dockerfile
# frontend/Dockerfile

# ─── Stage 1 : Dépendances ────────────────────────────────────────────────────
FROM node:20-alpine AS deps

RUN apk add --no-cache libc6-compat
WORKDIR /app

COPY package.json package-lock.json ./
RUN npm ci --only=production --frozen-lockfile

# ─── Stage 2 : Build ──────────────────────────────────────────────────────────
FROM node:20-alpine AS builder

WORKDIR /app

# Copier les dépendances installées
COPY --from=deps /app/node_modules ./node_modules
COPY . .

# Variables d'environnement nécessaires au build
# NEXT_PUBLIC_* sont intégrées au bundle au moment du build
ARG NEXT_PUBLIC_API_BASE_URL
ENV NEXT_PUBLIC_API_BASE_URL=$NEXT_PUBLIC_API_BASE_URL

# Build Next.js en mode production avec output standalone
ENV NEXT_TELEMETRY_DISABLED=1
ENV NODE_ENV=production
RUN npm run build

# ─── Stage 3 : Image finale minimale ──────────────────────────────────────────
FROM node:20-alpine AS runner

WORKDIR /app

RUN addgroup --system --gid 1001 nodejs && \
    adduser --system --uid 1001 nextjs

ENV NODE_ENV=production
ENV NEXT_TELEMETRY_DISABLED=1

# Copier les fichiers nécessaires uniquement
COPY --from=builder /app/public ./public
COPY --from=builder --chown=nextjs:nodejs /app/.next/standalone ./
COPY --from=builder --chown=nextjs:nodejs /app/.next/static ./.next/static

USER nextjs

EXPOSE 3000
ENV PORT=3000
ENV HOSTNAME="0.0.0.0"

HEALTHCHECK --interval=30s --timeout=3s --start-period=30s --retries=3 \
  CMD wget --no-verbose --tries=1 --spider http://localhost:3000 || exit 1

CMD ["node", "server.js"]
```

**Important** : activer le mode `standalone` dans `next.config.js` :

```js
// frontend/next.config.js
/** @type {import('next').NextConfig} */
const nextConfig = {
  reactStrictMode: true,
  output: 'standalone',  // Ajouter cette ligne
}

module.exports = nextConfig
```

### 7.4 `.dockerignore` frontend

Créer `frontend/.dockerignore` :

```
# Cache et builds
.next/
node_modules/
out/
build/

# Secrets
.env*.local
.env.production

# Tests et coverage
coverage/
__tests__/
*.test.ts
*.test.tsx
*.spec.ts
*.spec.tsx

# Documentation
*.md
docs/

# Git et IDE
.git/
.gitignore
.idea/
.vscode/

# Logs
*.log
npm-debug.log*
yarn-debug.log*

# OS
.DS_Store
Thumbs.db
```

### 7.5 Stratégie de tags des images

Les images Docker sont taguées avec le SHA court du commit git :

```bash
# Format recommandé : sha-<7 premiers caractères du SHA>
docker build -t ghcr.io/OWNER/collectoria-backend:sha-$(git rev-parse --short HEAD) .

# On pousse aussi le tag "latest" qui pointe sur le dernier déploiement prod
docker tag ghcr.io/OWNER/collectoria-backend:sha-abc1234 ghcr.io/OWNER/collectoria-backend:latest
```

Cela permet :
- De savoir exactement quel commit est en production
- De revenir en arrière en re-déployant une image précédente par son SHA

---

## 8. Pipeline CI/CD GitHub Actions

### 8.1 Secrets GitHub Actions à configurer

Dans GitHub > Settings > Secrets and variables > Actions > New repository secret :

| Secret | Description | Comment l'obtenir |
|---|---|---|
| `VPS_HOST` | IP du VPS OVH | Email OVH après commande |
| `VPS_USER` | Utilisateur SSH (`collectoria`) | Défini à l'étape 1.2 |
| `VPS_SSH_KEY` | Clé privée SSH (contenu entier de `~/.ssh/id_ed25519`) | `cat ~/.ssh/id_ed25519` |
| `VPS_DEPLOY_PATH` | Chemin sur le VPS (`/home/collectoria/collectoria`) | Défini à l'étape 3.1 |
| `GHCR_TOKEN` | Personal Access Token GitHub avec scope `write:packages` | GitHub > Settings > Developer settings |

Le token GHCR est nécessaire pour pousser des images vers ghcr.io. Créer un PAT avec les scopes `read:packages`, `write:packages`, `delete:packages`.

### 8.2 Workflow `.github/workflows/deploy.yml`

```yaml
# .github/workflows/deploy.yml

name: Build and Deploy to Production

on:
  push:
    branches:
      - main

env:
  REGISTRY: ghcr.io
  BACKEND_IMAGE: ghcr.io/${{ github.repository_owner }}/collectoria-backend
  FRONTEND_IMAGE: ghcr.io/${{ github.repository_owner }}/collectoria-frontend

jobs:

  # ─────────────────────────────────────────────────────────────────────────────
  # JOB 1 : Tests backend Go
  # ─────────────────────────────────────────────────────────────────────────────
  test-backend:
    name: Tests Backend Go
    runs-on: ubuntu-latest
    defaults:
      run:
        working-directory: backend/collection-management

    services:
      postgres:
        image: postgres:15-alpine
        env:
          POSTGRES_USER: collectoria_test
          POSTGRES_PASSWORD: test_password
          POSTGRES_DB: collection_management_test
        ports:
          - 5432:5432
        options: >-
          --health-cmd pg_isready
          --health-interval 10s
          --health-timeout 5s
          --health-retries 5

    steps:
      - name: Checkout code
        uses: actions/checkout@v4

      - name: Setup Go
        uses: actions/setup-go@v5
        with:
          go-version-file: backend/collection-management/go.mod
          cache-dependency-path: backend/collection-management/go.sum

      - name: Download dependencies
        run: go mod download

      - name: Run unit tests (sans base de données)
        run: go test ./internal/... -v -coverprofile=coverage.txt -covermode=atomic
        env:
          JWT_SECRET: test_jwt_secret_for_ci_pipeline_at_least_32_chars

      - name: Upload coverage
        uses: codecov/codecov-action@v4
        with:
          files: backend/collection-management/coverage.txt
          flags: backend
        continue-on-error: true  # Ne pas bloquer si Codecov est indisponible

  # ─────────────────────────────────────────────────────────────────────────────
  # JOB 2 : Tests frontend Next.js
  # ─────────────────────────────────────────────────────────────────────────────
  test-frontend:
    name: Tests Frontend Next.js
    runs-on: ubuntu-latest
    defaults:
      run:
        working-directory: frontend

    steps:
      - name: Checkout code
        uses: actions/checkout@v4

      - name: Setup Node.js
        uses: actions/setup-node@v4
        with:
          node-version: '20'
          cache: 'npm'
          cache-dependency-path: frontend/package-lock.json

      - name: Install dependencies
        run: npm ci

      - name: Run tests
        run: npm test -- --run

      - name: TypeScript check
        run: npx tsc --noEmit

      - name: Lint
        run: npm run lint

  # ─────────────────────────────────────────────────────────────────────────────
  # JOB 3 : Build et push image Docker backend
  # ─────────────────────────────────────────────────────────────────────────────
  build-backend:
    name: Build Backend Docker Image
    runs-on: ubuntu-latest
    needs: [test-backend]
    outputs:
      image-tag: ${{ steps.meta.outputs.tags }}
      short-sha: ${{ steps.sha.outputs.short }}

    steps:
      - name: Checkout code
        uses: actions/checkout@v4

      - name: Get short SHA
        id: sha
        run: echo "short=$(git rev-parse --short HEAD)" >> $GITHUB_OUTPUT

      - name: Setup Docker Buildx
        uses: docker/setup-buildx-action@v3

      - name: Login to GitHub Container Registry
        uses: docker/login-action@v3
        with:
          registry: ${{ env.REGISTRY }}
          username: ${{ github.actor }}
          password: ${{ secrets.GHCR_TOKEN }}

      - name: Extract metadata
        id: meta
        uses: docker/metadata-action@v5
        with:
          images: ${{ env.BACKEND_IMAGE }}
          tags: |
            type=sha,prefix=sha-,format=short
            type=raw,value=latest,enable={{is_default_branch}}

      - name: Build and push backend image
        uses: docker/build-push-action@v5
        with:
          context: backend/collection-management
          file: backend/collection-management/Dockerfile
          push: true
          tags: ${{ steps.meta.outputs.tags }}
          labels: ${{ steps.meta.outputs.labels }}
          cache-from: type=gha
          cache-to: type=gha,mode=max
          platforms: linux/amd64

  # ─────────────────────────────────────────────────────────────────────────────
  # JOB 4 : Build et push image Docker frontend
  # ─────────────────────────────────────────────────────────────────────────────
  build-frontend:
    name: Build Frontend Docker Image
    runs-on: ubuntu-latest
    needs: [test-frontend]

    steps:
      - name: Checkout code
        uses: actions/checkout@v4

      - name: Setup Docker Buildx
        uses: docker/setup-buildx-action@v3

      - name: Login to GitHub Container Registry
        uses: docker/login-action@v3
        with:
          registry: ${{ env.REGISTRY }}
          username: ${{ github.actor }}
          password: ${{ secrets.GHCR_TOKEN }}

      - name: Extract metadata
        id: meta
        uses: docker/metadata-action@v5
        with:
          images: ${{ env.FRONTEND_IMAGE }}
          tags: |
            type=sha,prefix=sha-,format=short
            type=raw,value=latest,enable={{is_default_branch}}

      - name: Build and push frontend image
        uses: docker/build-push-action@v5
        with:
          context: frontend
          file: frontend/Dockerfile
          push: true
          tags: ${{ steps.meta.outputs.tags }}
          labels: ${{ steps.meta.outputs.labels }}
          cache-from: type=gha
          cache-to: type=gha,mode=max
          platforms: linux/amd64
          # NEXT_PUBLIC_API_BASE_URL sera override par la variable d'env du container
          # On met une valeur de build vide qui sera remplacée au runtime via NEXT_PUBLIC
          build-args: |
            NEXT_PUBLIC_API_BASE_URL=/api/v1

  # ─────────────────────────────────────────────────────────────────────────────
  # JOB 5 : Déploiement sur le VPS
  # ─────────────────────────────────────────────────────────────────────────────
  deploy:
    name: Deploy to VPS
    runs-on: ubuntu-latest
    needs: [build-backend, build-frontend]
    environment: production  # Permet d'ajouter une approbation manuelle dans GitHub si souhaité

    steps:
      - name: Deploy via SSH
        uses: appleboy/ssh-action@v1.0.3
        with:
          host: ${{ secrets.VPS_HOST }}
          username: ${{ secrets.VPS_USER }}
          key: ${{ secrets.VPS_SSH_KEY }}
          script: |
            set -e

            cd ${{ secrets.VPS_DEPLOY_PATH }}

            # Charger les variables d'environnement de production
            export $(grep -v '^#' .env.production | xargs)

            # Forcer les nouveaux tags d'image (SHA du commit courant)
            export BACKEND_IMAGE_TAG=sha-${{ github.sha }}
            export FRONTEND_IMAGE_TAG=sha-${{ github.sha }}
            # Tronquer le SHA au format court (7 chars) comme Docker metadata-action
            SHORT_SHA=$(echo "${{ github.sha }}" | cut -c1-7)
            export BACKEND_IMAGE_TAG=sha-${SHORT_SHA}
            export FRONTEND_IMAGE_TAG=sha-${SHORT_SHA}

            # Authentification GHCR pour pouvoir puller les images privées
            echo "${{ secrets.GHCR_TOKEN }}" | docker login ghcr.io \
              -u "${{ github.actor }}" --password-stdin

            # Tirer les nouvelles images
            docker compose -f docker-compose.prod.yml \
              --env-file .env.production \
              pull backend-collection frontend

            # Redémarrer avec zero-downtime
            # --no-deps : ne pas redémarrer postgres si pas modifié
            docker compose -f docker-compose.prod.yml \
              --env-file .env.production \
              up -d --no-deps \
              backend-collection frontend

            # Health check : attendre que le backend réponde
            echo "Waiting for backend health check..."
            for i in $(seq 1 12); do
              if curl -sf http://localhost:8080/api/v1/health > /dev/null 2>&1; then
                echo "Backend is healthy after ${i}x5s"
                break
              fi
              if [ $i -eq 12 ]; then
                echo "ERROR: Backend failed to become healthy after 60s"
                docker compose -f docker-compose.prod.yml logs --tail=50 backend-collection
                exit 1
              fi
              sleep 5
            done

            # Nettoyer les anciennes images non utilisées (libère de l'espace disque)
            docker image prune -f

            echo "Deployment successful: sha-${SHORT_SHA}"
```

### 8.3 Stratégie zero-downtime

Le script de déploiement utilise `--no-deps` pour ne redémarrer que les services dont l'image a changé. La stratégie est :

1. Docker Compose pull les nouvelles images en arrière-plan
2. `up -d` remplace les containers en cours d'exécution par les nouveaux
3. Docker Compose attend que le healthcheck passe avant de considérer le container comme opérationnel
4. Si le nouveau container ne passe pas le healthcheck, le pipeline échoue et l'ancien container continue de tourner

Pour un vrai zero-downtime avec plusieurs répliques, il faudrait Kubernetes ou Docker Swarm. Pour ce stade du projet (single instance), le délai de redémarrage est de 10–30 secondes.

---

## 9. Base de données en production

### 9.1 PostgreSQL dans Docker

PostgreSQL est géré via Docker Compose avec un volume nommé persistant. Le volume `collectoria_postgres_collection_data` survit aux redémarrages et mises à jour des containers.

```bash
# Vérifier que le volume existe
docker volume inspect collectoria_postgres_collection_data

# Ne JAMAIS faire : docker compose down -v
# L'option -v supprime les volumes et efface toutes les données !
```

### 9.2 Stratégie de migrations

Le projet utilise des fichiers SQL dans `backend/collection-management/migrations/`. En production, les migrations sont appliquées manuellement avant chaque déploiement impliquant des changements de schéma.

**Procédure de migration :**

```bash
# Sur le VPS, se connecter en tant que collectoria
ssh collectoria@<IP_DU_VPS>
cd /home/collectoria/collectoria

# Charger les variables d'environnement
export $(grep -v '^#' .env.production | xargs)

# Appliquer une migration spécifique
docker exec -i collectoria-postgres-collection \
  psql -U "${POSTGRES_COLLECTION_USER}" -d "${POSTGRES_COLLECTION_DB}" \
  < /chemin/vers/migration.sql

# Ou depuis le dépôt git (après git pull)
docker exec -i collectoria-postgres-collection \
  psql -U "${POSTGRES_COLLECTION_USER}" -d "${POSTGRES_COLLECTION_DB}" \
  < /home/collectoria/collectoria/backend/collection-management/migrations/010_nouvelle_migration.sql
```

**Règles pour les migrations de production :**

1. Toujours tester la migration sur une copie de la base de prod avant de l'appliquer
2. Écrire des migrations backward-compatible quand possible (ajouter des colonnes nullable, jamais supprimer sans version intermédiaire)
3. Toujours créer un script de rollback avant d'appliquer
4. Appliquer les migrations AVANT de déployer le nouveau code backend

### 9.3 Backup PostgreSQL

**Script de backup quotidien** : créer `/home/collectoria/scripts/backup-db.sh`

```bash
mkdir -p /home/collectoria/scripts
cat > /home/collectoria/scripts/backup-db.sh << 'SCRIPT'
#!/bin/bash
set -euo pipefail

# Configuration
BACKUP_DIR="/home/collectoria/backups/postgres"
CONTAINER="collectoria-postgres-collection"
DATE=$(date +%Y%m%d_%H%M%S)
RETAIN_DAYS=14

# Charger les variables d'environnement
source /home/collectoria/collectoria/.env.production 2>/dev/null || true

DB_USER="${POSTGRES_COLLECTION_USER:-collectoria_prod}"
DB_NAME="${POSTGRES_COLLECTION_DB:-collection_management}"

# Créer le répertoire de backup
mkdir -p "${BACKUP_DIR}"

# Nom du fichier de backup
BACKUP_FILE="${BACKUP_DIR}/${DB_NAME}_${DATE}.sql.gz"

echo "[$(date)] Starting backup of ${DB_NAME}..."

# Dump PostgreSQL compressé
docker exec "${CONTAINER}" \
  pg_dump -U "${DB_USER}" "${DB_NAME}" \
  | gzip > "${BACKUP_FILE}"

# Vérification que le fichier n'est pas vide
if [ ! -s "${BACKUP_FILE}" ]; then
  echo "[$(date)] ERROR: Backup file is empty!"
  rm -f "${BACKUP_FILE}"
  exit 1
fi

BACKUP_SIZE=$(du -sh "${BACKUP_FILE}" | cut -f1)
echo "[$(date)] Backup created: ${BACKUP_FILE} (${BACKUP_SIZE})"

# Rotation : supprimer les backups de plus de RETAIN_DAYS jours
find "${BACKUP_DIR}" -name "*.sql.gz" -mtime +${RETAIN_DAYS} -delete
echo "[$(date)] Cleaned backups older than ${RETAIN_DAYS} days"

# Lister les backups restants
echo "[$(date)] Current backups:"
ls -lh "${BACKUP_DIR}/" || echo "No backups found"
SCRIPT

chmod +x /home/collectoria/scripts/backup-db.sh
```

**Planification automatique via cron :**

```bash
crontab -e
# Ajouter la ligne suivante (backup tous les jours à 2h du matin)
0 2 * * * /home/collectoria/scripts/backup-db.sh >> /home/collectoria/logs/backup.log 2>&1
```

```bash
# Créer le répertoire des logs
mkdir -p /home/collectoria/logs
mkdir -p /home/collectoria/backups/postgres
```

### 9.4 Procédure de restauration

```bash
# Identifier le backup à restaurer
ls -lh /home/collectoria/backups/postgres/

# Restaurer depuis un fichier de backup
BACKUP_FILE="/home/collectoria/backups/postgres/collection_management_20260426_020000.sql.gz"

export $(grep -v '^#' /home/collectoria/collectoria/.env.production | xargs)

# ATTENTION : Cette commande écrase les données actuelles
# Arrêter le backend d'abord pour éviter des écritures pendant la restauration
docker compose -f /home/collectoria/collectoria/docker-compose.prod.yml stop backend-collection

# Restaurer
gunzip -c "${BACKUP_FILE}" | docker exec -i collectoria-postgres-collection \
  psql -U "${POSTGRES_COLLECTION_USER}" -d "${POSTGRES_COLLECTION_DB}"

# Redémarrer le backend
docker compose -f /home/collectoria/collectoria/docker-compose.prod.yml start backend-collection

echo "Restauration terminée"
```

---

## 10. Monitoring léger

### 10.1 Logs Docker

```bash
# Voir les logs en temps réel de tous les services
docker compose -f docker-compose.prod.yml logs -f

# Logs d'un service spécifique (100 dernières lignes)
docker compose -f docker-compose.prod.yml logs --tail=100 backend-collection
docker compose -f docker-compose.prod.yml logs --tail=100 frontend
docker compose -f docker-compose.prod.yml logs --tail=100 traefik

# Rechercher une erreur dans les logs
docker compose -f docker-compose.prod.yml logs backend-collection | grep -i error
```

### 10.2 Health checks dans docker-compose.prod.yml

Les health checks sont déjà définis dans le `docker-compose.prod.yml` de la section 4 :
- `postgres-collection` : `pg_isready` toutes les 10s
- `backend-collection` : `wget` sur `/api/v1/health` toutes les 30s
- `frontend` : `wget` sur `/` toutes les 30s

Vérifier l'état des health checks :

```bash
docker compose -f docker-compose.prod.yml ps
# La colonne "STATUS" indique "Up (healthy)" ou "Up (unhealthy)"
```

### 10.3 Uptime Kuma (recommandé)

Uptime Kuma est un outil self-hosted léger de monitoring de disponibilité (< 100 Mo RAM). Il envoie des alertes par email ou Telegram quand un service tombe.

**Déploiement rapide :**

```bash
# Ajouter dans docker-compose.prod.yml ou dans un compose séparé
# uptime-kuma tourne sur un port différent (3001), protégé par Traefik

cat >> /home/collectoria/collectoria/docker-compose.prod.yml << 'EOF'

  # ─────────────────────────────────────────────
  # UPTIME KUMA — Monitoring de disponibilité
  # ─────────────────────────────────────────────
  uptime-kuma:
    image: louislam/uptime-kuma:1
    container_name: collectoria-uptime-kuma
    restart: unless-stopped
    volumes:
      - uptime_kuma_data:/app/data
    networks:
      - proxy
    labels:
      - "traefik.enable=true"
      - "traefik.http.routers.uptime-kuma.rule=Host(`status.${DOMAIN}`)"
      - "traefik.http.routers.uptime-kuma.entrypoints=websecure"
      - "traefik.http.routers.uptime-kuma.tls.certresolver=letsencrypt"
      - "traefik.http.services.uptime-kuma.loadbalancer.server.port=3001"
EOF
```

Ne pas oublier d'ajouter `uptime_kuma_data` dans la section `volumes` du compose.

Ajouter aussi l'enregistrement DNS `status.collectoria.example.com` pointant vers l'IP du VPS.

**Configuration après déploiement :**

1. Accéder à `https://status.collectoria.example.com`
2. Créer un compte admin (première connexion)
3. Ajouter les moniteurs :
   - HTTP(s) — `https://collectoria.example.com` (frontend) — interval 60s
   - HTTP(s) — `https://collectoria.example.com/api/v1/health` (backend) — interval 60s

---

## 11. Procédure de premier déploiement

### Checklist complète — premier déploiement depuis zéro

Suivre ces étapes dans l'ordre. Ne pas sauter d'étape.

```
[ ] Étape 1  : VPS commandé chez OVH et réceptionné (IP + mot de passe root)
[ ] Étape 2  : Domaine acheté chez OVH
[ ] Étape 3  : Enregistrement DNS A créé pointant vers l'IP du VPS (TTL 300)
[ ] Étape 4  : Attente propagation DNS (vérifier avec : dig +short mon-domaine.com)
[ ] Étape 5  : Provisioning serveur (section 1)
[ ] Étape 6  : Installation Docker (section 2)
[ ] Étape 7  : Clonage du dépôt git sur le VPS
[ ] Étape 8  : Création du fichier .env.production sur le VPS
[ ] Étape 9  : Mise en place des fichiers Traefik
[ ] Étape 10 : Démarrage de l'infrastructure
[ ] Étape 11 : Vérification des certificats TLS
[ ] Étape 12 : Application des migrations SQL
[ ] Étape 13 : Configuration des secrets GitHub Actions
[ ] Étape 14 : Premier push sur main → déclenchement du pipeline CI/CD
[ ] Étape 15 : Vérification santé de l'application
```

### Commandes exactes dans l'ordre

```bash
# ─── DEPUIS VOTRE MACHINE LOCALE ───────────────────────────────────────────────

# Étape 3 : Vérifier que le DNS est propagé
dig +short votre-domaine.com A
# Doit retourner : <IP_DU_VPS>

# ─── SUR LE VPS (en root) ──────────────────────────────────────────────────────

# Étape 5 : Provisioning (section 1 intégralement)
# [Suivre les commandes de la section 1]

# Étape 6 : Docker (section 2 intégralement)
# [Suivre les commandes de la section 2]

# ─── SUR LE VPS (en tant que collectoria) ──────────────────────────────────────

# Étape 7 : Cloner le dépôt
cd /home/collectoria
git clone https://github.com/VOTRE_USERNAME/Collectoria.git collectoria
cd collectoria

# Créer le réseau Docker proxy
docker network create collectoria_proxy

# Étape 8 : Créer le fichier .env.production
# Générer les secrets d'abord
JWT_SECRET=$(openssl rand -hex 32)
PG_PASSWORD=$(openssl rand -base64 24 | tr -d '=+/' | head -c 32)

echo "JWT_SECRET   : ${JWT_SECRET}"
echo "PG_PASSWORD  : ${PG_PASSWORD}"
echo "Notez ces valeurs dans un gestionnaire de mots de passe !"

# Créer le fichier .env.production
cat > .env.production << EOF
DOMAIN=votre-domaine.com
POSTGRES_COLLECTION_USER=collectoria_prod
POSTGRES_COLLECTION_PASSWORD=${PG_PASSWORD}
POSTGRES_COLLECTION_DB=collection_management
JWT_SECRET=${JWT_SECRET}
JWT_EXPIRATION_HOURS=24
JWT_ISSUER=collectoria-api
CORS_ALLOWED_ORIGINS=https://votre-domaine.com
GITHUB_REPOSITORY_OWNER=VOTRE_USERNAME_GITHUB
BACKEND_IMAGE_TAG=latest
FRONTEND_IMAGE_TAG=latest
RATE_LIMIT_LOGIN_REQUESTS=5
RATE_LIMIT_LOGIN_WINDOW=15m
RATE_LIMIT_READ_REQUESTS=100
RATE_LIMIT_READ_WINDOW=1m
RATE_LIMIT_WRITE_REQUESTS=30
RATE_LIMIT_WRITE_WINDOW=1m
EOF
chmod 600 .env.production

# Étape 9 : Mettre en place les fichiers Traefik
mkdir -p traefik letsencrypt
# [Copier traefik/traefik.yml et traefik/dynamic.yml tels que définis en section 3]
# Remplacer "votre-email@example.com" dans traefik.yml
touch letsencrypt/acme.json
chmod 600 letsencrypt/acme.json

# Étape 10 : Démarrer l'infrastructure de base (Traefik + PostgreSQL uniquement)
docker compose -f docker-compose.prod.yml \
  --env-file .env.production \
  up -d traefik postgres-collection

# Vérifier que PostgreSQL est sain
docker compose -f docker-compose.prod.yml ps
# Attendre "healthy" pour postgres-collection

# Étape 11 : Les certificats TLS sont générés automatiquement par Traefik
# Vérifier dans les logs de Traefik
docker compose -f docker-compose.prod.yml logs traefik | grep -i "certificate"
# Attendre 30 à 60 secondes après le démarrage de Traefik

# Étape 12 : Appliquer les migrations SQL
export $(grep -v '^#' .env.production | xargs)

# Migration 001 : Schéma principal
docker exec -i collectoria-postgres-collection \
  psql -U "${POSTGRES_COLLECTION_USER}" -d "${POSTGRES_COLLECTION_DB}" \
  < backend/collection-management/migrations/001_create_collections_schema.sql

# Migration 002 : Seed MECCG réel (attention : fichier lourd ~497 Ko)
docker exec -i collectoria-postgres-collection \
  psql -U "${POSTGRES_COLLECTION_USER}" -d "${POSTGRES_COLLECTION_DB}" \
  < backend/collection-management/migrations/002_seed_meccg_real.sql

# Migration 003 : Table activités
docker exec -i collectoria-postgres-collection \
  psql -U "${POSTGRES_COLLECTION_USER}" -d "${POSTGRES_COLLECTION_DB}" \
  < backend/collection-management/migrations/003_create_activities_table.sql

# Note : Migration 004 (seed_dev_possession) = données de dev, NE PAS appliquer en prod
# C'est une seed de développement, pas de production

# Migration 005 : Collection Books
docker exec -i collectoria-postgres-collection \
  psql -U "${POSTGRES_COLLECTION_USER}" -d "${POSTGRES_COLLECTION_DB}" \
  < backend/collection-management/migrations/005_add_books_collection.sql

# Migration 006 : Title/description activities
docker exec -i collectoria-postgres-collection \
  psql -U "${POSTGRES_COLLECTION_USER}" -d "${POSTGRES_COLLECTION_DB}" \
  < backend/collection-management/migrations/006_add_title_description_to_activities.sql

# Migration 007 : Allow null name_fr
docker exec -i collectoria-postgres-collection \
  psql -U "${POSTGRES_COLLECTION_USER}" -d "${POSTGRES_COLLECTION_DB}" \
  < backend/collection-management/migrations/007_allow_null_name_fr.sql

# Migration 008 : Correction noms MECCG
docker exec -i collectoria-postgres-collection \
  psql -U "${POSTGRES_COLLECTION_USER}" -d "${POSTGRES_COLLECTION_DB}" \
  < backend/collection-management/migrations/008_update_meccg_corrected_names.sql

# Migration 009 : Correction complète noms MECCG
docker exec -i collectoria-postgres-collection \
  psql -U "${POSTGRES_COLLECTION_USER}" -d "${POSTGRES_COLLECTION_DB}" \
  < backend/collection-management/migrations/009_fix_all_meccg_names_from_csv.sql

# Vérifier la base de données
docker exec collectoria-postgres-collection \
  psql -U "${POSTGRES_COLLECTION_USER}" -d "${POSTGRES_COLLECTION_DB}" \
  -c "SELECT COUNT(*) as total_cards FROM cards;"
# Attendu : 1679

# Étape 13 : Configurer les secrets GitHub Actions
# (Faire dans l'interface GitHub — voir section 8.1)

# Étape 14 : Premier push sur main
# DEPUIS VOTRE MACHINE LOCALE
git add .
git commit -m "chore: add production Docker configuration"
git push origin main
# Observer le pipeline sur GitHub Actions

# Étape 15 : Après succès du pipeline, vérifier l'application
curl -f https://votre-domaine.com/api/v1/health
curl -f https://votre-domaine.com
```

### Vérification finale

```bash
# Sur le VPS
docker compose -f docker-compose.prod.yml ps
# Tous les services doivent être "Up (healthy)"

# Test des endpoints
curl -s https://votre-domaine.com/api/v1/health | python3 -m json.tool
# Attendu : {"status":"ok","database":"healthy",...}

# Test authentification
curl -s -X POST https://votre-domaine.com/api/v1/auth/login \
  -H "Content-Type: application/json" \
  -d '{"email":"arnaud.dars@gmail.com","password":"flying38"}' \
  | python3 -m json.tool
# Attendu : {"token":"...","expires_at":"..."}

# Test TLS
openssl s_client -connect votre-domaine.com:443 -servername votre-domaine.com </dev/null 2>&1 | \
  grep -E "subject|issuer|Verify"
# "Let's Encrypt" doit apparaître dans "issuer"
```

---

## 12. Procédure de mise à jour

### 12.1 Ce qui se passe automatiquement via CI/CD

Lors de tout push sur la branche `main` :

1. **Tests** : Go tests + Vitest frontend s'exécutent automatiquement
2. **Build** : Nouvelles images Docker buildées et poussées sur ghcr.io
3. **Déploiement** :
   - SSH sur le VPS
   - Pull des nouvelles images
   - Redémarrage des containers `backend-collection` et `frontend` uniquement
   - Health check automatique (60s max)
4. **Rollback automatique** : Si le health check échoue, le pipeline marque le déploiement comme échoué. L'ancien container continue de tourner.

### 12.2 Ce qui nécessite une intervention manuelle

#### Migrations de base de données

Toute nouvelle migration SQL doit être appliquée manuellement sur le VPS avant ou après le déploiement selon son type :

**Migration additive (ajouter colonnes, tables, index)** :
```bash
# Appliquer AVANT le déploiement du backend qui en dépend
ssh collectoria@<IP_DU_VPS>
cd /home/collectoria/collectoria
export $(grep -v '^#' .env.production | xargs)
docker exec -i collectoria-postgres-collection \
  psql -U "${POSTGRES_COLLECTION_USER}" -d "${POSTGRES_COLLECTION_DB}" \
  < backend/collection-management/migrations/0XX_nouvelle_migration.sql
# Puis pousser sur main pour déclencher le déploiement
```

**Migration destructive (supprimer colonnes, renommer)** :
```bash
# 1. Déployer d'abord la version du code compatible avec les deux états du schéma
# 2. Appliquer la migration
# 3. Déployer la version finale du code
```

#### Changements de configuration

Si `.env.production` doit être modifié (nouveau secret, nouveau domaine, etc.) :

```bash
ssh collectoria@<IP_DU_VPS>
cd /home/collectoria/collectoria

# Éditer le fichier
nano .env.production

# Redémarrer le service concerné pour prendre en compte les nouvelles variables
docker compose -f docker-compose.prod.yml \
  --env-file .env.production \
  up -d --no-deps backend-collection
```

#### Mise à jour de PostgreSQL

```bash
# 1. Faire un backup complet avant toute chose
/home/collectoria/scripts/backup-db.sh

# 2. Modifier l'image dans docker-compose.prod.yml (ex: postgres:15 → postgres:16)
# 3. Redémarrer uniquement postgres (ATTENTION : peut nécessiter une migration de données)
docker compose -f docker-compose.prod.yml \
  --env-file .env.production \
  up -d --no-deps postgres-collection
```

#### Mise à jour de Traefik

```bash
# Modifier le tag dans docker-compose.prod.yml (ex: traefik:v3.0 → traefik:v3.1)
docker compose -f docker-compose.prod.yml \
  --env-file .env.production \
  up -d --no-deps traefik
# Les certificats Let's Encrypt sont dans le volume et sont conservés
```

#### Renouvellement des certificats Let's Encrypt

Traefik gère le renouvellement automatique des certificats (avant leur expiration à 90 jours). Aucune intervention manuelle n'est nécessaire en fonctionnement normal.

En cas de problème :

```bash
# Vérifier l'état des certificats
docker compose -f docker-compose.prod.yml logs traefik | grep -i "acme\|certificate\|renew"

# Forcer le renouvellement (en dernier recours : supprimer acme.json)
# ATTENTION : interruption du service HTTPS pendant quelques minutes
docker compose -f docker-compose.prod.yml stop traefik
rm letsencrypt/acme.json
touch letsencrypt/acme.json
chmod 600 letsencrypt/acme.json
docker compose -f docker-compose.prod.yml start traefik
```

### 12.3 Rollback manuel d'urgence

Si un déploiement provoque une régression non détectée par les health checks :

```bash
ssh collectoria@<IP_DU_VPS>
cd /home/collectoria/collectoria
export $(grep -v '^#' .env.production | xargs)

# Identifier le SHA du dernier déploiement stable
# (visible dans les logs GitHub Actions ou dans les tags d'images)
STABLE_SHA="sha-abc1234"

export BACKEND_IMAGE_TAG="${STABLE_SHA}"
export FRONTEND_IMAGE_TAG="${STABLE_SHA}"

docker compose -f docker-compose.prod.yml \
  --env-file .env.production \
  up -d --no-deps backend-collection frontend

echo "Rollback vers ${STABLE_SHA} effectué"
```

---

## Annexe : Architecture réseau

```
Internet
    │
    ▼
[VPS OVH - Ubuntu 24.10]
    │
[UFW Firewall]
    │  ports 80, 443
    ▼
[Traefik v3 - container]────────────── collectoria_proxy network
    │
    ├── traefik.collectoria.example.com → [collectoria-frontend:3000]
    │
    └── traefik /api/** → [collectoria-backend-collection:8080]
                                │
                         backend_internal network (isolé)
                                │
                         [collectoria-postgres-collection:5432]
                         (volume : collectoria_postgres_collection_data)
```

## Annexe : Commandes de diagnostic rapide

```bash
# État de tous les containers
docker compose -f docker-compose.prod.yml ps

# Utilisation des ressources
docker stats --no-stream

# Espace disque
df -h
docker system df

# Logs en temps réel
docker compose -f docker-compose.prod.yml logs -f --tail=50

# Tester la connectivité interne backend → postgres
docker exec collectoria-backend-collection \
  wget --no-verbose --tries=1 -O- \
  http://localhost:8080/api/v1/health

# Lister les images présentes et leur taille
docker images | grep collectoria

# Inspecter un volume
docker volume inspect collectoria_postgres_collection_data
```
