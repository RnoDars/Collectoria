# Plan d'Action URGENT - Fixes Délégation Agents Spécialistes

**Date** : 2026-04-23  
**Priorité** : CRITIQUE  
**Durée estimée** : 3h (critical path)  
**Objectif** : Empêcher Alfred d'oublier de déléguer aux spécialistes

---

## Contexte

**Incident déclencheur** : Alfred a utilisé `sudo systemctl start postgresql` au lieu de déléguer à DevOps.

**Analyse** : Rapport complet dans `reports/2026-04-23_audit-delegation-specialists.md`

**Causes identifiées** :
1. Pas de déclencheurs automatiques de délégation dans CLAUDE.md d'Alfred
2. Règles critiques DevOps noyées dans 558 lignes de documentation
3. Documentation contradictoire (systemctl vs docker)

---

## Actions CRITIQUES (à faire AVANT toute nouvelle feature)

### Action 1 : Ajouter Déclencheurs Automatiques dans CLAUDE.md Alfred

**Durée** : 30 min  
**Fichier** : `/CLAUDE.md`  
**Position** : Après ligne 25 (après "Dispatch Intelligent")

**Contenu à ajouter** :

```markdown
## Déclencheurs Automatiques de Délégation

**RÈGLE CRITIQUE** : AVANT d'agir directement, TOUJOURS vérifier cette liste.

### Déclencheurs Obligatoires (TOUJOURS déléguer)

**Mots-clés Infrastructure** → **Agent DevOps**
- PostgreSQL, Docker, Compose, Container, Port, Environnement
- Tests locaux, Démarrage services, Redémarrage
- "Lance", "Démarre", "Teste localement"
- **Action** : `🤖 Alfred : Je fais appel à l'Agent DevOps pour [raison]`

**Mots-clés Sécurité** → **Agent Security**
- Vulnérabilité, Audit, CVE, OWASP, Secrets
- "Vérifie la sécurité", "Audit de", "Scan"
- **Action** : `🤖 Alfred : Je fais appel à l'Agent Security pour [raison]`

**Mots-clés Spécifications** → **Agent Spécifications**
- Nouvelle feature, Spec, Analyse d'image, Mockup
- "Crée une spec", "Analyse cette image"
- **Action** : AVANT de créer spec → VÉRIFIER plans existants (cf. lesson-check-existing-plans.md)

**Mots-clés Tests** → **Agent Testing**
- Tests unitaires, Tests intégration, TDD, Coverage
- "Écris des tests", "Teste", "Coverage"
- **Action** : `🤖 Alfred : Je fais appel à l'Agent Testing pour [raison]`

### Checklist Pré-Action

Avant d'agir directement (sans déléguer), Alfred DOIT répondre OUI à ces 3 questions :

1. ✅ Cette tâche n'est dans les responsabilités d'AUCUN agent spécialiste ?
2. ✅ Cette tâche est simple (< 5 min) et ne nécessite aucune expertise spécifique ?
3. ✅ Cette tâche n'implique aucun mot-clé déclencheur ci-dessus ?

Si UNE SEULE réponse est NON → DÉLÉGUER à l'agent approprié.

### Exemples de Routage

| Demande Utilisateur | Mot-clé Détecté | Agent | Raison |
|---------------------|-----------------|-------|--------|
| "Démarre PostgreSQL" | PostgreSQL | DevOps | Infrastructure |
| "Lance les tests locaux" | Tests locaux | DevOps | Environnement |
| "Vérifie les vulnérabilités" | Vulnérabilités | Security | Audit |
| "Crée une spec pour Books" | Spec | Spécifications | MAIS vérifier plans existants AVANT |
| "Ajoute des tests pour Cards" | Tests | Testing | Tests |
```

**Validation** :
- Relire : déclencheurs clairs ?
- Test : "Démarre PostgreSQL" → Alfred détecte mot-clé et délègue ?

---

### Action 2 : Ajouter Rappel Agents Critiques dans CLAUDE.md Alfred

**Durée** : 10 min  
**Fichier** : `/CLAUDE.md`  
**Position** : Après ligne 5 (avant "Responsabilités")

**Contenu à ajouter** :

```markdown
## ⚠️ Agents Critiques (Délégation Obligatoire)

