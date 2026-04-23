# Phase 3 Sécurité - Planification vers 10.0/10

**Date de création** : 2026-04-23  
**Priorité** : MOYENNE  
**Effort estimé** : 2-3 jours (16-24h)  
**Status** : Planification  
**Score actuel** : 9.0/10 (production-ready)  
**Score cible** : 10.0/10 (excellent, best practices complètes)

---

## 📋 Vue d'ensemble

La Phase 3 vise à atteindre l'excellence en sécurité (10.0/10) en ajoutant les couches de protection avancées et l'automatisation complète des audits de sécurité.

**Contexte** :
- Phase 1 Quick Wins : 4.5/10 → 7.0/10 ✅
- Phase 2 Production-Ready : 7.0/10 → 9.0/10 ✅
- Phase 3 Excellence : 9.0/10 → 10.0/10 (cette phase)

---

## 🎯 Objectifs de la Phase 3

### Score de Sécurité
- **Avant Phase 3** : 9.0/10 (production-ready baseline)
- **Après Phase 3** : 10.0/10 (+1.0, excellence en sécurité)

### Domaines d'Amélioration

1. **Automatisation des Audits** (+0.3)
   - Intégration CI/CD des tests de sécurité
   - Audit automatique des dépendances (CVE scanning)
   - Audit automatique des secrets (gitleaks)

2. **Observabilité Sécurité** (+0.2)
   - Logging structuré des événements de sécurité
   - Métriques Prometheus pour rate limiting
   - Alertes automatiques sur événements suspects

3. **Hardening Avancé** (+0.3)
   - Content Security Policy (CSP) renforcé
   - Subresource Integrity (SRI) pour assets externes
   - HTTPS strict avec HSTS
   - Certificate pinning (optionnel)

4. **Authentification Avancée** (+0.2)
   - Refresh tokens (JWT rotation)
   - Multi-factor authentication (MFA) préparation
   - Session management avancé
   - Account lockout après tentatives échouées

---

## 📊 Tâches Détaillées

### Tâche 1 : CI/CD Security Integration (6h)

**Score Impact** : +0.15

#### Sous-tâches

##### 1.1 Integration Tests Database (2h)

**Objectif** : Configurer PostgreSQL de test dans GitHub Actions

**Actions** :
```yaml
# .github/workflows/security-tests.yml
services:
  postgres:
    image: postgres:15
    env:
      POSTGRES_USER: collectoria_test
      POSTGRES_PASSWORD: collectoria_test
      POSTGRES_DB: collection_management_test
```

**Livrables** :
- Workflow GitHub Actions pour tests de sécurité
- 105 tests SQL injection exécutés automatiquement
- Badge de sécurité dans README

##### 1.2 Dependency Scanning (2h)

**Objectif** : Détecter automatiquement les CVEs dans les dépendances

**Outils** :
- **Go** : `govulncheck` (officiel Go team)
- **NPM** : `npm audit`
- **GitHub** : Dependabot alerts

**Actions** :
```yaml
# .github/workflows/security-scan.yml
- name: Go vulnerability check
  run: govulncheck ./...

- name: NPM audit
  run: npm audit --audit-level=moderate
```

**Livrables** :
- Scan automatique à chaque push
- Rapport CVE dans GitHub Actions
- Alertes Slack pour nouvelles vulnérabilités

##### 1.3 Secret Scanning (1h)

**Objectif** : Détecter les secrets commitées par erreur

**Outil** : `gitleaks`

**Actions** :
```yaml
# .github/workflows/secrets-scan.yml
- name: Gitleaks
  uses: gitleaks/gitleaks-action@v2
  env:
    GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
```

**Configuration** : `.gitleaks.toml`
```toml
[allowlist]
paths = [
  ".*_test\\.go$",
  ".*/testdata/.*"
]
```

**Livrables** :
- Scan du repo complet
- Prévention de commits avec secrets
- Rapport de secrets détectés

##### 1.4 Pre-commit Hooks (1h)

**Objectif** : Bloquer les commits non sécurisés avant push

**Hooks à ajouter** :
- Scan gitleaks local
- Tests de sécurité obligatoires
- Validation des messages de commit

**Installation** :
```bash
# .git/hooks/pre-commit
#!/bin/bash
echo "🔒 Running security checks..."
gitleaks protect --staged --verbose
go test ./tests/security/...
```

