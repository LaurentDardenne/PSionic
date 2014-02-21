# New-ProgressBarInformations command data
$Datas = @{
	NewProgressBarInformationsSynopsis = "Créer un objet de déclaration d'une barre de progression PSionic standardisée."
	NewProgressBarInformationsDescription = 'Cet objet est utilisé par la fonction New-ReadOptions.'
	NewProgressBarInformationsSets__AllParameterSets = ''
	NewProgressBarInformationsParametersactivity = @"
Indique la première ligne de texte dans le titre de la barre de progression. 
Ce texte décrit l'activité dont la progression est rapportée.
"@
	NewProgressBarInformationsParametersactivityId =@"
Indique un identifiant distinguant chaque barre de progression. 
Utilisez ce paramètre lorsque vous créez plusieurs barres de progression en une seule commande. 
Si les barres de progression n'ont pas d'identifiant différent, elles seront superposées au lieu d'être affichées l'une en dessous de l'autre.
"@
	NewProgressBarInformationsInputsDescription1 = ''
	NewProgressBarInformationsOutputsDescription1 = ''
	NewProgressBarInformationsNotes = ''
	NewProgressBarInformationsExamplesRemarks1 = @"
Cette exemple crée une barre de progression utilisée dans le paramétrage des options de lecture d'une archive.
Dans ce contexte le nom des fichiers lus n'étant pas accessible, la barre de progression affichera uniquement le nombre d'entrée lue.  
"@
	NewProgressBarInformationsExamplesRemarks2 = @"
Cette exemple lit toutes les archives ZIP du répertoire C:\Temp, puis les extrait.
On utilise directement le paramètre -ProgressID de la fonction Expand-ZipFile qui configure en interne une barre de progression.
Dans ce cas lors de la lecture du catalogue, la valeur du paramètre Activity n'est pas modifiable, car elle est figée dans le code.
"@
}


