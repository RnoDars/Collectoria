# Uptime Kuma — Surveillance de disponibilité

**Dernière mise à jour** : 2026-04-26  
**Prérequis** :
- VPS provisionné avec Docker — voir [production-setup.md](../production-setup.md)
- Réseau Docker `monitoring` créé — voir [00-overview.md](00-overview.md)
- Enregistrement DNS `status.mondomaine.com` pointant vers le VPS
- Stack applicative déployée (backend, frontend, PostgreSQL)

---

## Table des matières

1. [Ajout au docker-compose.prod.yml](#1-ajout-au-docker-composeprodym)
2. [Démarrage du service](#2-démarrage-du-service)
3. [Accès initial et création du compte admin](#3-accès-initial-et-création-du-compte-admin)
4. [Configuration des monitors](#4-configuration-des-monitors)
5. [Configuration des alertes Telegram](#5-configuration-des-alertes-telegram)
6. [Configuration des alertes email (alternative)](#6-configuration-des-alertes-email-alternative)
7. [Vérification finale](#7-vérification-finale)

---

## 1. Ajout au docker-compose.prod.yml

Ajouter le service Uptime Kuma dans le fichier `docker-compose.prod.yml` existant.

**Section `networks`** — ajouter le réseau `monitoring` à la liste des réseaux externes :

```yaml
networks:
  proxy:
    name: collectoria_proxy
    external: true
  backend_internal:
    internal: true
  monitoring:
    name: monitoring
    external: true
```

**Section `volumes`** — ajouter le volume Uptime Kuma :

```yaml
volumes:
  postgres_collection_data:
    name: collectoria_postgres_collection_data
  traefik_letsencrypt:
    name: collectoria_traefik_letsencrypt
  uptime_kuma_data:
    name: collectoria_uptime_kuma_data
```

**Section `services`** — ajouter le service :

```yaml
  # ─────────────────────────────────────────────
  # UPTIME KUMA — Surveillance de disponibilité
  # ─────────────────────────────────────────────
  uptime-kuma:
    image: louislam/uptime-kuma:1
    container_name: collectoria-uptime-kuma
    restart: unless-stopped
    security_opt:
      - no-new-privileges:true
    volumes:
      - uptime_kuma_data:/app/data
    networks:
      - proxy
      - monitoring
    labels:
      - "traefik.enable=true"
      - "traefik.http.routers.uptime-kuma.rule=Host(`status.${DOMAIN}`)"
      - "traefik.http.routers.uptime-kuma.entrypoints=websecure"
      - "traefik.http.routers.uptime-kuma.tls.certresolver=letsencrypt"
      - "traefik.http.routers.uptime-kuma.middlewares=security-headers@file"
      - "traefik.http.services.uptime-kuma.loadbalancer.server.port=3001"
    healthcheck:
      test: ["CMD", "wget", "--no-verbose", "--tries=1", "--spider", "http://localhost:3001"]
      interval: 30s
      timeout: 10s
      retries: 3
      start_period: 30s
```

**Note** : Uptime Kuma est connecté aux deux réseaux `proxy` (pour Traefik) et `monitoring` (pour le réseau dédié monitoring). Il n'a pas besoin d'accéder à `backend_internal`.

---

## 2. Démarrage du service

```bash
cd /home/collectoria/collectoria

# Charger les variables d'environnement
export $(grep -v '^#' .env.production | xargs)

# Démarrer uniquement Uptime Kuma (sans perturber les autres services)
docker compose -f docker-compose.prod.yml \
  --env-file .env.production \
  up -d uptime-kuma

# Vérifier que le container est démarré
docker compose -f docker-compose.prod.yml ps uptime-kuma
# Attendu : STATUS "Up" ou "Up (healthy)"

# Suivre les logs de démarrage
docker compose -f docker-compose.prod.yml logs -f uptime-kuma
# Ctrl+C pour quitter les logs une fois "Listening on 3001" affiché
```

Attendre 30 à 60 secondes que Traefik détecte le nouveau service et que Let's Encrypt délivre le certificat pour `status.mondomaine.com`.

---

## 3. Accès initial et création du compte admin

Ouvrir un navigateur et accéder à `https://status.mondomaine.com`.

Lors de la **première connexion**, Uptime Kuma affiche un formulaire de création du compte administrateur :

1. Saisir un nom d'utilisateur (ex. `admin`)
2. Saisir un mot de passe fort (minimum 12 caractères, générer avec `openssl rand -base64 16`)
3. Cliquer sur **Create**

**Important** : noter ce mot de passe dans un gestionnaire de mots de passe. Uptime Kuma ne propose pas de réinitialisation par email native.

---

## 4. Configuration des monitors

### 4.1 Monitor backend — endpoint HTTP health

1. Cliquer sur **Add New Monitor**
2. **Monitor Type** : `HTTP(s)`
3. **Friendly Name** : `Collectoria Backend`
4. **URL** : `https://mondomaine.com/api/v1/health`
5. **Heartbeat Interval** : `60` secondes
6. **Retries** : `3`
7. **Accepted Status Codes** : `200`
8. Cliquer sur **Save**

### 4.2 Monitor frontend — page d'accueil

1. Cliquer sur **Add New Monitor**
2. **Monitor Type** : `HTTP(s)`
3. **Friendly Name** : `Collectoria Frontend`
4. **URL** : `https://mondomaine.com`
5. **Heartbeat Interval** : `60` secondes
6. **Retries** : `3`
7. **Accepted Status Codes** : `200`
8. Cliquer sur **Save**

### 4.3 Monitor PostgreSQL — TCP port

Uptime Kuma peut vérifier qu'un port TCP est ouvert sans avoir accès au container PostgreSQL. Cependant, PostgreSQL n'est pas exposé sur le réseau hôte (port 5432 non publié dans docker-compose.prod.yml). Il faut utiliser le nom réseau interne.

**Option A** : Monitor TCP via le nom du container (réseau `monitoring`)

Uptime Kuma peut résoudre les noms DNS des containers Docker si il est sur le même réseau. PostgreSQL est sur `backend_internal`, pas sur `monitoring`. Il faut donc surveiller PostgreSQL indirectement via le health check du backend (qui lui-même vérifie la connexion DB dans sa réponse `/api/v1/health`).

1. Cliquer sur **Add New Monitor**
2. **Monitor Type** : `HTTP(s) — Keyword`
3. **Friendly Name** : `PostgreSQL (via backend health)`
4. **URL** : `https://mondomaine.com/api/v1/health`
5. **Keyword** : `"database":"healthy"` (ou la valeur exacte retournée par votre endpoint)
6. **Heartbeat Interval** : `60` secondes
7. Cliquer sur **Save**

**Option B** : Monitor TCP direct si PostgreSQL expose son port localement

Si la configuration est modifiée pour publier le port 5432 sur l'interface loopback uniquement (`127.0.0.1:5432:5432`), Uptime Kuma peut le surveiller :

1. **Monitor Type** : `TCP Port`
2. **Friendly Name** : `PostgreSQL TCP`
3. **Hostname** : `collectoria-postgres-collection` (nom du container)
4. **Port** : `5432`
5. **Heartbeat Interval** : `60` secondes

### 4.4 Page de statut publique (optionnel)

Uptime Kuma propose une page de statut publique consultable sans authentification :

1. Aller dans **Status Page** → **New Status Page**
2. **Name** : `Collectoria Status`
3. **Slug** : `collectoria` (URL sera `https://status.mondomaine.com/status/collectoria`)
4. Ajouter les 3 monitors créés
5. Cliquer sur **Save**

---

## 5. Configuration des alertes Telegram

Telegram est recommandé pour les alertes : gratuit, instantané, fiable, et compatible avec les serveurs sans serveur email configuré.

### 5.1 Créer un bot Telegram

1. Ouvrir Telegram et rechercher `@BotFather`
2. Envoyer `/newbot`
3. Suivre les instructions : donner un nom, puis un username (doit finir par `bot`)
4. BotFather retourne un **token** de la forme `123456789:ABCdefGHIjklMNOpqrSTUvwxYZ`
5. Copier ce token — c'est votre `TELEGRAM_BOT_TOKEN`

### 5.2 Obtenir le Chat ID

1. Démarrer une conversation avec votre bot (cliquer `/start`)
2. Envoyer n'importe quel message au bot
3. Ouvrir dans un navigateur :
   ```
   https://api.telegram.org/bot<VOTRE_TOKEN>/getUpdates
   ```
4. Dans la réponse JSON, trouver `"chat":{"id":XXXXXXX}` — c'est votre `TELEGRAM_CHAT_ID`

### 5.3 Configurer la notification dans Uptime Kuma

1. Aller dans **Settings** → **Notifications** → **Setup Notification**
2. **Notification Type** : `Telegram`
3. **Friendly Name** : `Alerte Telegram Collectoria`
4. **Bot Token** : coller le token obtenu à l'étape 5.1
5. **Chat ID** : coller l'ID obtenu à l'étape 5.2
6. Cliquer sur **Test** pour vérifier que le message de test arrive dans Telegram
7. Cliquer sur **Save**

### 5.4 Attacher la notification aux monitors

Pour chaque monitor créé :

1. Éditer le monitor
2. Dans la section **Notifications**, activer la notification Telegram
3. Sauvegarder

---

## 6. Configuration des alertes email (alternative)

Si vous préférez les alertes par email (nécessite un serveur SMTP ou un service comme Mailgun/SendGrid) :

1. Aller dans **Settings** → **Notifications** → **Setup Notification**
2. **Notification Type** : `Email (SMTP)`
3. Remplir les champs SMTP :
   - **Hostname** : `smtp.gmail.com` (ou votre serveur SMTP)
   - **Port** : `587`
   - **Security** : `STARTTLS`
   - **Username** : votre adresse email
   - **Password** : mot de passe d'application (Gmail) ou clé API SMTP
   - **From** : `monitoring@mondomaine.com`
   - **To** : adresse de réception des alertes
4. Cliquer sur **Test**
5. Cliquer sur **Save**

**Note** : Pour Gmail, il faut activer la validation en deux étapes et créer un "mot de passe d'application" (Google Account → Security → App Passwords).

---

## 7. Vérification finale

```bash
# 1. Vérifier que le container tourne
docker ps | grep uptime-kuma
# Attendu : collectoria-uptime-kuma ... Up X minutes

# 2. Vérifier les logs (pas d'erreur)
docker logs collectoria-uptime-kuma --tail=20

# 3. Vérifier l'accès HTTPS
curl -I https://status.mondomaine.com
# Attendu : HTTP/2 200
# Le header "server: Caddy" ou similaire n'apparaît pas — Traefik masque le serveur en amont

# 4. Vérifier le certificat TLS
openssl s_client -connect status.mondomaine.com:443 \
  -servername status.mondomaine.com </dev/null 2>&1 | grep -E "subject|issuer"
# Attendu : "Let's Encrypt" dans le champ issuer

# 5. Vérifier le volume de données persistant
docker volume inspect collectoria_uptime_kuma_data
# Le volume doit exister et avoir un Mountpoint
```

**Test de bout en bout** :

1. Accéder à `https://status.mondomaine.com` dans le navigateur
2. Se connecter avec le compte admin
3. Les 3 monitors doivent être en vert (Up)
4. Vérifier qu'une alerte Telegram de test a bien été reçue (étape 5.3)

**Test d'alerte** (optionnel, en environnement de test) :

```bash
# Arrêter temporairement le backend pour déclencher une alerte
docker stop collectoria-backend-collection
# Attendre 2-3 cycles (2-3 minutes selon l'intervalle configuré)
# → Une alerte "Down" doit arriver sur Telegram

# Redémarrer le backend
docker start collectoria-backend-collection
# → Une alerte "Up" doit arriver sur Telegram
```
