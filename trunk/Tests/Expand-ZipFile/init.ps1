# Suppression des fichiers qui ont servis aux tests précédents
if(Test-Path $global:WorkDir\Archive){ rm $global:WorkDir\Archive -Recurse -force -verbose }
if(Test-Path $global:WorkDir\CryptedArchive){ rm $global:WorkDir\CryptedArchive -Recurse -force -verbose }
if(Test-Path $global:WorkDir\Archive.zip){ rm $global:WorkDir\Archive.zip -force -verbose }
if(Test-Path $global:WorkDir\Archive1.zip){ rm $global:WorkDir\Archive1.zip -force -verbose }
if(Test-Path $global:WorkDir\CryptedArchive.zip){ rm $global:WorkDir\CryptedArchive.zip -Recurse -force -verbose }

# Création de Archive.zip dans le répertoire temporaire de l'utilisateur courant
md $global:WorkDir\Archive\directory  >$null
md $global:WorkDir\Archive\test\test1\test2  >$null
cp "$PsIonicTests\Expand-ZipFile\PerfCenterCpl.ico" $global:WorkDir\Archive
cp $PsIonicLivraison\PsIonicSetup.exe $global:WorkDir\Archive\test
cp "$PsIonicTests\Expand-ZipFile\about_Pester.help.txt" $global:WorkDir\Archive\test\test1
cp $PsIonicLivraison\PsIonic\3.0\PSIonicTools.dll $global:WorkDir\Archive\test\test1
cp $PsIonicLivraison\PsIonic\Log4Net.Config.xml $global:WorkDir\Archive\test\test1\test2
cp $PsIonicLivraison\PsIonic\Ionic.Zip.dll $global:WorkDir\Archive\directory
cp $PsIonicLivraison\PsIonic\Log4Net.Config.xml $global:WorkDir\Archive\directory
Compress-ZipFile -Path $global:WorkDir\Archive -Output $global:WorkDir\Archive.zip -Recurse

sleep -m 300
rm $global:WorkDir\Archive -Recurse -force

# Création de CryptedArchive.zip dans le répertoire temporaire de l'utilisateur courant
md $global:WorkDir\CryptedArchive\Archive > $null
cp "$PsIonicTests\Expand-ZipFile\about_Pester.help.txt" $global:WorkDir\CryptedArchive
cp "$PsIonicTests\Expand-ZipFile\PerfCenterCpl.ico" $global:WorkDir\CryptedArchive\Archive
Compress-ZipFile -Path $global:WorkDir\CryptedArchive -Output $global:WorkDir\CryptedArchive.zip -Password password -Recurse

rm $global:WorkDir\CryptedArchive -Recurse -force

Get-ChildItem $global:WorkDir\TestPsIonic -inc File*.txt -Rec|
 Compress-ZipFile -OutputName $global:WorkDir\Archive1.zip -EntryPathRoot $TestDirectory -ErrorAction Stop -Recurse 
