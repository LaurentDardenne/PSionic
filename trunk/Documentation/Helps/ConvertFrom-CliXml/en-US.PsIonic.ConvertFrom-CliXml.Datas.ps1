# ConvertFrom-CliXml command data
$Datas = @{
	ConvertFromCliXmlSynopsis = 'Creates a Powershell object from an XML representation and issues it in the pipeline.'
	ConvertFromCliXmlDescription = @"
You can receive an XML object from the 'Expand-ZipEntry' function.
"@
	ConvertFromCliXmlSets__AllParameterSets = ''
	ConvertFromCliXmlParametersInputObject = 'Specifies XML representation of the object to be converted.'
	ConvertFromCliXmlInputsDescription1 = ''
	ConvertFromCliXmlOutputsDescription1 = ''
	ConvertFromCliXmlNotes = ''
	ConvertFromCliXmlExamplesRemarks1 = @'
At first time, those instructions save a serialized object into an entry named 'PSVersiontable_clixml', then in a second time link it and assign it to the $MyVersionArray variable.
'@
}


