'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:38 pm'!
!classDefinition: #HashedCollection category: #Kernel!
Collection subclass: #HashedCollection
	instanceVariableNames: 'tally table'
	classVariableNames: 'Policies'
	poolDictionaries: ''
	category: 'Kernel'!
!HashedCollection commentStamp: '<historical>' prior: 0!

    Copyright (c) 2020 Aucerna. 
    See (MIT) license in root directory.
!

!HashedCollection methodsFor:  'adding' stamp: 'KenD 28/Jun/2026 13:27:38'!
add: element
	(table atKey: element put: element) == nil ifTrue: [self incrementTally].
	^element
! !

!HashedCollection methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
at: anInteger
	^self errorNotIndexable
! !

!HashedCollection methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
at: anInteger put: anObject
	^self errorNotIndexable
! !

!HashedCollection methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:38'!
basicAdd: element
	tally := tally + 1.
	table basicAtKey: element put: element.
	^element
! !

!HashedCollection methodsFor:  'enumerating' stamp: 'KenD 28/Jun/2026 13:27:38'!
basicDo: aBlock
	table elementsDo: aBlock count: tally
! !

!HashedCollection methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:38'!
beWeak
	| policy |
	policy := self policy.
	policy == self ifTrue: [policy := self defaultPolicy].
	policy useWeakSlots.
	table beWeak.
	self usePolicy: policy
! !

!HashedCollection methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
bucketClass
	^OpenHashTable
! !

!HashedCollection methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:38'!
bucketOfSize: anInteger
	^(self bucketClass new: anInteger) owner: self
! !

!HashedCollection methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:38'!
contentOfSize: anInteger
	^self policy == self
		ifTrue: [(self bucketClass new: anInteger) owner: self]
		ifFalse: [self policy contentOfSize: anInteger]
! !

!HashedCollection methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:38'!
contents
	^table
! !

!HashedCollection methodsFor:  'copying' stamp: 'KenD 28/Jun/2026 13:27:38'!
copy
	| copy |
	copy := super copy.
	table policy == self ifTrue: [copy useDefaultPolicy] ifFalse: [
		self ASSERT: table policy class == HashTablePolicy.
		copy usePolicy: table policy copy].
	^copy
! !

!HashedCollection methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:38'!
defaultPolicy
	^HashTablePolicy new
		storesAssociations: self storesAssociations;
		bucketClass: self bucketClass
! !

!HashedCollection methodsFor:  'enumerating' stamp: 'KenD 28/Jun/2026 13:27:38'!
do: aBlock
	self basicDo: aBlock
! !

!HashedCollection methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:38'!
emptySlot
	^nil
! !

!HashedCollection methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:38'!
equates: key with: element
	^key = element
! !

!HashedCollection methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:38'!
grow
	self resizeTo: tally * 2
! !

!HashedCollection methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:38'!
hashFor: anObject
	^anObject hash
! !

!HashedCollection methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:38'!
incrementTally
	tally := tally + 1.
	(table isCapacityGreaterThan: tally) ifFalse: [self grow]
! !

!HashedCollection methodsFor:  'initialization' stamp: 'KenD 28/Jun/2026 13:27:38'!
initialize: anInteger
	| t |
	t := self contentOfSize: anInteger.
	self onTable: t
! !

!HashedCollection methodsFor:  'initialization' stamp: 'KenD 28/Jun/2026 13:27:38'!
initializeWeakSize: anInteger
	self initialize: anInteger.
	table beWeak
! !

!HashedCollection methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
keyFor: anObject
	^anObject
! !

!HashedCollection methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:38'!
maxSlots
	^self policy == self ifFalse: [self policy maxSlots]
! !

!HashedCollection methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:38'!
maxSlots: anInteger
	| policy |
	policy := self policy.
	policy == self ifTrue: [policy := self defaultPolicy].
	policy maxSlots: anInteger.
	self usePolicy: policy
! !

!HashedCollection methodsFor:  'inquiries' stamp: 'KenD 28/Jun/2026 13:27:38'!
occurrencesOf: anObject
	^(self includes: anObject) ifTrue: [1] ifFalse: [0]
! !

!HashedCollection methodsFor:  'initialization' stamp: 'KenD 28/Jun/2026 13:27:38'!
onTable: aHashTable
	tally := 0.
	table := aHashTable
