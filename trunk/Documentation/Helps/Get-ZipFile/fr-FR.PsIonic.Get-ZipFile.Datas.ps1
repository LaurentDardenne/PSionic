# Get-ZipFile command data
$Datas = @{
	GetZipFileSynopsis = 'Obtient un objet archive à partir d''un fichier Zip.'
	GetZipFileDescription = 'Obtient un objet archive à partir d''un fichier Zip. L''objet archive ne contient que le catalogue, pour récupèrer le contenu d''une entrée du catalogue vous devez l''extraire sur un lecteur du système de fichier.'
	GetZipFileSetsFile = ''
	GetZipFileSetsManualOption = ''
	GetZipFileSetsReadOption = ''
	GetZipFileParametersEncoding = 'Type d''encodage de l''archive. L''utilisation de la valeur par défaut est recommandée.'
	GetZipFileParametersEncryption = 'Type de cryptage utilisé lors de l''opération de compression. Nécessite de préciser un mot de passe (cf. le paramètre Password).'
	GetZipFileParametersFollow =@"
L'usage de ce paramètre crée un gestionnaire d'événements pour les opérations de lecture. 
Lors de l'ouverture d'archive zip de grande taille, vous pouvez choisir d'afficher une barre de progression. 
"@ #TODO
	GetZipFileParametersName = 'Nom de fichier de l''archive'
	GetZipFileParametersNotTraverseReparsePoints = 'Indique si les recherches traverseront les points d''analyse NTFS (Reparse Point), tels que les jonctions.'
	GetZipFileParametersOptions = 'Options utilisées lors de la création d''un archive autoextractible (cf. New-ZipSfxOptions).'
	GetZipFileParametersPassword = 'Précise le mot de passe nécessaire à la lecture d''une archive encryptée.'
	GetZipFileParametersReadOptions = 'Objet d''option de lecture créé à l''aide de la fonction New-ReadOptions.'
	GetZipFileParametersSortEntries = 'Tri les entrées avant de les envoyer dans le pipeline.'
	GetZipFileParametersSplit = 'Découpe le fichier d''archive par segment de la taille spécifiée.'
	GetZipFileParametersTempLocation = 'Nom du répertoire temporaire utilisé lors de la constrution de l''archive. Par défaut récupère le contenu de la variable d''environnement %TEMP%.'
	GetZipFileParametersUnixTimeFormat = 'Le format de date des fichiers sera celui d''Unix'
	GetZipFileParametersWindowsTimeFormat = 'Le format de date des fichiers sera celui de Windows'
	GetZipFileParametersZipErrorAction = 'Précise le mode de gestion des erreurs.'
	GetZipFileInputsDescription1 = 'String'
	GetZipFileOutputsDescriptionFile = 'Ionic.Zip.ZipFile'
	GetZipFileOutputsDescriptionIonicZipZipFile = 'Ionic.Zip.ZipFile'
	GetZipFileNotes = ''
	GetZipFileExamplesRemarks1 = 'exmple 1 todo'
    GetZipFileExamplesRemarks2 = 'exmple 2 todo'
    GetZipFileExamplesRemarks3 = 'exmple 3 todo'
    GetZipFileExamplesRemarks4 = 'exmple 4 todo'
}


