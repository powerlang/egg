"
    Copyright (c) 2020 Aucerna. 
    See (MIT) license in root directory.
"

Class {
	#name : #OpenHashTable,
	#superclass : #HashTable,
	#type : #variable,
	#category : #Kernel
}

{ #category : #accessing }
OpenHashTable >> at: index key: key put: element [
	| object |
	object := self at: index.
	object == self emptySlot ifTrue: [object := nil].
	object == nil ifTrue: [self at: index put: element].
	^object
]

{ #category : #accessing }
OpenHashTable >> atKey: key hash: hash sum: magnitude [
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
]

{ #category : #private }
OpenHashTable >> basicAtKey: key put: element [
	| index |
	index := self indexOfKey: key.
	self at: index put: element
]

{ #category : #private }
OpenHashTable >> copyAssociations [
	self
		withIndexDo: [:a :index | a isAssociation
			ifTrue: [self at: index put: a key -> a value]]
]

{ #category : #private }
OpenHashTable >> copyFromBucket: bucket [
	| count |
	count := 0.
	bucket elementsDo: [:element | | key |
		count := count + 1.
		key := self keyFor: element.
		self basicAtKey: key put: element].
	^count
]

{ #category : #accessing }
OpenHashTable >> count [
	^self count: [:n | n notNil]
]

{ #category : #enumerating }
OpenHashTable >> elementsDo: aBlock count: n [
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
]

{ #category : #private }
OpenHashTable >> indexOfHash: integer [
	^integer \\ self size + 1
]

{ #category : #testing }
OpenHashTable >> isCapacityGreaterThan: count [
	^self size * 75 > (count * 100)
]

{ #category : #enumerating }
OpenHashTable >> keysAndValuesDo: aBlock [
	self
		elementsDo: [:assoc | aBlock evaluateWith: assoc key with: assoc value]
]

{ #category : #private }
OpenHashTable >> lookupValue: key [
	^self lookupValue: key ifAbsent: [self keyNotFound: key]
]

{ #category : #private }
OpenHashTable >> lookupValue: key ifAbsent: aBlock [
	| assoc |
	assoc := super lookupValue: key ifAbsent: [^aBlock value].
	^assoc value
]

{ #category : #removing }
OpenHashTable >> moveSlot: anInteger to: targetInteger [
	| a |
	a := self basicAt: anInteger.
	self
		basicAt: anInteger put: self emptySlot;
		basicAt: targetInteger put: a
]

