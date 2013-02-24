#DemoInvokeErrorEvent

if ((Get-Module PsIonic) -eq $null) 
{
  try {
   ipmo Psionic  -EA stop
  } catch {
   Throw "Module PsIonic unavailable."
  }

Function Lock-File([string] $Path)
{
  New-Object System.IO.FileStream($Path, 
                                  [System.IO.FileMode]::Open, 
                                  [System.IO.FileAccess]::ReadWrite, 
                                  [System.IO.FileShare]::None)
}

$temp=[System.IO.Path]::GetTempPath() -replace '\\$',''
fsutil file createnew "$Temp\TestPsIonic\testfile1.txt" 1000 >$null
fsutil file createnew "$Temp\TestPsIonic\testfile2.log" 500 >$null
fsutil file createnew "$Temp\TestPsIonic\testfile3.txt" 20 >$null
fsutil file createnew "$Temp\TestPsIonic\testfile4.dat" 3000 >$null
fsutil file createnew "$Temp\TestPsIonic\testfile5.txt" 10000 >$null

$TestLockFiles= @(
 (Lock-File "$Temp\testfile5.txt"),
 (Lock-File "$Temp\testfile4.dat"),
 (Lock-File "$Temp\testfile1.txt")
 )
 
$directoryToZip = "$Temp\TestPsIonic"
md $directoryToZip -ea SilentlyContinue > $null
$directoryToZip = Get-Item $directoryToZip
 
$zipFileToCreate = "$Temp\ArchiveTest.zip"
  try {
    $zip =  new-object Ionic.Zip.ZipFile
    $zip.StatusMessageTextWriter= [System.Console]::Out;
    $ZH.SetZipErrorHandler($zip)
    $Zip.ZipErrorAction = "InvokeErrorEvent"

    #ATTENTION crée une archive avec *.* en nom de répertoire todo test
   [void]$Zip.AddDirectory($directoryToZip.FullName, $directoryToZip.Name)
    [void]$Zip.Save($zipFileToCreate)
  } 
  Finally {
   $Zip.Dispose()
   $TestLockFiles|% {$_.Close()}
  }
