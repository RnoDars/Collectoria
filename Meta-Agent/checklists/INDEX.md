# Index des Checklists — Système Multi-Agents Collectoria

Ce fichier centralise toutes les checklists de vérification pour chaque agent du système.

**Usage** : Agent Meta utilise ce fichier pour auditer la conformité des agents.

---

## Alfred (Agent de Dispatch Principal)

**Fichier** : `/CLAUDE.md`

### Checklist Début de Session

**Référence** : `/CLAUDE.md` lignes 306-371

- [ ] `git pull origin main` exécuté
- [ ] `STATUS.md` lu et résumé extrait
- [ ] Résumé structuré présenté (dernière session / état actuel / priorités)
- [ ] PostgreSQL démarré (`docker compose up -d`)
- [ ] Backend démarré avec toutes les variables env (DB + JWT + CORS + LOG)
- [ ] Frontend démarré (`npm run dev`)
- [ ] Health check Backend : `curl http://localhost:8080/api/v1/health`
- [ ] Confirmation services : PostgreSQL, Backend, Frontend

### Checklist Pendant la Session

- [ ] Préfixer TOUS messages avec "🤖 Alfred :"
- [ ] Annoncer AVANT chaque appel agent : "Je fais appel à [Agent] pour [raison]"
- [ ] NE JAMAIS développer code directement (Backend/Frontend)
- [ ] Après implémentation Backend/Frontend → Appeler Agent Testing
- [ ] Après modifications Frontend importantes → Nettoyer cache .next
- [ ] Après modifications Backend → Redémarrer backend
- [ ] Après commit majeur → Vérifier que Agent Security a été appelé

### Checklist Fin de Session

- [ ] Appeler Agent Amélioration Continue si session >1h ou problèmes rencontrés
- [ ] Mettre à jour STATUS.md (ou demander à Agent Suivi)
- [ ] Vérifier que tous commits ont "Co-Authored-By: Claude Sonnet 4.5 <noreply@anthropic.com>"
- [ ] Fournir résumé final à l'utilisateur
- [ ] Appeler Agent Meta pour audit de conformité

### Checklist Délégation (Pré-Action)

Avant d'agir directement, répondre OUI à ces 5 questions :

- [ ] Cette tâche n'est dans les responsabilités d'AUCUN agent spécialiste ?
- [ ] Cette tâche est simple (<5 min) et ne nécessite aucune expertise spécifique ?
- [ ] Cette tâche n'implique aucun mot-clé déclencheur (infra, tests, sécurité, spec) ?
- [ ] Cette tâche n'est PAS du développement de code (Backend/Frontend/SQL) ?
- [ ] Cette tâche n'est PAS la rédaction d'une spécification ?

Si UNE SEULE réponse est NON → DÉLÉGUER à l'agent approprié.

### Checklist Cache Next.js

**Référence** : `/CLAUDE.md` lignes 385-499

Déclencheurs nettoyage cache .next :

- [ ] Suppression d'un ou plusieurs composants React
- [ ] Ajout/suppression de pages dans `/app`
- [ ] Modification de `page.tsx` ou `layout.tsx`
- [ ] Refactoring structure des répertoires
- [ ] Renommage composants avec changement d'imports
- [ ] Modifications massives (≥3 fichiers `.tsx` ou `.ts`)

Procédure :
1. Arrêter frontend : `pkill -f "next-server"`
2. Nettoyer cache : `cd frontend && rm -rf .next`
3. Redémarrer : `npm run dev > /tmp/frontend.log 2>&1 &`
4. Attendre : `sleep 8`
5. Vérifier : `curl -s http://localhost:3000 -o /dev/null -w "%{http_code}"` (attendu : 200)

### Checklist Redémarrage Backend

**Référence** : `/CLAUDE.md` lignes 501-530

Déclencheurs OBLIGATOIRES :

- [ ] Agent Backend a terminé une implémentation
- [ ] Code Go existant modifié
- [ ] Migration SQL appliquée

Procédure :
1. Tuer processus : `pkill -f "go run cmd/api/main.go" || lsof -ti :8080 | xargs -r kill -9`
2. Relancer avec toutes variables env
3. Health check : `curl -s http://localhost:8080/api/v1/health`

---

## Agent Backend

**Fichier** : `/Backend/CLAUDE.md`

### Checklist Avant de Commencer

