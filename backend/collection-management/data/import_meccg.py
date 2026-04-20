#!/usr/bin/env python3
"""
Génère un fichier SQL d'import pour les cartes MECCG depuis le fichier Excel.
Usage: python3 import_meccg.py
Output: ../migrations/002_seed_meccg_real.sql
"""

import openpyxl
import uuid
import os

XLSX_PATH = os.path.join(os.path.dirname(__file__), "meccg cards.xlsx")
OUTPUT_PATH = os.path.join(os.path.dirname(__file__), "../migrations/002_seed_meccg_real.sql")

COLLECTION_NAME = "Middle-earth CCG"
COLLECTION_SLUG = "meccg"
COLLECTION_ID   = "11111111-1111-1111-1111-111111111111"
USER_ID         = "00000000-0000-0000-0000-000000000001"

# Mapping nom onglet → nom français des collections
SERIES_MAP = {
    "Les Sorciers":        "Les Sorciers",
    "Les Dragons":         "Les Dragons",
    "Against the shadow":  "Against the Shadow",
    "L'Oeil de Sauron":    "L'Oeil de Sauron",
    "Sombres SéIdes":      "Sombres Séides",
    "The Balrog":          "The Balrog",
    "The White Hand":      "The White Hand",
    "Promo":               "Promo",
}

def esc(s):
    if s is None:
        return "NULL"
    return "'" + str(s).replace("'", "''") + "'"

def main():
    wb = openpyxl.load_workbook(XLSX_PATH)
    ws = wb["Liste SdA"]

    cards = []
    for row in ws.iter_rows(min_row=2, values_only=True):
        collection = row[0]
        nom_fr     = row[2]
        nom_en     = row[3]
        rarete     = row[4]
        possedee   = row[5]
        card_type  = row[6]

        if not collection:
            continue

        cards.append({
            "id":        str(uuid.uuid4()),
            "series":    SERIES_MAP.get(collection, collection),
            "name_en":   nom_en if nom_en else nom_fr if nom_fr else "?",
            "name_fr":   nom_fr if nom_fr else nom_en if nom_en else "?",
            "rarity":    rarete if rarete and rarete != "-" else "?",
            "card_type": card_type if card_type else "Inconnu",
            "owned":     possedee == "Oui",
        })

    total    = len(cards)
    owned    = sum(1 for c in cards if c["owned"])
    print(f"Cartes trouvées : {total} ({owned} possédées)")

    lines = []
    lines.append("-- Migration 002 : Import des vraies cartes MECCG")
    lines.append(f"-- {total} cartes dont {owned} possédées")
    lines.append("")

    # Supprimer les données mock
    lines.append("-- Nettoyage des données mock")
    lines.append(f"DELETE FROM user_cards WHERE card_id IN (SELECT id FROM cards WHERE collection_id = '{COLLECTION_ID}');")
    lines.append(f"DELETE FROM user_collections WHERE collection_id = '{COLLECTION_ID}';")
    lines.append(f"DELETE FROM cards WHERE collection_id = '{COLLECTION_ID}';")
    lines.append(f"DELETE FROM collections WHERE id = '{COLLECTION_ID}';")
    lines.append("")

    # Réinsérer la collection
    lines.append("-- Collection MECCG")
    lines.append(f"""INSERT INTO collections (id, name, slug, category, total_cards, description, created_at, updated_at) VALUES (
    '{COLLECTION_ID}',
    'Middle-earth CCG',
    'meccg',
    'card_game',
    {total},
    'Le Seigneur des Anneaux - Jeu de cartes à collectionner (1995-2001)',
    NOW(), NOW()
);""")
    lines.append("")

    # Insérer les cartes par batch de 500
    lines.append("-- Cartes MECCG")
    batch = []
    for i, c in enumerate(cards):
        batch.append(
            f"('{c['id']}', '{COLLECTION_ID}', {esc(c['name_en'])}, {esc(c['name_fr'])}, "
            f"{esc(c['card_type'])}, {esc(c['series'])}, {esc(c['rarity'])}, NOW(), NOW())"
        )
        if len(batch) == 500 or i == len(cards) - 1:
            lines.append("INSERT INTO cards (id, collection_id, name_en, name_fr, card_type, series, rarity, created_at, updated_at) VALUES")
            lines.append(",\n".join(batch) + ";")
            lines.append("")
            batch = []

    # User collection
    lines.append("-- Association user <-> collection")
    lines.append(f"INSERT INTO user_collections (user_id, collection_id, created_at) VALUES ('{USER_ID}', '{COLLECTION_ID}', NOW());")
    lines.append("")

    # Possession des cartes
    lines.append("-- Possession des cartes")
    owned_cards = [c for c in cards if c["owned"]]
    not_owned   = [c for c in cards if not c["owned"]]

    batch = []
    for i, c in enumerate(owned_cards + not_owned):
        is_owned = "true" if c["owned"] else "false"
        acquired = "NOW()" if c["owned"] else "NULL"
        batch.append(f"('{USER_ID}', '{c['id']}', {is_owned}, {acquired}, NOW(), NOW())")
        if len(batch) == 500 or i == len(cards) - 1:
            lines.append("INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES")
            lines.append(",\n".join(batch) + ";")
            lines.append("")
            batch = []

    with open(OUTPUT_PATH, "w", encoding="utf-8") as f:
        f.write("\n".join(lines))

    print(f"Fichier SQL généré : {OUTPUT_PATH}")

if __name__ == "__main__":
    main()
