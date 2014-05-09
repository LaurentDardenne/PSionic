# Expand-ZipFile command help
@{
	command = 'Expand-ZipFile'
	synopsis = $Datas.ExpandZipFileSynopsis
	description = $Datas.ExpandZipFileDescription
	sets = @{
		Path = $Datas.ExpandZipFileSetsPath
		LiteralPath = $Datas.ExpandZipFileSetsLiteralPath
	}
	parameters = @{
		Create = $Datas.ExpandZipFileParametersCreate
		OutputPath = $Datas.ExpandZipFileParametersOutputPath
		Encoding = $Datas.ExpandZipFileParametersEncoding
		ExtractAction = $Datas.ExpandZipFileParametersExtractAction
		Path = $Datas.ExpandZipFileParametersPath
        LiteralPath = $Datas.ExpandZipFileParametersLiteralPath
		Flatten = $Datas.ExpandZipFileParametersFlatten
		ProgressID = $Datas.ExpandZipFileParametersProgressID
		From = $Datas.ExpandZipFileParametersFrom
		Passthru = $Datas.ExpandZipFileParametersPassthru
		Password = $Datas.ExpandZipFileParametersPassword
		Query = $Datas.ExpandZipFileParametersQuery
	}
	inputs = @(
		@{
			type = 'System.String,System.IO.FileInfo'
			description = $Datas.ExpandZipFileInputsDescription1
		}
	)
	outputs = @(
		@{
			type = 'Aucun'
			description = $Datas.ExpandZipFileOutputsDescription1
		}
		@{
			type = 'Ionic.Zip.ZipFile'
			description = $Datas.ExpandZipFileOutputsDescriptionIonicZipZipFile
		}
	)
	notes = $Datas.ExpandZipFileNotes
    examples = @(
		@{
			code = {
              Expand-ZipFile -Path C:\Archive.zip -OutputPath C:\Temp\
			}
			remarks = $Datas.ExpandZipFileExamplesRemarks1
			test = { . $args[0] }
		}
		@{
			code = {
              Expand-ZipFile -Path C:\Archive.zip -OutputPath C:\Temp\Archive -Create
			}
			remarks = $Datas.ExpandZipFileExamplesRemarks2
			test = { . $args[0] }
		}
		@{
			code = {
              Get-ChildItem D:\*.zip -recurse | 
               Expand-ZipFile C:\Temp\
			}
			remarks = $Datas.ExpandZipFileExamplesRemarks3
			test = { . $args[0] }
		}
		@{
			code = {
              Get-ChildItem D:\*.zip -recurse | 
               Expand-ZipFile C:\Temp\ -ExtractAction OverwriteSilently
			}
			remarks = $Datas.ExpandZipFileExamplesRemarks4
			test = { . $args[0] }
		}
		@{
			code = {
              Expand-ZipFile -Path C:\Archive.zip -OutputPath C:\Temp\ -Query 'name = *.jpg'
			}
			remarks = $Datas.ExpandZipFileExamplesRemarks5
			test = { . $args[0] }
		}
		@{
			code = {
              Expand-ZipFile -Path C:\Archive.zip -OutputPath C:\Temp\ -Query 'type = D'
			}
			remarks = $Datas.ExpandZipFileExamplesRemarks6
			test = { . $args[0] }
		}
		@{
			code = {
              Expand-ZipFile -Path C:\Archive.zip -OutputPath C:\Temp\Test -Create -ProgressID 1
			}
			remarks = $Datas.ExpandZipFileExamplesRemarks7
			test = { . $args[0] }
		}
		@{
			code = {
'C:\Temp\Archive.zip'|
 Expand-ZipFile -OutputPath {"C:\Temp\TestZip\$($_.BaseName)"} -Create

Get-Childitem 'C:\Temp\Archive.zip'|
 Expand-ZipFile -OutputPath {"C:\Temp\TestZip\$($_.BaseName)"} -Create -ExtractAction OverwriteSilently
			}
			remarks = $Datas.ExpandZipFileExamplesRemarks8
			test = { . $args[0] }
		}
		@{
			code = {
try {
 $Splatting=@{
  Path='C:\Temp\Archive.zip'
  OutputPath='C:\Temp\ExtractArchive'
  Query='*.DLL' 
  From='Bin/V2/'
  Create=$True
  Flatten=$True 
  Passthru=$True              
 }            
 $ZipFile= Expand-ZipFile @Splatting
 $ZipFile.Query
} finally {
  if ($ZipFile -ne $null )
  { $ZipFile.PSDispose() }
}  
        
           
			}
			remarks = $Datas.ExpandZipFileExamplesRemarks9
			test = { . $args[0] }
		}
	)
	links = @(
 @{ text = ''; URI = 'https://psionic.codeplex.com/wikipage?title=Expand-ZipFile-FR'}
	)
}

