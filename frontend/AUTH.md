# Authentification Frontend - Collectoria

## Vue d'ensemble

Ce document décrit l'implémentation de l'authentification JWT dans le frontend de Collectoria.

## Architecture

### Composants principaux

1. **Utilitaires Auth** (`src/lib/auth.ts`)
   - Gestion du token JWT dans localStorage
   - Vérification d'expiration automatique
   - Vérification d'authentification

2. **API Client** (`src/lib/api/client.ts`)
   - Client HTTP avec injection automatique du token JWT
   - Gestion des erreurs 401 (redirection vers login)
   - Methods: GET, POST, PATCH, DELETE

3. **API Auth** (`src/lib/api/auth.ts`)
   - Endpoint de login
   - Types TypeScript pour les credentials et réponses

4. **Hook useAuth** (`src/hooks/useAuth.ts`)
   - Hook React pour l'authentification
   - Utilise React Query pour la gestion d'état
   - Gère les redirections et notifications

5. **Page Login** (`src/app/login/page.tsx`)
   - Formulaire de connexion avec design Ethos V1
   - Validation des champs (email, password)
   - États loading/error
   - Redirection automatique si déjà connecté

6. **ProtectedRoute** (`src/components/auth/ProtectedRoute.tsx`)
   - Composant pour protéger les routes nécessitant une authentification
   - Redirection automatique vers /login si non authentifié

7. **TopNav** (`src/components/layout/TopNav.tsx`)
   - Bouton "Se connecter" si non authentifié
   - Bouton "Se déconnecter" si authentifié

## Flux d'authentification

### Login

1. L'utilisateur visite `/login`
2. Remplit email et password
3. Soumission du formulaire
4. Appel à `POST /api/v1/auth/login`
5. Si succès:
   - Token JWT stocké dans localStorage
   - Redirection vers `/`
   - Toast de succès
6. Si échec:
   - Message d'erreur affiché
   - Formulaire reste accessible

### Requêtes API authentifiées

1. Toutes les requêtes API passent par `apiClient`
2. Le client injecte automatiquement le header `Authorization: Bearer <token>`
3. Si réponse 401:
   - Token supprimé du localStorage
   - Redirection automatique vers `/login`

### Logout

1. Clic sur le bouton "Se déconnecter"
2. Suppression du token du localStorage
3. Redirection vers `/login`
4. Toast de succès

## Utilisation

### Protéger une route

#### Option 1: Composant ProtectedRoute

```tsx
import ProtectedRoute from '@/components/auth/ProtectedRoute'

export default function MyProtectedPage() {
  return (
    <ProtectedRoute>
      <div>Contenu protégé</div>
    </ProtectedRoute>
  )
}
```

#### Option 2: Hook useAuth

```tsx
'use client'

import { useAuth } from '@/hooks/useAuth'
import { useEffect } from 'react'
import { useRouter } from 'next/navigation'

export default function MyPage() {
  const { isAuthenticated } = useAuth()
  const router = useRouter()

  useEffect(() => {
    if (!isAuthenticated()) {
      router.push('/login')
    }
  }, [isAuthenticated, router])

  if (!isAuthenticated()) return null

  return <div>Contenu protégé</div>
}
```

### Faire une requête API authentifiée

```tsx
import { apiClient } from '@/lib/api/client'

// GET
const response = await apiClient.get('/api/v1/collections')
const data = await response.json()

// POST
const response = await apiClient.post('/api/v1/cards', {
  name: 'Pikachu',
  series: 'Base Set',
})

// PATCH
const response = await apiClient.patch('/api/v1/cards/123', {
  is_owned: true,
})

// DELETE
const response = await apiClient.delete('/api/v1/cards/123')
```

### Utiliser le hook useAuth

```tsx
'use client'

import { useAuth } from '@/hooks/useAuth'

export default function MyComponent() {
  const { login, logout, isAuthenticated, isLoading } = useAuth()

  const handleLogin = async () => {
    try {
      await login('user@example.com', 'password123')
      // Redirection automatique vers /
    } catch (error) {
      // Erreur affichée via toast automatiquement
    }
  }

  const handleLogout = () => {
    logout()
    // Redirection automatique vers /login
  }

  return (
    <div>
      {isAuthenticated() ? (
        <button onClick={handleLogout}>Se déconnecter</button>
      ) : (
        <button onClick={handleLogin} disabled={isLoading}>
          {isLoading ? 'Connexion...' : 'Se connecter'}
        </button>
      )}
    </div>
  )
}
```

## Stockage du token

Le token JWT est stocké dans localStorage avec les clés:
- `collectoria_auth_token`: Le token JWT
- `collectoria_auth_expires`: Date d'expiration ISO8601

Le token est automatiquement supprimé si:
- L'utilisateur se déconnecte
- Le token a expiré (vérification à chaque lecture)
- Une requête API retourne 401

## Sécurité

- **HTTPS obligatoire en production**: Le token ne doit jamais être transmis en HTTP
- **Pas de stockage du mot de passe**: Seul le token est stocké
- **Expiration automatique**: Le token expiré est automatiquement supprimé
- **Redirection 401**: Si le backend invalide le token, l'utilisateur est redirigé vers /login

## Tests

### Tests unitaires

- **Auth utilities** (`src/lib/__tests__/auth.test.ts`): 13 tests
  - setAuthToken / getAuthToken / removeAuthToken
  - isAuthenticated
  - Vérification d'expiration
  - getTokenExpiration

- **Login page** (`src/app/login/__tests__/page.test.tsx`): 15 tests
  - Rendering du formulaire
  - Validation email/password
  - Soumission du formulaire
  - États loading/error
  - Redirection si authentifié

### Lancer les tests

```bash
npm test                 # Tous les tests
npm run test:ui          # Interface graphique
npm run test:coverage    # Coverage
```

## Configuration

### Variables d'environnement

```env
NEXT_PUBLIC_API_URL=http://localhost:8080
```

Cette variable définit l'URL de base du backend API.

## Migration des appels API existants

Tous les appels `fetch()` dans `src/lib/api/collections.ts` ont été migrés pour utiliser `apiClient`:

- `fetchCollectionSummary()`
- `fetchRecentActivities()`
- `fetchGrowthStats()`
- `fetchCards()`
- `updateCardPossession()`
- `fetchCollections()`

Ces fonctions injectent maintenant automatiquement le token JWT si l'utilisateur est authentifié.

## Roadmap

- [ ] Page d'inscription (`/register`)
- [ ] Mot de passe oublié (`/forgot-password`)
- [ ] Remember me (persistance du token plus longue)
- [ ] Refresh token automatique
- [ ] Middleware Next.js pour la protection des routes
- [ ] Affichage de l'email utilisateur dans la TopNav
- [ ] Avatar utilisateur

## Support

Pour toute question sur l'authentification, consulter:
- Backend JWT: `/home/arnaud.dars/git/Collectoria/backend/collection-management/docs/jwt-auth.md`
- Specs API: OpenAPI spec dans le backend
