#PsIonic.psm1
# ------------------------------------------------------------------
# Depend : Ionic.Zip.Dll
# copyright (c) 2008 by Dino Chiesa
# ------------------------------------------------------------------

Add-Type -Path "$psScriptRoot\$($PSVersionTable.PSVersion)\PSIonicTools.dll"
 
#<DEFINE %DEBUG%>
Add-Type -Path "$psScriptRoot\$($PSVersionTable.PSVersion)\log4net.dll" 

Function Start-Log4Net {
#Paramètrage du log4net via un fichier XML spécifique au module         
  $ConfigFile=New-Object System.IO.fileInfo "$psScriptRoot\Log4Net.Config.xml"
  Write-debug("load '$psScriptRoot\Log4Net.Config.xml'") 
  [Log4net.Config.XmlConfigurator]::Configure($ConfigFile)
}#Start-Log4Net

Function Get-Loggger {
#Renvoi le logger principal
  [log4net.LogManager]::GetLogger('File')
} #Get-Loggger

Function Stop-Log4Net {
#Vide les buffers puis stop le framework log4net  
  $script:Logger.Debug("Shutdown log4Net") 
  
 [log4net.LogManager]::GetRepository().GetAppenders()|
  Where {$_ -is  [log4net.Appender.BufferingAppenderSkeleton]}|
  Foreach {
   $script:Logger.Debug("Flush appender $($_.Name)")           
    $_.Flush() 
  }

  [log4net.LogManager]::Shutdown() 
}#Stop-Log4Net

Function Set-Log4NETDebugLevel {
#Bascule le niveau global de log
 param (
   [log4net.Core.Level] $DefaultLevel=[log4net.Core.Level]::Info,
   [switch] $OFF 
 ) 
 
 If ($script:Logger -ne $null)
 { 
    If ($Off) 
     { $script:Logger.logger.Hierarchy.Root.Level=$DefaultLevel }
    else
     { $script:Logger.logger.Hierarchy.Root.Level==[log4net.Core.Level]::Debug } 
 }
 else
 { Write-Warning $MessageTable.LoggerDotNotExist }
}#Set-Log4NETDebugLevel

Function Stop-ConsoleAppender {
 If ($script:Logger -ne $null)
 { 
    $Console=$logger.Logger.Parent.Appenders|Where {$_.Name -eq 'Console'}
    $Console.Threshold=[log4net.Core.Level]::Off
 }
 else
 { Write-Warning $MessageTable.LoggerDotNotExist }
}#Stop-ConsoleAppender

Start-Log4Net
$Script:Logger=Get-Loggger
#<UNDEF %DEBUG%>   

Import-LocalizedData -BindingVariable MessageTable -Filename PsIonicLocalizedData.psd1 -EA Stop

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
    [Ionic.Zip.ZipFile] $Zip,
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

