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
			code = {
Get-ChildItem *.txt|Compress-File C:\Temp\Test.zip
			}
			remarks = $Datas.CompressZipFileExamplesRemarks1
			test = { . $args[0] }
		}
		@{
			code = {
$ZipFileName="C:\Temp\Test.zip"
$FileNames='C:\Temp\ListeFichiers.txt'
Dir C:\Temp\*.ps1| Foreach-object {$_.Fullname}| Set-Content -Path $FilesNameTest
 
Get-Content $FilesName| Compress-ZipFile $ZipFileName
			}
			remarks = $Datas.CompressZipFileExamplesRemarks2
			test = { . $args[0] }
		}
		@{
			code = {
$ZipFileName="C:\Temp\Test.zip"
$FileNames=@(
 'C:\Temp\*.ps1',
 'C:\Temp\Test2.zip',
 'C:\Temp\*.txt'
)
$FileNames| Compress-ZipFile $ZipFileName
			}
			remarks = $Datas.CompressZipFileExamplesRemarks3
			test = { . $args[0] }
		}
	)
	links = @(
		@{ text = 'Test online'; URI = 'http://psionic.codeplex.com/wikipage?title=Compress-ZipFile_FR' }
	)
}

