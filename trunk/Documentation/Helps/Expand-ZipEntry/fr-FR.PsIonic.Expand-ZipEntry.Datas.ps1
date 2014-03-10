# Expand-ZipEntry command data
$Datas = @{
	ExpandZipEntrySynopsis = 'Extrait des entrées d''une archive compressée au format Zip.'
	ExpandZipEntryDescription = @"
Extrait des entrées d'une archive compressée au format Zip. Les données extraites sont soit des données sérialisées, soit un tableau d'octets, soit une chaîne de caractère et ils permettent de reconstruire un objet.
Pour extraire des fichiers d'une archive utilisez Expand-ZipFile.
"@
	ExpandZipEntrySetsByteArray = ''
	ExpandZipEntrySetsString = ''
	ExpandZipEntrySetsXML = ''
    ExpandZipEntryParametersAsHashTable= 'Renvoi les entrées lues dans un objet de type hashtable. Les noms des entrées à extraire seront utilisées en tant que nom de clé.'
    ExpandZipEntryParametersByte = "L'entrée est renvoyée en tant que tableau d'octets."	
    ExpandZipEntryParametersEncoding = @"
Type d'encodage de l'archive. Les valeurs possibles sont :
-ASCII	          : encodage pour le jeu de caractères ASCII (7 bits).
-BigEndianUnicode : encodage pour le format UTF-16 qui utilise l'ordre d'octet avec primauté des octets de poids fort (big-endian).
-Default	      : encodage pour la page de codes ANSI actuelle du système d'exploitation.
-Unicode	      : encodage pour le format UTF-16 avec primauté des octets de poids faible (little-endian).
-UTF32	          : encodage pour le format UTF-32 avec primauté des octets de poids faible (little-endian).
-UTF7	          : encodage pour le format UTF-7.
-UTF8	          : encodage pour le format UTF-8.
.
Pour une meilleure portabilité, l'utilisation de la valeur par défaut ('DefaultEncoding') est recommandé.    
"@
	ExpandZipEntryParametersExtractAction = 'Précise le comportement à adopter lorsque des données sont déjà présentes dans le répertoire de destination.'
	ExpandZipEntryParametersName = 'Nom des entrées à extraire.'
	ExpandZipEntryParametersPassword =  'Précise le mot de passe nécessaire à l''extraction des entrées contenues dans une archive encryptée.'
	ExpandZipEntryParametersStrict = 'Les erreurs déclenchent une exception au lieu d''être affichées.'
	ExpandZipEntryParametersXML = "L'objet de type string est renvoyé dans le format XML."
	ExpandZipEntryParametersZipFile =  'Objet contenant une archive Zip.'
	ExpandZipEntryInputsDescription1 = ''
	ExpandZipEntryOutputsDescriptionIonicZipZipEntry = ''
	ExpandZipEntryOutputsDescriptionSystemXmlXmlDocument = ''
	ExpandZipEntryOutputsDescriptionSystemString = ''
	ExpandZipEntryOutputsDescriptionSystemByte = '' 
	ExpandZipEntryNotes = 'Cette fonction est couplée à la fonction nommée Add-ZipEntry'
	ExpandZipEntryExamplesRemarks1 =@'
Ces instructions enregistrent dans un premier temps du texte dans une entrée nommée MyText, puis dans un second temps la relit et l'affecte à la variable $Text. 
'@
	ExpandZipEntryExamplesRemarks2 =@'
Ces instructions enregistrent dans un premier temps un objet sérialisé dans une entrée nommée 'PSVersiontable_clixml', puis dans un second temps la relit et l'affecte à la variable $MaTableDeVersion. 
'@
	ExpandZipEntryExamplesRemarks3 =@'
Ces instructions enregistrent dans un premier temps un tableau d'octets dans une entrée nommée MyArray, puis dans un second temps la relit et l'affecte à la variable $Array. 
'@
}


