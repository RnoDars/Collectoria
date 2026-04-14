# Tâches : Définition de la Vision et Spécification MVP MECCG

**Date de création** : 2026-04-14  
**Statut** : Terminé  
**Priorité** : Critique

## Objectif
Définir la vision complète du projet Collectoria et créer la spécification technique détaillée du MVP centré sur MECCG.

## Contexte

Suite à l'échange avec l'utilisateur, nous avons clarifié :
- **Collectoria** : Gestionnaire personnel de collections de jeux et loisirs
- **Collections cibles** : Cartes MECCG, Doomtrooper, livres JdR, romans, jeux de société, figurines X-Wing
- **MVP** : Focus sur MECCG avec modèle simple (possession oui/non)
- **Source de données** : Google Sheet existant avec toutes les cartes

## Livrables Créés

### 1. Document de Vision ✅
**Fichier** : `Project follow-up/vision.md`

**Contenu** :
- Vision et problème résolu
- Utilisateur cible (mono-utilisateur MVP, multi-utilisateurs futur)
- Collections gérées (6 types, priorisées)
- Fonctionnalités principales (MVP simplifié)
- Sources de données (Google Sheet, futures intégrations)
- Bounded contexts DDD identifiés (6)
- Roadmap 6 milestones
- Critères de succès

**Highlights** :
- Application web responsive (desktop + mobile)
- Focus MVP : MECCG simple (possession oui/non, pas de quantités/états)
- Pas de visuels cartes pour MVP
- Import initial depuis Google Sheet
- Extension progressive aux autres collections

### 2. Roadmap Détaillée ✅
**Fichier** : `Project follow-up/roadmap.md`

**Structure** :
- **M1 (3-4 mois)** : MVP MECCG - En cours
- **M2 (2 mois)** : MECCG v2 (visuels, valorisation)
- **M3 (1-2 mois)** : Doomtrooper
- **M4 (2-3 mois)** : Multi-collections (livres, jeux, figurines, romans)
- **M5 (2 mois)** : Intégrations externes (Leboncoin)
- **M6 (3+ mois)** : Communauté multi-utilisateurs

**MVP M1 Détaillé** :
- Bounded contexts DDD définis
- Microservices identifiés (catalog-service, collection-service)
- Deliverables techniques listés
- Critères de succès MVP
- Sprints 1-4 planifiés (2 semaines chacun)

### 3. Spécification Technique Complète ✅
**Fichier** : `Specifications/technical/mvp-meccg-data-model.md`

**Contenu** (18 sections, ~500 lignes) :
- **Ubiquitous Language** : Card, Game, Type, Series, Rarity, Collection, Possession, Completion
- **Bounded Contexts** : Catalog, Collection Management
- **Modèle de données détaillé** :
  - Aggregate Card (Catalog)
  - Aggregate UserCollection (Collection Management)
  - Entity CardPossession
  - Value Objects (CardType, Series, Rarity, Game)
- **Schemas PostgreSQL** :
  - Tables catalog-service (games, series, cards)
  - Tables collection-service (card_possessions)
  - Indexes optimisés
- **API REST Contracts** :
  - Catalog Service : 3 endpoints
  - Collection Service : 6 endpoints
  - Formats JSON détaillés
- **Repository Interfaces** : Go interfaces complètes
- **Domain Events** : CardMarkedAsOwned, CardMarkedAsMissing (Kafka)
- **Import Google Sheet** : Process et format CSV
- **Tests TDD** : Liste complète des tests à écrire
- **Points d'attention** : Performance, scalabilité, extensibilité

## Modèle de Données Cartes (MECCG & Doomtrooper)

### Attributs d'une Carte
- **Nom anglais** : Nom original
- **Nom français** : Traduction
- **Type** : Catégorie (Personnage, Équipement, etc.)
- **Série** : Set/Extension
- **Indice de rareté** : Rareté de la carte
- **Jeu** : MECCG ou DOOMTROOPER

