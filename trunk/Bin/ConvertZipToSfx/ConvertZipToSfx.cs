// ConvertZipToSfx.cs
// ------------------------------------------------------------------
//
// This is a command-line tool that creates a self-extracting Zip archive, given a
// standard zip archive.
// It requires the .NET Framework 2.0 on the target machine in order to run.
//
//
// The Visual Studio Project is a little weird.  There are code files that ARE NOT compiled
// during a normal build of the VS Solution.  They are marked as embedded resources.  These
// are the various "boilerplate" modules that are used in the self-extractor. These modules are:
//   WinFormsSelfExtractorStub.cs
//   WinFormsSelfExtractorStub.Designer.cs
//   CommandLineSelfExtractorStub.cs
//   PasswordDialog.cs
//   PasswordDialog.Designer.cs
//   ZipContentsDialog.cs
//   ZipContentsDialog.Designer.cs
//   FolderBrowserDialogEx.cs
//
// At design time, if you want to modify the way the GUI looks, you have to mark those modules
// to have a "compile" build action.  Then tweak em, test, etc.  Then again mark them as
// "Embedded resource".
//
//
// Author: Dinoch
// built on host: DINOCH-2
//
// ------------------------------------------------------------------
//
// Copyright (c) 2008 by Dino Chiesa
// All rights reserved!
//
//
// ------------------------------------------------------------------

using System;
using System.Text;
using Ionic.Zip;

namespace Psionic.Sfx
{

    public class ConvertZipToSfx
    {
        private ConvertZipToSfx() { }

        string ExeOnUnpack;
        string ZipComment;
        string ZipFileToConvert;
        string targetName;
        string ExtractDir;

        string Description;
        private Version FileVersion;
        string IconFile;
        string Title;
        string Name;
        string Version;
        string Copyright;
        // #Additional options for the csc.exe compiler, when producing the SFX
        // #see : http://msdn.microsoft.com/en-us/library/6s2x2bzy.aspx
        string Compiler;
        Boolean Quiet = false;
        Boolean Remove = false;

        bool _gaveUsage;
        SelfExtractorFlavor flavor = Ionic.Zip.SelfExtractorFlavor.WinFormsApplication;

