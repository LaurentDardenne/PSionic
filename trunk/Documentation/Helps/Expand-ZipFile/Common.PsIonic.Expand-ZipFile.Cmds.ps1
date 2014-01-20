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
		Path = $Datas.ExpandZipFileParametersPath
		Flatten = $Datas.ExpandZipFileParametersFlatten
		ProgressID = $Datas.ExpandZipFileParametersProgressID
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
			code = {
              Expand-ZipFile -Path C:\Archive.zip -Destination C:\Temp\
			}
			remarks = $Datas.CompressZipFileExamplesRemarks1
			test = { . $args[0] }
		}
		@{
			code = {
              Get-ChildItem D:\*.zip -recurse | 
               Expand-ZipFile C:\Temp\
			}
			remarks = $Datas.CompressZipFileExamplesRemarks2
			test = { . $args[0] }
		}
		@{
			code = {
              Expand-ZipFile -Path C:\Archive.zip -Destination C:\Temp\ -Query 'name = *.jpg'
			}
			remarks = $Datas.CompressZipFileExamplesRemarks3
			test = { . $args[0] }
		}
		@{
			code = {
              Expand-ZipFile -Path C:\Archive.zip -Destination C:\Temp\ -Query 'type = D'
			}
			remarks = $Datas.CompressZipFileExamplesRemarks4
			test = { . $args[0] }
		}
	)
	links = @(
		@{ text = ''; URI = '' }
	)
}

