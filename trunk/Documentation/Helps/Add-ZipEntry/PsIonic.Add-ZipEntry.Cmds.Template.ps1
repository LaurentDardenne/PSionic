# Add-ZipEntry command help
@{
	command = 'Add-ZipEntry'
	synopsis = $Datas.AddZipEntrySynopsis
	description = $Datas.AddZipEntryDescription
	parameters = @{
		Comment= $Datas.AddZipEntryParametersComment
        DirectoryPath = $Datas.AddZipEntryParametersDirectoryPath
		Name = $Datas.AddZipEntryParametersName
		Object = $Datas.AddZipEntryParametersObject
        Overwrite = $Datas.AddZipEntryParametersOverwrite
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

