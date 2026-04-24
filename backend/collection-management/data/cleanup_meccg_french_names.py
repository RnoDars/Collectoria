#!/usr/bin/env python3
"""
Script to clean up MECCG card names using the official Council of Elrond database.

PROBLEM: Our database has French names in BOTH name_en and name_fr columns.
SOLUTION: Use the French name to find the card, then update both EN and FR columns.
"""

import json
import os
import sys

try:
    import psycopg2
except ImportError:
    print("ERROR: psycopg2 is not installed.")
    print("Please install it with: pip install psycopg2-binary")
    sys.exit(1)


# Database configuration
DB_CONFIG = {
    'host': os.getenv('DB_HOST', 'localhost'),
    'port': int(os.getenv('DB_PORT', '5432')),
    'user': os.getenv('DB_USER', 'collectoria'),
    'password': os.getenv('DB_PASSWORD', 'changeme'),
    'database': os.getenv('DB_NAME', 'collection_management')
}

# JSON source file path
JSON_SOURCE = '/tmp/meccg_cards.json'


def normalize_name(name):
    """Normalize card name for comparison (remove extra spaces, lowercase)."""
    if not name:
        return ''
    return ' '.join(name.strip().lower().split())


def load_reference_data():
    """Load the official MECCG cards database from JSON."""
    print(f"Loading reference data from {JSON_SOURCE}...")

    if not os.path.exists(JSON_SOURCE):
        print(f"ERROR: Reference file not found: {JSON_SOURCE}")
        print("Please download it first with:")
        print("curl -s https://raw.githubusercontent.com/council-of-elrond-meccg/meccg-cards-database/master/cards.json -o /tmp/meccg_cards.json")
        sys.exit(1)

    with open(JSON_SOURCE, 'r', encoding='utf-8') as f:
        data = json.load(f)

    # Build lookup dictionaries
    # Key: normalized name -> (en_name, fr_name)
    en_lookup = {}  # Search by English name
    fr_lookup = {}  # Search by French name

    for set_id, set_data in data.items():
        if 'cards' in set_data:
            for card_id, card in set_data['cards'].items():
                en_name = card.get('name', {}).get('en', '')
                fr_name = card.get('name', {}).get('fr', '')

                if en_name:
                    en_key = normalize_name(en_name)
                    en_lookup[en_key] = (en_name, fr_name if fr_name and fr_name.strip() else None)

                if fr_name and fr_name.strip():
                    fr_key = normalize_name(fr_name)
                    fr_lookup[fr_key] = (en_name, fr_name)

    print(f"✅ Loaded {len(en_lookup)} cards (by EN name)")
    print(f"✅ Loaded {len(fr_lookup)} cards (by FR name)")
    return en_lookup, fr_lookup


def connect_db():
    """Connect to PostgreSQL database."""
    print(f"Connecting to database {DB_CONFIG['database']} on {DB_CONFIG['host']}:{DB_CONFIG['port']}...")

    try:
        conn = psycopg2.connect(**DB_CONFIG)
        print("✅ Database connection established")
        return conn
    except psycopg2.Error as e:
        print(f"ERROR: Failed to connect to database: {e}")
        sys.exit(1)


def get_meccg_cards(conn):
    """Retrieve all MECCG cards from the database."""
    print("Fetching MECCG cards from database...")

    cur = conn.cursor()
    cur.execute("""
        SELECT c.id, c.name_en, c.name_fr, c.series
        FROM cards c
        JOIN collections col ON c.collection_id = col.id
        WHERE col.name = 'Middle-earth CCG'
        ORDER BY c.series, c.name_en
    """)

    cards = cur.fetchall()
    cur.close()

    print(f"✅ Found {len(cards)} MECCG cards in database")
    return cards


