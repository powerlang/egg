"
	Copyright (c) 2023 Quorum Software.
	See (MIT) license in root directory.
"

Extension {#name : #String}

{#category : '*STON'}
String >> stonOn: aSTONWriter [
	aSTONWriter writeString: self]

