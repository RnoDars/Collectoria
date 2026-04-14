# Système d'Agents - Collectoria

## Architecture

Ce projet utilise un système d'agents spécialisés basé sur des fichiers `CLAUDE.md` et l'outil Agent de Claude Code.

## Agent Principal

### Alfred (Agent de Dispatch)
- **Localisation** : Racine du projet `/`
- **Fichier** : `CLAUDE.md`
- **Spécialité** : Coordination, dispatch des tâches, point d'entrée principal
- **Invocation** : Par défaut lors du travail à la racine
- **Rôle** : C'est l'agent avec lequel vous interagissez principalement. Il analyse vos demandes et les dispatche aux agents spécialisés appropriés.

## Agents de Gestion

### 1. Agent de Suivi de Projet
- **Localisation** : `Project follow-up/`
- **Fichier** : `Project follow-up/CLAUDE.md`
- **Spécialité** : Gestion de projet, suivi des tâches, documentation d'avancement
- **Invocation** : Via Alfred ou directement dans le répertoire

### 2. Agent Spécifications
- **Localisation** : `Specifications/`
- **Fichier** : `Specifications/CLAUDE.md`
- **Spécialité** : Création de specs de développement, analyse d'images/mockups
- **Invocation** : Via Alfred pour créer des spécifications
- **Expertise** : Transformation d'idées et images en spécifications techniques détaillées

### 3. Agent Amélioration Continue
- **Localisation** : `Continuous-Improvement/`
- **Fichier** : `Continuous-Improvement/CLAUDE.md`
- **Spécialité** : Optimisation du système d'agents, détection de besoins d'amélioration
- **Invocation** : Via Alfred ou consultation périodique
- **Rôle** : Surveille la santé du système d'agents, propose des améliorations et détecte les besoins de subdivision

## Agents Techniques

### 4. Agent Backend
- **Localisation** : `Backend/`
- **Fichier** : `Backend/CLAUDE.md`
- **Spécialité** : Architecture serveur, API, base de données, logique métier
- **Invocation** : Via Alfred pour les tâches backend

### 5. Agent Frontend
- **Localisation** : `Frontend/`
- **Fichier** : `Frontend/CLAUDE.md`
- **Spécialité** : Interface utilisateur, composants, UX, gestion d'état
- **Invocation** : Via Alfred pour les tâches frontend

### 6. Agent DevOps
- **Localisation** : `DevOps/`
- **Fichier** : `DevOps/CLAUDE.md`
- **Spécialité** : CI/CD, déploiement, infrastructure, monitoring
- **Invocation** : Via Alfred pour les tâches DevOps

### 7. Agent Testing
- **Localisation** : `Testing/`
- **Fichier** : `Testing/CLAUDE.md`
- **Spécialité** : Tests unitaires, intégration, E2E, qualité du code
- **Invocation** : Via Alfred pour les tâches de test

### 8. Agent Documentation
- **Localisation** : `Documentation/`
- **Fichier** : `Documentation/CLAUDE.md`
- **Spécialité** : Documentation technique, guides utilisateur, API docs
- **Invocation** : Via Alfred pour les tâches de documentation

## Comment utiliser les agents

### Workflow Recommandé
1. **Interaction avec Alfred** : Commencez toujours par interagir avec Alfred à la racine
2. **Dispatch automatique** : Alfred analyse votre demande et la dispatche au bon agent
3. **Suivi** : Alfred vous tient informé des actions effectuées par les agents spécialisés

### Méthode 1 : Via Alfred (Recommandé)
Travaillez à la racine du projet. Alfred lira le `CLAUDE.md` principal et dispatchera les tâches aux agents appropriés.

### Méthode 2 : Contexte local direct
Naviguez dans le répertoire d'un agent spécifique et travaillez directement. Claude lira automatiquement le fichier `CLAUDE.md` local.

### Méthode 3 : Agent Tool
Utilisez l'outil Agent avec le type approprié et référencez le contexte spécifique :
- Pour exploration : `Agent tool avec subagent_type=Explore`
- Pour planification : `Agent tool avec subagent_type=Plan`

## Création d'un nouvel agent

1. Créer un répertoire pour l'agent : `mkdir "NomAgent"`
2. Créer le fichier de contexte : `touch "NomAgent/CLAUDE.md"`
3. Définir le rôle, responsabilités et instructions spécifiques
4. Mettre à jour ce fichier `AGENTS.md`
5. Référencer l'agent dans les `CLAUDE.md` des autres agents si nécessaire

## Bonnes pratiques

- **Point d'entrée unique** : Interagir principalement avec Alfred
- **Spécialisation claire** : Chaque agent a un domaine bien défini
- **Communication** : Les agents se référencent mutuellement via Alfred
- **Documentation** : Chaque agent documente ses actions
- **Git** : Commiter les changements de chaque agent séparément
- **Contexte** : Utiliser les fichiers CLAUDE.md pour le contexte persistant
- **Amélioration continue** : Consulter régulièrement l'Agent Amélioration Continue
- **Spécifications d'abord** : Utiliser l'Agent Spécifications avant de développer de nouvelles fonctionnalités

## Flux de Travail Typique

### Nouvelle Fonctionnalité
1. **Demande** à Alfred : "Je veux créer [fonctionnalité]"
2. Alfred → **Agent Spécifications** : Création de specs (analyse d'images si besoin)
3. Alfred → **Agent Suivi** : Création de tâches
4. Alfred → **Agents Techniques** (Backend/Frontend) : Implémentation
5. Alfred → **Agent Testing** : Création des tests
6. Alfred → **Agent Documentation** : Documentation
7. Alfred → **Agent DevOps** : Déploiement

### Optimisation du Système
1. **Agent Amélioration Continue** : Analyse périodique
2. Détection de besoins d'amélioration
3. Proposition à Alfred
4. Validation et implémentation
5. Mise à jour de AGENTS.md
