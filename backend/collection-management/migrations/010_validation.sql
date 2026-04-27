-- Migration 010 Validation Script
-- Purpose: Verify that D&D 5e collection was imported correctly
-- Date: 2026-04-27

-- ============================================================================
-- 1. VERIFY TABLE STRUCTURE
-- ============================================================================

-- Check new columns in books table
SELECT
    column_name,
    data_type,
    is_nullable,
    column_default
FROM information_schema.columns
WHERE table_name = 'books'
AND column_name IN ('name_en', 'name_fr', 'edition')
ORDER BY column_name;

-- Check new columns in user_books table
SELECT
    column_name,
    data_type,
    is_nullable,
    column_default
FROM information_schema.columns
WHERE table_name = 'user_books'
AND column_name IN ('owned_en', 'owned_fr')
ORDER BY column_name;

-- Check indexes created
SELECT
    indexname,
    tablename,
    indexdef
FROM pg_indexes
WHERE tablename IN ('books', 'user_books')
AND indexname LIKE '%edition%'
   OR indexname LIKE '%owned_en%'
   OR indexname LIKE '%owned_fr%';

-- ============================================================================
-- 2. VERIFY COLLECTION
-- ============================================================================

-- Check D&D 5e collection exists
SELECT
    id,
    name,
    slug,
    category,
    total_cards,
    description
FROM collections
WHERE id = '33333333-3333-3333-3333-333333333333';

-- ============================================================================
-- 3. VERIFY BOOKS COUNT
-- ============================================================================

-- Total books in D&D 5e collection (should be 53)
SELECT COUNT(*) as total_books
FROM books
WHERE collection_id = '33333333-3333-3333-3333-333333333333';

-- Books by type
SELECT
    book_type,
    COUNT(*) as count
FROM books
WHERE collection_id = '33333333-3333-3333-3333-333333333333'
GROUP BY book_type
ORDER BY book_type;

-- Expected results:
-- Campagnes: 17
-- Core Rules: 6
-- Recueil d'aventures: 7
-- Setting: 11
-- Starter Set: 4
-- Supplément de règles: 8

-- ============================================================================
-- 4. VERIFY DATA INTEGRITY
-- ============================================================================

-- Check all D&D books have edition = 'D&D 5'
SELECT COUNT(*) as books_without_edition
FROM books
WHERE collection_id = '33333333-3333-3333-3333-333333333333'
AND (edition IS NULL OR edition != 'D&D 5');
-- Expected: 0

-- Check all D&D books have author = 'Wizards of the Coast'
SELECT COUNT(*) as books_wrong_author
FROM books
WHERE collection_id = '33333333-3333-3333-3333-333333333333'
AND author != 'Wizards of the Coast';
-- Expected: 0

-- Check all D&D books have name_en
SELECT COUNT(*) as books_without_name_en
FROM books
WHERE collection_id = '33333333-3333-3333-3333-333333333333'
AND name_en IS NULL;
-- Expected: 0

-- Check books with and without name_fr (some are untranslated)
SELECT
    CASE
        WHEN name_fr IS NULL THEN 'Untranslated'
        ELSE 'Translated'
    END as translation_status,
    COUNT(*) as count
FROM books
WHERE collection_id = '33333333-3333-3333-3333-333333333333'
GROUP BY (name_fr IS NULL)
ORDER BY translation_status;

-- Expected:
-- Translated: 28
-- Untranslated: 25

-- ============================================================================
-- 5. VERIFY POSSESSIONS
-- ============================================================================

-- Total possessions for D&D 5e (should be 36: 19 FR + 17 EN)
SELECT COUNT(*) as total_possessions
FROM user_books ub
JOIN books b ON ub.book_id = b.id
WHERE b.collection_id = '33333333-3333-3333-3333-333333333333';

-- Possessions breakdown
SELECT
    CASE
        WHEN ub.owned_en = true AND ub.owned_fr = true THEN 'Both EN & FR'
        WHEN ub.owned_en = true THEN 'EN only'
        WHEN ub.owned_fr = true THEN 'FR only'
        ELSE 'None'
    END as possession_type,
    COUNT(*) as count
FROM user_books ub
JOIN books b ON ub.book_id = b.id
WHERE b.collection_id = '33333333-3333-3333-3333-333333333333'
GROUP BY (
    CASE
        WHEN ub.owned_en = true AND ub.owned_fr = true THEN 'Both EN & FR'
        WHEN ub.owned_en = true THEN 'EN only'
        WHEN ub.owned_fr = true THEN 'FR only'
        ELSE 'None'
    END
)
ORDER BY possession_type;