- [ ] Spec technique lue complètement
- [ ] Tests identifiés (TDD)
- [ ] Architecture DDD comprise (domain/application/infrastructure)

### Checklist Pendant l'Implémentation

- [ ] Tests unitaires écrits AVANT le code (TDD)
- [ ] Architecture DDD respectée (domain/application/infrastructure)
- [ ] Gestion d'erreurs explicite (pas de panic)
- [ ] Logging structuré ajouté
- [ ] Code suit conventions Go (gofmt, golint)

### Checklist Après l'Implémentation

- [ ] Tous tests passent : `go test ./...`
- [ ] Coverage >80% pour code domaine
- [ ] Code compilé sans erreur
- [ ] Informer Alfred : "Implémentation terminée, prêt pour tests"
- [ ] Rappeler à Alfred de redémarrer le backend

### Checklist Redémarrage Backend (CRITIQUE)

- [ ] Rappeler à Alfred de redémarrer backend si code Go modifié
- [ ] Attendre confirmation backend redémarré avant dire "terminé"
- [ ] Ne JAMAIS tester sans redémarrage après modifications

---

## Agent Frontend

**Fichier** : `/Frontend/CLAUDE.md`

### Checklist Avant de Commencer

- [ ] Design system "The Digital Curator" lu (`Design/design-system/Ethos-V1-2026-04-15.md`)
- [ ] Variables CSS disponibles vérifiées (`globals.css`)
- [ ] Page `/cards` consultée si nouvelle collection

### Checklist Pendant l'Implémentation

- [ ] Pattern des 4 états appliqué (Loading/Error/Empty/Success)
- [ ] Tests créés avec @testing-library/react
- [ ] Design system respecté (No-Line Rule, Tonal Layering)
- [ ] Variables CSS UNIQUEMENT celles définies dans `globals.css`
- [ ] Accessibilité WCAG 2.1 AA

### Checklist Après l'Implémentation

- [ ] Tous tests passent : `npm test`
- [ ] Composants rendus sans erreur console
- [ ] Informer Alfred des modifications importantes

### Checklist Nettoyage Cache (CRITIQUE)

Si modifications importantes détectées :

- [ ] Rappeler à Alfred : "⚠️ Nettoyage cache .next requis avant redémarrage"
- [ ] Lister modifications : composants supprimés, pages modifiées, ≥3 fichiers
- [ ] Attendre confirmation cache nettoyé et frontend redémarré

**Modifications considérées importantes** :
- Suppression composants
- Ajout/suppression pages `/app`
- Modification `page.tsx` ou `layout.tsx`
- Refactoring structure
- ≥3 fichiers `.tsx` modifiés

---

## Agent DevOps

**Fichier** : `/DevOps/CLAUDE.md`

### Checklist Tests Locaux

- [ ] Utiliser TOUJOURS `sg docker -c "docker ..."`
- [ ] Seed données via `docker exec`, JAMAIS `psql` direct
- [ ] Vérifier ports Frontend (3000/3001/3002)
- [ ] Rapport de lancement structuré fourni

### Checklist Démarrage Services

- [ ] PostgreSQL démarré : `sg docker -c "docker compose up -d"`
- [ ] Backend démarré avec TOUTES variables env (DB + JWT)
- [ ] Frontend démarré : `npm run dev`
- [ ] Health checks validés (Backend, Frontend, PostgreSQL)
- [ ] Ports indiqués clairement dans rapport

### Checklist Avant Déploiement Production

- [ ] Variables `.env` complètes (aucun placeholder)
- [ ] Espace disque >2 GB : `df -h`
- [ ] Extensions PostgreSQL documentées et installées
- [ ] Build args NEXT_PUBLIC_* définis dans docker-compose.prod.yml
- [ ] Healthchecks cohérents Dockerfile ↔ docker-compose
- [ ] Fichiers Docker testés LOCALEMENT avant production

### Checklist Pendant Déploiement

- [ ] Suivre checklist : `devops-production-deployment-checklist_2026-05-04.md`
- [ ] Logs surveillés pendant rebuild
- [ ] Backup créé avant changements critiques
- [ ] `git pull` exécuté sur serveur

### Checklist Après Déploiement