$AcceleratorsType= [PSObject].Assembly.GetType("System.Management.Automation.TypeAccelerators")
Try {
  $PsIonicShortCut.GetEnumerator() |
  Foreach {
   Try {
     $Logger.Debug("Add TypeAccelerators $($_.Key) =$($_.Value)") #<%REMOVE%>
     $AcceleratorsType::Add($_.Key,$_.Value)
   } Catch [System.Management.Automation.MethodInvocationException]{
     write-Error $_.Exception.Message 
   }
 } 
} Catch [System.Management.Automation.RuntimeException] {
   write-Error $_.Exception.Message
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

#   Fonctions spécifiques à PsIonic
function GetSFXname {
 param (
  [String] $FileName
 )
 $FileName -Replace '\.zip$',".exe"
} #GetSFXname

Function IsValueSupported {
#Utilisée dans un attribut ValidateScript
  [CmdletBinding(DefaultParameterSetName = "Compress")]
  param(
     [ValidateNotNullOrEmpty()] 
     [Parameter(Position=0, Mandatory=$true)]
    $Value,
     [Parameter(ParameterSetName="Extract")]
    [switch] $Extract,
     [Parameter(ParameterSetName="Compress")]
    [switch] $Compress
  )

 $Logger.Debug("Call= $($PsCmdlet.ParameterSetName)") #<%REMOVE%>
 
 if (&$IsValueSupported[$PsCmdlet.ParameterSetName] $Value)
 { 
   $Msg=$MessageTable.ValueNotSupported -F $value
   $Logger.Fatal($Msg)  #<%REMOVE%>
   Throw $Msg 
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
       [PSIonicTools.ZipPassword]::Reset($ZipFile) 
  }#ResetPassword                
  
  $Logger.Debug("Encryption configuration of the archive $($ZipFile.Name)") #<%REMOVE%>
   
  try {
    if ($Reset)
    {  ResetPassword }  # -> Encryption = None  
    else 
    {    
      $isPwdValid= [string]::IsNullOrEmpty($Password) -eq $false
      $isEncryptionValid=$DataEncryption -ne "None"
      
      If ($isPwdValid -and -not $isEncryptionValid)
      {
         $Logger.Debug("Encryption Weak")  #<%REMOVE%>
         $ZipFile.Encryption = "Weak"
         $ZipFile.Password = $Password
      }
      elseif (-not $isPwdValid -and -not $isEncryptionValid)
      { 
         ResetPassword #Encryption = None -> Reset
      }
      elseif ($DataEncryption -ne "None")
      {
         if ($isPwdValid)
         { 
           $Msg=$MessageTable.InvalidPasswordForDataEncryptionValue -F $Password,$DataEncryption
           $Logger.Fatal($Msg) #<%REMOVE%>
           Throw $Msg 
         }
         $Logger.Debug("Encryption $DataEncryption") #<%REMOVE%>
         $ZipFile.Encryption = $DataEncryption
         $ZipFile.Password = $Password
      }
      else
      { ResetPassword  }#Encryption = None -> Reset  
    }
   } 
   catch{
     $Msg=$MessageTable.ErrorSettingEncryptionValue -F $ZipFile.Name,$_.Exception.Message
     $Logger.Fatal($Msg) #<%REMOVE%>
     Throw $Msg
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
       #Ici pas récursion sur les sous-répertoires
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
  $Logger.DebugFormat($MessageTable.ConvertingFile, $TargetName)  #<%REMOVE%>
  Write-Verbose ($MessageTable.ConvertingFile -F $TargetName)
  try{
      $Zip.SaveSelfExtractor($TargetName, $Options)  
  }
  catch{
     $Msg=$MessageTable.ErrorSFX -F $TargetName,$_
     $Logger.Fatal($Msg,$_.Exception)  #<%REMOVE%>
     Throw $Msg
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
        Write-Debug("`t ZipFile Dispose PSStream") #<%REMOVE%> 
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
         Write-Debug("`t Dispose delegates") #<%REMOVE%> 
         #Récupère la liste des 'méthodes' à appeler
         # Au moins un, peut être de notre type : $_.Target -is [PSIonicTools.PSZipError]
        $ZipErrorDeleguate.GetInvocationList()|
        Foreach {
           Write-Debug("`t Dispose $_") #<%REMOVE%>
           #On supprime tous les abonnements  
          $Event.RemoveEventHandler($this,$_)
        }
      }
       #On appelle la méthode Dispose() de l'instance en cours               
      $this.Dispose()
  }            
} #AddMethodPSDispose
         
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
      [string]$Name, #todo array
        
        [Parameter(Position=0, Mandatory=$false, ParameterSetName="ReadOption")]
  	  [Ionic.Zip.ReadOptions] $ReadOptions=$null,
         
      [Ionic.Zip.SelfExtractorSaveOptions] $Options =$Script:DefaultSfxConfiguration,
  
        [ValidateScript( {$_ -ge 64Kb})]  
      [Int] $Split= 0, 
      
      [Ionic.Zip.ZipErrorAction] $ZipErrorAction=[Ionic.Zip.ZipErrorAction]::Throw,  
      
      [Ionic.Zip.EncryptionAlgorithm] $Encryption="None",
      
      [String] $Password,
      
      [string] $TempLocation =[System.IO.Path]::GetTempPath(), #Possible Security Exception
      
        [Parameter(Position=0, Mandatory=$false, ParameterSetName="ManualOption")]
      [System.Text.Encoding] $Encoding,
      
      [switch] $NotTraverseReparsePoints,
      [switch] $SortEntries,
        # N'est pas exclusif avec $WindowsTimeFormat 
      [switch] $UnixTimeFormat,    
        # N'est pas exclusif avec $UnixTimeFormat
      [switch] $WindowsTimeFormat,
        [Parameter(Position=0, Mandatory=$false, ParameterSetName="ManualOption")]
      [switch] $Follow
    )

  begin {
    [Switch] $isVerbose= $null
    [void]$PSBoundParameters.TryGetValue('Verbose',[REF]$isVerbose)
    $Logger.Debug("-Verbose: $isverbose") #<%REMOVE%>  
    
    if ($PsCmdlet.ParameterSetName -eq "ManualOption")
    { 
      $ReadOptions=New-ReadOptions $Encoding -Verbose:$isVerbose -Follow:$isFollow
    }
    elseif ($ReadOptions -eq $null)
    { 
      $ReadOptions=New-ReadOptions -Verbose:$isVerbose
    }
  }
 
  process {  
    try {
      $FileName = GetArchivePath $Name
      if($FileName -eq $null)
      { 
          $Msg=$MessageTable.InvalidValue -F $Name
          $Logger.Fatal($Msg) #<%REMOVE%>
          Write-Error $Msg 
          return $null
      }
         
      $ZipFile = [Ionic.Zip.ZipFile]::Read($FileName, $ReadOptions)
     
      $ZipFile.UseZip64WhenSaving=[Ionic.Zip.Zip64Option]::AsNecessary
      $ZipFile.ZipErrorAction=$ZipErrorAction
  
      SetZipErrorHandler $ZipFile
      AddMethodPSDispose $ZipFile
  
      $ZipFile.SortEntriesBeforeSaving=$SortEntries
      $ZipFile.TempFileFolder=$TempLocation 
      $ZipFile.EmitTimesInUnixFormatWhenSaving=$UnixTimeFormat
      $ZipFile.EmitTimesInWindowsFormatWhenSaving=$WindowsTimeFormat
      
      if (-not [string]::IsNullOrEmpty($Password) -or ($DataEncryption -ne "None"))
      { SetZipFileEncryption $ZipFile $Encryption $Password }
       #Les autres options sont renseignées avec les valeurs par défaut
      ,$ZipFile
    }
    catch [System.Management.Automation.ItemNotFoundException],[System.Management.Automation.DriveNotFoundException]
    {
      $Logger.Fatal($_.Exception.Message) #<%REMOVE%>
      Write-Error $_.Exception.Message
    }     
  } #Process
} #Get-ZipFile

