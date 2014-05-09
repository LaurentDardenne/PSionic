# New-ProgressBarInformations command help
@{
	command = 'New-ProgressBarInformations'
	synopsis = $Datas.NewProgressBarInformationsSynopsis
	description = $Datas.NewProgressBarInformationsDescription
	parameters = @{
		activity = $Datas.NewProgressBarInformationsParametersactivity
		activityId = $Datas.NewProgressBarInformationsParametersactivityId
	}
	inputs = @(
		@{
			type = 'Aucun'
			description = $Datas.NewProgressBarInformationsInputsDescription1
		}
	)
	outputs = @(
		@{
			type = 'PSCustomObject'
			description = $Datas.NewProgressBarInformationsOutputsDescription1
		}
	)
	notes = $Datas.NewProgressBarInformationsNotes
	examples = @(
		
        @{
			code = {
$pbi=New-ProgressBarInformations 1 "Read in progress "
$ReadOptions=New-ReadOptions $Encoding $pbi  
$FileName='C:\Temp\Backup.zip'
try {
  $ZipFile = [Ionic.Zip.ZipFile]::Read($FileName,$ReadOptions)
} finally {
 $ZipFile.Dispose()
}
			}
			remarks = $Datas.NewProgressBarInformationsExamplesRemarks1
			test = { . $args[0] }
		}
		
        @{
			code = {
$Files=Dir 'C:\temp\*.zip'
$Count=$Files.Count
$I=0
$Files| 
 Foreach -begin {  $id=1 } -process { 
   [int]$PCpercent =(($I / $Count ) * 100)
   $I++
   
   Write-Progress -id $id -Activity "Archive : " -Status "$_" -PercentComplete $PCpercent
   Expand-ZipFile -Path $_ -OutputPath 'C:\Temp\TestZip' -Create -ExtractAction OverwriteSilently -ProgressID 2
 }#foreach
			}
			remarks = $Datas.NewProgressBarInformationsExamplesRemarks2
			test = { . $args[0] }
		}
	)
	links = @(
 @{ text = ''; URI = 'https://psionic.codeplex.com/wikipage?title=New-ProgressBarInformations-FR'}
	)
}

