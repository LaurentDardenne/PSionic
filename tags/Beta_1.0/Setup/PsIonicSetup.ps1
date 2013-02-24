try {
  $My=split-path -parent $MyInvocation.MyCommand.Definition
  Start-Transcript "$My\PsIonicSetup.Log" -ea SilentlyContinue

  function Test-ExecutionPolicy {
    if ((Get-ExecutionPolicy) -eq "Restricted") {
      Throw "Your execution policy has disabled the scripts execution."
     }
  }#Test-ExecutionPolicy
  
  function Install-Psionic {
  #Adapted from (new-object Net.WebClient).DownloadString("http://psget.net/GetPsGet.ps1")         
      $ModulePaths = @($Env:PSModulePath -split ';')
      $ExpectedUserModulePath = Join-Path -Path ([Environment]::GetFolderPath('MyDocuments')) -ChildPath WindowsPowerShell\Modules
      $Destination = $ModulePaths | Where-Object { $_ -eq $ExpectedUserModulePath}
      if (-not $Destination) {
          $Destination = $ModulePaths | Select-Object -Index 0
      }
      New-Item ($Destination + "\PsIonic\") -ItemType Directory -Force | out-null
      Copy *.*  "$Destination\Psionic" -rec
  } #Install-Psionic  
  
  function New-LG4NetConfigurationFile {  
    # crée le fichier XML 
    $Lines=[System.IO.File]::ReadAllText("$my\Log4Net.Config.xml.Template")
    $TempPath=[System.IO.Path]::GetTempPath()
    $PsIonicLogsLg4n=$TempPath.Replace('\','\\') #Possible Security Exception 
    $ExecutionContext.InvokeCommand.ExpandString($Lines)|
     Set-Content "$TempPath\Log4Net.Config.xml" -Encoding UTF8
  } #New-LG4NetConfigurationFile


  New-LG4NetConfigurationFile
  Install-Psionic
} 
Finally {  
 Stop-Transcript 
} 