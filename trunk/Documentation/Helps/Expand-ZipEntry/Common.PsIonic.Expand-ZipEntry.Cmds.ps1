# Expand-ZipEntry command help
@{
	command = 'Expand-ZipEntry'
	synopsis = $Datas.ExpandZipEntrySynopsis
	description = $Datas.ExpandZipEntryDescription
	sets = @{
		ByteArray = $Datas.ExpandZipEntrySetsByteArray
		String = $Datas.ExpandZipEntrySetsString
		XML = $Datas.ExpandZipEntrySetsXML
	}
	parameters = @{
		AsHashTable = $Datas.ExpandZipEntryParametersAsHashTable
		Byte = $Datas.ExpandZipEntryParametersByte
		Encoding = $Datas.ExpandZipEntryParametersEncoding
		ExtractAction = $Datas.ExpandZipEntryParametersExtractAction
		Name = $Datas.ExpandZipEntryParametersName
		Password = $Datas.ExpandZipEntryParametersPassword
		Strict = $Datas.ExpandZipEntryParametersStrict
		XML = $Datas.ExpandZipEntryParametersXML
		ZipFile = $Datas.ExpandZipEntryParametersZipFile
	}
	inputs = @(
		@{
			type = ''
			description = $Datas.ExpandZipEntryInputsDescription1
		}
	)
	outputs = @(
		@{
			type = 'System.Xml.XmlDocument'
			description = $Datas.ExpandZipEntryOutputsDescriptionSystemXmlXmlDocument
		}
		@{
			type = 'System.String'
			description = $Datas.ExpandZipEntryOutputsDescriptionSystemString
		}
		@{
			type = 'System.Byte[]'
			description = $Datas.ExpandZipEntryOutputsDescriptionSystemByte
		}
	)
	notes = $Datas.ExpandZipEntryNotes
	examples = @(
		@{
			#title = ''
			#introduction = ''
			code = {
			}
			remarks = $Datas.ExpandZipEntryExamplesRemarks1
			test = { . $args[0] }
		}
	)
	links = @(
		@{ text = ''; URI = '' }
	)
}

