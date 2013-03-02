$global:here = Split-Path -Parent $MyInvocation.MyCommand.Path
$global:sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path).Replace(".Tests.", ".")

$PSionicModule=Get-Module PsIonic

if(Test-Path $global:here\Archive){ rm $global:here\Archive -Recurse -force }

  Describe "Expand-ZipFile" {

    It "Expand C:\temp\unknown.zip file return true" {
        try{
           &$PSionicModule {Expand-ZipFile -File C:\temp\unknown.zip -Destination C:\temp\testExpandZipFile -ErrorAction Stop}
        }catch{
            $result=$_.Exception.Message -eq "Impossible de trouver le chemin d'accès « C:\temp\unknown.zip », car il n'existe pas."
        }
        $result | should be ($true)
    }

    It "Expand existing zip file in not existing destination return true" {
        try{
           &$PSionicModule {Expand-ZipFile -File $global:here\Archive.zip -Destination $global:here\Archive -ErrorAction Stop}
        }catch{
            $result=$_.Exception.Message -match "Le nom de chemin n'existe pas"
        }
        $result | should be ($true)
    }

    It "Expand a file that is not a zip file return true" {
        try{
           &$PSionicModule {Expand-ZipFile -File $global:here\PerfCenterCpl.ico -Destination $global:here\Archive -Create -ErrorAction Stop}
        }catch{
            $result=$_.Exception.Message -match "Une erreur s'est produite lors de la lecture de l'archive"
        }
        $result | should be ($true)
    }
  
    It "Expand Archive.zip file return true" {
        try{
           &$PSionicModule {Expand-ZipFile -File $global:here\Archive.zip -Destination $global:here\Archive -create -ErrorAction Stop}
           if(-not (test-path $global:here\Archive\Archive\test\test1\test2\background.bmp)){
             throw "Fichier provenant de l'archive non trouvé après extraction"
           }
           rm $global:here\Archive -Recurse -Force
           $result=$true
        }catch{
            $result=$false
        }
        $result | should be ($true)
    }

    It "Expand dll files from Archive.zip file return true" {
        try{
           &$PSionicModule {Expand-ZipFile -File $global:here\Archive.zip -Destination $global:here\Archive -create -Query '*.dll' -ErrorAction Stop}
           $Dllfiles = Get-ChildItem $global:here\Archive -filter *.dll -recurse
           $Files =  Get-ChildItem $global:here\Archive -recurse
           if($Dllfiles.count -ne 2 -or $Files.count -ne 2){
             throw "Les 2 fichiers .dll n'ont pas été extraits"
           }
           rm $global:here\Archive -Recurse -Force
           $result=$true
        }catch{
            $result=$false
        }
        $result | should be ($true)
    }

    It "Expand one dll file from a subdirectory in zip file return true" {
        try{
           &$PSionicModule {Expand-ZipFile -File $global:here\Archive.zip -Destination $global:here\Archive -create -Query '*.dll' -From 'Archive\directory' -ErrorAction Stop}
           $Dllfiles = Get-ChildItem $global:here\Archive -filter *.dll -recurse
           $Files =  Get-ChildItem $global:here\Archive -recurse
           if($Dllfiles.count -ne 1 -or $Files.count -ne 3){
             throw "Le fichier .dll n'a pas été extrait"
           }
           rm $global:here\Archive -Recurse -Force
           $result=$true
        }catch{
            $result=$false
        }
        $result | should be ($true)
    }
    
    It "Expand one dll file from a subdirectory in zip file with flatten return true" {
        try{
           &$PSionicModule {Expand-ZipFile -File $global:here\Archive.zip -Destination $global:here\Archive -create -Query '*.dll' -From 'Archive\directory' -Flatten -ErrorAction Stop}
           $Dllfiles = Get-ChildItem $global:here\Archive -filter *.dll -recurse
           $Files =  Get-ChildItem $global:here\Archive -recurse
           if($Dllfiles.count -ne 1 -or $Files.count -ne 1){
             throw "Le fichier .dll n'a pas été extrait"
           }
           rm $global:here\Archive -Recurse -Force
           $result=$true
        }catch{
            $result=$false
        }
        $result | should be ($true)
    }
  }

