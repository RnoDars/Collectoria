# Future Tasks - Tâches Futures Collectoria

Ce répertoire contient les tâches et améliorations planifiées pour le futur, avec des déclencheurs et plans d'action détaillés.

---

## Philosophie

**"Don't over-engineer for scale you don't have yet"**

Les tâches ici sont :
- 📋 **Documentées** : Plan détaillé prêt à l'emploi
- 🎯 **Déclencheurs définis** : Critères objectifs pour démarrer
- ⏱️ **Estimées** : Effort et planning
- 🔄 **Réévaluées** : Périodiquement

**Principe** : Ces tâches ne sont PAS urgentes. Elles seront déclenchées quand les besoins réels les justifient.

---

## Index des Tâches Futures

### Design & UX

#### Custom Icons Design System
- **Fichier** : `custom-icons-design-system.md`
- **Priorité** : MEDIUM (après validation redesign mobile)
- **Effort** : 2-4 heures
- **Contexte** : Session mobile redesign 2026-04-28

**Objectif** : Remplacer les icônes emoji Unicode (🏠🎴📚🎲) par un jeu d'icônes custom SVG cohérent avec "The Digital Curator" design system.

**Problème** : Emojis actuels ont rendu inconsistant selon OS/browser, pas de cohérence design system, qualité visuelle limitée.

**Solution** : Demander à Stitch génération d'icônes custom SVG (line icons + filled variants) alignées avec design system Collectoria.

**Déclencheurs** (démarrer après validation redesign mobile) :
- [x] Redesign mobile 2026-04-28 appliqué
- [ ] Score design mobile confirmé 95+/100
- [ ] Utilisateur approuve priorité
- [ ] Temps disponible : 2-4 heures

**Bénéfices** :
- Rendu consistent tous OS/browsers
- 100% cohérent design system
- Score design mobile : +5-10 points potentiel
- Identité visuelle unique

**Réévaluation** : Après validation redesign mobile 2026-04-28

---

### Architecture

#### Migration Kafka Activités
- **Fichier** : `migration-kafka-activities.md`
- **Priorité** : MEDIUM (après MVP)
- **Effort** : 3-5 jours
- **ADR Référence** : `decisions/2026-04-21_activities-architecture-choice.md`

**Objectif** : Migrer l'architecture des activités récentes vers Kafka event-driven.

**Architecture Actuelle (Phase 1)** :
```
Collection Management → activities table → API
```

**Architecture Cible (Phase 2)** :
```
Collection Service → Kafka Topic → Activity Service → API
                                 ↓ Notification Service
                                 ↓ Analytics Service
```

**Déclencheurs** (migrer quand 2+ conditions remplies) :
- [ ] 2+ services producteurs d'événements
- [ ] Volume > 10,000 activités/jour
- [ ] Besoin notifications temps réel
- [ ] Besoin audit trail durable
- [ ] Problèmes de scalabilité observés

**Réévaluation** : Tous les 2-3 mois

**Contenu** :
- Infrastructure (Kafka + Zookeeper)
- Développement Activity Service
- Producer Kafka
- Tests (unit, integration, charge)
- Migration données historiques
- DevOps (Docker, CI/CD, monitoring)
- Documentation

**Bénéfices** :
- Découplage complet entre services
- Scalabilité horizontale
- Résilience (buffer des événements)
- Base pour notifications temps réel
- Base pour analytics avancées

**Risques** :
- Complexité opérationnelle (Kafka)
- Monitoring nécessaire
- Schema evolution

**Migration** : Stratégie en 4 phases documentée (Préparation, Double-write, Bascule, Nettoyage)

---

## Tâches à Ajouter

### Design & UX
- [x] Custom Icons Design System (documenté 2026-04-28)

