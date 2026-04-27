-- Migration 011: Separate collections into dedicated tables
-- Description: Splits the books table into forgottenrealms_novels and dnd5_books with their ownership tables
-- Date: 2026-04-27
-- Reason: Architectural refactoring - two different collections should not share the same table

-- ============================================================================
-- 1. CREATE NEW TABLES FOR FORGOTTEN REALMS NOVELS
-- ============================================================================

CREATE TABLE IF NOT EXISTS forgottenrealms_novels (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    number VARCHAR(10) NOT NULL,
    title VARCHAR(255) NOT NULL,
    author VARCHAR(255) NOT NULL,
    publication_date DATE NOT NULL,
    book_type VARCHAR(50) NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMP NOT NULL DEFAULT NOW()
);

-- Indexes for forgottenrealms_novels
CREATE INDEX idx_forgottenrealms_novels_number ON forgottenrealms_novels(number);
CREATE INDEX idx_forgottenrealms_novels_author ON forgottenrealms_novels(author);
CREATE INDEX idx_forgottenrealms_novels_title ON forgottenrealms_novels(title);
CREATE INDEX idx_forgottenrealms_novels_book_type ON forgottenrealms_novels(book_type);

-- Comments for forgottenrealms_novels table
COMMENT ON TABLE forgottenrealms_novels IS 'Catalog of Forgotten Realms novels published by Fleuve Noir';
COMMENT ON COLUMN forgottenrealms_novels.id IS 'Unique identifier for the novel';
COMMENT ON COLUMN forgottenrealms_novels.number IS 'Novel number in the collection (e.g., "1", "84", "HS1")';
COMMENT ON COLUMN forgottenrealms_novels.title IS 'Title of the novel (French)';
COMMENT ON COLUMN forgottenrealms_novels.author IS 'Author of the novel';
COMMENT ON COLUMN forgottenrealms_novels.publication_date IS 'Publication date of the novel';
COMMENT ON COLUMN forgottenrealms_novels.book_type IS 'Type of book: "roman" or "recueil de romans"';

-- User ownership table for Forgotten Realms novels
CREATE TABLE IF NOT EXISTS user_forgottenrealms_novels (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL,
    novel_id UUID NOT NULL REFERENCES forgottenrealms_novels(id) ON DELETE CASCADE,
    is_owned BOOLEAN NOT NULL DEFAULT false,
    created_at TIMESTAMP NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMP NOT NULL DEFAULT NOW(),
    UNIQUE(user_id, novel_id)
);

-- Indexes for user_forgottenrealms_novels
CREATE INDEX idx_user_forgottenrealms_novels_user_id ON user_forgottenrealms_novels(user_id);
CREATE INDEX idx_user_forgottenrealms_novels_novel_id ON user_forgottenrealms_novels(novel_id);
CREATE INDEX idx_user_forgottenrealms_novels_is_owned ON user_forgottenrealms_novels(user_id, is_owned);

-- Comments for user_forgottenrealms_novels table
COMMENT ON TABLE user_forgottenrealms_novels IS 'Tracks which Forgotten Realms novels users own';
COMMENT ON COLUMN user_forgottenrealms_novels.id IS 'Unique identifier for the user-novel relationship';
COMMENT ON COLUMN user_forgottenrealms_novels.user_id IS 'User who owns (or doesn''t own) the novel';
COMMENT ON COLUMN user_forgottenrealms_novels.novel_id IS 'Reference to the novel';
COMMENT ON COLUMN user_forgottenrealms_novels.is_owned IS 'Whether the user owns this novel';

-- ============================================================================
-- 2. CREATE NEW TABLES FOR D&D 5E BOOKS
-- ============================================================================

CREATE TABLE IF NOT EXISTS dnd5_books (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    number VARCHAR(10) NOT NULL,
    name_en VARCHAR(255) NOT NULL,
    name_fr VARCHAR(255) NULL,
    book_type VARCHAR(50) NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMP NOT NULL DEFAULT NOW()
);

-- Indexes for dnd5_books
CREATE INDEX idx_dnd5_books_number ON dnd5_books(number);
CREATE INDEX idx_dnd5_books_name_en ON dnd5_books(name_en);
CREATE INDEX idx_dnd5_books_name_fr ON dnd5_books(name_fr);
CREATE INDEX idx_dnd5_books_book_type ON dnd5_books(book_type);

-- Comments for dnd5_books table
COMMENT ON TABLE dnd5_books IS 'Catalog of D&D 5e official books published by Wizards of the Coast';
COMMENT ON COLUMN dnd5_books.id IS 'Unique identifier for the book';
COMMENT ON COLUMN dnd5_books.number IS 'Book code (e.g., "PHB2014", "MM2024", "CoS")';
COMMENT ON COLUMN dnd5_books.name_en IS 'English title of the book';
COMMENT ON COLUMN dnd5_books.name_fr IS 'French title of the book (NULL if not translated)';
COMMENT ON COLUMN dnd5_books.book_type IS 'Type: "Core Rules", "Supplément de règles", "Setting", "Campagnes", "Recueil d''aventures", "Starter Set"';

