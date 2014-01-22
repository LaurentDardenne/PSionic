#http://powershell-scripting.com/index.php?option=com_joomlaboard&Itemid=76&func=view&id=6132&catid=14#6132
Function New-FactoryFilterDate( [string] $PropertyName,
                                [type]   $Class,
                                [switch] $Force) {  
#
# Crée un objet générateur de filtres de recherche.
# Les filtres sont basés sur une propriété, de type date, d'un objet 
# de n'importe quelle classe (sauf les classes WMI).
#  Pour WMI mieux vaut filtrer les instances à l'aide de WQL.
#  
#
#Paramètres :  Aucun 
# 
#Cette fonction renvoie un objet de type PSObject, ses membres sont :
# Propriétés :
# ----------
#  PropertyName   : [String]. Nom de la propriété contenant la date de recherche.
#                   Comme on utilise des méthodes du framework dotnet, 
#                    faites attention à la casse du nom !
#                   Son contenu est utilisé en interne uniquement lors de la création d'un scriptblock de recherche.
#                    Valeur par défaut : CreationTime
#
#  Class          : [Type]. Nom de la classe contenant la propriété $PropertyName.
#                   Son contenu est utilisé en interne pour vérifier si la propriété 
#                   $PropertyName existe bien dans la classe ciblée par un des filtres.
#                    Valeur par défaut : [System.IO.FileSystemInfo]
#
#  Force          : [Boolean]. A utiliser si la propriété référence un membre synthétique.
#                   Dans ce cas, on ne teste pas l'existence de ce membre dans la classe, 
#                   de plus le respect de la casse du nom de propriété n'est plus nécessaire.
#                   Valeur par défaut : False
#
#  Description    : [String]. Contient le nom de la propriété et le nom de la classe en cours.
#
#
# Méthodes 
# ----------
# La plupart renvoient un scriptblock pouvant être utilisé avec Where-Object.
#           
#  ThisDate       : Recherche les fichiers de la date spécifiée. Les deux opérandes sont de type String.
#                   Attend un argument de type string contenant une date au format de la culture en cours.
#                   Fr = "28/12/2009"
#
#  TheseDates     : Recherche les fichiers des dates spécifiées. Les deux opérandes sont de type String. 
#                   Attend un argument de type string contenant une regex référençant des dates au format de la culture en cours.
#                   Fr : "(^30/12/2009|^15/01/2009)" Us : "(^12/30/2009|^1/15/2009)"
# 
#  AfterThisDate  : Recherche les fichiers postérieurs ou égaux à la date spécifiée. Les deux opérandes sont de type DateTime. 
#                   Attend un argument de type entier, négatif ou zéro. Cf. Notes
#      
#  BeforeThisDate : Recherche les fichiers antérieurs la date spécifiée. Les deux opérandes sont de type DateTime. 
#                   Attend un argument de type entier, négatif ou zéro. Cf. Notes
#
#  LastMinutes    : Recherche les fichiers agés de n minutes. Les deux opérandes sont de type DateTime. 
#                   Attend un argument de type entier, négatif. Cf. Notes
# 
#  LastHours      : Recherche les fichiers agés de n heures. Les deux opérandes sont de type DateTime. 
#                   Attend un argument de type entier, négatif. Cf. Notes
#
#  LastMonths     : Recherche les fichiers agés de n mois. Les deux opérandes sont de type DateTime. 
#                   Attend un argument de type entier, négatif. Cf. Notes
# 
#  LastYears      : Recherche les fichiers agés de n années. Les deux opérandes sont de type DateTime. 
#                   Attend un argument de type entier, négatif. Cf. Notes
#
#  Combine        : Crée un filtre contenant plusieurs clauses combinées et utilisant l'opérateur -or
#                   Attend un argument de type tableau de scriptblock.
#
#  ToString        : Renvoi une string résultant de l'appel à ThisDate paramétré avec la date du jour.
#
#  Set             : Affecte une ou plusieurs propriété en une passe.
#                    L'ordre de passage des paramètres est le suivant : 
#                     PropertyName :  [string] ou le résultat de Object.ToString() 
#                     Class        :  [string] ou [type]
#                     Force        :  [string] ou [Boolean] 
#
#  ReBuildProperty : Méthode privée, ne pas l'utiliser.
#
# Exemples :
#  $Filtre= New-FilterDateFile
#   #renvoi un scriptblock par défaut
#  $sb=$ExecutionContext.InvokeCommand.NewScriptBlock("$filtre")
# Get-Childitem "$pwd"|Where $sb|Select Name,"$($Filtre.PropertyName)"
#
#   #Filtre les fichiers d'il y a une semaine.
#  $AfterThisDate=$Filtre.AfterThisDate(-7)
#  $AfterThisDate #affiche le code du scriptblock
#  Get-Childitem "$pwd"|Where $AfterThisDate|Select Name, "CreationTime"
# 
#  #Filtre les fichiers créés le 25 octobre 2009 et ceux créés le 31 octobre 2009
# $TheseDates=$Filtre.TheseDates("(^25/10/2009|^31/10/2009)")
# Get-Childitem "$pwd"|Where $TheseDates|Select Name,"CreationTime"
# 
#  #Filtre les fichiers créés le 30 décembre 2009.
# $ThisDate=$Filtre.ThisDate("30/12/2009")
#  #Filtre les fichiers créés :
#  # Il y a une semaine,  
#  # ceux du 25 octobre 2009 et ceux du 31 octobre 2009.
# $FiltrePlusieursDates=$Filtre.Combine( @($AfterThisDate, $TheseDates))
# Get-Childitem "$pwd"|Where $FiltrePlusieursDates |Select Name,"CreationTime"
#
#    #Modifie l'ensemble des champs du générateur de filtre.
# $Filtre.Set("TimeGenerated","System.Diagnostics.EventLogEntry",$False)
#
#Note:
# Suppose lors de la recherche que la date du PC est bien le jour calendaire courant.
# Le validité des scriptblocks ne sera connue que lors de son exécution. 

  
  # Code généré (Fr)           "'{0:dd/MM/yyyy}' -f `$_.CreationTime -eq '$($Args[0])'"
  # Renvoie lors de l'appel    {'{0:dd/MM/yyyy}' -f $_.CreationTime -eq '28/12/2009'}
  #On récupère la culture du thread et pas celle du poste.
  #Ainsi, lors de l'appel de la création du code, on adapte la localisation au contexte d'exécution
 $ThisDate="`$ExecutionContext.InvokeCommand.NewScriptBlock(`"'{0:`$([System.Threading.Thread]::CurrentThread.CurrentCulture.DateTimeFormat.ShortDatePattern)}' -f ```$_.`$(`$this.PropertyName)"+" -eq '`$(`$Args[0])'`")"
   
   #On construit dynamiquement du code de création d'un scriptblock
   #Le code généré contient l'appel de création d'un scriptblock dont
   # le contenu est définie dynamiquement.
   #Comme il y a deux niveaux de substition on doit tripler le caractère backtick.
   #ce code génére :
   #  $ExecutionContext.InvokeCommand.NewScriptBlock("`$_.MypropertyName"}
 $CodeNewSB="`$ExecutionContext.InvokeCommand.NewScriptBlock(`"```$_.`$(`$this.PropertyName)"
  
  # Code généré              "`$_.LastWriteTime -match '$($Args[0])'"
  # renvoie lors de l'appel  {$_.LastWriteTime -match "(^10/07/2009|^10/31/2009)"}
  #Conversion explicite de PropertyName afin d'utiliser les informations de la culture courante
  #Si on utilise une conversion implicite, PowerShell utilise la culture invariant, c'est-à-dire US.   
 $TheseDates=$CodeNewSB+".ToString() -match '`$(`$Args[0])'`")"

 $AfterThisDate=$CodeNewSB+" -ge [DateTime]::Today.Adddays(`$(`$Args[0]))`")" 
 $BeforeThisDate=$CodeNewSB+" -lt [DateTime]::Today.Adddays(`$(`$Args[0]))`")"
 $LastMinutes=$CodeNewSB+" -ge [DateTime]::Now.AddMinutes(`$(`$Args[0]))`")"
 $LastHours=$CodeNewSB+" -ge [DateTime]::Now.AddHours(`$(`$Args[0]))`")"
 $LastMonths=$CodeNewSB+" -ge [DateTime]::Now.AddMonths(`$(`$Args[0]))`")"
 $LastYears=$CodeNewSB+" -ge [DateTime]::Now.AddYears(`$(`$Args[0]))`")"

  #Construction dynamique du code de création de l'objet Filtre
  #La plupart des méthodes renvoient un scriptblock
 $MakeFilter=@"
