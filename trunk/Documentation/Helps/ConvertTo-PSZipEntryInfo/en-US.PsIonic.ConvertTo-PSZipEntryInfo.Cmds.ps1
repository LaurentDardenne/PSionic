# ConvertTo-PSZipEntryInfo command help
@{
	command = 'ConvertTo-PSZipEntryInfo'
	synopsis = $Datas.ConvertToPSZipEntryInfoSynopsis
	description = $Datas.ConvertToPSZipEntryInfoDescription
	parameters = @{
		Info = $Datas.ConvertToPSZipEntryInfoParametersInfo
	}
	inputs = @(
		@{
			type = 'System.String'
			description = $Datas.ConvertToPSZipEntryInfoInputsDescription1
		}
	)
	outputs = @(
		@{
			type = 'PSCustomObject'
			description = $Datas.ConvertToPSZipEntryInfoOutputsDescription1
		}
	)
	notes = $Datas.ConvertToPSZipEntryInfoNotes
	examples = @(
		@{
			code = {
$PSEntries=Get-ZipFile -Path .\Test.zip -List 
$PSEntries[0].Info=ConvertTo-PSZipEntryInfo $PSEntries[0].Info
$PSEntries[0].Info.Zipentry       
			}
			remarks = $Datas.ConvertToPSZipEntryInfoExamplesRemarks1
			test = { . $args[0] }
		}
		@{
			code = {
try {
  $Zip=Get-ZipFile -Path .\Test.zip         
  Add-Member -Input $Zip -Force NoteProperty Info (ConvertTo-PSZipEntryInfo $Zip.Info)
  $Zip.Info[0].ZipEntry
  $File=Get-Item C:\Temp\Test.ps1
  Add-ZipEntry -Object $File -ZipFile $Zip
  Add-Member -Input $Zip -Force NoteProperty Info (ConvertTo-PSZipEntryInfo $Zip.psbase.Info)
} finally {
  if ($Zip -ne $null )
  { $Zip.PSDispose() } 
}
			}
			remarks = $Datas.ConvertToPSZipEntryInfoExamplesRemarks2
			test = { . $args[0] }
		}
	)
	links = @(
 @{ text = ''; URI = 'https://psionic.codeplex.com/wikipage?title=ConvertTo-PSZipEntryInfo-EN'}
	)
}

