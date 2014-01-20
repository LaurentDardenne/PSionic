Function Compare-PSObject {
 param (
  [PSObject] $ObjectOne,
  [PSObject] $ObjectTwo         
 )
 
  $p1 = $($ObjectOne.PSObject.Properties)
  $p2 = $($ObjectTwo.PSObject.Properties)
  Compare-Object $p1 $p2 -Property Name,Value | Sort-Object Name
}#Compare-PSObject