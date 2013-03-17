# ConvertTo-Sfx command data
$Datas = @{
	ConvertToSfxSynopsis = 'Convertit une archive .ZIP en une archive autoextractible.'
	ConvertToSfxDescription = @"
La conversion d'une archive .ZIP en une archive autoextractible intégre dans le fichier généré le traitement de décompression.
Vous pouvez également préciser une ligne de commande à exécuter une fois la décompression de tous les fichiers terminée.     
"@
	ConvertToSfxSets__AllParameterSets = ''
	ConvertToSfxParametersComment = 'Commentaire associé à l''archive.'
	ConvertToSfxParametersName = 'Nom du fichier .zip a convertir.'
	ConvertToSfxParametersSaveOptions = 'Options de génération créées via la fonction New-ZipSfxOptions.'
    ConvertToSfxParametersReadOptions = 'Options appliquées lors de la lecture de l''archive (.zip) à partir de laquelle on génére une archive autoexetractible (.exe). Options créées via la fonction New-ReadOptions.'
	ConvertToSfxParametersPassthru = 'Renvoi le fichier généré sous forme d''objet et pas seulement son nom.'
	ConvertToSfxParametersZipFile = 'Nom du fichier de l''archive à convertir.'
	ConvertToSfxInputsDescription1 = @"
System.Management.Automation.PSObject

Vous pouvez émettre n'importe quel objet dans le pipeline, sous réserve que sa tranformation en un type String contienne un nom de fichier.
"@
	ConvertToSfxOutputsDescriptionSystemIOFileInfo = @"
Aucun ou System.IO.FileInfo
 
Lorsque vous utilisez le paramètre PassThru, ConvertTo-Sfx renvoi l'objet fichier de l'archive autoextractible. Sinon cette fonction ne génére aucune sortie.
"@ 
	ConvertToSfxNotes = @"
La présence du framework dotnet 2.0 est nécessaire pour exécuter le fichier .exe de l’archive autoextractible.
Le répertoire précisé par la paramètre 'ExtractDirectory' (cf. New-ZipSfxOptions) peut contenir des références de variable système.
Par exemple %UserProfile%, celles-ci seront substituées lors de l'exécution de l’archive autoextractible.

Attention, il n'est pas possible d'enregistrer une archive splittée dans une archive autoextractible.
"@
	ConvertToSfxExamplesRemarks1 = ''
}
