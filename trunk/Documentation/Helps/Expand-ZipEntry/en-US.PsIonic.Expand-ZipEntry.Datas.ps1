# Expand-ZipEntry command data
$Datas = @{
	ExpandZipEntrySynopsis = 'todo'
	ExpandZipEntryDescription = ''
	ExpandZipEntrySetsByteArray = ''
	ExpandZipEntrySetsString = ''
	ExpandZipEntrySetsXML = ''
	ExpandZipEntryParametersAsHashTable = ''
	ExpandZipEntryParametersByte = ''
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
	ExpandZipEntryParametersExtractAction = ''
	ExpandZipEntryParametersName ='Names of entries to extract.'
	ExpandZipEntryParametersPassword = @"
Password used for encryption. Encryption method needs to be specified with the '-Encryption' parameter.
"@
	ExpandZipEntryParametersStrict = ''
	ExpandZipEntryParametersXML = ''
	ExpandZipEntryParametersZipFile = 'Target archive in which specified entry is extracted. This parameter waits for a ZipFile object and not a file name.'
	ExpandZipEntryInputsDescription1 = ''
	ExpandZipEntryOutputsDescriptionSystemXmlXmlDocument = ''
	ExpandZipEntryOutputsDescriptionSystemString = ''
	ExpandZipEntryOutputsDescriptionSystemByte = ''
	ExpandZipEntryNotes = ''
	ExpandZipEntryExamplesRemarks1 = ''
}


