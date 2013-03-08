# Expand-ZipFile command help
@{
	command = 'Expand-ZipFile'
	synopsis = $Datas.ExpandZipFileSynopsis
	description = $Datas.ExpandZipFileDescription
	sets = @{
		Default = $Datas.ExpandZipFileSetsDefault
		List = $Datas.ExpandZipFileSetsList
	}
	parameters = @{
		Create = $Datas.ExpandZipFileParametersCreate
		Destination = $Datas.ExpandZipFileParametersDestination
		Encoding = $Datas.ExpandZipFileParametersEncoding
		ExtractAction = $Datas.ExpandZipFileParametersExtractAction
		File = $Datas.ExpandZipFileParametersFile
		Flatten = $Datas.ExpandZipFileParametersFlatten
		Follow = $Datas.ExpandZipFileParametersFollow
		From = $Datas.ExpandZipFileParametersFrom
		Interactive = $Datas.ExpandZipFileParametersInteractive
		List = $Datas.ExpandZipFileParametersList
		Passthru = $Datas.ExpandZipFileParametersPassthru
		Password = $Datas.ExpandZipFileParametersPassword
		Query = $Datas.ExpandZipFileParametersQuery
	}
	inputs = @(
		@{
			type = ''
			description = $Datas.ExpandZipFileInputsDescription1
		}
	)
	outputs = @(
		@{
			type = 'Default'
			description = $Datas.ExpandZipFileOutputsDescriptionDefault
		}
		@{
			type = 'Ionic.Zip.ZipFile'
			description = $Datas.ExpandZipFileOutputsDescriptionIonicZipZipFile
		}
		@{
			type = 'List'
			description = $Datas.ExpandZipFileOutputsDescriptionList
		}
		@{
			type = 'Ionic.Zip.ZipEntry'
			description = $Datas.ExpandZipFileOutputsDescriptionIonicZipZipEntry
		}
	)
	notes = $Datas.ExpandZipFileNotes
	examples = @(
		@{
			#title = ''
			#introduction = ''
			code = {
			}
			remarks = $Datas.ExpandZipFileExamplesRemarks1
			test = { . $args[0] }
		}
	)
	links = @(
		@{ text = ''; URI = '' }
	)
}

