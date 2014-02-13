function Show-BalloonTip  
{
#HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\TrayNotify dword: 29 
# To configure how long to show tooltips:
# 
#     [HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\TrayNotify]
#     BalloonTip = 3 (Time in seconds) 
  [CmdletBinding(SupportsShouldProcess = $true)]
  param
  (
    [Parameter(Mandatory=$true)]
    $Text,
   
    [Parameter(Mandatory=$true)]
    $Title,
   
    [ValidateSet('None', 'Info', 'Warning', 'Error')]
    $Icon = 'Info',

    $Timeout = 10000
  )
 
  Add-Type -AssemblyName System.Windows.Forms

  if ($script:balloon -eq $null)
  {
    $script:balloon = New-Object System.Windows.Forms.NotifyIcon
  }

  $path                    = Get-Process -id $pid | Select-Object -ExpandProperty Path
  $script:balloon.Icon            = [System.Drawing.Icon]::ExtractAssociatedIcon($path)
  $script:balloon.BalloonTipIcon  = $Icon
  $script:balloon.BalloonTipText  = $Text
  $script:balloon.BalloonTipTitle = $Title
  $script:balloon.Visible         = $true

  $script:balloon.ShowBalloonTip($Timeout)
} 

