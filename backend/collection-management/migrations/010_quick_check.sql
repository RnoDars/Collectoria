-- Quick Check Script for Migration 010
-- Usage: Run this after applying migration to verify success quickly

\echo '=== QUICK CHECK - Migration 010 ==='
\echo ''

-- 1. D&D 5e Collection exists
\echo '1. D&D 5e Collection:'
SELECT name, slug, total_cards FROM collections WHERE id = '33333333-3333-3333-3333-333333333333';
\echo ''

-- 2. Total books count
\echo '2. Total Books:'
SELECT COUNT(*) as dnd5_books FROM books WHERE collection_id = '33333333-3333-3333-3333-333333333333';
\echo ''

-- 3. Books by type
\echo '3. Books by Type:'
SELECT book_type, COUNT(*) as count FROM books
WHERE collection_id = '33333333-3333-3333-3333-333333333333'
GROUP BY book_type ORDER BY book_type;
\echo ''

-- 4. Possessions summary
\echo '4. Possessions Summary:'
SELECT
    COUNT(*) as total_possessions,
    SUM(CASE WHEN owned_fr = true THEN 1 ELSE 0 END) as owned_fr,
    SUM(CASE WHEN owned_en = true THEN 1 ELSE 0 END) as owned_en
FROM user_books ub
JOIN books b ON ub.book_id = b.id
WHERE b.collection_id = '33333333-3333-3333-3333-333333333333';
\echo ''

-- 5. No regression on Royaumes Oubliés
\echo '5. Royaumes Oubliés (No Regression):'
SELECT
    COUNT(*) as books,
    (SELECT COUNT(*) FROM user_books ub JOIN books b ON ub.book_id = b.id WHERE b.collection_id = '22222222-2222-2222-2222-222222222222') as possessions
FROM books WHERE collection_id = '22222222-2222-2222-2222-222222222222';
\echo ''

\echo '=== Expected Results ==='
\echo 'Collection: D&D 5e | dnd5 | 53'
\echo 'Books: 53'
\echo 'Possessions: 36 total (19 FR, 17 EN)'
\echo 'Royaumes Oubliés: 94 books, 41 possessions'
\echo ''
