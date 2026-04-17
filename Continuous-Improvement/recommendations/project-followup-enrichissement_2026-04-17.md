# Recommandation : Enrichir l'Agent Project follow-up

**Date** : 2026-04-17
**Agent ciblé** : Project follow-up
**Priorité** : Haute
**Effort estimé** : 1 heure

---

## Problème Identifié

`Project follow-up/CLAUDE.md` ne contient que **26 lignes** — un squelette sans instructions opérationnelles réelles.

Pourtant, le répertoire compte **6 commits** (le plus actif proportionnellement des agents), ce qui indique une utilisation réelle. L'agent produit des documents de suivi sans avoir de guide sur comment les produire.

Anomalies spécifiques :
- La section "Agents spécialisés disponibles" dit "À compléter au fur et à mesure" — elle est restée vide
- Aucune description du format des rapports produits
- Aucune structure pour les sous-répertoires listés (`tasks/`, `decisions/`, `reports/`, `milestones/`)
- Aucun workflow : quand mettre à jour ? À quelle fréquence ? Quelle information y mettre ?

## Impact si Non Traité

- Documents de suivi incohérents d'un sprint à l'autre
- L'agent improvise le format à chaque utilisation
- Pas de standard pour les autres agents qui consultent le suivi
- Alfred ne peut pas coordonner efficacement sans un suivi structuré

## Solution Proposée

Enrichir `Project follow-up/CLAUDE.md` avec les sections suivantes :

### 1. Définition des sous-répertoires
- `tasks/` : fichiers de type `SPRINT-N.md` ou `tasks-YYYY-MM.md`
- `milestones/` : fichiers de type `milestone-N-nom.md` avec critères d'entrée/sortie
- `decisions/` : journal des décisions importantes (format ADR simplifié)
- `reports/` : rapports d'avancement horodatés

### 2. Format de rapport d'avancement standard
```markdown
# Rapport d'Avancement - [Date]

## Résumé
- Phase actuelle
- Complétion estimée

## Réalisé depuis le dernier rapport
- ...

## En cours
- ...

## Bloquants
- ...

## Prochaines étapes
- ...
```

### 3. Fréquence de mise à jour
- Rapport : à chaque milestone ou tous les 10 commits
- Tasks : en temps réel à chaque démarrage/fin de tâche
- Decisions : immédiatement lors d'une décision architecturale

### 4. Compléter la liste des agents spécialisés
La section "Agents spécialisés disponibles" devrait lister tous les agents avec leur domaine, pour que Project follow-up puisse coordonner correctement.

## Plan d'Action

1. Lire les fichiers existants dans `Project follow-up/` pour comprendre le format actuellement utilisé
2. Enrichir le CLAUDE.md en s'appuyant sur les pratiques déjà en place
3. Ne pas imposer un format radical — enrichir l'existant

## Agents Impactés

- **Project follow-up** : Modification du CLAUDE.md
- **Alfred** : Bénéficie d'un suivi plus structuré pour la coordination
- **Tous les agents** : Peuvent référencer les tâches de manière cohérente
