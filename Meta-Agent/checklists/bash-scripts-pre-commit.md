# Checklist Pré-Commit : Scripts Bash

**Usage** : Checklist OBLIGATOIRE avant tout commit de script Bash (`.sh`).

**Référence** : `Continuous-Improvement/recommendations/workflow-bash-scripts-testing_2026-05-05.md`

**Pourquoi** : Session 2026-05-05 — 10 commits de corrections pour un seul script non testé. Cette checklist évite 90% des erreurs détectées.

---

## ✅ Étape 1 : Validation Syntaxe

### 1.1 Linter shellcheck

```bash
shellcheck scripts/path/to/script.sh
```

**Attendu** : Aucune erreur, warnings acceptables si justifiés.

**Si shellcheck absent** : Installer avec `sudo apt install shellcheck` (Debian/Ubuntu) ou `brew install shellcheck` (macOS).

- [ ] shellcheck exécuté sans erreur

### 1.2 Bash -n (syntax check)

```bash
bash -n scripts/path/to/script.sh
```

**Attendu** : Aucune sortie (syntaxe valide).

- [ ] bash -n exécuté sans erreur

---

## ✅ Étape 2 : Validation Références

### 2.1 Services Docker Compose

**Si le script utilise des noms de services Docker Compose** (avec `docker compose -f ... <SERVICE_NAME>`) :

```bash
# Lister les services définis
grep -E "^  [a-z-]+:" docker-compose.prod.yml
```

**Vérifier que** :
- Les noms de services dans le script correspondent exactement aux noms dans docker-compose.prod.yml
- Exemples corrects : `backend-collection`, `frontend`, `postgres-collection`
- Exemples incorrects : `backend` (n'existe pas), `collectoria-backend` (c'est le container, pas le service)

- [ ] Noms de services validés contre docker-compose.prod.yml

### 2.2 Containers Docker

**Si le script utilise des noms de containers** (avec `docker exec`, `docker logs`, etc.) :

```bash
# En production, lister les containers actuels
docker ps --format "{{.Names}}"
```

**Vérifier que** :
- Les noms de containers dans le script correspondent aux noms réels
- Exemples corrects : `collectoria-backend-collection-prod`, `collectoria-frontend-prod`, `collectoria-collection-db-prod`
- Exemples incorrects : `collectoria-backend` (nom incomplet)

- [ ] Noms de containers validés contre environnement cible

### 2.3 Fonctions Appelées

**Si le script appelle des fonctions de `common.sh` ou `docker-utils.sh`** :

```bash
# Vérifier que la fonction existe
grep "^function_name()" scripts/lib/common.sh scripts/lib/docker-utils.sh
```

**Référence** : `scripts/lib/README.md` (documentation complète des fonctions disponibles).

**Vérifier que** :
- Toutes les fonctions appelées sont définies dans les libraries
- Les signatures (nombre/ordre paramètres) correspondent
- Exemple erreur : `check_service_health()` appelée mais non définie (session 2026-05-05)

- [ ] Toutes les fonctions appelées existent dans common.sh ou docker-utils.sh

### 2.4 Variables d'Environnement

**Si le script utilise des variables d'environnement** :

```bash
# Vérifier que les variables sont documentées ou ont des valeurs par défaut
grep 'export\|${.*:-' scripts/path/to/script.sh
```

**Vérifier que** :
- Toutes les variables ont des valeurs par défaut `${VAR:-default}`
- Ou sont documentées dans le header du script

- [ ] Variables d'environnement ont des valeurs par défaut ou sont documentées

---

## ✅ Étape 3 : Tests Locaux

### 3.1 Help / Usage

```bash
scripts/path/to/script.sh --help
```

**Attendu** : Affiche l'aide sans erreur.

- [ ] --help fonctionne correctement

### 3.2 Dry-Run (si disponible)

```bash
scripts/path/to/script.sh --dry-run
```

**Attendu** : Affiche les actions qui seraient effectuées sans les exécuter réellement.

- [ ] --dry-run fonctionne correctement

### 3.3 Cas Nominal Local

**Exécuter le script localement** dans un cas d'usage nominal (avec les bons paramètres).

**Si le script nécessite production** : Passer à l'étape 4 (tests production avec dry-run).

- [ ] Exécution locale réussie (si applicable)

### 3.4 Cas d'Erreur

**Tester au moins un cas d'erreur** :
- Fichier manquant
- Permission refusée
- Container inexistant
- Disque plein (simulation)

