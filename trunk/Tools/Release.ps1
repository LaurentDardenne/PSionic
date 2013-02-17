#Release.ps1
#Construit la version Release via Psake

Include "$PsIonicTools\Common.ps1"

Task default -Depends Delivery,CompilePsIonicTools,BuildXmlHelp

Task Delivery -Depends Clean,RemoveConditionnal {
#Recopie les fichiers dans le répertoire de livraison  
  
   $VerbosePreference='Continue'
#DLL
   Copy "$PsIonicTrunk\Log4Net.Config.xml" "$PsIonicLivraison"
   Copy "$PsIonicBin\${Configuration}\log4net\2.0\log4net.dll" "$PsIonicLivraison\2.0"  
   Copy "$PsIonicBin\${Configuration}\log4net\4.0\log4net.dll" "$PsIonicLivraison\3.0" 
#lg4N config
# on copie la config de dev nécessaire au build. 
#todo Le setup doit la reconfigurer le chemin des logs.
   Copy "$PsIonicTrunk\Log4Net.Config.xml" "$PsIonicLivraison"

   Copy "$PsIonicBin\${Configuration}\Ionic.Zip.dll" "$PsIonicLivraison"
# PSIonicTools.dll est compilé d'aprés la version PS courante
   
   if  ($Configuration -eq "Debug")
   { Copy "$PsIonicBin\${Configuration}\Ionic.Zip.pdb" "$PsIonicLivraison" }

#Doc xml localisée
   Copy "$PsIonicTrunk\en-US" "$PsIonicLivraison\en-US" -Recurse
   Copy "$PsIonicTrunk\fr-FR" "$PsIonicLivraison\fr-FR" -Recurse
   Copy "$PsIonicTrunk\Demo" "$PsIonicLivraison\Demo" -Recurse
   Copy "$PsIonicTrunk\FormatData" "$PsIonicLivraison\FormatData" -Recurse
   Copy "$PsIonicTrunk\TypeData" "$PsIonicLivraison\TypeData" -Recurse

#Licence
   Copy "$PsIonicTrunk\Documentation\Licence"  "$PsIonicLivraison\Documentation\Licence" -Recurse 
   Copy "$PsIonicTrunk\Documentation\DotNetZip-Documentation-v1.9.zip"  "$PsIonicLivraison\Documentation"
   Copy "$PsIonicTrunk\Licence-PsIonicModule.txt" "$PsIonicLivraison" 

#Module
   Copy "$PsIonicTrunk\PsIonic.psd1" "$PsIonicLivraison"
   if ($Config -eq "Debug")
   { Copy "$PsIonicTrunk\PsIonic.psm1" "$PsIonicLivraison" }
   #else  PsIonic.psm1 est créé par la tâche RemoveConditionnal 
   
#Setup
   Copy "$PsIonicTrunk\Setup\PsIonicSetup.ps1" "$PsIonicLivraison"

#Other todo
   #Copy "$PsIonicTrunk\Revisions.txt" "$PsIonicLivraison"
} #Delivery

Task RemoveConditionnal { return $Config -ne "Debug" } {
#Supprime les lignes de code de Debug et de test
     
   $VerbosePreference='Continue'
   Write-Verbose "Load Remove-Conditionnal"
   ."$PsIonicTools\Remove-Conditionnal.ps1"

   $Directives=@('DEBUG','Remove')
   Dir "$PsIonicTrunk\PsIonic.psm1"|
    Foreach {Write-Verbose "Parse :$($_.FullName)"; $CurrentFileName=$_.Name;$_}|
    Get-Content -ReadCount 0|
    Remove-Conditionnal -ConditionnalsKeyWord  $Directives|
    Remove-Conditionnal -Clean|
    Foreach { $_|Set-Content -Path "$PsIonicLivraison\$CurrentFileName" -Force } #todo pas terrible !! revoir l'exemple sur le site, bug ?  
} #RemoveConditionnal

Task BuildXmlHelp {
 Write-Host " *** under construction !!!" #todo
}

Task Clean -Depends Init {
# Supprime, puis recrée le dossier de livraison   
  
   $VerbosePreference='Continue'
   Remove-Item $PsIonicLivraison -Recurse -Force -ea SilentlyContinue
   md "$PsIonicLivraison\2.0" -Verbose -ea SilentlyContinue > $null 
   md "$PsIonicLivraison\3.0" -Verbose -ea SilentlyContinue > $null
} #Clean

Task Init {
#validation à minima des prérequis
     
 if (-not (Test-Path Variable:Psionic))
  {Throw "La variable Psionic n'est pas déclarée."}
} #Init