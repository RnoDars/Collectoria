# Spécification Technique : MVP Collectoria - Modèle de Données v2

**Date** : 2026-04-14  
**Version** : 2.0 (Basée sur analyse des données réelles)  
**Statut** : Validé  
**Auteur** : Alfred (Agent de Dispatch) + Agent Spécifications

---

## Vue d'ensemble

Cette spécification définit le modèle de données pour le MVP de Collectoria, basé sur l'analyse des **données réelles** des Google Sheets :
- **Doomtrooper** : 1055 cartes
- **MECCG (SdA)** : 1678 cartes

Le modèle gère les différences structurelles entre les deux jeux tout en maintenant une architecture unifiée.

---

## Contexte Métier

### Ubiquitous Language (DDD)

- **Card** (Carte) : Carte de référence du catalogue complet
- **Game** (Jeu) : Jeu de cartes à collectionner (MECCG, Doomtrooper)
- **Collection** (Série) : Extension/Set du jeu (bilingue : FR et EN)
- **Type** : Catégorie de carte (simple pour Doomtrooper, hiérarchique pour MECCG)
- **Rarity** (Rareté) : Indice de rareté (codes multiples)
- **Affiliation** : Faction d'une carte (Doomtrooper uniquement)
- **Possession** : Fait de posséder ou non une carte
- **Owned** (Possédée) : Booléen indiquant la possession

### Bounded Contexts

1. **Catalog** : Catalogue de référence des cartes (toutes les cartes existantes)
2. **Collection Management** : Gestion de la collection personnelle (possession)

---

## Analyse des Données Réelles

### Doomtrooper (1055 cartes)

**Structure Google Sheet** :
```
Collection, Nom anglais, Nom français, Rareté, Type, Possédée, Affiliation
```

**Collections** (7) :
- Jeu de base (344 cartes)
- Inquisition (175 cartes)
- Warzone (131 cartes)
- Mortificator (122 cartes)
- Golgotha (80 cartes)
- Apocalypse (80 cartes)
- Paradise Lost (124 cartes)

**Types** (12) :
- Alliance
- Bêtes
- Combattant
- Équipement
- Fortification
- Mission
- Mystères
- Pouvoir Ki
- Relique
- Spéciale
- Symétrie Obscure
- Zone de guerre

**Raretés** :
- Commune, Peu commune, Rare (noms complets)
- C1, C2, C3 (communes niveau 1-3)
- U1, U2, U3 (peu communes niveau 1-3)

**Affiliation** (présente) : Bauhaus, Capitol, Cybertronic, Imperial, Mishima, Confrérie, Légions Obscures, Cartel, Templiers, etc.

**Noms** : Tous présents en français ET anglais ✅

### MECCG - SdA (1678 cartes)

**Structure Google Sheet** :
```
Collection, (vide), Nom français, Nom anglais, Rareté, Possédée, Type
```

**Collections** (8) :
- Against the shadow / (pas de traduction FR) (407 cartes)
- Les Dragons / The Dragons (660 cartes)
- Les Sorciers / The Wizards
- L'Oeil de Sauron / The Lidless Eye
- Promo
- Sombres Séides / Dark Minions
- The Balrog
- The White Hand

**Types hiérarchiques** (avec `/` comme séparateur) :
- `Héros / Personnage`
- `Héros / Personnage / Sorcier`
- `Héros / Ressource / Faction`
- `Héros / Ressource / Objet`
- `Héros / Ressource / Allié`
- `Héros / Ressource / Evènement`
- `Héros / Site`
- `Héros / Site / Havre`
- `Péril / Créature`
- `Péril / Evènement`
- `Séide / Personnage`
- `Séide / Personnage / Agent`
- `Séide / Ressource / Faction`
- `Région`
- etc.

