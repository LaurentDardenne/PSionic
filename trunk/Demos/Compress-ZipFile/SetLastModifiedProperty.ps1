$scriptPath = split-path -Parent (split-path -Parent $MyInvocation.MyCommand.Definition)
. "$scriptPath\Initialize-Demo.ps1

$SbUTnewest={
  $fixedTimestamp = New-Object System.DateTime(1601,1,1,0,0,0)
  foreach($entry in $ZipFile)
  {
    if ($entry.LastModified -gt $fixedTimestamp)
    { $fixedTimestamp = $entry.LastModified }
  }
  
  foreach($entry in $zipFile)
  { $entry.LastModified = $fixedTimestamp }
}

$sbUToldest={
  $fixedTimestamp = "10/01/2014 16:37" -as [Datetime]             

  foreach($entry in $ZipFile)
  {
    if ($entry.LastModified -lt $fixedTimestamp)
    { $fixedTimestamp = $entry.LastModified }
  }

  foreach($entry in $ZipFile)
  { $entry.LastModified = $fixedTimestamp }
}

$sbTimestamp={
  $fixedTimestamp = [Datetime]::Now  
  #or
  #  $fixedTimestamp = "10/01/2014 16:37" -as [Datetime]                   
  
  foreach($entry in $ZipFile)
  { $entry.LastModified = $fixedTimestamp }
}

Get-ChildItem $TestDirectory -Exclude *.zip|
 Where {!$_.psiscontainer}| 
 Compress-ZipFile -OutputName "$TestDirectory\LastModifiedProperty.zip" -ErrorAction Stop -SetLastModifiedProperty $sbUToldest
