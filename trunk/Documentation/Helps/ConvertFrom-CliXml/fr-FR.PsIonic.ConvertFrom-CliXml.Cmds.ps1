# ConvertFrom-CliXml command help
@{
	command = 'ConvertFrom-Clixml'
	synopsis = $Datas.ConvertFromCliXmlSynopsis
	description = $Datas.ConvertFromCliXmlDescription
	parameters = @{
		InputObject = $Datas.ConvertFromCliXmlParametersInputObject
	}
	inputs = @(
		@{
			type = ''
			description = $Datas.ConvertFromCliXmlInputsDescription1
		}
	)
	outputs = @(
		@{
			type = ''
			description = $Datas.ConvertFromCliXmlOutputsDescription1
		}
	)
	notes = $Datas.ConvertFromCliXmlNotes
	examples = @(
		@{
			code = {
try {
  $ZipFile=Get-Zipfile -Path C:\Temp\Test.zip         
  ConvertTo-Clixml $PSVersionTable | Add-ZipEntry -Name 'PSVersiontable.clixml' -ZipFile $ZipFile
} finally {
  $ZipFile.Close()
}

try {
  $ZipFile=Get-Zipfile -Path C:\Temp\Test.zip 
  $MaTableDeVersion=Expand-ZipEntry -Zip $ZipFile 'PSVersiontable.clixml'|ConvertFrom-Clixml   
} finally {
  if ($ZipFile -ne $null )
  { $ZipFile.PSDispose() }
}
$MaTableDeVersion         
			}
			remarks = $Datas.ConvertFromCliXmlExamplesRemarks1
			test = { . $args[0] }
		}
	)
	links = @(
      @{ text = ''; URI = 'https://psionic.codeplex.com/wikipage?title=ConvertFrom-CliXml-FR'}
      @{ text = 'Expand-ZipEntry'; URI = '' }
	)
}

