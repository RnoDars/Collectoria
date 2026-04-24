-- Migration: Update MECCG card names with manual corrections
-- Date: 2026-04-24 17:46:16
-- Total corrections: 385

-- FRENCH_CHARS_IN_EN (98 cards)
-- ======================================================================

-- Against the Shadow: Bûrat
UPDATE cards SET
    name_en = 'Bûrat',
    name_fr = 'Bûrat',
    updated_at = NOW()
WHERE id = 'fb9f4692-dfa5-442e-98e7-6a348bb09c7a';

-- Against the Shadow: Corsairs of Rhûn
UPDATE cards SET
    name_en = 'Corsairs of Rhûn',
    name_fr = 'Corsaires de Rhûn',
    updated_at = NOW()
WHERE id = '931ba65e-3299-4928-bfc7-bb80f2559a68';

-- Against the Shadow: Dwarven Ring of Thélor's Tribe 
UPDATE cards SET
    name_en = 'Dwarven Ring of Thélor''s Tribe',
    name_fr = 'Anneau Nain de la tribu de Thélor',
    updated_at = NOW()
WHERE id = '0ef9cf9c-aca4-4f00-b288-4e42a2ba20d8';

-- Against the Shadow: Eärcaraxë Roused
UPDATE cards SET
    name_en = 'Eärcaraxë Roused',
    name_fr = 'Eärcaraxë enragée',
    updated_at = NOW()
WHERE id = '338369bc-6f4a-4dd0-bfdf-8ef0e46f385f';

-- Against the Shadow: Mîonid
UPDATE cards SET
    name_en = 'Mîonid',
    name_fr = 'Mîonid',
    updated_at = NOW()
WHERE id = '16075af5-100f-40d9-832b-2ea8ac1cacdd';

-- Against the Shadow: Nûriags
UPDATE cards SET
    name_en = 'Nûriags',
    name_fr = 'Nûriags',
    updated_at = NOW()
WHERE id = 'de334e53-e427-47b3-928b-4914c7ad7c74';

-- Against the Shadow: Nûrniag Camp
UPDATE cards SET
    name_en = 'Nûrniag Camp',
    name_fr = 'Camp des Nûrniags',
    updated_at = NOW()
WHERE id = 'd7197cad-c70b-40fb-8394-e38e1ccd1791';

-- Against the Shadow: Nûrniags
UPDATE cards SET
    name_en = 'Nûrniags',
    name_fr = 'Nûrniags',
    updated_at = NOW()
WHERE id = '6db8d21d-9334-4723-a09f-4bfd99296069';

-- Against the Shadow: The Pûkel-deeps
UPDATE cards SET
    name_en = 'The Pûkel-deeps',
    name_fr = 'Les Abîmes Biscornus',
    updated_at = NOW()
WHERE id = '44465599-b4b3-4bc5-a542-0b2fec7e301f';

-- Against the Shadow: Tûma
UPDATE cards SET
    name_en = 'Tûma',
    name_fr = 'Tûma',
    updated_at = NOW()
WHERE id = '71fabb48-6736-4a17-a8c8-b93f0dfec357';

-- Against the Shadow: Wûluag
UPDATE cards SET
    name_en = 'Wûluag',
    name_fr = 'Wûluag',
    updated_at = NOW()
WHERE id = '2eca10c0-397e-4576-85f3-09c89a020c64';

-- L'Oeil de Sauron: Adûnaphel Unleashed
UPDATE cards SET
    name_en = 'Adûnaphel Unleashed',
    name_fr = 'Adûnaphel déchaînée',
    updated_at = NOW()
WHERE id = 'e5fcbb1d-5e46-4c78-b9a3-e7453eb649be';

-- L'Oeil de Sauron: Adûnaphel the Ringwraith
UPDATE cards SET
    name_en = 'Adûnaphel the Ringwraith',
    name_fr = 'Adûnaphel la Spectre',
    updated_at = NOW()
WHERE id = '82adaef3-e357-42d0-94eb-b78bda70fe33';

-- L'Oeil de Sauron: Akhôrahil Unleashed
UPDATE cards SET
    name_en = 'Akhôrahil Unleashed',
    name_fr = 'Akhôrahil déchaîné',
    updated_at = NOW()
WHERE id = '613b39cc-4dc5-4f3c-beeb-5a6c32f20000';

-- L'Oeil de Sauron: Akhôrahil the Ringwraith
UPDATE cards SET
    name_en = 'Akhôrahil the Ringwraith',
    name_fr = 'Akhôrahil le Spectre',
    updated_at = NOW()
WHERE id = 'a783c470-46d4-4666-b406-150ea321ce1f';

-- L'Oeil de Sauron: Barad-dûr
UPDATE cards SET
    name_en = 'Barad-dûr',
    name_fr = 'Barad-dûr',
    updated_at = NOW()
WHERE id = 'a24db64a-7797-4cd4-8ccb-24f775ef139c';

-- L'Oeil de Sauron: Carn Dûm
UPDATE cards SET
    name_en = 'Carn Dûm',
    name_fr = 'Carn Dûm',
    updated_at = NOW()
WHERE id = '746c12c2-582a-49c6-81a1-9d671168c52a';

-- L'Oeil de Sauron: Caves of Ûlund
UPDATE cards SET
    name_en = 'Caves of Ûlund',
    name_fr = 'Grottes d''Ulûnd',
    updated_at = NOW()
WHERE id = '6f0c4f0c-9264-449b-9ab0-1159a1c806d7';

-- L'Oeil de Sauron: Dôgrib
UPDATE cards SET
    name_en = 'Dôgrib',
    name_fr = 'Dôgrib',
    updated_at = NOW()
WHERE id = '98c92b27-eee2-4c91-ae2d-1cebbfeed997';

-- L'Oeil de Sauron: Haudh-in-Gwanûr
UPDATE cards SET
    name_en = 'Haudh-in-Gwanûr',
    name_fr = 'Haudh-in-Gwanûr',
    updated_at = NOW()
WHERE id = 'b9f6c38e-4625-4048-9934-5ff0e5c65e54';

-- L'Oeil de Sauron: Henneth Annûn
UPDATE cards SET
    name_en = 'Henneth Annûn',
    name_fr = 'Henneth Annûn',
    updated_at = NOW()
WHERE id = 'ab5ec7a8-d3a5-4099-b234-70892ddaef5a';

-- L'Oeil de Sauron: Hoarmûrath Unleashed
UPDATE cards SET
    name_en = 'Hoarmûrath Unleashed',
    name_fr = 'Hoarmûrath déchaîné',
    updated_at = NOW()
WHERE id = 'ceabae40-1436-4e1b-8667-0ad75cf0659e';

-- L'Oeil de Sauron: Hoarmûrath the Ringwraith
UPDATE cards SET
    name_en = 'Hoarmûrath the Ringwraith',
    name_fr = 'Hoarmûrath le Spectre',
    updated_at = NOW()
WHERE id = 'f09aa1e9-b625-4215-9e98-cfb324a65650';

-- L'Oeil de Sauron: Indûr Unleashed
UPDATE cards SET
    name_en = 'Indûr Unleashed',
    name_fr = 'Indûr déchaîné',
    updated_at = NOW()
WHERE id = 'e13c9259-5246-4c84-bb41-73a33f1348f8';

-- L'Oeil de Sauron: Indûr the Ringwraith
UPDATE cards SET
    name_en = 'Indûr the Ringwraith',
    name_fr = 'Indûr le Spectre',
    updated_at = NOW()
WHERE id = '43627ebe-d2d5-46f3-8866-6766e4467a3d';

-- L'Oeil de Sauron: Khamûl Unleashed
UPDATE cards SET
    name_en = 'Khamûl Unleashed',
    name_fr = 'Khamûl déchaîné',
    updated_at = NOW()
WHERE id = '6d4627f1-b127-42c9-94cd-638bf34282da';

-- L'Oeil de Sauron: Khamûl the Ringwraith
UPDATE cards SET
    name_en = 'Khamûl the Ringwraith',
    name_fr = 'Khamûl le Spectre',
    updated_at = NOW()
WHERE id = 'be204c07-a10c-4281-a79a-781f60835a45';

-- L'Oeil de Sauron: Nevido Smôd
UPDATE cards SET
    name_en = 'Nevido Smôd',
    name_fr = 'Nevido Smôd',
    updated_at = NOW()
WHERE id = '25d0a609-0f4d-4e9f-94c5-5e11a72a1ae5';

-- L'Oeil de Sauron: Nûrniag Camp
UPDATE cards SET
    name_en = 'Nûrniag Camp',
    name_fr = 'Camp des Nûrniags',
    updated_at = NOW()
WHERE id = '029c3ea3-91c9-4431-9e75-9d99b2046375';

-- L'Oeil de Sauron: Nûrniags
UPDATE cards SET
    name_en = 'Nûrniags',
    name_fr = 'Nûrniags',
    updated_at = NOW()
WHERE id = 'db3374c4-2bfb-423d-bc5c-82a931d402b0';

-- L'Oeil de Sauron: Orcs of Udûn
UPDATE cards SET
    name_en = 'Orcs of Udûn',
    name_fr = 'Orques d''Udûn',
    updated_at = NOW()
WHERE id = 'c65cbb53-3799-45d4-8761-2a06c875ed8b';

-- L'Oeil de Sauron: Palantír of Amon Sûl
UPDATE cards SET
    name_en = 'Palantír of Amon Sûl',
    name_fr = 'Palantír d''Amon Sûl',
    updated_at = NOW()
WHERE id = 'ca17646f-9982-4966-9d45-13164886a9d1';

-- L'Oeil de Sauron: Zarak Dûm
UPDATE cards SET
    name_en = 'Zarak Dûm',
    name_fr = 'Zarak Dûm',
    updated_at = NOW()
WHERE id = '8d2ca7c8-92e1-4762-9ae9-34cd555b98c2';

-- L'Oeil de Sauron: Ûvatha Unleashed
UPDATE cards SET
    name_en = 'Ûvatha Unleashed',
    name_fr = 'Ûvatha déchaîné',
    updated_at = NOW()
WHERE id = '70692f8c-763e-43c8-a600-898b90c240d5';

-- L'Oeil de Sauron: Ûvatha the Ringwraith
UPDATE cards SET
    name_en = 'Ûvatha the Ringwraith',
    name_fr = 'Ûvatha le Spectre',
    updated_at = NOW()
WHERE id = 'b0506ce0-53f2-48f2-9d43-152fcf7709c7';

-- Les Dragons: A une once près
UPDATE cards SET
    name_en = 'Known to an Ounce',
    name_fr = 'A une once près',
    updated_at = NOW()
WHERE id = 'ad94514a-eb29-467c-bdae-51b612e7ecd0';

-- Les Dragons: Disparais dans la lumière !
UPDATE cards SET
    name_en = 'Vanish in Sunlight !',
    name_fr = 'Disparais dans la lumière !',
    updated_at = NOW()
WHERE id = '8ee573f5-c34c-4b7f-bf9e-d070e5cead1e';

-- Les Dragons: Eärcaraxë
UPDATE cards SET
    name_en = 'Eärcaraxë',
    name_fr = 'Eärcaraxë',
    updated_at = NOW()
WHERE id = 'fe11f8c9-17ef-407d-b677-d6d9682075b1';

-- Les Dragons: Eärcaraxë Ahunt
UPDATE cards SET
    name_en = 'Eärcaraxë Ahunt',
    name_fr = 'Eärcaraxë en chasse',
    updated_at = NOW()
WHERE id = '237d3258-b738-4110-af72-fdf4f7b42522';

-- Les Dragons: Eärcaraxë at Home
UPDATE cards SET
    name_en = 'Eärcaraxë at Home',
    name_fr = 'Eärcaraxë au gîte',
    updated_at = NOW()
WHERE id = 'fde81a2e-f5ec-479e-a66b-f3f1e82a4953';

-- Les Dragons: Holà ! Venez gai dol !
UPDATE cards SET
    name_en = 'Hey ! Come merry dol!',
    name_fr = 'Holà ! Venez gai dol !',
    updated_at = NOW()
WHERE id = '976146ca-34a6-4c58-9765-952d4971fcf9';

-- Les Dragons: Nenseldë the Wingild
UPDATE cards SET
    name_en = 'Nenseldë the Wingild',
    name_fr = 'Nenseldë la Wingild',
    updated_at = NOW()
WHERE id = 'd33b6950-3656-4c96-90b9-a3b86b2cdf8d';

-- Les Dragons: Que coeurs et membres se réchauffent !
UPDATE cards SET
    name_en = 'Warm Now Be Heart And Limb',
    name_fr = 'Que coeurs et membres se réchauffent !',
    updated_at = NOW()
