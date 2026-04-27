-- Migration 010: Add D&D 5e book collection with bilingual possession
-- Description: Extends books and user_books tables for D&D 5e support and imports 53 official books
-- Date: 2026-04-27

-- ============================================================================
-- 1. EXTEND books TABLE
-- ============================================================================

ALTER TABLE books
  ADD COLUMN IF NOT EXISTS name_en   VARCHAR(255) NULL,
  ADD COLUMN IF NOT EXISTS name_fr   VARCHAR(255) NULL,
  ADD COLUMN IF NOT EXISTS edition   VARCHAR(50)  NULL;

-- Note: book_type already exists (VARCHAR(50) NOT NULL) from migration 005
-- We will use it for both collections with different values:
-- - Royaumes Oubliés: "roman", "recueil de romans"
-- - D&D 5e: "Core Rules", "Supplément de règles", "Setting", "Campagnes", "Recueil d'aventures", "Starter Set"

-- Index sur edition pour filtrage D&D 5e
CREATE INDEX IF NOT EXISTS idx_books_edition ON books(edition);
-- Index sur book_type pour filtrage par catégorie D&D
CREATE INDEX IF NOT EXISTS idx_books_book_type ON books(book_type);

-- Comments
COMMENT ON COLUMN books.name_en IS 'English title for D&D 5 books. NULL for non-D&D collections.';
COMMENT ON COLUMN books.name_fr IS 'French title for D&D 5 books. NULL for non-D&D collections.';
COMMENT ON COLUMN books.edition IS 'Fixed value "D&D 5" for D&D books. NULL for non-D&D collections.';

-- ============================================================================
-- 2. EXTEND user_books TABLE — possession bilingue
-- ============================================================================

ALTER TABLE user_books
  ADD COLUMN IF NOT EXISTS owned_en BOOLEAN NULL,
  ADD COLUMN IF NOT EXISTS owned_fr BOOLEAN NULL;

-- Index pour filtrage "possédé EN" et "possédé FR"
CREATE INDEX IF NOT EXISTS idx_user_books_owned_en ON user_books(user_id, owned_en);
CREATE INDEX IF NOT EXISTS idx_user_books_owned_fr ON user_books(user_id, owned_fr);

-- Comments
COMMENT ON COLUMN user_books.owned_en IS 'English version owned — D&D 5 only. NULL for non-D&D collections.';
COMMENT ON COLUMN user_books.owned_fr IS 'French version owned — D&D 5 only. NULL for non-D&D collections.';

-- ============================================================================
-- 3. INSERT D&D 5e COLLECTION
-- ============================================================================

INSERT INTO collections (id, name, slug, category, total_cards, description, created_at, updated_at)
VALUES (
    '33333333-3333-3333-3333-333333333333',
    'D&D 5e',
    'dnd5',
    'jeux-de-role',
    53,
    'Livres officiels de Dungeons & Dragons 5ème édition publiés par Wizards of the Coast',
    NOW(),
    NOW()
) ON CONFLICT (id) DO NOTHING;

-- ============================================================================
-- 4. INSERT 53 D&D 5e BOOKS
-- ============================================================================

-- Note:
-- - title = name_en (to satisfy NOT NULL constraint)
-- - name_fr = NULL for non-translated books
-- - edition = 'D&D 5' for all books
-- - author = 'Wizards of the Coast' for all books
-- - publication_date = NULL (not available in source data)

INSERT INTO books (id, collection_id, number, title, name_en, name_fr, author, publication_date, edition, book_type) VALUES

-- Core Rules (4 books)
(gen_random_uuid(), '33333333-3333-3333-3333-333333333333', 'PHB2014', 'Player''s Handbook - 2014', 'Player''s Handbook - 2014', 'Player''s Handbook - 2014', 'Wizards of the Coast', '2014-01-01', 'D&D 5', 'Core Rules'),
(gen_random_uuid(), '33333333-3333-3333-3333-333333333333', 'MM2014', 'Monster Manual - 2014', 'Monster Manual - 2014', 'Monster Manual - 2014', 'Wizards of the Coast', '2014-01-01', 'D&D 5', 'Core Rules'),
(gen_random_uuid(), '33333333-3333-3333-3333-333333333333', 'DMG2014', 'Dungeon master''s guide - 2014', 'Dungeon master''s guide - 2014', 'Dungeon master''s guide - 2014', 'Wizards of the Coast', '2014-01-01', 'D&D 5', 'Core Rules'),
(gen_random_uuid(), '33333333-3333-3333-3333-333333333333', 'DMG2024', 'Dungeon master''s guide - 2024', 'Dungeon master''s guide - 2024', 'Guide du maître - 2024', 'Wizards of the Coast', '2024-01-01', 'D&D 5', 'Core Rules'),
(gen_random_uuid(), '33333333-3333-3333-3333-333333333333', 'PHB2024', 'Player''s Handbook - 2024', 'Player''s Handbook - 2024', 'Manuel des joueurs - 2024', 'Wizards of the Coast', '2024-01-01', 'D&D 5', 'Core Rules'),
(gen_random_uuid(), '33333333-3333-3333-3333-333333333333', 'MM2024', 'Monster Manual - 2024', 'Monster Manual - 2024', 'Manuel des monstres - 2024', 'Wizards of the Coast', '2024-01-01', 'D&D 5', 'Core Rules'),

