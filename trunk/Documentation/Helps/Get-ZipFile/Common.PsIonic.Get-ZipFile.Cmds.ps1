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
		List = $Datas.GetZipFileParametersList
        ProgressID = $Datas.GetZipFileParametersProgressID
		Path = $Datas.GetZipFileParametersPath
		Options = $Datas.GetZipFileParametersOptions
		Password = $Datas.GetZipFileParametersPassword
		ReadOptions = $Datas.GetZipFileParametersReadOptions
		SortEntries = $Datas.GetZipFileParametersSortEntries
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
  if ($ZipFile -ne $null )
  { $ZipFile.PSDispose() }
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
  if ($ZipFile -ne $null )
  { $ZipFile.PSDispose() }
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
  if ($ZipFile -ne $null )
  { $ZipFile.PSDispose() }
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
		@{

			code = {
$PSZipEntries=Get-Zipfile -Path Test.zip -List
try {
 $Zip=Get-Zipfile -Path Test.zip
 $Entry=$Zip.Entries|Where {$_.FileName -eq 'Test.ps1'}
 $Entry.Extract('C:\Temp')
} finally {
 $ZipFile.Close()
}
 
			}
			remarks = $Datas.GetZipFileExamplesRemarks5
			test = { . $args[0] }
		}
	)
	links = @(
		@{ text = ''; URI = '' }
	)
}

