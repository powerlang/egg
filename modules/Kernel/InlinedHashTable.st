"
    Copyright (c) 2020 Aucerna. 
    See (MIT) license in root directory.
"

Class {
	#name : #InlinedHashTable,
	#superclass : #HashTable,
	#type : #variable,
	#category : #Kernel
}

{ #category : #'instance creation' }
InlinedHashTable class >> new: anInteger [
	| n |
	n := self primeFor: anInteger.
	^self basicNew: n * 2
]

{ #category : #accessing }
InlinedHashTable >> at: index key: key put: element [
	(self at: index) ifNil: [
		self
			at: index put: key;
			at: index + 1 put: element.
		^nil].
	self at: index + 1 put: element.
	^key
]

{ #category : #accessing }
InlinedHashTable >> atKey: key hash: hash sum: magnitude [
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
]

{ #category : #private }
InlinedHashTable >> basicAtKey: key put: element [
	| index |
	index := self indexOfKey: key.
	self
		at: index put: key;
		at: index + 1 put: element
]

{ #category : #removing }
InlinedHashTable >> clearSlot: anInteger with: emptySlot [
	self
		basicAt: anInteger put: emptySlot;
		basicAt: anInteger + 1 put: emptySlot
]

{ #category : #private }
InlinedHashTable >> copyFromBucket: bucket [
	| count |
	count := 0.
	bucket keysAndValuesDo: [:key :value | 
		count := count + 1.
		self basicAtKey: key put: value].
	^count
]

{ #category : #accessing }
InlinedHashTable >> count [
	| n empty |
	n := 0.
	empty := self emptySlot.
	1 to: self size by: 2 do: [:i | | k |
		k := self at: i.
		(k == nil or: [k == empty]) ifFalse: [n := n + 1]].
	^n
]

{ #category : #enumerating }
InlinedHashTable >> elementsDo: aBlock count: n [
	| count |
	count := 0.
	self keysAndValuesDo: [:k :v | | assoc |
		assoc := Association key: k value: v.
		aBlock evaluateWith: assoc.
		count := count + 1.
		count = n ifTrue: [^self]]
]

{ #category : #private }
InlinedHashTable >> indexOfHash: integer [
	^integer \\ (self size // 2) * 2 + 1
]

{ #category : #testing }
InlinedHashTable >> isCapacityGreaterThan: count [
	^self size * 3 > (count * 8)
]

{ #category : #enumerating }
InlinedHashTable >> keysAndValuesDo: aBlock [
	1 to: self size by: 2 do: [:index | | key value |
		key := self at: index.
		key notNil ifTrue: [
			key := key == NilToken ifFalse: [key].
			value := self at: index + 1.
			value := value == NilToken ifFalse: [value].
			aBlock value: key value: value]]
]

{ #category : #private }
InlinedHashTable >> lookupValue: key [
	^self lookupValue: key ifAbsent: [self keyNotFound: key]
]

{ #category : #removing }
InlinedHashTable >> moveSlot: anInteger to: targetInteger [
	| k v empty |
	empty := self emptySlot.
	k := self basicAt: anInteger.
	v := self basicAt: anInteger + 1.
	self
		basicAt: anInteger put: empty;
		basicAt: anInteger + 1 put: empty;
		basicAt: targetInteger put: k;
		basicAt: targetInteger + 1 put: v
]

{ #category : #removing }
InlinedHashTable >> slotsPerElement [
	^2
]

{ #category : #private }
InlinedHashTable >> valueAt: index ifAbsent: aBlock [
	| k value |
	k := self at: index.
	(k == nil or: [k == self emptySlot]) ifTrue: [^aBlock value].
	value := self at: index + 1.
	^value == NilToken ifFalse: [value]
]

