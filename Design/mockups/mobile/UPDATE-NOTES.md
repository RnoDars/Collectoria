# Notes de Mise à Jour - Prompt Stitch Mobile (2026-04-28)

## Raison de la Mise à Jour

Le prompt Stitch original (créé le 15 avril) était basé sur une maquette conceptuelle initiale qui ne reflétait plus l'implémentation web actuelle ni les choix de design validés depuis.

Une clarification majeure de l'utilisateur a révélé que :
- Le **hero progress** (section de stats globales en haut) a été **délibérément supprimé** sur le web
- Ce n'est **PAS un gap** à combler, mais un **choix de design validé**
- L'approche privilégie le focus immédiat sur les collections individuelles

Cette mise à jour aligne le prompt Stitch avec l'état réel et les décisions validées du projet.

---

## Clarification Majeure : Hero Progress

### Ancien Contexte (Mauvais)
Le prompt original supposait que le "hero progress" était manquant sur le web et devait être ajouté sur mobile.

### Nouveau Contexte (Correct)
Le hero progress a été **volontairement retiré** sur le web car :
- Ça ne faisait pas de sens pour l'expérience utilisateur
- Focus direct sur les collections = meilleure expérience
- Approche "galerie muséale" renforcée

**Conséquence** : Le hero progress ne doit PAS apparaître dans les nouvelles maquettes mobiles.

---

## Changements Appliqués au Prompt

### 1. Nouvelle Section "État Actuel Implémenté Web"
Ajout d'une section complète décrivant précisément ce qui est implémenté sur le web actuel :
- Bottom navigation (4 collections : Accueil, MECCG, Royaumes Oubliés, D&D 5e)
- Collection cards avec image hero (120px), titre, description, progress bar, stats
- Pas de header distinct
- Pas de hero progress (mentionné explicitement comme choix validé)

Cette section devient la **base de référence** pour les nouvelles maquettes.

### 2. Structure en Variantes (3 Maquettes)
Le prompt demande désormais **3 variantes progressives** au lieu d'une seule ou deux vagues options :

**Variante 1 : Base Actuelle**
- Représente fidèlement l'implémentation web
- Bottom nav (4 collections)
- Collection cards (approche galerie)
- Pas de header
- Pas de hero progress
- Pas de recent activity

**Variante 2 : + Mini-Header avec Logo**
- Ajoute un mini-header (48-56px) avec logo "Collectoria"
- Optionnel : Icône recherche ou menu à droite
- Conserve bottom nav et collection cards
- Objectif : Explorer l'impact du branding mobile

**Variante 3 : + Mini-Header + Recent Activity**
- Mini-header comme variante 2
- Section "Activité Récente" entre header et cards :
  - Card conteneur blanche
  - 2-3 items récents (icône + texte + timestamp)
  - Style : Tonal layering, pas de lignes
  - Optionnel : Bouton "Voir tout"
- Trade-off : Moins d'espace pour collection cards (scroll nécessaire)
- Objectif : Explorer l'engagement utilisateur

### 3. Clarification "Choix Validés vs Explorations"
Section dédiée pour distinguer :
- **Choix validés** (ne pas changer) : Bottom nav collections, cards visuelles, layout vertical, absence de hero progress
- **Explorations** (variantes) : Logo dans header, recent activity

### 4. Spécifications Techniques Détaillées
Spécifications beaucoup plus précises pour chaque élément :
- Bottom nav : Dimensions exactes, onglets détaillés (actif/inactif), couleurs, fonts
- Mini-header : Height, logo, optionnel icône, shadow
- Recent Activity : Structure card, items, icônes, timestamp, bouton "Voir tout"
- Collection cards : Tous les détails (image, titre, description, progress bar, stats)

### 5. Checklist de Validation
Ajout d'une checklist finale pour valider que chaque variante respecte :
- Format 375×812px
- No-Line Rule
- Tonal Layering
- Typography Dual-Type
- Gradient parcimonie
- Border radius lg
- Spacing généreux
- Pas de hero progress

---

## Rationale des 3 Variantes

### Pourquoi 3 Variantes ?