! !

!HashedCollection methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
policy
	^table notNil ifTrue: [table policy] ifFalse: [self]
! !

!HashedCollection methodsFor:  'copying' stamp: 'KenD 28/Jun/2026 13:27:38'!
postCopy
	super postCopy.
	table := table copy
! !

!HashedCollection methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:38'!
rehash
	tally isNil ifTrue: [tally := table count].
	self resizeTo: tally
! !

!HashedCollection methodsFor:  'removing' stamp: 'KenD 28/Jun/2026 13:27:38'!
remove: anObject ifAbsent: aBlock
	table removeKey: anObject ifAbsent: [^aBlock value].
	tally := tally - 1.
	^anObject
! !

!HashedCollection methodsFor:  'removing' stamp: 'KenD 28/Jun/2026 13:27:38'!
removeAll
	tally = 0 ifTrue: [^self].
	table removeAll.
	tally := 0
! !

!HashedCollection methodsFor:  'removing' stamp: 'KenD 28/Jun/2026 13:27:38'!
removeAll: aCollection
	^self removeAll: aCollection ifAbsent: [self errorNotFound]
! !

!HashedCollection methodsFor:  'removing' stamp: 'KenD 28/Jun/2026 13:27:38'!
removeAll: aCollection ifAbsent: aBlock
	| n |
	n := aCollection size.
	table removeKeys: aCollection ifAbsent: [
		n := n - 1.
		aBlock value].
	tally := tally - n.
	^aCollection
! !

!HashedCollection methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:38'!
resizeTo: anInteger
	| copy t policy n |
	n := self class sizeFor: anInteger.
	t := self contentOfSize: n.
	copy := self class on: t.
	policy := self policy.
	policy == self ifFalse: [
		self ASSERT: policy class == HashTablePolicy.
		copy usePolicy: policy copy].
	self rebuildOn: copy.
	policy == self ifTrue: [table policy: self] ifFalse: [table policy: policy]
! !

!HashedCollection methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
size
	^tally
! !

!HashedCollection methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:38'!
storesAssociations
	^false
! !

!HashedCollection methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:38'!
table
	^table
! !

!HashedCollection methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:38'!
useDefaultPolicy
	table policy == self ifTrue: [^self].
	table policy: self.
	self notEmpty ifTrue: [self rehash]
! !

!HashedCollection methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:38'!
useIdentityHash
	| policy |
	policy := self defaultPolicy.
	policy useIdentityHash.
	self usePolicy: policy
! !

!HashedCollection methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:38'!
usePolicy: aHashTablePolicy
	table isNil ifTrue: [^self].
	table policy: aHashTablePolicy.
	aHashTablePolicy usesWeakSlots
		ifTrue: [self class registerPolicy: aHashTablePolicy for: self].
	self notEmpty ifTrue: [self rehash]
! !

!HashedCollection methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:38'!
usesWeakSlots
	| p |
	p := self policy.
	^p !!== self and: [p usesWeakSlots]
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'HashedCollection class' category: #Kernel!
HashedCollection class
	instanceVariableNames: 'Policies'!

!HashedCollection class methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:38'!
initializePolicies
	Policies := WeakIdentityDictionary new
! !

!HashedCollection class methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:27:38'!
new
	^self new: 5
! !

!HashedCollection class methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:27:38'!
new: anInteger
	| size |
	size := self sizeFor: anInteger.
	^self basicNew initialize: size
! !

!HashedCollection class methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:27:38'!
new: anInteger using: aHashedCollectionPolicy
	| size |
	size := self sizeFor: anInteger.
	^self basicNew
		onTable: (aHashedCollectionPolicy contentOfSize: size);
		usePolicy: aHashedCollectionPolicy
! !

!HashedCollection class methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:27:38'!
on: aHashTable
	^self new onTable: aHashTable
! !

!HashedCollection class methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:38'!
registerPolicy: aHashTablePolicy for: aHashedCollection
	Policies at: aHashedCollection put: aHashTablePolicy
! !

!HashedCollection class methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:38'!
sizeFor: anInteger
	^7 max: anInteger * 3 // 2
! !

!HashedCollection class methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:27:38'!
withAll: aCollection
	| instance |
	instance := self new: aCollection size.
	^instance addAll: aCollection; yourself
! !


