ConvertFrom-StringData @'
 ParameterStringEmpty=The parameter '{0}' can not be an empty string.
 PathMustExist=The path does not exist : {0}
 ValueNotSupported=The value '{0}' is not supported.
 TypeNotSupported={0}: The type '{1}' is not supported.
 CommentMaxValue=The value of 'Comment' parameter must not exceeds 32767 characters.

 InvalidPassword=The desired encryption ('{0}') needs a password is provided.
 isBadPasswordWarning=Bad password for the archive {0}
 ZipArchiveBadPassword=An invalid password was given to extract archive {0}.
 InvalidPasswordForDataEncryptionValue=The value provided for Password parameter ('{0}') is invalid for the given value of DataEncryption '{1}'.
 ZipArchiveCheckPasswordError=Error occured while checking password on the archive {0] : {1}.

 ConvertingFile=Converting archive {0} to a self-extracting archive.
 ErrorSFX=Error occured while creating the self-extracting archive {0} : {1}

 AddEntryError=Can not add the entry {0} : {1}
 EntryIsNull=The entry '{0}' is `$null.
 ExpandZipEntryError=The entry named {0} do not exist in the archive '{1}'
 

 ZipArchiveReadError=Error occured while reading the archive {0} : {1}.
 ZipArchiveExtractError=Error occured while extracting the archive {0} : {1}.
 ZipArchiveCheckIntegrityError=Error occured while checking the archive integrity {0} : {1}.
 isCorruptedZipArchiveWarning=Corrupted archive : {0}

 TestisArchiveError=Error occured while testing the archive {0] : {1}.
 isNotZipArchiveWarning=The file is not a zip archive : {0}
 
 ExcludedObject=The objects of the type directory are excluded.
 IsNullOrEmptyArchivePath=The file name is empty or ToString() return an empty string.
 EmptyResolution=The resolution does not find file.
 
 SaveIsNotPermitted=You specified an EXE for a plain zip file.
 
 ProgressBarExtract=Extract in progress
'@ 

