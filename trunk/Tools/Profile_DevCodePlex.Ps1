#requires -version 2.0

 #todo [FunctionalType('FilePath')] #<%REMOVE%>

 #Pour cette hashtable on retarde la substitution, 
 #car on référence des clés de la hashtable 'primaire'
$Paths=@{
 Bin='$($Properties.Trunk)\Bin'; #Debug et Release
 Livraison='C:\Temp\$Projectname'; # Spécifique au poste de dev, n'est pas versionné. 
                                   # On construit la livraison à partir du référentiel SVN
 Tests='$($Properties.Trunk)\Tests';
 Tools='$($Properties.Trunk)\Tools';
 Logs='C:\Temp\$Projectname\Logs'
}
$MyPath='G:\PS\PsIonic\Trunk\Tools'
."$MyPath\New-ProjectVariable.ps1"


$PsIonic=New-ProjectVariable 'PsIonic' 'G:\PS' 'https://psionic.svn.codeplex.com/svn' $Paths
$PsIonic.NewVariables()
#dir variable:psi*
$PsIonic


$Lg4nPath="$PsIonicBin\Debug\log4net\2.0\log4net.dll"
if ($PSVersionTable.PSVersion -eq 3.0)
{ $Lg4nPath="$PsIonicBin\Deubug\log4net\4.0\log4net.dll"}
 

Add-type -Path $Lg4nPath

#Crée le fichier de config à partir du template Log4Net.Config.xml
md $PsIonicLogs -ea SilentlyContinue

$Lines=[System.IO.File]::ReadAllText("$PsIonicTools\Log4Net.Config.xml")
#bug V3 seul un nom de variable peut être utilisé et pas $var.method()
$PsIonicLogsLg4n=$PsIonicLogs.Replace('\','\\') 
$ExecutionContext.InvokeCommand.ExpandString($Lines) |Set-Content "$PsIonicLogs\Log4Net.Config.xml" -Encoding UTF8

$ConfigFile=New-Object System.IO.FileInfo "$PsIonicLogs\Log4Net.Config.xml"

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
