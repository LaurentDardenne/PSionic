# Update-ZipEntry command data
$Datas = @{
	UpdateZipEntrySynopsis = 'Updates a .ZIP archive or a self-extracting .EXE archive.'
	UpdateZipEntryDescription = 'Updates a .ZIP archive or a self-extracting .EXE archive by changing its inputs or by adding new ones.'
	UpdateZipEntrySets__AllParameterSets = ''
	UpdateZipEntryParametersComment = 'Comment associated with the entry. For entries such as strings or arrays, the comment will be their name by default : [String] or [Byte[]].'
	UpdateZipEntryParametersEntryPathRoot = @"
The entry will be updated or added in the specified path. By default, it is updatedd to the root of the tree contained in the archive. 
The value of this parameter must reference an existing directory path.
.
You need to specify this parameter in order to avoid entry name clashes when compressing a recursive tree.
This one allows to build the name of the entry relatively to the specified directory.

For example, specifying 'C:\Temp\Backup', the treating building name will remove 'C:\Temp\Backup' for each received file during recursive compression of 'C:\Temp\Backup'.
So, for files 'C:\Temp\Backup\File1.ps1' and 'C:\Temp\Backup\Projet\File1.ps1', created entries in the catalog will be respectively :
File1.ps1
Projet/File.ps1   
.
By specifying a directory name different from the begining of the archive will trigger an error and will stop current archiving path.
"@
	UpdateZipEntryParametersInputObject = @"
Content associated with an input archive. Types expected are:
   - One or more objects from type files or directories,
   - One or more file or directory names,
   - A string,
   - An array of bytes.
For all other object types, there will be converted into string with ToString() method.
"@
	UpdateZipEntryParametersName = @"
Each entry is associated with a name in the catalog. For files or directories, their names are automatically used for entries names, in the root of the archive.

For strings or array of bytes, you must specify an entry name. The use of the -EntryPathRoot parameter will not influence this naming.
"@
	UpdateZipEntryParametersPassthru = 'Once the entry is updated in the archive catalog, it is issued in the pipeline.'
	UpdateZipEntryParametersZipFile = 'Target archive in which specified entry is updated. This parameter waits for a ZipFile object and not a file name.'
	UpdateZipEntryInputsDescription1 = ''
	UpdateZipEntryOutputsDescriptionIonicZipZipEntry = ''
	UpdateZipEntryNotes = @"
If an entry already exists, it is updated. The LastModified property is populated with the current date and time.
Updating a directory entry type only adds new elements, but does not delete entries that are no longer on the FileSystem. This is not a synchronization.
By default the addition of an existing entry will trigger an exception.
"@
	UpdateZipEntryExamplesRemarks1 = @"
This commands update an entry in the C:\Temp\Test.zip archive:
   - The first instruction creates an archive object from a file name,
   - The second, from the current directory, updates archive entries corresponding to *.txt file names,
   - The third updates the file in the archive,
   - The fourth saves the archive on the disk and frees system ressources.
"@
	UpdateZipEntryExamplesRemarks2 = @"
This commands update entries in the archive 'C:\Temp\Test.Zip':
   - The first instruction creates an archive object from a file name,
   - The second one updates all entries of the archive corresponding to '*.txt' file names from current directory,
   - The third updates or creates an entry containing a string,
   - The fourth saves the archive on the disk and frees system ressources.
"@
	UpdateZipEntryExamplesRemarks3 = @"
This commands update a named entry in the archive 'C:\Temp\Test.Zip' from a string:
   - The first instruction creates an archive object from a file name,
   - The second one read a file text and sets the result into a string,
   - The third updates or creates an entry containing a string,
   - The fourth saves the archive on the disk and frees system ressources.
"@
	UpdateZipEntryExamplesRemarks4 = @"
This commands update a named entry in the archive 'C:\Temp\Test.Zip' from a serialized object:
   - The first instruction creates an archive object from a file name,
   - The second one serializes the object contained in the $PSVersionTable variable, then updates or creates named entry in the archive,
   - The third saves the archive on the disk and frees system ressources.
"@
	UpdateZipEntryExamplesRemarks5 = @"
This commands update an entry named 'MyArray' in the archive 'C:\Temp\Test.Zip':
   - The first instruction creates an archive object from a file name,
   - The second one adds the object contained in the '$Array' variable, then updates or creates the entry named 'MyArray', 
   - The third saves the archive on the disk and frees system ressources.
"@
}


