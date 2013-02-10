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
} #Init
