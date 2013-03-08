# Compress-ZipFile command help
@{
	command = 'Compress-ZipFile'
	synopsis = $Datas.CompressZipFileSynopsis
	description = $Datas.CompressZipFileDescription
	sets = @{
		File = $Datas.CompressZipFileSetsFile
		SFX = $Datas.CompressZipFileSetsSFX
		UT = $Datas.CompressZipFileSetsUT
		UTnewest = $Datas.CompressZipFileSetsUTnewest
		UTnow = $Datas.CompressZipFileSetsUTnow
		UToldest = $Datas.CompressZipFileSetsUToldest
	}
	parameters = @{
		CodePageIdentifier = $Datas.CompressZipFileParametersCodePageIdentifier
		Comment = $Datas.CompressZipFileParametersComment
		Encoding = $Datas.CompressZipFileParametersEncoding
		Encryption = $Datas.CompressZipFileParametersEncryption
		File = $Datas.CompressZipFileParametersFile
		Name = $Datas.CompressZipFileParametersName
		NewUniformTimestamp = $Datas.CompressZipFileParametersNewUniformTimestamp
		NotTraverseReparsePoints = $Datas.CompressZipFileParametersNotTraverseReparsePoints
		NowUniformTimestamp = $Datas.CompressZipFileParametersNowUniformTimestamp
		OldUniformTimestamp = $Datas.CompressZipFileParametersOldUniformTimestamp
		Options = $Datas.CompressZipFileParametersOptions
		Passthru = $Datas.CompressZipFileParametersPassthru
		Password = $Datas.CompressZipFileParametersPassword
		Recurse = $Datas.CompressZipFileParametersRecurse
		SFX = $Datas.CompressZipFileParametersSFX
		SortEntries = $Datas.CompressZipFileParametersSortEntries
		Split = $Datas.CompressZipFileParametersSplit
		TempLocation = $Datas.CompressZipFileParametersTempLocation
		UniformTimestamp = $Datas.CompressZipFileParametersUniformTimestamp
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
			type = 'File'
			description = $Datas.CompressZipFileOutputsDescriptionFile
		}
		@{
			type = 'Ionic.Zip.ZipFile'
			description = $Datas.CompressZipFileOutputsDescriptionIonicZipZipFile
		}
		@{
			type = 'SFX'
			description = $Datas.CompressZipFileOutputsDescriptionSFX
		}
		@{
			type = 'System.IO.FileInfo'
			description = $Datas.CompressZipFileOutputsDescriptionSystemIOFileInfo
		}
	)
	notes = $Datas.CompressZipFileNotes
	examples = @(
		@{
			code = {
              dir*.txt|Compress-File c:\temp\test.zip
			}
			remarks = $Datas.CompressZipFileExamplesRemarks1
			test = { . $args[0] }
		}
		@{
			code = {
              dir*.txt|Compress-File c:\temp\test.zip
			}
			remarks = $Datas.CompressZipFileExamplesRemarks2
			test = { . $args[0] }
		}
	)
	links = @(
		@{ text = ''; URI = '' }
	)
}

