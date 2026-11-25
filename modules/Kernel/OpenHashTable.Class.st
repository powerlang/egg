'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:38 pm'!
!classDefinition: #OpenHashTable category: #Kernel!
HashTable subclass: #OpenHashTable
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Kernel'!
!OpenHashTable commentStamp: '<historical>' prior: 0!

    Copyright (c) 2020 Aucerna. 
    See (MIT) license in root directory.
!

!OpenHashTable methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
at: index key: key put: element
	| object |
	object := self at: index.
	object == self emptySlot ifTrue: [object := nil].
	object == nil ifTrue: [self at: index put: element].
	^object
! !

!OpenHashTable methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
atKey: key hash: hash sum: magnitude
	| index object assoc sum |
	index := self indexOfKey: key hash: hash.
	object := self at: index.
	(object == nil or: [object == self emptySlot]) ifTrue: [
		assoc := self associationClass key: key value: magnitude.
		self at: index put: assoc.
		^nil].
	sum := object value + magnitude.
	object value: sum.
	^object
! !

!OpenHashTable methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:38'!
basicAtKey: key put: element
	| index |
	index := self indexOfKey: key.
	self at: index put: element
! !

!OpenHashTable methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:38'!
copyAssociations
	self
		withIndexDo: [:a :index | a isAssociation
			ifTrue: [self at: index put: a key -> a value]]
! !

!OpenHashTable methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:38'!
copyFromBucket: bucket
	| count |
	count := 0.
	bucket elementsDo: [:element | | key |
		count := count + 1.
		key := self keyFor: element.
		self basicAtKey: key put: element].
	^count
! !

!OpenHashTable methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
count
	^self count: [:n | n notNil]
! !

!OpenHashTable methodsFor:  'enumerating' stamp: 'KenD 28/Jun/2026 13:27:38'!
elementsDo: aBlock count: n
	| i empty |
	n = 0 ifTrue: [^self].
	i := 0.
	empty := self emptySlot.
	1 to: self size do: [:index | | value |
		value := self at: index.
		value == nil | (value == empty) ifFalse: [
			value := value == NilToken ifFalse: [value].
			aBlock evaluateWith: value.
			i := i + 1.
			i = n ifTrue: [^self]]]
! !

!OpenHashTable methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:38'!
indexOfHash: integer
	^integer \\ self size + 1
! !

!OpenHashTable methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:38'!
isCapacityGreaterThan: count
	^self size * 75 > (count * 100)
! !

!OpenHashTable methodsFor:  'enumerating' stamp: 'KenD 28/Jun/2026 13:27:38'!
keysAndValuesDo: aBlock
	self
		elementsDo: [:assoc | aBlock evaluateWith: assoc key with: assoc value]
! !

!OpenHashTable methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:38'!
lookupValue: key
	^self lookupValue: key ifAbsent: [self keyNotFound: key]
! !

!OpenHashTable methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:38'!
lookupValue: key ifAbsent: aBlock
	| assoc |
	assoc := super lookupValue: key ifAbsent: [^aBlock value].
	^assoc value
! !

!OpenHashTable methodsFor:  'removing' stamp: 'KenD 28/Jun/2026 13:27:38'!
moveSlot: anInteger to: targetInteger
	| a |
	a := self basicAt: anInteger.
	self
		basicAt: anInteger put: self emptySlot;
		basicAt: targetInteger put: a
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'OpenHashTable class' category: #Kernel!
OpenHashTable class
	instanceVariableNames: ''!


