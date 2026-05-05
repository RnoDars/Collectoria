# Installation de shellcheck

shellcheck est un linter pour scripts Bash qui détecte les erreurs de syntaxe, mauvaises pratiques et bugs potentiels.

## Installation

### Ubuntu / Debian

```bash
sudo apt update
sudo apt install shellcheck
```

### macOS (Homebrew)

```bash
brew install shellcheck
```

### Fedora / CentOS / RHEL

```bash
sudo dnf install shellcheck
```

### Via snap (multi-plateformes)

```bash
sudo snap install shellcheck
```

### Binaire direct (si pas de gestionnaire de paquets)

```bash
# Télécharger la dernière version
wget https://github.com/koalaman/shellcheck/releases/download/stable/shellcheck-stable.linux.x86_64.tar.xz

# Extraire
tar -xvf shellcheck-stable.linux.x86_64.tar.xz

# Copier dans /usr/local/bin
sudo cp shellcheck-stable/shellcheck /usr/local/bin/

# Vérifier installation
shellcheck --version
```

## Vérification

```bash
# Vérifier que shellcheck est installé
which shellcheck

# Afficher la version
shellcheck --version
```

## Utilisation

### Vérifier un script

```bash
shellcheck scripts/deploy/deploy-backend.sh
```

### Format GCC (utilisé par validate-script.sh)

```bash
shellcheck -f gcc scripts/deploy/deploy-backend.sh
```

### Ignorer des warnings spécifiques

```bash
# Dans le script
# shellcheck disable=SC2086
command $VARIABLE
```

## Codes d'erreur courants

| Code | Description | Exemple |
|------|-------------|---------|
| SC2086 | Variable non quotée | `docker exec $CONTAINER` → `docker exec "$CONTAINER"` |
| SC2046 | Command substitution non quoté | `$(command)` → `"$(command)"` |
| SC2155 | Déclaration et assignation combinées | `local var=$(cmd)` → Split en 2 lignes |
| SC2162 | read sans -r | `read line` → `read -r line` |
| SC2181 | Vérifier $? directement | `if [ $? -eq 0 ]` → `if command; then` |

## Intégration dans le workflow

shellcheck est utilisé automatiquement par :
- `scripts/lib/validate-script.sh` (validation automatique)
- Agent Code Review (review avant commit)
- Checklist pré-commit (validation manuelle)

## Références

- **Documentation officielle** : https://www.shellcheck.net/
- **Wiki** : https://github.com/koalaman/shellcheck/wiki
- **Liste des codes** : https://github.com/koalaman/shellcheck/wiki/Checks

## Status Installation

- [x] macOS (dev) : ❌ Non installé
- [ ] Ubuntu Server (prod) : À vérifier
- [ ] CI/CD : Pas encore configuré

## Action Requise

**Installer shellcheck sur machine de développement** :

```bash
# macOS
brew install shellcheck

# Linux
sudo apt install shellcheck
```

**Vérifier installation** :

```bash
shellcheck --version
# Attendu: ShellCheck - shell script analysis tool
#          version: x.x.x
```
