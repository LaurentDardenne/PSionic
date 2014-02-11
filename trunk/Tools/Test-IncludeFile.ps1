function Test-IncludeFile {
 #Valide les fichiers inséré via des 'include' cf. Remove-Conditionnal
 #Evite l'usage de svn:externals
 
 param(
      [ValidateNotNullOrEmpty()]
      [Parameter(Position=0, Mandatory=$true)]
    [System.Collections.IDictionary] $Include,
       #Force la vérification de l'encodage des fichiers
       #ce qui permet de distinguer la cause des différences.
    [switch] $Verify
 )
 
 if ($Verify)
 {
     #http://www.dtwconsulting.com/PS/Module_FileSystem.htm
    Import-Module DTW.PS.FileSystem
 }  
 
 Function New-FCInformation{
  #Résultats d'un appel à FC.exe
  param(
           [Parameter(Mandatory=$True,position=0)]
          $Target,
            [Parameter(Mandatory=$True,position=1)]
          $Source,
           [Parameter(Mandatory=$True,position=2)]
          $ErrorCode,
           [Parameter(Mandatory=$True,position=3)]
          $Message
  )
    #Les paramétres liés définissent aussi les propriétés de l'objet
   $O=New-Object PSObject -Property $PSBoundParameters
  
   $O.PsObject.TypeNames.Insert(0,"FCInformation")
   $O
  
 }# New-FCInformation
 
 $pathHelper = $ExecutionContext.SessionState.Path

 $Include.GetEnumerator()|
  Foreach { 
    Write-Verbose  "Compare la source du fichier inclus $($_.Name)" 
    $Target=Join-path ($pathHelper.GetUnresolvedProviderPathFromPSPath($_.Value.Target)) $_.Name 
    $Source=Join-path ($pathHelper.GetUnresolvedProviderPathFromPSPath($_.Value.Source) ) $_.Name
    if ($Target -ne $Source)
    {
      $isSameEncoding=$true
      if ($Verify)
      {
       $EncodingTarget=Get-DTWFileEncoding $Target
       if ($EncodingTarget -ne $null) 
       { Write-Verbose "EncodingTarget $($EncodingTarget.EncodingName)" }
       $EncodingSource=Get-DTWFileEncoding $Source
       if ($EncodingSource -ne $null) 
       { Write-Verbose "EncodingSource $($EncodingSource.EncodingName)" } 
       $isSameEncoding= $EncodingTarget.EncodingName -eq $EncodingSource.EncodingName  
      }
      
      if ($isSameEncoding)
      {
        #La comparaison requiert un même encodage de fichier.
        #S'il est différent $LastExitCode sera tjrs égal à 1
        $res=fc.exe "$Source" "$Target" /U 2>&1
        $ErrorCode=$LastExitCode
        if ($ErrorCode -eq 1)
        { $Message="Fichier différent." } #$Res contient le détail verbeux 
        else 
        { $Message="$Res" }
      }
      else 
      { 
        $Message="Fichier d'encodage différent."
        $ErrorCode=-1
      }           
       
       Write-Output (New-FCInformation $Target $Source $ErrorCode $Message)
    }
    else
    { Write-Error "$($_.Name) : La localisation des fichiers doit être différente et les noms de fichier identique." }
  }#foreach
} #Test-IncludeFile
