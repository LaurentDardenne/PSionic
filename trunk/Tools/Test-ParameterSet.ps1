Function Test-ParameterSet{
#Requires -Version 3.0

 param (
  [parameter(Mandatory=$True,ValueFromPipeline=$True)]
  [string]$Command
 ) 
begin {
 [string[]] $CommonParameters=[System.Management.Automation.Internal.CommonParameters].GetProperties()| 
                               Foreach {$_.Name}
 function Test-Sequential{
  #La collection doit être triée
  param([int[]]$List)
    $Count=$List.Count
    for ($i = 1; $i -lt $Count; $i++)
    {
       if ($List[$i] -ne $List[$i - 1] + 1)
       {return $false}
    }
    return $true
 }# Test-Sequential
}#end

process {
  $Cmd=Get-Command $Command
  Write-Debug "Test $Command"
  
        #bug PS : https://connect.microsoft.com/PowerShell/feedback/details/653708/function-the-metadata-for-a-function-are-not-returned-when-a-parameter-has-an-unknow-data-type
  $oldEAP,$ErrorActionPreference=$ErrorActionPreference,'Stop'
   $SetCount=$Cmd.get_ParameterSets().count
  $ErrorActionPreference=$oldEAP

  $_AllNames=@($Cmd.ParameterSets|
            Foreach {
              $PrmStName=$_.Name
              $P=$_.Parameters|Foreach {$_.Name}|Where  {$_ -notin $CommonParameters} 
              Write-Debug "Build $PrmStName $($P.Count)"
              if (($P.Count) -eq 0)
              { Write-Warning "[$($Cmd.Name)]: the parameter set '$PrmStName' is empty." }
              $P
            })

  $Sets=@{}
  Add-Member -Input $Sets -MemberType NoteProperty -Name CommandName -value $Cmd.Name 
  if ($_AllNames.Count -eq 0 ) 
  { return $Sets  }
   
   #Contient les noms des paramètre de tous les jeux
   #Les noms peuvent être dupliqués
  $AllNames=new-object System.Collections.ArrayList(,$_AllNames)
  
  $Cmd.ParameterSets| 
   foreach {
     $Name=$_.Name
      #Contient tous les noms de paramètre du jeux courant
     $Params=new-object System.Collections.ArrayList
      #Contient les positions des paramètres du jeux courant
     $Positions=new-object System.Collections.ArrayList
     $Others=$AllNames.Clone()
     
     $_.Parameters|
      Where {$_.Name -notin $CommonParameters}|
      Foreach {
        Write-debug "Add $($_.Name) $($_.Position)"
        $Params.Add($_.Name) > $null
        $Positions.Add($_.Position) > $null
      }
     
      #Supprime dans la collection globale
      #les noms de paramètres du jeux courant
     $Params| 
      Foreach { 
        Write-Debug "Remove $_"
        $Others.Remove($_) 
      }

      #Supprime les valeurs des positions par défaut
     $FilterPositions=$Positions|Where {$_ -ge 0}
      #Get-Unique attend une collection triée
     $SortedPositions=$FilterPositions|Sort-Object  
     $isDuplicate= -not (@($SortedPositions|Get-Unique).Count -eq $FilterPositions.Count)
     $isSequential= Test-Sequential $SortedPositions
     
     $isPositionValid=($isDuplicate -eq $False) -and ($isSequential -eq $true)
     
     $HasParameterUnique= &{
         if ($Others.Count -eq 0 ) 
         { 
           Write-Debug "Only one parameter set."
           return $true
         }
         foreach ($Current in $Params)
         {
           if ($Current -notin $Others)
           { return $true}
         }
         return $false           
      }#$HasParameterUnique
            
     $O=[psCustomObject]@{
            #Mémorise les informations.
            #Utiles en cas de construction de rapport
           Params=$Params;
           Others=$Others;
           Positions=$Positions;
            
            #Les propriété suivantes indiquent la ou les causes d'erreur
           isHasUniqueParameter= $HasParameterUnique;

           isPositionContainsDuplicate= $isDuplicate;
            #S'il existe des nombres dupliqués, la collection ne peut pas être une suite
           isPositionSequential= $isSequential
            
           isPositionValid= $isPositionValid
           
            #La propriété suivante indique si le jeux de paramètre est valide ou pas.
           isValid= $HasParameterUnique -and $isPositionValid
         }#PSObject
     Write-Debug "Add $Name key"
     $Sets.$Name=$O
   }#For ParameterSets
   ,$Sets
 }#process
}#Test-ParameterSet
