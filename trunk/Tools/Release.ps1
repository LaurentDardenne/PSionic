#Release.ps1
#Construit la version Release via Psake

Include "$PsIonicTools\Common.ps1"

Task default -Depends Delivery,CompilePsIonicTools,BuildXmlHelp

Task Delivery -Depends Clean,RemoveConditionnal,FindTodo {
#Recopie les fichiers dans le répertoire de livraison  
  
$VerbosePreference='Continue'

#Module
   Copy "$PsIonicTrunk\Modules\Log4Posh" "$PsIonicLivraison" -Recurse
 
#lg4N config
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
#Demo
   Copy "$PsIonicTrunk\Demo" "$PsIonicLivraison\PsIonic\Demo" -Recurse

#PS1mxl   
   Copy "$PsIonicTrunk\FormatData\PsIonic.ReadOptions.Format.ps1xml" "$PsIonicLivraison\PsIonic\FormatData\PsIonic.ReadOptions.Format.ps1xml"
   Copy "$PsIonicTrunk\FormatData\PsIonic.ZipEntry.Format.ps1xml" "$PsIonicLivraison\PsIonic\FormatData\PsIonic.ZipEntry.Format.ps1xml"

   Copy "$PsIonicTrunk\TypeData" "$PsIonicLivraison\PsIonic\TypeData" -Recurse

#Licence                         
   Copy "$PsIonicTrunk\Documentation\Licence"  "$PsIonicLivraison\PsIonic\Documentation\Licence" -Recurse 
   Copy "$PsIonicTrunk\Documentation\DotNetZip-Documentation-v1.9.zip"  "$PsIonicLivraison\PsIonic\Documentation"
   Copy "$PsIonicTrunk\Licence-PsIonicModule.txt" "$PsIonicLivraison\PsIonic" 

#Module
   Copy "$PsIonicTrunk\PsIonic.psd1" "$PsIonicLivraison\PsIonic"
   #PsIonic.psm1 est créé par la tâche RemoveConditionnal 
   
#Setup
   Copy "$PsIonicTrunk\Setup\PsIonicSetup.ps1" "$PsIonicLivraison\PsIonic"

#Other 
   Copy "$PsIonicTrunk\Revisions.txt" "$PsIonicLivraison\PsIonic"
} #Delivery

Task RemoveConditionnal -Depend TestLocalizedData {
#Traite les pseudo directives de parsing conditionnelle
   
   $VerbosePreference='Continue'
   ."$PsIonicTools\Remove-Conditionnal.ps1"
   Write-debug "Configuration=$Configuration"
   Dir "$PsIonicTrunk\PsIonic.psm1"|
    Foreach {
      Write-Verbose "Parse :$($_.FullName)"
      $CurrentFileName="$PsIonicLivraison\PsIonic\$($_.Name)"
      Write-Warning "CurrentFileName=$CurrentFileName"
      if ($Configuration -eq "Release")
      { 
         Write-Warning "`tTraite la configuration Release"
         #Supprime les lignes de code de Debug et de test
         #On traite une directive et supprime les lignes demandées. 
         #On inclut les fichiers.       
        $Directives=@('DEBUG')
        $isRemove=$true 
      }
      else
      { 
         #On ne traite aucune directive et on ne supprime rien. 
         #On inclut les fichiers.
        Write-Warning "`tTraite la configuration DEBUG" 
        $Directives=@('NODEBUG')
        $isRemove=$false 
      }
    
      Get-Content -Path $_ -ReadCount 0|
       Remove-Conditionnal -ConditionnalsKeyWord $Directives -Include -Remove:$isRemove|
       Remove-Conditionnal -Clean| 
       Set-Content -Path $CurrentFileName -Force
    }#foreach
} #RemoveConditionnal

Task TestLocalizedData -ContinueOnError {
 ."$PsIonicTools\Test-LocalizedData.ps1"

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
  $Module=Import-Module "$PsIonicLivraison\PsIonic\PsIonic.psd1" -PassThru
 
  [string] $TempLocation ="$([System.IO.Path]::GetTempPath())PsIonic"
  If ( (Test-Path $TempLocation) )
  { Remove-Item $TempLocation -Recurse -Force }
  md $TempLocation >$null
 
  $VerbosePreference='SilentlyContinue' 

   #https://github.com/nightroman/Helps
  ."$PSScripts\Helps\Helps.ps1"
  ."$PsIonicTools\HelpsAddon.ps1"
  
  $Excludes='Set-Log4NETDebugLevel','Stop-ConsoleAppender','Start-ConsoleAppender','ConvertFrom-CliXml','ConvertTo-CliXml'
 
  #$Cultures | todo
  "fr-Fr" | 
    Foreach {
      $Module.ExportedFunctions.GetEnumerator()|
      Where {$Excludes -notContains $_.Key} |
       ConvertTo-XmlHelp $Module.Name -Source $PsIonicHelp -Target $TempLocation  -Culture $_
    }
   
  #$Cultures |
  "fr-Fr" | 
    Foreach {
      $Module.ExportedFunctions.GetEnumerator()|
       Where {$Excludes -notContains $_.Key} |
       Join-XmlHelp $Module.Name -Source $TempLocation "$PsIonicLivraison\PsIonic\$_" -Culture $_
    } 
   
  Remove-Module PsIonic
} #BuildXmlHelp 

Task Clean -Depends Init {
# Supprime, puis recrée le dossier de livraison   
  
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

Task Init {
#validation à minima des prérequis

 Write-host "Mode $Configuration"
  if (-not (Test-Path Variable:Psionic))
  {Throw "La variable Psionic n'est pas déclarée."}
  "$PSScripts\Helps\Helps.ps1"| 
    Foreach {
     if (-Not (Test-Path $_))
     {Throw "Fichier nécessaire introuvable :$_"}
    
     Import-Module DTW.PS.FileSystem 
     $InvalidFiles=@(&"$PsIonicTools\Test-BOMFile")
     if ($InvalidFiles.Count -ne 0)
     { 
       $InvalidFiles |Format-List *
       Throw "Des fichiers ne sont pas encodés en UTF8 ou sont codés BigEndian."
     }  
    }#foreach  
} #Init

Task FindTodo {
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