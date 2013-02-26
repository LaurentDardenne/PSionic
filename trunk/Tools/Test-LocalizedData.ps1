Function Test-LocalizedData {
# Test-LocalizedData '$PsionicTrunk' 'PsIonicLocalizedData.psd1' 'Psionic.Psm1' 'Messagetable\.'
 [CmdletBinding()]
 param(
     [Parameter(Mandatory=$true,ValueFromPipeline = $true)]
   $Culture, 
     [Parameter(Position=0, Mandatory=$true)] 
   $Path,
   [Parameter(Position=1, Mandatory=$true)]
   $LocalizedFilename,
   [Parameter(Position=2, Mandatory=$true)]
   $FileName,
   [Parameter(Position=3, Mandatory=$false)]
   $PrefixPattern
  ) 
 process {          
  try {
   $result=$true
    Push-location $pwd
    Write-Verbose "Valide the culture $Culture" 
    Write-Debug "[$Culture] current directory $Path"
    Set-Location $Path 
    Import-LocalizedData -BindingVariable Msg -Filename $LocalizedFilename -UI $Culture -BaseDirectory $Path -ea Stop
    
    $Text=Get-Content $FileName
    
    $Msg.Keys|
     Foreach {
      $CurrentName=$_
      Write-Debug "Search the key $_"  
       #bug : https://connect.microsoft.com/PowerShell/feedback/details/684218/select-strings-quiet-never-returns-false
      [bool](Select-string -input $Text -Pattern "$PrefixPattern${_}" -Quiet)
     }| 
     Where { $_ -eq $false}|
     Foreach { 
      $Result=$false
      Write-Warning "The Key $CurrentName is unused in the .psd1 $FileName."
     }
  } Finally {
      Pop-location
      $Result 
  }
 }
 } #Test-LocalizedData
 