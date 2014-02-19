# Get-ZipFile command data
$Datas = @{
	GetZipFileSynopsis = 'Obtient un objet archive à partir d''un fichier Zip.'
	GetZipFileDescription = 'Obtient un objet archive à partir d''un fichier Zip. L''objet archive ne contient que le catalogue, une liste d''objets de type ZipEntry, pour récupèrer le contenu d''une entrée du catalogue vous devez l''extraire sur un lecteur du système de fichier.'
	GetZipFileSetsManualOption = ''
	GetZipFileSetsReadOption = ''
	GetZipFileParametersEncoding = 'Type d''encodage de l''archive. L''utilisation de la valeur par défaut est recommandée.'
	GetZipFileParametersEncryption = 'Type de cryptage utilisé lors de l''opération de compression. Nécessite de préciser un mot de passe (cf. le paramètre Password).'
	GetZipFileParametersList = @"
Obtient les entrées contenu dans le catalogue de l'archive. Les objets renvoyés sont des objets personnalisés dont le nom de type est PSZipEntry.
"@
	GetZipFileParametersProgressID =@"
L'usage de ce paramètre crée un gestionnaire d'événements pour les opérations de lecture.
Lors de l'ouverture d'une archive zip de grande taille, vous pouvez choisir d'afficher une barre de progression standardisée.
Cette ID permet de distinguer la barre de progression interne des autres. Utilisez ce paramètre lorsque vous créez plus d'une barre de progression.
"@
	GetZipFileParametersPath = 'Nom du ou des fichiers ZIP à lire. Vous pouvez préciser des noms de fichier comportant des jokers.'
	GetZipFileParametersOptions = 'Options utilisées lors de la création d''un archive autoextractible (cf. New-ZipSfxOptions).'
	GetZipFileParametersPassword = 'Précise le mot de passe nécessaire à la lecture d''une archive encryptée.'
	GetZipFileParametersReadOptions = 'Objet d''option de lecture créé à l''aide de la fonction New-ReadOptions.'
	GetZipFileParametersSortEntries = 'Tri les entrées avant de les envoyer dans le pipeline.'
	GetZipFileParametersUnixTimeFormat = 'Le format de date des fichiers sera celui d''Unix'
	GetZipFileParametersWindowsTimeFormat = 'Le format de date des fichiers sera celui de Windows'
	GetZipFileParametersZipErrorAction = 'Précise le mode de gestion des erreurs.'
	GetZipFileInputsDescription1 = 'String'
	GetZipFileOutputsDescriptionIonicZipZipFile = 'Ionic.Zip.ZipFile'
	GetZipFileNotes = @"
Cette fonction renvoyant seulement un objet archive Zip à partir de son nom complet, la plupart des paramètres servent à configurer les propriètes de l'archive si vous souhaitez la modifier.
Par exemple, le paramètre 'Encryption' n’influe pas sur la lecture du Zip, seul le paramètre Password est nécessaire, car ce sont les entrées de l'archive Zip qui portent l’information de cryptage, et pas l'objet de type [ZipFile].
Une archive Zip peut donc en théorie contenir plusieurs entrées dont chacune a un mode de compression différente des autres.
ATTENTION, pour chaque objet renvoyé vous devrez appeler la méthode PSDispose afin de libérer correctement les ressources de l'archive.
"@
	GetZipFileExamplesRemarks1 = @"
Cet exemple lit un fichier zip, affiche sont contenu puis libére ses ressources. 
"@
    GetZipFileExamplesRemarks2 = @"
Cet exemple lit un fichier zip, lui ajoute une entrée à partir d'un fichier, puis l'enregistre et enfin libére ses ressources. 
"@
    GetZipFileExamplesRemarks3 =  @"
Cet exemple lit un fichier zip, lui ajoute une entrée à partir d'une chaine de caractères, puis l'enregistre et enfin libére ses ressources. 
"@
    GetZipFileExamplesRemarks4 =  @"
Cet exemple lit un fichier zip, lui ajoute tous les fichiers txt d'un répertoire, puis l'enregistre en libérant ses ressources. 
La méthode Close() appelle en interne la méthode Save() puis PSDispose(). 
"@
}


