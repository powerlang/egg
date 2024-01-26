"
	Copyright (c) 2024 Quorum Software.
	See (MIT) license in root directory.
"

Extension {#name : #Symbol}

{#category : '*STON'}
Symbol >> stonOn: aSTONWriter [
	aSTONWriter writeSymbol: self
]

