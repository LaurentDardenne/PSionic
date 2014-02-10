$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$global:WorkDir = $env:TEMP

Describe "Get-ZipFile" {

    It "Get an archive file" {
        try{
            Get-ChildItem C:\temp\PsIonic | Compress-ZipFile -OutputName $global:WorkDir\TestArchive.zip -ErrorAction Stop
            if(-not (Test-Path $global:WorkDir\Archive.zip)){
                throw "Archive introuvable"
            }
            $Z=Get-ZipFile -Path $global:WorkDir\TestArchive.zip
            $Z.Close()
            $result = $true
        }catch{
            Write-host "Error : $($_.Exception.Message)" -ForegroundColor Yellow
            $result=$false
        }
        $result | should be ($true)
    }

    It "Get an archive file from an objet (ToString() transformation)" {
        try{
            $B=1|Select PathName
            $B|Add-Member -Force -MemberType ScriptMethod ToString { $this.PathName }
            $B.PathName="$global:WorkDir\TestArchive.zip"

            Get-ChildItem C:\temp\PsIonic | Compress-ZipFile -OutputName $global:WorkDir\TestArchive.zip -ErrorAction Stop
            if(-not (Test-Path $global:WorkDir\Archive.zip)){
                throw "Archive introuvable"
            }
            $Z=Get-ZipFile -Path $B #$global:WorkDir\TestArchive.zip
            $Z.Close()
            $result = $true
        }catch{
            Write-host "Error : $($_.Exception.Message)" -ForegroundColor Yellow
            $result=$false
        }
        $result | should be ($true)
    }
    
    It "Get an encrypted archive file" {
        try{
            del $global:WorkDir\TestCryptedArchive.zip -ea SilentlyContinue
            Get-ChildItem C:\temp\PsIonic | Compress-ZipFile -OutputName $global:WorkDir\TestCryptedArchive.zip -Password password -ErrorAction Stop  
            if(-not (Test-Path $global:WorkDir\TestCryptedArchive.zip)){
                throw "Archive introuvable"
            }
            $Z=Get-ZipFile -Path $global:WorkDir\TestCryptedArchive.zip -Password password 
            $Z.Close()
            $result = $true
        }catch{
            Write-host "Error : $($_.Exception.Message)" -ForegroundColor Yellow
            $result=$false
        }
        $result | should be ($true)
    }

    It "Try to get an encrypted archive file with a bad password" {
        try{
            $Z=Get-ZipFile -Path $global:WorkDir\TestCryptedArchive.zip -Password fauxpassword  -ea Stop
            if ($z -ne $null) {$Z.Close()}
            $result = $false
        }catch{
            Write-host "Error : $($_.Exception.Message)" -ForegroundColor Yellow
            $result=$true
        }
        $result | should be ($true)
    }
      
#     It "try to get an unknown archive file" {
#         try{
#             del $global:WorkDir\TestArchive.zip 
#             $Z=Get-ZipFile -Path $global:WorkDir\TestArchive.zip -ea Stop
#             $result = $false
#         }catch{
#             Write-host "Error : $($_.Exception.Message)" -ForegroundColor Yellow
#             $result=$true
#         }
#         $result | should be ($true)
#     }
# 
#     It "try to get an exe" {
#         try{
#             $Z=Get-ZipFile -Path "$PsIonicLivraison\PsIonicSetup.exe" -ea Stop
#             $Z.PSDispose()
#             $result = $true
#         }catch{
#             Write-host "Error : $($_.Exception.Message)" -ForegroundColor Yellow
#             $result=$False
#         }
#         $result | should be ($true)
#     }    
# 
#     It "try to get and save an exe" {
#         try{
#             $Z=Get-ZipFile -Path "$PsIonicLivraison\PsIonicSetup.exe" -ea Stop
#             $Z.Close()
#             $result = $false
#         }catch{
#             Write-host "Error : $($_.Exception.Message)" -ForegroundColor Yellow
#             $result=$true
#         }
#         $result | should be ($true)
#     }    
#     
#     It "try to get an unknown drive" {
#         try{
#             $Z=Get-ZipFile -Path A:\TestArchive.zip -ea Stop
#             $result = $false
#         }catch{
#             Write-host "Error : $($_.Exception.Message)" -ForegroundColor Yellow
#             $result=$true
#         }
#         $result | should be ($true)
#     }    
# 
#     It "Try to get an invalid archive file (.gz)" {
#         try{
#             $Z=Get-ZipFile -Path "$PSionicTests\Archive erronees\Test.gz" -ea Stop
#             $result = $false
#         }catch{
#             Write-host "Error : $($_.Exception.Message)" -ForegroundColor Yellow
#             $result=$true
#         }
#         $result | should be ($true)
#     }
# 
#     It "Try to get an invalid archive file (.psm1)" {
#         try{
#             $Z=Get-ZipFile -Path "$PSionicLivraison\PsIonic\Psionic.psm1" -ea Stop
#             $result = $false
#         }catch{
#             Write-host "Error : $($_.Exception.Message)" -ForegroundColor Yellow
#             $result=$true
#         }
#         $result | should be ($true)
#     }
# 
#     It "Try to get an invalid archive file (Directory)" {
#         try{
#             #Ne renvoi pas de fichier
#             $Z=Get-ZipFile -Path (Get-Item 'C:\temp') -ea Stop
#             $result = $true
#         }catch{
#             Write-host "Error : $($_.Exception.Message)" -ForegroundColor Yellow
#             $result=$false
#         }
#         $result | should be ($true)
#     }
#     
#     It "Try to get an invalid archive file (..)" {
#         try{
#              #Ne renvoi pas de fichier
#             $Z=Get-ZipFile -Path .. -ea Stop
#             $result = $true
#         }catch{
#             Write-host "Error : $($_.Exception.Message)" -ForegroundColor Yellow
#             $result=$false
#         }
#         $result | should be ($true)
#     }
#     
#     It "Try to get an invalid archive file (invalid PSdrive)" {
#         try{
#             $Z=Get-ZipFile -Path hklm:\SYSTEM\CurrentControlSet\services\Winmgmt -ea Stop
#             $result = $false
#         }catch{
#             Write-host "Error : $($_.Exception.Message)" -ForegroundColor Yellow
#             $result=$true
#         }
#         $result | should be ($true)
#     }
#     It "Try to get an invalid archive file (`$null)" {
#         try{
#             $Z=Get-ZipFile -Path $Null -ea Stop
#             $result = $false
#         }catch{
#             Write-host "Error : $($_.Exception.Message)" -ForegroundColor Yellow
#             $result=$true
#         }
#         $result | should be ($true)
#     }
#     
#     It "Try to get an invalid archive file ([String]::Empty)" {
#         try{
#             $Z=Get-ZipFile -Path ([String]::Empty) -ea Stop
#             $result = $false
#         }catch{
#             Write-host "Error : $($_.Exception.Message)" -ForegroundColor Yellow
#             $result=$true
#         }
#         $result | should be ($true)
#     }
# 
#     It "Get archives files" {
#         try{
#             Get-ChildItem C:\temp\PsIonic | Compress-ZipFile -OutputName $global:WorkDir\TestArchive.zip -ErrorAction Stop
#             if(-not (Test-Path $global:WorkDir\Archive.zip)){
#                 throw "Archive introuvable"
#             }
#             Get-ChildItem C:\temp\PsIonic | Compress-ZipFile -OutputName $global:WorkDir\TestArchive2.zip -ErrorAction Stop
#             if(-not (Test-Path $global:WorkDir\Archive.zip)){
#                 throw "Archive introuvable"
#             } 
#             $Zips=Get-ZipFile -Path $global:WorkDir\TestArchive.zip,$global:WorkDir\TestArchive2.zip
#             $result = (($Zips[0].Name -eq "$global:WorkDir\TestArchive.zip") -and ($Zips[1].Name -eq "$global:WorkDir\TestArchive2.zip"))
#             $Zips[0].Close()
#             $Zips[1].Close()
#         }catch{
#             Write-host "Error : $($_.Exception.Message)" -ForegroundColor Yellow
#             $result=$false
#         }
#         $result | should be ($true)
#     }    
}


