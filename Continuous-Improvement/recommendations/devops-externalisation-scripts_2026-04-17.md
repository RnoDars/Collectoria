# Recommandation : Agent DevOps — Externalisation des Scripts Inline

**Date** : 2026-04-17
**Agent ciblé** : DevOps
**Priorité** : Haute
**Effort estimé** : 1-2 heures

---

## Problème Identifié

`DevOps/CLAUDE.md` contient **513 lignes** et dépasse le seuil d'alerte de 500 lignes.

L'analyse du contenu révèle que ~200 lignes (39% du fichier) sont du **code bash inline** : le script `scripts/test-local.sh` (~90L), le script `scripts/cleanup-local.sh` (~15L), le script `scripts/monitor-local.sh` (~25L), et le Makefile (~30L), plus des exemples de docker-compose YAML (~40L).

Ces scripts sont présentés comme "à créer" — ils ne sont pas encore de vrais fichiers dans le dépôt.

## Impact si Non Traité

- Contexte surchargé : l'agent charge 200 lignes de code qui ne sont pas des instructions
- Difficulté à trouver les vraies règles opérationnelles dans la masse
- Risque de divergence : les scripts dans CLAUDE.md peuvent devenir obsolètes sans être exécutés
- Croissance prévisible : chaque nouveau microservice ajoutera des sections similaires

## Solution Proposée

### Étape 1 : Créer les vrais fichiers scripts

Créer les fichiers référencés dans DevOps/CLAUDE.md :
```
scripts/
├── test-local.sh
├── cleanup-local.sh
└── monitor-local.sh
Makefile (racine)
docker-compose.test.yml (racine)
```

### Étape 2 : Remplacer le code inline par des références

Dans `DevOps/CLAUDE.md`, remplacer chaque bloc de code par une référence courte. Exemple :

**Avant (30+ lignes) :**
```markdown
#### Script Principal : `scripts/test-local.sh`
```bash
#!/bin/bash
# Script principal pour tester tous les services localement
# ... (80 lignes de bash) ...
```
```

**Après (5 lignes) :**
```markdown
#### Script Principal : `scripts/test-local.sh`
Lance les services locaux, applique les migrations, seed les données, teste les endpoints.
Usage : `./scripts/test-local.sh [service-name]` ou `make test-backend`
Voir le fichier pour les détails d'implémentation.
```

### Étape 3 : Conserver les règles opérationnelles essentielles

Les sections suivantes doivent **rester** dans CLAUDE.md car ce sont des règles de comportement pour l'agent, pas du code :
- "Docker sans sudo — utiliser `sg docker`" (règle critique)
- "Charger les données de seed via docker exec" (règle critique)
- Ports par défaut (référence rapide)
- Workflow DevOps pour Tests Locaux (logique de dispatch)

## Résultat Attendu

| Métrique | Avant | Après |
|---|---|---|
| Lignes CLAUDE.md | 513 | ~280-310 |
| Statut | ALERTE | OK |
| Scripts réels | 0 | 3-4 fichiers exécutables |

## Plan d'Action

1. Demander à Alfred de dispatcher vers DevOps pour créer les fichiers scripts
2. Une fois les scripts créés, l'Agent Amélioration Continue retravaille le CLAUDE.md pour supprimer le code inline
3. Vérifier que les scripts fonctionnent réellement avant de supprimer le code du CLAUDE.md
4. Committer les deux changements ensemble (scripts + CLAUDE.md allégé)

## Agents Impactés

- **DevOps** : Modification majeure du CLAUDE.md
- **Alfred** : Aucun changement nécessaire
- **Backend** : Les scripts doivent être cohérents avec la structure `backend/collection-management/`
