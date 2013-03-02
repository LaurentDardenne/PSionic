$global:here = Split-Path -Parent $MyInvocation.MyCommand.Path
$global:sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path).Replace(".Tests.", ".")


 $PSionicModule=Get-Module PsIonic

  Describe "IsIconImage" {

    It "Test .BMP file return false" {
        &$PSionicModule {IsIconImage "$Global:here\background.bmp"} | should be ($false)
    }

    It "Test .PS1 file return false" {
        &$PSionicModule {IsIconImage "$global:sut"} | should be ($false)
    }
  
    It "Test .ICO file return true" {
        &$PSionicModule {IsIconImage "$Global:here\PerfCenterCpl.ico"} | should be ($true)
    }
  }