def update_card_names(conn, en_lookup, fr_lookup):
    """Update card names in database based on reference data."""
    cards = get_meccg_cards(conn)

    stats = {
        'total': len(cards),
        'updated': 0,
        'already_correct': 0,
        'not_found': 0,
        'by_series': {},
        'match_by_fr': 0,
        'match_by_en': 0,
        'match_by_fallback': 0
    }

    details = {
        'updated': [],
        'not_found': []
    }

    cur = conn.cursor()

    print("\nProcessing cards...")

    for card_id, name_en_current, name_fr_current, series in cards:
        # Initialize series stats
        if series not in stats['by_series']:
            stats['by_series'][series] = {
                'total': 0,
                'updated': 0,
                'already_correct': 0,
                'not_found': 0
            }

        stats['by_series'][series]['total'] += 1

        # STRATEGY: Prioritize name_fr as the primary lookup key since it's reliable
        # name_en might contain French names due to import errors

        correct_en = None
        correct_fr = None
        match_strategy = None

        # Strategy 1 (PRIMARY): Look up by name_fr column - most reliable
        if name_fr_current and name_fr_current.strip():
            fr_key = normalize_name(name_fr_current)
            found_fr = fr_lookup.get(fr_key)
            if found_fr:
                correct_en, correct_fr = found_fr
                match_strategy = 'by_fr'
                stats['match_by_fr'] += 1

        # Strategy 2 (FALLBACK): Look up by name_en in English lookup
        # Only if not found via name_fr (card might already be correct)
        if correct_en is None:
            en_key = normalize_name(name_en_current)
            found_en = en_lookup.get(en_key)
            if found_en:
                correct_en, correct_fr = found_en
                match_strategy = 'by_en'
                stats['match_by_en'] += 1

        # Strategy 3 (LAST RESORT): Try name_en as if it were French
        # For cards where name_en contains French but name_fr is empty/different
        if correct_en is None:
            fr_key2 = normalize_name(name_en_current)
            found_fr2 = fr_lookup.get(fr_key2)
            if found_fr2:
                correct_en, correct_fr = found_fr2
                match_strategy = 'by_en_as_fr'
                stats['match_by_fallback'] += 1

        if correct_en is None:
            # Card not found in reference
            stats['not_found'] += 1
            stats['by_series'][series]['not_found'] += 1
            details['not_found'].append({
                'name_en': name_en_current,
                'name_fr': name_fr_current,
                'series': series,
                'reason': 'No match found in reference database'
            })
            continue

        # Check if update is needed
        needs_update = False
        if name_en_current != correct_en:
            needs_update = True
        if correct_fr and name_fr_current != correct_fr:
            needs_update = True
        if correct_fr is None and name_fr_current is not None:
            needs_update = True

        if needs_update:
            # Update the card
            if correct_fr is None:
                # No French translation exists
                cur.execute(
                    "UPDATE cards SET name_en = %s, name_fr = NULL WHERE id = %s",
                    (correct_en, card_id)
                )
            else:
                cur.execute(
                    "UPDATE cards SET name_en = %s, name_fr = %s WHERE id = %s",
                    (correct_en, correct_fr, card_id)
                )

            stats['updated'] += 1
            stats['by_series'][series]['updated'] += 1
            details['updated'].append({
                'series': series,
                'old_en': name_en_current,
                'old_fr': name_fr_current,
                'new_en': correct_en,
                'new_fr': correct_fr,
                'match_strategy': match_strategy
            })
        else:
            stats['already_correct'] += 1
            stats['by_series'][series]['already_correct'] += 1

    conn.commit()
    cur.close()

    print("✅ Database updated successfully")

    return stats, details


