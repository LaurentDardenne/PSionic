#psGet
#Install-Module

Write-Warning "Under construction..."
return
  
  try {
  $My=split-path -parent $MyInvocation.MyCommand.Definition
  Start-Transcript "$My\PsIonicSetup.Log" -ea SilentlyContinue
  
   # crée le fichier XML 
  $Lines=[System.IO.File]::ReadAllText("$PsIonicTools\Log4Net.Config.xml")
  #bug V3 seul un nom de variable peut être utilisé et pas $var.method()
  $PsIonicLogsLg4n=$PsIonicLogs.Replace('\','\\') 
  $ExecutionContext.InvokeCommand.ExpandString($Lines)|
   Set-Content "$([System.IO.Path]::GetTempPath())\Log4Net.Config.xml" -Encoding UTF8
  

} 
Finally {  
 Stop-Transcript 
} 