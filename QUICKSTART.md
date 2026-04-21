# 🚀 Quick Start - Collectoria Frontend

Guide rapide pour tester le frontend Collectoria en local avec toutes les fonctionnalités disponibles.

## ⚡ Installation Ultra-Rapide

```bash
# 1. Aller dans le répertoire frontend
cd ~/git/Collectoria/frontend

# 2. Installer les dépendances (première fois seulement, ~30 secondes)
npm install

# 3. Lancer le serveur de développement
npm run dev
```

✅ **C'est tout !** Ouvrir http://localhost:3000 dans votre navigateur.

---

## 🎯 Ce Que Vous Allez Voir

### Page d'Accueil - Homepage Complète (http://localhost:3000) ⭐ NOUVEAU
- **HeroCard** : Carte principale avec progression globale de la collection
  - Nombre de cartes possédées / total
  - Barre de progression avec pourcentage
  - Badge de complétion dynamique
- **CollectionsGrid** : Grille des collections (MECCG, Doomtrooper)
  - 2 colonnes sur desktop, 1 sur mobile
  - Hero images avec gradients (vert MECCG, rouge/noir Doomtrooper)
  - Stats de complétion par collection
- **Dashboard Widgets** :
  - **Recent Activity** : 5 activités récentes (ajout carte, milestone, import)
  - **Growth Insight** : Graphique d'évolution sur 6 mois

### Page Gestion des Cartes (http://localhost:3000/cards/add) ⭐ NOUVEAU
- **Liste complète des cartes** avec scroll infini (12 cartes par batch)
- **Filtres avancés** :
  - **Type** : 33 types de cartes (Héros, Personnage, Sorcier, Péril, Créature, Équipement, etc.)
  - **Rareté** : 12 raretés (C1-C3, U1-U3, R1-R3, F1-F2, P)
  - **Recherche** : Recherche par nom de carte
- **Toggle de possession** : Switch interactif pour marquer les cartes comme possédées/non possédées
- **Toast notifications** : Notifications de succès/erreur lors du toggle
- **Design Ethos V1** : Tonal Layering, Dual-Type System (Manrope + Inter)

### Page de Test Backend (http://localhost:3000/test-backend)
- **HeroCard** avec données réelles depuis le backend
- **CollectionsGrid** avec données réelles depuis le backend
- Affichage de 1,679 cartes MECCG réelles importées

### Page de Test Interactive (http://localhost:3000/test)
- **Formulaire interactif** :
  - Champ de texte
  - Bouton "Afficher le texte"
- **Affichage dynamique** du texte saisi
- **Historique** de toutes les saisies
- **Bouton "Effacer"** pour réinitialiser
- **Indicateurs de test réussi** ✅
- **Bouton retour** vers l'accueil

---

## 🧪 Tests à Faire

### Tests Homepage (http://localhost:3000)
1. ✅ **HeroCard** : Affichage de la progression globale (24/40 cartes, 60%)
2. ✅ **CollectionsGrid** : 2 collections affichées (MECCG, Doomtrooper)
3. ✅ **Recent Activity** : 5 activités affichées
4. ✅ **Growth Insight** : Graphique 6 mois affiché
5. ✅ **Responsive** : Tester sur mobile et desktop

### Tests Gestion des Cartes (http://localhost:3000/cards/add) ⭐ NOUVEAU
1. ✅ **Liste des cartes** : Cartes affichées (12 par défaut)
2. ✅ **Scroll infini** : Scroller vers le bas pour charger plus de cartes
3. ✅ **Filtre Type** : Sélectionner un type (ex: "Héros") → Cartes filtrées
4. ✅ **Filtre Rareté** : Sélectionner une rareté (ex: "R1") → Cartes filtrées
5. ✅ **Recherche** : Taper "Gandalf" → Cartes correspondantes affichées
6. ✅ **Toggle** : Cliquer sur le switch d'une carte → État inversé
7. ✅ **Toast** : Vérifier que le toast "Card marked as owned" apparaît
8. ✅ **Optimistic Update** : L'UI se met à jour instantanément

### Tests Backend (http://localhost:3000/test-backend)
1. ✅ **Données réelles** : HeroCard affiche les vraies stats (24/40)
2. ✅ **Collections** : CollectionsGrid affiche MECCG et Doomtrooper
3. ✅ **Backend connecté** : Pas d'erreur CORS

### Tests Interactifs (http://localhost:3000/test)
1. ✅ **Vérifier le chargement** : La page s'affiche correctement ?
2. ✅ **Tester le formulaire** : Taper du texte et cliquer sur "Afficher"
3. ✅ **Vérifier l'affichage** : Le texte apparaît dans le bloc coloré ?
4. ✅ **Tester l'historique** : Plusieurs saisies s'accumulent ?
5. ✅ **Tester "Effacer"** : L'historique se vide ?
6. ✅ **Tester la navigation** : Les liens fonctionnent ?
7. ✅ **Tester le hover** : Les boutons s'animent au survol ?

---

