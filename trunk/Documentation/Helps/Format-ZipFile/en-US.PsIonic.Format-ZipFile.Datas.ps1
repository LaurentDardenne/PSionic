# Format-ZipFile command data
$Datas = @{
	FormatZipFileSynopsis = 'Formats content of the properties of an archive object.'
	FormatZipFileDescription = 'Formats content of the properties of a Zip archive. Read Notes section for details about default displayed properties.'
	FormatZipFileSets__AllParameterSets = ''
	FormatZipFileParametersProperties = 'Array of property names to display when internal calling to Format-List.'
	FormatZipFileParametersZip = 'Archive object to format. You need to force the inclusion of the object by prefixing the variable with a comma.'
	FormatZipFileInputsDescription1 = ''
	FormatZipFileOutputsDescription1 = ''
	FormatZipFileNotes = @"
List of default properties to display :
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
The presence of this function is due to a bug in the type extension system and formatting that can not manage a class with an indexer.
"@
	FormatZipFileExamplesRemarks1 = 'This example gets an archive object from a file name, then formats his contents before freeing system resources.'
}


