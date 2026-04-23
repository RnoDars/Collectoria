-- Migration 005: Add Books Collection (Royaumes oubliés)
-- Description: Creates tables for book collection management and imports 94 books from "Royaumes oubliés" collection
-- Date: 2026-04-23

-- ============================================================================
-- 1. CREATE TABLES
-- ============================================================================

-- Table books (catalog of books in a collection)
CREATE TABLE IF NOT EXISTS books (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    collection_id UUID NOT NULL REFERENCES collections(id) ON DELETE CASCADE,
    number VARCHAR(10) NOT NULL,
    title VARCHAR(255) NOT NULL,
    author VARCHAR(255) NOT NULL,
    publication_date DATE NOT NULL,
    book_type VARCHAR(50) NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMP NOT NULL DEFAULT NOW()
);

-- Indexes for books
CREATE INDEX idx_books_collection_id ON books(collection_id);
CREATE INDEX idx_books_number ON books(number);
CREATE INDEX idx_books_author ON books(author);
CREATE INDEX idx_books_title ON books(title);

-- Comments for books table
COMMENT ON TABLE books IS 'Catalog of books in collections (e.g., Royaumes oubliés novels)';
COMMENT ON COLUMN books.id IS 'Unique identifier for the book';
COMMENT ON COLUMN books.collection_id IS 'Reference to the collection this book belongs to';
COMMENT ON COLUMN books.number IS 'Book number in the collection (e.g., "1", "84", "HS1")';
COMMENT ON COLUMN books.title IS 'Title of the book';
COMMENT ON COLUMN books.author IS 'Author of the book';
COMMENT ON COLUMN books.publication_date IS 'Publication date of the book';
COMMENT ON COLUMN books.book_type IS 'Type of book: "roman" or "recueil de romans"';

-- Table user_books (ownership tracking for books)
CREATE TABLE IF NOT EXISTS user_books (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL,
    book_id UUID NOT NULL REFERENCES books(id) ON DELETE CASCADE,
    is_owned BOOLEAN NOT NULL DEFAULT false,
    created_at TIMESTAMP NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMP NOT NULL DEFAULT NOW(),

    UNIQUE(user_id, book_id)
);

-- Indexes for user_books
CREATE INDEX idx_user_books_user_id ON user_books(user_id);
CREATE INDEX idx_user_books_book_id ON user_books(book_id);
CREATE INDEX idx_user_books_is_owned ON user_books(user_id, is_owned);

-- Comments for user_books table
COMMENT ON TABLE user_books IS 'Tracks which books users own in their collections';
COMMENT ON COLUMN user_books.id IS 'Unique identifier for the user-book relationship';
COMMENT ON COLUMN user_books.user_id IS 'User who owns (or doesn''t own) the book';
COMMENT ON COLUMN user_books.book_id IS 'Reference to the book';
COMMENT ON COLUMN user_books.is_owned IS 'Whether the user owns this book';

-- ============================================================================
-- 2. INSERT COLLECTION
-- ============================================================================

-- Insert "Royaumes oubliés" collection
INSERT INTO collections (id, name, slug, category, total_cards, description, created_at, updated_at)
VALUES (
    '22222222-2222-2222-2222-222222222222',
    'Royaumes oubliés',
    'royaumes-oublies',
    'romans',
    94,
    'Collection de romans Forgotten Realms publiés chez Fleuve Noir',
    NOW(),
    NOW()
);

-- ============================================================================
-- 3. INSERT 94 BOOKS
-- ============================================================================

