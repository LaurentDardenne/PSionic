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

if (Test-Path $Env:Temp)
{ $Temp=$Env:Temp }
else
{ $Temp=[System.IO.Path]::GetTempPath() -replace '\\$','' }

$TestDirectory="$Temp\TestPsIonic"
Write-host "Test in $TestDirectory"
md $TestDirectory -ea SilentlyContinue >$null
 
$zipFileToCreate = "$Temp\ArchiveTest.zip"
 
fsutil file createnew "$TestDirectory\testfile1.txt" 1000 >$null
fsutil file createnew "$TestDirectory\testfile2.log" 500 >$null
fsutil file createnew "$TestDirectory\testfile3.txt" 20 >$null
fsutil file createnew "$TestDirectory\testfile4.dat" 3000 >$null
fsutil file createnew "$TestDirectory\testfile5.txt" 10000 >$null

$TestLockFiles= @(
 (Lock-File "$TestDirectory\testfile5.txt"),
 (Lock-File "$TestDirectory\testfile4.dat"),
 (Lock-File "$TestDirectory\testfile1.txt")
 )
try {
  Dir  "$TestDirectory\testfile?.txt"|
   Compress-ZipFile -OutputName $zipFileToCreate -ZipErrorAction InvokeErrorEvent #-Verbose 
} 
Finally {
 $TestLockFiles|% {$_.Close()}
}
