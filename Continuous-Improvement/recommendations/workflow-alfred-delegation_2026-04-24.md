# Recommandation : Workflow Alfred - Délégation et Démarrage de Session

**Date** : 2026-04-24  
**Type** : Règles Critiques  
**Priorité** : HAUTE  
**Status** : Implémenté

## Contexte

Lors de la session du 24 avril 2026, deux problèmes majeurs ont été identifiés dans le workflow d'Alfred :

1. **Alfred a développé directement** : Alfred a créé du code Backend (migrations SQL, repositories Go, handlers) et Frontend (composant React BookConfirmModal) au lieu de déléguer aux agents spécialisés.

2. **Environnement non démarré** : La session a commencé sans démarrer PostgreSQL ni le backend, causant des interruptions en cours de développement pour démarrer les services manuellement.

Ces problèmes ont causé :
- Confusion des responsabilités entre agents
- Perte d'efficacité (interruptions, redémarrages)
- Duplication de contexte technique dans Alfred
- Mauvaise traçabilité des actions

## Règle 1 : Alfred ne développe JAMAIS directement

### Problème Identifié

Alfred agit comme un développeur au lieu d'un coordinateur, créant directement :
- Code Backend Go (handlers, services, repositories)
- Migrations SQL
- Composants React/TypeScript
- Modifications de fichiers techniques

### Impact

- **Confusion des responsabilités** : Les agents spécialisés perdent leur raison d'être
- **Perte d'expertise** : Les agents Backend/Frontend ont des patterns et bonnes pratiques spécifiques
- **Mauvaise traçabilité** : Difficile de savoir qui a fait quoi
- **Duplication de contexte** : Alfred doit connaître les détails techniques de chaque domaine

### Solution : Règle de Non-Développement

**❌ Alfred ne doit JAMAIS** :
- Créer ou modifier des fichiers `.go`, `.sql`
- Créer ou modifier des fichiers `.tsx`, `.ts`, `.jsx`, `.js`
- Écrire du code technique (Backend, Frontend, Infrastructure)
- Modifier des fichiers de configuration technique

**✅ Alfred doit TOUJOURS** :
- Déléguer au **Agent Backend** pour tout code Go, SQL, migrations, repositories, services, handlers
- Déléguer au **Agent Frontend** pour tout code React, TypeScript, Next.js, composants, pages, hooks
- Déléguer au **Agent DevOps** pour toute infrastructure, Docker, scripts
- Déléguer au **Agent Testing** pour tout code de tests

### Exemples Concrets

#### ✅ Bon Usage

```
Utilisateur : "Crée un endpoint GET /books/{id}"

Alfred : 🤖 Alfred : Je fais appel à l'Agent Backend pour implémenter 
l'endpoint GET /books/{id}. Cela inclut :
- Le handler HTTP
- Le service métier
- Le repository pour accéder à la BDD
- La migration SQL si nécessaire

[Agent Backend s'exécute]

Alfred : 🤖 Alfred : L'Agent Backend a implémenté l'endpoint GET /books/{id}.
Le code est prêt pour les tests.
```

#### ❌ Mauvais Usage

```
Utilisateur : "Crée un endpoint GET /books/{id}"

Alfred : Je crée le handler...

[Alfred crée directement book_handler.go]
[Alfred crée directement book_service.go]
[Alfred crée directement book_repository.go]
[Alfred crée directement la migration SQL]

Alfred : Voilà, l'endpoint est créé.
```

### Comment Détecter

**Signes qu'Alfred développe à tort** :
- Alfred crée des fichiers `.go`, `.ts`, `.tsx`, `.sql`
- Alfred écrit du code dans ses réponses
- Commits de code dans `/` au lieu de `/Backend/` ou `/Frontend/`
- Alfred utilise directement Write/Edit pour du code applicatif

**Action de l'Agent Amélioration Continue** :
- Surveiller les patterns de création de fichiers
- Alerter immédiatement si Alfred développe
- Documenter les incidents

## Règle 2 : Démarrage Automatique de l'Environnement

### Problème Identifié

Les sessions de développement commencent sans démarrer l'environnement de test local, causant :
- Impossibilité de tester immédiatement
- Interruptions en cours de développement
- Erreurs de connexion PostgreSQL
- Perte de temps pour démarrer manuellement

### Impact

- **Inefficacité** : Temps perdu à démarrer les services en cours de route
- **Détection tardive** : Les problèmes de démarrage ne sont découverts qu'au moment du test
- **Workflow fragmenté** : Le développement est interrompu pour gérer l'infrastructure

### Solution : Workflow de Démarrage Automatique

**Déclencheurs** :
- L'utilisateur dit "On commence", "Nouvelle session", "Démarrons", "C'est parti"
- Début d'une session de développement
- Avant de travailler sur une feature nécessitant un test local

**Procédure** :

```
🤖 Alfred : Je démarre l'environnement de test local...

1. 🗄️ PostgreSQL (Collection Management)
   - cd /home/arnaud.dars/git/Collectoria/backend/collection-management/
   - docker compose up -d
   - Vérification : Port 5432 accessible

2. 🔧 Backend API (Collection Management)
   - cd /home/arnaud.dars/git/Collectoria/backend/collection-management/
   - Variables d'environnement :
     * DB_HOST=localhost
     * DB_PORT=5432
     * DB_USER=collection_user
     * DB_PASSWORD=collection_pass
     * DB_NAME=collection_db
     * SERVER_PORT=8080
   - go run cmd/api/main.go (background)
   - Vérification : Health check sur http://localhost:8080/health

3. 🎨 Frontend Next.js
   - cd /home/arnaud.dars/git/Collectoria/frontend/
   - npm run dev (background)
   - Vérification : Port 3000 accessible

4. ✅ Confirmation
   ✅ PostgreSQL : Running (port 5432)
   ✅ Backend API : Running (port 8080, health OK)
   ✅ Frontend : Running (port 3000)

L'environnement est prêt ! On peut commencer à développer.
```

