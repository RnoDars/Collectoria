# Séparation des Données par Environnement

**Date de création** : 2026-05-04
**Priorité** : HAUTE
**Effort estimé** : 4-6h
**Agent(s) responsable(s)** : Agent Backend + Agent DevOps
**Status** : 📋 TODO

---

## Contexte

Actuellement, les données utilisateurs et les seeds de test sont mélangées entre l'environnement de développement et la production. Cela pose plusieurs problèmes critiques :

1. **Données identiques en prod et local** : Les users de test apparaissent en production
2. **Risque d'écrasement** : Les seeds de développement peuvent écraser les données production
3. **Pas de séparation claire** : Structure (migrations) et données (seeds) sont confondues
4. **Sécurité** : Données de test hardcodées en production

**Impact** :
- Données de production non protégées
- Environnements non isolés
- Risque de perte de données utilisateurs réels

---

## Objectif

Séparer strictement :
1. **Structure de la base de données** (migrations SQL) - Commune à tous les environnements
2. **Données de développement** (seeds de test) - Uniquement en développement local
3. **Données de production** (user admin) - Uniquement en production

**Règle d'or** : Les seeds de test NE DOIVENT JAMAIS s'exécuter en production.

---

## Architecture Actuelle vs Cible

### Architecture Actuelle (Problématique)

```
backend/collection-management/
├── migrations/
│   ├── 001_create_users.up.sql          # Structure + INSERT hardcodé
│   ├── 002_create_meccg_cards.up.sql    # Structure + seeds de test
│   ├── 003_create_user_cards.up.sql     # Structure + données de test
│   └── 004_create_user_collections.up.sql
└── docker-compose.yml                    # Exécute migrations au démarrage
```

**Problèmes** :
- ❌ Migrations contiennent des `INSERT` de données de test
- ❌ Même user admin en dev et prod (email/password identiques)
- ❌ Seeds de test s'exécutent automatiquement en production
- ❌ Pas de distinction entre structure et données

### Architecture Cible (Sécurisée)

```
backend/collection-management/
├── migrations/                          # Structure UNIQUEMENT (DDL)
│   ├── 001_create_users.up.sql         # CREATE TABLE users (pas d'INSERT)
│   ├── 002_create_meccg_cards.up.sql   # CREATE TABLE meccg_cards
│   ├── 003_create_user_cards.up.sql    # CREATE TABLE user_cards
│   └── 004_create_user_collections.up.sql
│
├── seeds/
│   ├── dev/                             # Seeds de développement UNIQUEMENT
│   │   ├── 001_seed_test_users.sql     # Users de test (alice, bob)
│   │   ├── 002_seed_meccg_cards.sql    # Cartes MECCG
│   │   ├── 003_seed_user_cards.sql     # Possession de test
│   │   └── 004_seed_user_collections.sql
│   │
│   └── prod/                            # Seeds de production UNIQUEMENT
│       └── 001_create_admin_user.sql   # 1 seul user admin
│
└── scripts/
    ├── migrate.sh                       # Applique migrations (toujours)
    ├── seed-dev.sh                      # Applique seeds dev (si ENV=dev)
    └── seed-prod.sh                     # Applique seeds prod (si ENV=prod, 1 fois)
```

**Avantages** :
- ✅ Migrations = Structure pure (idempotent, safe)
- ✅ Seeds = Données séparées par environnement
- ✅ Production protégée (1 admin, pas de données de test)
- ✅ Développement isolé (seeds de test sans risque)

---

## Plan d'Action

### Phase 1 : Audit des Données Actuelles (1h)

**Agent Backend** :
- [ ] Lister toutes les migrations existantes
- [ ] Identifier les `INSERT` hardcodés dans les migrations
- [ ] Extraire les données de test vs données structure
- [ ] Identifier les tables concernées :
  - `users` (test users vs admin prod)
  - `meccg_cards` (données de référence)
  - `user_cards` (possession de test)
  - `user_collections` (collections de test)
  - `books_forgotten_realms` (données de référence)
  - `dnd5_items` (données de référence)

**Rapport attendu** :
```
Migration 001 : CREATE TABLE users + INSERT 2 test users
  → Extraire INSERT vers seeds/dev/001_seed_test_users.sql

Migration 002 : CREATE TABLE meccg_cards + INSERT 500 cartes
  → Extraire INSERT vers seeds/dev/002_seed_meccg_cards.sql

Migration 003 : CREATE TABLE user_cards + INSERT possession test
  → Extraire INSERT vers seeds/dev/003_seed_user_cards.sql
```

### Phase 2 : Création Structure Seeds (1h)

**Agent Backend** :
- [ ] Créer répertoire `backend/collection-management/seeds/`
- [ ] Créer sous-répertoires `seeds/dev/` et `seeds/prod/`
- [ ] Créer fichiers seeds dev :
  ```sql
  -- seeds/dev/001_seed_test_users.sql
  INSERT INTO users (id, email, username, password_hash, created_at, updated_at)
  VALUES
    ('550e8400-e29b-41d4-a716-446655440001', 'alice@test.com', 'alice', '[hash]', NOW(), NOW()),
    ('550e8400-e29b-41d4-a716-446655440002', 'bob@test.com', 'bob', '[hash]', NOW(), NOW());
  ```
