# ConvertTo-CliXml command data
$Datas = @{
	ConvertToCliXmlSynopsis = 'Creates an XML representation of one or several objects and sends it to the pipeline.'
	ConvertToCliXmlDescription = @"
You can sends the result of this function to the 'Add-ZipEntry' and 'Update-ZipEntry' functions.
"@
	ConvertToCliXmlSets__AllParameterSets = ''
	ConvertToCliXmlParametersInputObject = 'Specifies the object to be converted.'
	ConvertToCliXmlInputsDescription1 = ''
	ConvertToCliXmlOutputsDescription1 = ''
	ConvertToCliXmlNotes = "The record of the XML representation is compatible with the 'Export-CliXML' Cmdlet."
	ConvertToCliXmlExamplesRemarks1 = @'
Those commands add a named entry to the 'C:\Temp\Test.zip' archive from  a serialized object:
   - The first instruction creates an archive object from a file name,
   - The second one serializes the object contained in the $PSVersionTable variable and adds it as an input named in the archive,
   - The third saves the archive to the disk and frees system ressources.
'@
}


