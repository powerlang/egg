"
	Copyright (c) 2024 Quorum Software.
	See (MIT) license in root directory.
"

Extension {#name : #'Class class'}

{#category : '*STON'}
Class class >> fromSton: stonReader [
	^Smalltalk at: stonReader parseListSingleton
]

{#category : '*STON'}
Class >> stonOn: aSTONWriter [
	aSTONWriter writeObject: self listSingleton: self symbol
]

