#todo description à revoir
# Compress-ZipFile command data
$Datas = @{
	CompressZipFileSynopsis = 'Compresse une liste de fichiers dans une archive .ZIP.'
	CompressZipFileDescription = 'Compresse une liste de fichiers dans une archive .ZIP.'
	CompressZipFileSetsFile = 'jeux de paramètre 2'
	CompressZipFileSetsSFX = 'jeux de paramètre 3'
	CompressZipFileSetsUT = 'jeux de paramètre 4'
	CompressZipFileSetsUTnewest = 'jeux de paramètre 5'
	CompressZipFileSetsUTnow = 'jeux de paramètre 6'
	CompressZipFileSetsUToldest = 'jeux de paramètre 7'
	CompressZipFileParametersCodePageIdentifier = 'Nom de la page de code utilisé pour le nom de fichier. L''utilisation de la valeur par défaut est recommandée.'
	CompressZipFileParametersComment = 'Commentaire associé à l''archive.'
	CompressZipFileParametersEncoding = 'Type d''encodage de l''archive.L''utilisation de la valeur par défaut est recommandé.'
	CompressZipFileParametersEncryption = 'Type de cryptage utilisé lors de l''opération de compression. Nécessite de préciser un mot de passe (cf. le paramètre Password).'
	CompressZipFileParametersFile = 'Liste du nom de fichiers à compresser. Peut être un objet fichier ou une chaîne de caractères, dans ce cas celle-ci peut contenir des caractères génériques (* , ? , [A-D] ou [1CZ]).'
	CompressZipFileParametersName = 'Nom du fichier l''archive à construire. Le nom du drive utilisé doit pointer sur un drive du provider FileSystem.'
	CompressZipFileParametersNewUniformTimestamp = 'Uniformise la date et de l''heure de toutes les entrées en prenant la date et l''heure de l''entrée la plus récente dans l''archive.'
	CompressZipFileParametersNowUniformTimestamp = 'Uniformise, à partir de la date et l''heure courante, la date et de l''heure de toutes les entrées.'
	CompressZipFileParametersNotTraverseReparsePoints = 'Indique si les recherches traverseront les points d''analyse NTFS (Reparse Point), tels que les jonctions.'
 	CompressZipFileParametersOldUniformTimestamp = 'Uniformise la date et de l''heure de toutes les entrées en prenant la date et l''heure de l''entrée la plus ancienne dans l''archive.'
	CompressZipFileParametersOptions = 'Options utilisées lors de la création d''un archive autoextractible (cf. New-ZipSfxOptions).'
	CompressZipFileParametersPassthru = 'Emet le fichier d''archive dans le pipeline. Attention, dans ce cas la libération des ressources par l''appel à la méthode Close() est à votre charge.'
	CompressZipFileParametersPassword = 'Mot de passe utilisé lors de la du cryptage. Nécessite de préciser un mode de cryptage (cf. le paramètre Encryption).'
	CompressZipFileParametersRecurse = 'Parcourt récursif des arborescences (todo ?) '
	CompressZipFileParametersSFX = 'Construit une archive compressée et autoextractible. La fonction génére un fichier .exe.'
	CompressZipFileParametersSortEntries = 'Les entrées sont triées' #todo tjr utilisée ?
	CompressZipFileParametersSplit = @"
Découpe le fichier d'archive par segment de la taille spécifiée. La syntaxe suivante 64Kb est possible et le nombre maximum de segment est de 99.
Attention, il n'est pas possible d'enregistrer une archive splittée dans une archive autoextractible.
"@
	CompressZipFileParametersTempLocation  = @"
Nom du répertoire temporaire utilisé lors de la constrution de l'archive. 
Par défaut la fonction récupère le contenu de la variable d'environnement %TEMP%.
Sinon, le fichier temporaire de l'archive en cours de constrution sera enregistré dans le répertoire spécifié par le paramètre 'Name'.
"@
	CompressZipFileParametersUniformTimestamp = 'Uniformise la date et de l''heure de toutes les entrées en prenant la date et l''heure précisée en argument.'
	CompressZipFileParametersUnixTimeFormat = 'Le format de date des fichiers sera celui d''Unix'
	CompressZipFileParametersWindowsTimeFormat = 'Le format de date des fichiers sera celui de Windows'
	CompressZipFileParametersZipErrorAction = 'Précise le mode de gestion des erreurs.'
	CompressZipFileInputsDescription1 = 'System.String,System.IO.FileInfo'
	CompressZipFileOutputsDescriptionFile = 'System.String'
	CompressZipFileOutputsDescriptionIonicZipZipFile = 'Ionic.Zip.ZipFile'
	CompressZipFileOutputsDescriptionSFX = 'Emet le nom d''un fichier .exe.'
	CompressZipFileOutputsDescriptionSystemIOFileInfo = 'System.IO.FileInfo'
	CompressZipFileNotes = @"
Selon le contenu, votre archive peut être compressée en 64 bits, pour déterminer si l‘archive utilise les extensions Zip64 consultez le propriété ''OutputUsedZip64'' de l''archive.
Aucun contrôle n'est effectué sur l'espace disponible lors de la création de l'archive.
"@ 
	CompressZipFileExamplesRemarks1 = "Cet exemple ajoute, à partir du répertoire courant, tous les fichiers dont l''extension est '.txt' dans l''archive 'C:\Temp\Test.zip'."

}
