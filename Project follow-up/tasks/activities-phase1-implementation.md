# Tâches : Implémentation Architecture Activités Phase 1

**Créé le** : 2026-04-21  
**Type** : Feature Implementation  
**Priorité** : Medium  
**Effort estimé** : 2-3 heures  
**Agent responsable** : Backend + Frontend  
**Référence ADR** : `decisions/2026-04-21_activities-architecture-choice.md`

---

## Contexte

Implémenter l'architecture Phase 1 (MVP) du système d'activités récentes :
- Stockage en base de données locale (Collection Management)
- Création synchrone lors des actions utilisateur
- Exposition via API REST

---

## Tâches Backend (1.5h)

### 1. Migration Base de Données (15 min)

- [ ] **Créer migration SQL** : `migrations/00X_create_activities_table.sql`
  ```sql
  CREATE TABLE activities (
      id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
      user_id UUID NOT NULL,
      activity_type VARCHAR(50) NOT NULL,
      entity_type VARCHAR(50) NOT NULL,
      entity_id UUID NOT NULL,
      metadata JSONB,
      created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW()
  );
  
  CREATE INDEX idx_activities_user_id_created_at 
      ON activities(user_id, created_at DESC);
  
  COMMENT ON TABLE activities IS 'User activities for recent activity feed';
  COMMENT ON COLUMN activities.activity_type IS 'Type: card_possession_changed, card_added, etc.';
  COMMENT ON COLUMN activities.entity_type IS 'Entity: card, collection, etc.';
  COMMENT ON COLUMN activities.metadata IS 'Additional context (card_name, collection_name, etc.)';
  ```

- [ ] **Appliquer migration** : `psql -h localhost -U collectoria -d collection_management -f migrations/00X_create_activities_table.sql`

- [ ] **Valider** : `psql -h localhost -U collectoria -d collection_management -c "\d activities"`

---

### 2. Domain Layer (15 min)

**Fichier** : `internal/domain/activity.go`

- [ ] **Créer entité Activity**
  ```go
  type Activity struct {
      ID           uuid.UUID
      UserID       uuid.UUID
      ActivityType string
      EntityType   string
      EntityID     uuid.UUID
      Metadata     map[string]interface{}
      CreatedAt    time.Time
  }
  ```

- [ ] **Créer ActivityType constants**
  ```go
  const (
      ActivityTypeCardPossessionChanged = "card_possession_changed"
      ActivityTypeCardAdded             = "card_added"
      // Future: card_removed, wishlist_added, etc.
  )
  ```

- [ ] **Créer EntityType constants**
  ```go
  const (
      EntityTypeCard       = "card"
      EntityTypeCollection = "collection"
  )
  ```

- [ ] **Créer ActivityRepository interface**
  ```go
  type ActivityRepository interface {
      Create(ctx context.Context, activity *Activity) error
      GetRecentByUserID(ctx context.Context, userID uuid.UUID, limit int) ([]*Activity, error)
  }
  ```

---

### 3. Application Layer (20 min)

**Fichier** : `internal/application/activity_service.go`

- [ ] **Créer ActivityService**
  ```go
  type ActivityService struct {
      activityRepo domain.ActivityRepository
  }
  
  func NewActivityService(activityRepo domain.ActivityRepository) *ActivityService {
      return &ActivityService{activityRepo: activityRepo}
  }
  ```

- [ ] **Implémenter RecordCardActivity**
  ```go
  func (s *ActivityService) RecordCardActivity(
      ctx context.Context,
      userID uuid.UUID,
      activityType string,
      cardID uuid.UUID,
      metadata map[string]interface{},
  ) error {
      activity := &domain.Activity{
          ID:           uuid.New(),
          UserID:       userID,
          ActivityType: activityType,
          EntityType:   domain.EntityTypeCard,
          EntityID:     cardID,
          Metadata:     metadata,
          CreatedAt:    time.Now(),
      }
      return s.activityRepo.Create(ctx, activity)
  }
  ```

