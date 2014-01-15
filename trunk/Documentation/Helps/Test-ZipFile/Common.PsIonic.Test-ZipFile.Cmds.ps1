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
			code = {
"C:\Temp\*.*"|Compress-ZipFile "C:\Temp\Test.zip"
Test-Zipfile "C:\Temp\Test.zip"
			}
			remarks = $Datas.TestZipFileExamplesRemarks1
			test = { . $args[0] }
		},
		@{
			code = {
"C:\Temp\*.*"|Compress-ZipFile "C:\Temp\Test.zip" -Sfx
Test-Zipfile "C:\Temp\Test.exe"
			}
			remarks = $Datas.TestZipFileExamplesRemarks2
			test = { . $args[0] }
		},
		@{
			code = {
Get-Service Winmgmt|Test-ZipFile
			}
			remarks = $Datas.TestZipFileExamplesRemarks3
			test = { . $args[0] }
		}
	)
	links = @(
		@{ text = ''; URI = '' }
	)
}

