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
         Throw $Msg 
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
     Throw (New-Object System.Exception($Msg,$_.Exception))
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
      Write-Debug("Dispose $($this.Name)") #<%REMOVE%               
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
        Write-Debug("Close : save $($this.Name)") #<%REMOVE%
        $this.Save()
      }
      catch [Ionic.Zip.BadStateException]
      {
        if  ($this.name.EndsWith(".exe"))
        { Write-Error $PsIonicMsgs.SaveIsNotPermitted } 
      } 
      finally {
       #On appelle la méthode Dispose() de l'instance en cours  
       Write-Debug("Close : PSDispose $($this.Name)") #<%REMOVE%             
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
    Foreach($Current in $Name){
     try {
        $FileName = GetArchivePath $Current
        if($FileName -eq $null)
        { 
            $Msg=$PsIonicMsgs.InvalidValue -F $Name.ToString()
            $Logger.Fatal($Msg) #<%REMOVE%>
            Write-Error $Msg 
            return $null
        }
        if ((TestZipArchive -Archive $FileName  -Password $Password -Passthru ) -ne $null)
        {   
          $ZipFile = [Ionic.Zip.ZipFile]::Read($FileName, $ReadOptions)
         
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
     catch [System.Management.Automation.ItemNotFoundException],[System.Management.Automation.DriveNotFoundException]
     {
        $Logger.Fatal($_.Exception.Message) #<%REMOVE%>
        Write-Error $_.Exception.Message
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
      { Throw $PsIonicMsgs.CommentMaxValue }
      
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
        Throw (New-Object System.Exception($_,$_.Exception))
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
       $Logger.Debug("Recurse Add-Entry")  #<%REMOVE%>
       $InputObject.GetEnumerator()|
        GetObjectByType $File|
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
    Write-Error ($PsIonicMsgs.AddEntryError -F $InputObject,$ZipFile.Name,$_.Exception.Message)
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

Function Expand-Entry { 
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
        { $Entry.Extract($Stream)}
        else 
        { 
          $msg=$PsIonicMsgs.ExpandEntryError -F $EntryName,$ZipFile.Name
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
        { $Data=$Result -as [String] }
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
} #Expand-Entry

Function Expand-ZipFile { 
# .ExternalHelp PsIonic-Help.xml         
    [CmdletBinding(DefaultParameterSetName="Default")] 
	[OutputType("Default",[Ionic.Zip.ZipFile])]
    [OutputType("List",[Ionic.Zip.ZipEntry])]
	param(
		[parameter(Mandatory=$True,ValueFromPipeline=$True)]
	  $File,        
 
        [ValidateNotNullOrEmpty()] 
        [parameter(Position=0,Mandatory=$True, ValueFromPipelineByPropertyName=$True, ParameterSetName="Default")]
	  [PSObject]$Destination,
	    
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
       [Parameter(Mandatory=$false, ParameterSetName="Default")]
      [switch] $Create
	)

  Begin{
    [Switch] $isVerbose= $null
    [void]$PSBoundParameters.TryGetValue('Verbose',[REF]$isVerbose)
    
    $isFollow=$PSBoundParameters.ContainsKey('Follow')
    $isDefaultParameterSetName= $PsCmdlet.ParameterSetName -eq 'Default'
    
    $ReadOptions=New-ReadOptions $Encoding -Verbose:$isVerbose -Follow:$isFollow
    
    Function ZipFileRead {
      try{
        $Logger.Debug("Read the file $zipPath") #<%REMOVE%> 
        $ZipFile = [ZipFile]::Read($FileName,$ReadOptions)
        $ZipFile.FlattenFoldersOnExtract = $Flatten  
        
        AddMethods $ZipFile
        return ,$zipFile
      }
      catch {
        DisposeZip
        $Msg=$PsIonicMsgs.ZipArchiveReadError -F $FileName.ToString(), $_.Exception.Message
        $Logger.Fatal($Msg,$_.Exception) #<%REMOVE%>
        throw (New-Object System.Exception($Msg,$_.exception))
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
                  $Logger.Debug("Destination=$Destination") #<%REMOVE%>
                  $Logger.Debug("ExtractAction=$ExtractAction") #<%REMOVE%>
                  
                   #bug null to string, use reflection
                  [type[]] $private:ParameterTypesOfExtractSelectedEntriesMethod=[string],[string],[string],[Ionic.Zip.ExtractExistingFileAction]
                  $ExtractSelectedEntriesMethod=[Ionic.Zip.ZipFile].GetMethod("ExtractSelectedEntries",$private:ParameterTypesOfExtractSelectedEntriesMethod)
                  $params = @($Query,$Null,($Destination.ToString()),$ExtractAction)
                  $ZipEntry=$ExtractSelectedEntriesMethod.Invoke($ZipFile, $params)                        
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
                return ,$ZipFile
              }              
          }#else isnotnul $Query
       }#else
      }#try
      catch [Ionic.Zip.BadPasswordException]{
         throw (New-Object System.Exception(($PsIonicMsgs.ZipArchiveBadPassword -F $zipPath),$_.Exception))
         
      }
      catch{
         $Msg=$PsIonicMsgs.ZipArchiveExtractError -F $zipPath, $_.Exception.Message
         if (($_.Exception -is [Ionic.Zip.ZipException]) -and ($ZipFile.ExtractExistingFile -ne "Throw") ) 
         {
           $Logger.Fatal($Msg,$_.Exception) #<%REMOVE%>
           throw (New-Object System.Exception($Msg,$_.Exception))
         }
         else 
         {
           $Logger.Error($Msg) #<%REMOVE%>
           Write-Error $Msg
         }
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
        $Msg=$PsIonicMsgs.InvalidValue -F $Archive.ToString()
        $Logger.Error($Msg) #<%REMOVE%>
        Write-Error $Msg 
      }
      else 
      {
                                
        if ($isDefaultParameterSetName) 
        {
           #Le chemin de destination doit être valide  
           #le chemin valide doit exister
           #Le chemin doit référencer le FileSystem
          $PSPathInfo=Resolve-PSPath $zipPath
          $Destination=$PSPathInfo.ResolvedPath
          
          if (-not $PSPathInfo.IsCandidate()) 
          {
             $Msg=$PsIonicMsgs.PathIsNotAFileSystemPath -F $Destination
             $Logger.Error($Msg) #<%REMOVE%>
             Write-Error $Msg
             continue 
          }
          if ($Create)
          {
              #On le cré si possible
              if ($PSPathInfo.IsValidForCreation())
              {              
                $Logger.Debug("Create `$Destination directory $isDestinationExist") #<%REMOVE%>
                Md $Destination > $Null
              }
          }
          elseif (-not $PSPathInfo.IsValidForExtraction())
          { throw ($PsIonicMsgs.PathMustExist -F $Destination) }            
         }
       }  
              
        Foreach($FileName in $ZipPath){
          $Logger.Debug("Full path name : $FileName") #<%REMOVE%>
          $zipFile= ZipFileRead
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
    #todo doc
    $Logger.Debug("Est-ce une archive ?") #<%REMOVE%>
    try{
        $isZipFile = [ZipFile]::isZipFile($Archive, $isValid)
    }
    catch{
        throw (New-Object System.Exception(($PsIonicMsgs.TestisArchiveError -F $Archive,$_),$_.Exception)) 
        
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
         throw (New-Object System.Exception(($PsIonicMsgs.ZipArchiveCheckIntegrityError -F $Archive,$_),$_.Exception))
      }
    }

    if($isZipFile -and -not [string]::IsNullOrEmpty($Password)){
        $Logger.Debug("Contrôle du mot de passe sur l'archive")  #<%REMOVE%>
        try{
            $goodPassword = [ZipFile]::CheckZipPassword($Archive, $Password)
        }
        catch{
            throw (New-Object System.Exception(($PsIonicMsgs.ZipArchiveCheckPasswordError -F $Archive,$_),$_.Exception))
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
    $Logger.Debug("-Verbose: $isVerbose") #<%REMOVE%>  
   }
    Process{
        Foreach($Archive in $File){  
          try {  
            $zipPath = GetArchivePath $Archive -Verbose:$isVerbose
         	if((-not $isValid) -and ($zipPath -eq $null))
         	{ 
                 # usage de ToString() pour éviter un bug v2
                $Msg=$PsIonicMsgs.InvalidValue -F $Archive.ToString()
                $Logger.Error($Msg) #<%REMOVE%>
                Write-Error $Msg
             }
             else {
              Foreach($ZipFile in $ZipPath){
               $Logger.Debug("Full path name : $zipFile ") #<%REMOVE%>
               if ($PsCmdlet.ParameterSetName -eq "File")
               {TestZipArchive -Archive $zipFile -isValid:$isValid -Check:$Check -Repair:$Repair -Password $Password -Passthru:$Passthru -verbose:$isVerbose}
               else
               {TestZipArchive -Archive $zipFile -isValid:$isValid -Check:$Check -Repair:$Repair -Password $Password -verbose:$isVerbose}
              }
            }
          }
          catch [System.Management.Automation.ItemNotFoundException],[System.Management.Automation.DriveNotFoundException]
          {
            $Logger.Fatal($_.Exception.Message) #<%REMOVE%>
             # On émet dans le pipe que les nom des fichiers existant (-passthru) ou les nom des archives valides (-isValid -passthru) 
             # Tous les fichiers inexistant et toutes les archives existantes invalides ne sont donc pas émises.
            if (($PsCmdlet.ParameterSetName -ne "File") -or ($Passthru -eq $false))
            { write-output $false }
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


function Test-UNCPath {
#Valide si un chemin est au format UNC (IPv4 uniquement).
#On ne valide pas l'existence du chemin

 param(  
  [string] $Path
  )
 try {
  $Uri=[uri]$Path.Replace('/','\')
    #Le nom de chemin doit comporter au moins deux segments :  : \\server\share\file_path
   #et il doit débuter par '\\' ou '//' et ne pas être suivi de '\' ou de'/'
   $isValid=($Uri -ne $Null) -and ($Uri.Segments -ne $null) -and ($Uri.Segments.Count -ge 2) -and ($Path -match '^(\\{2}|/{2})(?!(\\|/))')
   
   Write-Debug "[Test-UNCPath] isValid=$isValid isUNnc=$($Uri.IsUnc) $Path $($Uri.LocalPath)"
 }
 catch [System.Management.Automation.RuntimeException] { #[System.ArgumentNullException],[System.UriFormatException]{
   Write-Debug "$_"
   $isValid=$false
 }
 $isValid
} #Test-UNCPath
(Get-Item function:Test-UNCPath).Description='Test un chemin UNC'

Function Resolve-PSPath{
#Version 1.0
 [CmdletBinding(DefaultParameterSetName = "Path")]          
 param(
    [Parameter(Mandatory=$true,ValueFromPipeline=$true,ParameterSetName="Path")]
   [string]$Path,
    [Parameter(Mandatory=$true,ValueFromPipeline=$true, ParameterSetName="LitteralPath")]
   [String]$LitteralPath
 )

 begin { 
    Function New-PSPathInfoError{
     #construit une string affectée à la propriété LastError
      param ($ErrorRecord)
     Return "[{0}] {1}" -F $ErrorRecord.Exception.GetType().FullName,$ErrorRecord.Exception.Message
    }#New-PSPathInfoError

    Function New-PSPathInfo{
     #construit un objet portant les informations d'analyse d'un PSPath
     param(
        [Parameter(position=1)]
      $Name,
      [switch] $asLitteral
    )
      Write-debug "name=$name"
      $Helper = $ExecutionContext.SessionState.Path
      $O=New-Object PSObject -Property @{
         # !! Certaines propriétés boolean sont affectées par défaut à $false
         #Leurs interprétation dépendent de la propriété LastError.
         #Par exemple pour un nom de chemin référençant un provider inexistant, 
         #Bien que dans ce cas IsAbsolute=$false, on ne peut en conclure que le nom de chemin est relatif.
          
                #Nom du chemin à analyser
              Name=$Name;
              
               #Mémorise le type d'interprétation du path
              asLitteral=$asLitteral
              
               #Indique si le chemin résolu est valide
              isValid=$false
              
               #Nombre de fichier si le globbing est détecté
               #Le globbing peut être détecté sans pour autant que le chemin renvoit de fichier
              Count=0;
               
               #Texte de la dernière exception rencontrée (exceptions gérées uniquement)
              LastError=$Null;
               
               #Contient le nom réel du chemin. 
               #Par exemple avec 'New-PSDrive -name TestsWinform -root G:\PS\Add-Lib\Add-Lib\trunk\Tests\Convert-Form -psp FileSystem'
               #Pour 'TestsWinform:\1Form1.Designer.cs' on renvoi 'G:\PS\Add-Lib\Add-Lib\trunk\Tests\Convert-Form\1Form1.Designer.cs'
               #
               #Peut être vide selon le provider pointé et la syntaxe utilisée: 
               #'Alias:','FeedStore:','Function:','PscxSettings:\'
               #ex: cd function: ; $pathHelper.GetUnresolvedProviderPathFromPSPath('.') -> renvoi une chaîne vide. cf. Capacités du provider.
              ResolvedPath=$Null;
               
               #Indique si le drive existe ou pas
              isDriveExist=$false;
               
               #Indique si l'élément existe ou pas.
              isItemExist=$False;
               
               #Précise si le provider indiqué par le nom de chemin $Name est celui du FileSystem
              isFileSystemProvider=$False;
               
               #Référence le provider du nom de chemin contenu dans $Name
              isProviderExist=$False;
               
               #Nom du provider associé au chemin $Name, soit il est précisé dans le nom, soit c'est le lecteur qui, s'il existe, porte l'info.
               #Pour les chemins relatif c'est le nom du provider du drive courant. Le résultat dépend donc de la localisation.
              Provider=$Null;
               
               #Le nom de chemin ne contient pas de nom de drive, ce qui est le cas d'un chemin ralatif, de '~' et d'un chemin de type UNC
              isAbsolute=$False;
               
               #contient $True si le nom de chemin commence par 'NomDeProvider::'
              isProviderQualified=$False;
               
               #Indique si le nom de chemin contient des caractères joker Powershell. 
               # PS globbing comprend les caractères suivants :  *,?,[]
               #Si le paramètre -Litteral est utilisé cette propriété vaut $false  
              isWildcard=$False;
               
               #Indique si le nom du provider de la localisation courante est le provider FileSystem
              isCurrentLocationFileSystem =$Helper.CurrentFileSystemLocation.Path -eq $Helper.CurrentLocation.Path
              
              #ATTENTION le nom du drive peut contenir des jokers ( 'C*' ) ou des espaces, exemple : ' C:\Temp\foo.txt'
                #dans ce cas le caractére espace est recopié dans Drivename. Il est possible de nommer un drive avec des espaces :
                # New-PSDrive -Name ' Toto' -PSProvider FileSystem -Root C:\Temp
                # Dir ' Toto:' 
                #
                #Pour un chemin UNC le nom du drive pointé est inconnu.             
               DriveName=$Null;
               
               #Nom du drive en cours lors de l'appel.
               #contient le nom du drive courant ou le nom du provider si le chemin est ProviderQualified.
               CurrentDriveName=$null;
               
               #Indique si le chemin est au format UNC
               #Si UNC égale $true et que absolute est $false
               #alors Provider et isFileSystemProvider référence le provider courant, 
               # ce qui ne réfléte pas celui porté par ResolvedPath
               isUNC=$false
             }          
      $O.PsObject.TypeNames.Insert(0,"PSPathInfo")
      $O
      #$O|Add-Member ScriptMethod ToString {$this.Name} -Force -Passthru
    }# New-PSPathInfo
 
   $pathHelper = $ExecutionContext.SessionState.Path
   
   # $PSBoundParameters.ContainsKey("ErrorAction") -and $PSBoundParameters["ErrorAction"]
   $_EA= $null
   [void]$PSBoundParameters.TryGetValue('ErrorAction',[REF]$_EA)
   if ($_EA -ne $null) 
   { $ErrorActionPreference=$_EA}
   
   Write-Debug "Resolve-PSPath.Begin `$ErrorActionPreference=$ErrorActionPreference" 
 }#begin
  
 process {
   try {
     $isLitteral = $PsCmdlet.ParameterSetName -eq 'LitteralPath'
     if ( $isLitteral )
     { $CurrentPath=$LitteralPath }
     else
     { $CurrentPath=$Path }

     Write-Debug  "CurrentPath=$CurrentPath"
     $Infos=New-PSPathInfo $CurrentPath -asLitteral:$isLitteral

     $Infos.IsProviderQualified=$pathHelper.IsProviderQualified($CurrentPath)
     $ProviderInfo=$DriveInfo=$CurrentDriveName=$null
    
      #Récupère le nom du drive
      #Ne déclenche pas d'exception pour les chemins erronés, sauf si $PsPath=$null
      #
      #Si le path est relatif alors Absolute est faux, dans ce cas le drive renvoyé est le drive courant
      #Si le path est Provider-Qualified alors Absolute est tjrs vrai. 
      #Si le provider ou le drive n'existe pas l'information IsAbsolute reste valide.
      #'~' renvoi $false
      #un chemin UNC renvoi $false
     $infos.IsAbsolute=$pathHelper.IsPSAbsolute($CurrentPath,[ref]$CurrentDriveName)
     
     #!! Attention : 
     #Pour les noms de chemin tel que 'FileSystem::\Temp\*' ou 'FileSystem::\Temp', 
     #PS renvoi le path pointé par [Environment]::CurrentDirectory
     # voir http://www.beefycode.com/post/The-Difference-between-your-Current-Directory-and-your-Current-Location.aspx
     
     try {
       #Si le path est ProviderQualified alors DriveInfo est à $null
       #Si la localisation est 'HKLM:\', alors pour le nom de chemin '..', l'appel renvoie HKEY_LOCAL_MACHINE\ qui est la racine courante, 
       #mais la racine courante du provider registry n'est pas un nom de drive PS, c'est ici le nom de la ruche.
       #Si la localisation est 'C:\', alors pour le nom de chemin '..', l'appel renvoie C:\qui est la racine courante, pour le filesystem elle contient le nom du drive PS, 
       #car celui-ci existe en dehors de Powershell.
       #Le nom de path '...' est pris en compte. Bug ?
      $ursvPath=$pathHelper.GetUnresolvedProviderPathFromPSPath($CurrentPath,[ref]$ProviderInfo,[ref]$DriveInfo)

      $Infos.isProviderExist=$True     
      $Infos.Provider=$ProviderInfo.Name
      $Infos.isFileSystemProvider=$ProviderInfo.Name -eq 'FileSystem'

      Write-Debug "Provider : $ProviderInfo"
      Write-debug "IsProviderQualified = $($Infos.IsProviderQualified)"
      Write-debug "IsAbsolute = $($infos.IsAbsolute)"
      
      if ($Infos.IsProviderQualified -eq $false)
      {
        if ($Infos.IsAbsolute -eq $false) 
        {
          Write-debug "On change le path RELATIF : $ursvPath"
          $CurrentPath=$ursvPath
        }
        else 
        { Write-debug "On ne change pas le path ABSOLU : $CurrentPath" } 
        $Infos.IsUnC=Test-UNCPath $CurrentPath       
      }
      else 
      { 
        Write-debug "On ne change pas le path PROVIDER-QUALIFIED : $CurrentPath"
        #'Registry::\\localhost\c$\temp' ne doit pas être reconnu comme UNC 
        if ($Infos.isFileSystemProvider)  
        { 
          $lpath=$CurrentPath -replace '(.*?)::(.*)','$2'
          $Infos.IsUnc=Test-UNCPath $lpath
           #pour 'filesystem::z\' isValid renvoie true
           #'z:\' isValid  déclenche une exception DriveNotFound
           try {
             #Pour valider le path, on doit se placer sur le provider FS    
            Push-Location $env:windir
            [void]$PathHelper.IsValid($lpath)
           }finally {
             Pop-Location
           }
        } 
      }

      Write-debug "isUNC=$($Infos.IsUnc)"
      
       #Ici on ne traite que des drives connus sur des providers existant
      Write-debug "CurrentDrivename=$CurrentDrivename"
      $Infos.CurrentDrivename=$CurrentDrivename
      if ($DriveInfo -ne $null)
      {
        $Infos.DriveName=$DriveInfo.Name
        $infos.isDriveExist=$True
        Write-Debug "Drive name: $($DriveInfo.Name)"
      }
     
      #Pour 'c:\temp\MyTest[a' iswildcard vaut $true, mais le globbing est invalide, à priori la seule présence du [ renvoi $true  
      #Pour 'c:\temp\MyTest`[a' iswildcard vaut $false
      #Si c'est un chemin littéral les caractères génériques ne peuvent être interprétés, car il générerait une exception
      if ($isLitteral)
      {  $infos.isWildCard=[Management.Automation.WildcardPattern]::ContainsWildcardCharacters(([Management.Automation.WildcardPattern]::Escape($CurrentPath)))}
      else
      {  $infos.isWildCard=[Management.Automation.WildcardPattern]::ContainsWildcardCharacters($CurrentPath)}
       
      Write-Debug "Path résolu : $CurrentPath" 
     } catch [System.Management.Automation.ProviderInvocationException],
              # sur la registry les noms de chemin '\..' et '\..' déclenche :  
              #  Le chemin d'accès 'HKEY_LOCAL_MACHINE\..' fait référence à un élément situé hors du chemin d'accès de base 'HKEY_LOCAL_MACHINE'.  
             [System.Management.Automation.PSInvalidOperationException] {
       #Sur la registry, '~' déclenche cette exception, car la propriété Home n'est pas renseigné.
       Write-Debug  "$_"
       Write-Debug "Path n'est pas résolu : $CurrentPath"
       $Infos.LastError=New-PSPathInfoError $_
       #On quitte, car les informations nécessaires sont inconnues. 
       return
     } 
     
     if (($Infos.IsProviderQualified -eq $false) -and ($Infos.IsAbsolute -eq $false) -and ($Infos.isFileSystemProvider -eq $false) ) 
     {
       Write-debug "Ajoute le nom du provider : $CurrentPath"
       if ($Infos.IsUnc)
       {$Infos.ResolvedPath='FileSystem::'+$CurrentPath }
       else
       {$Infos.ResolvedPath=$Infos.Provider+'::'+$CurrentPath }
       Write-debug "Resultat après l'ajout : $($Infos.ResolvedPath)" 
     }
     else
     {$Infos.ResolvedPath=$CurrentPath}

     #Implémente Path et LitteralPath
     try {
       #Le globbing est pris en compte
       if ($isLitteral)
       { $Infos.isItemExist= $ExecutionContext.InvokeProvider.Item.Exists(([Management.Automation.WildcardPattern]::Escape($Infos.ResolvedPath)),$false,$false) } 
       else 
       { $Infos.isItemExist= $ExecutionContext.InvokeProvider.Item.Exists($Infos.ResolvedPath,$false,$false) }
       Write-Debug "L'item existe-til ? $($Infos.isItemExist)"
       if ($Infos.isItemExist)
       {
         try {
           Write-Debug "Analyse le globbing."
           $provider=$null
            #renvoi le nom du provider et le fichier ou les fichiers en cas de globbing
           if ($isLitteral)
           { $result=@($pathHelper.GetResolvedProviderPathFromPSPath(([Management.Automation.WildcardPattern]::Escape($Infos.ResolvedPath)),[ref]$provider)) }
           else 
           { $result=@($pathHelper.GetResolvedProviderPathFromPSPath($Infos.ResolvedPath,[ref]$provider)) }
           $Infos.Count=$Result.Count
           Write-Debug ("Count={0} Result[0]={1} " -F $Infos.Count,$Result[0]) 
         } catch [System.Management.Automation.PSInvalidOperationException] {
             Write-Debug  "Exception GetResolvedProviderPathFromPSPath : $($_.Exception.GetType().Name)"
             #Sur la registry, '~' déclenche cette exception, car la propriété Home n'est pas renseigné.
            $Infos.Count=0
         }
       }
     }  
     catch [System.Management.Automation.MethodInvocationException]  {
           #Path Invalide. 'C:\temp\t>\t.txt' -> "Caractères non conformes dans le chemin d'accès."
       Write-Debug  "$_"
       Write-Debug  "Exception Exists: $($_.Exception.GetType().Name)"
       $Infos.LastError=New-PSPathInfoError $_        
     }

    }#try
    catch [System.Management.Automation.ProviderNotFoundException],

              #Le lecteur physique peut ne pas exister, exemple A:\
          [System.Management.Automation.DriveNotFoundException],

              #Le lecteur physique existe, mais est amovible exemple A:\ ou un lecteur de CD-Rom
              #Avec : New-PSDrive -name ' Space' -root C:\Temp -psp FileSystem
              #l'appel de    : ' Space:\Test'|Resolve-PSpath
              # le message d'erreur contiendra la référence à 'C:\Temp\Test' et pas ' Space:\Test' 
              #pour 'Registry::HKLM:\System' le message d'erreur référencera « HKLM:\System » 
          [System.Management.Automation.ItemNotFoundException],

           #Path Invalide.
          [System.Management.Automation.PSArgumentException],

           # Caractères génériques invalides.
          [System.Management.Automation.WildcardPatternException], 

           #Pour les items du filesystem contenant des caractères interdits :  < > | : ? * etc
           #Pour le 'etc' voir : [System.IO.Path]::GetInvalidFileNameChars()
           #Les noms de chemin contenant un nom de périphérique Win32 tels que 
           # PRN, AUX, CLOCK,NUL,CON,COM1,LPT2...
           #sont testé en interne par le provider FileSystem. 
           #Ces noms ne peuvent exister et seront considéré comme inconnus.
           #Pour d'autres provider ces caractères et noms peuvent être autorisés.
          [System.NotSupportedException] {
      Write-Debug  "Exception : $($_.Exception.GetType().Name)"
      $Infos.LastError=New-PSPathInfoError $_
    }
    finally {

      #Répond à la question : Le chemin est-il valide ?
      $Infos| 
        Add-Member -Membertype Scriptmethod -Name IsCandidate {
           $result= $this.isValid  -and
                   ($this.LastError -eq $null)  -and 
                   (($this.isFileSystemProvider -eq $true) -or ($this.isUNC -eq $true)) -and 
                   ($this.isWildcard -eq $false)  
          if (-not $result)
          { Write-Debug "Invalide pour une utilisation sur le FileSystem : $($this.ResolvedPath)" } 
          $result                    
        }  

      #Répond à la question : Le chemin est-il un répertoire valide ?
      $Infos| 
        Add-Member -Membertype Scriptmethod -Name IsValidForExtraction {
            #Pour utiliser un répertoire d'extraction on doit savoir s'il :
            #  est valide (ne pas contenir de joker,ni de caractères interdits),
            #  existe,
            #  pointe sur le file systeme (s'il est relatif, la location courante doit être le FS)
           $result= $false
           if ($this.IsCandidate() -and $this.isItemExist)
           { 
             if ($this.asLitteral)
             { $lpath=[Management.Automation.WildcardPattern]::Escape($this.ResolvedPath) }
             else 
             { $lpath=$this.ResolvedPath }
             $result=$ExecutionContext.InvokeProvider.Item.IsContainer($lpath)
           }
           If ($result)
           { Write-Debug "Valide en tant que répertoire d'extraction : $($this.ResolvedPath)"}
           $result     
        }  

      #Répond à la question : Le chemin peut-il être crée ?
      $Infos| 
        Add-Member -Membertype Scriptmethod -Name IsValidForCreation {
            # Pour créer un répertoire d'extraction on doit savoir s'il :
            #  est valide (ne pas contenir de joker, ni de caractères interdits),
            #  S'il n'existe pas déjà,
            #  pointe sur le file système (s'il est relatif, la location courante doit être le FS)
            #
            # $this.ResolvedPath est un nom d'entrée du FileSystem, pas un Fichier ou un Répertoire, 
            # c'est lors de la création de cette entrée que l'on détermine son type.
           $result= ( $this.IsCandidate() -and ($this.isItemExist -eq $false) ) 
           If ($result)
           { Write-Debug "Valide pour une création de répertoire d'extraction : $($this.ResolvedPath)"}
           $result
        }  
        #Un chemin tel que 'registry::hklm:\' est considéré comme candidate
        #on s'assure que sa construction est valide pour le provider   
       if ($Infos.ResolvedPath -ne $null)
       { 
         try {
             $Infos.isValid=$ExecutionContext.SessionState.Path.isValid($Infos.ResolvedPath) 
         } catch [System.Management.Automation.ProviderInvocationException]  {
             #Par exemple pour 'Registry::\\localhost\c$\temp' ou 'Registry::..\temp'
             Write-Debug  "isValid : $($_.Exception.GetType().Name)"
            $Infos.LastError=New-PSPathInfoError $_
         }
      }
       $Infos
    }
 } #process
} #Resolve-PSPath

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
#todo  Stop-Log4Net vérifier si + module utilise une config différente ou une ddll de version différente !!!
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
                                                        Expand-Entry
                                                        #Update-ZipFile,
                                                        #Sync-ZipFile,
                                                        #Split-ZipFile,
                                                        #Join-ZipFile,
                                                        #Merge-ZipFile,
                                                        #Update-ZipEntry,
                                                        #Remove-ZipEntry,
                                                        #Rename-ZipEntry,