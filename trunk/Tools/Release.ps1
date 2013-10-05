#Release.ps1
#Construit la version Release via Psake

Include "$PsIonicTools\Common.ps1"

Task default -Depends Delivery,CompilePsIonicTools,BuildXmlHelp

Task Delivery -Depends Clean,RemoveConditionnal {
#Recopie les fichiers dans le répertoire de livraison  
  
   $VerbosePreference='Continue'
#DLL
   Copy "$PsIonicBin\Debug\log4net\2.0\log4net.dll" "$PsIonicLivraison\2.0"  
   Copy "$PsIonicBin\Debug\log4net\4.0\log4net.dll" "$PsIonicLivraison\3.0"
 
#lg4N config
# on copie la config de dev nécessaire au build. 
   Copy "$PsIonicTrunk\Log4Net.Config.xml" "$PsIonicLivraison"
      #crée le template pour le setup
   Copy "$PsIonicTools\Log4Net.Config.xml" "$PsIonicLivraison\Log4Net.Config.xml.Template"
   
   Copy "$PsIonicBin\${Configuration}\Ionic.Zip.dll" "$PsIonicLivraison"
# PSIonicTools.dll est compilé d'aprés la version PS courante
   
   Copy "$PsIonicBin\Debug\Ionic.Zip.pdb" "$PsIonicLivraison"

#Doc xml localisée
   Copy "$PsIonicTrunk\en-US\PsIonicLocalizedData.psd1" "$PsIonicLivraison\en-US\PsIonicLocalizedData.psd1" 
   Copy "$PsIonicTrunk\fr-FR\PsIonicLocalizedData.psd1" "$PsIonicLivraison\fr-FR\PsIonicLocalizedData.psd1" 
#Demo
   Copy "$PsIonicTrunk\Demo" "$PsIonicLivraison\Demo" -Recurse

#PS1mxl   
   Copy "$PsIonicTrunk\FormatData\PsIonic.ReadOptions.Format.ps1xml" "$PsIonicLivraison\FormatData\PsIonic.ReadOptions.Format.ps1xml"
   Copy "$PsIonicTrunk\FormatData\PsIonic.ZipEntry.Format.ps1xml" "$PsIonicLivraison\FormatData\PsIonic.ZipEntry.Format.ps1xml"

   Copy "$PsIonicTrunk\TypeData" "$PsIonicLivraison\TypeData" -Recurse

#Licence                         
   Copy "$PsIonicTrunk\Documentation\Licence"  "$PsIonicLivraison\Documentation\Licence" -Recurse 
   Copy "$PsIonicTrunk\Documentation\DotNetZip-Documentation-v1.9.zip"  "$PsIonicLivraison\Documentation"
   Copy "$PsIonicTrunk\Licence-PsIonicModule.txt" "$PsIonicLivraison" 

#Module
   Copy "$PsIonicTrunk\PsIonic.psd1" "$PsIonicLivraison"
   if ( $Configuration -eq "Debug")
   { Copy "$PsIonicTrunk\PsIonic.psm1" "$PsIonicLivraison" }
   #else  PsIonic.psm1 est créé par la tâche RemoveConditionnal 
   
#Setup
   Copy "$PsIonicTrunk\Setup\PsIonicSetup.ps1" "$PsIonicLivraison"

#Other 
   Copy "$PsIonicTrunk\Revisions.txt" "$PsIonicLivraison"
} #Delivery

Task RemoveConditionnal -Depend TestLocalizedData { $go=$Configuration -ne "Debug"; if (-not $go) {Write-Host "Mode Debug, on passe la tâche en cours"} ; $go} {
#Supprime les lignes de code de Debug et de test
     
   $VerbosePreference='Continue'
   ."$PsIonicTools\Remove-Conditionnal.ps1"

   $Directives=@('DEBUG','Remove')
   Dir "$PsIonicTrunk\PsIonic.psm1"|
    Foreach {
      Write-Verbose "Parse :$($_.FullName)"
      $CurrentFileName=$_.Name
      $_}|
    Get-Content -ReadCount 0|
    Remove-Conditionnal -ConditionnalsKeyWord  $Directives|
    Remove-Conditionnal -Clean|
    Set-Content -Path { "$PsIonicLivraison\$CurrentFileName"} -Force  
} #RemoveConditionnal

Task TestLocalizedData -ContinueOnError {
 ."$PsIonicTools\Test-LocalizedData.ps1""

 $SearchDir="$PsionicTrunk"
 Foreach ($Culture in $Cultures)
 {
   Dir "$SearchDir\Psionic.psm1"|          
    Foreach-Object {
       #Construit un objet contenant des membres identiques au nombre de 
       #paramètres de la fonction Test-LocalizedData 
      New-Object PsCustomObject -Property @{
                                     Culture=$Culture;
                                     Path="$SearchDir\$($_.BaseName)";
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
   
   
} #TestLocalizedData

Task BuildXmlHelp {
  $Module=Import-Module "$PSionicLivraison\PsIonic.psd1" -PassThru
 
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
       Join-XmlHelp $Module.Name -Source $TempLocation "$PsIonicLivraison\$_" -Culture $_
    } 
   
  Remove-Module PsIonic
} #BuildXmlHelp 

Task Clean -Depends Init {
# Supprime, puis recrée le dossier de livraison   
  
   $VerbosePreference='Continue'
   Remove-Item $PsIonicLivraison -Recurse -Force -ea SilentlyContinue
   "$PsIonicLivraison\2.0", 
   "$PsIonicLivraison\3.0",
   "$PsIonicLivraison\en-US", 
   "$PsIonicLivraison\fr-FR", 
   "$PsIonicLivraison\FormatData",
   "$PsIonicLivraison\TypeData"|
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
       $InvalidFiles
       Throw "Des fichiers ne sont pas encodés en UTF8 ou sont codés BigEndian."
     }  
    }#foreach  
} #Init