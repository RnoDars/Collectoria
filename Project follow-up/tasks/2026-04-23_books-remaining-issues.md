# Collection Books - Problèmes Restants

**Date** : 2026-04-23  
**Priorité** : MOYENNE  
**Effort estimé** : 1-2h  
**Status** : TODO

---

## Contexte

La collection Books "Royaumes oubliés" est fonctionnelle et déployée :
- ✅ 94 livres en base de données
- ✅ API REST complète (GET /books + PATCH possession)
- ✅ Page frontend /books avec filtres
- ✅ Navigation (homepage + navbar)
- ✅ Toggle possession fonctionne

Cependant, 2 problèmes restants ont été identifiés en fin de session.

---

## Problème 1 : Activités Books sans titre/description

### Symptôme

Dans la section "Activité récente" de la homepage, les activités de books s'affichent **sans nom** :
- Un événement apparaît
- Mais le titre et la description sont vides
- L'utilisateur ne sait pas quelle action a été effectuée

### Comportement attendu

```
Activité récente:
├─ Ajout d'un roman              ← TITRE
   Ajout du roman: Valombre      ← DESCRIPTION
   Il y a 2 minutes
```

### Comportement actuel

```
Activité récente:
├─ (vide)                         ← PAS DE TITRE
   (vide)                         ← PAS DE DESCRIPTION
   Il y a 2 minutes
```

### Investigation effectuée

**Backend** :
- Fix appliqué dans `activity_service.go` (commit cb98328)
- `RecordBookActivity` définit maintenant `Title` et `Description`
- Code correct selon analyse

**API Response** :
```bash
curl http://localhost:8080/api/v1/activities/recent
```
Retourne toujours :
```json
{
  "type": "book_added",
  "title": "",           // ❌ Toujours vide
  "description": "",     // ❌ Toujours vide
  "metadata": {
    "description": "Ajout du roman: Valombre"
  }
}
```

### Hypothèses

1. **Le backend n'a pas été correctement redémarré** avec le nouveau code
2. **Le repository ne persiste pas les champs Title/Description** dans la BDD
   - Vérifier schéma table `activities`
   - Vérifier INSERT dans `postgres_activity_repository.go`
3. **Les anciennes activités** (avant le fix) restent en cache
   - Besoin de créer de nouvelles activités pour voir le fix

### Solution à implémenter

#### Étape 1 : Vérifier le schéma BDD

```sql
-- Se connecter à la base
docker exec -i collectoria-collection-db psql -U collectoria -d collection_management

-- Vérifier la structure de la table
\d activities

-- Vérifier si les colonnes title et description existent
SELECT column_name, data_type 
FROM information_schema.columns 
WHERE table_name = 'activities';
```

**Si les colonnes n'existent pas** → Créer migration SQL :
```sql
ALTER TABLE activities ADD COLUMN title VARCHAR(255);
ALTER TABLE activities ADD COLUMN description TEXT;
```

#### Étape 2 : Vérifier le repository

Fichier : `backend/collection-management/internal/infrastructure/postgres/activity_repository.go`

Vérifier que la méthode `Create()` ou `Insert()` inclut bien `title` et `description` :

```go
// Doit ressembler à :
query := `
    INSERT INTO activities (id, user_id, type, title, description, timestamp, metadata)
    VALUES ($1, $2, $3, $4, $5, $6, $7)
`
_, err := r.db.ExecContext(ctx, query, 
    activity.ID, 
    userID, 
    activity.Type,
    activity.Title,        // ← Vérifier présence
    activity.Description,  // ← Vérifier présence
    activity.Timestamp,
    metadataJSON,
)
```

#### Étape 3 : Tester

1. Redémarrer backend proprement
2. Toggler un livre
3. Vérifier API `/api/v1/activities/recent`
4. Vérifier homepage "Activité récente"

### Fichiers concernés

- `backend/collection-management/internal/application/activity_service.go` - ✅ Fixed
- `backend/collection-management/internal/infrastructure/postgres/activity_repository.go` - À vérifier
- `backend/collection-management/migrations/00X_create_activities.sql` - À vérifier schéma

---

## Problème 2 : Pas de modale de confirmation au toggle

### Symptôme

Quand l'utilisateur clique sur le toggle de possession d'un livre :
- Le toggle bascule immédiatement
- Aucune confirmation n'est demandée
- L'action est irréversible sans feedback

### Comportement attendu

```
User clique toggle → Modale s'ouvre
┌──────────────────────────────────┐
│ Confirmer l'action ?             │
│                                  │
│ Voulez-vous ajouter "Valombre"   │
│ à votre collection ?             │
│                                  │
│  [Annuler]     [Confirmer]       │
└──────────────────────────────────┘
User clique Confirmer → Toggle + Toast notification
```

### Comportement actuel

```
User clique toggle → Toggle immédiat + Toast
```

### Référence

Le plan initial mentionnait une modale de confirmation :

> **Fichier** : `frontend/src/app/books/page.tsx`
> - Toggle possession **avec modal confirmation**

Mais non implémentée dans le code actuel.

### Solution à implémenter

#### Option 1 : Modale de confirmation (recommandé pour UX)

**Fichier** : `frontend/src/components/books/BookConfirmModal.tsx`

