#DemoInvokeErrorEvent
$scriptPath = split-path -Parent (split-path -Parent $MyInvocation.MyCommand.Definition)
. "$scriptPath\Initialize-Demo.ps1"

$zipFileToCreate = "$TestDirectory\ArchiveTest.zip"
 
$TestLockFiles= @(
 (Lock-File "$TestDirectory\A3.dat"),
 (Lock-File "$TestDirectory\A3.log"),
 (Lock-File "$TestDirectory\A3.txt")
 )
try {
  #Archive tous les ficheir demandé sauf les trois ficheirs lockés
  Dir  "$TestDirectory\[AMZ][123].*"|
   Compress-ZipFile -OutputName $zipFileToCreate -ZipErrorAction InvokeErrorEvent -Verbose 
   #Par défaut la présence d'un fichier verrouillé déclenche une exception, la valeur Skip pour -ZipErrorAction passe outre mais en silence.
} 
Finally {
 $TestLockFiles|% {$_.Close()}
}
