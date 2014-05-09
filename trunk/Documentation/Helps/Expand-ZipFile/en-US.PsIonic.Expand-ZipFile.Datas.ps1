# Expand-ZipFile command data
$Datas = @{
	ExpandZipFileSynopsis = 'Extracts files and/or folders from an archive compressed in Zip format.'
	ExpandZipFileDescription = @"
Extracts files and/or folders from an archive compressed in Zip format or a self-extracting archive ('.EXE').
"@
	ExpandZipFileSetsLiteralPath = ''
	ExpandZipFileSetsPath = ''
	ExpandZipFileParametersCreate = "Creates the destination directory if it does not exist."
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
	ExpandZipFileParametersExtractAction = 'Specifies steps to be taken when data is already present in the destination folder.'
	ExpandZipFileParametersFlatten = 'Files are extracted with no directory tree.'
	ExpandZipFileParametersFrom = @"
Specifies the archive directory from which entries will be extracted.
The syntax of an archive directory name is : 'DirectoryName/' or 'DirectoryName/SubDirectoryName/'.

The use of this parameter needs to specify a '-Query' parameter, otherwise an exception will be triggered.
"@
	ExpandZipFileParametersLiteralPath = @"
Zip file object of type String or system.IO.FileInfo.
In case of a String type, it must not contains wild card caracters. Delayed script block on '-OutPutPath' parameter
will only trigger once. In contrast, the late binding will be triggered for each object received.
"@
	ExpandZipFileParametersOutputPath = @"
Destination folder used for data extraction contained in a Zip archive.
This parameter can use a delayed script block.
"@
	ExpandZipFileParametersPassthru = @'
Sends out the zip archive in the pipeline. Be careful, in this case the release of resources by calling the Close () method is your responsibility.
The archive object returned is not locked so pay attention to your usage scenarios of this object.
'@
	ExpandZipFileParametersPassword = @"
Password used for encryption. Encryption method needs to be specified with the '-Encryption' parameter.
"@
	ExpandZipFileParametersPath =@"
File names list to expand. Can be a file object or a string. In this last case, generic characters can be used (* , ? , [A-D] ou [1CZ]).
"@
	ExpandZipFileParametersProgressID = @"
When opening a zip archive of a big size, you can choose to display a progress bar.
The use of this parameter makes a progress bar for read operations that will be replaced during write operations.
The progress bar for read operations only displays the number of read entries.
If '-Query' parameter is specified, then progress bar for extraction will only display the extracted files. Otherwise it will display the name and the percentage of the progress.

Note : Obviously the duration of the presence of the progress bar on the screen depends on the number of entries in the archive.
"@
	ExpandZipFileParametersQuery = @"
Specifies a search for data to be extracted from the zip archive.
For more information on writing and query syntax, see the 'about_Query_Selection_Criteria' Help file or the documentation from the Ionic dll (.chm help file).
Warning, there is no consistency check on the contents of the query, for example 'size <100 byte AND Size> 1000 byte' will not cause an error, but no file will be selected.
If you also specify the '-Passthru' parameter, a custom property named 'Query' will be added to the returned object.
"@
	ExpandZipFileInputsDescription1 = ''
	ExpandZipFileOutputsDescription1 = '' 
    ExpandZipFileOutputsDescriptionIonicZipZipFile = 'If the Passthru parameter is specified, the output is the archive Zip object.'
	ExpandZipFileNotes = @"
A Zip archive should contains several entries each of which has a compression mode and / or other different encryption.
However, this function needs a same passeword for all archive entries. Otherwise an exception will occured during the first encrypted file decompression.
"@
	ExpandZipFileExamplesRemarks1 = 'Extracts data contained in a Zip archive to a folder path destination.'
    ExpandZipFileExamplesRemarks2 = @"
Extracts data contained in a Zip archive to a folder path destination. 
The use of '-Create' parameter forces the creation of a target folder if it does not exist.
"@
    ExpandZipFileExamplesRemarks3 = @"
Extracts data contained in a Zip archive to a folder path destination.
During extraction the first collision entries name will trigger an exception because of the default 'Throw' value of the -ErrorAction parameter.
"@
    ExpandZipFileExamplesRemarks4 = @"
Extracts data contained in a Zip archive to a folder path destination.
During extraction the use of the 'OverwriteSilently' value for the '-ErrorAction' parameter will trigger simple errors in case of possibles files name collisions. 
"@
    ExpandZipFileExamplesRemarks5 = @"
Extracts data contained in a Zip archive to a folder path destination.
Only data corresponding to the query are extracted. Here it is files whith '.jpg' extension.
"@
    ExpandZipFileExamplesRemarks6 = @"
Extracts data contained in a Zip archive to a folder path destination.
Only data corresponding to the query are extracted. Here it is folders only.
"@
    ExpandZipFileExamplesRemarks7 = @"
Extracts data contained in a Zip archive to a folder path destination.
A progress bar displays extraction's informations.
"@
    ExpandZipFileExamplesRemarks8 = @"
The first line of instruction extracts all archives in the new folder 'C:\Temp\TestZip'.
Here delayed script block is triggered only one time, because the 'Expand-ZipFile' function receives only one object.
Furthermore the object issued being a string and not a file, the BaseName property of the current object does not exist.
The strings representing the files are processed internally, well after the onset of late delayed script block.
.
The second line instruction extracts each archive to a new folder 'C:\Temp\TestZip'.
Here delayed script block is trigerred many times because the 'Expand-ZipFile' function receives several objects, all of file types.
So this instructions will make folder paths 'C:\Temp\TestZip\Archive1','C:\Temp\TestZip\Archive2', 'C:\Temp\TestZip\ArchiveN'...  
"@
    ExpandZipFileExamplesRemarks9 = @"
This example extracts all '.dll' files from the 'Bin/V2/' directory of the archive, to the 'C:\Temp\ExtractArchive' folder.
The '-Flatten' parameter says to extract files to the specified root directory. The already existing directory tree is not created again.
The '-Verbose' parameter displays all read entries, then extracted ones.
The '-passthru' parameter retrieves the instance of the archive, which allows to continue working on the archive.
Once processing is finished, we explicitly frees the instance of the archive object, which will unlock the file.
"@
}


