# Bonnes Pratiques de Développement Frontend

## Page de Test `/test`

### Utilisation

La page `/test` est la page de test unique pour le développement. Elle sert à :
- Tester l'intégration avec le backend
- Tester les composants UI de manière interactive
- Débugger les problèmes de connexion
- Valider les nouvelles fonctionnalités

### Structure de la Page

La page `/test` est organisée en 4 sections :

1. **Connexion Backend** : Indicateur de status de l'API, visualisation de l'état de connexion
2. **Tests d'Intégration Backend** : CollectionsGrid avec données réelles, test des endpoints API
3. **Tests UI Interactifs** : Formulaire de test, gestion d'état React, interactions utilisateur
4. **Debug Info** : Données techniques, variables d'environnement, informations de débogage

### Accès

La page `/test` n'apparaît PAS dans la navigation principale (TopNav) pour garder l'interface propre.

**Pour y accéder** :
- Taper directement l'URL : `http://localhost:3000/test`
- Ou ajouter un lien temporaire dans le code pendant le développement

### Bonne Pratique : Liens vers Pages Non Créées

**Problème** : Quand on crée un lien dans le frontend mais que la page de destination n'existe pas encore, le lien devient cassé et génère une erreur 404.

**Solution** : Utiliser `/test` comme cible par défaut.

**Exemple** :

```tsx
// ❌ Mauvais : Lien vers page non créée
<Link href="/stats">Statistiques</Link>
// → Génère une erreur 404

// ✅ Bon : Lien temporaire vers /test
<Link href="/test">Statistiques (en développement)</Link>
// → Redirige vers la page de test
// → Ajouter un TODO ou commentaire pour créer la vraie page plus tard

// ✅ Encore mieux : Avec indication visuelle
<Link href="/test" style={{ opacity: 0.6 }}>
  Statistiques (en cours)
</Link>
```

**Quand créer la vraie page** :
1. Créer `/app/stats/page.tsx`
2. Mettre à jour le lien : `href="/test"` → `href="/stats"`
3. Retirer l'indication "en développement"

### Avantages

- Pas de liens cassés (404)
- Navigation testable même avec pages incomplètes
- Indicateur visuel pour les pages en cours de développement
- Expérience utilisateur fluide pendant le développement

## TopNav - Navigation Principale

### Principe

La TopNav doit rester propre et ne contenir que les liens vers les fonctionnalités principales de l'application.

**Liens permanents** :
- Accueil
- Cartes
- Livres
- (Autres fonctionnalités métier au fur et à mesure)

**Liens à éviter** :
- Pages de test
- Pages de debug
- Pages de développement
- Pages non finalisées

### Ajout d'un Nouveau Lien

Avant d'ajouter un lien dans la TopNav, vérifier :
1. Est-ce une fonctionnalité métier principale ?
2. La page est-elle complète et prête pour l'utilisateur ?
3. Est-ce que l'utilisateur final aura besoin d'y accéder régulièrement ?

Si non à l'une de ces questions → Ne pas ajouter le lien dans la TopNav.

## Workflow de Développement

### Étape 1 : Développement Initial

```tsx
// Ajouter un lien temporaire dans TopNav ou autre composant
<Link href="/test">Nouvelle Feature (en dev)</Link>
```

### Étape 2 : Création de la Page

```bash
# Créer la page réelle
mkdir -p frontend/src/app/nouvelle-feature
touch frontend/src/app/nouvelle-feature/page.tsx
```

### Étape 3 : Mise à Jour du Lien

```tsx
// Mettre à jour le lien vers la vraie page
<Link href="/nouvelle-feature">Nouvelle Feature</Link>
```

### Étape 4 : Ajout dans TopNav (si nécessaire)

```tsx
// Seulement si c'est une fonctionnalité principale
const NAV_LINKS = [
  { href: '/', label: 'Accueil' },
  { href: '/cards', label: 'Cartes' },
  { href: '/books', label: 'Livres' },
  { href: '/nouvelle-feature', label: 'Nouvelle Feature' }, // ✅
]
```

## Tests Locaux

### Backend + Frontend

Pour tester l'intégration complète :

```bash
# Terminal 1 : Backend
cd backend/collection-management
docker compose up -d
export DB_HOST=localhost DB_PORT=5432 DB_USER=collection_user DB_PASSWORD=collection_pass DB_NAME=collection_db
go run cmd/api/main.go

# Terminal 2 : Frontend
cd frontend
npm run dev
```

Puis accéder à : `http://localhost:3000/test`

### Health Checks

```bash
# Backend
curl http://localhost:8080/health

# Frontend
curl http://localhost:3000
```

## Cache Next.js

### Problème

Le cache Next.js (`.next/`) peut se corrompre après des modifications importantes, causant des erreurs "Internal Server Error".

### Solution

Nettoyer le cache et redémarrer :

```bash
cd frontend
rm -rf .next
npm run dev
```

### Quand Nettoyer

- Après suppression de composants
- Après modifications de structure de répertoires
- Après refactoring important
- Si erreurs "ENOENT" ou "Module not found" sur des fichiers existants
- Si HTTP 500 inexpliqués

## Structure de Projet

```
frontend/
├── src/
│   ├── app/                    # Pages Next.js
│   │   ├── page.tsx           # Accueil
│   │   ├── cards/             # Page Cartes
│   │   ├── books/             # Page Livres
│   │   └── test/              # Page de test (non dans TopNav)
│   ├── components/            # Composants réutilisables
│   │   ├── layout/            # TopNav, Footer, etc.
│   │   └── homepage/          # Composants spécifiques
│   ├── hooks/                 # Custom React hooks
│   ├── lib/                   # Utilitaires, helpers
│   └── types/                 # Types TypeScript
├── public/                    # Assets statiques
└── DEVELOPMENT_PRACTICES.md   # Ce fichier
```

## Conventions de Code

### Composants

```tsx
// Toujours typer les props
interface MyComponentProps {
  title: string
  count: number
}

export default function MyComponent({ title, count }: MyComponentProps) {
  return <div>{title}: {count}</div>
}
```

### Hooks Personnalisés

```tsx
// Préfixer avec "use"
export function useMyData() {
  const [data, setData] = useState(null)
  // ...
  return { data, isLoading, error }
}
```

### Styles

- Utiliser les CSS-in-JS inline pour la cohérence avec le design system
- Utiliser les variables CSS Material Design 3 (`var(--surface-container)`, etc.)
- Utiliser les polices du système : Manrope (titres), Inter (corps de texte)

### Nomenclature

- **Composants** : PascalCase (`CollectionsGrid.tsx`)
- **Hooks** : camelCase avec préfixe "use" (`useCollections.ts`)
- **Types** : PascalCase (`Collection`, `Book`)
- **Fichiers utilitaires** : camelCase (`authUtils.ts`)

## Résumé des Bonnes Pratiques

1. Toujours utiliser `/test` pour les liens temporaires
2. Ne pas ajouter de pages de dev/test dans la TopNav
3. Nettoyer le cache `.next` après modifications importantes
4. Typer toutes les props et fonctions TypeScript
5. Tester l'intégration backend/frontend régulièrement via `/test`
6. Garder la TopNav propre et focalisée sur les fonctionnalités métier
7. Utiliser les conventions de nommage et structure du projet