- [ ] Créer fichier seed prod :
  ```sql
  -- seeds/prod/001_create_admin_user.sql
  INSERT INTO users (id, email, username, password_hash, created_at, updated_at)
  VALUES
    (gen_random_uuid(), 'admin@collectoria.com', 'admin', '[hash-sécurisé]', NOW(), NOW())
  ON CONFLICT (email) DO NOTHING; -- Idempotent
  ```
- [ ] Extraire toutes les données de test des migrations vers seeds

### Phase 3 : Nettoyage des Migrations (1h)

**Agent Backend** :
- [ ] Nettoyer `001_create_users.up.sql` → Supprimer INSERT, garder CREATE TABLE uniquement
- [ ] Nettoyer `002_create_meccg_cards.up.sql` → Structure uniquement
- [ ] Nettoyer `003_create_user_cards.up.sql` → Structure uniquement
- [ ] Nettoyer `004_create_user_collections.up.sql` → Structure uniquement
- [ ] Vérifier que migrations contiennent UNIQUEMENT du DDL (CREATE, ALTER, DROP)
- [ ] Valider syntax SQL

### Phase 4 : Scripts de Seeding (1h)

**Agent DevOps** :
- [ ] Créer `scripts/seed-dev.sh` :
  ```bash
  #!/bin/bash
  # Applique les seeds de développement UNIQUEMENT si ENV != production
  
  if [ "$ENV" = "production" ]; then
    echo "❌ Seeds dev interdits en production"
    exit 1
  fi
  
  echo "Applying dev seeds..."
  psql -h $DB_HOST -U $DB_USER -d $DB_NAME -f seeds/dev/001_seed_test_users.sql
  psql -h $DB_HOST -U $DB_USER -d $DB_NAME -f seeds/dev/002_seed_meccg_cards.sql
  psql -h $DB_HOST -U $DB_USER -d $DB_NAME -f seeds/dev/003_seed_user_cards.sql
  echo "✅ Dev seeds applied"
  ```
  
- [ ] Créer `scripts/seed-prod.sh` :
  ```bash
  #!/bin/bash
  # Crée le user admin en production (1 seule fois, idempotent)
  
  if [ "$ENV" != "production" ]; then
    echo "⚠️ Ce script est réservé à la production"
    exit 1
  fi
  
  echo "Creating admin user..."
  psql -h $DB_HOST -U $DB_USER -d $DB_NAME -f seeds/prod/001_create_admin_user.sql
  echo "✅ Admin user created (or already exists)"
  ```

- [ ] Rendre les scripts exécutables :
  ```bash
  chmod +x scripts/seed-dev.sh scripts/seed-prod.sh
  ```

### Phase 5 : Mise à Jour Docker Compose (30min)

**Agent DevOps** :
- [ ] Mettre à jour `docker-compose.yml` (dev) :
  ```yaml
  services:
    backend-collection-management:
      environment:
        - ENV=development
      volumes:
        - ./backend/collection-management/seeds:/app/seeds:ro
      command: >
        sh -c "
          ./scripts/migrate.sh &&
          ./scripts/seed-dev.sh &&
          ./cmd/api/main
        "
  ```

- [ ] Mettre à jour `docker-compose.prod.yml` (prod) :
  ```yaml
  services:
    backend-collection-management:
      environment:
        - ENV=production
      # PAS de volume seeds monté (sécurité)
      command: >
        sh -c "
          ./scripts/migrate.sh &&
          ./cmd/api/main
        "
  ```

- [ ] Documenter le process de création admin prod :
  ```bash
  # À exécuter manuellement UNE SEULE FOIS après premier déploiement prod
  docker exec collectoria-backend-collection-management ./scripts/seed-prod.sh
  ```

### Phase 6 : Tests et Validation (1-1.5h)

**Environnement Local (Dev)** :
- [ ] Supprimer la base de données locale
  ```bash
  docker compose down -v
  ```
- [ ] Redémarrer avec nouvelle structure
  ```bash
  docker compose up -d
  ```
- [ ] Vérifier migrations appliquées (structure uniquement)
  ```sql
  \dt -- Lister les tables
  SELECT * FROM schema_migrations;
  ```
- [ ] Vérifier seeds dev appliquées
  ```sql
  SELECT COUNT(*) FROM users; -- Doit contenir alice, bob
  SELECT COUNT(*) FROM meccg_cards; -- Doit contenir les cartes de test
  ```
- [ ] Tester l'API avec users de test
  ```bash
  curl -X POST http://localhost:8080/api/v1/auth/login \
    -d '{"email":"alice@test.com","password":"password123"}'
  ```

**Environnement Staging (si disponible)** :
- [ ] Déployer la nouvelle structure
- [ ] Vérifier migrations appliquées
- [ ] Vérifier qu'AUCUNE seed dev n'a été appliquée
- [ ] Créer manuellement l'admin prod
  ```bash
  docker exec collectoria-backend-collection-management ./scripts/seed-prod.sh
  ```
- [ ] Tester login avec admin prod

