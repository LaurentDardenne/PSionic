# Compress-SfxFile command help
@{
	command = 'Compress-SfxFile'
	synopsis = $Datas.CompressSfxFileSynopsis
	description = $Datas.CompressSfxFileDescription
	sets = @{
		LiteralPath = $Datas.CompressSfxFileSetsLiteralPath
		Path = $Datas.CompressSfxFileSetsPath
	}
	parameters = @{
		CodePageIdentifier = $Datas.CompressSfxFileParametersCodePageIdentifier
		Comment = $Datas.CompressSfxFileParametersComment
		Encoding = $Datas.CompressSfxFileParametersEncoding
		Encryption = $Datas.CompressSfxFileParametersEncryption
		LiteralPath = $Datas.CompressSfxFileParametersLiteralPath
		NotTraverseReparsePoints = $Datas.CompressSfxFileParametersNotTraverseReparsePoints
		Options = $Datas.CompressSfxFileParametersOptions
		OutputName = $Datas.CompressSfxFileParametersOutputName
        Passthru = $Datas.CompressSfxFileParametersPassthru
		Password = $Datas.CompressSfxFileParametersPassword
		Path = $Datas.CompressSfxFileParametersPath
		Recurse = $Datas.CompressSfxFileParametersRecurse
		SetLastModifiedProperty = $Datas.CompressSfxFileParametersSetLastModifiedProperty
		SortEntries = $Datas.CompressSfxFileParametersSortEntries
		TempLocation = $Datas.CompressSfxFileParametersTempLocation
		UnixTimeFormat = $Datas.CompressSfxFileParametersUnixTimeFormat
		WindowsTimeFormat = $Datas.CompressSfxFileParametersWindowsTimeFormat
		ZipErrorAction = $Datas.CompressSfxFileParametersZipErrorAction
	}
	inputs = @(
		@{
			type = ''
			description = $Datas.CompressSfxFileInputsDescription1
		}
	)
	outputs = @(
		@{
			type = 'System.IO.FileInfo'
			description = $Datas.CompressSfxFileOutputsDescriptionSystemIOFileInfo
		}
	)
	notes = $Datas.CompressSfxFileNotes
	examples = @(
		@{
			code = {
 $ZipFileName="C:\Temp\MySetup.exe"
 
 $Save=@{
	ExeOnUnpack="Powershell -noprofile -File .\MySetup.ps1";  
      Description="Setup for one Powershell module"; 
      ExtractExistingFile=[Ionic.Zip.ExtractExistingFileAction]::OverwriteSilently;
      NameOfProduct="MyProject";
      VersionOfProduct="1.0.0";
      Copyright='This module is free for non-commercial purposes.'
 }
 $SaveOptions=New-ZipSfxOptions @Save

 Dir "C:\Temp\*.ps1"|
   Compress-SfxFile $ZipFileName -Options $SaveOptions          
			}
			remarks = $Datas.CompressSfxFileExamplesRemarks1
			test = { . $args[0] }
		}
		@{
			code = {
$ZipFileName="C:\Temp\MySetup.exe"

Dir "C:\Temp\*.ps1"|
   Compress-SfxFile $ZipFileName -Options (Get-PsIonicSfxOptions) -Verbose         
			}
			remarks = $Datas.CompressSfxFileExamplesRemarks2
			test = { . $args[0] }
		}
	)
	links = @(
		@{ text = ''; URI = '' }
	)
}