**Structure hiérarchique** :
- **Niveau 1** : Héros / Séide / Péril / Région / Stage
- **Niveau 2** : Personnage / Ressource / Site / Créature / Evènement
- **Niveau 3** : Sorcier / Faction / Objet / Allié / Havre / Agent

**Raretés** (30+ codes) :
- **Simples** : C, U, R
- **Numérotées** : C2-C4, U1-U4, R1-R3
- **Fixed** : F1-F5
- **Booster** : B1-B2
- **Variants** : CA1-CA2, CB1-CB2
- **Special** : S1-S2, T2-T6

**Affiliation** : Non présente ❌

**Noms manquants** :
- **407 cartes sans nom français** (collection "Against the shadow") → Utiliser nom anglais par défaut
- **660 cartes sans nom anglais** (collection "Les Dragons" principalement) → Utiliser nom français par défaut

---

## Modèle de Données Unifié

### Aggregate : Card (Catalog Bounded Context)

**Description** : Une carte de référence dans le catalogue complet.

#### Attributs

| Attribut | Type | Obligatoire | Description |
|----------|------|-------------|-------------|
| `id` | UUID | Oui | Identifiant unique |
| `game` | Enum | Oui | Jeu (MECCG, DOOMTROOPER) |
| `collectionEN` | String | Oui | Nom anglais de la série/collection |
| `collectionFR` | String | Optionnel | Nom français de la série/collection |
| `nameEN` | String | Conditionnellement obligatoire | Nom anglais de la carte |
| `nameFR` | String | Conditionnellement obligatoire | Nom français de la carte |
| `rarity` | String | Oui | Code de rareté (tel quel) |
| `type` | String | Oui | Type de carte (string complet) |
| `typeParsed` | String[] | Optionnel | Type parsé en niveaux (MECCG uniquement) |
| `affiliation` | String | Optionnel | Affiliation (Doomtrooper uniquement) |
| `createdAt` | Timestamp | Oui | Date de création |
| `updatedAt` | Timestamp | Oui | Date de mise à jour |

#### Invariants (Business Rules)

1. **Au moins un nom** : `nameEN` OU `nameFR` doit être renseigné
2. **Nom par défaut** :
   - Si `nameFR` vide → `nameFR = nameEN`
   - Si `nameEN` vide → `nameEN = nameFR`
3. **Type parsé MECCG** : Si `game = MECCG` ET `type` contient `/`, parser en `typeParsed`
4. **Affiliation** : Uniquement pour `game = DOOMTROOPER`
5. **Unicité** : (`game`, `nameEN`, `collectionEN`) doit être unique

#### Value Objects

##### Game
```go
type Game string

const (
    GameMECCG       Game = "MECCG"
    GameDoomtrooper Game = "DOOMTROOPER"
)
```

##### CardType (MECCG - parsé)
```go
type CardType struct {
    Full    string   // Type complet : "Héros / Ressource / Faction"
    Level1  string   // "Héros"
    Level2  string   // "Ressource"
    Level3  string   // "Faction"
}

// Parsing
func ParseCardType(typeStr string, game Game) CardType {
    if game != GameMECCG || !strings.Contains(typeStr, "/") {
        return CardType{Full: typeStr}
    }
    
    parts := strings.Split(typeStr, " / ")
    ct := CardType{Full: typeStr}
    
    if len(parts) >= 1 {
        ct.Level1 = strings.TrimSpace(parts[0])
    }
    if len(parts) >= 2 {
        ct.Level2 = strings.TrimSpace(parts[1])
    }
    if len(parts) >= 3 {
        ct.Level3 = strings.TrimSpace(parts[2])
    }
    
    return ct
}
```

