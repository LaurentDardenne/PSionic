# New-ProgressBarInformations command data
$Datas = @{
	NewProgressBarInformationsSynopsis = 'Creates a statement object of a standard Psionic progress bar.'
	NewProgressBarInformationsDescription = "This object is used by the 'New-ReadOptions' function."
	NewProgressBarInformationsSets__AllParameterSets = ''
	NewProgressBarInformationsParametersactivity = @"
Shows the first text line in the progress bar title.
This text describes activity whose progress is reported.
"@
	NewProgressBarInformationsParametersactivityId = @"
Indicates an identifier distinguishing each progress bar.
Use this parameter when you create several progress bars into only one command.
If progress bars have no different identity, there will be superposed instead of being shown one below the other.
"@
	NewProgressBarInformationsInputsDescription1 = ''
	NewProgressBarInformationsOutputsDescription1 = 'Its typename is ProgressBarInformations.'
	NewProgressBarInformationsNotes = ''
	NewProgressBarInformationsExamplesRemarks1 = @"
This example creates a progress bar used in settings of an archive read options.
In this context the names of the files that are read are not accessible, so the progress bar will display only the number of read entries.
"@
	NewProgressBarInformationsExamplesRemarks2 = @"
This example reads all Zip archives from C:\Temp folder, then extracts them.
We directly use the '-ProgressID' parameter of the 'Expand-ZipFile' function which configures internally a progress bar.
In this case when reading the catalog, the value of the 'Activity' parameter can not be modified, because it is hard-coded. 
"@
}


