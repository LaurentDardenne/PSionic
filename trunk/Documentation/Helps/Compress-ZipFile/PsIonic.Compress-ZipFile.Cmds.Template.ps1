# Compress-ZipFile command help
@{
	command = 'Compress-ZipFile'
	synopsis = $Datas.CompressZipFileSynopsis
	description = $Datas.CompressZipFileDescription
	sets = @{
		LiteralPath = $Datas.CompressZipFileSetsLiteralPath
		Path = $Datas.CompressZipFileSetsPath
	}
	parameters = @{
		CodePageIdentifier = $Datas.CompressZipFileParametersCodePageIdentifier
		Comment = $Datas.CompressZipFileParametersComment
		Encoding = $Datas.CompressZipFileParametersEncoding
		Encryption = $Datas.CompressZipFileParametersEncryption
		EntryPathRoot = CompressZipFileParametersEntryPathRoot
		LiteralPath = $Datas.CompressZipFileParametersLiteralPath
		NotTraverseReparsePoints = $Datas.CompressZipFileParametersNotTraverseReparsePoints
		OutputName = $Datas.CompressZipFileParametersOutputName
		Passthru = $Datas.CompressZipFileParametersPassthru
		Password = $Datas.CompressZipFileParametersPassword
		Path = $Datas.CompressZipFileParametersPath
		Recurse = $Datas.CompressZipFileParametersRecurse
		SetLastModifiedProperty = $Datas.CompressZipFileParametersSetLastModifiedProperty
		SortEntries = $Datas.CompressZipFileParametersSortEntries
		Split = $Datas.CompressZipFileParametersSplit
		TempLocation = $Datas.CompressZipFileParametersTempLocation
		UnixTimeFormat = $Datas.CompressZipFileParametersUnixTimeFormat
		WindowsTimeFormat = $Datas.CompressZipFileParametersWindowsTimeFormat
		ZipErrorAction = $Datas.CompressZipFileParametersZipErrorAction
	}
	inputs = @(
		@{
			type = ''
			description = $Datas.CompressZipFileInputsDescription1
		}
	)
	outputs = @(
		@{
			type = 'Ionic.Zip.ZipFile'
			description = $Datas.CompressZipFileOutputsDescriptionIonicZipZipFile
		}
	)
	notes = $Datas.CompressZipFileNotes
	examples = @(
		@{
			#title = ''
			#introduction = ''
			code = {
			}
			remarks = $Datas.CompressZipFileExamplesRemarks1
			test = { . $args[0] }
		}
	)
	links = @(
		@{ text = ''; URI = '' }
	)
}

