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
			type = 'Ionic.Zip.SelfExtractorSaveOptions'
			description = $Datas.SetPsIonicSfxOptionsInputsDescription1
		}
	)
	outputs = @(
		@{
			type = 'None'
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
		@{ text = ''; URI = '' }
	)
}

