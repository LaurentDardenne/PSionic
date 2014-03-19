# ConvertTo-Sfx command data
$Datas = @{
	ConvertToSfxSynopsis = 'Converts a .Zip archive to a self-extracting archive.'
	ConvertToSfxDescription = @"
.Zip archive conversion to a self-extracting archive includes uncompress treatment in the resulting file. 
You can specify a command line to run once the uncompression process has finished.
"@
	ConvertToSfxSets__AllParameterSets = ''
	ConvertToSfxParametersComment = 'Archive''s comment.'
	ConvertToSfxParametersPath = '.Zip file name to convert.'
	ConvertToSfxParametersLiteralPath = @"
.Zip file name to convert. Generic characters won't be interpreted.
"@
	ConvertToSfxParametersSaveOptions = 'Generation options created through the New-ZipSfxOptions function.'
    ConvertToSfxParametersReadOptions = 'Options applied when reading archive (.zip) that is converted to a self-extracting archive (.exe). Created options from the New-ReadOptions function.'
	ConvertToSfxParametersPassthru = @"
Returns the generated file in object form and not just his name. 
Archive object is not locked so be attentive to your usage scenarios of this object.
"@
	ConvertToSfxInputsDescription1 = @"
You can send any object in the pipeline, but his transformation to a string type must be a file name.
"@
	ConvertToSfxOutputsDescriptionSystemIOFileInfo = @"
None or System.IO.FileInfo
 
When using the PassThru parameter, ConvertTo-Sfx sends the self-extracting archive's file object. Ottherwise this function doesn't make output.
"@ 
	ConvertToSfxNotes = @"
The dotnet framework 2.0 is needed on the computer that uncompresses the self-exctracting archive.
The folder specified by the 'ExtractDirectory' parameter (cf. New-ZipSfxOptions) can contains system variables references.
For example %UserProfile%. Those will be replaced while running the self-extracting archive.

Be carrefull : it is not possible to save a splitted archive into a self-extracting archive.
"@
	ConvertToSfxExamplesRemarks1 = @'
Using New-ZipSfxOptions function, those instructions build the settings to be used during the construction of the self-extracting archive.
Then it converts a .Zip file archive into a self-extracting archive (.exe).
The $ReadOptions variable is used to display the progress of the process in the console. 
'@ 
}
