# Get-ZipFile command help
@{
	command = 'Get-ZipFile'
	synopsis = $Datas.GetZipFileSynopsis
	description = $Datas.GetZipFileDescription
	sets = @{
		ManualOption = $Datas.GetZipFileSetsManualOption
		ReadOption = $Datas.GetZipFileSetsReadOption
	}
	parameters = @{
		Encoding = $Datas.GetZipFileParametersEncoding
		Encryption = $Datas.GetZipFileParametersEncryption
		ProgressID = $Datas.GetZipFileParametersProgressID
		Path = $Datas.GetZipFileParametersPath
		Options = $Datas.GetZipFileParametersOptions
		Password = $Datas.GetZipFileParametersPassword
		ReadOptions = $Datas.GetZipFileParametersReadOptions
		SortEntries = $Datas.GetZipFileParametersSortEntries
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
			type = 'Ionic.Zip.ZipFile'
			description = $Datas.GetZipFileOutputsDescriptionIonicZipZipFile
		}
	)
	notes = $Datas.GetZipFileNotes
	examples = @(
		@{

			code = {
try {
 $ZipFile=Get-Zipfile -Path Test.zip
 $ZipFile
} finally {
 $ZipFile.PSDispose()
}
			}
			remarks = $Datas.GetZipFileExamplesRemarks1
			test = { . $args[0] }
		}
		@{

			code = {
try {         
 $File=Dir C:\Temp\Test.ps1 
 $ZipFile=Get-Zipfile -Path Test.zip
 Add-ZipEntry -Object $File -ZipFile $ZipFile
 $ZipFile.Save()
} finally {
 $ZipFile.PSDispose()
}
			}
			remarks = $Datas.GetZipFileExamplesRemarks2
			test = { . $args[0] }
		}
		@{

			code = {
try {         
 $Zip=Get-Zipfile -Path Test.zip
  $ofs="`r`n"
  [string]$Text=Get-Content C:\Temp\Test.ps1
 Add-ZipEntry -Object $Text -EntryName MyText -ZipFile $ZipFile
 $ZipFile.Save()
} finally {
 $ZipFile.PSDispose()
}
         
			}
			remarks = $Datas.GetZipFileExamplesRemarks3
			test = { . $args[0] }
		}
		@{

			code = {
try {
 $Zip=Get-Zipfile -Path Test.zip
 Dir *.txt|Add-ZipEntry -ZipFile $Zip
} finally {
 $ZipFile.Close()
}
         
			}
			remarks = $Datas.GetZipFileExamplesRemarks4
			test = { . $args[0] }
		}
	)
	links = @(
		@{ text = ''; URI = '' }
	)
}

