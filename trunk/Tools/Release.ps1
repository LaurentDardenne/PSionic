#Release.ps1
#Construit la version Release via Psake
# La compilation doit se faire sous PS v3, ainsi on a les deux DLL pour les framework .Net v2 et 4.0

Include "$PsIonicTools\Common.ps1"
 #charge cette fonction dans la portée de PSake
include "$PsIonicTools\Show-BalloonTip.ps1"

Task default -Depends Delivery,CompilePsIonicTools,BuildXmlHelp,TestBomFinal,Finalize

Task Delivery -Depends Clean,RemoveConditionnal,FindTodo {
#Recopie les fichiers dans le répertoire de livraison  
Show-BalloonTip –Text $TaskName –Title 'Build Psionic' –Icon Info 
  
$VerbosePreference='Continue'

#Modules requis
   Copy "$PsIonicTrunk\Modules\Log4Posh" "$PsIonicLivraison" -Recurse
 
#log4Net config
# on copie la config de dev nécessaire au build. 
   Copy "$PsIonicTrunk\Log4Net.Config.xml" "$PsIonicLivraison\PsIonic"
      #crée le template pour le setup
   Copy "$PsIonicTools\Log4Net.Config.xml" "$PsIonicLivraison\PsIonic\Log4Net.Config.xml.Template"
   
   Copy "$PsIonicBin\${Configuration}\Ionic.Zip.dll" "$PsIonicLivraison\PsIonic"
# PSIonicTools.dll est compilé d'aprés la version PS courante
   
   Copy "$PsIonicBin\Debug\Ionic.Zip.pdb" "$PsIonicLivraison\PsIonic"

#Doc xml localisée
   Copy "$PsIonicTrunk\en-US\PsIonicLocalizedData.psd1" "$PsIonicLivraison\PsIonic\en-US\PsIonicLocalizedData.psd1" 
   Copy "$PsIonicTrunk\fr-FR\PsIonicLocalizedData.psd1" "$PsIonicLivraison\PsIonic\fr-FR\PsIonicLocalizedData.psd1" 

#Demos
   Copy "$PsIonicTrunk\Demos" "$PsIonicLivraison\PsIonic\Demos" -Recurse

#PS1xml   
   Copy "$PsIonicTrunk\FormatData\PsIonic.ReadOptions.Format.ps1xml" "$PsIonicLivraison\PsIonic\FormatData\PsIonic.ReadOptions.Format.ps1xml"
   Copy "$PsIonicTrunk\FormatData\PsIonic.ZipEntry.Format.ps1xml" "$PsIonicLivraison\PsIonic\FormatData\PsIonic.ZipEntry.Format.ps1xml"

   Copy "$PsIonicTrunk\TypeData\System.ZipEntry.Types.ps1xml" "$PsIonicLivraison\PsIonic\TypeData\System.ZipEntry.Types.ps1xml"

#Licence                         
   Copy "$PsIonicTrunk\Documentation\Licence"  "$PsIonicLivraison\PsIonic\Documentation\Licence" -Recurse 
   Copy "$PsIonicTrunk\Documentation\DotNetZip-Documentation-v1.9.zip"  "$PsIonicLivraison\PsIonic\Documentation"
   Copy "$PsIonicTrunk\Licence-PsIonicModule.txt" "$PsIonicLivraison\PsIonic" 

#Module
      #PsIonic.psm1 est créé par la tâche RemoveConditionnal
   Copy "$PsIonicTrunk\PsIonic.psd1" "$PsIonicLivraison\PsIonic"
   Copy "$PsIonicTrunk\PsIonic.ico" "$PsIonicLivraison\PsIonic"
   Copy "$PsIonicTrunk\Get-PsIonicDefaultSfxConfiguration.ps1" "$PsIonicLivraison\PsIonic"
   
#Setup
   Copy "$PsIonicTrunk\Setup\PsIonicSetup.ps1" "$PsIonicLivraison\PsIonic"

#Other 
   Copy "$PsIonicTrunk\Revisions.txt" "$PsIonicLivraison\PsIonic"
} #Delivery

