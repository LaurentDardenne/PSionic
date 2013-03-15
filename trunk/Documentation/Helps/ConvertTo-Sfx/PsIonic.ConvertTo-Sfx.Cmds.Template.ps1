# ConvertTo-Sfx command help
@{
	command = 'ConvertTo-Sfx'
	synopsis = $Datas.ConvertToSfxSynopsis
	description = $Datas.ConvertToSfxDescription
	parameters = @{
		Comment = $Datas.ConvertToSfxParametersComment
		Name = $Datas.ConvertToSfxParametersName
		Passthru = $Datas.ConvertToSfxParametersPassthru
		ReadOptions = $Datas.ConvertToSfxParametersReadOptions
		SaveOptions = $Datas.ConvertToSfxParametersSaveOptions
	}
	inputs = @(
		@{
			type = ''
			description = $Datas.ConvertToSfxInputsDescription1
		}
	)
	outputs = @(
		@{
			type = 'System.IO.FileInfo'
			description = $Datas.ConvertToSfxOutputsDescriptionSystemIOFileInfo
		}
	)
	notes = $Datas.ConvertToSfxNotes
	examples = @(
		@{
			#title = ''
			#introduction = ''
			code = {
			}
			remarks = $Datas.ConvertToSfxExamplesRemarks1
			test = { . $args[0] }
		}
	)
	links = @(
		@{ text = ''; URI = '' }
	)
}