-- Série principale (84 books: 1-84)
INSERT INTO books (id, collection_id, number, title, author, publication_date, book_type) VALUES
(gen_random_uuid(), '22222222-2222-2222-2222-222222222222', '1', 'Valombre', 'Richard AWLINSON', '1994-03-01', 'roman'),
(gen_random_uuid(), '22222222-2222-2222-2222-222222222222', '2', 'Tantras', 'Richard AWLINSON', '1994-03-01', 'roman'),
(gen_random_uuid(), '22222222-2222-2222-2222-222222222222', '3', 'Eau Profonde', 'Richard AWLINSON', '1994-03-01', 'roman'),
(gen_random_uuid(), '22222222-2222-2222-2222-222222222222', '4', 'Terre natale', 'Robert Anthony SALVATORE', '1994-06-01', 'roman'),
(gen_random_uuid(), '22222222-2222-2222-2222-222222222222', '5', 'Terre d''exil', 'Robert Anthony SALVATORE', '1994-06-01', 'roman'),
(gen_random_uuid(), '22222222-2222-2222-2222-222222222222', '6', 'Terre promise', 'Robert Anthony SALVATORE', '1994-06-01', 'roman'),
(gen_random_uuid(), '22222222-2222-2222-2222-222222222222', '7', 'La Fontaine de lumière', 'Jane COOPER HONG & James Michael WARD', '1994-08-01', 'roman'),
(gen_random_uuid(), '22222222-2222-2222-2222-222222222222', '8', 'Les Fontaines de ténèbres', 'Anne K. BROWN & James Michael WARD', '1994-08-01', 'roman'),
(gen_random_uuid(), '22222222-2222-2222-2222-222222222222', '9', 'La Fontaine de pénombre', 'Anne K. BROWN & James Michael WARD', '1994-08-01', 'roman'),
(gen_random_uuid(), '22222222-2222-2222-2222-222222222222', '10', 'Magefeu', 'Ed GREENWOOD', '1994-10-01', 'roman'),
(gen_random_uuid(), '22222222-2222-2222-2222-222222222222', '11', 'Les Liens d''Azur', 'Jeff GRUBB & Kate NOVAK', '1995-01-01', 'roman'),
(gen_random_uuid(), '22222222-2222-2222-2222-222222222222', '12', 'L''Éperon de Wiverne', 'Jeff GRUBB & Kate NOVAK', '1995-02-01', 'roman'),
(gen_random_uuid(), '22222222-2222-2222-2222-222222222222', '13', 'Le Chant des saurials', 'Jeff GRUBB & Kate NOVAK', '1995-02-01', 'roman'),
(gen_random_uuid(), '22222222-2222-2222-2222-222222222222', '14', 'La Couronne de feu', 'Ed GREENWOOD', '1995-06-01', 'roman'),
(gen_random_uuid(), '22222222-2222-2222-2222-222222222222', '15', 'L''Éclat de cristal', 'Robert Anthony SALVATORE', '1995-09-01', 'roman'),
(gen_random_uuid(), '22222222-2222-2222-2222-222222222222', '16', 'Les Torrents d''argent', 'Robert Anthony SALVATORE', '1995-10-01', 'roman'),
(gen_random_uuid(), '22222222-2222-2222-2222-222222222222', '17', 'Le Joyau du petit homme', 'Robert Anthony SALVATORE', '1995-11-01', 'roman'),
(gen_random_uuid(), '22222222-2222-2222-2222-222222222222', '18', 'Les Revenants du fond du gouffre', 'Robert Anthony SALVATORE', '1996-01-01', 'roman'),
(gen_random_uuid(), '22222222-2222-2222-2222-222222222222', '19', 'La Nuit éteinte', 'Robert Anthony SALVATORE', '1996-01-01', 'roman'),
(gen_random_uuid(), '22222222-2222-2222-2222-222222222222', '20', 'Les Compagnons du renouveau', 'Robert Anthony SALVATORE', '1996-03-01', 'roman'),
(gen_random_uuid(), '22222222-2222-2222-2222-222222222222', '21', 'Le Prince des mensonges', 'James LOWDER', '1996-06-01', 'roman'),
(gen_random_uuid(), '22222222-2222-2222-2222-222222222222', '22', 'Cantique', 'Robert Anthony SALVATORE', '1996-09-01', 'roman'),
(gen_random_uuid(), '22222222-2222-2222-2222-222222222222', '23', 'A l''ombre des forêts', 'Robert Anthony SALVATORE', '1996-10-01', 'roman'),
(gen_random_uuid(), '22222222-2222-2222-2222-222222222222', '24', 'Les Masques de la nuit', 'Robert Anthony SALVATORE', '1996-11-01', 'roman'),
(gen_random_uuid(), '22222222-2222-2222-2222-222222222222', '25', 'La Forteresse déchue', 'Robert Anthony SALVATORE', '1997-01-01', 'roman'),
(gen_random_uuid(), '22222222-2222-2222-2222-222222222222', '26', 'Chaos cruel', 'Robert Anthony SALVATORE', '1997-01-01', 'roman'),
(gen_random_uuid(), '22222222-2222-2222-2222-222222222222', '27', 'Elminster : la jeunesse d''un mage', 'Ed GREENWOOD', '1997-04-01', 'roman'),
(gen_random_uuid(), '22222222-2222-2222-2222-222222222222', '28', 'Le Coureur des ténèbres', 'Douglas NILES', '1997-08-01', 'roman'),
(gen_random_uuid(), '22222222-2222-2222-2222-222222222222', '29', 'Les Sorciers noirs', 'Douglas NILES', '1997-08-01', 'roman'),
(gen_random_uuid(), '22222222-2222-2222-2222-222222222222', '30', 'La Source obscure', 'Douglas NILES', '1997-08-01', 'roman'),
(gen_random_uuid(), '22222222-2222-2222-2222-222222222222', '31', 'Le Prophète des Sélénae', 'Douglas NILES', '1998-01-01', 'roman'),
(gen_random_uuid(), '22222222-2222-2222-2222-222222222222', '32', 'Le Royaume de corail', 'Douglas NILES', '1998-03-01', 'roman'),
(gen_random_uuid(), '22222222-2222-2222-2222-222222222222', '33', 'La Prêtresse devint reine', 'Douglas NILES', '1998-04-01', 'roman'),
(gen_random_uuid(), '22222222-2222-2222-2222-222222222222', '34', 'Les Ombres de l''Apocalypse', 'Ed GREENWOOD', '1998-09-01', 'roman'),
(gen_random_uuid(), '22222222-2222-2222-2222-222222222222', '35', 'Le Manteau des ombres', 'Ed GREENWOOD', '1998-11-01', 'roman'),
(gen_random_uuid(), '22222222-2222-2222-2222-222222222222', '36', '... Et les ombres s''enfuirent', 'Ed GREENWOOD', '1998-11-01', 'roman'),
(gen_random_uuid(), '22222222-2222-2222-2222-222222222222', '37', 'Vers la lumière', 'Robert Anthony SALVATORE', '1999-02-01', 'roman'),
(gen_random_uuid(), '22222222-2222-2222-2222-222222222222', '38', 'La Fille du sorcier Drow', 'Elaine CUNNINGHAM', '1999-03-01', 'roman'),
(gen_random_uuid(), '22222222-2222-2222-2222-222222222222', '39', 'L''Étreinte de l''araignée', 'Elaine CUNNINGHAM', '1999-04-01', 'roman'),
(gen_random_uuid(), '22222222-2222-2222-2222-222222222222', '40', 'La Mer assoiffée', 'Troy DENNING', '1999-08-01', 'roman'),
(gen_random_uuid(), '22222222-2222-2222-2222-222222222222', '41', 'L''Ombre de l''elfe', 'Elaine CUNNINGHAM', '1999-10-01', 'roman'),
(gen_random_uuid(), '22222222-2222-2222-2222-222222222222', '42', 'Magie rouge', 'Jean RABE', '1999-10-01', 'roman'),
(gen_random_uuid(), '22222222-2222-2222-2222-222222222222', '43', 'Retour à la clarté', 'Robert Anthony SALVATORE', '2000-02-01', 'roman'),
(gen_random_uuid(), '22222222-2222-2222-2222-222222222222', '44', 'Elminster à Myth Drannor', 'Ed GREENWOOD', '2000-04-01', 'roman'),
(gen_random_uuid(), '22222222-2222-2222-2222-222222222222', '45', 'Éternelle rencontre, le berceau des elfes', 'Elaine CUNNINGHAM', '2000-05-01', 'roman'),
(gen_random_uuid(), '22222222-2222-2222-2222-222222222222', '46', 'Les Frères de la nuit', 'Scott CIENCIN', '2000-09-01', 'roman'),
(gen_random_uuid(), '22222222-2222-2222-2222-222222222222', '47', 'L''Anneau de l''hiver', 'James LOWDER', '2000-10-01', 'roman'),
(gen_random_uuid(), '22222222-2222-2222-2222-222222222222', '48', 'La Crypte du Roi obscur', 'Mark ANTHONY', '2000-11-01', 'roman'),
(gen_random_uuid(), '22222222-2222-2222-2222-222222222222', '49', 'Histoires des sept sœurs', 'Ed GREENWOOD', '2000-11-01', 'roman'),
(gen_random_uuid(), '22222222-2222-2222-2222-222222222222', '50', 'Les Soldats de glace', 'David COOK', '2001-04-01', 'roman'),
(gen_random_uuid(), '22222222-2222-2222-2222-222222222222', '51', 'La Chanson de l''Elfe', 'Elaine CUNNINGHAM', '2001-05-01', 'roman'),
(gen_random_uuid(), '22222222-2222-2222-2222-222222222222', '52', 'Mascarades', 'Jeff GRUBB & Kate NOVAK', '2001-06-01', 'roman'),
(gen_random_uuid(), '22222222-2222-2222-2222-222222222222', '53', 'Meurtre au Cormyr', 'Chet WILLIAMSON', '2001-10-01', 'roman'),
(gen_random_uuid(), '22222222-2222-2222-2222-222222222222', '54', 'Assassinat à Halruaa', 'Richard S. MEYERS', '2001-11-01', 'roman'),
(gen_random_uuid(), '22222222-2222-2222-2222-222222222222', '55', 'Les Larmes d''acier', 'Elaine CUNNINGHAM', '2002-05-01', 'roman'),
(gen_random_uuid(), '22222222-2222-2222-2222-222222222222', '56', 'Le Sang des ménestrels', 'Elaine CUNNINGHAM', '2002-06-01', 'roman'),
(gen_random_uuid(), '22222222-2222-2222-2222-222222222222', '57', 'Le Prix des rêves', 'Elaine CUNNINGHAM', '2002-06-01', 'roman'),
(gen_random_uuid(), '22222222-2222-2222-2222-222222222222', '58', 'Cormyr', 'Ed GREENWOOD & Jeff GRUBB', '2002-09-01', 'roman'),
(gen_random_uuid(), '22222222-2222-2222-2222-222222222222', '59', 'La Bibliothèque perdue de Cormanthyr', 'Mel ODOM', '2002-10-01', 'roman'),
(gen_random_uuid(), '22222222-2222-2222-2222-222222222222', '60', 'Cette beauté que la laideur nous cache', 'Troy DENNING', '2002-11-01', 'roman'),
(gen_random_uuid(), '22222222-2222-2222-2222-222222222222', '61', 'L''Étoile de Cursrah', 'Clayton EMERY', '2002-11-01', 'roman'),
(gen_random_uuid(), '22222222-2222-2222-2222-222222222222', '62', 'La Tueuse de mage', 'Elaine CUNNINGHAM', '2003-05-01', 'roman'),
(gen_random_uuid(), '22222222-2222-2222-2222-222222222222', '63', 'Les Chemins de la vengeance', 'Elaine CUNNINGHAM', '2003-06-01', 'roman'),
(gen_random_uuid(), '22222222-2222-2222-2222-222222222222', '64', 'La Guerre des sorciers', 'Elaine CUNNINGHAM', '2003-06-01', 'roman'),
(gen_random_uuid(), '22222222-2222-2222-2222-222222222222', '65', 'L''Épine dorsale du monde', 'Robert Anthony SALVATORE', '2003-11-01', 'roman'),
(gen_random_uuid(), '22222222-2222-2222-2222-222222222222', '66', 'Le Nid des corbeaux', 'Richard BAKER', '2003-11-01', 'roman'),
(gen_random_uuid(), '22222222-2222-2222-2222-222222222222', '67', 'La Colline du temple', 'Drew KARPYSHYN', '2004-01-01', 'roman'),
(gen_random_uuid(), '22222222-2222-2222-2222-222222222222', '68', 'Le Joyau du Turmish', 'Mel ODOM', '2004-02-01', 'roman'),
(gen_random_uuid(), '22222222-2222-2222-2222-222222222222', '69', 'La Tentation d''Elminster', 'Ed GREENWOOD', '2004-03-01', 'roman'),
(gen_random_uuid(), '22222222-2222-2222-2222-222222222222', '70', 'L''Appel au meurtre', 'Troy DENNING', '2004-06-01', 'roman'),
(gen_random_uuid(), '22222222-2222-2222-2222-222222222222', '71', 'Le Cri des justes', 'Troy DENNING', '2004-07-01', 'roman'),
(gen_random_uuid(), '22222222-2222-2222-2222-222222222222', '72', 'Le Silence des innocents', 'Troy DENNING', '2004-08-01', 'roman'),
(gen_random_uuid(), '22222222-2222-2222-2222-222222222222', '73', 'Le Masque de lumière', 'Elaine CUNNINGHAM', '2004-11-01', 'roman'),
(gen_random_uuid(), '22222222-2222-2222-2222-222222222222', '74', 'Le Bâton d''Albâtre', 'Edward BOLME', '2005-02-01', 'roman'),
(gen_random_uuid(), '22222222-2222-2222-2222-222222222222', '75', 'Le Bouquet noir', 'Richard Lee BYERS', '2005-02-01', 'roman'),
(gen_random_uuid(), '22222222-2222-2222-2222-222222222222', '76', 'L''Or écarlate', 'Voronica WHITNEY-ROBINSON', '2005-04-01', 'roman'),
(gen_random_uuid(), '22222222-2222-2222-2222-222222222222', '77', 'Le Procès de Cyric le fou', 'Troy DENNING', '2005-09-01', 'roman'),
(gen_random_uuid(), '22222222-2222-2222-2222-222222222222', '78', 'La Cité des Araignées', 'Richard Lee BYERS', '2005-10-01', 'roman'),
(gen_random_uuid(), '22222222-2222-2222-2222-222222222222', '79', 'La Cité des Toiles Chatoyantes', 'Thomas M. REID', '2005-11-01', 'roman'),
(gen_random_uuid(), '22222222-2222-2222-2222-222222222222', '80', 'Les Fosses Démoniaques', 'Richard BAKER', '2006-03-01', 'roman'),
(gen_random_uuid(), '22222222-2222-2222-2222-222222222222', '81', 'Extinction', 'Lisa SMEDMAN', '2006-04-01', 'roman'),
(gen_random_uuid(), '22222222-2222-2222-2222-222222222222', '82', 'Les Ailes noires de la mort', 'Robert Anthony SALVATORE', '2006-06-01', 'roman'),
(gen_random_uuid(), '22222222-2222-2222-2222-222222222222', '83', 'Annihilation', 'Philip ATHANS', '2006-10-01', 'roman'),
(gen_random_uuid(), '22222222-2222-2222-2222-222222222222', '84', 'Résurrection', 'Paul S. KEMP', '2007-04-01', 'roman');

