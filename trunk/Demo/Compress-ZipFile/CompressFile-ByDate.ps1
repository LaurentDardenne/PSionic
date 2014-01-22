# $FactoryFilterDate= New-FactoryFilterDate -PropertyName "LastWriteTime"
# $PatternDate="{0:$((Get-Culture).DateTimeFormat.ShortDatePattern)}"
# $YesterdayFiles=$FactoryFilterDate.ThisDate($PatternDate -F [system.DateTime]::Today.AddDays(-1))
# dir -rec | ? $code


$FileInfoLib= New-FilterLib (New-FactoryFilterDate)
$FileInfoLib
Dir |Where $FileInfoLib.Yesterday