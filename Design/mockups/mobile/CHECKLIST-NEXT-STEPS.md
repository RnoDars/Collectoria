# Checklist - Prochaines Étapes Mobile Design

**Date** : 2026-04-28  
**Statut** : Documentation complétée - En attente décisions utilisateur

---

## Phase 1 : Décisions Stratégiques (Vous)

### ☐ Décision 1 : Bottom Navigation

**Question** : Quelle approche pour la bottom nav ?

- [ ] **Option A** : Fonctions (Home, Catalog, Collections, Stats, Settings) - Maquette originale
- [ ] **Option B** : Collections (Accueil, MECCG, Royaumes, D&D 5e) - Implémentation actuelle
- [ ] **Option C** : Hybrid (Home, Collections, Stats, Plus) - Recommandation Agent Design
- [ ] **Option D** : Autre (préciser) : _____________________

**Impact** : Détermine structure complète navigation mobile

**Référence** : `/Design/mockups/mobile/GAPS-ANALYSIS.md` section 7

---

### ☐ Décision 2 : Combler les Gaps Majeurs

**Question** : Faut-il implémenter les éléments manquants de la maquette originale ?

**Gap 1 - Logo Mobile** :
- [ ] **Oui** : Ajouter mini-header avec logo "Collectoria"
- [ ] **Non** : Garder sans logo
- [ ] **Différer** : À voir plus tard

**Gap 2 - Hero Progress Section** :
- [ ] **Oui** : Implémenter card violet "Total Collection Progress"
- [ ] **Non** : Page commence par liste collections (actuel)
- [ ] **Différer** : À voir plus tard

**Gap 3 - Recent Activity** :
- [ ] **Oui** : Ajouter section historique des actions
- [ ] **Non** : Pas de section activité
- [ ] **Différer** : À voir plus tard

**Impact** : Détermine scope développement Phase 2

**Référence** : `/Design/mockups/mobile/GAPS-ANALYSIS.md` section "Écarts Majeurs"

---

### ☐ Décision 3 : Layout Collection Cards

**Question** : Quel layout pour les cards de collections ?

- [ ] **Option A** : Garder layout actuel (vertical, image hero 120px)
- [ ] **Option B** : Revenir layout maquette (horizontal compact, icône + texte)
- [ ] **Option C** : Offrir toggle view (user choice)

**Impact** : Design des collection cards mobile

**Référence** : `/Design/mockups/mobile/COMPARISON-DESKTOP-MOBILE.md` section "Collection Cards"

---

## Phase 2 : Génération Maquettes (Agent Design + Stitch)

### ☐ Tâche 1 : Copier le Prompt Stitch

