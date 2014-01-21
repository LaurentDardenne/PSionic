﻿# Test-ZipFile command data
$Datas = @{
	TestZipFileSynopsis = 'Test si un fichier est une archive au format PkZip.'
	TestZipFileDescription = @'
Test si un fichier est une archive au format PkZip. 
Il est également possible lors de ce test de verifier si l'archive est valide et de tenter de la réparer le cas contraire.
'@
	TestZipFileSetsDefault = ''
	TestZipFileSetsFile = ''
	TestZipFileParametersCheck = @"
Vérifie si le catalogue de l''archive indiquée est correcte.
Pour vérifier le contenu, vous devrez, sur la même ligne de commande, spécifier -isValid. 
# On peut donc renvoyer true si on précise seulement -Check sur une archive invalide
"@
	TestZipFileParametersPath = 'Nom du fichier de l''archive à tester.'
	TestZipFileParametersisValid = @"
Vérifie si le contenu de l''archive indiquée est valide. 
Si un fichier n'est pas une archive et que le paramètre 'isValid' est précisé alors une erreur non bloquante sera émise.
"@
	TestZipFileParametersPassthru = @'
 Emet le nom du fichier de l'archive dans le pipeline. 
 Si le paramètre -isValid est également précisé alors les fichiers considérés comme invalide ne seront pas émis dans le pipeline et aucune erreur ne sera émise.
 Ce comportement est similaire à un filtre, où seul les fichiers valide seront émit dans le pipeline.  
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
