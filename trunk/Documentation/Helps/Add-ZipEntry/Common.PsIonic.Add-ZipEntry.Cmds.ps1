# Add-ZipEntry command help
@{
	command = 'Add-ZipEntry'
	synopsis = $Datas.AddZipEntrySynopsis
	description = $Datas.AddZipEntryDescription
	parameters = @{
		DirectoryPath = $Datas.AddZipEntryParametersDirectoryPath
		Name = $Datas.AddZipEntryParametersName
		Object = $Datas.AddZipEntryParametersObject
		Passthru = $Datas.AddZipEntryParametersPassthru
		ZipFile = $Datas.AddZipEntryParametersZipFile
	}
	inputs = @(
		@{
			type = ''
			description = $Datas.AddZipEntryInputsDescription1
		}
	)
	outputs = @(
		@{
			type = 'Ionic.Zip.ZipEntry'
			description = $Datas.AddZipEntryOutputsDescriptionIonicZipZipEntry
		}
	)
	notes = $Datas.AddZipEntryNotes
	examples = @(
		@{
			code = {
try {         
  $ZipFile=Get-Zipfile -Path C:\Temp\Test.zip
  $File=Get-Item C:\Temp\Test.ps1 
  Add-ZipEntry -Object $File -ZipFile $ZipFile
} finally {
  $ZipFile.Close()
}
			}
			remarks = $Datas.AddZipEntryExamplesRemarks1
			test = { . $args[0] }
		}
		@{
			code = {
try {         
  $ZipFile=Get-Zipfile -Path C:\Temp\Test.zip
  Get-ChildItem *.txt|Add-ZipEntry -ZipFile $ZipFile
} finally {
  $ZipFile.Close()
}
			}
			remarks = $Datas.AddZipEntryExamplesRemarks2
			test = { . $args[0] }
		}
		@{
			code = {
try {         
  $ZipFile=Get-Zipfile -Path C:\Temp\Test.zip
  [string]$Text=Get-Content C:\Temp\Test.ps1|Out-String
  Add-ZipEntry -Object $Text -Name MyText -ZipFile $ZipFile
} finally {
  $ZipFile.Close()
}
			}
			remarks = $Datas.AddZipEntryExamplesRemarks3
			test = { . $args[0] }
		}
		@{
			code = {
try {
  $ZipFile=Get-Zipfile -Path C:\Temp\Test.zip         
  ConvertTo-CliXml $PSVersionTable | Add-ZipEntry -Name 'PSVersiontable.climxl' -ZipFile $ZipFile
} finally {
  $ZipFile.Close()
}
			}
			remarks = $Datas.AddZipEntryExamplesRemarks4
			test = { . $args[0] }
		}
		@{
			code = {
try {         
  $ZipFile=Get-Zipfile -Path C:\Temp\Test.zip 
  [byte[]] $Array=@(1..20)
  Add-ZipEntry -Object $Array -Name MyArray -ZipFile $ZipFile
} finally {
  $ZipFile.Close()
}
			}
			remarks = $Datas.AddZipEntryExamplesRemarks5
			test = { . $args[0] }
		}
	)
	links = @(
		@{ text = ''; URI = '' }
	)
}

