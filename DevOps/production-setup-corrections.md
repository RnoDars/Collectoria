# Corrections à Apporter au Guide production-setup.md

**Date** : 2026-04-28  
**Contexte** : Session de déploiement Scaleway - Retour d'expérience Phase 1+2

---

## Vue d'Ensemble

Ce document recense les corrections à apporter au guide `production-setup.md` suite à l'expérience réelle du déploiement sur serveur Scaleway Debian 13.

**Statut** : ⏸️ Corrections à appliquer avant prochaine utilisation du guide

---

## Correction 1 : Utiliser `apt` au lieu de `apt-get`

### Localisation
- Section 1.1 "Provisioning initial du serveur"
- Lignes 39-40

### Problème
Le guide utilise `apt-get`, qui est déprécié. Debian 13 recommande l'utilisation de `apt`.

### Correction à Appliquer

**Ancien (ligne 39-40)** :
```bash
apt update && apt upgrade -y
apt install -y curl wget git ufw fail2ban unattended-upgrades apt-listchanges
```

**Nouveau (recommandé)** :
```bash
apt update && apt upgrade -y
apt install -y curl wget git ufw fail2ban unattended-upgrades apt-listchanges
```

**Résultat** : Pas de changement nécessaire ici (apt déjà utilisé)

### Vérification
Vérifier que toutes les occurrences de `apt-get` dans le document sont remplacées par `apt`.

```bash
# Rechercher les occurrences de apt-get
grep -n "apt-get" production-setup.md
```

**Impact** : Cosmétique uniquement, pas d'impact fonctionnel.

---

## Correction 2 : Adapter le Dépôt Docker pour Debian (au lieu d'Ubuntu)

### Localisation
- Section 2.1 "Docker Engine"
- Lignes 223-232

### Problème
Le guide est écrit pour Ubuntu, mais le déploiement a été fait sur Debian 13. L'URL du dépôt Docker doit être adaptée.

### Correction à Appliquer

**Ancien (lignes 223-232)** :
```bash
# Clé GPG Docker officielle
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | \
  sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg

# Dépôt Docker stable
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] \
  https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
```

**Nouveau (recommandé - séparation en 4 commandes distinctes + adaptation Debian)** :

```bash
# Clé GPG Docker officielle
sudo install -m 0755 -d /etc/apt/keyrings

# Télécharger et installer la clé GPG (adapter selon OS)
# Pour Debian :
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

# Pour Ubuntu :
# curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

sudo chmod a+r /etc/apt/keyrings/docker.gpg

# Ajouter le dépôt Docker stable (adapter selon OS)
# Pour Debian :
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Pour Ubuntu :
# echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
```

### Raison de la Séparation en 4 Commandes

**Problème rencontré** : Lors du copier-coller d'une commande multi-lignes (backslash `\`), le terminal peut interpréter incorrectement les sauts de ligne, causant une exécution partielle ou une erreur.

**Solution** : Séparer en commandes distinctes, chacune sur une ligne, pour assurer l'exécution complète même en copier-coller.

**Impact** : Évite les erreurs d'exécution lors du provisioning manuel.

---

## Correction 3 : Ajouter Note sur Bloc Multi-Lignes

### Localisation
- Section 2.1 "Docker Engine"
- Avant la section "Dépôt Docker stable"

### Correction à Appliquer

Ajouter un encadré d'avertissement avant les commandes Docker :

```markdown
> **⚠️ Note importante pour copier-coller**
> 
> Les commandes ci-dessous sont séparées en blocs distincts pour éviter les problèmes de copier-coller. 
> Exécutez chaque commande individuellement dans l'ordre indiqué.
> 
> Évitez de copier-coller des commandes multi-lignes avec backslash (\) car elles peuvent être mal interprétées par le terminal.
```

**Impact** : Évite la confusion et les erreurs lors du provisioning manuel.

---

## Correction 4 : Ajouter Section Troubleshooting