WHERE id = '918a677f-d913-4f0c-9824-3bfef9ce108c';

-- Les Dragons: Rhûn
UPDATE cards SET
    name_en = 'Rhûn',
    name_fr = 'Rhûn',
    updated_at = NOW()
WHERE id = 'dbfd8b81-3d4a-4847-be1a-fead2716f395';

-- Les Dragons: Thráïn II
UPDATE cards SET
    name_en = 'Thráïn II',
    name_fr = 'Thráïn II',
    updated_at = NOW()
WHERE id = 'a82bf61a-9c12-4ad0-95c7-a37292c5e5b1';

-- Les Dragons: Un oeil à moitié ouvert
UPDATE cards SET
    name_en = 'Half an Eye Open',
    name_fr = 'Un oeil à moitié ouvert',
    updated_at = NOW()
WHERE id = '53995def-d5b6-4aa3-9e51-4b7d3eeb5fe7';

-- Les Dragons: Zarak Dûm
UPDATE cards SET
    name_en = 'Zarak Dûm',
    name_fr = 'Zarak Dûm',
    updated_at = NOW()
WHERE id = '16846e8a-2861-49ed-b44c-134776927aa8';

-- Les Dragons: Émeraude de Doriath
UPDATE cards SET
    name_en = 'Emerald of Doriath',
    name_fr = 'Émeraude de Doriath',
    updated_at = NOW()
WHERE id = '175c1af2-96a1-4a87-8b28-98eee6384f0c';

-- Les Dragons: Épuises et affamés
UPDATE cards SET
    name_en = 'Worn and Famished',
    name_fr = 'Épuises et affamés',
    updated_at = NOW()
WHERE id = 'aa40e57b-a61c-4ac2-a6a6-079b8349b15e';

-- Les Dragons: Épée vaillante
UPDATE cards SET
    name_en = 'Valiant Sword',
    name_fr = 'Épée vaillante',
    updated_at = NOW()
WHERE id = '95377839-59ef-492a-8922-a58b64365234';

-- Les Sorciers: "Bert" (Bûrat)
UPDATE cards SET
    name_en = '"Bert" (Bûrat)',
    name_fr = '"Bert" (Bûrat)',
    updated_at = NOW()
WHERE id = '5bd6cbcc-4fe3-478d-868e-9f5573bc05ac';

-- Les Sorciers: "Tom" (Tûma)
UPDATE cards SET
    name_en = '"Tom" (Tûma)',
    name_fr = '"Tom" (Tûma)',
    updated_at = NOW()
WHERE id = 'd43e6942-775d-425d-bf65-a64213c50d7f';

-- Les Sorciers: "William" (Wûluag)
UPDATE cards SET
    name_en = '"William" (Wûluag)',
    name_fr = '"William" (Wûluag)',
    updated_at = NOW()
WHERE id = 'e2f9f7a2-4f15-450e-9590-214558510376';

-- Les Sorciers: Adûnaphel
UPDATE cards SET
    name_en = 'Adûnaphel',
    name_fr = 'Adûnaphel',
    updated_at = NOW()
WHERE id = '24cb9b8b-a7ea-48ab-ba97-af38e780c659';

-- Les Sorciers: Akhôrahil
UPDATE cards SET
    name_en = 'Akhôrahil',
    name_fr = 'Akhôrahil',
    updated_at = NOW()
WHERE id = 'be02e4ee-a011-4eaa-84b3-7efed8ef589a';

-- Les Sorciers: Arinmîr
UPDATE cards SET
    name_en = 'Arinmîr',
    name_fr = 'Arinmîr',
    updated_at = NOW()
WHERE id = 'dbe06c87-9126-4a60-8151-43b71a913b57';

-- Les Sorciers: Barad-dûr
UPDATE cards SET
    name_en = 'Barad-dûr',
    name_fr = 'Barad-dûr',
    updated_at = NOW()
WHERE id = '02eaa499-344c-4b41-8ce3-9d9327c57c2a';

-- Les Sorciers: Carn Dûm
UPDATE cards SET
    name_en = 'Carn Dûm',
    name_fr = 'Carn Dûm',
    updated_at = NOW()
WHERE id = '1e6ea909-3234-43ec-9d89-57d4eafc1ed3';

-- Les Sorciers: Caves of Ûlund
UPDATE cards SET
    name_en = 'Caves of Ûlund',
    name_fr = 'Grottes d''Ulûnd',
    updated_at = NOW()
WHERE id = '6e6da2d0-d08a-4270-aa66-c39748b51548';

-- Les Sorciers: Contrôler un Palantir
UPDATE cards SET
    name_en = 'Align Palantir',
    name_fr = 'Contrôler un Palantir',
    updated_at = NOW()
WHERE id = 'fb7784c7-e40a-43e5-ad5b-dbfc3d64ad92';

-- Les Sorciers: Dwarven Ring of Thélor’s Tribe
UPDATE cards SET
    name_en = 'Dwarven Ring of Thélor’s Tribe',
    name_fr = 'Anneau Nain de la Tribu de Thélor',
    updated_at = NOW()
WHERE id = '79941529-ef37-498e-9833-cea7ebfcf197';

-- Les Sorciers: Dáïn II
UPDATE cards SET
    name_en = 'Dáïn II',
    name_fr = 'Dáïn II',
    updated_at = NOW()
WHERE id = 'a8158a19-34c7-4a7d-9229-43ad2d69440e';

-- Les Sorciers: Désespoir du coeur
UPDATE cards SET
    name_en = 'Despair of the Heart',
    name_fr = 'Désespoir du coeur',
    updated_at = NOW()
WHERE id = '2220758f-d831-4af4-ad51-7ce1f7c35842';

-- Les Sorciers: Ghân-buri-Ghân
UPDATE cards SET
    name_en = 'Ghân-buri-Ghân',
    name_fr = 'Ghán-buri-Ghán',
    updated_at = NOW()
WHERE id = '581e655c-9ea8-45ac-8ff5-8ebe9262af58';

-- Les Sorciers: Henneth Annûn
UPDATE cards SET
    name_en = 'Henneth Annûn',
    name_fr = 'Henneth Annûn',
    updated_at = NOW()
WHERE id = '28b072f2-2e06-4203-b2a9-9a24552f6788';

-- Les Sorciers: Hoarmûrath of Dír
UPDATE cards SET
    name_en = 'Hoarmûrath of Dír',
    name_fr = 'Hoarmûrath de Dír',
    updated_at = NOW()
WHERE id = '793e9bc3-4cbf-4e4c-b166-40a1de5a8954';

-- Les Sorciers: Indûr Dawndeath
UPDATE cards SET
    name_en = 'Indûr Dawndeath',
    name_fr = 'Indûr Aubemort',
    updated_at = NOW()
WHERE id = 'ec293091-955c-4f86-81cc-4f4957c0827c';

-- Les Sorciers: Khamûl the Easterling
UPDATE cards SET
    name_en = 'Khamûl the Easterling',
    name_fr = 'Khamûl l''Oriental',
    updated_at = NOW()
WHERE id = '71b75992-a334-4eb5-8cef-1e0483373f00';

-- Les Sorciers: Mûmak (Oliphant)
UPDATE cards SET
    name_en = 'Mûmak (Oliphant)',
    name_fr = 'Mûmak (Oliphant)',
    updated_at = NOW()
WHERE id = '7c82642c-ee30-4dd3-97db-7b626431a3c8';

-- Les Sorciers: Old Pûkel Gap
UPDATE cards SET
    name_en = 'Old Pûkel Gap',
    name_fr = 'Passe des Vieux Biscornus',
    updated_at = NOW()
WHERE id = 'e0a5e42f-d796-4863-b3d6-6e26b8290975';

-- Les Sorciers: Old Pûkel-land
UPDATE cards SET
    name_en = 'Old Pûkel-land',
    name_fr = 'Pays des Vieux Biscornus',
    updated_at = NOW()
WHERE id = 'e1569450-cf3b-4ea0-b03f-6a4bcddd4232';

-- Les Sorciers: Oïn
UPDATE cards SET
    name_en = 'Oïn',
    name_fr = 'Oïn',
    updated_at = NOW()
WHERE id = '3600f591-b138-4657-8889-1cad226eff23';

-- Les Sorciers: Palantír of Amon Sûl
UPDATE cards SET
    name_en = 'Palantír of Amon Sûl',
    name_fr = 'Palantír d''Amon Sûl',
    updated_at = NOW()
WHERE id = 'd57e2371-befe-42c1-b62a-465fbcd28ade';

-- Les Sorciers: Pûkel-men
UPDATE cards SET
    name_en = 'Pûkel-men',
    name_fr = 'Hommes Biscornus',
    updated_at = NOW()
WHERE id = '12496d14-f291-4a01-a6f4-638a0d9c69c1';

-- Les Sorciers: Roäc the Raven
UPDATE cards SET
    name_en = 'Roäc the Raven',
    name_fr = 'Roäc le Corbeau',
    updated_at = NOW()
WHERE id = '0baf0827-ad1d-45fb-a549-bf1e8f6638ce';

-- Les Sorciers: Storms of Ossë
UPDATE cards SET
    name_en = 'Storms of Ossë',
    name_fr = 'Tempêtes d''Ossë',
    updated_at = NOW()
WHERE id = '0c72c473-9db8-4ee1-8b10-604a5ce16e18';

-- Les Sorciers: The Nazgûl are Abroad
UPDATE cards SET
    name_en = 'The Nazgûl are Abroad',
    name_fr = 'Les Nazgûl sont sortis',
    updated_at = NOW()
WHERE id = '0af9c845-40f0-4459-88e2-8b92053491d6';

-- Les Sorciers: Théoden
UPDATE cards SET
    name_en = 'Théoden',
    name_fr = 'Théoden',
    updated_at = NOW()
WHERE id = 'c57c8097-1864-4e2d-ac23-6231874609d2';

-- Les Sorciers: Udûn
UPDATE cards SET
    name_en = 'Udûn',
    name_fr = 'Udûn',
    updated_at = NOW()
WHERE id = 'fae00684-8a28-443a-849f-a64246cc8ce3';

-- Les Sorciers: Vôteli
UPDATE cards SET
    name_en = 'Vôteli',
    name_fr = 'Vôteli',
    updated_at = NOW()
WHERE id = 'b5515cb6-95ec-4ba1-ab8c-4368cbb9f721';

-- Les Sorciers: Woses of Old Pûkel-land
UPDATE cards SET
    name_en = 'Woses of Old Pûkel-land',
    name_fr = 'Woses du Pays des Vieux Biscornus',
    updated_at = NOW()
WHERE id = 'c8fdb0dd-cd70-4413-b0d4-8dfcd55002ac';

-- Les Sorciers: Épée de Gondolin
UPDATE cards SET
    name_en = 'Sword of Gondolin',
    name_fr = 'Épée de Gondolin',
    updated_at = NOW()
WHERE id = 'aec7d28a-6ce9-496c-abe2-47405dec8c12';

-- Les Sorciers: Île des Morts qui Vivent
UPDATE cards SET
    name_en = 'Isles of the Dead that Live',
    name_fr = 'Île des Morts qui Vivent',
    updated_at = NOW()
WHERE id = '2010008b-9a7b-44a0-8bfb-377be774df0f';

-- Sombres Séides: Bûthrakaur the Green
UPDATE cards SET
    name_en = 'Bûthrakaur the Green',
    name_fr = 'Bûthrakaur le Vert',
    updated_at = NOW()
WHERE id = 'df903de9-244a-4972-a1c3-05367cf9ec69';

-- Sombres Séides: Dâsakûn
UPDATE cards SET
    name_en = 'Dâsakûn',
    name_fr = 'Dâsakûn',
    updated_at = NOW()
WHERE id = 'a1c87452-6b53-4636-941e-dd2bc13e3de8';

-- Sombres Séides: Haudh-in-Gwanûr
UPDATE cards SET
    name_en = 'Haudh-in-Gwanûr',
    name_fr = 'Haudh-in-Gwanûr',
    updated_at = NOW()
WHERE id = '518d660d-ad52-481e-8cd9-a4962f6d8aed';

-- Sombres Séides: Jûoma
UPDATE cards SET
    name_en = 'Jûoma',
    name_fr = 'Jûoma',
    updated_at = NOW()
WHERE id = '6b2e2b6a-f6fa-473c-b8bc-a99bd323e1b5';

-- Sombres Séides: Pôn-ora-Pôn
UPDATE cards SET
    name_en = 'Pôn-ora-Pôn',
    name_fr = 'Pôn-ora-Pôn',
    updated_at = NOW()
WHERE id = '3d228cd8-3c5a-4b52-82f0-22ab4a171f04';

