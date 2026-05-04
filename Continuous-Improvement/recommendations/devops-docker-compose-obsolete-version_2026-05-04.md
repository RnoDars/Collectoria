# Recommandation : Suppression Ligne Obsolète docker-compose

**Date** : 2026-05-04  
**Agent** : Amélioration Continue  
**Priorité** : BASSE (cosmétique)  
**Impact** : Suppression warning obsolète, logs plus propres

---

## Contexte

**Problème rencontré (session 2026-05-04)** :
- Warning à chaque commande `docker compose` :
  ```
  WARN[0000] /path/to/docker-compose.prod.yml: `version` is obsolete
  ```
- **Cause** : Ligne `version: '3.8'` obsolète depuis Docker Compose v2
- **Impact** : Pollution des logs, confusion utilisateur

**Root cause** : Docker Compose v2+ n'utilise plus la directive `version`. Elle est ignorée mais génère un warning.

---

## Solution : Suppression Ligne

### Changement Effectué

**Fichier** : `docker-compose.prod.yml`

**Avant** :
```yaml
version: '3.8'

services:
  postgres-collection:
    ...
```

**Après** :
```yaml
services:
  postgres-collection:
    ...
```

**Commit** : [À créer]

---

## Validation

### Test Après Suppression

```bash
# Vérifier aucun warning
docker compose -f docker-compose.prod.yml config

# Attendu : Configuration valide, aucun warning "version is obsolete"
```

### Compatibilité

**Docker Compose v2+** : ✅ La ligne `version` est optionnelle et ignorée  
**Docker Compose v1** : ⚠️ Ligne `version` requise, mais v1 est deprecated depuis 2021

**Recommandation** : Supprimer `version` pour tous les fichiers docker-compose du projet (v2 est standard).

---

## Fichiers Concernés

### Fichiers docker-compose du Projet

1. `docker-compose.yml` (local)
2. `docker-compose.prod.yml` (production)
3. Autres fichiers docker-compose s'ils existent

**Action** : Vérifier et supprimer `version: '3.x'` de tous les fichiers docker-compose.

---

## Procédure de Vérification

```bash
# Chercher tous fichiers docker-compose avec directive version
grep -r "^version:" docker-compose*.yml

# Si résultats, supprimer la ligne de chaque fichier
```

---

## Impact Attendu

**Avant** :
- Warning à chaque commande docker compose
- Pollution des logs
- Confusion utilisateur (ligne inutile)

**Après** :
- Aucun warning
- Logs propres
- Conformité avec Docker Compose v2

**Gain** : Qualité cosmétique, meilleure expérience utilisateur

---

## Documentation Docker Compose v2

**Référence officielle** : https://docs.docker.com/compose/compose-file/04-version-and-name/

> The top-level `version` property is defined by the Compose Specification for backward compatibility. It is only informative and you'll receive a warning message that it is obsolete if used.

---

## Prochaines Étapes

1. ✅ Supprimer `version: '3.8'` de docker-compose.prod.yml (FAIT)
2. Vérifier docker-compose.yml (local)
3. Commit changement
4. Tester en production : aucun warning

---

**Référence** : Session 2026-05-04 - Warning docker-compose version obsolète