-- Hors Série (10 books: HS1-HS10)
INSERT INTO books (id, collection_id, number, title, author, publication_date, book_type) VALUES
(gen_random_uuid(), '22222222-2222-2222-2222-222222222222', 'HS1', 'La Trilogie de l''Elfe noir', 'Robert Anthony SALVATORE', '1995-01-01', 'recueil de romans'),
(gen_random_uuid(), '22222222-2222-2222-2222-222222222222', 'HS2', 'Cormyr', 'Ed GREENWOOD & Jeff GRUBB', '1998-09-01', 'roman'),
(gen_random_uuid(), '22222222-2222-2222-2222-222222222222', 'HS3', 'L''Épine dorsale du monde', 'Robert Anthony SALVATORE', '2000-03-01', 'roman'),
(gen_random_uuid(), '22222222-2222-2222-2222-222222222222', 'HS4', 'La Tentation d''Elminster', 'Ed GREENWOOD', '2001-11-01', 'roman'),
(gen_random_uuid(), '22222222-2222-2222-2222-222222222222', 'HS5', 'La Damnation d''Elminster', 'Ed GREENWOOD', '2002-11-01', 'roman'),
(gen_random_uuid(), '22222222-2222-2222-2222-222222222222', 'HS6', 'Les Ailes noires de la mort', 'Robert Anthony SALVATORE', '2003-11-01', 'roman'),
(gen_random_uuid(), '22222222-2222-2222-2222-222222222222', 'HS7', 'Aussi loin qu''une âme ait pu fuir', 'Robert Anthony SALVATORE', '2004-10-01', 'roman'),
(gen_random_uuid(), '22222222-2222-2222-2222-222222222222', 'HS8', 'Les Mille orcs', 'Robert Anthony SALVATORE', '2005-06-01', 'roman'),
(gen_random_uuid(), '22222222-2222-2222-2222-222222222222', 'HS9', 'Le Drow solitaire', 'Robert Anthony SALVATORE', '2006-05-01', 'roman'),
(gen_random_uuid(), '22222222-2222-2222-2222-222222222222', 'HS10', 'Les Deux épées', 'Robert Anthony SALVATORE', '2007-05-01', 'roman');

-- ============================================================================
-- 4. INSERT USER POSSESSIONS (41 owned books)
-- ============================================================================

-- Note: Using the same user_id as other migrations (dev user)
-- Owned books: 1-10, 13-17, 19-31, 34, 36-38, 43-45, 49, 58-59, 65, 70, 74

INSERT INTO user_books (user_id, book_id, is_owned, created_at, updated_at)
SELECT
    '00000000-0000-0000-0000-000000000001' as user_id,
    b.id as book_id,
    true as is_owned,
    NOW() as created_at,
    NOW() as updated_at
FROM books b
WHERE b.collection_id = '22222222-2222-2222-2222-222222222222'
AND b.number IN (
    '1', '2', '3', '4', '5', '6', '7', '8', '9', '10',
    '13', '14', '15', '16', '17',
    '19', '20', '21', '22', '23', '24', '25', '26', '27', '28', '29', '30', '31',
    '34',
    '36', '37', '38',
    '43', '44', '45',
    '49',
    '58', '59',
    '65',
    '70',
    '74'
);
