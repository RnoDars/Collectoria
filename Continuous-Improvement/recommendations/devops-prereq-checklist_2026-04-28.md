# Recommandation : Checklist Prérequis Phase 3 Déploiement

**Date** : 2026-04-28  
**Source** : Analyse session déploiement Scaleway  
**Priorité** : Haute  
**Impact** : Gain 10-15 minutes, moins d'interruptions  

---

## Problème Identifié

Lors du déploiement Phase 3 (Traefik HTTPS), le DNS n'était pas configuré. Cela a été découvert PENDANT la phase, causant :
- Interruption du workflow
- Configuration DNS en urgence
- Attente propagation DNS
- Stress utilisateur (deadline 18h)

**Temps perdu** : ~10-15 minutes

---

## Solution Proposée

L'Agent DevOps doit demander ET VALIDER tous les prérequis AVANT de démarrer Phase 3.

### Checklist Interactive Obligatoire

AVANT Phase 3, Agent DevOps doit poser ces questions :

```
🔍 Vérification prérequis Phase 3 (Traefik HTTPS) :

1. Domaine acheté ?
   → Quel est le nom de domaine exact ?
   → Réponse attendue : collectoria.example.com

2. DNS configuré ?
   → Validons ensemble MAINTENANT avec cette commande :
   $ dig +short VOTRE_DOMAINE.com A
   
   → Attendu : <IP_DU_VPS>
   → Si vide ou autre IP : DNS PAS ENCORE PROPAGÉ
   
   Alternative si dig non installé :
   $ ping VOTRE_DOMAINE.com -c 1

3. Email Let's Encrypt fourni ?
   → Quel email pour les certificats ?
   → Réponse attendue : votre.email@example.com

4. Temps disponible ?
   → Combien de temps avez-vous disponible maintenant ?
   → Phase 3 estimée : 30-40 minutes
   → Si <1h disponible : proposer report ou mode rapide
```

### Règle Stricte

**SI UN SEUL prérequis manque → NE PAS DÉMARRER PHASE 3**

Proposer :
- Configurer le prérequis maintenant
- Reporter Phase 3 à plus tard

---

## Implémentation

### 1. Fichier `DevOps/production-deployment-checklist.md`

Créer un fichier dédié contenant :
- Checklist complète Phase 1, 2, 3
- Commandes de validation pour chaque prérequis
- Template de questions à poser

### 2. Mise à jour `DevOps/production-setup.md`

Ajouter section "Prérequis Phase 3" AVANT la section actuelle "3. Reverse proxy et TLS (Traefik v3)" :

```markdown
## Prérequis Phase 3 (OBLIGATOIRE)

AVANT de démarrer Phase 3, VALIDER ces 3 points :

### 1. Domaine acheté et configuré
- Domaine acheté chez un registrar (OVH, Gandi, etc.)
- Enregistrement DNS A créé pointant vers IP du VPS
- TTL configuré à 300 (5 min) pour corrections rapides

### 2. DNS propagé et validé
**Commande de validation** :
```bash
dig +short VOTRE_DOMAINE.com A
# Doit retourner : <IP_DU_VPS>
```

**Alternative si dig non installé** :
```bash
ping VOTRE_DOMAINE.com -c 1
# Doit afficher l'IP du VPS
```

**Si DNS non propagé** :
- Attendre 5-30 minutes selon TTL
- Vérifier configuration DNS chez registrar
- NE PAS continuer Phase 3 tant que DNS ne répond pas

### 3. Email Let's Encrypt fourni
- Email valide pour notifications certificats
- Sera configuré dans `traefik/traefik.yml`
```

### 3. Mise à jour `DevOps/CLAUDE.md`

Ajouter règle dans section "Responsabilités" :

```markdown
### Validation Prérequis Production

**Règle critique** : AVANT Phase 3 (Traefik HTTPS), TOUJOURS valider :
1. Domaine acheté → demander nom exact
2. DNS propagé → valider avec dig/ping MAINTENANT
3. Email fourni → demander email Let's Encrypt

**Si un prérequis manque** : NE PAS DÉMARRER PHASE 3.
Proposer de configurer le prérequis ou reporter la phase.

**Référence** : `DevOps/production-deployment-checklist.md`
```

---

## Template Questions Agent DevOps

L'Agent DevOps doit utiliser ce template EXACTEMENT avant Phase 3 :

```
🤖 Agent DevOps : Avant de démarrer Phase 3 (Traefik HTTPS), 
je dois valider les prérequis obligatoires.

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
📋 Checklist Prérequis Phase 3
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

1️⃣ Domaine acheté ?
→ Quel est le nom de domaine exact ?

2️⃣ DNS configuré ?
→ Vérifions ensemble maintenant :

Sur votre machine locale, exécutez :
$ dig +short VOTRE_DOMAINE.com A

Si dig non installé, alternative :
$ ping VOTRE_DOMAINE.com -c 1

→ Quel est le résultat ?
→ Attendu : 51.159.161.31 (IP de votre VPS)

3️⃣ Email Let's Encrypt ?
→ Quel email pour les notifications certificats ?

4️⃣ Temps disponible ?
→ Phase 3 estimée : 30-40 minutes
→ Combien de temps avez-vous disponible maintenant ?

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

⚠️ Si un prérequis manque, je recommande de le configurer 
AVANT de continuer Phase 3.
```

---

## Exemple Réel (Session 2026-04-28)

### Ce qui s'est passé
Agent DevOps a démarré Phase 3 directement, DNS découvert non configuré en pleine phase.

### Ce qui aurait dû se passer

**Agent DevOps** :
```
🤖 Agent DevOps : Avant de démarrer Phase 3, validons les prérequis.

1️⃣ Domaine acheté ?
```

**Utilisateur** :
```
Oui, collectoria.example.com
```

**Agent DevOps** :
```
2️⃣ DNS configuré ? Vérifions maintenant :
$ dig +short collectoria.example.com A

Quel est le résultat ?
```

**Utilisateur** :
```
Vide / Pas de réponse
```

**Agent DevOps** :
```
⚠️ DNS pas encore propagé. Phase 3 nécessite DNS opérationnel.

Options :
A. Configurer DNS maintenant + attendre propagation (15-30 min)
B. Reporter Phase 3 à demain (DNS aura le temps de propager)

Que préférez-vous ?
```

→ Pas d'interruption en pleine phase, décision claire, planning adapté.

---

## Bénéfices Attendus

| Métrique | Avant | Après | Gain |
|----------|-------|-------|------|
| Interruptions Phase 3 | 1-2 par session | 0 | Workflow fluide |
| Temps perdu DNS | 10-15 min | 0 | Gain temps |
| Stress utilisateur | Élevé | Faible | Meilleure expérience |
| Taux succès Phase 3 | 80% | 100% | Plus de confiance |

---

## Checklist Implémentation

- [ ] Créer `DevOps/production-deployment-checklist.md`
- [ ] Mettre à jour `DevOps/production-setup.md` section prérequis Phase 3
- [ ] Mettre à jour `DevOps/CLAUDE.md` règle validation prérequis
- [ ] Tester template questions avec utilisateur

---

## Statut

- **Créée** : 2026-04-28
- **Implémentée** : En attente
- **Testée** : Non
- **Validée** : Non

---

**Note** : Cette recommandation est complémentaire à la Recommandation 3 (Détection contrainte temps). Les deux doivent être implémentées ensemble pour un effet maximal.
