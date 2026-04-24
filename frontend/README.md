# Collectoria Frontend

Application Next.js pour Collectoria - Gestionnaire de collections de jeux et loisirs.

## 🚀 Démarrage Rapide

### Installation

```bash
# Installer les dépendances
npm install
```

### Développement

```bash
# Lancer le serveur de développement
npm run dev
```

Ouvrir [http://localhost:3000](http://localhost:3000) dans votre navigateur.

### Pages Disponibles

- **Page d'accueil** : `/` - Page d'accueil avec liens vers les fonctionnalités
- **Page Cartes** : `/cards` - Gestion des cartes à collectionner
- **Page Livres** : `/books` - Gestion des livres et BD
- **Page de test** : `/test` - Page unifiée pour tests backend et UI (développement uniquement)

### Structure

```
frontend/
├── src/
│   ├── app/
│   │   ├── layout.tsx        # Layout principal
│   │   ├── page.tsx          # Page d'accueil
│   │   ├── globals.css       # Styles globaux
│   │   ├── cards/            # Pages cartes
│   │   ├── books/            # Pages livres
│   │   └── test/
│   │       └── page.tsx      # Page de test (dev)
│   ├── components/           # Composants réutilisables
│   │   ├── layout/           # TopNav, Footer
│   │   └── homepage/         # Composants page accueil
│   ├── hooks/                # Custom React hooks
│   ├── lib/                  # Utilitaires, helpers
│   └── types/                # Types TypeScript
├── public/                   # Assets statiques
├── DEVELOPMENT_PRACTICES.md  # Bonnes pratiques
├── package.json
├── tsconfig.json
└── next.config.js
```

## 🧪 Page de Test

La page `/test` est la page de test unifiée pour le développement. Elle combine :
- **Tests d'intégration backend** : Connexion API, CollectionsGrid avec données réelles
- **Tests UI interactifs** : Formulaire, états React, interactions utilisateur
- **Debug info** : Variables d'environnement, données techniques

**Accès** : `http://localhost:3000/test` (pas de lien dans la navigation)

**Utilisation** :
- Tester l'intégration avec le backend
- Valider les composants UI
- Débugger les problèmes de connexion
- Servir de destination pour les liens non implémentés

Voir `DEVELOPMENT_PRACTICES.md` pour plus de détails sur l'utilisation de la page de test et les bonnes pratiques.

## 📦 Technologies

- **Next.js 14** : Framework React avec App Router
- **React 18** : Bibliothèque UI
- **TypeScript** : Typage statique
- **CSS-in-JS** : Styles inline avec TypeScript

## 🔜 Prochaines Étapes

- [ ] Intégration Tailwind CSS
- [ ] Composants UI réutilisables
- [ ] Connexion API backend
- [ ] Pages de gestion des collections
- [ ] Dashboard avec statistiques
- [ ] Authentification (plus tard)

## 🐛 Troubleshooting

### Port déjà utilisé

Si le port 3000 est déjà utilisé :

```bash
# Trouver le processus
lsof -i :3000

# Le tuer
kill -9 <PID>

# Ou utiliser un autre port
PORT=3001 npm run dev
```

### Erreur de dépendances

```bash
# Nettoyer et réinstaller
rm -rf node_modules package-lock.json
npm install
```

## 📚 Documentation

- [Next.js Documentation](https://nextjs.org/docs)
- [React Documentation](https://react.dev)
- [TypeScript Documentation](https://www.typescriptlang.org/docs)
