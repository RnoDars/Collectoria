# Spécification Technique : MVP MECCG - Modèle de Données

**Date** : 2026-04-14  
**Version** : 1.0  
**Statut** : Draft  
**Auteur** : Agent Spécifications

---

## Vue d'ensemble

Cette spécification définit le modèle de données pour le MVP de Collectoria, centré sur la gestion de collections de cartes MECCG (Middle Earth Collectible Cards Game). Le modèle est conçu pour être extensible à Doomtrooper qui partage la même structure.

## Contexte Métier

### Ubiquitous Language (DDD)

- **Card** (Carte) : Carte de référence du catalogue complet
- **Game** (Jeu) : Jeu de cartes à collectionner (MECCG, Doomtrooper)
- **Type** : Catégorie de carte (Personnage, Équipement, etc.)
- **Series** (Série) : Set/Extension auquel appartient la carte
- **Rarity** (Rareté) : Indice de rareté de la carte
- **Collection** : Ensemble des cartes d'un utilisateur
- **Possession** : Fait de posséder ou non une carte spécifique
- **Completion** (Complétion) : Pourcentage de cartes possédées par rapport au total

### Bounded Contexts

Ce modèle couvre deux bounded contexts :
1. **Catalog** : Catalogue de référence des cartes
2. **Collection Management** : Gestion de la collection personnelle

---

## Modèle de Données - Catalog Bounded Context

### Aggregate : Card

**Description** : Une carte de référence dans le catalogue complet d'un jeu.

#### Attributs

| Attribut | Type | Obligatoire | Description |
|----------|------|-------------|-------------|
| `id` | UUID | Oui | Identifiant unique de la carte |
| `game` | Enum | Oui | Jeu (MECCG, DOOMTROOPER) |
| `nameEN` | String | Oui | Nom anglais de la carte |
| `nameFR` | String | Oui | Nom français de la carte |
| `type` | String | Oui | Type de carte (Personnage, Équipement, etc.) |
| `series` | String | Oui | Série/Set de la carte |
| `rarity` | String | Oui | Indice de rareté |
| `createdAt` | Timestamp | Oui | Date de création dans le système |
| `updatedAt` | Timestamp | Oui | Date de dernière mise à jour |

#### Invariants (Business Rules)

- `nameEN` ne peut pas être vide
- `nameFR` ne peut pas être vide
- `type` doit exister dans la liste des types valides
- `series` doit exister dans la liste des séries valides
- `rarity` doit exister dans la liste des raretés valides
- La combinaison (`game`, `nameEN`, `series`) doit être unique

#### Value Objects

##### CardType
```go
type CardType string

const (
    CardTypeCharacter   CardType = "PERSONNAGE"
    CardTypeEquipment   CardType = "EQUIPEMENT"
    CardTypeEvent       CardType = "EVENEMENT"
    CardTypeResource    CardType = "RESSOURCE"
    // À compléter avec les types réels MECCG
)
```

##### Series
```go
type Series struct {
    Code string  // Ex: "METW", "MELE"
    Name string  // Ex: "The Wizards", "The Lidless Eye"
    Game Game
    ReleaseDate time.Time
}
```

##### Rarity
```go
type Rarity string

const (
    RarityCommon    Rarity = "COMMUNE"
    RarityUncommon  Rarity = "PEU_COMMUNE"
    RarityRare      Rarity = "RARE"
    RarityUltraRare Rarity = "ULTRA_RARE"
    // À compléter avec les raretés réelles MECCG
)
```

