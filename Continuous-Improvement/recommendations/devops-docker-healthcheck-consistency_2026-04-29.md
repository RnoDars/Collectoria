# Recommandation : Cohérence Healthcheck Dockerfile ↔ docker-compose

**Date** : 2026-04-29  
**Agent** : Amélioration Continue  
**Priorité** : CRITIQUE  
**Effort** : Moyen  
**ROI** : Très élevé

---

## Problème Identifié

### Incident Phase 4

Lors du déploiement Phase 4, le backend était fonctionnel (logs OK, requêtes manuelles réussies) mais Docker le marquait "unhealthy", bloquant le déploiement pendant 1 heure.

**Cause** :
- Healthcheck Dockerfile : `wget --spider` (requête HTTP HEAD)
- Healthcheck docker-compose.prod.yml : également `wget --spider` (HEAD)
- Endpoint backend `/api/v1/health` : accepte uniquement GET

**Piège** :
- Modifier uniquement le Dockerfile était INSUFFISANT
- docker-compose.prod.yml OVERRIDE le healthcheck du Dockerfile
- Il fallait corriger LES DEUX fichiers (ou uniquement docker-compose si on utilise celui-ci)

---

## Impact

### Temps Perdu
- **1 heure** de debug (50% du temps de la session Phase 4)
- **4 rebuilds** complets de l'image Docker
- **Multiples commits** en production

### Gravité
- **Blocage total** du déploiement
- Cause non évidente (healthcheck vs méthode HTTP)
- Frustration élevée (multiples tentatives infructueuses)

### Coût Business
- Retard déploiement
- Stress utilisateur
- Perte de confiance

---

## Solution Proposée

### 1. Checker de Cohérence Pré-Déploiement

Créer un script `DevOps/scripts/validate-healthchecks.sh` :

```bash
#!/bin/bash
# Validation cohérence healthcheck Dockerfile ↔ docker-compose.prod.yml

set -e

echo "🔍 Validation des healthchecks..."

# Chemins
BACKEND_DOCKERFILE="backend/collection-management/Dockerfile"
FRONTEND_DOCKERFILE="frontend/Dockerfile"
DOCKER_COMPOSE_PROD="docker-compose.prod.yml"

# Extraction healthcheck du Dockerfile backend
BACKEND_DOCKERFILE_HC=$(grep -A 1 "HEALTHCHECK" $BACKEND_DOCKERFILE | grep "CMD" || echo "NONE")

# Extraction healthcheck du docker-compose backend
BACKEND_COMPOSE_HC=$(yq '.services.backend.healthcheck.test' $DOCKER_COMPOSE_PROD || echo "NONE")

# Extraction healthcheck du Dockerfile frontend
FRONTEND_DOCKERFILE_HC=$(grep -A 1 "HEALTHCHECK" $FRONTEND_DOCKERFILE | grep "CMD" || echo "NONE")

# Extraction healthcheck du docker-compose frontend
FRONTEND_COMPOSE_HC=$(yq '.services.frontend.healthcheck.test' $DOCKER_COMPOSE_PROD || echo "NONE")

# Fonction de validation
validate_healthcheck() {
  local service=$1
  local dockerfile_hc=$2
  local compose_hc=$3

  echo ""
  echo "📋 Service: $service"
  echo "  Dockerfile: $dockerfile_hc"
  echo "  docker-compose: $compose_hc"

  # Vérifier si docker-compose override le healthcheck
  if [[ "$compose_hc" != "NONE" && "$compose_hc" != "null" ]]; then
    echo "  ⚠️  docker-compose.prod.yml OVERRIDE le healthcheck du Dockerfile"
    
    # Vérifier cohérence
    if [[ "$compose_hc" == *"--spider"* ]]; then
      echo "  ❌ ERREUR : docker-compose utilise --spider (HTTP HEAD)"
      echo "     Les endpoints Go n'acceptent généralement que GET"
      echo "     Solution : Remplacer --spider par -O /dev/null"
      return 1
    fi
  fi

  # Vérifier Dockerfile si pas d'override
  if [[ "$compose_hc" == "NONE" || "$compose_hc" == "null" ]]; then
    if [[ "$dockerfile_hc" == *"--spider"* ]]; then
      echo "  ❌ ERREUR : Dockerfile utilise --spider (HTTP HEAD)"
      echo "     Solution : Remplacer --spider par -O /dev/null"
      return 1
    fi
  fi

  echo "  ✅ Healthcheck OK"
  return 0
}

# Validation
ERRORS=0

validate_healthcheck "backend" "$BACKEND_DOCKERFILE_HC" "$BACKEND_COMPOSE_HC" || ERRORS=$((ERRORS+1))
validate_healthcheck "frontend" "$FRONTEND_DOCKERFILE_HC" "$FRONTEND_COMPOSE_HC" || ERRORS=$((ERRORS+1))

# Résultat final
echo ""
if [ $ERRORS -eq 0 ]; then
  echo "✅ Tous les healthchecks sont valides"
  exit 0
else
  echo "❌ $ERRORS erreur(s) détectée(s)"
  echo ""
  echo "💡 Rappel :"
  echo "   - docker-compose.prod.yml OVERRIDE le healthcheck du Dockerfile"
  echo "   - wget --spider = requête HTTP HEAD"
  echo "   - wget -O /dev/null = requête HTTP GET"
  echo "   - Les endpoints Go (router.GET) n'acceptent que GET"
  exit 1
fi
```

