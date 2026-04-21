# Workflow de Synchronisation du STATUS.md

**Date de création** : 2026-04-21  
**Objectif** : Maintenir le STATUS.md synchronisé avec l'avancement réel du projet

---

## Pourquoi ce workflow ?

Le STATUS.md est le document central de suivi du projet. Il doit refléter fidèlement :
- Les tâches complétées
- Les métriques actuelles (nombre de cartes, endpoints, tests, etc.)
- L'état actuel de chaque composant (backend, frontend, DevOps)
- Les prochaines priorités

Un STATUS.md obsolète crée de la confusion et nuit à la productivité.

---

## QUAND mettre à jour le STATUS.md

### Déclencheurs Automatiques

1. **Après chaque tâche majeure complétée** :
   - Implémentation d'un nouveau microservice ou endpoint
   - Import de nouvelles données (ex: vraies cartes MECCG)
   - Complétion d'une phase (ex: "Phase 1 Backend COMPLÈTE")
   - Création de nouveaux composants frontend
   - Mise en place d'infrastructure (Docker, CI/CD)
   - Ajout de nouveaux agents ou workflows

2. **En fin de session de travail** :
   - Si la session a duré >2 heures
   - Si plusieurs tâches ont été complétées
   - Si des décisions architecturales ont été prises

3. **Lors de changements de direction** :
   - Changement de priorités
   - Abandon d'une approche au profit d'une autre
   - Ajout de nouvelles fonctionnalités au MVP

### Déclencheurs sur Demande

- L'utilisateur demande explicitement "mets à jour le STATUS"
- Avant une présentation du projet à un tiers
- Avant une pause longue (>1 semaine)

---

## QUI est responsable

### Rôle d'Alfred (Agent de Dispatch Principal)

**Alfred** est responsable de :
1. **Détecter** les moments où le STATUS.md doit être mis à jour (voir déclencheurs ci-dessus)
2. **Solliciter** l'Agent Suivi de Projet pour effectuer la mise à jour
3. **Annoncer** la mise à jour à l'utilisateur

**Exemple de message d'Alfred** :
```
🤖 Alfred : La Phase 2 du Backend vient d'être complétée. 
Je fais appel à l'Agent Suivi de Projet pour mettre à jour le STATUS.md 
avec les nouvelles métriques (3 nouveaux endpoints, 15 tests ajoutés).
```

### Rôle de l'Agent Suivi de Projet

**Agent Suivi de Projet** est responsable de :
1. **Analyser** l'avancement réel (commits Git, fichiers créés, tests passants)
2. **Mettre à jour** le STATUS.md avec précision
3. **Vérifier** la cohérence (métriques, dates, statuts des tâches)
4. **Identifier** les nouvelles priorités basées sur l'état actuel

---

## COMMENT mettre à jour le STATUS.md

### Checklist de mise à jour

#### 1. Vérifier les informations obsolètes (5 min)

- [ ] **En-tête (ligne 3-4)** :
  - Date actuelle
  - Mention de la dernière tâche majeure complétée
  - Prochaine session claire

- [ ] **Section "✅ Ce Qui Est Fait"** :
  - Déplacer les tâches de "🔜 À faire" vers "✅ Fait"
  - Ajouter la date de complétion (ex: "(20 avril)")
  - Ajouter les détails techniques (nombre de fichiers, lignes de code, tests)
  - Ajouter un ⭐ NOUVEAU ou 📍 EN COURS si pertinent

- [ ] **Section "🚧 En Cours / Prochaines Étapes"** :
  - Retirer les tâches complétées
  - Ajouter les nouvelles tâches identifiées
  - Ajuster les priorités (Priorité 1, 2, 3)

- [ ] **Section "📂 Structure Actuelle du Projet"** :
  - Ajouter les nouveaux répertoires/fichiers créés
  - Mettre à jour les commentaires (ex: "# 29 fichiers (3,940 lignes)")

#### 2. Mettre à jour les métriques (5 min)

Dans la section "📌 Métriques du Projet" :

- [ ] **Documentation** : Nombre de lignes, fichiers de specs, commits Git
- [ ] **Code Backend** : Nombre de fichiers Go, lignes de code, tests, coverage
- [ ] **Code Frontend** : Nombre de composants React, hooks, pages
- [ ] **Endpoints REST** : Nombre et liste des endpoints opérationnels
- [ ] **Base de données** : Nombre de vraies cartes importées (vs mock)
- [ ] **Tests** : Nombre de tests unitaires/intégration, pourcentage de coverage
- [ ] **Design** : Nombre de maquettes, design systems

**Commandes utiles pour obtenir les métriques** :
```bash
# Backend : Nombre de fichiers Go
find backend/ -name "*.go" | wc -l

# Backend : Lignes de code Go
find backend/ -name "*.go" -exec wc -l {} + | tail -1

# Backend : Nombre de tests
grep -r "func Test" backend/ | wc -l

# Frontend : Nombre de composants
find frontend/src/components -name "*.tsx" | wc -l

# Git : Nombre de commits
git rev-list --count HEAD

# Base de données : Nombre de cartes (depuis le SQL ou psql)
grep "INSERT INTO cards" backend/collection-management/migrations/*.sql | wc -l
```

