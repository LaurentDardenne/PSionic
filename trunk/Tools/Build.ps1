#Build.ps1
#Appel Psake 

Import-Module Psake

Set-Location $PsIonic.Trunk
 #Affiche les dépendances des tâches sans exécuter le script
Invoke-psake .\Release.ps1 -doc

 #Exécuter les tâches du  script
Invoke-psake .\Release.ps1

Write-Warning "Affiche le contenu de la variable `$PSake"
$psake
