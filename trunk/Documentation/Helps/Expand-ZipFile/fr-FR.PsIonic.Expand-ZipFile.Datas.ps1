# Expand-ZipFile command data
$Datas = @{
	ExpandZipFileSynopsis = 'Extrait des fichiers et/ou des répertoires depuis une archive compressée au format Zip.'
	ExpandZipFileDescription = 'La cmdlet Expand-ZipFile permet d''extraire des fichiers et/ou des répertoires depuis une archive compressée au format Zip.'
	ExpandZipFileSetsDefault = 'Jeu de paramètre 1'
	ExpandZipFileSetsList = 'Jeu de paramètre 2'
    ExpandZipFileParametersPath = 'Nom du fichier Zip sous la forme d''un objet de type String ou System.IO.FileInfo'
	ExpandZipFileParametersOutputPath = 'Répertoire de destination utilisé lors de l''extraction des données contenues dans une archive Zip.'
	ExpandZipFileParametersQuery = @"
Précise un critère de recherche pour les données à extraire de l'archive Zip.
Pour plus d'informations sur l'écriture et la syntaxe de la requête, consultez la documentation de la dll Ionic (fichier d'aide .chm).
Attention, il n’y a pas de contrôle de cohérence sur le contenu de la query, par exemple celle-ci 'size <100 byte AND Size>1000 byte' ne provoquera pas d'erreur mais aucun fichier ne sera sélectionné.
"@
	ExpandZipFileParametersFrom = 'Précise le répertoire de travail au sein du fichier Zip.'
	ExpandZipFileParametersExtractAction = 'Précise le comportement à adopter lorsque des données sont déjà présentes dans le répertoire de destination.'
    ExpandZipFileParametersPassword = 'Précise le mot de passe nécessaire à l''extraction d''une archive encryptée.'	
	ExpandZipFileParametersEncoding = 'Type d''encodage de l''archive. L''utilisation de la valeur par défaut est recommandée.'
	ExpandZipFileParametersInteractive = 'Passe les actions de la Cmdlet en mode interactif.'
	ExpandZipFileParametersList = 'Liste les données contenues dans le fichier Zip.'
	ExpandZipFileParametersFlatten = 'Les fichiers sont extraits sans arborescence.'
	ExpandZipFileParametersProgressID = @"
L'usage de ce paramètre crée un gestionnaire d'événements pour les opérations de lecture. 
Lors de l'ouverture d'archive zip de grande taille, vous pouvez choisir d'afficher une barre de progression. 
"@
	ExpandZipFileParametersPassthru = 'Emet dans le pipeline les entrées contenues dans l''archive zip. Attention, dans ce cas la libération des ressources par l''appel à la méthode Close() est à votre charge.'
    ExpandZipFileParametersCreate = 'Créer le répertoire de destination si celui-ci n''existe pas.'	
	ExpandZipFileInputsDescription1 = 'En entrée des String ou des Fileinfo'
	ExpandZipFileOutputsDescriptionDefault = 'Emet une instance de type ZipFile.'
	ExpandZipFileOutputsDescriptionIonicZipZipFile = 'Emet une instance de type ZipFile.'
	ExpandZipFileOutputsDescriptionList = 'Emet une ou des instance(s) de type ZipFile.'
	ExpandZipFileOutputsDescriptionIonicZipZipEntry = 'Emet une instance de type ZipEntry.'
	ExpandZipFileNotes = @"
Une archive Zip peut donc théorie contenir plusieurs entrées dont chacune a un mode de compression différente des autres. 
Cette fonction suppose que le mot de passe et le type de cryptage est commun à toutes les entrées de l'archive.
"@
	ExpandZipFileExamplesRemarks1 = 'Extrait les données contenues dans une archive Zip vers un répertoire de destination.'
    ExpandZipFileExamplesRemarks2 = 'Extrait les données contenues dans des archives Zip vers un répertoire de destination.'
    ExpandZipFileExamplesRemarks3 = @"
 Extrait les données contenues dans une archive Zip vers un répertoire de destination.
 Seules les données correspondantes à la requête sont extraites, ici les fichiers dont l'extension est '.jpg'.
 "@
    ExpandZipFileExamplesRemarks4 = @"
Extrait les données contenues dans une archive Zip vers un répertoire de destination.
Seules les données correspondantes à la requête sont extraites, ici uniquement les répertoires.
"@
}
