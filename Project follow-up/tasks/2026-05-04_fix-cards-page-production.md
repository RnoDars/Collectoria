# Fix Page /cards en Production - Bug Critique

**Date de création** : 2026-05-04
**Priorité** : CRITIQUE (URGENT)
**Effort estimé** : 1-2h
**Agent(s) responsable(s)** : Agent DevOps + Agent Backend
**Status** : 📋 TODO

---

## Contexte

La page `/cards` ne fonctionne pas en production. L'utilisateur rencontre l'erreur "failed to fetch cards" alors que l'application fonctionne correctement en développement local.

**Symptôme** : Erreur lors du chargement de la page `/cards` en production
**Impact** : BLOQUANT - Fonctionnalité principale inaccessible
**Pages potentiellement affectées** : `/cards`, `/books`, `/dnd5` (toutes les pages de collections)

---

## Objectif

Diagnostiquer et corriger le bug empêchant l'affichage de la page `/cards` en production, puis valider que toutes les pages de collections fonctionnent correctement.

---

## Plan d'Action

### Phase 1 : Diagnostic (30min)

#### Backend
- [ ] Consulter les logs Docker backend production
  ```bash
  ssh [serveur-prod]
  docker logs collectoria-backend-collection-management -f --tail=100
  ```
- [ ] Vérifier l'état de santé du service
  ```bash
  curl https://[domaine-prod]/api/v1/health
  ```
- [ ] Tester l'endpoint `/api/v1/cards` directement
  ```bash
  curl -H "Authorization: Bearer [token]" https://[domaine-prod]/api/v1/cards
  ```
- [ ] Vérifier la connectivité PostgreSQL
  ```bash
  docker exec collectoria-backend-collection-management pg_isready -h db -U collectoria
  ```
- [ ] Examiner les variables d'environnement (JWT_SECRET, DB credentials)
  ```bash
  docker exec collectoria-backend-collection-management env | grep -E "(DB_|JWT_|SERVER_)"
  ```

#### Frontend
- [ ] Consulter les logs Docker frontend production
  ```bash
  docker logs collectoria-frontend -f --tail=100
  ```
- [ ] Vérifier la configuration de l'URL API (`NEXT_PUBLIC_API_URL`)
- [ ] Tester le chargement de la page depuis le serveur
  ```bash
  curl -I https://[domaine-prod]/cards
  ```

#### Réseau & Infrastructure
- [ ] Vérifier configuration Traefik (routing, HTTPS, CORS)
  ```bash
  docker logs traefik --tail=100
  ```
- [ ] Vérifier la résolution DNS interne Docker
- [ ] Tester la communication inter-conteneurs

### Phase 2 : Identification de la Cause (15min)

**Hypothèses possibles** :
1. **Backend inaccessible** : Port non exposé, service arrêté, crash au démarrage
2. **Base de données** : Migration non appliquée, connectivité PostgreSQL, seeds manquantes
3. **Variables d'environnement** : JWT_SECRET manquant, DB credentials incorrects
4. **Réseau Docker** : Services non sur le même réseau, Traefik mal configuré
5. **CORS** : Headers CORS manquants ou mal configurés
6. **Authentication** : Token JWT invalide, expiré ou non fourni
7. **Frontend** : URL API incorrecte (localhost au lieu de domaine prod)

**Procédure d'élimination** :
- [ ] Si `/api/v1/health` échoue → Problème backend/réseau
- [ ] Si `/api/v1/health` OK mais `/api/v1/cards` échoue → Problème DB/auth/données
- [ ] Si API OK mais page frontend échoue → Problème frontend/configuration

### Phase 3 : Correction (30-45min)

**Scénario A : Problème Backend**
- [ ] Redémarrer le service backend
  ```bash
  docker restart collectoria-backend-collection-management
  ```
- [ ] Si crash au démarrage, corriger la configuration (JWT_SECRET, DB credentials)
- [ ] Vérifier et appliquer les migrations manquantes
  ```bash
  docker exec collectoria-backend-collection-management ./scripts/migrate.sh
  ```

