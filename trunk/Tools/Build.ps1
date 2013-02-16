#Build.ps1
#Construit la version de PsIonic selon la version de Powershell en cours. 

# Le profile utilisateur (Profile_DevCodePlex.Ps1) doit être chargé
$PS=@{
  64="$env:SystemRoot\system32\WindowsPowerShell\v1.0\powershell.exe";
  32="$env:SystemRoot\syswow64\WindowsPowerShell\v1.0\powershell.exe"
  #  32.20="$env:SystemRoot\syswow64\WindowsPowerShell\v1.0\powershell.exe -version 2.0"
}

Set-Location $PsIonic.Tools

try {
 IMport-Module Psake -EA stop
 Invoke-Psake .\Release.ps1
 $psake
} catch {
 Throw "Module Psake is unavailable."
}
