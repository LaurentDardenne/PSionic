# Get-PsIonicSfxOptions command help
@{
	command = 'Get-PsIonicSfxOptions'
	synopsis = $Datas.GetPsIonicSfxOptionsSynopsis
	description = $Datas.GetPsIonicSfxOptionsDescription
	inputs = @(
		@{
			type = ''
			description = $Datas.GetPsIonicSfxOptionsInputsDescription1
		}
	)
	outputs = @(
		@{
			type = ''
			description = $Datas.GetPsIonicSfxOptionsOutputsDescription1
		}
	)
	notes = $Datas.GetPsIonicSfxOptionsNotes
	examples = @(
		@{
			code = {
$MyConfiguration=Get-PsIonicSfxOptions         
			}
			remarks = $Datas.GetPsIonicSfxOptionsExamplesRemarks1
			test = { . $args[0] }
		}
	)
	links = @(
 @{ text = ''; URI = 'https://psionic.codeplex.com/wikipage?title=Get-PsIonicSfxOptions-FR'}
	)
}

