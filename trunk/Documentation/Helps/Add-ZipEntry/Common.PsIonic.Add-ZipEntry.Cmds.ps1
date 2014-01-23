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
$ZipFile=Get-Zipfile -Name C:\Temp\Test.zip
$File=Get-Item C:\Temp\Test.ps1 
Add-ZipEntry -Object $File -ZipFile $ZipFile
$ZipFile.Close()
			}
			remarks = $Datas.GetZipFileExamplesRemarks1
			test = { . $args[0] }
		}
		@{
			code = {
$ZipFile=Get-Zipfile -Name C:\Temp\Test.zip
Get-ChildItem *.txt|Add-ZipEntry -ZipFile $ZipFile
$ZipFile.Close()
			}
			remarks = $Datas.GetZipFileExamplesRemarks2
			test = { . $args[0] }
		}
		@{
			code = {
$ZipFile=Get-Zipfile -Name C:\Temp\Test.zip
[string]$Text=Get-Content C:\Temp\Test.ps1|Out-String
Add-ZipEntry -Object $Text -Name MyText -ZipFile $ZipFile
$ZipFile.Close()
			}
			remarks = $Datas.GetZipFileExamplesRemarks3
			test = { . $args[0] }
		}
		@{
			code = {
$ZipFile=Get-Zipfile -Name C:\Temp\Test.zip         
ConvertTo-CliXml $PSVersionTable | Add-ZipEntry -Name PSVersiontable -ZipFile $ZipFile
$ZipFile.Close()
         
			}
			remarks = $Datas.GetZipFileExamplesRemarks4
			test = { . $args[0] }
		}
		@{
			code = {
#Todo Byte[]
         
			}
			remarks = $Datas.GetZipFileExamplesRemarks5
			test = { . $args[0] }
		}
	)
	links = @(
		@{ text = ''; URI = '' }
	)
}