**Livrables** :
- Script d'installation des hooks
- Documentation pour développeurs
- Validation automatique pré-commit

---

### Tâche 2 : Security Observability (5h)

**Score Impact** : +0.2

#### Sous-tâches

##### 2.1 Structured Security Logging (2h)

**Objectif** : Logger tous les événements de sécurité avec contexte enrichi

**Événements à logger** :
- Tentatives de login échouées (avec IP, timestamp, user)
- Rate limiting 429 (endpoint, IP, tentatives)
- Erreurs d'authentification JWT (token invalide, expiré)
- Accès refusé (403, avec ressource demandée)

**Exemple** :
```go
log.Warn().
    Str("event", "auth_failed").
    Str("ip", clientIP).
    Str("username", username).
    Int("attempt_count", count).
    Msg("Authentication failed")
```

**Format** : JSON structuré (déjà en place avec zerolog)

**Livrables** :
- Logging enrichi dans tous les handlers de sécurité
- Corrélation IDs pour tracer les requêtes
- Log retention policy documentée

##### 2.2 Prometheus Metrics (2h)

**Objectif** : Exposer des métriques de sécurité pour Grafana

**Métriques à exposer** :
```go
// Rate Limiting
rate_limit_hits_total{endpoint="login"} 42
rate_limit_blocks_total{endpoint="login", ip="x.x.x.x"} 5

// Authentication
auth_attempts_total{status="success"} 1523
auth_attempts_total{status="failed"} 34
jwt_token_validations_total{status="valid"} 8421
jwt_token_validations_total{status="expired"} 12

// SQL Injection (si détecté)
sql_injection_attempts_total{vector="search"} 0
```

**Library** : `github.com/prometheus/client_golang`

**Endpoint** : `GET /metrics` (non authentifié, pour scraping Prometheus)

**Livrables** :
- Métriques Prometheus exposées
- Grafana dashboard JSON
- Alerting rules pour Prometheus

##### 2.3 Security Alerting (1h)

**Objectif** : Alertes automatiques sur événements critiques

**Alertes à créer** :
1. **Brute Force Attack** : >10 tentatives login échouées depuis même IP en 5min
2. **Rate Limit Abuse** : >50 requêtes 429 en 10min
3. **Suspicious Activity** : Tentatives d'accès à ressources interdites
4. **CVE Detection** : Nouvelle vulnérabilité détectée dans dépendances

**Canaux** :
- Slack webhook
- Email (critiques uniquement)
- PagerDuty (production)

**Livrables** :
- Configuration Prometheus Alertmanager
- Templates d'alertes Slack
- Playbook de réponse aux incidents

---

### Tâche 3 : Advanced Hardening (5h)

**Score Impact** : +0.3

#### Sous-tâches

##### 3.1 Content Security Policy (CSP) (2h)

**Objectif** : Renforcer CSP pour prévenir XSS et injection de contenu

**Actuel** :
```
Content-Security-Policy: default-src 'self'; frame-ancestors 'none'
```

**Amélioré** :
```
Content-Security-Policy:
  default-src 'self';
  script-src 'self' 'sha256-xxx' https://trusted-cdn.com;
  style-src 'self' 'unsafe-inline';
  img-src 'self' data: https:;
  font-src 'self' https://fonts.gstatic.com;
  connect-src 'self' https://api.collectoria.com;
  frame-ancestors 'none';
  base-uri 'self';
  form-action 'self';
  upgrade-insecure-requests;
```

**Actions** :
- Audit de toutes les ressources externes (CDN, fonts, scripts)
- Calcul des hashes SHA-256 pour scripts inline
- Configuration CSP dans middleware
- Tests de violation CSP

**Livrables** :
- CSP renforcé en production
- Report-URI pour violations CSP
- Documentation des sources autorisées

##### 3.2 Subresource Integrity (SRI) (1h)

**Objectif** : Garantir l'intégrité des assets externes (CDN)

**Exemple** :
```html
<script src="https://cdn.example.com/library.js"
        integrity="sha384-oqVuAfXRKap7fdgcCY5uykM6+R9GqQ8K/ux..."
        crossorigin="anonymous"></script>
```

**Actions** :
- Identifier tous les scripts/styles externes
- Générer les hashes SRI
- Ajouter `integrity` et `crossorigin` attributes
- Tests de chargement avec SRI

**Livrables** :
- SRI pour tous les assets externes
- Fallback local si CDN fail
- Documentation des hashes

