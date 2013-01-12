#Remove-Conditionnal.ps1
Function Remove-Conditionnal {
<#
.SYNOPSIS
    Supprime dans un fichier source toutes les lignes plac�es entre deux 
    directives de 'parsing conditionnal', tels que #<DEFINE %DEBUG%> et 
    #<UNDEF %DEBUG%>.
 
.DESCRIPTION
    La fonction Remove-Conditionnal filtre dans un fichier source toutes les 
    lignes plac�es entre deux directives de 'parsing conditionnal'.
.
    PowerShell ne propose pas de m�canisme similaire a ceux de la compilation 
    conditionnelle, qui permet � l'aide de directives d'ignorer certaines
     parties du texte source.      
    Cette fonction utilise les constructions suivantes :
       . pour d�clarer une directive : #<DEFINE %Nom_De_Directive_A%> 
       . pour annuler un directive :   #<UNDEF %Nom_De_Directive_A%>.
.
    Chacune de ces directives doit �tre plac�e en d�but de ligne et peut �tre 
    pr�c�d�es d'un ou plusieurs caract�res espaces ou tabulation.  
    Le nom de directive ne doit pas contenir d'espace ou de tabulation.
.
    Ces directives peuvent �tres imbriqu�es:
     #<DEFINE %Nom_De_Directive_A%> 
     
      #<DEFINE %Nom_De_Directive_B%> 
      #<UNDEF %Nom_De_Directive_B%>
     
     #<UNDEF %Nom_De_Directive_A%>
.
    Par principe la construction suivante n'est pas autoris�e :
     #<DEFINE %Nom_De_Directive_A%> 
     
      #<DEFINE %Nom_De_Directive_B%> 
      #<UNDEF %Nom_De_Directive_A%>  #fin de directive erron�e
     
     #<UNDEF %Nom_De_Directive_B%>        

.
    La directive #<%REMOVE%%> peut �tre plac�e � la fin de chaque ligne  :
         Write-Host 'Test' #<%REMOVE%> 
         #commentaire de Test #<%REMOVE%>
.
    Elle indique que l'int�gralit� de la ligne sera toujours filtr�e lors de 
    l'ex�cution de la fonction Remove-Conditionnal. 
    Si vous utilisez le param�tre -Clean alors chaque occurence de cette 
    directive sera supprim�e, mais pas l'int�gralit� de la ligne de texte.
    Ainsi la ligne suivante :
    
     Write-Host 'Test' #<%REMOVE%> 
    
    sera tranform�e en 
    
     Write-Host 'Test' 
.
    Ne placez donc pas de texte � la suite de cette directive. 

.PARAMETER  InputObject
    Sp�cifie le texte du code source � transformer. 
    L'objet texte doit �tre de type tableau afin de traiter chaque ligne du 
    code source. Si le texte est contenu dans une seule cha�ne de caract�res l'
    analyse des directives �chouera, dans ce cas le texte du fichier source ne 
    sera pas transform�.

.PARAMETER ConditionnalsKeyWord
    Tableau de cha�nes de caract�res contenant les directives � rechercher.
    
.PARAMETER  Clean
    Filtre toutes les lignes contenant une directive. Cette op�ration 
    supprime seulement les lignes contenant une directive et pas le texte
    entre deux directives.    

.EXAMPLE
    $Code=@'
      Function Test-Directive {
        Write-Host "Test"
       #<DEFINE %DEBUG%>
        Write-Debug "$DebugPreference"
       #<UNDEF %DEBUG%>   
      } 
    '@ 
    
    Remove-Conditionnal -Input ($code -split "`n") -ConditionnalsKeyWord  "DEBUG"
.        
    Description
    -----------
    Ces instructions cr�ent une variable contenant du code, dans lequel on 
    d�clare une directive DEBUG. Cette variable �tant du type cha�ne de 
    caract�res, on doit la transformer en un tableau de cha�ne, � l'aide de 
    l'op�rateur -Split, avant de l'affecter au param�tre -Input. 
.    
    Le param�tre ConditionnalsKeyWord d�clare une seule directive nomm�e 
    'DEBUG', ainsi configur� le code transform� correspondra � ceci :
    
       Function Test-Directive {
        Write-Host "Test"
       } 
       
    Les lignes comprisent entre la directive #<DEFINE %DEBUG%> et la directive
    #<UNDEF %DEBUG%> sont filtr�es, les lignes des directives �galement.   

.EXAMPLE
    $Code=@'
      Function Test-Directive {
        Write-Host "Test"
       #<DEFINE %DEBUG%>
        Write-Debug "$DebugPreference"
       #<UNDEF %DEBUG%>   
      } 
    '@ 
    
    ($code -split "`n")|Remove-Conditionnal -ConditionnalsKeyWord  "DEBUG"
.        
    Description
    -----------
    Cet exemple provoquera l'erreur suivante :
     Remove-Conditionnal : Parsing annul�. Les directives suivantes n'ont pas 
     de mot cl� de fin : DEBUG:1
    
    Le message d'erreur contient le nom de la directive suivi du num�ro de 
    ligne du code source o� elle est d�clar�e.
    
    La cause de l'erreur est due au type d'objet transmit dans le pipeline, 
    cette syntaxe transmet les objets contenus dans le tableau les uns � la 
    suite des autres, l'analyse ne peut donc se faire sur l'int�gralit� du code 
    source, car la fonction op�re sur une seule ligne et autant de fois qu'elle
    re�oit de ligne.
.    
    Pour �viter ce probl�me on doit forcer l'�mission du tableau en sp�cifiant 
    une virgule AVANT la variable de type tableau :
    
    ,($code -split "`n")|Remove-Conditionnal -ConditionnalsKeyWord  "DEBUG"
 
.EXAMPLE
    $Code=@'
      Function Test-Directive {
        Write-Host "Test"
       #<DEFINE %DEBUG%>
        Write-Debug "$DebugPreference"
       #<UNDEF %DEBUG%>   
      } 
    '@ > C:\Temp\Test1.PS1
    
    Get-Content C:\Temp\Test1.PS1 -ReadCount 0|
     Remove-Conditionnal -Clean
.        
    Description
    -----------
    La premi�re instruction cr�e un fichier contenant du code, dans lequel on 
    d�clare une directive DEBUG. La seconde instruction lit le fichier en 
    une seule �tape, car on indique � l'aide du param�tre -ReadCount de 
    r�cup�rer un tableau de cha�nes. Le param�tre Clean filtrera toutes les 
    lignes contenant une directive, ainsi configur� le code transform� 
    correspondra � ceci :
    
      Function Test-Directive {
        Write-Host "Test"
        Write-Debug "$ErrorActionPreference"
      } 
      
    Les lignes comprisent entre la directive #<DEFINE %DEBUG%> et la directive
    #<UNDEF %DEBUG%> ne sont pas filtr�es, par contre les lignes contenant 
    une d�claration de directive le sont. 

.EXAMPLE
    $Code=@'
      Function Test-Directive {
        param (
           [FunctionalType('FilePath')] #<%REMOVE%>
         [String]$Serveur
        )
       #<DEFINE %DEBUG%>
        Write-Debug "$DebugPreference"
       #<UNDEF %DEBUG%>   
       
        Write-Host "Test"
       
       #<DEFINE %TEST%>
        Test-Connection $Serveur
       #<UNDEF %TEST%>         
      } 
    '@ > C:\Temp\Test2.PS1
    
    Get-Content C:\Temp\Test1.PS1 -ReadCount 0|
     Remove-Conditionnal -ConditionnalsKeyWord  "DEBUG"
     Remove-Conditionnal -Clean
.        
    Description
    -----------
    Ces instructions d�clarent une variable contenant du code, dans lequel on 
    d�clare deux directives, DEBUG et TEST. 
    On applique le filtre de la directive 'DEBUG' puis on filtre les 
    d�clarations des directives restantes, ici 'TEST'. 
.    
    Le code transform� correspondra � ceci :
    
      Function Test-Directive {
        param (
         [String]$Serveur
        )
        Write-Host "Test"

        Test-Connection $Serveur
      } 

.EXAMPLE
    $code=@'
    #<DEFINE %V3%>
    #Requires -Version 3.0
    #<UNDEF %V3%>
    
    #<DEFINE %V2%>
    #Requires -Version 2.0
    #<UNDEF %V2%>
    
    Filter Test {
    #<DEFINE %V2%>
     dir | % { $_.FullName } #v2
    #<UNDEF %V2%>
    
    #<DEFINE %V3%>
     (dir).FullName   #v3
    #<UNDEF %V3%>
    
    #<DEFINE %DEBUG%>
    Write-Debug "$DebugPreference"
    #<UNDEF %DEBUG%>  
    } 
    '@ -split "`n" 
    
     #Le code est compatible avec la v2 uniquement
    ,$Code|
      Remove-Conditionnal -ConditionnalsKeyWord  "V3","DEBUG"|
      Remove-Conditionnal -Clean
    
     #Le code est compatible avec la v3 uniquement
    ,$Code|
      Remove-Conditionnal -ConditionnalsKeyWord  "V2","DEBUG"|
      Remove-Conditionnal -Clean   
.        
    Description
    -----------
    Ces instructions g�n�rent, selon le param�trage, un code d�di� � une 
    version sp�cifique de Powershell. 
.    
    En pr�cisant la directive 'V3', on supprime le code sp�cifique � la version 
    3. On g�n�re donc du code compatible avec la version 2 de Powershell. 
    Le code transform� correspondra � ceci :
    
      #Requires -Version 2.0
      Filter Test {
       dir | % { $_.FullName } #v2
      } 
.    
    En pr�cisant la directive V2 on supprime le code sp�cifique � la version 2 
    on g�n�re donc du code compatible avec la version 3 de Powershell.
    Le code transform� correspondra � ceci :
    
      #Requires -Version 3.0
      Filter Test {
       (dir).FullName   #v3
      } 

.EXAMPLE
    $PathSource="C:\Temp"
    $code=@'
     Filter Test {
    #<DEFINE %SEVEN%>
      #http://psclientmanager.codeplex.com/  #<%REMOVE%>
     Import-Module PSClientManager   #Seven
     Add-ClientFeature -Name TelnetServer
    #<UNDEF %SEVEN%>
    
    #<DEFINE %2008R2%>
     Import-Module ServerManager  #2008R2
     Add-WindowsFeature Telnet-Server
    #<UNDEF %2008R2%>
    } 
    '@ > "$PathSource\Add-FeatureTelnetServer.PS1"
    
    
    $VerbosePreference='Continue'
    $Livraison='C:\Temp\Livraison'
    Del "$Livraison\*.ps1" -ea 'SilentlyContinue'
      
      #Le code est compatible avec Windows 2008R2 uniquement
    $Directives=@('SEVEN','Remove')
    
    Dir "$PathSource\Add-FeatureTeletServer.PS1"|
     Foreach {Write-Verbose "Parse :$($_.FullName)"; $CurrentFileName=$_.Name;$_}|
     Get-Content -ReadCount 0|
     Remove-Conditionnal -ConditionnalsKeyWord  $Directives|
     Remove-Conditionnal -Clean|
     Set-Content -Path {(Join-Path $Livraison $CurrentFileName)} -Force
.        
    Description
    -----------
    Ces instructions g�n�rent, selon le param�trage, un code d�di� � une 
    version sp�cifique de Windows. On lit le fichier script prenant en compte 
    plusieurs versions de Windows, on le transforme, puis on le r��crit dans 
    un r�pertoire de livraison.
.    
    Dans cette exemple on g�n�re un script contenant du code 
    d�di� � Windows 2008R2.
.    
    En pr�cisant la directive '2008R2' on g�n�rerait du code d�di� � Windows 
    SEVEN.

.INPUTS
    System.Management.Automation.PSObject

.OUTPUTS
    System.String

.NOTES
		Author:  Laurent Dardenne
		Version:  1.0
		Date: 18/10/2012

.COMPONENT
    parsing
    
.ROLE
    Windows Administrator
    Developper

.FUNCTIONALITY
    Global

.FORWARDHELPCATEGORY <Function>
#>    
[CmdletBinding()]
param (
        [Parameter(Mandatory=$true,ValueFromPipeline = $true)]
      $InputObject,
        [ValidateNotNullOrEmpty()]
        [Parameter(Mandatory=$true,position=0,ParameterSetName="Keyword")]
      [String[]]$ConditionnalsKeyWord,
       [Parameter(ParameterSetName="Clean")]
      [Switch] $Clean
)
 Begin {
   function New-ParsingDirective {
    param(
         [Parameter(Mandatory=$true,position=0)]
        $Name,
         [Parameter(Mandatory=$true,position=1)]
        $Line
    )
      #Les param�tres li�s d�finissent aussi les propri�t�s de l'objet
     $O=New-Object PSObject -Property $PSBoundParameters 
     $O.PsObject.TypeNames[0] = "ParsingDirective"
     $O|Add-Member ScriptMethod ToString {'{0}:{1}' -F $this.Name,$this.Line} -force -pass
   }#New-ParsingDirective

   $oldofs,$ofs=$ofs,'|'
   if ( $Clean)
   {$RegexDefine="^\s*#<\s*DEFINE\s*%(?<ConditionalKeyWord>.*[^%\s])%"}
   else 
   {
     $ConditionnalsKeyWord|
      Where {$Directive=$_; $Directive.Contains(' ')}|
      Foreach {Throw "Une directive contient des espaces :$Directive" }
     $RegexDefine="^\s*#<\s*DEFINE\s*%(?<ConditionalKeyWord>$ConditionnalsKeyWord)%"
   }
   $Directives=New-Object System.Collections.Queue
   $ofs=$oldofs
 }       
 
 Process { 
   $LineNumber=0; 
   $isDirectiveBloc=$False

    #renvoi toutes les lignes sauf celles du bloc d�limit�es par une 'directive' 
   if ($Clean)
   {$CurrentDirective='.*[^%\s]'}
   else 
   {$CurrentDirective=$null}


   $Result=$InputObject|
     Foreach-Object { 
       $LineNumber++
       [string]$Line=$_
       Write-Debug "`t Traite $Line `t  isDirectiveBloc=$isDirectiveBloc"
       switch -regex ($_)  
       {
          #Recherche le mot cl� de d�but d'une directive, puis l'empile 
         $RegexDefine {   Write-Debug "Match DEFINE"
                          if (-not $Clean)
                          {
                              $CurrentDirective=$Matches.ConditionalKeyWord
                              Write-Debug "Enqueue $CurrentDirective"
                              $O=New-ParsingDirective $CurrentDirective $LineNumber 
                              $Directives.Enqueue($O)
                              $isDirectiveBloc=$True
                          }
                          continue
                       }
                    
          #Recherche le mot cl� de fin de la directive courante, puis d�pile
         "^\s*#<\s*UNDEF %${CurrentDirective}%>"   {    
                                                     Write-Debug "Match UNDEF"
                                                     if (-not $Clean)
                                                     {
                                                       if ($Directives.Count -gt 0) 
                                                       {
                                                         Write-Debug "Dequeue $CurrentDirective"
                                                         $CurrentDirective=($Directives.Dequeue()).Name
                                                         if ($Directives.Count -gt 0)  {Write-Debug "Reprend sur $CurrentDirective"} 
                                                       }
                                                       if ($Directives.Count -eq 0)
                                                       {Write-Debug "Fin d'imbrication"}
                                                       $isDirectiveBloc=$False;
                                                     }
                                                     continue
                                                  }
          #Supprime la ligne                                      
         "#<%REMOVE%>"  { Write-Debug "Match REMOVE"
                              if ($Clean)
                               {$Line -replace "#<%REMOVE%>",''}
                              continue
                            } 
         # "^\s*#<%EXPAND \$(?<VarName>.*)%%>"  {  #todo  #<%REMOVE%>
         # "^\s*#<%INCLUDE \$(?<FileName>.*)%%>"  {  #todo  #<%REMOVE%>
         
         default {
           Write-Debug "Match Default"
             #On traite les lignes qui ne se trouvent pas dans le bloc de la 'directive'
           if ($isDirectiveBloc -eq $false)
           {$Line}
         }#default
      }#Switch
   }#Foreach
   if ($Directives.Count -gt 0) 
   { 
     $oldofs,$ofs=$ofs,','
     Write-Error "Parsing annul�. Les directives suivantes n'ont pas de mot cl� de fin : $Directives" 
     $ofs=$oldofs
  }
   else 
   { ,$Result } #renvoi un tableau
   $Directives.Clear()
 }#process
} #Remove-Conditionnal
