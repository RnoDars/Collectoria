# TODO : Corrections Responsive Mobile

**Priorité** : MEDIUM
**Effort estimé** : 2-4 heures
**Dépendances** : Aucune
**Contexte** : Session 2026-04-28

## Objectif

Corriger les problèmes d'affichage restants sur les pages de l'application en vue mobile/responsive, après le redesign mobile du 28 avril.

## Problèmes Connus

- Des problèmes de layout persistent en vue responsive (pages à préciser lors de la session de correction)
- La BottomNav était visible en desktop à cause d'un `display: 'flex'` inline — **corrigé le 28/04**

## Déclencheurs

Démarrer dès que du temps est disponible (pas de condition bloquante) :
- [x] Redesign mobile 2026-04-28 appliqué
- [x] Bug BottomNav desktop corrigé
- [ ] Session dédiée responsive planifiée

## Plan d'Action

### Phase 1 : Audit (30 min)
- [ ] Ouvrir chaque page en vue responsive (DevTools 375px, 768px)
- [ ] Pages à auditer : `/` (homepage), `/cards`, `/books`, `/dnd5`, `/login`
- [ ] Lister tous les problèmes avec capture d'écran si possible

### Phase 2 : Corrections (1-3h selon volume)
- [ ] Corriger les problèmes identifiés (CSS Tailwind, media queries)
- [ ] Vérifier que la BottomNav s'affiche correctement sur mobile
- [ ] Vérifier que la Sidebar est masquée sur mobile
- [ ] Vérifier les marges/paddings avec la BottomNav (contenu caché derrière)

### Phase 3 : Validation (30 min)
- [ ] Tester sur plusieurs breakpoints (375px, 414px, 768px)
- [ ] Vérifier Safari iOS (backdrop-blur, glassmorphism)
- [ ] Vérifier Chrome Android

## Références

- Redesign mobile : `Design/mockups/mobile/`
- Globals CSS : `frontend/src/app/globals.css`
- Composants layout : `frontend/src/components/layout/`

## Notes

Le redesign mobile du 28 avril a ciblé principalement `/collections/[id]`. D'autres pages n'ont pas encore reçu les mêmes améliorations.
