# ConvertTo-CliXml command help
@{
	command = 'ConvertTo-CliXml'
	synopsis = $Datas.ConvertToCliXmlSynopsis
	description = $Datas.ConvertToCliXmlDescription
	parameters = @{
		InputObject = $Datas.ConvertToCliXmlParametersInputObject
	}
	inputs = @(
		@{
			type = ''
			description = $Datas.ConvertToCliXmlInputsDescription1
		}
	)
	outputs = @(
		@{
			type = ''
			description = $Datas.ConvertToCliXmlOutputsDescription1
		}
	)
	notes = $Datas.ConvertToCliXmlNotes
	examples = @(
		@{
			#title = ''
			#introduction = ''
			code = {
			}
			remarks = $Datas.ConvertToCliXmlExamplesRemarks1
			test = { . $args[0] }
		}
	)
	links = @(
		@{ text = ''; URI = '' }
	)
}

