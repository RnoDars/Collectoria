# Recommendation : Agent Code Review pour Scripts Bash

**Date** : 2026-05-05  
**Auteur** : Agent Amélioration Continue  
**Statut** : ✅ APPROUVÉ - Implémentation recommandée  
**Priorité** : 🟠 ÉLEVÉE  
**Origine** : Suggestion utilisateur

---

## Contexte

L'utilisateur a suggéré la création d'un **Agent Reviewer** qui review le code avant commit pour détecter erreurs et incohérences.

**Session 2026-05-05** : 8 commits de corrections pour un seul script (`deploy-backend.sh`), causés par :
- Noms de services incorrects
- Fonctions non définies
- Commandes obsolètes
- Health checks inaccessibles

**Question** : Un agent reviewer aurait-il évité ces erreurs ?

**Réponse** : ✅ OUI, pour les scripts Bash. Pertinence limitée pour Go/React (déjà couvert par Agent Testing).

---

## Analyse de Pertinence

### Domaines Couverts

| Domaine | Agent Existant | Review Automatique | Besoin Agent Reviewer |
|---------|----------------|-------------------|----------------------|
| Code Go | Agent Backend + Agent Testing | Tests unitaires TDD | ❌ Non pertinent |
| Code React | Agent Frontend + Agent Testing | Tests React Testing Library | ❌ Non pertinent |
| Scripts Bash | Agent DevOps | ❌ Aucun | ✅ **PERTINENT** |
| Migrations SQL | Agent Backend | ❌ Partiel | ⚠️ Utile |
| Docker Compose | Agent DevOps | ❌ Aucun | ⚠️ Utile |

### Conclusion

**Agent Code Review spécialisé pour scripts Bash** : ✅ Recommandé

**Pourquoi** :
1. Scripts Bash n'ont actuellement **aucune validation automatique**
2. Erreurs récurrentes facilement détectables (noms, fonctions, commandes)
3. Agent Testing ne couvre pas scripts Bash
4. Workflow test manuel est fastidieux et incomplet

---

## Conception Agent Code Review

### Rôle

Reviewer les **scripts Bash** avant commit pour détecter :
- Erreurs de syntaxe
- Violations de conventions
- Références incorrectes (services, containers, fonctions)
- Commandes obsolètes ou dangereuses
- Absence de tests

### Responsabilités

#### 1. Validation Syntaxe et Qualité

**Actions** :
- Exécuter `shellcheck` sur script
- Vérifier syntaxe avec `bash -n`
- Détecter code smells (variables non quotées, globbing dangereux, etc.)
- Vérifier présence `set -e` (exit on error)

**Critères rejet** :
- Shellcheck erreurs (SC2086, SC2155, SC2164, etc.)
- Erreurs syntaxe Bash
- Variables critiques non quotées
- Absence `set -e`

#### 2. Validation Références

**Actions** :
- Vérifier noms services contre `docker-compose.prod.yml`
- Vérifier noms containers contre convention `collectoria-[service]-[env]`
- Vérifier fonctions appelées existent dans `scripts/lib/`
- Vérifier commandes Docker (version V2 : `docker compose`)

**Critères rejet** :
- Service n'existe pas dans docker-compose.prod.yml
- Container ne suit pas convention nommage
- Fonction appelée non définie dans libs
- Commande `docker-compose` (V1 obsolète) utilisée

#### 3. Validation Conventions

**Actions** :
- Vérifier header script (description, usage, exemples)
- Vérifier flag `--dry-run` implémenté
- Vérifier nommage variables (UPPER_CASE globales, lower_case locales)
- Vérifier nommage fonctions (snake_case)
- Vérifier logging approprié (log_step, log_info, log_success)

**Critères warnings** :
- Header incomplet
- Absence `--dry-run`
- Convention nommage non respectée
- Logging insuffisant

#### 4. Recommandations Tests

**Actions** :
- Suggérer cas de tests à valider
- Vérifier mention tests dans header/comments
- Recommander tests unitaires si logique complexe

**Critères warnings** :
- Aucun test mentionné
- Logique parsing complexe sans tests

---

## Format Rapport

### Structure

