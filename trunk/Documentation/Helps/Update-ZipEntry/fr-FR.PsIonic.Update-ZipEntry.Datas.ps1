# Update-ZipEntry command data
$Datas = @{
	UpdateZipEntrySynopsis = 'Met à jour une archive .ZIP ou une archive auto extractible .EXE.'
	UpdateZipEntryDescription = 'Met à jour une archive .ZIP, ou une archive auto extractible .EXE, en modifiant ses entrées ou en lui en ajoutant de nouvelles.'
	UpdateZipEntrySets__AllParameterSets = ''
	UpdateZipEntryParametersComment =  'Commentaire associé à l''entrée. Pour les entrées de type string ou tableau, par défaut leur champ contiendra le nom de leur type : [String] ou [Byte[]].'
	UpdateZipEntryParametersEntryPathRoot = @"
La nouvelle entrée sera ajoutée dans un répertoire spécifique. Par défaut elle est ajoutée à la racine de l'arborescence contenue dans l'archive. 
La valeur de ce paramètre doit référencer un répertoire existant.

Pour éviter les collisions de nom d'entrée lors de la compression récursive d'une arborescence vous devrez utiliser ce paramètre.
Celui-ci permet de construire le nom de l'entrée relativement au nom de répertoire spécifié.

Par exemple en précisant 'C:\Temp\Backup', lors de la compression récursive de 'C:\Temp\Backup' le traitement de construction du nom d'entrée retranchera 'C:\Temp\Backup' à chaque nom de fichier reçus.
Donc, pour les fichiers 'C:\Temp\Backup\File1.ps1' et 'C:\Temp\Backup\Projet\File1.ps1' les entrées créées dans le catalogue seront respectivement:
File1.ps1
Projet/File.ps1   
.
De préciser un nom de répertoire différent de celui d'où débute l'archivage déclenchera une erreur et stoppera l'archivage du path en cours.
"@
	UpdateZipEntryParametersInputObject = @"
Contenu associé à une entrée d'archive. Les types attendus sont : 
   - Un ou des objets fichiers ou répertoires,
   - un nom ou des noms de fichier ou de répertoire,
   - une chaîne de caractères,
   - ou un tableau d'octets.
Tous les autres types d'objet seront transformés en chaîne de caractères via la méthode ToString().   
"@
	UpdateZipEntryParametersName = @"
Chaque entrée d'archive est associée à un nom dans le catalogue. Pour les fichiers ou les répertoires, leurs noms sont automatiquement utilisés comme nom d'entrée à la racine de l'archive.

Pour les chaînes de caractères ou les tableaux d'octets, vous devez préciser un nom d'entrée. L'usage du paramètre -EntryPathRoot n'influencera pas ce nommage.
"@	
	UpdateZipEntryParametersPassthru =  'Une fois l''entrée mise à jour dans le catalogue de l''archive, elle est émise dans le pipeline.'
	UpdateZipEntryParametersZipFile = 'Archive cible dans laquelle on met à jour l''entrée précisée. Ce paramètre attend un objet de type ZipFile et pas un nom de fichier.'
	UpdateZipEntryInputsDescription1 = "Tous les autres types d'objet seront transformés en chaîne de caractères via la méthode ToString()."
	UpdateZipEntryOutputsDescriptionIonicZipZipEntry = "Le ou les objets retournés sont les entrées modifiées dans l'archive."
	UpdateZipEntryNotes =  @"
Si une entrée existe déjà, elle est mise à jour. La propriété LastModified est renseignée avec la date et l'heure courante.
La mise à jour d'une entrée de type directory ne fait qu'ajouter les nouveaux éléments, mais ne supprime pas les entrées qui ne sont plus sur le FileSystem. Ce n'est pas une synchronisation.
Par défaut l'ajout d'une entrée existante déclenchera une exception.
"@
	UpdateZipEntryExamplesRemarks1 = @"
Ces commandes mettent à jour une entrée dans l'archive C:\Temp\Test.zip. 
  -La première instruction crée un objet archive à partir d'un nom de fichier, 
  -la seconde crée un objet fichier à partir d'un nom de fichier, 
  -la troisième met à jour le fichier dans l'archive, 
  -la quatrième enregistre l'archive sur le disque et libère les ressources systèmes.  
"@
    UpdateZipEntryExamplesRemarks2 = @"
Ces commandes mettent à jour des entrées dans l'archive C:\Temp\Test.zip. 
  -La première instruction crée un objet archive à partir d'un nom de fichier, 
  -la seconde, depuis le répertoire courant, met à jour toutes les entrées de l'archive correspondant aux noms de fichier *.txt, 
  -la troisième enregistre l'archive sur le disque et libère les ressources systèmes.
"@        
    UpdateZipEntryExamplesRemarks3 = @"
Ces commandes mettent à jour, à partir d'une chaîne de caractères, une entrée nommée dans l'archive C:\Temp\Test.zip. 
  -La première instruction crée un objet archive à partir d'un nom de fichier, 
  -la seconde lit un fichier texte et récupère le résultat dans une chaîne de caractères,
  -la troisième met à jour ou crée une entrée dont le contenu est renseigné à partir d'une chaîne de caractères, 
  -la quatrième enregistre l'archive sur le disque et libère les ressources systèmes.
"@  
    UpdateZipEntryExamplesRemarks4 = @'
Ces commandes mettent à jour, à partir d'un objet sérialisé, une entrée nommée dans l'archive C:\Temp\Test.zip. 
  -La première instruction crée un objet archive à partir d'un nom de fichier, 
  -la seconde sérialise l'objet contenu dans la variable $PSVersiontable, puis met à jour ou crée l'entrée nommée dans l'archive, 
  -la troisième enregistre l'archive sur le disque et libère les ressources systèmes.
.
Par convention, vous pouvez postfixer vos noms d'entrée sérialisé par '_clixml'.
'@  
    UpdateZipEntryExamplesRemarks5 =@'
Ces commandes mettent à jour une entrée nommée MyArray dans l'archive C:\Temp\Test.zip. 
  -La première instruction crée un objet archive à partir d'un nom de fichier, 
  -la seconde ajoute l'objet contenu dans la variable $Array, puis met à jour ou crée l'entrée nommée MyArray, 
  -la troisième enregistre l'archive sur le disque et libère les ressources systèmes.  
'@
}


