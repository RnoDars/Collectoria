# Roadmap Collectoria

**Dernière mise à jour** : 2026-04-14  
**Version** : 1.0

## 🎯 Objectif Global

Créer un gestionnaire personnel de collections de jeux et loisirs, en commençant par les cartes MECCG.

## 📊 Vue d'Ensemble

```
MVP (M1)  →  MECCG v2 (M2)  →  Doomtrooper (M3)  →  Multi-Collections (M4)  →  Intégrations (M5)  →  Communauté (M6)
 3-4 mois      2 mois            1-2 mois            2-3 mois                  2 mois               3+ mois
```

---

## 🚀 Milestone 1 : MVP MECCG
**Durée estimée** : 3-4 mois  
**Statut** : 🔄 En cours  
**Priorité** : Critique

### Objectif
Application web responsive permettant de gérer sa collection personnelle de cartes MECCG : catalogue complet, marquage possession/manquante, statistiques de complétion, recherche et filtres. Import initial depuis Google Sheet.

### Fonctionnalités Clés
- ✅ Vision et architecture définies
- ✅ Modèle de données cartes défini
- 🔜 Infrastructure et CI/CD de base
- 🔜 Microservice Catalog (MECCG)
  - Catalogue de référence des cartes MECCG (nom EN/FR, type, série, rareté)
  - Import depuis Google Sheet
  - Recherche et filtres
  - API REST
- 🔜 Microservice Collection Management
  - Marquage possession/non-possession par carte
  - Liste cartes possédées
  - Liste cartes manquantes
  - Statistiques de complétion
  - API REST
- 🔜 Frontend Next.js
  - Dashboard avec statistiques générales
    - Complétion globale
    - Complétion par série
    - Complétion par type/rareté
    - Graphiques visuels
  - Vue catalogue MECCG (toutes les cartes)
  - Vue "Mes cartes" (possédées uniquement)
  - Vue "Cartes manquantes" (non possédées)
  - Recherche unifiée
  - Toggle possession sur chaque carte
  - Responsive mobile

### Bounded Contexts (DDD)

1. **Catalog** (MECCG) - Core Domain
   - **Aggregate Root** : Card
     - CardId (UUID)
     - NameEN (string)
     - NameFR (string)
     - Type (value object : CardType)
     - Series (value object : Series)
     - Rarity (value object : Rarity)
     - Game (MECCG | Doomtrooper)
   - **Repository** : CardRepository
   - **Services** : CardCatalogService, ImportService
   - **Microservice** : catalog-service

2. **Collection Management** - Core Domain
   - **Aggregate Root** : UserCollection
     - UserId (pour MVP = utilisateur unique)
     - Possessions : Map<CardId, bool>
   - **Entities** : CardPossession
     - CardId (référence vers Catalog)
     - Owned (bool)
   - **Repository** : CollectionRepository
   - **Services** : CollectionService, StatisticsService
   - **Domain Events** : 
     - CardMarkedAsOwned
     - CardMarkedAsMissing
   - **Microservice** : collection-service

3. **Statistics** (intégré dans Collection Management pour MVP)
   - **Value Objects** : 
     - CompletionStats
     - SeriesCompletion
     - TypeCompletion
   - **Services** : StatisticsCalculator

### Deliverables Techniques
- [ ] Setup repository (monorepo ou multi-repos)
- [ ] Docker Compose local (PostgreSQL, Kafka, services)
- [ ] CI/CD GitHub Actions (lint, test, build)
- [ ] Microservice catalog-service (Go)
  - [ ] Domain layer (DDD)
  - [ ] API REST (/api/v1/cards)
  - [ ] Tests TDD (80%+ couverture)
  - [ ] PostgreSQL schema + migrations
- [ ] Microservice collection-service (Go)
  - [ ] Domain layer (DDD)
  - [ ] API REST (/api/v1/collection, /api/v1/wishlist)
  - [ ] Tests TDD
  - [ ] PostgreSQL schema + migrations
