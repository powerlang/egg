"
	Copyright (c) 2024 Quorum Software.
	See (MIT) license in root directory.
"

Extension {#name : #'Metaclass class'}

{#category : '*STON'}
Metaclass class >> fromSton: stonReader [
	| class |
	class := Smalltalk at: stonReader parseListSingleton.
	^class class
]

{#category : '*STON'}
Metaclass >> stonName [
	^#Class
]

{#category : '*STON'}
Metaclass >> stonOn: aSTONWriter [
	aSTONWriter writeObject: self listSingleton: self instanceClass symbol
]