##### Collection (bilingue)
```go
type Collection struct {
    NameEN  string
    NameFR  string
    Game    Game
}

// Mapping FR ↔ EN pour MECCG
var MECCGCollectionMapping = map[string]string{
    "Les Sorciers": "The Wizards",
    "The Wizards": "Les Sorciers",
    "L'Oeil de Sauron": "The Lidless Eye",
    "The Lidless Eye": "L'Oeil de Sauron",
    "Les Dragons": "The Dragons",
    "The Dragons": "Les Dragons",
    "Sombres Séides": "Dark Minions",
    "Dark Minions": "Sombres Séides",
    // Against the shadow : pas de traduction FR
    // The Balrog : pas de traduction FR
    // The White Hand : pas de traduction FR
    // Promo : pas de traduction
}
```

#### Repository Interface

```go
type CardRepository interface {
    // Création
    Create(ctx context.Context, card *Card) error
    CreateBulk(ctx context.Context, cards []*Card) error
    
    // Lecture
    FindByID(ctx context.Context, id uuid.UUID) (*Card, error)
    FindByGame(ctx context.Context, game Game) ([]*Card, error)
    FindAll(ctx context.Context) ([]*Card, error)
    
    // Recherche et filtres
    Search(ctx context.Context, query SearchQuery) ([]*Card, error)
    
    // Statistiques catalogue
    CountByGame(ctx context.Context, game Game) (int, error)
    CountByCollection(ctx context.Context, game Game) (map[string]int, error)
    
    // Mise à jour
    Update(ctx context.Context, card *Card) error
    
    // Suppression (rare)
    Delete(ctx context.Context, id uuid.UUID) error
}

type SearchQuery struct {
    Game          *Game
    
    // Recherche noms (bilingue)
    SearchText    *string  // Recherche dans nameEN OU nameFR
    NameEN        *string  // Recherche partielle nameEN
    NameFR        *string  // Recherche partielle nameFR
    
    // Filtres
    Collection    *string  // EN ou FR acceptés
    Type          *string  // Type complet ou niveau (MECCG)
    TypeLevel1    *string  // MECCG uniquement
    TypeLevel2    *string  // MECCG uniquement
    TypeLevel3    *string  // MECCG uniquement
    Rarity        *string
    Affiliation   *string  // Doomtrooper uniquement
    
    // Pagination et tri
    Limit         int
    Offset        int
    OrderBy       string   // "nameEN", "nameFR", "collection", "rarity"
    OrderDir      string   // "ASC", "DESC"
}
```

---

## Schema PostgreSQL - Catalog Service

### Tables

