# Remove-ZipEntry command help
@{
	command = 'Remove-ZipEntry'
	synopsis = $Datas.RemoveZipEntrySynopsis
	description = $Datas.RemoveZipEntryDescription
	sets = @{
		Name = $Datas.RemoveZipEntrySetsName
		Query = $Datas.RemoveZipEntrySetsQuery
	}
	parameters = @{
		From = $Datas.RemoveZipEntryParametersFrom
		InputObject = $Datas.RemoveZipEntryParametersInputObject
		Name = $Datas.RemoveZipEntryParametersName
		Query = $Datas.RemoveZipEntryParametersQuery
		ZipFile = $Datas.RemoveZipEntryParametersZipFile
	}
	inputs = @(
		@{
			type = ''
			description = $Datas.RemoveZipEntryInputsDescription1
		}
	)
	outputs = @(
		@{
			type = 'System.Management.Automation.PSObject'
			description = $Datas.RemoveZipEntryOutputsDescriptionSystemManagementAutomationPSObject
		}
	)
	notes = $Datas.RemoveZipEntryNotes
	examples = @(
		@{
			#title = ''
			#introduction = ''
			code = {
			}
			remarks = $Datas.RemoveZipEntryExamplesRemarks1
			test = { . $args[0] }
		}
	)
	links = @(
		@{ text = ''; URI = '' }
	)
}

