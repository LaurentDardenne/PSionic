$global:here = Split-Path -Parent $MyInvocation.MyCommand.Path
$global:WorkDir = $env:TEMP

$PSionicModule=Get-Module PsIonic

write-warning $global:here 
&$global:here\init.ps1 | out-null

  Describe "Expand-ZipFile" {

    It "Expand C:\temp\unknown.zip file return true (exception)" {
        try{
           Expand-ZipFile -Path C:\temp\unknown.zip -OutputPath $global:WorkDir -ErrorAction Stop
        }catch{
            $result=$_.Exception.Message -match [regex]::Escape("Impossible de trouver le chemin d'accès 'C:\temp\unknown.zip', car il n'existe pas")
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
           md $global:WorkDir\Archive >$null
           Expand-ZipFile -Path $global:WorkDir\Archive.zip -OutputPath $global:WorkDir\Archive -create -ExtractAction overwritesilently -ErrorAction Stop
           if(-not (test-path $global:WorkDir\Archive\test\test1\test2\Log4Net.Config.xml)){
             throw "Fichier provenant de l'archive introuvable après extraction"
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
             throw "Fichier provenant de l'archive introuvable après extraction"
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
           $result=$_.Exception.Message -match '^Chemin invalide pour le provider FileSystem'
        }
        $result | should be ($true)
    }
 
	It "Expand zip file to wsman provider return true (exception)" {
        try{
           Expand-ZipFile -Path $global:WorkDir\Archive.zip -OutputPath wsman:\localhost -create -ErrorAction Stop
        }catch{
            Write-host "Error : $($_.Exception.Message)" -ForegroundColor Yellow
            $result=$_.Exception.Message -match '^Chemin invalide pour le provider FileSystem'
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
             throw "Les 2 fichiers .dll n'ont pas été extraits"
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
           md $global:WorkDir\Archive >$null
           Expand-ZipFile -Path $global:WorkDir\Archive.zip -OutputPath $global:WorkDir\Archive -create -Query '*.dll' -From 'directory' -ErrorAction Stop
           $Dllfiles = @(Get-ChildItem $global:WorkDir\Archive -filter *.dll -recurse|Where  { !$_.PSIsContainer})
           if($Dllfiles.count -ne 1){
             throw "Le fichier .dll n'a pas été extrait"
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
           Expand-ZipFile -Path $global:WorkDir\Archive.zip -OutputPath $global:WorkDir\Archive -create -Query '*.dll' -From 'directory' -Flatten -ErrorAction Stop
           $Dllfiles = @(Get-ChildItem $global:WorkDir\Archive -filter *.dll -recurse|Where  { !$_.PSIsContainer})
           if($Dllfiles.count -ne 1){
             throw "Le fichier .dll n'a pas été extrait"
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
                throw "Fichier provenant de l'archive non trouvé après extraction"
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
             throw "Fichier provenant de l'archive inexistant après extraction"
           }
           if(-not (test-path $global:WorkDir\CryptedArchive\about_Pester.help.txt)){
             throw "Fichier provenant de l'archive inexistant après extraction"
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
             throw "Les fichiers n'ont pas été extraits"
           }
           if(-not (test-path $global:WorkDir\CryptedArchive\Archive\PerfCenterCpl.ico)){
             throw "Le fichier .ico n'a pas été extrait"
           }
           rm $global:WorkDir\CryptedArchive -Recurse -Force
           $result=$true
        }catch{
            Write-host "Error : $($_.Exception.Message)" -ForegroundColor Yellow
            $result=$false
        }
        $result | should be ($true)
    }
}
