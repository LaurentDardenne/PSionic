$global:here = Split-Path -Parent $MyInvocation.MyCommand.Path
$global:WorkDir = $env:TEMP

$PSionicModule=Get-Module PsIonic

&$global:here\init.ps1 | out-null

  Describe "Expand-ZipFile" {

    It "Expand C:\temp\unknown.zip file return true (exception)" {
        try{
           &$PSionicModule {Expand-ZipFile -File C:\temp\unknown.zip -Destination $global:WorkDir -ErrorAction Stop}
        }catch{
            $result=$_.Exception.Message -eq "Impossible de trouver le chemin d'accès « C:\temp\unknown.zip », car il n'existe pas."
        }
        $result | should be ($true)
    }

    It "Expand existing zip file in not existing destination return true (exception)" {
        try{
           &$PSionicModule {Expand-ZipFile -File $global:WorkDir\Archive.zip -Destination $global:WorkDir\Archive -ErrorAction Stop}
        }catch{
            $result=$_.Exception.Message -match "Le nom de chemin n'existe pas"
        }
        $result | should be ($true)
    }

    It "Expand a file that is not a zip file return true (exception)" {
        try{
           &$PSionicModule {Expand-ZipFile -File $global:here\PerfCenterCpl.ico -Destination $global:WorkDir\Archive -Create -ErrorAction Stop}
        }catch{
            $result=$_.Exception.Message -match "Une erreur s'est produite lors de la lecture de l'archive"
        }
        $result | should be ($true)
    }
  
    It "Expand Archive.zip file return true" {
        try{
           &$PSionicModule {Expand-ZipFile -File $global:WorkDir\Archive.zip -Destination $global:WorkDir\Archive -create -ErrorAction Stop}
           if(-not (test-path $global:WorkDir\Archive\test\test1\test2\Log4Net.Config.xml)){
             throw "Fichier provenant de l'archive non trouvé après extraction"
           }
           # rm $global:WorkDir\Archive -Recurse -Force : Pas de suppression, pour le test suivant
           $result=$true
        }catch{
            Write-host "Une erreur s'est produite : $($_.Exception.Message)" -ForegroundColor Yellow
            $result=$false
        }
        $result | should be ($true)
    }
	
	It "Expand zip file to already existing destination (throw) return true (exception)" {
        try{
           &$PSionicModule {Expand-ZipFile -File $global:WorkDir\Archive.zip -Destination $global:WorkDir\Archive -ErrorAction Stop}
        }catch{
			$result=$_.Exception.Message -match '« The file C:\\Users\\Matthew\\AppData\\Local\\Temp\\Archive\\directory\\Ionic.Zip.dll already exists. »'
        }
        $result | should be ($true)
    }
	
	It "Expand zip file to already existing destination (OverwriteSilently) return true" {
        try{
           &$PSionicModule {Expand-ZipFile -File $global:WorkDir\Archive.zip -Destination $global:WorkDir\Archive -ExtractAction OverwriteSilently -ErrorAction Stop}
           if(-not (test-path $global:WorkDir\Archive\test\test1\test2\Log4Net.Config.xml)){
             throw "Fichier provenant de l'archive non trouvé après extraction"
           }
           rm $global:WorkDir\Archive -Recurse -Force
           $result=$true
        }catch{
            Write-host "Une erreur s'est produite : $($_.Exception.Message)" -ForegroundColor Yellow
            $result=$false
        }
        $result | should be ($true)
    }
	
	It "Expand zip file to registry provider return true (exception)" {
        try{
           &$PSionicModule {Expand-ZipFile -File $global:WorkDir\Archive.zip -Destination hklm:\software -create -ErrorAction Stop}
        }catch{
            $result=$_.Exception.Message -match 'Le format du chemin d''accès donné n''est pas pris en charge.'
        }
        $result | should be ($true)
    }

	It "Expand zip file to wsman provider return true (exception)" {
        try{
           &$PSionicModule {Expand-ZipFile -File $global:WorkDir\Archive.zip -Destination wsman:\localhost -create -ErrorAction Stop}
        }catch{
            $result=$_.Exception.Message -match 'Le client ne peut pas se connecter à la destination spécifiée dans la demande'
        }
        $result | should be ($true)
    }

    It "Expand dll files from Archive.zip file return true" {
        try{
           &$PSionicModule {Expand-ZipFile -File $global:WorkDir\Archive.zip -Destination $global:WorkDir\Archive -create -Query '*.dll' -ErrorAction Stop}
           $Dllfiles = Get-ChildItem $global:WorkDir\Archive -filter *.dll -recurse
           $Files =  Get-ChildItem $global:WorkDir\Archive -recurse
           if($Dllfiles.count -ne 2 -or $Files.count -ne 5){
             throw "Les 2 fichiers .dll n'ont pas été extraits"
           }
           rm $global:WorkDir\Archive -Recurse -Force
           $result=$true
        }catch{
            Write-host "Une erreur s'est produite : $($_.Exception.Message)" -ForegroundColor Yellow
            $result=$false
        }
        $result | should be ($true)
    }

    It "Expand one dll file from a subdirectory in zip file return true" {
        try{
           &$PSionicModule {Expand-ZipFile -File $global:WorkDir\Archive.zip -Destination $global:WorkDir\Archive -create -Query '*.dll' -From 'directory' -ErrorAction Stop}
           $Dllfiles = Get-ChildItem $global:WorkDir\Archive -filter *.dll -recurse
           $Files =  Get-ChildItem $global:WorkDir\Archive -recurse
           if($Dllfiles.count -ne 1 -or $Files.count -ne 2){
             throw "Le fichier .dll n'a pas été extrait"
           }
           rm $global:WorkDir\Archive -Recurse -Force
           $result=$true
        }catch{
            Write-host "Une erreur s'est produite : $($_.Exception.Message)" -ForegroundColor Yellow
            $result=$false
        }
        $result | should be ($true)
    }
    
    It "Expand one dll file from a subdirectory in zip file with flatten return true" {
        try{
           &$PSionicModule {Expand-ZipFile -File $global:WorkDir\Archive.zip -Destination $global:WorkDir\Archive -create -Query '*.dll' -From 'directory' -Flatten -ErrorAction Stop}
           $Dllfiles = Get-ChildItem $global:WorkDir\Archive -filter *.dll -recurse
           $Files =  Get-ChildItem $global:WorkDir\Archive -recurse
           if($Dllfiles.count -ne 1 -or $Files.count -ne 1){
             throw "Le fichier .dll n'a pas été extrait"
           }
           rm $global:WorkDir\Archive -Recurse -Force
           $result=$true
        }catch{
            Write-host "Une erreur s'est produite : $($_.Exception.Message)" -ForegroundColor Yellow
            $result=$false
        }
        $result | should be ($true)
    }

    It "Expand zip file with many parameters from different parameter sets return true (exception)" {
        try{
           &$PSionicModule {Expand-ZipFile -File $global:WorkDir\Archive.zip -Destination $global:WorkDir\Archive -create -Query '*.dll' -From 'Archive\directory' -Flatten -List -ErrorAction Stop}
        }catch{
            $result= $_.Exception.Message -match 'Le jeu de paramètres ne peut pas être résolu à l''aide des paramètres nommés spécifiés.'
        }
        $result | should be ($true)
    }

    It "Expand zip file with list parameter return true" {
        try{
            $result = $null
            $result = &$PSionicModule {Expand-ZipFile -File $global:WorkDir\Archive.zip -List -ErrorAction Stop}
        }catch{
            Write-host "Une erreur s'est produite : $($_.Exception.Message)" -ForegroundColor Yellow
            $result= $false
        }
        $result | should be ($true)
    }

    It "Expand Archive.zip file with passthru parameter return true" {
        try{
            $result = $null
            $result = &$PSionicModule {Expand-ZipFile -File $global:WorkDir\Archive.zip -Destination $global:WorkDir\Archive -create -Passthru -ErrorAction Stop}
            if(-not (test-path $global:WorkDir\Archive\test\test1\test2\Log4Net.Config.xml)){
                throw "Fichier provenant de l'archive non trouvé après extraction"
            }
            rm $global:WorkDir\Archive -Recurse -Force
        }catch{
            Write-host "Une erreur s'est produite : $($_.Exception.Message)" -ForegroundColor Yellow
            $result=$false
        }
        $result | should be ($true)
    }

 # Tests for encrypted archive

     It "Expand encrypted zip file with BAD password return true (exception)" {
        try{
           &$PSionicModule {Expand-ZipFile -File $global:WorkDir\CryptedArchive.zip -Destination $global:WorkDir\CryptedArchive -create -Password BADpassword -ErrorAction Stop}
        }catch{
            $result= $_.Exception.Message -match 'Mot de passe incorrect'
        }
        $result | should be ($true)
    }

     It "Expand encrypted zip file with good password return true" {
        try{
           &$PSionicModule {Expand-ZipFile -File $global:WorkDir\CryptedArchive.zip -Destination $global:WorkDir\CryptedArchive -create -Password password -ErrorAction Stop}
           if(-not (test-path $global:WorkDir\CryptedArchive\Archive\PerfCenterCpl.ico)){
             throw "Fichier provenant de l'archive non trouvé après extraction"
           }
           if(-not (test-path $global:WorkDir\CryptedArchive\about_Pester.help.txt)){
             throw "Fichier provenant de l'archive non trouvé après extraction"
           }
           rm $global:WorkDir\CryptedArchive -Recurse -Force
           $result=$true
        }catch{
            Write-host "Une erreur s'est produite : $($_.Exception.Message)" -ForegroundColor Yellow
            $result=$false
        }
        $result | should be ($true)
    }

    It "Expand .ico file from encrypted zip file with good password return true" {
        try{
           &$PSionicModule {Expand-ZipFile -File $global:WorkDir\CryptedArchive.zip -Destination $global:WorkDir\CryptedArchive -create -Query '*.ico' -Password password -ErrorAction Stop}
           $icoFile = Get-ChildItem $global:WorkDir\CryptedArchive -filter *.ico -recurse
           $Files =  Get-ChildItem $global:WorkDir\CryptedArchive -recurse
           if($icoFile.count -ne 1 -or $Files.count -ne 2){
             throw "Les fichiers n'ont pas été extraits"
           }
           if(-not (test-path $global:WorkDir\CryptedArchive\Archive\PerfCenterCpl.ico)){
             throw "Le fichier .ico n'a pas été extrait"
           }
           rm $global:WorkDir\CryptedArchive -Recurse -Force
           $result=$true
        }catch{
            Write-host "Une erreur s'est produite : $($_.Exception.Message)" -ForegroundColor Yellow
            $result=$false
        }
        $result | should be ($true)
    }

    # TODO : Follow, Interactive

  }

