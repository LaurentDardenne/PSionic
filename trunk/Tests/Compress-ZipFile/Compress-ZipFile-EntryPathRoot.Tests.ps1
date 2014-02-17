$global:here = Split-Path -Parent $MyInvocation.MyCommand.Path

if (Test-Path $Env:Temp)
{ $global:WorkDir=$Env:Temp }
else
{ $global:WorkDir=[System.IO.Path]::GetTempPath() }

$TestDirectory=Join-Path $global:WorkDir TestPsIonic

Remove-Item $global:WorkDir\Archive??.zip -Force

Function ValidateExpectedContent {
 param($path,$ExpectedEntries) 
  try {
   $ZipFile=Get-Zipfile -Path $Path
   $Catalog=$ZipFile.Entries|select -expand Filename  
  } finally {
   $ZipFile.PSDispose()
  }   
  $Cmp=@(Compare-Object $ExpectedEntries $Catalog)
  $Result=$Cmp.Count -eq 0
  if ($Result -eq $false)
  {
   Write-host @"
$($cmp|select *)
=> Entrée supplémentaire dans le catalogue
<= Entrée manquante dans le catalogue
"@
  }
  $Result
}#ValidateExpectedContent

function LZ {
  try {
   $ZipFile=Get-Zipfile -Path  $global:WorkDir\Archive1.zip 
   $ZipFile.Entries| Select -Expand FileName|% { "'$_',"}
  } finally {
   $ZipFile.PSDispose()
  }
}

