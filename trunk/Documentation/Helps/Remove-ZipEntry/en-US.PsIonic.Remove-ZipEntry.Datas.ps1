# Remove-ZipEntry command data
$Datas = @{
	RemoveZipEntrySynopsis = 'Deletes one or more entries from an archive.'
	RemoveZipEntryDescription = "Deletes one or more entries from a '.Zip' archive or from a self-extracting archive .exe."
	RemoveZipEntrySetsName = ''
	RemoveZipEntrySetsQuery = ''
	RemoveZipEntryParametersFrom = @"
Specifies the archive folder in which entries will be deleted.
A folder name in an archive has the following syntax : 'FolderName/' or 'FolderName/SubFolderName/'.

The use of this parameter needs to specify the '-Query' parameter, otherwise an exception will be thrown.
"@
	RemoveZipEntryParametersInputObject = @"
Content associated with an input archive. Types expected are:
   - One or more objects from type files or directories,
   - A string referencing an entry. If it references a directory name, it must end with the '/' character,
   - An object fro mtype ZipEntry,
   - An array of objects from type ZipEntry,
   - An array of strings or objects. In this last case his contents will be changed to String.
All others arrays types, other than those indicated above, will throw an exception.
For all other object types, there will be converted into string.
"@
	RemoveZipEntryParametersName = @"
Each entry is associated with a name in the catalog. For files or directories, their names are automatically used for entries names, in the root of the archive.
"@
	RemoveZipEntryParametersQuery = @"
Specifies a search for data to be deleted from the Zip archive.
For more information on writing and query syntax, see the Help file about_Query_Selection_Criteria or the documentation of Ionic dll (Chm help file).
Warning, there is no consistency check on the contents of the query, for example 'size <100 byte AND Size> 1000 byte' will not cause an error, but no file will be selected.
"@
	RemoveZipEntryParametersZipFile = 'Target archive in which specified entry is removed. This parameter waits for a ZipFile object and not a file name.'
	RemoveZipEntryInputsDescription1 = ''
	RemoveZipEntryOutputsDescription1 = ''
	RemoveZipEntryNotes = ''
	RemoveZipEntryExamplesRemarks1 = "These statements remove, if it exists, the entry 'Test.ps1' from the root of 'Test.zip' file."
	RemoveZipEntryExamplesRemarks2 = "These statements remove, if it exists, the entry 'Test.ps1' from the root of 'Test.zip' file."
	RemoveZipEntryExamplesRemarks3 = 'These statements remove, if it exists, the entries ''Test.ps1'' and ''Setup.ps1'', contained in the array of string $Tab, from the root of ''Test.zip'' file.'
	RemoveZipEntryExamplesRemarks4 = @"
Those instructions delete from the root of the 'Test.zip' file and if it exists :
- The 'Test.ps1' entry,
- All entries finishing with '.XML' and
- All names of the entries contained in the 'C:\Temp\ListeFileName.txt' file.
"@
	RemoveZipEntryExamplesRemarks5 = @"
Those instructions, using a query, delete all entries ending with '.TXT' from the root of the 'Test.zip' file.
"@
	RemoveZipEntryExamplesRemarks6 = @"
Those instructions, using a query, delete all entries ending with '.TXT', in the 'Doc/' directory of the 'Test.zip' file.
"@
}