```typescript
interface BookConfirmModalProps {
  book: Book | null
  isOpen: boolean
  onClose: () => void
  onConfirm: () => void
  action: 'add' | 'remove'
}

export default function BookConfirmModal({ 
  book, 
  isOpen, 
  onClose, 
  onConfirm,
  action 
}: BookConfirmModalProps) {
  if (!book) return null

  const actionText = action === 'add' 
    ? `Voulez-vous ajouter "${book.title}" à votre collection ?`
    : `Voulez-vous retirer "${book.title}" de votre collection ?`

  return (
    <Dialog open={isOpen} onOpenChange={onClose}>
      <DialogContent>
        <DialogHeader>
          <DialogTitle>Confirmer l'action</DialogTitle>
          <DialogDescription>{actionText}</DialogDescription>
        </DialogHeader>
        <DialogFooter>
          <Button variant="outline" onClick={onClose}>
            Annuler
          </Button>
          <Button onClick={onConfirm}>
            Confirmer
          </Button>
        </DialogFooter>
      </DialogContent>
    </Dialog>
  )
}
```

**Modifications** dans `BookCard.tsx` :

```typescript
// État local pour la modale
const [isModalOpen, setIsModalOpen] = useState(false)
const [pendingAction, setPendingAction] = useState<'add' | 'remove'>('add')

// Au lieu d'appeler onToggle directement
<button
  onClick={() => {
    setPendingAction(book.isOwned ? 'remove' : 'add')
    setIsModalOpen(true)
  }}
  // ...
>

// Ajouter la modale
<BookConfirmModal
  book={book}
  isOpen={isModalOpen}
  onClose={() => setIsModalOpen(false)}
  onConfirm={() => {
    onToggle(book.id, !book.isOwned)
    setIsModalOpen(false)
  }}
  action={pendingAction}
/>
```

#### Option 2 : Confirmation simple (plus rapide)

Utiliser `window.confirm()` (moins joli mais fonctionnel) :

```typescript
<button
  onClick={() => {
    const action = book.isOwned ? 'retirer' : 'ajouter'
    if (window.confirm(`Voulez-vous ${action} "${book.title}" ?`)) {
      onToggle(book.id, !book.isOwned)
    }
  }}
  // ...
>
```

#### Option 3 : Pas de confirmation (mode rapide)

Si l'utilisateur préfère l'action directe, garder comportement actuel mais :
- Améliorer le feedback visuel (animation du toggle)
- Toast plus visible
- Possibilité d'annuler via un bouton "Annuler" dans le toast

### Fichiers concernés

- `frontend/src/components/books/BookCard.tsx` - Toggle handler
- `frontend/src/components/books/BookConfirmModal.tsx` - Nouveau composant (à créer)
- `frontend/src/app/books/page.tsx` - Gestion de l'état de la modale

---

## Priorité et Planning

### Priorité

- **Problème 1** (Activités) : **HAUTE** - Fonctionnalité visible sur homepage
- **Problème 2** (Modale) : **MOYENNE** - UX nice-to-have

### Effort estimé

| Tâche | Temps estimé |
|-------|--------------|
| Debug + fix activités | 30-45 min |
| Implémenter modale confirmation | 30 min |
| Tests | 15 min |
| **Total** | **1h15 - 1h30** |

### Ordre d'exécution recommandé

1. **Problème 1** (activités) - Plus critique
2. **Problème 2** (modale) - Amélioration UX

---

## Tests de validation

### Problème 1 - Activités

**Critères de succès** :
- [ ] API `/api/v1/activities/recent` retourne `title` et `description` non vides
- [ ] Homepage "Activité récente" affiche le nom de l'action
- [ ] Exemple : "Ajout d'un roman - Ajout du roman: Valombre"

**Commandes de test** :
```bash
# 1. Toggler un livre via frontend
# 2. Vérifier API
curl -H "Authorization: Bearer $JWT" \
  http://localhost:8080/api/v1/activities/recent | jq '.activities[0]'

# 3. Vérifier homepage affiche le titre
```

### Problème 2 - Modale

**Critères de succès** :
- [ ] Clic sur toggle → Modale s'ouvre
- [ ] Modale affiche le titre du livre
- [ ] Bouton "Annuler" → Ferme modale sans action
- [ ] Bouton "Confirmer" → Toggle + Toast + Ferme modale
- [ ] UI responsive (mobile + desktop)

---

## Notes additionnelles

### Pourquoi le fix des activités ne fonctionne pas ?

**Hypothèse principale** : Le repository ne persiste pas `title` et `description` en BDD.

Le fix dans `activity_service.go` définit bien les champs dans l'objet `Activity`, mais si le repository (`postgres_activity_repository.go`) ne les insère pas dans la BDD, ils sont perdus.

**Action critique** : Vérifier la méthode `Create()` ou `RecordActivity()` dans le repository PostgreSQL.

### Alternative pour modale

Si le temps manque, utiliser Option 2 (`window.confirm()`) comme solution temporaire, puis migrer vers Option 1 (composant shadcn/ui Dialog) plus tard.

---

## Références

- Plan initial : `Project follow-up/tasks/books-collection-implementation.md`
- Commits concernés :
  - cb98328 - Fix activity title/description (incomplete)
  - cbe77a6 - Frontend Books page
- Documentation activités : `backend/collection-management/internal/domain/activity.go`

---

**Créé par** : Alfred  
**Date** : 2026-04-23  
**Session** : Implémentation collection Books  
**Status** : Documenté, prêt pour prochaine session