##### 3.3 HTTPS Strict & HSTS (1h)

**Objectif** : Forcer HTTPS partout avec HSTS

**Actuel** :
```
Strict-Transport-Security: max-age=31536000; includeSubDomains
```

**Amélioré** :
```
Strict-Transport-Security: max-age=63072000; includeSubDomains; preload
```

**Actions** :
- Augmenter max-age à 2 ans
- Ajouter `preload` directive
- Soumettre à HSTS preload list (hstspreload.org)
- Redirection automatique HTTP → HTTPS

**Livrables** :
- HSTS preload activé
- Soumission HSTS preload list
- Tests de redirection HTTPS

##### 3.4 Additional Security Headers (1h)

**Objectif** : Ajouter headers de sécurité manquants

**Headers à ajouter** :
```
Permissions-Policy: geolocation=(), microphone=(), camera=()
Cross-Origin-Embedder-Policy: require-corp
Cross-Origin-Opener-Policy: same-origin
Cross-Origin-Resource-Policy: same-origin
```

**Actions** :
- Audit des headers actuels vs recommandations OWASP
- Ajout des headers manquants
- Tests avec securityheaders.com

**Livrables** :
- Tous headers OWASP recommandés présents
- Score A+ sur securityheaders.com
- Documentation des headers

---

### Tâche 4 : Advanced Authentication (4h)

**Score Impact** : +0.2

#### Sous-tâches

##### 4.1 JWT Refresh Tokens (2h)

**Objectif** : Rotation automatique des tokens JWT

**Actuel** :
- Access token : 24h expiration
- Pas de refresh token

**Amélioré** :
- Access token : 15 min expiration
- Refresh token : 7 jours expiration
- Rotation automatique

**Endpoints** :
- `POST /auth/refresh` - Renouvelle access token avec refresh token
- `POST /auth/logout` - Révoque refresh token

**Storage** :
- Refresh tokens en base de données (table `refresh_tokens`)
- Possibilité de révoquer tous les tokens d'un utilisateur

**Livrables** :
- Implémentation refresh token
- Tests automatisés (rotation, révocation)
- Documentation API

##### 4.2 Account Lockout (1h)

**Objectif** : Bloquer comptes après tentatives échouées

**Règles** :
- 5 tentatives échouées → Compte bloqué 15 min
- 10 tentatives échouées → Compte bloqué 1h
- 20 tentatives échouées → Compte bloqué manuellement

**Storage** :
- Table `login_attempts` (user_id, timestamp, ip, success)
- Cleanup automatique des anciennes tentatives

**Actions** :
- Tracking des tentatives de login
- Blocage automatique
- Notification email à l'utilisateur
- Endpoint admin pour débloquer

**Livrables** :
- Account lockout fonctionnel
- Tests automatisés
- Documentation pour admins

##### 4.3 MFA Preparation (1h)

**Objectif** : Préparer l'infrastructure pour MFA (Time-based OTP)

**Note** : Implémentation complète MFA en Phase 4, Phase 3 = préparation

**Actions** :
- Schéma BDD pour secrets MFA (`user_mfa_secrets`)
- Endpoints stub :
  - `POST /auth/mfa/setup` - Génère QR code TOTP
  - `POST /auth/mfa/verify` - Vérifie code TOTP
  - `POST /auth/mfa/disable` - Désactive MFA
- Tests avec library `github.com/pquerna/otp`

**Livrables** :
- Structure BDD MFA
- Endpoints stubs (retournent 501 Not Implemented)
- Documentation design MFA

---

## 📋 Ordre d'Exécution Recommandé

### Sprint 1 (8h - Jour 1)
1. **Tâche 1.1-1.4** : CI/CD Security Integration (6h)
2. **Tâche 2.1** : Structured Security Logging (2h)

### Sprint 2 (8h - Jour 2)
3. **Tâche 2.2-2.3** : Metrics & Alerting (3h)
4. **Tâche 3.1-3.2** : CSP & SRI (3h)
5. **Tâche 4.1** : JWT Refresh Tokens (2h)

### Sprint 3 (4-8h - Jour 3)
6. **Tâche 3.3-3.4** : HTTPS Strict & Headers (2h)
7. **Tâche 4.2-4.3** : Account Lockout & MFA Prep (2h)
8. **Tests & Documentation** : Validation complète (2-4h)

