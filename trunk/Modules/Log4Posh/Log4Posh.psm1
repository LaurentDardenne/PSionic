#Log4Posh.psm1
 
Import-LocalizedData -BindingVariable Log4PoshMsgs -Filename Log4PoshLocalizedData.psd1 -EA Stop

# ------------ Initialisation et Finalisation  ----------------------------------------------------------------------------

 #On permet un chargement pour la V3 ( fx 4.0)
Add-Type -Path "$psScriptRoot\$($PSVersionTable.PSVersion)\log4net.dll" 

Function Get-ParentProcess {
#Permet de retrouver le process parent ayant ex�cut� 
#la session Powershell ex�cutant ce script/module
 param( $ID )
 $parentID=$ID         
 $Result=@(
   Do {
     $Process=Get-WmiObject Win32_Process -Filter "ProcessID='$parentID'" -property Name,CommandLine,ParentProcessID
      #Permet de retrouver la t�che appelante
      #On peut inclure le nom de la t�che dans la ligne d'appel :
      # ... -Command "$TaskName='TaskCeraKioskMonitorOFF_V1';..."
     #$Logger.DebugFormat("Name :{0}`t cmdLine={1}",@($Process.name,$Process.CommandLine))
     $parentID=$Process.ParentProcessID
     try {
      write-warning $parentID
      get-process -ID $parentID
      $exit=$true
      }
     catch [Microsoft.PowerShell.Commands.ProcessCommandException] {
      $exit=$false       
     }
   } until ($Exit)
 )
   
 $ofs='.'
 [Array]::Reverse($Result)
 ,$Result
} #Get-ParentProcess

 $Hostname=$ExecutionContext.host.Name
 if ($Hostname -eq 'ServerRemoteHost')
 {$_pid= (Get-ParentProcess  $PID)[0].Id}
 else
 {$_pid= $pid}
 #Propri�t� statique, indique le process PowerShell courant
 #Dans un job local ce n'est pas le process courant, mais le parent 
[log4net.GlobalContext]::Properties.Item("Owner")=$_pid
[log4net.GlobalContext]::Properties.Item("RunspaceId")=$ExecutionContext.host.Runspace.InstanceId

 #Propri�t� dynamique, Log4net appel la m�htode ToString de l'objet r�f�renc�.
$Script:JobName= new-object System.Management.Automation.PSObject -Property @{Value=$ExecutionContext.host.Name}
$Script:JobName|Add-Member -Force -MemberType ScriptMethod ToString { $this.Value.toString() }
[log4net.GlobalContext]::Properties["JobName"]=$Script:JobName

$LogShortCut=@{
  LogManager = [log4net.LogManager];
  LogBasicCnfg = [log4net.Config.BasicConfigurator];
  LogXmlCnfg = [log4net.Config.XmlConfigurator];
  LogColoredConsole = [log4net.Appender.ColoredConsoleAppender];
  LogColors = [log4net.Appender.ColoredConsoleAppender+Colors];
  LogLevel = [log4net.Core.Level];
  LogThreadCtx = [log4net.ThreadContext];
  LogGlobalCtx = [log4net.GlobalContext];
  LogMailPriority = [System.Net.Mail.MailPriority];
  LogSmtpAuthentication = [log4net.Appender.SmtpAppender+SmtpAuthentication];
}

Function Start-Log4Net {
#D�marre le m�canisme de log � l'aide d'un fichier de configuration XML
 param (
    [Parameter(Mandatory=$True,Position=0)]  
    [ValidateNotNullOrEmpty()]
  [String] $Path
 )
 
#Param�trage du log4net via un fichier XML sp�cifique         
  $ConfigFile=New-Object System.IO.fileInfo $Path
  Write-debug "load '$Path'" 
  $Result=[Log4net.Config.XmlConfigurator]::Configure($ConfigFile)
  if ($Result.Count -ne 0 )
  { 
    $ofs="`r`n"
    [string]$Message=$Result|Out-String
    throw ( New-Object System.Xml.XmlException $Message) 
  }
}#Start-Log4Net

Function Stop-Log4Net {
#On arr�te proprement,on vide les buffers, puis on stop le framework log4net
#Avec [log4net.LogManager]::Shutdown() tous les appenders sont ferm�s proprement, 
#mais le repository par d�faut reste configur�
 $Logger.Debug("Shutdown log4Net") 
  
 [log4net.LogManager]::GetRepository().GetAppenders()|
  Where {$_ -is  [log4net.Appender.BufferingAppenderSkeleton]}|
  Foreach {
   $Logger.Debug("Flush appender $($_.Name)")           
    $_.Flush() 
  }
   #Shutdown() est appel� en interne, le repository par d�faut n'est plus configur�
 [log4net.LogManager]::ResetConfiguration() 
}#Stop-Log4Net


