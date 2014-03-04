# Remove-ZipEntry command data
$Datas = @{
	RemoveZipEntrySynopsis = 'Supprime une ou des entrées d''une archive'
	RemoveZipEntryDescription = 'Supprime une ou des entrées d''une archive .ZIP ou d''une archive auto extractible .exe.'
	RemoveZipEntrySetsName = ''
	RemoveZipEntrySetsQuery = ''
	RemoveZipEntryParametersFrom = @"
Précise le répertoire de l'archive dans lequel seront supprimé les entrées. 
Un nom de répertoire dans une archive à la syntaxe suivante : 'NomRépertoire/' ou 'NomRépertoire/NomDeSousRépertoire/'.

L'usage de ce paramètre nécessite de préciser le paramètre -Query, sinon une exception sera déclenchée.
"@
 
	RemoveZipEntryParametersInputObject = @"
Contenu associé à une entrée d'archive. Les types attendus sont : 
   - Un ou des objets de type fichiers ou de type répertoires,
   - une chaîne de caractères référençant une entrée, si celle-ci référence un nom de répertoire, elle doit se terminer par le caractére '/',
   - un objet de type ZipEntry,
   - un tableau d'objet de type ZipEntry,
   - un tableau de String ou d'Object, dans ce dernier cas son contenu sera transformé en String.
Tous les autres type de tableaux, autres que ceux indiqué ci-dessus, déclencheront une erreur.
Pour tous les autres types d'objet, ils seront convertis en chaîne de caractères.   
"@
	RemoveZipEntryParametersName = @"
Chaque entrée d'archive est associèe à un nom dans le catalogue. Pour les fichiers ou les répertoires, leurs noms sont automatiquement utilisés comme nom d'entrée à la racine de l'archive.
"@	
	RemoveZipEntryParametersQuery = @"
Précise un critère de recherche pour les données à supprimer de l'archive Zip.
Pour plus d'informations sur l'écriture et la syntaxe de la requête, consultez le fichier d'aide about_Query_Selection_Criteria ou la documentation de la dll Ionic (fichier d'aide .chm).
Attention, il n’y a pas de contrôle de cohérence sur le contenu de la query, par exemple celle-ci 'size <100 byte AND Size>1000 byte' ne provoquera pas d'erreur, mais aucun fichier ne sera sélectionné.
"@
	RemoveZipEntryParametersZipFile = 'Archive cible dans laquelle on supprime la ou les entrées précisées. Ce paramètre attend un objet de type ZipFile et pas un nom de fichier.'
	RemoveZipEntryInputsDescription1 = ''
	RemoveZipEntryOutputsDescriptionSystemManagementAutomationPSObject = ''
	RemoveZipEntryNotes = ''
	RemoveZipEntryExamplesRemarks1 = 'Ces instructions suppriment, si elle existe, l''entrée ''Test.ps1'' à la racine du fichier Test.zip'
    RemoveZipEntryExamplesRemarks2 = 'Ces instructions suppriment, si elle existe, l''entrée ''Test.ps1'' à la racine du fichier Test.zip'
    RemoveZipEntryExamplesRemarks3 = 'Ces instructions suppriment, si elles existent, les entrées ''Test.ps1'' et ''Setup.ps1'', contenues dans le tableau de chaîne de caractères $Tab, à la racine du fichier Test.zip'
    RemoveZipEntryExamplesRemarks4 = @"
 Ces instructions suppriment à la racine du fichier Test.zip et si elles existent :
 - l'entrée 'Test.ps1',
 - toutes les entrées se terminant par '.XML' et
 - tous les noms d'entrée contenus dans le fichier 'C:\Temp\ListeFileName.txt'.
"@
    RemoveZipEntryExamplesRemarks5 =@"
Ces instructions, à l'aide d'une requête, suppriment toutes les entrées se terminant par '.TXT' à la racine du fichier Test.zip'    
"@
    RemoveZipEntryExamplesRemarks6 =@"
Ces instructions, à l'aide d'une requête, suppriment toutes les entrées se terminant par '.TXT' dans le répertoire 'Doc/' du fichier Test.zip'    
"@ 
    
}


