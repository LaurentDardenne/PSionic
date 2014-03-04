# Set-PsIonicSfxOptions command help
@{
	command = 'Set-PsIonicSfxOptions'
	synopsis = $Datas.SetPsIonicSfxOptionsSynopsis
	description = $Datas.SetPsIonicSfxOptionsDescription
	parameters = @{
		Options = $Datas.SetPsIonicSfxOptionsParametersOptions
	}
	inputs = @(
		@{
			type = ''
			description = $Datas.SetPsIonicSfxOptionsInputsDescription1
		}
	)
	outputs = @(
		@{
			type = ''
			description = $Datas.SetPsIonicSfxOptionsOutputsDescription1
		}
	)
	notes = $Datas.SetPsIonicSfxOptionsNotes
	examples = @(
		@{
			code = {
$MyConfiguration=New-ZipSfxOptions -Copyright "This module is free for non-commercial purposes." 
Set-PsIonicSfxOptions $MyConfiguration         
			}
			remarks = $Datas.SetPsIonicSfxOptionsExamplesRemarks1
			test = { . $args[0] }
		}
	)
	links = @(
 @{ text = ''; URI = 'https://psionic.codeplex.com/wikipage?title=Set-PsIonicSfxOptions-FR'}
	)
}

