﻿ConvertFrom-StringData @' 
 LoggerDotNotExist=La variable `$Logger n'existe pas ou est `$null
 ParameterStringEmpty=Le paramètre '{0}' ne peut être une chaîne vide.
 PathMustExist=Le nom de chemin n'existe pas : {0}
 FileMustExist=Le fichier n'existe pas : {0}
 ValueNotSupported=La valeur '{0}' n'est pas supportée.
 TypeNotSupported={0}: le type '{1}' n'est pas supporté.
 CommentMaxValue=Le contenu du paramètre 'Comment' ne doit pas excéder 32767 caractères.
 
 InvalidPassword=Le type de cryptage demandé ('{0}'), nécessite que le paramètre password soit renseigné.
 isBadPasswordWarning=Mauvais mot de passe pour l'archive {0}
 ZipArchiveBadPassword=Mot de passe incorrect pour l'extraction de l'archive {0}
 InvalidPasswordForDataEncryptionValue=La valeur du paramètre Password ('{0}') est invalide pour la valeur de DataEncryption '{1}'.
 ZipArchiveCheckPasswordError=Erreur lors du contrôle de mot de passe sur l'archive {0] : {1}
 
 ConvertingFile=Conversion de l'archive {0} en une archive autoextractible.
 ErrorSFX=Erreur lors de la création de l'archive autoextractible {0} : {1}
  
 ErrorSettingEncryptionValue=Erreur lors du paramètrage de l'archive {0} : {1}
 
 AddEntryError=Impossible d'ajouter l'élement {0} dans l'archive '{1}' : {2}
 
 ZipArchiveReadError=Une erreur s'est produite lors de la lecture de l'archive {0} : {1}
 ZipArchiveExtractError=Une erreur s'est produite lors de l'extraction de l'archive {0} : {1}
 ZipArchiveCheckIntegrityError=Erreur lors du contrôle d'intégrité de l'archive {0] : {1}
 isCorruptedZipArchiveWarning=Archive corrompue : {0}
 
 TestisArchiveError=Erreur lors du test de l'archive {0} : {1}
 isNotZipArchiveWarning=N'est pas une archive Zip : {0}
'@ 

