# Remove-ZipEntry command help
@{
	command = 'Remove-ZipEntry'
	synopsis = $Datas.RemoveZipEntrySynopsis
	description = $Datas.RemoveZipEntryDescription
	sets = @{
		Name = $Datas.RemoveZipEntrySetsName
		Query = $Datas.RemoveZipEntrySetsQuery
	}
	parameters = @{
		From = $Datas.RemoveZipEntryParametersFrom
		InputObject = $Datas.RemoveZipEntryParametersInputObject
		Name = $Datas.RemoveZipEntryParametersName
		Query = $Datas.RemoveZipEntryParametersQuery
		ZipFile = $Datas.RemoveZipEntryParametersZipFile
	}
	inputs = @(
		@{
			type = 'System.String, System.IO.DirectoryInfo, System.IO.FileInfo, System.Byte[], System.Collections.IDictionary, Ionic.Zip.ZipEntry'
			description = $Datas.RemoveZipEntryInputsDescription1
		}
	)
	outputs = @(
		@{
			type = 'Aucun'
			description = $Datas.RemoveZipEntryOutputsDescription1
		}
	)
	notes = $Datas.RemoveZipEntryNotes
	examples = @(
		@{
			code = {
try {         
  $ZipFile=Get-Zipfile -Path C:\Temp\Test.zip
  Get-Item C:\Temp\Test.ps1|Remove-ZipEntry -ZipFile $ZipFile
} finally {
  $ZipFile.Close()
}
         
			}
			remarks = $Datas.RemoveZipEntryExamplesRemarks1
			test = { . $args[0] }
		}
		@{
			code = {
try {         
  $ZipFile=Get-Zipfile -Path C:\Temp\Test.zip
  'Test.ps1'|Remove-ZipEntry -ZipFile $ZipFile
} finally {
  $ZipFile.Close()
}         
			}
			remarks = $Datas.RemoveZipEntryExamplesRemarks2
			test = { . $args[0] }
		}
		@{
			code = {
try {         
  $ZipFile=Get-Zipfile -Path C:\Temp\Test.zip
  $Tab=@('Test.ps1','Setu1.ps1')
  ,$Tab|Remove-ZipEntry -ZipFile $ZipFile
} finally {
  $ZipFile.Close()
}         
			}
			remarks = $Datas.RemoveZipEntryExamplesRemarks3
			test = { . $args[0] }
		}
		@{
			code = {
try {         
  $ZipFile=Get-Zipfile -Path C:\Temp\Test.zip
  $Tab=@('Test1.ps1';Get-ChildItem *.XML;Get-Content C:\Temp\ListeFileName.txt)
  ,$Tab|Remove-ZipEntry -ZipFile $ZipFile
} finally {
  $ZipFile.Close()
}
			}
			remarks = $Datas.RemoveZipEntryExamplesRemarks4
			test = { . $args[0] }
		}
		@{
			code = {
try
{          
  $ZipFile=Get-ZipFile -path C:\Temp\archive.zip -ZipErrorAction Skip -Verbose 
  Remove-ZipEntry -ZipFile $ZipFile -Query 'name = *.txt'
} finally {
  $ZipFile.Close()
} 
			}
			remarks = $Datas.RemoveZipEntryExamplesRemarks5
			test = { . $args[0] }
		}
		@{
			code = {
try
{          
  $ZipFile=Get-ZipFile -path C:\Temp\archive.zip -ZipErrorAction Skip -Verbose 
  Remove-ZipEntry -ZipFile $ZipFile -Query 'name = *.txt' -From 'Doc/' 
} finally {
  $ZipFile.Close()
}      
			}
			remarks = $Datas.RemoveZipEntryExamplesRemarks6
			test = { . $args[0] }
		}

	)
	links = @(
 @{ text = ''; URI = 'https://psionic.codeplex.com/wikipage?title=Remove-ZipEntry-FR'}
	)
}
