#PsIonic.psm1
# ------------------------------------------------------------------
# Depend : Ionic.Zip.Dll
# copyright (c) 2008 by Dino Chiesa
# ------------------------------------------------------------------

Add-Type -Path "$psScriptRoot\$($PSVersionTable.PSVersion)\PSIonicTools.dll"
 
Start-Log4Net "$psScriptRoot\Log4Net.Config.xml"

$Script:Logger=Get-Log4NetLogger 'File'

Import-LocalizedData -BindingVariable PsIonicMsgs -Filename PsIonicLocalizedData.psd1 -EA Stop

#------------Pseudo Formatage, la présence d'un indexer sur la classe ZipFile 
#            empêche l'usage d'un fichier de formatage .ps1xml ( v2 et v3).

[String[]] $ZipFrm=@(
 "CaseSensitiveRetrieval","UseUnicodeAsNecessary","UseZip64WhenSaving","RequiresZip64","OutputUsedZip64",
 "InputUsesZip64","ProvisionalAlternateEncoding","AlternateEncoding","AlternateEncodingUsage","StatusMessageTextWriter",
 "TempFileFolder","Password","ExtractExistingFile","ZipErrorAction","Encryption","SetCompression","MaxOutputSegmentSize",
 "NumberOfSegmentsForMostRecentSave","ParallelDeflateThreshold","ParallelDeflateMaxBufferPairs","Count","FullScan",
 "SortEntriesBeforeSaving","AddDirectoryWillTraverseReparsePoints","BufferSize","CodecBufferSize","FlattenFoldersOnExtract",
 "Strategy","Name","CompressionLevel","CompressionMethod","Comment","EmitTimesInWindowsFormatWhenSaving","EmitTimesInUnixFormatWhenSaving"
 )

function New-Exception($Exception,$Message=$null) {
#Crée et renvoi un objet exception pour l'utiliser avec $PSCmdlet.WriteError()

   #Le constructeur de la classe de l'exception trappée est inaccessible  
  if ($Exception.GetType().IsNotPublic)
   {
     $ExceptionClassName="System.Exception"
      #On mémorise l'exception courante. 
     $InnerException=$Exception
   }
  else
   { 
     $ExceptionClassName=$Exception.GetType().FullName
     $InnerException=$Null
   }
  if ($Message -eq $null)
   {$Message=$Exception.Message}
    
   #Recrée l'exception trappée avec un message personnalisé 
	New-Object $ExceptionClassName($Message,$InnerException)       
} #New-Exception

Function New-ArrayReadOnly {
 param([ref]$Tableau)
   #La méthode AsReadOnly retourne un wrapper en lecture seule pour le tableau spécifié.
   #On recherche les informations de la méthode publique spécifiée.  
  [System.Reflection.MethodInfo] $Methode = [System.Array].GetMethod("AsReadOnly")
  
   #Crée une méthode générique
   #On précise le même type que celui déclaré pour la variable $Tableau
  $MethodeGenerique = $Methode.MakeGenericMethod($Tableau.Value.GetType().GetElementType())
  
   #Appel la méthode générique créée qui renvoi 
   #une collection en lecture seule, par exemple :
   # [System.Collections.ObjectModel.ReadOnlyCollection``1[System.String]]
  $TableauRO=$MethodeGenerique.Invoke($null,@(,$Tableau.Value.Clone()))
  ,$TableauRO
}

$ZipFrmRO=New-ArrayReadOnly ([ref]$ZipFrm)

function Format-ZipFile {
# .ExternalHelp PsIonic-Help.xml   
  param(
     [Parameter(Mandatory=$true,ValueFromPipeline = $true)]
    [Ionic.Zip.ZipFile] $Zip,
      [Parameter(Position=0,Mandatory=$false)]
    $Properties=$ZipFrmRO
  )
  $Zip.PSbase|Format-List $Properties
}

#------------

 #Liste des raccourcis de type
 #ATTENTION ne pas utiliser dans la déclaration d'un type de paramètre d'une fonction 
$PsIonicShortCut=@{
  ZipFile=[Ionic.Zip.ZipFile];
  ZipEntry=[Ionic.Zip.ZipEntry];
  ZipEncryption=[Ionic.Zip.EncryptionAlgorithm];
  ZipSfxOptions=[Ionic.Zip.SelfExtractorSaveOptions];
  ZipSfxFlavor=[Ionic.Zip.SelfExtractorFlavor];
  ZipExtractExistingFileAction=[Ionic.Zip.ExtractExistingFileAction];
  ZipErrorAction=[Ionic.Zip.ZipErrorAction];
  Encoding=[System.Text.Encoding];
}

$AcceleratorsType= [PSObject].Assembly.GetType("System.Management.Automation.TypeAccelerators") #v2 & v3
Try {
  $PsIonicShortCut.GetEnumerator() |
  Foreach {
   Try {
     $Logger.Debug("Add TypeAccelerators $($_.Key) =$($_.Value)") #<%REMOVE%>
     $AcceleratorsType::Add($_.Key,$_.Value)
   } Catch [System.Management.Automation.MethodInvocationException]{
     Write-Error -Exception $_.Exception 
   }
 } 
} Catch [System.Management.Automation.RuntimeException] {
   Write-Error -Exception $_.Exception
}

Function CloneSfxOptions { 
#Clone les propriétés de type 'Property" uniquement
 param (
  $Old,
  $New=$null
 ) 

 if ($New -eq $null) 
 { $New=New-ZipSfxOptions }

 $Old.PSObject.Properties.Match("*","Property")|
  Foreach {
   $New."$($_.Name)"=$Old."$($_.Name)"
  } 
 $New
} #CloneSfxOptions 

Function Set-PsIonicSfxOptions { 
# .ExternalHelp PsIonic-Help.xml         
  param (
   [Ionic.Zip.SelfExtractorSaveOptions] $Options
  )
  [void](CloneSfxOptions $Options $Script:DefaultSfxConfiguration)
} #Set-PsIonicSfxOptions 

Function Get-PsIonicSfxOptions { 
# .ExternalHelp PsIonic-Help.xml         

 CloneSfxOptions $Script:DefaultSfxConfiguration
} #Get-PsIonicSfxOptions 

Function Reset-PsIonicSfxOptions { 
# .ExternalHelp PsIonic-Help.xml         

  $Script:DefaultSfxConfiguration=New-ZipSfxOptions
} #Reset-PsIonicSfxOptions 

 #Utilisé par la fonction interne IsValueSupported
$IsValueSupported=@{
 Extract={
   Param ([Ionic.Zip.ExtractExistingFileAction] $Value) 
    $Logger.Debug("Value= $Value . Return $($Value -eq [ZipExtractExistingFileAction]::InvokeExtractProgressEvent)")  #<%REMOVE%>
    $Value -eq [ZipExtractExistingFileAction]::InvokeExtractProgressEvent
 }
}

Function IsIconImage{
 #valide si un fichier est du type attendu, ici un fichier Icon ( .ico )
 param($Filename)
  try
  {
      $Img = [System.Drawing.Image]::FromFile($Filename)
      return $img.RawFormat.Equals([System.Drawing.Imaging.ImageFormat]::Icon)
  }
  catch [System.IO.FileNotFoundException], [System.OutOfMemoryException]
  {
     return $false;
  }
  finally {
   if ($Img -ne $Null)
   {$Img.Dispose()}
  }
}#isIconImage

function isCollection {
 param($Object)
   $Object -is [System.Collections.IEnumerable] -and $Object -isnot [String]
}#isCollection

Function ConvertPSDataCollection {
#Analyse la collection Error d'un objet de type PSEventJob
#Renvoi un objet exception ou génére une erreur normale.
 param (
  [System.Management.Automation.PSDataCollection[System.Management.Automation.ErrorRecord]] $PSEventJobError
 )
    #Le job de l'event peut provoquer des erreurs,
   #on propage les possibles erreurs dans la session
  if ($PSEventJobError.Count -gt 0)                   
  { 
    $PSEventJobError.Error|Export-Clixml 'c:\temp\PSEventJobError.xml'  #<%REMOVE%>
     #Transforme la collection spécialisée en un array
    $T=@($PSEventJobError.Error|% {$_})
     #A la différence de la collection $Error, on doit inverse le contenu 
    [System.Array]::Reverse($T)
    $ofs="`r`n"
    if ($T[0].Exception -isnot [Microsoft.PowerShell.Commands.WriteErrorException])
    { 
      #Construit l'exception ayant arrêté le job
      Write-Output New-Exception $T[0].Exception "ExtractProgress -> $T" 
    }
    else
    { 
      #Ecrit la dernière erreur déclenchée dans le job 
      Write-Error "ExtractProgress -> $($T|% {$_.Exception}|out-string)" 
    } 
  }
} #ConvertPSDataCollection

