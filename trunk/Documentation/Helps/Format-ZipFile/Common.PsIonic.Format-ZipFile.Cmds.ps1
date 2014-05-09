# Format-ZipFile command help
@{
	command = 'Format-ZipFile'
	synopsis = $Datas.FormatZipFileSynopsis
	description = $Datas.FormatZipFileDescription
	parameters = @{
		Properties = $Datas.FormatZipFileParametersProperties
		Zip = $Datas.FormatZipFileParametersZip
	}
	inputs = @(
		@{
			type = 'Ionic.Zip.ZipFile'
			description = $Datas.FormatZipFileInputsDescription1
		}
	)
	outputs = @(
		@{
			type = 'Microsoft.PowerShell.Commands.Internal.Format'
			description = $Datas.FormatZipFileOutputsDescription1
		}
	)
	notes = $Datas.FormatZipFileNotes
	examples = @(
		@{
			code = {
try {         
  ,($ZipFile=Get-Zipfile -Path Test.zip)|Format-ZipFile
} finally {
  $ZipFile.PSDispose()
}  
			}
			remarks = $Datas.FormatZipFileExamplesRemarks1
			test = { . $args[0] }
		}
	)
	links = @(
		@{ text = ''; URI = '' }
	)
}

