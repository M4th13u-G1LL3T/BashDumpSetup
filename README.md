## Script d'installation WSL et Ubuntu sous Windows

Ce dossier contient le script `WSL_Install.bat` qui automatise l'activation des fonctionnalités Windows nécessaires à WSL2, planifie l'installation d'Ubuntu au prochain redémarrage, puis redémarre la machine.

### Ce que fait le script
- Active les fonctionnalités Windows suivantes sans redémarrage immédiat:
  - Microsoft-Hyper-V
  - Microsoft-Windows-Subsystem-Linux (WSL)
  - VirtualMachinePlatform
- Programme via `RunOnce` l'exécution au prochain démarrage de:
  - `wsl.exe --set-default-version 2`
  - `wsl.exe --install -d Ubuntu`
- Déclenche un redémarrage automatique pour finaliser l'activation des fonctionnalités.

### Prérequis
- Windows 10 version 2004 (build 19041) ou plus récent, ou Windows 11.
- Droits administrateur sur la machine.
- Connexion Internet pour télécharger les composants WSL et la distribution Ubuntu.

### Utilisation
1. Ouvrez une invite de commandes en tant qu'administrateur.
2. Naviguez dans le dossier du script et exécutez:
   ```bat
   WSL_Install.bat
   ```
3. Le PC redémarre automatiquement après l'activation des fonctionnalités.
4. Au redémarrage, l'installation WSL/Ubuntu démarre automatiquement (fenêtre console Windows). Suivez les instructions (création d'utilisateur Linux, etc.).

### Vérifications et dépannage
- Vérifier que WSL par défaut est bien en version 2:
  ```bat
  wsl.exe -l -v
  ```
  Ubuntu doit apparaître avec la colonne `VERSION` à `2`.
- Si l'installation d'Ubuntu ne démarre pas au redémarrage, vous pouvez la lancer manuellement:
  ```bat
  wsl.exe --set-default-version 2
  wsl.exe --install -d Ubuntu
  ```
- Pour vérifier/retirer l'entrée `RunOnce` manuellement (avancé):
  - Clé: `HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnce`
  - Valeur: `InstallUbuntuWSL`

### Téléchargement de Safe Exam Browser
Pour les besoins d'examen sécurisé, vous pouvez télécharger Safe Exam Browser (SEB) depuis la page officielle des téléchargements:

- [Télécharger Safe Exam Browser](https://safeexambrowser.org/download_en.html)

Consultez la documentation fournie sur cette page pour choisir la version adaptée à votre système (Windows, macOS, iOS) et suivre les bonnes pratiques d'installation et de configuration.

### Notes
- Le script doit impérativement être exécuté en tant qu'administrateur; sinon, il se relancera avec élévation de privilèges.
- Le redémarrage est nécessaire pour finaliser l'activation des fonctionnalités Windows.
- Selon la politique réseau/pare-feu de votre organisation, le téléchargement d'Ubuntu via WSL peut être filtré.