Ces agents DOIVENT être appelés systématiquement pour leurs domaines :

### 1. Agent DevOps
**Quand** : Infrastructure, PostgreSQL, Docker, Tests locaux, Ports, Environnement
**Pourquoi** : Procédures critiques (sg docker, ports, seeds)
**Comment** : `🤖 Alfred : Je fais appel à l'Agent DevOps pour [raison]`

### 2. Agent Security
**Quand** : Avant chaque commit majeur, audit, vulnérabilités
**Pourquoi** : Détection précoce des failles de sécurité
**Comment** : `🤖 Alfred : Je fais appel à l'Agent Security pour audit`

### 3. Agent Testing
**Quand** : Après toute implémentation, validation code
**Pourquoi** : Garantie qualité, TDD
**Comment** : `🤖 Alfred : Je fais appel à l'Agent Testing pour [raison]`

**Règle d'or** : En cas de doute, DÉLÉGUER plutôt qu'agir directement.
```

**Validation** :
- Visible immédiatement en haut de CLAUDE.md ?
- Rappel clair des 3 agents critiques ?

---

### Action 3 : Restructurer DevOps/CLAUDE.md (Règles Critiques en Haut)

**Durée** : 1h  
**Fichier** : `DevOps/CLAUDE.md`  
**Objectif** : Passer de 558 lignes à ~350 lignes, règles critiques au début

**Nouvelle structure** :

```markdown
# Agent DevOps - Collectoria

## Rôle
[Garder existant - lignes 1-5]

---

## ⚠️ RÈGLES CRITIQUES (à retenir absolument)

### 1. Docker TOUJOURS avec sg docker
**JAMAIS** : `sudo docker` ou `docker` seul
**TOUJOURS** : `sg docker -c "docker compose up -d"`
**Pourquoi** : Groupe docker non actif en session courante.

### 2. Seed de données via docker exec
**JAMAIS** : `psql` directement sur hôte (pas installé)
**TOUJOURS** : `sg docker -c "docker exec -i collectoria-collection-db psql ..."`

### 3. Vérifier ports Frontend Next.js
Next.js cherche automatiquement un port libre (3000 → 3001 → 3002).
**TOUJOURS** : Vérifier et indiquer le port réel après démarrage.

### 4. DevOps = Point d'entrée pour tests locaux
Quand Alfred ou un autre agent a besoin de tester localement :
→ **TOUJOURS** faire appel à DevOps.

---

## Responsabilités
[Garder section responsabilités - simplifiée]

## Documentation Détaillée

Pour procédures complètes, consulter :
- [Tests Locaux](testing-local.md) - Scripts, workflow, initialisation
- [Redémarrage](restart-procedures.md) - Procédures après config
- [Architecture](environment-setup.md) - Architecture cible

---

## Workflow Opérationnel
[Garder workflow - condensé]

## Template de Rapport
[Garder template rapport]

## Ports Standards
[Garder ports]

## Credentials de Développement
[Garder credentials]

## Problèmes Courants
[Garder solutions rapides]

## Interaction avec Autres Agents
[Garder section]

## Références Rapides
[Garder liens]
```

**Ce qui change** :
- Règles critiques passent de ligne 89 à ligne 8 (impossible à manquer)
- Structure plus claire et hiérarchique
- Procédures détaillées restent en référence
- Cible : ~350 lignes (gain de 200 lignes)

**Validation** :
- Règles critiques visibles immédiatement ?
- CLAUDE.md reste autonome (pas besoin de lire 3 autres fichiers) ?
- Taille < 400 lignes ?

---

### Action 4 : Corriger backend/QUICKSTART.md

**Durée** : 20 min  
**Fichier** : `backend/collection-management/QUICKSTART.md`  
**Lignes à modifier** : 183-190

**Remplacer** :

```markdown
### Port 5432 déjà utilisé
```bash
# Arrêter le PostgreSQL local
sudo systemctl stop postgresql

# Ou changer le port dans docker-compose.yml
ports:
  - "5433:5432"
```
```

**Par** :

```markdown
### Port 5432 déjà utilisé