-- Starter Set (4 books)
(gen_random_uuid(), '33333333-3333-3333-3333-333333333333', 'LMoP', 'Starter Set: Lost mine of Phandelver', 'Starter Set: Lost mine of Phandelver', 'Kit d''Initiation', 'Wizards of the Coast', '2014-01-01', 'D&D 5', 'Starter Set'),
(gen_random_uuid(), '33333333-3333-3333-3333-333333333333', 'EK', 'Essentiels Kit', 'Essentiels Kit', 'L''Essentiel', 'Wizards of the Coast', '2019-01-01', 'D&D 5', 'Starter Set'),
(gen_random_uuid(), '33333333-3333-3333-3333-333333333333', 'DoSI', 'Starter Set: Dragons of Stormwreck Isl', 'Starter Set: Dragons of Stormwreck Isl', 'Starter Set: Les dragons de l''île aux Tempêtes', 'Wizards of the Coast', '2022-01-01', 'D&D 5', 'Starter Set'),
(gen_random_uuid(), '33333333-3333-3333-3333-333333333333', 'HotB', 'Starter Set: Heroes of the Borderlands', 'Starter Set: Heroes of the Borderlands', NULL, 'Wizards of the Coast', '2024-01-01', 'D&D 5', 'Starter Set'),

-- Suppléments de règles (8 books)
(gen_random_uuid(), '33333333-3333-3333-3333-333333333333', 'VGtM', 'Volo''s Guide to Monsters', 'Volo''s Guide to Monsters', NULL, 'Wizards of the Coast', '2016-01-01', 'D&D 5', 'Supplément de règles'),
(gen_random_uuid(), '33333333-3333-3333-3333-333333333333', 'XGtE', 'Xanathar''s Guide to Everything', 'Xanathar''s Guide to Everything', 'Le Guide Complet de Xanathar', 'Wizards of the Coast', '2017-01-01', 'D&D 5', 'Supplément de règles'),
(gen_random_uuid(), '33333333-3333-3333-3333-333333333333', 'MToF', 'Mordenkeinen''s Tome of Foes', 'Mordenkeinen''s Tome of Foes', NULL, 'Wizards of the Coast', '2018-01-01', 'D&D 5', 'Supplément de règles'),
(gen_random_uuid(), '33333333-3333-3333-3333-333333333333', 'TCoE', 'Tasha''s Cauldron of Everything', 'Tasha''s Cauldron of Everything', 'Le chaudron des merveilles de Tasha', 'Wizards of the Coast', '2020-01-01', 'D&D 5', 'Supplément de règles'),
(gen_random_uuid(), '33333333-3333-3333-3333-333333333333', 'FToD', 'Fizban''s Treasury of Dragons', 'Fizban''s Treasury of Dragons', 'Le Trésor Draconique de Fizban', 'Wizards of the Coast', '2021-01-01', 'D&D 5', 'Supplément de règles'),
(gen_random_uuid(), '33333333-3333-3333-3333-333333333333', 'MotM', 'Monsters of the Multiverse', 'Monsters of the Multiverse', 'Les Monstres du Multivers', 'Wizards of the Coast', '2022-01-01', 'D&D 5', 'Supplément de règles'),
(gen_random_uuid(), '33333333-3333-3333-3333-333333333333', 'BGG', 'Bigby presents: Glory of the Giants', 'Bigby presents: Glory of the Giants', 'Bigby présente La Gloire des Géant', 'Wizards of the Coast', '2023-01-01', 'D&D 5', 'Supplément de règles'),
(gen_random_uuid(), '33333333-3333-3333-3333-333333333333', 'BMT', 'The book of many things', 'The book of many things', NULL, 'Wizards of the Coast', '2023-01-01', 'D&D 5', 'Supplément de règles'),

