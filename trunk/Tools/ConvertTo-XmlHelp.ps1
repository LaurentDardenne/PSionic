Function ConvertTo-XmlHelp {
 param (
   [Parameter(Mandatory=$true,ValueFromPipeline = $true,ValueFromPipelineByPropertyName = $true)]
   [ValidateNotNullOrEmpty()]
   [Alias('Key')]
  [string]$CommandName,
  
    [Parameter(Position=0,Mandatory=$true)]
    [ValidateNotNullOrEmpty()]
  [string]$ModuleName,

    [Parameter(Position=1,Mandatory=$true)]
    [ValidateNotNullOrEmpty()]
    [ValidateScript( {Test-Path $_})]
  [string] $SourceDirectory,  
  
    [Parameter(Position=1,Mandatory=$true)]
    [ValidateNotNullOrEmpty()]
    [ValidateScript( {Test-Path $_})]
  [string] $TargetDirectory,
  
    [Parameter(Position=2,Mandatory=$true)]
    [ValidateNotNull()]
  [System.Globalization.CultureInfo]$Culture  
 )
 begin {
    $NewDirectory="$TargetDirectory\{0}" -F $Culture        
    Write-Verbose "Create directory : $NewDirectory"
    md $NewDirectory > $null       
 }
 Process {
    Write-Verbose "[$Culture] create xml help files for the command : $CommandName"
    $WorkingDirectory="$SourceDirectory\$CommandName" 
    $FileDataBloc="$WorkingDirectory\{0}.{1}.{2}.Datas.ps1" -F $Culture,$ModuleName,$CommandName
    Write-Verbose "Load Datas from $FileDataBloc"
    .$FileDataBloc
    
     #Traite le fichier Cmds de la culture courante
    $FileCmdBloc="$WorkingDirectory\{0}.{1}.{2}.Cmds.ps1" -F $Culture,$ModuleName,$CommandName 
    Write-verbose "`tValide $FileCmdBloc"
    if (-not (Test-Path $FileCmdBloc) ) 
    {
      #sinon, traite le fichier Cmds commun
      $FileCmdBloc="$WorkingDirectory\Common.{0}.{1}.Cmds.ps1" -F $ModuleName,$CommandName
    }
    Write-verbose "Convert $FileCmdBloc"
    $NewXmlFile="$NewDirectory\{0}.{1}.xml" -F $ModuleName,$CommandName
    Write-verbose "Write $NewXmlFile`r`n"
    Convert-Helps  $FileCmdBloc $NewXmlFile
 }#process
} #ConvertTo-XmlHelp

