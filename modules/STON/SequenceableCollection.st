"
	Copyright (c) 2024 Quorum Software.
	See (MIT) license in root directory.
"

Extension {#name : #'SequenceableCollection class'}

{#category : '*STON'}
SequenceableCollection class >> fromSton: stonReader [
	| references i collection |
	references := OrderedCollection new.
	i := 1.
	collection := self streamContents: [:stream | 
		stonReader parseListDo: [:element | 
			stream nextPut: element.
			element isStonReference ifTrue: [references add: {element. i}].
			i := i + 1]].
	references
		do: [:ref | stonReader addElement: ref first of: collection at: ref second].
	^collection
]

{#category : '*STON'}
SequenceableCollection >> stonOn: aSTONWriter [
	self class == STON listClass
		ifTrue: [aSTONWriter writeList: self]
		ifFalse: [super stonOn: aSTONWriter]
]

