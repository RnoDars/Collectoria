# Audit de Sécurité Production

**Date de création** : 2026-05-04
**Priorité** : MEDIUM
**Effort estimé** : 3-4h
**Agent(s) responsable(s)** : Agent Security + Agent DevOps
**Status** : 📋 TODO

---

## Contexte

Le projet Collectoria a obtenu un score de sécurité de **9.0/10** en environnement de développement lors du dernier audit (Agent Security). Cependant, la configuration de production n'a pas encore été auditée de manière exhaustive.

**Différences Dev vs Prod** :
- **Dev** : Environnement local, pas d'exposition Internet, secrets en clair
- **Prod** : Serveur exposé Internet, Traefik reverse proxy, Docker, potentiellement SSH accessible

**Objectif** : Vérifier que la configuration production respecte les standards de sécurité et n'introduit pas de vulnérabilités.

---

## Objectif

Auditer la sécurité de l'environnement de production Collectoria :
1. **Infrastructure** : Docker, réseau, ports exposés, Traefik
2. **Application** : Headers HTTP, CORS, authentification, secrets
3. **Base de données** : Permissions, accès réseau, backup
4. **Serveur** : SSH, firewall, permissions, mises à jour
5. **Monitoring** : Logs, alerting, détection intrusion

**Livrable** :
- Rapport d'audit complet avec score /10
- Liste des vulnérabilités identifiées (CRITICAL, HIGH, MEDIUM, LOW)
- Recommandations priorisées
- Plan de remediation

---

## Checklist d'Audit

### 1. Infrastructure Docker & Réseau (Agent DevOps)

#### Docker Configuration
- [ ] **Images** : Utilisation d'images officielles ou auditées
- [ ] **Images** : Scan CVE avec `docker scan` ou Trivy
- [ ] **Versions** : Images à jour (pas de versions obsolètes)
- [ ] **Secrets** : Pas de secrets dans les Dockerfiles ou images
- [ ] **User** : Conteneurs ne tournent PAS en root (USER non-root)
- [ ] **Capabilities** : Capabilities Linux minimales (drop ALL, add nécessaires uniquement)
- [ ] **Read-only** : Filesystem read-only si possible
- [ ] **Volumes** : Montages sécurisés (pas de `/` ou `/etc`)

#### Réseau Docker
- [ ] **Isolation** : Services sur réseau Docker isolé (pas de `host` mode)
- [ ] **Ports** : Uniquement Traefik exposé sur 80/443, pas de ports backend/DB publics
- [ ] **Firewall** : iptables/ufw bloque tout sauf 80/443/22
- [ ] **Communication** : Services communiquent via réseau interne Docker uniquement

#### Docker Compose Production
- [ ] **Secrets** : Variables sensibles via secrets Docker ou `.env.production` (pas de hardcode)
- [ ] **Restart policy** : `restart: unless-stopped` pour haute disponibilité
- [ ] **Health checks** : Health checks définis pour tous les services
- [ ] **Resources** : Limites CPU/RAM définies (prévenir DoS)

**Commandes d'audit** :
```bash
# Scan CVE des images
docker images | tail -n +2 | awk '{print $1":"$2}' | xargs -I {} docker scan {}

# Vérifier les ports exposés
docker ps --format "table {{.Names}}\t{{.Ports}}"

# Vérifier les processus root dans conteneurs
docker ps -q | xargs docker inspect --format '{{.Config.User}} {{.Name}}'

# Vérifier les capabilities
docker inspect <container> | jq '.[0].HostConfig.CapDrop'
```

---

### 2. Traefik Reverse Proxy (Agent DevOps)

#### Configuration HTTPS
- [ ] **HTTPS obligatoire** : Redirection HTTP → HTTPS automatique
- [ ] **Certificats TLS** : Let's Encrypt configuré et auto-renouvellement
- [ ] **TLS version** : TLS 1.2+ uniquement (pas de TLS 1.0/1.1)
- [ ] **Ciphers** : Ciphers forts uniquement (ECDHE, AES-GCM)
- [ ] **HSTS** : Header `Strict-Transport-Security` activé

#### Headers de Sécurité HTTP
- [ ] `X-Frame-Options: DENY` ou `SAMEORIGIN`
- [ ] `X-Content-Type-Options: nosniff`
- [ ] `X-XSS-Protection: 1; mode=block`
- [ ] `Referrer-Policy: strict-origin-when-cross-origin`
- [ ] `Content-Security-Policy` (CSP) configuré
- [ ] `Permissions-Policy` (anciennement Feature-Policy)