- [ ] **Implémenter GetRecentActivities**
  ```go
  func (s *ActivityService) GetRecentActivities(
      ctx context.Context,
      userID uuid.UUID,
      limit int,
  ) ([]*domain.Activity, error) {
      if limit <= 0 || limit > 100 {
          limit = 10 // Default limit
      }
      return s.activityRepo.GetRecentByUserID(ctx, userID, limit)
  }
  ```

**Fichier** : `internal/application/activity_service_test.go`

- [ ] **Tests RecordCardActivity** (Happy path, validations)
- [ ] **Tests GetRecentActivities** (Happy path, limit validation)

---

### 4. Infrastructure Layer - Repository (20 min)

**Fichier** : `internal/infrastructure/postgres/activity_repository.go`

- [ ] **Implémenter PostgresActivityRepository**
  ```go
  type PostgresActivityRepository struct {
      db *sql.DB
  }
  
  func NewPostgresActivityRepository(db *sql.DB) *PostgresActivityRepository {
      return &PostgresActivityRepository{db: db}
  }
  ```

- [ ] **Implémenter Create**
  ```sql
  INSERT INTO activities (id, user_id, activity_type, entity_type, entity_id, metadata, created_at)
  VALUES ($1, $2, $3, $4, $5, $6, $7)
  ```

- [ ] **Implémenter GetRecentByUserID**
  ```sql
  SELECT id, user_id, activity_type, entity_type, entity_id, metadata, created_at
  FROM activities
  WHERE user_id = $1
  ORDER BY created_at DESC
  LIMIT $2
  ```

**Fichier** : `internal/infrastructure/postgres/activity_repository_test.go`

- [ ] **Tests d'intégration** (Create, GetRecentByUserID)
- [ ] **Utiliser testcontainers-go** pour PostgreSQL temporaire

---

### 5. Infrastructure Layer - HTTP Handler (20 min)

**Fichier** : `internal/infrastructure/http/handlers/activity_handler.go`

- [ ] **Créer ActivityHandler**
  ```go
  type ActivityHandler struct {
      activityService *application.ActivityService
  }
  ```

- [ ] **Implémenter GetRecentActivities**
  - Endpoint : `GET /api/v1/activities/recent?limit=10`
  - Query param : `limit` (default 10, max 100)
  - Response :
    ```json
    [
      {
        "id": "uuid",
        "user_id": "uuid",
        "activity_type": "card_possession_changed",
        "entity_type": "card",
        "entity_id": "uuid",
        "metadata": {
          "card_name": "Gandalf",
          "collection_name": "MECCG",
          "is_owned": true
        },
        "created_at": "2026-04-21T15:00:00Z"
      }
    ]
    ```

**Fichier** : `internal/infrastructure/http/server.go`

- [ ] **Ajouter route** : `router.GET("/api/v1/activities/recent", activityHandler.GetRecentActivities)`

**Fichier** : `internal/infrastructure/http/handlers/activity_handler_test.go`

- [ ] **Tests handler** (GET recent, query params, errors)

---

### 6. Intégration dans CardService (10 min)

**Fichier** : `internal/application/card_service.go`

- [ ] **Injecter ActivityService** dans CardService
  ```go
  type CardService struct {
      cardRepo     domain.CardRepository
      activitySvc  *ActivityService // NEW
  }
  ```

- [ ] **Modifier ToggleCardPossession**
  ```go
  // After updating card possession
  metadata := map[string]interface{}{
      "card_name":       card.Name,
      "collection_name": collection.Name,
      "is_owned":        isOwned,
  }
  err = s.activitySvc.RecordCardActivity(
      ctx,
      userID,
      domain.ActivityTypeCardPossessionChanged,
      cardID,
      metadata,
  )
  if err != nil {
      // Log error but don't fail the main operation
      log.Warn("Failed to record activity", "error", err)
  }
  ```

**Fichier** : `internal/application/card_service_test.go`

- [ ] **Mettre à jour tests** pour inclure ActivityService mock
- [ ] **Vérifier que RecordCardActivity est appelé**

---

### 7. Wiring (10 min)

**Fichier** : `cmd/api/main.go`

- [ ] **Créer ActivityRepository**
  ```go
  activityRepo := postgres.NewPostgresActivityRepository(db)
  ```

- [ ] **Créer ActivityService**
  ```go
  activitySvc := application.NewActivityService(activityRepo)
  ```

