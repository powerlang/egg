'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:39 pm'!


!SequenceableCollection methodsFor:  '*Extensions' stamp: 'KenD 28/Jun/2026 13:27:39'!
asParser
	^PPSequenceParser withAll: (self collect: [:e | e asParser])
! !

!SequenceableCollection methodsFor:  '*Extensions' stamp: 'KenD 28/Jun/2026 13:27:39'!
asPetitStream
	^ PPStream on: self
! !

!SequenceableCollection methodsFor:  '*Extensions' stamp: 'KenD 28/Jun/2026 13:27:39'!
keysAndValuesDo: aBlock
	1 to: self size do: [:i | aBlock value: i value: (self atValid: i)]
! !


