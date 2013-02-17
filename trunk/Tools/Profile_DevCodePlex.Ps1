#requires -version 2.0

#Write these line in the Windows PowerShell profile
# ."$env:PsIonic\Tools\Profile_DevCodePlex.Ps1"
#Puis créez une variable d'environnement système nommée PsIonic pointant sur votre répertoire de travail

$SM = [System.Environment+SpecialFolder]::MyDocuments
$PSProfile="$([System.Environment]::GetFolderPath($SM))\WindowsPowerShell"
$PSScripts=$PSProfile+"\Scripts"

$SvnPathRepository='G:\PS' # Spécifique au poste de développement
$ProjectName='PsIonic'

$PsVersion=$PSVersionTable.PsVersion

Set-Location "$SvnPathRepository\$ProjectName\Trunk\Tools"

  #Pour cette hashtable on retarde la substitution, 
 #car on référence des clés de la hashtable 'primaire'
$Paths=@{
 Bin='$($Properties.Trunk)\Bin'; #Debug et Release
 Livraison='C:\Temp\$ProjectName'; # Spécifique au poste de développement, n'est pas versionné. 
                                   # On construit la livraison à partir du référentiel SVN
 Tests='$($Properties.Trunk)\Tests';
 Tools='$($Properties.Trunk)\Tools';
 Help='$($Properties.Trunk)\Documentation\Helps';
 Setup='$($Properties.Trunk)\Setup';
 Logs='C:\Temp\Logs\$ProjectName'   # Spécifique au poste de développement
}

. .\New-ProjectVariable.ps1

$PsIonic=New-ProjectVariable $ProjectName  $SvnPathRepository 'https://psionic.svn.codeplex.com/svn' $Paths
$PsIonic.NewVariables() #Crée des variables constante d'après les clés de la hashtable $PsIonic

rv SM,Paths,ProjectName,SvnPathRepository
Set-Location ..
