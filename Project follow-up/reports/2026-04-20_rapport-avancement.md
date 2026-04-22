# Rapport d'avancement - 2026-04-20

## Résumé

La session du 2026-04-20 a été très productive : la homepage est désormais complète avec tous ses widgets (HeroCard, CollectionsGrid, RecentActivityWidget, GrowthInsightWidget, TopNav), et le backend dispose maintenant de 5 endpoints opérationnels. L'import des vraies données MECCG (1679 cartes, dont 1661 possédées) marque une étape importante dans la concrétisation du MVP. Le travail en cours porte sur la page `/cards` avec scroll infini, dont le backend est terminé et le frontend reste à implémenter.

## Avancement par milestone

- Milestone 1 (MVP MECCG) : 65% — En cours

## Tâches complétées depuis le dernier rapport

- Intégration de HeroCard et CollectionsGrid dans la homepage (Phase 3)
- Ajout de la TopNav avec liens vers les pages de test
- Ajout des endpoints GET `/activities/recent` et GET `/statistics/growth` (7 tests TDD)
- Ajout des widgets RecentActivityWidget et GrowthInsightWidget dans la homepage
- Mise à jour de STATUS.md pour la session du 2026-04-20
- Import des vraies données MECCG (1679 cartes, 1661 possédées)
- Ajout de la règle `.gitignore` pour les fichiers de données `.xlsx`
- Correction du `Math.random()` dans le skeleton pour résoudre le mismatch SSR/hydration
- Ajout de l'endpoint GET `/api/v1/cards` avec filtres et pagination (TDD, scroll infini prévu)

## Tâches en cours

- Implémentation du frontend de la page `/cards` avec scroll infini (backend terminé)

## Blocages et risques

- Aucun blocage majeur identifié.
- Risque mineur : la volumétrie des données (1679 cartes) devra être validée en conditions réelles pour le scroll infini côté frontend (performances de rendu).

## Prochaines étapes

1. Implémenter la page `/cards` côté frontend avec scroll infini (Intersection Observer ou équivalent)
2. Ajouter les filtres UI sur la page `/cards` (par set, par type, par possession)
3. Implémenter la page de détail d'une carte (`/cards/[id]`)
4. Ajouter la gestion des collections (ajout/retrait de cartes)
5. Valider l'ensemble du MVP avec des données réelles

## Décisions prises

- Les fichiers de données sources (`.xlsx`) sont exclus du dépôt git via `.gitignore`.
- L'utilisation de `Math.random()` dans les skeletons est proscrite afin d'éviter les mismatches SSR/hydration ; remplacer par des valeurs déterministes ou des placeholders CSS.
- L'endpoint `/api/v1/cards` intègre dès le départ filtres et pagination pour préparer le scroll infini.
