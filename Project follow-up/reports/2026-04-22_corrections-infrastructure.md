# Rapport de session — 22 avril 2026 (fin de journée)
## Corrections et Infrastructure Multi-Machines

**Date** : 2026-04-22  
**Durée** : ~1h  
**Focus** : Corrections bugs + Setup reproductible multi-machines

---

## Problèmes résolus

### 1. `react-hot-toast` manquant au démarrage
- **Symptôme** : Build error — `Module not found: Can't resolve 'react-hot-toast'`
- **Cause** : Paquet utilisé dans `layout.tsx` mais absent de `package.json` sur cette machine
- **Fix** : `npm install react-hot-toast`

### 2. Hydration mismatch sur TopNav
- **Symptôme** : Erreur React — server HTML (`<a href="/login">`) ≠ client HTML (`<button logout>`)
- **Cause** : `isAuthenticated()` lit `localStorage` pendant le rendu SSR → toujours `false` côté serveur, `true` côté client
- **Fix** : Ajout état `mounted` dans `TopNav.tsx` — l'UI auth ne se rend qu'après `useEffect` initial
- **Fichier** : `frontend/src/components/layout/TopNav.tsx`

### 3. Table `activities` absente (migration manquante)
- **Symptôme** : `GET /api/v1/activities/recent` → 500 `pq: relation "activities" does not exist`
- **Cause** : Migration 003 non jouée sur cette machine
- **Fix** : Application manuelle de `migrations/003_create_activities_table.sql`
- **Leçon** : Procédure d'init documentée dans DevOps pour éviter ce cas

### 4. Clés dupliquées dans RecentActivityWidget
- **Symptôme** : Warning React — `Encountered two children with the same key`
- **Cause** : Dans `activity_repository.go`, `rows.Scan()` utilisait `&a.ID` comme destination pour 3 colonnes (`id`, `user_id`, `entity_id`). La dernière valeur scannée (`entity_id` = card_id) écrasait l'ID de l'activité → plusieurs activités sur la même carte avaient le même ID
- **Fix** : Variables dédiées `scannedUserID uuid.UUID` et `scannedEntityID uuid.UUID`
- **Fichier** : `backend/collection-management/internal/infrastructure/postgres/activity_repository.go`

---

## Amélioration : Setup multi-machines

### Contexte
L'environnement de dev tourne sur deux machines différentes. Les données de possession (table `user_cards`) étant locales, elles divergent entre machines.

### Solution retenue : Option A — Seed de dev dans git
- Création de `migrations/004_seed_dev_possession.sql`
  - 1679 `INSERT` avec `ON CONFLICT (user_id, card_id) DO NOTHING`
  - Snapshot de la possession réelle depuis le Google Sheets original (1661/1679 possédées)
  - Idempotente : peut être rejouée sans risque sur une base existante

### Procédure d'init documentée
`DevOps/CLAUDE.md` — nouvelle section "Initialisation d'une Nouvelle Machine" :
1. Clone repo
2. `docker compose up -d`
3. Appliquer les 4 migrations dans l'ordre
4. `npm install`
5. Lancer backend + frontend

### Corrections DevOps/CLAUDE.md
- Chemins : `/home/arnaud.dars/` → `~/git/Collectoria/`
- Mot de passe DB : `changeme` → `collectoria`
- Variables JWT manquantes ajoutées dans la commande de lancement backend
- Tableau des credentials de dev

---

## Métriques
- **4 bugs corrigés**
- **1 migration ajoutée** (004_seed_dev_possession.sql, 1679 lignes)
- **1 section DevOps ajoutée** (init nouvelle machine)
- **0 test cassé**

---

## Prochaine session
**Collection Romans "Royaumes oubliés"** — plan complet disponible dans `Project follow-up/tasks/books-collection-implementation.md`
