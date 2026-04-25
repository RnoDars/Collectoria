# Audit Session — 2026-04-25

**Produit par** : Agent Amélioration Continue  
**Date** : 2026-04-25  
**Contexte** : Analyse post-session de 4 incidents remontés par l'utilisateur

---

## Score Système

| Dimension | Avant | Après | Delta |
|-----------|-------|-------|-------|
| Couverture migrations (documentation) | 4/9 migrations documentées | 9/9 | +5 |
| Règle délégation specs (Alfred) | Implicite, non enforced | Explicite + checklist +1 item | +1 |
| Redémarrage backend post-implémentation | Règle mémoire externe non appliquée | Workflow automatique intégré dans CLAUDE.md | +1 |
| Cohérence données BDD / feature visible | Partielle (385/1679 noms FR corrigés) | Complète (1679 depuis migration 009) | +1 |
| **Score global (estimation)** | **6/10** | **8.5/10** | **+2.5** |

---

## Incident 1 — Migrations manquantes au démarrage

### Description
Au `docker compose up -d`, PostgreSQL est recréé à zéro. Alfred a appliqué les migrations 001-004 (les seules documentées dans `DevOps/testing-local.md`) mais pas 005-009. La table `books` était absente, la page /books était non fonctionnelle.

### Cause Racine
`DevOps/testing-local.md` — source de vérité pour l'initialisation d'une nouvelle machine — n'avait pas été mis à jour lors de l'ajout des migrations 005 à 009. Absence de règle obligeant la mise à jour de ce fichier à chaque nouvelle migration.

`DevOps/CLAUDE.md` indiquait également "Migrations : 4 fichiers SQL (001 à 004)" dans la section Architecture Actuelle.

### Impact
- Environnement non fonctionnel après recréation du container
- Blocage total sur les features impliquant des tables créées par les migrations 005+
- Temps de diagnostic perdu (symptôme indirect : page cassée)

### Fréquence Probable
Haute — ce problème se reproduira à chaque recréation du container (crash Docker, nouvelle machine, CI) si la documentation n'est pas maintenue synchronisée.

### Corrections Apportées
1. **`DevOps/testing-local.md`** : Déjà mis à jour (9 migrations documentées) — correction partielle faite en session.
2. **`DevOps/CLAUDE.md`** :
   - Section "Initialisation Nouvelle Machine" : suppression de la référence au chiffre "4 migrations" remplacée par "TOUTES les migrations (voir testing-local.md)".
   - Nouvelle règle ajoutée : "⚠️ Règle : Mise à Jour de testing-local.md à Chaque Nouvelle Migration" avec commande de vérification rapide (`wc -l` migrations réelles vs documentées).
   - Section "Architecture Actuelle / Données" : mise à jour de "4 fichiers SQL (001 à 004)" → "9 fichiers SQL (001 à 009)".

### Recommandations Résiduelles
- **Automatisation possible** : Ajouter un hook Git post-commit qui vérifie que le nombre de migrations dans `testing-local.md` correspond au nombre de fichiers `.sql` dans `migrations/` et avertit si désynchronisé.
- **Responsabilité** : L'Agent Backend qui crée une migration DOIT mettre à jour `testing-local.md` dans le même commit.

---

## Incident 2 — Alfred a rédigé la spec directement

### Description
L'utilisateur a demandé une spec pour le tri alphabétique. Alfred a rédigé lui-même `Specifications/cards-sort-feature-v1.md` au lieu de déléguer à l'Agent Spécifications. Corrigé seulement sur question explicite de l'utilisateur.

### Cause Racine
La règle de délégation pour les specs existait dans `CLAUDE.md` (section Dispatch Intelligent) mais elle était implicite : "Spécifications → Agent Spécifications". Aucune interdiction explicite rédigée pour Alfred, aucun item dédié dans la Checklist Pré-Action.

Alfred a rationalisé une action directe ("c'est une spec simple, je peux le faire") sans appliquer la règle de délégation systématique.

### Impact
- Confusion des responsabilités
- Spec produite sans la rigueur DDD de l'Agent Spécifications (format, critères d'acceptation, bounded context)
- Mauvaise traçabilité (qui a créé la spec ? avec quel processus ?)

### Fréquence Probable
Moyenne — tendance d'Alfred à agir directement sur des tâches perçues comme "simples" alors qu'elles relèvent d'un agent spécialiste.

### Corrections Apportées
**`CLAUDE.md` (Alfred)** :
1. Section "Mots-clés Spécifications" : ajout d'un avertissement explicite `⚠️ INTERDIT : Alfred ne rédige JAMAIS une spec directement. Même pour une feature "simple".` avec référence à l'incident.
2. Section "Checklist Pré-Action" : ajout d'un 5e critère `✅ Cette tâche n'est PAS la rédaction d'une spécification ?` — si NON → déléguer à l'Agent Spécifications.
3. Section "Rappels critiques" enrichie : `Alfred ne rédige JAMAIS une spec directement. Même "juste un brouillon". Toujours → Agent Spécifications.`

---

## Incident 3 — Backend non redémarré après implémentation

