#Log4Posh.psm1
 
Import-LocalizedData -BindingVariable Log4PoshMsgs -Filename Log4PoshLocalizedData.psd1 -EA Stop

# ------------ Initialisation et Finalisation  ----------------------------------------------------------------------------

 #On permet un chargement pour la V3 ( fx 4.0)
Add-Type -Path "$psScriptRoot\$($PSVersionTable.PSVersion)\log4net.dll" 

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
#Démarre le mécanisme de log à l'aide d'un fichier de configuration XML
 param (
    [Parameter(Mandatory=$True,Position=0)]  
    [ValidateNotNullOrEmpty()]
  [String] $Path
 )
 
#Paramètrage du log4net via un fichier XML spécifique         
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
#On arrête proprement,on vide les buffers, puis on stop le framework log4net
#Avec [log4net.LogManager]::Shutdown() tous les appenders sont fermés proprement, 
#mais le repository par défaut reste configuré
 $Logger.Debug("Shutdown log4Net") 
  
 [log4net.LogManager]::GetRepository().GetAppenders()|
  Where {$_ -is  [log4net.Appender.BufferingAppenderSkeleton]}|
  Foreach {
   $Logger.Debug("Flush appender $($_.Name)")           
    $_.Flush() 
  }
   #Shutdown() est appelé en interne, le repository par défaut n'est plus configuré
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

 #Définition des couleurs d'affichage par défaut
[System.Collections.Hashtable[]] $LogDefaultColors=@(
   @{Level="Debug";FColor="Green";BColor=""},
   @{Level="Info";FColor="White";BColor=""},
   @{Level="Warn";FColor="Yellow,HighIntensity";BColor=""},
   @{Level="Error";FColor="Red,HighIntensity";BColor=""},
   @{Level="Fatal";FColor="Red";BColor="Red,HighIntensity"}
 )

 # ------------- Type Accelerators -----------------------------------------------------------------
function Get-Log4NetShorcuts{
  #Affiche les raccourcis dédiés à Log4net
 $AcceleratorsType::Get.GetEnumerator()|Where {$_.Value.FullName -match "^log4net\.(.*)"}
}
 
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

function Set-Log4NetBasicConfigurator{
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
     Stop-Log4Net #Sinon on ajoute la nouvelle configuration à l'existante
     if ($Default) 
      { [log4net.Config.BasicConfigurator]::Configure() }
     else 
      { [log4net.Config.BasicConfigurator]::Configure($Appender) }
	  $Appender
  }
}


# -------------  Logger ----------------------------------------------------------------------------
function Get-Log4NetLoggers{
  #Renvoi tous les loggers du repository par défaut
  #The root logger is not included in the returned array. 
 [log4net.LogManager]::GetCurrentLoggers()
}

function Get-Log4NetLogger{
  Param (   
    [Parameter(Position=0,
                 Mandatory=$True,
                 ValueFromPipelineByPropertyName = $true)]
    [ValidateNotNullOrEmpty()]
    [String] 
   $Name)
 #Renvoi un logger de nom $Name ou le crée s'il n'existe pas. 
 # le nom "Root" est valide et renvoi le root existant
 
  process
  {  [log4net.LogManager]::GetLogger($Name)  }
}

function Get-Log4NetLoggerRepository{
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
 #Renvoi un logger de nom $Name ou le crée s'il n'existe pas. 
 # le nom "Root" est valide et renvoi le root existant
 process {
   [log4net.LogManager]::GetLogger($RepositoryName,$Name)
 }
}

function Get-Log4NetRootLogger {
  Param (   
     [ValidateNotNull()]
     [ValidateScript( {Test-IsImplementingInterface $_ "log4net.Core.ILoggerWrapper"} )]
     [Parameter(Position=0,
                Mandatory=$True,
                ValueFromPipelineByPropertyName = $true,  #todo impleter Process ou le pipe est inutile
                ParameterSetName="Logger")]
    $Logger, 
     [Parameter(ParameterSetName="Default")]
     [Switch] 
    $Default)
 #Renvoi le logger racine du logger passé en paramètre   
 if ($Default) 
  { $Repository=Get-LogRepository -Default }  
 else 
  {$Repository=$Logger.Repository }
 $Repository.Root
}

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
  'Get-Log4NetRootLogger'
)

#<DEFINE %DEBUG%>
Set-Alias -name Set-DebugLevel -value Set-Log4NETDebugLevel
Set-Alias -name dbglvl         -value Set-Log4NETDebugLevel
Set-Alias -name sca            -value Stop-ConsoleAppender
#<UNDEF %DEBUG%> 

Export-ModuleMember -Variable LogDefaultColors  -Alias * -Function $F