New-Object PSObject|
     #Args[0] attend une string contenant une date dans le format 
     # de la culture courante. Fr = "28/12/2009"
    Add-Member ScriptMethod ThisDate -value {$ThisDate} -Passthru|
     #Args[0] attend une string contenant une regex  référençant des dates dans le format 
     # de la culture courante. Fr = "(^31/10/2009|^13/12/2009)"
    Add-Member ScriptMethod TheseDates -value {$TheseDates} -Passthru|
     #Args[0] attend un entier négatif ou zéro. 
    Add-Member ScriptMethod AfterThisDate -value {$AfterThisDate} -Passthru|
     #Args[0] attend un entier négatif ou zéro.
    Add-Member ScriptMethod BeforeThisDate -value {$BeforeThisDate} -Passthru|
     #Args[0] attend un entier négatif. 
    Add-Member ScriptMethod LastMinutes -value {$LastMinutes} -Passthru|
     #Args[0] attend un entier négatif.
    Add-Member ScriptMethod LastHours -value {$LastHours} -Passthru|
     #Args[0] attend un entier négatif. 
    Add-Member ScriptMethod LastMonths -value {$LastMonths} -Passthru|
     #Args[0] attend un entier négatif. 
    Add-Member ScriptMethod LastYears -value {$LastYears} -Passthru|
     #Combine deux scriptblocs (créés ou pas par ce générateur)
     #La condition de recherche des scriptblokss combinés se base sur un -OR
    Add-Member ScriptMethod Combine -value { `$ArraySB=`$Args[0] -as [String[]]|% {"(`$_)"}
                                             `$Local:Ofs=" -or "
                                             `$sb=`$ExecutionContext.InvokeCommand.NewScriptBlock("`$ArraySB")
                                             `$sb  
                                            } -Passthru|  
    Add-Member ScriptProperty Description -Value {"Générateur de filtre de recherche sur une date, utilisant la propriété `$(`$this.PropertyName) de la la classe [`$(`$this.Class)].`r`nCe filtre peut être utilisé avec Where-Object."} -Passthru
"@
  #Exécution du code de création de l'objet Filtre
 $Object=Invoke-Expression $MakeFilter
  #Ajoute des propriétés "dynamiques",
  #A chaque affectation elle se recrée.
  #Les valeurs ne peuvent être que d'un type scalaire.
 $Object=$Object|Add-Member ScriptMethod ReBuildProperty -value {
            #On modifie la valeur du getter 
          $Getter=$ExecutionContext.InvokeCommand.NewScriptBlock($Args[1])
            #On réutilise le code du setter
            #(ici on est certains de ne récupérer qu'un seul élément).
          $Setter=($this.PsObject.Properties.Match($Args[0]))[0]
            #On supprime le membre actuel.
          [void]$this.PsObject.Properties.Remove($Args[0])
            #Puis on le reconstruit dynamiquement.
          $ANewMySelf=New-Object System.Management.Automation.PSScriptProperty($Args[0],$Getter,$Setter.SetterScript)  
          [void]$this.PsObject.Properties.Add($ANewMySelf) 
          } -Passthru| 
   #Args[0] attend une string non $null ni vide.                                     
  Add-Member ScriptProperty PropertyName  -value {"CreationTime"} -SecondValue {
           if ([string]::IsNullOrEmpty($args[0]) )
            {Throw "La propriété PropertyName doit être renseignée."}
           if (!$this.Force)
           {  #Contrôle l'existence du nom de propriété
             $PropertyInfo=($this.Class).GetMember($Args[0])
             if ($PropertyInfo.Count -eq 0)
              {Throw "La propriété $($Args[0]) n'existe pas dans la classe $(($this.Class).ToString())."}
             elseif ($PropertyInfo[0].PropertyType -ne [System.DateTime])
              {Throw "La valeur affectée à la propriété Propertyname ($($Args[0])) doit être une propriété du type [System.DateTime]."}        
           }
           
           $this.ReBuildProperty("PropertyName", "`"$($Args[0])`"")
        } -Passthru|
    #Args[0] attend un type.        
   Add-Member ScriptProperty Class  -value {[System.IO.FileSystemInfo]} -SecondValue {
           if ($Args[0] -isnot [Type]) 
            {Throw "La valeur affectée à la propriété Class ($($Args[0])) doit être un nom de type, tel que [System.IO.FileSystemInfo]."}
 
           $this.ReBuildProperty("Class", "[$($Args[0] -as [String])]")
         } -Passthru|
    #Args[0] attend un boolean.
   Add-Member ScriptProperty Force -value {$false} -SecondValue {
           if ($Args[0] -isnot [Boolean]) 
            {Throw "La valeur affectée à la propriété à la propriété Force ($($Args[0])) doit être de type [boolean]."}
 
           $this.ReBuildProperty("Force", "`$$($Args[0].ToString())")
         } -Passthru|
   Add-Member -Force -MemberType ScriptMethod ToString {
            $this.ThisDate((get-date -format ([System.Threading.Thread]::CurrentThread.CurrentCulture.DateTimeFormat.ShortDatePattern))) 
         } -PassThru|
    #Attend 1, 2 ou 3 paramètres     
   Add-Member ScriptMethod Set {  
          if (![string]::IsNullOrEmpty($args[1]))
           { $this.Class=$args[1] -as [Type]}
          if (![string]::IsNullOrEmpty($args[0]))
           {$this.PropertyName=$args[0] -as [string]}
          if (![string]::IsNullOrEmpty($args[2]))
           {$this.Force=$args[2] -as [boolean]}
         } -PassThru         
 $Object.Set($PropertyName,$Class,$Force.IsPresent)
 $Object          
}#New-FactoryFilterDate