```sql
-- Enum des jeux
CREATE TYPE game_type AS ENUM ('MECCG', 'DOOMTROOPER');

-- Table des collections (séries)
CREATE TABLE collections (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    game game_type NOT NULL,
    name_en VARCHAR(255) NOT NULL,
    name_fr VARCHAR(255),
    created_at TIMESTAMP NOT NULL DEFAULT NOW(),
    
    UNIQUE(game, name_en)
);

-- Index
CREATE INDEX idx_collections_game ON collections(game);
CREATE INDEX idx_collections_name_fr ON collections(name_fr) WHERE name_fr IS NOT NULL;

-- Pré-remplissage Doomtrooper
INSERT INTO collections (game, name_en, name_fr) VALUES 
    ('DOOMTROOPER', 'Jeu de base', 'Jeu de base'),
    ('DOOMTROOPER', 'Inquisition', 'Inquisition'),
    ('DOOMTROOPER', 'Warzone', 'Warzone'),
    ('DOOMTROOPER', 'Mortificator', 'Mortificator'),
    ('DOOMTROOPER', 'Golgotha', 'Golgotha'),
    ('DOOMTROOPER', 'Apocalypse', 'Apocalypse'),
    ('DOOMTROOPER', 'Paradise Lost', 'Paradise Lost');

-- Pré-remplissage MECCG
INSERT INTO collections (game, name_en, name_fr) VALUES 
    ('MECCG', 'Against the shadow', NULL),
    ('MECCG', 'The Dragons', 'Les Dragons'),
    ('MECCG', 'The Wizards', 'Les Sorciers'),
    ('MECCG', 'The Lidless Eye', 'L''Oeil de Sauron'),
    ('MECCG', 'Promo', 'Promo'),
    ('MECCG', 'Dark Minions', 'Sombres Séides'),
    ('MECCG', 'The Balrog', NULL),
    ('MECCG', 'The White Hand', NULL);

-- Table des cartes
CREATE TABLE cards (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    game game_type NOT NULL,
    collection_id UUID NOT NULL REFERENCES collections(id),
    
    -- Noms bilingues
    name_en VARCHAR(500) NOT NULL,
    name_fr VARCHAR(500) NOT NULL,  -- Rempli avec name_en si absent
    
    -- Type
    type VARCHAR(500) NOT NULL,
    type_level1 VARCHAR(255),  -- MECCG uniquement (Héros, Séide, Péril, etc.)
    type_level2 VARCHAR(255),  -- MECCG uniquement (Personnage, Ressource, Site, etc.)
    type_level3 VARCHAR(255),  -- MECCG uniquement (Sorcier, Faction, Objet, etc.)
    
    -- Rareté
    rarity VARCHAR(50) NOT NULL,
    
    -- Affiliation (Doomtrooper uniquement)
    affiliation VARCHAR(255),
    
    -- Métadonnées
    created_at TIMESTAMP NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMP NOT NULL DEFAULT NOW(),
    
    -- Contraintes
    UNIQUE(game, name_en, collection_id),
    CHECK (
        (game = 'DOOMTROOPER' AND affiliation IS NOT NULL) OR
        (game = 'MECCG' AND affiliation IS NULL)
    )
);

-- Indexes pour performances
CREATE INDEX idx_cards_game ON cards(game);
CREATE INDEX idx_cards_collection ON cards(collection_id);
CREATE INDEX idx_cards_name_en ON cards(name_en);
CREATE INDEX idx_cards_name_fr ON cards(name_fr);
CREATE INDEX idx_cards_type ON cards(type);
CREATE INDEX idx_cards_type_level1 ON cards(type_level1) WHERE type_level1 IS NOT NULL;
CREATE INDEX idx_cards_type_level2 ON cards(type_level2) WHERE type_level2 IS NOT NULL;
CREATE INDEX idx_cards_rarity ON cards(rarity);
CREATE INDEX idx_cards_affiliation ON cards(affiliation) WHERE affiliation IS NOT NULL;

-- Full-text search (recherche bilingue)
CREATE INDEX idx_cards_name_en_trgm ON cards USING gin(name_en gin_trgm_ops);
CREATE INDEX idx_cards_name_fr_trgm ON cards USING gin(name_fr gin_trgm_ops);

-- Extension nécessaire pour full-text
CREATE EXTENSION IF NOT EXISTS pg_trgm;
```

---

## Modèle de Données - Collection Management

### Aggregate : UserCollection

**Inchangé depuis v1**, voir spécification précédente.

### Entity : CardPossession

| Attribut | Type | Obligatoire | Description |
|----------|------|-------------|-------------|
| `userId` | UUID | Oui | ID de l'utilisateur (MVP = constante) |
| `cardId` | UUID | Oui | ID de la carte (référence Catalog) |
| `owned` | Boolean | Oui | true = possédée, false = non possédée |
| `markedAt` | Timestamp | Oui | Date du marquage |

### Schema PostgreSQL - Collection Service

```sql
-- Inchangé depuis v1
CREATE TABLE card_possessions (
    user_id UUID NOT NULL,
    card_id UUID NOT NULL,
    owned BOOLEAN NOT NULL DEFAULT false,
    marked_at TIMESTAMP NOT NULL DEFAULT NOW(),
    
    PRIMARY KEY (user_id, card_id)
);

CREATE INDEX idx_possessions_user ON card_possessions(user_id);
CREATE INDEX idx_possessions_owned ON card_possessions(user_id, owned);
```

---

## API REST Contracts

### Catalog Service - `/api/v1/catalog`

