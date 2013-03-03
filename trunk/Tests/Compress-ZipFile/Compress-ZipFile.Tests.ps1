$global:here = Split-Path -Parent $MyInvocation.MyCommand.Path

$PSionicModule=Get-Module PsIonic

if(Test-Path $global:here\Archive.Zip){ rm $global:here\Archive.Zip -Recurse -force }
if(Test-Path $global:here\CryptedArchive.Zip){ rm $global:here\CryptedArchive.Zip -Recurse -force }

Describe "Compress-ZipFile" {

    It "Compress data to zip file and then expand it return true" {
        try{
            &$PSionicModule {Get-ChildItem C:\temp\PsIonic | Compress-ZipFile -Name $global:here\Archive.zip -ErrorAction Stop  }
            if(-not (Test-Path $global:here\Archive.zip)){
                throw "Archive introuvable"
            } 
            &$PSionicModule {Expand-ZipFile -File $global:here\Archive.zip -Destination $global:here\Archive -create -ErrorAction Stop}
            del $global:here\Archive.zip
            rm $global:here\Archive -Recurse -Force
            $result = $true
        }catch{
            Write-host "Une erreur s'est produite : $($_.Exception.Message)" -ForegroundColor DarkRed
            $result=$false
        }
        $result | should be ($true)
    }

    It "Compress data to zip file with comment and then expand it return true" {
        try{
            &$PSionicModule {Get-ChildItem C:\temp\PsIonic | Compress-ZipFile -Name $global:here\Archive.zip -Comment "un commentaire pour tests : 03/03/2013" -ErrorAction Stop  }
            if(-not (Test-Path $global:here\Archive.zip)){
                throw "Archive introuvable"
            } 
            &$PSionicModule {Expand-ZipFile -File $global:here\Archive.zip -Destination $global:here\Archive -create -ErrorAction Stop}
            del $global:here\Archive.zip
            rm $global:here\Archive -Recurse -Force
            $result = $true
        }catch{
            Write-host "Une erreur s'est produite : $($_.Exception.Message)" -ForegroundColor DarkRed
            $result=$false
        }
        $result | should be ($true)
    }

    It "Compress data to zip file with password (default encryption) and then expand it return true" {
        try{
            &$PSionicModule {Get-ChildItem C:\temp\PsIonic | Compress-ZipFile -Name $global:here\CryptedArchive.zip -Password password -ErrorAction Stop  }
            if(-not (Test-Path $global:here\CryptedArchive.zip)){
                throw "Archive introuvable"
            } 
            &$PSionicModule {Expand-ZipFile -File $global:here\CryptedArchive.zip -Destination $global:here\CryptedArchive -create -Password password -ErrorAction Stop}
            del $global:here\CryptedArchive.zip
            rm $global:here\CryptedArchive -Recurse -Force
            $result = $true
        }catch{
            Write-host "Une erreur s'est produite : $($_.Exception.Message)" -ForegroundColor DarkRed
            $result=$false
        }
        $result | should be ($true)
    }

    It "Compress data to zip file with bad password (WinZipAes256 encryption) and then expand it return true (exception)" {
        try{
            &$PSionicModule {Get-ChildItem C:\temp\PsIonic | Compress-ZipFile -Name $global:here\CryptedArchive.zip -Password password -Encryption WinZipAes256 -ErrorAction Stop  }
        }catch{
            $result=$_.Exception.Message -match "La valeur du paramètre Password \('password'\) est invalide pour la valeur de DataEncryption 'WinZipAes256'."

        }
        $result | should be ($true)
    }

    It "Compress data to zip file with password (Bad encryption) return true (exception)" {
        try{
            &$PSionicModule {Get-ChildItem C:\temp\PsIonic | Compress-ZipFile -Name $global:here\CryptedArchive.zip -Password password -Encryption BadEncryption -ErrorAction Stop  }
        }catch{
            $result=$_.Exception.Message -match 'Impossible de traiter la transformation d''argument sur le paramètre « Encryption »'
        }
        $result | should be ($true)
    }


}