# Expand-ZipEntry command help
@{
	command = 'Expand-ZipEntry'
	synopsis = $Datas.ExpandZipEntrySynopsis
	description = $Datas.ExpandZipEntryDescription
	parameters = @{
		Encoding = $Datas.ExpandZipEntryParametersEncoding
		ExtractAction = $Datas.ExpandZipEntryParametersExtractAction
		Name = $Datas.ExpandZipEntryParametersName
		Password = $Datas.ExpandZipEntryParametersPassword
		Strict = $Datas.ExpandZipEntryParametersStrict
		XML = $Datas.ExpandZipEntryParametersXML
		ZipFile = $Datas.ExpandZipEntryParametersZipFile
	}
	inputs = @(
		@{
			type = ''
			description = $Datas.ExpandZipEntryInputsDescription1
		}
	)
	outputs = @(
		@{
			type = 'Ionic.Zip.ZipEntry'
			description = $Datas.ExpandZipEntryOutputsDescriptionIonicZipZipEntry
		}
	)
	notes = $Datas.ExpandZipEntryNotes
	examples = @(
		@{
			#title = ''
			#introduction = ''
			code = {
			}
			remarks = $Datas.ExpandZipEntryExamplesRemarks1
			test = { . $args[0] }
		}
	)
	links = @(
		@{ text = ''; URI = '' }
	)
}