#### GET `/api/v1/catalog/cards`
Récupérer la liste des cartes avec filtres

**Query Parameters** :
- `game` : MECCG | DOOMTROOPER
- `search` : Recherche dans nameEN OU nameFR (full-text)
- `nameEN` : Recherche partielle nom anglais
- `nameFR` : Recherche partielle nom français
- `collection` : Nom de collection (EN ou FR acceptés)
- `type` : Type complet ou partiel
- `typeLevel1` : Niveau 1 (MECCG uniquement)
- `typeLevel2` : Niveau 2 (MECCG uniquement)
- `typeLevel3` : Niveau 3 (MECCG uniquement)
- `rarity` : Rareté (code exact)
- `affiliation` : Affiliation (Doomtrooper uniquement)
- `limit` : Nombre de résultats (default: 100, max: 1000)
- `offset` : Pagination
- `orderBy` : nameEN | nameFR | collection | rarity | type
- `orderDir` : ASC | DESC

**Response** :
```json
{
  "data": [
    {
      "id": "uuid",
      "game": "MECCG",
      "collection": {
        "nameEN": "The Wizards",
        "nameFR": "Les Sorciers"
      },
      "nameEN": "Gandalf",
      "nameFR": "Gandalf",
      "type": {
        "full": "Héros / Personnage / Sorcier",
        "level1": "Héros",
        "level2": "Personnage",
        "level3": "Sorcier"
      },
      "rarity": "R2",
      "affiliation": null,
      "createdAt": "2026-04-14T10:00:00Z"
    },
    {
      "id": "uuid",
      "game": "DOOMTROOPER",
      "collection": {
        "nameEN": "Jeu de base",
        "nameFR": "Jeu de base"
      },
      "nameEN": "Alakai the cunning",
      "nameFR": "Alakhaï le rusé",
      "type": {
        "full": "Combattant"
      },
      "rarity": "Rare",
      "affiliation": "Légions Obscures",
      "createdAt": "2026-04-14T10:00:00Z"
    }
  ],
  "pagination": {
    "total": 2733,
    "limit": 100,
    "offset": 0
  }
}
```

#### GET `/api/v1/catalog/games/{game}/stats`
Statistiques du catalogue

**Response** :
```json
{
  "game": "MECCG",
  "totalCards": 1678,
  "collectionsCount": 8,
  "byCollection": {
    "Against the shadow": 407,
    "The Dragons": 660
  },
  "byType": {
    "Héros / Personnage": 150,
    "Héros / Ressource / Faction": 80
  },
  "byTypeLevel1": {
    "Héros": 800,
    "Séide": 500,
    "Péril": 300
  },
  "byRarity": {
    "C": 500,
    "U": 600,
    "R": 400,
    "F1": 50
  }
}
```

### Collection Service - `/api/v1/collection`

**Inchangé depuis v1**, voir spécification précédente pour :
- POST `/possessions/{cardId}/toggle`
- GET `/owned`
- GET `/missing`
- GET `/stats`

---

## Import de Données

### Format Recommandé

**XLSX (Excel)** ou **TSV (Tab Separated Values)**

**Raison** : Les noms de cartes contiennent des virgules (ex: "Burning Rick, Tree and Thatch"), ce qui casse le format CSV standard.

### Process d'Import

1. **Export depuis Google Sheets**
   - Fichier → Télécharger → Microsoft Excel (.xlsx)
   - Ou : Fichier → Télécharger → Valeurs séparées par des tabulations (.tsv)

2. **Parsing**
   - Go library : `excelize` (XLSX) ou standard `encoding/csv` avec `\t` separator (TSV)

3. **Transformation**
   - Nom par défaut : Si `nameFR` vide → copier `nameEN`, et vice-versa
   - Type parsing MECCG : Parser hiérarchie avec `/`
   - Collection mapping : Mapper noms FR ↔ EN
   - Validation : Vérifier invariants