        public ConvertZipToSfx(string[] args)
        {
            const string parameterDuplicated = "The parameter {0} is duplicated.";

            for (int i = 0; i < args.Length; i++)
            {
                switch (args[i].ToLower())
                {
                    case "-extractdir":
                        if (i >= args.Length - 1 || ExtractDir != null)
                        {
                            Console.Error.WriteLine(parameterDuplicated, "'extractdir");
                            Usage();
                            return;
                        }
                        ExtractDir = args[++i];
                        break;

                    case "-cmdline":
                        flavor = SelfExtractorFlavor.ConsoleApplication;
                        break;

                    case "-comment":
                        if (i >= args.Length-1 || ZipComment != null)
                        {
                            Console.Error.WriteLine(parameterDuplicated, "comment");
                            Usage();
                            return;
                        }
                        ZipComment = args[++i];
                        break;

                    case "-exeonunpack":
                        if (i >= args.Length-1 || ExeOnUnpack != null)
                        {
                            Console.Error.WriteLine(parameterDuplicated, "exeonunpack");
                            Usage();
                            return;
                        }
                        ExeOnUnpack = args[++i];
                        break;

                    case "-description":
                        if (i >= args.Length - 1 || Description != null)
                        {
                            Console.Error.WriteLine(parameterDuplicated, "description");
                            Usage();
                            return;
                        }
                        Description = args[++i];
                        break;

                    case "-fileversion":
                        if (i >= args.Length - 1 || FileVersion != null)
                        {
                            Console.Error.WriteLine(parameterDuplicated, "fileversion");
                            Usage();
                            return;
                        }
                        FileVersion = new Version(args[++i]);
                        break;

                    case "-title":
                        if (i >= args.Length - 1 || Title != null)
                        {
                           Console.Error.WriteLine(parameterDuplicated, "title");
                            Usage();
                            return;
                        }
                        Title = args[++i];
                        break;

                    case "-iconfile":
                        if (i >= args.Length - 1 || IconFile != null)
                        {
                            Console.Error.WriteLine(parameterDuplicated, "iconfile");
                            Usage();
                            return;
                        }
                        IconFile = args[++i];
                        break;

                    case "-name":
                        if (i >= args.Length - 1 || Name != null)
                        {
                            Console.Error.WriteLine(parameterDuplicated, "name");
                            Usage();
                            return;
                        }
                        Name = args[++i];
                        break;

                    case "-version":
                        if (i >= args.Length - 1 || Version != null)
                        {
                            Console.Error.WriteLine(parameterDuplicated, "version");
                            Usage();
                            return;
                        }
                        Version = args[++i];
                        break;

                    case "-copyright":
                        if (i >= args.Length - 1 || Copyright != null)
                        {
                            Console.Error.WriteLine(parameterDuplicated, "copyright");
                            Usage();
                            return;
                        }
                        Copyright = args[++i];
                        break;

                    case "-compiler":
                        if (i >= args.Length - 1 || Compiler != null)
                        {
                            Console.Error.WriteLine(parameterDuplicated, "compiler");
                            Usage();
                            return;
                        }
                        Compiler = args[++i];
                        break;

                    case "-quiet":
                        if (i >= args.Length - 1 || Quiet == true)
                        {
                            Console.Error.WriteLine(parameterDuplicated, "Quiet");
                            Usage();
                            return;
                        }
                        Quiet = true;
                        break;

                    case "-remove":
                        if (i >= args.Length - 1 || Remove == true)
                        {
                            Console.Error.WriteLine(parameterDuplicated, "remove");
                            Usage();
                            return;
                        }
                        Remove = true;
                        break;

                    case "-?":
                    case "-help":
                        Usage();
                        return;

                    default:
                            // positional args
                        if (ZipFileToConvert == null)
                        {
                            ZipFileToConvert = args[i];
                            targetName = ZipFileToConvert.Replace(".zip", ".exe");
                        }
                        else
                        {
                            Usage();
                            return;
                        }
                        break;
                }
            }
        }

        public int Run()
        {
            if (_gaveUsage) return 1;
            if (ZipFileToConvert == null)
            {
                Console.Error.WriteLine("No zipfile specified.");
                Usage();
                return 2;
            }

            if (!System.IO.File.Exists(ZipFileToConvert))
            {
                Console.Error.WriteLine("That zip file does not exist : {0}",ZipFileToConvert);
                Usage();
                return 3;
            }
             
            // Renvoi 0 ou une exception
            return Convert();
        }



        private int Convert()
        {
            Console.Out.WriteLine("Converting file {0} to SFX {1}", ZipFileToConvert, targetName);

            var options = new ReadOptions { StatusMessageWriter = Console.Out };
            using (ZipFile zip = ZipFile.Read(ZipFileToConvert, options))
            {
                zip.Comment = ZipComment;
                zip.UseZip64WhenSaving = Zip64Option.AsNecessary;
                SelfExtractorSaveOptions sfxOptions = new SelfExtractorSaveOptions();
                sfxOptions.Flavor =  flavor;
                sfxOptions.DefaultExtractDirectory = ExtractDir;
                sfxOptions.PostExtractCommandLine = ExeOnUnpack;

                sfxOptions.SfxExeWindowTitle =Title;
                sfxOptions.Description = Description;
                sfxOptions.FileVersion = FileVersion;
                sfxOptions.IconFile = IconFile;
                // ExtractExistingFile : always default value throw
                sfxOptions.ProductName = Name;
                sfxOptions.ProductVersion = Version;
                sfxOptions.Copyright=Copyright;
                sfxOptions.AdditionalCompilerSwitches = Compiler;

                sfxOptions.Quiet = false;
                sfxOptions.RemoveUnpackedFilesAfterExecute = false;
                zip.SaveSelfExtractor(targetName, sfxOptions);
            }
            return 0;
        }


