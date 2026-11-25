'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:39 pm'!


!Dictionary methodsFor:  '*STON' stamp: 'KenD 28/Jun/2026 13:27:39'!
stonOn: aSTONWriter
	self class == STON mapClass
		ifTrue: [aSTONWriter writeMap: self]
		ifFalse: [aSTONWriter writeObject: self do: [aSTONWriter encodeMap: self]]
! !

!Dictionary class methodsFor:  '*STON' stamp: 'KenD 28/Jun/2026 13:27:39'!
fromSton: stonReader
	| dictionary |
	dictionary := self new.
	stonReader parseMapDo: [:key :value | 
		dictionary at: key put: value.
		(key isStonReference or: [value isStonReference])
			ifTrue: [stonReader addReferenceKey: key value: value of: dictionary]].
	^dictionary
! !


