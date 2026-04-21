# Architecture Decision Records (ADR)

Ce répertoire contient toutes les décisions architecturales importantes du projet Collectoria.

---

## Format ADR

Chaque ADR suit le format simplifié :
- **Date** : Date de la décision
- **Statut** : PROPOSÉ | ACCEPTÉ | REJETÉ | SUPERSEDED
- **Décideur** : Qui a pris la décision
- **Type** : Architecture | Sécurité | DevOps | Fonctionnel
- **Contexte** : Pourquoi cette décision est nécessaire
- **Décision** : Quelle option a été choisie
- **Alternatives Considérées** : Autres options évaluées
- **Conséquences** : Positives, négatives, techniques

---

## Index des ADR

### ADR-001 : CORS - Ajout Méthode PATCH
- **Fichier** : `2026-04-21_cors-patch-method.md`
- **Date** : 2026-04-21
- **Statut** : ACCEPTÉ
- **Type** : Sécurité / DevOps
- **Résumé** : Ajout de la méthode PATCH dans les méthodes HTTP autorisées par CORS pour permettre le toggle de possession de cartes.

**Impact** :
- ✅ Toggle de possession fonctionnel
- ✅ Communication frontend-backend résolue
- ⚠️ À documenter dans les guidelines CORS

---

### ADR-002 : Architecture du Système d'Activités Récentes
- **Fichier** : `2026-04-21_activities-architecture-choice.md`
- **Date** : 2026-04-21
- **Statut** : ACCEPTÉ
- **Type** : Architecture
- **Résumé** : Choix d'une architecture MVP avec base de données locale plutôt qu'une architecture Kafka event-driven immédiate.

**Décision** :
- ✅ Phase 1 (MVP) : Stockage en base de données (2-3h)
- 📅 Phase 2 (Future) : Migration vers Kafka (3-5 jours)

**Raisons** :
- Validation rapide du concept
- Un seul service producteur actuellement
- Kafka a du sens quand on aura 2+ producteurs

**Migration Prévue** :
- Déclencheurs documentés
- Plan détaillé : `future-tasks/migration-kafka-activities.md`

**Impact** :
- ✅ Gain de temps : 1.5 jour économisé sur MVP
- ⚠️ Dette technique : 3-5 jours de migration future

---

## ADR à Venir

### Architecture
- [ ] ADR-003 : Stratégie de cache (Redis vs In-memory)
- [ ] ADR-004 : Gestion des images (CDN vs S3)
- [ ] ADR-005 : Search Engine (PostgreSQL Full-Text vs Elasticsearch)

### Sécurité
- [ ] ADR-006 : Stratégie JWT (Access Token + Refresh Token)
- [ ] ADR-007 : Rate Limiting (Redis vs In-memory)

### DevOps
- [ ] ADR-008 : Orchestration (Docker Compose vs Kubernetes)
- [ ] ADR-009 : CI/CD Pipeline (GitHub Actions vs GitLab CI)

---

## Workflow ADR

### Quand créer une ADR ?

Créer une ADR quand :
- Décision architecturale structurante
- Choix de technologie majeure
- Trade-off important entre plusieurs options
- Décision ayant un impact long terme

**Ne PAS créer d'ADR pour** :
- Décisions mineures ou temporaires
- Choix évidents sans alternative
- Décisions facilement réversibles

### Processus de Création

1. **Discussion** : Identifier le problème et les alternatives
2. **Rédaction** : Créer le fichier ADR (format ci-dessus)
3. **Revue** : Alfred + agents spécialisés
4. **Décision** : Statut ACCEPTÉ ou REJETÉ
5. **Documentation** : Mettre à jour README + rapports

### Cycle de Vie d'une ADR

```
PROPOSÉ → ACCEPTÉ → [SUPERSEDED]
       ↘ REJETÉ
```

- **PROPOSÉ** : En cours de discussion
- **ACCEPTÉ** : Décision validée et appliquée
- **REJETÉ** : Option rejetée (garder pour historique)
- **SUPERSEDED** : Remplacée par une nouvelle ADR

---

## Statistiques

| Statut | Nombre | Dernière Mise à Jour |
|--------|--------|----------------------|
| ACCEPTÉ | 2 | 2026-04-21 |
| PROPOSÉ | 0 | - |
| REJETÉ | 0 | - |
| SUPERSEDED | 0 | - |
| **TOTAL** | **2** | **2026-04-21** |

---

## Références

- Michael Nygard : "Documenting Architecture Decisions" (2011)
- ThoughtWorks Technology Radar : ADR
- Joel Parker Henderson : ADR Templates

---

**Dernière Mise à Jour** : 2026-04-21  
**Maintenu par** : Agent Suivi de Projet
