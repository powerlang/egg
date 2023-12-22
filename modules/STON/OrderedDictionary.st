"
	Copyright (c) 2023 Quorum Software.
	See (MIT) license in root directory.
"

Extension {#name : #OrderedDictionary}

{#category : '*STON'}
OrderedDictionary >> stonOn: aSTONWriter [
	aSTONWriter writeObject: self do: [aSTONWriter encodeMap: self]]