### Fonctionnalités MVP
1. **Catalogue complet** : Toutes les cartes MECCG
2. **Possession** : Marquer possédée/non possédée (booléen)
3. **Cartes manquantes** : Liste automatique
4. **Statistiques** :
   - Complétion globale (%)
   - Complétion par série
   - Complétion par type
   - Complétion par rareté
   - Graphiques visuels
5. **Recherche** : Par nom EN/FR, filtres (type, série, rareté, possession)

## Architecture Technique MVP

### Microservices (Go + DDD)
1. **catalog-service**
   - Bounded Context : Catalog
   - Responsabilité : Catalogue de référence des cartes
   - Base de données : PostgreSQL (games, series, cards)
   - API : GET /cards, GET /cards/{id}, GET /games/{game}/stats

2. **collection-service**
   - Bounded Context : Collection Management
   - Responsabilité : Gestion possession, statistiques
   - Base de données : PostgreSQL (card_possessions)
   - API : POST /possessions/{id}/toggle, GET /owned, GET /missing, GET /stats

### Frontend (Next.js)
- Dashboard avec statistiques
- Vue Catalogue (toutes les cartes)
- Vue "Mes cartes" (possédées)
- Vue "Cartes manquantes" (non possédées)
- Recherche unifiée avec filtres
- Toggle possession sur chaque carte
- Responsive mobile

### Communication
- REST API (OpenAPI contracts)
- Kafka events (CardMarkedAsOwned, CardMarkedAsMissing)

## Bounded Contexts DDD Identifiés

### MVP (M1)
1. **Catalog** (Core) : Catalogue de référence
2. **Collection Management** (Core) : Gestion possession
3. **Statistics** (intégré dans Collection) : Calcul complétion

### Post-MVP
4. **Valuation** (M2) : Valorisation collections
5. **Import/Export** (M2) : Import Google Sheet, CSV
6. **External Integration** (M5) : Leboncoin, eBay, etc.
7. **Identity** (M6) : Authentication, multi-users
8. **Social** (M6) : Échanges, messagerie

## Prochaines Actions

### Immédiat
1. ✅ Vision documentée
2. ✅ Roadmap créée
3. ✅ Spécification technique détaillée
4. 🔜 **Obtenir accès Google Sheet** pour analyser structure exacte
5. 🔜 Valider spécification avec utilisateur

### Sprint 1 (2 semaines suivantes)
1. Décider structure repository (monorepo vs multi-repos)
2. Setup infrastructure Docker Compose
3. Setup CI/CD GitHub Actions
4. Créer premiers ADR (Architecture Decision Records)
5. Setup microservice template Go DDD
6. Setup frontend Next.js

## Notes

### Simplifications MVP
- **Pas de quantités** : Juste possédée/non possédée
- **Pas d'états** : Pas de gestion de condition (Mint, Near Mint, etc.)
- **Pas de visuels** : Ajoutés en v2
- **Pas de valorisation** : Ajoutée en v2
- **Mono-utilisateur** : Multi-users en v6

### Extensions Futures
- **Doomtrooper** : Même modèle que MECCG (champ `game`)
- **Autres collections** : Livres JdR, Romans, Jeux, Figurines (M4)
- **Visuels** : Scraping/API pour images (M2)
- **Valorisation** : Prix et tendances (M2)
- **Leboncoin** : Alertes automatiques wishlist (M5)
- **Communauté** : Multi-users, échanges (M6)

## Statistiques

- **3 documents créés**
- **~1200 lignes de documentation**
- **6 bounded contexts identifiés**
- **2 microservices MVP**
- **9 endpoints API définis**
- **6 milestones roadmap**

## Validation Utilisateur

À valider :
- ✅ Modèle de données cartes correct ?
- ✅ Fonctionnalités MVP suffisantes ?
- ✅ Statistiques pertinentes ?
- 🔜 Accès Google Sheet pour import
- 🔜 Types de cartes MECCG exacts (Personnage, Équipement, etc.)
- 🔜 Séries MECCG exactes (METW, MELE, etc.)
- 🔜 Raretés MECCG exactes (Commune, Rare, etc.)
