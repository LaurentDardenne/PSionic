# Get-ZipFile command data
$Datas = @{
	GetZipFileSynopsis = 'Obtient et paramètre un objet archive à partir d''un fichier Zip.'
	GetZipFileDescription = @"
Obtient un objet archive à partir d'un fichier Zip. L'objet archive ne contient que le catalogue, une liste d'objets de type ZipEntry, pour récupérer le contenu d'une entrée du catalogue vous devez l'extraire sur un lecteur du système de fichier.
Cette fonction paramètre également les propriétés les plus usuelles de l'objet archive.
L'objet archive renvoyé est verrouillé tant que vous n'appellez pas sa méthode Close(). Par contre, l'usage du paramètre -List ne verrouille pas l'archive.
"@
	GetZipFileSetsManualOption = ''
	GetZipFileSetsReadOption = ''
	GetZipFileParametersEncoding = @"
Type d'encodage de l'archive. Les valeurs possibles sont :
-ASCII	          : encodage pour le jeu de caractères ASCII (7 bits).
-BigEndianUnicode : encodage pour le format UTF-16 qui utilise l'ordre d'octet avec primauté des octets de poids fort (big-endian).
-Default	      : encodage pour la page de codes ANSI actuelle du système d'exploitation.
-Unicode	      : encodage pour le format UTF-16 avec primauté des octets de poids faible (little-endian).
-UTF32	          : encodage pour le format UTF-32 avec primauté des octets de poids faible (little-endian).
-UTF7	          : encodage pour le format UTF-7.
-UTF8	          : encodage pour le format UTF-8.
.
A moins d'être assuré que celui sélectionné corresponde à celui utilisé lors de la compression de l'archive, l'utilisation de la valeur par défaut ('DefaultEncoding') est recommandé, 
"@
	GetZipFileParametersEncryption = 'Type de cryptage utilisé lors de l''opération de compression. Nécessite de préciser un mot de passe (cf. le paramètre Password).'
	GetZipFileParametersList = @"
Obtient les entrées contenues dans le catalogue de l'archive. Les objets renvoyés sont des objets personnalisés dont le nom de type est PSZipEntry.
Hormis sa propriété 'Info', toutes sont en lecture seule.
L'archive n'est pas verrouillée.
"@
	GetZipFileParametersProgressID =@"
L'usage de ce paramètre crée un gestionnaire d'événements pour les opérations de lecture.
Lors de l'ouverture d'une archive zip de grande taille, vous pouvez choisir d'afficher une barre de progression standardisée.
Cette ID permet de distinguer la barre de progression interne des autres. Utilisez ce paramètre lorsque vous créez plus d'une barre de progression.
"@
	GetZipFileParametersPath = 'Nom du ou des fichiers ZIP à lire. Vous pouvez préciser des noms de fichier comportant des jokers.'
	GetZipFileFParametersOptions = 'Options utilisées lors de la création d''une archive auto extractible (cf. New-ZipSfxOptions).'
	GetZipFileParametersPassword = 'Précise le mot de passe nécessaire à la lecture d''une archive encryptée.'
	GetZipFileParametersReadOptions = 'Objet d''option de lecture créé à l''aide de la fonction New-ReadOptions.'
	GetZipFileParametersSortEntries = 'Tri les entrées avant de les enregistrer dans l''archive.'
	GetZipFileParametersUnixTimeFormat = 'Le format de date des fichiers sera celui d''Unix'
	GetZipFileParametersWindowsTimeFormat = 'Le format de date des fichiers sera celui de Windows'
	GetZipFileParametersZipErrorAction = 'Précise le mode de gestion des erreurs.'
	GetZipFileInputsDescription1 = 'String'
	GetZipFileOutputsDescriptionIonicZipZipFile = 'Ionic.Zip.ZipFile'
	GetZipFileNotes = @"
Cette fonction renvoyant seulement un objet archive Zip à partir de son nom complet, la plupart des paramètres servent à configurer les propriétes de l'archive si vous souhaitez la modifier.
Par exemple, le paramètre 'Encryption' n’influe pas sur la lecture du Zip, seul le paramètre Password est nécessaire, car ce sont les entrées de l'archive Zip qui portent l’information de cryptage, et pas l'objet de type [ZipFile].
Une archive Zip peut donc en théorie contenir plusieurs entrées dont chacune a un mode de compression différente des autres.
ATTENTION, pour chaque objet renvoyé vous devrez appeler la méthode Close() afin de libérer correctement les ressources de l'archive.
"@
	GetZipFileExamplesRemarks1 = @"
Cet exemple lit un fichier zip, affiche son contenu puis libére ses ressources. 
"@
    GetZipFileExamplesRemarks2 = @"
Cet exemple lit un fichier zip, lui ajoute une entrée à partir d'un fichier, puis l'enregistre et enfin libère ses ressources. 
"@
    GetZipFileExamplesRemarks3 =  @"
Cet exemple lit un fichier zip, lui ajoute une entrée à partir d'une chaine de caractères, puis l'enregistre et enfin libère ses ressources. 
"@
    GetZipFileExamplesRemarks4 =  @"
Cet exemple lit un fichier zip, lui ajoute tous les fichiers txt d'un répertoire, puis l'enregistre en libérant ses ressources. 
La méthode Close() appelle en interne la méthode Save() puis PSDispose(). 
"@
    GetZipFileExamplesRemarks5 =  @"
La première instruction de cet exemple renvoi les entrées du catalogue d'une archive sous forme d'objet de type PSZipEntry.
Les suivantes recherche dans le catalogue d'origine une entrée nommée 'Test.ps1' puis la décompresse dans le répertoire C:\Temp.

La différence entre les deux approches est que les objets de type PSZipEntry ne dispose pas des méthodes spécifiques aux objets de type ZipEntry. 
"@
    GetZipFileExamplesRemarks6 =  @"
Cet exemple ouvre une archive, y supprime tous les fichiers .TXT et y ajoute tous les fichiers .LOG du répertoire C:\Temp.
Notez que chaque modification est enregistrée dans le catalogue de l'archive, mais seul l'appel à la méthode Close() enregistrera les modifications dans l'archive. 
"@
}