### Exemples Concrets

#### ✅ Bon Usage

```
Utilisateur : "On commence, je veux ajouter la gestion des livres"

Alfred : 🤖 Alfred : Je démarre l'environnement de test local...

[Alfred lance PostgreSQL, Backend, Frontend]
[Alfred vérifie les health checks]

Alfred : 🤖 Alfred : ✅ Environnement opérationnel !
- PostgreSQL : Running (port 5432)
- Backend API : Running (port 8080, health OK)
- Frontend : Running (port 3000)

Maintenant je fais appel à l'Agent Spécifications pour créer la spec 
de la gestion des livres.
```

#### ❌ Mauvais Usage

```
Utilisateur : "On commence, je veux ajouter la gestion des livres"

Alfred : Je fais appel à l'Agent Spécifications pour créer la spec.

[Plus tard, lors du test...]

Utilisateur : "Teste l'endpoint"
Alfred : Erreur : PostgreSQL n'est pas démarré
Utilisateur : "Démarre PostgreSQL"
Alfred : OK, je démarre...
```

### Cas Particuliers

**Services déjà en cours** :
```
Alfred : 🤖 Alfred : Je vérifie l'état de l'environnement...
✅ PostgreSQL : Déjà en cours (port 5432)
✅ Backend API : Déjà en cours (port 8080, health OK)
✅ Frontend : Déjà en cours (port 3000)

L'environnement est déjà opérationnel ! On peut commencer.
```

**Erreur de démarrage** :
```
Alfred : 🤖 Alfred : Je démarre l'environnement...
❌ Backend API : Erreur au démarrage (port 8080 déjà utilisé)

Je fais appel à l'Agent DevOps pour résoudre le conflit de port.
```

## Pourquoi Ces Règles Sont Importantes

### Séparation des Responsabilités

- **Alfred** : Coordinateur stratégique, dispatcher, gestionnaire de workflow
- **Agent Backend** : Expert Go, DDD, Clean Architecture, PostgreSQL, Kafka
- **Agent Frontend** : Expert React, Next.js, TypeScript, UI/UX
- **Agent DevOps** : Expert Infrastructure, Docker, CI/CD, environnements

Chaque agent a son expertise. Mélanger les responsabilités dilue l'efficacité.

### Efficacité du Workflow

**Sans démarrage automatique** :
```
Session Start → Spec → Développement → Test → ❌ Erreur (services non démarrés) 
→ Démarrage manuel → Retry test → ...
```

**Avec démarrage automatique** :
```
Session Start → Démarrage environnement → ✅ Validation → Spec → Développement 
→ Test → ✅ Succès
```

### Traçabilité

Avec la délégation systématique :
- Chaque action de code est tracée à l'agent approprié
- Les commits viennent du bon contexte (/Backend/, /Frontend/)
- L'historique Git est clair
- Les revues de code sont facilitées

## Implémentation

### Fichiers Modifiés

1. **`/CLAUDE.md` (Alfred)**
   - Ajout section "❌ Ce qu'Alfred ne fait PAS"
   - Ajout "Workflow Automatique : Démarrage de Session"
   - Modification "Checklist Pré-Action" (4ème question)

2. **`/AGENTS.md`**
   - Clarification du rôle d'Alfred comme coordinateur
   - Mention explicite : "Alfred ne développe JAMAIS directement"

3. **`/Continuous-Improvement/CLAUDE.md`**
   - Ajout "Détecteurs de Problèmes"
   - Ajout "Bonnes Pratiques du Système d'Agents"
   - Ajout "Anti-Patterns à Éviter"

4. **Ce fichier** : `/Continuous-Improvement/recommendations/workflow-alfred-delegation_2026-04-24.md`

### Validation

**Pour Règle 1 (Non-développement)** :
- Alfred ne crée plus de fichiers de code directement
- Toute tâche de développement passe par Agent Backend ou Frontend
- Agent Amélioration Continue surveille les violations

**Pour Règle 2 (Démarrage environnement)** :
- Chaque session commence par le workflow de démarrage
- Les health checks sont validés avant de commencer
- Les interruptions pour démarrage manuel disparaissent

## Maintenance

### Surveillance Continue

**Agent Amélioration Continue** doit surveiller :
- Violations de la règle de non-développement
- Sessions sans démarrage d'environnement
- Taux de délégation aux agents spécialisés

### Évolution

Ces règles peuvent évoluer si :
- De nouveaux agents spécialisés sont créés
- L'architecture du projet change
- De nouveaux patterns de workflow émergent

**Principe** : Toujours privilégier la délégation et l'automatisation.

## Références

- **Incident d'origine** : Session du 24 avril 2026
- **Fichier Alfred** : `/CLAUDE.md`
- **Fichier Agents** : `/AGENTS.md`
- **Agent Amélioration Continue** : `/Continuous-Improvement/CLAUDE.md`
- **Feedback utilisateur** : Demande d'intégration des règles dans le système

## Conclusion

Ces deux règles améliorent fondamentalement le workflow de Collectoria :

1. **Délégation systématique** : Chaque agent fait ce qu'il fait le mieux
2. **Démarrage automatique** : L'environnement est toujours prêt

Résultat attendu :
- Workflow plus fluide
- Moins d'interruptions
- Meilleure qualité de code (expertise des agents)
- Traçabilité claire des actions

Ces règles sont maintenant intégrées dans la documentation et doivent être appliquées systématiquement par Alfred.
