# Update-ZipEntry command data
$Datas = @{
	UpdateZipEntrySynopsis = 'todo'
	UpdateZipEntryDescription = ''
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
	UpdateZipEntryParametersInputObject = ''
	UpdateZipEntryParametersName = @"
Each entry is associated with a name in the catalog. For files or directories, their names are automatically used for entries names, in the root of the archive.
.
For strings or array of bytes, you must specify an entry name. The use of the -EntryPathRoot parameter will not influence this naming.
"@
	UpdateZipEntryParametersPassthru = ''
	UpdateZipEntryParametersZipFile = 'Target archive in which specified entry is updated. This parameter waits for a ZipFile object and not a file name.'
	UpdateZipEntryInputsDescription1 = ''
	UpdateZipEntryOutputsDescriptionIonicZipZipEntry = ''
	UpdateZipEntryNotes = ''
	UpdateZipEntryExamplesRemarks1 = ''
}