---

## 📊 Métriques de Succès

### Score de Sécurité
- **Avant Phase 3** : 9.0/10
- **Après CI/CD** : 9.15/10
- **Après Observability** : 9.35/10
- **Après Hardening** : 9.65/10
- **Après Auth Advanced** : **10.0/10** ✅

### Tests
- **Phase 2** : 253 tests
- **Phase 3** : +30 tests minimum
- **Total Phase 3** : 280+ tests

### Couverture Sécurité
- ✅ SQL Injection : 105 tests
- ✅ Rate Limiting : 9 tests
- ✅ JWT Auth : 22 tests
- 🆕 CVE Scanning : Automatique (CI/CD)
- 🆕 Secret Scanning : Automatique (CI/CD)
- 🆕 Refresh Tokens : +5 tests
- 🆕 Account Lockout : +3 tests

### Documentation
- **Phase 2** : ~20,000 lignes
- **Phase 3** : +2,000 lignes
- **Total** : ~22,000 lignes

### Commits
- **Phase 3** : 4-6 commits atomiques

---

## 🎯 Critères d'Acceptation (Phase 3 Complète)

### CI/CD Security
- [ ] Tests SQL injection s'exécutent automatiquement dans GitHub Actions
- [ ] Scan CVE automatique (govulncheck + npm audit)
- [ ] Scan secrets automatique (gitleaks)
- [ ] Pre-commit hooks installés et documentés
- [ ] Badge sécurité dans README

### Observability
- [ ] Événements de sécurité loggés en JSON structuré
- [ ] Métriques Prometheus exposées sur /metrics
- [ ] Grafana dashboard créé (JSON exporté)
- [ ] Alertes configurées (brute force, rate limit abuse)
- [ ] Tests d'alerting validés

### Hardening
- [ ] CSP renforcé avec sources explicites
- [ ] SRI pour tous assets externes
- [ ] HSTS preload activé et soumis
- [ ] Score A+ sur securityheaders.com
- [ ] Tous headers OWASP recommandés présents

### Authentication
- [ ] Refresh tokens implémentés et testés
- [ ] Account lockout fonctionnel (5 tentatives)
- [ ] Infrastructure MFA préparée (schéma BDD + stubs)
- [ ] Tests automatisés pour refresh + lockout
- [ ] Documentation API complète

### Documentation
- [ ] Plan de réponse aux incidents (playbook)
- [ ] Guide d'observabilité (métriques, logs, alertes)
- [ ] Guide de déploiement sécurisé (HTTPS, headers)
- [ ] README mis à jour avec nouveaux workflows CI/CD

### Score Final
- [ ] Score de sécurité : **10.0/10** atteint
- [ ] Audit complet documenté
- [ ] Rapport de phase 3 créé
- [ ] STATUS.md mis à jour

---

## 📚 Références

### Standards & Guidelines
- [OWASP Top 10 2021](https://owasp.org/www-project-top-ten/)
- [OWASP API Security Top 10](https://owasp.org/www-project-api-security/)
- [CWE Top 25](https://cwe.mitre.org/top25/)
- [NIST Cybersecurity Framework](https://www.nist.gov/cyberframework)

### Tools
- [govulncheck](https://pkg.go.dev/golang.org/x/vuln/cmd/govulncheck)
- [gitleaks](https://github.com/gitleaks/gitleaks)
- [Prometheus](https://prometheus.io/)
- [Grafana](https://grafana.com/)

### Best Practices
- [Mozilla Security Guidelines](https://infosec.mozilla.org/guidelines/)
- [Google Security Best Practices](https://cloud.google.com/security/best-practices)
- [NIST SP 800-53](https://csrc.nist.gov/publications/detail/sp/800-53/rev-5/final)

---

## 🚀 Après Phase 3

### Phase 4 (Optionnel - Excellence++)
- Implémentation MFA complète (TOTP + backup codes)
- WAF (Web Application Firewall)
- DDoS protection avancée
- Pen testing externe
- Bug bounty program

### Maintenance Continue
- Audit trimestriel des dépendances
- Revue mensuelle des logs de sécurité
- Tests de charge réguliers
- Mise à jour des playbooks d'incidents

---

**Date de création** : 2026-04-23  
**Auteur** : Alfred (Agent Principal)  
**Status** : PLANIFICATION  
**Priorité** : Après complétion des fonctionnalités métier prioritaires
