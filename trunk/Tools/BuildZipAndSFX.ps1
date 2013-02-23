if (-not $currentContext.tasks.default)
{ 
  Properties {
   $Configuration=$Config
   $PSVersion=$PSVersionTable.PSVersion.ToString()
  }
  Task default -Depends BuildZipAndSFX 
}

Task BuildZipAndSFX {
#Construit une archive autoextractible
 
  Pop-Location
   Set-location $PsIonicLivraison
   Write-Verbose "Import module in $PsIonicLivraison"
    #todo dans un job de build ? 
   Import-Module .\PsIonic.psd1 -Force
   if ($Configuration -eq "Debug") 
   { 
     Write-host "Mode $Configuration : no log"
     Set-Log4NETDebugLevel -Off 
   }
   
   $ZipFileName="$PsIonicLivraison\PsIonicSetup.zip"
   
   $Files="$PsIonicLivraison\*"
   $ReadOptions = New-Object Ionic.Zip.ReadOptions -Property @{ 
                    StatusMessageWriter = [System.Console]::Out;
                  } 

   $Save=@{
		ExeOnUnpack="Powershell -noprofile -File .\PsIonicSetup.ps1";  
        Description="Setup for the PsIonic Powershell module"; 
		ExtractExistingFile=[Ionic.Zip.ExtractExistingFileAction]::OverwriteSilently;
        NameOfProduct="PSIonic";
        VersionOfProduct="1.0.0";
        Copyright='This module is free for non-commercial purposes. Ce module est libre de droits pour tout usages non commercial'
	}
   $SaveOptions=New-ZipSfxOptions @Save

   Write-host "Crée l'archive $ZipFileName"
   dir $Files|
     Compress-ZipFile $ZipFileName
   Write-host "Puis crée une archive autoextractible"
   ConvertTo-Sfx $ZipFileName -Save $SaveOptions -Read $ReadOptions  

  Push-Location
  Remove-Module PsIonic -Force   
} #BuildZipAndSFX