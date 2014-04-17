# ConvertTo-CliXml command data
$Datas = @{
	ConvertToCliXmlSynopsis = 'Crée une représentation XML d''un ou de plusieurs objets et l''émet dans le pipeline.'
	ConvertToCliXmlDescription = @"
Vous pouvez émettre le résultat de cette fonction vers les fonctions Add-ZipEntry et Update-ZipEntry.
"@
	ConvertToCliXmlSets__AllParameterSets = ''
	ConvertToCliXmlParametersInputObject = 'Spécifie l''objet à convertir.'
	ConvertToCliXmlInputsDescription1 = ''
	ConvertToCliXmlOutputsDescription1 = ''
	ConvertToCliXmlNotes = 'L''enregistrement de la représentation XML est compatible avec le cmdlet Export-CliXml.'
	ConvertToCliXmlExamplesRemarks1 = @'
Ces commandes ajoutent, à partir d'un objet sérialisé, une entrée nommée dans l'archive C:\Temp\Test.zip. 
  -La première instruction crée un objet archive à partir d'un nom de fichier, 
  -la seconde sérialise l'objet contenu dans la variable $PSVersiontable et l'ajoute en tant qu'entrée nommée dans l'archive, 
  -la troisième enregistre l'archive sur le disque et libère les ressources systèmes.
'@ 
}


