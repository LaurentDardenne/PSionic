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
  
  foreach($entry in $ZipFile)
  { $entry.LastModified = $fixedTimestamp }
}

#todo chemins des fichiers de test
Get-ChildItem C:\temp\PsIonic  -Exclude *.zip,*.exe -rec|
 Where {!$_.psiscontainer}| 
 Compress-ZipFile -OutputName C:\temp\Archive.zip -ErrorAction Stop -SetLastModifiedProperty $sbUToldest