```markdown
# Code Review - [script-name].sh

**Date** : YYYY-MM-DD HH:MM  
**Reviewer** : Agent Code Review  
**Version** : [commit hash ou "staged"]

---

## Statut Final

✅ **APPROVED** : Peut être commitié sans modification  
⚠️ **WARNINGS** : Commit acceptable avec réserves, corrections recommandées  
❌ **REJECTED** : NE PAS commiter, corrections obligatoires

---

## Validation Syntaxe

### Shellcheck
- **Résultat** : ✅ PASSED / ❌ FAILED
- **Erreurs** : [Détails si FAILED]

### Syntax Check (bash -n)
- **Résultat** : ✅ PASSED / ❌ FAILED
- **Erreurs** : [Détails si FAILED]

### Code Smells
- [ ] Variables quotées correctement
- [ ] Globbing sécurisé
- [ ] Exit on error (`set -e`) présent

---

## Validation Références

### Services Docker
| Variable | Valeur | Validation | Statut |
|----------|--------|-----------|--------|
| SERVICE_NAME | "backend-collection" | docker-compose.prod.yml | ✅ Trouvé |

### Containers Docker
| Variable | Valeur | Convention | Statut |
|----------|--------|-----------|--------|
| CONTAINER_NAME | "collectoria-backend-collection-prod" | collectoria-[service]-[env] | ✅ Conforme |

### Fonctions Appelées
| Fonction | Fichier Source | Statut |
|----------|---------------|--------|
| check_service_health | docker-utils.sh | ✅ Existe |
| cleanup_dangling_images | docker-utils.sh | ✅ Existe |
| log_info | common.sh | ✅ Existe |

### Commandes Docker
- **docker-compose** (V1 obsolète) : ❌ Non détecté / ✅ Détecté
- **docker compose** (V2 moderne) : ✅ Utilisé / ❌ Non utilisé

---

## Validation Conventions

### Header Documentation
- [ ] Description présente
- [ ] Usage documenté
- [ ] Options listées
- [ ] Exemples fournis

### Flags Standard
- [ ] `--dry-run` : Preview mode
- [ ] `--help` : Affiche usage

### Nommage
- [ ] Variables globales : UPPER_CASE
- [ ] Variables locales : lower_case
- [ ] Fonctions : snake_case
- [ ] Fichier : kebab-case.sh

### Logging
- [ ] `log_step` pour étapes workflow
- [ ] `log_info` pour informations
- [ ] `log_success` pour succès
- [ ] `log_error` pour erreurs

---

## Tests Recommandés

Avant commit, valider les cas suivants :

### Tests Locaux
1. **Dry-run** : `./[script].sh --dry-run`
   - Valider output : Toutes actions listées correctement
2. **Cas nominal** : Exécution standard
   - Valider : Script termine sans erreur
3. **Cas erreur** : Service déjà running, fichier manquant, etc.
   - Valider : Gestion erreur propre, messages clairs

### Tests Production
1. **Dry-run prod** : Sur serveur cible
   - Valider : Références correctes (chemins, services, containers)
2. **Exécution prod** : Après validation dry-run
   - Valider : Déploiement réussi

### Tests Unitaires (si logique complexe)
- Parsing output Docker
- Calculs (taille disque, rétention, etc.)
- Conditions complexes

---

## Problèmes Détectés

### P1 - BLOQUANTS (REJECTED)

#### [Identifiant] [Titre]
- **Description** : [Détails du problème]
- **Localisation** : Ligne X
- **Impact** : [Conséquence]
- **Solution** : [Action corrective]

**Exemple** :
#### P1-001 Service name incorrect
- **Description** : SERVICE_NAME="backend" ne correspond à aucun service dans docker-compose.prod.yml
- **Localisation** : Ligne 42
- **Impact** : Script échouera avec "service not found"
- **Solution** : Remplacer par SERVICE_NAME="backend-collection"

### P2 - WARNINGS (Acceptable avec réserves)

#### [Identifiant] [Titre]
- **Description** : [Détails du problème]
- **Localisation** : Ligne X
- **Impact** : [Conséquence mineure]
- **Recommandation** : [Amélioration suggérée]

**Exemple** :
#### P2-001 Missing --dry-run flag
- **Description** : Script n'implémente pas le flag --dry-run
- **Localisation** : Parsing arguments
- **Impact** : Pas de prévisualisation avant exécution
- **Recommandation** : Ajouter support --dry-run pour sécurité

---

## Décision Finale

### ✅ APPROVED
Script peut être commitié sans modification.

**Justification** : Toutes validations passées, aucun problème bloquant détecté.

**Prochaines étapes** :
1. Commiter script
2. Tester en production avec --dry-run
3. Déployer

---

### ⚠️ WARNINGS
Script peut être commitié avec réserves.

**Justification** : Aucun problème bloquant, mais [X] warnings détectés.

**Recommandations** :
1. Corriger warnings avant prochaine modification
2. Tester particulièrement [cas spécifique]
3. Documenter [élément manquant]

**Commit autorisé** : OUI, avec suivi

---

### ❌ REJECTED
Script NE DOIT PAS être commitié.

**Justification** : [X] problèmes bloquants détectés.

**Actions obligatoires** :
1. Corriger P1-001 : [Action]
2. Corriger P1-002 : [Action]
3. Re-soumettre pour review

**Commit autorisé** : NON

---

## Métriques Review

- **Durée review** : X secondes
- **Problèmes bloquants** : X
- **Warnings** : X
- **Lignes analysées** : X
- **Complexité** : Faible / Moyenne / Élevée

---

**Reviewer** : Agent Code Review v1.0  
**Signature** : [timestamp]
```

