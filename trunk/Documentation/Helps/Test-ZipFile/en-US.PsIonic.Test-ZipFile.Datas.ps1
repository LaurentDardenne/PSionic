# Test-ZipFile command data
$Datas = @{
	TestZipFileSynopsis = 'Tests if a file is in PkZip format.'
	TestZipFileDescription = @'
Tests if a file is in PkZip format.
During this test, it is also possible to check if the archive is valid and in this case, to attempt to fix it. 
By default, simple errors are thrown.
'@
	TestZipFileSetsDefault = ''
	TestZipFileSetsFile = ''
	TestZipFileParametersCheck = @"
Verify if the archive catalog is correct.
This verification is stricter than that made ​​with the '-isValid' parameter.
So it can returns $false although the file is considered as a valid archive.
If you need to test an archive with a password, use this parameter with or without the ''-Password'' parameter.
"@
	TestZipFileParametersisValid = @"
Indicates whether the archive appears to be valid. This function can therefore returns $true when the contents of the archive is wrong.
If a file is not an archive and the '-isValid' parameter is specified, then the simple errors are not generated.
If you need to test an archive with a password, do not use this parameter, but the '-Password' parameter and/or the '-Check' parameter.
"@
	TestZipFileParametersPassthru = @'
Outputs the name of the archive file in the pipeline.
If ''-isValid'' parameter is also specified, then the names of files that are considered invalid will not be issued in the pipeline and no single error is triggered.
This behavior is similar to a filter where only the names of valid files would be issued in the pipeline.
The archive objects returned are not locked, pay attention to your use of these objects scenarios.
'@
	TestZipFileParametersPassword = @"
Password, necessary if the archive is protected by a password.
If you need to test an archive with a password, do not use the '-IsValid' parameter, because in this case the result returned is always false.
Use only the '-Password' parameter and/or the '-Check' parameter. If the password is wrong the result returned is false.
"@
	TestZipFileParametersPath = @"
Archive file name to test. Can be a file object or a string. In this last case, generic characters can be used (* , ? , [A-D] ou [1CZ]).
"@
	TestZipFileParametersRepair = 'Attempts to repair if archive is corrupt.'
	TestZipFileInputsDescription1 = 'String or System.IO.FileInfo or Object (transformed into a String type). Directory type objects are not treated.'
	TestZipFileOutputsDescriptionSystemBoolean = ''
	TestZipFileOutputsDescriptionSystemString = "If the Passthru parameter is specified, the output is the name of the tested file."
	TestZipFileNotes = ''
	TestZipFileExamplesRemarks1 = "The first line creates a Zip archive. The second tests if the file is a 'PkZip' archive format. The result of the execution is '$true'."
	TestZipFileExamplesRemarks2 = @"
The first line creates a zip archive. The second creates a self-extracting archive. The third tests if the file is a 'PkZip' archive format. 
It is found that a self-extracting archive is considered as a valid archive. The returned value is '$true'.
"@
	TestZipFileExamplesRemarks3 = "The result of the execution is '$false' because the object received, converted into string, does not reference a ZIP file archive."
}


