$global:here = Split-Path -Parent $MyInvocation.MyCommand.Path
$global:WorkDir = $env:TEMP

$PSionicModule=Get-Module PsIonic

if(Test-Path $global:WorkDir\Archive.Zip){ rm $global:WorkDir\Archive.Zip -force }
if(Test-Path $global:WorkDir\CryptedArchive.Zip){ rm $global:WorkDir\CryptedArchive.Zip -force }

Describe "Compress-ZipFile" {

    It "Compress data to zip file and then expand it return true" {
        try{
            Get-ChildItem C:\temp\PsIonic | Compress-ZipFile -OutputName $global:WorkDir\Archive.zip -ErrorAction Stop 
            if(-not (Test-Path $global:WorkDir\Archive.zip)){
                throw "Archive introuvable"
            } 
            Expand-ZipFile -Path $global:WorkDir\Archive.zip -OutputPath $global:WorkDir\Archive -create  -ExtractAction OverwriteSilently -ErrorAction Stop
            del $global:WorkDir\Archive.zip
            rm $global:WorkDir\Archive -Recurse -Force
            $result = $true
        }catch{
            Write-host "Error : $($_.Exception.Message)" -ForegroundColor Yellow
            $result=$false
        }
        $result | should be ($true)
    }

    It "Compress data to zip file with comment and then expand it return true" {
        try{
            Get-ChildItem C:\temp\PsIonic | Compress-ZipFile -OutputName $global:WorkDir\Archive.zip -Comment "un commentaire pour tests : 03/03/2013" -ErrorAction Stop
            if(-not (Test-Path $global:WorkDir\Archive.zip)){
                throw "Archive introuvable"
            } 
            Expand-ZipFile -Path $global:WorkDir\Archive.zip -OutputPath $global:WorkDir\Archive -create -ExtractAction OverwriteSilently -ErrorAction Stop
            del $global:WorkDir\Archive.zip
            rm $global:WorkDir\Archive -Recurse -Force
            $result = $true
        }catch{
            Write-host "Error : $($_.Exception.Message)" -ForegroundColor Yellow
            $result=$false
        }
        $result | should be ($true)
    }

    It "Compress data to zip file with password (default encryption) and then expand it return true" {
        try{
            Get-ChildItem C:\temp\PsIonic | Compress-ZipFile -OutputName $global:WorkDir\CryptedArchive.zip -Password password -ErrorAction Stop
            if(-not (Test-Path $global:WorkDir\CryptedArchive.zip)){
                throw "Archive introuvable"
            } 
            Expand-ZipFile -Path $global:WorkDir\CryptedArchive.zip -OutputPath $global:WorkDir\CryptedArchive -create -Password password -ErrorAction Stop
            del $global:WorkDir\CryptedArchive.zip
            rm $global:WorkDir\CryptedArchive -Recurse -Force
            $result = $true
        }catch{
            Write-host "Error : $($_.Exception.Message)" -ForegroundColor Yellow
            $result=$false
        }
        $result | should be ($true)
    }

    It "Compress data to zip file with bad password for WinZipAes256 encryption (exception)" {
        try{
            Get-ChildItem C:\temp\PsIonic | Compress-ZipFile -OutputName $global:WorkDir\CryptedArchive.zip -Encryption WinZipAes256 -ErrorAction Stop
        }catch{
            $result=$_.Exception.Message -match "La valeur du paramètre Password \(''\) est invalide pour la valeur de DataEncryption 'WinZipAes256'."
        }
        $result | should be ($true)
    }

    It "Compress data to zip file with password (Bad encryption) return true (exception)" {
        try{
            Get-ChildItem C:\temp\PsIonic | Compress-ZipFile -OutputName $global:WorkDir\CryptedArchive.zip -Password password -Encryption BadEncryption -ErrorAction Stop
        }catch{
            $result=$_.Exception.Message -match 'Impossible de traiter la transformation d''argument sur le paramètre « Encryption »'
        }
        $result | should be ($true)
    }
}