**Scénario B : Problème Base de Données**
- [ ] Vérifier que PostgreSQL est accessible
- [ ] Appliquer les migrations SQL
- [ ] Vérifier que les tables existent et contiennent des données
  ```sql
  SELECT COUNT(*) FROM meccg_cards;
  SELECT COUNT(*) FROM user_cards;
  ```

**Scénario C : Problème Configuration**
- [ ] Corriger les variables d'environnement manquantes
- [ ] Mettre à jour `docker-compose.yml` si nécessaire
- [ ] Redémarrer les services après modification

**Scénario D : Problème Réseau/Traefik**
- [ ] Vérifier les labels Traefik sur les services
- [ ] Vérifier la configuration CORS
- [ ] Vérifier le réseau Docker partagé entre services

**Scénario E : Problème Frontend**
- [ ] Corriger `NEXT_PUBLIC_API_URL` dans `.env.production`
- [ ] Rebuild et redéployer le frontend
  ```bash
  docker compose build frontend
  docker compose up -d frontend
  ```

### Phase 4 : Validation (15min)

- [ ] Tester `/api/v1/health` → Doit retourner 200 OK
- [ ] Tester `/api/v1/cards` (avec auth) → Doit retourner liste de cartes
- [ ] Tester page `/cards` dans le navigateur → Doit afficher les cartes
- [ ] Tester page `/books` → Doit fonctionner
- [ ] Tester page `/dnd5` → Doit fonctionner
- [ ] Tester sur mobile et desktop
- [ ] Vérifier les logs (pas d'erreurs)

---

## Critères d'Acceptation

- [ ] La page `/cards` s'affiche correctement en production
- [ ] Aucune erreur dans les logs backend
- [ ] Aucune erreur dans les logs frontend
- [ ] Les pages `/books` et `/dnd5` fonctionnent également
- [ ] L'API retourne les données correctement (avec authentification)
- [ ] Le health check backend retourne 200 OK

---

## Risques & Mitigations

**Risque 1** : Corruption de la base de données en production
→ **Mitigation** : Backup avant toute intervention sur la DB

**Risque 2** : Déploiement d'un fix cassant d'autres fonctionnalités
→ **Mitigation** : Tests complets des 3 pages de collections avant validation

**Risque 3** : Configuration manquante non documentée
→ **Mitigation** : Documenter toute variable d'environnement découverte comme obligatoire

---

## Références

- Architecture Backend : `/Backend/ARCHITECTURE.md`
- Configuration DevOps : `/DevOps/docker-compose.prod.yml`
- Frontend API client : `/frontend/src/lib/api.ts`
- Health check endpoint : `/backend/collection-management/internal/handlers/health.go`

---

## Notes

### Différences Dev vs Prod à Vérifier

**Environnement Local (fonctionne)** :
- Backend : `localhost:8080`
- Frontend : `localhost:3000`
- PostgreSQL : `localhost:5432`
- JWT_SECRET : Variable d'environnement définie manuellement

**Environnement Production** :
- Backend : Derrière Traefik (HTTPS)
- Frontend : Derrière Traefik (HTTPS)
- PostgreSQL : Conteneur Docker interne
- JWT_SECRET : Doit être défini dans `docker-compose.yml` ou `.env.production`

### Points de Vigilance

1. **JWT_SECRET manquant** : Le backend refuse de démarrer sans cette variable (erreur au startup)
2. **NEXT_PUBLIC_API_URL** : Doit pointer vers le domaine de production, PAS `localhost`
3. **CORS** : Headers CORS doivent autoriser le domaine frontend
4. **Migrations** : Doivent être appliquées au démarrage du backend en production

### Actions Post-Fix

Une fois le bug corrigé, documenter :
- [ ] La cause racine identifiée
- [ ] Les variables d'environnement obligatoires
- [ ] Les checks à faire avant chaque déploiement
- [ ] Mettre à jour la checklist de déploiement DevOps

---

**Début prévu** : Immédiatement
**Fin prévue** : 1-2h après début
**Blocage pour** : Toute utilisation de la production
