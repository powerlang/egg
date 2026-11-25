'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:38 pm'!
!classDefinition: #InlinedHashTable category: #Kernel!
HashTable subclass: #InlinedHashTable
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Kernel'!
!InlinedHashTable commentStamp: '<historical>' prior: 0!

    Copyright (c) 2020 Aucerna. 
    See (MIT) license in root directory.
!

!InlinedHashTable methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
at: index key: key put: element
	(self at: index) ifNil: [
		self
			at: index put: key;
			at: index + 1 put: element.
		^nil].
	self at: index + 1 put: element.
	^key
! !

!InlinedHashTable methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
atKey: key hash: hash sum: magnitude
	| index v k |
	index := self indexOfKey: key hash: hash.
	k := self at: index.
	(k == nil or: [k == self emptySlot]) ifFalse: [
		v := (self at: index + 1) + magnitude.
		self at: index + 1 put: v.
		^v].
	self
		at: index put: key;
		at: index + 1 put: magnitude.
	^nil
! !

!InlinedHashTable methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:38'!
basicAtKey: key put: element
	| index |
	index := self indexOfKey: key.
	self
		at: index put: key;
		at: index + 1 put: element
! !

!InlinedHashTable methodsFor:  'removing' stamp: 'KenD 28/Jun/2026 13:27:38'!
clearSlot: anInteger with: emptySlot
	self
		basicAt: anInteger put: emptySlot;
		basicAt: anInteger + 1 put: emptySlot
! !

!InlinedHashTable methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:38'!
copyFromBucket: bucket
	| count |
	count := 0.
	bucket keysAndValuesDo: [:key :value | 
		count := count + 1.
		self basicAtKey: key put: value].
	^count
! !

!InlinedHashTable methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
count
	| n empty |
	n := 0.
	empty := self emptySlot.
	1 to: self size by: 2 do: [:i | | k |
		k := self at: i.
		(k == nil or: [k == empty]) ifFalse: [n := n + 1]].
	^n
! !

!InlinedHashTable methodsFor:  'enumerating' stamp: 'KenD 28/Jun/2026 13:27:38'!
elementsDo: aBlock count: n
	| count |
	count := 0.
	self keysAndValuesDo: [:k :v | | assoc |
		assoc := Association key: k value: v.
		aBlock evaluateWith: assoc.
		count := count + 1.
		count = n ifTrue: [^self]]
! !

!InlinedHashTable methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:38'!
indexOfHash: integer
	^integer \\ (self size // 2) * 2 + 1
! !

!InlinedHashTable methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:38'!
isCapacityGreaterThan: count
	^self size * 3 > (count * 8)
! !

!InlinedHashTable methodsFor:  'enumerating' stamp: 'KenD 28/Jun/2026 13:27:38'!
keysAndValuesDo: aBlock
	1 to: self size by: 2 do: [:index | | key value |
		key := self at: index.
		key notNil ifTrue: [
			key := key == NilToken ifFalse: [key].
			value := self at: index + 1.
			value := value == NilToken ifFalse: [value].
			aBlock value: key value: value]]
! !

!InlinedHashTable methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:38'!
lookupValue: key
	^self lookupValue: key ifAbsent: [self keyNotFound: key]
! !

!InlinedHashTable methodsFor:  'removing' stamp: 'KenD 28/Jun/2026 13:27:38'!
moveSlot: anInteger to: targetInteger
	| k v empty |
	empty := self emptySlot.
	k := self basicAt: anInteger.
	v := self basicAt: anInteger + 1.
	self
		basicAt: anInteger put: empty;
		basicAt: anInteger + 1 put: empty;
		basicAt: targetInteger put: k;
		basicAt: targetInteger + 1 put: v
! !

!InlinedHashTable methodsFor:  'removing' stamp: 'KenD 28/Jun/2026 13:27:38'!
slotsPerElement
	^2
! !

!InlinedHashTable methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:38'!
valueAt: index ifAbsent: aBlock
	| k value |
	k := self at: index.
	(k == nil or: [k == self emptySlot]) ifTrue: [^aBlock value].
	value := self at: index + 1.
	^value == NilToken ifFalse: [value]
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'InlinedHashTable class' category: #Kernel!
InlinedHashTable class
	instanceVariableNames: ''!

!InlinedHashTable class methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:27:38'!
new: anInteger
	| n |
	n := self primeFor: anInteger.
	^self basicNew: n * 2
! !


