$global:here = Split-Path -Parent $MyInvocation.MyCommand.Path
    $global:sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path).Replace(".Tests.", ".")

 $PSionicModule=Get-Module PsIonic

    Describe "GetSFXName" {
      It "Test `$null return false" {
          $result= (&$PSionicModule {GetSFXName $null}) -eq "C:\Temp\Archive.exe"
          $result.should.be($false)
      }
      
      It "Test string.Empty return false" {
          $result= (&$PSionicModule {GetSFXName [string]::Empty}) -eq "C:\Temp\Archive.exe"
          $result.should.be($false)
      }
      
      It "Test 'C:\Temp\Archive.txt' return false" {
          $result= (&$PSionicModule {GetSFXName 'C:\Temp\Archive.txt'}) -eq "C:\Temp\Archive.exe"
          $result.should.be($false)
      }
      
      It "Test 'C:\temp\Archive.Zip' return true" {
          $result= (&$PSionicModule {GetSFXName "C:\Temp\Archive.Zip"}) -eq "C:\Temp\Archive.exe"
          $result.should.be($true)
      }
    }
