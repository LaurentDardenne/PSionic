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
			#title = ''
			#introduction = ''
			code = {
			}
			remarks = $Datas.NewZipSfxOptionsExamplesRemarks1
			test = { . $args[0] }
		}
	)
	links = @(
		@{ text = ''; URI = '' }
	)
}

