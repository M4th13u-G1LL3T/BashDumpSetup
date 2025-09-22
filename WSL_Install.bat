@echo off
:: Vérifie si le script est lancé en tant qu'administrateur
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo Ce script doit être exécuté en tant qu'administrateur.
    powershell -Command "Start-Process '%~f0' -Verb RunAs"
    exit /b
)

:: Active les fonctionnalités nécessaires via PowerShell
powershell -NoProfile -ExecutionPolicy Bypass -Command ^
"Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V -All -NoRestart; ^
 Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Windows-Subsystem-Linux -All -NoRestart; ^
 Enable-WindowsOptionalFeature -Online -FeatureName VirtualMachinePlatform -All -NoRestart"

:: Programme l'installation d'Ubuntu au redémarrage
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnce" /v InstallUbuntuWSL /t REG_SZ /d "cmd.exe /c wsl.exe --set-default-version 2 && wsl.exe --install -d Ubuntu" /f

echo ✅ Les fonctionnalités sont activées. Le PC va redémarrer pour finaliser l'installation.
shutdown /r /t 5 /c "Redémarrage pour finaliser l'installation WSL/Hyper-V" /f

exit /b