#### 3. Vérifier la cohérence globale (3 min)

- [ ] Les dates sont cohérentes (pas de date future, pas de "14 avril" pour une tâche du 20 avril)
- [ ] Les métriques correspondent entre les sections (ex: "1679 cartes" partout)
- [ ] Les statuts sont cohérents (pas de "✅ Fait" dans "🔜 À faire")
- [ ] La section "🎉 Bilan Global" reflète l'état actuel
- [ ] Les liens entre sections sont valides

#### 4. Identifier les nouvelles priorités (2 min)

Basé sur l'état actuel, définir :
- **Priorité 1** : Tâche critique pour débloquer le MVP
- **Priorité 2** : Tâche importante mais non bloquante
- **Priorité 3** : Amélioration ou optimisation

**Exemple de raisonnement** :
- Si le backend est complet et le frontend en cours → Priorité 1 = Tests frontend
- Si les données mock existent mais pas les vraies données → Priorité 1 = Import données réelles
- Si tout fonctionne en local mais pas en production → Priorité 1 = DevOps/CI/CD

---

## Exemples Concrets

### Exemple 1 : Import des vraies données MECCG (20 avril)

**Situation** :
- `backend/collection-management/data/import_meccg.py` créé (134 lignes)
- `backend/collection-management/migrations/002_seed_meccg_real.sql` créé (3398 lignes)
- 1679 cartes MECCG importées (1661 possédées)

**Mise à jour STATUS.md** :
1. Ajouter une sous-section "📊 Données (14 avril + 20 avril ⭐)" dans "✅ Ce Qui Est Fait"
2. Décrire l'import : script Python, migration SQL, nombre de cartes, séries couvertes
3. Mettre à jour "Métriques du Projet" : remplacer "40 cartes mock" par "1679 vraies cartes"
4. Mettre à jour l'en-tête : "1679 cartes" au lieu de "40 cartes"
5. Retirer "Import MECCG" de "🔜 À faire"

### Exemple 2 : Homepage complète (20 avril)

**Situation** :
- HeroCard + CollectionsGrid + 2 Dashboard Widgets complétés
- 4 endpoints REST opérationnels
- Frontend et Backend connectés avec données réelles

**Mise à jour STATUS.md** :
1. Passer "🎯 Option 1 : Compléter la Homepage" de "EN COURS" à "✅ COMPLÈTE"
2. Ajouter la section "🎯 Dashboard Widgets (20 avril) ⭐ NOUVEAU"
3. Mettre à jour "Endpoints REST" : 4 endpoints au lieu de 1
4. Mettre à jour "Métriques Frontend" : ~15 composants + hooks
5. Mettre à jour "État Actuel" dans "Bilan Global"
6. Définir nouvelles priorités : Tests Frontend, DevOps multi-services

---

## Bonnes Pratiques

### ✅ À FAIRE

- **Être précis** : "1679 cartes" plutôt que "beaucoup de cartes"
- **Dater les changements** : "(20 avril)" pour savoir quand c'est arrivé
- **Utiliser des émojis clairs** : ✅ (fait), 🔜 (à faire), ⭐ (nouveau), 📍 (en cours)
- **Citer les fichiers créés** : Avec chemins absolus depuis la racine du projet
- **Vérifier les métriques** : Utiliser des commandes pour confirmer les chiffres

### ❌ À ÉVITER

- **Garder des tâches obsolètes** : Si c'est fait, le marquer ✅ (pas laisser dans "À faire")
- **Métriques incohérentes** : "40 cartes" dans une section et "1679 cartes" dans une autre
- **Manque de contexte** : "Import complété" → Plutôt "Import MECCG complété (1679 cartes, 8 séries)"
- **Dates floues** : "Récemment" → Plutôt "(20 avril)"
- **Sections dupliquées** : Si une tâche existe déjà, mettre à jour l'existante plutôt qu'ajouter une nouvelle

---

## Fréquence Recommandée

### Idéale
- **Après chaque tâche majeure** (immédiat)
- **En fin de session** si plusieurs tâches complétées

### Acceptable
- **Une fois par jour** si session longue
- **Avant chaque pause longue** (week-end, vacances)

### Minimum
- **Une fois par semaine** (le vendredi)
- **Avant chaque présentation** du projet

---

## Validation de la Mise à Jour

Après chaque mise à jour du STATUS.md, vérifier :

1. **Cohérence temporelle** : Les dates sont dans l'ordre chronologique
2. **Cohérence des métriques** : Les chiffres correspondent entre sections
3. **Clarté** : Un lecteur externe comprend l'état actuel en <5 minutes
4. **Actualité** : La date en en-tête est celle du jour
5. **Complétude** : Toutes les tâches récentes sont mentionnées

---

## Notes

- Ce workflow est une recommandation, pas une obligation stricte
- L'utilisateur peut demander une mise à jour à tout moment
- Alfred doit rester flexible : si l'utilisateur est pressé, ne pas forcer une mise à jour
- Le STATUS.md n'est pas un journal de commit : synthétiser, ne pas tout lister

---

**Responsable de ce workflow** : Alfred (détection) → Agent Suivi de Projet (exécution)  
**Dernière révision** : 2026-04-21
