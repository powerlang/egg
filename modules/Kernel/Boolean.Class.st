'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:38 pm'!
!classDefinition: #Boolean category: #Kernel!
Object subclass: #Boolean
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Kernel'!
!Boolean commentStamp: '<historical>' prior: 0!

    Copyright (c) 2020 Aucerna. 
    See (MIT) license in root directory.
!

!Boolean methodsFor:  'converting' stamp: 'KenD 28/Jun/2026 13:27:38'!
asBoolean
	^self
! !

!Boolean methodsFor:  'printing' stamp: 'KenD 28/Jun/2026 13:27:38'!
canBePrintedAsLiteral
	^true
! !

!Boolean methodsFor:  'copying' stamp: 'KenD 28/Jun/2026 13:27:38'!
deepCopy
	^self
! !

!Boolean methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:38'!
isBoolean
	^true
! !

!Boolean methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:38'!
isFixedObject
	^true
! !

!Boolean methodsFor:  'copying' stamp: 'KenD 28/Jun/2026 13:27:38'!
shallowCopy
	^self
! !

!Boolean methodsFor:  'printing' stamp: 'KenD 28/Jun/2026 13:27:38'!
storeOn: aStream
	self printOn: aStream
! !

!Boolean methodsFor:  'flow control' stamp: 'KenD 28/Jun/2026 13:27:38'!
whileFalse: aBlock
	[self] whileFalse: [aBlock value]
! !

!Boolean methodsFor:  'flow control' stamp: 'KenD 28/Jun/2026 13:27:38'!
whileTrue: aBlock
	[self] whileTrue: [aBlock value]
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Boolean class' category: #Kernel!
Boolean class
	instanceVariableNames: ''!

!Boolean class methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:27:38'!
new
	^self shouldNotImplement
! !

!Boolean class methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:27:38'!
new: anInteger
	^self shouldNotImplement
! !