Function Compress-ZipFile {
# .ExternalHelp PsIonic-Help.xml          
   [CmdletBinding(DefaultParameterSetName="File")] 
   [OutputType("File",[Ionic.Zip.ZipFile])] #Emet une instance de ZipFile
   [OutputType("SFX",[System.IO.FileInfo])]  #Emet une instance de fichier .exe
	param( 
        [Parameter(Mandatory=$true,ValueFromPipeline = $true)]
      $File,
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
      { Throw $MessageTable.CommentMaxValue }
      
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
      AddMethodPSDispose $ZipFile

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
      GetObjectByType $File -Recurse:$Recurse|
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
        throw $_
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
    [string] $EntryName, 
    [string] $DirectoryPath=[string]::Empty,
    [switch] $Passthru
  )
   begin {
   [type[]] $private:ParameterTypesOfAddEntryMethod=[string],[byte[]]
   $private:AddEntryMethod=[Ionic.Zip.ZipFile].GetMethod("AddEntry",$private:ParameterTypesOfAddEntryMethod) 
 }#begin
 
 process {
  try {
    $Logger.Debug("Add $Object")  #<%REMOVE%>
    $isCollection=isCollection $Object
    if ($isCollection -and ($Object -is [byte[]]))
    { 
      $Logger.Debug("Add Byte[]")  #<%REMOVE%>
      if ([string]::IsNullOrEmpty($EntryName))
      { 
        Write-Error ($MessageTable.ParameterStringEmpty -F 'EntryName')
        return
      }
        #Problem with 'distance algorithm' ?
        # http://stackoverflow.com/questions/13084176/powershell-method-overload-resolution-bug  
        #  public ZipEntry AddEntry(string entryName, string content)  
        # public ZipEntry AddEntry(string entryName, byte[] byteContent)
      $params = @($EntryName, ($Object -as [byte[]]) )
      $ZipEntry=$private:AddEntryMethod.Invoke($ZipFile, $params)
    }
    elseif ($isCollection)
    {
       $Logger.Debug("Recurse Add-Entry")  #<%REMOVE%>
       $Object.GetEnumerator()|
        GetObjectByType $File|
        Add-ZipEntry $ZipFile -Passthru:$Passthru      
    }
    elseif ($Object -is [System.String])
    { 
       $Logger.Debug("Add String")  #<%REMOVE%>
       if ([string]::IsNullOrEmpty($EntryName))
       { 
         Write-Error ($MessageTable.ParameterStringEmpty -F 'EntryName')
         return  
       }
       $ZipEntry=$ZipFile.AddEntry($EntryName, $Object -as [string]) 
    }
    elseif ($Object -is [System.IO.DirectoryInfo])
    { 
      $Logger.Debug("Add Directory ")  #<%REMOVE%>
      $ZipEntry=$ZipFile.AddDirectory($Object.FullName, $Object.Name)
    }
    elseif ($Object -is [System.IO.FileInfo])
    { 
      $Logger.Debug("Add Fileinfo")  #<%REMOVE%>
       #($DirectoryPath -eq [string]::Empty) add on the root
       # IOnic doit connaitre le chemin complet sinon il est considéré comme relatif
     $ZipEntry=$ZipFile.AddFile($Object.FullName,$DirectoryPath)  
    }
    elseif ($Object -is [Ionic.Zip.ZipEntry])
    {
      $Logger.Debug("Add ZipEntry")  #<%REMOVE%>
      Write-Error "Under construction"
    }
    else
    {
      $Msg=$MessageTable.TypeNotSupported -F $MyInvocation.MyCommand.Name,$Object.GetType().FullName
      $Logger.Debug($Msg)  #<%REMOVE%>
      Write-Warning $Msg   
    }
    if ($Passthru)
    {$ZipEntry} 
   }
   catch { #ArgumentNullException or ArgumentException
    Write-Error ($MessageTable.AddEntryError -F $Object,$ZipFile.Name,$_.Exception.Message)
   }

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
	if($Object -is [System.IO.FileInfo])  
	{ return $Object.FullName  }
    elseif( $Object -is [System.IO.DirectoryInfo])
    { 
      $Logger.Debug("The objects of the type directory are excluded : $Object") #<%REMOVE%> 
      Write-Verbose "The objects of the type directory are excluded : $Object"  
      return $null 
    }
	elseif($Object -is [String])
	{ $ArchivePath = $Object  }
	else
	{   
       $Logger.Debug("Transformation to string") #<%REMOVE%>    
       $ArchivePath = $Object.ToString() 
    }
    if ([string]::IsNullOrEmpty($ArchivePath) )
    {
      $Logger.Debug("The file name is empty or ToString() return an empty string.") #<%REMOVE%>
      Write-Verbose "The file name is empty or ToString() return an empty string." 
      return $null 
    }
    
    $Logger.Debug("The file name is '$ArchivePath'") #<%REMOVE%>
    try {
      $List=@(Resolve-Path $ArchivePath -ea Stop)
    } 
    catch [System.Management.Automation.ActionPreferenceStopException] 
    { 
      throw $_.Exception 
    }

    if ($List.Count -eq 0) { return $null }
     
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

Function Expand-ZipFile { 
# .ExternalHelp PsIonic-Help.xml         
    [CmdletBinding(DefaultParameterSetName="Default")] 
	[OutputType("Default",[Ionic.Zip.ZipFile])]
    [OutputType("List",[Ionic.Zip.ZipEntry])]
	param(
		[parameter(Mandatory=$True,ValueFromPipeline=$True)]
	  $File,        
 
        [ValidateNotNullOrEmpty()] 
        [parameter(Position=0,Mandatory=$True, ParameterSetName="Default")]
	  $Destination,
	    
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
      [switch] $Interactive,
       
       [Parameter(Mandatory=$false, ParameterSetName="List")]
      [switch] $List,
      [switch] $Flatten,
      [switch] $Follow,
      [switch] $Passthru,
      [switch] $Create
	)

  Begin{
    [Switch] $isVerbose= $null
    [void]$PSBoundParameters.TryGetValue('Verbose',[REF]$isVerbose)
    
    $isFollow=$PSBoundParameters.ContainsKey('Follow')
    
    $ReadOptions=New-ReadOptions $Encoding -Verbose:$isVerbose -Follow:$isFollow
    
    if ($PsCmdlet.ParameterSetName -eq 'Default') 
    {
      $isDestinationExist=Test-Path $Destination
      if (-not $isDestinationExist -and $Create ) 
      { 
         $Logger.Debug("Create `$Destination directory $DestinationExist") #<%REMOVE%>
         Md $Destination > $Null
      }
      elseif(-not $isDestinationExist)
      { throw ($MessageTable.PathMustExist -F $Destination) } 
    }
     # Au cas où la destination est un chemin relatif, on récupère le chemin complet 
    if(-not $List)
    {
      $Destination = Resolve-Path $Destination|
                      Foreach { $_.Path } 
    }
  
    #dotNet reflection
    [type[]] $private:ParameterTypesOfExtractSelectedEntriesMethod=[string],[string],[string],[Ionic.Zip.ExtractExistingFileAction]
    $private:ExtractSelectedEntriesMethod=[Ionic.Zip.ZipFile].GetMethod("ExtractSelectedEntries",$private:ParameterTypesOfExtractSelectedEntriesMethod)
    
    Function ZipFileRead {
      try{
        $Logger.Debug("Read the file $zipPath") #<%REMOVE%> 
        $ZipFile = [ZipFile]::Read($FileName,$ReadOptions)
        $ZipFile.FlattenFoldersOnExtract = $Flatten  
        
        AddMethodPSDispose $ZipFile
        return ,$zipFile
      }
      catch {
        DisposeZip
        $Msg=$MessageTable.ZipArchiveReadError -F $FileName.ToString(), $_.Exception.Message
        $Logger.Fatal($Msg,$_.Exception) #<%REMOVE%>
        throw $Msg
      }              
    }#ZipFileRead
    
    function ExtractEntries {
      try{
        $isDispose=$true 
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
                   #bug null to string, use reflection
                  $params = @($Query,$Null,$Destination,$ExtractAction)
                  $ZipEntry=$private:ExtractSelectedEntriesMethod.Invoke($ZipFile, $params)                        
              }
              else{
                  $ZipFile.ExtractSelectedEntries($Query,$From,$Destination,$ExtractAction)  
              }
          }
          else{ 
              $Logger.Debug("Extraction without query.") #<%REMOVE%>
              $ZipFile.ExtractAll($Destination,$ExtractAction)
              if ($Passthru){
                $Logger.Debug("Send ZipFile instance") #<%REMOVE%>
                $isDispose=$false 
                return $ZipFile.PSbase
              }              
          }#else isnotnul $Query
       }#else
      }#try
      catch [Ionic.Zip.BadPasswordException]{
         throw ($MessageTable.ZipArchiveBadPassword -F $zipPath)
      }
      catch{
         $Msg=$MessageTable.ZipArchiveExtractError -F $zipPath, $_.Exception.Message
         $Logger.Fatal($Msg,$_.Exception) #<%REMOVE%>
         if ($_.Exception -is [Ionic.Zip.ZipException]) 
         {throw $Msg}
         else 
         {
           $Logger.Error($Msg) #<%REMOVE%>
           Write-Error
      }
      finally{
        if ($isDispose)
        { DisposeZip }
      }             
    }#ExtractEntries
 }#begin

 Process{
  Foreach($Archive in $File){
   try {
      $zipPath = GetArchivePath $Archive
      if ( $zipPath -eq $null )  
      { 
         # usage de ToString() pour éviter un bug v2
        $Msg=$MessageTable.InvalidValue -F $Archive.ToString()
        $Logger.Error($Msg) #<%REMOVE%>
        Write-Error $Msg 
      }
      else 
      {
        Foreach($FileName in $ZipPath){
          $Logger.Debug("Full path name : $FileName") #<%REMOVE%>
          $zipFile= ZipFileRead
          if ($ZipFile.Count -eq 0)
          {
            $Logger.Debug("No entries in the archive") #<%REMOVE%> 
            if ($Passthru)
            { return $ZipFile.PSbase }
            else 
            { 
              DisposeZip 
              return $null            
            } 
          }
          ExtractEntries
        }#foreach zipFile
      }#else zipath null
    }
    catch [System.Management.Automation.ItemNotFoundException],[System.Management.Automation.DriveNotFoundException]
    {
      $Logger.Error($_.Exception.Message) #<%REMOVE%>
      if (-not $isValid) 
      {Write-Error $_.Exception.Message}
   }   
  }#Foreach  
 } #process
 
 end {
   if ($ReadOptions -ne $null)
   { $ReadOptions.Dispose() }
 }   
}#Expand-ZipFile

