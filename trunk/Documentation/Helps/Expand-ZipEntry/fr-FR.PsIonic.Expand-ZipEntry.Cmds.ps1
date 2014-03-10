# Expand-ZipEntry command help
@{
	command = 'Expand-ZipEntry'
	synopsis = $Datas.ExpandZipEntrySynopsis
	description = $Datas.ExpandZipEntryDescription
	sets = @{
		ByteArray = $Datas.ExpandZipEntrySetsByteArray
		String = $Datas.ExpandZipEntrySetsString
		XML = $Datas.ExpandZipEntrySetsXML
	}
	parameters = @{
		AsHashTable = $Datas.ExpandZipEntryParametersAsHashTable
		Byte = $Datas.ExpandZipEntryParametersByte
		Encoding = $Datas.ExpandZipEntryParametersEncoding
		ExtractAction = $Datas.ExpandZipEntryParametersExtractAction
		Name = $Datas.ExpandZipEntryParametersName
		Password = $Datas.ExpandZipEntryParametersPassword
		Strict = $Datas.ExpandZipEntryParametersStrict
		XML = $Datas.ExpandZipEntryParametersXML
		ZipFile = $Datas.ExpandZipEntryParametersZipFile
	}
	inputs = @(
		@{
			type = ''
			description = $Datas.ExpandZipEntryInputsDescription1
		}
	)
	outputs = @(
		@{
			type = 'System.Xml.XmlDocument'
			description = $Datas.ExpandZipEntryOutputsDescriptionSystemXmlXmlDocument
		}
		@{
			type = 'System.String'
			description = $Datas.ExpandZipEntryOutputsDescriptionSystemString
		}
		@{
			type = 'System.Byte[]'
			description = $Datas.ExpandZipEntryOutputsDescriptionSystemByte
		}
	)
	notes = $Datas.ExpandZipEntryNotes
	examples = @(
		@{ 
 			code = {
try {         
  $ZipFile=Get-Zipfile -Path C:\Temp\Test.zip
  [string]$Text=Get-Content C:\Temp\Test.ps1|Out-String
  Add-ZipEntry -Object $Text -Name MyText -ZipFile $ZipFile
} finally {
  $ZipFile.Close()
}
Remove-Variable Text
try {
  $ZipFile=Get-Zipfile -Path C:\Temp\Test.zip 
  [string]$Text =Expand-ZipEntry -Zip $ZipFile MyText   
} finally {
  if ($ZipFile -ne $null )
  { $ZipFile.PSDispose() }
}
			}
			remarks = $Datas.ExpandZipEntryExamplesRemarks1
			test = { . $args[0] }
		}
		@{
			code = {
try {
  $ZipFile=Get-Zipfile -Path C:\Temp\Test.zip         
  ConvertTo-CliXml $PSVersionTable | Add-ZipEntry -Name 'PSVersiontable_clixml' -ZipFile $ZipFile
} finally {
  $ZipFile.Close()
}

try {
  $ZipFile=Get-Zipfile -Path C:\Temp\Test.zip 
  $MaTableDeVersion=Expand-ZipEntry -Zip $ZipFile 'PSVersiontable_clixml'|ConvertFrom-CliXml   
} finally {
  if ($ZipFile -ne $null )
  { $ZipFile.PSDispose() }
}
$MaTableDeVersion
			}
			remarks = $Datas.ExpandZipEntryExamplesRemarks2
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
Remove-Variable Array
try {
  $ZipFile=Get-Zipfile -Path C:\Temp\Test.zip 
  $Array=Expand-ZipEntry -Zip $ZipFile MyArray -Byte   
} finally {
  if ($ZipFile -ne $null )
  { $ZipFile.PSDispose() }
}
			}
			remarks = $Datas.ExpandZipEntryExamplesRemarks3
			test = { . $args[0] }
		}
	)
	links = @(
 @{ text = ''; URI = 'https://psionic.codeplex.com/wikipage?title=Expand-ZipEntry-FR'}
	)
}

