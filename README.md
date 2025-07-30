# Script d'Installation WSL et Ubuntu sur Windows 11

## Description

Ce script PowerShell automatise l'installation complète de WSL 2 et Ubuntu sur Windows 11. Il gère toutes les conditions possibles et effectue l'installation de manière autonome.

## Fonctionnalités

- ✅ Vérification automatique des privilèges administrateur
- ✅ Vérification de la compatibilité Windows
- ✅ Activation automatique des fonctionnalités Windows nécessaires
- ✅ Téléchargement et installation du package de mise à jour du noyau Linux
- ✅ Configuration de WSL 2 comme version par défaut
- ✅ Installation automatique d'Ubuntu
- ✅ Configuration de l'utilisateur Ubuntu
- ✅ Vérification complète de l'installation
- ✅ Messages colorés pour une meilleure lisibilité
- ✅ Gestion d'erreurs robuste

## Prérequis

- Windows 10 version 2004 (build 19041) ou plus récent / Windows 11
- Privilèges administrateur
- Connexion Internet pour télécharger les composants

## Instructions d'utilisation

### 1. Téléchargement du script

Le script `install-wsl-ubuntu.ps1` a été créé sur votre Bureau.

### 2. Exécution du script

1. **Ouvrir PowerShell en tant qu'administrateur :**
   - Appuyez sur `Windows + X`
   - Sélectionnez "Windows PowerShell (Admin)" ou "Terminal (Admin)"

2. **Naviguer vers le répertoire du script :**
   ```powershell
   cd $env:USERPROFILE\Desktop
   ```

3. **Exécuter le script :**
   ```powershell
   .\install-wsl-ubuntu.ps1
   ```

### 3. Suivre les instructions

Le script vous guidera à travers le processus d'installation :

- Il vérifiera automatiquement votre système
- Il activera les fonctionnalités Windows nécessaires
- Il téléchargera et installera les composants requis
- Il installera Ubuntu
- Il vous demandera de configurer votre utilisateur Ubuntu

## Étapes du processus d'installation

1. **Vérification des prérequis**
   - Privilèges administrateur
   - Version de Windows compatible

2. **Activation des fonctionnalités Windows**
   - Plateforme de machine virtuelle
   - Sous-système Windows pour Linux (WSL)

3. **Installation du package de mise à jour du noyau Linux**
   - Téléchargement automatique depuis Microsoft
   - Installation silencieuse

4. **Configuration de WSL 2**
   - Définition de WSL 2 comme version par défaut

5. **Installation d'Ubuntu**
   - Téléchargement depuis le Microsoft Store ou winget
   - Installation automatique

6. **Configuration de l'utilisateur**
   - Lancement d'Ubuntu pour la première configuration
   - Création du nom d'utilisateur et mot de passe

7. **Vérification finale**
   - Contrôle du statut WSL
   - Affichage des distributions installées

## Utilisation après installation

Une fois l'installation terminée, vous pouvez utiliser Ubuntu de plusieurs façons :

### Via PowerShell/Terminal
```powershell
wsl
```

### Via le menu Démarrer
- Recherchez "Ubuntu" dans le menu Démarrer
- Cliquez sur l'icône Ubuntu

### Via Windows Terminal (recommandé)
- Installez Windows Terminal depuis le Microsoft Store
- Ajoutez Ubuntu comme profil dans Windows Terminal

## Commandes utiles WSL

```powershell
# Lister les distributions installées
wsl --list --verbose

# Vérifier le statut WSL
wsl --status

# Mettre à jour Ubuntu
wsl -d Ubuntu -e sudo apt update && sudo apt upgrade

# Arrêter WSL
wsl --shutdown

# Désinstaller une distribution
wsl --unregister Ubuntu
```

## Dépannage

### Problèmes courants

1. **Erreur de privilèges administrateur**
   - Solution : Exécuter PowerShell en tant qu'administrateur

2. **Erreur de version Windows**
   - Solution : Mettre à jour Windows vers une version compatible

3. **Erreur de téléchargement**
   - Solution : Vérifier la connexion Internet et réessayer

4. **Erreur d'installation d'Ubuntu**
   - Le script tentera automatiquement d'autres méthodes d'installation

### Logs et débogage

Le script affiche des messages colorés pour indiquer le statut :
- 🟢 **Vert** : Succès
- 🟡 **Jaune** : Avertissement ou information
- 🔴 **Rouge** : Erreur
- 🔵 **Cyan** : Information technique

## Support

Si vous rencontrez des problèmes :

1. Vérifiez que vous avez les privilèges administrateur
2. Assurez-vous d'avoir une connexion Internet stable
3. Redémarrez votre ordinateur si nécessaire
4. Vérifiez que Windows est à jour

## Notes importantes

- Le script nécessite un redémarrage pour finaliser l'installation
- Ubuntu sera configuré avec votre nom d'utilisateur et mot de passe
- WSL 2 utilise la virtualisation, assurez-vous que la virtualisation est activée dans le BIOS
- Le script est conçu pour fonctionner sur Windows 11 mais peut aussi fonctionner sur Windows 10 compatible

## Sécurité

- Le script télécharge uniquement des composants officiels de Microsoft
- Aucune donnée personnelle n'est collectée
- Le script ne modifie que les fonctionnalités Windows nécessaires pour WSL

---

**Auteur :** Assistant IA  
**Date :** $(Get-Date -Format "yyyy-MM-dd")  
**Version :** 1.0 