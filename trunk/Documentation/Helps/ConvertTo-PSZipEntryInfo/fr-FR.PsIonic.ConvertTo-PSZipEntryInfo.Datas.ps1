# ConvertTo-PSZipEntryInfo command data
$Datas = @{
	ConvertToPSZipEntryInfoSynopsis = 'Converti la propriété Info d''un objet de type ZipFile ou ZipEntry.'
	ConvertToPSZipEntryInfoDescription = 'Converti la propriété Info d''un objet de type ZipFile en une liste d''objets personnalisés ou d''un objet de type ZipEntry/PSZipEntry en un objet personnalisé.'
	ConvertToPSZipEntryInfoSets__AllParameterSets = ''
	ConvertToPSZipEntryInfoParametersInfo = 'Contenu d''une propriété Info d''un objet Ionic.'
	ConvertToPSZipEntryInfoInputsDescription1 = ''
	ConvertToPSZipEntryInfoOutputsDescription1 = 'Son typename est PSZipEntryInfo.'
	ConvertToPSZipEntryInfoNotes = @"
La transformation de la propriété Info de type texte en plusieurs objets prend un certain temps.
Eviter de transformer plusieurs fois cette propriété au sein d'une boucle.
Soyez attentif au fait qu'une instance peut évoluer par l'ajout ou la suppression d'entrée, dans ce cas vous devrez mettre à jour ce champ(ZipEntry/PSZipEntry) ou reconstruire la liste (ZipFile).
"@
	ConvertToPSZipEntryInfoExamplesRemarks1 = @"
Cet exemple récupère d'une archive la liste des entrées, celles-ci sont des objets personnalisé Powershell.
Puis la propriété Info, qui est par défaut de type string, est transformée en un PSObject et celui-ci est réaffecté au contenu de la propriété Info.
L'information initiale de type string n'est plus accessible.    
"@
	ConvertToPSZipEntryInfoExamplesRemarks2 = @'
Cet exemple récupère une archive, puis sa propriété Info est transformée en une liste indexé d'objets de type PSZipEntryInfo.
Puis on ajoute une nouvelle entrée à l'archive et on reconstruit la liste de PSZipEntryInfo, cette fois à partir de l'information initiale accessible via $Zip.psbase.Info.
'@
}


