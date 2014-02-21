# Expand-ZipFile command data
$Datas = @{
	ExpandZipFileSynopsis = 'Extrait des fichiers et/ou des répertoires depuis une archive compressée au format Zip.'
	ExpandZipFileDescription = 'La cmdlet Expand-ZipFile permet d''extraire des fichiers et/ou des répertoires depuis une archive compressée au format Zip.'
	ExpandZipFileSetsPath = 'Les noms de fichiers peuvent contenir des caractères jokers.'
	ExpandZipFileSetsLiteralPath = 'Les noms de fichiers ne doivent pas contenir de caractère joker.'
    ExpandZipFileParametersPath = @"
Nom du fichier Zip sous la forme d'un objet de type String ou System.IO.FileInfo.
Dans le cas où c'est un type String et si celle-ci contient des jokers, alors la liaison retardée (delayed script block) sur le paramètre -OutputPath 
ne se déclenchera qu'une seule fois, et pas pour chaque nom d'entrée résolue. En revanche la liaison retardée sera déclenchée pour chaque objet reçu. 
"@
    ExpandZipFileParametersLiteralPath = @"
Nom du fichier Zip sous la forme d'un objet de type String ou System.IO.FileInfo.
Dans le cas où c'est un type String celui-ci ne doit pas contenir de jokers. La liaison retardée (delayed script block) sur le paramètre -OutputPath 
ne se déclenchera qu'une seule fois. En revanche la liaison retardée sera déclenchée pour chaque objet reçu. 
"@
	ExpandZipFileParametersOutputPath = @"
Répertoire de destination utilisé lors de l'extraction des données contenues dans une archive Zip.
Ce paramètre peut utiliser la liaison retardée (delayed script block). 
"@
	ExpandZipFileParametersQuery = @"
Précise un critère de recherche pour les données à extraire de l'archive Zip.
Pour plus d'informations sur l'écriture et la syntaxe de la requête, consultez le fichier d'aide about_Query_Selection_Criteria ou la documentation de la dll Ionic (fichier d'aide .chm).
Attention, il n’y a pas de contrôle de cohérence sur le contenu de la query, par exemple celle-ci 'size <100 byte AND Size>1000 byte' ne provoquera pas d'erreur, mais aucun fichier ne sera sélectionné.
.
Si vous précisez également le paramètre -Passthru, une propriété personnalisé nommée 'Query' sera ajouté à l'objet renvoyé. 
"@
	ExpandZipFileParametersFrom = @"
Précise le répertoire de l'archive à partir duquel seront extrait les entrées. 
Un nom de répertoire dans une archive à la syntaxe suivante : 'NomRépertoire/' ou 'NomRépertoire/NomDeSousRépertoire/'.
.
L'usage de ce paramètre nécessite de préciser le paramètre -Query, sinon une exception sera déclenchée.
"@
	ExpandZipFileParametersExtractAction = 'Précise le comportement à adopter lorsque des données sont déjà présentes dans le répertoire de destination.'
    ExpandZipFileParametersPassword = 'Précise le mot de passe nécessaire à l''extraction d''une archive encryptée.'	
	ExpandZipFileParametersEncoding = 'Type d''encodage de l''archive. L''utilisation de la valeur par défaut est recommandée.'
	ExpandZipFileParametersFlatten = 'Les fichiers sont extrait sans arborescence.'
	ExpandZipFileParametersProgressID = @"
Lors de l'ouverture d'archive zip de grande taille, vous pouvez choisir d'afficher une barre de progression.
L'usage de ce paramètre crée une barre de progression pour les opérations de lecture, celle-ci sera remplacée lors des opérations d'extraction. 
La barre de progression pour les opérations de lecture n'affiche que le nombre d'entrées lues.
Si le paramètre -Query est précisé, alors la barre de progression d'extraction affichera uniquement les noms des fichiers extraits, sinon elle affichera le nom et le pourcentage de la progression.
.
Note : bien évidement la durée de la présence de la barre de progression à l'écran dépendra du nombre d'entrées présente dans l'archive.
"@
	ExpandZipFileParametersPassthru = 'Emet dans le pipeline les entrées contenues dans l''archive zip. Attention, dans ce cas la libération des ressources par l''appel à la méthode Close() est à votre charge.'
    ExpandZipFileParametersCreate = 'Crée le répertoire de destination si celui-ci n''existe pas.'	
	ExpandZipFileInputsDescription1 = 'En entrée des objets de type [String] ou des [Fileinfo]'
	ExpandZipFileOutputsDescription1 = ''
	ExpandZipFileNotes = @"
