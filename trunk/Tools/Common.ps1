#Common.ps1
#Compile la DLL PSIonicTools
#todo Debug/Release 


Function Add-CScharpType {
 #Génére une DLL dotnet
 param (
      #Fichier .cs à compiler dans un assembly .dll
     $FileName,
     $Destination,
      #Chemin d'accès du compilateur CSharp csc.exe
     $cscPath=$([System.Runtime.InteropServices.RuntimeEnvironment]::GetRuntimeDirectory()),
      #Chemin d'accés du fichier Assembly.cs versionnant $FileName
     $PathAssemblyInfo 
 )
 if ((Test-Path $cscPath) -eq $false)
  {Throw "Le répertoire du runtime .NET est introuvable."}
 if ((Test-Path "$PathAssemblyInfo\AssemblyInfo.cs") -eq $false)
  {Throw "Le fichier $PathAssemblyInfo\AssemblyInfo.cs est introuvable."}

 $PathAssemblyInfo="$PathAssemblyInfo\AssemblyInfo.cs"
 
  #Compile un assembly à partir de la classe C
 if ([String]::IsNullOrEmpty($PathAssemblyInfo))
  { &"$($cscPath)csc.exe" /target:library "$FileName" /out:"$Destination" }
 else 
  { &"$($cscPath)csc.exe" /target:library "$FileName","$PathAssemblyInfo" /out:"$Destination" }
} #Add-CScharpType

Task CompilePsionicTools {
  $csharpFileName="$PsIonicBin\PSIonicTools.cs"
   #todo destination /Out
  Add-CScharpType -FileName $csharpFileName -Destination "$PsIonicBin" -PathAssemblyInfo "$PsIonicBin"
} #CompilePsionicTools

Task BuildLog4netConfig {
  $Lg4nPath="$PsIonicBin\Debug\log4net\2.0\log4net.dll"
  if ($PSVersionTable.PSVersion -eq 3.0)
  { $Lg4nPath="$PsIonicBin\Debug\log4net\4.0\log4net.dll"}
   
  #Crée le fichier de config à partir du template Log4Net.Config.xml
  md $PsIonicLogs -ea SilentlyContinue
  
  $Lines=[System.IO.File]::ReadAllText("$PsIonicTools\Log4Net.Config.xml")
  #bug V3 seul un nom de variable peut être utilisé et pas $var.method()
  $PsIonicLogsLg4n=$PsIonicLogs.Replace('\','\\') 
  $ExecutionContext.InvokeCommand.ExpandString($Lines) |Set-Content "$PsIonicLogs\Log4Net.Config.xml" -Encoding UTF8
} #BuildLog4netConfig