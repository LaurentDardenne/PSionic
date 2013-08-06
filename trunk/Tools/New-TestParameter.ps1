function New-TestSetParameters{
#Génére le produit cartésien de chaque jeux de paramètre d'une commande
#adapted from : #http://makeyourownmistakes.wordpress.com/2012/04/17/simple-n-ary-product-generic-cartesian-product-in-powershell-20/
 [CmdletBinding(DefaultParameterSetName="Nammed")]
 [OutputType([System.String])]
 param (
   
   [parameter(Mandatory=$True,ValueFromPipeline=$True)]
   [ValidateNotNull()]
  [System.Management.Automation.CommandInfo] $CommandName,
    
    [ValidateNotNullOrEmpty()]
    [Parameter(Position=0,Mandatory=$false,ParameterSetName="Nammed")]
  [string[]] $ParameterSetNames='__AllParameterSets',
    
    [ValidateNotNullOrEmpty()]
    [Parameter(Position=0,Mandatory=$false,ParameterSetName="All")]
  [string[]] $Exclude,
    [Parameter(ParameterSetName="All")]
  [switch] $All
)       

 begin {
  # Common parameters
  # [System.Management.Automation.Internal.CommonParameters].GetProperties()|Foreach {$_.name} 
  #  -Verbose (vb) -Debug (db) -WarningAction (wa)
  #  -WarningVariable (wv) -ErrorAction (ea) -ErrorVariable (ev)
  #  -OutVariable (ov) -OutBuffer (ob) -WhatIf (wi) -Confirm (cf)

  function getValue{
     if ($Value -eq $false)
     {
       Write-Debug "Switch is `$false, dont add the parameter name : $Result."
       return "$result"
     }
     else
     {
       Write-Debug "Switch is `$true, add only the parameter name : $result$Bindparam"
       return "$result$Bindparam"
     }
  }#getValue
  
  function AddToAll{
   param (
     [System.Management.Automation.CommandParameterInfo] $Parameter,
     $currentResult, 
     $valuesToAdd
   )
    Write-Debug "Treate '$($Parameter.Name)' parameter."
    Write-Debug "currentResult =$($currentResult.Count -eq 0)"
    $Bindparam=" -$($Parameter.Name)" 
      #Récupère une information du type du paramètre et pas la valeur liée au paramètre
    $isSwitch=($Parameter.parameterType.FullName -eq 'System.Management.Automation.SwitchParameter')
    Write-Debug "isSwitch=$isSwitch"
    $returnValue = @()
    if ($valuesToAdd -ne $null)
    {
      foreach ($value in $valuesToAdd)
      {
        Write-Debug "Add Value : $value "
        if ($currentResult -ne $null)
        {
          foreach ($result in $currentResult)
          {
            if ($isSwitch) 
            { $returnValue +=getValue } 
            else
            {
              Write-Debug "Add parameter and value : $result$Bindparam $value"
              $returnValue += "$result$Bindparam $value"
            }
          }#foreach
        }
        else
        {
           if ($isSwitch) 
           { $returnValue +="$($CommandName.Name)$(getValue)" } 
           else 
           {
             Write-Debug "Add parameter and value :: $Bindparam $value"
             $returnValue += "$($CommandName.Name)$Bindparam $value"
           }
        }
      }
    }
    else
    {
      Write-Debug "ValueToAdd is `$Null :$currentResult"
      $returnValue = $currentResult
    }
    return $returnValue
  }#AddToAll  
 }#begin

  process {
          
   foreach ($Set in $CommandName.ParameterSets)
   {
      if (-not $All -and ($ParameterSetNames -notcontains $Set.Name)) 
      { continue }
      elseif ( $All -and ($Exclude -contains $Set.Name)) 
      {
        Write-Debug "Exclude $($Set.Name) "
        continue
      }
      
      $returnValue = @()
      Write-Debug "Current set name is $($Set.Name) "
      Write-Debug "Parameter count=$($Set.Parameters.Count) "
      #Write-Debug "$($Set.Parameters|Select name|out-string) "
      foreach ($parameter in $Set.Parameters)
      {
        $Values=Get-Variable -Name $Parameter.Name -Scope 1 -ea SilentlyContinue
        if ( $Values -ne $Null) 
        { $returnValue = AddToAll -Parameter $Parameter $returnValue $Values.Value }
        else
        { $PSCmdlet.WriteWarning("The variable $($Parameter.Name) is not defined, processing the next parameter.") } 
      }
     New-Object PSObject -Property @{CommandName=$CommandName.Name;SetName=$Set.Name;Lines=$returnValue.Clone()}
   }#foreach
  }#process
} #New-TestSetParameters

<#
 #récupère les métadonnées d'une commande
$cmd=Get-Command Test-Path
 #Déclare un variable portant le même nom que le paramètre qu'on souhaite
 #inclure dans le produit cartésien. 
 #Chaque valeur du tableau crée une ligne d'appel 
$Path=@(
  "'c:\temp\unknow.zip'",
  "'Test.zip'",
  "(dir variable:OutputEncoding)",
  "'A:\test.zip'",
  "(Get-Item 'c:\temp')",
  "(Get-Service Winmgmt)",
  'Wsman:\*.*',
  'hklm:\SYSTEM\CurrentControlSet\services\Winmgmt'
)
#Le paramètre 'PathType' est une énumération de type booléen
$PathType=@("'Container'", "'Leaf'")
#Génére les combinaisons du jeu de paramètre nommée 'Path'
#Les paramètres qui ne sont pas associé à une variable, génére un warning.
$result=New-TestSetParameters -command $Cmd  -ParameterSetNames Path

#Nombre de lignes construites
$result.lines.count
#Exécution, Test-path n'a pas d'impact sur le FileSystem
$result.lines|% {Write-host $_ -fore green;$_}|Invoke-Expression

#On ajoute le paramètre 'iSValide' de type booléen
$isValid= @($true,$false)

#Génére les combinaisons du jeu de paramètre nommée 'Path'
#On supprime la génération du warning.
$result=New-TestSetParameters -command $Cmd  -ParameterSetNames Path -WarningAction 'SilentlyContinue'
#Nombre de lignes construites
$result.lines.count
#Tri des chaine de caractères puis exécution
$Result.lines|Sort-Object|% {Write-host $_ -fore green;$_}|Invoke-Expression

#On peut aussi générer du code de test pour Pester ou un autre module de test :
$Template=@'
#
    It "Test ..TODO.." {
        try{
          `$result = $_ -ea Stop
        }catch{
            Write-host "Error : `$(`$_.Exception.Message)" -ForegroundColor Yellow
             `$result=`$false
        }
        `$result | should be (`$true)
    }
'@
$Result.Lines| % { $ExecutionContext.InvokeCommand.ExpandString($Template) }
#>