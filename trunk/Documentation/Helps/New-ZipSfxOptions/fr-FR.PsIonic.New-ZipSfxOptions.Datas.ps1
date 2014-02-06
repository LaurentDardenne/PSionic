﻿# New-ZipSfxOptions command data
$Datas = @{
	NewZipSfxOptionsSynopsis = 'Crée un objet configuration utilisée lors de la construction d''une archive autoextractible.'
	NewZipSfxOptionsDescription = 'Crée un objet configuration utilisée lors de la construction d''une archive autoextractible.'
	NewZipSfxOptionsSetsCmdLine = 'L''archive autoextractible est encapsuléee dans un programme console (CLI).'
	NewZipSfxOptionsSetsGUI = 'L''archive autoextractible est encapsuléee dans un programme Winform (GUI).'
	NewZipSfxOptionsParametersAdditionalCompilerSwitches = 'Options supplémentaires utilisées lors de la génération de l''exécutable dotNET.'
	NewZipSfxOptionsParametersCmdLine = 'Précise que l''archive autoextractible est basée sur un programme console (CLI).'
	NewZipSfxOptionsParametersCopyright = 'Notice de copyright ou de copyleft.'
	NewZipSfxOptionsParametersDescription = 'Décrit l''usage de l''archive autoextratible.'
	NewZipSfxOptionsParametersExeOnUnpack = 'Précise le programme, et ses paramètres, à exécuter une fois que de tous les fichiers contenus dans l''archive ont été décompressés.'
	NewZipSfxOptionsParametersExtractDirectory = @"
Indique le répertoire de décompression par défaut. Il peut contenir des références de variable système, par exemple %UserProfile%. 
Celles-ci seront substituées lors de l'exécution de l’archive autoextractible.
"@
	NewZipSfxOptionsParametersExtractExistingFile = 'Indication de comportement en cas d''existence des fichiers dans le répertoire ciblé.'
	NewZipSfxOptionsParametersFileVersion = 'Numéro de version du fichier autoextractible.'
	NewZipSfxOptionsParametersGUI = 'Précise que l''archive autoextractible est basée sur un programme Winform (GUI).'
	NewZipSfxOptionsParametersIconFile = 'Nom d''un fichier contenant un icon à associer à la Winform.'
	NewZipSfxOptionsParametersNameOfProduct = 'Nom du produit contenu dans l''archive autoextractible.'
	NewZipSfxOptionsParametersQuiet = 'Quitte le programme une fois la décompression achevée.'
	NewZipSfxOptionsParametersRemove = 'Supprime en fin de traitement tous les fichiers extraits de l''archive.'
	NewZipSfxOptionsParametersVersionOfProduct = 'Numéro de version du produit contenu dans l''archive.'
	NewZipSfxOptionsParametersWindowTitle = 'Titre de la Winform.'
	NewZipSfxOptionsInputsDescription1 = 'Aucune'
	NewZipSfxOptionsOutputsDescriptionIonicZipSelfExtractorSaveOptions = 'Ionic.Zip.SelfExtractorSaveOptions'
	NewZipSfxOptionsNotes = 'Pour les paramètres de type string tous les caractères espaces sont supprimés en début ou en fin de chaîne.'
	NewZipSfxOptionsExamplesRemarks1 = 'Cette instruction crée une configuration SFX avec les valeurs par défaut sauf pour le champ Copyright.'
	NewZipSfxOptionsExamplesRemarks2 = 'Cette instruction crée une configuration SFX et l''affecte à la configuration par défaut.'
}


