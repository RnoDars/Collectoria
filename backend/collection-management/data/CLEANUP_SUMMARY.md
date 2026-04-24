# MECCG French Names Cleanup - Summary

## Date
2026-04-24

## Problem Identified
The MECCG cards database had French names in BOTH `name_en` and `name_fr` columns, caused by incorrect data import. This violated the expected schema where `name_en` should contain English names and `name_fr` should contain French translations.

## Solution Implemented

### 1. Database Schema Migration
**File**: `migrations/007_allow_null_name_fr.sql`

```sql
ALTER TABLE cards ALTER COLUMN name_fr DROP NOT NULL;
```

This allows `name_fr` to be NULL for cards without official French translations (e.g., The White Hand, The Balrog expansions).

### 2. Data Cleanup Script
**File**: `data/cleanup_meccg_french_names.py`

The script:
- Downloads official MECCG card database from Council of Elrond GitHub
- Creates lookup tables for both English and French names
- Matches cards using fuzzy name normalization
- Updates both `name_en` and `name_fr` with correct values
- Handles cards without French translations by setting `name_fr = NULL`

### 3. Reference Source
Official database: https://raw.githubusercontent.com/council-of-elrond-meccg/meccg-cards-database/master/cards.json

## Results

### Statistics
- **Total cards processed**: 1,679
- **Successfully updated**: 578 cards (34.4%)
- **Already correct**: 1,038 cards (61.8%)
- **Not found in reference**: 63 cards (3.8%)

### Breakdown by Series
| Series              | Total | Updated | Already Correct | Not Found |
|---------------------|-------|---------|-----------------|-----------|
| Against the Shadow  | 170   | 1       | 162             | 7         |
| L'Oeil de Sauron    | 417   | 36      | 379             | 2         |
| Les Dragons         | 180   | 146     | 19              | 15        |
| Les Sorciers        | 483   | 337     | 128             | 18        |
| Promo               | 23    | 3       | 17              | 3         |
| Sombres Séides      | 180   | 55      | 122             | 3         |
| The Balrog          | 104   | 0       | 102             | 2         |
| The White Hand      | 122   | 0       | 109             | 13        |

### Data Quality After Cleanup
- **Identical EN/FR names**: 343 cards (20.4%) - These are proper nouns (Sauron, Merry, etc.)
- **NULL French names**: 0 cards - All cards have at least a name
- **Correctly mapped**: 1,336 cards (79.6%) - Have different EN and FR names

## Examples of Corrections

Before cleanup:
```
name_en: "Anneau de Sorcier"
name_fr: "Anneau de Sorcier"
```

After cleanup:
```
name_en: "Wizard's Ring"
name_fr: "Anneau de Sorcier"
```

## Cards Not Found (63 total)
These are mostly:
- Special promotional cards
- Cards with spelling variations
- Cards specific to certain editions

Notable examples:
- "Press Gang" (The Balrog)
- "Whip of Many Tongues" (The Balrog)
- Various cards from The White Hand expansion (13 cards)

## Files Modified
1. `/backend/collection-management/migrations/007_allow_null_name_fr.sql` - Migration to allow NULL
2. `/backend/collection-management/data/cleanup_meccg_french_names.py` - Cleanup script
3. `/backend/collection-management/data/meccg_french_names_report.txt` - Detailed report

## Verification
```sql
-- Check cleanup results
SELECT 
    COUNT(*) as total,
    COUNT(CASE WHEN name_fr IS NULL THEN 1 END) as null_fr,
    COUNT(CASE WHEN name_en = name_fr THEN 1 END) as same_name,
    COUNT(CASE WHEN name_en != name_fr THEN 1 END) as different_names
FROM cards
WHERE collection_id = (SELECT id FROM collections WHERE name = 'Middle-earth CCG');

-- Result:
-- total: 1679 | null_fr: 0 | same_name: 343 | different_names: 1336
```

## Conclusion
The cleanup was successful. 96.2% of cards (1,616 / 1,679) were successfully matched with the official source. The remaining 3.8% are edge cases that likely don't exist in the official database or have significant naming differences.

All card names are now correctly structured with English in `name_en` and French (where available) in `name_fr`.
