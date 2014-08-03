#Requires -Version 3
Function Test-ParameterSet{
<#
.SYNOPSIS
   Détermine si les jeux de paramètres d'une commande sont valides.
   Un jeux de paramètres valide doit contenir au moins un paramètre unique et
   les numéros de positions de ses paramètres doivent se suivre et ne pas être dupliqué.
   Les noms de paramètres débutant par un chiffre invalideront le test.
#>  
 param (
   #Nom de la commande à tester
  [parameter(Mandatory=$True,ValueFromPipeline=$True)]
  [string]$Command
 ) 
begin {
 [string[]] $CommonParameters=[System.Management.Automation.Internal.CommonParameters].GetProperties().Name
 
 function Test-Sequential{
  #Prerequis: la collection doit être triée
  param([int[]]$List)
    $Count=$List.Count
    for ($i = 1; $i -lt $Count; $i++)
    {
       if ($List[$i] -ne $List[$i - 1] + 1)
       {return $false}
    }
    return $true
 }# Test-Sequential

  Function New-ParameterSetValidation{
    param(
       [Parameter(Mandatory=$True,position=0)]
      $ModuleName,       
       [Parameter(Mandatory=$True,position=1)]
      $CommandName,
       [Parameter(Mandatory=$True,position=2)]
      $ParameterSetName,
       [Parameter(Mandatory=$True,position=3)]
      $isValid,
       [Parameter(Mandatory=$True,position=4)]
      $Report
    )
  
    [pscustomobject]@{
      PSTypeName='ParameterSetValidation';
      #Nom du module (optionnel)
      ModuleName=$ModuleName;
       #Nom de la fonction ou du cmdlet testé
      CommandName=$CommandName;
       #Si aucun jeux n'est déclaré le jeu par défaut se nomme '__AllParameterSets'
       #Si aucun jeux n'est déclaré  et que l'attribut CmdletBinding déclare 
       #le paramètre DefaultParameterSetName, alors le jeu par défaut est égale au 
       # nom indiqué par DefaultParameterSetName  
      ParameterSetName=$ParameterSetName;
       #Le jeux est considéré comme valide selon les régles implémentées.
      isValid=$isValid;
       #Détails des régles implémentées. 
      Report=$Report;
     }
}# New-ParameterSetValidation

 Function New-ParameterSetReport{
  #Mémorise les informations.
  #Utiles en cas de construction de rapport
    param(
       [Parameter(Mandatory=$True,position=0)]
       #Liste des paramètres du jeu courant
      $Params,
       [Parameter(Mandatory=$True,position=1)]
       #Liste des paramètres n'appartenant pas au jeu courant
      $Others,
       [Parameter(Mandatory=$True,position=2)]
       #Liste de numéros de position des paramètres du jeu courant
      $Positions,
       [Parameter(Mandatory=$True,position=3)]
        #Liste des paramètres commençant par un chiffre
      $InvalidParameterName,
       [Parameter(Mandatory=$True,position=4)]
       #Un jeux de paramètre valide doit avoir un paramètre unique
       #n'appartenant à aucun autre jeu
      $isHasUniqueParameter,
       [Parameter(Mandatory=$True,position=5)]
        #les numéros de position ne doivent pas être dupliqués 
      $isPositionContainsDuplicate,
       [Parameter(Mandatory=$True,position=6)]
        #les numéros de position doivent se suivre séquentiellement
      $isPositionSequential,
       [Parameter(Mandatory=$True,position=7)]
       #Combinaison des deux champs précédents
      $isPositionValid,
       [Parameter(Mandatory=$True,position=8)]
       #Un nom de paramètre ne doit pas commencer par un chiffre
      $isContainsInvalidParameter,
       [Parameter(Mandatory=$True,position=9)]
       #Les noms de jeux de paramètre doivent être unique
       #PS autorise des noms de jeux sensible à la casse
      $isParameterSetNameDuplicate
   )
  
    [pscustomobject]@{
      PSTypeName='ParameterSetReport';
      Params=$Params;
      Others=$Others;
      Positions=$Positions;
      InvalidParameterName=$InvalidParameterName;
      isHasUniqueParameter=$isHasUniqueParameter;
      isPositionContainsDuplicate=$isPositionContainsDuplicate;
      isPositionSequential=$isPositionSequential;
      isPositionValid=$isPositionValid;
      isContainsInvalidParameter=$isContainsInvalidParameter;
      isParameterSetNameDuplicate=$isParameterSetNameDuplicate
     }
  }# New-ParameterSetReport
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

  $NamesOfParameterSet=$Cmd.ParameterSets.Name
#   if ($_AllNames.Count -eq 0 ) 
#   { return $Sets  }
   
   #Contient les noms des paramètres de tous les jeux
   #Les noms peuvent être dupliqués
  $AllNames=new-object System.Collections.ArrayList(,$_AllNames)
  $ParametersStartsWithNumber=new-object System.Collections.ArrayList
  
  $Cmd.ParameterSets| 
   foreach {
     $ParameterSetName=$_.Name 
     Write-Debug "Validate ParameterSet '$ParameterSetName'."
     
     $isParameterSetNameDuplicate =@($NamesOfParameterSet -eq $ParameterSetName).Count -gt 1
     
      #Contient tous les noms de paramètre du jeux courant
     $Params=new-object System.Collections.ArrayList
      #Contient les positions des paramètres du jeux courant
     $Positions=new-object System.Collections.ArrayList
     $Others=$AllNames.Clone()
     
     $_.Parameters|
      Where {$_.Name -notin $CommonParameters}|
      Foreach {
        $ParameterName=$_.Name
        Write-debug "Add $ParameterName $($_.Position)"
        $Params.Add($ParameterName) > $null
        $Positions.Add($_.Position) > $null
         #Les constructions suivantes sont possibles, mais pas testées : ${der[nier}, ${-1}, etc.
        if ($ParameterName -match "^\d" )
        { 
          Write-debug "Invalide parameter name '$ParameterName'"
          $ParametersStartsWithNumber.Add($ParameterName) > $null 
        }         
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
     
     $isContainsInvalidParameter=$ParametersStartsWithNumber.Count -gt 0

     $isValid= $HasParameterUnique -and $isPositionValid -and -not $isContainsInvalidParameter -and -not $isParameterSetNameDuplicate
     $Report=New-ParameterSetReport $Params `
                                    $Others `
                                    $Positions `
                                    $ParametersStartsWithNumber `
                                    $HasParameterUnique `
                                    $isDuplicate `
                                    $isSequential `
                                    $isPositionValid `
                                    $isContainsInvalidParameter `
                                    $isParameterSetNameDuplicate

     New-ParameterSetValidation  $Cmd.ModuleName `
                                 $Cmd.Name `
                                 $ParameterSetName `
                                 $isValid `
                                 $Report
   }#For ParameterSets
 }#process
}#Test-ParameterSet