Task RemoveConditionnal -Depend TestLocalizedData {
#Traite les pseudo directives de parsing conditionnelle

Show-BalloonTip –Text $TaskName –Title 'Build Psionic' –Icon Info
   
   $VerbosePreference='Continue'
   ."$PsIonicTools\Remove-Conditionnal.ps1"
   Write-debug "Configuration=$Configuration"
   Dir "$PsIonicTrunk\PsIonic.psm1"|
    Foreach {
      $Source=$_
      Write-Verbose "Parse :$($_.FullName)"
      $CurrentFileName="$PsIonicLivraison\PsIonic\$($_.Name)"
      Write-Warning "CurrentFileName=$CurrentFileName"
      if ($Configuration -eq "Release")
      { 
         Write-Warning "`tTraite la configuration Release"
         #Supprime les lignes de code de Debug et de test
         #On traite une directive et supprime les lignes demandées. 
         #On inclut les fichiers.       
        Get-Content -Path $_ -ReadCount 0 -Encoding UTF8|
         Remove-Conditionnal -ConditionnalsKeyWord 'DEBUG' -Include -Remove|
         Remove-Conditionnal -Clean| 
         Set-Content -Path $CurrentFileName -Force -Encoding UTF8        
      }
      else
      { 
         #On ne traite aucune directive et on ne supprime rien. 
         #On inclut uniquement les fichiers.
        Write-Warning "`tTraite la configuration DEBUG" 
         #Directive inexistante et on ne supprime pas les directives
         #sinon cela génére trop de différences en cas de comparaison de fichier
        Get-Content -Path $_ -ReadCount 0 -Encoding UTF8|
         Remove-Conditionnal -ConditionnalsKeyWord 'NODEBUG' -Include -Container $Source|
         Set-Content -Path $CurrentFileName -Force -Encoding UTF8       
         
      }
    }#foreach
} #RemoveConditionnal

Task TestLocalizedData -ContinueOnError {
 ."$PsIonicTools\Test-LocalizedData.ps1"
Show–BalloonTip –Text $TaskName –Title 'Build Psionic' –Icon Info

 $SearchDir="$PsionicTrunk"
 Foreach ($Culture in $Cultures)
 {
   Dir "$SearchDir\Psionic.psm1"|          
    Foreach-Object {
       #Construit un objet contenant des membres identiques au nombre de 
       #paramètres de la fonction Test-LocalizedData 
      New-Object PsCustomObject -Property @{
                                     Culture=$Culture;
                                     Path="$SearchDir";
                                       #convention de nommage de fichier d'aide
                                     LocalizedFilename="$($_.BaseName)LocalizedData.psd1";
                                     FileName=$_.Name;
                                       #convention de nommage de variable
                                     PrefixPattern="$($_.BaseName)Msgs\."
                                  }
    }|   
    Test-LocalizedData -verbose
 }
} #TestLocalizedData

Task BuildXmlHelp {
Show-BalloonTip –Text $TaskName –Title 'Build Psionic' –Icon Info
  $Module=Import-Module "$PsIonicLivraison\PsIonic\PsIonic.psd1" -PassThru
 
  [string] $TempLocation ="$([System.IO.Path]::GetTempPath())PsIonic"
  If ( (Test-Path $TempLocation) )
  { Remove-Item $TempLocation -Recurse -Force }
  md $TempLocation >$null
 
  $VerbosePreference='SilentlyContinue' 

   #https://github.com/nightroman/Helps
  ."$PSScripts\Helps\Helps.ps1"
  ."$PsIonicTools\HelpsAddon.ps1"
  
  $Excludes='ConvertFrom-CliXml','ConvertTo-CliXml'
 
  Write-Warning "!!! Reste la doc de la culture en-US "
  #$Cultures |
  "fr-Fr" | 
    Foreach {
      $Module.ExportedFunctions.GetEnumerator()|
      Where {$Excludes -notContains $_.Key} |
       ConvertTo-XmlHelp $Module.Name -Source $PsIonicHelp -Target $TempLocation  -Culture $_
    }
   
  "fr-Fr" | 
    Foreach {
      $Module.ExportedFunctions.GetEnumerator()|
       Where {$Excludes -notContains $_.Key} |
       Join-XmlHelp $Module.Name -Source $TempLocation "$PsIonicLivraison\PsIonic" -Culture $_
       #Join-XmlHelp crée le répertoire spécifique à une culture
    } 
   
  Remove-Module PsIonic
} #BuildXmlHelp 

