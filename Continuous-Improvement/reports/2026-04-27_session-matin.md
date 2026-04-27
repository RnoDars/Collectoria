# Audit Session Matin — 2026-04-27

**Produit par** : Agent Amélioration Continue  
**Date** : 2026-04-27  
**Contexte** : Session matinale de setup environnement et préparation de données D&D 5e (2h)

---

## Score Système

| Dimension | Avant session | Après session | Delta |
|-----------|---------------|---------------|-------|
| Environnement dev PostgreSQL | Down (credentials obsolètes) | Running avec extension unaccent | +1 |
| Extension PostgreSQL unaccent | Absente (nouvelle BDD) | Installée et opérationnelle | +1 |
| Documentation extension unaccent | Absente | À ajouter (recommandation) | 0 |
| Procédure cleanup volumes Docker | Non documentée | Appliquée avec succès | +1 |
| Données D&D 5e (préparation) | Aucune | 53 livres enrichis et validés | +1 |
| Workflow Excel → CSV → enrichissement | Non formalisé | Appliqué avec succès | +1 |
| Génération abréviations officielles | Manuelle | Automatique avec validation | +1 |
| **Score global (estimation)** | **8.5/10** | **9/10** | **+0.5** |

---

## 1. Ce Qui a Bien Fonctionné

### Setup Environnement — Diagnostic Rapide et Résolution Efficace

Le diagnostic du problème PostgreSQL (credentials obsolètes dans volume persistant) a été identifié rapidement et résolu proprement avec `docker compose down -v`. Cette méthode de cleanup complet des volumes est la solution correcte pour ce type de problème de credentials persistants.

**Pattern réutilisable** : Pour tout changement de credentials PostgreSQL, systématiquement supprimer le volume Docker avec `-v` avant redémarrage. À documenter dans `DevOps/restart-procedures.md`.

### Extension PostgreSQL unaccent — Installation Propre

L'installation de l'extension `unaccent` via `docker exec` avec la commande SQL `CREATE EXTENSION unaccent;` est la méthode standard et propre. L'extension est maintenant disponible pour les recherches insensibles aux accents sur les noms français.

**Point d'amélioration identifié** : Cette installation manuelle devrait être automatisée soit dans le Dockerfile PostgreSQL, soit dans une migration SQL de setup initiale. Actuellement, toute nouvelle installation de la base requiert une intervention manuelle.

### Workflow Excel → CSV → Enrichissement — Méthodologie Efficace

Le workflow mis en place est exemplaire et réutilisable pour toute future collection de données :

1. **Réception fichier source** : Excel `.xlsx` fourni par l'utilisateur (format natif, non technique)
2. **Conversion CSV** : Via LibreOffice (solution pragmatique sans dépendances Python/pip)
3. **Analyse automatique** : Détection des 53 livres, répartition par type, statistiques de traduction
4. **Génération automatique abréviations** : Basée sur conventions officielles D&D (PHB, DMG, CoS, etc.)
5. **Validation unicité** : Vérification automatique que toutes les abréviations sont uniques
6. **Fichier enrichi intermédiaire** : CSV avec colonne `number` ajoutée pour validation utilisateur
7. **Détection typos** : Identification automatique de "Forge ot the Artificer" → "of", "Stormwreck Isl" → "Isle"
8. **Correction utilisateur** : Validation et correction manuelle des anomalies détectées
9. **Commit atomique** : Un seul commit avec données source + enrichi + statistiques détaillées

Ce workflow combine automatisation (génération abréviations, détection typos) et validation humaine (corrections, vérification cohérence), ce qui est le bon équilibre pour des données critiques.

### Communication et Traçabilité — Best Practice Appliquée

La communication tout au long de la session a été exemplaire avec :
- Préfixe "🤖 Alfred :" systématique
- Validation étape par étape avec l'utilisateur
- Statistiques détaillées (53 livres, 28 traduits FR, 25 non traduits)
- Message de commit riche et structuré avec statistiques complètes

### Génération Abréviations Officielles — Automatisation Réussie

