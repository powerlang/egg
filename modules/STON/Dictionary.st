"
	Copyright (c) 2024 Quorum Software.
	See (MIT) license in root directory.
"

Extension {#name : #'Dictionary class'}

{#category : '*STON'}
Dictionary class >> fromSton: stonReader [
	| dictionary |
	dictionary := self new.
	stonReader parseMapDo: [:key :value | 
		dictionary at: key put: value.
		(key isStonReference or: [value isStonReference])
			ifTrue: [stonReader addReferenceKey: key value: value of: dictionary]].
	^dictionary
]

{#category : '*STON'}
Dictionary >> stonOn: aSTONWriter [
	self class == STON mapClass
		ifTrue: [aSTONWriter writeMap: self]
		ifFalse: [aSTONWriter writeObject: self do: [aSTONWriter encodeMap: self]]
]