**Objectif** : Permettre à l'utilisateur de **décider** quelle direction prendre pour l'expérience mobile, en visualisant concrètement les trade-offs.

**Variante 1** : Point de départ (état actuel web)
- Approche minimaliste
- Focus maximal sur les collections
- Démarrage immédiat

**Variante 2** : Exploration du branding
- Identité de marque renforcée (logo visible)
- Espace pour recherche/menu futur
- Léger sacrifice d'espace (mais ~2.5-3 cards encore visibles)

**Variante 3** : Exploration de l'engagement
- Identité de marque maintenue
- Engagement utilisateur via historique récent
- Trade-off plus marqué : Moins de collection cards visibles (~2), scroll requis

### Trade-offs à Visualiser

| Aspect                  | Variante 1 | Variante 2 | Variante 3 |
|-------------------------|------------|------------|------------|
| Espace collection cards | Maximum    | Moyen      | Réduit     |
| Branding logo visible   | Non        | Oui        | Oui        |
| Engagement utilisateur  | Non        | Non        | Oui        |
| Scroll requis           | Minimal    | Minimal    | Oui        |

L'utilisateur pourra choisir en connaissance de cause quelle expérience correspond le mieux à la vision produit.

---

## Éléments Retirés du Prompt Original

- ❌ Références ambiguës à "hero progress manquant"
- ❌ Options floues ("avec ou sans header")
- ❌ Bottom nav à 5 onglets (approche générique Home/Explore/Profile/Settings) → Remplacé par 4 onglets collections validés
- ❌ Manque de détails techniques précis

---

## Éléments Ajoutés

- ✅ Section "État Actuel Implémenté Web" (base de référence)
- ✅ Clarification "hero progress = choix validé, pas gap"
- ✅ Structure en 3 variantes progressives
- ✅ Spécifications techniques détaillées (dimensions, couleurs, fonts précises)
- ✅ Section "Choix Validés vs Explorations"
- ✅ Section "Trade-offs à Visualiser"
- ✅ Checklist de validation finale
- ✅ Rationale des variantes (pourquoi 3, objectif de chacune)

---

## Workflow d'Utilisation

1. **Copier/Coller** le contenu de `STITCH-PROMPT.txt` dans Stitch
2. **Générer les 3 variantes** mobile (375×812px, iPhone portrait)
3. **Analyser les trade-offs** visuellement :
   - Variante 1 : Focus maximal collections
   - Variante 2 : Branding renforcé
   - Variante 3 : Engagement utilisateur
4. **Décider** quelle direction correspond le mieux à la vision produit
5. **Itérer** si nécessaire (ajuster une variante, combiner des éléments)
6. **Versionner** les maquettes générées dans `/Design/mockups/mobile/stitch-output-YYYY-MM-DD/`

---

## Cohérence avec l'Ethos "The Digital Curator"

Le nouveau prompt maintient rigoureusement les principes de l'Ethos V1 :
- **No-Line Rule** : Pas de bordures 1px, Tonal Layering utilisé
- **Dual-Type** : Manrope (headlines) + Inter (body/navigation)
- **Gradient violet** : Parcimonie (progress bars, CTAs, onglet actif)
- **Whitespace** : Généreux, élément de design actif
- **Border radius** : lg (16px) minimum
- **Approche galerie** : Images hero mises en avant

Les 3 variantes respectent toutes ces principes fondamentaux.

---

## Date de Mise à Jour

**2026-04-28**

## Auteur

Agent Design (Collectoria)

---

## Prochaines Étapes

1. Générer les 3 maquettes via Stitch avec le nouveau prompt
2. Analyser visuellement les variantes
3. Décider quelle direction privilégier pour l'app mobile
4. Si besoin, itérer sur la variante choisie avec ajustements
5. Une fois validée, créer les spécifications détaillées pour l'Agent Frontend
6. Implémenter la version mobile en respectant la variante choisie

---

**Note Finale** : Ce prompt est désormais aligné avec l'implémentation réelle du projet et les choix de design validés. Il ne suppose plus de gaps inexistants et permet une exploration visuelle concrète des options d'évolution.
