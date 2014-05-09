# Compress-ZipFile command help
@{
	command = 'Compress-ZipFile'
	synopsis = $Datas.CompressZipFileSynopsis
	description = $Datas.CompressZipFileDescription
	sets = @{
		LiteralPath = $Datas.CompressZipFileSetsLiteralPath
		Path = $Datas.CompressZipFileSetsPath
	}
	parameters = @{
		CodePageIdentifier = $Datas.CompressZipFileParametersCodePageIdentifier
		Comment = $Datas.CompressZipFileParametersComment
		Encoding = $Datas.CompressZipFileParametersEncoding
		Encryption = $Datas.CompressZipFileParametersEncryption
		EntryPathRoot = $Datas.CompressZipFileParametersEntryPathRoot
		LiteralPath = $Datas.CompressZipFileParametersLiteralPath
		NotTraverseReparsePoints = $Datas.CompressZipFileParametersNotTraverseReparsePoints
		OutputName = $Datas.CompressZipFileParametersOutputName
		Passthru = $Datas.CompressZipFileParametersPassthru
		Password = $Datas.CompressZipFileParametersPassword
		Path = $Datas.CompressZipFileParametersPath
		Recurse = $Datas.CompressZipFileParametersRecurse
		SetLastModifiedProperty = $Datas.CompressZipFileParametersSetLastModifiedProperty
		SortEntries = $Datas.CompressZipFileParametersSortEntries
		Split = $Datas.CompressZipFileParametersSplit
		TempLocation = $Datas.CompressZipFileParametersTempLocation
		UnixTimeFormat = $Datas.CompressZipFileParametersUnixTimeFormat
		WindowsTimeFormat = $Datas.CompressZipFileParametersWindowsTimeFormat
		ZipErrorAction = $Datas.CompressZipFileParametersZipErrorAction
	}
	inputs = @(
		@{
			type = 'System.String,System.IO.FileInfo'
			description = $Datas.CompressZipFileInputsDescription1
		}
	)
	outputs = @(
		@{
			type = 'Ionic.Zip.ZipFile'
			description = $Datas.CompressZipFileOutputsDescriptionIonicZipZipFile
		}
	)
	notes = $Datas.CompressZipFileNotes
	examples = @(
		@{
			code = {
Get-ChildItem *.txt|Compress-ZipFile C:\Temp\Test.zip
			}
			remarks = $Datas.CompressZipFileExamplesRemarks1
			test = { . $args[0] }
		}
		@{
			code = {
$ZipFileName="C:\Temp\Test.zip"
$ListeFileName='C:\Temp\ListeFichiers.txt'
Dir C:\Temp\*.ps1| Select -expand Fullname| Set-Content -Path $ListeFileName
 
Get-Content $ListeFileName| Compress-ZipFile $ZipFileName
			}
			remarks = $Datas.CompressZipFileExamplesRemarks2
			test = { . $args[0] }
		}
		@{
			code = {
$ZipFileName="C:\Temp\Test.zip"
$FileNames=@(
 'C:\Temp\*.ps1',
 'C:\Temp\Test2.zip',
 'C:\Temp\*.txt'
)
$FileNames| Compress-ZipFile $ZipFileName -Verbose
			}
			remarks = $Datas.CompressZipFileExamplesRemarks3
			test = { . $args[0] }
		}
		@{
			code = {
$ZipFileName="C:\Temp\Test.zip"
$FileNames=@(
 'C:\Temp\*.ps1',
 'C:\Temp\*.ps1',
 'C:\Temp\*.txt'
)
$FileNames| Compress-ZipFile $ZipFileName -ZipErrorAction Skip
			}
			remarks = $Datas.CompressZipFileExamplesRemarks4
			test = { . $args[0] }
		}
		@{
			code = {

$sbTimestamp={
  $fixedTimestamp = [Datetime]::Now  
  #or $fixedTimestamp = "10/01/2014 16:37" -as [Datetime]                   
  foreach($entry in $ZipFile)
  { $entry.LastModified = $fixedTimestamp }
}
         
$SbUTnewest={
  $fixedTimestamp = New-Object System.DateTime(1601,1,1,0,0,0)
  foreach($entry in $ZipFile)
  {
    if ($entry.LastModified -gt $fixedTimestamp)
    { $fixedTimestamp = $entry.LastModified }
  }
  foreach($entry in $zipFile)
  { $entry.LastModified = $fixedTimestamp }
}

$sbUToldest={
  $fixedTimestamp = "10/01/2014 16:37" -as [Datetime]             
  foreach($entry in $ZipFile)
  {
    if ($entry.LastModified -lt $fixedTimestamp)
    { $fixedTimestamp = $entry.LastModified }
  }
  foreach($entry in $ZipFile)
  { $entry.LastModified = $fixedTimestamp }
}

Get-ChildItem C:\Temp -Exclude *.zip|
 Where {!$_.psiscontainer}| 
 Compress-ZipFile -OutputName "C:\Temp\LastModifiedProperty.zip" -SetLastModifiedProperty $sbUToldest
			}
			remarks = $Datas.CompressZipFileExamplesRemarks5
			test = { . $args[0] }
		}

		@{
			code = {
'C:\Temp\*'|
 Compress-ZipFile -OutputName C:\Temp\Archive.zip -Recurse

			}
			remarks = $Datas.CompressZipFileExamplesRemarks6
			test = { . $args[0] }
		}

		@{
			code = {
'C:\Temp'|
 Compress-ZipFile -OutputName C:\Temp\Archive.zip

			}
			remarks = $Datas.CompressZipFileExamplesRemarks7
			test = { . $args[0] }
		}

		@{
			code = {
Get-Item 'C:\Temp'|
 Compress-ZipFile -OutputName C:\Temp\Archive.zip

			}
			remarks = $Datas.CompressZipFileExamplesRemarks8
			test = { . $args[0] }
		}


		@{
			code = {
Get-ChildItem C:\Temp\* -Force|
 Where {!$_.psiscontainer}| 
 Compress-ZipFile -OutputName C:\Temp\Archive.zip -Recurse -ZipErrorAction Skip
			}
			remarks = $Datas.CompressZipFileExamplesRemarks9
			test = { . $args[0] }
		}  
  
		@{
			code = {
Get-ChildItem C:\Temp -inc *.txt -Rec |
 Compress-ZipFile -OutputName C:\Temp\Archive.zip -EntryPathRoot C:\Temp -Recurse -ZipErrorAction Skip
			}
			remarks = $Datas.CompressZipFileExamplesRemarks10
			test = { . $args[0] }
		}
		@{
			code = {
$T=@("C:\Temp\Logs\*"; (Dir C:\Temp\*.PS1),(Get-Item 'C:\Temp\Setup'))
$T|Compress-ZipFile -OutputName C:\Temp\Archive.zip -ZipErrorAction Skip -Split 65Kb 
         }
			remarks = $Datas.CompressZipFileExamplesRemarks11
			test = { . $args[0] }
		}
	)
	links = @(
 @{ text = ''; URI = 'https://psionic.codeplex.com/wikipage?title=Compress-ZipFile-FR'}
	)
}

