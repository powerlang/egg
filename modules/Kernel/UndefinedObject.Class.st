'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:38 pm'!
!classDefinition: #UndefinedObject category: #Kernel!
Object subclass: #UndefinedObject
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Kernel'!
!UndefinedObject commentStamp: '<historical>' prior: 0!

    Copyright (c) 2020 Aucerna. 
    See (MIT) license in root directory.
!

!UndefinedObject methodsFor:  'converting' stamp: 'KenD 28/Jun/2026 13:27:38'!
asParameter
	^0
! !

!UndefinedObject methodsFor:  'printing' stamp: 'KenD 28/Jun/2026 13:27:38'!
canBePrintedAsLiteral
	^true
! !

!UndefinedObject methodsFor:  'copying' stamp: 'KenD 28/Jun/2026 13:27:38'!
deepCopy
	^self
! !

!UndefinedObject methodsFor:  'ffi support' stamp: 'KenD 28/Jun/2026 13:27:38'!
externalCopy
	^nil
! !

!UndefinedObject methodsFor:  'ffi support' stamp: 'KenD 28/Jun/2026 13:27:38'!
free
	"
	do nothing
	"
	
! !

!UndefinedObject methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:38'!
ifNil: aBlock
	^aBlock value
! !

!UndefinedObject methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:38'!
ifNil: aBlock ifNotNil: anotherBlock
	^aBlock value
! !

!UndefinedObject methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:38'!
ifNotNil: aBlock
	^self
! !

!UndefinedObject methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:38'!
ifNotNil: aBlock ifNil: nilBlock
	^nilBlock argumentCount = 1
		ifTrue: [nilBlock value: self]
		ifFalse: [nilBlock value]
! !

!UndefinedObject methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:38'!
isEmptyOrNil
	^true
! !

!UndefinedObject methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:38'!
isFixedObject
	^true
! !

!UndefinedObject methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:38'!
isNil
	^true
! !

!UndefinedObject methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:38'!
notNil
	^false
! !

!UndefinedObject methodsFor:  'printing' stamp: 'KenD 28/Jun/2026 13:27:38'!
printOn: aStream
	aStream nextPutAll: 'nil'
! !

!UndefinedObject methodsFor:  'copying' stamp: 'KenD 28/Jun/2026 13:27:38'!
shallowCopy
	^self
! !

!UndefinedObject methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
sizeInBytes
	^0
! !

!UndefinedObject methodsFor:  'printing' stamp: 'KenD 28/Jun/2026 13:27:38'!
storeOn: aStream
	self printOn: aStream
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'UndefinedObject class' category: #Kernel!
UndefinedObject class
	instanceVariableNames: ''!

!UndefinedObject class methodsFor:  'instances' stamp: 'KenD 28/Jun/2026 13:27:38'!
allInstances
	^Array new: 1
! !

!UndefinedObject class methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:38'!
canBeDeleted
	^false
! !

!UndefinedObject class methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:27:38'!
new
	^self shouldNotImplement
! !

!UndefinedObject class methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:27:38'!
new: anInteger
	^self shouldNotImplement
! !


