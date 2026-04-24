#!/usr/bin/env python3
"""
Generate SQL migration from corrected MECCG card names CSV.

Usage:
    python generate_corrections_migration.py meccg_all_cards_review.csv

Output:
    ../migrations/008_update_meccg_corrected_names.sql
"""

import csv
import sys
from datetime import datetime

def load_corrections(csv_file):
    """Load corrections from CSV file."""
    corrections = []

    with open(csv_file, 'r', encoding='utf-8') as f:
        reader = csv.DictReader(f)
        for row in reader:
            # Only process rows with corrections (non-empty new_name_en or new_name_fr)
            if row['new_name_en'].strip() or row['new_name_fr'].strip():
                corrections.append({
                    'id': row['id'],
                    'current_en': row['current_name_en'],
                    'current_fr': row['current_name_fr'],
                    'new_en': row['new_name_en'].strip() or None,
                    'new_fr': row['new_name_fr'].strip() or None,
                    'series': row['series'],
                    'issue_type': row['issue_type'],
                    'notes': row['notes']
                })

    return corrections

def escape_sql_string(s):
    """Escape single quotes for SQL."""
    if s is None:
        return 'NULL'
    return "'" + s.replace("'", "''") + "'"

def generate_migration(corrections, output_file):
    """Generate SQL migration file."""

    with open(output_file, 'w', encoding='utf-8') as f:
        f.write(f"""-- Migration: Update MECCG card names with manual corrections
-- Date: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}
-- Total corrections: {len(corrections)}

""")

        # Group by issue type for clarity
        by_type = {}
        for corr in corrections:
            issue_type = corr['issue_type'] or 'OTHER'
            if issue_type not in by_type:
                by_type[issue_type] = []
            by_type[issue_type].append(corr)

        for issue_type, items in sorted(by_type.items()):
            f.write(f"-- {issue_type} ({len(items)} cards)\n")
            f.write("-- " + "="*70 + "\n\n")

            for corr in items:
                new_en = corr['new_en'] if corr['new_en'] else corr['current_en']
                new_fr = corr['new_fr'] if corr['new_fr'] else corr['current_fr']

                # Handle NULL for new_fr if explicitly set to "NULL"
                if corr['new_fr'] == 'NULL':
                    new_fr_sql = 'NULL'
                else:
                    new_fr_sql = escape_sql_string(new_fr)

                f.write(f"-- {corr['series']}: {corr['current_en']}\n")
                if corr['notes']:
                    f.write(f"--   Note: {corr['notes']}\n")

                f.write(f"UPDATE cards SET\n")
                f.write(f"    name_en = {escape_sql_string(new_en)},\n")
                f.write(f"    name_fr = {new_fr_sql},\n")
                f.write(f"    updated_at = NOW()\n")
                f.write(f"WHERE id = '{corr['id']}';\n\n")

        # Summary at end
        f.write(f"""
-- Summary
-- ========
-- Total cards updated: {len(corrections)}
""")
        for issue_type, items in sorted(by_type.items()):
            f.write(f"-- {issue_type}: {len(items)}\n")

    print(f"✅ Generated migration: {output_file}")
    print(f"   Total corrections: {len(corrections)}")

def main():
    if len(sys.argv) != 2:
        print("Usage: python generate_corrections_migration.py <csv_file>")
        sys.exit(1)

    csv_file = sys.argv[1]
    output_file = '../migrations/008_update_meccg_corrected_names.sql'

    print(f"Loading corrections from {csv_file}...")
    corrections = load_corrections(csv_file)

    if not corrections:
        print("No corrections found in CSV (new_name_en and new_name_fr are all empty)")
        return

    print(f"Found {len(corrections)} cards with corrections")

    generate_migration(corrections, output_file)

    print("\n✅ Done! Now apply the migration with:")
    print(f"   docker exec -i collectoria-collection-db psql -U collectoria -d collection_management < {output_file}")

if __name__ == '__main__':
    main()
