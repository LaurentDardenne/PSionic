$global:here = Split-Path -Parent $MyInvocation.MyCommand.Path

if (Test-Path $Env:Temp)
{ $global:WorkDir=$Env:Temp }
else
{ $global:WorkDir=[System.IO.Path]::GetTempPath() }

$TestDirectory=Join-Path $global:WorkDir TestPsIonic

&"$(Split-Path $global:here)\Initialize-FilesTest.ps1"

$PSionicModule=Get-Module PsIonic

&$global:here\init.ps1 | out-null

  Describe "Expand-ZipFile" {

    It "Expand C:\temp\unknown.zip file return true (exception)" {
        try{
           Expand-ZipFile -Path C:\temp\unknown.zip -OutputPath $global:WorkDir -ErrorAction Stop
        }catch{
            $result=$_.Exception.Message -match [regex]::Escape("Impossible de trouver le chemin d'acc�s 'C:\temp\unknown.zip', car il n'existe pas")
        }
        $result | should be ($true)
    }

    It "Expand existing zip file in not existing OutputPath return true (exception)" {
        try{
           $global:path = $global:WorkDir+"\Archive"
           Expand-ZipFile -Path $global:WorkDir\Archive.zip -OutputPath "${path}2" -ExtractAction overwritesilently -ErrorAction Stop
        }catch {
            Write-host "Error : $($_.Exception.Message)" -ForegroundColor Yellow
            $result=$_.exception -is [PSIonicTools.PsionicException]
        }
        $result| should be ($true)
    }

    It "Expand a file that is not a zip file return true (exception)" {
        try{
           $global:notZipFile = $global:here+"\PerfCenterCpl.ico"
		   Expand-ZipFile -Path $notZipFile -OutputPath $global:WorkDir -Create 
        }catch{
            Write-host "Error : $($_.Exception.Message)" -ForegroundColor Yellow
            $result=$_.Exception.InnerException.InnerException.InnerException -is [Ionic.Zip.BadReadException]
        }
        $result | should be ($true)
    }
  
    It "Expand Archive.zip file return true" {
        try{
           Expand-ZipFile -Path $global:WorkDir\Archive.zip -OutputPath $global:WorkDir\Archive -create -ExtractAction overwritesilently -ErrorAction Stop
           if(-not (test-path $global:WorkDir\Archive\test\test1\test2\Log4Net.Config.xml)){
             throw "Fichier provenant de l'archive introuvable apr�s extraction"
           }
           $result=$true
        }catch{
            Write-host "Error : $($_.Exception.Message)" -ForegroundColor Yellow
            $result=$false
        }
        $result | should be ($true)
    }
	
	It "Expand zip file to already existing OutputPath (throw) return true (exception)" {
        try{
           Expand-ZipFile -Path $global:WorkDir\Archive.zip -OutputPath $global:WorkDir\Archive -ErrorAction Stop
        }catch{
			$Exception = "The file $($global:WorkDir)\Archive\directory\Ionic.Zip.dll already exists."
            Write-host "Error : $($_.Exception.Message)" -ForegroundColor Yellow
			$result=$_.Exception.Message -match ([regex]::Escape($Exception))
        }
        $result | should be ($true)
    }
	
	It "Expand zip file to already existing OutputPath (OverwriteSilently) return true" {
        try{
           Expand-ZipFile -Path $global:WorkDir\Archive.zip -OutputPath $global:WorkDir\Archive -ExtractAction OverwriteSilently -ErrorAction Stop
           if(-not (test-path $global:WorkDir\Archive\test\test1\test2\Log4Net.Config.xml)){
             throw "Fichier provenant de l'archive introuvable apr�s extraction"
           }
          # rm $global:WorkDir\Archive -Recurse -Force
           $result=$true
        }catch{
            Write-host "Error : $($_.Exception.Message)" -ForegroundColor Yellow
            $result=$false
        }
        $result | should be ($true)
    }
	
	It "Expand zip file to registry provider return true (exception)" {
        try{
           Expand-ZipFile -Path $global:WorkDir\Archive.zip -OutputPath hklm:\software -create -ErrorAction Stop
        }catch{
           Write-host "Error : $($_.Exception.Message)" -ForegroundColor Yellow
           $result=$_.Exception.Message -match '^Le chemin ne r�f�rence pas un fichier ou le chemin est invalide'
        }
        $result | should be ($true)
    }
 
	It "Expand zip file to wsman provider return true (exception)" {
        try{
           Expand-ZipFile -Path $global:WorkDir\Archive.zip -OutputPath wsman:\localhost -create -ErrorAction Stop
        }catch{
            Write-host "Error : $($_.Exception.Message)" -ForegroundColor Yellow
            $result=$_.Exception.Message -match '^Le chemin ne r�f�rence pas un fichier ou le chemin est invalide'
        }
        $result | should be ($true)
    }
 
    It "Expand dll files from Archive.zip file return true" {
        try{
           remove-item  $global:WorkDir\Archive\directory\*.dll -ea SilentlyContinue
           remove-item  $global:WorkDir\Archive\test\test1\*.dll -ea SilentlyContinue
           Expand-ZipFile -Path $global:WorkDir\Archive.zip -OutputPath $global:WorkDir\Archive -create -Query '*.dll' -ErrorAction Stop
           $Dllfiles = @(Get-ChildItem $global:WorkDir\Archive -filter *.dll -recurse|Where  { !$_.PSIsContainer})
           $Files =  @(Get-ChildItem $global:WorkDir\Archive -recurse -exclude *.dll|Where  { !$_.PSIsContainer})
           if($Dllfiles.count -ne 2 -or $Files.count -ne 5){
             throw "Les 2 fichiers .dll n'ont pas �t� extraits"
           }
           rm $global:WorkDir\Archive -Recurse -Force
           $result=$true
        }catch{
            Write-host "Error : $($_.Exception.Message)" -ForegroundColor Yellow
            $result=$false
        }
        $result | should be ($true)
    }
 
    It "Expand one dll file from a subdirectory in zip file return true" {
        try{
           rm $global:WorkDir\Archive -rec -force -ea silentlyContinue > $null
           md $global:WorkDir\Archive >$null
           Expand-ZipFile -Path $global:WorkDir\Archive.zip -OutputPath $global:WorkDir\Archive -create -Query '*.dll' -From 'directory/' -ErrorAction Stop
           $Dllfiles = @(Get-ChildItem $global:WorkDir\Archive -filter *.dll -recurse|Where  { !$_.PSIsContainer})
           if($Dllfiles.count -ne 1){
             throw "Le fichier .dll n'a pas �t� extrait"
           }
           rm $global:WorkDir\Archive -Recurse -Force
           $result=$true
        }catch{
            Write-host "Error : $($_.Exception.Message)" -ForegroundColor Yellow
            $result=$false
        }
        $result | should be ($true)
    }
    
    It "Expand one dll file from a subdirectory in zip file with flatten return true" {
        try{
           md $global:WorkDir\Archive >$null
           Expand-ZipFile -Path $global:WorkDir\Archive.zip -OutputPath $global:WorkDir\Archive -create -Query '*.dll' -From 'directory/' -Flatten -ErrorAction Stop
           $Dllfiles = @(Get-ChildItem $global:WorkDir\Archive -filter *.dll -recurse|Where  { !$_.PSIsContainer})
           if($Dllfiles.count -ne 1){
             throw "Le fichier .dll n'a pas �t� extrait"
           }
           rm $global:WorkDir\Archive -Recurse -Force
           $result=$true
        }catch{
            Write-host "Error : $($_.Exception.Message)" -ForegroundColor Yellow
            $result=$false
        }
        $result | should be ($true)
    }
 
    It "Expand Archive.zip file with passthru parameter return true" {
        try{
            $result = $null
            $result = Expand-ZipFile -Path $global:WorkDir\Archive.zip -OutputPath $global:WorkDir\Archive -create -Passthru -ErrorAction Stop
			$result.dispose()
            if(-not (test-path $global:WorkDir\Archive\test\test1\test2\Log4Net.Config.xml)){
                throw "Fichier provenant de l'archive non trouv� apr�s extraction"
            }
            #rm $global:WorkDir\Archive -Recurse -Force
        }catch{
            Write-host "Error : $($_.Exception.Message)" -ForegroundColor Yellow
            $result=$false
        }
        $result | should be ($true)
    }
 
 # Tests for encrypted archive

     It "Expand encrypted zip file with BAD password return true (exception)" {
        try{
           Expand-ZipFile -Path $global:WorkDir\CryptedArchive.zip -OutputPath $global:WorkDir\CryptedArchive -create -Password BADpassword -ErrorAction Stop
        }catch{
			Write-host "Error : $($_.Exception.Message)" -ForegroundColor Yellow
            $Exception = (&$PSionicModule {$PsIonicMsgs.ZipArchiveBadPassword -f ($global:WorkDir+"\CryptedArchive.zip")})
            $result= $_.Exception.Message -match ([regex]::Escape($Exception))
        }
        $result | should be ($true)
    }
 
     It "Expand encrypted zip file with good password return true" {
        try{
           Expand-ZipFile -Path $global:WorkDir\CryptedArchive.zip -OutputPath $global:WorkDir\CryptedArchive -create -Password password -ErrorAction Stop
           if(-not (test-path $global:WorkDir\CryptedArchive\Archive\PerfCenterCpl.ico)){
             throw "Fichier provenant de l'archive inexistant apr�s extraction"
           }
           if(-not (test-path $global:WorkDir\CryptedArchive\init.ps1)){
             throw "Fichier provenant de l'archive inexistant apr�s extraction"
           }
           rm $global:WorkDir\CryptedArchive -Recurse -Force
           $result=$true
        }catch{
            Write-host "Error : $($_.Exception.Message)" -ForegroundColor Yellow
            $result=$false
        }
        $result | should be ($true)
    }

    It "Expand .ico file from encrypted zip file with good password return true" {
        try{
           Expand-ZipFile -Path $global:WorkDir\CryptedArchive.zip -OutputPath $global:WorkDir\CryptedArchive -create -Query '*.ico' -Password password -ExtractAction OverwriteSilently -ErrorAction Stop
           $icoFile = @(Get-ChildItem $global:WorkDir\CryptedArchive -filter *.ico -recurse)
           $Files =  @(Get-ChildItem $global:WorkDir\CryptedArchive -recurse)
           if($icoFile.count -ne 1 -or $Files.count -ne 2){
             throw "Les fichiers n'ont pas �t� extraits"
           }
           if(-not (test-path $global:WorkDir\CryptedArchive\Archive\PerfCenterCpl.ico)){
             throw "Le fichier .ico n'a pas �t� extrait"
           }
           rm $global:WorkDir\CryptedArchive -Recurse -Force
           $result=$true
        }catch{
            Write-host "Error : $($_.Exception.Message)" -ForegroundColor Yellow
            $result=$false
        }
        $result | should be ($true)
    }

    It "Compare the files name compressed by : Get-ChildItem $global:WorkDir\TestPsIonic -inc File*.txt -Rec" {
        try{
            $ExpectedFiles=@(
              "$global:WorkDir\Archive1\Backup1\File.txt",
              "$global:WorkDir\Archive1\Backup1\File1.txt",
              "$global:WorkDir\Archive1\Backup1\File2.txt",
              "$global:WorkDir\Archive1\Backup1\File[1].txt",
              "$global:WorkDir\Archive1\Backup1\File[2].txt",
              "$global:WorkDir\Archive1\Backup2\File.txt",
              "$global:WorkDir\Archive1\Backup2\File1.txt",
              "$global:WorkDir\Archive1\Backup2\File2.txt",
              "$global:WorkDir\Archive1\Backup2\File[1].txt",
              "$global:WorkDir\Archive1\Backup2\File[2].txt",
              "$global:WorkDir\Archive1\Backup[1]\File.txt",
              "$global:WorkDir\Archive1\Backup[1]\File1.txt",
              "$global:WorkDir\Archive1\Backup[1]\File2.txt",
              "$global:WorkDir\Archive1\Backup[1]\File[1].txt",
              "$global:WorkDir\Archive1\Backup[1]\File[2].txt",
              "$global:WorkDir\Archive1\Backup[2]\File.txt",
              "$global:WorkDir\Archive1\Backup[2]\File1.txt",
              "$global:WorkDir\Archive1\Backup[2]\File2.txt",
              "$global:WorkDir\Archive1\Backup[2]\File[1].txt",
              "$global:WorkDir\Archive1\Backup[2]\File[2].txt",
              "$global:WorkDir\Archive1\Test[\File.txt",
              "$global:WorkDir\Archive1\Test[\File1.txt",
              "$global:WorkDir\Archive1\Test[\File2.txt",
              "$global:WorkDir\Archive1\Test[\File[1].txt",
              "$global:WorkDir\Archive1\Test[\File[2].txt",
              "$global:WorkDir\Archive1\Test[zi]p\File.txt",
              "$global:WorkDir\Archive1\Test[zi]p\File1.txt",
              "$global:WorkDir\Archive1\Test[zi]p\File2.txt",
              "$global:WorkDir\Archive1\Test[zi]p\File[1].txt",
              "$global:WorkDir\Archive1\Test[zi]p\File[2].txt",
              ("$global:WorkDir\Archive1"+'\Test`[\File.txt'),
              ("$global:WorkDir\Archive1"+'\Test`[\File1.txt'),
              ("$global:WorkDir\Archive1"+'\Test`[\File2.txt'),
              ("$global:WorkDir\Archive1"+'\Test`[\File[1].txt'),
              ("$global:WorkDir\Archive1"+'\Test`[\File[2].txt'),
              "$global:WorkDir\Archive1\File.txt",
              "$global:WorkDir\Archive1\File1.txt",
              "$global:WorkDir\Archive1\File2.txt",
              "$global:WorkDir\Archive1\File[1].txt",
              "$global:WorkDir\Archive1\File[2].txt"
            )          
           rm $global:WorkDir\Archive1 -Recurse -Force -ea SilentlyContinue 
           Expand-ZipFile -Path $global:WorkDir\Archive1.zip -OutputPath $global:WorkDir\Archive1 -create -ExtractAction OverwriteSilently -ErrorAction Stop
           $Files =  @(Get-ChildItem $global:WorkDir\Archive1 -Recurse|? {$_.PSisContainer -eq $false }|Select -expand FullName )
           $Cmp=@(Compare-Object $ExpectedFiles $Files)
           $Result=$Cmp.Count -eq 0
           if ($Result -eq $false)
           {
             Write-host @"
$($cmp|select *)
=> Entr�e suppl�mentaire dans le catalogue
<= Entr�e manquante dans le catalogue
"@
             throw "Les fichiers extraits ne correspondent pas � ceux compress�s."
           }
           rm $global:WorkDir\Archive1 -Recurse -Force
           $result=$true
        }catch{
            Write-host "Error : $($_.Exception.Message)" -ForegroundColor Yellow
            $result=$false
        }
        $result | should be ($true)
    }

    It "Expand each zip file in a dedicated directory" {
        "$TestDirectory\File1.txt"|Compress-ZipFile -OutputName "$TestDirectory\File1.zip"
        "$TestDirectory\File2.txt"|Compress-ZipFile -OutputName "$TestDirectory\File2.zip"
        
        "$TestDirectory\File1.zip","$TestDirectory\File2.zip"|
        Dir |
         Expand-ZipFile -OutputPath {"$TestDirectory\$($_.BaseName)"} -Create -ExtractAction OverwriteSilently
        $result =("$TestDirectory\file1\File1.txt","$TestDirectory\file2\File2.txt"|Test-Path) -contains $false
        $result | should be ($false)
    }
}