##### Game
```go
type Game string

const (
    GameMECCG       Game = "MECCG"
    GameDoomtrooper Game = "DOOMTROOPER"
)
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
    CountBySeries(ctx context.Context, game Game) (map[string]int, error)
    
    // Mise à jour
    Update(ctx context.Context, card *Card) error
    
    // Suppression (rare)
    Delete(ctx context.Context, id uuid.UUID) error
}

type SearchQuery struct {
    Game       *Game
    NameEN     *string  // Recherche partielle
    NameFR     *string  // Recherche partielle
    Type       *CardType
    Series     *string
    Rarity     *Rarity
    Limit      int
    Offset     int
    OrderBy    string  // "nameEN", "nameFR", "series", "rarity"
    OrderDir   string  // "ASC", "DESC"
}
```

### Schema PostgreSQL - Catalog Service

```sql
-- Table des jeux
CREATE TABLE games (
    code VARCHAR(50) PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT NOW()
);

INSERT INTO games (code, name) VALUES 
    ('MECCG', 'Middle Earth Collectible Cards Game'),
    ('DOOMTROOPER', 'Doomtrooper');

-- Table des séries
CREATE TABLE series (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    game_code VARCHAR(50) NOT NULL REFERENCES games(code),
    code VARCHAR(50) NOT NULL,
    name VARCHAR(255) NOT NULL,
    release_date DATE,
    created_at TIMESTAMP NOT NULL DEFAULT NOW(),
    UNIQUE(game_code, code)
);

-- Table des cartes (catalogue de référence)
CREATE TABLE cards (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    game_code VARCHAR(50) NOT NULL REFERENCES games(code),
    name_en VARCHAR(255) NOT NULL,
    name_fr VARCHAR(255) NOT NULL,
    type VARCHAR(100) NOT NULL,
    series_id UUID NOT NULL REFERENCES series(id),
    rarity VARCHAR(50) NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMP NOT NULL DEFAULT NOW(),
    
    UNIQUE(game_code, name_en, series_id)
);

-- Indexes pour performances
CREATE INDEX idx_cards_game ON cards(game_code);
CREATE INDEX idx_cards_name_en ON cards(name_en);
CREATE INDEX idx_cards_name_fr ON cards(name_fr);
CREATE INDEX idx_cards_type ON cards(type);
CREATE INDEX idx_cards_series ON cards(series_id);
CREATE INDEX idx_cards_rarity ON cards(rarity);
CREATE INDEX idx_cards_name_en_trgm ON cards USING gin(name_en gin_trgm_ops);
CREATE INDEX idx_cards_name_fr_trgm ON cards USING gin(name_fr gin_trgm_ops);
```

---

## Modèle de Données - Collection Management Bounded Context

### Aggregate : UserCollection

**Description** : Collection personnelle d'un utilisateur, contenant les cartes qu'il possède.

#### Attributs

| Attribut | Type | Obligatoire | Description |
|----------|------|-------------|-------------|
| `userId` | UUID | Oui | ID de l'utilisateur (pour MVP = constante) |
| `game` | Enum | Oui | Jeu concerné |
| `possessions` | Map<UUID, bool> | Oui | Map cardId → owned |
| `createdAt` | Timestamp | Oui | Date de création |
| `updatedAt` | Timestamp | Oui | Date de dernière mise à jour |

#### Entity : CardPossession

**Description** : Représente le fait de posséder ou non une carte spécifique.

| Attribut | Type | Obligatoire | Description |
|----------|------|-------------|-------------|
| `userId` | UUID | Oui | ID de l'utilisateur |
| `cardId` | UUID | Oui | ID de la carte (référence Catalog) |
| `owned` | Boolean | Oui | true = possédée, false = non possédée |
| `markedAt` | Timestamp | Oui | Date du marquage |

#### Invariants (Business Rules)

- Une carte ne peut être marquée qu'une seule fois par utilisateur
- `cardId` doit exister dans le Catalog bounded context
- Par défaut, toutes les cartes sont considérées comme non possédées (owned = false)

#### Domain Events

