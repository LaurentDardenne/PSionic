The development workstation must contain the following lines in the Powershell user profile :
{code:powershell}
."$env:PsIonicProfile\"Profile_DevCodePlex.Ps1"
{code:powershell}

Then create a system environment variable named 'PsIonicProfile', pointing to your working directory. For example:
{code:powershell}
$env:PsIonicProfile
#point to
C:\Users\Laurent\Documents\WindowsPowerShell\Tools
{code:powershell}

To finish, copy the script **{"Profile_DevCodePlex.Ps1"}** in the _$env:PsIonicProfile_ and change all the lines indicated as specific development computer :
{code:powershell}
    $SvnPathRepository = 'G:\PS' # Specific development workstation
{code:powershell}

## Install needed Tools :

PSake
Pester
helps
log4net