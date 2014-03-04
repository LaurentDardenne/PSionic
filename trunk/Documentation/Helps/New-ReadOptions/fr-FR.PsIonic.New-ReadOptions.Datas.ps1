# New-ReadOptions command data
$Datas = @{
	NewReadOptionsSynopsis = 'Crée un objet contenant les différentes options pouvant être utilisées lors de la lecture d''une archive Zip.'
	NewReadOptionsDescription = 'Il est possible de préciser différent comportement lors de la lecture d''une archive Zip  '
	NewReadOptionsSets__AllParameterSets = ''
	NewReadOptionsParametersEncoding = @"
Type d'encodage de l'archive. Les valeurs possibles sont :
-ASCII	          : encodage pour le jeu de caractères ASCII (7 bits).
-BigEndianUnicode : encodage pour le format UTF-16 qui utilise l'ordre d'octet avec primauté des octets de poids fort (big-endian).
-Default	      : encodage pour la page de codes ANSI actuelle du système d'exploitation.
-Unicode	      : encodage pour le format UTF-16 avec primauté des octets de poids faible (little-endian).
-UTF32	          : encodage pour le format UTF-32 avec primauté des octets de poids faible (little-endian).
-UTF7	          : encodage pour le format UTF-7.
-UTF8	          : encodage pour le format UTF-8.
.
A moins d'être assuré que celui sélectionné corresponde à celui utilisé lors de la compression de l'archive, l'utilisation de la valeur par défaut ('DefaultEncoding') est recommandé, 
"@
	NewReadOptionsParametersProgressBarInformations = @"
L'usage de ce paramètre crée un gestionnaire d'événements pour les opérations de lecture. 
Lors de l'ouverture d'archive zip de grande taille, vous pouvez choisir d'afficher une barre de progression. 
L'objet passé en paramètre est construit à l'aide de fonction New-ProgressBarInformations.
"@
	NewReadOptionsInputsDescription1 = ''
	NewReadOptionsOutputsDescriptionIonicZipReadOptions = 'Ionic.Zip.ReadOptions'
	NewReadOptionsNotes = @"
Concernant l'usage de l'encodage, consultez l'aide de la dll Ionic.
 
Si le paramètre -Verbose est précisé, alors cet objet d'options est configuré avec une instance de la classe PSIonicTools.PSVerboseTextWriter.
La DLL Ionic l'utilise pour afficher des messages supplémentaires lors d'opérations sur une archive zip. 
La présence du paramètre -Verbose impose donc la libération implicite de cette instance via un appel à la méthode Close() sur l'archive ciblée par cet objet d'options.
"@
	NewReadOptionsExamplesRemarks1 = 'Cet exemple crée un objet option de lecture avec les valeurs par défaut.'
    NewReadOptionsExamplesRemarks2 = 'Cet exemple crée un objet option de lecture avec une valeur d''encodage par défaut et un PSVerboseTextWriter pour des affichages supplémentaires.'
    NewReadOptionsExamplesRemarks3 = 'Cet exemple crée un objet option de lecture avec une valeur d''encodage par défaut et une barre de progression.'
    NewReadOptionsExamplesRemarks4 = @"
Cet exemple crée un objet option de lecture avec une valeur d'encodage par défaut et une barre de progression. 
Puis on modifie directement sa propriété StatusMessageWriter afin d'afficher le suivi de l'opération sur la console et plus sur le flux verbose. 
"@
}