-- Sombres Séides: Râisha
UPDATE cards SET
    name_en = 'Râisha',
    name_fr = 'Râisha',
    updated_at = NOW()
WHERE id = '04aa3949-6b84-4b63-acad-7d62db5480a9';

-- Sombres Séides: Spider of the Môrlat
UPDATE cards SET
    name_en = 'Spider of the Môrlat',
    name_fr = 'Araignée du Môrlat',
    updated_at = NOW()
WHERE id = 'c42302ba-a0a6-457b-995f-f8aa5fdee982';

-- Sombres Séides: The Pûkel-deeps
UPDATE cards SET
    name_en = 'The Pûkel-deeps',
    name_fr = 'Les Abîmes Biscornus',
    updated_at = NOW()
WHERE id = 'a371f7f0-4def-4b4b-afee-9ee8b1a6488e';

-- Sombres Séides: Ôm-buri-Ôm
UPDATE cards SET
    name_en = 'Ôm-buri-Ôm',
    name_fr = 'Ôm-buri-Ôm',
    updated_at = NOW()
WHERE id = '5bce6bd5-84fd-4549-a2c9-fd5a0204713a';

-- The Balrog: Barad-dûr
UPDATE cards SET
    name_en = 'Barad-dûr',
    name_fr = 'Barad-dûr',
    updated_at = NOW()
WHERE id = '72845e58-9b79-4c58-b7b8-69841486a18e';

-- The Balrog: Bûthrakaur
UPDATE cards SET
    name_en = 'Bûthrakaur',
    name_fr = 'Bûthrakaur',
    updated_at = NOW()
WHERE id = '60f4ef3d-a95c-41c0-a65a-f9dc413b6d28';

-- The Balrog: Carn Dûm
UPDATE cards SET
    name_en = 'Carn Dûm',
    name_fr = 'Carn Dûm',
    updated_at = NOW()
WHERE id = 'e40e111e-2adc-4372-ae7b-94260c301605';

-- The Balrog: Flame of Udûn
UPDATE cards SET
    name_en = 'Flame of Udûn',
    name_fr = 'Flamme d''Udûn',
    updated_at = NOW()
WHERE id = 'ce8f7a0f-01ba-4def-aeeb-f9356ce9d493';

-- The Balrog: The Pûkel-deeps
UPDATE cards SET
    name_en = 'The Pûkel-deeps',
    name_fr = 'Les Abîmes Biscornus',
    updated_at = NOW()
WHERE id = '4cbfab52-c23e-4a11-bab4-514690cc0c89';

-- The White Hand: Oromë's Warders
UPDATE cards SET
    name_en = 'Oromë''s Warders',
    name_fr = 'Les Gardiens d’Oromë',
    updated_at = NOW()
WHERE id = 'eab5cd5b-b5da-4e59-bdb6-a9426b78162e';

-- IDENTICAL_NAMES_CHECK (228 cards)
-- ======================================================================

-- L'Oeil de Sauron: Amon Hen
UPDATE cards SET
    name_en = 'Amon Hen',
    name_fr = 'Amon Hen',
    updated_at = NOW()
WHERE id = 'e4049f84-bbd2-4420-bb0f-baf203d4a23c';

-- L'Oeil de Sauron: Asternak
UPDATE cards SET
    name_en = 'Asternak',
    name_fr = 'Asternak',
    updated_at = NOW()
WHERE id = '93bcd2ea-2984-4e61-bf1a-5337f150fa08';

-- L'Oeil de Sauron: Balchoth
UPDATE cards SET
    name_en = 'Balchoth',
    name_fr = 'Balchoth',
    updated_at = NOW()
WHERE id = '043deb82-a1cd-4b44-a9cb-26423e32a075';

-- L'Oeil de Sauron: Belegorn
UPDATE cards SET
    name_en = 'Belegorn',
    name_fr = 'Belegorn',
    updated_at = NOW()
WHERE id = 'eb40f59d-7d00-42df-a549-2202cfb99c28';

-- L'Oeil de Sauron: Bree
UPDATE cards SET
    name_en = 'Bree',
    name_fr = 'Bree',
    updated_at = NOW()
WHERE id = '6b392102-b466-485f-a9ef-f0eb425e06bf';

-- L'Oeil de Sauron: Brigands
UPDATE cards SET
    name_en = 'Brigands',
    name_fr = 'Brigands',
    updated_at = NOW()
WHERE id = 'a0c24358-f7c6-457d-97d4-36bca364196b';

-- L'Oeil de Sauron: Calendal
UPDATE cards SET
    name_en = 'Calendal',
    name_fr = 'Calendal',
    updated_at = NOW()
WHERE id = '87ea774a-2b53-4868-b4dc-e76bed2c6682';

-- L'Oeil de Sauron: Cameth Brin
UPDATE cards SET
    name_en = 'Cameth Brin',
    name_fr = 'Cameth Brin',
    updated_at = NOW()
WHERE id = '83d0eb82-fe28-4649-a642-83f8313ebbce';

-- L'Oeil de Sauron: Carambor
UPDATE cards SET
    name_en = 'Carambor',
    name_fr = 'Carambor',
    updated_at = NOW()
WHERE id = '4bf4ba9c-aeeb-4d72-8d88-a5dc81fa2e17';

-- L'Oeil de Sauron: Cirith Gorgor
UPDATE cards SET
    name_en = 'Cirith Gorgor',
    name_fr = 'Cirith Gorgor',
    updated_at = NOW()
WHERE id = '3b3b26e0-1837-446e-8d72-76c135ceaa89';

-- L'Oeil de Sauron: Cirith Ungol
UPDATE cards SET
    name_en = 'Cirith Ungol',
    name_fr = 'Cirith Ungol',
    updated_at = NOW()
WHERE id = '5ce134d0-f6a0-4da9-848d-c589de1620fa';

-- L'Oeil de Sauron: Ciryaher
UPDATE cards SET
    name_en = 'Ciryaher',
    name_fr = 'Ciryaher',
    updated_at = NOW()
WHERE id = '1223846a-2a1e-4239-9c1a-e194a557905f';

-- L'Oeil de Sauron: Diversion
UPDATE cards SET
    name_en = 'Diversion',
    name_fr = 'Diversion',
    updated_at = NOW()
WHERE id = 'af12d95a-6129-41d9-a416-accc3fe7afb7';

-- L'Oeil de Sauron: Dol Amroth
UPDATE cards SET
    name_en = 'Dol Amroth',
    name_fr = 'Dol Amroth',
    updated_at = NOW()
WHERE id = '9644f3d5-7e78-418a-8f55-695b26b7a8ea';

-- L'Oeil de Sauron: Dol Guldur
UPDATE cards SET
    name_en = 'Dol Guldur',
    name_fr = 'Dol Guldur',
    updated_at = NOW()
WHERE id = '4b93f7e7-86f2-4a2c-93a0-daae488a3e22';

-- L'Oeil de Sauron: Dorelas
UPDATE cards SET
    name_en = 'Dorelas',
    name_fr = 'Dorelas',
    updated_at = NOW()
WHERE id = '3b476dba-1021-4a80-ae6f-260f626eb163';

-- L'Oeil de Sauron: Dunharrow
UPDATE cards SET
    name_en = 'Dunharrow',
    name_fr = 'Dunharrow',
    updated_at = NOW()
WHERE id = 'c4002aed-3869-4cce-9309-e0b4be303ff7';

-- L'Oeil de Sauron: Edoras
UPDATE cards SET
    name_en = 'Edoras',
    name_fr = 'Edoras',
    updated_at = NOW()
WHERE id = '4b2dc53d-70e6-477a-b9d8-90a77e179ebe';

-- L'Oeil de Sauron: Eradan
UPDATE cards SET
    name_en = 'Eradan',
    name_fr = 'Eradan',
    updated_at = NOW()
WHERE id = '2bb2df61-c6cd-4fa0-83df-fa98e771990f';

-- L'Oeil de Sauron: Geann a-Lisch
UPDATE cards SET
    name_en = 'Geann a-Lisch',
    name_fr = 'Geann a-Lisch',
    updated_at = NOW()
WHERE id = '23b05d88-cd55-4cef-a18a-0f69eb57caec';

-- L'Oeil de Sauron: Gobel Mírlond
UPDATE cards SET
    name_en = 'Gobel Mírlond',
    name_fr = 'Gobel Mírlond',
    updated_at = NOW()
WHERE id = '460dd968-966b-4102-89ef-26040eef7ba0';

-- L'Oeil de Sauron: Gondmaeglom
UPDATE cards SET
    name_en = 'Gondmaeglom',
    name_fr = 'Gondmaeglom',
    updated_at = NOW()
WHERE id = '53715fee-2e0a-4df7-9e41-024341d80ba6';

-- L'Oeil de Sauron: Gorbag
UPDATE cards SET
    name_en = 'Gorbag',
    name_fr = 'Gorbag',
    updated_at = NOW()
WHERE id = '9f06c393-8db9-412a-8a64-4e088cd53f64';

-- L'Oeil de Sauron: Grishnákh
UPDATE cards SET
    name_en = 'Grishnákh',
    name_fr = 'Grishnákh',
    updated_at = NOW()
WHERE id = 'ecad92b7-3844-47c8-b97e-09b62c8dc14c';

-- L'Oeil de Sauron: Gulla
UPDATE cards SET
    name_en = 'Gulla',
    name_fr = 'Gulla',
    updated_at = NOW()
WHERE id = '3f2cb56f-d316-4be1-8eef-253f3682a047';

-- L'Oeil de Sauron: Hador
UPDATE cards SET
    name_en = 'Hador',
    name_fr = 'Hador',
    updated_at = NOW()
WHERE id = 'b3b2e8b3-4ca5-43a5-97fa-4299df40950f';

-- L'Oeil de Sauron: Hendolen
UPDATE cards SET
    name_en = 'Hendolen',
    name_fr = 'Hendolen',
    updated_at = NOW()
WHERE id = 'd329a519-1e99-4462-8ba6-d9982c9e47d8';

-- L'Oeil de Sauron: Huorn
UPDATE cards SET
    name_en = 'Huorn',
    name_fr = 'Huorn',
    updated_at = NOW()
WHERE id = 'dedcd435-814c-4bd8-9d77-4800efe714fb';

-- L'Oeil de Sauron: Isengard
UPDATE cards SET
    name_en = 'Isengard',
    name_fr = 'Isengard',
    updated_at = NOW()
WHERE id = '0632aa3b-24ef-44be-a99a-fb5175a11e86';

-- L'Oeil de Sauron: Jerrek
UPDATE cards SET
    name_en = 'Jerrek',
    name_fr = 'Jerrek',
    updated_at = NOW()
WHERE id = '621acc10-615d-4f7a-88e1-2aece41adce9';

-- L'Oeil de Sauron: Lagduf
UPDATE cards SET
    name_en = 'Lagduf',
    name_fr = 'Lagduf',
    updated_at = NOW()
WHERE id = '371418bc-fa18-4671-930e-944fc3d5c5d6';

-- L'Oeil de Sauron: Landroval
UPDATE cards SET
    name_en = 'Landroval',
    name_fr = 'Landroval',
    updated_at = NOW()
WHERE id = '8160b2c2-6a21-4441-ad2c-73a83386af3a';

-- L'Oeil de Sauron: Layos
UPDATE cards SET
    name_en = 'Layos',
    name_fr = 'Layos',
    updated_at = NOW()
WHERE id = 'a85e1d18-6286-4cf0-8a7c-721fb70f325b';

-- L'Oeil de Sauron: Lond Galen
UPDATE cards SET
    name_en = 'Lond Galen',
    name_fr = 'Lond Galen',
    updated_at = NOW()
WHERE id = 'a46f06d4-3293-45b5-a078-cc1c04511144';

-- L'Oeil de Sauron: Luitprand
UPDATE cards SET
    name_en = 'Luitprand',
    name_fr = 'Luitprand',
    updated_at = NOW()
WHERE id = 'd5a28711-fa17-44c5-93d6-a81495511a95';

-- L'Oeil de Sauron: Minas Morgul
UPDATE cards SET
    name_en = 'Minas Morgul',
    name_fr = 'Minas Morgul',
    updated_at = NOW()
WHERE id = 'bf3b0ff5-c5a9-4a15-a5a9-b2a1e86effae';

-- L'Oeil de Sauron: Minas Tirith
UPDATE cards SET
    name_en = 'Minas Tirith',
    name_fr = 'Minas Tirith',
    updated_at = NOW()
WHERE id = '0e19cf41-6220-4292-9925-0d14cae5019e';

-- L'Oeil de Sauron: Moria
UPDATE cards SET
    name_en = 'Moria',
    name_fr = 'Moria',
    updated_at = NOW()
