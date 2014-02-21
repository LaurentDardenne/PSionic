﻿# Update-ZipEntry command help
@{
	command = 'Update-ZipEntry'
	synopsis = $Datas.UpdateZipEntrySynopsis
	description = $Datas.UpdateZipEntryDescription
	parameters = @{
		Comment = $Datas.UpdateZipEntryParametersComment
		EntryPathRoot = $Datas.UpdateZipEntryParametersEntryPathRoot
		InputObject = $Datas.UpdateZipEntryParametersInputObject
		Name = $Datas.UpdateZipEntryParametersName
		Passthru = $Datas.UpdateZipEntryParametersPassthru
		ZipFile = $Datas.UpdateZipEntryParametersZipFile
	}
	inputs = @(
		@{
			type = ''
			description = $Datas.UpdateZipEntryInputsDescription1
		}
	)
	outputs = @(
		@{
			type = 'Ionic.Zip.ZipEntry'
			description = $Datas.UpdateZipEntryOutputsDescriptionIonicZipZipEntry
		}
	)
	notes = $Datas.UpdateZipEntryNotes
	examples = @(
		@{
			code = {
try {         
  $ZipFile=Get-Zipfile -Path C:\Temp\Test.zip
  $File=Get-Item C:\Temp\Test.ps1 
  Update-ZipEntry -InputObject $File -ZipFile $ZipFile
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
  Get-ChildItem *.txt|Update-ZipEntry -ZipFile $ZipFile
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
  Update-ZipEntry -InputObject $Text -Name MyText -ZipFile $ZipFile
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
  ConvertTo-CliXml $PSVersionTable | Update-ZipEntry -Name 'PSVersiontable.climxl' -ZipFile $ZipFile
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
  Update-ZipEntry -InputObject $Array -Name MyArray -ZipFile $ZipFile
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
