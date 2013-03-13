#Create a setup into a self-extracting archive 
 
$PathModule=[System.IO.Path]::GetTempPath()  -replace '\\$',''
Write-Host "Temp path : $PathModule"
$pathModule
$OutPath="$PathModule}\MyProject"
if (-not (Test-Path  $OutPath))  
 {MD $OutPath -Verbose} 

 #Create a test module
@"
Function Get-Files{
 Dir C:\Windows
}

New-Alias glf Get-Files  
"@ > "$PathModule\MyModule.psm1"


 #Create an installation script for the test module
@'
try {
  function Pause ($Message="Press any key to continue...")
  {
   Write-Host -NoNewLine $Message
   $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
   Write-Host ""
  }
    
  $My= Split-Path $MyInvocation.MyCommand.Path
  Start-Transcript "$My\SetupMyModule.Log" -ea SilentlyContinue
  Write-Host 
   
  $ExpectedUserModulePath = Join-Path -Path ([Environment]::GetFolderPath('MyDocuments')) -ChildPath WindowsPowerShell\Modules
  
  Copy "$My\MyModule.psm1" "$ExpectedUserModulePath\MyModule\MyModule.psm1" -whatif
   Write-Host 
  
  #etc
  Write-Host "[$(Get-Date)] Setup..." -fore Green
  Pause
  
} 
Finally {  
 Stop-Transcript 
} 
'@ > "$PathModule\MySetup.ps1"
 
 #Create options for generating a self-extracting archive. 
 $SfxConfiguration=New-ZipSfxOptions -Description "Setup MyModule" -ExeOnUnpack "Powershell -noprofile -File .\MySetup.ps1"

 #Create a self-extracting archive.
"$PathModule\MyModule.psm1",
"$PathModule\MySetup.ps1" |
 Compress-ZipFile -Name "$PathModule\myProject.exe" -Options $SfxConfiguration -SFX     

#Delete the files
"$PathModule\MyModule.psm1",
"$PathModule\MySetup.ps1"|
 Remove-Item
 
 #Show help and the command line.
&"$PathModule\myproject.exe" -?

#go
#Extract the files and run 'MySetup.ps1'
&"$PathModule\myproject.exe" -o
 
type "$PathModule\MyProject\SetupMyModule.Log"

#Import-Module MyModule
#Get-Module
 