# Test-ZipFile command help
@{
	command = 'Test-ZipFile'
	synopsis = $Datas.TestZipFileSynopsis
	description = $Datas.TestZipFileDescription
	sets = @{}
	parameters = @{
		Check = $Datas.TestZipFileParametersCheck
		isValid = $Datas.TestZipFileParametersisValid
		Passthru = $Datas.TestZipFileParametersPassthru
		Password = $Datas.TestZipFileParametersPassword
		Path = $Datas.TestZipFileParametersPath
		Repair = $Datas.TestZipFileParametersRepair
	}
	inputs = @(
		@{
			type = ''
			description = $Datas.TestZipFileInputsDescription1
		}
	)
	outputs = @(
		@{
			type = 'System.Boolean'
			description = $Datas.TestZipFileOutputsDescriptionSystemBoolean
		}
		@{
			type = 'System.String'
			description = $Datas.TestZipFileOutputsDescriptionSystemString
		}
	)
	notes = $Datas.TestZipFileNotes
	examples = @(
		@{
			#title = ''
			#introduction = ''
			code = {
			}
			remarks = $Datas.TestZipFileExamplesRemarks1
			test = { . $args[0] }
		}
	)
	links = @(
		@{ text = ''; URI = '' }
	)
}