Describe "Compress-ZipFile: EntryPathRoot" {

    It "Compressing an archive recursively, then validates its contents : Get-ChildItem `$TestDirectory\Backup?\File*.txt -Rec" {
        try{
            $ExpectedContent=@(
            'Backup1/File.txt',
            'Backup1/File1.txt',
            'Backup1/File2.txt',
            'Backup1/File[1].txt',
            'Backup1/File[2].txt',
            'Backup2/File.txt',
            'Backup2/File1.txt',
            'Backup2/File2.txt',
            'Backup2/File[1].txt',
            'Backup2/File[2].txt'
            )
            
            Get-ChildItem $TestDirectory\backup?\File*.txt -rec |
             Compress-ZipFile -OutputName $global:WorkDir\Archive1.zip -EntryPathRoot $TestDirectory -ErrorAction Stop -Recurse 
            if(-not (Test-Path $global:WorkDir\Archive1.zip)){
                throw "Archive introuvable"
            } 
            $result = ValidateExpectedContent "$global:WorkDir\Archive1.zip" $ExpectedContent
        }catch{
            Write-host "Error : $($_.Exception.Message)" -ForegroundColor Yellow
            $result=$false
        }
        $result | should be ($true)
    }
    
    It "Compressing an archive recursively, then validates its contents : Get-ChildItem `$TestDirectory -inc File*.txt -Rec" {
        try{
            $ExpectedContent=@(
              'Backup1/File.txt',
              'Backup1/File1.txt',
              'Backup1/File2.txt',
              'Backup1/File[1].txt',
              'Backup1/File[2].txt',
              'Backup2/File.txt',
              'Backup2/File1.txt',
              'Backup2/File2.txt',
              'Backup2/File[1].txt',
              'Backup2/File[2].txt',
              'Backup[1]/File.txt',
              'Backup[1]/File1.txt',
              'Backup[1]/File2.txt',
              'Backup[1]/File[1].txt',
              'Backup[1]/File[2].txt',
              'Backup[2]/File.txt',
              'Backup[2]/File1.txt',
              'Backup[2]/File2.txt',
              'Backup[2]/File[1].txt',
              'Backup[2]/File[2].txt',
              'Test[/File.txt',
              'Test[/File1.txt',
              'Test[/File2.txt',
              'Test[/File[1].txt',
              'Test[/File[2].txt',
              'Test[zi]p/File.txt',
              'Test[zi]p/File1.txt',
              'Test[zi]p/File2.txt',
              'Test[zi]p/File[1].txt',
              'Test[zi]p/File[2].txt',
              'Test`[/File.txt',
              'Test`[/File1.txt',
              'Test`[/File2.txt',
              'Test`[/File[1].txt',
              'Test`[/File[2].txt',
              'File.txt',
              'File1.txt',
              'File2.txt',
              'File[1].txt',
              'File[2].txt'
            )
            
            Get-ChildItem $TestDirectory -inc File*.txt -Rec|
             Compress-ZipFile -OutputName $global:WorkDir\Archive1.zip -EntryPathRoot $TestDirectory -ErrorAction Stop -Recurse 
            if(-not (Test-Path $global:WorkDir\Archive1.zip)){
                throw "Archive introuvable"
            } 
            $result = ValidateExpectedContent $global:WorkDir\Archive1.zip $ExpectedContent
        }catch{
            Write-host "Error : $($_.Exception.Message)" -ForegroundColor Yellow
            $result=$false
        }
        $result | should be ($true)
    }

    It "Compressing an archive recursively , then validates its content : Get-ChildItem `$TestDirectory -Include 'File[12].txt' -rec" {
        try{
            $ExpectedContent=@(
              'Backup1/File1.txt',
              'Backup1/File2.txt',
              'Backup2/File1.txt',
              'Backup2/File2.txt',
              'Backup[1]/File1.txt',
              'Backup[1]/File2.txt',
              'Backup[2]/File1.txt',
              'Backup[2]/File2.txt',
              'Test[/File1.txt',
              'Test[/File2.txt',
              'Test[zi]p/File1.txt',
              'Test[zi]p/File2.txt',
              'Test`[/File1.txt',
              'Test`[/File2.txt',
              'File1.txt',
              'File2.txt'
            )
            
            Get-ChildItem $TestDirectory -rec -Include 'File[12].txt'|
             Compress-ZipFile -OutputName $global:WorkDir\Archive1.zip -EntryPathRoot $TestDirectory -ErrorAction Stop -Recurse 
            if(-not (Test-Path $global:WorkDir\Archive1.zip)){
                throw "Archive introuvable"
            } 
            $result = ValidateExpectedContent $global:WorkDir\Archive1.zip $ExpectedContent
        }catch{
            Write-host "Error : $($_.Exception.Message)" -ForegroundColor Yellow
            $result=$false
        }
        $result | should be ($true)
    }

    It "Compressing an archive recursively , then validates its content : '$TestDirectory'" {
        try{
            $ExpectedContent=@(
              'Backup1/',   # EntryPathRoot n'est pas précisé on crée l'objet Directory
              'Backup1/File.txt',
              'Backup1/File1.txt',
              'Backup1/File2.txt',
              'Backup1/File[1].txt',
              'Backup1/File[2].txt',
              'Backup1/[a.txt',
              'Backup1/`[a.txt',
              'Backup2/',
              'Backup2/File.txt',
              'Backup2/File1.txt',
              'Backup2/File2.txt',
              'Backup2/File[1].txt',
              'Backup2/File[2].txt',
              'Backup2/[a.txt',
              'Backup2/`[a.txt',
              'Backup[1]/',
              'Backup[1]/File.txt',
              'Backup[1]/File1.txt',
              'Backup[1]/File2.txt',
              'Backup[1]/File[1].txt',
              'Backup[1]/File[2].txt',
              'Backup[1]/[a.txt',
              'Backup[1]/`[a.txt',
              'Backup[2]/',
              'Backup[2]/File.txt',
              'Backup[2]/File1.txt',
              'Backup[2]/File2.txt',
              'Backup[2]/File[1].txt',
              'Backup[2]/File[2].txt',
              'Backup[2]/[a.txt',
              'Backup[2]/`[a.txt',
              'Test[/',
              'Test[/File.txt',
              'Test[/File1.txt',
              'Test[/File2.txt',
              'Test[/File[1].txt',
              'Test[/File[2].txt',
              'Test[/[a.txt',
              'Test[/`[a.txt',
              'Test[zi]p/',
              'Test[zi]p/File.txt',
              'Test[zi]p/File1.txt',
              'Test[zi]p/File2.txt',
              'Test[zi]p/File[1].txt',
              'Test[zi]p/File[2].txt',
              'Test[zi]p/[a.txt',
              'Test[zi]p/`[a.txt',
              'Test`[/',
              'Test`[/File.txt',
              'Test`[/File1.txt',
              'Test`[/File2.txt',
              'Test`[/File[1].txt',
              'Test`[/File[2].txt',
              'Test`[/[a.txt',
              'Test`[/`[a.txt',
              'File.txt',
              'File1.txt',
              'File2.txt',
              'File[1].txt',
              'File[2].txt',
              '[a.txt',
              '`[a.txt'
            )
            
            $TestDirectory|
             Compress-ZipFile -OutputName $global:WorkDir\Archive1.zip -ErrorAction Stop -Recurse 
            if(-not (Test-Path $global:WorkDir\Archive1.zip)){
                throw "Archive introuvable"
            } 
            $result = ValidateExpectedContent $global:WorkDir\Archive1.zip $ExpectedContent
        }catch{
            Write-host "Error : $($_.Exception.Message)" -ForegroundColor Yellow
            $result=$false
        }
        $result | should be ($true)
    }

    It "Compressing an archive, then validates its contents : '$TestDirectory'" {
      try{
          $ExpectedContent=@(
            'File.txt',
            'File1.txt',
            'File2.txt',
            'File[1].txt',
            'File[2].txt',
            '[a.txt',
            '`[a.txt'
          )
          
          $TestDirectory|
           Compress-ZipFile -OutputName $global:WorkDir\Archive1.zip -ErrorAction Stop 
          if(-not (Test-Path $global:WorkDir\Archive1.zip)){
              throw "Archive introuvable"
          } 
          $result = ValidateExpectedContent $global:WorkDir\Archive1.zip $ExpectedContent
      }catch{
          Write-host "Error : $($_.Exception.Message)" -ForegroundColor Yellow
          $result=$false
      }
      $result | should be ($true)
    }

    It "Compressing an archive, then validates its contents : dir '$TestDirectory' -inc 'File`[[12]`].*' -rec" {
      try{
          $ExpectedContent=@(
            'Backup1/File[1].txt',
            'Backup1/File[2].txt',
            'Backup2/File[1].txt',
            'Backup2/File[2].txt',
            'Backup[1]/File[1].txt',
            'Backup[1]/File[2].txt',
            'Backup[2]/File[1].txt',
            'Backup[2]/File[2].txt',
            'Test[/File[1].txt',
            'Test[/File[2].txt',
            'Test[zi]p/File[1].txt',
            'Test[zi]p/File[2].txt',
            'Test`[/File[1].txt',
            'Test`[/File[2].txt',
            'File[1].txt',
            'File[2].txt'
          )
          
          Get-ChildItem $TestDirectory -inc 'File`[[12]`].*' -rec|
           Compress-ZipFile -OutputName $global:WorkDir\Archive1.zip -EntryPathRoot $TestDirectory -ErrorAction Stop -Recurse 
          if(-not (Test-Path $global:WorkDir\Archive1.zip)){
              throw "Archive introuvable"
          } 
          $result = ValidateExpectedContent $global:WorkDir\Archive1.zip $ExpectedContent
      }catch{
          Write-host "Error : $($_.Exception.Message)" -ForegroundColor Yellow
          $result=$false
      }
      $result | should be ($true)
    } 
    
    It "Path is not in EntryPathRoot : System.ArgumentException" {
      try{
        Get-ChildItem C:\temp -inc 'File`[[12]`].*' -rec|
         Compress-ZipFile -OutputName $global:WorkDir\Archive1.zip -EntryPathRoot $TestDirectory -ErrorAction Stop -Recurse
        $result=$true  
      }catch {
          Write-host "Error : $($_.Exception.Message)" -ForegroundColor Yellow
          Write-host "Type : $($_.Exception.Gettype())" -ForegroundColor Yellow
          $result=$false
      }
      $result | should be ($false)
    }  
    
    It "Path do not exist : System.Management.Automation.ParameterBindingValidationException" {
      try{
        Get-ChildItem  $TestDirectory -inc 'File`[[12]`].*' -rec|
         Compress-ZipFile -OutputName $global:WorkDir\Archive1.zip -EntryPathRoot $TestDirectory\Psionic -ErrorAction Stop -Recurse
        $result=$true  
      }catch {
          Write-host "Error : $($_.Exception.Message)" -ForegroundColor Yellow
          Write-host "Type : $($_.Exception.Gettype())" -ForegroundColor Yellow
          $result=$false
      }
      $result | should be ($false)
    }           
}