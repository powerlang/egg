"
	Copyright (c) 2024 Quorum Software.
	See (MIT) license in root directory.
"

Extension {#name : #Point}

{#category : '*STON'}
Point >> fromSton: aSTONReader [
	aSTONReader parseListDo: [:v :i | 
		i = 1 ifTrue: [x := v].
		i = 2 ifTrue: [y := v]]
]

{#category : '*STON'}
Point >> stonOn: stonWriter [
	stonWriter
		writeObject: self
		streamShortList: [:writer | writer add: x; add: y]
]

