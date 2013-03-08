Function New-CommandHelpTemplate {
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
  [string] $TargetDirectory
 )

 Process {
    $isDataBloc=$false
    $isCmdBloc=$false
    $sBuildData=new-object System.Text.StringBuilder
    $sBuildCmd=new-object System.Text.StringBuilder
    
    Write-Verbose "`r`nCurrent command : $CommandName"
    $WorkingDirectory="$TargetDirectory\$CommandName" 
    md $WorkingDirectory > $null
   
     #hashtable des messages
    $FileDataBloc="$WorkingDirectory\{0}.{1}.Datas.Template.ps1" -F $ModuleName,$CommandName
     #hashtable du code
    $FileCmdBloc="$WorkingDirectory\{0}.{1}.Cmds.Template.ps1" -F $ModuleName,$CommandName
     #fichier commun pour toutes les cultures qui 
     # ne déclarent pas de fichier 'cmds' spécifique
    $FileCmdBlocCommon="$WorkingDirectory\Common.{0}.{1}.Cmds.ps1" -F $ModuleName,$CommandName
    
     #Les déclaration émisent le sont dans deux 'blocs' distincts
    New-Helps -Command $CommandName -LocalizedData Datas |
     Foreach-Object { 
        $Line=$_
        switch ($Line)  
        {
         "# $CommandName command help"  {$isCmdBloc=$true;$isDataBloc=$false; break}
         "# $CommandName command data"  {$isDataBloc=$true;$isCmdBloc=$false;break}
        } 
           
        if ($isDataBloc)
        { 
          [void]$sBuildData.AppendLine($Line)
        }elseif ($isCmdBloc)
        { 
          [void]$sBuildCmd.AppendLine($Line)
        }
     }#Foreach 
 
    Write-verbose "Write $FileDataBloc"
    $sBuildData.ToString()|Set-Content $FileDataBloc
   
    Write-verbose "Write $FileCmdBloc"
    $sBuildCmd.ToString() |Set-Content $FileCmdBloc 
    $sBuildCmd.ToString() |Set-Content $FileCmdBlocCommon  
 }#process
} #New-CommandHelpTemplate