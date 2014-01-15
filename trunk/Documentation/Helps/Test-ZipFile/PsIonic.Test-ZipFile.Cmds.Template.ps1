# Test-ZipFile command help
@{
	command = 'Test-ZipFile'
	synopsis = $Datas.TestZipFileSynopsis
	description = $Datas.TestZipFileDescription
	sets = @{
		Default = $Datas.TestZipFileSetsDefault
		File = $Datas.TestZipFileSetsFile
	}
	parameters = @{
		Check = $Datas.TestZipFileParametersCheck
		Path = $Datas.TestZipFileParametersPath
		isValid = $Datas.TestZipFileParametersisValid
		Passthru = $Datas.TestZipFileParametersPassthru
		Password = $Datas.TestZipFileParametersPassword
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
			type = 'Default'
			description = $Datas.TestZipFileOutputsDescriptionDefault
		}
		@{
			type = 'bool'
			description = $Datas.TestZipFileOutputsDescriptionbool
		}
		@{
			type = 'File'
			description = $Datas.TestZipFileOutputsDescriptionFile
		}
		@{
			type = 'string'
			description = $Datas.TestZipFileOutputsDescriptionstring
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