**Action** :
1. Ouvrir `/Design/mockups/mobile/STITCH-PROMPT.txt`
2. Copier le prompt complet
3. Ouvrir Stitch (https://stitch.ai ou outil équivalent)
4. Coller le prompt
5. Générer la maquette

**Résultat attendu** : Maquette mobile homepage (375px × 812px)

**Variantes à générer** :
- [ ] Variante A : Sans mini-header (état actuel)
- [ ] Variante B : Avec mini-header (logo + recherche)

**Durée estimée** : 5-10 minutes

---

### ☐ Tâche 2 : Sauvegarder les Maquettes

**Action** :
1. Télécharger les maquettes générées (PNG haute résolution)
2. Renommer selon convention :
   - `homepage-mobile-v2-2026-04-28.png` (sans header)
   - `homepage-mobile-with-header-v2-2026-04-28.png` (avec header)
3. Sauvegarder dans `/Design/mockups/mobile/`

**Checklist** :
- [ ] Maquette sans header sauvegardée
- [ ] Maquette avec header sauvegardée
- [ ] Fichiers nommés correctement
- [ ] Résolution suffisante (2x ou 3x)

---

### ☐ Tâche 3 : Valider les Maquettes

**Action** :
1. Ouvrir les maquettes générées
2. Vérifier respect de l'Ethos :
   - [ ] No-Line Rule respectée (pas de bordures 1px)
   - [ ] Tonal Layering présent (cards blanches sur #f8f9fa)
   - [ ] Gradient violet (#667eea → #764ba2) avec parcimonie
   - [ ] Typography Dual-Type (Manrope + Inter)
   - [ ] Border radius lg (16px) minimum
   - [ ] Spacing généreux (adapté mobile)
3. Identifier ajustements nécessaires (si applicable)

**Si ajustements nécessaires** :
- [ ] Lister les corrections dans un document
- [ ] Régénérer maquettes ajustées

---

## Phase 3 : Implémentation Frontend (Agent Frontend)

**Prérequis** : Décisions Phase 1 prises + Maquettes Phase 2 générées

### ☐ Tâche 4 : Créer les Composants Manquants

**Si Gap 1 validé (Logo mobile)** :
- [ ] Créer `/frontend/src/components/layout/MobileHeader.tsx`
  - Logo "Collectoria" compact
  - Icône recherche
  - Height 48px
  - Background #ffffff
  - Shadow subtile
- [ ] Intégrer dans layout mobile
- [ ] Tests : Affichage < 768px, caché ≥ 768px

**Si Gap 2 validé (Hero Progress)** :
- [ ] Créer `/frontend/src/components/dashboard/HeroProgress.tsx`
  - Card violet avec gradient (#667eea → #764ba2)
  - Affichage % total et nombre de cartes
  - Progress bar intégrée
  - Responsive (adapté mobile)
- [ ] Intégrer en haut de homepage mobile
- [ ] Tests : Calcul % correct, données réelles

**Si Gap 3 validé (Recent Activity)** :
- [ ] Créer `/frontend/src/components/activity/RecentActivity.tsx`
  - Liste des 3-5 dernières activités
  - Format : "Added X to Y" (timestamp)
  - Scroll vertical si > 5 items
- [ ] Intégrer en bas de homepage (avant bottom nav)
- [ ] Tests : Données réelles, tri chronologique

---

### ☐ Tâche 5 : Ajuster Bottom Navigation

**Si Option A choisie (Fonctions)** :
- [ ] Refactorer `/frontend/src/components/layout/BottomNav.tsx`
- [ ] Onglets : Home, Catalog, Collections, Stats, Settings
- [ ] Routing : Adapter les liens
- [ ] Tests : Navigation fonctionnelle

**Si Option B choisie (Collections - actuel)** :
- [ ] Garder implémentation actuelle
- [ ] Ajouter menu hamburger ou "Plus" pour fonctions secondaires
- [ ] Tests : Accès Stats, Settings via menu

**Si Option C choisie (Hybrid)** :
- [ ] Refactorer bottom nav : Home, Collections, Stats, Plus
- [ ] Créer modal/drawer "Plus" avec Settings, Import, etc.
- [ ] Tests : Navigation + modal fonctionnels

---

### ☐ Tâche 6 : Ajuster Layout Collection Cards

**Si Option B choisie (Revenir layout maquette)** :
- [ ] Modifier composant collection card
- [ ] Layout horizontal : Icône + Texte + Badge + Progress
- [ ] Réduire height (plus compact)
- [ ] Tests : Responsive, tous devices

**Si Option C choisie (Toggle view)** :
- [ ] Créer state user preference (compact vs gallery)
- [ ] Ajouter toggle dans header ou settings
- [ ] Adapter rendering selon preference
- [ ] Persister préférence (localStorage)
- [ ] Tests : Toggle fonctionnel, persistence

---

## Phase 4 : Validation Design (Agent Design)

### ☐ Tâche 7 : Audit Ethos des Composants

**Pour chaque composant implémenté** :
- [ ] MobileHeader (si créé)
  - [ ] No-Line Rule respectée
  - [ ] Tonal Layering (background #ffffff)
  - [ ] Border radius approprié
  - [ ] Typography (Inter pour search)
  - [ ] Variables CSS utilisées
- [ ] HeroProgress (si créé)
  - [ ] Gradient violet correct
  - [ ] Progress bar avec inner-glow
  - [ ] Typography Dual-Type
  - [ ] Spacing généreux
- [ ] RecentActivity (si créé)
  - [ ] No-Line Rule (pas de dividers)
  - [ ] Spacing vertical comme séparateur
  - [ ] Typography Inter pour body
- [ ] BottomNav (ajusté)
  - [ ] État actif correct (couleur + background)
  - [ ] Transitions smooth
  - [ ] Shadow vers le haut

**Checklist globale Ethos** :
- [ ] Aucune bordure 1px solide (sauf accessibilité)
- [ ] Tonal Layering utilisé pour hiérarchie
- [ ] Gradient violet avec parcimonie
- [ ] Manrope (titres) + Inter (body/nav)
- [ ] Border radius lg/xl minimum
- [ ] Variables CSS (pas de hardcoded values)

**Si corrections nécessaires** :
- [ ] Lister dans rapport validation
- [ ] Dispatcher corrections à Agent Frontend
- [ ] Revalider après corrections

---

### ☐ Tâche 8 : Tests Utilisateur Mobile

**Action** :
1. Déployer sur environnement de test
2. Tester sur devices réels :
   - [ ] iPhone (Safari iOS)
   - [ ] Android (Chrome)
   - [ ] Différentes tailles (small, medium, large)
3. Vérifier :
   - [ ] Navigation fluide
   - [ ] Lisibilité texte
   - [ ] Touch targets suffisants (min 44px)
   - [ ] Pas de chevauchement content/bottom nav
   - [ ] Performance (scroll smooth)

**Si problèmes détectés** :
- [ ] Documenter dans rapport de test
- [ ] Prioriser corrections
- [ ] Itérer implémentation

---

## Phase 5 : Documentation Finale

### ☐ Tâche 9 : Mettre à jour le Changelog

**Action** :
1. Ouvrir `/Design/CHANGELOG-DESIGN.md`
2. Ajouter entrée pour implémentation finale :
   ```markdown
   ## YYYY-MM-DD : Mobile Implementation v2
   
   **Type** : Implémentation + Maquettes
   **Auteur** : Agent Design + Agent Frontend
   **Impact** : Mobile design complet aligné maquettes
   
   ### Contexte
   [Description]
   
   ### Actions
   [Liste des composants créés/modifiés]
   
   ### Références
   [Maquettes finales, composants, tests]
   ```

---

### ☐ Tâche 10 : Screenshots Finaux

**Action** :
1. Prendre screenshots de l'implémentation finale :
   - [ ] Homepage mobile (sans scroll)
   - [ ] Homepage mobile (scrollé)
   - [ ] Bottom nav (état actif différent onglets)
   - [ ] MobileHeader (si créé)
   - [ ] HeroProgress (si créé)
   - [ ] RecentActivity (si créé)
2. Sauvegarder dans `/Design/mockups/mobile/screenshots/`
3. Nommer : `implementation-[component]-v2-YYYY-MM-DD.png`

**Checklist** :
- [ ] Screenshots haute résolution (2x)
- [ ] Annotations si nécessaire (dimensions, spacing)
- [ ] Comparaisons avant/après (si pertinent)

---

## Suivi de Progression

### Statut Actuel

| Phase | Statut | Date | Notes |
|-------|--------|------|-------|
| Phase 1 (Décisions) | ⏳ En attente | - | Attente utilisateur |
| Phase 2 (Maquettes) | ⏳ Non commencé | - | Dépend Phase 1 |
| Phase 3 (Implémentation) | ⏳ Non commencé | - | Dépend Phase 1 + 2 |
| Phase 4 (Validation) | ⏳ Non commencé | - | Dépend Phase 3 |
| Phase 5 (Documentation) | ⏳ Non commencé | - | Dépend Phase 4 |

### Durée Estimée Totale

| Phase | Durée | Agent Responsable |
|-------|-------|-------------------|
| Phase 1 | 30 min | Utilisateur |
| Phase 2 | 1 jour | Agent Design + Stitch |
| Phase 3 | 2-3 jours | Agent Frontend |
| Phase 4 | 1 jour | Agent Design |
| Phase 5 | 0.5 jour | Agent Design |
| **Total** | **4-5 jours** | - |

---

## Points de Décision Critiques

### 🔴 Bloquants (doivent être résolus en priorité)

1. **Bottom Nav Approach** (Décision 1)
   - Impact : Structure entière navigation mobile
   - Bloque : Phase 3 (implémentation)

2. **Gaps Majeurs** (Décision 2)
   - Impact : Scope développement
   - Bloque : Phase 3 (implémentation)

### ⚠️ Non-bloquants (peuvent être différés)

3. **Layout Cards** (Décision 3)
   - Impact : Apparence collection cards uniquement
   - Peut être différé : Oui (implémentation actuelle fonctionnelle)

---

## Contact / Questions

**Agent Design** : Prêt à générer maquettes Stitch dès décisions Phase 1 prises.

**Agent Frontend** : Prêt à implémenter dès maquettes validées.

**Agent Testing** : Prêt à valider implémentation mobile (tests unitaires + intégration).

---

## Références Rapides

| Document | Chemin |
|----------|--------|
| Documentation complète | `/Design/mockups/mobile/mobile-design-v1-2026-04-28.md` |
| Prompt Stitch | `/Design/mockups/mobile/STITCH-PROMPT.txt` |
| Analyse gaps | `/Design/mockups/mobile/GAPS-ANALYSIS.md` |
| Comparatif desktop/mobile | `/Design/mockups/mobile/COMPARISON-DESKTOP-MOBILE.md` |
| Résumé exécutif | `/Design/mockups/mobile/SUMMARY-FOR-USER.md` |
| Changelog design | `/Design/CHANGELOG-DESIGN.md` |
| Ethos V1 | `/Design/design-system/Ethos-V1-2026-04-15.md` |
| Maquette originale mobile | `/Design/mockups/homepage/homepage-mobile-v1-2026-04-15.png` |
| Implementation BottomNav | `/frontend/src/components/layout/BottomNav.tsx` |

---

**Prochaine action recommandée** : Répondre aux 3 décisions de la Phase 1 dans `/Design/mockups/mobile/SUMMARY-FOR-USER.md`.

---

**Dernière mise à jour** : 2026-04-28  
**Maintenu par** : Agent Design
