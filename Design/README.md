# Design - Collectoria

Ce répertoire contient tous les assets de design et maquettes pour Collectoria.

## Structure

### `/mockups`
Maquettes haute-fidélité générées ou créées pour le projet.

**Convention de nommage** :
```
[page-name]-[version]-[date].png
```

**Exemples** :
- `homepage-v1-2026-04-15.png`
- `catalog-v1-2026-04-15.png`
- `card-detail-v2-2026-04-20.png`

**Organisation** :
```
mockups/
├── homepage/
│   ├── homepage-v1-2026-04-15.png
│   └── homepage-v2-2026-04-20.png
├── catalog/
│   └── catalog-v1-2026-04-15.png
└── statistics/
    └── statistics-v1-2026-04-16.png
```

### `/wireframes`
Wireframes basse-fidélité (croquis, structures).

**Convention de nommage** :
```
[page-name]-wireframe-[date].png
```

### `/assets`
Assets graphiques réutilisables (logos, icônes, patterns).

```
assets/
├── logos/
├── icons/
├── colors/
└── typography/
```

## Workflow

1. **Création de maquette** (Stitch, Figma, etc.)
   - Exporter en PNG ou JPG haute qualité
   - Nommer selon la convention
   - Placer dans le bon sous-dossier

2. **Versioning**
   - Chaque itération = nouvelle version (v1, v2, v3...)
   - Inclure la date dans le nom de fichier
   - Ne jamais écraser une version précédente

3. **Documentation**
   - Créer un fichier `NOTES.md` dans chaque sous-dossier
   - Documenter les changements entre versions
   - Référencer les specs techniques associées

4. **Référencement**
   - Les specs techniques doivent référencer les maquettes
   - Format : `Design/mockups/homepage/homepage-v1-2026-04-15.png`

## Outils Utilisés

- **Stitch** : Génération de maquettes par IA
- **Figma** : Design collaboratif (futur)
- **Excalidraw** : Wireframes rapides (futur)

## Historique des Maquettes

### 2026-04-15
- [ ] Homepage v1 (en cours)

## Notes

- Privilégier PNG pour les maquettes (meilleure qualité)
- Résolution minimale : 1920x1080 pour desktop, 375x812 pour mobile
- Inclure les annotations/dimensions si possible
- Garder les fichiers sources (Figma, Sketch) si disponibles
