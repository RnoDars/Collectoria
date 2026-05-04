# Plan d'Action Collectoria - Mai 2026

**Date de création** : 2026-05-04
**Auteur** : Agent Suivi de Projet
**Status** : 📋 EN ATTENTE VALIDATION UTILISATEUR

---

## Vue d'Ensemble

Ce plan d'action consolide 5 nouvelles tâches identifiées par l'utilisateur suite à la mise en production de Collectoria. Ces tâches adressent des problèmes critiques (bug production), des améliorations structurantes (séparation données, scripts déploiement) et des optimisations techniques (factorisation, audit sécurité).

**Contexte** :
- Collectoria est déployé en production avec 3 collections (MECCG, Books, DnD5)
- Un bug bloque actuellement la page `/cards` en production
- L'infrastructure de déploiement nécessite standardisation et automatisation
- Le code présente des duplications entre les 3 collections

**Objectifs** :
1. **Débloquer la production** (bug /cards)
2. **Sécuriser les données** (séparation environnements)
3. **Automatiser le déploiement** (scripts reproductibles)
4. **Optimiser le code** (factorisation collections)
5. **Valider la sécurité production** (audit complet)

---

## Priorisation Globale

### SESSION 1 (URGENT) - Fix Bug Production
**Priorité** : CRITIQUE (BLOQUANT)
**Tâche** : Fix page /cards en production
**Durée** : 1-2h
**Agents** : Agent DevOps + Agent Backend
**Blocage** : OUI - Production inutilisable

**Justification** :
- Bug bloquant l'utilisation de la production
- Doit être résolu EN PREMIER avant toute autre tâche
- Potentiellement affecte aussi `/books` et `/dnd5`

**Déclencheur** : Immédiat

---

### SESSION 2 - Séparation Données par Environnement
**Priorité** : HAUTE
**Tâche** : Séparation données dev/prod
**Durée** : 4-6h
**Agents** : Agent Backend + Agent DevOps
**Dépendances** : Aucune (peut commencer dès SESSION 1 terminée)

**Justification** :
- Risque critique : seeds de test peuvent écraser données prod
- Users identiques en dev et prod (sécurité)
- Prérequis pour déploiements futurs sécurisés

**Déclencheur** : Après SESSION 1

---

### SESSION 3 - Scripts Déploiement Automatisés
**Priorité** : HAUTE
**Tâche** : Scripts automatisés deploy/rollback
**Durée** : 3-4h
**Agents** : Agent DevOps
**Dépendances** : Aucune (parallélisable avec SESSION 2)

**Justification** :
- Déploiements actuels manuels et risqués
- Nécessaire pour déployer les corrections futures
- Réduira drastiquement le temps et le stress de déploiement

**Déclencheur** : Après SESSION 1

---

### SESSION 4 & 5 - Audit et Factorisation Collections
**Priorité** : MEDIUM
**Tâche** : Audit backend/frontend + factorisation
**Durée** : 6-8h (2 sessions de 3-4h)
**Agents** : Agent Backend + Agent Frontend
**Dépendances** : Aucune

**Justification** :
- Code dupliqué entre les 3 collections
- Maintenance difficile (changement = 3x le travail)
- Prépare l'ajout de nouvelles collections
- Non bloquant, peut être fait en parallèle des autres tâches

**Déclencheur** : Quand l'utilisateur a une session de 4h disponible

**Découpage** :
- **SESSION 4** (3-4h) : Audit Backend (Agent Backend) + Audit Frontend (Agent Frontend)
- **SESSION 5** (3-4h) : Implémentation factorisation (après validation audits)

---

### SESSION 6 - Audit Sécurité Production
**Priorité** : MEDIUM
**Tâche** : Audit sécurité complet prod
**Durée** : 3-4h
**Agents** : Agent Security + Agent DevOps
**Dépendances** : Aucune

**Justification** :
- Score dev 9.0/10, besoin validation prod
- Infrastructure production non auditée (Traefik, Docker, SSH)
- Détection précoce de vulnérabilités
- Non bloquant, peut attendre après urgences

**Déclencheur** : Après SESSIONS 2 & 3, quand l'utilisateur a 4h disponibles

---

## Planning Détaillé

### SESSION 1 : Fix Bug Production (URGENT)

**Fichier** : `tasks/2026-05-04_fix-cards-page-production.md`

**Phases** :
1. **Diagnostic Backend** (30min)
   - Consulter logs Docker backend
   - Tester endpoints API directement
   - Vérifier PostgreSQL connectivité
   - Vérifier variables d'environnement (JWT_SECRET, DB credentials)

2. **Diagnostic Frontend** (15min)
   - Consulter logs Docker frontend
   - Vérifier NEXT_PUBLIC_API_URL
   - Tester page depuis serveur

