# Get-ZipFile command help
@{
	command = 'Get-ZipFile'
	synopsis = $Datas.GetZipFileSynopsis
	description = $Datas.GetZipFileDescription
	sets = @{
		File = $Datas.GetZipFileSetsFile
		ManualOption = $Datas.GetZipFileSetsManualOption
		ReadOption = $Datas.GetZipFileSetsReadOption
	}
	parameters = @{
		Encoding = $Datas.GetZipFileParametersEncoding
		Encryption = $Datas.GetZipFileParametersEncryption
		ProgressID = $Datas.GetZipFileParametersProgressID
		Name = $Datas.GetZipFileParametersName
		NotTraverseReparsePoints = $Datas.GetZipFileParametersNotTraverseReparsePoints
		Options = $Datas.GetZipFileParametersOptions
		Password = $Datas.GetZipFileParametersPassword
		ReadOptions = $Datas.GetZipFileParametersReadOptions
		SortEntries = $Datas.GetZipFileParametersSortEntries
		Split = $Datas.GetZipFileParametersSplit
		TempLocation = $Datas.GetZipFileParametersTempLocation
		UnixTimeFormat = $Datas.GetZipFileParametersUnixTimeFormat
		WindowsTimeFormat = $Datas.GetZipFileParametersWindowsTimeFormat
		ZipErrorAction = $Datas.GetZipFileParametersZipErrorAction
	}
	inputs = @(
		@{
			type = ''
			description = $Datas.GetZipFileInputsDescription1
		}
	)
	outputs = @(
		@{
			type = 'File'
			description = $Datas.GetZipFileOutputsDescriptionFile
		}
		@{
			type = 'Ionic.Zip.ZipFile'
			description = $Datas.GetZipFileOutputsDescriptionIonicZipZipFile
		}
	)
	notes = $Datas.GetZipFileNotes
	examples = @(
		@{
			#title = ''
			#introduction = ''
			code = {
			}
			remarks = $Datas.GetZipFileExamplesRemarks1
			test = { . $args[0] }
		}
	)
	links = @(
		@{ text = ''; URI = '' }
	)
}