- [ ] **Injecter ActivityService dans CardService**
  ```go
  cardSvc := application.NewCardService(cardRepo, activitySvc)
  ```

- [ ] **Créer ActivityHandler**
  ```go
  activityHandler := handlers.NewActivityHandler(activitySvc)
  ```

- [ ] **Passer ActivityHandler au serveur HTTP**

---

### 8. Tests End-to-End Backend (10 min)

- [ ] **Tester en local** :
  1. Démarrer le backend : `go run cmd/api/main.go`
  2. Toggle une carte : `curl -X PATCH http://localhost:8080/api/v1/cards/{id}/possession`
  3. Vérifier activities créée : `GET http://localhost:8080/api/v1/activities/recent`

- [ ] **Valider** :
  - Activity enregistrée dans la DB
  - Metadata correctement rempli (card_name, collection_name, is_owned)
  - Timestamp correct
  - Endpoint GET retourne l'activité

---

## Tâches Frontend (1h)

### 1. Hook useRecentActivities (15 min)

**Fichier** : `frontend/src/hooks/useRecentActivities.ts`

- [ ] **Créer hook**
  ```typescript
  export function useRecentActivities(limit: number = 10) {
    const [activities, setActivities] = useState<Activity[]>([]);
    const [isLoading, setIsLoading] = useState(true);
    const [error, setError] = useState<Error | null>(null);
    
    useEffect(() => {
      fetch(`${API_BASE_URL}/api/v1/activities/recent?limit=${limit}`)
        .then(res => res.json())
        .then(data => setActivities(data))
        .catch(err => setError(err))
        .finally(() => setIsLoading(false));
    }, [limit]);
    
    return { activities, isLoading, error };
  }
  ```

- [ ] **Créer type Activity**
  ```typescript
  export interface Activity {
    id: string;
    user_id: string;
    activity_type: string;
    entity_type: string;
    entity_id: string;
    metadata: {
      card_name?: string;
      collection_name?: string;
      is_owned?: boolean;
    };
    created_at: string;
  }
  ```

---

### 2. Composant ActivityItem (15 min)

**Fichier** : `frontend/src/components/ActivityItem.tsx`

- [ ] **Créer composant**
  ```tsx
  export function ActivityItem({ activity }: { activity: Activity }) {
    const icon = getActivityIcon(activity.activity_type);
    const message = getActivityMessage(activity);
    const timeAgo = formatTimeAgo(activity.created_at);
    
    return (
      <div className="flex items-center gap-3 p-3 hover:bg-gray-50">
        <div className="text-xl">{icon}</div>
        <div className="flex-1">
          <p className="text-sm text-gray-900">{message}</p>
          <p className="text-xs text-gray-500">{timeAgo}</p>
        </div>
      </div>
    );
  }
  ```

- [ ] **Helper getActivityIcon**
  ```typescript
  function getActivityIcon(type: string): string {
    switch (type) {
      case 'card_possession_changed': return '✅';
      case 'card_added': return '➕';
      default: return '📋';
    }
  }
  ```

- [ ] **Helper getActivityMessage**
  ```typescript
  function getActivityMessage(activity: Activity): string {
    const { card_name, is_owned } = activity.metadata;
    if (activity.activity_type === 'card_possession_changed') {
      return is_owned 
        ? `Carte "${card_name}" ajoutée à votre collection`
        : `Carte "${card_name}" retirée de votre collection`;
    }
    return 'Activité';
  }
  ```

- [ ] **Helper formatTimeAgo**
  ```typescript
  function formatTimeAgo(isoDate: string): string {
    const date = new Date(isoDate);
    const now = new Date();
    const diffMs = now.getTime() - date.getTime();
    const diffMins = Math.floor(diffMs / 60000);
    
    if (diffMins < 1) return "À l'instant";
    if (diffMins < 60) return `Il y a ${diffMins} min`;
    const diffHours = Math.floor(diffMins / 60);
    if (diffHours < 24) return `Il y a ${diffHours}h`;
    const diffDays = Math.floor(diffHours / 24);
    return `Il y a ${diffDays}j`;
  }
  ```

---

### 3. Mettre à jour Widget RecentActivity (15 min)