**Validation Sécurité** :
- [ ] Confirmer qu'il est IMPOSSIBLE d'exécuter `seed-dev.sh` en production (exit 1)
- [ ] Confirmer que le répertoire `seeds/` n'est PAS monté en production
- [ ] Confirmer que l'admin prod a un password différent des users de test
- [ ] Documenter les credentials admin prod dans vault sécurisé (pas dans git)

---

## Critères d'Acceptation

- [ ] Les migrations contiennent UNIQUEMENT des instructions DDL (CREATE, ALTER, DROP)
- [ ] Aucun `INSERT` hardcodé dans les migrations
- [ ] Seeds dev dans `seeds/dev/` (users test, données de test)
- [ ] Seeds prod dans `seeds/prod/` (1 admin uniquement)
- [ ] Script `seed-dev.sh` refuse de s'exécuter si `ENV=production`
- [ ] Script `seed-prod.sh` refuse de s'exécuter si `ENV!=production`
- [ ] Environnement local fonctionne avec seeds dev
- [ ] Production protégée (pas de seeds dev, uniquement admin)
- [ ] Admin prod a credentials différents des users de test
- [ ] Documentation à jour (README DevOps)

---

## Règles de Sécurité

### INTERDICTIONS ABSOLUES

1. ❌ **JAMAIS** inclure de `INSERT` dans les migrations
2. ❌ **JAMAIS** exécuter seeds dev en production
3. ❌ **JAMAIS** commiter de credentials prod dans git
4. ❌ **JAMAIS** utiliser les mêmes passwords test et prod
5. ❌ **JAMAIS** monter le répertoire `seeds/` en lecture-écriture en prod

### OBLIGATIONS

1. ✅ **TOUJOURS** valider `ENV` avant d'appliquer des seeds
2. ✅ **TOUJOURS** utiliser `ON CONFLICT DO NOTHING` pour idempotence
3. ✅ **TOUJOURS** hasher les passwords avec bcrypt
4. ✅ **TOUJOURS** documenter les credentials admin dans vault sécurisé
5. ✅ **TOUJOURS** tester la séparation dev/prod avant déploiement

---

## Risques & Mitigations

**Risque 1** : Perte de données de production lors de la migration
→ **Mitigation** : Backup complet de la DB avant toute intervention

**Risque 2** : Seeds dev exécutées accidentellement en production
→ **Mitigation** : Check obligatoire `ENV=production` → exit 1

**Risque 3** : Oubli de création admin prod après déploiement
→ **Mitigation** : Documentation claire + checklist de déploiement

**Risque 4** : Credentials admin faibles ou identiques à dev
→ **Mitigation** : Générer password fort, stocker dans vault sécurisé

**Risque 5** : Seeds non idempotentes (erreur si réexécution)
→ **Mitigation** : Utiliser `ON CONFLICT DO NOTHING` systématiquement

---

## Références

- Architecture Backend : `/Backend/ARCHITECTURE.md`
- Migrations existantes : `/backend/collection-management/migrations/`
- Docker Compose Dev : `/backend/collection-management/docker-compose.yml`
- Docker Compose Prod : `/DevOps/docker-compose.prod.yml`

---

## Notes

### Données de Référence vs Données Utilisateur

**Données de Référence** (peuvent être seedées en prod) :
- Cartes MECCG officielles (liste complète du jeu)
- Livres Forgotten Realms (catalogue officiel)
- Items DnD5 (référence officielle)
→ Ces données sont statiques, publiques, nécessaires au fonctionnement

**Données Utilisateur** (JAMAIS seedées en prod) :
- Users (sauf 1 admin)
- user_cards (possession)
- user_collections (organisation)
- activities (historique)
→ Ces données sont dynamiques, privées, créées par les utilisateurs

### Stratégie de Migration des Données de Référence

**Option A** : Seeds en production (recommandé pour MVP)
```
seeds/prod/
  002_seed_meccg_cards.sql   # Cartes officielles
  003_seed_books_catalog.sql # Livres officiels
  004_seed_dnd5_items.sql    # Items officiels
```

**Option B** : Import via API admin (recommandé pour scale)
```
POST /api/v1/admin/import/meccg-cards
POST /api/v1/admin/import/books-catalog
POST /api/v1/admin/import/dnd5-items
```

Pour le MVP, utiliser Option A (seeds prod pour données de référence).

### Checklist Post-Migration

- [ ] Vérifier que la base dev contient les users de test
- [ ] Vérifier que la base prod contient UNIQUEMENT l'admin
- [ ] Vérifier que les données de référence sont présentes (cartes, livres, items)
- [ ] Tester login dev avec alice/bob
- [ ] Tester login prod avec admin uniquement
- [ ] Documenter les credentials admin dans vault sécurisé
- [ ] Mettre à jour la documentation DevOps

---

**Prochaines Actions** :
1. Phase 1 : Audit (Agent Backend)
2. Phase 2-3 : Extraction et nettoyage (Agent Backend)
3. Phase 4-5 : Scripts et Docker (Agent DevOps)
4. Phase 6 : Tests et validation (Agent Backend + Agent DevOps)
