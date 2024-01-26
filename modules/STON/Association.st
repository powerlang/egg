"
	Copyright (c) 2024 Quorum Software.
	See (MIT) license in root directory.
"

Extension {#name : #Association}

{#category : '*STON'}
Association >> stonOn: aSTONWriter [
	aSTONWriter writeAssociation: self
]

