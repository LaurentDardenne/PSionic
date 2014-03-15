# Get-ZipFile command data
$Datas = @{
	GetZipFileSynopsis = 'todo'
	GetZipFileDescription = ''
	GetZipFileSetsManualOption = ''
	GetZipFileSetsReadOption = ''
	GetZipFileParametersEncoding =@"
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
	GetZipFileParametersEncryption = ''
	GetZipFileParametersList = ''
	GetZipFileParametersProgressID = ''
	GetZipFileParametersPath = @"
File names list to compress. Can be a file object or a string. In this last case, generic characters can be used (* , ? , [A-D] ou [1CZ]).
"@
	GetZipFileParametersOptions = ''
	GetZipFileParametersPassword = @"
Password used for encryption. Encryption method needs to be specified with the '-Encryption' parameter.
"@
	GetZipFileParametersReadOptions = ''
	GetZipFileParametersSortEntries = @"
Entries are sorted before saving them. This can slow down the compression process, according to the number of files to compress.
"@ 
	GetZipFileParametersUnixTimeFormat = 'Unix time format for date file format will be used.'
	GetZipFileParametersWindowsTimeFormat = 'Windows time format for date file format will be used.'
	GetZipFileParametersZipErrorAction = @"
Specify the error mode handling.
.
'Skip' value displays the error message and continue executing.
.
'InvokeErrorEvent' value can be only used when saving archive. Errors triggered while building catalog won't call error manager linked with this value.
In this last case, a simple error will still be generated.
.
'Throw' value displays the error message and stops executing.
.
Avoid the use of the 'Retry' value because it could indefinitely try to solve a persistent error.
"@
	GetZipFileInputsDescription1 = ''
	GetZipFileOutputsDescriptionIonicZipZipFile = 'Ionic.Zip.ZipFile'
	GetZipFileNotes = ''
	GetZipFileExamplesRemarks1 = ''
}


