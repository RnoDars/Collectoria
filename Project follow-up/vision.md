# Vision du Projet Collectoria

**Date de création** : 2026-04-14  
**Statut** : Actif  
**Version** : 1.0

## 🎯 Vision

**Collectoria est un gestionnaire personnel de collections de jeux et loisirs**, permettant d'inventorier, cataloguer, rechercher et valoriser ses collections avec une interface web responsive et conviviale.

## 🎭 Le Problème

En tant que collectionneur de jeux (cartes à collectionner, livres de JdR, jeux de société, figurines, romans), il est difficile de :
- Savoir précisément ce que l'on possède (quantité, état, édition)
- Retrouver rapidement un élément dans ses collections
- Identifier ce qu'il nous manque (wishlist)
- Estimer la valeur de nos collections
- Éviter les doublons lors d'acquisitions
- Rechercher efficacement des éléments manquants sur des plateformes comme Leboncoin

## 👤 Utilisateur Cible

**Profil principal (Phase 1)** : Arnaud, collectionneur passionné
- Collections multiples et variées
- Besoin d'organisation et de suivi
- Utilisation sur ordinateur et mobile (consultations sur place)
- Mono-utilisateur pour commencer

**Profil futur (Phase 2+)** : Communauté de collectionneurs
- Multi-utilisateurs
- Partage et échanges entre collectionneurs
- Statistiques communautaires

## 💡 La Solution

Collectoria offre :
1. **Inventaire personnalisé** par type de collection avec gestion de quantité, état, édition
2. **Catalogues de référence** pour chaque type de collection (toutes les cartes MECCG, tous les livres JdR disponibles, etc.)
3. **Recherche puissante** pour retrouver rapidement un élément
4. **Wishlist intelligente** pour gérer ce que l'on cherche
5. **Valorisation** pour suivre l'évolution de la valeur de ses collections
6. **Interface responsive** pour consultation mobile agréable

## 📚 Collections Gérées

### Phase 1 - MVP : Cartes à Collectionner
1. **MECCG (Middle Earth Collectible Cards Game)** - PRIORITÉ 1
   - Collection principale pour le MVP
   - Gestion complète des cartes (éditions, raretés, états)
   
2. **Doomtrooper** - PRIORITÉ 2
   - Deuxième jeu de cartes à collectionner

### Phase 2 : Livres et Jeux
3. **Livres de Jeux de Rôle**
   - Éditions, états, complétion de gammes
   
4. **Romans**
   - Gestion de bibliothèque personnelle

5. **Jeux de Société**
   - Ludothèque avec extensions

### Phase 3 : Figurines
6. **Figurines X-Wing**
   - Vaisseaux, extensions, état de peinture

## ✨ Fonctionnalités Principales

### MVP (MECCG) - Simplifié

**Modèle de Données Cartes** :
- **Nom anglais** : Nom original de la carte
- **Nom français** : Traduction française
- **Type** : Catégorie (Équipement, Personnage, etc.)
- **Série** : Set auquel appartient la carte
- **Indice de rareté** : Rareté de la carte

**Note** : MECCG et Doomtrooper partagent le même modèle de données.

1. **Catalogue de Référence MECCG**
   - Base de données complète des cartes MECCG
   - Informations détaillées (nom EN/FR, type, rareté, série)
   - Import depuis Google Sheet existant
   - Pas de visuels pour MVP (ajoutés en v2)

2. **Gestion Collection (Possession)**
   - Marquer une carte comme "possédée" ou "non possédée" (booléen simple)
   - Vue de toutes les cartes avec statut de possession
   - Recherche dans le catalogue

3. **Cartes Manquantes**
   - Liste automatique des cartes non possédées
   - Filtres par série, type, rareté
   - Vue "Wishlist" = Cartes manquantes

4. **Statistiques Générales**
   - Nombre total de cartes MECCG existantes
   - Nombre de cartes possédées
   - Pourcentage de complétion globale
   - Complétion par série
   - Complétion par type
   - Complétion par rareté
   - Graphiques visuels (barres, camemberts)

5. **Recherche et Filtres**
   - Recherche textuelle (nom anglais, nom français)
   - Filtres (type, rareté, série, possession)
   - Tri (nom, rareté, série)
   - Mode "Possédées" / "Manquantes" / "Toutes"

### Version 2 (Post-MVP)
6. **Import de Données**
   - Import depuis Google Sheets existants
   - Import CSV/Excel

7. **Valorisation**
   - Prix estimé par carte (sources externes)
   - Évolution de la valeur dans le temps
   - Valeur totale de la collection

8. **Intégration Leboncoin**
   - Alertes automatiques pour éléments de la wishlist
   - Recherche facilitée sur Leboncoin

### Version 3 (Future)
9. **Multi-Collections**
   - Extension aux autres types (Doomtrooper, livres JdR, etc.)
   
10. **Multi-Utilisateurs**
    - Comptes utilisateurs
    - Partage et échanges entre collectionneurs

