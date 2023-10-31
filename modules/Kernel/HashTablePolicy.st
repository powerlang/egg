"
    Copyright (c) 2020 Aucerna. 
    See (MIT) license in root directory.
"

Class {
	#name : #HashTablePolicy,
	#superclass : #Object,
	#instVars : [
		'associationClass',
		'bucketClass',
		'maxSlots',
		'weak',
		'hasher',
		'comparison',
		'storesAssociations'
	],
	#classVars : [
		'EmptySlot'
	],
	#category : #Kernel
}

{ #category : #accessing }
HashTablePolicy class >> emptySlot [
	^EmptySlot
]

{ #category : #initialization }
HashTablePolicy class >> initializeEmptySlot [
	EmptySlot := Object new
]

{ #category : #services }
HashTablePolicy >> associationClass [
	^associationClass
]

{ #category : #accessing }
HashTablePolicy >> associationClass: aClass [
	associationClass := aClass
]

{ #category : #accessing }
HashTablePolicy >> bucketClass: aClass [
	bucketClass := aClass
]

{ #category : #services }
HashTablePolicy >> bucketOfSize: anInteger [
	| bucket |
	bucket := (bucketClass new: anInteger) policy: self.
	weak ifTrue: [bucket beWeak].
	^bucket
]

{ #category : #accessing }
HashTablePolicy >> comparison: evaluableObject [
	comparison := evaluableObject
]

{ #category : #private }
HashTablePolicy >> contentOfSize: anInteger [
	| table |
	table := bucketClass new: anInteger.
	table policy: self.
	weak ifTrue: [table beWeak].
	^table
]

{ #category : #accessing }
HashTablePolicy >> emptySlot [
	^weak ifTrue: [EmptySlot]
]

{ #category : #services }
HashTablePolicy >> equates: key with: anObject [
	| item |
	item := storesAssociations ifTrue: [anObject key] ifFalse: [anObject].
	^comparison isNil
		ifTrue: [key = item]
		ifFalse: [comparison evaluateWith: key with: item]
]

{ #category : #accessing }
HashTablePolicy >> hasher: evaluableObject [
	hasher := evaluableObject
]

{ #category : #services }
HashTablePolicy >> hashFor: anObject [
	^hasher notNil
		ifTrue: [hasher evaluateWith: anObject]
		ifFalse: [anObject hash]
]

{ #category : #initialization }
HashTablePolicy >> initialize [
	associationClass := Association.
	weak := storesAssociations := false
]

{ #category : #services }
HashTablePolicy >> keyFor: anObject [
	^storesAssociations ifTrue: [anObject key] ifFalse: [anObject]
]

{ #category : #accessing }
HashTablePolicy >> maxSlots [
	^maxSlots
]

{ #category : #accessing }
HashTablePolicy >> maxSlots: anInteger [
	maxSlots := anInteger
]

{ #category : #accessing }
HashTablePolicy >> storesAssociations: aBoolean [
	storesAssociations := aBoolean
]

{ #category : #accessing }
HashTablePolicy >> useIdentityHash [
	self
		hasher: [:key | key basicHash * 16273];
		comparison: [:a :b | a == b]
]

{ #category : #accessing }
HashTablePolicy >> useStringHash [
	self
		hasher: [:key | key stringHash];
		comparison: [:a :b | a equals: b]
]

{ #category : #accessing }
HashTablePolicy >> usesWeakSlots [
	^weak
]

{ #category : #services }
HashTablePolicy >> useWeakSlots [
	weak := true
]

{ #category : #accessing }
HashTablePolicy >> weak: aBoolean [
	weak := aBoolean
]

