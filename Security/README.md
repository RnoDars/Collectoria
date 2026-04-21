# Security - Collectoria Project

Ce répertoire contient tous les documents et outils relatifs à la sécurité du projet Collectoria.

---

## Structure

```
Security/
├── README.md                          # Ce fichier
├── CLAUDE.md                          # Instructions pour l'Agent Security
├── audit-script.sh                    # Script d'audit automatisé
├── reports/                           # Rapports d'audit
│   └── 2026-04-21_audit-mvp.md       # Audit complet MVP
└── recommendations/                   # Recommandations détaillées
    ├── CRIT-001_jwt-authentication.md
    ├── CRIT-002_sql-injection-fix.md
    └── QUICK-WINS.md                 # Corrections rapides
```

---

## Rapport d'Audit Principal

**[Audit MVP - 2026-04-21](reports/2026-04-21_audit-mvp.md)**

### Résumé Exécutif

| Métrique | Valeur |
|----------|--------|
| Score de Sécurité | 4.5/10 ⚠️ |
| Vulnérabilités CRITICAL | 5 |
| Vulnérabilités HIGH | 4 |
| Vulnérabilités MEDIUM | 6 |
| Vulnérabilités LOW | 3 |

### Vulnérabilités Critiques Identifiées

1. **CRIT-001**: Absence totale d'authentification (userID hardcodé)
2. **CRIT-002**: Risque d'injection SQL dans `CardRepository.GetCardsCatalog`
3. **CRIT-003**: Configuration CORS non sécurisée pour la production
4. **CRIT-004**: Credentials en clair dans `docker-compose.yml`
5. **CRIT-005**: Absence de rate limiting (risque DoS)

---

## Utilisation du Script d'Audit

### Installation des Dépendances

```bash
# Installer govulncheck pour scanner les dépendances Go
go install golang.org/x/vuln/cmd/govulncheck@latest

# S'assurer que npm est installé pour auditer le frontend
npm --version
```

### Exécution

```bash
# Depuis la racine du projet
./Security/audit-script.sh
```

### Interprétation des Résultats

Le script retourne un code de sortie selon la sévérité:
- `0`: Aucun problème critique ou élevé
- `1`: Problèmes HIGH détectés
- `2`: Problèmes CRITICAL détectés

### Exemple de Sortie

```
========================================
  Collectoria Security Audit Script
========================================

[1] Backend Security Checks

1.1 Checking for hardcoded userID...
✗ Hardcoded userID found in handlers (CRIT-001)

1.2 Checking JWT authentication...
✗ JWT authentication not implemented (CRIT-001)

[...]

========================================
  Audit Summary
========================================

Checks Passed: 8
Issues Found:  18

  CRITICAL: 5
  HIGH:     4
  MEDIUM:   6
  LOW:      3

Security Score: 4/10

⚠ CRITICAL issues detected! Address immediately before production.
   Priority: CRIT-001 (Auth), CRIT-002 (SQL Injection), CRIT-003 (CORS)
```

---

## Plan d'Action

### Phase 1 - IMMÉDIAT (2-3 jours) ⏱️

**Quick Wins** (2-3 heures):
- [ ] Externaliser credentials Docker Compose
- [ ] Ajouter headers de sécurité HTTP
- [ ] Configurer CORS via variables d'environnement
- [ ] Dockerfile non-root
- [ ] Logger configurable selon environnement

**Vulnérabilités CRITICAL** (2-3 jours):
- [ ] [CRIT-001](recommendations/CRIT-001_jwt-authentication.md): Implémenter JWT authentication
- [ ] [CRIT-002](recommendations/CRIT-002_sql-injection-fix.md): Corriger injection SQL
- [ ] CRIT-005: Implémenter rate limiting

### Phase 2 - COURT TERME (1 semaine) ⏱️

- [ ] HIGH-001: Validation stricte des inputs
- [ ] HIGH-002: Améliorer gestion des erreurs
- [ ] HIGH-003: Configurer timeouts SQL
- [ ] HIGH-004: Scanner dépendances (govulncheck)

### Phase 3 - MOYEN TERME (2-3 semaines) ⏱️

- [ ] MED-001: Headers de sécurité complets
- [ ] MED-002: Logging centralisé
- [ ] MED-003: Health check détaillé
- [ ] MED-004: CSP Frontend
- [ ] MED-006: Sécuriser Dockerfile

---

## Recommandations Détaillées

### Quick Wins (< 3 heures)

Consulter [QUICK-WINS.md](recommendations/QUICK-WINS.md) pour des corrections rapides avec un impact élevé:
- Headers de sécurité HTTP
- CORS configurable
- Credentials externalisés
- Dockerfile non-root
- Logging sécurisé

