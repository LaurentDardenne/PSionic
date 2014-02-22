# Add-ZipEntry command data
$Datas = @{
	AddZipEntrySynopsis = 'Ajoute une entrée dans le catalogue d''une archive Zip existante.'
	AddZipEntryDescription = 'Ajoute une entrée dans le catalogue d''une archive .ZIP ou d''une archive auto extractible .EXE, cette entrée peut être un nom de fichier ou de répertoire, une chaîne de caractères ou un tableau d''octets.'
	AddZipEntrySets__AllParameterSets = ''
    AddZipEntryParametersComment = 'Commentaire associé à l''entrée. Pour les entrées de type string ou tableau, par défaut leur champ contiendra le nom de leur type : [String] ou [Byte[]].' 
	AddZipEntryParametersEntryPathRoot = @"
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
	AddZipEntryParametersName = @"
Chaque entrée d'archive est associèe à un nom dans le catalogue. Pour les fichiers ou les répertoires, leurs nom sont automatiquement utilisés comme nom d'entrée à la racine de l'archive.
.
Pour les chaînes de caractères ou les tableaux d'octets, vous devez préciser un nom d'entrée. L'usage du paramètre -EntryPathRoot n'influencera pas ce nommage.
"@	
    AddZipEntryParametersInputObject = @"
Contenu associé à une entrée d'archive. Les types attendus sont : 
   - Un ou des objets fichiers ou répertoires,
   - un nom ou des noms de fichier ou de répertoire,
   - une chaîne de caractères,
   - ou un tableau d'octets.
Tous les autres types d'objet seront transformés en chaîne de caractères via la méthode ToString().   
"@
    AddZipEntryParametersPassthru = 'Une fois l''entrée ajoutée au catalogue de l''archive, elle est émise dans le pipeline.'
	AddZipEntryParametersZipFile = 'Archive cible dans laquelle on ajoute l''entrée précisée. Ce paramètre attend un objet de type ZipFile et pas un nom de fichier.'
	AddZipEntryInputsDescription1 = @"
System.Byte[], System.String, System.IO.DirectoryInfo, System.IO.FileInfo, Ionic.Zip.ZipEntry.
Vous pouvez émettre n'importe quel objet des types précédents dans le pipeline.
"@
	AddZipEntryOutputsDescriptionIonicZipZipEntry = 'Ionic.Zip.ZipEntry'
	AddZipEntryNotes = @"
Par défaut l'ajout d'une entrée existante déclenchera une exception.
Cette fonction est couplée à la fonction nommée Expand-ZipEntry.
"@
	AddZipEntryExamplesRemarks1 = @"
Ces commandes ajoutent une entrée dans l'archive C:\Temp\Test.zip. 
  -La première instruction crée un objet archive à partir d'un nom de fichier, 
  -la seconde crée un objet fichier à partir d'un nom de fichier, 
  -la troisième ajoute le fichier dans l'archive, 
  -la quatrième enregistre l'archive sur le disque et libère les ressources systèmes.  
"@
    AddZipEntryExamplesRemarks2 = @"
Ces commandes ajoutent des entrées dans l'archive C:\Temp\Test.zip. 
  -La première instruction crée un objet archive à partir d'un nom de fichier, 
  -la seconde, depuis le répertoire courant, ajoute dans l'archive tous les fichiers portant l'extension .txt, 
  -la troisième enregistre l'archive sur le disque et libère les ressources systèmes.
"@        
    AddZipEntryExamplesRemarks3 = @"
Ces commandes ajoutent, à partir d'une chaîne de caractères, une entrée nommée dans l'archive C:\Temp\Test.zip. 
  -La première instruction crée un objet archive à partir d'un nom de fichier, 
  -la seconde lit un fichier texte et récupère le résultat dans une chaîne de caractères,
  -la troisième crée une entrée dont le contenu est renseigné à partir d'une chaîne de caractères, 
  -la quatrième enregistre l'archive sur le disque et libère les ressources systèmes.
"@  
    AddZipEntryExamplesRemarks4 = @'
Ces commandes ajoutent, à partir d'un objet sérialisé, une entrée nommée dans l'archive C:\Temp\Test.zip. 
  -La première instruction crée un objet archive à partir d'un nom de fichier, 
  -la seconde sérialise l'objet contenu dans la variable $PSVersiontable et l'ajoute en tant qu'entrée nommée dans l'archive, 
  -la troisième enregistre l'archive sur le disque et libère les ressources systèmes.
'@  
    AddZipEntryExamplesRemarks5 =@'
Ces commandes ajoutent une entrée nommée MyArray dans l'archive C:\Temp\Test.zip. 
  -La première instruction crée un objet archive à partir d'un nom de fichier, 
  -la seconde ajoute l'objet contenu dans la variable $Array et l'ajoute dans l'archive en tant qu'entrée nommée MyArray, 
  -la troisième enregistre l'archive sur le disque et libère les ressources systèmes.  
'@
}