-- Setting (10 books)
(gen_random_uuid(), '33333333-3333-3333-3333-333333333333', 'SCAG', 'Sword Coast Adventurer''s Guide', 'Sword Coast Adventurer''s Guide', 'Le Guide des Aventuriers de la Côte des Épées', 'Wizards of the Coast', '2015-01-01', 'D&D 5', 'Setting'),
(gen_random_uuid(), '33333333-3333-3333-3333-333333333333', 'GGtR', 'Guildemasters Guide to Ravnica', 'Guildemasters Guide to Ravnica', NULL, 'Wizards of the Coast', '2018-01-01', 'D&D 5', 'Setting'),
(gen_random_uuid(), '33333333-3333-3333-3333-333333333333', 'AI', 'Acquisition Incorporated', 'Acquisition Incorporated', NULL, 'Wizards of the Coast', '2019-01-01', 'D&D 5', 'Setting'),
(gen_random_uuid(), '33333333-3333-3333-3333-333333333333', 'ERftLW', 'Eberron : Rising from the Last war', 'Eberron : Rising from the Last war', NULL, 'Wizards of the Coast', '2019-01-01', 'D&D 5', 'Setting'),
(gen_random_uuid(), '33333333-3333-3333-3333-333333333333', 'EGtW', 'Explorer''s guide to Wildemount', 'Explorer''s guide to Wildemount', NULL, 'Wizards of the Coast', '2020-01-01', 'D&D 5', 'Setting'),
(gen_random_uuid(), '33333333-3333-3333-3333-333333333333', 'MOoT', 'Mythic Odysses of Theros', 'Mythic Odysses of Theros', NULL, 'Wizards of the Coast', '2020-01-01', 'D&D 5', 'Setting'),
(gen_random_uuid(), '33333333-3333-3333-3333-333333333333', 'VRGtR', 'Van richten''s Guide to Ravenloft', 'Van richten''s Guide to Ravenloft', 'Le Guide de Van Richten sur Ravenloft', 'Wizards of the Coast', '2021-01-01', 'D&D 5', 'Setting'),
(gen_random_uuid(), '33333333-3333-3333-3333-333333333333', 'SaCoC', 'Strixhaven : A curriculum of Chaos', 'Strixhaven : A curriculum of Chaos', NULL, 'Wizards of the Coast', '2021-01-01', 'D&D 5', 'Setting'),
(gen_random_uuid(), '33333333-3333-3333-3333-333333333333', 'SjAiS', 'Spelljammer : Adventures in Space', 'Spelljammer : Adventures in Space', NULL, 'Wizards of the Coast', '2022-01-01', 'D&D 5', 'Setting'),
(gen_random_uuid(), '33333333-3333-3333-3333-333333333333', 'PAtM', 'Planescape: Adventures in the Multiverse', 'Planescape: Adventures in the Multiverse', NULL, 'Wizards of the Coast', '2023-01-01', 'D&D 5', 'Setting'),
(gen_random_uuid(), '33333333-3333-3333-3333-333333333333', 'EFotA', 'Eberron: Forge ot the Artificer', 'Eberron: Forge ot the Artificer', NULL, 'Wizards of the Coast', '2024-01-01', 'D&D 5', 'Setting'),

