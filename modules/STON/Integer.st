"
	Copyright (c) 2023 Quorum Software.
	See (MIT) license in root directory.
"

Extension {#name : #Integer}

{#category : '*STON'}
Integer >> stonOn: aSTONWriter [
	aSTONWriter writeInteger: self]

