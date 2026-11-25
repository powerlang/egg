'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:38 pm'!
!classDefinition: #HashTablePolicy category: #Kernel!
Object subclass: #HashTablePolicy
	instanceVariableNames: 'associationClass bucketClass maxSlots weak hasher comparison storesAssociations'
	classVariableNames: 'EmptySlot'
	poolDictionaries: ''
	category: 'Kernel'!
!HashTablePolicy commentStamp: '<historical>' prior: 0!

    Copyright (c) 2020 Aucerna. 
    See (MIT) license in root directory.
!

!HashTablePolicy methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:38'!
associationClass
	^associationClass
! !

!HashTablePolicy methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
associationClass: aClass
	associationClass := aClass
! !

!HashTablePolicy methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
bucketClass: aClass
	bucketClass := aClass
! !

!HashTablePolicy methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:38'!
bucketOfSize: anInteger
	| bucket |
	bucket := (bucketClass new: anInteger) policy: self.
	weak ifTrue: [bucket beWeak].
	^bucket
! !

!HashTablePolicy methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
comparison: evaluableObject
	comparison := evaluableObject
! !

!HashTablePolicy methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:38'!
contentOfSize: anInteger
	| table |
	table := bucketClass new: anInteger.
	table policy: self.
	weak ifTrue: [table beWeak].
	^table
! !

!HashTablePolicy methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
emptySlot
	^weak ifTrue: [EmptySlot]
! !

!HashTablePolicy methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:38'!
equates: key with: anObject
	| item |
	item := storesAssociations ifTrue: [anObject key] ifFalse: [anObject].
	^comparison isNil
		ifTrue: [key = item]
		ifFalse: [comparison evaluateWith: key with: item]
! !

!HashTablePolicy methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
hasher: evaluableObject
	hasher := evaluableObject
! !

!HashTablePolicy methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:38'!
hashFor: anObject
	^hasher notNil
		ifTrue: [hasher evaluateWith: anObject]
		ifFalse: [anObject hash]
! !

!HashTablePolicy methodsFor:  'initialization' stamp: 'KenD 28/Jun/2026 13:27:38'!
initialize
	associationClass := Association.
	weak := storesAssociations := false
! !

!HashTablePolicy methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:38'!
keyFor: anObject
	^storesAssociations ifTrue: [anObject key] ifFalse: [anObject]
! !

!HashTablePolicy methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
maxSlots
	^maxSlots
! !

!HashTablePolicy methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
maxSlots: anInteger
	maxSlots := anInteger
! !

!HashTablePolicy methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
storesAssociations: aBoolean
	storesAssociations := aBoolean
! !

!HashTablePolicy methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
useIdentityHash
	self
		hasher: [:key | key basicHash * 16273];
		comparison: [:a :b | a == b]
! !

!HashTablePolicy methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
useStringHash
	self
		hasher: [:key | key stringHash];
		comparison: [:a :b | a equals: b]
! !

!HashTablePolicy methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
usesWeakSlots
	^weak
! !

!HashTablePolicy methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:38'!
useWeakSlots
	weak := true
! !

!HashTablePolicy methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
weak: aBoolean
	weak := aBoolean
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'HashTablePolicy class' category: #Kernel!
HashTablePolicy class
	instanceVariableNames: 'EmptySlot'!

!HashTablePolicy class methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
emptySlot
	^EmptySlot
! !

!HashTablePolicy class methodsFor:  'initialization' stamp: 'KenD 28/Jun/2026 13:27:38'!
initializeEmptySlot
	EmptySlot := Object new
! !


HashTablePolicy initialize!

