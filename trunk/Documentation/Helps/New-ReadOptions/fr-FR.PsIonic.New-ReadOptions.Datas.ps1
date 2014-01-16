# New-ReadOptions command data
$Datas = @{
	NewReadOptionsSynopsis = 'Crée un objet contenant les différentes options pouvant être utilisées lors de la lecture d''une archive Zip.'
	NewReadOptionsDescription = 'Il est possible de préciser différent comportement lors de la lecture d''une archive Zip  '
	NewReadOptionsSets__AllParameterSets = ''
	NewReadOptionsParametersEncoding = 'Précise l''encodage à utiliser lors de la lecture des entrées contenues dans l''archive. L''utilisation de la valeur par défaut est recommandée.'
	NewReadOptionsParametersFollow = @"
L'usage de ce paramètre crée un gestionnaire d'événements pour les opérations de lecture. 
Lors de l'ouverture d'archive zip de grande taille, vous pouvez choisir d'afficher une barre de progression. 
"@ #TODO
	NewReadOptionsInputsDescription1 = ''
	NewReadOptionsOutputsDescriptionIonicZipReadOptions = 'Ionic.Zip.ReadOptions'
	NewReadOptionsNotes = @"
Concernant l'usage de l'encodage, consultez l'aide de la dll Ionic.
 
Si le paramètre -Verbose est précisé alors cette objet d'option est configurée avec une instance de la classe PSIonicTools.PSVerboseTextWriter.
La dll Ionic l'utilise pour afficher des messages supplémentaires lors d'opérations sur une archive zip. 
La présence du paramètre Verbose impose donc sa libération implicite via un apppel à PSDispose sur l'archive ciblée par cette objet d'options.
"@
	NewReadOptionsExamplesRemarks1 = 'Cet exemple crée un objet option de lecture avec les valeurs par défaut.'
    NewReadOptionsExamplesRemarks2 = 'Cet exemple crée un objet option de lecture avec une valeur d''encodage par défaut et un PSVerboseTextWriter pour des affichages supplémentaires.'
    NewReadOptionsExamplesRemarks3 = 'Cet exemple crée un objet option de lecture vec une valeur d''encodage par défaut et une barre de progression.'
}


