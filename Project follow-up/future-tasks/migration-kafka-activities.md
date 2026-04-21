# TODO : Migration Architecture Activités vers Kafka

**Priorité** : MEDIUM (à faire après MVP)
**Effort estimé** : 3-5 jours
**Dépendances** : Phase 2 Sécurité complétée + 2+ services producteurs
**ADR Référence** : `decisions/2026-04-21_activities-architecture-choice.md`

## Objectif

Migrer l'architecture des activités récentes du stockage en base de données
locale vers une architecture Kafka event-driven.

## Déclencheurs (Quand faire cette migration ?)

Réévaluer tous les 2-3 mois. Migrer quand AU MOINS 2 des conditions suivantes sont remplies :

- [ ] Au moins 2 services différents produisent des événements d'activité
- [ ] Volume d'activités > 10,000 par jour
- [ ] Besoin de notifications en temps réel
- [ ] Besoin d'audit trail complet et durable
- [ ] Problèmes de scalabilité observés (latence, CPU, mémoire)
- [ ] Besoin de multiple consumers (Analytics Service, Notification Service)

## Architecture Cible

### Avant (Phase 1 - Actuelle)
```
Collection Management Service:
  - Toggle Card Possession
  - ↓ (synchrone)
  - Create Activity Record (activities table)
  - ↓
  - Expose via GET /api/v1/activities/recent
```

### Après (Phase 2 - Kafka)
```
Collection Service → Kafka Topic → Activity Service → API
    (Producer)       (async)       (Consumer)
                       ↓
                  Notification Service (Consumer)
                       ↓
                  Analytics Service (Consumer)
```

## Tâches de Migration

### Infrastructure (0.5 jour)

- [ ] **Setup Kafka local**
  - [ ] Ajouter Kafka + Zookeeper dans docker-compose.yml
  - [ ] Configurer topics Kafka (`activity.events`)
  - [ ] Configurer retention policies (7 jours pour MVP, ajustable)
  - [ ] Configurer replication factor (1 local, 3 en prod)
  - [ ] Tester démarrage et connectivité

- [ ] **Setup Kafka production**
  - [ ] Provisionner infrastructure Kafka (Kubernetes ou service managé)
  - [ ] Configurer monitoring (Prometheus + Grafana)
  - [ ] Configurer alertes (lag, throughput, errors)
  - [ ] Backup et recovery strategy

### Développement Activity Service (1 jour)

- [ ] **Créer nouveau microservice Activity Service**
  - [ ] Structure projet Go (cmd, internal, pkg)
  - [ ] Configuration (config.go, .env)
  - [ ] Dockerfile et docker-compose

- [ ] **Repository Layer**
  - [ ] Domain : Activity entity
  - [ ] Repository interface
  - [ ] PostgreSQL implementation
  - [ ] Migrations schema activities

- [ ] **Consumer Kafka**
  - [ ] Setup Sarama ou Kafka Go client
  - [ ] Consumer group configuration
  - [ ] Message deserializer (Avro/Protobuf/JSON)
  - [ ] Handler pour event `card.possession.changed`
  - [ ] Error handling et retry logic
  - [ ] Offset management (auto-commit vs manual)

- [ ] **API REST**
  - [ ] GET /api/v1/activities/recent?limit=10
  - [ ] GET /api/v1/activities/{id}
  - [ ] Health check endpoint
  - [ ] Handlers + routing

### Développement Producer (1 jour)

- [ ] **Implémenter Producer Kafka dans Collection Management**
  - [ ] Setup Sarama producer
  - [ ] Event schema definition (Avro ou Protobuf recommandé)
  - [ ] Producer pour event : `card.possession.changed`
    ```json
    {
      "event_type": "card.possession.changed",
      "event_id": "uuid",
      "timestamp": "2026-04-21T15:00:00Z",
      "user_id": "uuid",
      "card_id": "uuid",
      "collection_id": "uuid",
      "is_owned": true,
      "metadata": {
        "card_name": "Gandalf",
        "collection_name": "MECCG"
      }
    }
    ```
  - [ ] Async fire-and-forget vs sync with callback
  - [ ] Error handling (dead letter queue?)

- [ ] **Double-write temporaire**
  - [ ] Garder l'ancien système (DB direct)
  - [ ] Ajouter producer Kafka en parallèle
  - [ ] Feature flag pour basculer entre les deux
  - [ ] Logs de comparaison pour validation

### Tests (1 jour)

- [ ] **Tests unitaires Activity Service**
  - [ ] Domain logic
  - [ ] Repository (mocks)
  - [ ] Handlers

- [ ] **Tests unitaires Producer**
  - [ ] Event serialization
  - [ ] Producer configuration

- [ ] **Tests d'intégration avec Kafka**
  - [ ] testcontainers Kafka
  - [ ] Test end-to-end : Producer → Kafka → Consumer → DB
  - [ ] Test error handling (Kafka down, deserialization failure)
  - [ ] Test offset management
  - [ ] Test consumer lag

- [ ] **Tests de charge**
  - [ ] Produire 10k événements
  - [ ] Mesurer throughput et latency
  - [ ] Identifier bottlenecks

### Migration Données Historiques (0.5 jour - optionnel)

- [ ] **Décider si nécessaire**
  - Option A : Partir de zéro (perte historique)
  - Option B : Migrer les N derniers jours
  - Option C : Migrer tout l'historique

