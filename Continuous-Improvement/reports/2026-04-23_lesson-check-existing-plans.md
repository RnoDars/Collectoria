# Amélioration Continue - Leçon : Vérifier Plans Existants Avant Création

**Date** : 2026-04-23  
**Type** : Leçon apprise  
**Sévérité** : MOYENNE  
**Impact** : Temps perdu, sur-ingénierie

---

## 📋 Incident

### Ce qui s'est passé

1. **Contexte** : Utilisateur demande de travailler sur collection "Royaumes oubliés"
2. **Action Alfred** : 
   - Trouvé données existantes (`books_royaumes_oublies.sql`)
   - **MAIS** invoqué Agent Spécifications pour créer une spec complète
   - Créé spec ultra-complexe (1257 lignes) avec microservice séparé, statuts de lecture, notes, statistiques
   - Lancé Agent Backend pour implémenter cette spec complexe
3. **Problème détecté** : Utilisateur signale que le plan devait être simple depuis le début
4. **Découverte** : Un plan simple existait déjà depuis hier (`Project follow-up/tasks/books-collection-implementation.md`)

### Résultat

- ✅ Spec complexe créée : `royaumes-oublies-books-v1.md` (1257 lignes)
- ✅ Microservice créé : `backend/books-catalog/` (structure DDD complète)
- ❌ **Tout supprimé** : Spec + microservice inutiles
- ❌ **Temps perdu** : ~1-2 heures d'agents + contexte utilisateur
- ❌ **Confusion** : Utilisateur doit corriger l'approche

---

## 🔍 Analyse de l'Erreur

### Erreur Commise

**Alfred n'a PAS vérifié l'existence de plans/specs avant d'en créer de nouveaux.**

### Ce qui aurait dû se passer

1. Utilisateur : "Travaille sur Royaumes oubliés"
2. Alfred : **VÉRIFIER FICHIERS EXISTANTS**
   ```bash
   find Project follow-up/tasks/ -name "*book*" -o -name "*royau*"
   # Trouver : books-collection-implementation.md (plan simple d'hier)
   ```
3. Alfred : **LIRE LE PLAN EXISTANT**
4. Alfred : "J'ai trouvé ton plan d'hier, on suit ça ?"
5. Utilisateur : "Oui"
6. Alfred : Implémenter selon plan simple

### Ce qui s'est réellement passé

1. Utilisateur : "Travaille sur Royaumes oubliés"
2. Alfred : Trouve données SQL ✓
3. Alfred : **CRÉE NOUVELLE SPEC COMPLEXE** (sans vérifier plan existant) ❌
4. Alfred : Lance implémentation complexe ❌
5. Utilisateur : "C'est trop complexe, on fait simple"
6. Alfred : Découvre plan simple existant (trop tard)
7. **Suppression totale** + recommencer

---

## 📊 Impact

### Temps Perdu

| Activité | Temps | Résultat |
|----------|-------|----------|
| Création spec complexe (Agent Spécifications) | 30-40 min | ❌ Supprimée |
| Implémentation domaine (Agent Backend) | 30-40 min | ❌ Supprimée |
| Lecture + analyse spec | 10 min | ❌ Inutile |
| Échanges utilisateur | 10 min | ❌ Confusion |
| Suppression + nettoyage | 5 min | ✅ OK |
| **Total temps perdu** | **~1.5-2h** | |

### Impact Utilisateur

- 😕 **Confusion** : "Pourquoi une spec complexe alors qu'on a dit simple ?"
- 😟 **Doute** : "Alfred hallucine ?"
- ⏱️ **Temps perdu** : Doit corriger l'approche

### Impact Projet

- 📉 **Efficacité réduite** : Temps gaspillé
- 🔄 **Recommencement** : Tout à refaire
- 📝 **Commits inutiles** : `88b3dd0` (spec) puis `f06bdef` (revert)

---

## ✅ Règle d'Or à Adopter

### AVANT de créer une spec/plan : TOUJOURS VÉRIFIER

```bash
# 1. Chercher specs existantes
find Specifications/ -iname "*[mot-clé]*"

# 2. Chercher plans existants
find "Project follow-up/tasks/" -iname "*[mot-clé]*"

# 3. Chercher données existantes
find backend/ -iname "*[mot-clé]*" | grep -E "\.sql|\.json|\.csv"
```

### Workflow Correct

```
User request
    ↓
Alfred: SEARCH existing plans/specs
    ↓
Found? → YES → READ + ASK USER if plan is still valid
    ↓          ↓
    NO      User confirms → USE EXISTING PLAN
    ↓                    ↓
CREATE NEW         User says "no, do different" → DISCUSS + CREATE NEW
```

---

## 🎯 Actions Correctives

### Immédiat

1. ✅ **Supprimer** spec complexe
2. ✅ **Supprimer** microservice créé
3. ✅ **Documenter** cette erreur (ce fichier)
4. ⏳ **Suivre** le plan simple existant

### Préventif (pour futures sessions)

#### Règle 1 : Check Before Create

**AVANT** de demander à Agent Spécifications de créer une spec :

