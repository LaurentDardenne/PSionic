# Format-ZipFile command data
$Datas = @{
	FormatZipFileSynopsis = 'Formate le contenu des propriétés d''un objet archive.'
	FormatZipFileDescription = 'Formate le contenu des propriétés d''une archive Zip. Consultez la rubrique Notes pour le détail des propriètés affichées par défaut.'
	FormatZipFileSets__AllParameterSets = ''
	FormatZipFileParametersProperties = 'Tableau de nom de propriété à afficher lors de l''appel interne à Format-List'
	FormatZipFileParametersZip = 'Objet archive sur lequel appliquer le formatage.'
	FormatZipFileInputsDescription1 = 'Ionic.Zip.ZipFile'
	FormatZipFileOutputsDescription1 = 'Microsoft.PowerShell.Commands.Internal.Format'
	FormatZipFileNotes = @"
Liste des propriétés affichées par défaut :
  CaseSensitiveRetrieval
  UseUnicodeAsNecessary
  UseZip64WhenSaving
  RequiresZip64
  OutputUsedZip64
  InputUsesZip64
  ProvisionalAlternateEncoding
  AlternateEncoding
  AlternateEncodingUsage
  StatusMessageTextWriter
  TempFileFolder
  Password
  ExtractExistingFile
  ZipErrorAction
  Encryption
  SetCompression
  MaxOutputSegmentSize
  NumberOfSegmentsForMostRecentSave
  ParallelDeflateThreshold
  ParallelDeflateMaxBufferPairs
  Count
  FullScan
  SortEntriesBeforeSaving
  AddDirectoryWillTraverseReparsePoints
  BufferSize
  CodecBufferSize
  FlattenFoldersOnExtract
  Strategy
  Name
  CompressionLevel
  CompressionMethod
  Comment
  EmitTimesInWindowsFormatWhenSaving
.
La présence de cette fonction est due à un bug dans le système d'extension de type et de foramtage qui ne peut à ce jout gérer une classe possédant un indexeur.
"@
    FormatZipFileExamplesRemarks1 = 'Cet exemple récupère un objet archive à partir d''un nom de fichier, puis formate son contenu avant de libérer les ressources systèmes.'
}  