```go
// Event publié sur Kafka lors du marquage d'une carte comme possédée
type CardMarkedAsOwned struct {
    EventID     uuid.UUID
    UserID      uuid.UUID
    CardID      uuid.UUID
    Game        Game
    MarkedAt    time.Time
    OccurredAt  time.Time
}

// Event publié lors du marquage d'une carte comme non possédée
type CardMarkedAsMissing struct {
    EventID     uuid.UUID
    UserID      uuid.UUID
    CardID      uuid.UUID
    Game        Game
    MarkedAt    time.Time
    OccurredAt  time.Time
}
```

#### Repository Interface

```go
type CollectionRepository interface {
    // Possession
    MarkAsOwned(ctx context.Context, userID, cardID uuid.UUID) error
    MarkAsMissing(ctx context.Context, userID, cardID uuid.UUID) error
    TogglePossession(ctx context.Context, userID, cardID uuid.UUID) (bool, error)
    
    // Lecture
    IsOwned(ctx context.Context, userID, cardID uuid.UUID) (bool, error)
    GetOwnedCards(ctx context.Context, userID uuid.UUID, game Game) ([]uuid.UUID, error)
    GetMissingCards(ctx context.Context, userID uuid.UUID, game Game) ([]uuid.UUID, error)
    GetAllPossessions(ctx context.Context, userID uuid.UUID, game Game) (map[uuid.UUID]bool, error)
    
    // Statistiques
    GetStats(ctx context.Context, userID uuid.UUID, game Game) (*CollectionStats, error)
}

type CollectionStats struct {
    TotalCards      int
    OwnedCards      int
    MissingCards    int
    CompletionRate  float64  // Pourcentage (0-100)
    
    // Par série
    SeriesStats     map[string]SeriesStats
    
    // Par type
    TypeStats       map[string]TypeStats
    
    // Par rareté
    RarityStats     map[string]RarityStats
}

type SeriesStats struct {
    SeriesName      string
    TotalCards      int
    OwnedCards      int
    CompletionRate  float64
}

type TypeStats struct {
    TypeName        string
    TotalCards      int
    OwnedCards      int
    CompletionRate  float64
}

type RarityStats struct {
    RarityName      string
    TotalCards      int
    OwnedCards      int
    CompletionRate  float64
}
```

### Schema PostgreSQL - Collection Service

```sql
-- Table des possessions utilisateur
CREATE TABLE card_possessions (
    user_id UUID NOT NULL,  -- Pour MVP = constante
    card_id UUID NOT NULL,  -- Référence vers catalog-service.cards
    owned BOOLEAN NOT NULL DEFAULT false,
    marked_at TIMESTAMP NOT NULL DEFAULT NOW(),
    
    PRIMARY KEY (user_id, card_id)
);

-- Indexes pour performances
CREATE INDEX idx_possessions_user ON card_possessions(user_id);
CREATE INDEX idx_possessions_owned ON card_possessions(user_id, owned);

-- Note : card_id référence catalog-service.cards mais pas de FK car microservices séparés
-- La cohérence est assurée au niveau applicatif
```

---

## API REST Contracts

### Catalog Service - `/api/v1/catalog`

#### GET `/api/v1/catalog/cards`
Récupérer la liste des cartes avec filtres

**Query Parameters** :
- `game` : MECCG | DOOMTROOPER
- `nameEN` : Recherche partielle nom anglais
- `nameFR` : Recherche partielle nom français
- `type` : Type de carte
- `series` : Série
- `rarity` : Rareté
- `limit` : Nombre de résultats (default: 100, max: 1000)
- `offset` : Pagination
- `orderBy` : nameEN | nameFR | series | rarity
- `orderDir` : ASC | DESC

**Response** :
```json
{
  "data": [
    {
      "id": "uuid",
      "game": "MECCG",
      "nameEN": "Gandalf",
      "nameFR": "Gandalf",
      "type": "PERSONNAGE",
      "series": "METW",
      "rarity": "RARE",
      "createdAt": "2026-04-14T10:00:00Z",
      "updatedAt": "2026-04-14T10:00:00Z"
    }
  ],
  "pagination": {
    "total": 500,
    "limit": 100,
    "offset": 0
  }
}
```

