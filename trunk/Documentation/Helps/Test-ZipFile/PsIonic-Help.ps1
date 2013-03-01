
# Test-ZipFile command data
$Datas = @{
	TestZipFileSynopsis = 'Test si un fichier est une archive au format PkZip.'
	TestZipFileDescription = @'
Test si un fichier est une archive au format PkZip. Il est également possible lors de ce test de verifier si l'archive est valide et de tenter de la réparer le cas contraire.'
	TestZipFileSetsDefault = ''
	TestZipFileSetsFile = ''
	TestZipFileParametersCheck = 'Vérifie si l''archive est correcte.'
	TestZipFileParametersFile = 'Nom du fichier de l''archive à tester.'
	TestZipFileParametersisValid = 'Valide l''archive. Si un nom de fichier est invalide et isValid est précisé, une erreur non bloquante sera émise.'
	TestZipFileParametersPassthru = @'
 Emet le nom du fichier de l'archive dans le pipeline. 
 Si le paramètre -isValid est également précisé alors les fichiers considérés comme invalide ne seront pas émis dans le pipeline et aucune erreur ne sera émise.
 Ce comportement est similaire à un filtre, où seul les fichier valide seront émit dans le pipe.  
'@
	TestZipFileParametersPassword = 'Mot de passe, nécessaire si l''archive est protégée par un mot de passe.'
	TestZipFileParametersRepair = 'Tente une réparation si l''archive est corrompue.'
	TestZipFileInputsDescription1 = 'String ou System.IO.FileInfo ou Object ( transformé en un type String. Les objets de type répertoire ne sont pas traité.'
	TestZipFileOutputsDescriptionDefault = 'Emet $true ou $false'
	TestZipFileOutputsDescriptionbool = 'Emet $true ou $false'
	TestZipFileOutputsDescriptionFile = 'Emet le nom du fichier en cours de validation'
	TestZipFileOutputsDescriptionstring = ''
	TestZipFileNotes = ''
	TestZipFileExamplesRemarks1 = 'La première ligne crée une archive au format Zip, la seconde teste si le fichier est bien une archive au format PkZip. Le résultat de l''exécution vaut $true.'
    TestZipFileExamplesRemarks2 = 'La première ligne crée une archive autoextractible, la seconde teste si le fichier est bien une archive au format PkZip. On constate qu''une archive autoextratible est considérée comme étant une archive valide. Le résultat de l''exécution vaut $true.'
    TestZipFileExamplesRemarks3 = 'La première ligne crée une archive au format Zip, la seconde teste si le fichier est bien une archive au format PkZip. Le résultat de l''exécution vaut $true.'
}

# Test-ZipFile command help
@{
	command = 'Test-ZipFile'
	synopsis = $Datas.TestZipFileSynopsis
	description = $Datas.TestZipFileDescription
	sets = @{
		Default = $Datas.TestZipFileSetsDefault
		File = $Datas.TestZipFileSetsFile
	}
	parameters = @{
		Check = $Datas.TestZipFileParametersCheck
		File = $Datas.TestZipFileParametersFile
		isValid = $Datas.TestZipFileParametersisValid
		Passthru = $Datas.TestZipFileParametersPassthru
		Password = $Datas.TestZipFileParametersPassword
		Repair = $Datas.TestZipFileParametersRepair
	}
	inputs = @(
		@{
			type = ''
			description = $Datas.TestZipFileInputsDescription1
		}
	)
	outputs = @(
		@{
			type = 'Default'
			description = $Datas.TestZipFileOutputsDescriptionDefault
		}
		@{
			type = 'bool'
			description = $Datas.TestZipFileOutputsDescriptionbool
		}
		@{
			type = 'File'
			description = $Datas.TestZipFileOutputsDescriptionFile
		}
		@{
			type = 'string'
			description = $Datas.TestZipFileOutputsDescriptionstring
		}
	)
	notes = $Datas.TestZipFileNotes
	examples = @(
		@{
			code = {
"C:\Temp\*.*"|Compress-ZipFile "C:\Temp\Test.zip"
Test-Zipfile "C:\Temp\Test.zip"
			}
			remarks = $Datas.TestZipFileExamplesRemarks1
			test = { . $args[0] }
		},
		@{
			code = {
"C:\Temp\*.*"|Compress-ZipFile "C:\Temp\Test.zip" -Sfx
Test-Zipfile "C:\Temp\Test.exe"
			}
			remarks = $Datas.TestZipFileExamplesRemarks2
			test = { . $args[0] }
		},
		@{
			code = {
Get-Service Winmgmt|Test-ZipFile
			}
			remarks = $Datas.TestZipFileExamplesRemarks3
			test = { . $args[0] }
		}
	)
	links = @(
		@{ text = ''; URI = '' }
	)
}
