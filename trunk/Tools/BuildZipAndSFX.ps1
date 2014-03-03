if (-not $currentContext.tasks.default)
{ 
  Properties {
   $Configuration=$Config
   $PSVersion=$PSVersionTable.PSVersion.ToString()
  }
  Task default -Depends BuildZipAndSFX 
}
include "$PsIonicTools\Show-BalloonTip.ps1"

Task BuildZipAndSFX {
#Construit une archive autoextractible
Show-BalloonTip –Text $TaskName –Title 'Build Psionic' –Icon Info
 
  Pop-Location
   Set-location "$PsIonicLivraison\PsIonic"
   Write-Verbose "Import module in $PsIonicLivraison\PsIonic"

   Import-Module .\PsIonic.psd1 -Force
   if ($Configuration -eq "Debug") 
   { 
     Write-host "Mode $Configuration : disable log4net"
      #Utile si log4net est déjà configuré sinon on obtient 
      #un warning sans gravité sur le logger 
     Set-Log4NETDebugLevel -Off 
   }
   
   $ZipFileName="$PsIonicLivraison\PsIonicSetup.zip"
   
   $Files="$PsIonicLivraison\*"
   $ReadOptions = New-Object Ionic.Zip.ReadOptions -Property @{ 
                    StatusMessageWriter = [System.Console]::Out
                  } 

   $Save=@{
		ExeOnUnpack="Powershell -noprofile -File .\PsIonicSetup.ps1";  
        Description="Setup for the PsIonic Powershell module"; 
        NameOfProduct="PSIonic";
        VersionOfProduct="1.0.0";
        Copyright='This module is free for non-commercial purposes. Ce module est libre de droits pour tout usages non commercial'
	}
   $SaveOptions=New-ZipSfxOptions @Save

   Write-host "Crée l'archive $ZipFileName"
   dir $Files|
     Compress-ZipFile $ZipFileName
   Write-host "Puis crée une archive autoextractible"
   ConvertTo-Sfx -Path $ZipFileName -Save $SaveOptions -Read $ReadOptions  

  #Remove-Module PsIonic
  Push-Location   
} #BuildZipAndSFX