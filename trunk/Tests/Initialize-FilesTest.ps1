#Initialize-FilesTest.ps1

if (Test-Path $Env:Temp)
{ $Temp=$Env:Temp }
else
{ $Temp=[System.IO.Path]::GetTempPath() }

$TestDirectory=Join-Path $Temp TestPsIonic
Write-host "Test in $TestDirectory"
rm $TestDirectory -rec -force -ea SilentlyContinue >$null
md $TestDirectory -ea SilentlyContinue >$null

$Directories=@(
  'Backup1',
  'Backup2',
  'Backup[1]',
  'Backup[2]',
  'Test[',
  'Test`[',
  'Test[zi]p'
)

$Files=@(
  '[a.txt',
  '`[a.txt',
  'File.txt',
  'File1.txt',
  'File2.txt',
  'File[1].txt',
  'File[2].txt'
)

$verbosePreference='Continue'
foreach ($File in $Files)
{
  $Filename="$TestDirectory\$File"   
  Write-Verbose "Create new file :$Filename"    
  FsUtil.exe file createnew $Filename (get-Random -Maximum 500) >$null
}

foreach ($Directory in $Directories)
{
  md "$TestDirectory\$Directory" -EA SilentlyContinue
  foreach ($File in $Files)
  {
    $Filename="$TestDirectory\$Directory\$File"   
    Write-Verbose "Create new file :$Filename"    
    FsUtil.exe file createnew $Filename (get-Random -Maximum 500) >$null
  }
}
$verbosePreference='SilentlyContinue'
Write-Host "Files:"
dir $TestDirectory\* -Recurse |Select FullName
