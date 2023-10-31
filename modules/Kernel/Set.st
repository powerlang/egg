"
    Copyright (c) 2020 Aucerna. 
    See (MIT) license in root directory.
"

Class {
	#name : #Set,
	#superclass : #HashedCollection,
	#category : #Kernel
}

{ #category : #comparing }
Set >> = aSet [
	self == aSet ifTrue: [^true].
	(aSet isKindOf: Set) ifFalse: [^false].
	self size = aSet size ifFalse: [^false].
	self do: [:element | (aSet includes: element) ifFalse: [^false]].
	^true
]

{ #category : #copying }
Set >> copyWithout: anObject [
	^self copy remove: anObject ifAbsent: nil; yourself
]

{ #category : #testing }
Set >> includes: element [
	tally = 0 ifTrue: [^false].
	table lookupKey: element ifAbsent: [^false].
	^true
]

{ #category : #operations }
Set >> intersection: aCollection [
	| n set |
	n := self size min: aCollection size.
	set := self class new: n.
	^aCollection select: [:each | self includes: each] in: set
]

{ #category : #inquiries }
Set >> lookup: anObject [
	^table lookupKey: anObject
]

{ #category : #private }
Set >> rebuildOn: aSet [
	self basicDo: [:element | aSet basicAdd: element].
	table := aSet contents.
	tally := aSet size
]

