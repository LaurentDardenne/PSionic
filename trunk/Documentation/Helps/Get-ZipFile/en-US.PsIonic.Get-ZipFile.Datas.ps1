# Get-ZipFile command data
$Datas = @{
	GetZipFileSynopsis = 'Gets and Sets an archive object from a Zip file.'
	GetZipFileDescription = @"
Gets an archive object from a Zip file. The archive object contains only the catalog, an objects list of type ZipEntry, in order to get the contents of a catalog entry. You need to expand it on a filesystem drive.
Also, this function sets the most common properties of the object archive.
The returned object is locked until you don't call the 'Close()' method. On the other side, the use of the '-List' parameter does not lock the archive.
"@
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
	GetZipFileParametersEncryption = @"
Encryption algorythm used for compression. Need to specify a password with the '-Password' parameter.
"@
	GetZipFileParametersList = @"
Gets the contained entries from the archive catalog. The returned objects are custom objects with the PSZipEntry type name.
Aside from its property 'Info', all are read-only.
The archive is not locked.
"@
	GetZipFileParametersProgressID = @"
This parameter makes an events manager for read operations.
When opening a zip archive with a big size, you can choose to display a default progress bar.
This ID allows to distinguish the internal progress bar from the others. Use this parameter when you create more than one progress bar.
"@
	GetZipFileParametersPath = @"
File name(s) to read. Can be a file names with generic characters (* , ? , [A-D] ou [1CZ]).
"@
	GetZipFileParametersOptions = "Options used during the creation of the self-extracting archive (See 'New-ZipSfxOptions' for more details)."
	GetZipFileParametersPassword = "Password used to read the Zip archive."
	GetZipFileParametersReadOptions = "Options applied when reading archive (.zip). Created options from the 'New-ReadOptions' function."
	GetZipFileParametersSortEntries = 'Entries are sorted.'
	GetZipFileParametersUnixTimeFormat = 'Unix time format for date file format will be used.'
	GetZipFileParametersWindowsTimeFormat = 'Windows time format for date file format will be used.'
	GetZipFileParametersZipErrorAction = 'Specifies the error mode handling.'
	GetZipFileInputsDescription1 = ''
	GetZipFileOutputsDescriptionIonicZipZipFile = ''
	GetZipFileNotes = @"
This function returns only one Zip archive object from his fullname. Most of the parameters are used to configure the archive properties if you want to modify it.
For example, the 'Encryption' parameter does not affect reading the Zip. Only the 'Password' parameter is needed, because this is entries that are encrypted, and not the object of type [Zipfile].
So a Zip archive can theoretically contains several entries with differents compression mode for each of them.
Pay attention that for each returned object you must call the 'Close()' method in order to properly release resources of the archive.
"@
	GetZipFileExamplesRemarks1 = 'This example reads a Zip file, display its contents from a file and then releases resources archive.'
	GetZipFileExamplesRemarks2 = 'This example reads a Zip file, adds an entry from a file to it, saves it and then releases resources archive.'
	GetZipFileExamplesRemarks3 = 'This example reads a Zip file, adds an entry from a string, saves it and then releases resources archive.'
	GetZipFileExamplesRemarks4 = @"
This example reads a Zip file, adds '.txt' files from a folder to it, saves it and then releases resources archive.
The 'Close()' method internally calls the method 'Save()' then 'PSDispose()'.
"@
	GetZipFileExamplesRemarks5 = @"
The first instruction returns the catalog entries as objects of type 'PSZipEntry'.
The following search in the original catalog for an entry named 'Test.ps1' then decompresses the 'C:\Temp' Folder.

The difference between the two approaches is that objects of type PSZipEntry lacks methods specific to objects of type ZipEntry.
"@
	GetZipFileExamplesRemarks6 = @"
This example opens an archive, deletes all the .TXT files and adds all .LOG files from 'C:\Temp' folder.
Note that each change is recorded in the catalog of the archive, but only the call to 'Close ()' method will record the changes in the archive.
"@
}