11. **Mobile App Native**
    - Application iOS/Android dédiée

## 🗂️ Sources de Données

### Données Existantes
- **Google Sheets** : Listes complètes MECCG et Doomtrooper avec toutes les informations
  - Nom anglais
  - Nom français
  - Type
  - Série
  - Indice de rareté
  - Statut de possession (potentiellement)

### Données Externes à Rechercher (Post-MVP)
- **Visuels** : Images des cartes MECCG, Doomtrooper (v2)
- **Prix** : Sources de valorisation (v2)
- **Leboncoin API** : Pour intégration recherche automatique (v5)

### Sites Potentiels (à investiguer)
- COMC (Cardboard Connection)
- Scryfall (si similaire pour MECCG)
- Sites communautaires MECCG
- BoardGameGeek (pour jeux de société)
- PriceCharting, eBay (valorisation)

## 🎨 Expérience Utilisateur

### Web Desktop
- Interface moderne et épurée
- Navigation intuitive entre collections
- Recherche rapide accessible en permanence
- Tableaux avec tri et filtres
- Vues grille (avec visuels) et liste

### Web Mobile / Responsive
- Interface adaptée tactile
- Consultation rapide (magasins, conventions, bourses)
- Scan code-barre (futur)
- Ajout rapide à la collection
- Consultation wishlist en déplacement

## 🏗️ Architecture Technique

### Stack
- **Backend** : Microservices Go avec DDD
- **Frontend** : Next.js responsive
- **BDD** : PostgreSQL
- **Communication** : REST + Kafka

### Bounded Contexts Identifiés (DDD)

1. **Collection Management** (Core Domain)
   - Gestion de l'inventaire personnel
   - CRUD collections
   - États et quantités

2. **Catalog** (Supporting Domain)
   - Catalogues de référence par type
   - Cartes MECCG, Doomtrooper, etc.
   - Recherche dans les catalogues

3. **Wishlist** (Supporting Domain)
   - Gestion des éléments recherchés
   - Priorités et budgets

4. **Valuation** (Supporting Domain)
   - Valorisation des collections
   - Prix et tendances

5. **Import/Export** (Generic Domain)
   - Import Google Sheets, CSV
   - Export données

6. **External Integration** (Generic Domain)
   - Leboncoin, eBay, etc.
   - Sources de données externes

## 📅 Roadmap

### Milestone 1 : MVP MECCG (3-4 mois)
- ✅ Définition de la vision
- 🔄 Setup infrastructure et CI/CD
- 🔄 Microservice Catalog (MECCG)
- 🔄 Microservice Collection Management
- 🔄 Frontend : Dashboard + Inventaire + Catalogue
- 🔄 Import initial depuis Google Sheets
- 🔄 Recherche et filtres de base

### Milestone 2 : Amélioration MECCG (2 mois)
- Wishlist fonctionnelle
- Valorisation basique
- Amélioration UX mobile
- Visuels cartes MECCG

### Milestone 3 : Doomtrooper (1-2 mois)
- Extension Catalog pour Doomtrooper
- Import données Doomtrooper

### Milestone 4 : Multi-Collections (2-3 mois)
- Livres JdR
- Romans
- Jeux de société
- Figurines X-Wing

### Milestone 5 : Intégrations Externes (2 mois)
- API Leboncoin
- Alertes automatiques
- Sources de valorisation externes

### Milestone 6 : Communauté (3+ mois)
- Multi-utilisateurs
- Partage et échanges
- Statistiques communautaires

## 🎯 Critères de Succès

### MVP
- ✅ Pouvoir gérer ma collection MECCG complète
- ✅ Retrouver une carte en <5 secondes
- ✅ Savoir exactement ce que je possède
- ✅ Identifier ce qu'il me manque (wishlist)
- ✅ Interface utilisable sur mobile

### Long Terme
- Toutes mes collections gérées dans un seul outil
- Gain de temps lors d'acquisitions (pas de doublons)
- Alertes automatiques Leboncoin pour wishlist
- Valorisation précise de mes collections
- Potentiel partage avec d'autres collectionneurs

## 💭 Risques et Hypothèses

### Risques
- **Données de référence** : Difficulté à obtenir catalogues complets et visuels pour MECCG/Doomtrooper
- **Valorisation** : Marchés de niche, peu de données de prix disponibles
- **Leboncoin** : API non publique, scraping fragile

### Hypothèses à Valider
- ✅ Utilité personnelle immédiate (besoin réel)
- 🔄 Disponibilité de sources de données MECCG
- 🔄 Faisabilité technique import Google Sheets
- 🔄 Intérêt futur pour version multi-utilisateurs

## 📝 Notes

- Commencer simple (MVP MECCG mono-utilisateur)
- Itérer rapidement sur les fonctionnalités core
- Extension progressive aux autres collections
- Architecture évolutive (microservices DDD)
- Garder l'UX simple et intuitive