        private void Usage()
        {
            //Affichage sur la console, aucun intérêt d'utiliser stdout
            Console.WriteLine("usage:");
            Console.WriteLine("  CreateSelfExtractor [-cmdline]  [-extractdir <xxxx>]  [-comment <xx>]");
            Console.WriteLine("                      [-exec <xx>]  [-Description <xx>] [-FileVersion <xx>]"); 
            Console.WriteLine("                      [-IconFile <xx>] [-Copyright <xx>]");          
            Console.WriteLine("                      [-Name <xx>] [-Version <xx>] [-Compiler <xx>]");    
            Console.WriteLine("                      [-Title <xx>] [-Quiet] [-Remove] <Zipfile>\n");
            Console.WriteLine("  Creates a self-extracting archive (SFX) from an existing zip file.\n");
            Console.WriteLine("  options:");
            Console.WriteLine("     -cmdline           - The generated SFX will be a console/command-line exe.");
            Console.WriteLine("                          The default is that the SFX is a Windows (GUI) app.");
            Console.WriteLine("     -extractdir <xx>   - The default extract directory the user will see when running the self-extracting archive.");
            Console.WriteLine(@"                          You can specify environment variables within this string : %USERPROFILE%\Documents");
            Console.WriteLine("                          The value of these variables will be expanded at the time the SFX is run.");                              
            Console.WriteLine("     -exec <xx>         - The command line to execute after the SFX runs.");
            Console.WriteLine("     -comment <xx>      - Embed a comment into the self-extracting archive.");
            Console.WriteLine("                          It is displayed when the SFX is extracted.");
            Console.WriteLine("     -Description <xx>  - The description to embed into the generated EXE.");
            Console.WriteLine("     -FileVersion <xx>  - The file version number to embed into the generated EXE.");
            Console.WriteLine("                          It will show up, for example, during a mouseover in Windows Explorer.");
            Console.WriteLine("     -IconFile <xx>     - The name of an .ico file in the filesystem to use for the application");
            Console.WriteLine("                          icon for the generated SFX.");
            Console.WriteLine("     -Name <xx>         - The product name to embed into the generated EXE.");
            Console.WriteLine("     -Version <xx>      - The product version to embed into the generated EXE.");
            Console.WriteLine("                          It will show up, for example, during a mouseover in Windows Explorer.");
            Console.WriteLine("     -Copyright <xx>    - The copyright notice, if any, to embed into the generated EXE.");
            Console.WriteLine("     -Compiler <xx>     - Additional options for the csc.exe compiler, when producing the SFX EXE.");
            Console.WriteLine("     -Title <xx>        - The title to display in the Window of a GUI SFX, while it extracts.");
            Console.WriteLine("     -Quiet             - The Console application SFX will be quiet during extraction.");
            Console.WriteLine("     -Remove            - Remove the files that have been unpacked, after executing the content of exec parameter.\n");
            Console.WriteLine("ErrorLevel 1 : A parameter is duplicated.");
            Console.WriteLine("ErrorLevel 2 : No zipfile specified.");
            Console.WriteLine("ErrorLevel 3 : That zip file does not exist.\n");
            _gaveUsage = true;
        }


        public static void Main(string[] args)
        {
            string filename = string.Empty;
            try
            {
                ConvertZipToSfx zipSfx = new ConvertZipToSfx(args);
                filename = zipSfx.targetName;
                int result = zipSfx.Run();
                Environment.Exit(result);
            }
            catch (Exception e)
            {
                Console.Error.WriteLine("Exception while creating the self extracting archive '{0}' : {1}", filename, e.Message.ToString());
            }
        }


    }
}
