#requires -version 2.0

#Write these lines of comments in the Windows PowerShell profile
#
# Instructions spécifique à une session
# 
# $SvnPathRepository='G:\PS' # à modifier
# $ProjectName='PsIonic'
# 
# Set-Location "$SvnPathRepository\$ProjectName\Trunk\Tools"
# 
#   #Pour cette hashtable on retarde la substitution, 
#  #car on référence des clés de la hashtable 'primaire'
# $Paths=@{
#  Bin='$($Properties.Trunk)\Bin'; #Debug et Release
#  Livraison='C:\Temp\$ProjectName'; # Spécifique au poste de dev, n'est pas versionné. 
#                                    # On construit la livraison à partir du référentiel SVN
#  Tests='$($Properties.Trunk)\Tests';
#  Tools='$($Properties.Trunk)\Tools';
#  Logs='C:\Temp\Logs\$ProjectName'
# }
# 
# . .\Profile_DevCodePlex.Ps1
# $PsIonic
# 
# Write-Host "Projet $ProjectName configuré." -Fore Green
# Set-Location ..
# rv Paths,ProjectName,SvnPathRepository
. .\New-ProjectVariable.ps1


$PsIonic=New-ProjectVariable $ProjectName  $SvnPathRepository 'https://psionic.svn.codeplex.com/svn' $Paths
$PsIonic.NewVariables() #Crée des variables constante d'après les clés de la hashtable $PsIonic