def generate_report(stats, details):
    """Generate a detailed report of the cleanup operation."""
    report_path = os.getenv('REPORT_PATH', '/tmp/meccg_french_names_report.txt')

    print(f"\nGenerating report at {report_path}...")

    with open(report_path, 'w', encoding='utf-8') as f:
        f.write("=" * 80 + "\n")
        f.write("MECCG Card Names Cleanup Report\n")
        f.write("=" * 80 + "\n\n")

        f.write("SUMMARY\n")
        f.write("-" * 80 + "\n")
        f.write(f"Total cards processed: {stats['total']}\n")
        f.write(f"Updated: {stats['updated']} ({stats['updated']*100/stats['total']:.1f}%)\n")
        f.write(f"Already correct: {stats['already_correct']} ({stats['already_correct']*100/stats['total']:.1f}%)\n")
        f.write(f"Not found in reference: {stats['not_found']} ({stats['not_found']*100/stats['total']:.1f}%)\n")
        f.write("\n")
        f.write("MATCHING STRATEGIES\n")
        f.write("-" * 80 + "\n")
        matched = stats['match_by_fr'] + stats['match_by_en'] + stats['match_by_fallback']
        if matched > 0:
            f.write(f"Matched by name_fr (primary): {stats['match_by_fr']} ({stats['match_by_fr']*100/matched:.1f}%)\n")
            f.write(f"Matched by name_en (fallback): {stats['match_by_en']} ({stats['match_by_en']*100/matched:.1f}%)\n")
            f.write(f"Matched by name_en as FR (last resort): {stats['match_by_fallback']} ({stats['match_by_fallback']*100/matched:.1f}%)\n")
        f.write("\n")

        f.write("BREAKDOWN BY SERIES\n")
        f.write("-" * 80 + "\n")
        f.write(f"{'Series':<30} {'Total':>6} {'Updated':>8} {'Correct':>8} {'Not Found':>10}\n")
        f.write("-" * 80 + "\n")

        for series in sorted(stats['by_series'].keys()):
            s = stats['by_series'][series]
            f.write(f"{series:<30} {s['total']:>6} {s['updated']:>8} {s['already_correct']:>8} {s['not_found']:>10}\n")

        f.write("\n")

        if details['updated']:
            f.write("CARDS UPDATED\n")
            f.write("-" * 80 + "\n")
            f.write(f"Total updated: {len(details['updated'])} cards\n\n")

            # Show first 50 examples
            for i, card in enumerate(details['updated'][:50]):
                f.write(f"Series: {card['series']} (Matched {card.get('match_strategy', 'unknown')})\n")
                f.write(f"  OLD EN: {card['old_en']}\n")
                f.write(f"  OLD FR: {card['old_fr']}\n")
                f.write(f"  NEW EN: {card['new_en']}\n")
                f.write(f"  NEW FR: {card['new_fr']}\n")
                f.write("\n")

            if len(details['updated']) > 50:
                f.write(f"... and {len(details['updated']) - 50} more cards updated.\n\n")

        if details['not_found']:
            f.write("CARDS NOT FOUND IN REFERENCE DATABASE\n")
            f.write("-" * 80 + "\n")
            f.write(f"Total not found: {len(details['not_found'])} cards\n\n")

            for card in details['not_found'][:50]:
                f.write(f"Series: {card['series']}\n")
                f.write(f"  EN: {card['name_en']}\n")
                f.write(f"  FR: {card['name_fr']}\n")
                f.write(f"  Reason: {card.get('reason', 'Unknown')}\n")
                f.write("\n")

            if len(details['not_found']) > 50:
                f.write(f"... and {len(details['not_found']) - 50} more cards not found.\n\n")

    print(f"✅ Report generated: {report_path}")


def main():
    """Main execution function."""
    print("MECCG Card Names Cleanup Script")
    print("=" * 80)
    print()

    # Load reference data
    en_lookup, fr_lookup = load_reference_data()

    # Connect to database
    conn = connect_db()

    try:
        # Update card names
        stats, details = update_card_names(conn, en_lookup, fr_lookup)

        # Generate report
        generate_report(stats, details)

        print("\n" + "=" * 80)
        print("CLEANUP COMPLETED SUCCESSFULLY")
        print("=" * 80)
        print(f"Total cards processed: {stats['total']}")
        print(f"✅ Updated: {stats['updated']}")
        print(f"✓  Already correct: {stats['already_correct']}")
        print(f"⚠️  Not found in reference: {stats['not_found']}")
        print()
        matched = stats['match_by_fr'] + stats['match_by_en'] + stats['match_by_fallback']
        if matched > 0:
            print("MATCHING STRATEGIES:")
            print(f"  By name_fr: {stats['match_by_fr']} ({stats['match_by_fr']*100/matched:.1f}%)")
            print(f"  By name_en: {stats['match_by_en']} ({stats['match_by_en']*100/matched:.1f}%)")
            print(f"  By name_en as FR: {stats['match_by_fallback']} ({stats['match_by_fallback']*100/matched:.1f}%)")

    finally:
        conn.close()
        print("\nDatabase connection closed")


if __name__ == '__main__':
    main()