Function TestZipArchive {
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

    $Logger.Debug("Est-ce une archive et peut-on l'extraire ?") #<%REMOVE%>
    try{
        $isZipFile = [ZipFile]::isZipFile($Archive, $isValid)
    }
    catch{
        throw ($MessageTable.TestisArchiveError -F $Archive,$_)
    }

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
          throw ($MessageTable.ZipArchiveCheckIntegrityError -F $Archive,$_)
      }
    }

    if($isZipFile -and -not [string]::IsNullOrEmpty($Password)){
        $Logger.Debug("Contrôle du mot de passe sur l'archive")  #<%REMOVE%>
        try{
            $goodPassword = [ZipFile]::CheckZipPassword($Archive, $Password)
        }
        catch{
            throw ($MessageTable.ZipArchiveCheckPasswordError -F $Archive,$_)
        }
    }

    $GlobalCheck = ($isZipFile -and $goodPassword -and $checkZip)

    if($Passthru)
    {
        if($GlobalCheck){
            $Logger.Debug("Send the archive name into the pipeline : $Archive")  #  %REMOVE%
            write-output $Archive
        } 
        else{             
            if(-not $isZipFile -And -not $isValid){
                $PSCmdlet.WriteError(
                  (New-Object System.Management.Automation.ErrorRecord(
                    (New-Object Ionic.Zip.BadReadException($MessageTable.isNotZipArchiveWarning -F $Archive)), 
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
                    (New-Object Ionic.Zip.BadPasswordException($MessageTable.isBadPasswordWarning -F $Archive)), 
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
                    (New-Object Ionic.Zip.BadCrcException($MessageTable.isCorruptedZipArchiveWarning -F $Archive)), 
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
	  $File, 
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
   }
    Process{
        Foreach($Archive in $File){  
          try {  
            $zipPath = GetArchivePath $Archive -Verbose:$isVerbose
         	if((-not $isValid) -and ($zipPath -eq $null))
         	{ 
                 # usage de ToString() pour éviter un bug v2
                $Msg=$MessageTable.InvalidValue -F $Archive.ToString()
                $Logger.Error($Msg) #<%REMOVE%>
                Write-Error $Msg
             }
             else {
              Foreach($ZipFile in $ZipPath){
               $Logger.Debug("Full path name : $zipFile ") #<%REMOVE%>
               Write-Output (TestZipArchive -Archive $zipFile -isValid:$isValid -Check:$Check -Repair:$Repair -Password:$Password -Passthru:$Passthru)
              }
            }
          }
          catch [System.Management.Automation.ItemNotFoundException],[System.Management.Automation.DriveNotFoundException]
          {
            $Logger.Fatal($_.Exception.Message) #<%REMOVE%>
            if (-not $isValid) 
            {Write-Error $_.Exception.Message}
         }   
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
  	[Ionic.Zip.ReadOptions] $ReadOptions=$null, 
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

function New-ReadOptions {
 # .ExternalHelp PsIonic-Help.xml         
  [CmdletBinding()]
  [OutputType([Ionic.Zip.ReadOptions])]
  Param (
        [Parameter(Position=0, Mandatory=$false)]
      [System.Text.Encoding] $Encoding=[Ionic.Zip.ZipFile]::DefaultEncoding,  
      [switch] $Follow
  ) 
   [Switch] $isVerbose= $null
   [void]$PSBoundParameters.TryGetValue('Verbose',[REF]$isVerbose)
   $Logger.Debug("-Verbose: $isverbose") #<%REMOVE%>  
       
   $isFollow=$PSBoundParameters.ContainsKey('Follow')
   $ReadOptions=New-Object Ionic.Zip.ReadOptions 
   #Renseigne les membres de l'instance ZipFile à partir des options
   #  ZipFile.PSDispose supprimera bien les ressources allouées ici
   if ($isVerbose)
   {
      $Logger.Debug("Configure PSVerboseTextWriter") #<%REMOVE%>
      $Context=$PSCmdlet.SessionState.PSVariable.Get("ExecutionContext").Value            
      $ReadOptions.StatusMessageWriter=New-Object PSIonicTools.PSVerboseTextWriter($Context) 
   }    
  
   $ReadOptions.Encoding=$Encoding   

   if ($Follow) {Write-Warning "Under construction"}   

    #On laisse la possibilité de supprimer unitairement les ressources ?
   $Logger.Debug("Add Dispose method on a ReadOption instance")  #<%REMOVE%>
   Add-Member -Inputobject $ReadOptions -Force ScriptMethod Dispose{
      if (($this.StatusMessageWriter -ne $null) -and  ($this.StatusMessageWriter -is [PSIonicTools.PSVerboseTextWriter]))
      {
         #On libère que ce que l'on crée
        Write-Debug("`t ReadOptions dispose PSStream") #<%REMOVE%> 
        $this.StatusMessageWriter.Dispose()
        $this.StatusMessageWriter=$null               
      }   
   } 
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

# Suppression des objets du module 
Function OnRemovePsIonicZip {
  $PsIonicShortCut.GetEnumerator()|
   Foreach {
     Try {
       $Logger.Debug("Remove TypeAccelerators $($_.Key)") #<%REMOVE%> 
       [void]$AcceleratorsType::Remove($_.Key)
     } Catch {
       write-Error $_.Exception.Message
     }
   }
#<DEFINE %DEBUG%>
  Stop-Log4Net
#<UNDEF %DEBUG%>   
  
}#OnRemovePsIonicZip
 
# Section  Initialization
$MyInvocation.MyCommand.ScriptBlock.Module.OnRemove = { OnRemovePsIonicZip }

Reset-PsIonicSfxOptions 
 
Set-Alias -name cmpzf       -value Compress-ZiFile
Set-Alias -name expzf       -value Expand-ZiFile
Set-Alias -name cnvsfx      -value ConvertTo-Sfx
Set-Alias -name fz          -value Format-ZipFile

#<DEFINE %DEBUG%>
Set-Alias -name Set-DebugLevel -value Set-Log4NETDebugLevel
Set-Alias -name dbglvl         -value Set-Log4NETDebugLevel
Set-Alias -name sca            -value Stop-ConsoleAppender
#<UNDEF %DEBUG%> 

Export-ModuleMember -Variable Logger -Alias * -Function Compress-ZipFile,
                                                        #<DEFINE %DEBUG%>
                                                         Set-Log4NETDebugLevel,
                                                         Stop-ConsoleAppender,                                                          
                                                        #<UNDEF %DEBUG%> 
                                                        ConvertTo-Sfx,
                                                        Add-ZipEntry,
                                                        Expand-ZipFile, 
                                                        New-ReadOptions,
                                                        New-ZipSfxOptions,
                                                        Reset-PsIonicSfxOptions,
                                                        Set-PsIonicSfxOptions,
                                                        Get-PsIonicSfxOptions,
                                                        Test-ZipFile,
                                                        Get-ZipFile,
                                                        Format-ZipFile
                                                        #Update-ZipFile,
                                                        #Sync-ZipFile,
                                                        #Split-ZipFile,
                                                        #Join-ZipFile,
                                                        #Merge-ZipFile,
                                                        #Update-ZipEntry,
                                                        #Remove-ZipEntry,
                                                        #Rename-ZipEntry,