## 🎨 Ce Qui Est Testé

Le frontend Collectoria valide :
- ✅ **Next.js 15** avec App Router
- ✅ **React 19** et Hooks (useState, useQuery, useMutation)
- ✅ **TypeScript** avec types stricts
- ✅ **React Query** pour data fetching et cache
- ✅ **Client-side rendering** ('use client')
- ✅ **Intégration Backend** (Go API REST)
- ✅ **Formulaires interactifs** avec validation
- ✅ **State management** : Local (useState) + Server (React Query)
- ✅ **CSS Variables** avec Design Ethos V1
- ✅ **Navigation** (Link) + TopNav sticky
- ✅ **Animations CSS** et transitions
- ✅ **Toast notifications** (react-hot-toast)
- ✅ **Optimistic Updates** avec rollback
- ✅ **Scroll infini** avec batching
- ✅ **Filtres dynamiques** (type, rareté, recherche)
- ✅ **Responsive design** (mobile + desktop)
- ✅ **Tests Vitest** : 103 tests (tous passants)

---

## 🔧 En Cas de Problème

### Le serveur ne démarre pas

```bash
# Vérifier Node.js
node --version  # Devrait être 20+

# Réinstaller les dépendances
cd ~/git/Collectoria/frontend
rm -rf node_modules package-lock.json
npm install
npm run dev
```

### Port 3000 déjà utilisé

```bash
# Option 1 : Tuer le processus
lsof -i :3000
kill -9 <PID>

# Option 2 : Utiliser un autre port
PORT=3001 npm run dev
```

### Erreur TypeScript

```bash
# Nettoyer le cache
rm -rf .next
npm run dev
```

---

## 📝 Notes Importantes

### Cette Page de Test Sert À :
1. ✅ Valider que Next.js fonctionne correctement
2. ✅ Servir de destination pour les liens non implémentés
3. ✅ Éviter les liens morts pendant le développement
4. ✅ Tester l'interactivité React

### Tester avec le Backend (Optionnel)

Si vous voulez tester l'intégration complète avec le backend Go :

```bash
# Terminal 1 : Démarrer PostgreSQL
cd ~/git/Collectoria/backend/collection-management
docker compose up -d

# Terminal 2 : Démarrer le backend
cd ~/git/Collectoria/backend/collection-management
export DB_HOST=localhost
export DB_PORT=5432
export DB_USER=collectoria
export DB_PASSWORD=changeme
export DB_NAME=collection_management
export DB_SSLMODE=disable
export CORS_ALLOWED_ORIGINS=http://localhost:3000,http://localhost:3001
export ENV=development
export LOG_LEVEL=debug
go run cmd/api/main.go

# Terminal 3 : Démarrer le frontend
cd ~/git/Collectoria/frontend
npm run dev
```

Ensuite, ouvrir http://localhost:3000 pour voir les données réelles (1,679 cartes MECCG).

### Prochaine Étape
Travail sur **Phase 2 Sécurité** (JWT Authentication, Rate Limiting) avant mise en production.

---

## ⏱️ Temps Estimé

- **Installation** : 30 secondes à 1 minute
- **Premier lancement** : ~5 secondes
- **Test complet** : 2-3 minutes

**Total : ~5 minutes** pour tout tester ! 🚀

---

## 🎯 Checklist Rapide

### Frontend Seul (Sans Backend)
- [ ] `cd ~/git/Collectoria/frontend`
- [ ] `npm install`
- [ ] `npm run dev`
- [ ] Ouvrir http://localhost:3000
- [ ] Voir la homepage avec HeroCard + CollectionsGrid (données mock)
- [ ] Naviguer vers `/cards/add`
- [ ] Tester les filtres (type, rareté, recherche)
- [ ] **Succès !** 🎉

### Frontend + Backend (Avec Données Réelles)
- [ ] Démarrer PostgreSQL (`docker compose up -d`)
- [ ] Démarrer le backend (`go run cmd/api/main.go`)
- [ ] Démarrer le frontend (`npm run dev`)
- [ ] Ouvrir http://localhost:3000
- [ ] Voir les vraies stats (1,679 cartes MECCG)
- [ ] Naviguer vers `/cards/add`
- [ ] Tester le toggle de possession (cliquer sur le switch)
- [ ] Vérifier le toast de succès
- [ ] **Succès complet !** 🎉

---

## 💡 Bonus

### Voir les Logs de Développement

Le terminal affiche :
- Compilation TypeScript
- Erreurs éventuelles
- Hot reload quand vous modifiez le code

### Arrêter le Serveur

Appuyer sur `Ctrl + C` dans le terminal.

### Relancer Rapidement

```bash
npm run dev
```

---

**Prêt ?** Lancez-vous ! 🚀

Si tout fonctionne, vous verrez :
- ✅ Next.js fonctionne correctement
- ✅ React State Management OK
- ✅ Formulaires interactifs OK
- ✅ Client-side rendering OK
- ✅ CSS-in-JS OK

**Bon test ! 🎉**