- [ ] Frontend Next.js
  - [ ] Génération types depuis OpenAPI
  - [ ] Pages principales (dashboard, inventaire, catalogue, wishlist)
  - [ ] Composants UI de base
  - [ ] Tests Vitest + Playwright
- [ ] Import initial Google Sheets → PostgreSQL
- [ ] Documentation (ADR, README, API docs)

### Critères de Succès MVP
- ✅ Application déployée et accessible (local ou staging)
- ✅ Inventaire complet MECCG saisi et consultable
- ✅ Recherche rapide d'une carte (<5 sec)
- ✅ Wishlist fonctionnelle (ajout/consultation)
- ✅ Interface responsive utilisable sur mobile
- ✅ Tests automatisés passants (CI/CD)

---

## 🌟 Milestone 2 : MECCG v2 - Amélioration
**Durée estimée** : 2 mois  
**Statut** : 📅 Planifié  
**Priorité** : Haute

### Objectif
Enrichir l'expérience MECCG avec visuels, valorisation, et amélioration UX.

### Fonctionnalités
- [ ] **Visuels des cartes**
  - Scraping/API pour images cartes MECCG
  - Affichage dans catalogue et inventaire
  - Zoom et détails
  
- [ ] **Valorisation basique**
  - Nouveau bounded context : Valuation
  - Prix estimé par carte (saisie manuelle ou sources externes)
  - Valeur totale de collection
  - Graphiques d'évolution
  
- [ ] **Amélioration UX mobile**
  - Optimisation tactile
  - Ajout rapide à la collection (scan futur)
  - Mode consultation optimisé
  
- [ ] **Wishlist avancée**
  - Priorités
  - Budget estimé
  - Notes et rappels

### Bounded Contexts Ajoutés
4. **Valuation**
   - Aggregate : CardPrice
   - Value Object : Money
   - Microservice : valuation-service (ou intégré dans catalog)

### Critères de Succès
- ✅ Toutes les cartes ont un visuel
- ✅ Valeur totale de collection calculée
- ✅ UX mobile fluide et agréable

---

## 🎮 Milestone 3 : Doomtrooper
**Durée estimée** : 1-2 mois  
**Statut** : 📅 Planifié  
**Priorité** : Moyenne

### Objectif
Étendre le système pour gérer Doomtrooper (deuxième jeu de cartes).

### Fonctionnalités
- [ ] Extension catalog-service pour Doomtrooper
  - Nouveau type de collection dans le domaine
  - Import données Doomtrooper
  - Visuels
  
- [ ] Frontend : Support multi-jeux
  - Sélection du jeu (MECCG / Doomtrooper)
  - Filtres adaptés par jeu

### Architecture
- Pas de nouveau microservice : extension du Catalog bounded context
- Polymorphisme dans le domaine (CardGame : MECCG | Doomtrooper)

### Critères de Succès
- ✅ Collection Doomtrooper gérée comme MECCG
- ✅ Pas de régression MECCG

---

## 📚 Milestone 4 : Multi-Collections (Livres, Romans, Jeux, Figurines)
**Durée estimée** : 2-3 mois  
**Statut** : 📅 Planifié  
**Priorité** : Moyenne

### Objectif
Étendre Collectoria aux autres types de collections : livres JdR, romans, jeux de société, figurines X-Wing.

### Fonctionnalités
- [ ] **Livres de Jeux de Rôle**
  - Nouveau bounded context : RPGBooks
  - Catalogue de référence
  - Gestion éditions, gammes
  - État des livres
  
- [ ] **Romans**
  - Nouveau bounded context : Novels
  - Bibliothèque personnelle
  - Séries et auteurs
  
- [ ] **Jeux de Société**
  - Nouveau bounded context : BoardGames
  - Ludothèque avec extensions
  - État de complétion
  
- [ ] **Figurines X-Wing**
  - Nouveau bounded context : Miniatures
  - Vaisseaux et extensions
  - État de peinture

### Architecture
- Nouveaux microservices par bounded context ou extension catalog
- Frontend : Navigation par type de collection
- Pattern réutilisable pour tous types de collections

