# Suppression des fichiers qui ont servis aux tests précédents
if(Test-Path $global:WorkDir\Archive){ rm $global:WorkDir\Archive -Recurse -force }
if(Test-Path $global:WorkDir\CryptedArchive){ rm $global:WorkDir\CryptedArchive -Recurse -force }
if(Test-Path $global:WorkDir\Archive.zip){ rm $global:WorkDir\Archive.zip -Recurse -force }
if(Test-Path $global:WorkDir\CryptedArchive.zip){ rm $global:WorkDir\CryptedArchive.zip -Recurse -force }

# Création de Archive.zip dans le répertoire temporaire de l'utilisateur courant
md $global:WorkDir\Archive
md $global:WorkDir\Archive\directory
md $global:WorkDir\Archive\test
md $global:WorkDir\Archive\test\test1
md $global:WorkDir\Archive\test\test1\test2
cp c:\Windows\System32\PerfCenterCpl.ico $global:WorkDir\Archive
cp c:\Temp\PsIonic\PsIonicSetup.exe $global:WorkDir\Archive\test
cp C:\Windows\System32\WindowsPowerShell\v1.0\Modules\Pester\en-US\about_Pester.help.txt $global:WorkDir\Archive\test\test1
cp C:\Temp\PsIonic\3.0\PSIonicTools.dll $global:WorkDir\Archive\test\test1
cp c:\Temp\PsIonic\Log4Net.Config.xml $global:WorkDir\Archive\test\test1\test2
cp C:\Temp\PsIonic\Ionic.Zip.dll $global:WorkDir\Archive\directory
cp c:\Temp\PsIonic\Log4Net.Config.xml $global:WorkDir\Archive\directory
Compress-ZipFile -File $global:WorkDir\Archive -Name $global:WorkDir\Archive.zip

rm $global:WorkDir\Archive -Recurse -force

# Création de CryptedArchive.zip dans le répertoire temporaire de l'utilisateur courant
md $global:WorkDir\CryptedArchive
md $global:WorkDir\CryptedArchive\Archive
cp C:\Windows\System32\WindowsPowerShell\v1.0\Modules\Pester\en-US\about_Pester.help.txt $global:WorkDir\CryptedArchive
cp c:\Windows\System32\PerfCenterCpl.ico $global:WorkDir\CryptedArchive\Archive
Compress-ZipFile -File $global:WorkDir\CryptedArchive -Name $global:WorkDir\CryptedArchive.zip -Password password

rm $global:WorkDir\CryptedArchive -Recurse -force