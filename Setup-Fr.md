Le poste de développement doit contenir les lignes suivantes dans le profile utilisateur Powershell :
{code:powershell}
."$env:PsIonicProfile\"Profile_DevCodePlex.Ps1"
{code:powershell}

Ensuite créez une variable d'environnement système, nommée PsIonicProfile, pointant sur votre répertoire de travail, exemple :
{code:powershell}
$env:PsIonicProfile
#pointe sur 
C:\Users\Laurent\Documents\WindowsPowerShell\Tools
{code:powershell}

Enfin recopiez le script **{"Profile_DevCodePlex.Ps1"}** dans le répertoire _$env:PsIonicProfile_, puis modifiez toutes les lignes indiquées comme étant spécifiques au poste de développement :
{code:powershell}
   $SvnPathRepository='G:\PS' # Spécifique au poste de développement
{code:powershell}

## Installation des outils
[Psake](https://github.com/psake/psake). Une [introduction à Psake](http://ottomatt.pagesperso-orange.fr/Data/Tutoriaux/Powershell/UsageDePsake/UsageDePsake.pdf)
[Pester](https://github.com/pester/Pester)
[Helps](https://github.com/nightroman/Helps)  ([Documentation des scripts complémentaires](http://ottomatt.pagesperso-orange.fr/Data/Tutoriaux/Powershell/Creation-de-fichier-daide-XML-Powershell/Creation-de-fichier-daide-XML-Powershell.pdf))

## Construction de la livraison
Une fois les outils nécessaires installés et accessibles, exécuter dans le répertoire \Tools le script **Build.ps1.** 

Celui-ci appelle les tâches PSAKE contenues dans les scripts suivants :   
 _\Tools\Release.ps1_
 _\Tools\BuildZipAndSFX.ps1_
 _\Tools\Common.ps1_

Il est recommandé d'exécuter cette construction à partitr d'une console Powershell version 3, ainsi la compilation de la dll PsionicTools se fera pour le framework dotnet 2.0 ( PS v2) et pour le framework dotnet 4.0 ( PS v3).

Les tâches exécutées se charge de :
* vérifier l'encodage des fichiers du projet avant et après la génération effectuée,
* supprimer et reconstruire l'arborescence du répertoire $PsIonicLivraison, 
* valider le contenu des fichiers de localisation .psd1 ( recherche des clés inutilisées ou absentes),
* exécuter le parsing condionnel, Function Remove-Conditionnal, c'est à dire inclus des fichiers PS1 externes au projet, supprime les lignes de DEBUG,
* recopier les fichiers du référentiel dans l'arborescence du répertoire $PsIonicLivraison,
* valider la syntaxe des scripts,
* compiler la DLL PsionicTools,
* construire l'aide offline XML,
* et enfin, en utilisant le module du projet, génère une archive (.zip) et une archive auto extractible (.exe) exécutant un script de setup. 
En un mot, ces tâches automatisent la construction du livrable et les contrôles préliminaires associés.

[Détails des fonctions utilisées](FunctionsDev-FR)