-- Expected:
-- EN only: 17
-- FR only: 19
-- Both EN & FR: 0
-- None: 0

-- Possessions by book type
SELECT
    b.book_type,
    SUM(CASE WHEN ub.owned_fr = true THEN 1 ELSE 0 END) as owned_fr_count,
    SUM(CASE WHEN ub.owned_en = true THEN 1 ELSE 0 END) as owned_en_count,
    COUNT(*) as total_owned
FROM user_books ub
JOIN books b ON ub.book_id = b.id
WHERE b.collection_id = '33333333-3333-3333-3333-333333333333'
GROUP BY b.book_type
ORDER BY b.book_type;

-- ============================================================================
-- 6. VERIFY NO REGRESSION ON ROYAUMES OUBLIÉS
-- ============================================================================

-- Check Royaumes Oubliés books still have NULL for new columns
SELECT
    COUNT(*) as books_count,
    SUM(CASE WHEN name_en IS NOT NULL THEN 1 ELSE 0 END) as has_name_en,
    SUM(CASE WHEN name_fr IS NOT NULL THEN 1 ELSE 0 END) as has_name_fr,
    SUM(CASE WHEN edition IS NOT NULL THEN 1 ELSE 0 END) as has_edition
FROM books
WHERE collection_id = '22222222-2222-2222-2222-222222222222';

-- Expected:
-- books_count: 94
-- has_name_en: 0
-- has_name_fr: 0
-- has_edition: 0

-- Check Royaumes Oubliés possessions still use is_owned
SELECT
    COUNT(*) as possessions_count,
    SUM(CASE WHEN is_owned = true THEN 1 ELSE 0 END) as owned_count,
    SUM(CASE WHEN owned_en IS NOT NULL THEN 1 ELSE 0 END) as has_owned_en,
    SUM(CASE WHEN owned_fr IS NOT NULL THEN 1 ELSE 0 END) as has_owned_fr
FROM user_books ub
JOIN books b ON ub.book_id = b.id
WHERE b.collection_id = '22222222-2222-2222-2222-222222222222';

-- Expected:
-- possessions_count: 41
-- owned_count: 41
-- has_owned_en: 0
-- has_owned_fr: 0

-- ============================================================================
-- 7. SAMPLE DATA VERIFICATION
-- ============================================================================

-- Show 5 sample D&D books with all fields
SELECT
    number,
    title,
    name_en,
    name_fr,
    author,
    edition,
    book_type
FROM books
WHERE collection_id = '33333333-3333-3333-3333-333333333333'
ORDER BY number
LIMIT 5;

-- Show sample possessions with book details
SELECT
    b.number,
    b.name_en,
    b.name_fr,
    b.book_type,
    ub.owned_en,
    ub.owned_fr
FROM user_books ub
JOIN books b ON ub.book_id = b.id
WHERE b.collection_id = '33333333-3333-3333-3333-333333333333'
ORDER BY b.number
LIMIT 10;

-- ============================================================================
-- 8. FINAL SUMMARY
-- ============================================================================

SELECT
    'D&D 5e Collection' as metric,
    (SELECT COUNT(*) FROM books WHERE collection_id = '33333333-3333-3333-3333-333333333333') as value,
    '53 books expected' as expected
UNION ALL
SELECT
    'D&D 5e Possessions',
    (SELECT COUNT(*) FROM user_books ub JOIN books b ON ub.book_id = b.id WHERE b.collection_id = '33333333-3333-3333-3333-333333333333'),
    '36 possessions expected'
UNION ALL
SELECT
    'D&D 5e Owned FR',
    (SELECT COUNT(*) FROM user_books ub JOIN books b ON ub.book_id = b.id WHERE b.collection_id = '33333333-3333-3333-3333-333333333333' AND ub.owned_fr = true),
    '19 expected'
UNION ALL
SELECT
    'D&D 5e Owned EN',
    (SELECT COUNT(*) FROM user_books ub JOIN books b ON ub.book_id = b.id WHERE b.collection_id = '33333333-3333-3333-3333-333333333333' AND ub.owned_en = true),
    '17 expected'
UNION ALL
SELECT
    'Royaumes Oubliés Books (no regression)',
    (SELECT COUNT(*) FROM books WHERE collection_id = '22222222-2222-2222-2222-222222222222'),
    '94 books expected'
UNION ALL
SELECT
    'Royaumes Oubliés Possessions (no regression)',
    (SELECT COUNT(*) FROM user_books ub JOIN books b ON ub.book_id = b.id WHERE b.collection_id = '22222222-2222-2222-2222-222222222222'),
    '41 possessions expected';
