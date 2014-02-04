# Compress-ZipFile command data
$Datas = @{
	CompressZipFileSynopsis = 'Compresse une liste de fichiers dans une archive .ZIP.'
	CompressZipFileDescription = 'Le cmdlet Compress-ZipFile compresse des fichiers et/ou des répertoires dans une archive au format Zip.'
	CompressZipFileSetsLiteralPath = ''
	CompressZipFileSetsPath = ''
	CompressZipFileParametersCodePageIdentifier = 'Nom de la page de code utilisé pour le nom de fichier. L''utilisation de la valeur par défaut est recommandée.'
	CompressZipFileParametersComment = 'Commentaire associé à l''archive.'
	CompressZipFileParametersEncoding = 'Type d''encodage de l''archive.L''utilisation de la valeur par défaut est recommandé.'
	CompressZipFileParametersEncryption = 'Type de cryptage utilisé lors de l''opération de compression. Nécessite de préciser un mot de passe (cf. le paramètre Password).'
	CompressZipFileParametersLiteralPath = @"
Liste des nom de fichiers à compresser,ceux-ci sont traités tel quel, c'est-à-dire que les caractères génériques ne sont pas interprétés. 
Peut être un objet fichier ou une chaîne de caractères.
"@
	CompressZipFileParametersNotTraverseReparsePoints = 'Indique si les recherches traverseront les points d''analyse NTFS (Reparse Point), tels que les jonctions.'
	CompressZipFileParametersOutputName = 'Nom du fichier de l''archive à construire. Le nom du drive utilisé doit pointer sur un drive du provider FileSystem.'
	CompressZipFileParametersPassthru = 'Emet le fichier d''archive dans le pipeline. Attention, dans ce cas la libération des ressources par l''appel à la méthode Close() est à votre charge.'
	CompressZipFileParametersPassword = 'Mot de passe utilisé lors de la du cryptage. Nécessite de préciser un mode de cryptage (cf. le paramètre Encryption).'
	CompressZipFileParametersPath = @"
Liste des nom de fichiers à compresser. Peut être un objet fichier ou une chaîne de caractères, dans ce cas celle-ci peut contenir des caractères génériques (* , ? , [A-D] ou [1CZ]).
"@
	CompressZipFileParametersRecurse = 'Parcourt récursif des arborescences (todo ?) '
	CompressZipFileParametersSetLastModifiedProperty = @"
Permet, avant d'enregister l'archive, de modifier la propriété LastModified de chaque entrée de l'archive. La variable $Entry doit être utilisée dans le corps du scriptblock.
"@
	CompressZipFileParametersSortEntries = @"
Les entrées sont triées avant d'être enregistrées. Selon le nombre de fichiers traités, ce traitement peut ralentir l'opération de compression.
"@ 
	CompressZipFileParametersSplit = @"
Découpe le fichier d'archive par segment de la taille spécifiée. La syntaxe '64Kb' est possible et le nombre maximum de segment est de 99.
"@
	CompressZipFileParametersTempLocation  = @"
Nom du répertoire temporaire utilisé lors de la construction de l'archive. 
Par défaut la fonction récupère le contenu de la variable d'environnement %TEMP%.
Sinon, le fichier temporaire de l'archive en cours de construction sera enregistré dans le répertoire spécifié par le paramètre 'OutputName'.
"@
	CompressZipFileParametersUnixTimeFormat = 'Le format de date des fichiers sera celui d''Unix'
	CompressZipFileParametersWindowsTimeFormat = 'Le format de date des fichiers sera celui de Windows'
	CompressZipFileParametersZipErrorAction = 'Précise le mode de gestion des erreurs.'
	CompressZipFileInputsDescription1 = 'System.String,System.IO.FileInfo'
	CompressZipFileOutputsDescriptionIonicZipZipFile = 'Ionic.Zip.ZipFile'
	CompressZipFileNotes = @"
Selon le contenu, votre archive peut être compressée en 64 bits, pour déterminer si l‘archive utilise les extensions Zip64 consultez le propriété ''OutputUsedZip64'' de l''archive.
Aucun contrôle n'est effectué sur l'espace disponible lors de la création de l'archive.
"@ 
	CompressZipFileExamplesRemarks1 = "Cet exemple ajoute, à partir du répertoire courant, tous les fichiers dont l''extension est '.txt' dans l''archive 'C:\Temp\Test.zip'."
}