### Localisation
Nouvelle section à ajouter après "12. Procédure de mise à jour"

### Contenu à Ajouter

```markdown
---

## 13. Troubleshooting — Problèmes Courants

### 13.1 Commande Multi-Ligne Non Exécutée

**Symptôme** : Une commande avec backslash `\` ne s'exécute pas complètement lors du copier-coller.

**Cause** : Le terminal interprète mal les sauts de ligne.

**Solution** : Séparer la commande en plusieurs commandes distinctes, chacune sur une ligne.

**Exemple** :
```bash
# ❌ Problématique (copier-coller peut échouer)
echo \
  "longue commande sur \
  plusieurs lignes" | \
  sudo tee fichier.txt

# ✅ Recommandé (fonctionne toujours)
COMMAND="longue commande sur plusieurs lignes"
echo "$COMMAND" | sudo tee fichier.txt
```

---

### 13.2 Dépôt Docker Non Trouvé (404)

**Symptôme** : `sudo apt update` retourne une erreur 404 sur `download.docker.com`.

**Cause** : Mauvaise URL de dépôt (ubuntu au lieu de debian, ou inversement).

**Solution** : Vérifier l'OS et adapter l'URL :

```bash
# Identifier l'OS
cat /etc/os-release

# Pour Debian
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | sudo tee /etc/apt/sources.list.d/docker.list

# Pour Ubuntu
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | sudo tee /etc/apt/sources.list.d/docker.list
```

---

### 13.3 Fichier docker.list Non Créé

**Symptôme** : Après la commande `echo ... | sudo tee`, le fichier `/etc/apt/sources.list.d/docker.list` n'existe pas.

**Cause** : Commande `tee` mal exécutée ou interrompue.

**Solution** : Forcer la création avec vérification :

```bash
# Créer le fichier explicitement
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Vérifier la création
cat /etc/apt/sources.list.d/docker.list
```

---

### 13.4 fail2ban Ne Démarre Pas

**Symptôme** : `systemctl start fail2ban` échoue avec erreur de configuration.

**Cause** : Erreur de syntaxe dans `/etc/fail2ban/jail.local`.

**Solution** : Valider la syntaxe du fichier de configuration :

```bash
# Tester la configuration
sudo fail2ban-client -t

# Voir les erreurs de syntaxe
sudo journalctl -u fail2ban -n 50
```

---
```

**Impact** : Facilite le dépannage lors du provisioning et évite la perte de temps.

---

## Correction 5 : Ajouter Note sur Spécifications Matérielles Scaleway

### Localisation
- En-tête du document (ligne 3-5)

### Problème
Le guide mentionne "OVH VPS-1 · Ubuntu 24.10 · 4 vCore · 8 Go RAM · 75 Go SSD NVMe", mais le déploiement a été fait sur Scaleway avec Debian 13 et spécifications différentes.

### Correction à Appliquer

**Ancien (ligne 3-5)** :
```markdown
**Serveur cible** : OVH VPS-1 · Ubuntu 24.10 · 4 vCore · 8 Go RAM · 75 Go SSD NVMe  
**Dernière mise à jour** : 2026-04-26  
**Stack** : Go (microservices) + Next.js + PostgreSQL + Docker Compose + Traefik v3
```

**Nouveau (recommandé)** :
```markdown
**Serveur cible** : Cloud VPS (OVH, Scaleway, etc.)  
**OS supportés** : Debian 13 (trixie), Ubuntu 24.10 ou supérieur  
**Spécifications minimales** : 2 vCore · 4 Go RAM · 40 Go SSD  
**Dernière mise à jour** : 2026-04-28  
**Stack** : Go (microservices) + Next.js + PostgreSQL + Docker Compose + Traefik v3

> **Note** : Ce guide est compatible avec Debian 13 et Ubuntu 24.10. Adaptez les URLs de dépôt Docker selon votre distribution (voir section 2.1).
```

