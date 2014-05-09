# Reset-PsIonicSfxOptions command help
@{
	command = 'Reset-PsIonicSfxOptions'
	synopsis = $Datas.ResetPsIonicSfxOptionsSynopsis
	description = $Datas.ResetPsIonicSfxOptionsDescription
	inputs = @(
		@{
			type = 'None'
			description = $Datas.ResetPsIonicSfxOptionsInputsDescription1
		}
	)
	outputs = @(
		@{
			type = 'None'
			description = $Datas.ResetPsIonicSfxOptionsOutputsDescription1
		}
	)
	notes = $Datas.ResetPsIonicSfxOptionsNotes
	examples = @(
		@{
			code = {
Reset-PsIonicSfxOptions         
			}
			remarks = $Datas.ResetPsIonicSfxOptionsExamplesRemarks1
			test = { . $args[0] }
		}
	)
	links = @(
		@{ text = ''; URI = '' }
	)
}