**Fichier** : `frontend/src/components/widgets/RecentActivity.tsx`

- [ ] **Supprimer les données mockées**

- [ ] **Utiliser le hook useRecentActivities**
  ```tsx
  const { activities, isLoading, error } = useRecentActivities(5);
  ```

- [ ] **Gérer les états**
  - Loading : Skeleton loader
  - Error : Message d'erreur
  - Empty : "Aucune activité récente"
  - Success : Liste des ActivityItem

- [ ] **Implémenter le render**
  ```tsx
  {isLoading && <SkeletonActivityList />}
  {error && <ErrorMessage error={error} />}
  {!isLoading && !error && activities.length === 0 && (
    <EmptyState message="Aucune activité récente" />
  )}
  {!isLoading && !error && activities.length > 0 && (
    <div className="divide-y divide-gray-100">
      {activities.map(activity => (
        <ActivityItem key={activity.id} activity={activity} />
      ))}
    </div>
  )}
  ```

---

### 4. Tests Frontend (15 min)

**Fichier** : `frontend/src/hooks/useRecentActivities.test.ts`

- [ ] **Test fetch success**
- [ ] **Test fetch error**
- [ ] **Test loading state**

**Fichier** : `frontend/src/components/ActivityItem.test.tsx`

- [ ] **Test render card_possession_changed (owned)**
- [ ] **Test render card_possession_changed (not owned)**
- [ ] **Test time ago formatting**

**Fichier** : `frontend/src/components/widgets/RecentActivity.test.tsx`

- [ ] **Test loading state**
- [ ] **Test error state**
- [ ] **Test empty state**
- [ ] **Test success state with activities**

---

## Validation Finale (15 min)

### Tests Automatisés

- [ ] **Backend** : `go test ./...` (tous les tests passent)
- [ ] **Frontend** : `npm run test` (tous les tests passent)

### Tests Manuels

- [ ] **Scénario 1 : Toggle une carte**
  1. Ouvrir `/cards/add`
  2. Toggle une carte (posséder)
  3. Vérifier que l'activité apparaît dans le widget (homepage)
  4. Message : "Carte 'Gandalf' ajoutée à votre collection"
  5. Timestamp : "Il y a X min"

- [ ] **Scénario 2 : Toggle plusieurs cartes**
  1. Toggle 5 cartes différentes
  2. Vérifier que les 5 activités apparaissent
  3. Ordre décroissant (plus récent en haut)

- [ ] **Scénario 3 : Retirer une carte**
  1. Toggle une carte (ne plus posséder)
  2. Vérifier message : "Carte 'X' retirée de votre collection"

### Performance

- [ ] **Latency** : GET /api/v1/activities/recent < 100ms
- [ ] **Database** : Index utilisé (EXPLAIN ANALYZE)
- [ ] **Frontend** : Pas de re-render inutile

### Sécurité

- [ ] **SQL Injection** : Tester avec limit=-1, limit=99999
- [ ] **XSS** : Tester avec card_name contenant du HTML
- [ ] **Rate Limiting** : (À implémenter en Phase 2)

---

## Critères de Succès

- [x] Table `activities` créée et indexée
- [x] Architecture TDD complète (Domain, Application, Infrastructure)
- [x] Tests backend : 100% passants
- [x] Endpoint GET /api/v1/activities/recent fonctionnel
- [x] Activités enregistrées lors du toggle possession
- [x] Widget frontend affiche les vraies données
- [x] Tests frontend : 100% passants
- [x] Design Ethos V1 respecté
- [x] Performance : latency < 100ms

---

## Liens Utiles

- **ADR** : `decisions/2026-04-21_activities-architecture-choice.md`
- **Migration Future** : `future-tasks/migration-kafka-activities.md`
- **Backend README** : `backend/collection-management/README.md`

---

## Notes

- Cette implémentation est la **Phase 1 (MVP)**
- Architecture simple et rapide à implémenter
- Migration vers Kafka prévue en **Phase 2** (voir `future-tasks/`)
- Priorité : Valider le concept et le format des activités

---

**Créé par** : Agent Suivi de Projet  
**Date** : 2026-04-21  
**Version** : 1.0
