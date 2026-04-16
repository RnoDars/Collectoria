-- Seed Data: 40 cartes MECCG mock
-- Couvre toutes les dimensions: types hiérarchiques, séries, raretés, possession

-- User fictif
DO $$
BEGIN
    -- User ID fictif pour le MVP
    -- 00000000-0000-0000-0000-000000000001
END $$;

-- Collection MECCG
INSERT INTO collections (id, name, slug, category, total_cards, description, created_at, updated_at)
VALUES (
    '11111111-1111-1111-1111-111111111111',
    'Middle-earth CCG',
    'meccg',
    'Fantasy',
    40,
    'The definitive Middle-earth trading card game',
    NOW(),
    NOW()
) ON CONFLICT (slug) DO NOTHING;

-- User collection (associer l'utilisateur à la collection MECCG)
INSERT INTO user_collections (user_id, collection_id, created_at)
VALUES (
    '00000000-0000-0000-0000-000000000001',
    '11111111-1111-1111-1111-111111111111',
    NOW()
) ON CONFLICT (user_id, collection_id) DO NOTHING;

-- 40 cartes MECCG avec dimensions variées
-- Format: name_en, name_fr, card_type, series, rarity, is_owned

-- Série: The Wizards (10 cartes)
INSERT INTO cards (id, collection_id, name_en, name_fr, card_type, series, rarity, created_at, updated_at) VALUES
('c0000001-0001-0001-0001-000000000001', '11111111-1111-1111-1111-111111111111', 'Gandalf the Grey', 'Gandalf le Gris', 'Héros / Personnage / Sorcier', 'The Wizards', 'R1', NOW(), NOW()),
('c0000002-0002-0002-0002-000000000002', '11111111-1111-1111-1111-111111111111', 'Aragorn II', 'Aragorn II', 'Héros / Personnage', 'The Wizards', 'R2', NOW(), NOW()),
('c0000003-0003-0003-0003-000000000003', '11111111-1111-1111-1111-111111111111', 'Shadowfax', 'Gripoil', 'Héros / Ressource / Allié', 'The Wizards', 'U1', NOW(), NOW()),
('c0000004-0004-0004-0004-000000000004', '11111111-1111-1111-1111-111111111111', 'Mithril Coat', 'Cotte de Mithril', 'Héros / Ressource / Objet', 'The Wizards', 'U2', NOW(), NOW()),
('c0000005-0005-0005-0005-000000000005', '11111111-1111-1111-1111-111111111111', 'Rivendell', 'Fondcombe', 'Héros / Site / Havre', 'The Wizards', 'F1', NOW(), NOW()),
('c0000006-0006-0006-0006-000000000006', '11111111-1111-1111-1111-111111111111', 'The Ring of Barahir', 'L''Anneau de Barahir', 'Héros / Ressource / Objet', 'The Wizards', 'U3', NOW(), NOW()),
('c0000007-0007-0007-0007-000000000007', '11111111-1111-1111-1111-111111111111', 'Knights of Dol Amroth', 'Chevaliers de Dol Amroth', 'Héros / Ressource / Faction', 'The Wizards', 'C1', NOW(), NOW()),
('c0000008-0008-0008-0008-000000000008', '11111111-1111-1111-1111-111111111111', 'Thranduil', 'Thranduil', 'Héros / Personnage', 'The Wizards', 'C2', NOW(), NOW()),
('c0000009-0009-0009-0009-000000000009', '11111111-1111-1111-1111-111111111111', 'Ancient Stair', 'Escalier Ancien', 'Héros / Site', 'The Wizards', 'C3', NOW(), NOW()),
('c0000010-0010-0010-0010-000000000010', '11111111-1111-1111-1111-111111111111', 'Wizard''s River-horses', 'Chevaux-rivière du Sorcier', 'Héros / Ressource / Evènement', 'The Wizards', 'U1', NOW(), NOW());

-- Série: The Dragons (10 cartes)
INSERT INTO cards (id, collection_id, name_en, name_fr, card_type, series, rarity, created_at, updated_at) VALUES
('c0000011-0011-0011-0011-000000000011', '11111111-1111-1111-1111-111111111111', 'Smaug', 'Smaug', 'Péril / Créature', 'The Dragons', 'R1', NOW(), NOW()),
('c0000012-0012-0012-0012-000000000012', '11111111-1111-1111-1111-111111111111', 'Glaurung', 'Glaurung', 'Péril / Créature', 'The Dragons', 'R2', NOW(), NOW()),
('c0000013-0013-0013-0013-000000000013', '11111111-1111-1111-1111-111111111111', 'Scatha the Worm', 'Scatha le Ver', 'Péril / Créature', 'The Dragons', 'R3', NOW(), NOW()),
('c0000014-0014-0014-0014-000000000014', '11111111-1111-1111-1111-111111111111', 'Dragon''s Desolation', 'Désolation du Dragon', 'Péril / Evènement', 'The Dragons', 'U1', NOW(), NOW()),
('c0000015-0015-0015-0015-000000000015', '11111111-1111-1111-1111-111111111111', 'Cracks of Doom', 'Crevasses du Destin', 'Héros / Site', 'The Dragons', 'F2', NOW(), NOW()),
('c0000016-0016-0016-0016-000000000016', '11111111-1111-1111-1111-111111111111', 'Dragon''s Blood', 'Sang de Dragon', 'Héros / Ressource / Objet', 'The Dragons', 'U2', NOW(), NOW()),
('c0000017-0017-0017-0017-000000000017', '11111111-1111-1111-1111-111111111111', 'Leaflock', 'Feuilleverrouillé', 'Héros / Personnage', 'The Dragons', 'C1', NOW(), NOW()),
('c0000018-0018-0018-0018-000000000018', '11111111-1111-1111-1111-111111111111', 'Great Goblin', 'Grand Gobelin', 'Péril / Créature', 'The Dragons', 'C2', NOW(), NOW()),
('c0000019-0019-0019-0019-000000000019', '11111111-1111-1111-1111-111111111111', 'Misty Mountains', 'Monts Brumeux', 'Région', 'The Dragons', 'C3', NOW(), NOW()),
('c0000020-0020-0020-0020-000000000020', '11111111-1111-1111-1111-111111111111', 'Dragon-spells', 'Sortilèges du Dragon', 'Péril / Evènement', 'The Dragons', 'U3', NOW(), NOW());

-- Série: Against the Shadow (10 cartes)
INSERT INTO cards (id, collection_id, name_en, name_fr, card_type, series, rarity, created_at, updated_at) VALUES
('c0000021-0021-0021-0021-000000000021', '11111111-1111-1111-1111-111111111111', 'Saruman the White', 'Saroumane le Blanc', 'Héros / Personnage / Sorcier', 'Against the Shadow', 'R1', NOW(), NOW()),
('c0000022-0022-0022-0022-000000000022', '11111111-1111-1111-1111-111111111111', 'Galadriel', 'Galadriel', 'Héros / Personnage', 'Against the Shadow', 'R2', NOW(), NOW()),
('c0000023-0023-0023-0023-000000000023', '11111111-1111-1111-1111-111111111111', 'Elrond', 'Elrond', 'Héros / Personnage', 'Against the Shadow', 'R3', NOW(), NOW()),
('c0000024-0024-0024-0024-000000000024', '11111111-1111-1111-1111-111111111111', 'Orthanc', 'Orthanc', 'Héros / Site', 'Against the Shadow', 'F1', NOW(), NOW()),
('c0000025-0025-0025-0025-000000000025', '11111111-1111-1111-1111-111111111111', 'Beorn', 'Beorn', 'Héros / Personnage', 'Against the Shadow', 'U1', NOW(), NOW()),
('c0000026-0026-0026-0026-000000000026', '11111111-1111-1111-1111-111111111111', 'Palantir of Orthanc', 'Palantir d''Orthanc', 'Héros / Ressource / Objet', 'Against the Shadow', 'U2', NOW(), NOW()),
('c0000027-0027-0027-0027-000000000027', '11111111-1111-1111-1111-111111111111', 'Tom Bombadil', 'Tom Bombadil', 'Héros / Personnage', 'Against the Shadow', 'C1', NOW(), NOW()),
('c0000028-0028-0028-0028-000000000028', '11111111-1111-1111-1111-111111111111', 'Goldberry', 'Baie d''Or', 'Héros / Personnage', 'Against the Shadow', 'C2', NOW(), NOW()),
('c0000029-0029-0029-0029-000000000029', '11111111-1111-1111-1111-111111111111', 'Old Forest', 'Vieille Forêt', 'Région', 'Against the Shadow', 'C3', NOW(), NOW()),
('c0000030-0030-0030-0030-000000000030', '11111111-1111-1111-1111-111111111111', 'Hidden Haven', 'Refuge Caché', 'Héros / Ressource / Evènement', 'Against the Shadow', 'U3', NOW(), NOW());

-- Série: Dark Minions (5 cartes)
INSERT INTO cards (id, collection_id, name_en, name_fr, card_type, series, rarity, created_at, updated_at) VALUES
('c0000031-0031-0031-0031-000000000031', '11111111-1111-1111-1111-111111111111', 'Witch-king of Angmar', 'Roi-Sorcier d''Angmar', 'Séide / Personnage', 'Dark Minions', 'R1', NOW(), NOW()),
('c0000032-0032-0032-0032-000000000032', '11111111-1111-1111-1111-111111111111', 'Mouth of Sauron', 'Bouche de Sauron', 'Séide / Personnage / Agent', 'Dark Minions', 'R2', NOW(), NOW()),
('c0000033-0033-0033-0033-000000000033', '11111111-1111-1111-1111-111111111111', 'Morgul-knife', 'Poignard de Morgul', 'Séide / Ressource / Objet', 'Dark Minions', 'U1', NOW(), NOW()),
('c0000034-0034-0034-0034-000000000034', '11111111-1111-1111-1111-111111111111', 'Black Numenoreans', 'Numénoréens Noirs', 'Séide / Ressource / Faction', 'Dark Minions', 'C1', NOW(), NOW()),
('c0000035-0035-0035-0035-000000000035', '11111111-1111-1111-1111-111111111111', 'Minas Morgul', 'Minas Morgul', 'Séide / Site', 'Dark Minions', 'F1', NOW(), NOW());

-- Série: Promo (3 cartes)
INSERT INTO cards (id, collection_id, name_en, name_fr, card_type, series, rarity, created_at, updated_at) VALUES
('c0000036-0036-0036-0036-000000000036', '11111111-1111-1111-1111-111111111111', 'Bilbo Baggins', 'Bilbo Sacquet', 'Héros / Personnage', 'Promo', 'P', NOW(), NOW()),
('c0000037-0037-0037-0037-000000000037', '11111111-1111-1111-1111-111111111111', 'The One Ring', 'L''Anneau Unique', 'Stage', 'Promo', 'P', NOW(), NOW()),
('c0000038-0038-0038-0038-000000000038', '11111111-1111-1111-1111-111111111111', 'Gollum', 'Gollum', 'Héros / Personnage', 'Promo', 'P', NOW(), NOW());

-- Série: The Lidless Eye (2 cartes)
INSERT INTO cards (id, collection_id, name_en, name_fr, card_type, series, rarity, created_at, updated_at) VALUES
('c0000039-0039-0039-0039-000000000039', '11111111-1111-1111-1111-111111111111', 'Barad-dur', 'Barad-dur', 'Séide / Site', 'The Lidless Eye', 'F1', NOW(), NOW()),
('c0000040-0040-0040-0040-000000000040', '11111111-1111-1111-1111-111111111111', 'Shelob', 'Arachne', 'Péril / Créature', 'The Lidless Eye', 'R1', NOW(), NOW());

-- User Cards: Marquer 60% des cartes comme possédées (24/40)
-- Cartes possédées (is_owned = true)
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES
-- The Wizards (6 possédées sur 10)
('00000000-0000-0000-0000-000000000001', 'c0000001-0001-0001-0001-000000000001', true, NOW() - INTERVAL '30 days', NOW(), NOW()),
('00000000-0000-0000-0000-000000000001', 'c0000002-0002-0002-0002-000000000002', true, NOW() - INTERVAL '25 days', NOW(), NOW()),
('00000000-0000-0000-0000-000000000001', 'c0000003-0003-0003-0003-000000000003', true, NOW() - INTERVAL '20 days', NOW(), NOW()),
('00000000-0000-0000-0000-000000000001', 'c0000004-0004-0004-0004-000000000004', true, NOW() - INTERVAL '15 days', NOW(), NOW()),
('00000000-0000-0000-0000-000000000001', 'c0000005-0005-0005-0005-000000000005', true, NOW() - INTERVAL '10 days', NOW(), NOW()),
('00000000-0000-0000-0000-000000000001', 'c0000006-0006-0006-0006-000000000006', true, NOW() - INTERVAL '5 days', NOW(), NOW()),
-- The Wizards (4 non possédées)
('00000000-0000-0000-0000-000000000001', 'c0000007-0007-0007-0007-000000000007', false, NULL, NOW(), NOW()),
('00000000-0000-0000-0000-000000000001', 'c0000008-0008-0008-0008-000000000008', false, NULL, NOW(), NOW()),
('00000000-0000-0000-0000-000000000001', 'c0000009-0009-0009-0009-000000000009', false, NULL, NOW(), NOW()),
('00000000-0000-0000-0000-000000000001', 'c0000010-0010-0010-0010-000000000010', false, NULL, NOW(), NOW()),

-- The Dragons (6 possédées sur 10)
('00000000-0000-0000-0000-000000000001', 'c0000011-0011-0011-0011-000000000011', true, NOW() - INTERVAL '28 days', NOW(), NOW()),
('00000000-0000-0000-0000-000000000001', 'c0000012-0012-0012-0012-000000000012', true, NOW() - INTERVAL '23 days', NOW(), NOW()),
('00000000-0000-0000-0000-000000000001', 'c0000013-0013-0013-0013-000000000013', true, NOW() - INTERVAL '18 days', NOW(), NOW()),
('00000000-0000-0000-0000-000000000001', 'c0000014-0014-0014-0014-000000000014', true, NOW() - INTERVAL '13 days', NOW(), NOW()),
('00000000-0000-0000-0000-000000000001', 'c0000015-0015-0015-0015-000000000015', true, NOW() - INTERVAL '8 days', NOW(), NOW()),
('00000000-0000-0000-0000-000000000001', 'c0000016-0016-0016-0016-000000000016', true, NOW() - INTERVAL '3 days', NOW(), NOW()),
-- The Dragons (4 non possédées)
('00000000-0000-0000-0000-000000000001', 'c0000017-0017-0017-0017-000000000017', false, NULL, NOW(), NOW()),
('00000000-0000-0000-0000-000000000001', 'c0000018-0018-0018-0018-000000000018', false, NULL, NOW(), NOW()),
('00000000-0000-0000-0000-000000000001', 'c0000019-0019-0019-0019-000000000019', false, NULL, NOW(), NOW()),
('00000000-0000-0000-0000-000000000001', 'c0000020-0020-0020-0020-000000000020', false, NULL, NOW(), NOW()),

-- Against the Shadow (6 possédées sur 10)
('00000000-0000-0000-0000-000000000001', 'c0000021-0021-0021-0021-000000000021', true, NOW() - INTERVAL '27 days', NOW(), NOW()),
('00000000-0000-0000-0000-000000000001', 'c0000022-0022-0022-0022-000000000022', true, NOW() - INTERVAL '22 days', NOW(), NOW()),
('00000000-0000-0000-0000-000000000001', 'c0000023-0023-0023-0023-000000000023', true, NOW() - INTERVAL '17 days', NOW(), NOW()),
('00000000-0000-0000-0000-000000000001', 'c0000024-0024-0024-0024-000000000024', true, NOW() - INTERVAL '12 days', NOW(), NOW()),
('00000000-0000-0000-0000-000000000001', 'c0000025-0025-0025-0025-000000000025', true, NOW() - INTERVAL '7 days', NOW(), NOW()),
('00000000-0000-0000-0000-000000000001', 'c0000026-0026-0026-0026-000000000026', true, NOW() - INTERVAL '2 days', NOW(), NOW()),
-- Against the Shadow (4 non possédées)
('00000000-0000-0000-0000-000000000001', 'c0000027-0027-0027-0027-000000000027', false, NULL, NOW(), NOW()),
('00000000-0000-0000-0000-000000000001', 'c0000028-0028-0028-0028-000000000028', false, NULL, NOW(), NOW()),
('00000000-0000-0000-0000-000000000001', 'c0000029-0029-0029-0029-000000000029', false, NULL, NOW(), NOW()),
('00000000-0000-0000-0000-000000000001', 'c0000030-0030-0030-0030-000000000030', false, NULL, NOW(), NOW()),

-- Dark Minions (3 possédées sur 5)
('00000000-0000-0000-0000-000000000001', 'c0000031-0031-0031-0031-000000000031', true, NOW() - INTERVAL '26 days', NOW(), NOW()),
('00000000-0000-0000-0000-000000000001', 'c0000032-0032-0032-0032-000000000032', true, NOW() - INTERVAL '21 days', NOW(), NOW()),
('00000000-0000-0000-0000-000000000001', 'c0000033-0033-0033-0033-000000000033', true, NOW() - INTERVAL '16 days', NOW(), NOW()),
-- Dark Minions (2 non possédées)
('00000000-0000-0000-0000-000000000001', 'c0000034-0034-0034-0034-000000000034', false, NULL, NOW(), NOW()),
('00000000-0000-0000-0000-000000000001', 'c0000035-0035-0035-0035-000000000035', false, NULL, NOW(), NOW()),

-- Promo (2 possédées sur 3)
('00000000-0000-0000-0000-000000000001', 'c0000036-0036-0036-0036-000000000036', true, NOW() - INTERVAL '24 days', NOW(), NOW()),
('00000000-0000-0000-0000-000000000001', 'c0000037-0037-0037-0037-000000000037', true, NOW() - INTERVAL '19 days', NOW(), NOW()),
-- Promo (1 non possédée)
('00000000-0000-0000-0000-000000000001', 'c0000038-0038-0038-0038-000000000038', false, NULL, NOW(), NOW()),

-- The Lidless Eye (1 possédée sur 2)
('00000000-0000-0000-0000-000000000001', 'c0000039-0039-0039-0039-000000000039', true, NOW() - INTERVAL '14 days', NOW(), NOW()),
-- The Lidless Eye (1 non possédée)
('00000000-0000-0000-0000-000000000001', 'c0000040-0040-0040-0040-000000000040', false, NULL, NOW(), NOW());

-- Total: 24 possédées / 40 disponibles = 60%
