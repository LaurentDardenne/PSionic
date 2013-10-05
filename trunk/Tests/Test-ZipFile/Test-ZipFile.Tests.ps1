$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$global:WorkDir = $env:TEMP

Describe "Test-ZipFile" {

    It "Test an unknown archive file" {
        try{
            del $global:WorkDir\TestArchive.zip 
            $result = $true 
            Test-ZipFile -File $global:WorkDir\TestArchive.zip -ea Stop
        }catch{
            Write-host "Error : $($_.Exception.Message)" -ForegroundColor Yellow
            $result=$false
        }
        $result | should be ($false)
    }

    It "Test an valid archive file" {
        try{
            Get-ChildItem C:\temp\PsIonic | Compress-ZipFile -Name $global:WorkDir\TestArchive.zip -ErrorAction Stop
            $result = Test-ZipFile -File $global:WorkDir\TestArchive.zip -ea Stop
        }catch{
            Write-host "Error : $($_.Exception.Message)" -ForegroundColor Yellow
            $result=$false
        }
        $result | should be ($true)
    }
 
     It 'Test an array of a valid archive file ( @(Dir "$global:WorkDir\TestArchive.zip") )' {
        try{
            Get-ChildItem C:\temp\PsIonic | Compress-ZipFile -Name $global:WorkDir\TestArchive.zip -ErrorAction Stop
            $result = Test-ZipFile -File @(Dir "$global:WorkDir\TestArchive.zip") -ea Stop
        }catch{
            Write-host "Error : $($_.Exception.Message)" -ForegroundColor Yellow
            $result=$false
        }
        $result | should be ($true)
    }
    It "Get an archive file name from an objet (ToString() transformation)" {
        try{
            $B=1|Select File
            $B|Add-Member -Force -MemberType ScriptMethod ToString { $this.File }
            $B.File="$global:WorkDir\TestArchive.zip"

            $result = Test-ZipFile -File $B -ea Stop
        }catch{
            Write-host "Error : $($_.Exception.Message)" -ForegroundColor Yellow
            $result=$false
        }
        $result | should be ($true)
    }
    It "Test an .exe file" {
        try{
            $result = Test-ZipFile -File "$PsIonicLivraison\PsIonicSetup.exe" -ea Stop
        }catch{
            Write-host "Error : $($_.Exception.Message)" -ForegroundColor Yellow
            $result=$false
        }
        $result | should be ($true)
    }    
    
    It "Test an unknown drive" {
        try{
           $result = $true 
           Test-ZipFile -File A:\TestArchive.zip -ea Stop 
        }catch{
            Write-host "Error : $($_.Exception.Message)" -ForegroundColor Yellow
            $result=$false
        }
        $result | should be ($false)
    }    

    It "Test an invalid archive file (.gz)" {
        try{
            $result = Test-ZipFile -File "$PSionicTests\Archive erronees\Test.gz" -ea Stop 
        }catch{
            Write-host "Error : $($_.Exception.Message)" -ForegroundColor Yellow
            $result=$true
        }
        $result | should be ($false)
    }

    It "Test an invalid archive file (.psm1)" {
        try{
            $result = Test-ZipFile -File "$PSionicLivraison\PsIonic\Psionic.psm1" -ea Stop 
        }catch{
            Write-host "Error : $($_.Exception.Message)" -ForegroundColor Yellow
            $result=$true
        }
        $result | should be ($false)
    }

    It "Test an invalid archive file (Directory)" {
        try{
            $result = $true
            Test-ZipFile -File (Get-Item 'C:\temp') -ea Stop
        }catch{
            Write-host "Error : $($_.Exception.Message)" -ForegroundColor Yellow
            $result=$false
        }
        $result | should be ($false)
    }
    
    It "Test an invalid archive file (..)" {
        try{
            $result = $true
            Test-ZipFile -File '..' -ea Stop 
        }catch{
            Write-host "Error : $($_.Exception.Message)" -ForegroundColor Yellow
            $result=$false
        }
        $result | should be ($false)
    }
    
    It "Test an invalid archive file (invalid PSdrive)" {
        try{
            $result = Test-ZipFile -File hklm:\SYSTEM\CurrentControlSet\services\Winmgmt -ea Stop 
        }catch{
            Write-host "Error : $($_.Exception.Message)" -ForegroundColor Yellow
            $result=$true
        }
        $result | should be ($true)
    }
    It "Test an invalid archive file (`$null)" {
        try{
            $result = $true
            Test-ZipFile -File $null -ea Stop
        }catch{
            Write-host "Error : $($_.Exception.Message)" -ForegroundColor Yellow
            $result=$false
        }
        $result | should be ($false)
    }
    
    It "Test an invalid archive file ([String]::Empty)" {
        try{
            $result = $true
            Test-ZipFile -File ([String]::Empty) -ea Stop 
        }catch{
            Write-host "Error : $($_.Exception.Message)" -ForegroundColor Yellow
            $result=$false
        }
        $result | should be ($false)
    }

    It "Test a lot of files (c:\temp\*.*)" {
        try{
            $result = $true
            Test-ZipFile -File 'c:\temp\*.*' -ea Stop 
        }catch{
            Write-host "Error : $($_.Exception.Message)" -ForegroundColor Yellow
            $result=$false
        }
        $result | should be ($true)
    }

    It "Test an array of globbing ( 'c:\temp\*.*','c:\*.*' )" {
        try{
            $result = $true
            Test-ZipFile -File 'c:\temp\*.*','c:\*.*' -ea Stop 
        }catch{
            Write-host "Error : $($_.Exception.Message)" -ForegroundColor Yellow
            $result=$false
        }
        $result | should be ($true)
    }    
}