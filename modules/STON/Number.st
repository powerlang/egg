"
	Copyright (c) 2024 Quorum Software.
	See (MIT) license in root directory.
"

Extension {#name : #Number}

{#category : '*STON'}
Number >> stonOn: aSTONWriter [
	aSTONWriter writeFloat: self asFloat]

