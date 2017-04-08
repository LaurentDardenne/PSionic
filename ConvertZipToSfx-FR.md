Le programme console ConvertZipToSfx.exe permet de créer, à partir d'une archive.zip, une archive auto extractible.

Sous Powershell la méthode _SaveSelfExtractor_, de la classe Ionic.Zip.ZipFile, génére bien un exécutable, mais la dll Ionic ne peut être extrait lors de l'exécution de l'archive auto extractible.

Le module PsIonic est donc livré avec ce programme encapsulé par la fonction [ConvertTo-Sfx](ConvertTo-Sfx-FR).

Ce programme est basé sur un des [fichiers projet C# de Ionic](https://dotnetzip.codeplex.com/SourceControl/latest#Tools/ConvertZipToSfx/ConvertZipToSfx.cs) et propose un paramètrage plus fin des options de construction d'une archive auto extractible.
{code:powershell}
C:\Temp> .\ConvertZipToSfx.exe
usage:
  CreateSelfExtractor [-cmdline](-cmdline)  [-extractdir <xxxx>](-extractdir-_xxxx_)  [-comment <xx>](-comment-_xx_)
                      [-exec <xx>](-exec-_xx_)  [-Description <xx>](-Description-_xx_) [-FileVersion <xx>](-FileVersion-_xx_)
                      [-IconFile <xx>](-IconFile-_xx_) [-Copyright <xx>](-Copyright-_xx_)
                      [-Name <xx>](-Name-_xx_) [-Version <xx>](-Version-_xx_) [-Compiler <xx>](-Compiler-_xx_)
                      [-Title <xx>](-Title-_xx_) [-Quiet](-Quiet) [-Remove](-Remove) <Zipfile>

  Creates a self-extracting archive (SFX) from an existing zip file.

  options:
     -cmdline           - The generated SFX will be a console/command-line exe.
                          The default is that the SFX is a Windows (GUI) app.
     -extractdir <xx>   - The default extract directory the user will see when running the self-extracting archive.
                          You can specify environment variables within this string : %USERPROFILE%\Documents
                          The value of these variables will be expanded at the time the SFX is run.
     -exec <xx>         - The command line to execute after the SFX runs.
     -comment <xx>      - Embed a comment into the self-extracting archive.
                          It is displayed when the SFX is extracted.
     -Description <xx>  - The description to embed into the generated EXE.
     -FileVersion <xx>  - The file version number to embed into the generated EXE.
                          It will show up, for example, during a mouseover in Windows Explorer.
     -IconFile <xx>     - The name of an .ico file in the filesystem to use for the application
                          icon for the generated SFX.
     -Name <xx>         - The product name to embed into the generated EXE.
     -Version <xx>      - The product version to embed into the generated EXE.
                          It will show up, for example, during a mouseover in Windows Explorer.
     -Copyright <xx>    - The copyright notice, if any, to embed into the generated EXE.
     -Compiler <xx>     - Additional options for the csc.exe compiler, when producing the SFX EXE.
     -Title <xx>        - The title to display in the Window of a GUI SFX, while it extracts.
     -Quiet             - The Console application SFX will be quiet during extraction.
     -Remove            - Remove the files that have been unpacked, after executing the content of exec parameter.

ErrorLevel 1 : A parameter is duplicated
ErrorLevel 2 : No zipfile specified.
ErrorLevel 3 : That zip file does not exist.
{code:powershell}