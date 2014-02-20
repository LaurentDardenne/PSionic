#requires -version 2.0

#Write these line in the Windows PowerShell profile
# ."$env:PsIonicProfile\Tools\Profile_DevCodePlex.Ps1"
#Créez une variable d'environnement système nommée PsIonic pointant sur votre répertoire de travail
#Puis modifiez les lignes indiquées comme spécfiques au poste de  développement

$SM = [System.Environment+SpecialFolder]::MyDocuments
$PSProfile="$([System.Environment]::GetFolderPath($SM))\WindowsPowerShell"
$PSScripts=$PSProfile+"\Scripts"

$SvnPathRepository='G:\PS' # Spécifique au poste de développement
$ProjectName='PsIonic'

$PsVersion=$PSVersionTable.PsVersion

Set-Location "$SvnPathRepository\$ProjectName\Tools"

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

 #PSDrive sur le répertoire du projet 
$null=New-PsDrive -Scope Global -Name $PsIonic.ProjectName -PSProvider FileSystem -Root $PsIonicTrunk 

 #Crée une variable d'environnement utilisée dans 
 #le fichier de configuration Log4Net.Config.xml de dev
$env:PsionicLogPath= $PsIonicLogs
 
rv SM,Paths,ProjectName,SvnPathRepository
Set-Location ..
