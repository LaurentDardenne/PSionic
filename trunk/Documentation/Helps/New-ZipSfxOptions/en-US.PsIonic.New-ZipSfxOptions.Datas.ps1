# New-ZipSfxOptions command data
$Datas = @{
	NewZipSfxOptionsSynopsis = 'Makes a configuration object used when building a self-extracting archive.'
	NewZipSfxOptionsDescription = 'Makes a configuration object used when building a self-extracting archive.'
	NewZipSfxOptionsSetsCmdLine = ''
	NewZipSfxOptionsSetsGUI = ''
	NewZipSfxOptionsParametersAdditionalCompilerSwitches = 'Further options used during the generation of the dotNET executable.'
	NewZipSfxOptionsParametersCmdLine = 'Specifies that self-extracting archive is based on a console program (CLI).'
	NewZipSfxOptionsParametersCopyright = 'Notice of copyright or copyleft.'
	NewZipSfxOptionsParametersDescription = 'Discloses the use of the self-extracting archive.'
	NewZipSfxOptionsParametersExeOnUnpack = 'Specifies the program and its parameters, to run after all the files in the archive are unzipped.'
	NewZipSfxOptionsParametersExtractDirectory = @"
Specifies the default directory decompression. It may contain references to system variable, for example %UserProfile%.
These are substituted during the execution of the self-extracting archive.
"@
	NewZipSfxOptionsParametersFileVersion = 'Version number of the self-extracting file.'
	NewZipSfxOptionsParametersGUI = 'Specifies that the self-extracting archive is based on a Winform program (GUI).'
	NewZipSfxOptionsParametersIconFile = 'File name containing an icon for the Winform.'
	NewZipSfxOptionsParametersNameOfProduct = 'Product name contained in the self-extracting archive.'
	NewZipSfxOptionsParametersQuiet = 'Exit the program when decompression is finished.'
	NewZipSfxOptionsParametersRemove = 'Delete all files extracted from the archive at the end of the process.'
	NewZipSfxOptionsParametersVersionOfProduct = 'Version number of the product contained in the archive.'
	NewZipSfxOptionsParametersWindowTitle = 'Winform title.'
	NewZipSfxOptionsInputsDescription1 = 'No description'
	NewZipSfxOptionsOutputsDescriptionIonicZipSelfExtractorSaveOptions = 'Ionic.Zip.SelfExtractorSaveOptions'
	NewZipSfxOptionsNotes = @"
For all filled parameters of string type, spaces characters are deleted at the beginning or end of the string.

Here is the list of properties with default values:
Flavor                          : ConsoleApplication
Quiet                           : False
ExtractExistingFile             : Throw
RemoveUnpackedFilesAfterExecute : False
FileVersion                     : 1.0.0.0
.
Please note that the property 'ExtractExistingFile' must always have the value 'Throw'. This behavior is managed using the options on the generated executable.
"@
	NewZipSfxOptionsExamplesRemarks1 = 'This statement creates a SFX configuration with default values ​​except for the Copyright field.'
	NewZipSfxOptionsExamplesRemarks2 = 'This statement creates a SFX configuration and affects it to the default configuration.'
}


