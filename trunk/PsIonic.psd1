#
# Manifeste de module pour le module « IonicZip »
#
# Généré par : Matthew BETTON
#
# Généré le : 29/12/2012
#

@{
	ModuleToProcess = 'PsIonic.psm1'

	# Numéro de version de ce module.
	ModuleVersion = '1.0'
 
	# ID utilisé pour identifier de manière unique ce module
	GUID = '70d8092c-46de-4ea8-b971-d628cddf5dda'
	
  # Auteur de ce module
	Author = 'Matthew BETTON','Laurent Dardenne' 

	# Description de la fonctionnalité fournie par ce module
	Description = 'Cmdlets to manage zip files'

	# Version minimale du moteur Windows PowerShell requise par ce module
	PowerShellVersion = '2.0'
	
  FormatsToProcess   = @(
    'FormatData\PsIonic.ZipEntry.Format.ps1xml',
    'FormatData\PsIonic.ReadOptions.Format.ps1xml'
  )
  
#  TypesToProcess     = @(
#      'TypeData\Psionic.xxx.Type.ps1xml'
#  )
  
  # Assemblies qui doivent être chargés préalablement à l'importation de ce module
	RequiredAssemblies = @((Join-Path $psScriptRoot 'IOnic.Zip.dll'),
                         'System.Drawing')

  #Module de log
  RequiredModules=@{ModuleName="Log4Posh";GUID="f796dd07-541c-4ad8-bfac-a6f15c4b06a0"; ModuleVersion="1.0.0.0"}                           
}

