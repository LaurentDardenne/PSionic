# Compress-SfxFile command data
$Datas = @{
	CompressSfxFileSynopsis = 'Construit une archive compressée et autoextractible. La fonction génère un fichier .exe.'
	CompressSfxFileDescription = ''
	CompressSfxFileSetsLiteralPath = ''
	CompressSfxFileSetsPath = ''
	CompressSfxFileParametersCodePageIdentifier = 'Nom de la page de code utilisé pour le nom de fichier. L''utilisation de la valeur par défaut est recommandée.'
	CompressSfxFileParametersComment = 'Commentaire associé à l''archive.'
	CompressSfxFileParametersEncoding = 'Type d''encodage de l''archive.L''utilisation de la valeur par défaut est recommandé.'
	CompressSfxFileParametersEncryption = 'Type de cryptage utilisé lors de l''opération de compression. Nécessite de préciser un mot de passe (cf. le paramètre Password).'
	CompressSfxFileParametersLiteralPath =@"
Liste des nom de fichiers à compresser,ceux-ci sont traités tel quel, c'est-à-dire que les caractères génériques ne sont pas interprétés. 
Peut être un objet fichier ou une chaîne de caractères.
"@
	CompressSfxFileParametersNotTraverseReparsePoints = 'Indique si les recherches traverseront les points d''analyse NTFS (Reparse Point), tels que les jonctions.'
	CompressSfxFileParametersOptions = 'Options utilisées lors de la création d''un archive autoextractible (cf. New-ZipSfxOptions).'
	CompressSfxFileParametersOutputName = 'Nom du fichier de l''archive à construire. Le nom du drive utilisé doit pointer sur un drive du provider FileSystem.'
    CompressSfxFileParametersPassthru = 'Emet le fichier d''archive dans le pipeline. Attention, dans ce cas la libération des ressources par l''appel à la méthode Close() est à votre charge.'	
    CompressSfxFileParametersPassword = 'Mot de passe utilisé lors de la du cryptage. Nécessite de préciser un mode de cryptage (cf. le paramètre Encryption).'
	CompressSfxFileParametersPath =@"
Liste des nom de fichiers à compresser. Peut être un objet fichier ou une chaîne de caractères, dans ce cas celle-ci peut contenir des caractères génériques (* , ? , [A-D] ou [1CZ]).
"@
	CompressSfxFileParametersRecurse = 'Parcourt récursif des arborescences (todo ?) '
	CompressSfxFileParametersSetLastModifiedProperty =  @"
Permet, avant d'enregister l'archive, de modifier la propriété LastModified de chaque entrée de l'archive. La variable $Entry doit être utilisée dans le corps du scriptblock.
"@
	CompressSfxFileParametersSortEntries = @"
Les entrées sont triées avant d'être enregistrées. Selon le nombre de fichiers traités, ce traitement peut ralentir l'opération de compression.
"@ 
	CompressSfxFileParametersTempLocation =  @"
Nom du répertoire temporaire utilisé lors de la construction de l'archive. 
Par défaut la fonction récupère le contenu de la variable d'environnement %TEMP%.
Sinon, le fichier temporaire de l'archive en cours de construction sera enregistré dans le répertoire spécifié par le paramètre 'OutputName'.
"@
	CompressSfxFileParametersUnixTimeFormat = 'Le format de date des fichiers sera celui d''Unix'
	CompressSfxFileParametersWindowsTimeFormat = 'Le format de date des fichiers sera celui de Windows'
	CompressSfxFileParametersZipErrorAction = 'Précise le mode de gestion des erreurs.'
	CompressSfxFileInputsDescription1 = 'System.String,System.IO.FileInfo'
    CompressSfxFileOutputsDescriptionSystemIOFileInfo ='System.IO.FileInfo'
	CompressSfxFileNotes = @"
Selon le contenu, votre archive peut être compressée en 64 bits, pour déterminer si l‘archive utilise les extensions Zip64 consultez le propriété ''OutputUsedZip64'' de l''archive.
Aucun contrôle n'est effectué sur l'espace disponible lors de la création de l'archive.
"@ 
	CompressSfxFileExamplesRemarks1 = ''
}


