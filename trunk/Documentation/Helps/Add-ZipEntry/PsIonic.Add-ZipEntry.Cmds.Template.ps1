# Add-ZipEntry command help
@{
	command = 'Add-ZipEntry'
	synopsis = $Datas.AddZipEntrySynopsis
	description = $Datas.AddZipEntryDescription
	parameters = @{
		Comment= $Datas.AddZipEntryParametersComment
        EntryPathRoot = $Datas.AddZipEntryParametersEntryPathRoot
		Name = $Datas.AddZipEntryParametersName
		InputObject = $Datas.AddZipEntryParametersInputObject
		Passthru = $Datas.AddZipEntryParametersPassthru
		ZipFile = $Datas.AddZipEntryParametersZipFile
	}
	inputs = @(
		@{
			type = ''
			description = $Datas.AddZipEntryInputsDescription1
		}
	)
	outputs = @(
		@{
			type = 'Ionic.Zip.ZipEntry'
			description = $Datas.AddZipEntryOutputsDescriptionIonicZipZipEntry
		}
	)
	notes = $Datas.AddZipEntryNotes
	examples = @(
		@{
			#title = ''
			#introduction = ''
			code = {
			}
			remarks = $Datas.AddZipEntryExamplesRemarks1
			test = { . $args[0] }
		}
	)
	links = @(
		@{ text = ''; URI = '' }
	)
}

