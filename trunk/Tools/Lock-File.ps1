#Verrouille un fichier à des fins de tests
Function Lock-File{
# $Filename="C:\Temp\archive.zip"
# $TestLockFile= Lock-File $FileName
# # Execute test...
# $TestLockFile.Close()

  param([string] $Path)

  New-Object System.IO.FileStream($Path, 
                                  [System.IO.FileMode]::Open, 
                                  [System.IO.FileAccess]::ReadWrite, 
                                  [System.IO.FileShare]::None)
} #Lock-File


