# Tâches : Adaptation Spécification Technique - Données Réelles

**Date de création** : 2026-04-14  
**Statut** : Terminé  
**Priorité** : Critique

## Objectif
Analyser les données réelles des Google Sheets et adapter la spécification technique MVP en conséquence.

## Contexte

Suite au partage des Google Sheets, analyse complète de :
- **Doomtrooper** : 1055 cartes (Liste + Statistiques)
- **MECCG (SdA)** : 1678 cartes (Liste + Statistiques)
- **Total** : 2733 cartes

## Analyse des Données Réelles

### Google Sheets Analysés

**4 onglets identifiés** :
1. Liste Doomtrooper (gid=0) : 1055 cartes
2. Statistiques Doomtrooper (gid=1359250685)
3. Liste SdA/MECCG (gid=1887703243) : 1678 cartes
4. Statistiques SdA/MECCG (gid=1254914815)

### Structure Doomtrooper

**Colonnes** : Collection, Nom anglais, Nom français, Rareté, Type, Possédée, Affiliation

**Collections (7)** :
- Jeu de base (344 cartes)
- Inquisition (175)
- Warzone (131)
- Mortificator (122)
- Golgotha (80)
- Apocalypse (80)
- Paradise Lost (124)

**Types (12)** : Alliance, Bêtes, Combattant, Équipement, Fortification, Mission, Mystères, Pouvoir Ki, Relique, Spéciale, Symétrie Obscure, Zone de guerre

**Raretés** : Commune, Peu commune, Rare, C1-C3, U1-U3

**Affiliation** : Présente (Bauhaus, Capitol, Cybertronic, Imperial, Mishima, Confrérie, Légions Obscures, Cartel, etc.)

**Noms** : Tous présents en FR et EN ✅

### Structure MECCG

**Colonnes** : Collection, (vide), Nom français, Nom anglais, Rareté, Possédée, Type

**Collections (8)** :
- Against the shadow (407 cartes, pas de traduction FR)
- Les Dragons / The Dragons (660 cartes)
- Les Sorciers / The Wizards
- L'Oeil de Sauron / The Lidless Eye
- Promo
- Sombres Séides / Dark Minions
- The Balrog (pas de FR)
- The White Hand (pas de FR)

**Types hiérarchiques** (avec `/` comme séparateur) :
- Structure 3 niveaux : Héros / Ressource / Faction
- Niveau 1 : Héros, Séide, Péril, Région, Stage
- Niveau 2 : Personnage, Ressource, Site, Créature, Evènement
- Niveau 3 : Sorcier, Faction, Objet, Allié, Havre, Agent

**Raretés (30+ codes)** : C, C2-C4, U, U1-U4, R, R1-R3, F1-F5, B1-B2, CA1-CA2, CB1-CB2, S1-S2, T2-T6

**Pas d'affiliation** ❌

**Noms manquants** :
- 407 cartes sans nom français (collection "Against the shadow")
- 660 cartes sans nom anglais (collection "Les Dragons")

### Erreurs de Données Identifiées et Corrigées

#### Doomtrooper - Erreurs de Type (17 cartes)
- Ligne 859 : Type "U2" → Corrigé en "Spéciale" ✅
- Lignes 1035-1050 : Type "Warzone" → Corrigé en "Zone de guerre" ✅
- **Action** : Utilisateur a corrigé dans le Google Sheet

#### MECCG - Erreurs CSV (6 cartes)
- Lignes 344, 687, 710, 784, 1304, 1420 : Problèmes guillemets/virgules
- **Solution** : Import via XLSX ou TSV (pas CSV)

## Décisions de Design

### 1. Types Hiérarchiques MECCG
**Décision** : Parser en 3 niveaux (Level1/2/3) et stocker
- Stockage : type (complet) + type_level1 + type_level2 + type_level3
- Filtrage : Possible par niveau ou type complet
- Implémentation : Split sur " / " en Go

### 2. Raretés
**Décision** : Garder les codes tels quels (pas de normalisation)
- Stockage : String VARCHAR(50)
- Liste complète : 40+ codes différents documentés

### 3. Affiliation
**Décision** : Colonne optionnelle
- Présente uniquement pour Doomtrooper
- NULL pour MECCG
- Constraint check en base de données

### 4. Noms Manquants
**Décision** : Fallback automatique
- Si nameFR vide → copier nameEN
- Si nameEN vide → copier nameFR
- Garantit au moins un nom par carte

### 5. Collections Bilingues
**Décision** : Mapping FR ↔ EN
- Table collections avec name_en et name_fr
- Mapping explicite pour MECCG
- Recherche/filtres acceptent FR ou EN

