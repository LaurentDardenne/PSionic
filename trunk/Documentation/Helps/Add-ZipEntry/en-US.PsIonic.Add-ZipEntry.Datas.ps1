# Add-ZipEntry command data
$Datas = @{
	AddZipEntrySynopsis = 'Add an entry into an existing zip archive.'
	AddZipEntryDescription = 'Add an entry into an existing .zip archive''s catalog or a self extracting .exe archive. This entry can be a file or a directory name, a string or an array of bytes.'
	AddZipEntrySets__AllParameterSets = ''
    AddZipEntryParametersComment = 'Comment associated with the entry. For entries such as strings or arrays, the comment will be their name by default : [String] or [Byte[]].' 
	AddZipEntryParametersEntryPathRoot = @"
The new entry will be added in the specified path. By default, it is added to the root of the tree contained in the archive. 
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
	AddZipEntryParametersName = @"
Each entry is associated with a name in the catalog. For files or directories, their names are automatically used for entries names, in the root of the archive.
.
For strings or array of bytes, you must specify an entry name. The use of the -EntryPathRoot parameter will not influence this naming.
.
During the call of the Expand-ZipFile function, the string or arrays entries will be extracted like for files.
"@	
    AddZipEntryParametersInputObject = @"
Contents associated to an entry. Allowed types are :
   - one or many files or directories objects,
   - one or multiple file or directory names,
   - a string,
   - or an array of bytes.
.

All other types of object will be processed to string from ToString() method.   
"@
    AddZipEntryParametersPassthru = 'Once entry is added to the archive''s catalog, it is sent to the pipeline.'
	AddZipEntryParametersZipFile = 'Target archive in which specified entry is added. This parameter waits for a ZipFile object and not a file name.'
	AddZipEntryInputsDescription1 = @"
System.Byte[], System.String, System.IO.DirectoryInfo, System.IO.FileInfo, Ionic.Zip.ZipEntry.
You can send any object of the above types in the pipeline.
"@
	AddZipEntryOutputsDescriptionIonicZipZipEntry = ''
	AddZipEntryNotes = @"
By default, the add of an existing entry will trigger an exception.
This function works with the Expand-ZipEntry function.
"@
	AddZipEntryExamplesRemarks1 = @"
This commands add an entry to the C:\Temp\Test.zip archive.
  -The first command makes an archive object from a file name, 
  -The second one builds a file object from a file name, 
  -The third one adds the file to an archive, 
  -The forth saves the archive on the disk and frees system ressources.  
"@
    AddZipEntryExamplesRemarks2 = @"
This commands add entries to the C:\Temp\Test.zip archive. 
  -The first instruction builds an archive object from a file name, 
  -The second one, from current directory, adds all .txt files to the archive, 
  -The third saves the archive to the disk and frees all system ressources.
"@        
    AddZipEntryExamplesRemarks3 = @"
This commands add a named entry in the C:\Temp\Test.zip archive from a string.
  -The first instruction makes an archive object from a file name, 
  -The second reads a text file and get the result into a string,
  -The third one makes an entry whose contents is saved to a string, 
  -The forth one saves the archive to the disk and frees the system ressources.
"@  
    AddZipEntryExamplesRemarks4 = @'
This commands add a named entry in the C:\Temp\Test.zip archive from a serialized object.
  -The first instruction builds an archive object from a file name, 
  -The second serializes the contents of the object into the $PSVersiontable variable and adds it as a named entry to the archive, 
  -The third one saves the archive to the disk and frees the system ressources.
'@  
    AddZipEntryExamplesRemarks5 =@'
This commands add an entry named MyArray to the C:\Temp\Test.zip archive. 
  -The first instruction makes an archive object from a file name, 
  -The second one adds the object contained in the $Array variable and adds it to the archive as an entry named MyArray, 
  -The third one saves the archive to the disk and frees system ressources.  
'@
}


