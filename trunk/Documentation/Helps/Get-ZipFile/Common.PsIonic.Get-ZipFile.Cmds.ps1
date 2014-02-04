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
		NotTraverseReparsePoints = $Datas.GetZipFileParametersNotTraverseReparsePoints
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

			code = {
$File=Dir C:\Temp\Test.ps1 
$ZipFile=Get-Zipfile -Path Test.zip
Add-ZipEntry -Object $File -ZipFile $ZipFile
$ZipFile.Save()
$ZipFile.PSDispose()
			}
			remarks = $Datas.GetZipFileExamplesRemarks1
			test = { . $args[0] }
		}
		@{

			code = {
$File=Dir C:\Temp\Test.ps1 
$ZipFile=Get-Zipfile -Path Test.zip
$ZipFile.Save()
$ZipFile.PSDispose()
			}
			remarks = $Datas.GetZipFileExamplesRemarks2
			test = { . $args[0] }
		}
		@{

			code = {
$Zip=Get-Zipfile -Path Test.zip
 $ofs="`r`n"
 [string]$Text=Get-Content C:\Temp\Test.ps1
Add-ZipEntry -Object $Text -EntryName MyText -ZipFile $ZipFile
$ZipFile.Save()
$ZipFile.PSDispose()
         
			}
			remarks = $Datas.GetZipFileExamplesRemarks3
			test = { . $args[0] }
		}
		@{

			code = {
$Zip=Get-Zipfile -Path Test.zip
Dir *.txt|Add-ZipEntry -ZipFile $Zip
         
			}
			remarks = $Datas.GetZipFileExamplesRemarks4
			test = { . $args[0] }
		}
	)
	links = @(
		@{ text = ''; URI = '' }
	)
}