Task Clean -Depends Init {
# Supprime, puis recrée le dossier de livraison   
Show-BalloonTip –Text $TaskName –Title 'Build Psionic' –Icon Info

   $VerbosePreference='Continue'
   Remove-Item $PsIonicLivraison -Recurse -Force -ea SilentlyContinue
   "$PsIonicLivraison\PsIonic",
   "$PsIonicLivraison\PsIonic\2.0", 
   "$PsIonicLivraison\PsIonic\3.0",
   "$PsIonicLivraison\PsIonic\en-US", 
   "$PsIonicLivraison\PsIonic\fr-FR", 
   "$PsIonicLivraison\PsIonic\FormatData",
   "$PsIonicLivraison\PsIonic\TypeData"|
   Foreach {
    md $_ -Verbose -ea SilentlyContinue > $null
   } 
} #Clean

Task Init -Depends TestBOM {
#validation à minima des prérequis
Show-BalloonTip –Text $TaskName –Title 'Build Psionic' –Icon Info

 Write-host "Mode $Configuration"
  if (-not (Test-Path Variable:Psionic))
  {Throw "La variable Psionic n'est pas déclarée."}
  
  if (-Not (Test-Path "$PSScripts\Helps\Helps.ps1"))
  {Throw "Fichier nécessaire introuvable :$_"}
    
} #Init

Task TestBOM {
#Validation de l'encodage des fichiers AVANT la génération  
Show-BalloonTip –Text $TaskName –Title 'Build Psionic' –Icon Info  
  Write-Host "Validation de l'encodage des fichiers du répertoire : $PsionicTrunk"
  
  Import-Module DTW.PS.FileSystem -Global
  
  $InvalidFiles=@(&"$PsIonicTools\Test-BOMFile.ps1" $PsionicTrunk)
  if ($InvalidFiles.Count -ne 0)
  { 
     $InvalidFiles |Format-List *
     Throw "Des fichiers ne sont pas encodés en UTF8 ou sont codés BigEndian."
  }
} #TestBOM

#On duplique la tâche, car PSake ne peut exécuter deux fois une même tâche
Task TestBOMFinal {
Show-BalloonTip –Text $TaskName –Title 'Build Psionic' –Icon Info

#Validation de l'encodage des fichiers APRES la génération  
  
  Write-Host "Validation de l'encodage des fichiers du répertoire : $PsionicLivraison"
  $InvalidFiles=@(&"$PsIonicTools\Test-BOMFile.ps1" $PsionicLivraison)
  if ($InvalidFiles.Count -ne 0)
  { 
     $InvalidFiles |Format-List *
     Throw "Des fichiers ne sont pas encodés en UTF8 ou sont codés BigEndian."
  }
} #TestBOMFinal


Task FindTodo {
Show-BalloonTip –Text $TaskName –Title 'Build Psionic' –Icon Info    
if ($Configuration -eq "Release") 
{
   $Pattern='(?<=#).*?todo'
   $ResultFile="$env:Temp\$ProjectName-TODO-List.txt"
   Write-host "Recherche les occurences des TODO"
   Write-host "Résultat dans  : $ResultFile"
              
   Get-ChildItem -Path $PsionicTrunk -Include *.ps1,*.psm1,*.psd1,*.ps1xml,*.xml,*.txt,*.cs -Recurse |
    Where { (-not $_.PSisContainer) -and ($_.Length -gt 0)} |
    Select-String -pattern $Pattern|Set-Content $ResultFile -Encoding UTF8
   Invoke-Item $ResultFile
}
else
{Write-Warning "Config DEBUG : tache inutile" } 
} #FindTodo

Task Finalize {
 $script:balloon.Dispose()
 Remove-Variable -Scope script -Name Balloon
}