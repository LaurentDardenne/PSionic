#Build.ps1
#Construit la version de PsIonic selon la version de Powershell en cours. 
 [CmdletBinding(DefaultParameterSetName = "Debug")]
 Param(
     [Parameter(ParameterSetName="Release")]
   [switch] $Release
 ) 
# Le profile utilisateur (Profile_DevCodePlex.Ps1) doit être chargé

Set-Location $PsIonicTools

try {
 Import-Module Psake -EA stop -force
 Import-Module Log4Posh 
} catch {
 Throw "Module Psake is unavailable."
}
 
 Invoke-Psake .\Release.ps1 -parameters @{"Config"="$($PsCmdlet.ParameterSetName)"} -nologo

 if ($PSVersion -eq "3.0")
 {
   Invoke-Expression @"
Powershell -version 2.0 -noprofile -Command {."`$env:PsIonicProfile\Profile_DevCodePlex.Ps1";IPMO Psake; Set-Location $PsIonicTools; Invoke-Psake .\Common.ps1 -parameters @{"Config"="$($PsCmdlet.ParameterSetName)"} -nologo}
"@ 
 }

if ($psake.build_success)
{ Invoke-Psake .\BuildZipAndSFX.ps1 -parameters @{"Config"="$($PsCmdlet.ParameterSetName)"} -nologo }
