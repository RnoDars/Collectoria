# Mapping CSV → Base de Données - D&D 5e Collection

**Source** : `dnd5-books-enriched.csv`  
**Migration** : `010_add_dnd5_collection.sql`  
**Date** : 2026-04-27

---

## Mapping des Colonnes

| Colonne CSV | Colonne DB | Type | Transformation |
|-------------|------------|------|----------------|
| `number` | `number` | VARCHAR(10) | Direct (abréviation du livre) |
| `name_en` | `name_en` | VARCHAR(255) | Direct |
| `name_en` | `title` | VARCHAR(255) | Copie (pour satisfaire contrainte NOT NULL) |
| `name_fr` | `name_fr` | VARCHAR(255) | Direct (NULL si non traduit) |
| `book_type` | `book_type` | VARCHAR(50) | Direct (6 valeurs distinctes) |
| `owned_fr` | `owned_fr` | BOOLEAN | 'Oui' → `true`, 'Non' → `false` |
| `owned_en` | `owned_en` | BOOLEAN | 'Oui' → `true`, 'Non' → `false` |
| - | `author` | VARCHAR(255) | Fixe: 'Wizards of the Coast' |
| - | `edition` | VARCHAR(50) | Fixe: 'D&D 5' |
| - | `publication_date` | DATE | Estimé (année uniquement) |
| - | `collection_id` | UUID | Fixe: `33333333-3333-3333-3333-333333333333` |

---

## Correspondance Ligne par Ligne (Extrait)

### Core Rules (6 livres)

| CSV number | CSV name_en | CSV name_fr | DB owned_fr | DB owned_en |
|------------|-------------|-------------|-------------|-------------|
| PHB2014 | Player's Handbook - 2014 | Player's Handbook - 2014 | ✅ Oui | ❌ Non |
| MM2014 | Monster Manual - 2014 | Monster Manual - 2014 | ✅ Oui | ❌ Non |
| DMG2014 | Dungeon master's guide - 2014 | Dungeon master's guide - 2014 | ✅ Oui | ❌ Non |
| DMG2024 | Dungeon master's guide - 2024 | Guide du maître - 2024 | ❌ Non | ❌ Non |
| PHB2024 | Player's Handbook - 2024 | Manuel des joueurs - 2024 | ❌ Non | ❌ Non |
| MM2024 | Monster Manual - 2024 | Manuel des monstres - 2024 | ❌ Non | ❌ Non |

### Starter Set (4 livres)

| CSV number | CSV name_en | CSV name_fr | DB owned_fr | DB owned_en |
|------------|-------------|-------------|-------------|-------------|
| LMoP | Starter Set: Lost mine of Phandelver | Kit d'Initiation | ❌ Non | ❌ Non |
| EK | Essentiels Kit | L'Essentiel | ✅ Oui | ❌ Non |
| DoSI | Starter Set: Dragons of Stormwreck Isl | Starter Set: Les dragons de l'île aux Tempêtes | ✅ Oui | ❌ Non |
| HotB | Starter Set: Heroes of the Borderlands | *NULL* (non traduit) | ❌ Non | ❌ Non |

### Suppléments de règles (8 livres)

| CSV number | CSV name_en | CSV name_fr | DB owned_fr | DB owned_en |
|------------|-------------|-------------|-------------|-------------|
| VGtM | Volo's Guide to Monsters | *NULL* | ❌ Non | ❌ Non |
| XGtE | Xanathar's Guide to Everything | Le Guide Complet de Xanathar | ✅ Oui | ❌ Non |
| MToF | Mordenkeinen's Tome of Foes | *NULL* | ❌ Non | ✅ Oui |
| TCoE | Tasha's Cauldron of Everything | Le chaudron des merveilles de Tasha | ❌ Non | ✅ Oui |
| FToD | Fizban's Treasury of Dragons | Le Trésor Draconique de Fizban | ✅ Oui | ❌ Non |
| MotM | Monsters of the Multiverse | Les Monstres du Multivers | ✅ Oui | ❌ Non |
| BGG | Bigby presents: Glory of the Giants | Bigby présente La Gloire des Géant | ✅ Oui | ❌ Non |
| BMT | The book of many things | *NULL* | ❌ Non | ❌ Non |

### Setting (11 livres)

