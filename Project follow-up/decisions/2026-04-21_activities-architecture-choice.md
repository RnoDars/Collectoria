# ADR-002: Architecture du Système d'Activités Récentes

**Date** : 2026-04-21
**Statut** : ACCEPTÉ
**Décideur** : Utilisateur + Alfred
**Type** : Architecture

## Contexte

Le widget "Activités Récentes" du dashboard affiche actuellement des données mockées. 
Besoin de le brancher sur les vraies activités issues des actions utilisateur (toggle possession de cartes).

Deux approches ont été considérées :
1. MVP rapide avec stockage en base de données locale
2. Architecture Kafka event-driven dès le début

## Décision

**Choix : Option A - MVP avec événements en base de données**

### Phase 1 (MVP - Maintenant)

Architecture simple et directe :
- Activities stockées dans la table `activities` du microservice Collection Management
- Création synchrone lors des actions utilisateur (toggle possession)
- Exposition via l'endpoint existant GET /api/v1/activities/recent

```
Collection Management Service:
  - Toggle Card Possession
  - ↓ (synchrone)
  - Create Activity Record (activities table)
  - ↓
  - Expose via GET /api/v1/activities/recent
```

**Implémentation** :
- Service method : `ActivityService.RecordCardActivity()`
- Appelé depuis `CardService.ToggleCardPossession()`
- Repository : `ActivityRepository` (PostgreSQL)

**Effort estimé** : 2-3 heures

### Phase 2 (Migration Future - Documentée pour référence)

Architecture Kafka event-driven complète :

```
Collection Service → Kafka Topic → Activity Service → API
                   (async)        (consumer)
```

**Composants** :
- Topic Kafka : `activity.events`
- Producer : Collection Management Service
- Consumer : Activity Service (nouveau microservice dédié)
- Event types : `card.possession.changed`, `card.added`, etc.

**Effort estimé** : 3-5 jours

## Alternatives Considérées

### Option B : Kafka Event-Driven Immédiat

**Avantages** :
- Architecture cible propre dès le début
- Découplage fort entre services
- Scalabilité native
- Audit trail complet et durable
- Extensible (notifications, analytics, webhooks)
- Buffer en cas de défaillance d'un service
- Multiple consumers possibles (Activity Service, Notification Service, Analytics)

**Inconvénients** :
- Infrastructure complexe (Kafka + Zookeeper)
- Temps de développement : 1-2 jours
- Tests d'intégration Kafka nécessaires
- Courbe d'apprentissage pour l'équipe
- Overhead opérationnel (monitoring, debugging, scaling)
- Over-engineering pour MVP avec un seul producteur

**Pourquoi rejetée** : 
- Trop complexe pour un MVP
- Un seul service producteur actuellement (Collection Management)
- Peut être implémentée plus tard sans refonte majeure
- Permet d'itérer rapidement sur le format des activités

## Conséquences

### Positives
- ✅ Implémentation rapide (2-3h vs 1-2 jours)
- ✅ Validation immédiate du concept et du format d'activité
- ✅ Itération rapide sur le format des activités
- ✅ Pas de nouvelle infrastructure à gérer
- ✅ Migration vers Kafka reste possible et simple
- ✅ Suffisant pour le MVP et plusieurs milliers d'activités/jour
- ✅ Tests plus simples (pas de testcontainers Kafka)

### Négatives
- ⚠️ Couplage temporaire (activities dans Collection Management)
- ⚠️ Pas de buffer en cas de défaillance
- ⚠️ Scalabilité limitée (mais suffisante pour MVP)
- ⚠️ Dette technique à rembourser plus tard
- ⚠️ Pas d'audit trail durable (sauf si on garde les anciennes activities)
- ⚠️ Un seul consumer possible

### Techniques

**Tables** :
```sql
CREATE TABLE activities (
    id UUID PRIMARY KEY,
    user_id UUID NOT NULL,
    activity_type VARCHAR(50) NOT NULL,
    entity_type VARCHAR(50) NOT NULL,
    entity_id UUID NOT NULL,
    metadata JSONB,
    created_at TIMESTAMP WITH TIME ZONE NOT NULL
);

CREATE INDEX idx_activities_user_id_created_at 
    ON activities(user_id, created_at DESC);
```

**Endpoints** :
- GET /api/v1/activities/recent?limit=10

**Services** :
- `ActivityService.RecordCardActivity()`
- Appelé depuis `CardService.ToggleCardPossession()`

## Migration Future (Phase 2)

### Quand migrer vers Kafka ?

**Déclencheurs** :
- ✅ Au moins 2 services différents produisent des événements d'activité
- ✅ Volume d'activités > 10,000 par jour
- ✅ Besoin de notifications en temps réel
- ✅ Besoin d'audit trail complet et durable
- ✅ Besoin de multiple consumers (analytics, notifications, webhooks)
- ✅ Problèmes de scalabilité observés

**Réévaluation** : Tous les 2-3 mois ou à chaque nouveau service producteur.

### Effort estimé de migration

**Total** : 3-5 jours

**Détails** :
- Setup Kafka local + production : 0.5 jour
- Création Activity Service séparé : 1 jour
- Implémentation producers/consumers : 1 jour
- Tests d'intégration avec testcontainers Kafka : 1 jour
- Migration données historiques (optionnel) : 0.5 jour
- Documentation et monitoring : 0.5 jour

### Stratégie de migration

1. **Préparation** :
   - Setup Kafka en local
   - Créer Activity Service vide
   - Définir le schema des events (Avro ou Protobuf)

2. **Implémentation parallèle** :
   - Garder l'ancien système en place
   - Ajouter producer Kafka dans Collection Management
   - Implémenter consumer dans Activity Service
   - Double-write temporaire (DB + Kafka)

3. **Validation** :
   - Comparer les résultats des deux systèmes
   - Tests de charge
   - Validation en staging

4. **Bascule** :
   - Désactiver le double-write
   - Retirer l'ancien code
   - Nettoyer la table activities du Collection Management

5. **Post-migration** :
   - Migration données historiques (optionnel)
   - Documentation opérationnelle
   - Formation équipe

## Références

- Event Sourcing Pattern (Martin Fowler) : https://martinfowler.com/eaaDev/EventSourcing.html
- Microservices Patterns (Chris Richardson) : https://microservices.io/patterns/data/event-sourcing.html
- Kafka: The Definitive Guide : https://kafka.apache.org/documentation/
- TODO Migration : `Project follow-up/future-tasks/migration-kafka-activities.md`

## Notes

Cette décision permet d'avancer rapidement sur le MVP tout en gardant
une vision claire de l'architecture cible. La migration vers Kafka est
documentée et planifiée pour plus tard.

**Principe clé** : Start simple, evolve to complex when needed.

L'architecture actuelle (Phase 1) est suffisante pour :
- Valider le concept auprès des utilisateurs
- Tester différents formats d'activités
- Supporter plusieurs milliers d'activités par jour
- Itérer rapidement sur le produit

La migration vers Kafka (Phase 2) sera déclenchée par des besoins réels,
pas par des anticipations.
