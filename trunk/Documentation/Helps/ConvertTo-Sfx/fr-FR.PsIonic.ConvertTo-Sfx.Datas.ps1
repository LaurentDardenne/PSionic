# ConvertTo-Sfx command data
$Datas = @{
	ConvertToSfxSynopsis = 'Convertit une archive .ZIP en une archive auto extractible.'
	ConvertToSfxDescription = @"
La conversion d'une archive .ZIP en une archive auto extractible intègre dans le fichier généré le traitement de décompression.
Vous pouvez également préciser une ligne de commande à exécuter une fois la décompression de tous les fichiers terminée.     
"@
	ConvertToSfxSets__AllParameterSets = ''
	ConvertToSfxParametersComment = 'Commentaire associé à l''archive.'
	ConvertToSfxParametersPath = 'Nom du fichier .zip à convertir.'
	ConvertToSfxParametersLiteralPath = @"
Nom du fichier .zip à convertir. Celui-ci est traité tel quel, c'est-à-dire que les caractères génériques ne sont pas interprétés. 
"@
	ConvertToSfxParametersSaveOptions = 'Options de génération créées via la fonction New-ZipSfxOptions.'
    ConvertToSfxParametersReadOptions = 'Options appliquées lors de la lecture de l''archive (.zip) à partir de laquelle on génère une archive auto extractible (.exe). Options créées via la fonction New-ReadOptions.'
	ConvertToSfxParametersPassthru = @"
Renvoi le fichier généré sous forme d'objet et pas seulement son nom. 
L'objet archive renvoyé n'étant pas verrouillé, soyez attentif à vos scénarios d'usage de cet objet.    
"@
	ConvertToSfxInputsDescription1 = @"
Vous pouvez émettre n'importe quel objet dans le pipeline, sous réserve que sa tranformation en un type String soit un nom de fichier.
"@
	ConvertToSfxOutputsDescriptionNone="Par défaut ne renvoi pas d'objet"
    ConvertToSfxOutputsDescriptionSystemIOFileInfo = @"
Lorsque vous utilisez le paramètre PassThru, ConvertTo-Sfx renvoi l'objet fichier de l'archive auto extractible. Sinon cette fonction ne génére aucune sortie.
"@ 
	ConvertToSfxNotes = @"
La présence du framework dotnet 2.0 est nécessaire sur le poste exécutant la décompression de l’archive auto extractible.
Le répertoire précisé par le paramètre 'ExtractDirectory' (cf. New-ZipSfxOptions) peut contenir des références de variable système.
Par exemple %UserProfile%. Celles-ci seront substituées lors de l'exécution de l’archive auto extractible.

Attention, il n'est pas possible d'enregistrer une archive splittée dans une archive auto extractible.
"@
	ConvertToSfxExamplesRemarks1 = @'
Ces instructions créent, à l'aide de la fonction New-ZipSfxOptions, le paramétrage qui sera utilisé lors de la construction de l'archive auto extractible.
Enfin, on convertit un fichier d'archive .Zip en un fichier d'archive auto extractible .Exe.
La variable $ReadOptions paramètre l'affichage de la progression du traitement sur la console. 
'@ 
}
