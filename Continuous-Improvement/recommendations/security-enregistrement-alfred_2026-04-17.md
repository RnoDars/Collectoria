# Recommandation : Enregistrer l'Agent Security dans Alfred

**Date** : 2026-04-17
**Agent ciblé** : Alfred (CLAUDE.md racine) + AGENTS.md
**Priorité** : Urgente
**Effort estimé** : 5-10 minutes

---

## Problème Identifié

L'Agent Security (`Security/CLAUDE.md`, 272 lignes, contenu de qualité) a été créé lors du commit `f09edb7` ("Création agent Sécurité et amélioration agent DevOps pour tests locaux") mais **n'a jamais été enregistré dans le registre Alfred**.

Conséquences concrètes :
- Alfred ne sait pas que cet agent existe
- Aucun dispatch possible vers Security (ex: "audite le code pour les failles OWASP")
- L'agent Security interagit avec Backend, Frontend, DevOps, Testing — ces agents le mentionnent dans leurs sections "Interaction" mais Alfred ne peut pas les connecter
- Risque de doublons : si quelqu'un demande un audit de sécurité, Alfred pourrait improviser au lieu de dispatcher

## Solution Proposée

### Modification 1 : `CLAUDE.md` (Alfred, racine)

**Section "Dispatch Intelligent"** — Ajouter :
```markdown
- **Sécurité/Audit** → Agent Security (dans `Security/`)
```

**Section "Agents Techniques"** — Ajouter :
```markdown
- **Agent Security** : Audit code Go/React, dépendances CVE, OWASP Top 10, secrets scanning
```

### Modification 2 : `AGENTS.md` (si le fichier existe et liste les agents)

Vérifier le contenu de `AGENTS.md` à la racine et y ajouter l'Agent Security selon le format existant.

## Triggers de Dispatch vers Security

Pour information d'Alfred, les demandes typiques à dispatcher vers Security :
- "audite le code / cherche des failles"
- "scan les dépendances / vulnerabilités CVE"
- "vérifie les pratiques de sécurité"
- "implémente le rate limiting / JWT"
- "configure les headers de sécurité"
- "scan les secrets dans le code"

## Plan d'Action

1. Modifier `CLAUDE.md` (racine) — 2 ajouts de ligne
2. Modifier `AGENTS.md` si applicable
3. Committer avec message : `docs: enregistrer Agent Security dans le registre Alfred`

## Agents Impactés

- **Alfred** : Ajout de l'entrée Security dans le registre de dispatch
- **Security** : Aucun changement nécessaire (CLAUDE.md bien rédigé)
- **Tous les autres agents** : Bénéficient d'un dispatch correct vers Security
