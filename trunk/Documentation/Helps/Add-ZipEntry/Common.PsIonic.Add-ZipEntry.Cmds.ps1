# Add-ZipEntry command help
@{
	command = 'Add-ZipEntry'
	synopsis = $Datas.AddZipEntrySynopsis
	description = $Datas.AddZipEntryDescription
	parameters = @{
		DirectoryPath = $Datas.AddZipEntryParametersDirectoryPath
		EntryName = $Datas.AddZipEntryParametersEntryName
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
$File=Get-ChildItem C:\Temp\Test.ps1 

Add-ZipEntry -Object $File -ZipFile $ZipFile

$ZipFile.Save()
$ZipFile.PSDispose()
			}
			remarks = $Datas.GetZipFileExamplesRemarks1
			test = { . $args[0] }
		}
		@{

			code = {
$ZipFile=Get-Zipfile -Name Test.zip

Get-ChildItem *.txt|Add-ZipEntry -ZipFile $Zip

$ZipFile.Save()
$ZipFile.PSDispose()
			}
			remarks = $Datas.GetZipFileExamplesRemarks2
			test = { . $args[0] }
		}
		@{

			code = {
$Zip=Get-Zipfile -Name Test.zip
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

#Todo Byte[]
         
			}
			remarks = $Datas.GetZipFileExamplesRemarks4
			test = { . $args[0] }
		}
	)
	links = @(
		@{ text = ''; URI = '' }
	)
}

