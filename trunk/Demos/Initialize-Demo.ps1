#Initialize-Demo.ps1
Write-Warning "Initialize PsIonic Demos"

if ((Get-Module PsIonic) -eq $null) 
{
  try {
   ipmo Psionic -EA stop
  } catch {
   Throw "Module PsIonic unavailable."
  }
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
{ $Temp=[System.IO.Path]::GetTempPath() }

$TestDirectory=Join-Path $Temp TestPsIonic
Write-host "Test in $TestDirectory"
md $TestDirectory -ea SilentlyContinue >$null

if (-not (test-path "$TestDirectory\DatasDemos.xml") )
{
  $Date=[datetime]::now
  
  $Datas=@{}
  $Datas.Names=@('A','M','Z')
  $Datas.Extensions=@('.txt','.log','.dat')
  $Datas.Dates=@(
   $Date,              #Fichiers *1.*
   $Date.Adddays(-1),  #Fichiers *2.*
   $Date.Adddays(-2)   #Fichiers *3.*
   )
   
  $Datas|Export-CliXML "$TestDirectory\DatasDemos.xml"
  
  foreach ($name in $Datas.Names)
  {
    foreach ($extension in $Datas.Extensions)
    {
      1..3|
      Foreach {
        $Current=$_
        $Filename="$TestDirectory\$name$Current$extension"      
        FsUtil.exe file createnew $Filename (get-Random -Maximum 1000) >$null
         #touchFile
        switch ($Current) {
           2 {  Set-ItemProperty -Path $Filename -Name LastWriteTime -Value $Datas.Dates[1]}    
           3 {  Set-ItemProperty -Path $Filename -Name LastWriteTime -Value $Datas.Dates[2]}
        } 
      }
    }
  }
  Write-Host "Files:"
  dir "$TestDirectory\[AMZ][123].*"|sort LastWriteTime,name
}