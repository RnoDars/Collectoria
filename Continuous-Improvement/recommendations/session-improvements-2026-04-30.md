# Session Improvements — 2026-04-30

## Contexte

Quatre améliorations ont été identifiées et appliquées à la suite de la session du 30 avril 2026. Elles ont été observées directement par l'utilisateur lors de cette session.

---

## Amélioration #1 — Persistance dans la documentation, jamais en mémoire Claude

**Problème observé** : Alfred sauvegardait des informations dans `~/.claude/` (mémoire Claude) au lieu de les persister dans le dépôt git.

**Fichier modifié** : `CLAUDE.md`

**Changements appliqués** :
- Ajout d'une section dédiée "Interdiction Absolue : Mémoire Claude" dans le bloc "❌ Ce qu'Alfred ne fait PAS", avant "Interdiction Formelle : Développement Direct"
- La section liste explicitement l'interdiction de créer/modifier tout fichier dans `~/.claude/` et impose que toute persistance passe par l'Agent Suivi de Projet → `STATUS.md` ou `Continuous-Improvement/recommendations/`
- Suppression de deux références à des fichiers `~/.claude/` existants dans le texte (`feedback_announce_subagents.md`, `feedback_backend_restart.md`) — remplacées par des références de session dans le texte

**Pourquoi** : La mémoire Claude est volatile, non versionnée et invisible pour l'équipe. Le dépôt git est la seule source de vérité durable.

---

## Amélioration #2 — Workflow de démarrage de session plus complet et automatique

**Problème observé** : Le workflow de démarrage ne se déclenchait que sur mots-clés explicites ("On commence", etc.) et ne incluait pas git pull ni la lecture de STATUS.md.

**Fichier modifié** : `CLAUDE.md`

**Changements appliqués** :
- Le **déclencheur est désormais automatique** — Alfred exécute ce workflow au début de TOUTE session, sans attendre de mot-clé
- Ajout de l'étape 1 : `git pull` sur le dépôt Collectoria avec signalement des changements distants
- Ajout de l'étape 2 : Lecture de `Project follow-up/STATUS.md` (état actuel, dernière session, prochaines priorités)
- Ajout de l'étape 3 : Présentation d'un résumé structuré à l'utilisateur ("Dernière session / État actuel / Prochaines priorités")
- Les étapes 4-8 reprennent le démarrage des environnements locaux existant, avec chemins corrigés (`/home/rno/git/`)
- Ajout de la référence à la session 2026-04-30 dans la note de référence

**Pourquoi** : Démarrer une session sans contexte ou sans synchronisation git provoque des confusions et des reprises manuelles inutiles.

---

## Amélioration #3 — Agent Amélioration Continue : déclencheurs systématiques

**Problème observé** : L'agent Amélioration Continue tournait rarement car ses déclencheurs étaient flous (uniquement mentionné dans "Bonnes Pratiques" sans obligation).

**Fichiers modifiés** : `CLAUDE.md` et `Continuous-Improvement/CLAUDE.md`

**Changements dans `CLAUDE.md`** :
- Ajout d'une section "Déclencheurs Automatiques : Agent Amélioration Continue" dans la section des déclencheurs automatiques
- Trois déclencheurs obligatoires définis :
  1. Fin de session (durée > 1h ou problèmes rencontrés) → mini-audit
  2. Tous les 10 commits sur main → audit complet (avec commande git de vérification)
  3. Dysfonctionnement de workflow détecté → audit immédiat

**Changements dans `Continuous-Improvement/CLAUDE.md`** :
- Ajout d'une section "Déclencheurs Automatiques" en tête du bloc "Processus d'Amélioration"
- Définition précise du **mini-audit de fin de session** : durée cible 5-10 min, maximum 1 recommandation, sortie attendue formalisée, règle explicite sur les audits sans résultat

**Pourquoi** : Un agent dont les déclencheurs sont vagues n'est jamais invoqué. Des conditions concrètes et mesurables garantissent l'invocation systématique.

---

## Amélioration #4 — Agent Testing : déclencheur automatique après implémentation

**Problème observé** : L'Agent Testing n'était jamais invoqué car ses déclencheurs étaient purement réactifs — l'utilisateur devait explicitement le demander.

**Fichiers modifiés** : `CLAUDE.md` et `Testing/CLAUDE.md`

**Changements dans `CLAUDE.md`** :
- Ajout d'une section "Déclencheurs Automatiques : Agent Testing" (immédiatement après les déclencheurs Amélioration Continue)
- Deux déclencheurs automatiques définis :
  1. Après chaque intervention de l'Agent Backend (handler, service, repository, migration)
  2. Après chaque intervention de l'Agent Frontend (composant, page, hook)
- Message type d'Alfred formalisé

**Changements dans `Testing/CLAUDE.md`** :
- Ajout d'une section complète "Test Minimal Obligatoire après Implémentation"
- Définition du contenu minimal attendu lors d'une invocation automatique :
  - Tests unitaires : cas nominal + cas d'erreur principal (Backend), 4 états + interaction (Frontend)
  - Exécution des tests existants (`go test ./...` / `npm test`) avec blocage commit si régression
- Format de rapport de test minimal formalisé
- Mise à jour de la section "Interaction avec autres agents" pour inclure Alfred

**Pourquoi** : Sans déclencheur automatique, les tests ne sont exécutés que sur demande explicite. Un déclencheur systématique après implémentation garantit la non-régression à chaque changement.

---

## Résumé des fichiers modifiés

| Fichier | Sections ajoutées / modifiées |
|---------|-------------------------------|
| `CLAUDE.md` | Nouvelle section "Interdiction Absolue : Mémoire Claude" ; workflow démarrage de session entièrement refondu (automatique + git pull + STATUS.md) ; section "Déclencheurs Automatiques : Agent Amélioration Continue" ; section "Déclencheurs Automatiques : Agent Testing" ; suppression de 2 références à `~/.claude/` |
| `Continuous-Improvement/CLAUDE.md` | Nouvelle section "Déclencheurs Automatiques" avec définition complète du mini-audit de fin de session |
| `Testing/CLAUDE.md` | Nouvelle section "Test Minimal Obligatoire après Implémentation" avec procédures backend/frontend, commandes, rapport type |
| `Continuous-Improvement/recommendations/session-improvements-2026-04-30.md` | Ce fichier |