- [ ] Health checks tous services : backend, frontend, DB
- [ ] Pages principales testées
- [ ] Aucune erreur critique dans logs
- [ ] Extensions PostgreSQL vérifiées : `bash DevOps/scripts/verify-postgres-extensions.sh`
- [ ] Rapport de déploiement fourni à Alfred

---

## Agent Testing

**Fichier** : `/Testing/CLAUDE.md`

### Checklist Test Minimal Obligatoire

**Référence** : `/Testing/CLAUDE.md` lignes 206-266

- [ ] Tests unitaires cas nominal (happy path)
- [ ] Tests unitaires cas d'erreur principal
- [ ] Frontend : 4 états testés si applicable (Loading/Error/Empty/Success)
- [ ] Frontend : Interaction principale testée si présente

### Checklist Exécution Tests Existants

- [ ] Backend : `go test ./...` exécuté
- [ ] Frontend : `npm test` exécuté
- [ ] Tous tests passent : AUCUN test en échec
- [ ] Si tests échouent → BLOQUER et signaler immédiatement

### Checklist Détection Régression

- [ ] Régressions détectées : oui/non
- [ ] Si oui : fichiers concernés listés
- [ ] Impact des régressions évalué
- [ ] Ne JAMAIS dire "terminé" si tests échouent

### Checklist Rapport

- [ ] Nombre de tests créés
- [ ] Résultats tests existants (passed/failed)
- [ ] Régressions détectées : oui/non
- [ ] Couverture approximative
- [ ] Rapport fourni à Alfred

---

## Agent Security

**Fichier** : `/Security/CLAUDE.md`

### Checklist Audit Code

- [ ] OWASP Top 10 vérifié
- [ ] SQL Injection : paramètres préparés
- [ ] Authentication/Authorization : JWT validé
- [ ] Input validation : toutes entrées validées
- [ ] Error handling : aucune info sensible exposée
- [ ] Logging : aucun secret logué

### Checklist Audit Dépendances

- [ ] Backend : `govulncheck ./...` exécuté
- [ ] Frontend : `npm audit` exécuté
- [ ] Vulnérabilités critiques : aucune
- [ ] Si vulnérabilités : actions prioritaires listées

### Checklist Rapport

- [ ] Rapport dans `Security/reports/YYYY-MM-DD_audit-*.md`
- [ ] Vulnérabilités documentées avec criticité
- [ ] Actions prioritaires listées avec timeline
- [ ] Score de sécurité actuel indiqué
- [ ] Rapport fourni à Alfred

---

## Agent Documentation

**Fichier** : `/Documentation/CLAUDE.md`

### Checklist Documentation Technique

- [ ] Architecture documentée (diagrammes, C4)
- [ ] API documentée (OpenAPI specs)
- [ ] DDD documenté (ubiquitous language, aggregates)
- [ ] ADR créés pour décisions architecturales

### Checklist Documentation Utilisateur

- [ ] Guides clairs et structurés
- [ ] Exemples concrets inclus
- [ ] Troubleshooting guide mis à jour
- [ ] FAQ à jour

### Checklist Qualité

- [ ] Markdown validé
- [ ] Diagrammes à jour
- [ ] Liens fonctionnels
- [ ] Documentation versionnée avec code

---

## Agent Spécifications

**Fichier** : `/Specifications/CLAUDE.md`

### Checklist Création Spec

- [ ] Spec datée et versionnée (v1.0, v1.1, etc.)
- [ ] Ubiquitous Language DDD utilisé
- [ ] Bounded context identifié
- [ ] Building blocks DDD identifiés (Entities, Value Objects, Aggregates)
- [ ] Contrats API définis (OpenAPI)
- [ ] Critères d'acceptation clairs
- [ ] Tests requis listés

### Checklist Pattern Architecture

- [ ] Backend : Table dédiée par collection (PAS de table générique)
- [ ] Frontend : Référencer `/cards/page.tsx` si nouvelle collection
- [ ] Patterns UI standards inclus (switch langue, filtres, tri)

### Checklist Validation

- [ ] Complétude vérifiée
- [ ] Clarté validée
- [ ] Ambiguïtés identifiées
- [ ] Distribution aux agents concernés

---

## Agent Suivi de Projet

**Fichier** : `/Project follow-up/CLAUDE.md`

### Checklist Mise à Jour STATUS.md

- [ ] Après tâche majeure complétée
- [ ] En fin de session si >2h ou plusieurs tâches
- [ ] Lors de changements de direction
- [ ] Métriques actualisées
- [ ] Prochaines priorités identifiées

