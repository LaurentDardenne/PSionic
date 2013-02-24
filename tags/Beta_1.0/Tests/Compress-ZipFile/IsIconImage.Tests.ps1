$global:here = Split-Path -Parent $MyInvocation.MyCommand.Path
$global:sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path).Replace(".Tests.", ".")


 $PSionicModule=Get-Module PsIonic

  Describe "IsIconImage" {

    It "Test .BMP file return false" {
        $result= &$PSionicModule {IsIconImage "$Global:here\background.bmp"}
        $result.should.be($false)
    }

    It "Test .PS1 file return false" {
        $result= &$PSionicModule {IsIconImage "$global:sut"} 
        $result.should.be($false)
    }
  
    It "Test .ICO file return true" {

        $result= &$PSionicModule {IsIconImage "$Global:here\PerfCenterCpl.ico"} 
        $result.should.be($true)
    }
  }
