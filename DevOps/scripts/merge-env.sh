#!/bin/bash
# =============================================================================
# merge-env.sh — Fusion du template d'environnement avec le .env.production
#
# Usage :
#   bash DevOps/scripts/merge-env.sh [OPTIONS]
#
# Options :
#   --template <chemin>   Chemin du fichier template
#                         (défaut : <racine_repo>/DevOps/.env.production.template)
#   --env <chemin>        Chemin du fichier .env.production cible
#                         (défaut : <racine_repo>/.env.production)
#
# Comportement :
#   - Si .env.production n'existe pas : copie le template avec un avertissement
#   - Si .env.production existe : fusionne les deux fichiers
#     → conserve les valeurs existantes de production
#     → ajoute les nouvelles variables du template (placeholders)
#   - Crée un backup .env.production.bak avant toute modification
#   - Affiche un résumé : variables conservées / variables ajoutées
#   - N'affiche jamais les valeurs, uniquement les noms de variables
# =============================================================================

set -euo pipefail

# ---------------------------------------------------------------------------
# Couleurs pour le terminal
# ---------------------------------------------------------------------------
RED='\033[0;31m'
YELLOW='\033[1;33m'
GREEN='\033[0;32m'
CYAN='\033[0;36m'
BOLD='\033[1m'
RESET='\033[0m'

# ---------------------------------------------------------------------------
# Déterminer la racine du repo (en remontant depuis l'emplacement du script)
# ---------------------------------------------------------------------------
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

# ---------------------------------------------------------------------------
# Valeurs par défaut
# ---------------------------------------------------------------------------
TEMPLATE_PATH="$REPO_ROOT/DevOps/.env.production.template"
ENV_PATH="$REPO_ROOT/.env.production"

# ---------------------------------------------------------------------------
# Parsing des arguments
# ---------------------------------------------------------------------------
while [[ $# -gt 0 ]]; do
    case "$1" in
        --template)
            if [[ -z "${2:-}" ]]; then
                echo -e "${RED}Erreur : --template requiert un chemin en argument.${RESET}" >&2
                exit 1
            fi
            TEMPLATE_PATH="$2"
            shift 2
            ;;
        --env)
            if [[ -z "${2:-}" ]]; then
                echo -e "${RED}Erreur : --env requiert un chemin en argument.${RESET}" >&2
                exit 1
            fi
            ENV_PATH="$2"
            shift 2
            ;;
        -h|--help)
            grep '^#' "$0" | grep -v '^#!/' | sed 's/^# \{0,1\}//'
            exit 0
            ;;
        *)
            echo -e "${RED}Argument inconnu : $1${RESET}" >&2
            echo "Usage : $0 [--template <chemin>] [--env <chemin>]" >&2
            exit 1
            ;;
    esac
done

# ---------------------------------------------------------------------------
# Vérification du template
# ---------------------------------------------------------------------------
if [[ ! -f "$TEMPLATE_PATH" ]]; then
    echo -e "${RED}Erreur : template introuvable : $TEMPLATE_PATH${RESET}" >&2
    exit 1
fi

BAK_PATH="${ENV_PATH}.bak"

echo ""
echo -e "${BOLD}============================================================${RESET}"
echo -e "${BOLD}  merge-env.sh — Fusion de l'environnement de production${RESET}"
echo -e "${BOLD}============================================================${RESET}"
echo ""
echo -e "  Template  : ${CYAN}$TEMPLATE_PATH${RESET}"
echo -e "  Cible     : ${CYAN}$ENV_PATH${RESET}"
echo ""

