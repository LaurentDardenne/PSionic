# New-ReadOptions command help
@{
	command = 'New-ReadOptions'
	synopsis = $Datas.NewReadOptionsSynopsis
	description = $Datas.NewReadOptionsDescription
	parameters = @{
		Encoding = $Datas.NewReadOptionsParametersEncoding
		Follow = $Datas.NewReadOptionsParametersFollow
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
			remarks = $Datas.NewReadOptionsExamplesRemarks1
			test = { . $args[0] }
		}
		@{
			code = {
$ReadOptions=New-ReadOptions $Encoding -Follow         
			}
			remarks = $Datas.NewReadOptionsExamplesRemarks1
			test = { . $args[0] }
		}
	)
	links = @(
		@{ text = ''; URI = '' }
	)
}

