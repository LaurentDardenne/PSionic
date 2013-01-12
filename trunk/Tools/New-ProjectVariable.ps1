function New-ProjectVariable {
 param (
     [Parameter(Position=0, Mandatory=$true)]
     [ValidateNotNullOrEmpty()]
   [string]$ProjectName, 
     
     [Parameter(Position=1, Mandatory=$true)]
     [ValidateNotNullOrEmpty()]
   [string]$SvnPath,
     
     [Parameter(Position=2, Mandatory=$true)]
     [ValidateNotNullOrEmpty()]
   [string]$URlSvnServer,
     
     [Parameter(Position=3, Mandatory=$false)]
     [ValidateNotNullOrEmpty()]
  [System.Collections.IDictionary] $ProjectParameters,

     [Parameter(Mandatory=$false)]
   [int]$Scope=1
 )
  
  # Hashtable 'primaire'
  # Ces clés peuvent être référencées dans le code de l'appelant
  $Properties=@{
     ProjectName=$ProjectName;
     Url=$URlSvnServer;
     Svn="$SvnPath\$ProjectName";
     Trunk="$SvnPath\$ProjectName\trunk";
  }
  
  # Ajoute la hashtable additionnelle si besoin
  if ($PSBoundParameters.ContainsKey('ProjectParameters'))
  { 
       #Construit les noms de chemins
      $New=@{}
      $ProjectParameters.GetEnumerator() | 
       Foreach { 
          #V3 Bug 
          #$_.Value=$ExecutionContext.InvokeCommand.ExpandString(($_.Value))
          #une chaîne de type '$($Properties.Trunk)\Bin' -> Null Reference exception
         Write-debug "Before $($_.value)"
         $New."$($_.Key)"=iex "`"$($_.value)`""
         Write-debug ("After " + $New."$($_.Key)")
       }
      $Properties +=$New 
  }

  New-Object PSObject -Property  $Properties |
   Add-Member -Passthru -Member ScriptMethod -Name NewVariables -Value { 
    $this.Psobject.Properties | 
      Foreach {
          # Crée, à partir de la hastable d'un projet, 
          # une variable constante par clé et ce dans le scope de l'appelant.
          # Le nom de la variable est préfixée par le nom du projet 
          # on évite les collisions de noms et facilite la saisie lors de la substitution de chaîne 
        New-Variable "$($this.ProjectName)$($_.Name)" -Value $Value -Option Constant  -Scope 1
      }
  } 
} #New-ProjectVariable

#Exemple :
#
#  #Pour cette hashtable on retarde la substitution, 
#  #car on référence des clés de la hashtable 'primaire' 
#  # déclarées dans la fonction New-ProjectVariable
# $Paths=@{
#  Bin='$($Properties.Trunk)\Bin'; 
#  Livraison='C:\Temp\$Projectname';  
#  Tests='$($Properties.Trunk)\Tests';
#  Tools='$($Properties.Trunk)\Tools'
# }
# 
# 
# $PsIonic=New-ProjectVariable 'PsIonic' 'G:\PS' 'https://psionic.svn.codeplex.com/svn' $Paths
# $PsIonic