WHERE id = 'c77b9481-6fa6-4038-83db-7514d91bb826';

-- L'Oeil de Sauron: Muzgash
UPDATE cards SET
    name_en = 'Muzgash',
    name_fr = 'Muzgash',
    updated_at = NOW()
WHERE id = 'ae6ec9e1-8cf9-49e4-ac97-083940e35d30';

-- L'Oeil de Sauron: Ost-in-Edhil
UPDATE cards SET
    name_en = 'Ost-in-Edhil',
    name_fr = 'Ost-in-Edhil',
    updated_at = NOW()
WHERE id = '80af0b31-4d27-4dbc-bb88-6206ee5d0165';

-- L'Oeil de Sauron: Ostisen
UPDATE cards SET
    name_en = 'Ostisen',
    name_fr = 'Ostisen',
    updated_at = NOW()
WHERE id = '50d07caf-79bd-4c9b-bbea-2c3610a3acbe';

-- L'Oeil de Sauron: Pelargir
UPDATE cards SET
    name_en = 'Pelargir',
    name_fr = 'Pelargir',
    updated_at = NOW()
WHERE id = '6b61767e-744c-4916-9243-986c5331da35';

-- L'Oeil de Sauron: Pirates
UPDATE cards SET
    name_en = 'Pirates',
    name_fr = 'Pirates',
    updated_at = NOW()
WHERE id = 'd17f4488-d375-4efd-8e16-23d8c48c70b8';

-- L'Oeil de Sauron: Poison
UPDATE cards SET
    name_en = 'Poison',
    name_fr = 'Poison',
    updated_at = NOW()
WHERE id = '198e31e7-c85c-4ba8-9036-39089b6f5f7e';

-- L'Oeil de Sauron: Pon Opar
UPDATE cards SET
    name_en = 'Pon Opar',
    name_fr = 'Pon Opar',
    updated_at = NOW()
WHERE id = 'd3c389ea-d028-413b-91dd-364de8852d3c';

-- L'Oeil de Sauron: Radbug
UPDATE cards SET
    name_en = 'Radbug',
    name_fr = 'Radbug',
    updated_at = NOW()
WHERE id = '9a2d13da-6775-413f-b6d5-975315dcc140';

-- L'Oeil de Sauron: Ruse
UPDATE cards SET
    name_en = 'Ruse',
    name_fr = 'Ruse',
    updated_at = NOW()
WHERE id = '71d11a3a-fc0c-4c17-b2a5-94ab59e013b2';

-- L'Oeil de Sauron: Sarn Goriwing
UPDATE cards SET
    name_en = 'Sarn Goriwing',
    name_fr = 'Sarn Goriwing',
    updated_at = NOW()
WHERE id = 'dd285557-3cd5-4866-81dd-20819ead1593';

-- L'Oeil de Sauron: Shagrat
UPDATE cards SET
    name_en = 'Shagrat',
    name_fr = 'Shagrat',
    updated_at = NOW()
WHERE id = '5ac2c1a9-1e7c-45fa-9330-6f5ad9e66f75';

-- L'Oeil de Sauron: Shrel-Kain
UPDATE cards SET
    name_en = 'Shrel-Kain',
    name_fr = 'Shrel-Kain',
    updated_at = NOW()
WHERE id = '7aea7c19-f50e-4173-86e2-e998a4556064';

-- L'Oeil de Sauron: Shámas
UPDATE cards SET
    name_en = 'Shámas',
    name_fr = 'Shámas',
    updated_at = NOW()
WHERE id = 'c9fde72c-962b-471c-9518-1fb18c491c59';

-- L'Oeil de Sauron: Snaga
UPDATE cards SET
    name_en = 'Snaga',
    name_fr = 'Snaga',
    updated_at = NOW()
WHERE id = 'eea586fb-1d5b-4dbf-a88f-5c24717c15a9';

-- L'Oeil de Sauron: Tarcil
UPDATE cards SET
    name_en = 'Tarcil',
    name_fr = 'Tarcil',
    updated_at = NOW()
WHERE id = '8a297c6a-2cc5-4a40-93da-128766687a51';

-- L'Oeil de Sauron: Tharbad
UPDATE cards SET
    name_en = 'Tharbad',
    name_fr = 'Tharbad',
    updated_at = NOW()
WHERE id = 'eaf1ebd1-93be-4418-9f68-614e3b2d3922';

-- L'Oeil de Sauron: Tros Hesnef
UPDATE cards SET
    name_en = 'Tros Hesnef',
    name_fr = 'Tros Hesnef',
    updated_at = NOW()
WHERE id = '7c0973ec-faf1-4b23-acbd-586d59a0b9d5';

-- L'Oeil de Sauron: Uchel
UPDATE cards SET
    name_en = 'Uchel',
    name_fr = 'Uchel',
    updated_at = NOW()
WHERE id = '5cf07892-5cb1-4dc7-97da-3fc4c1b0fbf9';

-- L'Oeil de Sauron: Ufthak
UPDATE cards SET
    name_en = 'Ufthak',
    name_fr = 'Ufthak',
    updated_at = NOW()
WHERE id = '6bcbfa3b-15e6-43c3-b55f-4cb23a860b93';

-- L'Oeil de Sauron: Urlurtsu Nurn
UPDATE cards SET
    name_en = 'Urlurtsu Nurn',
    name_fr = 'Urlurtsu Nurn',
    updated_at = NOW()
WHERE id = '5430565c-3dfa-4080-839a-35c7e50cc1ea';

-- Les Dragons: A examiner par la suite
UPDATE cards SET
    name_en = 'Look More Closely Later',
    name_fr = 'A examiner par la suite',
    updated_at = NOW()
WHERE id = '76ead6b3-61ba-4ae2-b8a1-6fbc0c8ca156';

-- Les Dragons: Brand
UPDATE cards SET
    name_en = 'Brand',
    name_fr = 'Brand',
    updated_at = NOW()
WHERE id = '438f5fb5-1e59-47be-845a-73496fdf93c9';

-- Les Dragons: Buhr Widu
UPDATE cards SET
    name_en = 'Buhr Widu',
    name_fr = 'Buhr Widu',
    updated_at = NOW()
WHERE id = 'afef59fc-c55b-4979-968b-ef505b9a53b0';

-- Les Dragons: Connaissance des mathoms
UPDATE cards SET
    name_en = 'Mathom Lore',
    name_fr = 'Connaissances des mathoms',
    updated_at = NOW()
WHERE id = 'bb217d56-cbba-47c5-b3d4-0124f18d39fa';

-- Les Dragons: Cram
UPDATE cards SET
    name_en = 'Cram',
    name_fr = 'Cram',
    updated_at = NOW()
WHERE id = '17185277-cdee-48fc-b954-880354b2f09d';

-- Les Dragons: Cruel Caradhras
UPDATE cards SET
    name_en = 'Cruel Caradhras',
    name_fr = 'Cruel Caradhras',
    updated_at = NOW()
WHERE id = 'dc3ecd29-8f5a-4854-b9c9-7ec851a68e61';

-- Les Dragons: Forod
UPDATE cards SET
    name_en = 'Forod',
    name_fr = 'Forod',
    updated_at = NOW()
WHERE id = 'fd68d4ca-1578-4545-a4a0-1ad78e65cbb0';

-- Les Dragons: Galdor
UPDATE cards SET
    name_en = 'Galdor',
    name_fr = 'Galdor',
    updated_at = NOW()
WHERE id = '860f3291-7f68-4051-94e8-f28dcb6b70ba';

-- Les Dragons: Gondmaeglom
UPDATE cards SET
    name_en = 'Gondmaeglom',
    name_fr = 'Gondmaeglom',
    updated_at = NOW()
WHERE id = '19c4581c-3f1a-4655-9810-9e159dc59b51';

-- Les Dragons: Gothmog
UPDATE cards SET
    name_en = 'Gothmog',
    name_fr = 'Gothmog',
    updated_at = NOW()
WHERE id = '81874f4b-2a77-4429-a986-e14a2847750a';

-- Les Dragons: Harad
UPDATE cards SET
    name_en = 'Harad',
    name_fr = 'Harad',
    updated_at = NOW()
WHERE id = 'eedd6ff0-ef08-48a7-a943-d4232ed06a13';

-- Les Dragons: Ioreth
UPDATE cards SET
    name_en = 'Ioreth',
    name_fr = 'Ioreth',
    updated_at = NOW()
WHERE id = 'da871054-e41a-4a2f-ba3c-13b4cc609b58';

-- Les Dragons: Issu des fosses d'Angband
UPDATE cards SET
    name_en = 'From the Pits of Angband',
    name_fr = 'Issus des fosses d''Angband',
    updated_at = NOW()
WHERE id = '5f4d3768-d32d-4fc1-acc1-b66825b99cfb';

-- Les Dragons: Itangast
UPDATE cards SET
    name_en = 'Itangast',
    name_fr = 'Itangast',
    updated_at = NOW()
WHERE id = '24c03cf5-1530-49da-8ab3-ea33d344912f';

-- Les Dragons: Le heaume de son secret
UPDATE cards SET
    name_en = 'Helm of Her Secrecy',
    name_fr = 'Le heaume de son secret',
    updated_at = NOW()
WHERE id = '1210fbe0-498b-4633-bc98-bc6112d5020e';

-- Les Dragons: Oeil inquisiteur
UPDATE cards SET
    name_en = 'Searching Eye',
    name_fr = 'Oeil inquisiteur',
    updated_at = NOW()
WHERE id = '9b07042b-9815-4d94-b736-c245966c0b7a';

-- Les Dragons: Refuge
UPDATE cards SET
    name_en = 'Refuge',
    name_fr = 'Refuge',
    updated_at = NOW()
WHERE id = '0854707b-f2cb-4a83-8283-14842609533c';

-- Les Dragons: Scatha
UPDATE cards SET
    name_en = 'Scatha',
    name_fr = 'Scatha',
    updated_at = NOW()
WHERE id = '8104db52-a59c-4960-8e8a-741e65b8a8cd';

-- Les Dragons: Scorba
UPDATE cards SET
    name_en = 'Scorba',
    name_fr = 'Scorba',
    updated_at = NOW()
WHERE id = '103e1501-04c1-4b48-b305-e0a0daee2a31';

-- Les Dragons: Sentier elfique
UPDATE cards SET
    name_en = 'Elf-path',
    name_fr = 'Sentier elfique',
    updated_at = NOW()
WHERE id = '3f5f5b15-c753-495f-aea6-b779f759d929';

-- Les Dragons: Tharbad
UPDATE cards SET
    name_en = 'Tharbad',
    name_fr = 'Tharbad',
    updated_at = NOW()
WHERE id = '8bac83ba-674c-4c48-9b30-213d3b52efc1';

-- Les Sorciers: Adrazar
UPDATE cards SET
    name_en = 'Adrazar',
    name_fr = 'Adrazar',
    updated_at = NOW()
WHERE id = '13a04c51-2937-44ab-9356-7c694d46fa87';

-- Les Sorciers: Agburanar
UPDATE cards SET
    name_en = 'Agburanar',
    name_fr = 'Agburanar',
    updated_at = NOW()
WHERE id = '333aff36-fb4b-4400-a9ae-8aee1d7ea2af';

-- Les Sorciers: Alatar
UPDATE cards SET
    name_en = 'Alatar',
    name_fr = 'Alatar',
    updated_at = NOW()
WHERE id = 'eb6e93bc-e33a-4506-84ba-e0172e288ef3';

-- Les Sorciers: Amon Hen
UPDATE cards SET
    name_en = 'Amon Hen',
    name_fr = 'Amon Hen',
    updated_at = NOW()
WHERE id = '33775080-2fb1-4fc4-8a35-79a48974a76f';

-- Les Sorciers: Anborn
UPDATE cards SET
    name_en = 'Anborn',
    name_fr = 'Anborn',
    updated_at = NOW()
WHERE id = '6e33a757-add6-4efa-9519-47ac8c4fac88';

-- Les Sorciers: Andrast
UPDATE cards SET
    name_en = 'Andrast',
    name_fr = 'Andrast',
    updated_at = NOW()
WHERE id = '882e1adb-e3cf-416e-83d8-04f6a451cb61';

-- Les Sorciers: Anfalas
UPDATE cards SET
    name_en = 'Anfalas',
    name_fr = 'Anfalas',
    updated_at = NOW()
WHERE id = '438e68cf-1830-40f9-81ff-b77735879e2d';

-- Les Sorciers: Angmar
UPDATE cards SET
    name_en = 'Angmar',
    name_fr = 'Angmar',
    updated_at = NOW()
WHERE id = '6f23e190-4fe2-489a-a6cb-7788dc42fde2';

