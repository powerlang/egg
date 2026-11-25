'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:39 pm'!


!SequenceableCollection methodsFor:  '*STON' stamp: 'KenD 28/Jun/2026 13:27:39'!
stonOn: aSTONWriter
	self class == STON listClass
		ifTrue: [aSTONWriter writeList: self]
		ifFalse: [super stonOn: aSTONWriter]
! !

!SequenceableCollection class methodsFor:  '*STON' stamp: 'KenD 28/Jun/2026 13:27:39'!
fromSton: stonReader
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
! !