**Impact** : Rend le guide plus générique et applicable à plusieurs providers cloud.

---

## Correction 6 : Ajouter Checklist Pré-Provisioning

### Localisation
Nouvelle section à ajouter après l'en-tête, avant "Table des matières"

### Contenu à Ajouter

```markdown
---

## Checklist Pré-Provisioning

Avant de commencer le provisioning, assurez-vous d'avoir :

- [ ] Accès SSH au serveur (IP + mot de passe root)
- [ ] Clé SSH publique ED25519 ou RSA générée sur votre machine locale
- [ ] Nom de domaine acheté (recommandé, nécessaire pour Traefik)
- [ ] Adresse email valide (pour Let's Encrypt)
- [ ] Gestionnaire de mots de passe pour stocker les credentials
- [ ] Accès à la console web du provider (OVH, Scaleway, etc.) en cas d'urgence
- [ ] Temps estimé : 1h30 pour provisioning complet (Phase 1 à 4)

**OS supportés** :
- ✅ Debian 13 (trixie) — Testé le 2026-04-28
- ✅ Ubuntu 24.10 — Documentation originale
- ⚠️ Autres distributions : nécessitent adaptation des URLs de dépôt

---
```

**Impact** : Évite de démarrer le provisioning sans tous les prérequis, gagne du temps.

---

## Résumé des Corrections

| # | Section | Type | Priorité | Impact |
|---|---------|------|----------|--------|
| 1 | 1.1 | Clarification | Faible | Cosmétique |
| 2 | 2.1 | Adaptation OS | **Haute** | Fonctionnel (bloquant si mauvais OS) |
| 3 | 2.1 | Note copier-coller | Moyenne | Prévention d'erreurs |
| 4 | Nouvelle | Troubleshooting | Haute | Dépannage |
| 5 | En-tête | Généralisation | Moyenne | Clarté |
| 6 | Avant TOC | Checklist | Haute | Prévention d'oublis |

---

## Actions à Effectuer

### Immédiat (Avant Prochaine Utilisation)
1. ✅ Créer ce document (production-setup-corrections.md)
2. ⏸️ Appliquer Correction 2 (adaptation Debian/Ubuntu) — **PRIORITÉ HAUTE**
3. ⏸️ Appliquer Correction 4 (section Troubleshooting) — **PRIORITÉ HAUTE**
4. ⏸️ Appliquer Correction 6 (checklist pré-provisioning) — **PRIORITÉ HAUTE**

### Court Terme
5. ⏸️ Appliquer Correction 3 (note copier-coller)
6. ⏸️ Appliquer Correction 5 (généralisation en-tête)
7. ⏸️ Relecture complète du document pour cohérence

### Validation
8. ⏸️ Tester le guide mis à jour sur une nouvelle machine Debian 13
9. ⏸️ Tester le guide mis à jour sur une nouvelle machine Ubuntu 24.10
10. ⏸️ Documenter les résultats des tests

---

## Méthode de Mise à Jour

Pour chaque correction :

1. Localiser la section dans `production-setup.md`
2. Lire le contexte (5 lignes avant et après)
3. Appliquer la correction avec l'outil Edit
4. Vérifier la syntaxe Markdown
5. Cocher la correction dans ce document

---

## Références

- **Guide original** : `/home/arnaud.dars/git/Collectoria/DevOps/production-setup.md`
- **Progression déploiement** : `/home/arnaud.dars/git/Collectoria/DevOps/production-deployment-progress.md`
- **Infos serveur** : `/home/arnaud.dars/git/Collectoria/DevOps/scaleway-server-info.md`
- **Session de déploiement** : 2026-04-28 (Phase 1+2 terminées)

---

*Document créé par l'Agent DevOps - Date : 2026-04-28*
*Ce document est un plan d'action, pas une documentation finale. Une fois les corrections appliquées, ce fichier peut être archivé.*