4. **Insertion**
   - Bulk insert dans PostgreSQL
   - Transaction pour rollback en cas d'erreur
   - Rapport d'import (succès, erreurs, warnings)

### Mapping des Colonnes

#### Doomtrooper
```
Google Sheet Column → Database Column
Collection          → collection_id (lookup)
Nom anglais         → name_en
Nom français        → name_fr
Rareté              → rarity
Type                → type
Possédée            → (vers collection_possessions)
Affiliation         → affiliation
```

#### MECCG
```
Google Sheet Column → Database Column
Collection          → collection_id (lookup)
(colonne vide)      → ignorée
Nom français        → name_fr (ou name_en si vide)
Nom anglais         → name_en (ou name_fr si vide)
Rareté              → rarity
Possédée            → (vers collection_possessions)
Type                → type + parsing vers type_level1/2/3
```

### Script d'Import (Go)

```go
type ImportService struct {
    cardRepo       CardRepository
    collectionRepo CollectionRepository
    possessionRepo CollectionRepository
}

func (s *ImportService) ImportFromXLSX(filePath string, game Game) (*ImportReport, error) {
    // 1. Ouvrir fichier XLSX
    f, err := excelize.OpenFile(filePath)
    if err != nil {
        return nil, err
    }
    
    // 2. Lire lignes
    rows, err := f.GetRows("Sheet1")
    if err != nil {
        return nil, err
    }
    
    report := &ImportReport{}
    
    // 3. Parser et transformer
    for i, row := range rows {
        if i == 0 {
            continue // skip header
        }
        
        card, possession, err := s.parseRow(row, game)
        if err != nil {
            report.Errors = append(report.Errors, ImportError{
                Line: i+1,
                Error: err.Error(),
            })
            continue
        }
        
        // 4. Valider
        if err := card.Validate(); err != nil {
            report.Errors = append(report.Errors, ImportError{
                Line: i+1,
                Error: err.Error(),
            })
            continue
        }
        
        // 5. Insérer
        if err := s.cardRepo.Create(ctx, card); err != nil {
            report.Errors = append(report.Errors, ImportError{
                Line: i+1,
                Error: err.Error(),
            })
            continue
        }
        
        // 6. Possession
        if possession != nil {
            s.possessionRepo.MarkAsOwned(ctx, possession.UserID, card.ID)
        }
        
        report.Success++
    }
    
    return report, nil
}

func (s *ImportService) parseRow(row []string, game Game) (*Card, *CardPossession, error) {
    card := &Card{
        ID:   uuid.New(),
        Game: game,
    }
    
    var owned bool
    
    if game == GameDoomtrooper {
        // Doomtrooper format
        card.CollectionEN = row[0]
        card.NameEN = row[1]
        card.NameFR = row[2]
        card.Rarity = row[3]
        card.Type = row[4]
        owned = (row[5] == "Oui")
        card.Affiliation = &row[6]
        
    } else if game == GameMECCG {
        // MECCG format
        card.CollectionEN = row[0]
        // row[1] vide
        card.NameFR = row[2]
        card.NameEN = row[3]
        card.Rarity = row[4]
        owned = (row[5] == "Oui")
        card.Type = row[6]
        
        // Fallback noms
        if card.NameFR == "" {
            card.NameFR = card.NameEN
        }
        if card.NameEN == "" {
            card.NameEN = card.NameFR
        }
        
        // Parser type hiérarchique
        card.TypeParsed = ParseCardType(card.Type, game)
    }
    
    // Lookup collection
    collection, err := s.collectionRepo.FindByName(ctx, card.Game, card.CollectionEN)
    if err != nil {
        return nil, nil, err
    }
    card.CollectionID = collection.ID
    
    var possession *CardPossession
    if owned {
        possession = &CardPossession{
            UserID: DefaultUserID,
            CardID: card.ID,
            Owned:  true,
        }
    }
    
    return card, possession, nil
}
```

