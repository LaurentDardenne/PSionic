# Expand-Entry command help
@{
	command = 'Expand-Entry'
	synopsis = $Datas.ExpandEntrySynopsis
	description = $Datas.ExpandEntryDescription
	parameters = @{
		Encoding = $Datas.ExpandEntryParametersEncoding
		ExtractAction = $Datas.ExpandEntryParametersExtractAction
		Name = $Datas.ExpandEntryParametersName
		Password = $Datas.ExpandEntryParametersPassword
		Strict = $Datas.ExpandEntryParametersStrict
		XML = $Datas.ExpandEntryParametersXML
		ZipFile = $Datas.ExpandEntryParametersZipFile
	}
	inputs = @(
		@{
			type = ''
			description = $Datas.ExpandEntryInputsDescription1
		}
	)
	outputs = @(
		@{
			type = 'Ionic.Zip.ZipEntry'
			description = $Datas.ExpandEntryOutputsDescriptionIonicZipZipEntry
		}
	)
	notes = $Datas.ExpandEntryNotes
	examples = @(
		@{
			#title = ''
			#introduction = ''
			code = {
			}
			remarks = $Datas.ExpandEntryExamplesRemarks1
			test = { . $args[0] }
		}
	)
	links = @(
		@{ text = ''; URI = '' }
	)
}

