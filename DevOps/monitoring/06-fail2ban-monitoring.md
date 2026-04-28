# Monitoring fail2ban - Surveillance des Attaques SSH

**Dernière mise à jour** : 2026-04-28  
**Prérequis** : fail2ban installé, Prometheus + Grafana configurés

---

## 1. Objectif

Surveiller les attaques SSH détectées par fail2ban et visualiser :
- Nombre de tentatives SSH échouées en temps réel
- Nombre d'IPs bannies (actuel et historique)
- Tendances des attaques (heures, jours, géolocalisation)
- Alertes sur pics d'attaques inhabituels

**Pourquoi** : Le serveur est exposé sur Internet et subit des attaques par force brute constantes. fail2ban protège le serveur, mais sans monitoring on ne sait pas :
- Si les attaques augmentent (besoin de renforcer la sécurité)
- Quels pays/IPs attaquent le plus
- Si fail2ban fonctionne correctement

---

## 2. Métriques à Collecter

### Métriques fail2ban disponibles

fail2ban ne fournit pas d'exporter Prometheus natif, mais on peut :

**Option 1 : Scraper les logs fail2ban via Promtail + Loki**
- Promtail collecte `/var/log/fail2ban.log`
- Loki indexe les logs
- Grafana affiche les dashboards avec LogQL

**Option 2 : fail2ban-exporter (Prometheus exporter)**
- Exporter tiers : https://github.com/jangrewe/prometheus-fail2ban-exporter
- Expose métriques Prometheus sur port 9191
- Prometheus scrape l'exporter

**Métriques exposées** :
- `fail2ban_up` : fail2ban est actif (1) ou non (0)
- `fail2ban_jail_banned_current` : Nombre d'IPs bannies actuellement (par jail)
- `fail2ban_jail_banned_total` : Total d'IPs bannies depuis le démarrage (par jail)
- `fail2ban_jail_failed_current` : Tentatives échouées actuelles (par jail)
- `fail2ban_jail_failed_total` : Total de tentatives échouées (par jail)

---

## 3. Architecture Recommandée

```
fail2ban (port 22 protégé)
    │
    ├─> Logs → /var/log/fail2ban.log
    │           │
    │           └─> Promtail collecte
    │                   │
    │                   └─> Loki stocke
    │                           │
    │                           └─> Grafana affiche (LogQL)
    │
    └─> fail2ban-exporter (port 9191)
            │
            └─> Prometheus scrape
                    │
                    └─> Grafana affiche (PromQL)
```

**Recommandation** : Utiliser les deux approches :
- **Logs Promtail/Loki** : Pour détails textuels des bannissements (IPs, raisons, timestamps)
- **fail2ban-exporter** : Pour métriques numériques et graphiques de tendances

---

## 4. Installation fail2ban-exporter

### Méthode 1 : Docker (recommandé)

Ajouter ce service au `docker-compose.monitoring.yml` :

```yaml
fail2ban-exporter:
  image: jangrewe/prometheus-fail2ban-exporter:latest
  container_name: fail2ban-exporter
  restart: unless-stopped
  networks:
    - monitoring
  ports:
    - "9191:9191"  # Exporter interne uniquement
  volumes:
    - /var/log/fail2ban.log:/var/log/fail2ban.log:ro
    - /var/lib/fail2ban:/var/lib/fail2ban:ro
  environment:
    - FAIL2BAN_LOG_PATH=/var/log/fail2ban.log
```

### Méthode 2 : Installation manuelle (Python)

```bash
sudo apt install python3-pip -y
sudo pip3 install prometheus-fail2ban-exporter

# Lancer l'exporter
sudo prometheus-fail2ban-exporter --port 9191 &
```

---

## 5. Configuration Prometheus

Ajouter ce job de scrape dans `prometheus.yml` :

```yaml
scrape_configs:
  - job_name: 'fail2ban'
    static_configs:
      - targets: ['fail2ban-exporter:9191']
    scrape_interval: 30s
```

Redémarrer Prometheus après modification.

---

## 6. Dashboard Grafana

### Requêtes PromQL utiles

**1. Nombre d'IPs bannies actuellement (jail sshd)**
```promql
fail2ban_jail_banned_current{jail="sshd"}
```

**2. Total de tentatives SSH échouées depuis démarrage**
```promql
fail2ban_jail_failed_total{jail="sshd"}
```

**3. Taux d'échecs SSH par minute**
```promql
rate(fail2ban_jail_failed_total{jail="sshd"}[5m])
```

**4. Nombre de bannissements par heure**
```promql
increase(fail2ban_jail_banned_total{jail="sshd"}[1h])
```

### Panels recommandés

