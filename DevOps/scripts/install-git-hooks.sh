#!/bin/bash
# Installation des hooks Git automatiques pour Collectoria
# Usage: bash DevOps/scripts/install-git-hooks.sh

set -e

REPO_ROOT="$(git rev-parse --show-toplevel)"
HOOKS_DIR="$REPO_ROOT/.git/hooks"

echo "📋 Installation des hooks Git automatiques pour Collectoria"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# Vérifier qu'on est bien dans le repo
if [ ! -d "$HOOKS_DIR" ]; then
  echo "❌ Erreur: Répertoire .git/hooks non trouvé"
  echo "   Exécuter ce script depuis la racine du repo Collectoria"
  exit 1
fi

echo "📂 Répertoire hooks: $HOOKS_DIR"
echo ""

# ============================================================================
# Hook #1: post-commit Security
# ============================================================================

echo "🔒 Installation du hook post-commit Security..."

cat > "$HOOKS_DIR/post-commit" << 'EOF'
#!/bin/bash
# Hook post-commit: Audit Security automatique
# Déclenché après chaque commit touchant Backend/ ou Frontend/

COMMIT_HASH=$(git rev-parse --short HEAD)
FILES=$(git diff-tree --no-commit-id --name-only -r HEAD)

# Vérifier si Backend ou Frontend modifié
if echo "$FILES" | grep -qE '^(Backend|Frontend|backend|frontend)/'; then
  echo ""
  echo "🔒 Hook Security: Commit $COMMIT_HASH touche Backend/Frontend"

  # Créer répertoire reports si nécessaire
  REPORT_DIR="Security/reports"
  mkdir -p "$REPORT_DIR"

  # Créer rapport minimal
  REPORT_FILE="$REPORT_DIR/$(date +%Y-%m-%d)_audit-commit-$COMMIT_HASH.md"

  cat > "$REPORT_FILE" << REPORT_EOF
# Audit Sécurité - Commit $COMMIT_HASH

**Date** : $(date +%Y-%m-%d)
**Commit** : $COMMIT_HASH
**Déclencheur** : Hook post-commit automatique

## Fichiers Modifiés

\`\`\`
$FILES
\`\`\`

## Résultat

**TODO** : Audit à compléter par Agent Security

### Checklist Audit

- [ ] Pas de secrets hardcodés (API keys, passwords, tokens)
- [ ] Validation des inputs utilisateur
- [ ] Gestion des erreurs sécurisée (pas de stack traces exposées)
- [ ] Authentification/Authorization correcte
- [ ] Pas de vulnérabilités OWASP Top 10
- [ ] Dépendances à jour (pas de CVE connus)

## Actions Recommandées

_À compléter après audit manuel_

---

*Rapport généré automatiquement par hook post-commit.*
*Pour audit complet, exécuter: \`Security/audit-mvp.sh\`*
REPORT_EOF

  echo "   ✅ Rapport créé: $REPORT_FILE"
  echo "   ⚠️  TODO: Compléter l'audit manuellement ou via Agent Security"
  echo ""
fi
EOF

chmod +x "$HOOKS_DIR/post-commit"
echo "   ✅ Hook post-commit Security installé"
echo ""

# ============================================================================
# Hook #2: post-commit Amélioration Continue (périodique)
# ============================================================================

echo "📊 Installation du hook post-commit Amélioration Continue..."

# Note: Git n'exécute qu'un seul fichier post-commit
# On ajoute la logique Amélioration Continue dans le même fichier

cat >> "$HOOKS_DIR/post-commit" << 'EOF'

# ============================================================================
# Hook Amélioration Continue: Audit périodique tous les 10 commits
# ============================================================================

COMMIT_COUNT=$(git rev-list --count HEAD)

if [ $((COMMIT_COUNT % 10)) -eq 0 ]; then
  echo "📊 Hook Amélioration Continue: Commit #$COMMIT_COUNT (multiple de 10)"
  echo ""
  echo "   🔍 Audit système d'agents recommandé"
  echo "   📋 Actions suggérées:"
  echo "      - Analyser taille fichiers CLAUDE.md"
  echo "      - Vérifier redondances entre agents"
  echo "      - Identifier gaps de couverture"
  echo "      - Créer rapport dans Continuous-Improvement/reports/"
  echo ""
  echo "   💡 Commande manuelle:"
  echo "      Demander à Alfred d'invoquer Agent Amélioration Continue"
  echo ""
fi
EOF

echo "   ✅ Hook post-commit Amélioration Continue ajouté"
echo ""

# ============================================================================
# Vérification installation
# ============================================================================

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "✅ Installation terminée avec succès!"
echo ""
echo "📋 Hooks installés:"
echo "   - post-commit (Security + Amélioration Continue)"
echo ""
echo "🧪 Test recommandé:"
echo "   1. Créer un commit dummy:"
echo "      git commit --allow-empty -m 'test: verify git hooks installed'"
echo ""
echo "   2. Vérifier qu'un rapport Security est créé dans Security/reports/"
echo ""
echo "   3. Au commit #80 (multiple de 10), vérifier message Amélioration Continue"
echo ""
echo "📊 État actuel:"
COMMIT_COUNT=$(git rev-list --count HEAD)
echo "   - Commits totaux: $COMMIT_COUNT"
echo "   - Prochain audit périodique: commit #$((((COMMIT_COUNT / 10) + 1) * 10))"
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