**Attendu** : Le script détecte l'erreur et affiche un message clair sans crasher.

- [ ] Gestion d'erreur validée

---

## ✅ Étape 4 : Tests Production (si applicable)

### 4.1 Dry-Run Production OBLIGATOIRE

```bash
# Sur le serveur de production
scripts/path/to/script.sh --dry-run
```

**RÈGLE CRITIQUE** : JAMAIS de première exécution production sans `--dry-run`.

**Attendu** :
- Affiche les actions prévues
- Valide que les noms services/containers/chemins sont corrects
- Aucune erreur

- [ ] Dry-run production exécuté sans erreur

### 4.2 Exécution Réelle (après validation dry-run)

```bash
scripts/path/to/script.sh
```

**Attendu** : Exécution réussie avec logs clairs.

- [ ] Exécution production réussie

---

## ✅ Étape 5 : Documentation

### 5.1 Header du Script

**Vérifier que le header contient** :
- Description claire du but du script
- Section Usage avec exemples
- Section Options avec description de chaque flag
- Section Environment pour les variables requises

```bash
# Exemple de header complet
#!/bin/bash
#
# script-name.sh - One-line description
#
# Description:
#   Detailed description of what the script does
#
# Usage:
#   ./script-name.sh [OPTIONS]
#
# Options:
#   --option1    Description of option1
#   --option2    Description of option2
#
# Examples:
#   ./script-name.sh --option1
#
# Environment:
#   VAR_NAME    Description (default: value)
```

- [ ] Header complet et clair

### 5.2 Commentaires Internes

**Vérifier que** :
- Les sections principales ont des commentaires `# Step 1: Description`
- Les parties complexes sont expliquées
- Pas de commentaires inutiles (éviter le bruit)

- [ ] Commentaires appropriés

---

## ✅ Étape 6 : Commit Message

### 6.1 Format Convention

```
<type>(scope): short description

Long description explaining:
- What changed
- Why this change was needed
- Any breaking changes or important notes

Co-Authored-By: Claude Sonnet 4.5 <noreply@anthropic.com>
```

**Types** : `feat`, `fix`, `refactor`, `docs`, `test`, `chore`

**Scopes** : `deploy`, `database`, `maintenance`, `infrastructure`

- [ ] Commit message suit la convention

---

## ✅ Étape 7 : Review Finale

### 7.1 Lecture du Diff

```bash
git diff scripts/path/to/script.sh
```

**Vérifier** :
- Pas de debug `echo` oublié
- Pas de TODO non résolu
- Pas de credentials hardcodés
- Pas de chemins absolus spécifiques à une machine

- [ ] Diff reviewed manuellement

### 7.2 Agent Code Review (si disponible)

```bash
# Une fois Agent Code Review implémenté
./scripts/review/review-bash-script.sh scripts/path/to/script.sh
```

**Attendu** : Rapport APPROVED ou WARNINGS (pas REJECTED).

- [ ] Agent Code Review exécuté (si disponible)

---

## ✅ Étape 8 : Commit et Push

### 8.1 Commit

```bash
git add scripts/path/to/script.sh
git commit -m "feat(deploy): add backend deployment script

Implements automated backend deployment with health checks,
rollback on failure, and image cleanup.

Co-Authored-By: Claude Sonnet 4.5 <noreply@anthropic.com>"
```

- [ ] Commit créé avec message clair

### 8.2 Push

```bash
git push origin main
```

- [ ] Push réussi

---

## 📊 Métriques

**Temps estimé par checklist** : 5-10 minutes

**Temps économisé en debug** : 30-60 minutes

**Taux de commits corrections évités** : ~90%

---

## 🚨 Cas d'Exception

**Si urgence production** :
- Minimum obligatoire : Étapes 1, 2, 4.1, 8
- Créer une issue pour compléter les tests après déploiement

**Si script trivial (<20 lignes, aucune référence externe)** :
- Minimum obligatoire : Étapes 1, 3.1, 5, 8

---

## Références

- **Workflow complet** : `Continuous-Improvement/recommendations/workflow-bash-scripts-testing_2026-05-05.md`
- **Lesson learned** : `Continuous-Improvement/lessons/bash-scripts-are-code.md`
- **Lesson dry-run** : `Continuous-Improvement/lessons/dry-run-mandatory-production.md`
- **API Reference** : `scripts/lib/README.md`