### 6. Format Import
**Décision** : XLSX ou TSV recommandés
- Évite les problèmes de virgules dans les noms
- CSV déconseillé (échappement complexe)

## Spécification Technique v2

**Fichier créé** : `Specifications/technical/mvp-data-model-v2.md`

### Contenu (500+ lignes)

1. **Modèle de Données Unifié**
   - Aggregate Card avec tous les attributs réels
   - Value Objects : Game, CardType (parsé), Collection (bilingue)
   - Repository interfaces complètes

2. **Schemas PostgreSQL**
   - Table collections (bilingue)
   - Table cards avec type_level1/2/3
   - Indexes optimisés (full-text, hiérarchie)
   - Constraints et validations
   - Pré-remplissage des 15 collections

3. **API REST Contracts**
   - Endpoints Catalog adaptés (filtres par niveau, bilingue)
   - Endpoints Collection (inchangés)
   - Formats JSON détaillés

4. **Import de Données**
   - Process XLSX/TSV
   - Parsing des 2 formats différents
   - Transformation (fallback noms, parsing types)
   - Script Go complet

5. **Tests TDD**
   - Tests parsing types hiérarchiques
   - Tests fallback noms
   - Tests recherche bilingue
   - Tests import avec erreurs

6. **Annexes**
   - Liste complète raretés (40+ codes)
   - Liste complète collections (15)
   - Mapping collections bilingues
   - Statistiques finales

## Différences Structurelles

| Aspect | Doomtrooper | MECCG |
|--------|-------------|-------|
| Noms | Toujours FR + EN | FR ou EN (fallback) |
| Collections | Noms simples | Bilingues (mapping) |
| Types | Plats (12 types) | Hiérarchiques (3 niveaux) |
| Raretés | Simples (9 codes) | Complexes (30+ codes) |
| Affiliation | Présente | Absente |
| Nombre cartes | 1055 | 1678 |

## Changements vs Spécification v1

**Archivée** : `mvp-meccg-data-model.md` → `mvp-meccg-data-model-v1-draft.md`

**Modifications majeures** :
1. Types hiérarchiques MECCG (3 niveaux parsés)
2. Collections bilingues avec mapping
3. Affiliation optionnelle (Doomtrooper uniquement)
4. Fallback automatique pour noms manquants
5. Raretés multiples (40+ codes au lieu de 4)
6. Format import XLSX/TSV (au lieu de CSV)
7. Schemas PostgreSQL adaptés
8. API avec filtres par niveau de type
9. Recherche bilingue dans noms

## Statistiques Finales

- **Total cartes** : 2733 (1055 + 1678)
- **Collections** : 15 (7 + 8)
- **Types Doomtrooper** : 12
- **Types MECCG** : 50+ (combinaisons hiérarchiques)
- **Raretés uniques** : 40+ codes
- **Spec v2** : 500+ lignes de documentation technique

## Validation Utilisateur

Questions posées et réponses :

1. **Types MECCG hiérarchiques** : Parser en plusieurs champs ✅
2. **Codes rareté** : Garder tels quels ✅
3. **Affiliation** : Informatif uniquement ✅
4. **Erreurs de données** : Listées, utilisateur a corrigé ✅
5. **Noms manquants** : Utiliser l'autre langue par défaut ✅

## Prochaines Actions

### Immédiat
1. ✅ Spécification technique v2 créée
2. ✅ Données réelles analysées
3. ✅ Erreurs de Type corrigées par utilisateur
4. 🔜 Validation finale de la spec v2

### Sprint 1 (prochains)
1. Créer OpenAPI specs complètes (Catalog + Collection)
2. Setup PostgreSQL avec schemas v2
3. Implémentation domain layer (parsing types, fallback noms)
4. Implémentation repositories
5. Script import XLSX

## Notes

### Points Clés
- Modèle unifié malgré différences structurelles importantes
- Types MECCG : 3 niveaux stockés séparément pour filtrage
- Noms : Fallback garantit toujours au moins un nom
- Collections : Mapping bilingue pour recherche FR ou EN
- Import : XLSX évite problèmes de virgules dans noms

### Architecture Scalable
- Ajout futurs jeux facile (modèle générique)
- Ajout attributs simple (colonnes optionnelles)
- Types non hard-codés (flexibilité)
- Raretés non normalisées (garde la richesse des données)

### Qualité des Données
- 17 erreurs Type Doomtrooper : Corrigées ✅
- 6 erreurs CSV MECCG : Résolues par XLSX ✅
- 1067 noms manquants : Gérés par fallback ✅
- 2733 cartes prêtes pour import ✅