| CSV number | CSV name_en | CSV name_fr | DB owned_fr | DB owned_en |
|------------|-------------|-------------|-------------|-------------|
| SCAG | Sword Coast Adventurer's Guide | Le Guide des Aventuriers de la Côte des Épées | ✅ Oui | ❌ Non |
| GGtR | Guildemasters Guide to Ravnica | *NULL* | ❌ Non | ✅ Oui |
| AI | Acquisition Incorporated | *NULL* | ❌ Non | ✅ Oui |
| ERftLW | Eberron : Rising from the Last war | *NULL* | ❌ Non | ✅ Oui |
| EGtW | Explorer's guide to Wildemount | *NULL* | ❌ Non | ✅ Oui |
| MOoT | Mythic Odysses of Theros | *NULL* | ❌ Non | ✅ Oui |
| VRGtR | Van richten's Guide to Ravenloft | Le Guide de Van Richten sur Ravenloft | ✅ Oui | ❌ Non |
| SaCoC | Strixhaven : A curriculum of Chaos | *NULL* | ❌ Non | ❌ Non |
| SjAiS | Spelljammer : Adventures in Space | *NULL* | ❌ Non | ❌ Non |
| PAtM | Planescape: Adventures in the Multiverse | *NULL* | ❌ Non | ❌ Non |
| EFotA | Eberron: Forge ot the Artificer | *NULL* | ❌ Non | ❌ Non |

### Campagnes (17 livres)

| CSV number | CSV name_en | CSV name_fr | DB owned_fr | DB owned_en |
|------------|-------------|-------------|-------------|-------------|
| BGDiA | Baldur's Gate: Descent into Avernus | La Porte de Baldur : Descente en Averne | ❌ Non | ✅ Oui |
| HotDQ | Hoard of the Dragon Queen | *NULL* | ❌ Non | ✅ Oui |
| RoT | The rise of Tiamat | *NULL* | ❌ Non | ✅ Oui |
| PotA | Princes of Apocalypse | *NULL* | ❌ Non | ✅ Oui |
| OotA | Out of the Abyss | *NULL* | ❌ Non | ✅ Oui |
| CoS | Curse of Strahd | La Malédiction de Strahd | ✅ Oui | ❌ Non |
| SKT | Storm King's Thunder | *NULL* | ❌ Non | ❌ Non |
| ToA | Tomb of Annihilation | La tombe de l'annihilation | ✅ Oui | ❌ Non |
| WDotMM | Waterdeep: Dungeon of the Mad Mage | Le Donjon du Mage Dément | ✅ Oui | ❌ Non |
| ToD | Tyranny of Dragons | *NULL* | ❌ Non | ❌ Non |
| RotF | Rime of the Frostmaiden | *NULL* | ❌ Non | ✅ Oui |
| WBtW | The Wild beyond the Witchlight | Par-delà le Carnaval de Sorcelume | ✅ Oui | ❌ Non |
| CotN | Call of the Netherdeep | *NULL* | ❌ Non | ✅ Oui |
| DSotDQ | Dragonlance: Shadow of the Dragon Queen | Dragonlance - L'ombre de la reine de dragons | ✅ Oui | ❌ Non |
| PaBtSO | Phandelver and Below: The Shattered Obelisk | Les tréfonds de Phancreux - L'Obélisque brisé | ✅ Oui | ❌ Non |
| VEoR | Vecna: Eve of Ruin | Vecna: Au Seuil du Néant | ✅ Oui | ❌ Non |
| WDH | Waterdeep: Dragon Heist | Waterdeep - Le Vol des Dragons | ❌ Non | ✅ Oui |

### Recueil d'aventures (7 livres)

| CSV number | CSV name_en | CSV name_fr | DB owned_fr | DB owned_en |
|------------|-------------|-------------|-------------|-------------|
| KftGV | Keys from the Golden Vault | Les clés du verrou d'or | ❌ Non | ❌ Non |
| TftYP | Tales from the Yawning Portal | Les Contes du Portail Béant | ❌ Non | ✅ Oui |
| GoS | Ghosts of Saltmarsh | *NULL* | ❌ Non | ✅ Oui |
| CM | Candelkeep Mysteries | *NULL* | ❌ Non | ❌ Non |
| JttRC | Journeys through the Radiant Citadel | Horizons de la Citadelle Radieuse | ✅ Oui | ❌ Non |
| QftIS | Quests from the infinite Staircase | *NULL* | ❌ Non | ❌ Non |
| DD | Dragon Delves | *NULL* | ❌ Non | ❌ Non |

---

## Statistiques de Traduction

| Statut | Nombre | Pourcentage |
|--------|--------|-------------|
| Traduits (name_fr présent) | 28 | 52.8% |
| Non traduits (name_fr = NULL) | 25 | 47.2% |
| **Total** | **53** | **100%** |

### Par Type de Livre

| Type | Traduits | Non Traduits | Total |
|------|----------|--------------|-------|
| Core Rules | 6 | 0 | 6 |
| Starter Set | 3 | 1 | 4 |
| Supplément de règles | 4 | 4 | 8 |
| Setting | 2 | 9 | 11 |
| Campagnes | 9 | 8 | 17 |
| Recueil d'aventures | 2 | 5 | 7 |