#### GET `/api/v1/catalog/cards/{cardId}`
Récupérer une carte par ID

**Response** :
```json
{
  "id": "uuid",
  "game": "MECCG",
  "nameEN": "Gandalf",
  "nameFR": "Gandalf",
  "type": "PERSONNAGE",
  "series": "METW",
  "rarity": "RARE",
  "createdAt": "2026-04-14T10:00:00Z",
  "updatedAt": "2026-04-14T10:00:00Z"
}
```

#### GET `/api/v1/catalog/games/{game}/stats`
Statistiques du catalogue pour un jeu

**Response** :
```json
{
  "game": "MECCG",
  "totalCards": 500,
  "seriesCount": 10,
  "typeCount": 5,
  "bySeries": {
    "METW": 150,
    "MELE": 120
  },
  "byType": {
    "PERSONNAGE": 200,
    "EQUIPEMENT": 150
  },
  "byRarity": {
    "COMMUNE": 250,
    "RARE": 100
  }
}
```

### Collection Service - `/api/v1/collection`

#### POST `/api/v1/collection/possessions/{cardId}/toggle`
Toggle la possession d'une carte

**Request Body** : Aucun

**Response** :
```json
{
  "cardId": "uuid",
  "owned": true,
  "markedAt": "2026-04-14T15:30:00Z"
}
```

#### PUT `/api/v1/collection/possessions/{cardId}`
Marquer explicitement une carte comme possédée ou non

**Request Body** :
```json
{
  "owned": true
}
```

**Response** :
```json
{
  "cardId": "uuid",
  "owned": true,
  "markedAt": "2026-04-14T15:30:00Z"
}
```

#### GET `/api/v1/collection/possessions`
Récupérer toutes les possessions

**Query Parameters** :
- `game` : MECCG | DOOMTROOPER
- `owned` : true | false (filtrer possédées ou manquantes)

**Response** :
```json
{
  "game": "MECCG",
  "possessions": {
    "card-uuid-1": true,
    "card-uuid-2": false,
    "card-uuid-3": true
  }
}
```

#### GET `/api/v1/collection/owned`
Liste des cartes possédées (avec détails depuis Catalog)

**Query Parameters** :
- `game` : MECCG | DOOMTROOPER
- Filtres identiques à catalog/cards

**Response** : Identique à catalog/cards mais uniquement les cartes possédées

#### GET `/api/v1/collection/missing`
Liste des cartes manquantes (avec détails depuis Catalog)

**Query Parameters** :
- `game` : MECCG | DOOMTROOPER
- Filtres identiques à catalog/cards

**Response** : Identique à catalog/cards mais uniquement les cartes non possédées

#### GET `/api/v1/collection/stats`
Statistiques de complétion de la collection

**Query Parameters** :
- `game` : MECCG | DOOMTROOPER

**Response** :
```json
{
  "game": "MECCG",
  "totalCards": 500,
  "ownedCards": 350,
  "missingCards": 150,
  "completionRate": 70.0,
  "seriesStats": [
    {
      "seriesName": "METW - The Wizards",
      "totalCards": 150,
      "ownedCards": 120,
      "completionRate": 80.0
    }
  ],
  "typeStats": [
    {
      "typeName": "PERSONNAGE",
      "totalCards": 200,
      "ownedCards": 150,
      "completionRate": 75.0
    }
  ],
  "rarityStats": [
    {
      "rarityName": "RARE",
      "totalCards": 100,
      "ownedCards": 60,
      "completionRate": 60.0
    }
  ]
}
```

---

## Import Google Sheet

### Process

1. **Export Google Sheet en CSV**
   - Format attendu : `game,nameEN,nameFR,type,series,rarity`