-- Les Sorciers: Annalena
UPDATE cards SET
    name_en = 'Annalena',
    name_fr = 'Annalena',
    updated_at = NOW()
WHERE id = '3fd3c876-0258-48aa-aa36-abc910f1e68a';

-- Les Sorciers: Anórien
UPDATE cards SET
    name_en = 'Anórien',
    name_fr = 'Anórien',
    updated_at = NOW()
WHERE id = 'b67e7711-8a21-4cb4-92a5-c3cccd55ad83';

-- Les Sorciers: Aragorn II
UPDATE cards SET
    name_en = 'Aragorn II',
    name_fr = 'Aragorn II',
    updated_at = NOW()
WHERE id = 'b3bf7995-2e10-44f8-a11b-5702648db632';

-- Les Sorciers: Arthedain
UPDATE cards SET
    name_en = 'Arthedain',
    name_fr = 'Arthedain',
    updated_at = NOW()
WHERE id = '2824c1d7-135d-4547-a6d2-3ea7d7647895';

-- Les Sorciers: Arwen
UPDATE cards SET
    name_en = 'Arwen',
    name_fr = 'Arwen',
    updated_at = NOW()
WHERE id = 'fcc5ca57-dd89-4711-8524-35eb092bdc16';

-- Les Sorciers: Assassin
UPDATE cards SET
    name_en = 'Assassin',
    name_fr = 'Assassin',
    updated_at = NOW()
WHERE id = 'd9400372-97d0-46f4-9cb2-7ef75f21a14a';

-- Les Sorciers: Athelas
UPDATE cards SET
    name_en = 'Athelas',
    name_fr = 'Athelas',
    updated_at = NOW()
WHERE id = '822ff136-7eaf-4758-81dd-7d596e9a3c31';

-- Les Sorciers: Belfalas
UPDATE cards SET
    name_en = 'Belfalas',
    name_fr = 'Belfalas',
    updated_at = NOW()
WHERE id = 'b64d34a2-19dc-49aa-9b50-b610312e6979';

-- Les Sorciers: Beorn
UPDATE cards SET
    name_en = 'Beorn',
    name_fr = 'Beorn',
    updated_at = NOW()
WHERE id = 'c72ca8fc-3e40-4ec6-b265-1934f77ca224';

-- Les Sorciers: Beregond
UPDATE cards SET
    name_en = 'Beregond',
    name_fr = 'Beregond',
    updated_at = NOW()
WHERE id = '500d2f4c-ee9d-464b-859b-142e586cc1e6';

-- Les Sorciers: Beretar
UPDATE cards SET
    name_en = 'Beretar',
    name_fr = 'Beretar',
    updated_at = NOW()
WHERE id = '97b3c34a-3c6e-40c9-b75e-3ee07e619683';

-- Les Sorciers: Bergil
UPDATE cards SET
    name_en = 'Bergil',
    name_fr = 'Bergil',
    updated_at = NOW()
WHERE id = 'b19ae6dc-d03b-4a61-b0a6-8115ead9adac';

-- Les Sorciers: Bifur
UPDATE cards SET
    name_en = 'Bifur',
    name_fr = 'Bifur',
    updated_at = NOW()
WHERE id = '4dc0e359-8c2d-4750-b7d0-032a54a07dc0';

-- Les Sorciers: Bofur
UPDATE cards SET
    name_en = 'Bofur',
    name_fr = 'Bofur',
    updated_at = NOW()
WHERE id = '34a5a3c6-7c4a-4d2a-8988-d94e61c40c20';

-- Les Sorciers: Bombur
UPDATE cards SET
    name_en = 'Bombur',
    name_fr = 'Bombur',
    updated_at = NOW()
WHERE id = '4225e368-9365-43c8-b189-9cb889dca4b6';

-- Les Sorciers: Boromir II
UPDATE cards SET
    name_en = 'Boromir II',
    name_fr = 'Boromir II',
    updated_at = NOW()
WHERE id = '49c74fe9-c704-4021-a173-c62eec767398';

-- Les Sorciers: Bree
UPDATE cards SET
    name_en = 'Bree',
    name_fr = 'Bree',
    updated_at = NOW()
WHERE id = '1d503979-c2f7-4dd5-9505-657e416c2d69';

-- Les Sorciers: Brigands
UPDATE cards SET
    name_en = 'Brigands',
    name_fr = 'Brigands',
    updated_at = NOW()
WHERE id = 'eaea3298-dd83-460f-8604-dbb36be2defd';

-- Les Sorciers: Cameth Brin
UPDATE cards SET
    name_en = 'Cameth Brin',
    name_fr = 'Cameth Brin',
    updated_at = NOW()
WHERE id = 'a7842718-6848-4ea8-81d4-7a4ccffc2927';

-- Les Sorciers: Cardolan
UPDATE cards SET
    name_en = 'Cardolan',
    name_fr = 'Cardolan',
    updated_at = NOW()
WHERE id = '88bed807-45dc-4053-8a48-83db11affef0';

-- Les Sorciers: Celeborn
UPDATE cards SET
    name_en = 'Celeborn',
    name_fr = 'Celeborn',
    updated_at = NOW()
WHERE id = 'e83aaa7a-dfcf-455f-9d43-3bc53a4847d4';

-- Les Sorciers: Cirith Ungol
UPDATE cards SET
    name_en = 'Cirith Ungol',
    name_fr = 'Cirith Ungol',
    updated_at = NOW()
WHERE id = '50efda4b-8ec6-4a5e-b548-89574ad22613';

-- Les Sorciers: Círdan
UPDATE cards SET
    name_en = 'Círdan',
    name_fr = 'Círdan',
    updated_at = NOW()
WHERE id = '78ff2739-12b2-4703-a6f9-7d99acd89a82';

-- Les Sorciers: Daelomin
UPDATE cards SET
    name_en = 'Daelomin',
    name_fr = 'Daelomin',
    updated_at = NOW()
WHERE id = '844925f3-f678-4503-b0cd-d688b69634e3';

-- Les Sorciers: Dagorlad
UPDATE cards SET
    name_en = 'Dagorlad',
    name_fr = 'Dagorlad',
    updated_at = NOW()
WHERE id = 'a6e74ac3-c27e-471a-9e59-85279ea860f0';

-- Les Sorciers: Damrod
UPDATE cards SET
    name_en = 'Damrod',
    name_fr = 'Damrod',
    updated_at = NOW()
WHERE id = '3749e8bb-f945-42e9-bc50-5560e7c032af';

-- Les Sorciers: Denethor II
UPDATE cards SET
    name_en = 'Denethor II',
    name_fr = 'Denethor II',
    updated_at = NOW()
WHERE id = 'ed58ca1c-17f6-44c6-aa83-674f4661a276';

-- Les Sorciers: Dol Amroth
UPDATE cards SET
    name_en = 'Dol Amroth',
    name_fr = 'Dol Amroth',
    updated_at = NOW()
WHERE id = '967d1bca-6381-4c78-a916-aa9b644810b6';

-- Les Sorciers: Dol Guldur
UPDATE cards SET
    name_en = 'Dol Guldur',
    name_fr = 'Dol Guldur',
    updated_at = NOW()
WHERE id = 'f74f8776-3ab1-4825-9d93-f745f4436cc6';

-- Les Sorciers: Dori
UPDATE cards SET
    name_en = 'Dori',
    name_fr = 'Dori',
    updated_at = NOW()
WHERE id = '43b4ef6e-0758-4e1e-81a8-4521102c8f16';

-- Les Sorciers: Dorwinion
UPDATE cards SET
    name_en = 'Dorwinion',
    name_fr = 'Dorwinion',
    updated_at = NOW()
WHERE id = '5445262a-df40-4017-9760-34ea326d1a92';

-- Les Sorciers: Dunharrow
UPDATE cards SET
    name_en = 'Dunharrow',
    name_fr = 'Dunharrow',
    updated_at = NOW()
WHERE id = '42e0df19-dcb1-4032-960e-b5a18ea7d128';

-- Les Sorciers: Edhellond
UPDATE cards SET
    name_en = 'Edhellond',
    name_fr = 'Edhellond',
    updated_at = NOW()
WHERE id = '2b69239a-24bc-42de-90df-a528d8c5e851';

-- Les Sorciers: Edoras
UPDATE cards SET
    name_en = 'Edoras',
    name_fr = 'Edoras',
    updated_at = NOW()
WHERE id = '07f67f96-5335-4748-bb91-8b17dfba026e';

-- Les Sorciers: Elladan
UPDATE cards SET
    name_en = 'Elladan',
    name_fr = 'Elladan',
    updated_at = NOW()
WHERE id = '99839b4d-15f8-4940-a5e2-4a06a854d7fa';

-- Les Sorciers: Elrohir
UPDATE cards SET
    name_en = 'Elrohir',
    name_fr = 'Elrohir',
    updated_at = NOW()
WHERE id = 'bce89fbd-95dd-45c0-83c2-875e7fafa21b';

-- Les Sorciers: Elrond
UPDATE cards SET
    name_en = 'Elrond',
    name_fr = 'Elrond',
    updated_at = NOW()
WHERE id = '5ab223d1-8392-4d6f-92dd-e677d669cca3';

-- Les Sorciers: Enedwaith
UPDATE cards SET
    name_en = 'Enedwaith',
    name_fr = 'Enedwaith',
    updated_at = NOW()
WHERE id = '1b92f80c-bc49-4fa0-b1a6-4e7361a2500b';

-- Les Sorciers: Eomer
UPDATE cards SET
    name_en = 'Eomer',
    name_fr = 'Eomer',
    updated_at = NOW()
WHERE id = 'ec10a0ac-4064-4a1c-8736-88eed9e51af1';

-- Les Sorciers: Eowyn
UPDATE cards SET
    name_en = 'Eowyn',
    name_fr = 'Eowyn',
    updated_at = NOW()
WHERE id = 'd1a77d90-9718-44eb-85ee-6f4ed0af8e53';

-- Les Sorciers: Erkenbrand
UPDATE cards SET
    name_en = 'Erkenbrand',
    name_fr = 'Erkenbrand',
    updated_at = NOW()
WHERE id = '4e2991fb-f374-4941-8bda-5b6083dfd1d6';

-- Les Sorciers: Fangorn
UPDATE cards SET
    name_en = 'Fangorn',
    name_fr = 'Fangorn',
    updated_at = NOW()
WHERE id = '968b2833-c3a8-4ba3-b9d8-44269cf518bc';

-- Les Sorciers: Faramir
UPDATE cards SET
    name_en = 'Faramir',
    name_fr = 'Faramir',
    updated_at = NOW()
WHERE id = 'affb1b08-828f-4f8a-b03b-f09e22869b0a';

-- Les Sorciers: Forlong
UPDATE cards SET
    name_en = 'Forlong',
    name_fr = 'Forlong',
    updated_at = NOW()
WHERE id = 'dd76056c-8dd8-4f8d-9a64-0d66873fe861';

-- Les Sorciers: Forochel
UPDATE cards SET
    name_en = 'Forochel',
    name_fr = 'Forochel',
    updated_at = NOW()
WHERE id = 'f43fdf13-1cde-4f8b-963b-575fb4378d1d';

-- Les Sorciers: Fíli
UPDATE cards SET
    name_en = 'Fíli',
    name_fr = 'Fíli',
    updated_at = NOW()
WHERE id = 'b3e11df1-4795-41cf-b193-9976e1aa24c8';

-- Les Sorciers: Galadriel
UPDATE cards SET
    name_en = 'Galadriel',
    name_fr = 'Galadriel',
    updated_at = NOW()
WHERE id = '4d0401da-3b6f-43bb-994a-89e77737e920';

-- Les Sorciers: Galva
UPDATE cards SET
    name_en = 'Galva',
    name_fr = 'Galva',
    updated_at = NOW()
WHERE id = '383a7e0f-fdc0-48f4-b42e-63cf45b16c33';

-- Les Sorciers: Gandalf
UPDATE cards SET
    name_en = 'Gandalf',
    name_fr = 'Gandalf',
    updated_at = NOW()
WHERE id = '732f9565-5e02-404c-8c82-f5cea49ad424';

-- Les Sorciers: Gildor Inglorion
UPDATE cards SET
    name_en = 'Gildor Inglorion',
    name_fr = 'Gildor Inglorion',
    updated_at = NOW()
WHERE id = '6378e419-ec8d-42b0-981a-70e8372daa30';

-- Les Sorciers: Gimli
UPDATE cards SET
    name_en = 'Gimli',
    name_fr = 'Gimli',
    updated_at = NOW()
WHERE id = '537be06a-58ce-4798-9d70-1af316d0a565';