```bash
# 1. Vérifier specs existantes
find Specifications/ -iname "*keyword*" -type f

# 2. Vérifier tâches existantes
find "Project follow-up/tasks/" -iname "*keyword*" -type f

# 3. Si trouvé → LIRE AVANT de créer nouveau
```

#### Règle 2 : Ask User About Existing Plans

Si un plan/spec existant est trouvé :

```
Alfred: "J'ai trouvé un plan existant pour [feature] créé [date].
Il propose [résumé approche].
Veux-tu que je suive ce plan ou que je crée une nouvelle spec ?"

User: "Suis le plan existant" OU "Crée nouveau"
```

#### Règle 3 : Simplicity First

Quand utilisateur dit "ajouter collection X" :

**Défaut** : Approche simple (réutiliser existant)
**Exception** : Si utilisateur demande explicitement "fais un microservice séparé"

#### Règle 4 : Memory Check

Consulter la mémoire auto (`~/.claude/projects/.../memory/`) pour contexte récent.

---

## 📝 À Ajouter dans CLAUDE.md (Alfred)

### Section : "Workflow Création de Specs"

```markdown
## Avant de Créer une Spec

**RÈGLE CRITIQUE** : Toujours vérifier l'existant AVANT de créer.

1. **Chercher specs existantes** :
   - `find Specifications/ -iname "*keyword*"`
   - Lire si trouvé

2. **Chercher plans/tâches existants** :
   - `find "Project follow-up/tasks/" -iname "*keyword*"`
   - Lire si trouvé

3. **Si existant trouvé** :
   - Lire le contenu
   - Demander à l'utilisateur : "Plan X existe, on suit ça ?"
   - Attendre confirmation avant de créer nouveau

4. **Si rien trouvé** :
   - Créer nouvelle spec SIMPLE par défaut
   - Demander à l'utilisateur s'il veut complexe

**Leçon** : 2026-04-23 - Spec complexe créée alors que plan simple existait.
Temps perdu : 2h. Tout supprimé.
```

---

## 🎓 Leçons Retenues

### Pour Alfred

1. ✅ **Check existing before creating** - TOUJOURS
2. ✅ **Simple by default** - Ne pas sur-ingénierer
3. ✅ **Ask user about existing plans** - Communication
4. ✅ **Read user's previous work** - Respecter l'historique

### Pour l'Utilisateur

1. ✅ **Peut faire confiance** : Alfred documente ses erreurs
2. ✅ **Peut corriger** : Alfred écoute et s'adapte
3. ⚠️ **Doit rappeler** : Si Alfred oublie le contexte simple

---

## 📊 Métriques d'Amélioration

### Avant cette leçon

- **Vérification plans existants** : 0% (non fait)
- **Specs créées sans besoin** : 1 (royaumes-oublies-books-v1.md)
- **Temps gaspillé** : 2h

### Après cette leçon

- **Vérification plans existants** : 100% (obligatoire)
- **Specs créées sans besoin** : 0 (cible)
- **Temps gaspillé** : 0 (cible)

### Indicateur de succès

**Prochaine demande "Ajoute collection Y"** :
1. Alfred cherche plans existants
2. Alfred demande confirmation si trouvé
3. Alfred propose approche simple si rien trouvé
4. Pas de sur-ingénierie
5. Pas de temps perdu

---

## 🔗 Références

### Fichiers Concernés

**Créés par erreur** :
- `Specifications/collections/royaumes-oublies-books-v1.md` (1257 lignes) - SUPPRIMÉ
- `backend/books-catalog/` (microservice complet) - SUPPRIMÉ

**Qui auraient dû être lus** :
- `Project follow-up/tasks/books-collection-implementation.md` (plan simple d'hier)
- `backend/collection-management/data/books_royaumes_oublies.sql` (94 livres)

**Commits** :
- `88b3dd0` - spec: add Forgotten Realms books collection specification (INUTILE)
- `f06bdef` - revert: remove over-engineered books specification (CORRECTION)

---

## ✅ Action Plan

### Court Terme (Aujourd'hui)

1. ✅ Documenter cette erreur (ce fichier)
2. ⏳ Suivre le plan simple existant
3. ⏳ Implémenter collection Romans (approche simple)

### Moyen Terme (Prochaines sessions)

1. ⏳ Mettre à jour `CLAUDE.md` (Alfred) avec règle "Check Before Create"
2. ⏳ Tester la règle sur prochaine feature
3. ⏳ Valider que temps perdu = 0

### Long Terme (Amélioration Continue)

1. ⏳ Audit régulier : "Specs créées vs specs utilisées"
2. ⏳ Métrique : "Plans existants ignorés" (cible : 0)

---

## 📌 Conclusion

**Erreur** : Ne pas vérifier plans existants avant création → Sur-ingénierie → Temps perdu

**Solution** : Règle "Check Before Create" - TOUJOURS vérifier existant avant de créer

**Impact** : -2h aujourd'hui, +Nx heures gagnées dans le futur

**Status** : ✅ Leçon documentée, règle établie, à appliquer dès maintenant

---

**Créé par** : Alfred (Agent Principal)  
**Date** : 2026-04-23  
**Type** : Amélioration Continue  
**Priorité** : HAUTE (prévenir récurrence)