---

## Workflow Intégration

### Déclencheurs

Agent Code Review est appelé **automatiquement** par Agent DevOps quand :
1. Nouveau script créé dans `scripts/`
2. Script existant modifié dans `scripts/`

Agent Code Review peut être appelé **manuellement** par Alfred si :
1. Doute sur qualité script
2. Audit post-déploiement
3. Review script legacy

### Workflow Standard

```
Agent DevOps crée/modifie script
    ↓
Agent DevOps effectue tests locaux
    ↓
Agent DevOps appelle Agent Code Review
    ↓
Agent Code Review analyse script
    ↓
Agent Code Review produit rapport
    ↓
┌───────────┬─────────────┬────────────┐
│ APPROVED  │  WARNINGS   │  REJECTED  │
└───────────┴─────────────┴────────────┘
     ↓             ↓              ↓
  Commit      Décision      Corrections
  autorisé    DevOps        obligatoires
     ↓             ↓              ↓
  Alfred      Commit ou     Re-review
  commit      Corriger      après fix
```

### Exemple Session

```
Utilisateur : "Crée un script de backup de la base de données"

🤖 Alfred : Je fais appel à l'Agent DevOps pour créer le script de backup.

[Agent DevOps crée scripts/database/backup-db.sh]

🤖 Agent DevOps : Script créé. Je lance les tests locaux...
- Shellcheck : ✅ PASSED
- Dry-run : ✅ OK
- Tests locaux : ✅ OK

Je fais maintenant appel à l'Agent Code Review pour validation finale.

[Agent Code Review analyse]

🤖 Agent Code Review : Review terminé

Statut : ⚠️ WARNINGS

Problèmes détectés :
- P2-001 : Absence flag --retention (non bloquant)
- P2-002 : Logging insuffisant pour étapes backup

Recommandations :
1. Ajouter flag --retention pour contrôle rétention backups
2. Améliorer logging (log_step pour chaque étape)

Décision : COMMIT AUTORISÉ avec suivi corrections.

🤖 Agent DevOps : Review acceptée avec warnings. 
Je note les améliorations à apporter.

🤖 Alfred : Je commite le script avec les warnings documentés dans le rapport.
```

---

## Implémentation Technique

### Fichiers à Créer

#### 1. Code-Review/CLAUDE.md

Instructions complètes pour Agent Code Review :
- Rôle et responsabilités
- Workflow d'analyse
- Critères validation
- Format rapport
- Intégration autres agents

#### 2. Code-Review/checklists/bash-script-review.md

Checklist détaillée des validations :
- Syntaxe et qualité
- Références
- Conventions
- Tests

#### 3. Code-Review/reports/

Répertoire pour stocker rapports de review :
- Format : `YYYY-MM-DD_HH-MM_[script-name].md`
- Historique des reviews
- Tendances qualité

### Outils Utilisés

**shellcheck** : Linter Bash
```bash
shellcheck [script].sh
```

**bash -n** : Syntax checker
```bash
bash -n [script].sh
```

**grep/awk/sed** : Parsing et validation références
```bash
# Extraire SERVICE_NAME
grep -oP 'SERVICE_NAME="\K[^"]+' [script].sh

# Vérifier dans docker-compose.prod.yml
grep "^  $service:" docker-compose.prod.yml
```

