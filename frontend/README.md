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
- **Page de test** : `/test` - Page interactive pour tester le déploiement

### Structure

```
frontend/
├── src/
│   ├── app/
│   │   ├── layout.tsx        # Layout principal
│   │   ├── page.tsx          # Page d'accueil
│   │   ├── globals.css       # Styles globaux
│   │   └── test/
│   │       └── page.tsx      # Page de test interactive
│   └── components/           # Composants réutilisables (à venir)
├── public/                   # Assets statiques
├── package.json
├── tsconfig.json
└── next.config.js
```

## 🧪 Page de Test

La page `/test` permet de :
- Tester le bon fonctionnement de Next.js
- Valider le déploiement local
- Servir de destination pour les liens non implémentés
- Éviter les liens morts pendant le développement

**Fonctionnalités** :
- Formulaire interactif
- Affichage dynamique
- Historique des saisies
- State management React
- CSS-in-JS

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