#<DEFINE %DEBUG%>
#Routine de debug de code
Function Set-Log4NetDebugLevel {
#Bascule le niveau global de log
 param (
   [log4net.Core.Level] $DefaultLevel=[log4net.Core.Level]::Info,
   [switch] $OFF 
 ) 
 
 If ($Logger -ne $null)
 { 
    If ($Off) 
     { $Logger.logger.Hierarchy.Root.Level=$DefaultLevel }
    else
     { $Logger.logger.Hierarchy.Root.Level==[log4net.Core.Level]::Debug } 
 }
 else
 { Write-Warning $Log4PoshMsgs.LoggerDotNotExist }
}#Set-Log4NETDebugLevel

Function Stop-ConsoleAppender {
 If ($Logger -ne $null)
 { 
    $Console=$logger.Logger.Parent.Appenders|Where {$_.Name -eq 'Console'}
    if ($Console -ne $null) 
    { $Console.Threshold=[log4net.Core.Level]::Off }
 }
 else
 { Write-Warning $Log4PoshMsgs.LoggerDotNotExist }
}#Stop-ConsoleAppender

Function Start-ConsoleAppender {
 If ($Logger -ne $null)
 { 
    $Console=$logger.Logger.Parent.Appenders|Where {$_.Name -eq 'Console'}
    if ($Console -ne $null) 
    { $Console.Threshold=[log4net.Core.Level]::Debug }
 }
 else
 { Write-Warning $Log4PoshMsgs.LoggerDotNotExist }
}#Start-ConsoleAppender
#<UNDEF %DEBUG%>   

 #D�finition des couleurs d'affichage par d�faut
[System.Collections.Hashtable[]] $LogDefaultColors=@(
   @{Level="Debug";FColor="Green";BColor=""},
   @{Level="Info";FColor="White";BColor=""},
   @{Level="Warn";FColor="Yellow,HighIntensity";BColor=""},
   @{Level="Error";FColor="Red,HighIntensity";BColor=""},
   @{Level="Fatal";FColor="Red";BColor="Red,HighIntensity"}
 )

 # ------------- Type Accelerators -----------------------------------------------------------------
function Get-Log4NetShorcuts {
  #Affiche les raccourcis d�di�s � Log4net
 $AcceleratorsType::Get.GetEnumerator()|Where {$_.Value.FullName -match "^log4net\.(.*)"}
}#Get-Log4NetShorcuts
 
$AcceleratorsType = [PSObject].Assembly.GetType("System.Management.Automation.TypeAccelerators")   
 # Ajoute les raccourcis de type    
 Try {
  $LogShortCut.GetEnumerator() |
  Foreach {
   Try {
     Write-debug "Add TypeAccelerators $($_.Key) =$($_.Value)"
     $AcceleratorsType::Add($_.Key,$_.Value)
   } Catch [System.Management.Automation.MethodInvocationException]{
     write-Error $_.Exception.Message 
   }
  } 
 } Catch [System.Management.Automation.RuntimeException] 
 {
   write-Error $_.Exception.Message
 }

#------------------------ Code -------------------------------------------

function Set-Log4NetBasicConfigurator {
  Param (   
    [Parameter(Position=0,
               Mandatory=$True,
               ValueFromPipelineByPropertyName = $true,
               ParameterSetName="Appender")]
    [log4net.Appender.AppenderSkeleton] 
   $Appender,
    [Parameter(ParameterSetName="Default")]
    [Switch] 
   $Default)
    
 #Configure le Framework, le root pointera sur $Appender 
  process #Gestion du pipeline  
  {
     Stop-Log4Net #Sinon on ajoute la nouvelle configuration � l'existante
     if ($Default) 
      { [log4net.Config.BasicConfigurator]::Configure() }
     else 
      { [log4net.Config.BasicConfigurator]::Configure($Appender) }
	  $Appender
  }
}#Set-Log4NetBasicConfigurator

# -------------  Logger ----------------------------------------------------------------------------
function Get-Log4NetLoggers {
  #Renvoi tous les loggers du repository par d�faut
  #The root logger is not included in the returned array. 
 [log4net.LogManager]::GetCurrentLoggers()
}#Get-Log4NetLoggers

