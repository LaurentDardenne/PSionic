# ConvertTo-Sfx command help
@{
	command = 'ConvertTo-Sfx'
	synopsis = $Datas.ConvertToSfxSynopsis
	description = $Datas.ConvertToSfxDescription
	parameters = @{
		Comment = $Datas.ConvertToSfxParametersComment
		Name = $Datas.ConvertToSfxParametersName
		Passthru = $Datas.ConvertToSfxParametersPassthru
		ReadOptions = $Datas.ConvertToSfxParametersReadOptions
		SaveOptions = $Datas.ConvertToSfxParametersSaveOptions
	}
	inputs = @(
		@{
			type = ''
			description = $Datas.ConvertToSfxInputsDescription1
		}
	)
	outputs = @(
		@{
			type = 'System.IO.FileInfo'
			description = $Datas.ConvertToSfxOutputsDescriptionSystemIOFileInfo
		}
	)
	notes = $Datas.ConvertToSfxNotes
	examples = @(
		@{
			code = {
         
$ZipFileName="C:\Temp\MySetup.zip" 

$Files="C:\Project\MyScripts\*"
$ReadOptions = New-Object Ionic.Zip.ReadOptions -Property @{ 
                StatusMessageWriter = [System.Console]::Out
              } 

$Save=@{
    ExeOnUnpack="Powershell -noprofile -File .\MySetup.ps1";  
    Description="Setup for the my module"; 
    ExtractExistingFile=[Ionic.Zip.ExtractExistingFileAction]::OverwriteSilently;
    NameOfProduct="MyProjectName";
    VersionOfProduct="1.0.0";
    Copyright='This module is free for non-commercial purposes.'
}
$SaveOptions=New-ZipSfxOptions @Save

dir $Files |
 ConvertTo-Sfx $ZipFileName -Save $SaveOptions -Read $ReadOptions #todo à vérifier           
			}
			remarks = $Datas.ConvertToSfxExamplesRemarks1
			test = { . $args[0] }
		}
	)
	links = @(
		@{ text = ''; URI = '' }
	)
}

