# Script PowerShell pour installer WSL et Ubuntu sur Windows 11

# Fonction pour afficher les messages avec couleur
function Write-ColorOutput {
    param(
        [string]$Message,
        [string]$Color = "White"
    )
    Write-Host $Message -ForegroundColor $Color
}

# Fonction pour vérifier si l'utilisateur est administrateur
function Test-Administrator {
    $currentUser = [Security.Principal.WindowsIdentity]::GetCurrent()
    $principal = New-Object Security.Principal.WindowsPrincipal($currentUser)
    return $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

# Fonction pour vérifier la version de Windows
function Test-WindowsVersion {
    $osInfo = Get-ComputerInfo | Select-Object WindowsProductName, WindowsVersion
    Write-ColorOutput "Version Windows détectée: $($osInfo.WindowsProductName) $($osInfo.WindowsVersion)" "Cyan"
    
    # Vérifier si c'est Windows 10 ou 11
    $buildNumber = [System.Environment]::OSVersion.Version.Build
    if ($buildNumber -lt 19041) {
        Write-ColorOutput "ATTENTION: WSL 2 nécessite Windows 10 version 2004 (build 19041) ou plus récent" "Yellow"
        return $false
    }
    return $true
}

# Fonction pour activer les fonctionnalités Windows nécessaires
function Enable-WindowsFeatures {
    Write-ColorOutput "Activation des fonctionnalités Windows nécessaires..." "Yellow"
    
    try {
        # Activer la plateforme de machine virtuelle
        Write-ColorOutput "Activation de la plateforme de machine virtuelle..." "Cyan"
        Enable-WindowsOptionalFeature -Online -FeatureName VirtualMachinePlatform -All -NoRestart | Out-Null
        
        # Activer WSL
        Write-ColorOutput "Activation de WSL..." "Cyan"
        Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Windows-Subsystem-Linux -All -NoRestart | Out-Null
        
        Write-ColorOutput "Fonctionnalités activées avec succès!" "Green"
        return $true
    }
    catch {
        Write-ColorOutput "Erreur lors de l'activation des fonctionnalités: $($_.Exception.Message)" "Red"
        return $false
    }
}

# Fonction pour télécharger et installer le package de mise à jour du noyau Linux
function Install-LinuxKernelUpdate {
    Write-ColorOutput "Téléchargement et installation du package de mise à jour du noyau Linux..." "Yellow"
    
    try {
        $kernelUrl = "https://wslstorestorage.blob.core.windows.net/wslblob/wsl_update_x64.msi"
        $kernelPath = "$env:TEMP\wsl_update_x64.msi"
        
        Write-ColorOutput "Téléchargement en cours..." "Cyan"
        Invoke-WebRequest -Uri $kernelUrl -OutFile $kernelPath -UseBasicParsing
        
        Write-ColorOutput "Installation du package..." "Cyan"
        Start-Process msiexec.exe -Wait -ArgumentList "/I $kernelPath /quiet"
        
        Remove-Item $kernelPath -Force -ErrorAction SilentlyContinue
        Write-ColorOutput "Package de mise à jour du noyau Linux installé!" "Green"
        return $true
    }
    catch {
        Write-ColorOutput "Erreur lors de l'installation du package de mise à jour: $($_.Exception.Message)" "Red"
        return $false
    }
}

# Fonction pour définir WSL 2 comme version par défaut
function Set-WSL2Default {
    Write-ColorOutput "Configuration de WSL 2 comme version par défaut..." "Yellow"
    
    try {
        wsl --set-default-version 2
        Write-ColorOutput "WSL 2 défini comme version par défaut!" "Green"
        return $true
    }
    catch {
        Write-ColorOutput "Erreur lors de la configuration de WSL 2: $($_.Exception.Message)" "Red"
        return $false
    }
}

# Fonction pour installer Ubuntu
function Install-Ubuntu {
    Write-ColorOutput "Installation d'Ubuntu..." "Yellow"
    
    try {
        # Vérifier si Ubuntu est déjà installé
        $ubuntuInstalled = wsl --list --verbose 2>$null | Select-String "Ubuntu"
        
        if ($ubuntuInstalled) {
            Write-ColorOutput "Ubuntu est déjà installé!" "Green"
            return $true
        }
        
        # Installer Ubuntu depuis le Microsoft Store
        Write-ColorOutput "Téléchargement et installation d'Ubuntu depuis le Microsoft Store..." "Cyan"
        
        # Méthode alternative si le Microsoft Store n'est pas disponible
        $ubuntuUrl = "https://aka.ms/wslubuntu"
        $ubuntuPath = "$env:TEMP\Ubuntu.appx"
        
        Write-ColorOutput "Téléchargement d'Ubuntu..." "Cyan"
        Invoke-WebRequest -Uri $ubuntuUrl -OutFile $ubuntuPath -UseBasicParsing
        
        Write-ColorOutput "Installation d'Ubuntu..." "Cyan"
        Add-AppxPackage -Path $ubuntuPath
        
        Remove-Item $ubuntuPath -Force -ErrorAction SilentlyContinue
        
        Write-ColorOutput "Ubuntu installé avec succès!" "Green"
        return $true
    }
    catch {
        Write-ColorOutput "Erreur lors de l'installation d'Ubuntu: $($_.Exception.Message)" "Red"
        Write-ColorOutput "Tentative d'installation via winget..." "Yellow"
        
        try {
            winget install Canonical.Ubuntu
            Write-ColorOutput "Ubuntu installé via winget!" "Green"
            return $true
        }
        catch {
            Write-ColorOutput "Échec de l'installation via winget: $($_.Exception.Message)" "Red"
            return $false
        }
    }
}

# Fonction pour configurer l'utilisateur Ubuntu
function Initialize-UbuntuUser {
    Write-ColorOutput "Configuration de l'utilisateur Ubuntu..." "Yellow"
    
    try {
        # Lancer Ubuntu pour la première fois
        Write-ColorOutput "Lancement d'Ubuntu pour la configuration initiale..." "Cyan"
        Write-ColorOutput "Une fenêtre Ubuntu va s'ouvrir. Veuillez créer votre nom d'utilisateur et mot de passe." "Yellow"
        Write-ColorOutput "Appuyez sur Entrée pour continuer..." "Cyan"
        Read-Host
        
        wsl -d Ubuntu
        
        Write-ColorOutput "Configuration Ubuntu terminée!" "Green"
        return $true
    }
    catch {
        Write-ColorOutput "Erreur lors de la configuration d'Ubuntu: $($_.Exception.Message)" "Red"
        return $false
    }
}

# Fonction pour vérifier l'installation
function Test-WSLInstallation {
    Write-ColorOutput "Vérification de l'installation..." "Yellow"
    
    try {
        $wslStatus = wsl --status
        Write-ColorOutput "Statut WSL:" "Cyan"
        Write-ColorOutput $wslStatus "White"
        
        $wslList = wsl --list --verbose
        Write-ColorOutput "Distributions installées:" "Cyan"
        Write-ColorOutput $wslList "White"
        
        return $true
    }
    catch {
        Write-ColorOutput "Erreur lors de la vérification: $($_.Exception.Message)" "Red"
        return $false
    }
}

# Fonction principale
function Install-WSLAndUbuntu {
    Write-ColorOutput "=== Installation de WSL et Ubuntu sur Windows 11 ===" "Magenta"
    Write-ColorOutput "Ce script va installer WSL 2 et Ubuntu automatiquement." "White"
    Write-ColorOutput ""
    
    # Vérifier les privilèges administrateur
    if (-not (Test-Administrator)) {
        Write-ColorOutput "ERREUR: Ce script nécessite des privilèges administrateur!" "Red"
        Write-ColorOutput "Veuillez exécuter PowerShell en tant qu'administrateur." "Yellow"
        return $false
    }
    
    # Vérifier la version de Windows
    if (-not (Test-WindowsVersion)) {
        Write-ColorOutput "ERREUR: Version de Windows non compatible!" "Red"
        return $false
    }
    
    # Activer les fonctionnalités Windows
    if (-not (Enable-WindowsFeatures)) {
        Write-ColorOutput "ERREUR: Impossible d'activer les fonctionnalités Windows!" "Red"
        return $false
    }
    
    # Installer le package de mise à jour du noyau
    if (-not (Install-LinuxKernelUpdate)) {
        Write-ColorOutput "ERREUR: Impossible d'installer le package de mise à jour!" "Red"
        return $false
    }
    
    # Définir WSL 2 comme version par défaut
    if (-not (Set-WSL2Default)) {
        Write-ColorOutput "ERREUR: Impossible de configurer WSL 2!" "Red"
        return $false
    }
    
    # Installer Ubuntu
    if (-not (Install-Ubuntu)) {
        Write-ColorOutput "ERREUR: Impossible d'installer Ubuntu!" "Red"
        return $false
    }
    
    # Configurer l'utilisateur Ubuntu
    if (-not (Initialize-UbuntuUser)) {
        Write-ColorOutput "ERREUR: Impossible de configurer l'utilisateur Ubuntu!" "Red"
        return $false
    }
    
    # Vérifier l'installation
    if (-not (Test-WSLInstallation)) {
        Write-ColorOutput "ERREUR: Problème lors de la vérification de l'installation!" "Red"
        return $false
    }
    
    Write-ColorOutput ""
    Write-ColorOutput "=== Installation terminée avec succès! ===" "Green"
    Write-ColorOutput "WSL 2 et Ubuntu ont été installés correctement." "White"
    Write-ColorOutput "Pour utiliser Ubuntu, tapez 'wsl' dans PowerShell ou ouvrez Ubuntu depuis le menu Démarrer." "Cyan"
    Write-ColorOutput ""
    Write-ColorOutput "Redémarrage recommandé pour finaliser l'installation." "Yellow"
    
    $restart = Read-Host "Voulez-vous redémarrer maintenant? (O/N)"
    if ($restart -eq "O" -or $restart -eq "o") {
        Restart-Computer -Force
    }
    
    return $true
}

# Exécution du script principal
try {
    Install-WSLAndUbuntu
}
catch {
    Write-ColorOutput "Erreur fatale: $($_.Exception.Message)" "Red"
    Write-ColorOutput "Veuillez vérifier les logs et réessayer." "Yellow"
} 
