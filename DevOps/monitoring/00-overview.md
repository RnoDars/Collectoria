# Monitoring Collectoria — Vue d'ensemble

**Dernière mise à jour** : 2026-04-26  
**Prérequis** : VPS provisionné, Docker installé, domaine configuré — voir [production-setup.md](../production-setup.md)

---

## Table des matières

1. [Objectif de la stack monitoring](#1-objectif-de-la-stack-monitoring)
2. [Architecture générale](#2-architecture-générale)
3. [Outils retenus et leur rôle](#3-outils-retenus-et-leur-rôle)
4. [Ports et accès](#4-ports-et-accès)
5. [Estimation mémoire](#5-estimation-mémoire)
6. [Ordre d'installation recommandé](#6-ordre-dinstallation-recommandé)
7. [Réseau Docker dédié](#7-réseau-docker-dédié)
8. [Sous-domaines DNS à créer](#8-sous-domaines-dns-à-créer)

---

## 1. Objectif de la stack monitoring

La stack monitoring apporte trois capacités distinctes :

- **Disponibilité** : savoir immédiatement si un service est hors ligne, avant les utilisateurs.
- **Performance** : mesurer l'utilisation CPU, RAM, disque, latence des API, charge PostgreSQL.
- **Logs centralisés** : consulter et corréler les logs de tous les containers Docker depuis une interface unique.

---

## 2. Architecture générale

```
                          Internet
                              │
                    ┌─────────┴─────────┐
                    │   Traefik v3      │  (reverse proxy TLS)
                    └─────────┬─────────┘
                              │
          ┌───────────────────┼──────────────────────┐
          │                   │                      │
          ▼                   ▼                      ▼
  status.mondomaine.com  grafana.mondomaine.com  mondomaine.com
  [Uptime Kuma :3001]    [Grafana :3000]         [App Collectoria]
          │                   │
          │            ┌──────┴──────┐
          │            │             │
          │     [Prometheus :9090]  [Loki :3100]
          │            │             │
          │     ┌──────┴───────┐    [Promtail]
          │     │              │         │
          │  [node_exporter] [postgres_  │
          │  [:9100]          exporter]  │
          │                  [:9187]     │
          │                             │
          │    scrape toutes les 15s    │ collecte tous les logs Docker
          │                             ▼
          │                    /var/lib/docker/containers/
          │
          ▼
  surveille HTTP/TCP endpoints
  (backend :8080, frontend :3000, postgres :5432)
  → alerte Telegram si KO
```

**Légende des flux :**

| Flux | Direction | Protocole |
|---|---|---|
| Promtail → Loki | push logs | HTTP |
| Prometheus → node_exporter | scrape métriques | HTTP |
| Prometheus → postgres_exporter | scrape métriques | HTTP |
| Prometheus → backend `/metrics` | scrape métriques | HTTP |
| Grafana → Prometheus | requêtes PromQL | HTTP |
| Grafana → Loki | requêtes LogQL | HTTP |
| Uptime Kuma → endpoints app | sonde HTTP/TCP | HTTP/TCP |

---

## 3. Outils retenus et leur rôle

### Uptime Kuma
- **Rôle** : surveillance de disponibilité (« est-ce que le service répond ? »)
- **Ce qu'il surveille** : endpoint HTTP `/api/v1/health` (backend), `/` (frontend), port TCP 5432 (PostgreSQL)
- **Ce qu'il fait** : alerte Telegram/email dès qu'un service ne répond plus
- **Accès** : `https://status.mondomaine.com` (derrière Traefik)
- **Document** : [01-uptime-kuma.md](01-uptime-kuma.md)

### Prometheus
- **Rôle** : collecte et stockage de métriques numériques (time series)
- **Ce qu'il collecte** : métriques système (node_exporter), métriques PostgreSQL (postgres_exporter), métriques applicatives Go (endpoint `/metrics` du backend)
- **Accès** : réseau Docker interne uniquement — pas d'exposition publique
- **Document** : [02-prometheus.md](02-prometheus.md)

### Grafana
- **Rôle** : dashboards de visualisation (métriques + logs)
- **Sources de données** : Prometheus (métriques) + Loki (logs)
- **Accès** : `https://grafana.mondomaine.com` (derrière Traefik)
- **Document** : [03-grafana.md](03-grafana.md)

### Loki + Promtail
- **Rôle** : agrégation et indexation des logs de tous les containers Docker
- **Promtail** : agent de collecte qui lit les logs Docker et les pousse vers Loki
- **Loki** : stockage et indexation des logs (requêtes via LogQL)
- **Accès** : réseau Docker interne uniquement
- **Document** : [04-loki-promtail.md](04-loki-promtail.md)

### Instrumentation backend Go
- **Rôle** : exposer les métriques applicatives au format Prometheus
- **Ce que le backend doit implémenter** : endpoint `/metrics`, middleware de comptage des requêtes, histogramme de latence
- **Document** : [05-backend-instrumentation.md](05-backend-instrumentation.md) — destiné à l'Agent Backend

---

## 4. Ports et accès

| Service | Port interne | Accès externe | URL publique |
|---|---|---|---|
| Uptime Kuma | 3001 | via Traefik HTTPS | `https://status.mondomaine.com` |
| Grafana | 3000 | via Traefik HTTPS | `https://grafana.mondomaine.com` |
| Prometheus | 9090 | aucun (interne uniquement) | — |
| Loki | 3100 | aucun (interne uniquement) | — |
| Promtail | — | aucun (push vers Loki) | — |
| node_exporter | 9100 | aucun (interne uniquement) | — |
| postgres_exporter | 9187 | aucun (interne uniquement) | — |

**Règle de sécurité** : seuls Uptime Kuma et Grafana sont accessibles depuis Internet, via Traefik avec TLS. Prometheus, Loki et les exporters ne sont accessibles que depuis le réseau Docker `monitoring`.

---

## 5. Estimation mémoire

| Service | RAM estimée |
|---|---|
| Uptime Kuma | ~80 Mo |
| Prometheus | ~150 Mo |
| Grafana | ~120 Mo |
| Loki | ~150 Mo |
| Promtail | ~30 Mo |
| node_exporter | ~10 Mo |
| postgres_exporter | ~15 Mo |
| **Total stack monitoring** | **~555 Mo** |

Le VPS dispose de 8 Go de RAM. La stack applicative (Traefik + backend Go + frontend Next.js + PostgreSQL) consomme environ 600–800 Mo. La stack monitoring ajoute ~555 Mo, ce qui reste dans les marges confortables du serveur.

---

## 6. Ordre d'installation recommandé

L'ordre suivant respecte les dépendances entre outils :

```
Étape 1 — Uptime Kuma          (indépendant, alertes immédiates)
Étape 2 — Prometheus           (base de collecte des métriques)
Étape 3 — Grafana              (dépend de Prometheus)
Étape 4 — Loki + Promtail      (dépend de Grafana pour la datasource)
Étape 5 — Instrumentation Go   (dépend de Prometheus pour le scrape)
Étape 6 — Monitoring fail2ban  (surveillance attaques SSH)
```

**Pourquoi cet ordre** :
- Uptime Kuma en premier : surveillance opérationnelle disponible dès le début, même si les métriques ne sont pas encore collectées.
- Prometheus avant Grafana : Grafana ne peut pas être configuré sans source de données.
- Loki après Grafana : la datasource Loki est ajoutée dans Grafana à la fin.
- L'instrumentation Go peut être faite à tout moment, mais les métriques n'apparaîtront dans Grafana qu'une fois Prometheus configuré.
- Monitoring fail2ban en dernier : nécessite Prometheus + Grafana pour visualiser les attaques SSH et bannissements.

---

## 7. Réseau Docker dédié

Tous les services monitoring partagent un réseau Docker dédié `monitoring`, isolé du réseau applicatif `collectoria_proxy`.

```bash
# Créer le réseau (une seule fois, avant toute installation)
docker network create monitoring
```

Seuls Uptime Kuma et Grafana sont également connectés au réseau `collectoria_proxy` pour être accessibles via Traefik.

---

## 8. Sous-domaines DNS à créer

Avant de démarrer les services, ajouter ces deux enregistrements DNS dans l'espace client OVH (Zone DNS) :

| Type | Sous-domaine | TTL | Cible |
|---|---|---|---|
| A | `status` | 300 | `<IP_DU_VPS>` |
| A | `grafana` | 300 | `<IP_DU_VPS>` |

Ces entrées permettent à Traefik d'obtenir automatiquement des certificats Let's Encrypt pour `status.mondomaine.com` et `grafana.mondomaine.com`.

Vérifier la propagation DNS avant de démarrer les services :

```bash
dig +short status.mondomaine.com A
dig +short grafana.mondomaine.com A
# Les deux doivent retourner l'IP du VPS
```
