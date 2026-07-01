'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:38 pm'!
!classDefinition: #False category: #Kernel!
Boolean subclass: #False
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Kernel'!
!False commentStamp: '<historical>' prior: 0!

    Copyright (c) 2020 Aucerna. 
    See (MIT) license in root directory.
!

!False methodsFor:  'operations' stamp: 'KenD 28/Jun/2026 13:27:38'!
& aBoolean
	^self
! !

!False methodsFor:  'operations' stamp: 'KenD 28/Jun/2026 13:27:38'!
| aBoolean
	^aBoolean
! !

!False methodsFor:  'operations' stamp: 'KenD 28/Jun/2026 13:27:38'!
and: aBlock
	^false
! !

!False methodsFor:  'operations' stamp: 'KenD 28/Jun/2026 13:27:38'!
and: block1 and: block2
	^self
! !

!False methodsFor:  'operations' stamp: 'KenD 28/Jun/2026 13:27:38'!
and: block1 and: block2 and: block3
	^self
! !

!False methodsFor:  'operations' stamp: 'KenD 28/Jun/2026 13:27:38'!
and: block1 andNot: block2
	^self
! !

!False methodsFor:  'operations' stamp: 'KenD 28/Jun/2026 13:27:38'!
andNot: aBlock
	^self
! !

!False methodsFor:  'converting' stamp: 'KenD 28/Jun/2026 13:27:38'!
asParameter
	^0
! !

!False methodsFor:  'comparing' stamp: 'KenD 28/Jun/2026 13:27:38'!
basicHash
	^0
! !

!False methodsFor:  'comparing' stamp: 'KenD 28/Jun/2026 13:27:38'!
hash
	^0
! !

!False methodsFor:  'flow control' stamp: 'KenD 28/Jun/2026 13:27:38'!
ifFalse: aBlock
	^aBlock value
! !

!False methodsFor:  'flow control' stamp: 'KenD 28/Jun/2026 13:27:38'!
ifFalse: aBlock ifTrue: anotherBlock
	^aBlock value
! !

!False methodsFor:  'flow control' stamp: 'KenD 28/Jun/2026 13:27:38'!
ifTrue: aBlock
	^nil
! !

!False methodsFor:  'flow control' stamp: 'KenD 28/Jun/2026 13:27:38'!
ifTrue: aBlock ifFalse: anotherBlock
	^anotherBlock value
! !

!False methodsFor:  'operations' stamp: 'KenD 28/Jun/2026 13:27:38'!
not
	^true
! !

!False methodsFor:  'operations' stamp: 'KenD 28/Jun/2026 13:27:38'!
or: aBlock
	^aBlock value
! !

!False methodsFor:  'operations' stamp: 'KenD 28/Jun/2026 13:27:38'!
or: aBlock or: anotherBlock
	^aBlock value or: [anotherBlock value]
! !

!False methodsFor:  'operations' stamp: 'KenD 28/Jun/2026 13:27:38'!
orNot: aBlock
	^aBlock value not
! !

!False methodsFor:  'converting' stamp: 'KenD 28/Jun/2026 13:27:38'!
printOn: aStream
	aStream nextPutAll: 'false'
! !

!False methodsFor:  'operations' stamp: 'KenD 28/Jun/2026 13:27:38'!
xor: aBlock
	^aBlock value
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'False class' category: #Kernel!
False class
	instanceVariableNames: ''!

!False class methodsFor:  'instances' stamp: 'KenD 28/Jun/2026 13:27:38'!
allInstances
	^{false}
! !

!False class methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:38'!
canBeDeleted
	^false
! !