| Panel | Type | Requête | Description |
|-------|------|---------|-------------|
| Statut fail2ban | Stat | `fail2ban_up` | Affiche 1 si actif, 0 sinon |
| IPs bannies actuelles | Gauge | `fail2ban_jail_banned_current{jail="sshd"}` | Nombre d'IPs bloquées maintenant |
| Total tentatives échouées | Stat | `fail2ban_jail_failed_total{jail="sshd"}` | Compteur depuis démarrage |
| Taux d'attaques SSH | Graph (Time series) | `rate(fail2ban_jail_failed_total[5m])` | Évolution des attaques par minute |
| Bannissements dernière heure | Stat | `increase(fail2ban_jail_banned_total[1h])` | Nombre d'IPs bannies cette heure |

---

## 7. Alertes Recommandées

### Alerte 1 : fail2ban inactif

```yaml
groups:
  - name: fail2ban
    rules:
      - alert: Fail2banDown
        expr: fail2ban_up == 0
        for: 5m
        labels:
          severity: critical
        annotations:
          summary: "fail2ban est inactif"
          description: "fail2ban ne répond plus, le serveur SSH n'est plus protégé contre les attaques par force brute."
```

### Alerte 2 : Pic d'attaques SSH inhabituel

```yaml
- alert: HighSSHAttackRate
  expr: rate(fail2ban_jail_failed_total{jail="sshd"}[5m]) > 10
  for: 10m
  labels:
    severity: warning
  annotations:
    summary: "Pic d'attaques SSH détecté"
    description: "Plus de 10 tentatives SSH échouées par minute depuis 10 minutes. Attaque en cours possible."
```

---

## 8. Configuration Promtail pour Logs fail2ban

Ajouter ce scrape config dans `promtail-config.yaml` :

```yaml
scrape_configs:
  - job_name: fail2ban
    static_configs:
      - targets:
          - localhost
        labels:
          job: fail2ban
          __path__: /var/log/fail2ban.log
```

Monter le volume dans le container Promtail :

```yaml
volumes:
  - /var/log/fail2ban.log:/var/log/fail2ban.log:ro
```

---

## 9. Requêtes LogQL (Grafana Loki)

**1. Toutes les IPs bannies aujourd'hui**
```logql
{job="fail2ban"} |~ "Ban"
```

**2. Nombre de bannissements par heure**
```logql
count_over_time({job="fail2ban"} |~ "Ban" [1h])
```

**3. Top 10 des IPs les plus bannies**
```logql
{job="fail2ban"} |~ "Ban" | regexp "Ban (?P<ip>\\d+\\.\\d+\\.\\d+\\.\\d+)" | unwrap ip | topk(10)
```

---

## 10. Checklist d'Installation

- [ ] fail2ban installé et actif sur le serveur (Phase 1 provisioning)
- [ ] Prometheus + Grafana configurés (Phases monitoring précédentes)
- [ ] fail2ban-exporter déployé (Docker ou Python)
- [ ] Prometheus scrape job ajouté pour fail2ban-exporter
- [ ] Promtail configuré pour collecter `/var/log/fail2ban.log`
- [ ] Dashboard Grafana créé avec panels fail2ban
- [ ] Alertes configurées (fail2ban down, pic d'attaques)
- [ ] Tests : déclencher un bannissement manuel et vérifier métriques

---

## 11. Tests de Validation

### Déclencher un bannissement manuel

Sur une machine distante (PAS le serveur), tenter plusieurs connexions SSH échouées :

```bash
for i in {1..6}; do
  ssh fake-user@51.159.161.31
done
```

Après 5 tentatives échouées, fail2ban devrait bannir l'IP.

### Vérifier le bannissement

Sur le serveur :
```bash
sudo fail2ban-client status sshd
```

### Vérifier les métriques Prometheus

```bash
curl http://localhost:9191/metrics | grep fail2ban_jail_banned_current
# Devrait afficher 1 (une IP bannie)
```

### Vérifier le dashboard Grafana

Ouvrir le dashboard fail2ban → le panel "IPs bannies actuelles" doit afficher 1.

---

## 12. Maintenance

### Débannir une IP manuellement

```bash
sudo fail2ban-client set sshd unbanip <IP>
```

### Consulter les logs fail2ban

```bash
sudo tail -f /var/log/fail2ban.log
```

### Redémarrer fail2ban

```bash
sudo systemctl restart fail2ban
```

---

## 13. Ressources

- **fail2ban documentation** : https://www.fail2ban.org/
- **fail2ban-exporter GitHub** : https://github.com/jangrewe/prometheus-fail2ban-exporter
- **Grafana dashboard fail2ban** : https://grafana.com/grafana/dashboards/11705 (exemple communautaire)

---

**Note** : Cette configuration a été ajoutée suite à la session de provisioning du 2026-04-28, où il a été constaté que le serveur subissait déjà 46 tentatives SSH échouées avec 1 IP bannie dès la première heure de mise en ligne.