-- Les Sorciers: Glamdring
UPDATE cards SET
    name_en = 'Glamdring',
    name_fr = 'Glamdring',
    updated_at = NOW()
WHERE id = '6c6bc313-ff3e-4d52-b730-4e1c713768c6';

-- Les Sorciers: Glorfindel II
UPDATE cards SET
    name_en = 'Glorfindel II',
    name_fr = 'Glorfindel II',
    updated_at = NOW()
WHERE id = '89e96c4a-16fe-4521-8538-d953279173b9';

-- Les Sorciers: Gollum
UPDATE cards SET
    name_en = 'Gollum',
    name_fr = 'Gollum',
    updated_at = NOW()
WHERE id = 'a13970b5-6911-416f-b3e1-dd4460c4ae91';

-- Les Sorciers: Gorgoroth
UPDATE cards SET
    name_en = 'Gorgoroth',
    name_fr = 'Gorgoroth',
    updated_at = NOW()
WHERE id = '5156e593-72eb-4157-a10b-5374a8d02d2c';

-- Les Sorciers: Gundabad
UPDATE cards SET
    name_en = 'Gundabad',
    name_fr = 'Gundabad',
    updated_at = NOW()
WHERE id = 'a596039e-41bf-4892-b0b9-81fe08b0cb12';

-- Les Sorciers: Gwaihir
UPDATE cards SET
    name_en = 'Gwaihir',
    name_fr = 'Gwaihir',
    updated_at = NOW()
WHERE id = 'd8404c4a-fbdf-48a6-8c2a-0fae89bef58a';

-- Les Sorciers: Halbarad
UPDATE cards SET
    name_en = 'Halbarad',
    name_fr = 'Halbarad',
    updated_at = NOW()
WHERE id = '01919f36-7389-4b7c-b13e-41b1e4b254d3';

-- Les Sorciers: Haldalam
UPDATE cards SET
    name_en = 'Haldalam',
    name_fr = 'Haldalam',
    updated_at = NOW()
WHERE id = 'eed6b77d-83a0-42d0-8d82-e61bfe00caed';

-- Les Sorciers: Haldir
UPDATE cards SET
    name_en = 'Haldir',
    name_fr = 'Haldir',
    updated_at = NOW()
WHERE id = '911f555a-c77c-4096-9881-8a0381fcbf57';

-- Les Sorciers: Harondor
UPDATE cards SET
    name_en = 'Harondor',
    name_fr = 'Harondor',
    updated_at = NOW()
WHERE id = 'bfd82b72-415e-4292-b29b-879c117ccb08';

-- Les Sorciers: Himring
UPDATE cards SET
    name_en = 'Himring',
    name_fr = 'Himring',
    updated_at = NOW()
WHERE id = 'a809ea74-c71e-4631-81b0-be1fa4888b10';

-- Les Sorciers: Hobbits
UPDATE cards SET
    name_en = 'Hobbits',
    name_fr = 'Hobbits',
    updated_at = NOW()
WHERE id = '114a7cc9-27f3-4c82-ae87-def1c4324c07';

-- Les Sorciers: Huorn
UPDATE cards SET
    name_en = 'Huorn',
    name_fr = 'Huorn',
    updated_at = NOW()
WHERE id = 'de77e1b9-c18f-45a9-beb8-a32ff72bce48';

-- Les Sorciers: Háma
UPDATE cards SET
    name_en = 'Háma',
    name_fr = 'Háma',
    updated_at = NOW()
WHERE id = '66751473-dc89-442b-8b53-6153cb1e9546';

-- Les Sorciers: Imlad Morgul
UPDATE cards SET
    name_en = 'Imlad Morgul',
    name_fr = 'Imlad Morgul',
    updated_at = NOW()
WHERE id = '21bcb067-55b3-485b-b2c1-d22e0979947b';

-- Les Sorciers: Imrahil
UPDATE cards SET
    name_en = 'Imrahil',
    name_fr = 'Imrahil',
    updated_at = NOW()
WHERE id = 'cf330977-8bd6-48d2-9769-8e8a07794673';

-- Les Sorciers: Isengard
UPDATE cards SET
    name_en = 'Isengard',
    name_fr = 'Isengard',
    updated_at = NOW()
WHERE id = '88b24390-cf39-4aab-bdff-6f8b74351453';

-- Les Sorciers: Ithilien
UPDATE cards SET
    name_en = 'Ithilien',
    name_fr = 'Ithilien',
    updated_at = NOW()
WHERE id = '1aba34d8-3aba-4ee1-a5de-33186a80c204';

-- Les Sorciers: Khand
UPDATE cards SET
    name_en = 'Khand',
    name_fr = 'Khand',
    updated_at = NOW()
WHERE id = '3f7fc716-0f25-4bbf-8df8-08b1e94a17e0';

-- Les Sorciers: Kíli
UPDATE cards SET
    name_en = 'Kíli',
    name_fr = 'Kíli',
    updated_at = NOW()
WHERE id = '7ad42f6b-0869-4fe2-b812-dcb33c3f570f';

-- Les Sorciers: Lamedon
UPDATE cards SET
    name_en = 'Lamedon',
    name_fr = 'Lamedon',
    updated_at = NOW()
WHERE id = 'eaa15b2f-af04-4980-a45a-cb437540ae28';

-- Les Sorciers: Lassitude du coeur
UPDATE cards SET
    name_en = 'Weariness of the Heart',
    name_fr = 'Lassitude du coeur',
    updated_at = NOW()
WHERE id = 'e4e5daff-1b9f-484b-9eec-eec45cc56301';

-- Les Sorciers: Lebennin
UPDATE cards SET
    name_en = 'Lebennin',
    name_fr = 'Lebennin',
    updated_at = NOW()
WHERE id = 'e2ead620-6ce3-4714-83e3-e12a5b489a9c';

-- Les Sorciers: Legolas
UPDATE cards SET
    name_en = 'Legolas',
    name_fr = 'Legolas',
    updated_at = NOW()
WHERE id = '1b1551a1-7cd3-4572-8f2c-ca99d9ea5dbb';

-- Les Sorciers: Leucaruth
UPDATE cards SET
    name_en = 'Leucaruth',
    name_fr = 'Leucaruth',
    updated_at = NOW()
WHERE id = 'ef1cdf77-6166-4436-b70d-bed108fe3305';

-- Les Sorciers: Lindon
UPDATE cards SET
    name_en = 'Lindon',
    name_fr = 'Lindon',
    updated_at = NOW()
WHERE id = '0d761b27-c522-40ea-a573-c99919514ebc';

-- Les Sorciers: Lond Galen
UPDATE cards SET
    name_en = 'Lond Galen',
    name_fr = 'Lond Galen',
    updated_at = NOW()
WHERE id = '16b7e1d1-c622-4303-8693-d018e6e75afc';

-- Les Sorciers: Lossoth
UPDATE cards SET
    name_en = 'Lossoth',
    name_fr = 'Lossoth',
    updated_at = NOW()
WHERE id = '288c46f5-a32d-4216-950c-584ed7f08072';

-- Les Sorciers: Lórien
UPDATE cards SET
    name_en = 'Lórien',
    name_fr = 'Lórien',
    updated_at = NOW()
WHERE id = '0d242b5b-48a9-445f-bb28-46e7cc41bd0a';

-- Les Sorciers: Mablung
UPDATE cards SET
    name_en = 'Mablung',
    name_fr = 'Mablung',
    updated_at = NOW()
WHERE id = '67e4213e-bae9-41be-88f3-d9d316b4453e';

-- Les Sorciers: Minas Morgul
UPDATE cards SET
    name_en = 'Minas Morgul',
    name_fr = 'Minas Morgul',
    updated_at = NOW()
WHERE id = 'aa1f26e8-44d9-4527-8091-e5401a7f2b64';

-- Les Sorciers: Minas Tirith
UPDATE cards SET
    name_en = 'Minas Tirith',
    name_fr = 'Minas Tirith',
    updated_at = NOW()
WHERE id = '48269002-dbfa-431d-bc86-42451e6c7c54';

-- Les Sorciers: Miruvor
UPDATE cards SET
    name_en = 'Miruvor',
    name_fr = 'Miruvor',
    updated_at = NOW()
WHERE id = '150532c7-618c-45c9-9698-eb1603dd454f';

-- Les Sorciers: Morannon
UPDATE cards SET
    name_en = 'Morannon',
    name_fr = 'Morannon',
    updated_at = NOW()
WHERE id = '3c2326c5-dd5c-4edd-8bfa-1c18458a337b';

-- Les Sorciers: Moria
UPDATE cards SET
    name_en = 'Moria',
    name_fr = 'Moria',
    updated_at = NOW()
WHERE id = '3f8ab5f8-8cdf-4238-a2b8-bd66df5fec61';

-- Les Sorciers: Narsil
UPDATE cards SET
    name_en = 'Narsil',
    name_fr = 'Narsil',
    updated_at = NOW()
WHERE id = '7f18a262-2db0-48ab-806f-6d2169b82724';

-- Les Sorciers: Narya
UPDATE cards SET
    name_en = 'Narya',
    name_fr = 'Narya',
    updated_at = NOW()
WHERE id = '0d54338f-76e9-4387-bdb1-73867bd33721';

-- Les Sorciers: Nenya
UPDATE cards SET
    name_en = 'Nenya',
    name_fr = 'Nenya',
    updated_at = NOW()
WHERE id = '732cc2fd-0415-406e-8514-4558ef65ed7d';

-- Les Sorciers: Nori
UPDATE cards SET
    name_en = 'Nori',
    name_fr = 'Nori',
    updated_at = NOW()
WHERE id = 'dcd89574-272c-4596-a531-b4bcf4fbb4e6';

-- Les Sorciers: Nurn
UPDATE cards SET
    name_en = 'Nurn',
    name_fr = 'Nurn',
    updated_at = NOW()
WHERE id = 'b25f2659-d5e3-4dba-a945-d4cfc9755f6d';

-- Les Sorciers: Númeriador
UPDATE cards SET
    name_en = 'Númeriador',
    name_fr = 'Númeriador',
    updated_at = NOW()
WHERE id = 'c45af2df-ee83-459a-915e-b0852e3980d7';

-- Les Sorciers: Oeil de Sauron
UPDATE cards SET
    name_en = 'Eye of Sauron',
    name_fr = 'Oeil de Sauron',
    updated_at = NOW()
WHERE id = '2baea4c2-84f3-4a3b-82f0-c937604a6c34';

-- Les Sorciers: Orcrist
UPDATE cards SET
    name_en = 'Orcrist',
    name_fr = 'Orcrist',
    updated_at = NOW()
WHERE id = '3729f918-a25e-4386-ab35-58fe41eba912';

-- Les Sorciers: Ori
UPDATE cards SET
    name_en = 'Ori',
    name_fr = 'Ori',
    updated_at = NOW()
WHERE id = 'aae63935-21f2-4a17-a601-798532558644';

-- Les Sorciers: Orophin
UPDATE cards SET
    name_en = 'Orophin',
    name_fr = 'Orophin',
    updated_at = NOW()
WHERE id = '3c2f73a9-60e4-4c96-8513-623c1ada639d';

-- Les Sorciers: Ost-in-Edhil
UPDATE cards SET
    name_en = 'Ost-in-Edhil',
    name_fr = 'Ost-in-Edhil',
    updated_at = NOW()
WHERE id = 'd847e442-adf4-4885-a0c1-406757e718c5';

-- Les Sorciers: Pallando
UPDATE cards SET
    name_en = 'Pallando',
    name_fr = 'Pallando',
    updated_at = NOW()
WHERE id = '9cdbb1a3-98f0-4f65-ab8e-d21c91074405';

-- Les Sorciers: Parole de persuasion
UPDATE cards SET
    name_en = 'Persuasive Words',
    name_fr = 'Parole de persuasion',
    updated_at = NOW()
WHERE id = '18b719af-c949-42ec-bb33-ddc339910bd9';

-- Les Sorciers: Peath
UPDATE cards SET
    name_en = 'Peath',
    name_fr = 'Peath',
    updated_at = NOW()
WHERE id = '618cdbdf-41a7-4dee-915f-0cfacd92d67e';

-- Les Sorciers: Pelargir
UPDATE cards SET
    name_en = 'Pelargir',
    name_fr = 'Pelargir',
    updated_at = NOW()
WHERE id = '3d941aa8-6715-49f2-9707-e76dec0439f0';

-- Les Sorciers: Pippin
UPDATE cards SET
    name_en = 'Pippin',
    name_fr = 'Pippin',
    updated_at = NOW()
WHERE id = '2bc84489-d3b7-4b1b-8761-544653444409';

-- Les Sorciers: Radagast
UPDATE cards SET
    name_en = 'Radagast',
    name_fr = 'Radagast',
    updated_at = NOW()
