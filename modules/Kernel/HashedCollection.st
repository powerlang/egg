"
    Copyright (c) 2020 Aucerna. 
    See (MIT) license in root directory.
"

Class {
	#name : #HashedCollection,
	#superclass : #Collection,
	#instVars : [
		'tally',
		'table'
	],
	#classVars : [
		'Policies'
	],
	#category : #Kernel
}

{ #category : #private }
HashedCollection class >> initializePolicies [
	Policies := WeakIdentityDictionary new
]

{ #category : #'instance creation' }
HashedCollection class >> new [
	^self new: 5
]

{ #category : #'instance creation' }
HashedCollection class >> new: anInteger [
	| size |
	size := self sizeFor: anInteger.
	^self basicNew initialize: size
]

{ #category : #'instance creation' }
HashedCollection class >> new: anInteger using: aHashedCollectionPolicy [
	| size |
	size := self sizeFor: anInteger.
	^self basicNew
		onTable: (aHashedCollectionPolicy contentOfSize: size);
		usePolicy: aHashedCollectionPolicy
]

{ #category : #'instance creation' }
HashedCollection class >> on: aHashTable [
	^self new onTable: aHashTable
]

{ #category : #private }
HashedCollection class >> registerPolicy: aHashTablePolicy for: aHashedCollection [
	Policies at: aHashedCollection put: aHashTablePolicy
]

{ #category : #private }
HashedCollection class >> sizeFor: anInteger [
	^7 max: anInteger * 3 // 2
]

{ #category : #'instance creation' }
HashedCollection class >> withAll: aCollection [
	| instance |
	instance := self new: aCollection size.
	^instance addAll: aCollection; yourself
]

{ #category : #adding }
HashedCollection >> add: element [
	(table atKey: element put: element) == nil ifTrue: [self incrementTally].
	^element
]

{ #category : #accessing }
HashedCollection >> at: anInteger [
	^self errorNotIndexable
]

{ #category : #accessing }
HashedCollection >> at: anInteger put: anObject [
	^self errorNotIndexable
]

{ #category : #private }
HashedCollection >> basicAdd: element [
	tally := tally + 1.
	table basicAtKey: element put: element.
	^element
]

{ #category : #enumerating }
HashedCollection >> basicDo: aBlock [
	table elementsDo: aBlock count: tally
]

{ #category : #services }
HashedCollection >> beWeak [
	| policy |
	policy := self policy.
	policy == self ifTrue: [policy := self defaultPolicy].
	policy useWeakSlots.
	table beWeak.
	self usePolicy: policy
]

{ #category : #accessing }
HashedCollection >> bucketClass [
	^OpenHashTable
]

{ #category : #private }
HashedCollection >> bucketOfSize: anInteger [
	^(self bucketClass new: anInteger) owner: self
]

{ #category : #private }
HashedCollection >> contentOfSize: anInteger [
	^self policy == self
		ifTrue: [(self bucketClass new: anInteger) owner: self]
		ifFalse: [self policy contentOfSize: anInteger]
]

{ #category : #private }
HashedCollection >> contents [
	^table
]

{ #category : #copying }
HashedCollection >> copy [
	| copy |
	copy := super copy.
	table policy == self ifTrue: [copy useDefaultPolicy] ifFalse: [
		self ASSERT: table policy class == HashTablePolicy.
		copy usePolicy: table policy copy].
	^copy
]

{ #category : #private }
HashedCollection >> defaultPolicy [
	^HashTablePolicy new
		storesAssociations: self storesAssociations;
		bucketClass: self bucketClass
]

{ #category : #enumerating }
HashedCollection >> do: aBlock [
	self basicDo: aBlock
]

{ #category : #private }
HashedCollection >> emptySlot [
	^nil
]

{ #category : #private }
HashedCollection >> equates: key with: element [
	^key = element
]

{ #category : #private }
HashedCollection >> grow [
	self resizeTo: tally * 2
]

{ #category : #private }
HashedCollection >> hashFor: anObject [
	^anObject hash
]

{ #category : #private }
HashedCollection >> incrementTally [
	tally := tally + 1.
	(table isCapacityGreaterThan: tally) ifFalse: [self grow]
]

{ #category : #initialization }
HashedCollection >> initialize: anInteger [
	| t |
	t := self contentOfSize: anInteger.
	self onTable: t
]

{ #category : #initialization }
HashedCollection >> initializeWeakSize: anInteger [
	self initialize: anInteger.
	table beWeak
]

{ #category : #accessing }
HashedCollection >> keyFor: anObject [
	^anObject
]

{ #category : #private }
HashedCollection >> maxSlots [
	^self policy == self ifFalse: [self policy maxSlots]
]

{ #category : #services }
HashedCollection >> maxSlots: anInteger [
	| policy |
	policy := self policy.
	policy == self ifTrue: [policy := self defaultPolicy].
	policy maxSlots: anInteger.
	self usePolicy: policy
]

{ #category : #inquiries }
HashedCollection >> occurrencesOf: anObject [
	^(self includes: anObject) ifTrue: [1] ifFalse: [0]
]

{ #category : #initialization }
HashedCollection >> onTable: aHashTable [
	tally := 0.
	table := aHashTable
]

{ #category : #accessing }
HashedCollection >> policy [
	^table notNil ifTrue: [table policy] ifFalse: [self]
]

{ #category : #copying }
HashedCollection >> postCopy [
	super postCopy.
	table := table copy
]

{ #category : #services }
HashedCollection >> rehash [
	tally isNil ifTrue: [tally := table count].
	self resizeTo: tally
]

{ #category : #removing }
HashedCollection >> remove: anObject ifAbsent: aBlock [
	table removeKey: anObject ifAbsent: [^aBlock value].
	tally := tally - 1.
	^anObject
]

{ #category : #removing }
HashedCollection >> removeAll [
	tally = 0 ifTrue: [^self].
	table removeAll.
	tally := 0
]

{ #category : #removing }
HashedCollection >> removeAll: aCollection [
	^self removeAll: aCollection ifAbsent: [self errorNotFound]
]

{ #category : #removing }
HashedCollection >> removeAll: aCollection ifAbsent: aBlock [
	| n |
	n := aCollection size.
	table removeKeys: aCollection ifAbsent: [
		n := n - 1.
		aBlock value].
	tally := tally - n.
	^aCollection
]

{ #category : #private }
HashedCollection >> resizeTo: anInteger [
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
]

{ #category : #accessing }
HashedCollection >> size [
	^tally
]

{ #category : #testing }
HashedCollection >> storesAssociations [
	^false
]

{ #category : #private }
HashedCollection >> table [
	^table
]

{ #category : #services }
HashedCollection >> useDefaultPolicy [
	table policy == self ifTrue: [^self].
	table policy: self.
	self notEmpty ifTrue: [self rehash]
]

{ #category : #services }
HashedCollection >> useIdentityHash [
	| policy |
	policy := self defaultPolicy.
	policy useIdentityHash.
	self usePolicy: policy
]

{ #category : #services }
HashedCollection >> usePolicy: aHashTablePolicy [
	table isNil ifTrue: [^self].
	table policy: aHashTablePolicy.
	aHashTablePolicy usesWeakSlots
		ifTrue: [self class registerPolicy: aHashTablePolicy for: self].
	self notEmpty ifTrue: [self rehash]
]

{ #category : #testing }
HashedCollection >> usesWeakSlots [
	| p |
	p := self policy.
	^p !== self and: [p usesWeakSlots]
]

