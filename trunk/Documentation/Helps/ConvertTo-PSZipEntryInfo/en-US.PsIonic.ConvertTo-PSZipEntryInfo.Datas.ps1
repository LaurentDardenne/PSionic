# ConvertTo-PSZipEntryInfo command data
$Datas = @{
	ConvertToPSZipEntryInfoSynopsis = 'Converts Info property of a ZipFile or ZipEntry object.'
	ConvertToPSZipEntryInfoDescription = 'Converts Info property of a ZipFile object to a custom objects list or a ZipEntry/PSZipEntry object to a custom object.'
	ConvertToPSZipEntryInfoSets__AllParameterSets = ''
	ConvertToPSZipEntryInfoParametersInfo = 'Contents of a Ionic object''s Info property.'
	ConvertToPSZipEntryInfoInputsDescription1 = ''
	ConvertToPSZipEntryInfoOutputsDescription1 = 'Its typename is PSZipEntryInfo.'
	ConvertToPSZipEntryInfoNotes = @"
The Info property conversion into several objects takes some time.
Avoid to convert this property several times into a loop.
Be aware that an instance can evolve by adding or removing an entry. In this case, you need to update this field (ZipEntry/PSZipEntry) or build a new list (ZipFile).
"@
	ConvertToPSZipEntryInfoExamplesRemarks1 = @"
This example gets an entry list from an archive. Those are Powershell custom objects.
The Info property (which is string type by default), is converted to a PSObject. Then this PSObject is reassigned to the contents of the Info property.
The string type initial information is no longer available.
"@
	ConvertToPSZipEntryInfoExamplesRemarks2 = @'
This example gets an archive then its Info property is converted to an indexed list of PSZipEntryInfo objects.
Then it adds a new entry to the archive and it builds a new PSZipEntryInfo list, this time from the initial information which is reachable through $Zip.psbase.Info.
'@
}