La génération automatique des abréviations basée sur les conventions officielles D&D est un succès :
- PHB (Player's Handbook), DMG (Dungeon Master's Guide), MM (Monster Manual)
- CoS (Curse of Strahd), ToA (Tomb of Annihilation), BgDiA (Baldur's Gate: Descent into Avernus)
- Gestion des cas spéciaux (suffixes années 2014/2024 pour Core Rules)
- Toutes les abréviations uniques et validées

**Pattern réutilisable** : Pour toute collection avec titres longs, la génération automatique d'abréviations basée sur des conventions métier est efficace et évite les erreurs humaines.

---

## 2. Incidents et Leçons

### Incident A — Container PostgreSQL avec ancien mot de passe

**Description**  
Au démarrage de l'environnement, PostgreSQL refusait la connexion avec le nouveau mot de passe `collectoria` alors que le `docker-compose.yml` était correct. Cause : le volume Docker persistait avec les credentials de l'ancien mot de passe `postgres`.

**Cause Racine**  
Docker Compose utilise des volumes nommés persistants pour PostgreSQL. Lors du premier `docker compose up`, PostgreSQL initialise la base avec les credentials fournis et les stocke dans le volume. Les redémarrages ultérieurs réutilisent ce volume.

Lors du changement de credentials dans `docker-compose.yml` (passage de `postgres` à `collectoria`), le volume existant contenait encore l'ancien mot de passe. PostgreSQL ne réinitialise jamais un volume existant par sécurité.

**Impact**  
- Blocage total au démarrage de session
- Impossibilité de se connecter à la base
- Temps de diagnostic perdu (tentatives de redémarrage inutiles avant identification du volume persistant)

**Fréquence Probable**  
Faible en routine (les credentials ne changent pas souvent), mais élevée lors de :
- Changement de configuration sécurité (rotation de mots de passe)
- Setup d'une nouvelle machine avec ancien volume copié
- Réinitialisation d'environnement de test

**Résolution Appliquée**  
```bash
docker compose down -v  # -v supprime les volumes associés
docker compose up -d    # Recrée un volume propre avec nouveaux credentials
```

**Recommandations**

1. **DevOps/restart-procedures.md — Ajout section "Changement Credentials PostgreSQL"**  
   Documenter la procédure `docker compose down -v` avec warning explicite sur la perte de données.

2. **DevOps/CLAUDE.md — Ajout rule "Cleanup Volumes lors Changement Credentials"**  
   Règle rappelant systématiquement la commande `-v` lors de tout changement de credentials PostgreSQL.

3. **Script de cleanup sécurisé**  
   Créer `scripts/reset-postgres.sh` qui :
   - Demande confirmation ("⚠️ Cette action supprimera toutes les données PostgreSQL locales")
   - Execute `docker compose down -v`
   - Relance `docker compose up -d`
   - Applique les migrations
   - Installe l'extension `unaccent`

---

### Incident B — Extension `unaccent` manquante

**Description**  
Après recréation du container PostgreSQL avec `docker compose down -v`, l'extension `unaccent` (nécessaire pour les recherches insensibles aux accents sur les noms français) n'était plus disponible. Elle avait été installée manuellement lors d'une session précédente mais n'a pas survécu à la recréation du volume.

**Cause Racine**  
L'extension `unaccent` n'est pas installée automatiquement lors de l'initialisation de la base. Elle nécessite une commande SQL manuelle `CREATE EXTENSION unaccent;` qui avait été exécutée une fois mais n'est pas persistée dans :
- Le Dockerfile PostgreSQL (pas de `CREATE EXTENSION` dans l'image)
- Les migrations SQL (aucune migration ne crée cette extension)
- Les scripts d'initialisation Docker (`/docker-entrypoint-initdb.d/`)

**Impact**  
- Fonctionnalité de recherche insensible aux accents non disponible
- Risque d'erreurs SQL si du code backend utilise `unaccent()` sans que l'extension existe
- Installation manuelle requise à chaque recréation du volume

**Fréquence Probable**  
Élevée — se reproduit à chaque fois que le volume PostgreSQL est supprimé :
- `docker compose down -v`
- Changement de machine de développement
- Setup CI/CD avec base de données éphémère
- Environnement de test isolé

**Résolution Appliquée en Session**  
```bash
docker exec -it collection-management-db psql -U collectoria -d collection_management \
  -c "CREATE EXTENSION unaccent;"
```

**Recommandations Prioritaires**

**Option 1 — Migration SQL dédiée (RECOMMANDÉ)**  
Créer une migration `001_setup_extensions.sql` (ou l'ajouter à la migration 001 existante) :

```sql
-- Migration 001: Setup extensions PostgreSQL
-- Description: Extensions requises pour le bon fonctionnement de Collectoria
-- Date: 2026-04-27

CREATE EXTENSION IF NOT EXISTS unaccent;

-- Commentaire pour traçabilité
COMMENT ON EXTENSION unaccent IS 'Required for accent-insensitive search on French names';
```

**Avantages** :
- Reproductible et versionné avec les migrations
- S'applique automatiquement sur toute nouvelle base (dev, test, prod)
- Documenté dans l'historique des migrations
- `IF NOT EXISTS` rend l'opération idempotente

**Option 2 — Script d'initialisation Docker**  
Ajouter un script `backend/collection-management/docker/init-extensions.sql` :

```sql
CREATE EXTENSION IF NOT EXISTS unaccent;
```

Et monter ce script dans le container PostgreSQL via `docker-compose.yml` :

```yaml
volumes:
  - ./docker/init-extensions.sql:/docker-entrypoint-initdb.d/01-extensions.sql
```

**Avantages** :
- Exécuté automatiquement lors du premier démarrage du container
- Pas besoin de migration applicative

**Inconvénients** :
- Non versionnée avec les migrations applicatives
- Moins visible (fichier hors du répertoire `migrations/`)

**Option 3 — Dockerfile PostgreSQL custom**  
Créer un Dockerfile avec image PostgreSQL + extension :

```dockerfile
FROM postgres:16
RUN apt-get update && apt-get install -y postgresql-contrib
```

**Inconvénients** :
- `unaccent` fait partie de `postgresql-contrib` qui est déjà inclus dans l'image officielle
- Le problème n'est pas l'absence du module mais l'absence du `CREATE EXTENSION`

**Décision Recommandée** : **Option 1 (Migration SQL)** car elle suit le pattern existant des migrations, est versionnée avec Git, et s'applique automatiquement lors de la procédure de setup.

---

### Incident C — Pip/openpyxl non disponibles

**Description**  
Lors de la tentative de conversion du fichier Excel `.xlsx` vers CSV avec un script Python utilisant `openpyxl`, la commande `pip` n'était pas disponible sur le système (Ubuntu sans Python installé ou Python sans pip).

**Cause Racine**  
Le système de développement (machine locale ou environnement isolé) n'avait pas `pip` installé. L'installation de `pip` via `apt` aurait requis des permissions sudo et ajouté une dépendance système pour une opération ponctuelle.

**Impact**  
- Blocage temporaire de la conversion Excel → CSV
- Temps de recherche d'une solution alternative

**Résolution Appliquée**  
Utilisation de LibreOffice pour convertir le fichier Excel en CSV :

```bash
libreoffice --headless --convert-to csv dnd5-books-source.xlsx
```

**Fréquence Probable**  
Faible en routine (une fois les données converties, ce problème ne se reproduit pas), mais moyen lors de :
- Nouvelle collection avec données source Excel
- Import de données utilisateur en format Office

**Recommandations**

**Pattern Général — Favoriser CSV comme Format d'Échange**

Pour toute future collection de données ou import utilisateur, privilégier le format CSV dès le départ :
- Demander à l'utilisateur un export CSV si possible
- Documenter dans `Documentation/data-import-guidelines.md` que le format préféré est CSV UTF-8
- Si Excel requis, documenter la procédure LibreOffice comme solution standard

**Workflow Recommandé pour Import Données**

```markdown
# Procédure Import Données — Standard Collectoria

## 1. Format Préféré : CSV UTF-8
Demander à l'utilisateur un export CSV avec :
- Encodage : UTF-8
- Séparateur : virgule (,)
- Quote char : guillemets doubles (")
- Headers : première ligne

## 2. Si Format Excel Fourni
### Option A — Conversion LibreOffice (recommandé)
libreoffice --headless --convert-to csv fichier.xlsx

### Option B — Conversion Python (si environnement disponible)
pip install openpyxl pandas
python scripts/excel_to_csv.py fichier.xlsx

### Option C — Conversion manuelle utilisateur
Demander à l'utilisateur d'ouvrir Excel et "Enregistrer sous... CSV UTF-8"

## 3. Validation CSV
- Vérifier encodage UTF-8 : `file -i fichier.csv`
- Vérifier headers : `head -1 fichier.csv`
- Compter lignes : `wc -l fichier.csv`
```

**Leçon Générale**  
Ne pas supposer la disponibilité d'outils Python sur l'environnement de développement. Privilégier des outils standards Linux (LibreOffice, `csvkit` si disponible) ou demander des formats natifs texte (CSV, JSON).

---

### Incident D — Typos dans fichier source

**Description**  
Lors de l'analyse du fichier Excel source fourni par l'utilisateur, deux typos ont été détectées :
1. "Eberron: Forge ot the Artificer" → devrait être "Forge **of** the Artificer"
2. "Starter Set: Dragons of Stormwreck Isl" → devrait être "Stormwreck **Isle**"

**Cause Racine**  
Erreurs de saisie humaine dans le fichier Excel source. Le fichier a été préparé manuellement par l'utilisateur sans vérification automatique orthographique sur les noms anglais.

**Impact**  
- Risque de données incorrectes en base de données
- Incohérence avec les titres officiels Wizards of the Coast
- Abréviations générées potentiellement incorrectes (EFotA au lieu de EFotA avec mauvais titre)

**Fréquence Probable**  
Moyenne — toute saisie manuelle de données comporte un risque de typos. Plus élevé pour :
- Titres longs en langue étrangère
- Collections avec >50 entrées
- Saisie sans vérification croisée avec source officielle

**Résolution Appliquée**  
Détection automatique lors de l'analyse + correction manuelle par l'utilisateur :

1. **Détection automatique** : Pattern "ot" au lieu de "of", mots courts tronqués (Isl)
2. **Signal à l'utilisateur** : "⚠️ Typos potentielles détectées : [liste]"
3. **Validation utilisateur** : Confirmation des corrections à appliquer
4. **Correction manuelle** : Modification du CSV enrichi avant commit

**Recommandations**

**Workflow Validation Données — Check Automatiques**

Pour tout import de données de collection, implémenter des validations automatiques :

```python
# Patterns de validation à ajouter dans scripts/validate_collection_data.py

COMMON_TYPOS = {
    r'\sot\s': ' of ',      # "Forge ot the" → "Forge of the"
    r'\sIsl\b': ' Isle',    # "Stormwreck Isl" → "Stormwreck Isle"
    r'\sAdn\s': ' and ',    # "Dragons adn Dungeons"
}

SUSPICIOUS_PATTERNS = [
    r'\b\w{1,2}\b',        # Mots de 1-2 lettres isolés (sauf articles)
    r'[A-Z]{5,}',          # Acronymes très longs (potentiellement mal formatés)
    r'\d{5,}',             # Nombres longs suspects
]
```

**Checklist Validation Pré-Import**

```markdown
# Checklist Validation Données Collection

Avant de générer une migration SQL à partir de données sources :

- [ ] Encodage UTF-8 vérifié : `file -i fichier.csv`
- [ ] Headers conformes au schéma attendu
- [ ] Aucune ligne vide ou incomplète : `awk -F',' 'NF!=6' fichier.csv`
- [ ] Typos courantes détectées : `grep -E '\sot\s|\sIsl\b' fichier.csv`
- [ ] Doublons détectés : `sort fichier.csv | uniq -d`
- [ ] Valeurs enum valides (book_type) : vérifier whitelist
- [ ] Abréviations uniques : `cut -d',' -f1 fichier.csv | sort | uniq -d`
- [ ] Validation manuelle utilisateur : confirmer les données critiques

Si UNE SEULE vérification échoue → signaler à l'utilisateur et bloquer la génération SQL.
```

**Leçon Générale**  
Les données sources fournies par l'utilisateur doivent systématiquement passer par une phase de validation automatique avant enrichissement et génération SQL. La détection de typos courantes doit être automatisée mais la correction finale doit rester manuelle avec confirmation utilisateur.

---

## 3. Recommandations Prioritaires

### R1 — PRIORITÉ HAUTE : Automatiser installation extension `unaccent`

**Problème** : L'extension `unaccent` doit être installée manuellement à chaque recréation du volume PostgreSQL.

**Solution** : Ajouter `CREATE EXTENSION IF NOT EXISTS unaccent;` dans une migration SQL (de préférence migration 001 ou nouvelle migration 001_setup_extensions.sql).

**Fichier à créer/modifier** : `backend/collection-management/migrations/001_setup_extensions.sql`

```sql
-- Migration 001: Setup extensions PostgreSQL
-- Description: Extensions requises pour le bon fonctionnement de Collectoria
-- Date: 2026-04-27

CREATE EXTENSION IF NOT EXISTS unaccent;

COMMENT ON EXTENSION unaccent IS 'Required for accent-insensitive search on French book names and card names';
```

**Responsable** : Agent Backend  
**Effort estimé** : 10 minutes  
**Impact si non traité** : Chaque nouvel environnement (dev, test, CI, prod) nécessitera une installation manuelle, risque d'erreurs SQL si l'extension est appelée sans exister.

---

### R2 — PRIORITÉ HAUTE : Documenter procédure cleanup volumes Docker

**Problème** : Le workflow `docker compose down -v` pour changer les credentials PostgreSQL n'est pas documenté.

**Solution** : Enrichir `DevOps/restart-procedures.md` avec une section dédiée.

**Fichier à modifier** : `DevOps/restart-procedures.md`

**Contenu à ajouter** :

```markdown
## Changement de Credentials PostgreSQL

⚠️ **ATTENTION** : Cette procédure supprime toutes les données locales PostgreSQL.

### Quand l'utiliser
- Changement de mot de passe PostgreSQL dans `docker-compose.yml`
- Changement d'utilisateur PostgreSQL
- Réinitialisation complète de l'environnement de test

### Procédure

1. **Sauvegarder les données si nécessaire**
   ```bash
   docker exec collection-management-db pg_dump -U collectoria collection_management > backup.sql
   ```

2. **Arrêter et supprimer les volumes**
   ```bash
   docker compose down -v  # -v = supprime les volumes associés
   ```

3. **Redémarrer avec nouveaux credentials**
   ```bash
   docker compose up -d
   ```

4. **Réappliquer les migrations**
   ```bash
   cd backend/collection-management
   make migrate  # ou appliquer manuellement les migrations
   ```

5. **Installer extension unaccent** (temporaire jusqu'à R1)
   ```bash
   docker exec -it collection-management-db psql -U collectoria -d collection_management \
     -c "CREATE EXTENSION unaccent;"
   ```

6. **Vérifier la connexion**
   ```bash
   docker exec -it collection-management-db psql -U collectoria -d collection_management -c "\conninfo"
   ```

### Erreurs Courantes

**"password authentication failed"** après changement credentials → Volume existant non supprimé
**Solution** : Relancer avec `docker compose down -v`

**"extension unaccent does not exist"** → Extension non réinstallée
**Solution** : Exécuter l'étape 5 ou attendre l'implémentation de R1
```

**Responsable** : Agent DevOps  
**Effort estimé** : 15 minutes  
**Impact si non traité** : Perte de temps lors de futurs changements de credentials, procédure non standardisée.

---

### R3 — PRIORITÉ MOYENNE : Créer script `reset-postgres.sh`

**Problème** : La procédure de réinitialisation PostgreSQL complète (down -v + up + migrations + extension) nécessite plusieurs commandes manuelles.

**Solution** : Script bash interactif qui automatise toute la procédure avec confirmation utilisateur.

**Fichier à créer** : `scripts/reset-postgres.sh`

```bash
#!/bin/bash
set -e

echo "⚠️  ATTENTION : Cette action va supprimer toutes les données PostgreSQL locales."
echo "Les données suivantes seront perdues :"
echo "  - Toutes les tables de collection_management"
echo "  - Toutes les données de cartes, livres, utilisateurs"
echo ""
read -p "Êtes-vous sûr de vouloir continuer ? (tapez 'oui' pour confirmer) : " confirmation

if [ "$confirmation" != "oui" ]; then
    echo "❌ Opération annulée."
    exit 0
fi

echo "🔄 Arrêt et suppression des volumes Docker..."
docker compose down -v

echo "🚀 Redémarrage PostgreSQL..."
docker compose up -d collection-management-db

echo "⏳ Attente disponibilité PostgreSQL (10 secondes)..."
sleep 10

echo "📦 Installation extension unaccent..."
docker exec -it collection-management-db psql -U collectoria -d collection_management \
  -c "CREATE EXTENSION IF NOT EXISTS unaccent;"

echo "🔄 Application des migrations..."
cd backend/collection-management
# Appliquer toutes les migrations (adapter selon votre outil de migration)
for migration in migrations/*.sql; do
    echo "  - Applying $(basename $migration)"
    docker exec -i collection-management-db psql -U collectoria -d collection_management < "$migration"
done
cd ../..

echo "✅ Réinitialisation PostgreSQL terminée avec succès."
echo ""
echo "Prochaines étapes suggérées :"
echo "  - Redémarrer le backend : cd backend/collection-management && go run cmd/api/main.go"
echo "  - Vérifier les données : docker exec -it collection-management-db psql -U collectoria -d collection_management -c '\dt'"
```

**Responsable** : Agent DevOps  
**Effort estimé** : 30 minutes  
**Impact si non traité** : Procédure manuelle plus longue, risque d'oubli d'étapes (extension, migrations).

---

### R4 — PRIORITÉ MOYENNE : Standardiser workflow import données collections

**Problème** : Le workflow Excel → CSV → enrichissement → validation a été appliqué avec succès pour D&D 5e mais n'est pas documenté pour réutilisation.

**Solution** : Créer un document `Documentation/data-import-workflow.md` qui standardise le processus.

**Fichier à créer** : `Documentation/data-import-workflow.md`

**Contenu** :

```markdown
# Workflow Import Données Collection — Standard Collectoria

Ce document décrit le workflow standard pour importer des données de collection dans Collectoria.

## Phase 1 : Réception Données Source

### Format Préféré : CSV UTF-8
- Encodage : UTF-8
- Séparateur : virgule (,)
- Quote char : guillemets doubles (")
- Headers : première ligne obligatoire

### Si Format Excel (.xlsx)
Convertir avec LibreOffice (solution sans dépendances) :
```bash
libreoffice --headless --convert-to csv fichier.xlsx --outdir data/
```

## Phase 2 : Analyse Initiale

### Validation Encodage et Structure
```bash
# Vérifier encodage
file -i fichier.csv

# Vérifier headers
head -1 fichier.csv

# Compter lignes (hors header)
tail -n +2 fichier.csv | wc -l
```

### Statistiques Descriptives
Produire un rapport avec :
- Nombre total d'entrées
- Répartition par catégorie (book_type, card_type, etc.)
- Statistiques de possession initiale (si applicable)
- Détection valeurs manquantes

Exemple pour D&D 5e :
```
Total : 53 livres
Répartition :
  - Core Rules : 6 livres
  - Campagnes : 17 livres
  - Supplément de règles : 8 livres
  - Setting : 11 livres
  - Recueil d'aventures : 7 livres
  - Starter Set : 4 livres

Traductions FR : 28/53 (52.8%)
Possession initiale : 19 FR + 17 EN
```

## Phase 3 : Validation Automatique

### Checklist Validation (OBLIGATOIRE)

- [ ] **Headers conformes** : Vérifier que les colonnes correspondent au schéma attendu
- [ ] **Aucune ligne vide** : `awk -F',' 'NF!=<expected_columns>' fichier.csv`
- [ ] **Typos courantes** : `grep -E '\sot\s|\sIsl\b|\sadn\s' fichier.csv`
- [ ] **Doublons** : `sort fichier.csv | uniq -d`
- [ ] **Valeurs enum valides** : Vérifier whitelist (book_type, card_type, etc.)
- [ ] **Champs requis non vides** : Vérifier que les colonnes NOT NULL ont une valeur

Exemple validation book_type D&D 5e :
```bash
# Valeurs valides
VALID_TYPES="Core Rules|Supplément de règles|Setting|Campagnes|Recueil d'aventures|Starter Set"

# Détecter valeurs invalides
awk -F',' -v valid="$VALID_TYPES" 'NR>1 && $4 !~ valid {print "Invalid book_type:", $0}' fichier.csv
```

### Détection Typos Automatique

Patterns communs à détecter :
- ` ot ` → devrait être ` of `
- ` adn ` → devrait être ` and `
- Mots tronqués : `Isl` → `Isle`, `Lst` → `Last`

## Phase 4 : Enrichissement

### Génération Abréviations (si applicable)

Pour les collections avec titres longs (livres D&D, campagnes), générer des abréviations officielles :

Règles D&D 5e (exemple) :
- Prendre initiales majuscules : "Curse of Strahd" → CoS
- Cas spéciaux : "Player's Handbook" → PHB (pas PH)
- Suffixes années pour rééditions : PHB2014, PHB2024
- Validation unicité : vérifier aucun doublon

### Ajout Métadonnées

Ajouter colonnes calculées si nécessaire :
- Numéro séquentiel (pour collections ordonnées)
- Catégories dérivées
- Dates formatées (YYYY-MM-DD)

## Phase 5 : Validation Utilisateur

### Fichier Enrichi Intermédiaire

Créer un CSV enrichi (`*-enriched.csv`) avec :
- Toutes les colonnes sources
- Colonnes calculées ajoutées
- Format prêt pour génération SQL

### Points de Validation Manuelle

Demander à l'utilisateur de vérifier :
- Abréviations générées sont correctes
- Typos détectées ont été corrigées
- Répartition par catégorie est cohérente
- Possession initiale est exacte

**RÈGLE** : Ne JAMAIS passer à la génération SQL sans validation utilisateur explicite.

## Phase 6 : Génération Migration SQL

Une fois les données validées, générer la migration SQL avec :

```sql
-- Migration XXX: Import collection [nom]
-- Description: [statistiques]
-- Date: YYYY-MM-DD

-- Insert collection
INSERT INTO collections (id, name, slug, category, total_cards, description, created_at, updated_at)
VALUES (...);

-- Insert données
INSERT INTO [table] (columns...) VALUES
  (...),
  (...);

-- Update total_cards
UPDATE collections SET total_cards = (SELECT COUNT(*) FROM [table] WHERE collection_id = '...')
WHERE id = '...';
```

## Phase 7 : Commit Atomique

Message de commit structuré :

```
data: add [Collection Name] source data (N entries)

Préparation de la collection [nom] avec données sources validées.

Fichiers ajoutés :
- [source-file].xlsx : Fichier source fourni par l'utilisateur
  * N entrées
  * [statistiques descriptives]

- [enriched-file].csv : CSV enrichi avec [colonnes ajoutées]
  * [validations effectuées]
  * Prêt pour génération migration SQL

Statistiques :
- [statistique 1]
- [statistique 2]

Prochaine étape : Génération migration XXX pour implémenter la collection [nom]

Co-Authored-By: Claude Opus 4.7 <noreply@anthropic.com>
```

## Workflow Résumé

```
Excel → CSV → Validation Auto → Enrichissement → Validation Utilisateur → Migration SQL → Commit
  ↓       ↓           ↓                ↓                   ↓                    ↓          ↓
LibreOffice  Typos   Stats         Abréviations      Vérification       INSERT INTO    Git
            Doublons  Complétude    Métadonnées      Manuelle           VALUES
```

## Exemples Concrets

### Exemple 1 : Collection D&D 5e (53 livres)
- Source : `dnd5-books-source.xlsx`
- Enrichi : `dnd5-books-enriched.csv` (colonne `number` avec abréviations)
- Commit : `0aebf01`
- Typos détectées : "Forge ot the Artificer" → "of", "Stormwreck Isl" → "Isle"
- Temps total : 1h30 (analyse + enrichissement + validation)

### Exemple 2 : Collection MECCG (cartes)
[À documenter après prochaine collection similaire]
```

**Responsable** : Agent Documentation  
**Effort estimé** : 45 minutes  
**Impact si non traité** : Processus non standardisé, risque de variabilité qualité entre collections, temps perdu à redéfinir le workflow à chaque import.

---

### R5 — PRIORITÉ FAIBLE : Script validation automatique données collections

**Problème** : Les validations automatiques (typos, doublons, valeurs enum) ont été effectuées manuellement avec des commandes bash ad-hoc.

**Solution** : Créer un script Python réutilisable `scripts/validate_collection_data.py`.

**Fichier à créer** : `scripts/validate_collection_data.py`

```python
#!/usr/bin/env python3
"""
Validation automatique de données de collection avant import.

Usage:
    python scripts/validate_collection_data.py data/collection.csv --schema dnd5-books

Schémas disponibles :
    - dnd5-books : Livres D&D 5e
    - meccg-cards : Cartes MECCG
    - forgotten-realms-books : Livres Royaumes Oubliés
"""

import sys
import csv
import re
from pathlib import Path
from typing import List, Dict, Set

# Patterns typos communs
COMMON_TYPOS = {
    r'\sot\s': ' of ',
    r'\sadn\s': ' and ',
    r'\sIsl\b': ' Isle',
}

# Schémas de validation
SCHEMAS = {
    'dnd5-books': {
        'required_columns': ['number', 'name_en', 'name_fr', 'book_type', 'owned_fr', 'owned_en'],
        'valid_book_types': ['Core Rules', 'Supplément de règles', 'Setting', 'Campagnes', 'Recueil d\'aventures', 'Starter Set'],
        'valid_owned_values': ['Oui', 'Non', ''],
    },
    # Ajouter d'autres schémas au fur et à mesure
}

def validate_csv(filepath: Path, schema_name: str) -> Dict[str, List[str]]:
    """
    Valide un fichier CSV selon le schéma spécifié.
    Retourne un dictionnaire d'erreurs par catégorie.
    """
    errors = {
        'structure': [],
        'typos': [],
        'duplicates': [],
        'invalid_enum': [],
        'missing_required': [],
    }

    schema = SCHEMAS.get(schema_name)
    if not schema:
        errors['structure'].append(f"Schéma inconnu : {schema_name}")
        return errors

    with open(filepath, 'r', encoding='utf-8') as f:
        reader = csv.DictReader(f)
        headers = reader.fieldnames

        # Validation headers
        if not all(col in headers for col in schema['required_columns']):
            missing = set(schema['required_columns']) - set(headers)
            errors['structure'].append(f"Colonnes manquantes : {', '.join(missing)}")
            return errors  # Stop si headers incorrects

        seen_numbers = set()
        line_num = 1

        for row in reader:
            line_num += 1

            # Validation champs requis
            for col in schema['required_columns']:
                if col == 'name_fr':  # name_fr peut être vide pour non traduits
                    continue
                if not row.get(col):
                    errors['missing_required'].append(f"Ligne {line_num}: {col} est vide")

            # Validation enum book_type
            if 'valid_book_types' in schema:
                book_type = row.get('book_type', '')
                if book_type and book_type not in schema['valid_book_types']:
                    errors['invalid_enum'].append(f"Ligne {line_num}: book_type invalide '{book_type}'")

            # Détection typos dans name_en et name_fr
            for field in ['name_en', 'name_fr']:
                text = row.get(field, '')
                for pattern, replacement in COMMON_TYPOS.items():
                    if re.search(pattern, text):
                        errors['typos'].append(f"Ligne {line_num}: Typo potentielle dans {field} : '{text}'")

            # Détection doublons number
            number = row.get('number', '')
            if number:
                if number in seen_numbers:
                    errors['duplicates'].append(f"Ligne {line_num}: Doublon number '{number}'")
                seen_numbers.add(number)

    return errors

def print_report(errors: Dict[str, List[str]]) -> int:
    """
    Affiche le rapport de validation.
    Retourne 0 si aucune erreur, 1 sinon.
    """
    total_errors = sum(len(errs) for errs in errors.values())

    if total_errors == 0:
        print("✅ Validation réussie : aucune erreur détectée.")
        return 0

    print(f"❌ Validation échouée : {total_errors} erreur(s) détectée(s).\n")

    for category, errs in errors.items():
        if errs:
            print(f"## {category.upper()} ({len(errs)})")
            for err in errs:
                print(f"  - {err}")
            print()

    return 1

if __name__ == '__main__':
    if len(sys.argv) < 3:
        print("Usage: python scripts/validate_collection_data.py <csv_file> --schema <schema_name>")
        sys.exit(1)

    filepath = Path(sys.argv[1])
    schema_name = sys.argv[3] if len(sys.argv) > 3 else 'dnd5-books'

    if not filepath.exists():
        print(f"❌ Fichier introuvable : {filepath}")
        sys.exit(1)

    errors = validate_csv(filepath, schema_name)
    exit_code = print_report(errors)
    sys.exit(exit_code)
```

**Responsable** : Agent Backend / Agent DevOps  
**Effort estimé** : 1 heure  
**Impact si non traité** : Validations manuelles plus lentes, risque d'erreurs non détectées, pas de standardisation.

---

## 4. Patterns Efficaces Réutilisables

### Pattern 1 : Workflow Excel → CSV → Enrichissement → Validation

**Contexte** : Import de données de collection fournies par l'utilisateur en format Excel.

**Pattern** :
1. Conversion Excel → CSV avec LibreOffice (sans dépendances Python)
2. Analyse statistiques descriptives (count, répartition, complétude)
3. Détection automatique anomalies (typos, doublons, valeurs enum invalides)
4. Enrichissement automatique (génération abréviations, métadonnées calculées)
5. Validation manuelle utilisateur sur fichier enrichi intermédiaire
6. Génération migration SQL après validation explicite
7. Commit atomique avec statistiques complètes

**Avantages** :
- Équilibre automatisation / validation humaine
- Détection précoce erreurs avant insertion BDD
- Traçabilité complète (fichier source + enrichi + migration)
- Réutilisable pour toute future collection

**Réutilisation** : Collections MECCG expansions, autres collections de livres (Pathfinder, Warhammer), import données utilisateur personnalisées.

---

### Pattern 2 : Génération Automatique Abréviations avec Validation Unicité

**Contexte** : Collections avec titres longs nécessitant des identifiants courts (badges UI, clés uniques).

**Pattern** :
1. Définir règles de génération basées sur conventions métier (initiales, cas spéciaux)
2. Générer abréviations automatiquement via script
3. Vérifier unicité automatique (détection collisions)
4. Validation manuelle utilisateur des abréviations générées
5. Ajout colonne `number` dans CSV enrichi

**Exemple D&D 5e** :
- "Player's Handbook" → PHB (cas spécial connu)
- "Curse of Strahd" → CoS (initiales majuscules)
- "Player's Handbook - 2014" → PHB2014 (suffixe année pour collision)

**Avantages** :
- Évite erreurs de saisie manuelle
- Cohérence avec conventions officielles
- Unicité garantie automatiquement
- Gain de temps significatif (53 abréviations générées en quelques secondes)

**Réutilisation** : Collections de livres, extensions de jeux, catalogues produits avec références courtes.

---

### Pattern 3 : Détection Automatique Typos Courantes avec Correction Manuelle

**Contexte** : Données saisies manuellement avec risque d'erreurs orthographiques.

**Pattern** :
1. Définir dictionnaire patterns typos courantes (regex)
2. Scanner automatique fichier source avec patterns
3. Reporter lignes suspectes à l'utilisateur
4. Correction manuelle utilisateur après validation
5. Pas de correction automatique sans confirmation

**Patterns détectés en session** :
- ` ot ` au lieu de ` of `
- Mots tronqués `Isl` au lieu de `Isle`
- Espaces doubles, apostrophes incorrectes

**Avantages** :
- Détection rapide sans lecture ligne par ligne manuelle
- Aucune correction automatique risquée (faux positifs possibles)
- Validation humaine finale garantit qualité

**Réutilisation** : Tout import de données textuelles (noms, descriptions, titres).

---

### Pattern 4 : Commit Atomique avec Statistiques Descriptives

**Contexte** : Import de données volumineuses avec besoin de traçabilité.

**Pattern de message de commit** :

```
data: add [Collection] source data (N entries)

Préparation de la collection [nom] avec données sources validées.

Fichiers ajoutés :
- [source].xlsx : Fichier source fourni par l'utilisateur
  * [statistiques structure]

- [enriched].csv : CSV enrichi avec [colonnes ajoutées]
  * [validations effectuées]
  * Prêt pour génération migration SQL

Statistiques :
- [statistique 1]
- [statistique 2]

Prochaine étape : [action suivante]

Co-Authored-By: Claude Opus 4.7 <noreply@anthropic.com>
```

**Avantages** :
- Traçabilité complète de l'import
- Statistiques accessibles dans historique Git
- Compréhension immédiate du contenu du commit sans lire les fichiers

**Réutilisation** : Tout commit de données (seeds, migrations, imports).

---

### Pattern 5 : Validation Étape par Étape avec Utilisateur

**Contexte** : Import de données critiques avec risque d'erreurs coûteuses.

**Pattern** :
1. Analyser données → Présenter statistiques à l'utilisateur → Attendre validation
2. Détecter anomalies → Reporter anomalies → Demander confirmation corrections
3. Générer enrichissement → Montrer preview → Attendre validation finale
4. Générer SQL → NE PAS exécuter sans validation utilisateur explicite

**RÈGLE** : Jamais d'insertion en BDD sans validation manuelle utilisateur.

**Avantages** :
- Confiance utilisateur (contrôle total sur les données)
- Détection erreurs avant point de non-retour (insertion BDD)
- Collaboration humain-AI efficace (AI détecte, humain décide)

**Réutilisation** : Tout workflow avec impact critique (migrations, suppressions, imports).

---

## 5. État du Système d'Agents

### Points Forts

**1. Communication Clara et Traçabilité**  
Le préfixe "🤖 Alfred :" a été appliqué systématiquement tout au long de la session, avec annonces explicites de chaque délégation. La traçabilité est excellente.

**2. Workflow Automatisé Démarrage Environnement**  
La détection des problèmes environnement (credentials PostgreSQL) a été rapide et la résolution efficace. Le workflow de démarrage a bien fonctionné une fois les volumes nettoyés.

**3. Validation Étape par Étape**  
Toutes les étapes critiques (analyse données, génération abréviations, détection typos) ont été validées avec l'utilisateur avant passage à l'étape suivante. Aucune action irréversible sans confirmation.

**4. Commit Atomique et Message Structuré**  
Le commit `0aebf01` suit parfaitement les best practices : un seul commit pour les données source + enrichi, message détaillé avec statistiques, Co-Authored-By présent.

**5. Patterns Réutilisables Identifiés**  
Le workflow Excel → CSV → enrichissement → validation a été formalisé de facto pendant la session et est documenté dans ce rapport pour réutilisation.

### Points d'Amélioration

**1. Extension PostgreSQL non automatisée**  
L'installation manuelle de l'extension `unaccent` à chaque recréation du volume est un point de friction. La recommandation R1 (migration SQL automatique) doit être implémentée rapidement.

**2. Procédure Cleanup Volumes non documentée**  
Le workflow `docker compose down -v` n'était pas documenté dans `DevOps/restart-procedures.md`. La recommandation R2 comble ce gap.

**3. Workflow Import Données non standardisé**  
Bien que le workflow ait été appliqué avec succès pour D&D 5e, il n'était pas formalisé avant cette session. La recommandation R4 standardise ce processus pour les futures collections.

**4. Validation Automatique Données ad-hoc**  
Les validations (typos, doublons) ont été effectuées manuellement avec des commandes bash ad-hoc. La recommandation R5 (script Python réutilisable) améliorerait la reproductibilité.

---

## 6. Métriques Session

| Métrique | Valeur | Commentaire |
|----------|--------|-------------|
| Durée session | 2h00 | Démarrage environnement (30 min) + Préparation données (1h30) |
| Incidents bloquants | 2 | PostgreSQL credentials + extension unaccent |
| Temps résolution incidents | 30 min | Diagnostic rapide, résolutions efficaces |
| Données préparées | 53 livres | Collection D&D 5e complète |
| Abréviations générées | 53 | Génération automatique avec validation |
| Typos détectées | 2 | "Forge ot" + "Stormwreck Isl" |
| Commits produits | 1 | Commit atomique avec données source + enrichi |
| Lignes CSV validées | 54 | Headers + 53 livres |
| Recommandations produites | 5 | 2 haute priorité, 2 moyenne, 1 faible |
| Patterns réutilisables identifiés | 5 | Documentés en section 4 |

---

## 7. Actions Restantes

| Action | Priorité | Responsable | Effort | Deadline Suggérée |
|--------|----------|-------------|--------|-------------------|
| R1 : Automatiser extension unaccent (migration SQL) | HAUTE | Agent Backend | 10 min | Avant génération migration 010 |
| R2 : Documenter cleanup volumes Docker | HAUTE | Agent DevOps | 15 min | Avant fin de journée 27 avril |
| R3 : Créer script reset-postgres.sh | MOYENNE | Agent DevOps | 30 min | Semaine du 28 avril |
| R4 : Standardiser workflow import données | MOYENNE | Agent Documentation | 45 min | Semaine du 28 avril |
| R5 : Script validation automatique données | FAIBLE | Agent Backend/DevOps | 1h | Semaine du 5 mai |
| Génération migration 010 D&D 5e | HAUTE | Agent Backend | 1h | Après-midi 27 avril (planifié) |

---

## 8. Leçons Clés — Récapitulatif

### Leçon 1 : Volumes Docker persistants et credentials
**Problème** : Changement credentials PostgreSQL non pris en compte à cause d'un volume persistant.  
**Solution** : `docker compose down -v` systématiquement lors de changement credentials.  
**À documenter** : `DevOps/restart-procedures.md` (R2).

### Leçon 2 : Extensions PostgreSQL non versionnées
**Problème** : Extension `unaccent` installée manuellement, perdue à chaque recréation volume.  
**Solution** : Migration SQL `CREATE EXTENSION IF NOT EXISTS unaccent;` dans migration 001.  
**À implémenter** : R1 (priorité haute).

### Leçon 3 : Validation données source systématique
**Problème** : Typos dans fichier Excel source (saisie manuelle utilisateur).  
**Solution** : Détection automatique patterns typos + validation manuelle corrections.  
**À standardiser** : Script validation automatique (R5) + workflow documenté (R4).

### Leçon 4 : Workflow Excel → CSV pragmatique
**Problème** : Pip/Python non disponible sur environnement dev.  
**Solution** : LibreOffice pour conversion Excel → CSV (solution sans dépendances).  
**À documenter** : Workflow import données (R4) avec recommandation LibreOffice.

### Leçon 5 : Abréviations générées automatiquement
**Problème** : 53 abréviations à créer manuellement = risque erreurs + temps long.  
**Solution** : Génération automatique basée conventions métier D&D + validation unicité.  
**Pattern réutilisable** : Pour toutes collections avec titres longs (Pattern 2).

---

*Rapport produit par l'Agent Amélioration Continue — 2026-04-27 (session matin)*
