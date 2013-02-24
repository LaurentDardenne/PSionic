#Common.ps1
#l'instruction suivante doit être la première dans le script de la tâche principale : 
# Include "$PsIonicTools\Common.ps1" 

Properties {
   $Configuration=$Config
   $PSVersion=$PSVersionTable.PSVersion.ToString()
}

if (-not $currentContext.tasks.default)
{Task default -Depends CompilePsionicTools}
 
Task CompilePsionicTools {
#Compile la dll psionic
 
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
  $cp.OutputAssembly="$PsIonicLivraison\$PSVersion\PSIonicTools.dll"
     #see to http://msdn.microsoft.com/en-us/library/6ds95cz0(v=vs.80).aspx
  Add-Type -Path $Files -CompilerParameters $cp
  Write-Host "Compilation réussie de $($cp.OutputAssembly) version $PSVersion"
} #CompilePsionicTools