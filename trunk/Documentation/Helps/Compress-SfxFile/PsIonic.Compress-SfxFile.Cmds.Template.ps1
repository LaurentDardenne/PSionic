# Compress-SfxFile command help
@{
	command = 'Compress-SfxFile'
	synopsis = $Datas.CompressSfxFileSynopsis
	description = $Datas.CompressSfxFileDescription
	sets = @{
		LiteralPath = $Datas.CompressSfxFileSetsLiteralPath
		Path = $Datas.CompressSfxFileSetsPath
	}
	parameters = @{
		CodePageIdentifier = $Datas.CompressSfxFileParametersCodePageIdentifier
		Comment = $Datas.CompressSfxFileParametersComment
		Encoding = $Datas.CompressSfxFileParametersEncoding
		Encryption = $Datas.CompressSfxFileParametersEncryption
		LiteralPath = $Datas.CompressSfxFileParametersLiteralPath
		NotTraverseReparsePoints = $Datas.CompressSfxFileParametersNotTraverseReparsePoints
		Options = $Datas.CompressSfxFileParametersOptions
		OutputName = $Datas.CompressSfxFileParametersOutputName
        Passthru = $Datas.CompressSfxFileParametersPassthru
		Password = $Datas.CompressSfxFileParametersPassword
		Path = $Datas.CompressSfxFileParametersPath
		Recurse = $Datas.CompressSfxFileParametersRecurse
		SetLastModifiedProperty = $Datas.CompressSfxFileParametersSetLastModifiedProperty
		SortEntries = $Datas.CompressSfxFileParametersSortEntries
		TempLocation = $Datas.CompressSfxFileParametersTempLocation
		UnixTimeFormat = $Datas.CompressSfxFileParametersUnixTimeFormat
		WindowsTimeFormat = $Datas.CompressSfxFileParametersWindowsTimeFormat
		ZipErrorAction = $Datas.CompressSfxFileParametersZipErrorAction
	}
	inputs = @(
		@{
			type = ''
			description = $Datas.CompressSfxFileInputsDescription1
		}
	)
	outputs = @(
		@{
			type = 'System.IO.FileInfo'
			description = $Datas.CompressSfxFileOutputsDescriptionSystemIOFileInfo
		}
	)
	notes = $Datas.CompressSfxFileNotes
	examples = @(
		@{
			#title = ''
			#introduction = ''
			code = {
			}
			remarks = $Datas.CompressSfxFileExamplesRemarks1
			test = { . $args[0] }
		}
	)
	links = @(
		@{ text = ''; URI = '' }
	)
}