-- Campagnes (18 books)
(gen_random_uuid(), '33333333-3333-3333-3333-333333333333', 'BGDiA', 'Baldur''s Gate: Descent into Avernus', 'Baldur''s Gate: Descent into Avernus', 'La Porte de Baldur : Descente en Averne', 'Wizards of the Coast', '2019-01-01', 'D&D 5', 'Campagnes'),
(gen_random_uuid(), '33333333-3333-3333-3333-333333333333', 'HotDQ', 'Hoard of the Dragon Queen', 'Hoard of the Dragon Queen', NULL, 'Wizards of the Coast', '2014-01-01', 'D&D 5', 'Campagnes'),
(gen_random_uuid(), '33333333-3333-3333-3333-333333333333', 'RoT', 'The rise of Tiamat', 'The rise of Tiamat', NULL, 'Wizards of the Coast', '2014-01-01', 'D&D 5', 'Campagnes'),
(gen_random_uuid(), '33333333-3333-3333-3333-333333333333', 'PotA', 'Princes of Apocalypse', 'Princes of Apocalypse', NULL, 'Wizards of the Coast', '2015-01-01', 'D&D 5', 'Campagnes'),
(gen_random_uuid(), '33333333-3333-3333-3333-333333333333', 'OotA', 'Out of the Abyss', 'Out of the Abyss', NULL, 'Wizards of the Coast', '2015-01-01', 'D&D 5', 'Campagnes'),
(gen_random_uuid(), '33333333-3333-3333-3333-333333333333', 'CoS', 'Curse of Strahd', 'Curse of Strahd', 'La Malédiction de Strahd', 'Wizards of the Coast', '2016-01-01', 'D&D 5', 'Campagnes'),
(gen_random_uuid(), '33333333-3333-3333-3333-333333333333', 'SKT', 'Storm King''s Thunder', 'Storm King''s Thunder', NULL, 'Wizards of the Coast', '2016-01-01', 'D&D 5', 'Campagnes'),
(gen_random_uuid(), '33333333-3333-3333-3333-333333333333', 'ToA', 'Tomb of Annihilation', 'Tomb of Annihilation', 'La tombe de l''annihilation ', 'Wizards of the Coast', '2017-01-01', 'D&D 5', 'Campagnes'),
(gen_random_uuid(), '33333333-3333-3333-3333-333333333333', 'WDotMM', 'Waterdeep: Dungeon of the Mad Mage', 'Waterdeep: Dungeon of the Mad Mage', 'Le Donjon du Mage Dément', 'Wizards of the Coast', '2018-01-01', 'D&D 5', 'Campagnes'),
(gen_random_uuid(), '33333333-3333-3333-3333-333333333333', 'ToD', 'Tyranny of Dragons', 'Tyranny of Dragons', NULL, 'Wizards of the Coast', '2019-01-01', 'D&D 5', 'Campagnes'),
(gen_random_uuid(), '33333333-3333-3333-3333-333333333333', 'RotF', 'Rime of the Frostmaiden', 'Rime of the Frostmaiden', NULL, 'Wizards of the Coast', '2020-01-01', 'D&D 5', 'Campagnes'),
(gen_random_uuid(), '33333333-3333-3333-3333-333333333333', 'WBtW', 'The Wild beyond the Witchlight', 'The Wild beyond the Witchlight', 'Par-delà le Carnaval de Sorcelume', 'Wizards of the Coast', '2021-01-01', 'D&D 5', 'Campagnes'),
(gen_random_uuid(), '33333333-3333-3333-3333-333333333333', 'CotN', 'Call of the Netherdeep', 'Call of the Netherdeep', NULL, 'Wizards of the Coast', '2022-01-01', 'D&D 5', 'Campagnes'),
(gen_random_uuid(), '33333333-3333-3333-3333-333333333333', 'DSotDQ', 'Dragonlance: Shadow of the Dragon Queen', 'Dragonlance: Shadow of the Dragon Queen', 'Dragonlance - L''ombre de la reine de dragons', 'Wizards of the Coast', '2022-01-01', 'D&D 5', 'Campagnes'),
(gen_random_uuid(), '33333333-3333-3333-3333-333333333333', 'PaBtSO', 'Phandelver and Below: The Shattered Obelisk', 'Phandelver and Below: The Shattered Obelisk', 'Les tréfonds de Phancreux - L''Obélisque brisé', 'Wizards of the Coast', '2023-01-01', 'D&D 5', 'Campagnes'),
(gen_random_uuid(), '33333333-3333-3333-3333-333333333333', 'VEoR', 'Vecna: Eve of Ruin', 'Vecna: Eve of Ruin', 'Vecna: Au Seuil du Néant', 'Wizards of the Coast', '2024-01-01', 'D&D 5', 'Campagnes'),
(gen_random_uuid(), '33333333-3333-3333-3333-333333333333', 'WDH', 'Waterdeep: Dragon Heist', 'Waterdeep: Dragon Heist', 'Waterdeep - Le Vol des Dragons', 'Wizards of the Coast', '2018-01-01', 'D&D 5', 'Campagnes'),