**Option 1 : Arrêter PostgreSQL système (si installé)** :
```bash
sudo systemctl stop postgresql
```

**Option 2 (RECOMMANDÉ) : Utiliser Docker uniquement** :
```bash
# Vérifier qu'aucun container PostgreSQL ne tourne
sg docker -c "docker ps | grep postgres"

# Si container existe, le stopper
sg docker -c "docker stop collectoria-collection-db"

# Redémarrer proprement
sg docker -c "docker compose up -d"
```

**Option 3 : Changer le port dans docker-compose.yml** :
```yaml
ports:
  - "5433:5432"
```

**Note** : Pour gestion complète de l'environnement (tests locaux, multi-services), consulter l'Agent DevOps ou utiliser le Makefile à la racine.
```

**Ajouter note en haut** (après ligne 3) :

```markdown
> **Note** : Ce guide est pour démarrage rapide manuel. Pour gestion complète de l'environnement, consulter l'Agent DevOps ou utiliser le Makefile à la racine.
```

**Validation** :
- Option Docker recommandée ?
- Référence à DevOps ajoutée ?

---

## Tests de Validation (30 min)

### Test 1 : Délégation PostgreSQL

```
User: "Démarre PostgreSQL"
  ↓
Alfred: Détecte mot-clé "PostgreSQL"
  ↓
Alfred: "🤖 Alfred : Je fais appel à l'Agent DevOps pour démarrer PostgreSQL"
  ↓
DevOps: Utilise `sg docker -c "docker compose up -d"`
  ↓
DevOps: Retourne rapport avec ports
  ↓
✅ SUCCÈS si Alfred a délégué
❌ ÉCHEC si Alfred a agi directement
```

### Test 2 : Tests locaux

```
User: "Lance les tests locaux"
  ↓
Alfred: Détecte "tests locaux"
  ↓
Alfred: "🤖 Alfred : Je fais appel à l'Agent DevOps pour tests locaux"
  ↓
✅ SUCCÈS
```

### Test 3 : Création de spec

```
User: "Crée une spec pour collection Games"
  ↓
Alfred: Détecte "spec"
  ↓
Alfred: Vérifie plans existants : `find Specifications/ -iname "*game*"`
  ↓
Alfred: Vérifie tâches : `find "Project follow-up/tasks/" -iname "*game*"`
  ↓
Alfred: Si trouvé → demande confirmation utilisateur
  ↓
Alfred: "🤖 Alfred : Je fais appel à l'Agent Spécifications"
  ↓
✅ SUCCÈS
```

### Test 4 : Audit sécurité

```
User: "Vérifie la sécurité du JWT"
  ↓
Alfred: Détecte "sécurité"
  ↓
Alfred: "🤖 Alfred : Je fais appel à l'Agent Security pour audit JWT"
  ↓
✅ SUCCÈS
```

**Critères de succès** :
- ✅ 4/4 tests passent
- ✅ Aucun test où Alfred agit directement au lieu de déléguer

---

## Actions HAUTE Priorité (après tests, 1h)

### Action 5 : Audit Documentation Contradictoire

**Durée** : 20 min

```bash
# Chercher toutes mentions systemctl
grep -r "systemctl" ~/git/Collectoria --include="*.md"

# Chercher toutes mentions sudo docker
grep -r "sudo docker" ~/git/Collectoria --include="*.md"

# Vérifier chaque occurrence et corriger si nécessaire
```

**Résultat attendu** :
- systemctl : uniquement dans contextes appropriés (arrêt système local)
- sudo docker : 0 occurrence (remplacer par sg docker)

---

### Action 6 : Corriger Autres Fichiers

**Durée** : 30 min

Corriger toutes les mentions incorrectes trouvées à l'Action 5.

**Validation** :
```bash
# Aucune mention incorrecte
grep -r "systemctl" ~/git/Collectoria --include="*.md" | grep -v "stop postgresql"
grep -r "sudo docker" ~/git/Collectoria --include="*.md"
# → Résultat vide ou uniquement en exemple "ne pas faire"
```

---

### Action 7 : Note "Single Source of Truth"

**Durée** : 10 min  
**Fichier** : `DevOps/CLAUDE.md`

Ajouter à la fin :

```markdown
---

