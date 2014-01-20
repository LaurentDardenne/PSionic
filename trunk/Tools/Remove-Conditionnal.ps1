#Remove-Conditionnal.ps1
Function Remove-Conditionnal {
<#
.SYNOPSIS
    Supprime dans un fichier source toutes les lignes placées entre deux 
    directives de 'parsing conditionnal', tels que #<DEFINE %DEBUG%> et 
    #<UNDEF %DEBUG%>.
 
.DESCRIPTION
    La fonction Remove-Conditionnal filtre dans un fichier source toutes les 
    lignes placées entre deux directives de 'parsing conditionnal'.
.
    PowerShell ne propose pas de mécanisme similaire a ceux de la compilation 
    conditionnelle, qui permet à l'aide de directives d'ignorer certaines
     parties du texte source.      
    Cette fonction utilise les constructions suivantes :
       . pour déclarer une directive : #<DEFINE %Nom_De_Directive_A%> 
       . pour annuler un directive :   #<UNDEF %Nom_De_Directive_A%>.
.
    Chacune de ces directives doit être placée en début de ligne et peut être 
    précédées d'un ou plusieurs caractères espaces ou tabulation.  
    Le nom de directive ne doit pas contenir d'espace ou de tabulation.
.
    Ces directives peuvent êtres imbriquées:
     #<DEFINE %Nom_De_Directive_A%> 
     
      #<DEFINE %Nom_De_Directive_B%> 
      #<UNDEF %Nom_De_Directive_B%>
     
     #<UNDEF %Nom_De_Directive_A%>
.
    Par principe la construction suivante n'est pas autorisée :
     #<DEFINE %Nom_De_Directive_A%> 
     
      #<DEFINE %Nom_De_Directive_B%> 
      #<UNDEF %Nom_De_Directive_A%>  #fin de directive erronée
     
     #<UNDEF %Nom_De_Directive_B%>        

.
    La directive #<%REMOVE%> peut être placée à la fin de chaque ligne  :
         Write-Host 'Test' #<%REMOVE%> 
         #commentaire de Test #<%REMOVE%>
.
    Elle indique que l'intégralité de la ligne sera toujours filtrée lors de 
    l'exécution de la fonction Remove-Conditionnal. 
    Si vous utilisez le paramétre -Clean alors chaque occurence de cette 
    directive sera supprimée, mais pas l'intégralité de la ligne de texte.
    Ainsi la ligne suivante :
    
     Write-Host 'Test' #<%REMOVE%> 
    
    sera tranformée en 
    
     Write-Host 'Test' 
.
    Ne placez donc pas de texte à la suite de cette directive. 
.
    La directive #<INCLUDE %'FullPathName'%>, doit être être placée en début de ligne :
         #<INCLUDE %'C:\Temp\Test.ps1'%>"
.
    Elle indique que le fichier C:\Temp\Test.ps1 sera inclus dans le fichier en 
    cours de traitement. Vous devez vous assurer de l'existence du fichier. 
    Ce nom de fichier doit être précédé de %' et suivi de '%>
    L'imbrication de directive INCLUDE est possible, car ce traitement
    appel récursivement la fonction Remove-Conditionnal avec le contenu du 
    paramètre -ConditionnalsKeyWord.
    Cette directive attend un seul nom de fichier.
    Les espaces en début et fin de chaîne sont supprimé.
.
    Ne placez donc pas de texte à la suite de cette directive.     

.PARAMETER  InputObject
    Spécifie le texte du code source à transformer. 
    L'objet texte doit être de type tableau afin de traiter chaque ligne du 
    code source. Si le texte est contenu dans une seule chaîne de caractères l'
    analyse des directives échouera, dans ce cas le texte du fichier source ne 
    sera pas transformé.

.PARAMETER ConditionnalsKeyWord
    Tableau de chaînes de caractères contenant les directives à rechercher.
    
.PARAMETER  Clean
    Filtre toutes les lignes contenant une directive. Cette opération 
    supprime seulement les lignes contenant une directive et pas le texte
    entre deux directives.
.        
    Pour la directive Include, on supprime la ligne, sauf si le paramètre -Include 
    est spécifié. Dans ce cas on inclut le fichier sur lequel on effectue le même 
    traitement de nettoyage que demandé. 
.    
    Pour la directive Remove, on supprime l'occurence du nom de la directive, 
    sauf si le paramètre -Remove est spécifié. Dans ce cas on supprime la ligne.
.
    Pour la directive unComment, on supprime l'occurence du nom de la directive, 
    le commentaire reste, sauf si le paramètre -UnComment est spécifié.
    Dans ce cas la ligne n'est plus commentée.

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
    Ces instructions créent une variable contenant du code, dans lequel on 
    déclare une directive DEBUG. Cette variable étant du type chaîne de 
    caractères, on doit la transformer en un tableau de chaîne, à l'aide de 
    l'opérateur -Split, avant de l'affecter au paramétre -Input. 
.    
    Le paramétre ConditionnalsKeyWord déclare une seule directive nommée 
    'DEBUG', ainsi configuré le code transformé correspondra à ceci :
    
       Function Test-Directive {
        Write-Host "Test"
       } 
       
    Les lignes comprisent entre la directive #<DEFINE %DEBUG%> et la directive
    #<UNDEF %DEBUG%> sont filtrées, les lignes des directives également.   

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
     Remove-Conditionnal : Parsing annulé. Les directives suivantes n'ont pas 
     de mot clé de fin : DEBUG:1
    
    Le message d'erreur contient le nom de la directive suivi du numéro de 
    ligne du code source où elle est déclarée.
    
    La cause de l'erreur est due au type d'objet transmit dans le pipeline, 
    cette syntaxe transmet les objets contenus dans le tableau les uns à la 
    suite des autres, l'analyse ne peut donc se faire sur l'intégralité du code 
    source, car la fonction opére sur une seule ligne et autant de fois qu'elle
    reçoit de ligne.
.    
    Pour éviter ce problème on doit forcer l'émission du tableau en spécifiant 
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
    La première instruction crée un fichier contenant du code, dans lequel on 
    déclare une directive DEBUG. La seconde instruction lit le fichier en 
    une seule étape, car on indique à l'aide du paramétre -ReadCount de 
    récupèrer un tableau de chaînes. Le paramétre Clean filtrera toutes les 
    lignes contenant une directive, ainsi configuré le code transformé 
    correspondra à ceci :
    
      Function Test-Directive {
        Write-Host "Test"
        Write-Debug "$ErrorActionPreference"
      } 
      
    Les lignes comprisent entre la directive #<DEFINE %DEBUG%> et la directive
    #<UNDEF %DEBUG%> ne sont pas filtrées, par contre les lignes contenant 
    une déclaration de directive le sont. 

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
    Ces instructions déclarent une variable contenant du code, dans lequel on 
    déclare deux directives, DEBUG et TEST. 
    On applique le filtre de la directive 'DEBUG' puis on filtre les 
    déclarations des directives restantes, ici 'TEST'. 
.    
    Le code transformé correspondra à ceci :
    
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
    Ces instructions génèrent, selon le paramétrage, un code dédié à une 
    version spécifique de Powershell. 
.    
    En précisant la directive 'V3', on supprime le code spécifique à la version 
    3. On génère donc du code compatible avec la version 2 de Powershell. 
    Le code transformé correspondra à ceci :
    
      #Requires -Version 2.0
      Filter Test {
       dir | % { $_.FullName } #v2
      } 
.    
    En précisant la directive V2 on supprime le code spécifique à la version 2 
    on génère donc du code compatible avec la version 3 de Powershell.
    Le code transformé correspondra à ceci :
    
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
    Ces instructions génèrent, selon le paramétrage, un code dédié à une 
    version spécifique de Windows. On lit le fichier script prenant en compte 
    plusieurs versions de Windows, on le transforme, puis on le réécrit dans 
    un répertoire de livraison.
.    
    Dans cette exemple on génère un script contenant du code 
    dédié à Windows 2008R2.
.    
    En précisant la directive '2008R2' on génèrerait du code dédié à Windows 
    SEVEN.
    
.EXAMPLE
    @'
    #Fichier d'inclusion C:\Temp\Test1.ps1
    1-un
    '@ > C:\Temp\Test1.ps1
    #
    #     
    @'
    #Fichier d'inclusion C:\Temp\Test2.ps1
    #<INCLUDE %'C:\Temp\Test3.ps1'%>
    2-un
    #<DEFINE %DEBUG%>
    2-deux
    #<UNDEF %DEBUG%>  
    '@ > C:\Temp\Test2.ps1
    #
    #    
    @'
    #Fichier d'inclusion C:\Temp\Test3.ps1
    3-un
    #<INCLUDE %'C:\Temp\Test1.ps1'%> 
    $Logger.Debug('Test') #<%REMOVE%>
    #<DEFINE %PSV2%>
    3-deux
    #<UNDEF %PSV2%>  
    '@ > C:\Temp\Test3.ps1
    #
    #   
    Dir C:\Temp\Test2.ps1|
     Get-Content -ReadCount 0|
     Remove-Conditionnal -ConditionnalsKeyWord  'DEBUG'
.        
    Description
    -----------
    Ces instructions crées trois fichiers. L'appel à Remove-Conditionnal génère  
    le code suivant :
    #Fichier d'inclusion C:\Temp\Test2.ps1
    #Fichier d'inclusion C:\Temp\Test3.ps1
    3-un
    #Fichier d'inclusion C:\Temp\Test1.ps1
    1-un
    #<DEFINE %PSV2%>
    3-deux
    #<UNDEF %PSV2%>
    2-un      
.
    Chaque appel interne à Remove-Conditionnal utilisera les directives déclarées 
    sur l'appel d'origine.  

.INPUTS
    System.Management.Automation.PSObject

.OUTPUTS
    System.String

.NOTES
		Author:  Laurent Dardenne
		Version:  1.1
		Date: 16/01/2014

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
      [Switch] $Clean, #L'opération de nettoyage des directives devrait être la dernière tâche de transformation
      [Switch] $Remove, #on peut vouloir nettoyer les directives inutilisées et supprimer une ligne
      [Switch] $Include, #idem et inclure un fichier
      [Switch] $UnComment #idem, mais ne pas décommenter 
)
 Begin {
   function New-ParsingDirective {
    param(
         [Parameter(Mandatory=$true,position=0)]
        $Name,
         [Parameter(Mandatory=$true,position=1)]
        $Line
    )
      #Les paramétres liés définissent aussi les propriétés de l'objet
     $O=New-Object PSObject -Property $PSBoundParameters 
     $O.PsObject.TypeNames[0] = "ParsingDirective"
     $O|Add-Member ScriptMethod ToString {'{0}:{1}' -F $this.Name,$this.Line} -force -pass
   }#New-ParsingDirective
   
   Write-Debug "Clean=$Clean"
   Write-Debug "Remove=$Remove"
   Write-Debug "Include=$Include"
   Write-Debug "UnComment=$UnComment"
   Write-Debug "ConditionnalsKeyWord : $ConditionnalsKeyWord" 
   
   $oldofs,$ofs=$ofs,'|'
   if ($Clean.isPresent)
   {
      $RegexDefine="^\s*#<\s*DEFINE\s*%(?<ConditionalKeyWord>.*[^%\s])%"
      Write-Debug "Regex pour Clean :'$RegexDefine'"
   }
   else 
   {
     $ConditionnalsKeyWord=$ConditionnalsKeyWord|Select -Unique
     
     $ConditionnalsKeyWord|
      Where {$Directive=$_; $Directive.Contains(' ')}|
      Foreach {Throw "Une directive contient des espaces :$Directive" }
     $RegexDefine="^\s*#<\s*DEFINE\s*%(?<ConditionalKeyWord>$ConditionnalsKeyWord)%"
     Write-Debug "Regex de base:'$RegexDefine'"

      #Directives liées à un paramètre
     $ReservedKeyWord=@('Clean','Remove','Include','UnComment')

     $KeyWordsNotAllowed=@(Compare-object $ConditionnalsKeyWord $ReservedKeyWord -IncludeEqual -PassThru| Where {$_.SideIndicator -eq "=="})
     if ($KeyWordsNotAllowed.Count -gt 0)
     { 
        $ofs=','
        Throw "Ces noms de directive sont réservées : ${KeyWordsNotAllowed}.Utilisez le paramétre associé."
     }     
   }
   
   $Directives=New-Object System.Collections.Queue
   $ofs=$oldofs
 }#begin       
 
 Process { 
   $LineNumber=0; 
   $isDirectiveBloc=$False

    #renvoi toutes les lignes sauf celles du bloc délimitées par une 'directive' 
   if ($Clean.isPresent)
   {$CurrentDirective='.*[^%\s]'}
   else 
   {$CurrentDirective=$null}


   $Result=$InputObject|
     Foreach-Object { 
       $LineNumber++
       [string]$Line=$_
       #Write-Debug "`t Traite $Line `t  isDirectiveBloc=$isDirectiveBloc"
       switch -regex ($_)  
       {
          #Recherche le mot clé de début d'une directive, puis l'empile 
         $RegexDefine {   Write-Debug "Match DEFINE"
                          if (-not $Clean.isPresent)
                          {
                              $CurrentDirective=$Matches.ConditionalKeyWord
                              Write-Debug "Enqueue $CurrentDirective"
                              $O=New-ParsingDirective $CurrentDirective $LineNumber 
                              $Directives.Enqueue($O)
                              $isDirectiveBloc=$True
                          }
                          continue
                       }
                    
          #Recherche le mot clé de fin de la directive courante, puis dépile
         "^\s*#<\s*UNDEF %${CurrentDirective}%>"   { Write-Debug "Match UNDEF"
                                                     if (-not $Clean.isPresent)
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
         "#<%REMOVE%>"  {  Write-Debug "Match REMOVE"
                           if ($Remove.isPresent)
                           { 
                             Write-Debug "`tREMOVE Line"
                             continue 
                           }
                           if ($Clean.isPresent)
                           { 
                             Write-Debug "`tREMOVE directive"
                             $Line -replace "#<%REMOVE%>",'' 
                           }
                           else
                           { $Line } 
                           continue
                        } 
          
          #Décommente la ligne
         "#<%UNCOMMENT%>"  { Write-Debug "Match UNCOMMENT"
                             if ($UnComment.isPresent)
                             { 
                               Write-Debug "`tUNCOMMENT  Line"
                               $Line -replace "^\s*#*<%UNCOMMENT%>",''
                             }
                             elseif ($Clean.isPresent)
                             { 
                               Write-Debug "`tRemove UNCOMMENT directive"
                               $Line -replace "^\s*#*<%UNCOMMENT%>(.*)",'#$1'
                             } 
                             else
                             { $Line }
                             continue
                           }
          
          #Traite un fichier la fois
          #L'utilisateur à la charge de valider le nom et l'existence du fichier
         "^\s*#<INCLUDE\s{1,}%'(?<FileName>.*)'%>" { 
                             Write-Debug "Match INCLUDE"
                             if ($Include.isPresent)
                             {
                               $FileName=$Matches.FileName.Trim()
                               Write-Debug "Inclut le fichier $FileName"
                                #Lit le fichier, le transforme à son tour, puis l'envoi dans le pipe
                                #Imbrication d'INCLUDE possible
                                #Exécution dans une nouvelle portée 
                               if ($Clean.isPresent)
                               {
                                  Write-Debug "Recurse Remove-Conditionnal -Clean"
                                  $NestedResult= Get-Content $FileName -ReadCount 0|
                                                  Remove-Conditionnal -Clean -Remove:$Remove -Include:$Include -UnComment:$UnComment
                                  #Ici on émet le contenu du tableau et pas le tableau reçu
                                  #Seul le résultat final est renvoyé en tant que tableau 
                                 $NestedResult
                               }
                               else 
                               {
                                  Write-Debug "Recurse Remove-Conditionnal $ConditionnalsKeyWord"
                                  $NestedResult= Get-Content $FileName -ReadCount 0|
                                                  Remove-Conditionnal -ConditionnalsKeyWord $ConditionnalsKeyWord -Remove:$Remove -Include:$Include -UnComment:$UnComment
                                 $NestedResult
                               }
                             }
                             elseif (-not $Clean.isPresent)
                             { $Line }
                             continue
                           }
         default {
           #Write-Debug "Match Default"
             #On traite les lignes qui ne se trouvent pas dans le bloc de la 'directive'
           if ($isDirectiveBloc -eq $false)
           {$Line}
         }#default
      }#Switch
   }#Foreach
   if ($Directives.Count -gt 0) 
   { 
     $oldofs,$ofs=$ofs,','
     Write-Error "Parsing annulé. Les directives suivantes n'ont pas de mot clé de fin : $Directives" 
     $ofs=$oldofs
  }
   else 
   { ,$Result } #Renvoi un tableau, permet d'imbriquer un second appel sans transformation du résultat
   $Directives.Clear()
 }#process
} #Remove-Conditionnal

