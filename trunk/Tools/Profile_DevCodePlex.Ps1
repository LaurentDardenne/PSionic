#requires -version 2.0

. .\New-ProjectVariable.ps1


$PsIonic=New-ProjectVariable $ProjectName  $SvPathRepository 'https://psionic.svn.codeplex.com/svn' $Paths
$PsIonic.NewVariables() #Crée des variables constante d'après les clées de la hashtable $PsIonic

