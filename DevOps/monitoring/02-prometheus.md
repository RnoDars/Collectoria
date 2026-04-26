# Prometheus — Collecte des métriques

**Dernière mise à jour** : 2026-04-26  
**Prérequis** :
- VPS provisionné avec Docker — voir [production-setup.md](../production-setup.md)
- Réseau Docker `monitoring` créé — voir [00-overview.md](00-overview.md)
- Stack applicative déployée (backend, frontend, PostgreSQL)
- Backend Go instrumenté avec endpoint `/metrics` — voir [05-backend-instrumentation.md](05-backend-instrumentation.md)

---

## Table des matières

1. [Structure des fichiers](#1-structure-des-fichiers)
2. [Configuration prometheus.yml](#2-configuration-prometheusyml)
3. [Ajout au docker-compose monitoring](#3-ajout-au-docker-compose-monitoring)
4. [node_exporter — métriques système](#4-node_exporter--métriques-système)
5. [postgres_exporter — métriques PostgreSQL](#5-postgres_exporter--métriques-postgresql)
6. [Sécurité — accès interne uniquement](#6-sécurité--accès-interne-uniquement)
7. [Démarrage](#7-démarrage)
8. [Vérification](#8-vérification)

---

## 1. Structure des fichiers

Créer le répertoire de configuration Prometheus sur le VPS :

```bash
mkdir -p /home/collectoria/collectoria/monitoring/prometheus
mkdir -p /home/collectoria/collectoria/monitoring/grafana/provisioning
```

Arborescence finale :

```
/home/collectoria/collectoria/
├── docker-compose.prod.yml          (existant — modifié à l'étape 3)
├── docker-compose.monitoring.yml    (nouveau — créé à l'étape 3)
├── .env.production                  (existant)
├── .env.monitoring                  (nouveau — créé à l'étape 3)
└── monitoring/
    └── prometheus/
        └── prometheus.yml           (créé à l'étape 2)
```

---

## 2. Configuration prometheus.yml

Créer le fichier `/home/collectoria/collectoria/monitoring/prometheus/prometheus.yml` :

```yaml
# prometheus.yml
# Configuration Prometheus pour Collectoria
# Intervalle de scrape global : 15 secondes

global:
  scrape_interval: 15s
  evaluation_interval: 15s
  external_labels:
    project: 'collectoria'
    environment: 'production'

# Règles d'alertes (optionnel — à ajouter ultérieurement)
# rule_files:
#   - /etc/prometheus/rules/*.yml

scrape_configs:

  # ─────────────────────────────────────────────
  # Prometheus lui-même
  # ─────────────────────────────────────────────
  - job_name: 'prometheus'
    static_configs:
      - targets: ['localhost:9090']

  # ─────────────────────────────────────────────
  # Métriques système du VPS — node_exporter
  # ─────────────────────────────────────────────
  - job_name: 'node'
    static_configs:
      - targets: ['node-exporter:9100']
        labels:
          instance: 'vps-collectoria'

  # ─────────────────────────────────────────────
  # Métriques PostgreSQL — postgres_exporter
  # ─────────────────────────────────────────────
  - job_name: 'postgresql'
    static_configs:
      - targets: ['postgres-exporter:9187']
        labels:
          instance: 'collectoria-postgres'

  # ─────────────────────────────────────────────
  # Métriques backend Go — endpoint /metrics
  # Le backend est sur le réseau backend_internal
  # mais aussi sur collectoria_proxy
  # ─────────────────────────────────────────────
  - job_name: 'backend-collection'
    static_configs:
      - targets: ['collectoria-backend-collection:8080']
        labels:
          service: 'collection-management'
    metrics_path: '/metrics'
    # Scrape uniquement depuis le réseau interne, pas via Traefik
    scheme: 'http'
```

**Note sur le scrape du backend** : Prometheus accède directement au container backend via son nom DNS Docker (`collectoria-backend-collection`), sans passer par Traefik. Pour cela, Prometheus doit être sur un réseau commun avec le backend. Ceci est géré à l'étape 3 en ajoutant Prometheus au réseau `collectoria_proxy`.

---

## 3. Ajout au docker-compose monitoring

La stack monitoring est déployée dans un fichier Compose séparé pour ne pas alourdir `docker-compose.prod.yml`.

Créer `/home/collectoria/collectoria/docker-compose.monitoring.yml` :

```yaml
# docker-compose.monitoring.yml
# Stack monitoring Collectoria : Prometheus + node_exporter + postgres_exporter
# Lancer avec : docker compose -f docker-compose.monitoring.yml --env-file .env.monitoring up -d

networks:
  # Réseau dédié monitoring (isolé du réseau applicatif)
  monitoring:
    name: monitoring
    external: true
  # Accès au réseau proxy pour scraper le backend Go directement
  proxy:
    name: collectoria_proxy
    external: true
  # Accès au réseau interne pour postgres_exporter → PostgreSQL
  backend_internal:
    name: collectoria_backend_internal
    external: true

volumes:
  prometheus_data:
    name: collectoria_prometheus_data

services:

  # ─────────────────────────────────────────────
  # PROMETHEUS — Collecte des métriques
  # ─────────────────────────────────────────────
  prometheus:
    image: prom/prometheus:v2.51.2
    container_name: collectoria-prometheus
    restart: unless-stopped
    security_opt:
      - no-new-privileges:true
    user: "65534:65534"   # nobody:nobody — ne pas tourner en root
    command:
      - '--config.file=/etc/prometheus/prometheus.yml'
      - '--storage.tsdb.path=/prometheus'
      - '--storage.tsdb.retention.time=30d'
      - '--storage.tsdb.retention.size=5GB'
      - '--web.console.libraries=/usr/share/prometheus/console_libraries'
      - '--web.console.templates=/usr/share/prometheus/consoles'
      - '--web.enable-lifecycle'
      # Pas de --web.external-url ni d'exposition via Traefik
      # Prometheus n'est accessible que depuis le réseau monitoring
    volumes:
      - ./monitoring/prometheus/prometheus.yml:/etc/prometheus/prometheus.yml:ro
      - prometheus_data:/prometheus
    networks:
      - monitoring
      - proxy          # pour scraper le backend Go
      - backend_internal  # pour que postgres_exporter puisse atteindre PostgreSQL
    # Pas de ports exposés sur l'hôte — accès interne uniquement
    healthcheck:
      test: ["CMD", "wget", "--no-verbose", "--tries=1", "--spider", "http://localhost:9090/-/healthy"]
      interval: 30s
      timeout: 10s
      retries: 3
      start_period: 30s

  # ─────────────────────────────────────────────
  # NODE EXPORTER — Métriques système VPS
  # ─────────────────────────────────────────────
  node-exporter:
    image: prom/node-exporter:v1.7.0
    container_name: collectoria-node-exporter
    restart: unless-stopped
    security_opt:
      - no-new-privileges:true
    command:
      - '--path.procfs=/host/proc'
      - '--path.rootfs=/rootfs'
      - '--path.sysfs=/host/sys'
      - '--collector.filesystem.mount-points-exclude=^/(sys|proc|dev|host|etc)($$|/)'
    volumes:
      - /proc:/host/proc:ro
      - /sys:/host/sys:ro
      - /:/rootfs:ro
    networks:
      - monitoring
    # Pas de ports exposés sur l'hôte
    healthcheck:
      test: ["CMD", "wget", "--no-verbose", "--tries=1", "--spider", "http://localhost:9100/metrics"]
      interval: 30s
      timeout: 10s
      retries: 3

  # ─────────────────────────────────────────────
  # POSTGRES EXPORTER — Métriques PostgreSQL
  # ─────────────────────────────────────────────
  postgres-exporter:
    image: prometheuscommunity/postgres-exporter:v0.15.0
    container_name: collectoria-postgres-exporter
    restart: unless-stopped
    security_opt:
      - no-new-privileges:true
    environment:
      DATA_SOURCE_NAME: "postgresql://${POSTGRES_COLLECTION_USER}:${POSTGRES_COLLECTION_PASSWORD}@collectoria-postgres-collection:5432/${POSTGRES_COLLECTION_DB}?sslmode=disable"
    networks:
      - monitoring
      - backend_internal   # pour atteindre postgres-collection
    # Pas de ports exposés sur l'hôte
    healthcheck:
      test: ["CMD", "wget", "--no-verbose", "--tries=1", "--spider", "http://localhost:9187/metrics"]
      interval: 30s
      timeout: 10s
      retries: 3
```

Créer le fichier `.env.monitoring` sur le VPS (ne jamais commiter dans git) :

```bash
cat > /home/collectoria/collectoria/.env.monitoring << 'EOF'
# Variables pour la stack monitoring
# Ce fichier référence les mêmes credentials PostgreSQL que .env.production
# Copier les valeurs depuis .env.production

POSTGRES_COLLECTION_USER=collectoria_prod
POSTGRES_COLLECTION_PASSWORD=COPIER_DEPUIS_ENV_PRODUCTION
POSTGRES_COLLECTION_DB=collection_management
EOF

chmod 600 /home/collectoria/collectoria/.env.monitoring
```

---

## 4. node_exporter — métriques système

node_exporter collecte automatiquement les métriques suivantes du VPS :

| Métrique | Description |
|---|---|
| `node_cpu_seconds_total` | Temps CPU par mode (user, system, idle, iowait) |
| `node_memory_MemAvailable_bytes` | RAM disponible |
| `node_filesystem_avail_bytes` | Espace disque disponible par partition |
| `node_network_receive_bytes_total` | Bytes reçus par interface réseau |
| `node_network_transmit_bytes_total` | Bytes émis par interface réseau |
| `node_load1` / `node_load5` / `node_load15` | Charge système (1, 5, 15 minutes) |
| `node_disk_read_bytes_total` | Bytes lus depuis le disque |
| `node_disk_written_bytes_total` | Bytes écrits sur le disque |

Ces métriques alimentent le dashboard **Node Exporter Full** (ID Grafana : 1860).

---

## 5. postgres_exporter — métriques PostgreSQL

postgres_exporter collecte les métriques PostgreSQL via la connexion définie dans `DATA_SOURCE_NAME` :

| Métrique | Description |
|---|---|
| `pg_up` | PostgreSQL est-il accessible (1/0) |
| `pg_stat_database_tup_fetched` | Tuples lus par base |
| `pg_stat_database_tup_inserted` | Insertions par base |
| `pg_stat_database_xact_commit` | Transactions validées |
| `pg_stat_database_xact_rollback` | Transactions annulées |
| `pg_stat_activity_count` | Connexions actives |
| `pg_database_size_bytes` | Taille de la base en octets |
| `pg_locks_count` | Verrous par type |

Ces métriques alimentent le dashboard **PostgreSQL Database** (ID Grafana : 9628).

**Permissions PostgreSQL requises** : l'utilisateur utilisé par postgres_exporter doit avoir les droits de lecture sur `pg_stat_database` et `pg_stat_activity`. L'utilisateur `collectoria_prod` possède ces droits en tant que propriétaire de la base.

---

## 6. Sécurité — accès interne uniquement

Prometheus ne doit **jamais** être exposé publiquement. Points de contrôle :

- Aucun `ports:` n'est défini pour Prometheus dans le Compose — le port 9090 n'est pas publié sur l'hôte.
- Prometheus n'a aucun label Traefik — il n'est pas accessible via le reverse proxy.
- Le réseau `monitoring` est un réseau Docker interne non routé vers Internet.

Pour accéder à l'interface Prometheus à des fins de debug, utiliser un tunnel SSH :

```bash
# Depuis votre machine locale
ssh -L 9090:localhost:9090 collectoria@<IP_DU_VPS>

# Puis ouvrir dans le navigateur
http://localhost:9090
```

---

## 7. Démarrage

```bash
cd /home/collectoria/collectoria

# Vérifier que le réseau monitoring existe
docker network ls | grep monitoring
# Si absent : docker network create monitoring

# Démarrer la stack monitoring
docker compose -f docker-compose.monitoring.yml \
  --env-file .env.monitoring \
  up -d

# Vérifier l'état des containers
docker compose -f docker-compose.monitoring.yml ps
# Les 3 services doivent être "Up"
```

---

## 8. Vérification

```bash
# 1. Vérifier que Prometheus est healthy
docker exec collectoria-prometheus \
  wget --no-verbose --tries=1 -O- \
  http://localhost:9090/-/healthy
# Attendu : "Prometheus Server is Healthy."

# 2. Vérifier que node_exporter expose des métriques
docker exec collectoria-node-exporter \
  wget --no-verbose --tries=1 -O- \
  http://localhost:9100/metrics | head -20
# Attendu : lignes commençant par "# HELP node_..." et "node_cpu_seconds_total ..."

# 3. Vérifier que postgres_exporter est connecté
docker exec collectoria-postgres-exporter \
  wget --no-verbose --tries=1 -O- \
  http://localhost:9187/metrics | grep "pg_up"
# Attendu : "pg_up 1"

# 4. Vérifier que Prometheus scrape bien les targets (via tunnel SSH si nécessaire)
# Ouvrir http://localhost:9090/targets dans le navigateur
# Tous les targets doivent être "UP"

# 5. Vérifier les logs Prometheus (pas d'erreur de scrape)
docker logs collectoria-prometheus --tail=30

# 6. Requête PromQL de test (via tunnel SSH)
# Ouvrir http://localhost:9090/graph
# Saisir : up
# Attendu : valeur 1 pour tous les targets
```

**Test du scrape backend** : une fois le backend instrumenté (voir [05-backend-instrumentation.md](05-backend-instrumentation.md)) :

```bash
# Via tunnel SSH
# Dans le navigateur http://localhost:9090/graph
# Saisir : http_requests_total
# Des métriques doivent apparaître
```