WHERE id = '82ea60b3-bcab-4806-bd6f-762e79c2802e';

-- Les Sorciers: Rhosgobel
UPDATE cards SET
    name_en = 'Rhosgobel',
    name_fr = 'Rhosgobel',
    updated_at = NOW()
WHERE id = 'f913c14c-c2aa-410b-bb15-ae6be0eb384c';

-- Les Sorciers: Rhovanion Septentrional
UPDATE cards SET
    name_en = 'Northern Rhovanion',
    name_fr = 'Rhovanion Septentrional',
    updated_at = NOW()
WHERE id = 'b74d44e8-3ff0-400a-83e8-8fa65d55e333';

-- Les Sorciers: Rhudaur
UPDATE cards SET
    name_en = 'Rhudaur',
    name_fr = 'Rhudaur',
    updated_at = NOW()
WHERE id = 'a7da202c-13dc-4023-85d6-831a8db6a3e2';

-- Les Sorciers: Rogrog
UPDATE cards SET
    name_en = 'Rogrog',
    name_fr = 'Rogrog',
    updated_at = NOW()
WHERE id = '8b19d863-0378-4cd1-bce2-7245996d8769';

-- Les Sorciers: Rohan
UPDATE cards SET
    name_en = 'Rohan',
    name_fr = 'Rohan',
    updated_at = NOW()
WHERE id = '0d61a05b-a1ff-497e-bb4e-54d48c9ed791';

-- Les Sorciers: Sarn Goriwing
UPDATE cards SET
    name_en = 'Sarn Goriwing',
    name_fr = 'Sarn Goriwing',
    updated_at = NOW()
WHERE id = 'a02078f6-0426-4d6f-bd86-39afd1e38648';

-- Les Sorciers: Shrel-Kain
UPDATE cards SET
    name_en = 'Shrel-Kain',
    name_fr = 'Shrel-Kain',
    updated_at = NOW()
WHERE id = '0eecb689-ec2c-4b6c-ba78-9e2c72cc7e89';

-- Les Sorciers: Smaug
UPDATE cards SET
    name_en = 'Smaug',
    name_fr = 'Smaug',
    updated_at = NOW()
WHERE id = 'bb59f353-d9ac-4326-9394-bbbdf5f36aaa';

-- Les Sorciers: Thranduil
UPDATE cards SET
    name_en = 'Thranduil',
    name_fr = 'Thranduil',
    updated_at = NOW()
WHERE id = '80c11de9-3e97-41dd-9c97-dd3cde8ddd72';

-- Les Sorciers: Tolfalas
UPDATE cards SET
    name_en = 'Tolfalas',
    name_fr = 'Tolfalas',
    updated_at = NOW()
WHERE id = '151e4141-8519-4f0b-8670-eae5c6c13a18';

-- Les Sorciers: Tom Bombadil
UPDATE cards SET
    name_en = 'Tom Bombadil',
    name_fr = 'Tom Bombadil',
    updated_at = NOW()
WHERE id = 'b3598ade-a959-4181-94e5-016f06b27d39';

-- Les Sorciers: Utiliser un Palantir
UPDATE cards SET
    name_en = 'Use Palantir',
    name_fr = 'Utiliser un Palantir',
    updated_at = NOW()
WHERE id = '21fc53b7-d471-403b-9e12-5a986c04ba8e';

-- Les Sorciers: Uvatha le Cavalier
UPDATE cards SET
    name_en = 'Ûvatha the Horseman',
    name_fr = 'Uvatha le Cavalier',
    updated_at = NOW()
WHERE id = 'fe1107c5-3147-493b-99d3-0787c6f8bb13';

-- Les Sorciers: Vilya
UPDATE cards SET
    name_en = 'Vilya',
    name_fr = 'Vilya',
    updated_at = NOW()
WHERE id = 'a8349edd-523a-4af8-9159-6539d7585cb4';

-- Les Sorciers: Vygavril
UPDATE cards SET
    name_en = 'Vygavril',
    name_fr = 'Vygavril',
    updated_at = NOW()
WHERE id = '2d41f969-1959-40d4-b100-084126ba0634';

-- Les Sorciers: Wacho
UPDATE cards SET
    name_en = 'Wacho',
    name_fr = 'Wacho',
    updated_at = NOW()
WHERE id = '13370465-2f5a-46e8-a58e-082a8aa40610';

-- Sombres Séides: Aiglos
UPDATE cards SET
    name_en = 'Aiglos',
    name_fr = 'Aiglos',
    updated_at = NOW()
WHERE id = '8fd2b1c4-ea58-4b46-9978-ca85a8457d0d';

-- Sombres Séides: Anarin
UPDATE cards SET
    name_en = 'Anarin',
    name_fr = 'Anarin',
    updated_at = NOW()
WHERE id = '200052bd-f56b-4f2c-ad60-e7c882417714';

-- Sombres Séides: Baduila
UPDATE cards SET
    name_en = 'Baduila',
    name_fr = 'Baduila',
    updated_at = NOW()
WHERE id = 'cfb4f542-ad4c-48be-b63e-14d28313c861';

-- Sombres Séides: Deallus
UPDATE cards SET
    name_en = 'Deallus',
    name_fr = 'Deallus',
    updated_at = NOW()
WHERE id = '71e0351c-c9dd-4b0c-9872-629e05d0c849';

-- Sombres Séides: Drór
UPDATE cards SET
    name_en = 'Drór',
    name_fr = 'Drór',
    updated_at = NOW()
WHERE id = '6b3d903e-3a22-4cc7-9ae9-8dcfc80813ad';

-- Sombres Séides: Elerína
UPDATE cards SET
    name_en = 'Elerína',
    name_fr = 'Elerína',
    updated_at = NOW()
WHERE id = '5a1b36db-e0fd-464c-940b-4bb48a2113b5';

-- Sombres Séides: Elwen
UPDATE cards SET
    name_en = 'Elwen',
    name_fr = 'Elwen',
    updated_at = NOW()
WHERE id = '4ceb96d5-c667-4cd5-a1bf-910a34042049';

-- Sombres Séides: Eun
UPDATE cards SET
    name_en = 'Eun',
    name_fr = 'Eun',
    updated_at = NOW()
WHERE id = '8c50e5b8-6d00-41ea-9745-bf2930f5f53b';

-- Sombres Séides: Firiel
UPDATE cards SET
    name_en = 'Firiel',
    name_fr = 'Firiel',
    updated_at = NOW()
WHERE id = 'a1640c47-c525-4792-a585-96d66422f595';

-- Sombres Séides: Gergeli
UPDATE cards SET
    name_en = 'Gergeli',
    name_fr = 'Gergeli',
    updated_at = NOW()
WHERE id = '35335371-21c5-4b35-b0c5-ae625e264960';

-- Sombres Séides: Gisulf
UPDATE cards SET
    name_en = 'Gisulf',
    name_fr = 'Gisulf',
    updated_at = NOW()
WHERE id = 'f8f8f822-8196-4a89-8df1-d66a69f1513a';

-- Sombres Séides: Golodhros
UPDATE cards SET
    name_en = 'Golodhros',
    name_fr = 'Golodhros',
    updated_at = NOW()
WHERE id = '30daed50-2da2-4bcf-b234-48082b1941cd';

-- Sombres Séides: Herion
UPDATE cards SET
    name_en = 'Herion',
    name_fr = 'Herion',
    updated_at = NOW()
WHERE id = '63b139e4-287e-4d9a-b002-e0acf01b0c39';

-- Sombres Séides: Ivic
UPDATE cards SET
    name_en = 'Ivic',
    name_fr = 'Ivic',
    updated_at = NOW()
WHERE id = '8f273238-a2d7-4787-90e5-f821726cfc91';

-- Sombres Séides: Leamon
UPDATE cards SET
    name_en = 'Leamon',
    name_fr = 'Leamon',
    updated_at = NOW()
WHERE id = '4b10842f-a062-4835-8fc4-ff34d3b27f75';

-- Sombres Séides: Mallorn
UPDATE cards SET
    name_en = 'Mallorn',
    name_fr = 'Mallorn',
    updated_at = NOW()
WHERE id = '8bb8b1f4-456f-41b2-ba86-ca72922a9d14';

-- Sombres Séides: Mithril
UPDATE cards SET
    name_en = 'Mithril',
    name_fr = 'Mithril',
    updated_at = NOW()
WHERE id = '11cd39dd-c09c-44f0-8a29-b6a2ac404919';

-- Sombres Séides: Nimloth
UPDATE cards SET
    name_en = 'Nimloth',
    name_fr = 'Nimloth',
    updated_at = NOW()
WHERE id = '63ede61b-9aed-4448-b7d8-12342b7e65f0';

-- Sombres Séides: Súrion
UPDATE cards SET
    name_en = 'Súrion',
    name_fr = 'Súrion',
    updated_at = NOW()
WHERE id = '04e8d657-7a14-4416-8f44-ef829981f6d6';

-- Sombres Séides: Taladhan
UPDATE cards SET
    name_en = 'Taladhan',
    name_fr = 'Taladhan',
    updated_at = NOW()
WHERE id = '32694931-add2-4aa1-85f1-0272d4452eab';

-- Sombres Séides: Urlutsu Nurn
UPDATE cards SET
    name_en = 'Urlutsu Nurn',
    name_fr = 'Urlutsu Nurn',
    updated_at = NOW()
WHERE id = '0161d087-18a2-4ea4-82d4-a687eaaf5536';

-- Sombres Séides: Woffung
UPDATE cards SET
    name_en = 'Woffung',
    name_fr = 'Woffung',
    updated_at = NOW()
WHERE id = '1be8085f-0a54-4bb2-a3d2-8681203b1ef9';

-- NO_FR_TRANSLATION_EXPECTED (59 cards)
-- ======================================================================

-- Against the Shadow: Asdriags
UPDATE cards SET
    name_en = 'Asdriags',
    name_fr = 'Asdriags',
    updated_at = NOW()
WHERE id = '14b29d69-4cb6-42b9-9ba1-4fa25eb1df18';

-- Against the Shadow: Cirith Gorgor
UPDATE cards SET
    name_en = 'Cirith Gorgor',
    name_fr = 'Cirith Gorgor',
    updated_at = NOW()
WHERE id = '41b62cea-d572-4faf-83d5-7fa27a570de1';

-- Against the Shadow: Creature of and Older World
UPDATE cards SET
    name_en = 'Creature of and Older World',
    name_fr = 'Créature d’un monde plus ancien',
    updated_at = NOW()
WHERE id = '0be5f835-e9b4-4c88-8b65-c6a7fa5567f2';

-- Against the Shadow: Drughu
UPDATE cards SET
    name_en = 'Drughu',
    name_fr = 'Drughu',
    updated_at = NOW()
WHERE id = '89aaf478-4023-4b97-aaf1-3071d4853a9c';

-- Against the Shadow: Durin's Folk
UPDATE cards SET
    name_en = 'Durin''s Folk',
    name_fr = 'Le peuple de Durin',
    updated_at = NOW()
WHERE id = '19c98257-c759-43a4-b831-d289ed760d7b';

-- Against the Shadow: Dwarven Ring of Thrár's Tribe
UPDATE cards SET
    name_en = 'Dwarven Ring of Thrár''s Tribe',
    name_fr = 'Anneau Nain de la tribu de Thrár',
    updated_at = NOW()
WHERE id = 'd4e2b29b-95bb-469d-9449-e634b258aa45';

-- Against the Shadow: Eagles' Eyrie
UPDATE cards SET
    name_en = 'Eagles'' Eyrie',
    name_fr = 'Aire des Aigles',
    updated_at = NOW()
WHERE id = 'a5255d0a-f082-4993-bdcb-7a93e0af7f40';

-- Against the Shadow: Edhellond
UPDATE cards SET
    name_en = 'Edhellond',
    name_fr = 'Edhellond',
    updated_at = NOW()
WHERE id = '09250388-6768-4095-8bc7-956bc9232aa6';

-- Against the Shadow: Galadhrim
UPDATE cards SET
    name_en = 'Galadhrim',
    name_fr = 'Galadhrim',
    updated_at = NOW()
WHERE id = 'bafd1df1-6bb5-4afe-a1fa-afb3e97dabb3';

-- Against the Shadow: Geann a-Lisch
UPDATE cards SET
    name_en = 'Geann a-Lisch',
    name_fr = 'Geann a-Lisch',
    updated_at = NOW()
WHERE id = '057a4ad0-d184-4d36-be4d-a1aa2ccd081b';

-- Against the Shadow: Gobel Mírlond
UPDATE cards SET
    name_en = 'Gobel Mírlond',
    name_fr = 'Gobel Mírlond',
    updated_at = NOW()
