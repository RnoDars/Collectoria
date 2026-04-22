# Backlog d'Améliorations - Collectoria

**Dernière mise à jour** : 2026-04-22

Ce fichier regroupe les idées d'améliorations identifiées mais non prioritaires pour le moment.

---

## 🎨 UX/UI

### Header - Identité Utilisateur

**Priorité** : LOW  
**Effort** : 1-2h

**Idées** :
1. **Avatar/Icône utilisateur** :
   - Ajouter un avatar à côté de l'email dans le TopNav
   - Options : Initiales dans un cercle coloré, Gravatar, upload d'avatar
   
2. **Dropdown menu utilisateur** :
   - Click sur email/avatar → menu déroulant
   - Options du menu :
     - Mon profil
     - Paramètres
     - Statistiques personnelles
     - Se déconnecter
   - Design Ethos V1 (Tonal Layering, animations fluides)

**Mockup rapide** :
```
┌─────────────────────────────────────┐
│ Collectoria  [nav]  [👤 arnaud@...] │ ← Click
│                      └─────────────┐ │
│                      │ Mon profil  │ │
│                      │ Paramètres  │ │
│                      │ Statistiques│ │
│                      │ ───────────│ │
│                      │ Déconnexion│ │
│                      └─────────────┘ │
└─────────────────────────────────────┘
```

**Références** :
- Composant Dropdown : Headless UI ou Radix UI
- Animation : Framer Motion ou CSS transitions

---

## 🚀 Navigation

### Simplification des URLs de cartes

**Priorité** : MEDIUM  
**Effort** : 30min  
**Statut** : 🔜 À faire

**Problème identifié** :
- Deux pages existent : `/cards` et `/cards/add`
- La page `/cards/add` est préférable (liste complète avec filtres + toggle)
- L'URL `/cards/add` est moins intuitive

**Solution proposée** :
- Fusionner : `/cards` devrait afficher le contenu actuel de `/cards/add`
- Supprimer `/cards/add`
- Mettre à jour la navigation (liens dans TopNav)

---

## 🗄️ Données et Qualité

### Nettoyage des noms français MECCG

**Priorité** : MEDIUM  
**Effort** : 2-4h

**Problème identifié** :
- Lors de l'import, les noms français étaient obligatoires
- Quand un nom français n'existait pas, le nom anglais a été dupliqué
- Résultat : Mix de vrais noms français + noms anglais dans la colonne `name_fr`

**Exemples probables** :
```
✅ name_en: "Gandalf the Grey"   | name_fr: "Gandalf le Gris"  (OK)
❌ name_en: "The One Ring"       | name_fr: "The One Ring"     (Devrait être vide ou traduit)
❌ name_en: "Shadowfax"          | name_fr: "Shadowfax"        (Idem)
```

**Solution proposée** :
1. **Audit automatique** : Script SQL pour détecter les doublons name_en = name_fr
2. **Identification** : Lister toutes les cartes concernées
3. **Options de correction** :
   - Option A : Mettre `name_fr = NULL` si pas de vraie traduction
   - Option B : Chercher les vraies traductions (source externe)
   - Option C : Permettre affichage name_en en fallback si name_fr est NULL
4. **Validation** : Vérifier les corrections avec un sample
5. **Migration SQL** : Appliquer les corrections

**Requête SQL d'audit** :
```sql
-- Détecter les doublons name_en = name_fr
SELECT 
  id, 
  name_en, 
  name_fr, 
  card_type, 
  series
FROM cards
WHERE name_en = name_fr
ORDER BY series, card_type;
```

**Effort estimé** :
- Audit : 30min
- Décision stratégie : 15min
- Correction manuelle ou automatique : 1-2h
- Tests : 30min

**Impact utilisateur** :
- Améliore la qualité des données
- Meilleure expérience pour utilisateurs francophones
- Évite la confusion (doublons visibles)

---

## 📊 Fonctionnalités Futures

### Authentification Avancée

**Priorité** : MEDIUM (après Phase 2 Sécurité)  
**Effort** : 2-3 jours

- Page d'inscription (`/register`)
- Mot de passe oublié (`/forgot-password`)
- Vérification email
- Gestion multi-utilisateurs avec vraie table `users`
- Hashing des mots de passe (bcrypt)

### Statistiques Avancées

**Priorité** : LOW  
**Effort** : 1.5 jours

- Page `/stats` dédiée
- Complétion par série (graphiques)
- Complétion par type de carte
- Complétion par rareté
- Évolution temporelle avec charts interactifs
- Export PDF des statistiques

### Wishlist

**Priorité** : LOW  
**Effort** : 1 jour

- Toggle wishlist séparé de possession
- Page `/wishlist`
- Filtres et recherche
- Export/partage de la wishlist

### Import/Export

**Priorité** : MEDIUM  
**Effort** : 1 jour

- Export CSV/JSON de la collection
- Import CSV (ajout massif de cartes)
- Format compatible avec Excel/Sheets
- Validation des imports

---

## 🔒 Sécurité (Post-Phase 2)

### Refresh Tokens

**Priorité** : MEDIUM  
**Effort** : 4h

- Implémenter refresh tokens pour JWT
- Endpoint `/auth/refresh`
- Rotation automatique avant expiration

### 2FA (Two-Factor Authentication)

**Priorité** : LOW  
**Effort** : 2 jours

- TOTP avec QR code
- Codes de secours
- SMS/Email backup (optionnel)

---

## 🎯 Performance

### Cache Client-Side

**Priorité** : LOW  
**Effort** : 3h

- Service Worker pour cache offline
- IndexedDB pour données volumineuses
- PWA (Progressive Web App)

### Optimisation Images

**Priorité** : LOW  
**Effort** : 2h

- Next.js Image optimization
- CDN pour les images de cartes
- Lazy loading agressif

---

## 📱 Mobile

### App Mobile Native

**Priorité** : VERY LOW  
**Effort** : 3-4 semaines

- React Native ou Flutter
- Scanner de cartes (OCR/Vision)
- Mode hors-ligne

---

## Notes

- Ce backlog est vivant : ajouter de nouvelles idées au fur et à mesure
- Prioriser selon : Valeur utilisateur / Effort / Dépendances
- Réviser régulièrement (tous les mois)
