# Loki + Promtail — Agrégation des logs Docker

**Dernière mise à jour** : 2026-04-26  
**Prérequis** :
- Réseau Docker `monitoring` créé — voir [00-overview.md](00-overview.md)
- Grafana démarré et opérationnel — voir [03-grafana.md](03-grafana.md)
- Tous les containers applicatifs tournent (backend, frontend, PostgreSQL, Traefik)

---

## Table des matières

1. [Principe de fonctionnement](#1-principe-de-fonctionnement)
2. [Configuration Loki](#2-configuration-loki)
3. [Configuration Promtail](#3-configuration-promtail)
4. [Ajout au docker-compose.monitoring.yml](#4-ajout-au-docker-composemonitoringyml)
5. [Démarrage](#5-démarrage)
6. [Vérification des logs dans Grafana](#6-vérification-des-logs-dans-grafana)
7. [Requêtes LogQL utiles](#7-requêtes-logql-utiles)
8. [Vérification finale](#8-vérification-finale)

---

## 1. Principe de fonctionnement

```
Containers Docker
(backend, frontend, postgres, traefik)
        │
        │ écrivent dans
        ▼
/var/lib/docker/containers/<id>/<id>-json.log
        │
        │ lu par
        ▼
   [Promtail]
   - découverte automatique des containers via Docker API
   - ajout de labels (container_name, service, image)
   - envoi en streaming vers Loki
        │
        │ push HTTP
        ▼
     [Loki]
   - stockage indexé des logs
   - requêtes via LogQL
        │
        │ requêtes LogQL
        ▼
    [Grafana]
   - exploration interactive des logs
   - corrélation avec les métriques Prometheus
```

**Différence avec Elasticsearch** : Loki n'indexe que les labels (metadata), pas le contenu des logs. C'est pourquoi il est très léger en RAM (~150 Mo) comparé à un stack ELK (~1–2 Go).

---

## 2. Configuration Loki

Créer le répertoire de configuration :

```bash
mkdir -p /home/collectoria/collectoria/monitoring/loki
mkdir -p /home/collectoria/collectoria/monitoring/promtail
```

Créer `/home/collectoria/collectoria/monitoring/loki/loki-config.yml` :

```yaml
# loki-config.yml
# Configuration Loki pour Collectoria

auth_enabled: false    # Pas d'authentification multi-tenant (instance single-tenant)

server:
  http_listen_port: 3100
  grpc_listen_port: 9096
  log_level: warn

common:
  instance_addr: 127.0.0.1
  path_prefix: /loki
  storage:
    filesystem:
      chunks_directory: /loki/chunks
      rules_directory: /loki/rules
  replication_factor: 1
  ring:
    kvstore:
      store: inmemory

schema_config:
  configs:
    - from: 2024-01-01
      store: tsdb
      object_store: filesystem
      schema: v13
      index:
        prefix: index_
        period: 24h

ingester:
  chunk_idle_period: 3m
  chunk_block_size: 262144
  chunk_retain_period: 1m
  wal:
    dir: /loki/wal

limits_config:
  # Rétention des logs : 30 jours
  retention_period: 720h
  # Limite de débit d'ingestion par stream
  ingestion_rate_mb: 4
  ingestion_burst_size_mb: 6
  # Limite du nombre de streams actifs par tenant
  max_streams_per_user: 10000
  max_global_streams_per_user: 10000

compactor:
  working_directory: /loki/boltdb-shipper-compactor
  compaction_interval: 10m
  retention_enabled: true
  retention_delete_delay: 2h
  retention_delete_worker_count: 150
  delete_request_store: filesystem

query_range:
  results_cache:
    cache:
      embedded_cache:
        enabled: true
        max_size_mb: 100

ruler:
  alertmanager_url: http://localhost:9093

analytics:
  reporting_enabled: false
```

---

## 3. Configuration Promtail

Créer `/home/collectoria/collectoria/monitoring/promtail/promtail-config.yml` :

```yaml
# promtail-config.yml
# Collecte automatique de TOUS les logs des containers Docker

server:
  http_listen_port: 9080
  grpc_listen_port: 0
  log_level: warn

positions:
  # Fichier de position : mémorise où Promtail en est dans chaque fichier de log
  # Persiste entre les redémarrages pour ne pas ré-ingérer les anciens logs
  filename: /tmp/positions.yaml

clients:
  - url: http://collectoria-loki:3100/loki/api/v1/push
    # Tentatives de retry en cas d'erreur réseau
    backoff_config:
      min_period: 500ms
      max_period: 5m
      max_retries: 10

scrape_configs:

  # ─────────────────────────────────────────────
  # Découverte automatique de tous les containers Docker
  # ─────────────────────────────────────────────
  - job_name: docker-containers
    docker_sd_configs:
      - host: unix:///var/run/docker.sock
        refresh_interval: 5s
        filters:
          # Collecter tous les containers en cours d'exécution
          - name: status
            values: ["running"]

    relabel_configs:
      # Label : nom du container (ex: collectoria-backend-collection)
      - source_labels: ['__meta_docker_container_name']
        regex: '/(.*)'
        target_label: 'container_name'

      # Label : nom du service Docker Compose (ex: backend-collection)
      - source_labels: ['__meta_docker_container_label_com_docker_compose_service']
        target_label: 'service'

      # Label : projet Docker Compose (ex: collectoria)
      - source_labels: ['__meta_docker_container_label_com_docker_compose_project']
        target_label: 'compose_project'

      # Label : image utilisée (ex: ghcr.io/owner/collectoria-backend:sha-abc1234)
      - source_labels: ['__meta_docker_container_image_name']
        target_label: 'image'

      # Chemin du fichier de log Docker
      - source_labels: ['__meta_docker_container_id']
        target_label: '__path__'
        replacement: '/var/lib/docker/containers/$1/$1-json.log'

      # Format JSON des logs Docker
      - target_label: '__path__'
        source_labels: ['__meta_docker_container_id']
        regex: '(.*)'
        replacement: '/var/lib/docker/containers/$1/$1-json.log'

    # Analyse du format JSON des logs Docker
    pipeline_stages:
      # Les logs Docker sont en JSON : {"log":"message\n","stream":"stdout","time":"..."}
      - json:
          expressions:
            output: log
            stream: stream
            timestamp: time

      # Extraire le timestamp du log Docker
      - timestamp:
          source: timestamp
          format: RFC3339Nano

      # Utiliser le contenu du champ "log" comme message principal
      - output:
          source: output

      # Ajouter le label stream (stdout/stderr)
      - labels:
          stream:

      # Détecter le niveau de log si le message est en JSON (backend Go)
      - match:
          selector: '{service="backend-collection"}'
          stages:
            - json:
                expressions:
                  level: level
                  msg: msg
            - labels:
                level:

      # Détecter les erreurs dans tous les containers (label "level=error")
      - match:
          selector: '{container_name=~".+"}'
          stages:
            - regex:
                expression: '(?i)(error|fatal|panic|critical)'
                source: output
```

---

## 4. Ajout au docker-compose.monitoring.yml

Ajouter dans `/home/collectoria/collectoria/docker-compose.monitoring.yml`.

**Section `volumes`** — ajouter :

```yaml
  loki_data:
    name: collectoria_loki_data
  promtail_positions:
    name: collectoria_promtail_positions
```

**Section `services`** — ajouter :

```yaml
  # ─────────────────────────────────────────────
  # LOKI — Stockage et indexation des logs
  # ─────────────────────────────────────────────
  loki:
    image: grafana/loki:2.9.7
    container_name: collectoria-loki
    restart: unless-stopped
    security_opt:
      - no-new-privileges:true
    user: "10001:10001"   # UID loki officiel
    command: -config.file=/etc/loki/loki-config.yml
    volumes:
      - ./monitoring/loki/loki-config.yml:/etc/loki/loki-config.yml:ro
      - loki_data:/loki
    networks:
      - monitoring
    # Pas de ports exposés sur l'hôte — accès interne uniquement
    healthcheck:
      test: ["CMD", "wget", "--no-verbose", "--tries=1", "--spider", "http://localhost:3100/ready"]
      interval: 30s
      timeout: 10s
      retries: 3
      start_period: 30s

  # ─────────────────────────────────────────────
  # PROMTAIL — Agent de collecte des logs Docker
  # ─────────────────────────────────────────────
  promtail:
    image: grafana/promtail:2.9.7
    container_name: collectoria-promtail
    restart: unless-stopped
    security_opt:
      - no-new-privileges:true
    command: -config.file=/etc/promtail/promtail-config.yml
    volumes:
      - ./monitoring/promtail/promtail-config.yml:/etc/promtail/promtail-config.yml:ro
      # Accès aux logs Docker
      - /var/lib/docker/containers:/var/lib/docker/containers:ro
      # Socket Docker pour la découverte automatique des containers
      - /var/run/docker.sock:/var/run/docker.sock:ro
      # Persistance de la position de lecture (survit aux redémarrages)
      - promtail_positions:/tmp
    networks:
      - monitoring
    depends_on:
      - loki
    healthcheck:
      test: ["CMD", "wget", "--no-verbose", "--tries=1", "--spider", "http://localhost:9080/ready"]
      interval: 30s
      timeout: 10s
      retries: 3
      start_period: 20s
```

**Note de sécurité** : Promtail a accès au socket Docker (`/var/run/docker.sock`) pour la découverte des containers. Ce socket donne un accès root effectif au système. Surveiller les permissions de ce container et ne jamais l'exposer au réseau public.

---

## 5. Démarrage

```bash
cd /home/collectoria/collectoria

# Démarrer Loki puis Promtail
docker compose -f docker-compose.monitoring.yml \
  --env-file .env.monitoring \
  up -d loki promtail

# Vérifier que Loki est ready
docker exec collectoria-loki \
  wget --no-verbose --tries=1 -O- \
  http://localhost:3100/ready
# Attendu : "ready"

# Vérifier que Promtail collecte des logs
docker logs collectoria-promtail --tail=20
# Attendu : messages de découverte des containers

# Vérifier l'état des deux services
docker compose -f docker-compose.monitoring.yml ps loki promtail
```

---

## 6. Vérification des logs dans Grafana

### 6.1 Vérifier la datasource Loki

1. Accéder à `https://grafana.mondomaine.com`
2. **Connections** → **Data sources** → **Loki**
3. Cliquer **Save & test**
4. Attendu : `"Data source connected and labels found"`

### 6.2 Explorer les logs (Explore)

1. Cliquer sur l'icône **Explore** (boussole dans le menu gauche)
2. Sélectionner la datasource **Loki** en haut
3. Dans le **Label browser**, les labels `container_name`, `service`, `compose_project` doivent apparaître
4. Sélectionner `container_name = collectoria-backend-collection`
5. Cliquer **Run query**
6. Les logs du backend doivent s'afficher en temps réel

### 6.3 Dashboard Logs (optionnel)

Créer un dashboard simple pour les logs :

1. **Dashboards** → **New** → **New dashboard**
2. **Add visualization**
3. Sélectionner datasource **Loki**
4. Dans le champ de requête, saisir :
   ```
   {compose_project="collectoria"}
   ```
5. Choisir le type de visualisation **Logs**
6. Sauvegarder dans le dossier `Collectoria`

---

## 7. Requêtes LogQL utiles

LogQL est le langage de requête de Loki. Voici les requêtes les plus utiles pour Collectoria.

### 7.1 Tous les logs du projet

```logql
{compose_project="collectoria"}
```

### 7.2 Logs du backend uniquement

```logql
{service="backend-collection"}
```

### 7.3 Logs d'erreur — tous containers

```logql
{compose_project="collectoria"} |= "error"
```

Ou en insensible à la casse :

```logql
{compose_project="collectoria"} |~ "(?i)(error|fatal|panic)"
```

### 7.4 Erreurs HTTP 5xx dans les logs Traefik

Traefik émet des logs JSON avec les codes HTTP. Filtrer les 5xx :

```logql
{service="traefik"} | json | status >= 500
```

### 7.5 Requêtes lentes (> 500 ms) dans les logs backend

Si le backend Go loggue la durée des requêtes avec un champ `duration_ms` :

```logql
{service="backend-collection"} | json | duration_ms > 500
```

### 7.6 Logs d'authentification (login)

```logql
{service="backend-collection"} |= "auth" |= "login"
```

### 7.7 Taux d'erreurs sur les 5 dernières minutes

```logql
rate({compose_project="collectoria"} |= "error" [5m])
```

Cette métrique peut être utilisée dans un panel Grafana pour créer une alerte sur un taux d'erreurs anormal.

### 7.8 Logs des erreurs PostgreSQL

```logql
{service="postgres-collection"} |= "ERROR"
```

### 7.9 Filtrer par niveau de log (backend Go avec JSON logs)

Si le backend Go émet des logs JSON avec un champ `level` :

```logql
{service="backend-collection"} | json | level="error"
```

```logql
{service="backend-collection"} | json | level="warn"
```

### 7.10 Compter les requêtes HTTP par endpoint (5 dernières minutes)

```logql
sum by (path) (
  rate({service="backend-collection"} | json | __error__="" [5m])
)
```

---

## 8. Vérification finale

```bash
# 1. Loki est-il opérationnel ?
docker exec collectoria-loki wget --no-verbose -O- http://localhost:3100/ready
# Attendu : "ready"

# 2. Promtail est-il connecté à Loki ?
docker exec collectoria-promtail wget --no-verbose -O- http://localhost:9080/ready
# Attendu : "Ready"

# 3. Voir les labels que Promtail a découverts
docker exec collectoria-promtail wget --no-verbose \
  -O- 'http://localhost:9080/service-discovery'
# Attendu : liste des containers découverts

# 4. Vérifier l'ingestion de logs (via tunnel SSH → http://localhost:3100)
# Dans l'interface Grafana : Explore → Loki → {compose_project="collectoria"}
# Des logs doivent apparaître dans les 30 dernières secondes

# 5. Vérifier les logs de Promtail (pas d'erreur d'ingestion)
docker logs collectoria-promtail --tail=30 | grep -i error
# Attendu : aucune ligne (pas d'erreur)

# 6. Vérifier les logs de Loki
docker logs collectoria-loki --tail=20
# Attendu : messages "ingester flushed X chunks" ou similaire

# 7. Volume de données Loki
docker volume inspect collectoria_loki_data
# Le Mountpoint doit exister et ne pas être vide après quelques minutes
```