### Sécurité
- [ ] Migration vers HTTPS (Let's Encrypt)
- [ ] Implementation WAF (Web Application Firewall)
- [ ] Backup & Disaster Recovery complet

### Performance
- [ ] Cache Redis pour collections
- [ ] CDN pour images de cartes
- [ ] Optimisation requêtes SQL (EXPLAIN ANALYZE)

### Fonctionnalités
- [ ] Search avancé (Elasticsearch)
- [ ] Export PDF de collection
- [ ] Import CSV bulk
- [ ] Wishlist collaborative
- [ ] Marketplace (échange de cartes)

### DevOps
- [ ] Migration Kubernetes (si scaling nécessaire)
- [ ] Multi-région deployment
- [ ] Blue-Green deployment
- [ ] Canary releases

### Analytics
- [ ] Dashboard admin (métriques, users, collections)
- [ ] A/B testing framework
- [ ] User behavior tracking (respectueux RGPD)

---

## Template de Tâche Future

```markdown
# TODO : [Nom de la Tâche]

**Priorité** : LOW | MEDIUM | HIGH
**Effort estimé** : X jours
**Dépendances** : [Liste]
**ADR Référence** : [Si applicable]

## Objectif
[Description claire de ce qu'on veut accomplir]

## Déclencheurs
Réévaluer tous les X mois. Démarrer quand Y conditions sont remplies :
- [ ] Condition 1
- [ ] Condition 2
- [ ] Condition 3

## Architecture Actuelle
[État actuel du système]

## Architecture Cible
[État désiré après implémentation]

## Tâches
### Phase 1 : [Nom] (X jours)
- [ ] Tâche 1
- [ ] Tâche 2

### Phase 2 : [Nom] (Y jours)
- [ ] Tâche 3
- [ ] Tâche 4

## Bénéfices Attendus
- Bénéfice 1
- Bénéfice 2

## Risques
- Risque 1 → Mitigation
- Risque 2 → Mitigation

## Stratégie de Migration/Déploiement
[Plan détaillé de bascule]

## Références
- Lien 1
- Lien 2

## Notes
[Contexte additionnel]
```

---

## Workflow

### Ajouter une Nouvelle Tâche Future

1. **Identifier le besoin** (mais pas urgent)
2. **Créer le fichier** avec le template ci-dessus
3. **Définir les déclencheurs** objectifs
4. **Estimer l'effort** réaliste
5. **Documenter le plan** complet
6. **Mettre à jour ce README**

### Réévaluer une Tâche Future

**Fréquence** : Tous les 2-3 mois ou quand nouvelle fonctionnalité majeure

**Checklist** :
- [ ] Vérifier les déclencheurs
- [ ] Réévaluer la priorité
- [ ] Mettre à jour l'estimation
- [ ] Ajuster le plan si nécessaire

**Décision** :
- Si déclencheurs atteints → Déplacer vers `tasks/` (action immédiate)
- Sinon → Garder ici et réévaluer plus tard

### Démarrer une Tâche Future

Quand les déclencheurs sont atteints :

1. **Déplacer** : `future-tasks/X.md` → `tasks/X-implementation.md`
2. **Créer sprint** : Ajouter dans `tasks/SPRINT-N.md`
3. **Assigner agent** : Backend, Frontend, DevOps, etc.
4. **Suivre** : Comme toute autre tâche

---

## Statistiques

| Catégorie | Nombre de Tâches | Effort Total |
|-----------|------------------|--------------|
| Design & UX | 1 | 2-4 heures |
| Architecture | 1 | 3-5 jours |
| Sécurité | 0 | - |
| Performance | 0 | - |
| Fonctionnalités | 0 | - |
| DevOps | 0 | - |
| **TOTAL** | **2** | **3.5-5.5 jours** |

---

## Historique des Tâches

### Tâches Déplacées vers Action Immédiate

_Aucune pour l'instant_

### Tâches Annulées

_Aucune pour l'instant_

---

## Références

- ADR : `../decisions/`
- Tâches Actives : `../tasks/`
- Rapports : `../reports/`

---

## Changelog

### 2026-04-28
- ✅ Ajouté : Custom Icons Design System (2-4h, MEDIUM)
  - Contexte : Redesign mobile session
  - Problème : Emojis Unicode inconsistents
  - Solution : SVG custom alignés design system

### 2026-04-21
- ✅ Ajouté : Migration Kafka Activités (3-5 jours, MEDIUM)
  - Contexte : ADR-002 architecture activités
  - Solution : Event-driven architecture

---

**Dernière Mise à Jour** : 2026-04-28  
**Maintenu par** : Agent Suivi de Projet  
**Prochaine Réévaluation** : 2026-06-28
