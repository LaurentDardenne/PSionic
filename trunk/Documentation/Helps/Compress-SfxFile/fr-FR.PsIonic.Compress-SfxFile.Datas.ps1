# Compress-SfxFile command data
$Datas = @{
	CompressSfxFileSynopsis = 'Construit une archive compressée et auto extractible. La fonction génère un fichier .exe.'
	CompressSfxFileDescription = ''
	CompressSfxFileSetsLiteralPath = ''
	CompressSfxFileSetsPath = ''
	CompressSfxFileParametersCodePageIdentifier = 'Nom de la page de code utilisé pour le nom de fichier. L''utilisation de la valeur par défaut est recommandée.'
	CompressSfxFileParametersComment = 'Commentaire associé à l''archive.'
	CompressSfxFileParametersEncoding = 'Type d''encodage de l''archive. L''utilisation de la valeur par défaut est recommandé.'
	CompressSfxFileParametersEncryption = 'Type de cryptage utilisé lors de l''opération de compression. Nécessite de préciser un mot de passe (cf. le paramètre Password).'
	CompressSfxFileParametersEntryPathRoot = @"
La nouvelle entrée sera ajoutée dans un répertoire spécifique. Par défaut elle est ajoutée à la racine de l'arborescence contenue dans l'archive. 
La valeur de ce paramètre doit référencer un répertoire existant.
.
Pour éviter les collisions de nom d'entrée lors de la compression récursive d'une arborescence vous devrez utiliser ce paramètre.
Celui-ci permet de construire le nom de l'entrée relativement au nom de répertoire spécifié.
. 
Par exemple en précisant 'C:\Temp\Backup', lors de la compression récursive de 'C:\Temp\Backup' le traitement de construction du nom d'entrée retranchera 'C:\Temp\Backup' à chaque nom de fichier reçus.
Donc, pour les fichiers 'C:\Temp\Backup\File1.ps1' et 'C:\Temp\Backup\Projet\File1.ps1' les entrées créées dans le catalogue seront respectivement:
File1.ps1
Projet/File.ps1   
.
De préciser un nom de répertoire différent de celui d'où débute l'archivage déclenchera une erreur et stoppera l'archivage du path en cours.
"@
	CompressSfxFileParametersLiteralPath =@"
Liste des noms de fichier à compresser, ceux-ci sont traités tel quel, c'est-à-dire que les caractères génériques ne sont pas interprétés. 
Peut être un objet fichier ou une chaîne de caractères.
"@
	CompressSfxFileParametersNotTraverseReparsePoints = 'Indique si les recherches traverseront les points d''analyse NTFS (Reparse Point), tels que les jonctions.'
	CompressSfxFileParametersOptions = 'Options utilisées lors de la création d''un archive auto extractible (cf. New-ZipSfxOptions).'
	CompressSfxFileParametersOutputName = 'Nom du fichier de l''archive à construire. Le nom du lecteur utilisé doit pointer sur un lecteur du provider FileSystem.'
    CompressSfxFileParametersPassthru = 'Emet le fichier d''archive dans le pipeline. Attention, dans ce cas la libération des ressources par l''appel à la méthode Close() est à votre charge.'	
    CompressSfxFileParametersPassword = 'Mot de passe utilisé lors du cryptage. Nécessite de préciser un mode de cryptage (cf. le paramètre Encryption).'
	CompressSfxFileParametersPath =@"
Liste des noms de fichier à compresser. Peut être un objet fichier ou une chaîne de caractères, dans ce cas celle-ci peut contenir des caractères génériques (* , ? , [A-D] ou [1CZ]).
"@
	CompressSfxFileParametersRecurse = 'Parcourt récursif des arborescences définies par le paramètre Path ou LiteralPath.'
	CompressSfxFileParametersSetLastModifiedProperty =  @"
Permet, avant d'enregistrer l'archive, de modifier la propriété LastModified de chaque entrée de l'archive. La variable `$ZipFile, représentant l'archive en cours de traitement, doit être utilisée dans le corps du scriptblock.
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
Selon le contenu, votre archive peut être compressée en 64 bits, pour déterminer si l'archive utilise les extensions Zip64 consultez le propriété 'OutputUsedZip64' de l'archive.
Aucun contrôle n'est effectué sur l'espace disponible lors de la création de l'archive.
"@ 
	CompressSfxFileExamplesRemarks1 = @'
Ces instructions créent une archive autoextractible contenant tous les fichiers .ps1 du répertoire C:\temp.
Les options sont définies avant la création.
'@
 	CompressSfxFileExamplesRemarks2 = @'
Ces instructions créent une archive auto extractible contenant tous les fichiers .ps1 du répertoire C:\temp.
Les options sont récupérées par la fonction Get-PsIonicSfxOptions qui sont les options par défaut de PsIonic ou ceux que vous avez configuré.
L'usage du paramètre -Verbose permet l'affichage de la progression sur la console.  
'@
}