Une archive Zip peut en théorie contenir plusieurs entrées dont chacune a un mode de compression et/ou de cryptage différent des autres. 
Par contre, cette fonction suppose que le mot de passe est commun à toutes les entrées de l'archive, sinon une exception sera déclenchée lors du traitement du premier fichier possédant un mot de passe différent.
"@
	ExpandZipFileExamplesRemarks1 = 'Extrait les données contenues dans une archive Zip vers un répertoire de destination.'
    ExpandZipFileExamplesRemarks2 = 'Extrait les données d''une archive Zip dans un répertoire de destination. L''usage du paramètre -Create force la création du répertoire cible s''il n''existe pas.'
    ExpandZipFileExamplesRemarks3 = @"
Extrait les données contenues dans des archives Zip vers un répertoire de destination.
Lors de l'extraction, la première collision de nom de fichier déclenchera une exception, car le paramètre -ErrorAction a par défaut la valeur 'Throw'. 
"@
    ExpandZipFileExamplesRemarks4 = @"
Extrait les données contenues dans des archives Zip vers un répertoire de destination.
Lors de l'extraction, l'usage de la valeur 'OverwriteSilently' pour le paramètre -ErrorAction déclenchera des erreurs simples lors des possibles collisions de noms de fichier. 
"@
    ExpandZipFileExamplesRemarks5 = @"
Extrait les données contenues dans une archive Zip vers un répertoire de destination.
Seules les données correspondantes à la requête sont extraites, ici les fichiers dont l'extension est '.jpg'.
 "@
    ExpandZipFileExamplesRemarks6 = @"
Extrait les données contenues dans une archive Zip vers un répertoire de destination.
Seules les données correspondantes à la requête sont extraites, ici uniquement les répertoires.
"@
    ExpandZipFileExamplesRemarks7 = @"
Extrait les données contenues dans une archive Zip vers un répertoire de destination.
Le suivi de l'extraction est affiché dans une barre de progression.
"@
    ExpandZipFileExamplesRemarks8 = @"
La première ligne d'instruction extrait toutes les archives dans le nouveau répertoire C:\Temp\TestZip.
Ici le delayed script block ou liaison retardée de script block, est déclenché une seule fois, car la fonction Expand-ZipFile ne reçoit qu'un seul objet.
De plus l'objet émit étant une chaîne de caractères et pas un fichier, fait que la propriété BaseName sur l'objet courant n'existe pas.
Les chaînes de caractères représentant des fichiers, sont transformées en interne, bien après le déclenchement de la liaison retardée de script block.    
.
La seconde ligne d'instruction extrait chaque archive dans un nouveau répertoire dont la racine sera C:\Temp\TestZip.
Ici le delayed script block est déclenché plusieurs fois, car la fonction Expand-ZipFile reçoit plusieurs objets, tous de type fichier.
Ainsi ces instructions créeront les répertoires 'C:\Temp\TestZip\Archive1','C:\Temp\TestZip\Archive2', 'C:\Temp\TestZip\ArchiveN'...  
"@
    ExpandZipFileExamplesRemarks9 = @"
Cet exemple extrait tous les fichiers '.dll' contenu dans le répertoire 'Bin/V2/' de l'archive, dans le répertoire 'C:\Temp\ExtractArchive'.
Le paramètre -Flatten indique d'extraire tous les fichiers à la racine du répertoire indiqué, l'arborescence existante dans l'archive n'est pas recréé.  
Le paramètre -Verbose affiche les toutes entrées lues, puis celles extraites.
Le paramètre -passthru récupère l'instance de l'archive, ce qui permet de continuer de travailler sur l'archive. 
Une fois les traitements terminés, on libère explicitement l'instance de l'objet archive, ce qui déverrouillera le fichier.
"@
}
