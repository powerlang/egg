"
	Copyright (c) 2023 Quorum Software.
	See (MIT) license in root directory.
"

Extension {#name : #Boolean}

{#category : '*STON'}
Boolean >> stonOn: aSTONWriter [
	aSTONWriter writeBoolean: self]

