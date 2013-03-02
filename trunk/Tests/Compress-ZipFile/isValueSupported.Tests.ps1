
$PSionicModule=Get-Module PsIonic

  Describe "isValueSupported" {
   
   It "Test [Ionic.Zip.ExtractExistingFileAction]::Unknown return true" {
      try {
        &$PSionicModule {isValueSupported Unknown -Extract}
      }catch {
        $result=$_.Exception.Message -match "Impossible de convertir la valeur « Unknown » en type"
      } 
      $result | should be ($true)
   }
   
   It "Test [Ionic.Zip.ExtractExistingFileAction]::Throw return true" {
      $result= &$PSionicModule {isValueSupported Throw -Extract}
      $result | should be ($true)
   }
   
   It "Test [Ionic.Zip.ExtractExistingFileAction]::InvokeExtractProgressEvent return exception" {
      try {
         &$PSionicModule {isValueSupported InvokeExtractProgressEvent -Extract}
      }catch {
         $result=$_.Exception.Message -eq "La valeur 'InvokeExtractProgressEvent' n'est pas supportée."
      } 
      $result | should be ($true)
   }

   It "Test [Ionic.Zip.ZipErrorAction]::Unknown return true" {
      try {
        &$PSionicModule {isValueSupported Unknown }
      }catch {
        $result=$_.Exception.Message -match "Impossible de convertir la valeur « Unknown » en type"
      } 
      $result | should be ($false)   
   }
   
   It "Test [Ionic.Zip.ZipErrorAction]::Throw return true" {
      $result= &$PSionicModule {isValueSupported Throw}
      $result | should be ($true)
   }
   
   It "Test [Ionic.Zip.ZipErrorAction]::InvokeErrorEvent return exception" {
      try {
         &$PSionicModule {isValueSupported InvokeErrorEvent -Extract}
      }catch {
         $result=$_.Exception.Message -match "Impossible de convertir la valeur « InvokeErrorEvent » en type"
      } 
      $result | should be ($true)
   }
  }