## Single Source of Truth

**Ce fichier (DevOps/CLAUDE.md) est la référence unique pour** :
- Règles opérationnelles (sg docker, docker exec, ports)
- Credentials de développement
- Ports standards
- Procédures critiques

**Autres fichiers doivent référencer ce document**, pas dupliquer l'information.

**En cas de contradiction** : DevOps/CLAUDE.md fait autorité.
```

---

## Résumé des Changements

| Fichier | Type de changement | Lignes ajoutées | Lignes supprimées |
|---------|-------------------|-----------------|-------------------|
| `/CLAUDE.md` (Alfred) | Ajout déclencheurs + agents critiques | ~100 | 0 |
| `DevOps/CLAUDE.md` | Restructuration (règles en haut) | ~350 | ~558 |
| `backend/collection-management/QUICKSTART.md` | Correction systemctl | ~20 | ~8 |
| Autres `.md` | Corrections contradictions | Variable | Variable |

**Net** : ~200 lignes de plus (guides Alfred) mais -200 lignes DevOps = équilibré

---

## Ordre d'Exécution Recommandé

1. **Action 1** : Déclencheurs automatiques Alfred (30 min) → TEST
2. **Action 2** : Agents critiques Alfred (10 min) → TEST
3. **Tests 1-4** : Validation délégation (30 min)
4. **Action 3** : Restructuration DevOps (1h) → TEST
5. **Action 4** : Correction QUICKSTART.md (20 min)
6. **Actions 5-7** : Audit + corrections documentation (1h)

**Total** : 3h30 (critical path : Actions 1-4 + Tests = 2h30)

---

## Critères de Succès

### CRITIQUE (obligatoire)
- ✅ 4/4 tests de délégation passent
- ✅ Déclencheurs automatiques en place dans CLAUDE.md Alfred
- ✅ Règles critiques DevOps en haut du fichier
- ✅ backend/QUICKSTART.md corrigé

### HAUTE (souhaitable)
- ✅ DevOps/CLAUDE.md < 400 lignes
- ✅ 0 mention "sudo docker" incorrecte
- ✅ Documentation cohérente

### MOYENNE (bonus)
- ✅ Guide de délégation créé (future Action 8)
- ✅ Automatisation détection (future Action 9)

---

## Après Implémentation

**Commit message suggéré** :

```
fix(agents): add automatic delegation triggers to prevent specialist bypass

- Add automatic delegation triggers in Alfred's CLAUDE.md
  - Keywords: PostgreSQL/Docker → DevOps
  - Keywords: Security/Audit → Security
  - Keywords: Spec → Specifications (with existing plans check)
  - Keywords: Tests → Testing
  
- Add pre-action checklist (3 questions before acting directly)

- Restructure DevOps/CLAUDE.md with critical rules at top
  - Move "sg docker" rule to line 8 (was line 89)
  - Reduce from 558 to ~350 lines
  - Keep detailed procedures as references
  
- Fix backend/QUICKSTART.md contradictory documentation
  - Replace "sudo systemctl" with Docker Compose recommendation
  - Add reference to DevOps agent
  
- Add "Critical Agents" reminder section in Alfred's CLAUDE.md

**Root cause**: Alfred was acting directly instead of delegating because
no automatic triggers existed. This led to:
- Using "sudo systemctl" instead of Docker (violates DevOps procedures)
- Creating complex specs without checking existing plans (wasted 2h)

**Impact**: 0 delegation misses expected after these changes.

**Reference**: Continuous-Improvement/reports/2026-04-23_audit-delegation-specialists.md

Co-Authored-By: Claude Opus 4.7 <noreply@anthropic.com>
```

---

**Prochain audit** : Commit #80 ou dans 5-7 jours
**Focus audit suivant** : Métriques de délégation (oublis détectés ?)

---

**Plan créé par** : Agent Amélioration Continue  
**Date** : 2026-04-23  
**Statut** : PRÊT POUR EXÉCUTION IMMÉDIATE