### Checklist Documentation Décision

- [ ] Décision architecturale documentée dans `decisions/`
- [ ] Format ADR simplifié respecté
- [ ] Fichier nommé `YYYY-MM-DD_sujet-decision.md`
- [ ] Référencé dans rapport d'avancement

### Checklist Rapport Avancement

- [ ] Créé à chaque milestone ou tous les 10 commits
- [ ] Format standard respecté
- [ ] Tâches complétées listées
- [ ] Blocages identifiés
- [ ] Prochaines étapes claires

---

## Agent Amélioration Continue

**Fichier** : `/Continuous-Improvement/CLAUDE.md`

### Checklist Mini-Audit Fin de Session

**Référence** : `/Continuous-Improvement/CLAUDE.md` lignes 92-114

- [ ] Résumé session lu (git log ou demande Alfred)
- [ ] AU MAXIMUM UN problème/amélioration identifié
- [ ] Si problème : fichier créé dans `recommendations/`
- [ ] STATUS.md mis à jour si impact priorités
- [ ] Rapport bref (3-5 lignes) fourni à Alfred

### Checklist Audit Complet (Tous les 10 commits)

- [ ] Tous CLAUDE.md lus
- [ ] Tailles fichiers mesurées
- [ ] Historique Git analysé
- [ ] Patterns d'utilisation identifiés
- [ ] Rapport dans `reports/YYYY-MM-DD_report.md`

### Checklist Détection Problèmes

- [ ] Alfred développe directement ? → BLOQUER
- [ ] Environnement non démarré ? → Rappeler workflow
- [ ] Manque délégation agents critiques ? → Documenter

---

## Agent Meta (Superviseur)

**Fichier** : `/Meta-Agent/CLAUDE.md`

### Checklist Auto-Vérification

- [ ] Tous workflows audités systématiquement
- [ ] Toutes règles critiques vérifiées
- [ ] Rapports produits dans `Meta-Agent/reports/`
- [ ] Actions correctives communiquées clairement
- [ ] Escalade si manquement critique

### Checklist Rapport Conformité

- [ ] Contexte et déclencheur indiqués
- [ ] Workflows vérifiés (✅/❌ par étape)
- [ ] Règles critiques vérifiées (✅/❌)
- [ ] Manquements listés avec criticité
- [ ] Actions correctives priorisées
- [ ] Score de conformité calculé

### Checklist Communication

- [ ] Ton factuel et constructif
- [ ] Solutions proposées, pas seulement problèmes
- [ ] Rapport concis et structuré
- [ ] Escalade appropriée si critique

---

## Utilisation de cet Index

### Par Agent Meta

Lors d'un audit, Agent Meta :
1. Identifie l'agent à auditer
2. Consulte sa checklist dans ce fichier
3. Vérifie chaque point
4. Documente les manquements
5. Produit rapport de conformité

### Par Agents Spécialisés

Chaque agent peut consulter sa propre checklist pour :
- Auto-vérification avant de dire "terminé"
- S'assurer de ne rien oublier
- Respecter les workflows obligatoires

### Par Alfred

Alfred utilise cet index pour :
- Vérifier qu'il suit ses propres workflows
- Rappeler les checklists aux agents spécialisés
- Valider qu'un agent a terminé correctement

---

## Maintenance de cet Index

**Responsable** : Agent Amélioration Continue

**Quand mettre à jour** :
- Nouveau workflow ajouté dans un CLAUDE.md
- Nouvelle règle critique définie
- Checklist modifiée dans un CLAUDE.md
- Nouvel agent créé

**Comment mettre à jour** :
1. Lire le CLAUDE.md modifié
2. Extraire la nouvelle checklist ou workflow
3. Ajouter dans ce fichier avec référence ligne
4. Indiquer date de mise à jour

**Dernière mise à jour** : 2026-05-04

---

## Légende

- `[ ]` : Point de checklist à vérifier
- `✅` : Conforme / Respecté
- `❌` : Non-conforme / Violé
- `⚠️` : Partiel / Attention requise

---

**Fichier** : `/Meta-Agent/checklists/INDEX.md`  
**Version** : 1.0  
**Date** : 2026-05-04  
**Responsable** : Agent Meta (Superviseur)
