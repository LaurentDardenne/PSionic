# Compress-ZipFile command data
$Datas = @{
	CompressZipFileSynopsis = 'Compress files list into a .ZIP file archive.'
	CompressZipFileDescription = 'The Compress-ZipFile Cmdlet compress files and/or folders into a .ZIP file archive.'
	CompressZipFileSetsLiteralPath = ''
	CompressZipFileSetsPath = ''
	CompressZipFileParametersCodePageIdentifier = @"
Code page name used for the file name.
Default value ('IBM437') is recommanded.
"@
	CompressZipFileParametersComment = 'Comment linked with the archive.'
	CompressZipFileParametersEncoding = @"
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
	CompressZipFileParametersEncryption = @"
Encryption algorythm used for compression. Need to specify a password with the '-Password' parameter.
.
Compatibility note:
For the '-Encryption' parameter, the values 'PkzipWeak' and 'None' specified in the PKWARE zip specifications are considered as 'standard'.
A zip archive built with this options will be compatible with lot of zip tools and libraries, including windows explorer.
.
The 'WinZipAes128' and 'WinZipAes256' are not part of specifications. So it involves the use of a specific Winzip provider extension.
If you want to build compatible Zip archives, don't use this values.
"@
	CompressZipFileParametersEntryPathRoot = @"
The new entry will be added into a specific directory. By default it is added to the root tree of the archive.
The value of this parameter must reference an existing directory.

In order to avoid entry name collisions during a recursive tree compression you must use this parameter.
This one allows to build the name of the input, relatively to the specified directory.

For example, by specifying 'C:\Temp\Backup', during the recursive compression of 'C:\Temp\Backup', treatment construction of the entry name will cut off 'C:\Temp\Backup' for each received file name.
So, for 'C:\Temp\Backup\File1.ps1' and 'C:\Temp\Backup\Projet\File1.ps1' files, the entries created in the catalog will be respecively:
File1.ps1
Projet/File.ps1   
.
By specifying a directory different from the begining of archive, archiving process will trigger an exception and it will stop working from the current path.
"@
    CompressZipFileParametersLiteralPath = @"
File names list to compress. Generic characters won't be interpreted.
Can be a file object or a string.
"@
	CompressZipFileParametersNotTraverseReparsePoints = 'Indicates if searches will traverse NTFS reparse points, like junctions.'
	CompressZipFileParametersOutputName = 'Archive file name to build. The drive name must be part of an existing FileSystem provider.'
	CompressZipFileParametersPassthru = @"
Sends archive file down the pipeline as input to other commands. Be aware that resources won't be freed with Close() method so it is your responsibility.
The archive object is not locked so be carefull of usage scenarios of this object.
"@
	CompressZipFileParametersPassword = @"
Password used for encryption. Encryption method needs to be specified with the '-Encryption' parameter.
"@
	CompressZipFileParametersPath = @"
File names list to compress. Can be a file object or a string. In this last case, generic characters can be used (* , ? , [A-D] ou [1CZ]).
"@
	CompressZipFileParametersRecurse = 'Compress the items in the specified locations and all child items of the locations specified with the ''-Path'' or ''-LiteralPath'' parameters.'
	CompressZipFileParametersSetLastModifiedProperty = @'
Before saving the archive, allows to modify the 'LastModified' property of each archive entries. The $Entry variable must be used in the scriptblock.
'@
	CompressZipFileParametersSortEntries = @"
Entries are sorted before saving them. This can slow down the compression process, according to the number of files to compress.
"@ 
	CompressZipFileParametersSplit = @"
Specify that the Zip file should be saved as a split archive. The value of this parameter determines the size of each segment.
'64Kb' syntax can be used. The maximum number of segments is 99.
In the case of more than 99 segments are needed, an exception will occure. Created files on the disk won't be deleted.
"@
	CompressZipFileParametersTempLocation  = @"
Temporary directory name used during the build of the archive.
By default, the function gets the environment variable %TEMP% contents.
Otherwise, the temporary file will be saved in the directory specified by the '-OutputName' parameter.
"@
	CompressZipFileParametersUnixTimeFormat = 'Unix time format for date file format will be used.'
	CompressZipFileParametersWindowsTimeFormat = 'Windows time format for date file format will be used.'
	CompressZipFileParametersZipErrorAction = @"
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
	CompressZipFileInputsDescription1 = 'System.String,System.IO.FileInfo'
	CompressZipFileOutputsDescriptionIonicZipZipFile = 'Ionic.Zip.ZipFile'
	CompressZipFileNotes = @"
Depending on the content, your archive is compressed in 64 bits. In order to define if the archive use Zip64 extensions, see the 'OutputUsedZip64' property of the archive.
Free disk space is not checked during the build of the archive.
If the catalog is empty and no exception has occured, the .Zip file still exist.
"@ 
	CompressZipFileExamplesRemarks1 = @"
This example adds all files with '.TXT' extension and from current directory in 'C:\Temp\Test.zip' archive.
"@
	CompressZipFileExamplesRemarks2 = @"
This example builds a list of file names and save it to a text file.
Then thi text file is read line by line and each file name is added to the 'C:\Temp\Test.zip' archive.
"@
	CompressZipFileExamplesRemarks3 = @"
This examples builds an array of file names. Some of them include wild cards.
Each file name is resolved, then its result is added to the 'C:\Temp\Test.zip' archive.
The use of '-verbose' parameter display compression progress in the console.
All files are added to the root of the archive. The first entry name clash will trigger an exception because of the default value of '-ZipErrorAction' which is 'Throw'.
"@
	CompressZipFileExamplesRemarks4 = @"
This examples builds an array of file names. Some of them include wild cards.
Each file name is resolved, then its result is added to the 'C:\Temp\Test.zip' archive.
All files are added to the root of the archive. The 'Skip' value of '-ZipErrorAction' parameter will trigger simple errors during possibles entry name clashes.
"@
	CompressZipFileExamplesRemarks5 = @"
This example archive all files from 'C:\Temp' directory.
The '-SetLastModifiedProperty' parameter gets a scriptblock as a value. This one is called internally in order to change 'LastModified' property for each archive entry.
Selected date will be the entry date with the oldest 'LastModified' property.
"@  
	CompressZipFileExamplesRemarks6 = @"
This example recursively archive all files and directories from 'C:\Temp'.
By using 'C:\Temp\*' as a value for '-Path' parameter, it is ensured that there is no entry name clash in the catalog since it is not explicitly traverses the tree, but only the entries in the current directory.
It gets internally the path names returned by the call of 'Resolve-Path' cmdlet. Be aware that hidden files and directories are not archived.
The archive contains multiple entries in the root catalog.
"@
	CompressZipFileExamplesRemarks7 = @"
This example archives all files from 'C:\Temp' directory but without subfolders.
The archive contains several entries at the root of the catalog.
"@
	CompressZipFileExamplesRemarks8 = @"
This example archives all the 'C:\Temp' directory, including subfolders.
The archive contains only one entry at the root of the catalog. This entry is named 'Temp' and is Directory type.
Hidden files and folders are archived.
"@
	CompressZipFileExamplesRemarks9 = @"
This example archives all files in 'C:\Temp' directory.
Hidden files are archived.
"@
	CompressZipFileExamplesRemarks10 = @"
This example archives all '.TXT' files from 'C:\Temp' directory.
The use of '-EntryPathRoot' parameter avoids entry names clashes in the catalog by building encountered tree in the archive.
Hidden files and folders are not archived, but could be by using '-Force' parameter on the 'Get-ChildItem' Cmdlet.
"@
	CompressZipFileExamplesRemarks11 = @"
This example archive all files from 'C:\Temp\Logs' directory, all '.PS1' files from 'C:\Temp' directory and then 'C:\Temp\Setup' directory.
The use of '-Split' parameter split the archive in several files. By number of files to archive, it will create files Archive.z01 and Archive.z0N (where N goes from 2 to 99) and Archive.zip.
"@
}
