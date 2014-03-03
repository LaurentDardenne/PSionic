#Common.ps1
#l'instruction suivante doit être la première dans le script de la tâche principale : 
# Include "$PsIonicTools\Common.ps1" 

Properties {
   $Configuration=$Config
   $PSVersion=$PSVersionTable.PSVersion.ToString()
   $Cultures= "fr-FR","en-US"
   $ProjectName=$PsIonic.ProjectName
}
include "$PsIonicTools\Show-BalloonTip.ps1"

if (-not $currentContext.tasks.default)
{Task default -Depends CompilePsionicTools}
 
Task CompilePsionicTools -Depends TestPSSyntax {
#Compile la dll psionic
Show-BalloonTip –Text $TaskName –Title 'Build Psionic' –Icon Info  
  $Files=@(
    "$PsIonicBin\PSIonicTools.cs",
    "$PsIonicBin\AssemblyInfo.cs"
  )
  
  $cp = New-Object System.CodeDom.Compiler.CompilerParameters
  $cp.IncludeDebugInformation = $Configuration -eq "Debug"
  $cp.GenerateInMemory=$false

  $cp.ReferencedAssemblies.Add("$PsIonicBin\${Configuration}\Ionic.Zip.dll") > $null
   #Pointe sur la version adéquate de System.Management.Automation.dll
  $cp.ReferencedAssemblies.Add([PSObject].Assembly.Location) >$null
  $cp.OutputAssembly="$PsIonicLivraison\PsIonic\$PSVersion\PSIonicTools.dll"
     #see to http://msdn.microsoft.com/en-us/library/6ds95cz0(v=vs.80).aspx
  Add-Type -Path $Files -CompilerParameters $cp
  Write-Host "Compilation réussie de $($cp.OutputAssembly) version $PSVersion"
  
  # si default,CompilePsionicTools  et TestPSSyntax uniquement
  if ($psake.Context.tasks.Count -eq 3)
  {
   if ($script:balloon -ne $null)
   {
     $script:balloon.Dispose()
     Remove-Variable -Scope script -Name Balloon
   }
  }   
} #CompilePsionicTools

Task TestPSSyntax {
 ."$PsIonicTools\Test-PSScript.ps1"
 
 $Result=@("$PsIonicLivraison\Log4Posh\Log4Posh.psd1",
           "$PsIonicLivraison\Log4Posh\Log4Posh.psm1",
           "$PsIonicLivraison\PsIonic\psionic.psd1",
           "$PsIonicLivraison\PsIonic\psionic.psm1"|
            Test-PSScript -IncludeSummaryReport
          )
 $Result          
 if ($Result.Count -gt 0)
 {Throw "Corriger les erreurs de syntaxe."}        
} #TestPSSyntax