-- Recueil d'aventures (9 books)
(gen_random_uuid(), '33333333-3333-3333-3333-333333333333', 'KftGV', 'Keys from the Golden Vault', 'Keys from the Golden Vault', 'Les clés du verrou d''or', 'Wizards of the Coast', '2023-01-01', 'D&D 5', 'Recueil d''aventures'),
(gen_random_uuid(), '33333333-3333-3333-3333-333333333333', 'TftYP', 'Tales from the Yawning Portal', 'Tales from the Yawning Portal', 'Les Contes du Portail Béant', 'Wizards of the Coast', '2017-01-01', 'D&D 5', 'Recueil d''aventures'),
(gen_random_uuid(), '33333333-3333-3333-3333-333333333333', 'GoS', 'Ghosts of Saltmarsh', 'Ghosts of Saltmarsh', NULL, 'Wizards of the Coast', '2019-01-01', 'D&D 5', 'Recueil d''aventures'),
(gen_random_uuid(), '33333333-3333-3333-3333-333333333333', 'CM', 'Candelkeep Mysteries', 'Candelkeep Mysteries', NULL, 'Wizards of the Coast', '2021-01-01', 'D&D 5', 'Recueil d''aventures'),
(gen_random_uuid(), '33333333-3333-3333-3333-333333333333', 'JttRC', 'Journeys through the Radiant Citadel', 'Journeys through the Radiant Citadel', 'Horizons de la Citadelle Radieuse', 'Wizards of the Coast', '2022-01-01', 'D&D 5', 'Recueil d''aventures'),
(gen_random_uuid(), '33333333-3333-3333-3333-333333333333', 'QftIS', 'Quests from the infinite Staircase', 'Quests from the infinite Staircase', NULL, 'Wizards of the Coast', '2024-01-01', 'D&D 5', 'Recueil d''aventures'),
(gen_random_uuid(), '33333333-3333-3333-3333-333333333333', 'DD', 'Dragon Delves', 'Dragon Delves', NULL, 'Wizards of the Coast', '2024-01-01', 'D&D 5', 'Recueil d''aventures');

-- ============================================================================
-- 5. INSERT USER POSSESSIONS (36 entries: 19 FR + 17 EN)
-- ============================================================================

-- Note: Using user_id = '00000000-0000-0000-0000-000000000001' (dev user)
-- For D&D 5e: is_owned = false, owned_en and owned_fr reflect actual ownership

-- Livres possédés FR uniquement (owned_fr = Oui, owned_en = Non)
INSERT INTO user_books (user_id, book_id, is_owned, owned_en, owned_fr, created_at, updated_at)
SELECT
    '00000000-0000-0000-0000-000000000001' as user_id,
    b.id as book_id,
    false as is_owned,
    false as owned_en,
    true as owned_fr,
    NOW() as created_at,
    NOW() as updated_at
FROM books b
WHERE b.collection_id = '33333333-3333-3333-3333-333333333333'
AND b.number IN (
    'PHB2014', 'MM2014', 'DMG2014',  -- Core Rules FR
    'XGtE', 'FToD', 'MotM', 'BGG',   -- Suppléments FR
    'SCAG', 'VRGtR',                  -- Setting FR
    'CoS', 'ToA', 'WDotMM', 'WBtW', 'DSotDQ', 'PaBtSO', 'VEoR',  -- Campagnes FR
    'JttRC',                          -- Recueil FR
    'EK', 'DoSI'                      -- Starter Set FR
);

-- Livres possédés EN uniquement (owned_en = Oui, owned_fr = Non)
INSERT INTO user_books (user_id, book_id, is_owned, owned_en, owned_fr, created_at, updated_at)
SELECT
    '00000000-0000-0000-0000-000000000001' as user_id,
    b.id as book_id,
    false as is_owned,
    true as owned_en,
    false as owned_fr,
    NOW() as created_at,
    NOW() as updated_at
FROM books b
WHERE b.collection_id = '33333333-3333-3333-3333-333333333333'
AND b.number IN (
    'BGDiA',                                  -- Campagnes EN
    'MToF', 'TCoE',                           -- Suppléments EN
    'GGtR', 'AI', 'ERftLW', 'EGtW', 'MOoT',  -- Setting EN
    'HotDQ', 'RoT', 'PotA', 'OotA', 'RotF', 'CotN', 'WDH',  -- Campagnes EN
    'TftYP', 'GoS'                            -- Recueil EN
);

-- ============================================================================
-- 6. UPDATE total_cards COUNT
-- ============================================================================

UPDATE collections
SET total_cards = (SELECT COUNT(*) FROM books WHERE collection_id = '33333333-3333-3333-3333-333333333333')
WHERE id = '33333333-3333-3333-3333-333333333333';