2. **Script d'import** (Go)
   - Lecture CSV
   - Validation des données
   - Création des séries si non existantes
   - Bulk insert des cartes
   - Rapport d'import (succès, erreurs)

3. **API Import** (optionnel, pour v2)
   - POST `/api/v1/catalog/import`
   - Upload CSV
   - Traitement asynchrone
   - Webhook ou polling pour status

### Format CSV Attendu

```csv
game,nameEN,nameFR,type,series,rarity
MECCG,Gandalf,Gandalf,PERSONNAGE,METW,RARE
MECCG,Glamdring,Glamdring,EQUIPEMENT,METW,UNCOMMON
DOOMTROOPER,Mitch Hunter,Mitch Hunter,PERSONNAGE,Base Set,RARE
```

---

## Tests TDD

### Tests Catalog Service

#### Tests Unitaires (Domain)
- ✅ Création d'une Card valide
- ✅ Validation des invariants (nameEN/FR non vides)
- ✅ Unicité (game, nameEN, series)
- ✅ Value Objects (CardType, Rarity, Series, Game)

#### Tests d'Intégration (Repository)
- ✅ CRUD cartes dans PostgreSQL
- ✅ Recherche avec filtres multiples
- ✅ Pagination et tri
- ✅ Recherche full-text (nom EN/FR)
- ✅ Comptage par série/type/rareté

#### Tests API (Handlers)
- ✅ GET /cards avec divers filtres
- ✅ GET /cards/{id}
- ✅ GET /games/{game}/stats
- ✅ Validation des query parameters
- ✅ Codes HTTP appropriés

### Tests Collection Service

#### Tests Unitaires (Domain)
- ✅ Toggle possession
- ✅ Calcul statistiques de complétion
- ✅ Events domain (CardMarkedAsOwned, CardMarkedAsMissing)

#### Tests d'Intégration (Repository)
- ✅ Mark as owned/missing
- ✅ Toggle possession
- ✅ Récupération cartes possédées/manquantes
- ✅ Calcul statistiques (globales, par série, type, rareté)

#### Tests API (Handlers)
- ✅ POST /possessions/{cardId}/toggle
- ✅ PUT /possessions/{cardId}
- ✅ GET /owned avec filtres
- ✅ GET /missing avec filtres
- ✅ GET /stats

#### Tests E2E
- ✅ Import CSV → Catalog → Toggle possession → Stats
- ✅ Recherche cartes manquantes après marquage

---

## Points d'Attention

### Performance
- **Index PostgreSQL** : Essentiels pour recherches rapides (full-text sur noms)
- **Pagination** : Obligatoire pour grandes collections (500+ cartes)
- **Cache** : Envisager Redis pour statistiques (calculées souvent)

### Scalabilité
- **Database per Service** : catalog-service et collection-service ont chacun leur PostgreSQL
- **Pas de FK inter-services** : Cohérence assurée applicativement
- **Events Kafka** : Pour communication asynchrone si besoin

### Extensibilité
- **Modèle générique** : Identique pour MECCG et Doomtrooper (champ `game`)
- **Types dynamiques** : Types, séries, raretés non hard-codés (tables référence)
- **Ajout attributs** : Facile d'ajouter des champs (ex: image_url en v2)

### Sécurité (pour multi-users v2+)
- **Authentication** : JWT pour identifier l'utilisateur
- **Authorization** : Un utilisateur ne peut modifier que sa collection
- **Rate Limiting** : Prévenir abus API

---

## Prochaines Étapes

1. ✅ Validation du modèle avec utilisateur
2. 🔜 Création OpenAPI specs complètes
3. 🔜 Setup PostgreSQL schemas et migrations
4. 🔜 Implémentation domain layer (TDD)
5. 🔜 Implémentation repositories (TDD)
6. 🔜 Implémentation API handlers (TDD)
7. 🔜 Script d'import Google Sheet
8. 🔜 Tests E2E complets
