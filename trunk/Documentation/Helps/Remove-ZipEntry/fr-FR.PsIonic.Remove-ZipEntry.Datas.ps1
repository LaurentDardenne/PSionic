# Remove-ZipEntry command data
$Datas = @{
	RemoveZipEntrySynopsis = 'Supprime une ou des entrées d''une archive'
	RemoveZipEntryDescription = 'Supprime une ou des entrées d''une archive'
	RemoveZipEntrySetsName = ''
	RemoveZipEntrySetsQuery = ''
	RemoveZipEntryParametersFrom = @"
Précise le répertoire de l'archive dans lequel seront supprimé les entrées. 
Un nom de répertoire dans une archive à la syntaxe suivante : 'NomRépertoire/' ou 'NomRépertoire/NomDeSousRépertoire/'.
.
L'usage de ce paramètre nécessite de préciser le paramètre -Query, sinon une exception sera déclenchée.
"@
 
	RemoveZipEntryParametersInputObject = @"
todo  en cours de dev
Contenu associé à une entrée d'archive. Les types attendus sont : 
   - Un ou des objets fichiers ou répertoires,
   - un nom ou des noms de fichier ou de répertoire,
   - une chaîne de caractères,
   - ou un tableau d'octets.
Tous les autres types d'objet seront transformés en chaîne de caractères via la méthode ToString().   
"@
	RemoveZipEntryParametersName = @"
todo  en cours de dev
Chaque entrée d'archive est associèe à un nom dans le catalogue. Pour les fichiers ou les répertoires, leurs nom sont automatiquement utilisés comme nom d'entrée à la racine de l'archive.
.
Pour les chaînes de caractères ou les tableaux d'octets, vous devez préciser un nom d'entrée. L'usage du paramètre -EntryPathRoot n'influencera pas ce nommage.
"@	
	RemoveZipEntryParametersQuery = @"
Précise un critère de recherche pour les données à supprimer de l'archive Zip.
Pour plus d'informations sur l'écriture et la syntaxe de la requête, consultez le fichier d'aide about_Query_Selection_Criteria ou la documentation de la dll Ionic (fichier d'aide .chm).
Attention, il n’y a pas de contrôle de cohérence sur le contenu de la query, par exemple celle-ci 'size <100 byte AND Size>1000 byte' ne provoquera pas d'erreur, mais aucun fichier ne sera sélectionné.
"@
	RemoveZipEntryParametersZipFile = 'Archive cible dans laquelle on supprime la ou les entrées précisées. Ce paramètre attend un objet de type ZipFile et pas un nom de fichier.'
	RemoveZipEntryInputsDescription1 = ''
	RemoveZipEntryOutputsDescriptionSystemManagementAutomationPSObject = ''
	RemoveZipEntryNotes = 'todo  en cours de dev'
	RemoveZipEntryExamplesRemarks1 = 'todo  en cours de dev'
}


