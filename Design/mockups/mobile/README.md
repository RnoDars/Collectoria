# Maquettes Mobile - Collectoria

Ce répertoire contient les maquettes et documentation pour l'expérience mobile de Collectoria.

## Fichiers

### Documentation

- **mobile-design-v1-2026-04-28.md** : Documentation complète des évolutions mobile + Prompt Stitch pour génération maquettes
  - Contexte évolution desktop → responsive
  - Décisions de design (bottom nav, cards compactes)
  - Différences desktop vs mobile
  - Prompt Stitch copier/coller
  - Recommandations UX

### Maquettes (à générer)

Les maquettes seront générées via Stitch et versionnées ici :

- `homepage-mobile-v1-2026-04-28.png` : Homepage avec bottom navigation et collection cards compactes
- `homepage-mobile-with-header-v1-2026-04-28.png` : Variante avec mini-header incluant logo
- `collection-detail-mobile-v1-2026-04-28.png` (optionnel) : Page détail collection avec liste cartes

## Quick Start

### Générer les Maquettes

1. Lire le prompt Stitch dans `mobile-design-v1-2026-04-28.md` (section 5.1)
2. Copier le prompt complet
3. Ouvrir Stitch
4. Coller le prompt
5. Sauvegarder les maquettes générées dans ce répertoire

### Workflow de Validation

```
Agent Design (Stitch) → Maquettes mobile → Validation utilisateur
                                               ↓
                                         Agent Frontend
                                    (Implémentation responsive)
                                               ↓
                                         Agent Design
                                    (Validation Ethos)
```

## Caractéristiques Mobile

### Bottom Navigation (< 768px)

- 4 onglets : Accueil, MECCG, Royaumes, D&D 5e
- Position fixe bottom (64px height)
- Onglet actif : #667eea avec background rgba(102, 126, 234, 0.08)
- Shadow vers le haut

### Collection Cards Compactes

| Élément | Desktop | Mobile |
|---------|---------|--------|
| Image hero | 160px | 120px |
| Padding | 24px | 16px |
| Titre | 1.5rem | 1.25rem |
| Description | 2 lignes | 1 ligne |

### Principes Ethos Conservés

- No-Line Rule (pas de bordures)
- Tonal Layering (cards blanches sur #f8f9fa)
- Gradient violet signature (#667eea → #764ba2)
- Typography Dual-Type (Manrope + Inter)
- Border radius lg (16px)

## Recommandations Futures

1. Mini-header avec logo Collectoria
2. User menu étendu (accès fonctions secondaires)
3. Toggle view density (compact/spacious)
4. Gestures navigation (swipe, long press)
5. Lazy loading images

## Références

- Design System : `/Design/design-system/Ethos-V1-2026-04-15.md`
- Maquette Desktop : `/Design/mockups/homepage/homepage-desktop-v1-2026-04-15.png`
- Agent Design : `/Design/CLAUDE.md`

---

**Dernière mise à jour** : 2026-04-28  
**Status** : Documentation v1 complétée - Maquettes à générer