---

## Tests TDD

### Tests Catalog Service

#### Tests Unitaires (Domain)
- ✅ Parsing types MECCG hiérarchiques
- ✅ Fallback nom FR → EN et EN → FR
- ✅ Validation invariants (au moins un nom)
- ✅ Collection mapping bilingue

#### Tests d'Intégration (Repository)
- ✅ CRUD cartes Doomtrooper
- ✅ CRUD cartes MECCG avec types parsés
- ✅ Recherche full-text bilingue (nameEN + nameFR)
- ✅ Filtres par type hiérarchique (level1, level2, level3)
- ✅ Filtres par collection (EN ou FR)
- ✅ Filtres par affiliation (Doomtrooper)

#### Tests Import
- ✅ Import XLSX Doomtrooper
- ✅ Import XLSX MECCG avec noms manquants
- ✅ Import avec erreurs (rapport d'erreurs)
- ✅ Rollback en cas d'échec partiel

---

## Points d'Attention

### Différences Structurelles

| Aspect | Doomtrooper | MECCG |
|--------|-------------|-------|
| Noms | Toujours FR + EN | FR ou EN (fallback) |
| Collections | Noms simples | Bilingues (mapping) |
| Types | Plats (12 types) | Hiérarchiques (3 niveaux) |
| Raretés | Simples (9 codes) | Complexes (30+ codes) |
| Affiliation | Présente | Absente |
| Nombre cartes | 1055 | 1678 |

### Performance

- **Index full-text** : Essentiels pour recherche bilingue (pg_trgm)
- **Index hiérarchie** : type_level1, type_level2, type_level3 pour MECCG
- **Cache** : Considérer Redis pour statistiques (recalculées souvent)

### Extensibilité

- **Modèle générique** : Supporte les 2 jeux malgré différences
- **Types dynamiques** : Pas de enum hard-codé (flexibilité)
- **Collections bilingues** : Mapping extensible pour nouveaux jeux
- **Ajout attributs** : Facile (ex: image_url en v2)

### Format Import

- **XLSX recommandé** : Évite problèmes virgules dans noms
- **TSV acceptable** : Alternative plus légère
- **CSV déconseillé** : Nécessite échappement complexe des virgules

---

## Prochaines Étapes

1. ✅ Validation du modèle de données (fait)
2. 🔜 Création OpenAPI specs complètes (Catalog + Collection)
3. 🔜 Setup PostgreSQL schemas et migrations
4. 🔜 Implémentation domain layer (TDD)
5. 🔜 Implémentation repositories (TDD)
6. 🔜 Implémentation API handlers (TDD)
7. 🔜 Script d'import XLSX/TSV
8. 🔜 Tests E2E complets

---

## Annexes

### Liste Complète des Raretés MECCG

```
C, C2, C3, C4
U, U1, U2, U3, U4
R, R1, R2, R3
F1, F2, F3, F4, F5
B1, B2
CA1, CA2
CB1, CB2
S1, S2
T2, T3, T4, T6
```

### Liste Complète des Collections

**Doomtrooper** :
- Jeu de base
- Inquisition
- Warzone
- Mortificator
- Golgotha
- Apocalypse
- Paradise Lost

**MECCG** :
- Against the shadow (pas de FR)
- The Dragons / Les Dragons
- The Wizards / Les Sorciers
- The Lidless Eye / L'Oeil de Sauron
- Promo
- Dark Minions / Sombres Séides
- The Balrog (pas de FR)
- The White Hand (pas de FR)

### Statistiques Finales

- **Total cartes** : 2733 (1055 Doomtrooper + 1678 MECCG)
- **Collections** : 15 (7 Doomtrooper + 8 MECCG)
- **Types Doomtrooper** : 12
- **Types MECCG** : 50+ (combinaisons hiérarchiques)
- **Raretés** : 40+ codes uniques
