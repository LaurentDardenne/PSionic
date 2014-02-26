# New-ZipSfxOptions command help
@{
	command = 'New-ZipSfxOptions'
	synopsis = $Datas.NewZipSfxOptionsSynopsis
	description = $Datas.NewZipSfxOptionsDescription
	sets = @{
		CmdLine = $Datas.NewZipSfxOptionsSetsCmdLine
		GUI = $Datas.NewZipSfxOptionsSetsGUI
	}
	parameters = @{
		AdditionalCompilerSwitches = $Datas.NewZipSfxOptionsParametersAdditionalCompilerSwitches
		CmdLine = $Datas.NewZipSfxOptionsParametersCmdLine
		Copyright = $Datas.NewZipSfxOptionsParametersCopyright
		Description = $Datas.NewZipSfxOptionsParametersDescription
		ExeOnUnpack = $Datas.NewZipSfxOptionsParametersExeOnUnpack
		ExtractDirectory = $Datas.NewZipSfxOptionsParametersExtractDirectory
		FileVersion = $Datas.NewZipSfxOptionsParametersFileVersion
		GUI = $Datas.NewZipSfxOptionsParametersGUI
		IconFile = $Datas.NewZipSfxOptionsParametersIconFile
		NameOfProduct = $Datas.NewZipSfxOptionsParametersNameOfProduct
		Quiet = $Datas.NewZipSfxOptionsParametersQuiet
		Remove = $Datas.NewZipSfxOptionsParametersRemove
		VersionOfProduct = $Datas.NewZipSfxOptionsParametersVersionOfProduct
		WindowTitle = $Datas.NewZipSfxOptionsParametersWindowTitle
	}
	inputs = @(
		@{
			type = ''
			description = $Datas.NewZipSfxOptionsInputsDescription1
		}
	)
	outputs = @(
		@{
			type = 'Ionic.Zip.SelfExtractorSaveOptions'
			description = $Datas.NewZipSfxOptionsOutputsDescriptionIonicZipSelfExtractorSaveOptions
		}
	)
	notes = $Datas.NewZipSfxOptionsNotes
	examples = @(
		@{
			code = {
$MyConfiguration=New-ZipSfxOptions -Copyright "This module is free for non-commercial purposes." 
			}
			remarks = $Datas.NewZipSfxOptionsExamplesRemarks1
			test = { . $args[0] }
		}
		@{
			code = {
New-ZipSfxOptions -Copyright "This module is free for non-commercial purposes."|Set-PsIonicSfxOptions

			}
			remarks = $Datas.NewZipSfxOptionsExamplesRemarks2
			test = { . $args[0] }
		}
	)
	links = @(
		@{ text = 'AdditionalCompilerSwitches'; URI = 'http://msdn.microsoft.com/en-us/library/system.codedom.compiler.compilerparameters(v=vs.80).aspx' }
	)
}

