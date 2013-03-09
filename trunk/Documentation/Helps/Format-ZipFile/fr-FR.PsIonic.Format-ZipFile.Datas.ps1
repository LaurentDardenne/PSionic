﻿# Format-ZipFile command data
$Datas = @{
	FormatZipFileSynopsis = 'Formate le contenu des propriètés d''un objet archive.'
	FormatZipFileDescription = 'Formate le contenu des propriètés d''une archive Zip. Consultez la rubrique Notes pour le détails des propriètés affichées par défaut.'
	FormatZipFileSets__AllParameterSets = ''
	FormatZipFileParametersProperties = 'Tableau de nom de proriété à afficher lors de l''appel interne à Format-List'
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
"@
    FormatZipFileExamplesRemarks1 = 'Cet exemple récupère un objet archive à partir d''un nom de fichier, puis formate son contenu avant de libérer les ressouces systèmes.'
}  


