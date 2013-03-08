# Format-ZipFile command help
@{
	command = 'Format-ZipFile'
	synopsis = $Datas.FormatZipFileSynopsis
	description = $Datas.FormatZipFileDescription
	parameters = @{
		Properties = $Datas.FormatZipFileParametersProperties
		Zip = $Datas.FormatZipFileParametersZip
	}
	inputs = @(
		@{
			type = ''
			description = $Datas.FormatZipFileInputsDescription1
		}
	)
	outputs = @(
		@{
			type = ''
			description = $Datas.FormatZipFileOutputsDescription1
		}
	)
	notes = $Datas.FormatZipFileNotes
	examples = @(
		@{
			#title = ''
			#introduction = ''
			code = {
			}
			remarks = $Datas.FormatZipFileExamplesRemarks1
			test = { . $args[0] }
		}
	)
	links = @(
		@{ text = ''; URI = '' }
	)
}

