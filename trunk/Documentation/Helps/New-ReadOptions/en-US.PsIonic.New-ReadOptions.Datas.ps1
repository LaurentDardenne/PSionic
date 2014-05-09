# New-ReadOptions command data
$Datas = @{
	NewReadOptionsSynopsis = 'Creates an object containing differents options that can be used when reading a Zip archive.'
	NewReadOptionsDescription = 'It is possible to specify different behavior when reading a Zip archive.'
	NewReadOptionsSets__AllParameterSets = ''
	NewReadOptionsParametersEncoding = @"
Archive encoding type. Possible values are :
-ASCII	          : ASCII characters encoding scheme (7 bits).
-BigEndianUnicode : encoding for the UTF-16 format using the big endian byte order.
-Default	      : encoding for the operating system's current ANSI code page.
-Unicode	      : encoding for the UTF-16 format using the little endian byte order.
-UTF32	          : encoding for the UTF-32 format using the little endian byte order.
-UTF7	          : encoding for the UTF-7.
-UTF8	          : encoding for the UTF-8.
.
For better portability, the default value ('DefaultEncoding') is recommended.
"@
	NewReadOptionsParametersProgressBarInformations = @"
The use of this parameter creates an event manager for reading operations.
When opening large zip archive, you can choose to display a progress bar.
The object value of the parameter is builded by the use of the 'New-ProgressBarInformations' function.
"@
	NewReadOptionsInputsDescription1 = ''
	NewReadOptionsOutputsDescriptionIonicZipReadOptions = ''
	NewReadOptionsNotes = @"
Regarding the use of encoding, see the Ionic dll help documentation.

If the '-Verbose' parameter is specified, then object of options is configured with an instance of the class 'PSIonicTools' : 'PSVerboseTextWriter'.
The Ionic DLL use it in order to display additional messages during operations on a Zip archives.
Presence of the '-Verbose' parameter therefore imposes implicit release of this instance through a call to the 'Close()' method on the target archive by this object of options.
"@
	NewReadOptionsExamplesRemarks1 = 'This example creates a read option object with the default values.'
	NewReadOptionsExamplesRemarks2 = "This example creates a read option object with a default encoding value and a 'PSVerboseTextWriter' for the additional views."
	NewReadOptionsExamplesRemarks3 = "This example creates a read option object with a default encoding value and a progress bar"
	NewReadOptionsExamplesRemarks4 = @"
This example creates a read option object with a default encoding value and a progress bar.
Then we modify directly his 'StatusMessageWriter' property in order to display the progression in console and not in the verbose flow. 
"@
}


