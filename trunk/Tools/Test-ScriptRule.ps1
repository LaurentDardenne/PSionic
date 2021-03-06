﻿#todo
# Add into build.ps1
Function Test-ScriptRule{
#Extract from Microsoft Script Analyzer, ISE Addon.
 param(
  [string] $FilePath,
  [string[]] $Rules #nom -> dll/NS.Name : CheckInPolicy.IsAliasUsed
 )
 
   #Initialize or RAZ the Problem collection
   #Create private AST from a script
  $PSAnalyzer = new-object CheckInPolicy.PSAnalyzer($FilePath)
  $PSAnalyzer.GetAvailableCmdletsAndAlias();   
   
   #Ces classes renseignent les propriétés de $PSAnalyzer
  new-object CheckInPolicy.IsAliasUsed >$null
  new-object CheckInPolicy.CheckForEmptyCatchBlock >$null
  new-object CheckInPolicy.PositionalArgumentsFound >$null
  new-object CheckInPolicy.FunctionNameUseStandardVerbName >$null
  new-object CheckInPolicy.InvokeExpressionFound >$null
  
  $pbCount=$PSAnalyzer.getProblemCount
  if ($pbCount -gt 0)
  {
     for ($i = 0; $i -lt $pbCount; $i++)
     {
        $pSAnalyzer.GetProblem($i)
     }
  }
}#Test-ScriptRule

$Asm=Add-Type -Path 'C:\Program Files (x86)\Microsoft Corporation\Microsoft Script Browser\CheckInPolicy.dll' -pass
$Require="1.2.1"
if ($Asm[0].assembly.GetName().Version -le $Require)
{throw "Microsoft Script Browser\CheckInPolicy.dll : version '$Require' requise." }

$filePath="$PsIonicLivraison\PsIonic\PsIonic.psm1"
[xml]$Datas=Gc "$PsIonicTools\ScriptAnalyzerRules.xml"
[string[]]$Rules=$Datas.rules.rule.Name

get-date
$res=Test-ScriptRule -FilePath $FilePath -Rules $Rules|
 Select-Object ID, Line, Name, Script,Statement 
get-date
