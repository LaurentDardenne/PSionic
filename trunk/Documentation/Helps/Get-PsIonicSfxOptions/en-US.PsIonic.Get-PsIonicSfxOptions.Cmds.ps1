# Get-PsIonicSfxOptions command help
@{
	command = 'Get-PsIonicSfxOptions'
	synopsis = $Datas.GetPsIonicSfxOptionsSynopsis
	description = $Datas.GetPsIonicSfxOptionsDescription
	inputs = @(
		@{
			type = 'None'
			description = $Datas.GetPsIonicSfxOptionsInputsDescription1
		}
	)
	outputs = @(
		@{
			type = 'Ionic.Zip.SelfExtractorSaveOptions'
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
 @{ text = ''; URI = 'https://psionic.codeplex.com/wikipage?title=Get-PsIonicSfxOptions-EN'}
	)
}