### Critères de Succès
- ✅ Les 4 types de collections supplémentaires gérés
- ✅ Navigation fluide entre collections
- ✅ Architecture scalable pour futurs types

---

## 🔗 Milestone 5 : Intégrations Externes
**Durée estimée** : 2 mois  
**Statut** : 📅 Planifié  
**Priorité** : Moyenne

### Objectif
Automatiser la recherche d'éléments manquants et la valorisation via intégrations externes.

### Fonctionnalités
- [ ] **Leboncoin Integration**
  - Nouveau bounded context : ExternalIntegration
  - Recherche automatique wishlist sur Leboncoin
  - Alertes email/notification
  - API ou scraping
  
- [ ] **eBay / PriceCharting**
  - Sources de valorisation automatique
  - Mise à jour périodique des prix
  
- [ ] **Notifications**
  - Email ou push pour alertes
  - Résumé hebdomadaire

### Architecture
- Nouveau microservice : integration-service
- Kafka events : WishlistItemAdded → ExternalSearchTriggered
- Polling ou webhooks pour sources externes

### Critères de Succès
- ✅ Alertes automatiques Leboncoin pour wishlist
- ✅ Valorisation mise à jour automatiquement
- ✅ Gain de temps significatif pour recherches

---

## 👥 Milestone 6 : Communauté (Multi-Utilisateurs)
**Durée estimée** : 3+ mois  
**Statut** : 📅 Futur  
**Priorité** : Basse (Long terme)

### Objectif
Ouvrir Collectoria à d'autres collectionneurs et créer une communauté.

### Fonctionnalités
- [ ] **Authentication & Users**
  - Nouveau bounded context : Identity
  - Inscription, login
  - Gestion comptes
  
- [ ] **Partage de Collections**
  - Collections publiques/privées
  - Profils utilisateurs
  
- [ ] **Échanges**
  - Proposition d'échanges entre collectionneurs
  - Messagerie interne
  
- [ ] **Statistiques Communautaires**
  - Collections les plus complètes
  - Cartes les plus rares possédées
  - Leaderboards

### Architecture
- Nouveau microservice : identity-service
- Nouveau microservice : social-service (échanges, messages)
- Multi-tenancy sur collection-service

### Critères de Succès
- ✅ 10+ utilisateurs actifs
- ✅ Premiers échanges réalisés via la plateforme
- ✅ Communauté engagée

---

## 📋 Prochaines Actions Immédiates

### Sprint 1 (2 semaines) - Setup Projet
1. [ ] Décider structure repository (monorepo vs multi-repos)
2. [ ] Setup infrastructure locale (Docker Compose)
3. [ ] Setup CI/CD GitHub Actions
4. [ ] Créer premiers ADR (Architecture Decision Records)
5. [ ] Setup microservice template (structure Go DDD)
6. [ ] Setup frontend Next.js avec structure

### Sprint 2 (2 semaines) - Catalog Service
1. [ ] Spec détaillée Catalog bounded context (DDD)
2. [ ] Implémenter Catalog domain layer (TDD)
3. [ ] Implémenter Catalog API REST
4. [ ] Tests d'intégration PostgreSQL
5. [ ] OpenAPI spec Catalog API

### Sprint 3 (2 semaines) - Collection Service
1. [ ] Spec détaillée Collection Management bounded context
2. [ ] Implémenter Collection domain layer (TDD)
3. [ ] Implémenter Collection API REST
4. [ ] Tests d'intégration PostgreSQL
5. [ ] OpenAPI spec Collection API

### Sprint 4 (2 semaines) - Frontend Foundation
1. [ ] Génération types TypeScript depuis OpenAPI
2. [ ] Page Dashboard
3. [ ] Page Inventaire (liste + grille)
4. [ ] Page Catalogue MECCG
5. [ ] Composants de base (Card, Table, Search)

---

## 🔄 Révisions

- **2026-04-14** : Version initiale de la roadmap (v1.0)
