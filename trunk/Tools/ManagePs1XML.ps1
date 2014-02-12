$Formats=@(
 'C:\Temp\PsIonic\PsIonic\FormatData\PsIonic.ZipEntry.Format.ps1xml',
 'C:\Temp\PsIonic\PsIonic\FormatData\PsIonic.ReadOptions.Format.ps1xml'
)

$Types=@(
 'C:\Temp\PsIonic\PsIonic\TypeData\System.ZipEntry.Types.ps1xml' 
)

Function Search-ETSPs1xmlIndex {
#Recherche dans $RunspaceCollection
#le numéro d'index de chaque fichier présent dans $XMLFiles
 param (
  $RunspaceCollection,
  $XMLFiles
 )         
           
  $i=-1
  $RunspaceCollection|
   Foreach-object {$i++;($Current=$_)}|
   Where-object {
    #Write-Debug "[$i] search $Current"
    $XMLFiles  -Contains $_.Filename 
   }|
   Foreach {
    Write-Debug "[$i] match $Current"        
    New-Object PSObject -property @{ index=$i;value=$Current}  
   }
}#Search-ETSPs1xmlIndex

Function Remove-ETSPs1XMLData {
#Supprime des entrées indexées dans $RunspaceCollection
#$ItemsIndex contient la liste des entrés à supprimés.
#Les numéro d'index sont déceémernté à chaque suppression
 param (
  $RunspaceCollection,
  $ItemsIndex
 )     

 $Count=0
 $ItemsIndex|
  Sort-Object Index|
  Foreach-Object {
   Write-Debug ("Supprime {0}" -F $_.Value.Filename)   
   $RunspaceCollection.RemoveItem(($_.Index-$Count))
   $Count++
  }
}#Remove-ETSPs1XMLData

$RS=[System.Management.Automation.Runspaces.Runspace]::DefaultRunspace
$FrmtIndex=Search-ETSPs1xmlIndex $rs.RunspaceConfiguration.Formats $Formats
Remove-ETSPs1XMLData $rs.RunspaceConfiguration.Formats $FrmtIndex 

$TypesIndex=Search-ETSPs1xmlIndex $rs.RunspaceConfiguration.Types $Types
Remove-ETSPs1XMLData $rs.RunspaceConfiguration.Types $TypesIndex 

