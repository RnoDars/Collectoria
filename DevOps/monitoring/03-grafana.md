# Grafana — Dashboards métriques et logs

**Dernière mise à jour** : 2026-04-26  
**Prérequis** :
- Réseau Docker `monitoring` créé — voir [00-overview.md](00-overview.md)
- Prometheus démarré et opérationnel — voir [02-prometheus.md](02-prometheus.md)
- Enregistrement DNS `grafana.mondomaine.com` pointant vers le VPS
- Loki démarré (pour la datasource Loki) — voir [04-loki-promtail.md](04-loki-promtail.md)

---

## Table des matières

1. [Structure des fichiers de configuration](#1-structure-des-fichiers-de-configuration)
2. [Provisioning automatique des datasources](#2-provisioning-automatique-des-datasources)
3. [Provisioning automatique des dashboards](#3-provisioning-automatique-des-dashboards)
4. [Ajout au docker-compose.monitoring.yml](#4-ajout-au-docker-composemonitoringyml)
5. [Variables d'environnement Grafana](#5-variables-denvironnement-grafana)
6. [Démarrage](#6-démarrage)
7. [Configuration initiale dans l'interface](#7-configuration-initiale-dans-linterface)
8. [Import des dashboards communautaires](#8-import-des-dashboards-communautaires)
9. [Vérification finale](#9-vérification-finale)

---

## 1. Structure des fichiers de configuration

Grafana supporte le **provisioning** : les datasources et dashboards peuvent être préconfigurés via des fichiers YAML/JSON, sans manipulation manuelle dans l'interface.

```bash
mkdir -p /home/collectoria/collectoria/monitoring/grafana/provisioning/datasources
mkdir -p /home/collectoria/collectoria/monitoring/grafana/provisioning/dashboards
```

Arborescence :

```
monitoring/grafana/
└── provisioning/
    ├── datasources/
    │   └── datasources.yml      (Prometheus + Loki)
    └── dashboards/
        └── dashboards.yml       (répertoire source des dashboards JSON)
```

---

## 2. Provisioning automatique des datasources

Créer `/home/collectoria/collectoria/monitoring/grafana/provisioning/datasources/datasources.yml` :

```yaml
# datasources.yml
# Datasources préconfigurées — chargées automatiquement au démarrage de Grafana

apiVersion: 1

datasources:

  # ─────────────────────────────────────────────
  # Prometheus — métriques
  # ─────────────────────────────────────────────
  - name: Prometheus
    type: prometheus
    access: proxy
    url: http://collectoria-prometheus:9090
    uid: prometheus-collectoria
    isDefault: true
    jsonData:
      timeInterval: "15s"
      httpMethod: "POST"
    editable: false

  # ─────────────────────────────────────────────
  # Loki — logs
  # ─────────────────────────────────────────────
  - name: Loki
    type: loki
    access: proxy
    url: http://collectoria-loki:3100
    uid: loki-collectoria
    isDefault: false
    jsonData:
      maxLines: 1000
    editable: false
```

**Note** : `editable: false` empêche la modification accidentelle des datasources depuis l'interface Grafana. Pour modifier une datasource, éditer ce fichier et redémarrer Grafana.

---

## 3. Provisioning automatique des dashboards

Créer `/home/collectoria/collectoria/monitoring/grafana/provisioning/dashboards/dashboards.yml` :

```yaml
# dashboards.yml
# Indique à Grafana où trouver les fichiers JSON des dashboards

apiVersion: 1

providers:
  - name: 'collectoria-dashboards'
    orgId: 1
    folder: 'Collectoria'
    type: file
    disableDeletion: false
    updateIntervalSeconds: 30
    allowUiUpdates: true
    options:
      path: /var/lib/grafana/dashboards
```

Les fichiers JSON des dashboards seront placés dans `/home/collectoria/collectoria/monitoring/grafana/dashboards/` (monté en volume dans le container).

---

## 4. Ajout au docker-compose.monitoring.yml

Ajouter le service Grafana dans `/home/collectoria/collectoria/docker-compose.monitoring.yml`.

**Section `volumes`** — ajouter :

```yaml
volumes:
  prometheus_data:
    name: collectoria_prometheus_data
  grafana_data:
    name: collectoria_grafana_data
```

**Section `services`** — ajouter :

```yaml
  # ─────────────────────────────────────────────
  # GRAFANA — Dashboards métriques et logs
  # ─────────────────────────────────────────────
  grafana:
    image: grafana/grafana-oss:10.4.2
    container_name: collectoria-grafana
    restart: unless-stopped
    security_opt:
      - no-new-privileges:true
    user: "472:472"    # UID/GID grafana officiel
    environment:
      # Sécurité : désactiver la création de compte anonyme
      GF_AUTH_ANONYMOUS_ENABLED: "false"
      GF_AUTH_ANONYMOUS_ORG_ROLE: "Viewer"
      # Désactiver la télémétrie Grafana
      GF_ANALYTICS_REPORTING_ENABLED: "false"
      GF_ANALYTICS_CHECK_FOR_UPDATES: "false"
      # Mot de passe admin — JAMAIS hardcodé, lu depuis .env.monitoring
      GF_SECURITY_ADMIN_PASSWORD__FILE: /run/secrets/grafana_admin_password
      GF_SECURITY_ADMIN_USER: ${GRAFANA_ADMIN_USER}
      # URL externe pour les liens dans les dashboards
      GF_SERVER_ROOT_URL: "https://grafana.mondomaine.com"
      GF_SERVER_DOMAIN: "grafana.mondomaine.com"
      # Chemin des dashboards provisionnés
      GF_PATHS_PROVISIONING: /etc/grafana/provisioning
      # Logs
      GF_LOG_LEVEL: "warn"
      GF_LOG_MODE: "console"
      # Désactiver le signup
      GF_USERS_ALLOW_SIGN_UP: "false"
    secrets:
      - grafana_admin_password
    volumes:
      - grafana_data:/var/lib/grafana
      - ./monitoring/grafana/provisioning:/etc/grafana/provisioning:ro
      - ./monitoring/grafana/dashboards:/var/lib/grafana/dashboards:ro
    networks:
      - monitoring
      - proxy        # pour Traefik
    labels:
      - "traefik.enable=true"
      - "traefik.http.routers.grafana.rule=Host(`grafana.${DOMAIN}`)"
      - "traefik.http.routers.grafana.entrypoints=websecure"
      - "traefik.http.routers.grafana.tls.certresolver=letsencrypt"
      - "traefik.http.routers.grafana.middlewares=security-headers@file"
      - "traefik.http.services.grafana.loadbalancer.server.port=3000"
    depends_on:
      - prometheus
    healthcheck:
      test: ["CMD", "wget", "--no-verbose", "--tries=1", "--spider", "http://localhost:3000/api/health"]
      interval: 30s
      timeout: 10s
      retries: 3
      start_period: 60s

secrets:
  grafana_admin_password:
    file: ./secrets/grafana_admin_password.txt
```

**Note sur les secrets Docker** : Grafana lit le mot de passe admin depuis un fichier secret monté en `/run/secrets/grafana_admin_password`. Cela évite de passer le mot de passe en variable d'environnement (visible dans `docker inspect`).

---

## 5. Variables d'environnement Grafana

Créer le fichier secret sur le VPS :

```bash
mkdir -p /home/collectoria/collectoria/secrets

# Générer un mot de passe admin fort
GRAFANA_PASSWORD=$(openssl rand -base64 24 | tr -d '=+/' | head -c 32)
echo "Grafana admin password : ${GRAFANA_PASSWORD}"
echo "Notez ce mot de passe dans votre gestionnaire de mots de passe !"

# Écrire dans le fichier secret
echo -n "${GRAFANA_PASSWORD}" > /home/collectoria/collectoria/secrets/grafana_admin_password.txt

# Permissions restrictives
chmod 600 /home/collectoria/collectoria/secrets/grafana_admin_password.txt
chmod 700 /home/collectoria/collectoria/secrets/
```

Ajouter les variables Grafana dans `.env.monitoring` :

```bash
# Ajouter dans .env.monitoring
cat >> /home/collectoria/collectoria/.env.monitoring << 'EOF'

# Grafana
GRAFANA_ADMIN_USER=admin
EOF
```

Ajouter `secrets/` au `.gitignore` de la racine du projet (si pas déjà présent) :

```bash
# Vérifier
grep -q "secrets/" /home/collectoria/collectoria/.gitignore || \
  echo "secrets/" >> /home/collectoria/collectoria/.gitignore
```

---

## 6. Démarrage

```bash
cd /home/collectoria/collectoria

# Créer le répertoire des dashboards si absent
mkdir -p monitoring/grafana/dashboards

# Démarrer ou redémarrer la stack monitoring avec Grafana
docker compose -f docker-compose.monitoring.yml \
  --env-file .env.monitoring \
  up -d grafana

# Suivre les logs de démarrage
docker compose -f docker-compose.monitoring.yml logs -f grafana
# Attendre "HTTP Server Listen" dans les logs
# Ctrl+C pour quitter

# Vérifier l'état
docker compose -f docker-compose.monitoring.yml ps grafana
```

Attendre 30 à 60 secondes pour que Traefik détecte le service et que Let's Encrypt délivre le certificat.

---

## 7. Configuration initiale dans l'interface

Accéder à `https://grafana.mondomaine.com`.

Se connecter avec :
- **Username** : `admin` (ou la valeur de `GRAFANA_ADMIN_USER`)
- **Password** : le mot de passe généré à l'étape 5

Grafana propose de changer le mot de passe à la première connexion — **ne pas le changer ici** (il est géré par le fichier secret). Cliquer sur **Skip** ou **Later**.

### Vérifier les datasources provisionnées

1. Aller dans **Connections** → **Data sources**
2. Deux datasources doivent être présentes : `Prometheus` et `Loki`
3. Cliquer sur **Prometheus** → **Save & test** → doit afficher "Data source is working"
4. Cliquer sur **Loki** → **Save & test** → doit afficher "Data source connected and labels found" (uniquement après démarrage de Loki — voir [04-loki-promtail.md](04-loki-promtail.md))

---

## 8. Import des dashboards communautaires

Les dashboards suivants sont disponibles sur [grafana.com/grafana/dashboards](https://grafana.com/grafana/dashboards) et compatibles avec les exporters configurés.

### 8.1 Node Exporter Full — ID 1860

Dashboard complet pour les métriques système (CPU, RAM, disque, réseau, I/O).

1. Aller dans **Dashboards** → **New** → **Import**
2. Saisir l'ID `1860` dans le champ "Import via grafana.com"
3. Cliquer sur **Load**
4. **Prometheus** : sélectionner `Prometheus` (datasource configurée)
5. Cliquer sur **Import**

Ce dashboard affiche : utilisation CPU par core, charge système, RAM disponible/utilisée, swap, espace disque, I/O disque, trafic réseau.

### 8.2 Go runtime métriques — ID 13240

Dashboard pour les métriques Go runtime (goroutines, GC, heap, threads).

1. **Dashboards** → **New** → **Import**
2. ID : `13240`
3. **Prometheus** : sélectionner `Prometheus`
4. Cliquer sur **Import**

Ce dashboard nécessite que le backend Go expose `/metrics` avec les métriques Go standard (`go_goroutines`, `go_memstats_*`, etc.) — ce qui est automatique avec `prometheus/client_golang` (voir [05-backend-instrumentation.md](05-backend-instrumentation.md)).

### 8.3 PostgreSQL Database — ID 9628

Dashboard pour les métriques PostgreSQL (connexions, transactions, taille base, locks, cache hit).

1. **Dashboards** → **New** → **Import**
2. ID : `9628`
3. **Prometheus** : sélectionner `Prometheus`
4. Cliquer sur **Import**

### 8.4 Créer un dossier pour les dashboards Collectoria

Avant l'import, créer un dossier pour organiser les dashboards :

1. **Dashboards** → **New** → **New folder**
2. Nommer le dossier `Collectoria`
3. Lors de chaque import, sélectionner le dossier `Collectoria`

---

## 9. Vérification finale

```bash
# 1. Vérifier que Grafana est healthy
curl -s https://grafana.mondomaine.com/api/health
# Attendu : {"commit":"...","database":"ok","version":"..."}

# 2. Vérifier les logs (pas d'erreur critique)
docker logs collectoria-grafana --tail=30

# 3. Vérifier le certificat TLS
openssl s_client -connect grafana.mondomaine.com:443 \
  -servername grafana.mondomaine.com </dev/null 2>&1 | grep -E "subject|issuer"
# "Let's Encrypt" doit apparaître dans issuer

# 4. Vérifier que les datasources répondent
# Via l'interface Grafana → Connections → Data sources → Save & test

# 5. Vérifier le volume de données
docker volume inspect collectoria_grafana_data
```

**Test des dashboards** :

1. Ouvrir le dashboard **Node Exporter Full** — les graphiques CPU, RAM, disque doivent afficher des données en temps réel.
2. Ouvrir le dashboard **PostgreSQL** — `pg_up` doit valoir 1 et les métriques de connexion doivent être visibles.
3. Ouvrir le dashboard **Go runtime** — visible uniquement après instrumentation du backend (voir [05-backend-instrumentation.md](05-backend-instrumentation.md)).
