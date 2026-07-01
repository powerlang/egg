'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:38 pm'!
!classDefinition: #True category: #Kernel!
Boolean subclass: #True
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Kernel'!
!True commentStamp: '<historical>' prior: 0!

    Copyright (c) 2020 Aucerna. 
    See (MIT) license in root directory.
!

!True methodsFor:  'operations' stamp: 'KenD 28/Jun/2026 13:27:38'!
& aBoolean
	^aBoolean
! !

!True methodsFor:  'operations' stamp: 'KenD 28/Jun/2026 13:27:38'!
| aBoolean
	^self
! !

!True methodsFor:  'operations' stamp: 'KenD 28/Jun/2026 13:27:38'!
and: aBlock
	^aBlock value
! !

!True methodsFor:  'operations' stamp: 'KenD 28/Jun/2026 13:27:38'!
and: block1 and: block2
	^block1 value and: [block2 value]
! !

!True methodsFor:  'operations' stamp: 'KenD 28/Jun/2026 13:27:38'!
and: block1 and: block2 and: block3
	^block1 value and: [block2 value] and: [block3 value]
! !

!True methodsFor:  'operations' stamp: 'KenD 28/Jun/2026 13:27:38'!
and: block1 andNot: block2
	^block1 value andNot: [block2 value]
! !

!True methodsFor:  'operations' stamp: 'KenD 28/Jun/2026 13:27:38'!
andNot: aBlock
	^aBlock value not
! !

!True methodsFor:  'converting' stamp: 'KenD 28/Jun/2026 13:27:38'!
asParameter
	^1
! !

!True methodsFor:  'flow control' stamp: 'KenD 28/Jun/2026 13:27:38'!
ifFalse: aBlock
	^nil
! !

!True methodsFor:  'flow control' stamp: 'KenD 28/Jun/2026 13:27:38'!
ifFalse: aBlock ifTrue: anotherBlock
	^anotherBlock value
! !

!True methodsFor:  'flow control' stamp: 'KenD 28/Jun/2026 13:27:38'!
ifTrue: aBlock
	^aBlock value
! !

!True methodsFor:  'flow control' stamp: 'KenD 28/Jun/2026 13:27:38'!
ifTrue: aBlock ifFalse: anotherBlock
	^aBlock value
! !

!True methodsFor:  'operations' stamp: 'KenD 28/Jun/2026 13:27:38'!
not
	^false
! !

!True methodsFor:  'operations' stamp: 'KenD 28/Jun/2026 13:27:38'!
or: aBlock
	^self
! !

!True methodsFor:  'operations' stamp: 'KenD 28/Jun/2026 13:27:38'!
or: aBlock or: aBlock2
	^self
! !

!True methodsFor:  'operations' stamp: 'KenD 28/Jun/2026 13:27:38'!
orNot: aBlock
	^self
! !

!True methodsFor:  'printing' stamp: 'KenD 28/Jun/2026 13:27:38'!
printOn: aStream
	aStream nextPutAll: 'true'
! !

!True methodsFor:  'operations' stamp: 'KenD 28/Jun/2026 13:27:38'!
xor: aBlock
	^aBlock value not
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'True class' category: #Kernel!
True class
	instanceVariableNames: ''!

!True class methodsFor:  'instances' stamp: 'KenD 28/Jun/2026 13:27:38'!
allInstances
	^{true}
! !

!True class methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:38'!
canBeDeleted
	^false
! !


