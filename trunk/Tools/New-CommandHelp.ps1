Function New-CommandHelp {
 param (
   [Parameter(Mandatory=$true,ValueFromPipeline = $true)]
   [ValidateNotNullOrEmpty()]
  [string]$CommandName,
  
    [Parameter(Position=0,Mandatory=$true)]
    [ValidateNotNullOrEmpty()]
  [string]$ModuleName,
  
    [Parameter(Position=1,Mandatory=$true)]
    [ValidateNotNullOrEmpty()]
    [ValidateScript( {Test-Path $_})]
  [string] $TargetDirectory,
  
    [Parameter(Position=2,Mandatory=$true)]
    [ValidateNotNull()]
  [System.Globalization.CultureInfo]$Culture,
    
  [Switch] $All
  
 )

 Process {
    Write-Verbose "[$Culture] create files help for the command : $CommandName"
    $WorkingDirectory="$TargetDirectory\$CommandName" 
     #Crée les fichiers finaux de l'aide, préfixé du nom de culture
    $FileDataBloc="$WorkingDirectory\{0}.{1}.Datas.Template.ps1" -F $ModuleName,$CommandName
    $NewFileDataBloc="$WorkingDirectory\{0}.{1}.{2}.Datas.ps1" -F $Culture,$ModuleName,$CommandName
    Write-verbose "Write $NewFileDataBloc"
    Copy $FileDataBloc $NewFileDataBloc
    
    if ($All) 
    {
      $FileCmdBloc="$WorkingDirectory\{0}.{1}.Cmds.Template.ps1" -F $ModuleName,$CommandName
      $NewFileCmdBloc="$WorkingDirectory\{0}.{1}.{2}.Cmds.ps1" -F $Culture,$ModuleName,$CommandName
      Write-verbose "Write $NewFileCmdBloc"
      Copy $FileCmdBloc $NewFileCmdBloc
    } 
 }#process
} #New-CommandHelp