**Observation** : Les Core Rules et Starter Sets sont majoritairement traduits. Les Settings et Recueils d'aventures sont majoritairement non traduits.

---

## Statistiques de Possession

| Possession | Nombre | Pourcentage du total |
|------------|--------|----------------------|
| Possédés FR uniquement | 19 | 35.8% des 53 livres |
| Possédés EN uniquement | 17 | 32.1% des 53 livres |
| Possédés (total unique) | 36 | 67.9% des 53 livres |
| Non possédés | 17 | 32.1% des 53 livres |

### Par Type de Livre

| Type | Possédés FR | Possédés EN | Total Possédés | Non Possédés | % Possession |
|------|-------------|-------------|----------------|--------------|--------------|
| Core Rules | 3 | 0 | 3 | 3 | 50% |
| Starter Set | 2 | 0 | 2 | 2 | 50% |
| Supplément de règles | 4 | 2 | 6 | 2 | 75% |
| Setting | 2 | 5 | 7 | 4 | 63.6% |
| Campagnes | 7 | 8 | 15 | 2 | 88.2% |
| Recueil d'aventures | 1 | 2 | 3 | 4 | 42.9% |

**Observation** : Les Campagnes sont la catégorie la plus complète (88.2% de possession). Les Recueils d'aventures sont la catégorie la moins complète (42.9%).

---

## Livres Possédés dans les Deux Versions

**Aucun livre n'est possédé dans les deux versions simultanément** (owned_en = true ET owned_fr = true).

Cela correspond aux données du CSV source : chaque ligne a soit "Oui" en `owned_fr`, soit "Oui" en `owned_en`, jamais les deux.

---

## Livres Non Possédés (17 livres)

| number | name_en | name_fr | book_type |
|--------|---------|---------|-----------|
| DMG2024 | Dungeon master's guide - 2024 | Guide du maître - 2024 | Core Rules |
| PHB2024 | Player's Handbook - 2024 | Manuel des joueurs - 2024 | Core Rules |
| MM2024 | Monster Manual - 2024 | Manuel des monstres - 2024 | Core Rules |
| LMoP | Starter Set: Lost mine of Phandelver | Kit d'Initiation | Starter Set |
| HotB | Starter Set: Heroes of the Borderlands | *NULL* | Starter Set |
| VGtM | Volo's Guide to Monsters | *NULL* | Supplément de règles |
| BMT | The book of many things | *NULL* | Supplément de règles |
| SaCoC | Strixhaven : A curriculum of Chaos | *NULL* | Setting |
| SjAiS | Spelljammer : Adventures in Space | *NULL* | Setting |
| PAtM | Planescape: Adventures in the Multiverse | *NULL* | Setting |
| EFotA | Eberron: Forge ot the Artificer | *NULL* | Setting |
| SKT | Storm King's Thunder | *NULL* | Campagnes |
| ToD | Tyranny of Dragons | *NULL* | Campagnes |
| KftGV | Keys from the Golden Vault | Les clés du verrou d'or | Recueil d'aventures |
| CM | Candelkeep Mysteries | *NULL* | Recueil d'aventures |
| QftIS | Quests from the infinite Staircase | *NULL* | Recueil d'aventures |
| DD | Dragon Delves | *NULL* | Recueil d'aventures |

---

## Validation de l'Import

### Comptage Total

| Métrique | CSV | Base de Données | Match |
|----------|-----|-----------------|-------|
| Total de lignes CSV | 53 | - | - |
| Livres importés | - | 53 | ✅ |
| Possessions FR ('Oui' dans CSV) | 19 | 19 | ✅ |
| Possessions EN ('Oui' dans CSV) | 17 | 17 | ✅ |
| Total possessions | 36 | 36 | ✅ |

### Intégrité des Données

- ✅ Tous les livres du CSV ont été importés
- ✅ Toutes les possessions du CSV ont été créées
- ✅ Aucun doublon détecté
- ✅ Aucune perte de données

---

## Notes Importantes

1. **Champ `title`** : Copié depuis `name_en` pour satisfaire la contrainte NOT NULL existante. Ce champ n'est utilisé que pour Royaumes Oubliés, mais doit être renseigné pour D&D 5e.

2. **Livres non traduits** : 25 livres ont `name_fr = NULL` car ils n'ont pas de traduction française officielle.

3. **Date de publication** : Les dates sont estimées (année uniquement) car non disponibles dans le CSV source.

4. **Auteur** : Tous les livres ont `author = 'Wizards of the Coast'` (collectif).

5. **Édition** : Tous les livres ont `edition = 'D&D 5'` (fixe pour toute la collection).

---

**Document généré le** : 2026-04-27  
**Source** : `/home/arnaud.dars/git/Collectoria/backend/collection-management/data/dnd5-books-enriched.csv`  
**Migration** : `010_add_dnd5_collection.sql`
