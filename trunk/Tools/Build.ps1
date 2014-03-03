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
 Import-Module "$PsIonicTrunk\Modules\Log4Posh\Log4Posh.psd1"
} catch {
 Throw "Module Psake is unavailable."
}
try {
    #Release utilise en interne Show-BalloonTip
    #Une fois ses tâches terminée, la fonction Show-BalloonTip
    #n'est plus disponible, on la recharge donc dans la portée courante. 
   . "$PsIonicTools\Show-BalloonTip.ps1"
   Invoke-Psake .\Release.ps1 -parameters @{"Config"="$($PsCmdlet.ParameterSetName)"} -nologo
  
   if ($PSVersion -eq "3.0")
   {
     Invoke-Expression @"
  Powershell -version 2.0 -noprofile -Command {."`$env:PsIonicProfile\Profile_DevCodePlex.Ps1";IPMO Psake; Set-Location $PsIonicTools; Invoke-Psake .\Common.ps1 -parameters @{"Config"="$($PsCmdlet.ParameterSetName)"} -nologo}
"@ 
   }
  
  if ($psake.build_success)
  { 
   Show-BalloonTip –Text 'Construction terminée.' –Title 'Build Psionic' –Icon Info 
   Invoke-Psake .\BuildZipAndSFX.ps1 -parameters @{"Config"="$($PsCmdlet.ParameterSetName)"} -nologo 
   if ($script:balloon -ne $null)
   {
     $script:balloon.Dispose()
     Remove-Variable -Scope script -Name Balloon
   }
  }
  else
  { 
   Show-BalloonTip –Text 'Build Fail' –Title 'Build Psionic' –Icon Error   
  }
} finally {
 if ($script:balloon -ne $null)
 { 
   $script:balloon.Dispose()
   Remove-Variable -Scope script -Name Balloon
 }
}
