"
	Copyright (c) 2024 Quorum Software.
	See (MIT) license in root directory.
"

Extension {#name : #'Collection class'}

{#category : '*STON'}
Collection class >> fromSton: stonReader [
	| collection |
	collection := self new.
	stonReader parseListDo: [:element | 
		collection add: element.
		element isStonReference
			ifTrue: [stonReader addElement: element of: collection]].
	^collection
]

{#category : '*STON'}
Collection >> stonOn: aSTONWriter [
	aSTONWriter writeObject: self do: [aSTONWriter encodeList: self]
]

