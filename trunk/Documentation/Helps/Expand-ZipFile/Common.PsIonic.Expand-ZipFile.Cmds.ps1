# Expand-ZipFile command help
@{
	command = 'Expand-ZipFile'
	synopsis = $Datas.ExpandZipFileSynopsis
	description = $Datas.ExpandZipFileDescription
	sets = @{
		Path = $Datas.ExpandZipFileSetsPath
		LiteralPath = $Datas.ExpandZipFileSetsLiteralPath
	}
	parameters = @{
		Create = $Datas.ExpandZipFileParametersCreate
		OutputPath = $Datas.ExpandZipFileParametersOutputPath
		Encoding = $Datas.ExpandZipFileParametersEncoding
		ExtractAction = $Datas.ExpandZipFileParametersExtractAction
		Path = $Datas.ExpandZipFileParametersPath
        LiteralPath = $Datas.ExpandZipFileParametersLiteralPath
		Flatten = $Datas.ExpandZipFileParametersFlatten
		ProgressID = $Datas.ExpandZipFileParametersProgressID
		From = $Datas.ExpandZipFileParametersFrom
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
			type = ''
			description = $Datas.ExpandZipFileOutputsDescription1
		}
	)
	notes = $Datas.ExpandZipFileNotes
    examples = @(
		@{
			code = {
              Expand-ZipFile -Path C:\Archive.zip -OutputPath C:\Temp\
			}
			remarks = $Datas.ExpandZipFileExamplesRemarks1
			test = { . $args[0] }
		}
		@{
			code = {
              Get-ChildItem D:\*.zip -recurse | 
               Expand-ZipFile C:\Temp\
			}
			remarks = $Datas.ExpandZipFileExamplesRemarks2
			test = { . $args[0] }
		}
		@{
			code = {
              Expand-ZipFile -Path C:\Archive.zip -OutputPath C:\Temp\ -Query 'name = *.jpg'
			}
			remarks = $Datas.ExpandZipFileExamplesRemarks3
			test = { . $args[0] }
		}
		@{
			code = {
              Expand-ZipFile -Path C:\Archive.zip -OutputPath C:\Temp\ -Query 'type = D'
			}
			remarks = $Datas.ExpandZipFileExamplesRemarks4
			test = { . $args[0] }
		}
	)
	links = @(
		@{ text = ''; URI = '' }
	)
}

