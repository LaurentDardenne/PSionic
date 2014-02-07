# Expand-ZipEntry command data
$Datas = @{
	ExpandZipEntrySynopsis = 'Extrait des entrées d''une archive compressée au format Zip.'
	ExpandZipEntryDescription = @"
Extrait des entrées d'une archive compressée au format Zip, les données extraites sont des données sérialisées permettant de reconstruire un objet.
Pour extraire des fichiers d'une archive utilisez Expand-ZipFile.
"@
	ExpandZipEntrySetsByteArray = ''
	ExpandZipEntrySetsString = ''
	ExpandZipEntrySetsXML = ''
    ExpandZipEntryParametersAsHashTable= 'Renvoi les entrées lues dans un objet de type hashtable. Les noms des entrées à extraire seront utilisées en tant que nom de clé.'
    ExpandZipEntryParametersByte = "L'entrée est renvoyée en tant que tableau d'octest."	
    ExpandZipEntryParametersEncoding = 'Type d''encodage de l''archive. L''utilisation de la valeur par défaut est recommandée.'
	ExpandZipEntryParametersExtractAction = 'Précise le comportement à adopter lorsque des données sont déjà présentes dans le répertoire de destination.'
	ExpandZipEntryParametersName = 'Nom des entrées à extraire.'
	ExpandZipEntryParametersPassword =  'Précise le mot de passe nécessaire à l''extraction des entrées contenues dans une archive encryptée.'
	ExpandZipEntryParametersStrict = 'Les erreurs déclenchent une exception au lieu d''être affichées.'
	ExpandZipEntryParametersXML = "L'objet sérialisé est renvoyé dans son format XML d'origine."
	ExpandZipEntryParametersZipFile =  'Objet contenant une archive Zip.'
	ExpandZipEntryInputsDescription1 = ''
	ExpandZipEntryOutputsDescriptionIonicZipZipEntry = ''
	ExpandZipEntryOutputsDescriptionSystemXmlXmlDocument = ''
	ExpandZipEntryOutputsDescriptionSystemString = ''
	ExpandZipEntryOutputsDescriptionSystemByte = '' 
	ExpandZipEntryNotes = 'Cette fonction est couplée à la fonction nommée Add-ZipEntry'
	ExpandZipEntryExamplesRemarks1 = 'todo'
}


