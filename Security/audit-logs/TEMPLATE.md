# Audit Sécurité - [Type] - [Date]

**Date** : YYYY-MM-DD  
**Type d'audit** : [Manual / Automated / Scheduled / Post-Incident]  
**Auditeur** : [Agent Security / Nom développeur / Outil]  
**Contexte** : [Description du contexte : nouveau feature, incident, audit périodique, etc.]  
**Durée** : [Temps passé sur l'audit]

---

## Périmètre de l'Audit

**Composants audités** :
- [ ] Backend Go (microservices)
- [ ] Frontend Next.js
- [ ] Infrastructure (Docker, PostgreSQL)
- [ ] Dépendances (go.mod, package.json)
- [ ] Configuration & Secrets
- [ ] CI/CD Pipeline

**Fichiers/Répertoires analysés** :
- `path/to/file1.go`
- `path/to/file2.tsx`
- ...

**Commits concernés** : [Hash des commits si applicable]

---

## Méthodologie

**Outils utilisés** :
- [ ] Revue de code manuelle
- [ ] `govulncheck` (Go)
- [ ] `npm audit` (Node.js)
- [ ] `gosec` (Go static analysis)
- [ ] `trivy` (Docker scan)
- [ ] `git-secrets` (secrets scanning)
- [ ] OWASP ZAP / Burp Suite (tests dynamiques)
- [ ] Autres : [préciser]

**Standards appliqués** :
- OWASP Top 10
- CWE (Common Weakness Enumeration)
- SANS Top 25
- Règles projet Collectoria (Security/CLAUDE.md)

---

## Résultats de l'Audit

### Résumé Exécutif

| Criticité | Nombre | Statut |
|-----------|--------|--------|
| 🔴 CRITIQUE | 0 | - |
| 🟠 HAUTE | 0 | - |
| 🟡 MOYENNE | 0 | - |
| 🔵 BASSE | 0 | - |
| ✅ INFO | 0 | - |

**Score de sécurité** : X.X/10

**Verdict** : [Production-ready / Nécessite corrections CRITIQUES / Nécessite corrections HAUTES / Acceptable avec réserves]

---

## Vulnérabilités Identifiées

### 🔴 [CRITIQUE-001] Titre de la Vulnérabilité

**Type** : [SQL Injection / XSS / Authentication Bypass / etc.]  
**CWE** : CWE-XXX  
**CVE** : CVE-YYYY-XXXXX (si applicable)  
**CVSS Score** : X.X (Critical/High/Medium/Low)

**Localisation** :
- Fichier : `path/to/file.go`
- Ligne : 123
- Fonction/Composant : `FunctionName()`

**Description** :
[Description détaillée de la vulnérabilité]

**Preuve de Concept (PoC)** :
```bash
# Commande ou requête démontrant la vulnérabilité
curl -X POST http://localhost:8080/api/endpoint \
  -d "malicious_input"
```

**Impact** :
- **Confidentialité** : [Aucun / Faible / Moyen / Élevé]
- **Intégrité** : [Aucun / Faible / Moyen / Élevé]
- **Disponibilité** : [Aucun / Faible / Moyen / Élevé]
- **Impact métier** : [Description de l'impact réel sur l'application]

**Exploitabilité** : [Triviale / Facile / Difficile / Très Difficile]

**Recommandation** :
[Solution concrète avec exemple de code si possible]

```go
// Exemple de correction
// AVANT (vulnérable)
query := "SELECT * FROM users WHERE id = " + userInput

// APRÈS (sécurisé)
query := "SELECT * FROM users WHERE id = ?"
db.Query(query, userInput)
```

**Effort de correction** : [XS / S / M / L / XL] (< 1h / 1-4h / 1j / 2-3j / > 1 semaine)

**Statut** : [🔴 À CORRIGER / 🟡 EN COURS / ✅ CORRIGÉ / ⏸️ REPORTÉ / ❌ ACCEPTÉ (avec justification)]

**Assigné à** : [Agent Backend / Agent Frontend / Nom développeur]

**Deadline** : [YYYY-MM-DD] (CRITIQUE: immédiat, HAUTE: 7j, MOYENNE: 30j)

---

### 🟠 [HAUTE-001] Titre de la Vulnérabilité

[Même structure que ci-dessus]

---

## Dépendances Vulnérables

### Backend (Go)

| Package | Version Actuelle | Vulnérabilité | CVE | CVSS | Fix Version | Statut |
|---------|------------------|---------------|-----|------|-------------|--------|
| github.com/pkg/errors | 0.9.1 | - | - | - | 0.9.2 | ✅ À jour |
| ... | ... | ... | ... | ... | ... | ... |

**Commandes exécutées** :
```bash
cd backend/collection-management
govulncheck ./...
go list -m all
```

**Output complet** : Voir annexe A

---

### Frontend (Node.js)

| Package | Version Actuelle | Vulnérabilité | Severity | Fix Version | Statut |
|---------|------------------|---------------|----------|-------------|--------|
| react-dom | 19.0.0 | - | - | - | ✅ À jour |
| ... | ... | ... | ... | ... | ... |

**Commandes exécutées** :
```bash
cd frontend
npm audit
npm outdated
```

**Output complet** : Voir annexe B

---

## Bonnes Pratiques Respectées ✅

- ✅ Paramètres préparés (SQL) utilisés systématiquement
- ✅ Validation des inputs utilisateur sur tous les endpoints
- ✅ Headers de sécurité HTTP configurés
- ✅ CORS configuré strictement
- ✅ Authentification JWT implémentée
- ✅ Pas de secrets hardcodés (utilisation env vars)
- ✅ Logging sans données sensibles
- ✅ Docker non-root

---

## Points d'Attention (Non-Bloquants)

### ℹ️ [INFO-001] Titre du Point d'Attention

**Description** : [Description]

**Recommandation** : [Amélioration suggérée]

**Priorité** : [Nice-to-have / Bonne pratique / Recommandé]

---

## Actions Prioritaires

### Immédiat (< 24h)
1. [ ] [CRITIQUE-001] Corriger [titre vulnérabilité]
2. [ ] [CRITIQUE-002] ...

### Court terme (< 7 jours)
1. [ ] [HAUTE-001] Corriger [titre vulnérabilité]
2. [ ] [HAUTE-002] ...

### Moyen terme (< 30 jours)
1. [ ] [MOYENNE-001] ...
2. [ ] [MOYENNE-002] ...

### Long terme (> 30 jours)
1. [ ] [BASSE-001] ...
2. [ ] [INFO-001] ...

---

## Recommandations Générales

### Code
- [Recommandation générale sur les pratiques de code]

### Infrastructure
- [Recommandation infrastructure]

### Processus
- [Recommandation processus/workflow]

---

## Tests de Sécurité Effectués

### Tests d'Injection
- [ ] SQL Injection (endpoints API)
- [ ] NoSQL Injection (si applicable)
- [ ] Command Injection
- [ ] LDAP Injection (si applicable)

### Tests d'Authentification
- [ ] Bypass authentification
- [ ] Brute force protection
- [ ] Session fixation
- [ ] Token expiration
- [ ] Token revocation

### Tests d'Autorisation
- [ ] Privilege escalation (vertical)
- [ ] Horizontal access control (IDOR)
- [ ] Missing function level access control

### Tests XSS
- [ ] Reflected XSS
- [ ] Stored XSS
- [ ] DOM-based XSS

### Autres
- [ ] CSRF protection
- [ ] Clickjacking
- [ ] XXE (XML External Entity)
- [ ] SSRF (Server-Side Request Forgery)
- [ ] Open redirects
- [ ] File upload vulnerabilities

---

## Métriques

**Temps d'audit** : [X heures]  
**Lignes de code analysées** : ~[X,XXX] lignes  
**Fichiers analysés** : [XX] fichiers  
**Tests de sécurité exécutés** : [XX] tests  
**Vulnérabilités trouvées** : [XX] total  
**Taux de faux positifs** : [X%]

---

## Annexes

### Annexe A : Output govulncheck complet
```
[Coller l'output complet]
```

### Annexe B : Output npm audit complet
```
[Coller l'output complet]
```

### Annexe C : Logs / Screenshots
[Si applicable]

---

## Suivi

**Prochain audit prévu** : [YYYY-MM-DD]  
**Fréquence recommandée** : [Hebdomadaire / Bi-mensuelle / Mensuelle / Trimestrielle]

**Audit précédent** : [Lien vers audit précédent]  
**Audit suivant** : [À créer après corrections]

---

## Signatures

**Auditeur** : [Nom]  
**Date** : [YYYY-MM-DD]

**Validation** : [Nom responsable sécurité / Lead dev]  
**Date validation** : [YYYY-MM-DD]

---

*Template version 1.0 - 2026-04-23*  
*Basé sur OWASP Testing Guide et Security/CLAUDE.md*
