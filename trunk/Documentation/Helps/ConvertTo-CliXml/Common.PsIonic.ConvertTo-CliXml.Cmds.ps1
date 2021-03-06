﻿
# ConvertTo-CliXml command help
@{
	command = 'ConvertTo-Clixml'
	synopsis = $Datas.ConvertToCliXmlSynopsis
	description = $Datas.ConvertToCliXmlDescription
	parameters = @{
		InputObject = $Datas.ConvertToCliXmlParametersInputObject
	}
	inputs = @(
		@{
			type = ''
			description = $Datas.ConvertToCliXmlInputsDescription1
		}
	)
	outputs = @(
		@{
			type = ''
			description = $Datas.ConvertToCliXmlOutputsDescription1
		}
	)
	notes = $Datas.ConvertToCliXmlNotes
	examples = @(
		@{
			code = {
try {
  $ZipFile=Get-Zipfile -Path C:\Temp\Test.zip         
  ConvertTo-Clixml $PSVersionTable | Add-ZipEntry -Name 'PSVersiontable_clixml' -ZipFile $ZipFile
} finally {
  $ZipFile.Close()
}
			}
			remarks = $Datas.ConvertToCliXmlExamplesRemarks1
			test = { . $args[0] }
		}
	)
	links = @(
       @{ text = ''; URI = '' }
       @{ text = 'Add-ZipEntry'; URI = ''} 
       @{ text = 'Update-ZipEntry'; URI = ''}
	)
}

