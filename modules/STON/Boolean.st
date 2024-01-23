"
	Copyright (c) 2024 Quorum Software.
	See (MIT) license in root directory.
"

Extension {#name : #Boolean}

{#category : '*STON'}
Boolean >> stonOn: aSTONWriter [
	aSTONWriter writeBoolean: self]

