# Start Here - Collection Management Microservice

Bienvenue! Ce microservice est **prêt à démarrer** en 2 minutes.

---

## Démarrage Ultra-Rapide

```bash
# Une seule commande!
./setup.sh && go run cmd/api/main.go
```

Ensuite dans un autre terminal:

```bash
# Tester l'API
curl http://localhost:8080/api/v1/collections/summary | jq
```

**Résultat attendu**: 24 cartes possédées sur 40 = **60% de complétion** ✅

---

## Que fait ce microservice?

Il gère les **collections de cartes** pour Collectoria et fournit l'endpoint principal:

### GET /api/v1/collections/summary

Retourne les statistiques globales de la collection:
- Total de cartes disponibles
- Total de cartes possédées
- Pourcentage de complétion

---

## Fichiers Importants

| Fichier | Description |
|---------|-------------|
| **START_HERE.md** | Ce fichier - Démarrage rapide |
| **QUICKSTART.md** | Guide de démarrage détaillé (3 options) |
| **README.md** | Documentation complète du microservice |
| **IMPLEMENTATION_REPORT.md** | Rapport technique d'implémentation |
| **setup.sh** | Script de setup automatique |
| **Makefile** | Commandes utiles (make setup, make run, etc.) |

---

## Architecture en 30 secondes

```
HTTP Request → Chi Router → Handler → Service → Repository → PostgreSQL
                                 ↓
                            Domain Logic (DDD)
                                 ↓
                            Entities + Tests
```

**Principes**:
- **DDD** (Domain Driven Design) - Architecture centrée domaine
- **TDD** (Test Driven Development) - Tests avant code
- **Clean Architecture** - Séparation des couches

---

## Tests

```bash
# Tous les tests
go test ./...

# Avec couverture
go test ./... -cover
```

**Couverture actuelle**: 91.7% ✅

---

## Données de Test

**40 cartes MECCG** sont chargées automatiquement avec:
- 6 séries différentes (The Wizards, The Dragons, etc.)
- 17 types hiérarchiques (Héros/Personnage, Péril/Créature, etc.)
- 12 raretés (C1-C3, U1-U3, R1-R3, F1-F2, P)
- Noms bilingues EN/FR
- 24 cartes possédées (60%)

**Voir**: `testdata/MOCK_CARDS_VALIDATION.md`

---

## Prochaines Étapes

1. **Démarrer le service** (ci-dessus)
2. **Lire** `QUICKSTART.md` pour plus d'options
3. **Lire** `README.md` pour la doc complète
4. **Intégrer** avec le frontend Next.js

---

## Aide

### Le service ne démarre pas?

```bash
# Vérifier PostgreSQL
docker-compose ps

# Redémarrer si besoin
docker-compose restart postgres
```

### Port 8080 utilisé?

```bash
export SERVER_PORT=8081
go run cmd/api/main.go
```

### Besoin de réinitialiser les données?

```bash
make docker-down
make docker-up
sleep 5
make migrate
make seed
```

---

## Documentation Complète

- **Quick Start**: `QUICKSTART.md` (3 options de démarrage)
- **README**: `README.md` (documentation complète)
- **Implementation**: `IMPLEMENTATION_REPORT.md` (rapport technique)
- **Stats**: `PROJECT_STATS.md` (statistiques du projet)

---

## Support

Pour toute question, consultez:
1. README.md (99% des réponses)
2. QUICKSTART.md (troubleshooting)
3. Les tests unitaires (exemples d'utilisation)

---

**Ready? Let's go!** 🚀

```bash
./setup.sh && go run cmd/api/main.go
```