#### Rate Limiting
- [ ] **Rate limiting** : Limite de requêtes par IP (prévenir bruteforce)
- [ ] **Endpoints sensibles** : Rate limit strict sur `/api/v1/auth/login`

#### CORS
- [ ] **CORS** : `Access-Control-Allow-Origin` restreint (pas de `*`)
- [ ] **CORS** : Méthodes HTTP autorisées limitées (GET, POST, PUT, DELETE uniquement)
- [ ] **CORS** : Headers autorisés explicites

**Commandes d'audit** :
```bash
# Tester les headers de sécurité
curl -I https://collectoria.example.com | grep -E "(X-Frame|X-Content|X-XSS|Strict-Transport)"

# Tester TLS configuration
nmap --script ssl-enum-ciphers -p 443 collectoria.example.com

# Tester redirection HTTPS
curl -I http://collectoria.example.com
# Attendu : 301/302 redirect vers https://
```

**Outils** :
- [Mozilla Observatory](https://observatory.mozilla.org/) (scan automatique)
- [SSL Labs](https://www.ssllabs.com/ssltest/) (test TLS)
- [Security Headers](https://securityheaders.com/) (test headers HTTP)

---

### 3. Application Backend (Agent Security)

#### Authentication & Authorization
- [ ] **JWT Secret** : Fort (64+ chars), unique pour prod, pas committé dans git
- [ ] **JWT Expiration** : Tokens courts (≤24h) avec refresh token
- [ ] **Password hashing** : bcrypt avec salt (coût ≥12)
- [ ] **Endpoints protégés** : Middleware auth sur TOUS les endpoints sensibles
- [ ] **RBAC** : Vérification des permissions utilisateur (admin vs user)

#### Injection SQL
- [ ] **Parameterized queries** : Utilisation de `$1, $2` dans toutes les requêtes SQL
- [ ] **ORM/Query builder** : Utilisation de GORM ou sqlx (pas de string concat)
- [ ] **Input validation** : Validation stricte des inputs utilisateur

#### Secrets Management
- [ ] **Variables d'environnement** : Secrets via env vars (pas hardcodés)
- [ ] **Fichiers .env** : `.env.production` dans `.gitignore`
- [ ] **Logs** : Secrets JAMAIS loggés (passwords, tokens, API keys)

#### Error Handling
- [ ] **Messages d'erreur** : Pas de stack traces en production
- [ ] **Logs d'erreur** : Logs détaillés côté serveur uniquement (pas exposés API)

**Commandes d'audit** :
```bash
# Vérifier que JWT_SECRET n'est pas committé
git log --all -S "JWT_SECRET" --oneline

# Vérifier les endpoints sans auth
curl -X GET https://api.collectoria.example.com/api/v1/cards
# Attendu : 401 Unauthorized si auth requise

# Tester injection SQL (safe test)
curl -X GET "https://api.collectoria.example.com/api/v1/cards?name=test' OR '1'='1"
# Attendu : Erreur de validation ou 0 résultats (pas d'erreur SQL)
```

**Outils** :
- OWASP ZAP (scan automatique)
- SQLMap (test injection SQL)
- Burp Suite (test manuel)

---

### 4. Base de Données PostgreSQL (Agent DevOps)

#### Accès Réseau
- [ ] **Exposition** : PostgreSQL NON exposé sur Internet (port 5432 interne uniquement)
- [ ] **Listen address** : `127.0.0.1` ou réseau Docker interne uniquement
- [ ] **Firewall** : Port 5432 bloqué par firewall (ufw/iptables)

#### Permissions & Credentials
- [ ] **User dédié** : Pas d'utilisation de `postgres` superuser en prod
- [ ] **Permissions minimales** : User app a uniquement SELECT, INSERT, UPDATE, DELETE (pas de DROP, CREATE)
- [ ] **Password fort** : Password généré aléatoirement (64+ chars)
- [ ] **SSL/TLS** : Connexion chiffrée entre backend et DB

#### Backup & Recovery
- [ ] **Backups automatiques** : Cron job quotidien avec `pg_dump`
- [ ] **Backups testés** : Procédure de restore testée régulièrement
- [ ] **Encryption** : Backups chiffrés (GPG ou similaire)
- [ ] **Stockage distant** : Backups stockés hors serveur (S3, rsync distant)

#### Logs & Monitoring
- [ ] **Logs activés** : `log_statement = 'all'` ou `'mod'`
- [ ] **Log rotation** : Rotation automatique des logs
- [ ] **Monitoring** : Alertes sur échec connexion, queries lentes

**Commandes d'audit** :
```bash
# Vérifier que PostgreSQL n'est pas exposé
nmap -p 5432 <ip-serveur-prod>
# Attendu : Port filtered ou closed

# Vérifier les permissions user
docker exec collectoria-postgres psql -U collectoria -c "\du"

# Tester connexion externe (doit échouer)
psql -h <ip-serveur-prod> -U collectoria -d collection_management
# Attendu : Connection refused ou timeout
```

---

### 5. Serveur & SSH (Agent DevOps)

#### SSH Hardening
- [ ] **Root login** : `PermitRootLogin no`
- [ ] **Password auth** : `PasswordAuthentication no` (SSH keys uniquement)
- [ ] **Port non standard** : SSH sur port non-standard (pas 22)
- [ ] **Fail2ban** : Installé et configuré (bannir brute-force)
- [ ] **SSH keys** : Keys 4096-bit RSA ou Ed25519

#### Firewall
- [ ] **ufw/iptables** : Activé
- [ ] **Ports ouverts** : Uniquement 80, 443, SSH (port custom)
- [ ] **Default policy** : DENY par défaut, ALLOW explicite

#### Système
- [ ] **Mises à jour** : Système et packages à jour (`apt update && apt upgrade`)
- [ ] **Unattended upgrades** : Auto-update sécurité activé
- [ ] **Services inutiles** : Services non nécessaires désactivés

#### Monitoring & Logs
- [ ] **Logs centralisés** : Logs Docker + système dans un seul endroit
- [ ] **Rotation logs** : Logrotate configuré (éviter saturation disque)
- [ ] **Monitoring disque** : Alertes si disque >80% plein
- [ ] **Monitoring ressources** : CPU/RAM/réseau monitored

**Commandes d'audit** :
```bash
# Vérifier configuration SSH
grep -E "(PermitRootLogin|PasswordAuthentication)" /etc/ssh/sshd_config

# Vérifier firewall
sudo ufw status verbose

# Vérifier fail2ban
sudo fail2ban-client status sshd

# Vérifier mises à jour
apt list --upgradable

# Vérifier les services actifs
systemctl list-units --type=service --state=running
```

---

### 6. Détection & Réponse (Agent Security)

#### Logging
- [ ] **Access logs** : Traefik logs tous les accès HTTP
- [ ] **Application logs** : Backend logs toutes les actions importantes
- [ ] **Security events** : Login failures, auth errors loggés
- [ ] **Format structuré** : Logs JSON pour parsing automatique

#### Monitoring
- [ ] **Uptime monitoring** : Ping externe régulier (UptimeRobot, Pingdom)
- [ ] **Error rate** : Alertes si taux d'erreur 5XX >5%
- [ ] **Anomalies** : Détection de patterns suspects (nombreuses requêtes 401)

#### Incident Response
- [ ] **Procédure documentée** : Plan de réponse incident documenté
- [ ] **Contacts** : Liste de contacts en cas d'incident
- [ ] **Rollback** : Procédure de rollback rapide documentée

---

## Plan d'Action

### Phase 1 : Audit Infrastructure (1.5h)

**Agent DevOps** :
- [ ] Audit Docker (images, réseau, configuration)
- [ ] Audit Traefik (HTTPS, headers, rate limiting)
- [ ] Audit serveur (SSH, firewall, mises à jour)
- [ ] Rapport section Infrastructure

### Phase 2 : Audit Application (1h)

**Agent Security** :
- [ ] Audit authentification/autorisation
- [ ] Tests injection SQL
- [ ] Audit secrets management
- [ ] Rapport section Application

### Phase 3 : Audit Base de Données (30min)

**Agent DevOps** :
- [ ] Audit accès réseau PostgreSQL
- [ ] Audit permissions et credentials
- [ ] Audit backups
- [ ] Rapport section Base de Données

### Phase 4 : Tests Automatisés (30min)

**Agent Security** :
- [ ] Scan Mozilla Observatory (headers HTTP)
- [ ] Scan SSL Labs (TLS config)
- [ ] Scan OWASP ZAP (vulnérabilités web)
- [ ] Scan Trivy (CVE images Docker)

### Phase 5 : Consolidation Rapport (30min)

**Agent Security** :
- [ ] Fusionner tous les audits
- [ ] Calculer score global /10
- [ ] Prioriser les vulnérabilités (CRITICAL, HIGH, MEDIUM, LOW)
- [ ] Créer plan de remediation

---

## Critères d'Acceptation

- [ ] Audit complet de tous les domaines (Infrastructure, App, DB, Serveur)
- [ ] Rapport structuré avec score /10
- [ ] Vulnérabilités classées par criticité
- [ ] Plan de remediation détaillé avec priorités
- [ ] Tests automatisés exécutés (Observatory, SSL Labs, ZAP, Trivy)

---

## Format du Rapport

```markdown
# Rapport Audit Sécurité Production - Collectoria

**Date** : 2026-05-04
**Score Global** : X.X/10

---

## Résumé Exécutif

[2-3 paragraphes synthétisant l'état de sécurité]

---

## Score par Domaine

| Domaine | Score | Statut |
|---------|-------|--------|
| Infrastructure Docker | X/10 | ✅ / ⚠️ / ❌ |
| Traefik & HTTPS | X/10 | ✅ / ⚠️ / ❌ |
| Application Backend | X/10 | ✅ / ⚠️ / ❌ |
| Base de Données | X/10 | ✅ / ⚠️ / ❌ |
| Serveur & SSH | X/10 | ✅ / ⚠️ / ❌ |
| Monitoring & Logs | X/10 | ✅ / ⚠️ / ❌ |

---

## Vulnérabilités Identifiées

### CRITICAL (Score 9.0+)
1. [Vulnérabilité] — [Impact] — [Remediation]

### HIGH (Score 7.0-8.9)
1. [Vulnérabilité] — [Impact] — [Remediation]

### MEDIUM (Score 4.0-6.9)
1. [Vulnérabilité] — [Impact] — [Remediation]

### LOW (Score <4.0)
1. [Vulnérabilité] — [Impact] — [Remediation]

---

## Tests Automatisés

### Mozilla Observatory
- **Score** : X/100
- **Grade** : A+ / A / B / C / D / F
- **Détails** : [URL scan]

### SSL Labs
- **Score** : A+ / A / B / C / D / F
- **TLS Version** : 1.2, 1.3
- **Détails** : [URL scan]

### OWASP ZAP
- **Alertes** : X high, Y medium, Z low
- **Détails** : [Résumé]

### Trivy (CVE Docker)
- **Images scannées** : X
- **CVE critiques** : Y
- **CVE hautes** : Z

---

## Plan de Remediation

### Priorité 1 (URGENT - 1-2h)
- [ ] [Action] — [Agent responsable]

### Priorité 2 (HAUTE - 1 semaine)
- [ ] [Action] — [Agent responsable]

### Priorité 3 (MEDIUM - 1 mois)
- [ ] [Action] — [Agent responsable]

---

## Recommandations Long Terme

1. [Recommandation]
2. [Recommandation]

---

## Prochain Audit

**Date recommandée** : 2026-08-04 (3 mois)

---

**Rapport complet** : `/Security/audits/2026-05-04_production-audit.md`
```

---

## Risques & Mitigations

**Risque 1** : Audit identifie vulnérabilité critique exploitée activement
→ **Mitigation** : Patch immédiat, monitoring renforcé, analyse logs historiques

**Risque 2** : Tests de sécurité causent downtime production
→ **Mitigation** : Tests en lecture seule, pas de tests destructifs, hors heures de pointe

**Risque 3** : Faux positifs dans les scans automatiques
→ **Mitigation** : Validation manuelle par Agent Security

---

## Références

- OWASP Top 10 : https://owasp.org/www-project-top-ten/
- CIS Docker Benchmark : https://www.cisecurity.org/benchmark/docker
- Mozilla Security Guidelines : https://infosec.mozilla.org/guidelines/web_security
- Docker Security Best Practices : https://docs.docker.com/engine/security/

---

## Notes

### Comparaison Score Dev vs Prod

**Environnement Dev** : 9.0/10
- ✅ Code sécurisé (injection SQL, auth, validation)
- ✅ Dépendances à jour
- ⚠️ Pas de HTTPS (local)
- ⚠️ Secrets en clair (acceptable en dev)

**Environnement Prod** : TBD après audit
- ✅ HTTPS (attendu)
- ✅ Firewall (attendu)
- ❓ Headers sécurité HTTP
- ❓ Rate limiting
- ❓ Monitoring & logs
- ❓ Backups DB

**Objectif** : Maintenir score ≥9.0/10 en production.

---

**Prochaines Actions** :
1. Phase 1 : Audit Infrastructure (Agent DevOps, 1.5h)
2. Phase 2 : Audit Application (Agent Security, 1h)
3. Phase 3 : Audit DB (Agent DevOps, 30min)
4. Phase 4 : Tests automatisés (Agent Security, 30min)
5. Phase 5 : Rapport consolidé (Agent Security, 30min)
