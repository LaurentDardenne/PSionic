# ConvertFrom-CliXml command data
$Datas = @{
	ConvertFromCliXmlSynopsis = 'Crée un objet Powershell à partir d''une représentation XML et l''émet dans le pipeline.'
	ConvertFromCliXmlDescription = @"
Vous pouvez recevoir un objet XML depuis la fonction Expand-ZipEntry.
"@
	ConvertFromCliXmlSets__AllParameterSets = ''
	ConvertFromCliXmlParametersInputObject = 'Spécifie la représentation XML de l''objet à convertir.'
	ConvertFromCliXmlInputsDescription1 = ''
	ConvertFromCliXmlOutputsDescription1 = ''
	ConvertFromCliXmlNotes = ''
	ConvertFromCliXmlExamplesRemarks1 = @'
Ces instructions enregistrent dans un premier temps un objet sérialisé dans une entrée nommée 'PSVersiontable_clixml', puis dans un second temps la relit et l'affecte à la variable $MaTableDeVersion. 
'@
}


