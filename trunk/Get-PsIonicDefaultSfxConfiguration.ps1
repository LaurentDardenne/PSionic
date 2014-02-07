function Get-PsIonicDefaultSfxConfiguration {
#Create a personnal SFX configuration
#
#When this function exists before importing the module psionic, 
#it becomes the default configuration. See Get-PsIonicSfxOptions function. 

  $SfxOptions=@{
    ExeOnUnpack="Powershell -noprofile -File .\MySetup.ps1"
    ExtractDirectory='%TEMP%'
    Description='Archive autoextractible exécutant un script Powershell en fin d''extraction.'
    FileVersion='1.0'
    IconFile="$(($env:PSModulePath -split ';')[0])\PsIonic\PsIonic.ico"
    ExtractExistingFile='OverwriteSilently'
    NameOfProduct='Test'
    VersionOfProduct='1.0'
    Copyright='Auteur Laurent Dardenne.'

     #Additional options for the csc.exe compiler, when producing the SFX
     #see : http://msdn.microsoft.com/en-us/library/6s2x2bzy.aspx
    AdditionalCompilerSwitches= '/optimize'
    
    #WindowTitle='' with -GUI
    Quiet=$false #switch parameter
    Remove=$false #switch parameter
  }
 New-ZipSfxOptions @SfxOptions  -Cmdline # -Cmdline or -GUI
}#Get-DefaultSfxConfiguration


