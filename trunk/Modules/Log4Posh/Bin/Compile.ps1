#Compile.ps1

#include "$PsIonicTools\Show-BalloonTip.ps1"

if (-not $currentContext.tasks.default)
{
  Properties {
     $Configuration="Debug" #$Config
     $PSVersion=$PSVersionTable.PSVersion.ToString()
     $Cultures= "fr-FR","en-US"
     $ProjectName="Log4Posh"
  }
  Task default -Depends CompileLog4PoshTools
}
 
Task CompileLog4PoshTools {
#Compile la dll psionic
Show-BalloonTip –Text $TaskName –Title 'Build Log4Posh' –Icon Info  
  $Files=@(
    "$PsIonicTrunk\Modules\Log4Posh\Bin\PSObjectRenderer.cs",
    "$PsIonicTrunk\Modules\Log4Posh\Bin\AssemblyInfo.cs"
  )
  
  $cp = New-Object System.CodeDom.Compiler.CompilerParameters
  $cp.IncludeDebugInformation = $Configuration -eq "Debug"
  $cp.GenerateInMemory=$false
   #http://msdn.microsoft.com/en-us/library/6s2x2bzy.aspx
  $cp.CompilerOptions="/define:V$($PSVersion.ToString() -as [int])"
   #Pointe sur la version adéquate de System.Management.Automation.dll
  $cp.ReferencedAssemblies.Add([PSObject].Assembly.Location) >$null
  $cp.ReferencedAssemblies.Add("$PsIonicTrunk\Modules\Log4Posh\$PSVersion\log4net.dll") >$null
  if ( $PSVersion -gt "2.0")
  { $cp.ReferencedAssemblies.Add('System.core.dll') >$null }
    
  $cp.OutputAssembly="$PsIonicLivraison\Log4Posh\$PSVersion\Log4PoshTools.dll"
     #see to http://msdn.microsoft.com/en-us/library/6ds95cz0(v=vs.80).aspx
  Add-Type -Path $Files -CompilerParameters $cp
  Write-Host "Compilation réussie de $($cp.OutputAssembly) version $PSVersion"
  
  # si default et CompilePsionicTools uniquement
  if ($psake.Context.tasks.Count -eq 2)
  {
   if ($script:balloon -ne $null)
   {
     $script:balloon.Dispose()
     Remove-Variable -Scope script -Name Balloon
   }
  }   
} #CompileLog4PoshTools
