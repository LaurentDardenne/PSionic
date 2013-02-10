#Release.ps1
#Construit la version Release via Psake 

Task default -Depends Build

Include "$PsIonicTools\Common.ps1"

Task Build -Depends Init,Clean,CompilePsIonicTools,Copy {
   $VerbosePreference='Continue'

   Throw "Under construction..." #todo un seul script avec -Debug et/ou -Release 
   
   $Directives=@('DEBUG','Remove')
  
  
    #todo directive debug dans les fichiers ps1xml ? et psd1 ?
   Dir "$PsIonictrunk\PsIonic.psm1"|
    Foreach {Write-Verbose "Parse :$($_.FullName)"; $CurrentFileName=$_.Name;$_}|
    Get-Content -ReadCount 0|
    Remove-Conditionnal -ConditionnalsKeyWord  $Directives|
    Remove-Conditionnal -Clean|
    Set-Content -Path {(Join-Path $PsIonicLivraison $CurrentFileName)} -Force   
} #Build

Task Copy -Depends Clean  {
   $VerbosePreference='Continue'
   MD $PsIonicLivraison -Force -Verbose -ea SilentlyContinue 
   
   Copy "$PsIonicBin\Release\Ionic.Zip.dll" "$PsIonicLivraison"-Verbose
   
   Copy "$PsIonicTrunk\en-US\*.*" "$PsIonicLivraison\en-US" -Verbose
   Copy "$PsIonicTrunk\fr-FR\*.*" "$PsIonicLivraison\fr-FR" -Verbose
   Copy "$PsIonicTrunk\Demo\*.*" "$PsIonicLivraison\Demo" -Verbose
   Copy "$PsIonicTrunk\FormatData\*.*" "$PsIonicLivraison\FormatData" -Verbose
   Copy "$PsIonicTrunk\TypeData\*.*" "$PsIonicLivraison\TypeData" -Verbose

} #Copy

Task Clean -Depends Init {
   $VerbosePreference='Continue'
   Remove-Item $PsIonicLivraison -Recurse -Force -Verbose -ea SilentlyContinue
    
} #Clean

Task Init {
 if (-not (Test-Path Variable:Psionic))
  {Throw "La variable Psionic n'est pas déclarée."}
} #Init