### Authentification JWT

Consulter [CRIT-001_jwt-authentication.md](recommendations/CRIT-001_jwt-authentication.md) pour:
- Implémentation complète JWT
- Middleware d'authentification
- Tests de sécurité
- Migration progressive

### Correction Injection SQL

Consulter [CRIT-002_sql-injection-fix.md](recommendations/CRIT-002_sql-injection-fix.md) pour:
- Utilisation de Query Builder sécurisé (Squirrel)
- Validation stricte des filtres
- Tests d'injection SQL

---

## Checklist Avant Production

### Sécurité Backend

- [ ] Authentification JWT implémentée et testée
- [ ] Rate limiting actif (100 req/min/IP)
- [ ] CORS whitelist stricte configurée
- [ ] Secrets externalisés (pas dans Git)
- [ ] Validation d'input sur tous les endpoints
- [ ] Headers de sécurité HTTP en place
- [ ] Requêtes SQL sécurisées (Query Builder)
- [ ] Timeouts SQL configurés
- [ ] Logger en mode production (JSON)

### Sécurité Frontend

- [ ] CSP headers configurés
- [ ] Dépendances npm sans CVE
- [ ] API URL via env variables
- [ ] Pas de secrets hardcodés

### Infrastructure

- [ ] Dockerfile non-root (UID 1000)
- [ ] Credentials via secrets manager
- [ ] Health checks détaillés
- [ ] Scan de vulnérabilités automatisé (CI)
- [ ] Monitoring de sécurité actif

### Tests de Sécurité

- [ ] Tests d'injection SQL passés
- [ ] Tests d'authentification passés
- [ ] Tests de rate limiting passés
- [ ] Tests CORS passés
- [ ] Scan OWASP ZAP effectué

---

## Outils Recommandés

### Scan de Vulnérabilités

**Go**:
```bash
# Vulnérabilités de dépendances
go install golang.org/x/vuln/cmd/govulncheck@latest
govulncheck ./...

# Analyse statique de sécurité
go install github.com/securego/gosec/v2/cmd/gosec@latest
gosec ./...
```

**Node.js**:
```bash
# Audit npm
cd frontend
npm audit
npm audit fix

# Scan avec Snyk (optionnel)
npx snyk test
```

**Docker**:
```bash
# Scan d'images
docker scan collectoria-api
trivy image collectoria-api
```

### Tests de Pénétration

**OWASP ZAP**:
```bash
# Scan rapide
docker run -t zaproxy/zap-baseline -t http://localhost:8080
```

**Burp Suite Community**: Pour tests manuels avancés

---

## Politique de Divulgation de Vulnérabilités

### Signalement

Si vous découvrez une vulnérabilité de sécurité:

1. **NE PAS** créer d'issue publique GitHub
2. Envoyer un email à: `security@collectoria.local` (À créer)
3. Inclure:
   - Description de la vulnérabilité
   - Étapes de reproduction
   - Impact potentiel
   - Suggestions de correction (optionnel)

### Délais de Réponse

- **Accusé de réception**: 48 heures
- **Analyse initiale**: 7 jours
- **Correction**:
  - CRITICAL: 7 jours
  - HIGH: 30 jours
  - MEDIUM: 60 jours
  - LOW: 90 jours
- **Divulgation publique**: Coordonnée avec le chercheur

---

## Références

### OWASP

- [OWASP Top 10 2021](https://owasp.org/Top10/)
- [OWASP API Security Top 10](https://owasp.org/API-Security/)
- [OWASP Go Cheat Sheet](https://cheatsheetseries.owasp.org/cheatsheets/Go_Cheat_Sheet.html)

### Standards

- [CWE (Common Weakness Enumeration)](https://cwe.mitre.org/)
- [CVE (Common Vulnerabilities and Exposures)](https://cve.mitre.org/)
- [NIST Cybersecurity Framework](https://www.nist.gov/cyberframework)

### Best Practices

- [Go Security Best Practices](https://github.com/OWASP/Go-SCP)
- [Docker Security Best Practices](https://docs.docker.com/develop/security-best-practices/)
- [Next.js Security Headers](https://nextjs.org/docs/advanced-features/security-headers)

---

## Contact

**Agent Security**: Responsable de l'audit et des recommandations de sécurité

Pour toute question sur ce rapport ou les recommandations, consulter:
- Le rapport d'audit complet: `reports/2026-04-21_audit-mvp.md`
- Les recommandations spécifiques dans `recommendations/`
- L'Agent Security via le système d'agents Collectoria

---

**Dernière mise à jour**: 2026-04-21  
**Version du rapport**: 1.0  
**Prochaine revue**: Après implémentation des Quick Wins et CRITICAL fixes