WHERE id = '884aed43-30f4-4b18-b2ec-fadcfcb71d27';

-- Against the Shadow: Haradrim
UPDATE cards SET
    name_en = 'Haradrim',
    name_fr = 'Haradrim',
    updated_at = NOW()
WHERE id = 'b640f0d7-b6e2-444e-9359-2418e0688f74';

-- Against the Shadow: Haradrim
UPDATE cards SET
    name_en = 'Haradrim',
    name_fr = 'Haradrim',
    updated_at = NOW()
WHERE id = '99c5b52e-a023-4c23-bba7-a37293ea4326';

-- Against the Shadow: Himring
UPDATE cards SET
    name_en = 'Himring',
    name_fr = 'Himring',
    updated_at = NOW()
WHERE id = 'bf5ae960-cc2a-442b-aea3-70b613bf5ab7';

-- Against the Shadow: Lórien
UPDATE cards SET
    name_en = 'Lórien',
    name_fr = 'Lórien',
    updated_at = NOW()
WHERE id = 'b0880e67-fdec-4801-bf72-4d63ddfd435d';

-- Against the Shadow: Perchen
UPDATE cards SET
    name_en = 'Perchen',
    name_fr = 'Perchen',
    updated_at = NOW()
WHERE id = 'b685c62c-5aec-45ed-bdc7-6f7d67027023';

-- Against the Shadow: Rhosgobel
UPDATE cards SET
    name_en = 'Rhosgobel',
    name_fr = 'Rhosgobel',
    updated_at = NOW()
WHERE id = '34ca8f7a-c306-49db-ba39-745f2dd526c7';

-- Against the Shadow: Steward's Guard
UPDATE cards SET
    name_en = 'Steward''s Guard',
    name_fr = 'La garde de l’intendant',
    updated_at = NOW()
WHERE id = '648fbe4d-2e56-4262-8a19-fa6e7fc3443b';

-- Against the Shadow: Thrór's Map
UPDATE cards SET
    name_en = 'Thrór''s Map',
    name_fr = 'Carte de Thrór',
    updated_at = NOW()
WHERE id = 'a0e366c6-809c-4b7a-9fdc-00948bc4c92e';

-- Against the Shadow: Tolfalas
UPDATE cards SET
    name_en = 'Tolfalas',
    name_fr = 'Tolfalas',
    updated_at = NOW()
WHERE id = '81055b48-b4be-44b9-b864-ea22db4e08e4';

-- Promo: Baugur
UPDATE cards SET
    name_en = 'Baugur',
    name_fr = 'Baugur',
    updated_at = NOW()
WHERE id = 'e949137b-5186-4483-83cc-7172f9a6d0db';

-- Promo: Belegennon
UPDATE cards SET
    name_en = 'Belegennon',
    name_fr = 'Belegennon',
    updated_at = NOW()
WHERE id = '91d30bb4-948d-412b-877a-fc5b95b6285a';

-- Promo: Freca
UPDATE cards SET
    name_en = 'Freca',
    name_fr = 'Freca',
    updated_at = NOW()
WHERE id = 'aae68a40-28ba-4a8f-ac77-de558546da3d';

-- Promo: Merry
UPDATE cards SET
    name_en = 'Merry',
    name_fr = 'Merry',
    updated_at = NOW()
WHERE id = '86a85985-978a-4854-89a9-5e3c72417b7b';

-- Promo: Ringil
UPDATE cards SET
    name_en = 'Ringil',
    name_fr = 'Ringil',
    updated_at = NOW()
WHERE id = '99512ba9-18a4-496e-9c1d-1390ce7124e0';

-- Promo: The Pack at the Door
UPDATE cards SET
    name_en = 'Une meute à la porte',
    name_fr = 'The Pack at the Door',
    updated_at = NOW()
WHERE id = 'a00dbb96-bce0-4371-ac26-2b56ad4e33e7';

-- Promo: Wolf
UPDATE cards SET
    name_en = 'Wolf',
    name_fr = 'Wolf',
    updated_at = NOW()
WHERE id = '36c3b87c-ac89-4e8c-b3b9-b5b25f534e3c';

-- The Balrog: Azog
UPDATE cards SET
    name_en = 'Azog',
    name_fr = 'Azog',
    updated_at = NOW()
WHERE id = '3e2328a2-475c-4ff2-80ba-899a2ea4570d';

-- The Balrog: Bolg
UPDATE cards SET
    name_en = 'Bolg',
    name_fr = 'Bolg',
    updated_at = NOW()
WHERE id = '36d583c2-55cd-4b46-91fc-584b60e64d0d';

-- The Balrog: Cirith Gorgor
UPDATE cards SET
    name_en = 'Cirith Gorgor',
    name_fr = 'Cirith Gorgor',
    updated_at = NOW()
WHERE id = '62b9f6fc-b11b-4139-9dc7-bcb42ee4b862';

-- The Balrog: Cirith Ungol
UPDATE cards SET
    name_en = 'Cirith Ungol',
    name_fr = 'Cirith Ungol',
    updated_at = NOW()
WHERE id = '2ffce04e-a420-4036-90d9-81f89502cef6';

-- The Balrog: Dol Guldur
UPDATE cards SET
    name_en = 'Dol Guldur',
    name_fr = 'Dol Guldur',
    updated_at = NOW()
WHERE id = '524205f2-f1a7-4521-b21b-8958bed6d877';

-- The Balrog: Minas Morgul
UPDATE cards SET
    name_en = 'Minas Morgul',
    name_fr = 'Minas Morgul',
    updated_at = NOW()
WHERE id = 'c7c4cecb-e862-4fe3-b4b7-c6590b6d3aa3';

-- The Balrog: Moria
UPDATE cards SET
    name_en = 'Moria',
    name_fr = 'Moria',
    updated_at = NOW()
WHERE id = 'b00cf5ea-6774-4fb8-9199-b92698ce0cf0';

-- The Balrog: Press Gang
UPDATE cards SET
    name_en = 'Recruteur',
    name_fr = 'Press Gang',
    updated_at = NOW()
WHERE id = '57616221-6ae5-48de-b4a8-52886553ac8f';

-- The Balrog: Sauron
UPDATE cards SET
    name_en = 'Sauron',
    name_fr = 'Sauron',
    updated_at = NOW()
WHERE id = '47eb4f8c-3e33-4c28-ab8c-d80581431c00';

-- The Balrog: Umagaur
UPDATE cards SET
    name_en = 'Umagaur',
    name_fr = 'Umagaur',
    updated_at = NOW()
WHERE id = '649b43b7-4e00-4e83-9bb7-444f8cd0a397';

-- The Balrog: Whip of Many Tongues
UPDATE cards SET
    name_en = 'Whip of many Thongs',
    name_fr = 'Fouet à multiples lanières',
    updated_at = NOW()
WHERE id = '7bc92fd7-2c59-41a7-9a35-25aceda80321';

-- The White Hand: Alatar
UPDATE cards SET
    name_en = 'Alatar',
    name_fr = 'Alatar',
    updated_at = NOW()
WHERE id = '4486ffe4-7381-4e8f-9789-cb7573607b03';

-- The White Hand: Delver's Harvest
UPDATE cards SET
    name_en = 'Delver''s Harvest',
    name_fr = 'Récolte du mineur',
    updated_at = NOW()
WHERE id = '02e9a5a7-e524-426b-9da4-736eb50987d6';

-- The White Hand: Doeth (Durthak)
UPDATE cards SET
    name_en = 'Doeth (Durthak)',
    name_fr = 'Doeth (Durthak)',
    updated_at = NOW()
WHERE id = '2a0eb3f4-f8a0-4f3d-a9b4-3c1d65fd4af2';

-- The White Hand: Euog (Ulzog)
UPDATE cards SET
    name_en = 'Euog (Ulzog)',
    name_fr = 'Euog (Ulzog)',
    updated_at = NOW()
WHERE id = '520f16a0-7f66-42e4-9842-06f7c2a4e3c6';

-- The White Hand: Fool's Bane
UPDATE cards SET
    name_en = 'Fool''s Bane',
    name_fr = 'Fléau des fous',
    updated_at = NOW()
WHERE id = 'b7e9d30d-b942-40ca-aa21-a8d7bb841148';

-- The White Hand: Gandalf
UPDATE cards SET
    name_en = 'Gandalf',
    name_fr = 'Gandalf',
    updated_at = NOW()
WHERE id = '1ee8a1dc-8ebc-412f-a9cb-221c81d0eef6';

-- The White Hand: Gandalf's Friend
UPDATE cards SET
    name_en = 'Gandalf''s Friend',
    name_fr = 'Ami de Gandalf',
    updated_at = NOW()
WHERE id = '2d6e73e3-5712-49da-b179-7787270c28df';

-- The White Hand: Huntsman's Garb
UPDATE cards SET
    name_en = 'Huntsman''s Garb',
    name_fr = 'Tenue de chasseur',
    updated_at = NOW()
WHERE id = '4dc06139-079b-4a7e-878f-4f1d61f95b21';

-- The White Hand: Isengard
UPDATE cards SET
    name_en = 'Isengard',
    name_fr = 'Isengard',
    updated_at = NOW()
WHERE id = 'ebcc0bc6-5025-41d4-8a01-fc458f391113';

-- The White Hand: Lugdush
UPDATE cards SET
    name_en = 'Lugdush',
    name_fr = 'Lugdush',
    updated_at = NOW()
WHERE id = 'a5c79b37-bfa1-4c05-9ca7-944a14d9427d';

-- The White Hand: Nature's Revenge
UPDATE cards SET
    name_en = 'Nature''s Revenge',
    name_fr = 'Vengeance de la nature',
    updated_at = NOW()
WHERE id = 'aa0bb658-f6c1-4d60-804c-5fbc968c0cfb';

-- The White Hand: Pallando
UPDATE cards SET
    name_en = 'Pallando',
    name_fr = 'Pallando',
    updated_at = NOW()
WHERE id = 'd83c84b3-2578-4cfa-a8b7-70f29eb57f3d';

-- The White Hand: Pallando's Apprentice
UPDATE cards SET
    name_en = 'Pallando''s Apprentice',
    name_fr = 'Apprenti de Pallando',
    updated_at = NOW()
WHERE id = 'a7d097b9-dddf-4181-9693-cd53bf38d835';

-- The White Hand: Pallando's Hood
UPDATE cards SET
    name_en = 'Pallando''s Hood',
    name_fr = 'Capuche de Pallando',
    updated_at = NOW()
WHERE id = '6208ae37-3f6a-4dd9-bb6c-9f7f59afb31e';

-- The White Hand: Radagast
UPDATE cards SET
    name_en = 'Radagast',
    name_fr = 'Radagast',
    updated_at = NOW()
WHERE id = 'c0fda95e-4584-4b23-9726-1a596aa2aff4';

-- The White Hand: Radagast's Black Bird
UPDATE cards SET
    name_en = 'Radagast''s Black Bird',
    name_fr = 'L’oiseau noir de Radagast',
    updated_at = NOW()
WHERE id = '2b9e9e0b-70dd-4428-a0df-b79e41bc59b1';

-- The White Hand: Rhosgobel
UPDATE cards SET
    name_en = 'Rhosgobel',
    name_fr = 'Rhosgobel',
    updated_at = NOW()
WHERE id = '61826bad-f0c7-4089-b03c-240889480cf9';

-- The White Hand: Saruman's Machinery
UPDATE cards SET
    name_en = 'Saruman''s Machinery',
    name_fr = 'Machinerie de Saroumane',
    updated_at = NOW()
WHERE id = '0e93b062-8445-4d0d-845d-9498341b0c60';

-- The White Hand: Saruman's Ring
UPDATE cards SET
    name_en = 'Saruman''s Ring',
    name_fr = 'L’anneau de Saroumane',
    updated_at = NOW()
WHERE id = '0e9238db-493e-469a-a263-75f12c113afd';

-- The White Hand: Wizard's Myrmidon
UPDATE cards SET
    name_en = 'Wizard''s Myrmidon',
    name_fr = 'Myrmidon du Sorcier',
    updated_at = NOW()
WHERE id = '787a2f9c-f16e-41f9-8176-f399d358ab1e';

-- The White Hand: Wizard's Trove
UPDATE cards SET
    name_en = 'Wizard''s Trove',
    name_fr = 'Trophée du Sorcier',
    updated_at = NOW()
WHERE id = '9dc8f627-434c-4b6b-9e05-4e97b0a978af';


-- Summary
-- ========
-- Total cards updated: 385
-- FRENCH_CHARS_IN_EN: 98
-- IDENTICAL_NAMES_CHECK: 228
-- NO_FR_TRANSLATION_EXPECTED: 59
