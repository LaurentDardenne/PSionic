# Expand-ZipFile command help
@{
	command = 'Expand-ZipFile'
	synopsis = $Datas.ExpandZipFileSynopsis
	description = $Datas.ExpandZipFileDescription
	sets = @{
		LiteralPath = $Datas.ExpandZipFileSetsLiteralPath
		Path = $Datas.ExpandZipFileSetsPath
	}
	parameters = @{
		Create = $Datas.ExpandZipFileParametersCreate
		Encoding = $Datas.ExpandZipFileParametersEncoding
		ExtractAction = $Datas.ExpandZipFileParametersExtractAction
		Flatten = $Datas.ExpandZipFileParametersFlatten
		From = $Datas.ExpandZipFileParametersFrom
		LiteralPath = $Datas.ExpandZipFileParametersLiteralPath
		OutputPath = $Datas.ExpandZipFileParametersOutputPath
		Passthru = $Datas.ExpandZipFileParametersPassthru
		Password = $Datas.ExpandZipFileParametersPassword
		Path = $Datas.ExpandZipFileParametersPath
		ProgressID = $Datas.ExpandZipFileParametersProgressID
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
			type = ''
			description = $Datas.ExpandZipFileOutputsDescription1
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
		@{ text = 'about_Query_Selection_Criteria'; URI = '' }
	)
}