### Description
Après l'implémentation du tri alphabétique par l'Agent Backend, Alfred n'a pas redémarré le processus Go. Les tests montraient que le tri ne fonctionnait pas — alors que le code était correct. La confusion a duré jusqu'à ce que le redémarrage soit effectué manuellement.

### Cause Racine
La règle existait dans la mémoire utilisateur (`feedback_backend_restart.md`) mais n'était pas intégrée dans les workflows automatiques de `CLAUDE.md`. Les règles stockées dans des fichiers mémoire externes sont moins fiables que celles intégrées dans le contexte de l'agent.

Il manquait un **déclencheur automatique** lié à la fin d'une intervention de l'Agent Backend.

### Impact
- Perte de temps significative (tests confus, debugging inutile)
- Risque de fausse conclusion ("le code ne fonctionne pas") alors que le problème était l'environnement

### Fréquence Probable
Haute — ce pattern se reproduit systématiquement quand le backend est modifié sans redémarrage. La règle mémoire avait déjà été créée suite à un incident similaire, preuve de récurrence.

### Corrections Apportées
**`CLAUDE.md` (Alfred)** : Ajout du workflow "2. Redémarrage Backend Après Implémentation" avec :
- Déclencheurs obligatoires listés (fin d'implémentation Backend, modification Go, migration appliquée)
- Procédure complète (kill, relaunch, health check)
- Règle d'or explicite : `Ne JAMAIS tester une implémentation Backend sans avoir redémarré le backend après les changements.`
- Référence croisée avec `feedback_backend_restart.md`

### Recommandations Résiduelles
- La règle mémoire `feedback_backend_restart.md` peut être conservée comme backup mais la source de vérité est désormais `CLAUDE.md`.

---

## Incident 4 — Données base de données incomplètes (migration 009)

### Description
La migration 008 ne couvrait que les 385 cartes marquées `has_issue=YES` dans le CSV source. Environ 1000 cartes avaient un `new_name_fr` renseigné dans le CSV mais n'avaient jamais été mises à jour en base. Résultat : le tri FR donnait un résultat quasi-identique au tri EN car la majorité des `name_fr` étaient null ou identiques à `name_en`.

### Cause Racine
La migration 008 a été créée avec un scope partiel (uniquement les cartes problématiques) sans vérifier l'exhaustivité des données disponibles dans le CSV. L'Agent Backend / l'utilisateur n'avait pas audité l'ensemble du CSV avant de créer la migration.

Ce n'est pas un défaut du système d'agents mais une lacune dans le processus de validation des données avant migration.

### Impact
- Feature de tri FR invisible à l'utilisateur (résultat identique au tri EN)
- Migration 009 nécessaire pour corriger les 1679 cartes depuis le CSV complet
- Temps de développement gaspillé (feature implémentée mais non perceptible)

### Fréquence Probable
Faible en routine, mais risque lors de toute migration basée sur un CSV partiel.

### Corrections Apportées
Aucune correction système — l'incident a été résolu par la migration 009 en session. Il relève davantage d'une bonne pratique de préparation des données que d'une règle d'agent.

### Recommandations Résiduelles
- Avant toute migration de données depuis un CSV : vérifier la couverture totale des lignes avec `new_value IS NOT NULL`.
- Envisager d'ajouter cette vérification dans le CLAUDE.md de l'Agent Backend comme check pré-migration.

---

## Corrections Apportées — Récapitulatif

| Fichier | Modification | Incident Traité |
|---------|-------------|-----------------|
| `DevOps/CLAUDE.md` | Suppression référence "4 migrations", mise à jour "9 migrations", ajout règle obligatoire de mise à jour testing-local.md | #1 |
| `DevOps/testing-local.md` | Déjà corrigé en session (migrations 005-009 ajoutées) | #1 |
| `CLAUDE.md` (Alfred) | Interdiction explicite de rédiger une spec directement dans section déclencheurs + checklist item #5 | #2 |
| `CLAUDE.md` (Alfred) | Nouveau workflow "2. Redémarrage Backend Après Implémentation" avec procédure complète | #3 |

---

## Recommandations Résiduelles Prioritaires

### Priorité Haute

**R1 — Hook Git pour synchronisation migrations/documentation**
- Ajouter un script (hook post-commit ou pre-push) qui compare le nombre de fichiers `migrations/*.sql` avec le nombre de lignes `< migrations/` dans `testing-local.md` et affiche un warning si désynchronisé.
- Responsable : Agent DevOps
- Effort : ~30 minutes

**R2 — Règle pré-migration dans Backend/CLAUDE.md**
- Ajouter une checklist pré-migration de données depuis CSV : vérifier la couverture (`COUNT(*) WHERE new_value IS NOT NULL`), documenter le scope dans le nom de la migration.
- Responsable : Agent Amélioration Continue → Agent Backend
- Effort : ~15 minutes

### Priorité Moyenne

**R3 — Test de cohérence base de données au démarrage**
- Dans le workflow de démarrage de session (Alfred), ajouter une vérification rapide : compter le nombre de migrations appliquées vs le nombre de fichiers SQL disponibles.
- Cela permettrait de détecter une base incomplète dès le début de session.
- Responsable : Alfred / Agent DevOps
- Effort : ~45 minutes

---

*Rapport produit par l'Agent Amélioration Continue — 2026-04-25*
