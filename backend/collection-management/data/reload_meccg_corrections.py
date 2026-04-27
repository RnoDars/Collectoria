#!/usr/bin/env python3
"""
Script to reload corrected MECCG card names from CSV file.

Usage:
    python reload_meccg_corrections.py meccg_all_cards_review.csv

The CSV should have columns:
    id, current_name_en, current_name_fr, series, has_issue, issue_type, new_name_en, new_name_fr, notes

Only rows with non-empty new_name_en OR new_name_fr will be updated.
"""

import csv
import sys
import psycopg2
from psycopg2.extras import execute_batch

# Database connection parameters
DB_CONFIG = {
    'host': 'localhost',
    'port': 5432,
    'user': 'collectoria',
    'password': 'changeme',
    'database': 'collection_management'
}

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
                    'notes': row['notes']
                })

    return corrections

def apply_corrections(corrections):
    """Apply corrections to database."""
    conn = psycopg2.connect(**DB_CONFIG)
    cur = conn.cursor()

    updates = []
    for corr in corrections:
        # Determine which fields to update
        new_en = corr['new_en'] if corr['new_en'] else corr['current_en']
        new_fr = corr['new_fr'] if corr['new_fr'] else corr['current_fr']

        # Handle NULL for new_fr if explicitly set to "NULL"
        if corr['new_fr'] == 'NULL':
            new_fr = None

        updates.append((new_en, new_fr, corr['id']))

    if not updates:
        print("No corrections to apply (all new_name_en and new_name_fr are empty)")
        return

    print(f"Applying {len(updates)} corrections...")

    execute_batch(cur, """
        UPDATE cards
        SET
            name_en = %s,
            name_fr = %s,
            updated_at = NOW()
        WHERE id = %s
    """, updates)

    conn.commit()

    print(f"\n✅ Successfully updated {len(updates)} cards")

    # Show summary
    print("\nSummary by type:")
    for corr in corrections:
        changed = []
        if corr['new_en']:
            changed.append(f"EN: {corr['current_en']} → {corr['new_en']}")
        if corr['new_fr']:
            if corr['new_fr'] == 'NULL':
                changed.append(f"FR: {corr['current_fr']} → NULL")
            else:
                changed.append(f"FR: {corr['current_fr']} → {corr['new_fr']}")

        print(f"  {corr['series']}: {', '.join(changed)}")
        if corr['notes']:
            print(f"    Note: {corr['notes']}")

    cur.close()
    conn.close()

def main():
    if len(sys.argv) != 2:
        print("Usage: python reload_meccg_corrections.py <csv_file>")
        sys.exit(1)

    csv_file = sys.argv[1]

    print(f"Loading corrections from {csv_file}...")
    corrections = load_corrections(csv_file)

    if not corrections:
        print("No corrections found in CSV (new_name_en and new_name_fr are all empty)")
        return

    print(f"Found {len(corrections)} cards with corrections")

    # Ask for confirmation
    response = input(f"\nApply these corrections to database? (yes/no): ")
    if response.lower() not in ['yes', 'y']:
        print("Aborted")
        return

    apply_corrections(corrections)

    print("\n✅ Done!")

if __name__ == '__main__':
    main()
