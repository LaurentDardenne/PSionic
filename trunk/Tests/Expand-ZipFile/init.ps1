# Suppression des fichiers qui ont servis aux tests précédents
if(Test-Path $global:WorkDir\Archive){ rm $global:WorkDir\Archive -Recurse -force -verbose }
if(Test-Path $global:WorkDir\CryptedArchive){ rm $global:WorkDir\CryptedArchive -Recurse -force -verbose }
if(Test-Path $global:WorkDir\Archive.zip){ rm $global:WorkDir\Archive.zip -Recurse -force -verbose }
if(Test-Path $global:WorkDir\CryptedArchive.zip){ rm $global:WorkDir\CryptedArchive.zip -Recurse -force -verbose }

# Création de Archive.zip dans le répertoire temporaire de l'utilisateur courant
md $global:WorkDir\Archive\directory  >$null
md $global:WorkDir\Archive\test\test1\test2  >$null
cp "$($PsIonic.tests)\Expand-ZipFile\PerfCenterCpl.ico" $global:WorkDir\Archive
cp c:\Temp\PsIonic\PsIonicSetup.exe $global:WorkDir\Archive\test
cp "$($PsIonic.tests)\Expand-ZipFile\about_Pester.help.txt" $global:WorkDir\Archive\test\test1
cp C:\Temp\PsIonic\3.0\PSIonicTools.dll $global:WorkDir\Archive\test\test1
cp c:\Temp\PsIonic\Log4Net.Config.xml $global:WorkDir\Archive\test\test1\test2
cp C:\Temp\PsIonic\Ionic.Zip.dll $global:WorkDir\Archive\directory
cp c:\Temp\PsIonic\Log4Net.Config.xml $global:WorkDir\Archive\directory
Compress-ZipFile -Path $global:WorkDir\Archive -Output $global:WorkDir\Archive.zip

rm $global:WorkDir\Archive -Recurse -force

# Création de CryptedArchive.zip dans le répertoire temporaire de l'utilisateur courant
md $global:WorkDir\CryptedArchive\Archive > $null
cp "$($PsIonic.tests)\Expand-ZipFile\about_Pester.help.txt" $global:WorkDir\CryptedArchive
cp "$($PsIonic.tests)\Expand-ZipFile\PerfCenterCpl.ico" $global:WorkDir\CryptedArchive\Archive
Compress-ZipFile -Path $global:WorkDir\CryptedArchive -Output $global:WorkDir\CryptedArchive.zip -Password password

rm $global:WorkDir\CryptedArchive -Recurse -force