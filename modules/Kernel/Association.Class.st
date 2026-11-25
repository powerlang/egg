'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:38 pm'!
!classDefinition: #Association category: #Kernel!
Object subclass: #Association
	instanceVariableNames: 'key value'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Kernel'!
!Association commentStamp: '<historical>' prior: 0!

    Copyright (c) 2020 Aucerna. 
    See (MIT) license in root directory.
!

!Association methodsFor:  'comparing' stamp: 'KenD 28/Jun/2026 13:27:38'!
= anAssociation
	^anAssociation isAssociation
		and: [key = anAssociation key]
		and: [value = anAssociation value]
! !

!Association methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
canBePrintedAsLiteral
	^key canBePrintedAsLiteral and: [value canBePrintedAsLiteral]
! !

!Association methodsFor:  'comparing' stamp: 'KenD 28/Jun/2026 13:27:38'!
hash
	^key hash
! !

!Association methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:38'!
isAssociation
	^true
! !

!Association methodsFor:  'comparing' stamp: 'KenD 28/Jun/2026 13:27:38'!
key
	^key
! !

!Association methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
key: anObject
	key := anObject
! !

!Association methodsFor:  'printing' stamp: 'KenD 28/Jun/2026 13:27:38'!
printOn: aStream
	key printOn: aStream.
	aStream nextPutAll: ' -> '.
	value printOn: aStream
! !

!Association methodsFor:  'printing' stamp: 'KenD 28/Jun/2026 13:27:38'!
storeOn: aStream
	aStream nextPut: $(.
	key storeOn: aStream.
	aStream nextPutAll: ' -> '.
	value storeOn: aStream.
	aStream nextPut: $)
! !

!Association methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
value
	^value
! !

!Association methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
value: anObject
	value := anObject
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Association class' category: #Kernel!
Association class
	instanceVariableNames: ''!

!Association class methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:27:38'!
key: anObject
	^self new key: anObject
! !

!Association class methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:27:38'!
key: key value: value
	| assoc |
	assoc := self key: key.
	^assoc value: value
! !