Function RegisterEventExtractProgress {
 param(
  $ZipFile,
  [int] $ProgressID
 )
    $Logger.Debug("RegisterEvent ExtractProgress") #<%REMOVE%> 
    #Si le contexte est un job :
    #   $ExecutionContext.Host.name -ne "ServerRemoteHost"
    #alors l'information sera périméé une fois celui-ci terminé,
    #bien que l'affichage ne se fasse pas sur la console 
    # 
    #On laisse la possibilité de faire de l'implicit remoting : 
    # Extraction à distante, affichage de la progression en locale.
    #
    #
    #Si $ProgressPreference est à 'SilentlyContinue', on ne traite pas l'event inutilement  
    #Construit le scriptblock avec la valeur de ProgressBarCount courante
    #évite une variable globale
  $ProgressAction=@"
    if (`$eventargs.EventType -eq [Ionic.Zip.ZipProgressEventType]::Extracting_AfterExtractEntry)
    {
      `$Logger.Debug("EntriesExtracted=`$(`$eventargs.EntriesExtracted)") #<%REMOVE%>
      `$Logger.Debug("EntriesTotal=`$(`$eventargs.EntriesTotal)") #<%REMOVE%>
      `$Logger.Debug("FileName=`$(`$eventargs.CurrentEntry.FileName)") #<%REMOVE%>
      if (`$eventargs.EntriesTotal -eq 0)
      {
        `$Logger.Debug("-Query est précisée, EntriesTotal n'est pas pas renseigné")
        write-progress -ID $($ProgressID) -activity "$($PsIonicMsgs.ProgressBarExtract)" -Status "`$(`$eventargs.CurrentEntry.FileName)"
      }
      else
      {
         # Calcul du pourcentage du nombre de fichiers extrait
        [int]`$percent = ((`$eventargs.EntriesExtracted / `$eventargs.EntriesTotal) * 100)
        write-progress -ID $($ProgressID) -activity "$($PsIonicMsgs.ProgressBarExtract)" -Status "`$(`$eventargs.CurrentEntry.FileName)" -PercentComplete `$percent
      }
    }
"@
  $ProgressAction=[ScriptBlock]::Create($ProgressAction)
  Register-ObjectEvent -InputObject $ZipFile -EventName ExtractProgress -SourceIdentifier ZipFileExtractProgress -action $ProgressAction
}#RegisterEventExtractProgress

Function UnRegisterEvent{
  param( [System.Management.Automation.PSEventJob] $EventJob )
  
  $EventException=ConvertPSDataCollection $EventJob.Error
  $Logger.Debug("Unregister $($EventJob.Name) event. Remove-Job")#<%REMOVE%>
  Unregister-Event -SourceIdentifier $EventJob.Name -ErrorAction SilentlyContinue
  Remove-Job $EventJob
  
  if ($EventException -ne $null) 
  { throw (New-Object PSIonicTools.PsionicException($EventException)) }  
}#UnRegisterEvent

function ConvertFrom-CliXml {
# .ExternalHelp PsIonic-Help.xml 
# http://poshcode.org/2302
# by Joel Bennett, modification David Sjstrand

#On récupère une string XML afin de désérialiser un objet Powershell.
    param(
        [Parameter(Position=0, Mandatory=$true, ValueFromPipeline=$true)]
        [ValidateNotNullOrEmpty()]
        [String[]]$InputObject
    )
    begin
    {
		$OFS = "`n"
        [String]$xmlString = ""
    }
    process
    {
        $xmlString += $InputObject
    }
    end
    {
        $type = [PSObject].Assembly.GetType("System.Management.Automation.Deserializer")  #v2 & v3
        $ctor = $type.getconstructor("instance,nonpublic", $null, @([xml.xmlreader]), $null)
        $sr = new-object System.IO.StringReader $xmlString
        $xr = new-object System.Xml.XmlTextReader $sr
        $deserializer = $ctor.invoke($xr)
        $method = @($type.getmethods("nonpublic,instance") | where-object {$_.name -like "Deserialize"})[1]
        $done = $type.getmethod("Done", [System.Reflection.BindingFlags]"nonpublic,instance")
        while (!$done.invoke($deserializer, @()))
        {
            try {
                $method.invoke($deserializer, "")
            } catch {
                write-warning "Could not deserialize ${string}: $_"
            }
        }
		$xr.Close()
		$sr.Dispose()
    }
}

function ConvertTo-CliXml {
# .ExternalHelp PsIonic-Help.xml  
#from http://poshcode.org/2301
#by Joel Bennett

#Permet de sérialiser un objet PowerShell, on récupère une string XML
    param(
        [Parameter(Position=0, Mandatory=$true, ValueFromPipeline=$true)]
        [ValidateNotNullOrEmpty()]
        [PSObject[]]$InputObject
    )
    begin {
        $type = [PSObject].Assembly.GetType("System.Management.Automation.Serializer") #v2 & v3
        $ctor = $type.getconstructor("instance,nonpublic", $null, @([System.Xml.XmlWriter]), $null)
        $sw = new-object System.IO.StringWriter
        $xw = new-object System.Xml.XmlTextWriter $sw
        $serializer = $ctor.invoke($xw)
        $method = $type.getmethod("Serialize", "nonpublic,instance", $null, [type[]]@([object]), $null)
        $done = $type.getmethod("Done", [System.Reflection.BindingFlags]"nonpublic,instance")
    }
    process {
        try {
            [void]$method.invoke($serializer, $InputObject)
        } catch {
            write-warning "Could not serialize $($InputObject.gettype()): $_"
        }
    }
    end {    
        [void]$done.invoke($serializer, @())
        $sw.ToString()
		$xw.Close()
		$sw.Dispose()
    }
}

#   Fonctions spécifiques à PsIonic
function GetSFXname {
 param (
  [String] $FileName
 )
 $FileName -Replace '\.zip$',".exe"
} #GetSFXname

Function IsValueSupported {
#Utilisée dans un attribut ValidateScript
  [CmdletBinding(DefaultParameterSetName = "Extract")]
  param(
     [ValidateNotNullOrEmpty()] 
     [Parameter(Position=0, Mandatory=$true)]
    $Value,
     [Parameter(ParameterSetName="Extract")]
    [switch] $Extract
  )

 $Logger.Debug("Call= $($PsCmdlet.ParameterSetName)") #<%REMOVE%>
 
 if (&$IsValueSupported[$PsCmdlet.ParameterSetName] $Value)
 { 
   $Msg=$PsIonicMsgs.ValueNotSupported -F $value
   $Logger.Fatal($Msg)  #<%REMOVE%>
   Throw (New-Object PSIonicTools.PsionicException($Msg)) 
 } 
 
 $true
}#IsValueSupported    

Function NewZipFile{
# Gére les 3 constructeurs de la classe Ionic.Zip.ZipFile
  param (
    [string] $FileName,
	[System.IO.TextWriter] $statusMessageWriter,
	[Encoding] $Encoding
  )

  Write-Verbose "Delete $Filename" 
  if (Test-Path $Filename)
  { Remove-Item $Filename -ea SilentlyContinue } #Retarde la gestion lors du Save()
  
  $Parameters=@($Filename)
  
  if ($statusMessageWriter -ne $null) 
  {$Parameters +=$statusMessageWriter }
  
  if ($Encoding -ne [ZipFile]::DefaultEncoding) 
  {
     $Parameters +=$Encoding #[Ionic.Zip.ZipOption]::Always
  }
  #else #[Ionic.Zip.ZipOption]::Newer

  New-Object ZipFile -ArgumentList $Parameters 
}#NewZipFile

Function SetZipFileEncryption {
#Applique les régles liées à la configuration du cryptage 
    [CmdletBinding(DefaultParameterSetName = "Set")]
  param(
          [Parameter(Position=0,Mandatory=$true)]
        $ZipFile, #On suppose l'objet initialisé
         [Parameter(Position=1,ParameterSetName="Set")]
        [Ionic.Zip.EncryptionAlgorithm] $DataEncryption,
         [Parameter(Position=2,ParameterSetName="Set")]
        [String] $Password,
         [Parameter(ParameterSetName="Reset")]
        [switch] $Reset
  )
  
  function ResetPassword {
       $Logger.Debug("Reset password")  #<%REMOVE%>
       [PSIonicTools.ZipPassword]::Reset($ZipFile) # -> Encryption = None   
  }#ResetPassword                
  
  $Logger.Debug("Encryption configuration of the archive $($ZipFile.Name)") #<%REMOVE%>
   
  if ($Reset)
  {  ResetPassword }  
  else 
  {    
    $isPwdValid= [string]::IsNullOrEmpty($Password) -eq $false
    $isEncryptionValid=$DataEncryption -ne "None"
    
    If ($isPwdValid -and -not $isEncryptionValid)
    {
       $Logger.Debug("Encryption Weak")  #<%REMOVE%>
       $ZipFile.Encryption = "PkzipWeak"
       $ZipFile.Password = $Password
    }
    elseif (-not $isPwdValid -and -not $isEncryptionValid)
    { ResetPassword }
    elseif ($isEncryptionValid)
    {
       if (-not $isPwdValid)
       { 
         $Msg=$PsIonicMsgs.InvalidPasswordForDataEncryptionValue -F $Password,$DataEncryption
         $Logger.Fatal($Msg) #<%REMOVE%>
         Throw (New-Object PSIonicTools.PsionicException($Msg)) 
       }
       $Logger.Debug("Encryption $DataEncryption") #<%REMOVE%>
       $ZipFile.Encryption = $DataEncryption
       $ZipFile.Password = $Password
    }
    else
    { ResetPassword  }  
  }
 #Return $ZipFile
}#SetZipFileEncryption

Function GetObjectByType {
#Renvoi, selon le type reçu, le ou les objets fichiers à traiter
#Add-entry fait une distinction entre une string et un fichier          
 Param (
   [Parameter(Mandatory=$true,ValueFromPipeline = $true)]
  $Object,
  [boolean] $Recurse
  )
  
 begin {  
  function GetObject {  
   param ( $Object )
     $Logger.Debug("GetObject : $($Object.FullName)") #<%REMOVE%> 
     if ($Object.GetType().IsSubclassOf([System.IO.FileSystemInfo]) -or ($Object -is [Ionic.Zip.ZipEntry]))
     { 
       $Logger.Debug("Object is FileSystemInfo or Zipentry") #<%REMOVE%>
       #Ici pas de récursion sur les sous-répertoires
       # si dir * -rec|compress -rec, alors on dupliquerait les fichiers
       Return $Object 
     }
     elseif ($Object -isnot [String])
     { 
       $Logger.Debug("Call ToString()") #<%REMOVE%>
       $Object=$Object.ToString()  #tente une transformation
     } 
     
     if ([String]::IsNullOrEmpty($Object)) 
      {
        $Logger.Debug('Object is $null or empty.') #<%REMOVE%>
        return $null
      }
       #Renvoi une exception en cas de pb sur le FilesSystem
     if (Test-Path $Object -PathType Container)
     { 
       $Logger.Debug("Object is a directory : $Object") #<%REMOVE%> 
       #renvoi les objets Directory  
       Get-ChildItem $Object -Recurse:$Recurse  
     }
     else 
     {
       $Logger.Debug("Object is not a directory, call Resolve-Path  : $Object") #<%REMOVE%> 
           #Récupère tous les fichiers si le nom comporte des jokers : 
           #     ?, *, [a], [abc], [a-c], Test*[a][0-9], etc.
        #Renvoi une liste de Pathinfo
       Resolve-Path $Object|Get-ChildItem  -Recurse:$Recurse
     }   
  } #GetObject
 }#begin 
  
 Process {
  $Logger.Debug("GetObjectByType $($Object.GetType().FullName) `t $Object") #<%REMOVE%>   
  if ($Object -ne $null)   
  { 
    $Object|
     Foreach { GetObject $_ }
  } 
 }#process
} #GetObjectByType

function SaveSFXFile {
#Enregistre une archive autoextractible
 param (
  $Zip,
  $Options
 )
  $Logger.Debug("Save sfx")  #<%REMOVE%>
  $TargetName = GetSFXname $Zip.Name
  $Logger.DebugFormat($PsIonicMsgs.ConvertingFile, $TargetName)  #<%REMOVE%>
  Write-Verbose ($PsIonicMsgs.ConvertingFile -F $TargetName)
  try{
      $Zip.SaveSelfExtractor($TargetName, $Options)  
  }
  catch{
     $Msg=$PsIonicMsgs.ErrorSFX -F $TargetName,$_
     $Logger.Fatal($Msg,$_.Exception)  #<%REMOVE%>
     Throw (New-Object PSIonicTools.PsionicException($Msg,$_.Exception))
  }
} #SaveSFXFile

function SetZipErrorHandler {
#S'abonne à l'event ZipError
 param ($ZipFile)
   if ($ZipFile.ZipErrorAction -eq [ZipErrorAction]::InvokeErrorEvent)
  {
    $Logger.Debug("Gestion d'erreur via PSIonicTools.PSZipError")  #<%REMOVE%>
    $Context=$PSCmdlet.SessionState.PSVariable.Get("ExecutionContext").Value  
    $psZipErrorHandler=New-Object PSIonicTools.PSZipError($Context)
    $psZipErrorHandler.SetZipErrorHandler($ZipFile)
  }
}#SetZipErrorHandler 

function AddMethodPSDispose{
#Membre synthétique dédié à la libération des ressources
#Si on utilise Passthru, on doit pouvoir libèrer les ressources en dehors de la fonction
#Add-member -Force ne fonctionne pas sur une méthode de l'objet dotnet, on crée donc une autre méthode.

 param ($ZipInstance)
  
  $Logger.Debug("Add PSDispose method on $($ZipInstance.Name)")  #<%REMOVE%>
  Add-Member -Inputobject $ZipInstance -Force ScriptMethod PSDispose{
      if (($this.StatusMessageTextWriter -ne $null) -and  ($this.StatusMessageTextWriter -is [PSIonicTools.PSVerboseTextWriter]))
      {
         #On libère que ce que l'on crée
        $Logger.Debug("`t ZipFile Dispose PSStream") #<%REMOVE%> 
        $this.StatusMessageTextWriter.Dispose()
        $this.StatusMessageTextWriter=$null               
      }   
       #Récupère le type de l'instance
      $MyType=$this.GetType()
       #Récupère l'événement ZipError
      $Event=$MyType.GetEvent('ZipError')
       #Un event à un délégué privé
      $bindingFlags = [Reflection.BindingFlags]"GetField,NonPublic,Instance"
       #On récupère la valeur du délégué privé
      $EventField = $MyType.GetField('ZipError',$bindingFlags)
      $ZipErrorDeleguate=$EventField.GetValue($this)
      if ($ZipErrorDeleguate -ne $null)
      {
         $Logger.Debug("`t Dispose delegates") #<%REMOVE%> 
         #Récupère la liste des 'méthodes' à appeler
         # Au moins un, peut être de notre type : $_.Target -is [PSIonicTools.PSZipError]
        $ZipErrorDeleguate.GetInvocationList()|
        Foreach {
           $Logger.Debug("`t Dispose $_") #<%REMOVE%>
           #On supprime tous les abonnements  
          $Event.RemoveEventHandler($this,$_)
        }
      }
       #On appelle la méthode Dispose() de l'instance en cours
      $Logger.Debug("Dispose $($this.Name)") #<%REMOVE%>               
      $this.Dispose()
  }            
} #AddMethodPSDispose

function AddMethodClose{
#Membre synthétique dédié à la libération des ressources
#Si on utilise Passthru, on doit pouvoir libèrer les ressources en dehors de la fonction
#Evite l'appel successif de Save() puis PSDispose()

 param ($ZipInstance)
  
  $Logger.Debug("Add close method on $($ZipInstance.Name)")  #<%REMOVE%>
  Add-Member -Inputobject $ZipInstance -Force ScriptMethod Close {
      try {
        $Logger.Debug("Close : save $($this.Name)") #<%REMOVE%>
        $this.Save()
      }
      catch [Ionic.Zip.BadStateException]
      {
        if  ($this.name.EndsWith(".exe"))
        { Write-Error $PsIonicMsgs.SaveIsNotPermitted -Exception $_.Exception} 
      } 
      finally {
       #On appelle la méthode Dispose() de l'instance en cours  
       $Logger.Debug("Close : PSDispose $($this.Name)") #<%REMOVE%>             
      $this.PSDispose()
     }
  }            
} #AddMethodClose


function AddMethods{
 param ($ZipInstance)

  AddMethodPSDispose $ZipInstance
  AddMethodClose $ZipInstance
} #AddMethods
         
function DisposeZip{
#Code commun de libération d'une instance ZipFile
  if ($ZipFile -ne $null) 
  {       
     $Logger.Debug("`t DisposeZip $($ZipFile.Name)") #<%REMOVE%> 
     if ( @($ZipFile.psobject.Members.Match('PSDispose','ScriptMethod')).Count -ne 0)
     { $ZipFile.PSDispose() }
     else 
     {
       $Logger.Debug("`t $($ZipFile.Name) dont contains PSDispose method") #<%REMOVE%> 
       $ZipFile.Dispose()
    }
    $ZipFile=$null 
  }
}# DisposeZip

Function Get-ZipFile {
# .ExternalHelp PsIonic-Help.xml          
   [CmdletBinding(DefaultParameterSetName="File")] 
   [OutputType("File",[Ionic.Zip.ZipFile])] #Emet une instance de ZipFile
	param( 
        [ValidateNotNullOrEmpty()]
        [Parameter(Mandatory=$true,ValueFromPipeline = $true)]
      [string[]]$Name, 
        
        [Parameter(Position=0, Mandatory=$false, ParameterSetName="ReadOption")]
        [ValidateScript({@($_.PsObject.TypeNames[0] -contains "PsionicReadOptions").Count -gt 0})]
      $ReadOptions=$null,
         
      [Ionic.Zip.SelfExtractorSaveOptions] $Options =$Script:DefaultSfxConfiguration,
  
        [ValidateScript( {$_ -ge 64Kb})]  
      [Int] $Split= 0, 
      
      [Ionic.Zip.ZipErrorAction] $ZipErrorAction=[Ionic.Zip.ZipErrorAction]::Throw,  
      
      [Ionic.Zip.EncryptionAlgorithm] $Encryption="None", 
      
      [String] $Password,
      
      [string] $TempLocation =[System.IO.Path]::GetTempPath(), #Possible Security Exception
      
        [Parameter(Position=0, Mandatory=$false, ParameterSetName="ManualOption")]
      [System.Text.Encoding] $Encoding,
      
        [Parameter(ParameterSetName="ManualOption")]
      [int]$ProgressID,
      
      [switch] $NotTraverseReparsePoints,
      [switch] $SortEntries,
        # N'est pas exclusif avec $WindowsTimeFormat 
      [switch] $UnixTimeFormat,    
        # N'est pas exclusif avec $UnixTimeFormat
      [switch] $WindowsTimeFormat
    )

  begin {
    [Switch] $isVerbose= $null
    [void]$PSBoundParameters.TryGetValue('Verbose',[REF]$isVerbose)
    $Logger.Debug("-Verbose: $isverbose") #<%REMOVE%> 
    $isProgressID=$PSBoundParameters.ContainsKey('ProgressID')      
  }
 
  process {  
    Foreach($Current in $Name){
     try {
        $FileName = GetArchivePath $Current
        if ((TestZipArchive -Archive $FileName  -Password $Password -Passthru ) -ne $null)
        {   

          try {
            if ($PsCmdlet.ParameterSetName -eq "ManualOption")
            { 
              if ($isProgressID)
              { 
                $pbi=New-ProgressBarInformations $ProgressID "Read in progress "
                $ReadOptions=New-ReadOptions $Encoding $pbi -Verbose:$isVerbose 
              }
              else
              { $ReadOptions=New-ReadOptions $Encoding -Verbose:$isVerbose }
         
            }
            elseif ($ReadOptions -eq $null)
            {  $ReadOptions=New-ReadOptions -Verbose:$isVerbose  }              
            
            $ZipFile = [Ionic.Zip.ZipFile]::Read($FileName, $ReadOptions)
          } 
          finally {
            if ($ReadOptions -ne $null)
            { $ReadOptions.Dispose() }              
          }   

          $ZipFile.UseZip64WhenSaving=[Ionic.Zip.Zip64Option]::AsNecessary
          $ZipFile.ZipErrorAction=$ZipErrorAction
      
          SetZipErrorHandler $ZipFile
          AddMethods $ZipFile
      
          $ZipFile.SortEntriesBeforeSaving=$SortEntries
          $ZipFile.TempFileFolder=$TempLocation 
          $ZipFile.EmitTimesInUnixFormatWhenSaving=$UnixTimeFormat
          $ZipFile.EmitTimesInWindowsFormatWhenSaving=$WindowsTimeFormat
          
          if (-not [string]::IsNullOrEmpty($Password) -or ($DataEncryption -ne "None"))
          { SetZipFileEncryption $ZipFile $Encryption $Password }
           #Les autres options sont renseignées avec les valeurs par défaut
          ,$ZipFile
        }
     }
     catch [System.Management.Automation.ItemNotFoundException],
           [System.Management.Automation.DriveNotFoundException],
           [PsionicTools.PsionicInvalidValueException]
     {
        $Logger.Fatal($_.Exception.Message) #<%REMOVE%>
        Write-Error -Exception $_.Exception
     } 
   }#Foreach          
  } #Process
} #Get-ZipFile

Function Compress-ZipFile {
# .ExternalHelp PsIonic-Help.xml          
   [CmdletBinding(DefaultParameterSetName="File")] 
   [OutputType("File",[Ionic.Zip.ZipFile])] #Emet une instance de ZipFile
   [OutputType("SFX",[System.IO.FileInfo])]  #Emet une instance de fichier .exe
	param( 
        [Parameter(Mandatory=$true,ValueFromPipeline = $true)]
      $Path,
        [ValidateNotNullOrEmpty()]
        [Parameter(Position=0, Mandatory=$true)]
      [string] $Name,
        [Parameter(Position=1, Mandatory=$false, ParameterSetName="SFX")]
      [Ionic.Zip.SelfExtractorSaveOptions] $Options =$Script:DefaultSfxConfiguration,
      
        [Parameter(ParameterSetName="File")]
        [ValidateScript( {$_ -ge 64Kb})]  
      [Int] $Split= 0, 

      [Ionic.Zip.ZipErrorAction] $ZipErrorAction=[Ionic.Zip.ZipErrorAction]::Throw,  
      
      [string] $Comment,
      
      [Ionic.Zip.EncryptionAlgorithm] $Encryption="None", 
      [String] $Password,
      [string] $TempLocation =[System.IO.Path]::GetTempPath(), #Possible Security Exception
      [System.Text.Encoding] $Encoding=[Ionic.Zip.ZipFile]::DefaultEncoding,
     
         [Alias('CP')]
       [string]$CodePageIdentifier=[String]::Empty, 
     
        [Parameter(ParameterSetName="UT")]
        [Alias('UT')]
      [Datetime] $UniformTimestamp,
        
        [Parameter(ParameterSetName="UTnow")]
        [Alias('UTnow')]
      [switch] $NowUniformTimestamp,
        
        [Parameter(ParameterSetName="UTnewest")]
        [Alias('UTnewest')]
      [switch] $NewUniformTimestamp,
        
        [Parameter(ParameterSetName="UToldest")]
        [Alias('UToldest')]      
      [switch] $OldUniformTimestamp,
      
        [Parameter(ParameterSetName="File")]
      [switch] $Passthru,
       [Parameter(ParameterSetName="SFX")]
      [switch] $SFX,
      [switch] $NotTraverseReparsePoints, #todo à implémenter
      [switch] $SortEntries,
        # N'est pas exclusif avec $WindowsTimeFormat 
      [switch] $UnixTimeFormat,    
        # N'est pas exclusif avec $UnixTimeFormat
      [switch] $WindowsTimeFormat, 
      [switch] $Recurse 
      )
 
	Begin{
       function SetUniformTimestamp {
          if ($fixedTimestamp -ne $null)
          {
            if ($PSBoundParameters.ContainsKey('UTnewest'))
            {
               $fixedTimestamp = New-Object System.DateTime(1601,1,1,0,0,0)
               foreach($entry in $ZipFile)
               {
                 if ($entry.LastModified -gt $fixedTimestamp)
                 { $fixedTimestamp = $entry.LastModified }
               }
            }
            elseif ($PSBoundParameters.ContainsKey('UToldest'))
            {
              foreach($entry in $ZipFile)
              {
                if ($entry.LastModified -lt $fixedTimestamp)
                { $fixedTimestamp = $entry.LastModified }
              }   
            }
          }
          if ($fixedTimestamp -ne $null)
          {
            foreach($entry in $zipFile)
            { $entry.LastModified = $fixedTimestamp }
          }         
       }#SetUniformTimestamp   
	   
      [Switch] $isVerbose= $null
      [void]$PSBoundParameters.TryGetValue('Verbose',[REF]$isVerbose)
      $Logger.Debug("-Verbose: $isverbose") #<%REMOVE%>          
          
      if ($PSBoundParameters.ContainsKey('Comment') -And ($Comment.Length -gt 32767))
      { Throw (New-Object PSIonicTools.PsionicException($PsIonicMsgs.CommentMaxValue)) }
      
      $fixedTimestamp=$null
      If ($PSBoundParameters.ContainsKey('UTnow'))
      { $fixedTimestamp = [System.DateTime]::UtcNow }
      elseif ($PSBoundParameters.ContainsKey('UT'))
      { $fixedTimestamp=$UniformTimestamp }

      $psZipErrorHandler=$null
      $PSVW=$null
      if ($isverbose)
      {
          $Logger.Debug("Configure PSVerboseTextWriter") #<%REMOVE%>
           #On récupère le contexte d'exécution de la session, pas celui du module. 
          $Context=$PSCmdlet.SessionState.PSVariable.Get("ExecutionContext").Value            
          $PSVW=New-Object PSIonicTools.PSVerboseTextWriter($Context) 
      }

      $ZipFile= NewZipFile $Name $PSVW $Encoding
      if ( $CodePageIdentifier -ne [String]::Empty)
      { 
        $ZipFile.AlternateEncoding = System.Text.Encoding.GetEncoding($CodePageIdentifier)
        $ZipFilezip.AlternateEncodingUsage = ZipOption.Always
      }
      
       #Archive avec + de 0xffff entrées
      $ZipFile.UseZip64WhenSaving=[Ionic.Zip.Zip64Option]::AsNecessary
      $ZipFile.ZipErrorAction=$ZipErrorAction

      SetZipErrorHandler $ZipFile
      AddMethods $ZipFile
      
      $ZipFile.Name=$Name
      $ZipFile.Comment=$Comment
      $ZipFile.SortEntriesBeforeSaving=$SortEntries
      $ZipFile.TempFileFolder=$TempLocation 

      $ZipFile.EmitTimesInUnixFormatWhenSaving=$UnixTimeFormat
       #Par défaut sauvegarde au format de date Windows
       #WindowsTimeFormat existe pour porter la cas WindowsTimeFormat:$False 
      if ( -not $PSBoundParameters.ContainsKey('UnixTimeFormat') -and -not $PSBoundParameters.ContainsKey('WindowsTimeFormat') )
      { $ZipFile.EmitTimesInWindowsFormatWhenSaving=$true }
      else
      { $ZipFile.EmitTimesInWindowsFormatWhenSaving=$WindowsTimeFormat }
      
      if (-not [string]::IsNullOrEmpty($Password) -or ($DataEncryption -ne "None"))
      { SetZipFileEncryption $ZipFile $Encryption $Password }
    
       #Exclusion mutuelle via les attributs
      $isSplittedZip = $PSBoundParameters.ContainsKey('Split')
      $isSFX = $PsCmdlet.ParameterSetName -eq "Sfx" 
       
      $Logger.Debug("isSplittedZip =$isSplittedZip")  #<%REMOVE%> 
      $Logger.Debug("isSFXp =$isSFX")  #<%REMOVE%> 
       #Configure la taille des segments 
      If ($isSplittedZip)
      { $ZipFile.MaxOutputSegmentSize=$Split }
      else
      { $ZipFile.MaxOutputSegmentSize= 0 }    
     #Les autres options sont renseignées avec les valeurs par défaut
	} 

	Process{   
      GetObjectByType $Path -Recurse:$Recurse|
       Add-ZipEntry $ZipFile
	} #Process
    
    End {
      try {
        SetUniformTimestamp
        if ($PsCmdlet.ParameterSetName -eq "Sfx")
        {  SaveSFXFile $ZipFile $Options  }
        else 
        {
          $Logger.Debug("Save zip")  #<%REMOVE%>
          $ZipFile.Save()
        }
      } 
      catch [System.IO.IOException] 
      {
        $Logger.Fatal("Save",$_.Exception) #<%REMOVE%>
        DisposeZip
        Throw (New-Object PSIonicTools.PsionicException($_,$_.Exception))
      }
      
      if ($Passthru)
      { 
        if ($PsCmdlet.ParameterSetName -eq "Sfx")
        {Get-Item (GetSFXname $ZipFile.Name)} # Renvoi un fichier .exe
        else 
        { ,$ZipFile } # Renvoi une instance de ZipFile, on connait son nom via Name
      }
      else  
      { DisposeZip }
    }#End
} #Compress-ZipFile

Function AddEntry {
   param (
       [Parameter(Mandatory=$true,ValueFromPipeline = $true)]
     $InputObject,
       [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true)]
       [Alias('Key')]
       [Alias('Name')]
     [string] $KeyName, #Le nom d'entrée n'est pas obligatoire et peut provenir de la clé d'une entrée de hashtable
     [switch] $Passthru
    )
 begin {
   [type[]] $private:ParameterTypesOfAddEntryMethod=[string],[byte[]]
   $private:AddEntryMethod=[Ionic.Zip.ZipFile].GetMethod("AddEntry",$private:ParameterTypesOfAddEntryMethod) 
 }
 process {
  try {
    if ($InputObject.GetType().Fullname -match "^System.Collections.Generic.KeyValuePair|^System.Collections.DictionaryEntry")
    {
      if ($_.Value -eq $null)
      {
        Write-Error ($PsIonicMsgs.EntryIsNull -F $KeyName)
        return 
      }
      else 
      {$InputObject=$_.Value}
    }
    $Logger.Debug("Add $InputObject")  #<%REMOVE%>
    $Logger.Debug("Add $KeyName")  #<%REMOVE%>
    
    $isCollection=isCollection $InputObject
    if ($isCollection -and ($InputObject -is [byte[]]))
    { 
      $Logger.Debug("Add Byte[]")  #<%REMOVE%>
      if ([string]::IsNullOrEmpty($KeyName))
      { 
        Write-Error ($PsIonicMsgs.ParameterStringEmpty -F 'KeyName')
        return
      }
        #Problem with 'distance algorithm' ?
        # http://stackoverflow.com/questions/13084176/powershell-method-overload-resolution-bug  
        #  public ZipEntry AddEntry(string entryName, string content)  
        # public ZipEntry AddEntry(string entryName, byte[] byteContent)
      $params = @($KeyName, ($InputObject -as [byte[]]) )
      $ZipEntry=$private:AddEntryMethod.Invoke($ZipFile, $params)
    }
    elseif ($isCollection)
    {
       $Logger.Debug("Recurse Add-ZipEntry")  #<%REMOVE%>
       $InputObject.GetEnumerator()|
        GetObjectByType |  
        Add-ZipEntry $ZipFile -Passthru:$Passthru      
    }
    elseif ($InputObject -is [System.String])
    { 
       $Logger.Debug("Add String")  #<%REMOVE%>
       if ([string]::IsNullOrEmpty($KeyName))
       { 
         Write-Error ($PsIonicMsgs.ParameterStringEmpty -F 'KeyName')
         return  
       }
       $ZipEntry=$ZipFile.AddEntry($KeyName, $InputObject -as [string]) 
    }
    elseif ($InputObject -is [System.IO.DirectoryInfo])
    { 
      $Logger.Debug("Add Directory ")  #<%REMOVE%>
      $ZipEntry=$ZipFile.AddDirectory($InputObject.FullName, $InputObject.Name)
    }
    elseif ($InputObject -is [System.IO.FileInfo])
    { 
      $Logger.Debug("Add Fileinfo")  #<%REMOVE%>
       #($DirectoryPath -eq [string]::Empty) add on the root
       # IOnic doit connaitre le chemin complet sinon il est considéré comme relatif
     $ZipEntry=$ZipFile.AddFile($InputObject.FullName,$DirectoryPath)  
    }
    elseif ($InputObject -is [Ionic.Zip.ZipEntry])
    {
      $Logger.Debug("Add ZipEntry")  #<%REMOVE%>
      Write-Error "Under construction"
    }
    else
    {
      $Msg=$PsIonicMsgs.TypeNotSupported -F $MyInvocation.MyCommand.Name,$InputObject.GetType().FullName
      $Logger.Debug($Msg)  #<%REMOVE%>
      Write-Warning $Msg   
    }
    if ($Passthru)
    {$ZipEntry} 
   }
   catch { #ArgumentNullException or ArgumentException
    Write-Error ($PsIonicMsgs.AddEntryError -F $InputObject,$ZipFile.Name,$_.Exception.Message) -Exception $_.Exception
   }
  }#process
}#AddEntry
   
Function Add-ZipEntry { 
# .ExternalHelp PsIonic-Help.xml 
 [CmdletBinding()] 
 [OutputType([Ionic.Zip.ZipEntry])]
  param (
     [Parameter(Mandatory=$true,ValueFromPipeline = $true)]
    $Object,
       [ValidateNotNull()]
      [Parameter(Position=0,Mandatory=$true)]
    [Ionic.Zip.ZipFile] $ZipFile,
     [Parameter(Position=1,Mandatory=$false,ValueFromPipelineByPropertyName=$true)]
    [string] $Name, 
    [string] $DirectoryPath=[string]::Empty,
    [switch] $Passthru
  )
   process {
      $isCollection=isCollection $Object
      if ($isCollection -and ($Object -is [System.Collections.IDictionary]))
      {
        $Logger.Debug("Add entries from a hashtable.")  #<%REMOVE%>
        $Object.GetEnumerator()|
         AddEntry  -Passthru:$Passthru
      }
      else
      { AddEntry $Object $Name }
  }#process
} #Add-ZipEntry

Function GetArchivePath {
# Récupère une string et renvoie, si possible, un nom de chemin complet.
# L'objet passé en paramètre peut être un type FileInfo ou un String ou Object et 
# dans ce cas il sera transformé en String sous réserve qu'il ne soit ni vide ni $null.
# dans tous les autres cas on renvoie $null. 
  [CmdletBinding()] 
  param (
    $Object
  )

    $Logger.Debug("GetArchivePath : récupération de l'objet ") #<%REMOVE%> 
    $Logger.Debug("Object type = $($Object.GetType())") #<%REMOVE%>

	if ($Object -is [System.IO.FileInfo])  
	{ return $Object.FullName  }
    elseif ($Object -is [System.IO.DirectoryInfo])      
    {  throw (New-Object PsionicTools.PsionicInvalidValueException($Object,$PsIonicMsgs.ExcludedObject)) }
	elseif ($Object -is [String])
	{ $ArchivePath = $Object  }
	else
	{   
       $Logger.Debug("Transformation to string") #<%REMOVE%>    
       $ArchivePath = $Object.ToString() 
    }
    if ([string]::IsNullOrEmpty($ArchivePath) )
    {  throw (New-Object PsionicTools.PsionicInvalidValueException($Object,$PsIonicMsgs.IsNullOrEmptyArchivePath)) }

    $Logger.Debug("The file name is '$ArchivePath'") #<%REMOVE%>
    try {
      $List=@(Resolve-Path $ArchivePath -ea Stop)
    } 
    catch [System.Management.Automation.ActionPreferenceStopException] 
    { 
      throw $_.Exception #todo vérifier invocationInfo 
    }

    if ($List.Count -eq 0) 
    { throw (New-Object PsionicTools.PsionicInvalidValueException($PsIonicMsgs.EmptyResolution))}
     
     #todo Resolve-PSpath
    foreach ($Item in $List|Get-Item) {
     if ($Item -is [System.IO.FileInfo])
	 { 
        $Logger.Debug("return $($Item.FullName)") #<%REMOVE%> 
        Write-Output $Item.FullName 
     }
     else
     {
       $Logger.Debug("Is not an instance of System.IO.FileInfo : $Item") #<%REMOVE%>
       Write-Verbose "Is not an instance of System.IO.FileInfo : $Item"
     } 
    }#foreach
} #GetArchivePath

Function Expand-ZipEntry { 
# .ExternalHelp PsIonic-Help.xml         
    [CmdletBinding()] 
    [OutputType([System.String])]
	param(
		[ValidateNotNull()] 
        [parameter(Mandatory=$True,ValueFromPipeline=$True)]
      [Ionic.Zip.ZipFile] $ZipFile,        
      	[Parameter(Position=1,Mandatory=$True,ValueFromPipeline=$True)]
	  [String[]] $Name,      
        [Parameter(Mandatory=$false, ParameterSetName="Default")] 
		[ValidateScript( { IsValueSupported $_ -Extract } )] 
	  [Ionic.Zip.ExtractExistingFileAction] $ExtractAction=[Ionic.Zip.ExtractExistingFileAction]::Throw,
	
	  [String] $Password,

      [System.Text.Encoding] $Encoding=[Ionic.Zip.ZipFile]::DefaultEncoding,
      [Switch] $AsHashTable,
      [Switch] $XML,
      [Switch] $Strict
	)
 begin {
  if ($AsHashTable) {$HTable=@{}}     
 }     
 process {
   foreach ($EntryName in $Name)
   {         
     try {
        $Stream = New-Object System.IO.MemoryStream
        $Logger.Debug("ReadEntry $EntryName in $($ZipFile.Name)") #<%REMOVE%>
        $Entry=$ZipFile[$EntryName]
        if ($Entry -ne $null)
        { $Entry.Extract($Stream) }
        else 
        { 
          $msg=$PsIonicMsgs.ExpandZipEntryError -F $EntryName,$ZipFile.Name
          $Exception=New-Object System.ArgumentException($Msg,'Name')
          $Logger.Error($Msg) #<%REMOVE%>
          if ($Strict) 
          { throw $Exception }
          else 
          { 
             $PSCmdlet.WriteError(
                (New-Object System.Management.Automation.ErrorRecord(
                  $Exception, 
                  "EntryNotFound", 
                  "ObjectNotFound",
                  ("[{0}]" -f $EntryName)
                 )  
                ) 
             )
          }
          Continue 
        }
        $Stream.Position = 0;
        $Reader = New-Object System.IO.StreamReader($Stream)
        $Logger.Debug("Read data from the MemoryStream") #<%REMOVE%>
        $Result= $Reader.ReadToEnd()
        if ($XML)
        { $Data=$Result -as [XML] }
        else 
        { $Data=$Result -as [String] } #todo sinon erreur ?
        if ($AsHashTable) 
        { 
          $Logger.Debug("Add Hashtable") #<%REMOVE%>
          $HTable.Add($EntryName,$Data) 
        }
        else
        { 
           $Logger.Debug("Send Datas") #<%REMOVE%>
           Write-output $Data
        }
     }
     finally 
     {
       if ($Reader  -ne $Null)
       { 
         $Logger.Debug("Dispose Reader") #<%REMOVE%>
         $Reader.Dispose()
         $Reader=$null 
       }
       if ($Stream -ne $Null)
       { 
         $Logger.Debug("Dispose MemoryStream") #<%REMOVE%>     
         $Stream.Dispose()
         $Stream=$null 
       }
     }#finally
    }#foreach
 }#process

 end {
   if ($AsHashTable) 
   { Write-Output $HTable}      
 }#end
} #Expand-ZipEntry

Function Expand-ZipFile {
# .ExternalHelp PsIonic-Help.xml         
    [CmdletBinding(DefaultParameterSetName="Default")] 
	[OutputType("Default",[Ionic.Zip.ZipFile])]
    [OutputType("List",[Ionic.Zip.ZipEntry])]
	param(
		[parameter(Mandatory=$True,ValueFromPipeline=$True)]
	  $Path, #Todo add LiterralPath
 
        [ValidateNotNullOrEmpty()] 
        [parameter(Position=0,Mandatory=$True, ValueFromPipelineByPropertyName=$True, ParameterSetName="Default")]
	  [PSObject]$OutputPath,#Todo add $LiterralOutputPathLiterral


      	[Parameter(Position=1,Mandatory=$false, ParameterSetName="Default")]
	  [String] $Query,      
     
        [Parameter(Mandatory=$false, ParameterSetName="Default")]
	  [String] $From, 

        [Parameter(Mandatory=$false, ParameterSetName="Default")] 
		[ValidateScript( { IsValueSupported $_ -Extract } )] 
	  [Ionic.Zip.ExtractExistingFileAction] $ExtractAction=[Ionic.Zip.ExtractExistingFileAction]::Throw,
	
	  [String] $Password,

      [System.Text.Encoding] $Encoding=[Ionic.Zip.ZipFile]::DefaultEncoding,
        
        [Parameter(ParameterSetName="Default")]
      [int]$ProgressID,
      
       [Parameter(ParameterSetName="Default")]
      [switch] $Interactive, #todo à implémenter
       
       [Parameter(Mandatory=$false, ParameterSetName="List")]
      [switch] $List,
      [switch] $Flatten, 
      [switch] $Passthru,
       [Parameter(Mandatory=$false, ParameterSetName="Default")]
      [switch] $Create
	)

  Begin{
    [Switch] $isVerbose= $null
    [void]$PSBoundParameters.TryGetValue('Verbose',[REF]$isVerbose)
    $isProgressID=$PSBoundParameters.ContainsKey('ProgressID')   
    $Logger.Debug("Expand-ZipFile isProgressID=$isProgressID") #<%REMOVE%> 
    $isDefaultParameterSetName= $PsCmdlet.ParameterSetName -eq 'Default'
    
     #to manage delayed script block 
    $PreviousOutputPath=$null
    
    Function ZipFileRead {
     param( $FileName )
      try{
        $Logger.Debug("Read the file $zipPath") #<%REMOVE%> 
        #$isEvent= $isProgressID -and ($ProgressPreference -ne 'SilentlyContinue')
        if ($isProgressID)
        { 
          $pbi=New-ProgressBarInformations $ProgressID "Read in progress "
          $ReadOptions=New-ReadOptions $Encoding $pbi -Verbose:$isVerbose 
        }
        else
        { $ReadOptions=New-ReadOptions $Encoding -Verbose:$isVerbose }          

        $ZipFile = [ZipFile]::Read($FileName,$ReadOptions)
        $ZipFile.FlattenFoldersOnExtract = $Flatten  
        
        AddMethods $ZipFile
        return ,$zipFile
      }
      catch {
        DisposeZip
        $Msg=$PsIonicMsgs.ZipArchiveReadError -F $FileName.ToString(), $_.Exception.Message
        $Logger.Fatal($Msg,$_.Exception) #<%REMOVE%>
        throw (New-Object PSIonicTools.PsionicException($Msg,$_.Exception))
      }
      finally {
        if ($ReadOptions -ne $null)
        { $ReadOptions.Dispose() }                
      }                     
    }#ZipFileRead
    
    function ExtractEntries {
      try{
        $isDispose=$true 
        if ($Passthru)
        { 
          $Logger.Debug("Preserve the query by Add-Member") #<%REMOVE%>
          Add-Member -Input ($ZipFile -as[PSobject]) -MemberType NoteProperty -name Query -Value $Query 
        }
 
        if($List){
            $ZipFile.Entries.GetEnumerator()|
             Foreach {Write-Output $_}
        } 
        else{
          if(-not [String]::IsNullOrEmpty($Password))
          {  
              $Logger.Debug("Set Password") #<%REMOVE%> 
              $ZipFile.password = $Password  
          }
          
          if (-not [String]::IsNullOrEmpty($Query)) 
          {  
              $Logger.Debug("Extraction using a query : $Query") #<%REMOVE%> 
              if( [String]::IsNullOrEmpty($From)){
                  $Logger.Debug("From = null") #<%REMOVE%>
                  $Logger.Debug("OutputPath=$OutputPath") #<%REMOVE%>
                  $Logger.Debug("ExtractAction=$ExtractAction") #<%REMOVE%>
                  
                   #bug null to string, use reflection
                  [type[]] $private:ParameterTypesOfExtractSelectedEntriesMethod=[string],[string],[string],[Ionic.Zip.ExtractExistingFileAction]
                  $ExtractSelectedEntriesMethod=[Ionic.Zip.ZipFile].GetMethod("ExtractSelectedEntries",$private:ParameterTypesOfExtractSelectedEntriesMethod)
                  $params = @($Query,$Null,($OutputPath.ToString()),$ExtractAction)
                  $ZipEntry=$ExtractSelectedEntriesMethod.Invoke($ZipFile, $params)  
                  if ($Passthru){
                    $Logger.Debug("Send ZipFile instance") #<%REMOVE%>
                    $isDispose=$false 
                    return ,$ZipFile
                  }                                            
              }
              else{
                  $ZipFile.ExtractSelectedEntries($Query,$From,$OutputPath,$ExtractAction)  
              }
          }
          else{ 
              $Logger.Debug("Extraction without query.") #<%REMOVE%>
              $ZipFile.ExtractAll($OutputPath,$ExtractAction)
              if ($Passthru){
                $Logger.Debug("Send ZipFile instance") #<%REMOVE%>
                $isDispose=$false 
                return ,$ZipFile
              }              
          }#else isnotnul $Query
       }#else
      }#try
      catch [Ionic.Zip.BadPasswordException]{
         throw (New-Object PSIonicTools.PsionicException(($PsIonicMsgs.ZipArchiveBadPassword -F $zipPath),$_.Exception))
         
      }
      #todo 
      #InvalidOperationException (spécialisée) : n'est pas une archive 
      #BadStateException (spécialisée): la construction du code est erroné, l'état du ZIP ne la permet pas 
      #BadCrcException (spécialisée)
      #ZipException : générique
      # unsupported encryption algorithm, unsupported compression method 
      catch{
         $Msg=$PsIonicMsgs.ZipArchiveExtractError -F $zipPath, $_.Exception.Message
         if (($_.Exception -is [Ionic.Zip.ZipException]) -and ($ZipFile.ExtractExistingFile -ne "Throw") ) 
         {
           $Logger.Fatal($Msg,$_.Exception) #<%REMOVE%>
           throw (New-Object PSIonicTools.PsionicException($Msg,$_.Exception))
         }
         else 
         {
           $Logger.Error($Msg) #<%REMOVE%>
           Write-Error $Msg -Exception $_.Exception 
         }
      }
      finally{
        if ($isDispose)
        { DisposeZip }
      }             
    }#ExtractEntries
 }#begin

 Process{
  Foreach($Archive in $Path){
   try {
      $zipPath = GetArchivePath $Archive
       #Test à chaque itération car le delayed script block peut être demandé
       #On mémorise donc le répertoire de destination courant                        
      if (($PreviousOutputPath -ne $OutputPath) -and $isDefaultParameterSetName) 
      {
         $Logger.DebugFormat("delayed script block detected Previous {0} New {1}", $PreviousOutputPath,$OutputPath)  #<%REMOVE%>
         $PreviousOutputPath=$OutputPath
         #Le chemin de destination doit être valide  
         #le chemin valide doit exister
         #Le chemin doit référencer le FileSystem
        $PSPathInfo=Resolve-PSPath -Path $OutputPath 
        if (-not $PSPathInfo.IsCandidate()) 
        {
           $lFileName=If ($PSPathInfo.ResolvedPSPath -eq $null) {$PSPathInfo.Name} else {$PSPathInfo.ResolvedPSPath} 
           $Msg=$PsIonicMsgs.PathIsNotAFileSystemPath -F $lFileName + "`r`n$($PSPathInfo.LastError)"
           $Logger.Error($Msg) #<%REMOVE%>
           Write-Error $Msg
           continue 
        }
        $OutputPath=$PSPathInfo.Win32PathName
        if ($Create)
        {
            #On le crée si possible
            if ($PSPathInfo.IsCandidateForCreation())
            {              
              $Logger.Debug("Create `$OutputPath directory") #<%REMOVE%>
              Md $OutputPath > $Null
            }
        }
        elseif (-not $PSPathInfo.IsCandidateForExtraction())
        { throw (New-Object PSIonicTools.PsionicException(($PsIonicMsgs.PathMustExist -F $OutputPath ))) }            
      }
              
      Foreach($FileName in $ZipPath){
        $Logger.Debug("Full path name : $FileName") #<%REMOVE%>
        $zipFile= ZipFileRead $FileName
        if ($ZipFile.Count -eq 0)
        {
          $Logger.Debug("No entries in the archive") #<%REMOVE%> 
          if ($Passthru)
          { return ,$ZipFile }
          else 
          { 
            DisposeZip 
            return $null            
          } 
        }
         #Extract ProgressBar
        try {
          $isEvent=$isProgressID -and ($ProgressPreference -ne 'SilentlyContinue')
          $Logger.Debug("zipfile is null: $($zipfile.psbase -eq $null)") #<%REMOVE%>
          if ($isEvent) 
          { $RegEvent=RegisterEventExtractProgress $zipFile $ProgressID }
          ExtractEntries
        }
        finally {
          if ($isEvent)
          { UnRegisterEvent $RegEvent  }
        }#finally
      }#foreach zipFile
    }
    catch [System.Management.Automation.ItemNotFoundException],
          [System.Management.Automation.DriveNotFoundException],
          [PsionicTools.PsionicInvalidValueException]
    {
      $Logger.Error($_.Exception.Message) #<%REMOVE%>
      Write-Error -Exception $_.Exception 
    }   
  }#Foreach  
 } #process
}#Expand-ZipFile

Function TestZipArchive {
 [CmdletBinding()]         
    param(
	  [String] $Archive,
	  [String] $Password,
      [switch] $isValid,
      [switch] $Check,
      [switch] $Repair,
      [switch] $Passthru
    )
 try{   
    $isZipFile = $false
    $goodPassword = $checkZip = $true
    $PSVW=$Null

    # Isvalid=$true vérifie le contenu, mais Check=$true ne vérifie que le catalogue
    # On peut donc renvoyer true si on précise seulement -Check sur une archive invalide
    $Logger.Debug("Est-ce une archive ?") #<%REMOVE%>
    try{
        $isZipFile = [ZipFile]::isZipFile($Archive, $isValid)
    }
    catch{
        throw (New-Object PSIonicTools.PsionicException(($PsIonicMsgs.TestisArchiveError -F $Archive,$_),$_.Exception)) 
        
    }
#<DEFINE %DEBUG%>
    if ($isValid)
    {$Logger.Debug("Is that the archive is valid ? $isZipFile") } #<%REMOVE%>
#<UNDEF %DEBUG%>   

    
    if($isZipFile -and ($Check -or $Repair)){
      try{
        if($Check -and -not $Repair){
            $Logger.Debug("Checks a zip file to see if its directory is consistent.")  #<%REMOVE%>
            $checkZip = [ZipFile]::CheckZip($Archive)
        }
        else{
            $Logger.Debug("Checks a zip file to see if its directory is consistent, and optionally fixes the directory if necessary.")  #<%REMOVE%>
            [Switch] $isVerbose= $null
            [void]$PSBoundParameters.TryGetValue('Verbose',[REF]$isVerbose)
            $Logger.Debug("-Verbose: $isVerbose") #<%REMOVE%>   
            if ($isVerbose)
            {
                $Logger.Debug("Configure PSVerboseTextWriter")  #<%REMOVE%>
                 #On récupère le contexte d'exécution de la session, pas celui du module. 
                $Context=$PSCmdlet.SessionState.PSVariable.Get("ExecutionContext").Value            
                $PSVW=New-Object PSIonicTools.PSVerboseTextWriter($Context) 
            }
            $checkZip = [ZipFile]::CheckZip($Archive, $True, $PSVW)
        }
      }
      catch{
         throw (New-Object PSIonicTools.PsionicException(($PsIonicMsgs.ZipArchiveCheckIntegrityError -F $Archive,$_),$_.Exception))
      }
    }

    if($isZipFile -and -not [string]::IsNullOrEmpty($Password)){
        $Logger.Debug("Contrôle du mot de passe sur l'archive")  #<%REMOVE%>
        try{
            $goodPassword = [ZipFile]::CheckZipPassword($Archive, $Password)
        }
        catch{
            throw (New-Object PSIonicTools.PsionicException(($PsIonicMsgs.ZipArchiveCheckPasswordError -F $Archive,$_),$_.Exception))
        }
    }

    $GlobalCheck = ($isZipFile -and $goodPassword -and $checkZip)

    if($Passthru)
    {
        if($GlobalCheck){
            $Logger.Debug("Send the name of the archive into the pipeline : $Archive")  #  %REMOVE%
            Write-Output $Archive
        } 
        else{             
            if(-not $isZipFile -And -not $isValid){
                $PSCmdlet.WriteError(
                  (New-Object System.Management.Automation.ErrorRecord(
                    (New-Object Ionic.Zip.BadReadException($PsIonicMsgs.isNotZipArchiveWarning -F $Archive)), 
                    "InvalidFormat", 
                    "InvalidData",
                    ("[{0}]" -f $Archive)
                   )  
                  ) 
                )#WriteError                                 
            }
            if(-not $goodPassword){
                $PSCmdlet.WriteError(
                  (New-Object System.Management.Automation.ErrorRecord(
                    (New-Object Ionic.Zip.BadPasswordException($PsIonicMsgs.isBadPasswordWarning -F $Archive)), 
                    "InvalidPassword", 
                    "AuthenticationError",
                    ("[{0}]" -f 'Password')
                   )  
                  ) 
                )#WriteError             
            }
            if(-not $checkZip){
                $PSCmdlet.WriteError(
                  (New-Object System.Management.Automation.ErrorRecord(
                    (New-Object Ionic.Zip.BadCrcException($PsIonicMsgs.isCorruptedZipArchiveWarning -F $Archive)), 
                    "InvalidArchive", 
                    "ReadError",
                    ("[{0}]" -f $Archive)
                   )  
                  ) 
                )#WriteError                
            }
        }
    }
    else{ 
     $Logger.Debug("Send the result of the tests into the pipeline : $GlobalCheck ")  #  %REMOVE%
     write-output $GlobalCheck 
    }
 } finally {
    if ($PSVW -ne $null) 
    { 
       $Logger.Debug("`t Dispose PSStream")  #<%REMOVE%> 
       $PSVW.Dispose()
       $PSVW=$null
    }  
 }   
}#TestZipArchive

Function Test-ZipFile{
# .ExternalHelp PsIonic-Help.xml              
  [CmdletBinding(DefaultParameterSetName="Default")]
  [OutputType("Default",[boolean])]
  [OutputType("File",[System.String])]
 	param(
		[parameter(Position=0,Mandatory=$True,ValueFromPipeline=$True)]
	  $Path, 
	  [String] $Password,     
      [switch] $isValid,  
      [switch] $Check,
      [switch] $Repair,  
        [Parameter(Mandatory=$false, ParameterSetName="File")]
      [switch] $Passthru
    )
   begin {
    [Switch] $isVerbose= $null
    [void]$PSBoundParameters.TryGetValue('Verbose',[REF]$isVerbose)
    $Logger.Debug("-Verbose: $isVerbose") #<%REMOVE%>  
   }
    Process{
        Foreach($Archive in $Path){  
          try {  
            $zipPath = GetArchivePath $Archive -Verbose:$isVerbose
            Foreach($ZipFile in $ZipPath){
               $Logger.Debug("Full path name : $zipFile ") #<%REMOVE%>
               if ($PsCmdlet.ParameterSetName -eq "File")
               {TestZipArchive -Archive $zipFile -isValid:$isValid -Check:$Check -Repair:$Repair -Password $Password -Passthru:$Passthru -verbose:$isVerbose}
               else
               {TestZipArchive -Archive $zipFile -isValid:$isValid -Check:$Check -Repair:$Repair -Password $Password -verbose:$isVerbose}
            }
          }
          catch [System.Management.Automation.ItemNotFoundException],
                [System.Management.Automation.DriveNotFoundException],
                [PsionicTools.PsionicInvalidValueException]
          {
              $Logger.Debug("isValid=$isValid") #<%REMOVE%>
              $Logger.Debug("$($_.Exception -is [PsionicTools.PsionicInvalidValueException])") #<%REMOVE%>
              $Logger.Debug("$($_.Exception.GetType().FullName)") #<%REMOVE%>
              if (-not $isValid -and ($_.Exception -is [PsionicTools.PsionicInvalidValueException]))
              { Write-Error -Exception $_.Exception }
              $Logger.Error($_.Exception.Message)  #<%REMOVE%>
               # On émet dans le pipe que les noms des fichiers existant (-passthru) ou les noms des archives valides (-isValid -passthru) 
               # Tous les fichiers inexistant et toutes les archives existantes invalides ne sont donc pas émises.
              if (($PsCmdlet.ParameterSetName -ne "File") -or ($Passthru -eq $false))
              { Write-Output $false }           
          }#catch
        }#Foreach
    }#process
}#Test-ZipFile

Function ConvertTo-Sfx {
# .ExternalHelp PsIonic-Help.xml         
  [CmdletBinding()]
  [OutputType([System.IO.FileInfo])]
  Param (
  	 [ValidateNotNullOrEmpty()]
  	 [ValidateScript( {Test-Path $_})]
  	 [Parameter(Position=0, Mandatory=$true,ValueFromPipeline = $true)]
  	[string] $Name,  
  	 [Parameter(Position=1, Mandatory=$false)]
  	[Ionic.Zip.SelfExtractorSaveOptions] $SaveOptions =$Script:DefaultSfxConfiguration,
     [Parameter(Position=2, Mandatory=$false)]
     [ValidateScript({@($_.PsObject.TypeNames[0] -contains "PsionicReadOptions").Count -gt 0})]
    $ReadOptions=$null, 
	 [Parameter(Position=3, Mandatory=$false)]
    [string] $Comment,
    [switch] $Passthru
  )
 begin {
   if ($ReadOptions -eq $null)
   { $ReadOptions = New-Object Ionic.Zip.ReadOptions}
 }
 process {  
  try{
      $zipFile = [Ionic.Zip.ZipFile]::Read($Name, $ReadOptions)
      $zipFile.Comment =$Comment
      SaveSFXFile $ZipFile $SaveOptions 
      if ($Passthru)
      { Get-Item (GetSFXname $ZipFile.Name)} # renvoi un fichier .exe      
  }
  finally{
      DisposeZip
  }
 }#process
}#ConvertTo-Sfx

Function New-ZipSfxOptions {
# .ExternalHelp PsIonic-Help.xml         
	[CmdletBinding(DefaultParameterSetName = "CmdLine")]
	[OutputType([Ionic.Zip.SelfExtractorSaveOptions])]
	Param (
          [ValidateNotNullOrEmpty()]
          [Parameter(Position=0, Mandatory=$false)]
		[string] $ExeOnUnpack, #ex :"Powershell -noprofile -File .\MySetup.ps1"  
    
          [ValidateNotNullOrEmpty()]
		  [Parameter(Position=1, Mandatory=$false)]
		[string] $ExtractDirectory,     

    
          [ValidateNotNullOrEmpty()]
 	 	  [Parameter(Position=2, Mandatory=$false)]
		[string] $Description, 

          [ValidateNotNullOrEmpty()]
        [System.Version] $FileVersion='1.0.0.0',
  
          [ValidateNotNullOrEmpty()]
          [ValidateScript( { IsIconImage $_ } )]
		[string] $IconFile,
    
         [ValidateScript( { IsValueSupported $_ -Extract } )]
		[Ionic.Zip.ExtractExistingFileAction] $ExtractExistingFile=[Ionic.Zip.ExtractExistingFileAction]::Throw,
        
          [ValidateNotNullOrEmpty()]
        [string]$NameOfProduct,
       
         [ValidateNotNullOrEmpty()]
        [string]$VersionOfProduct,

          [ValidateNotNullOrEmpty()]
        [string] $Copyright,
          
          #http://msdn.microsoft.com/fr-fr/library/system.codedom.compiler.compilerparameters.compileroptions(v=vs.80).aspx
         [string] $AdditionalCompilerSwitches,

          [ValidateNotNullOrEmpty()]
         [Parameter(Position=3, Mandatory=$false,ParameterSetName="GUI")]
        [string] $WindowTitle,
        
        [switch] $Quiet,
        [switch] $Remove, 
        
		[Parameter(ParameterSetName="CmdLine")]
		[switch] $CmdLine, 
		[Parameter(ParameterSetName="GUI")]
		[switch] $GUI 
	)

	if ($PsCmdlet.ParameterSetName -eq "CmdLine")
     { $Flavor = [ZipSfxFlavor]::ConsoleApplication }
	else
    { $Flavor = [ZipSfxFlavor]::WinFormsApplication }

     #Crée une instance et renseigne seulement les membres  
     # qui ne sont pas de type string
      # https://connect.microsoft.com/feedback/ViewFeedback.aspx?FeedbackID=307821&SiteID=99
      # http://www.techtalkz.com/microsoft-windows-powershell/150495-gotcha-null-string-not-null-2.html     
	$SfxOptions=New-Object ZipSfxOptions -Property @{
                          AdditionalCompilerSwitches=$AdditionalCompilerSwitches;
                          ExtractExistingFile=$ExtractExistingFile;
                          Flavor = $Flavor;
                          FileVersion=$FileVersion;
                          RemoveUnpackedFilesAfterExecute=$Remove;
                          Quiet=$Quiet;
                         } 
     #Renseigne chaque membres de type string  
     # à partir du paramètre associé s'il n'est pas vide.
	if ($ExtractDirectory -ne [string]::Empty)
    { $SfxOptions.DefaultExtractDirectory =$ExtractDirectory }  
	
    if ($ExeOnUnpack -ne [string]::Empty)
    { $SfxOptions.PostExtractCommandLine = $ExeOnUnpack }
    
    if ($Description -ne [string]::Empty)
    { $SfxOptions.Description=$Description } 
    
    if ($IconFile -ne [string]::Empty)
    { $SfxOptions.IconFile=$IconFile }
    
    if ($NameOfProduct -ne [string]::Empty)
    { $SfxOptions.ProductName=$NameOfProduct }
    
    if ($VersionOfProduct -ne [string]::Empty)
    { $SfxOptions.ProductVersion=$VersionOfProduct }
  
    if ($Copyright -ne [string]::Empty)
    { $SfxOptions.Copyright=$Copyright } 
    
    if ($WindowTitle -ne [string]::Empty)
    { $SfxOptions.SfxExeWindowTitle=$WindowTitle }
   
    $SfxOptions
}#New-ZipSfxOptions

Function New-ProgressBarInformations{
param(
         [Parameter(Mandatory=$True,position=0)]
        [int] $activityId,
         [Parameter(Mandatory=$True,position=1)]
        [string] $activity
)
 $Logger.Debug("New New-ProgressBarInformations") #<%REMOVE%>
 $O=New-Object PSObject -Property $PSBoundParameters
 $O.PsObject.TypeNames.Insert(0,"ProgressBarInformations")
 $O
}# New-ProgressBarInformations

function New-ReadOptions {
 # .ExternalHelp PsIonic-Help.xml         
  [CmdletBinding()]
  [OutputType([Ionic.Zip.ReadOptions])]
  Param (
        [Parameter(Position=0, Mandatory=$false)]
      [System.Text.Encoding] $Encoding=[Ionic.Zip.ZipFile]::DefaultEncoding,
       [Parameter(Position=1, Mandatory=$false)]
       [ValidateScript({@($_.PsObject.TypeNames[0] -eq "ProgressBarInformations").Count -gt 0})]
      $ProgressBarInformations
  ) 
   [Switch] $isVerbose= $null
   [void]$PSBoundParameters.TryGetValue('Verbose',[REF]$isVerbose)
   $Logger.Debug("New-ReadOptions") #<%REMOVE%> 
   $Logger.Debug("-Verbose: $isverbose") #<%REMOVE%>   
       
   $isProgressBar=$PSBoundParameters.ContainsKey('ProgressBarInformations')
   
   $ReadOptions=New-Object Ionic.Zip.ReadOptions 
   #Renseigne les membres de l'instance ZipFile à partir des options
   #  ZipFile.PSDispose supprimera bien les ressources allouées ici
   if ($isVerbose)
   {
      $Logger.Debug("Configure PSVerboseTextWriter") 
      $Context=$PSCmdlet.SessionState.PSVariable.Get("ExecutionContext").Value            
      $ReadOptions.StatusMessageWriter=New-Object PSIonicTools.PSVerboseTextWriter($Context) 
   }    
  
   $ReadOptions.Encoding=$Encoding   

   if ($isProgressBar)
   { 
    $Logger.Debug("Gestion du ReadProgress via PSIonicTools.PSZipReadProgress")  
    $Context=$PSCmdlet.SessionState.PSVariable.Get("ExecutionContext").Value  
    $PSZipReadProgress=New-Object PSIonicTools.PSZipReadProgress($Context,
                                                                 $ProgressBarInformations.activityId,
                                                                 $ProgressBarInformations.activity
                                                                )
    $PSZipReadProgress.SetZipReadProgressHandler($ReadOptions)
   }   

    #On laisse la possibilité de supprimer unitairement les ressources ?
   $Logger.Debug("Add Dispose method on a ReadOption instance")  
   Add-Member -Inputobject $ReadOptions -Force ScriptMethod Dispose{
      if (($this.StatusMessageWriter -ne $null) -and  ($this.StatusMessageWriter -is [PSIonicTools.PSVerboseTextWriter]))
      {
         #On libère que ce que l'on crée
        $Logger.Debug("`t ReadOptions dispose PSStream") #<%REMOVE%>  
        $this.StatusMessageWriter.Dispose()
        $this.StatusMessageWriter=$null               
      }   
   } 
   #Si on passe utilise un paramètre de type [Ionic.Zip.ReadOptions]
   #on perd le membre synthétique Dispose() 
  $ReadOptions.PSObject.TypeNames.Insert(0,'PsionicReadOptions')
  $ReadOptions
}#New-ReadOptions

# Function Update-ZipFile {
# # .ExternalHelp PsIonic-Help.xml         
# 	[CmdletBinding()]
# 	param(
# 	)
# 
# 	Begin{
# 	} #begin
# 
# 	Process{
# 	} #process
#     
#     End {
#     } #end
# }#Update-ZipFile
# 
# Function Sync-ZipFile {
# # .ExternalHelp PsIonic-Help.xml         
# 	[CmdletBinding()]
# 	param(
# 	)
# 
# 	Begin{
# 	} #begin
# 
# 	Process{
# 	} #process
#     
#     End {
#     } #end
# }#Sync-ZipFile   
# 
# Function Split-ZipFile {
# # .ExternalHelp PsIonic-Help.xml         
# 	[CmdletBinding()]
# 	param(
# 	)
#  
# 	Begin{
# 	} #begin
# 
# 	Process{
# 	} #process
#     
#     End {
#     } #end
# }#Split-ZipFile 
# 
# 
# Function Join-ZipFile {
# # .ExternalHelp PsIonic-Help.xml         
# 	[CmdletBinding()]
# 	param(
# 	)
# 
# 	Begin{
# 	} #begin
# 
# 	Process{
# 	} #process
#     
#     End {
#     } #end
# }#Join-ZipFile
# 
# 
# Function Merge-ZipFile {
# # .ExternalHelp PsIonic-Help.xml         
# 	[CmdletBinding()]
# 	param(
# 	)
# 
# 	Begin{
# 	} #begin
# 
# 	Process{
# 	} #process
#     
#     End {
#     } #end
# }#Merge-ZipFile
#
#
# Function Update-ZipEntry {
# # .ExternalHelp PsIonic-Help.xml         
# 	[CmdletBinding()]
# 	param(
# 	)
# 
# 	Begin{
# 	} #begin
# 
# 	Process{
# 	} #process
#     
#     End {
#     } #end
# }#Update-ZipEntry
# 
# 
# Function Remove-ZipEntry {
# # .ExternalHelp PsIonic-Help.xml         
# 	[CmdletBinding()]
# 	param(
# 	)
# 	Begin{
# 	} #begin
# 
# 	Process{
# 	} #process
#     
#     End {
#     } #end
# }#Remove-ZipEntry 
# 
# 
# Function Rename-ZipEntry {
# # .ExternalHelp PsIonic-Help.xml         
# 	[CmdletBinding()]
# 	param(
# 	)
#  
# 	Begin{
# 	} #begin
# 
# 	Process{
# 	} #process
#     
#     End {
#     } #end
# }#Rename-ZipEntry 

#<INCLUDE %'PsIonic:\Tools\Resolve-PSPath.ps1'%>   

# Suppression des objets du module 
Function OnRemovePsIonicZip {
  $PsIonicShortCut.GetEnumerator()|
   Foreach {
     Try {
       $Logger.Debug("Remove TypeAccelerators $($_.Key)") #<%REMOVE%> 
       [void]$AcceleratorsType::Remove($_.Key)
     } Catch {
       write-Error -Exception $_.Exception 
     }
   }
#<DEFINE %DEBUG%>
#todo  Stop-Log4Net vérifier si + module utilise une config différente ou une dll de version différente !!!
#<UNDEF %DEBUG%>   
  
}#OnRemovePsIonicZip
 
# Section  Initialization
$MyInvocation.MyCommand.ScriptBlock.Module.OnRemove = { OnRemovePsIonicZip }
                                                        
Reset-PsIonicSfxOptions 
 
Set-Alias -name cmpzf   -value Compress-ZiFile
Set-Alias -name expzf   -value Expand-ZiFile
Set-Alias -name cnvsfx  -value ConvertTo-Sfx
Set-Alias -name fz      -value Format-ZipFile
Set-Alias -name tstzf   -value Test-ZipFile
Set-Alias -name gzf     -value Get-ZipFile
Set-Alias -name adze    -value Add-ZipEntry

Set-Alias -name nzfo    -value New-ZipSfxOptions
Set-Alias -name rzfo    -value Reset-PsIonicSfxOptions
Set-Alias -name szfo    -value Set-PsIonicSfxOptions
Set-Alias -name gzfo    -value Get-PsIonicSfxOptions

#<DEFINE %DEBUG%>
Set-Alias -name Set-DebugLevel -value Set-Log4NETDebugLevel
Set-Alias -name dbglvl         -value Set-Log4NETDebugLevel
Set-Alias -name sca            -value Stop-ConsoleAppender
#<UNDEF %DEBUG%> 

Export-ModuleMember -Variable Logger -Alias * -Function Compress-ZipFile,
                                                        ConvertTo-Sfx,
                                                        Add-ZipEntry,
                                                        Expand-ZipFile,
                                                        New-ProgressBarInformations,
                                                        New-ReadOptions,
                                                        New-ZipSfxOptions,
                                                        Reset-PsIonicSfxOptions,
                                                        Set-PsIonicSfxOptions,
                                                        Get-PsIonicSfxOptions,
                                                        Test-ZipFile,
                                                        Get-ZipFile,
                                                        Format-ZipFile,
                                                        ConvertFrom-CliXml,
                                                        ConvertTo-CliXml,
                                                        Expand-ZipEntry
                                                        #Update-ZipFile,
                                                        #Sync-ZipFile,
                                                        #Split-ZipFile,
                                                        #Join-ZipFile,
                                                        #Merge-ZipFile,
                                                        #Update-ZipEntry,
                                                        #Remove-ZipEntry,
                                                        #Rename-ZipEntry,