**Dépendances** :
- `yq` (pour parser YAML) : `sudo snap install yq` ou `brew install yq`

---

### 2. Template docker-compose.prod.yml

Fournir un template avec healthcheck correct par défaut :

```yaml
services:
  backend:
    healthcheck:
      test: ["CMD", "wget", "--quiet", "--tries=1", "-O", "/dev/null", "http://localhost:8080/api/v1/health"]
      interval: 30s
      timeout: 5s
      retries: 3
      start_period: 10s

  frontend:
    healthcheck:
      test: ["CMD", "wget", "--quiet", "--tries=1", "-O", "/dev/null", "http://localhost:3000/"]
      interval: 30s
      timeout: 5s
      retries: 3
      start_period: 15s
```

**Documentation inline** :
```yaml
# ⚠️ IMPORTANT : Ne PAS utiliser --spider (HTTP HEAD)
# Les endpoints Go (router.GET) n'acceptent que GET
# Utiliser -O /dev/null pour une requête GET
```

---

### 3. Procédure de Validation AVANT Phase 4

**Checklist ajoutée à Phase 3.5** :

```markdown
## Validation Healthcheck

- [ ] Script `validate-healthchecks.sh` exécuté localement
- [ ] Aucune erreur détectée
- [ ] Test local avec docker-compose.prod.yml :
  ```bash
  docker compose -f docker-compose.prod.yml up -d
  docker ps  # Vérifier colonne STATUS : healthy
  ```
- [ ] Healthcheck backend répond 200 :
  ```bash
  docker exec collectoria-backend wget -O- http://localhost:8080/api/v1/health
  ```
- [ ] Healthcheck frontend répond 200 :
  ```bash
  docker exec collectoria-frontend wget -O- http://localhost:3000/
  ```
```

---

### 4. Documentation dans DevOps/CLAUDE.md

Ajouter une **nouvelle règle 7** :

```markdown
### 7. Cohérence Healthcheck Dockerfile ↔ docker-compose

**Règle critique** : Les healthchecks doivent être cohérents ET compatibles avec les endpoints backend.

**Piège docker-compose** : 
- docker-compose.prod.yml OVERRIDE le healthcheck du Dockerfile
- Modifier uniquement le Dockerfile est INSUFFISANT si docker-compose définit aussi un healthcheck

**Méthode HTTP** :
- ❌ `wget --spider` → Requête HTTP HEAD
- ✅ `wget -O /dev/null` → Requête HTTP GET
- Les endpoints Go `router.GET(...)` n'acceptent QUE GET

**Validation OBLIGATOIRE** :
```bash
# Avant Phase 4
bash DevOps/scripts/validate-healthchecks.sh
```

**Référence** : Incident Phase 4 (2026-04-29) - 1h de debug
```