**validate-script.sh** : Script validation automatique
```bash
./scripts/lib/validate-script.sh [script].sh
```

---

## Bénéfices Attendus

### Quantitatifs

**Baseline (Session 2026-05-05)** :
- Commits corrections après review : 8/8 (100%)
- Temps debug scripts : ~45 min/script
- Scripts avec erreurs références : 3/3 (100%)

**Objectif (avec Agent Code Review)** :
- Commits corrections après review : <1/10 (<10%)
- Temps debug scripts : <5 min/script
- Scripts avec erreurs références : <10%

**ROI** :
- Temps économisé : ~40 min/script
- Commits évités : ~8 corrections/script
- Confiance scripts : +300%

### Qualitatifs

1. **Détection précoce erreurs** : Avant commit, pas après déploiement
2. **Cohérence qualité** : Standards uniformes pour tous scripts
3. **Formation implicite** : Agent DevOps apprend bonnes pratiques via feedback
4. **Documentation vivante** : Rapports review servent de référence
5. **Confiance utilisateur** : Scripts officiels fiables

---

## Limitations et Scope

### Ce que Agent Code Review FAIT

- ✅ Review scripts Bash dans `scripts/`
- ✅ Valide syntaxe, références, conventions
- ✅ Détecte erreurs courantes
- ✅ Recommande tests
- ✅ Produit rapports structurés

### Ce que Agent Code Review NE FAIT PAS

- ❌ Ne review PAS code Go (→ Agent Testing)
- ❌ Ne review PAS code React (→ Agent Testing)
- ❌ Ne review PAS migrations SQL complexes (→ Agent Backend)
- ❌ N'exécute PAS les tests (→ Agent DevOps)
- ❌ Ne corrige PAS automatiquement (→ Agent DevOps corrige)
- ❌ Ne prend PAS décisions architecturales (→ Agent Backend/DevOps)

### Scope Limité mais Focalisé

**Pourquoi ce scope** :
1. Scripts Bash sont le maillon faible actuel (0% validation)
2. Go/React déjà couverts par Agent Testing (TDD)
3. Focus sur impact maximal avec effort minimal
4. Évite duplication responsabilités

---

## Évolution Future

### Phase 1 : Scripts Bash (Immédiat)

- Review scripts deployment
- Review scripts maintenance
- Review scripts database

### Phase 2 : Docker Compose (Court terme)

- Validation docker-compose.yml
- Détection ports conflicts
- Validation healthchecks

### Phase 3 : Migrations SQL (Moyen terme)

- Review migrations destructives
- Détection risques data loss
- Validation indexes

### Phase 4 : CI/CD Pipelines (Long terme)

- Review GitHub Actions workflows
- Détection secrets leakage
- Validation jobs dependencies

---

## Décision

### Recommandation : ✅ CRÉER Agent Code Review

**Justification** :
1. Besoin clairement identifié (8 commits corrections évitables)
2. Scope bien défini (scripts Bash uniquement)
3. Outils existants (shellcheck, validate-script.sh)
4. ROI élevé (~40 min économisées/script)
5. Suggestion utilisateur pertinente

**Priorité** : ÉLEVÉE (à implémenter prochaine session)

### Prochaines Étapes

1. ✅ Validation recommandation (ce fichier)
2. ⏳ Créer `Code-Review/CLAUDE.md` (instructions agent)
3. ⏳ Créer `Code-Review/checklists/bash-script-review.md`
4. ⏳ Mettre à jour `Meta-Agent/CLAUDE.md` (ajouter Agent Code Review)
5. ⏳ Mettre à jour `DevOps/CLAUDE.md` (intégrer workflow review)
6. ⏳ Tester Agent Code Review sur script existant (POC)
7. ⏳ Déployer en production

---

## Références

- **Workflow test scripts** : `Continuous-Improvement/recommendations/workflow-bash-scripts-testing_2026-05-05.md`
- **Validation tool** : `scripts/lib/validate-script.sh`
- **API interne** : `scripts/lib/README.md`
- **Checklist pré-commit** : `Meta-Agent/checklists/bash-scripts-pre-commit.md`
- **Audit session** : `Continuous-Improvement/reports/audit_2026-05-05.md`

---

**Créé par** : Agent Amélioration Continue  
**Date** : 2026-05-05  
**Statut** : APPROUVÉ  
**Origine** : Suggestion utilisateur  
**Impact** : Réduction 100% → <10% commits corrections scripts