function Get-Log4NetLogger {
  Param (   
    [Parameter(Position=0,
                 Mandatory=$True,
                 ValueFromPipelineByPropertyName = $true)]
    [ValidateNotNullOrEmpty()]
    [String] 
   $Name)
 #Renvoi un logger de nom $Name ou le cr�e s'il n'existe pas. 
 # le nom "Root" est valide et renvoi le root existant
 
  process
  {  [log4net.LogManager]::GetLogger($Name)  }
} #Get-Log4NetLogger

function Get-Log4NetLoggerRepository {
  Param (   
    [Parameter(Position=0,
                 Mandatory=$True,
                 ValueFromPipelineByPropertyName = $true)]
    [ValidateNotNullOrEmpty()]
    [String] 
   $RepositoryName,
    [ValidateNotNullOrEmpty()]
    [String] 
   $Name)
 #Renvoi un logger de nom $Name ou le cr�e s'il n'existe pas. 
 # le nom "Root" est valide et renvoi le root existant
 process {
   [log4net.LogManager]::GetLogger($RepositoryName,$Name)
 }
} #Get-Log4NetLoggerRepository

function Get-Log4NetRootLogger {
  Param (   
     [ValidateNotNull()]
     [ValidateScript( {Test-IsImplementingInterface $_ "log4net.Core.ILoggerWrapper"} )]
     [Parameter(Position=0,
                Mandatory=$True,
                ParameterSetName="Logger")]
    $Logger, 
     [Parameter(ParameterSetName="Default")]
     [Switch] 
    $Default)
 #Renvoi le logger racine du logger pass� en param�tre   
 if ($Default) 
  { $Repository=Get-LogRepository -Default }  
 else 
  {$Repository=$Logger.Repository }
 $Repository.Root
} #Get-Log4NetRootLogger

Function Set-Log4NetFileName {
#Change le nom de fichier d'un FileAppender 
 param (
     [ValidateNotNullOrEmpty()]
     [Parameter(Position=0, Mandatory=$true)]
   [string] $AppenderName,
    [ValidateNotNullOrEmpty()]
    [Parameter(Position=1, Mandatory=$true)]    
   [string] $NewFileName
)
   
 $result=@(
   [log4net.LogManager]::GetRepository().GetAppenders()|
     Where {
      ($_.Name -eq $AppenderName) -and  ($_ -is [log4net.Appender.FileAppender])
     }
 )
 if ($Result.Count -ne 0) 
 {
   $Result[0].File = $NewFileName
   $Result[0].ActivateOptions()
 }
else 
 { Write-Error "L'appender de nom $AppenderName n'existe pas."}  
}#Set-Log4NetFileName

# ----------- Suppression des objets du Wrapper -------------------------------------------------------------------------
function OnRemoveLog4Posh {
   #Remove shortcuts
  $LogShortCut.GetEnumerator() |
    Foreach {
     Try {
       Write-debug "Remove TypeAccelerators $($_.Key)"
       [void]$AcceleratorsType::Remove($_.Key)
     } Catch {
       write-Error $_.Exception.Message
     }
  }
}

$MyInvocation.MyCommand.ScriptBlock.Module.OnRemove = { OnRemoveLog4Posh } 
$MyInvocation.MyCommand.ScriptBlock.Module.AccessMode="ReadOnly"

$F=@(
   #<DEFINE %DEBUG%>
  'Set-Log4NETDebugLevel',
  'Stop-ConsoleAppender',
  'Start-ConsoleAppender'                                                          
   #<UNDEF %DEBUG%>	
  'Start-Log4Net',
  'Stop-Log4Net',
  'Get-Log4NetShorcuts',
  'Set-Log4NetBasicConfigurator',
  'Get-Log4NetLoggers',
  'Get-Log4NetLogger',
  'Get-Log4NetLoggerRepository',
  'Get-Log4NetRootLogger',
  'Set-Log4NetFileName',
  'Get-ParentProcess'
)

#<DEFINE %DEBUG%>
Set-Alias -name Set-DebugLevel -value Set-Log4NETDebugLevel
Set-Alias -name dbglvl         -value Set-Log4NETDebugLevel
Set-Alias -name sca            -value Stop-ConsoleAppender
#<UNDEF %DEBUG%> 

Export-ModuleMember -Variable LogDefaultColors,JobName  -Alias * -Function $F
