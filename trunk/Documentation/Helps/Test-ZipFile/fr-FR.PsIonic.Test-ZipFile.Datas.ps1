# Test-ZipFile command data
$Datas = @{
	TestZipFileSynopsis = 'Teste si un fichier est une archive au format PkZip.'
	TestZipFileDescription = @'
Teste si un fichier est une archive au format PkZip. 
Lors de ce test, il est également possible de vérifier si l'archive est valide et de tenter dans ce cas de la réparer.
Par défaut les erreurs simples sont déclenchées.
'@
	TestZipFileSetsDefault = ''
	TestZipFileSetsFile = ''
	TestZipFileParametersCheck = @"
Vérifie si le catalogue de l'archive indiquée est correcte.
Cette vérification est plus stricte que celle effectuée avec le paramètre -isValid.
Elle peut donc renvoyer $false bien que le fichier soit considéré comme une archive valide.
Si vous devez tester une archive avec un mot de passe utilisez ce paramètre avec ou sans le paramètre -Password. 
"@
	TestZipFileParametersPath = 'Nom du fichier de l''archive à tester.'
	TestZipFileParametersisValid = @"
Indique si l'archive semble valide. Cette fonction peut donc renvoyer $true alors que le contenu de l'archive est erronée. 
Si un fichier n'est pas une archive et que le paramètre -isValid est précisé, alors les erreurs simples ne sont pas générées.
Si vous devez tester une archive avec un mot de passe n'utilisez pas ce paramètre, mais le paramètre -Password et/ou le paramètre -Check.
"@
	TestZipFileParametersPassthru = @'
Emet le nom du fichier de l'archive dans le pipeline. 
Si le paramètre -isValid est également précisé, alors les fichiers considérés comme invalide ne seront pas émis dans le pipeline et aucune erreur simple ne sera déclenchée.
Ce comportement est similaire à un filtre, où seul les fichiers valides seraient émis dans le pipeline.
Les objets archive renvoyés n'étant pas verrouillés, soyez attentif à vos scénarios d'usage de ces objets.    
'@
	TestZipFileParametersPassword = @'
Mot de passe, nécessaire si l'archive est protégée par un mot de passe.
Si vous devez tester une archive avec un mot de passe n'utilisez pas le paramètre -IsValid, car dans ce cas le résultat renvoyé sera toujours faux.
Utilisez uniquement le paramètre -Password et/ou le paramètre -Check. Si le password est faux le résultat renvoyé sera faux.  
'@
	TestZipFileParametersRepair = 'Tente une réparation si l''archive est corrompue.'
	TestZipFileInputsDescription1 = 'String ou System.IO.FileInfo ou Object (transformé en un type String). Les objets de type répertoire ne sont pas traités.'
	TestZipFileOutputsDescriptionSystemBoolean = ''
	TestZipFileOutputsDescriptionSystemString = ''
	TestZipFileNotes = ''
	TestZipFileExamplesRemarks1 = 'La première ligne crée une archive au format Zip, la seconde teste si le fichier est bien une archive au format PkZip. Le résultat de l''exécution vaut $true.'
    TestZipFileExamplesRemarks2 = @"
La première ligne crée une archive au format Zip, la seconde crée une archive auto extractible, la troisième teste si le fichier est bien une archive au format PkZip. 
On constate qu'une archive auto extractible est considérée comme étant une archive valide. Le résultat de l'exécution vaut $true.
"@
    TestZipFileExamplesRemarks3 = 'Le résultat de l''exécution vaut $false, car l''objet reçu, transformé en string, ne référence pas un fichier d''archive .ZIP.'
}
