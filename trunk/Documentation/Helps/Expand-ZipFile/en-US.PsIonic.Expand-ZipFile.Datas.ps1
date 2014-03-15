# Expand-ZipFile command data
$Datas = @{
	ExpandZipFileSynopsis = 'todo'
	ExpandZipFileDescription = ''
	ExpandZipFileSetsLiteralPath = ''
	ExpandZipFileSetsPath = ''
	ExpandZipFileParametersCreate = ''
	ExpandZipFileParametersEncoding = @"
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
	ExpandZipFileParametersExtractAction = ''
	ExpandZipFileParametersFlatten = ''
	ExpandZipFileParametersFrom = ''
	ExpandZipFileParametersLiteralPath = @"
File names list to compress. Generic characters won't be interpreted.
Can be a file object or a string.
"@
	ExpandZipFileParametersOutputPath = ''
	ExpandZipFileParametersPassthru = ''
	ExpandZipFileParametersPassword = ''
	ExpandZipFileParametersPath =@"
File names list to expand. Can be a file object or a string. In this last case, generic characters can be used (* , ? , [A-D] ou [1CZ]).
"@
	ExpandZipFileParametersProgressID = ''
	ExpandZipFileParametersQuery = ''
	ExpandZipFileInputsDescription1 = ''
	ExpandZipFileOutputsDescription1 = ''
	ExpandZipFileNotes = ''
	ExpandZipFileExamplesRemarks1 = ''
}