---

## Plan d'Action

### Étape 1 : Créer le Script de Validation
**Responsable** : Agent DevOps  
**Effort** : 20 minutes  
**Fichier** : `DevOps/scripts/validate-healthchecks.sh`

### Étape 2 : Créer Template docker-compose.prod.yml
**Responsable** : Agent DevOps  
**Effort** : 10 minutes  
**Fichier** : `DevOps/templates/docker-compose.prod.yml`

### Étape 3 : Créer Phase 3.5 avec Checklist
**Responsable** : Agent Amélioration Continue  
**Effort** : 15 minutes  
**Fichier** : `DevOps/phase3.5-production-files-validation.md`

### Étape 4 : Mettre à Jour DevOps/CLAUDE.md
**Responsable** : Agent Amélioration Continue  
**Effort** : 5 minutes  
**Modification** : Ajout règle 7

### Étape 5 : Tester le Workflow Complet
**Responsable** : Agent DevOps  
**Effort** : 30 minutes  
**Actions** :
1. Exécuter validate-healthchecks.sh
2. Corriger erreurs éventuelles
3. Build Docker local avec docker-compose.prod.yml
4. Vérifier colonne STATUS : healthy

---

## Agents Impactés

- **Agent DevOps** : Création scripts, templates, procédures
- **Agent Backend** : Validation endpoints healthcheck (GET vs HEAD)
- **Agent Amélioration Continue** : Création Phase 3.5, mise à jour doc
- **Alfred** : Intégration Phase 3.5 dans workflow déploiement

---

## Bénéfices Attendus

### Avant (Situation Actuelle)
- Healthcheck incompatible découvert en Phase 4
- 1 heure de debug en production
- 4 rebuilds multiples commits

### Après (Avec Recommandation)
- Healthcheck validé en Phase 3.5 (local)
- Erreurs détectées AVANT Phase 4
- Déploiement Phase 4 sans accroc

### Gains
- **Temps** : -60 minutes par déploiement
- **Stress** : Fortement réduit
- **Qualité** : Déploiements fiables

---

## Exemples Concrets

### Healthcheck INCORRECT (HEAD)
```yaml
healthcheck:
  test: ["CMD", "wget", "--spider", "http://localhost:8080/api/v1/health"]
```
**Résultat** : 405 Method Not Allowed → unhealthy

### Healthcheck CORRECT (GET)
```yaml
healthcheck:
  test: ["CMD", "wget", "-O", "/dev/null", "http://localhost:8080/api/v1/health"]
```
**Résultat** : 200 OK → healthy

---

## Validation

### Critères de Succès
1. ✅ Script `validate-healthchecks.sh` exécutable et fonctionnel
2. ✅ Template docker-compose.prod.yml avec healthcheck correct
3. ✅ Checklist Phase 3.5 inclut validation healthcheck
4. ✅ DevOps/CLAUDE.md contient règle 7
5. ✅ Test local docker-compose.prod.yml réussi

### Test de Non-Régression
Prochaine session Phase 4 :
- Healthcheck validé AVANT déploiement
- Aucun problème healthcheck en production
- Phase 4 complétée en <60 minutes

---

## Références

- **Incident** : Session Phase 4 (2026-04-29)
- **Rapport** : `Continuous-Improvement/reports/2026-04-29_phase4-deployment-issues.md`
- **Temps perdu** : 1 heure (50% de la session)
- **Gravité** : CRITIQUE (blocage total)

---

**Statut** : À Implémenter  
**Responsable** : Agent DevOps (avec support Agent Amélioration Continue)  
**Deadline** : Avant prochaine Phase 4
