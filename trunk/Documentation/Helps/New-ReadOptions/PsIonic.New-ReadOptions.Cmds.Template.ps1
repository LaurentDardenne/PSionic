﻿# New-ReadOptions command help
@{
	command = 'New-ReadOptions'
	synopsis = $Datas.NewReadOptionsSynopsis
	description = $Datas.NewReadOptionsDescription
	parameters = @{
		Encoding = $Datas.NewReadOptionsParametersEncoding
		ProgressBarInformations = $Datas.NewReadOptionsParametersProgressBarInformations
	}
	inputs = @(
		@{
			type = ''
			description = $Datas.NewReadOptionsInputsDescription1
		}
	)
	outputs = @(
		@{
			type = 'Ionic.Zip.ReadOptions'
			description = $Datas.NewReadOptionsOutputsDescriptionIonicZipReadOptions
		}
	)
	notes = $Datas.NewReadOptionsNotes
	examples = @(
		@{
			#title = ''
			#introduction = ''
			code = {
			}
			remarks = $Datas.NewReadOptionsExamplesRemarks1
			test = { . $args[0] }
		}
	)
	links = @(
		@{ text = ''; URI = '' }
	)
}

