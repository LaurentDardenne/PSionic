# New-ReadOptions command help
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
			type = 'Aucun'
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
			code = {
$ReadOptions=New-ReadOptions          
			}
			remarks = $Datas.NewReadOptionsExamplesRemarks1
			test = { . $args[0] }
		}
		@{
			code = {
$ReadOptions=New-ReadOptions -Verbose         
			}
			remarks = $Datas.NewReadOptionsExamplesRemarks2
			test = { . $args[0] }
		}
		@{
			code = {
$pbi=New-ProgressBarInformations $ProgressID "Reading in progress  "
$ReadOptions=New-ReadOptions $Encoding $pbi  
			}
			remarks = $Datas.NewReadOptionsExamplesRemarks3
			test = { . $args[0] }
		}
		@{
			code = {
$pbi=New-ProgressBarInformations $ProgressID "Reading in progress "
$ReadOptions=New-ReadOptions $Encoding $pbi  
$ReadOptions.StatusMessageWriter = [System.Console]::Out
			}
			remarks = $Datas.NewReadOptionsExamplesRemarks4
			test = { . $args[0] }
		}
	)
	links = @(
 @{ text = ''; URI = 'https://psionic.codeplex.com/wikipage?title=New-ReadOptions-FR'}
	)
}
