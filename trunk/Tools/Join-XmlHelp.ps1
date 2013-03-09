function Join-XmlHelp {
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
    $NewDirectory="$SourceDirectory\{0}" -F $Culture        
    Write-Verbose "Read from directory : $NewDirectory"
    $FirstCmd=$true
    $Help=$null
 }
 
 Process {
    $XmlFile="$NewDirectory\{0}.{1}.xml" -F $ModuleName,$CommandName
    Write-Verbose "Read $XmlFile"
    if ($FirstCmd)         
    {
      Write-Debug "Add first command : $CommandName"
       #Lit le premier fichier
      [xml]$Help=Get-Content $XmlFile
      $FirstCmd=$false
    }
    else 
    { 
      Write-Debug "Add next command : $CommandName"
       #On ajoute la commande courante dans la structure du premier fichier
      [xml]$NextCommand=Get-Content $XmlFile
      $Node=$NextCommand.helpItems.command.CloneNode($true)
      $NewNode=$Help.ImportNode($Node, $true);
      [void]$help.helpItems.AppendChild($NewNode)
    }
  }#process
  end {
    Write-Debug "Save all commands."
    $HelpFileName= "$TargetDirectory\${ModuleName}-Help.xml"
    Write-Verbose "Write $HelpFileName"
    $Help.Save($HelpFileName)
 }#end
}#Join-XmlHelp
