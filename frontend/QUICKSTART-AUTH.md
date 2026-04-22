# Guide de démarrage rapide - Authentification

## Pour tester l'authentification localement

### 1. Démarrer le backend

```bash
cd /home/arnaud.dars/git/Collectoria/backend/collection-management
make run
```

Le backend sera disponible sur `http://localhost:8080`

### 2. Démarrer le frontend

```bash
cd /home/arnaud.dars/git/Collectoria/frontend
npm run dev
```

Le frontend sera disponible sur `http://localhost:3000`

### 3. Accéder à la page de login

Ouvrir le navigateur et aller sur: `http://localhost:3000/login`

### 4. Se connecter

**Credentials de test** (créés dans le backend):
- Email: `test@example.com`
- Password: `password123`

**Remarque**: Si ces credentials n'existent pas encore dans la base de données, il faudra:
1. Créer un endpoint de register dans le backend (future feature)
2. Ou insérer manuellement un utilisateur dans PostgreSQL avec un hash bcrypt

### 5. Vérifier l'authentification

Après login:
- Vous devriez être redirigé vers `/` (page d'accueil)
- Un toast vert "Connexion réussie" s'affiche
- Le bouton "Se connecter" dans la TopNav devient "Se déconnecter"
- Le token JWT est stocké dans localStorage (F12 > Application > Local Storage)

### 6. Tester une requête API authentifiée

Aller sur la page `/cards` ou `/` et observer:
- Les requêtes API incluent maintenant le header `Authorization: Bearer <token>`
- Les données sont chargées normalement

### 7. Se déconnecter

Cliquer sur "Se déconnecter" dans la TopNav:
- Vous êtes redirigé vers `/login`
- Un toast "Déconnexion réussie" s'affiche
- Le token est supprimé du localStorage

## Tester l'expiration du token

### Option 1: Modifier manuellement l'expiration dans localStorage

1. Se connecter
2. Ouvrir les DevTools (F12)
3. Aller dans Application > Local Storage
4. Modifier `collectoria_auth_expires` avec une date passée
5. Rafraîchir la page
6. Vous devriez être redirigé vers `/login`

### Option 2: Attendre l'expiration naturelle

Le token expire après la durée configurée dans le backend (par défaut 24h).

## Tester la protection des routes

1. Se déconnecter (ou supprimer le token du localStorage)
2. Essayer d'accéder directement à `/` ou `/cards`
3. Vous devriez être redirigé vers `/login`

## Structure des fichiers créés

```
frontend/
├── src/
│   ├── lib/
│   │   ├── auth.ts                    # Utilitaires auth (token storage)
│   │   ├── api/
│   │   │   ├── client.ts              # API client avec JWT
│   │   │   ├── auth.ts                # Endpoints auth
│   │   │   └── collections.ts         # Migré vers apiClient
│   │   └── __tests__/
│   │       └── auth.test.ts           # Tests auth (13 tests)
│   ├── hooks/
│   │   └── useAuth.ts                 # Hook React auth
│   ├── components/
│   │   ├── auth/
│   │   │   └── ProtectedRoute.tsx     # HOC pour routes protégées
│   │   └── layout/
│   │       └── TopNav.tsx             # Updated avec logout
│   └── app/
│       └── login/
│           ├── page.tsx               # Page de login
│           └── __tests__/
│               └── page.test.tsx      # Tests login (15 tests)
├── AUTH.md                             # Documentation complète
└── QUICKSTART-AUTH.md                  # Ce fichier
```

## Prochaines étapes

1. **Créer un utilisateur de test** dans le backend
2. **Tester le flux complet** de login/logout
3. **Vérifier les requêtes API** avec le token JWT
4. **Ajouter la protection** aux routes existantes si nécessaire
5. **Implémenter la page de register** (future feature)

## Troubleshooting

### Le login ne fonctionne pas

- Vérifier que le backend tourne sur `http://localhost:8080`
- Vérifier que l'endpoint `/api/v1/auth/login` existe
- Vérifier les credentials dans la base de données
- Vérifier la console du navigateur pour les erreurs

### Token non injecté dans les requêtes

- Vérifier que toutes les requêtes API utilisent `apiClient` au lieu de `fetch` directement
- Vérifier que le token existe dans localStorage
- Vérifier que le token n'est pas expiré

### Redirection infinie

- Vérifier que `/login` n'est pas protégé par ProtectedRoute
- Vérifier que `isAuthenticated()` retourne bien false si pas de token

## Tests

Pour lancer les tests d'authentification:

```bash
npm test -- auth.test.ts         # Tests des utilitaires
npm test -- page.test.tsx        # Tests de la page de login
npm test                          # Tous les tests (109 tests)
```

Tous les tests devraient passer (109/109).
