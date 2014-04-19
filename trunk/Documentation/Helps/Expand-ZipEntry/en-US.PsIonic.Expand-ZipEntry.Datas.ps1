# Expand-ZipEntry command data
$Datas = @{
	ExpandZipEntrySynopsis = 'Extracts entries from a compressed archive to Zip format.'
	ExpandZipEntryDescription = @"
Extracts entries from a compressed archive to a Zip format. Extracted data are either serialized data, either an array of bytes, or a string and it allows to build an object.
To extract files from an archive use 'Expand-ZipFile' Cmdlet.
"@
	ExpandZipEntrySetsByteArray = ''
	ExpandZipEntrySetsString = ''
	ExpandZipEntrySetsXML = ''
	ExpandZipEntryParametersAsHashTable = 'Returns readen entries into an object of type hashtable. Name entries are extracted as a key name.'
	ExpandZipEntryParametersByte = 'Entry is returned as an array of bytes.'
	ExpandZipEntryParametersEncoding = @"
Archive encoding type. Possible values are :
-ASCII	          : ASCII characters encoding scheme (7 bits).
-BigEndianUnicode : encoding for the UTF-16 format using the big endian byte order.
-Default	      : encoding for the operating system's current ANSI code page.
-Unicode	      : encoding for the UTF-16 format using the little endian byte order.
-UTF32	          : encoding for the UTF-32 format using the little endian byte order.
-UTF7	          : encoding for the UTF-7.
-UTF8	          : encoding for the UTF-8.
.
For better portability, the default value ('DefaultEncoding') is recommended.
"@
	ExpandZipEntryParametersExtractAction = 'Specific steps to be taken when data is already present in the destination folder.'
	ExpandZipEntryParametersName ='Names of entries to extract.'
	ExpandZipEntryParametersPassword = 'Password used to uncompress encrypted archive.'
	ExpandZipEntryParametersStrict = 'Errors trigger exceptions in place of displaying them.'
	ExpandZipEntryParametersXML = 'String object is returned in XML format.'
	ExpandZipEntryParametersZipFile = 'An object containing a Zip archive.'
	ExpandZipEntryInputsDescription1 = ''
	ExpandZipEntryOutputsDescriptionIonicZipZipEntry = ''
	ExpandZipEntryOutputsDescriptionSystemXmlXmlDocument = ''
	ExpandZipEntryOutputsDescriptionSystemString = ''
	ExpandZipEntryOutputsDescriptionSystemByte = ''
	ExpandZipEntryNotes = 'This function is linked to the Add-ZipEntry function.'
	ExpandZipEntryExamplesRemarks1 = @'
At first time, those instructions save text to an entry named MyText, then links it and assigns it to the ''$MyVersionArray'' variable.
'@
	ExpandZipEntryExamplesRemarks2 =@'
At first time, those instructions save serialized object to an entry named ''PSVersiontable_clixml'', then links and assigns it to the $MyVersionArray variable. 
'@
	ExpandZipEntryExamplesRemarks3 =@'
At first time, those instructions save an array of bytes to an entry named ''MyArray'', then links it and assigns it to the ''$Array'' variable.
'@
}