-- User ownership table for D&D 5e books
CREATE TABLE IF NOT EXISTS user_dnd5_books (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL,
    book_id UUID NOT NULL REFERENCES dnd5_books(id) ON DELETE CASCADE,
    owned_en BOOLEAN NULL,
    owned_fr BOOLEAN NULL,
    created_at TIMESTAMP NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMP NOT NULL DEFAULT NOW(),
    UNIQUE(user_id, book_id)
);

-- Indexes for user_dnd5_books
CREATE INDEX idx_user_dnd5_books_user_id ON user_dnd5_books(user_id);
CREATE INDEX idx_user_dnd5_books_book_id ON user_dnd5_books(book_id);
CREATE INDEX idx_user_dnd5_books_owned_en ON user_dnd5_books(user_id, owned_en);
CREATE INDEX idx_user_dnd5_books_owned_fr ON user_dnd5_books(user_id, owned_fr);

-- Comments for user_dnd5_books table
COMMENT ON TABLE user_dnd5_books IS 'Tracks which D&D 5e books users own (bilingual: EN/FR)';
COMMENT ON COLUMN user_dnd5_books.id IS 'Unique identifier for the user-book relationship';
COMMENT ON COLUMN user_dnd5_books.user_id IS 'User who owns (or doesn''t own) the book';
COMMENT ON COLUMN user_dnd5_books.book_id IS 'Reference to the book';
COMMENT ON COLUMN user_dnd5_books.owned_en IS 'Whether the user owns the English version';
COMMENT ON COLUMN user_dnd5_books.owned_fr IS 'Whether the user owns the French version';

-- ============================================================================
-- 3. MIGRATE DATA FROM books TO forgottenrealms_novels
-- ============================================================================

-- Insert Forgotten Realms novels (collection_id = '22222222-2222-2222-2222-222222222222')
INSERT INTO forgottenrealms_novels (id, number, title, author, publication_date, book_type, created_at, updated_at)
SELECT
    id,
    number,
    title,
    author,
    publication_date,
    book_type,
    created_at,
    updated_at
FROM books
WHERE collection_id = '22222222-2222-2222-2222-222222222222';

-- Migrate ownership data for Forgotten Realms novels
INSERT INTO user_forgottenrealms_novels (id, user_id, novel_id, is_owned, created_at, updated_at)
SELECT
    ub.id,
    ub.user_id,
    ub.book_id as novel_id,
    ub.is_owned,
    ub.created_at,
    ub.updated_at
FROM user_books ub
INNER JOIN books b ON ub.book_id = b.id
WHERE b.collection_id = '22222222-2222-2222-2222-222222222222';

-- ============================================================================
-- 4. MIGRATE DATA FROM books TO dnd5_books
-- ============================================================================

-- Insert D&D 5e books (collection_id = '33333333-3333-3333-3333-333333333333')
INSERT INTO dnd5_books (id, number, name_en, name_fr, book_type, created_at, updated_at)
SELECT
    id,
    number,
    name_en,
    name_fr,
    book_type,
    created_at,
    updated_at
FROM books
WHERE collection_id = '33333333-3333-3333-3333-333333333333';

-- Migrate ownership data for D&D 5e books
INSERT INTO user_dnd5_books (id, user_id, book_id, owned_en, owned_fr, created_at, updated_at)
SELECT
    ub.id,
    ub.user_id,
    ub.book_id,
    ub.owned_en,
    ub.owned_fr,
    ub.created_at,
    ub.updated_at
FROM user_books ub
INNER JOIN books b ON ub.book_id = b.id
WHERE b.collection_id = '33333333-3333-3333-3333-333333333333';

-- ============================================================================
-- 5. DROP OLD TABLES
-- ============================================================================

-- Drop old tables (CASCADE will drop foreign key constraints)
DROP TABLE IF EXISTS user_books CASCADE;
DROP TABLE IF EXISTS books CASCADE;

-- ============================================================================
-- 6. UPDATE collections METADATA
-- ============================================================================

-- Update Forgotten Realms collection metadata
UPDATE collections
SET
    slug = 'forgottenrealms-novels',
    name = 'Romans des Royaumes Oubliés',
    updated_at = NOW()
WHERE id = '22222222-2222-2222-2222-222222222222';

-- Update D&D 5e collection metadata (slug remains 'dnd5', name already correct)
UPDATE collections
SET
    updated_at = NOW()
WHERE id = '33333333-3333-3333-3333-333333333333';

-- ============================================================================
-- 7. VERIFICATION QUERIES (commented out - for manual verification)
-- ============================================================================

-- Check data migration counts:
-- SELECT COUNT(*) FROM forgottenrealms_novels;        -- Expected: 94
-- SELECT COUNT(*) FROM user_forgottenrealms_novels;   -- Expected: 41
-- SELECT COUNT(*) FROM dnd5_books;                     -- Expected: 56 (53 from migration 010 + 3 from 2024 core)
-- SELECT COUNT(*) FROM user_dnd5_books;                -- Expected: 36

-- Verify no orphaned data:
-- SELECT COUNT(*) FROM books;                          -- Expected: 0 (table dropped)
-- SELECT COUNT(*) FROM user_books;                     -- Expected: 0 (table dropped)
