#Build.ps1
#Appel Psake 

Import-Module Psake

Set-Location $PsIonic.Tools

Invoke-psake .\Release.ps1

Write-Warning "Affiche le contenu de la variable `$PSake"
$psake
