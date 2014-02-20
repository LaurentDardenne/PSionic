# Update-ZipEntry command help
@{
	command = 'Update-ZipEntry'
	synopsis = $Datas.UpdateZipEntrySynopsis
	description = $Datas.UpdateZipEntryDescription
	parameters = @{
		Comment = $Datas.UpdateZipEntryParametersComment
		EntryPathRoot = $Datas.UpdateZipEntryParametersEntryPathRoot
		InputObject = $Datas.UpdateZipEntryParametersInputObject
		Name = $Datas.UpdateZipEntryParametersName
		Passthru = $Datas.UpdateZipEntryParametersPassthru
		ZipFile = $Datas.UpdateZipEntryParametersZipFile
	}
	inputs = @(
		@{
			type = ''
			description = $Datas.UpdateZipEntryInputsDescription1
		}
	)
	outputs = @(
		@{
			type = 'Ionic.Zip.ZipEntry'
			description = $Datas.UpdateZipEntryOutputsDescriptionIonicZipZipEntry
		}
	)
	notes = $Datas.UpdateZipEntryNotes
	examples = @(
		@{
			#title = ''
			#introduction = ''
			code = {
			}
			remarks = $Datas.UpdateZipEntryExamplesRemarks1
			test = { . $args[0] }
		}
	)
	links = @(
		@{ text = ''; URI = '' }
	)
}

