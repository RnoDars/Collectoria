# Système d'Agents - Collectoria

## Architecture

Ce projet utilise un système d'agents spécialisés basé sur des fichiers `CLAUDE.md` et l'outil Agent de Claude Code.

## Agents disponibles

### 1. Agent de Suivi de Projet
- **Localisation** : `Project follow-up/`
- **Fichier** : `Project follow-up/CLAUDE.md`
- **Spécialité** : Gestion de projet, suivi des tâches, documentation d'avancement
- **Invocation** : Travailler dans le répertoire `Project follow-up/` ou utiliser l'Agent tool avec contexte

### 2. Agent Backend
- **Localisation** : `Backend/`
- **Fichier** : `Backend/CLAUDE.md`
- **Spécialité** : Architecture serveur, API, base de données, logique métier
- **Invocation** : Travailler dans le répertoire `Backend/` ou utiliser l'Agent tool

### 3. Agent Frontend
- **Localisation** : `Frontend/`
- **Fichier** : `Frontend/CLAUDE.md`
- **Spécialité** : Interface utilisateur, composants, UX, gestion d'état
- **Invocation** : Travailler dans le répertoire `Frontend/` ou utiliser l'Agent tool

### 4. Agent DevOps
- **Localisation** : `DevOps/`
- **Fichier** : `DevOps/CLAUDE.md`
- **Spécialité** : CI/CD, déploiement, infrastructure, monitoring
- **Invocation** : Travailler dans le répertoire `DevOps/` ou utiliser l'Agent tool

### 5. Agent Testing
- **Localisation** : `Testing/`
- **Fichier** : `Testing/CLAUDE.md`
- **Spécialité** : Tests unitaires, intégration, E2E, qualité du code
- **Invocation** : Travailler dans le répertoire `Testing/` ou utiliser l'Agent tool

### 6. Agent Documentation
- **Localisation** : `Documentation/`
- **Fichier** : `Documentation/CLAUDE.md`
- **Spécialité** : Documentation technique, guides utilisateur, API docs
- **Invocation** : Travailler dans le répertoire `Documentation/` ou utiliser l'Agent tool

## Comment utiliser les agents

### Méthode 1 : Contexte local (CLAUDE.md)
Naviguez dans le répertoire de l'agent et travaillez. Claude lira automatiquement le fichier `CLAUDE.md` local.

### Méthode 2 : Agent Tool
Utilisez l'outil Agent avec le type approprié et référencez le contexte spécifique :
- Pour exploration : `Agent tool avec subagent_type=Explore`
- Pour code : `Agent tool avec subagent_type=Code`

### Méthode 3 : Combiner les deux
Créez un `CLAUDE.md` ET invoquez explicitement l'agent via l'Agent tool pour des tâches complexes nécessitant un contexte isolé.

## Création d'un nouvel agent

1. Créer un répertoire pour l'agent : `mkdir "NomAgent"`
2. Créer le fichier de contexte : `touch "NomAgent/CLAUDE.md"`
3. Définir le rôle, responsabilités et instructions spécifiques
4. Mettre à jour ce fichier `AGENTS.md`
5. Référencer l'agent dans les `CLAUDE.md` des autres agents si nécessaire

## Bonnes pratiques

- **Spécialisation claire** : Chaque agent a un domaine bien défini
- **Communication** : Les agents peuvent se référencer mutuellement
- **Documentation** : Chaque agent documente ses actions
- **Git** : Commiter les changements de chaque agent séparément
- **Contexte** : Utiliser les fichiers CLAUDE.md pour le contexte persistant