- [ ] **Script de migration**
  - [ ] Lire activities depuis Collection Management DB
  - [ ] Convertir en events Kafka
  - [ ] Produire dans le topic Kafka
  - [ ] Valider dans Activity Service DB

### DevOps (0.5 jour)

- [ ] **Dockerfiles**
  - [ ] Activity Service Dockerfile
  - [ ] Multi-stage build optimisé

- [ ] **docker-compose**
  - [ ] Ajouter Kafka + Zookeeper
  - [ ] Ajouter Activity Service
  - [ ] Networks et dependencies

- [ ] **CI/CD**
  - [ ] Build Activity Service
  - [ ] Tests automatisés (unit + integration)
  - [ ] Déploiement staging
  - [ ] Déploiement production

- [ ] **Monitoring Kafka**
  - [ ] Consumer lag (alerte si > 1000 messages)
  - [ ] Throughput (messages/sec)
  - [ ] Error rate
  - [ ] Disk usage Kafka

### Documentation

- [ ] **Mettre à jour ADR**
  - [ ] Marquer statut : SUPERSEDED
  - [ ] Ajouter date de migration
  - [ ] Lien vers nouvelle architecture

- [ ] **Documenter format des events**
  - [ ] Schema registry ou fichiers .avro
  - [ ] Exemples de payloads
  - [ ] Versioning strategy

- [ ] **Guide pour ajouter nouveaux producteurs**
  - [ ] Template event schema
  - [ ] Code examples (Go)
  - [ ] Best practices

- [ ] **Runbook opérationnel Kafka**
  - [ ] Comment redémarrer Kafka
  - [ ] Comment vérifier le lag
  - [ ] Comment retraiter des messages (reset offset)
  - [ ] Troubleshooting commun

- [ ] **Mettre à jour README backend**
  - [ ] Section Kafka architecture
  - [ ] Setup instructions
  - [ ] Development workflow

## Bénéfices Attendus

### Techniques
- Découplage complet entre services
- Scalabilité horizontale (multiple consumers)
- Résilience (buffer des événements en cas de panne)
- Audit trail complet et durable
- Base pour notifications temps réel
- Base pour analytics avancées

### Business
- Notifications push en temps réel
- Analytics : cartes les plus populaires, tendances
- Webhooks pour intégrations tierces
- Historique complet des actions utilisateur

## Risques

### Techniques
- Complexité opérationnelle accrue (Kafka + Zookeeper)
- Besoin de monitoring et alerting Kafka
- Gestion des échecs de consommation (retry, DLQ)
- Schema evolution et versioning (breaking changes)
- Debugging plus complexe (messages asynchrones)

### Mitigation
- Formation équipe sur Kafka
- Documentation opérationnelle complète
- Tests d'intégration robustes
- Feature flags pour rollback rapide
- Dead Letter Queue pour messages en erreur

## Stratégie de Bascule

### Phase 1 : Préparation (1 jour)
1. Setup Kafka en staging
2. Déployer Activity Service en staging
3. Tests end-to-end

### Phase 2 : Double-write (1 semaine)
1. Activer producer Kafka en production
2. Garder l'ancien système actif
3. Comparer les résultats (monitoring)
4. Valider que 100% des events arrivent

### Phase 3 : Bascule (1 jour)
1. Router le frontend vers Activity Service
2. Monitorer erreurs et latency
3. Si OK après 24h : désactiver l'ancien système

### Phase 4 : Nettoyage (1 jour)
1. Retirer le code de l'ancien système
2. Supprimer la table activities de Collection Management
3. Mettre à jour documentation

### Rollback Plan
- Si problème : feature flag pour revenir à l'ancien système
- Temps de rollback : < 5 minutes
- Aucune perte de données (double-write pendant la transition)

## Références

- ADR : `decisions/2026-04-21_activities-architecture-choice.md`
- Kafka Documentation : https://kafka.apache.org/documentation/
- Event Sourcing Pattern : https://martinfowler.com/eaaDev/EventSourcing.html
- Sarama Go Client : https://github.com/IBM/sarama
- testcontainers-go Kafka : https://golang.testcontainers.org/modules/kafka/

## Notes

### Pourquoi attendre ?

Cette migration n'est **PAS urgente**. L'architecture actuelle (Phase 1)
est suffisante pour le MVP et peut scaler jusqu'à plusieurs milliers
d'activités par jour.

### Principe de décision

**"Don't over-engineer for scale you don't have yet"**

Migrer vers Kafka uniquement quand les bénéfices justifient le coût
(développement + opérationnel).

### Réévaluation

Réévaluer la nécessité de cette migration :
- Tous les 2-3 mois
- À chaque nouveau service producteur d'événements
- Si problèmes de performance observés

### Alternative : Service managé

Si la complexité opérationnelle de Kafka est un frein, considérer
un service managé (AWS MSK, Confluent Cloud, Azure Event Hubs).

**Coût vs Complexité** :
- Self-hosted : Gratuit mais complexe à opérer
- Managé : Payant mais opérationnel simplifié

## Checklist de Validation Finale

Avant de considérer la migration complète :

- [ ] Tous les tests passent (unit + integration + e2e)
- [ ] Monitoring Kafka opérationnel
- [ ] Runbook documenté et testé
- [ ] Équipe formée sur Kafka
- [ ] Double-write validé en production (1 semaine)
- [ ] Performance : latency < 100ms (p99)
- [ ] Performance : consumer lag < 100 messages
- [ ] Rollback plan testé en staging
- [ ] Documentation à jour (ADR, README, guides)
