#requires -version 2.0

. .\New-ProjectVariable.ps1


$PsIonic=New-ProjectVariable $ProjectName  $SvPathRepository 'https://psionic.svn.codeplex.com/svn' $Paths
$PsIonic.NewVariables() #Crée des variables constante d'après les clées de la hashtable $PsIonic

$Lg4nPath="$PsIonicBin\Debug\log4net\2.0\log4net.dll"
if ($PSVersionTable.PSVersion -eq 3.0)
{ $Lg4nPath="$PsIonicBin\Debug\log4net\4.0\log4net.dll"}
 
 #Charge Log4Net
Add-type -Path $Lg4nPath

#Crée le fichier de config à partir du template Log4Net.Config.xml
md $PsIonicLogs -ea SilentlyContinue

$Lines=[System.IO.File]::ReadAllText("$PsIonicTools\Log4Net.Config.xml")
#bug V3 seul un nom de variable peut être utilisé et pas $var.method()
$PsIonicLogsLg4n=$PsIonicLogs.Replace('\','\\') 
$ExecutionContext.InvokeCommand.ExpandString($Lines) |Set-Content "$PsIonicLogs\Log4Net.Config.xml" -Encoding UTF8

$ConfigFile=New-Object System.IO.FileInfo "$PsIonicLogs\Log4Net.Config.xml"
rv Lg4nPath,PsIonicLogsLg4n,Lines

[Log4net.Config.XmlConfigurator]::Configure($ConfigFile)

$logger=[log4net.LogManager]::GetLogger('File')
#     #test Console
# $Logger.Debug("Level Debug.")
# $Logger.Info("Level Info.")
# $Logger.Warn("Level Warn.")
# $Logger.Error("Level Error.")
# $Logger.Fatal("Level Fatal.")
# 
# type  'C:\Temps\Logs\PsIonic.log'
#[log4net.LogManager]::Shutdown()