3. **Diagnostic Infrastructure** (15min)
   - Vérifier Traefik routing
   - Vérifier réseau Docker
   - Vérifier CORS

4. **Correction** (30-45min)
   - Appliquer le fix identifié
   - Redémarrer les services
   - Vérifier migrations SQL si nécessaire

5. **Validation** (15min)
   - Tester `/cards`, `/books`, `/dnd5`
   - Vérifier logs (pas d'erreurs)
   - Health checks

**Estimation** : 1h30-2h
**Risque** : Faible (diagnostic systématique)

---

### SESSION 2 : Séparation Données Environnement

**Fichier** : `tasks/2026-05-04_separation-donnees-environnement.md`

**Phases** :
1. **Audit données actuelles** (1h)
   - Inventaire migrations avec INSERT hardcodés
   - Identifier données test vs structure

2. **Création structure seeds** (1h)
   - Créer `seeds/dev/` et `seeds/prod/`
   - Extraire données de test vers seeds dev
   - Créer seed admin prod (1 user uniquement)

3. **Nettoyage migrations** (1h)
   - Supprimer INSERT des migrations
   - Garder uniquement DDL (CREATE TABLE)

4. **Scripts de seeding** (1h)
   - Créer `seed-dev.sh` (refuse si ENV=production)
   - Créer `seed-prod.sh` (refuse si ENV!=production)

5. **Mise à jour Docker Compose** (30min)
   - Configurer docker-compose.yml (dev)
   - Configurer docker-compose.prod.yml (prod)

6. **Tests et validation** (1-1.5h)
   - Tester en local (reset DB, redémarre avec seeds dev)
   - Tester en prod (vérifier seeds dev refusées)
   - Créer admin prod manuellement

**Estimation** : 5h-6h
**Risque** : Moyen (migration délicate, backup DB obligatoire)

**Règles de sécurité** :
- ❌ JAMAIS exécuter seeds dev en production
- ✅ TOUJOURS vérifier ENV avant seeds
- ✅ TOUJOURS backup DB avant intervention

---

### SESSION 3 : Scripts Déploiement

**Fichier** : `tasks/2026-05-04_scripts-deploiement-production.md`

**Phases** :
1. **Fonctions communes** (1h)
   - Créer `lib/common.sh` (logging, backup, health check)
   - Créer `lib/docker-utils.sh` (pull, stop, start, cleanup)

2. **Scripts déploiement** (1.5h)
   - Créer `deploy-frontend.sh`
   - Créer `deploy-backend.sh`
   - Créer `deploy-full.sh`

3. **Script rollback** (1h)
   - Créer `rollback.sh` (frontend, backend, full)
   - Tester restauration backup

4. **Scripts auxiliaires** (30min)
   - Créer `health-check.sh`
   - Créer `cleanup-images.sh`

5. **Tests et documentation** (1h)
   - Tester tous les scripts en staging/local
   - Créer `/DevOps/DEPLOYMENT.md`

**Estimation** : 4h-5h
**Risque** : Faible (tests en staging avant prod)

**Workflow type** :
```bash
# Check état
./scripts/deploy/health-check.sh

# Déploiement
sudo ./scripts/deploy/deploy-frontend.sh

# Si échec, rollback automatique
sudo ./scripts/deploy/rollback.sh frontend .deployment/backups/<timestamp>
```

---

### SESSION 4 : Audit Factorisation Collections

**Fichier** : `tasks/2026-05-04_audit-factorisation-collections.md`

**Phase 1 : Audit Backend** (3-4h) — Agent Backend

1. **Inventaire structures** (1h)
   - Tables, handlers, services, repositories pour MECCG, Books, DnD5
   - Documenter structure actuelle

2. **Analyse patterns communs** (1h)
   - Identifier code identique (parsing params, pagination, response format)
   - Identifier code similaire (filtres, tri)
   - Identifier code spécifique (domaine métier)

3. **Identification factorisations** (1h)
   - Proposer architecture générique (Generics + Interface)
   - Calculer métriques (réduction code estimée)
   - Identifier risques (sur-abstraction, complexité)

4. **Rapport** (1h)
   - Rapport structuré avec recommandations
   - Architecture cible détaillée
   - Plan de migration progressif

**Phase 2 : Audit Frontend** (3-4h) — Agent Frontend

1. **Inventaire composants** (1h)
   - Pages, composants, hooks, API clients pour les 3 collections

2. **Analyse patterns communs** (1h)
   - Structure pages identique ?
   - Hooks similaires ?
   - Composants Grid/Filters factorisables ?

3. **Identification factorisations** (1h)
   - Proposer architecture (Composition + Render Props)
   - Calculer métriques (réduction code estimée)

4. **Rapport** (1h)
   - Rapport structuré avec recommandations
   - Architecture cible détaillée
   - Plan de migration progressif

**Estimation** : 6h-8h (2 sessions)
**Risque** : Faible (audit uniquement, pas d'implémentation)

**Note** : Validation utilisateur requise avant SESSION 5 (implémentation)

---

### SESSION 5 : Implémentation Factorisation

**Déclencheur** : Après validation des rapports d'audit SESSION 4

**Contenu** : TBD après audits
**Estimation** : 6-10h (découpage en plusieurs sessions possibles)

---

### SESSION 6 : Audit Sécurité Production

**Fichier** : `tasks/2026-05-04_audit-securite-production.md`

**Phases** :
1. **Audit Infrastructure** (1.5h) — Agent DevOps
   - Docker (images, CVE, configuration)
   - Traefik (HTTPS, headers, rate limiting)
   - Serveur (SSH, firewall, mises à jour)

2. **Audit Application** (1h) — Agent Security
   - Authentification/autorisation
   - Injection SQL (tests)
   - Secrets management

3. **Audit Base de Données** (30min) — Agent DevOps
   - Accès réseau (PostgreSQL non exposé)
   - Permissions et credentials
   - Backups

4. **Tests automatisés** (30min) — Agent Security
   - Mozilla Observatory (headers HTTP)
   - SSL Labs (TLS config)
   - OWASP ZAP (vulnérabilités web)
   - Trivy (CVE Docker images)

5. **Rapport consolidé** (30min) — Agent Security
   - Score global /10
   - Vulnérabilités classées (CRITICAL, HIGH, MEDIUM, LOW)
   - Plan de remediation

**Estimation** : 4h
**Risque** : Faible (lecture seule, pas de modifications)

**Objectif** : Score ≥9.0/10 (comme en dev)

---

## Backlog Moyen Terme

Les tâches suivantes restent en backlog, sans urgence immédiate :

### Design & UX
- **Custom Icons Design System** (2-4h, MEDIUM)
  - Déclencheur : Après validation redesign mobile 2026-04-28
  - Objectif : Remplacer emojis par icônes custom Stitch
  - Fichier : `future-tasks/custom-icons-design-system.md`

- **Corrections Responsive Mobile** (2-4h, MEDIUM)
  - Déclencheur : Session dédiée planifiée
  - Objectif : Corriger problèmes affichage restants
  - Fichier : `future-tasks/responsive-fixes.md`

- **Toggle Confirmation Modal** (1h, LOW)
  - Objectif : Modal de confirmation pour actions critiques

### Fonctionnalités
- **Header Identité Utilisateur** (2-3h, LOW)
  - Objectif : Afficher user connecté dans header

- **Nettoyage Noms Français MECCG** (2-3h, MEDIUM)
  - Objectif : Supprimer noms français des cartes MECCG

- **Auth Avancée** (4-6h, MEDIUM)
  - Objectif : Refresh tokens, OAuth, 2FA

- **Stats Avancées** (3-5h, LOW)
  - Objectif : Graphiques, analytics collections

- **Wishlist** (4-6h, LOW)
  - Objectif : Liste de souhaits par collection

- **Import/Export** (4-6h, MEDIUM)
  - Objectif : Export CSV/JSON collections

### Architecture
- **Migration Kafka Activités** (3-5 jours, MEDIUM)
  - Déclencheur : 2+ services producteurs OU volume >10k activités/jour
  - Objectif : Architecture event-driven pour activités
  - Fichier : `future-tasks/migration-kafka-activities.md`

---

## Estimation Totale

### Par Priorité

| Priorité | Sessions | Durée Estimée |
|----------|----------|---------------|
| CRITIQUE | SESSION 1 | 1-2h |
| HAUTE | SESSION 2 & 3 | 7-10h |
| MEDIUM | SESSION 4, 5, 6 | 9-12h |
| **TOTAL** | **6 sessions** | **17-24h** |

### Par Agent

| Agent | Sessions | Durée Estimée |
|-------|----------|---------------|
| Agent DevOps | S1 (diagnostic), S2 (infra), S3 (scripts), S6 (audit infra) | 8-12h |
| Agent Backend | S1 (diagnostic), S2 (migrations), S4 (audit) | 6-9h |
| Agent Frontend | S4 (audit) | 3-4h |
| Agent Security | S6 (audit app + tests) | 1.5-2h |
| **TOTAL** | | **18.5-27h** |

### Timeline Estimée

**Si sessions de 4h régulières** :
- Semaine 1 : S1 (urgence 2h) + S2 (4h) + S3 (4h) = 10h
- Semaine 2 : S4 (4h) + début S6 (4h) = 8h
- Semaine 3 : Fin S6 (si nécessaire) + validation

**Total : 3 semaines** (avec sessions régulières de 4h)

**Si sessions irrégulières** :
- **4-6 semaines** (selon disponibilité utilisateur)

---

## Ordre de Priorité Recommandé

### Scénario A : Sessions Longues (4-6h)

```
Jour 1 : SESSION 1 (2h) + SESSION 2 (4-6h) = 6-8h
Jour 2 : SESSION 3 (3-4h)
Jour 3 : SESSION 4 (3-4h)
Jour 4 : SESSION 6 (3-4h)
```

**Total : 4 jours de travail**

### Scénario B : Sessions Courtes (2h)

```
Session 1 : S1 (2h) — URGENT
Session 2 : S2 Phase 1-2 (2h)
Session 3 : S2 Phase 3-5 (2h)
Session 4 : S2 Phase 6 (2h)
Session 5 : S3 Phase 1-2 (2h)
Session 6 : S3 Phase 3-5 (2h)
Session 7 : S4 Backend (2h)
Session 8 : S4 Backend suite (2h)
Session 9 : S4 Frontend (2h)
Session 10 : S4 Frontend suite (2h)
Session 11 : S6 Audit infra (2h)
Session 12 : S6 Audit app + tests (2h)
```

**Total : 12 sessions de 2h**

---

## Dépendances entre Tâches

```
SESSION 1 (Bug Prod) ──┬──> SESSION 2 (Séparation Données)
                       │
                       ├──> SESSION 3 (Scripts Déploiement)
                       │
                       ├──> SESSION 4 (Audit Factorisation)
                       │
                       └──> SESSION 6 (Audit Sécurité)

SESSION 4 (Audit) ─────────> SESSION 5 (Implémentation) [après validation]
```

**Parallelisation possible** :
- SESSION 2, 3, 4, 6 peuvent être faites en parallèle (aucune dépendance)
- SESSION 1 est bloquante pour TOUT le reste (production cassée)

---

## Risques Globaux

### Risque 1 : Bug production persiste
**Impact** : CRITIQUE
**Probabilité** : Faible
**Mitigation** : Diagnostic systématique, rollback si nécessaire

### Risque 2 : Sous-estimation durée
**Impact** : MEDIUM
**Probabilité** : Moyenne
**Mitigation** : Estimations hautes, découpage en phases courtes

### Risque 3 : Régressions lors des modifications
**Impact** : HIGH
**Probabilité** : Moyenne
**Mitigation** : Tests exhaustifs, backups systématiques, rollback automatique

### Risque 4 : Interruption longue entre sessions
**Impact** : MEDIUM
**Probabilité** : Moyenne
**Mitigation** : Documentation détaillée, STATUS.md à jour, reprise de contexte

---

## Métriques de Succès

### SESSION 1
- [ ] Page `/cards` fonctionne en production
- [ ] Aucune erreur dans logs backend/frontend
- [ ] Health checks OK

### SESSION 2
- [ ] Seeds dev ne s'exécutent JAMAIS en production
- [ ] 1 seul user admin en production
- [ ] Tests dev fonctionnent avec seeds de test

### SESSION 3
- [ ] Scripts de déploiement fonctionnels
- [ ] Rollback testé et fonctionnel
- [ ] Documentation complète

### SESSION 4
- [ ] Rapport audit backend complet
- [ ] Rapport audit frontend complet
- [ ] Architecture cible validée

### SESSION 6
- [ ] Score sécurité ≥9.0/10
- [ ] Plan de remediation priorisé
- [ ] Aucune vulnérabilité CRITICAL

---

## Prochaine Action Recommandée

**ACTION IMMÉDIATE** :
1. **Valider ce plan d'action** avec l'utilisateur
2. **Lancer SESSION 1** (Fix bug production) — URGENT
3. Après SESSION 1, proposer SESSION 2 ou SESSION 3 selon disponibilité

**QUESTIONS POUR L'UTILISATEUR** :
- [ ] Validation du plan d'action global ?
- [ ] Disponibilité pour SESSION 1 (URGENT, 2h) ?
- [ ] Préférence sessions longues (4-6h) ou courtes (2h) ?
- [ ] Validation de l'ordre des priorités (S1 → S2 → S3 → S4 → S6) ?

---

## Changelog

### 2026-05-04
- ✅ Création du plan d'action complet
- ✅ Identification des 5 nouvelles tâches
- ✅ Priorisation et séquencement
- ✅ Estimation des durées et ressources
- ✅ Création des 5 fichiers de tâches détaillés

---

**Maintenu par** : Agent Suivi de Projet
**Dernière Mise à Jour** : 2026-05-04
**Prochaine Réévaluation** : Après chaque session complétée
