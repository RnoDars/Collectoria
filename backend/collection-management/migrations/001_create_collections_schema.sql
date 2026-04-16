-- Migration 001: Création du schéma des collections

-- Table des collections (séries de cartes)
CREATE TABLE IF NOT EXISTS collections (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(255) NOT NULL,
    slug VARCHAR(255) NOT NULL UNIQUE,
    category VARCHAR(100) NOT NULL,
    total_cards INTEGER NOT NULL DEFAULT 0,
    description TEXT,
    created_at TIMESTAMP NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMP NOT NULL DEFAULT NOW()
);

-- Index sur les collections
CREATE INDEX idx_collections_slug ON collections(slug);
CREATE INDEX idx_collections_category ON collections(category);

-- Table des cartes
CREATE TABLE IF NOT EXISTS cards (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    collection_id UUID NOT NULL REFERENCES collections(id) ON DELETE CASCADE,
    name_en VARCHAR(500) NOT NULL,
    name_fr VARCHAR(500) NOT NULL,
    card_type VARCHAR(500) NOT NULL,
    series VARCHAR(255) NOT NULL,
    rarity VARCHAR(50) NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMP NOT NULL DEFAULT NOW()
);

-- Index sur les cartes
CREATE INDEX idx_cards_collection_id ON cards(collection_id);
CREATE INDEX idx_cards_name_en ON cards(name_en);
CREATE INDEX idx_cards_name_fr ON cards(name_fr);
CREATE INDEX idx_cards_card_type ON cards(card_type);
CREATE INDEX idx_cards_series ON cards(series);
CREATE INDEX idx_cards_rarity ON cards(rarity);

-- Table des collections utilisateur
CREATE TABLE IF NOT EXISTS user_collections (
    user_id UUID NOT NULL,
    collection_id UUID NOT NULL REFERENCES collections(id) ON DELETE CASCADE,
    created_at TIMESTAMP NOT NULL DEFAULT NOW(),
    PRIMARY KEY (user_id, collection_id)
);

-- Index sur user_collections
CREATE INDEX idx_user_collections_user_id ON user_collections(user_id);

-- Table des cartes possédées par les utilisateurs
CREATE TABLE IF NOT EXISTS user_cards (
    user_id UUID NOT NULL,
    card_id UUID NOT NULL REFERENCES cards(id) ON DELETE CASCADE,
    is_owned BOOLEAN NOT NULL DEFAULT false,
    acquired_at TIMESTAMP,
    created_at TIMESTAMP NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMP NOT NULL DEFAULT NOW(),
    PRIMARY KEY (user_id, card_id)
);

-- Index sur user_cards
CREATE INDEX idx_user_cards_user_id ON user_cards(user_id);
CREATE INDEX idx_user_cards_is_owned ON user_cards(user_id, is_owned);