# ---------------------------------------------------------------------------
# Cas 1 : .env.production n'existe pas → copier le template en entier
# ---------------------------------------------------------------------------
if [[ ! -f "$ENV_PATH" ]]; then
    echo -e "${YELLOW}⚠  Le fichier .env.production n'existe pas.${RESET}"
    echo -e "${YELLOW}   Copie du template vers : $ENV_PATH${RESET}"
    cp "$TEMPLATE_PATH" "$ENV_PATH"
    echo ""
    echo -e "${RED}${BOLD}  ╔══════════════════════════════════════════════════════╗${RESET}"
    echo -e "${RED}${BOLD}  ║  ATTENTION : TOUTES LES VALEURS SONT DES PLACEHOLDERS ║${RESET}"
    echo -e "${RED}${BOLD}  ║  Vous devez renseigner CHAQUE variable manuellement.  ║${RESET}"
    echo -e "${RED}${BOLD}  ╚══════════════════════════════════════════════════════╝${RESET}"
    echo ""

    # Lister toutes les variables du template
    vars_to_fill=()
    while IFS= read -r line; do
        # Ignorer commentaires et lignes vides
        [[ "$line" =~ ^[[:space:]]*# ]] && continue
        [[ -z "${line// }" ]] && continue
        # Extraire le nom de variable (avant le =)
        var_name="${line%%=*}"
        var_name="${var_name// /}"
        [[ -n "$var_name" ]] && vars_to_fill+=("$var_name")
    done < "$TEMPLATE_PATH"

    echo -e "${YELLOW}  Variables à renseigner (${#vars_to_fill[@]}) :${RESET}"
    for v in "${vars_to_fill[@]}"; do
        echo -e "    ${YELLOW}→ $v${RESET}"
    done
    echo ""
    echo -e "${GREEN}  Fichier créé : $ENV_PATH${RESET}"
    echo ""
    exit 0
fi

# ---------------------------------------------------------------------------
# Cas 2 : .env.production existe → fusionner
# ---------------------------------------------------------------------------

# Backup
cp "$ENV_PATH" "$BAK_PATH"
echo -e "  Backup créé : ${CYAN}$BAK_PATH${RESET}"
echo ""

# Charger les clés déjà présentes dans .env.production
declare -A existing_vars
while IFS= read -r line; do
    [[ "$line" =~ ^[[:space:]]*# ]] && continue
    [[ -z "${line// }" ]] && continue
    var_name="${line%%=*}"
    var_name="${var_name// /}"
    [[ -n "$var_name" ]] && existing_vars["$var_name"]=1
done < "$ENV_PATH"

# Préparer le fichier de sortie dans un fichier temporaire
TMP_OUTPUT="$(mktemp)"
trap 'rm -f "$TMP_OUTPUT"' EXIT

# Compteurs
count_kept=0
count_added=0
added_vars=()

# Copier le contenu existant de .env.production tel quel (valeurs de prod)
# puis ajouter à la fin les variables manquantes du template
cp "$ENV_PATH" "$TMP_OUTPUT"

# Vérifier si le fichier se termine par une newline (pour l'ajout propre)
if [[ -s "$TMP_OUTPUT" ]]; then
    last_char="$(tail -c1 "$TMP_OUTPUT" | wc -l)"
    if [[ "$last_char" -eq 0 ]]; then
        echo "" >> "$TMP_OUTPUT"
    fi
fi

# Compter les variables conservées
for var in "${!existing_vars[@]}"; do
    (( count_kept++ )) || true
done

# Parcourir le template pour identifier et ajouter les variables manquantes
# Conserver les blocs commentaire/vide du template pour les nouvelles variables
in_new_section=0

while IFS= read -r line; do
    # Ligne vide ou commentaire : bufferiser pour les ajouter
    # uniquement si une nouvelle variable suit
    if [[ "$line" =~ ^[[:space:]]*# ]] || [[ -z "${line// }" ]]; then
        # On ne les ajoute pas maintenant ; on les ajoutera lors d'une nouvelle var
        # Pour simplifier : on les ajoute dès qu'une nouvelle var est détectée
        continue
    fi

    # Ligne de variable
    var_name="${line%%=*}"
    var_name="${var_name// /}"
    [[ -z "$var_name" ]] && continue

    if [[ -z "${existing_vars[$var_name]+_}" ]]; then
        # Variable absente → ajouter
        if [[ "$in_new_section" -eq 0 ]]; then
            # Séparateur lisible pour les nouvelles variables
            echo "" >> "$TMP_OUTPUT"
            echo "# --- Variables ajoutées par merge-env.sh ($(date +%Y-%m-%d)) ---" >> "$TMP_OUTPUT"
            in_new_section=1
        fi
        echo "$line" >> "$TMP_OUTPUT"
        added_vars+=("$var_name")
        (( count_added++ )) || true
    fi
done < "$TEMPLATE_PATH"

# Remplacer le .env.production par le résultat
cp "$TMP_OUTPUT" "$ENV_PATH"

# ---------------------------------------------------------------------------
# Résumé
# ---------------------------------------------------------------------------
echo -e "${BOLD}  Résumé de la fusion${RESET}"
echo -e "  ─────────────────────────────────────────────────────"
echo -e "  Variables de production conservées : ${GREEN}${BOLD}$count_kept${RESET}"
echo ""

if [[ "$count_added" -eq 0 ]]; then
    echo -e "  ${GREEN}Aucune nouvelle variable à ajouter. Le fichier est à jour.${RESET}"
else
    echo -e "${RED}${BOLD}  ╔══════════════════════════════════════════════════════╗${RESET}"
    echo -e "${RED}${BOLD}  ║  $count_added NOUVELLE(S) VARIABLE(S) AJOUTÉE(S)              ║${RESET}"
    echo -e "${RED}${BOLD}  ║  Ces variables contiennent des placeholders :         ║${RESET}"
    echo -e "${RED}${BOLD}  ║  vous devez les renseigner manuellement !             ║${RESET}"
    echo -e "${RED}${BOLD}  ╚══════════════════════════════════════════════════════╝${RESET}"
    echo ""
    for v in "${added_vars[@]}"; do
        echo -e "    ${RED}${BOLD}→ $v${RESET}"
    done
fi

echo ""
echo -e "  ─────────────────────────────────────────────────────"
echo -e "  ${GREEN}Fichier mis à jour : $ENV_PATH${RESET}"
echo -e "  ${CYAN}Backup conservé   : $BAK_PATH${RESET}"
echo ""
