"
    Copyright (c) 2020 Aucerna. 
    See (MIT) license in root directory.
"

Class {
	#name : #SortedCollection,
	#superclass : #OrderedCollection,
	#instVars : [
		'sortBlock'
	],
	#category : #Kernel
}

{ #category : #'instance creation' }
SortedCollection class >> sortBlock: aBlock [
	| instance |
	instance := super new: 10.
	^instance sortBlock: aBlock
]

{ #category : #'instance creation' }
SortedCollection class >> withAll: aCollection sortingBy: aBlock [
	| collection |
	collection := self new: aCollection size.
	collection sortBlock: aBlock; addAll: aCollection.
	^collection
]

{ #category : #adding }
SortedCollection >> add: anObject [
	| idx |
	idx := self indexFor: anObject.
	self add: anObject at: idx
]

{ #category : #adding }
SortedCollection >> addAll: aCollection [
	aCollection size > (self size // 3)
		ifTrue: [
			aCollection do: [:each | self addLast: each].
			self reSort]
		ifFalse: [aCollection do: [:each | self add: each]].
	^aCollection
]

{ #category : #converting }
SortedCollection >> asOrderedCollection [
	^OrderedCollection withAll: self
]

{ #category : #converting }
SortedCollection >> asSortedCollection [
	^self
]

{ #category : #accessing }
SortedCollection >> at: anInteger put: anObject [
	^self shouldNotImplement
]

{ #category : #private }
SortedCollection >> blockForCopy: copy [
	(sortBlock isMessage and: [sortBlock receiver == self])
		ifTrue: [^sortBlock copy receiver: copy].
	^sortBlock
]

{ #category : #copying }
SortedCollection >> copyFrom: startIndex to: endIndex [
	| copy block |
	copy := super copyFrom: startIndex to: endIndex.
	block := self blockForCopy: copy.
	copy sortBlock: block.
	^copy
]

{ #category : #copying }
SortedCollection >> deepCopy [
	| copy block |
	copy := self species new.
	block := self blockForCopy: copy.
	copy sortBlock: block.
	self do: [:element | copy add: element copy].
	^copy
]

{ #category : #adding }
SortedCollection >> indexFor: newObject [
	| index low high sorter |
	low := start.
	high := end.
	sorter := sortBlock ifNil: [self].
	[
		index := high + low // 2.
		low > high]
		whileFalse: [
			(sorter value: (contents at: index) value: newObject)
				ifTrue: [low := index + 1]
				ifFalse: [high := index - 1]].
	^low - start + 1
]

{ #category : #private }
SortedCollection >> reSort [
	self sort: start to: end
]

{ #category : #enumerating }
SortedCollection >> select: aBlock [
	| collection block |
	collection := self species new.
	block := self blockForCopy: collection.
	collection sortBlock: block.
	self
		do: [:element | (aBlock evaluateWith: element)
			ifTrue: [collection add: element]].
	^collection
]

{ #category : #enumerating }
SortedCollection >> select: n satisfying: aBlock [
	| collection block |
	collection := super select: n satisfying: aBlock.
	block := self blockForCopy: collection.
	collection sortBlock: block.
	^collection
]

{ #category : #sorting }
SortedCollection >> sort: left to: right [
	| i j sorter |
	i := left.
	j := right.
	sorter := sortBlock ifNil: [self].
	[| remaining finished swapper middle temp last |
		remaining := j - i.
		(finished := remaining <= 1)
			ifTrue: [
				remaining = 1 ifTrue: [
					remaining := contents at: j.
					swapper := contents at: i.
					(sorter value: remaining value: swapper) ifTrue: [
						contents
							at: i put: remaining;
							at: j put: swapper]]]
			ifFalse: [
				middle := i + j // 2.
				temp := contents at: middle.
				contents at: middle put: (contents at: i).
				remaining := last := i.
				[
					remaining := remaining + 1.
					(sorter value: (contents at: remaining) value: temp) ifTrue: [
						last := last + 1.
						last = remaining ifFalse: [
							swapper := contents at: remaining.
							contents
								at: remaining put: (contents at: last);
								at: last put: swapper]].
					remaining < j] whileTrue.
				contents
					at: i put: (contents at: last);
					at: last put: temp.
				middle < last
					ifTrue: [
						self sort: last + 1 to: j.
						j := last - 1]
					ifFalse: [
						self sort: i to: last - 1.
						i := last + 1]].
		finished] whileFalse
]

{ #category : #private }
SortedCollection >> sortBlock [
	^sortBlock
]

{ #category : #accessing }
SortedCollection >> sortBlock: aBlock [
	sortBlock := aBlock.
	self reSort
]

{ #category : #accessing }
SortedCollection >> sortBy: criteria [
	sortBlock := criteria.
	self reSort
]

{ #category : #private }
SortedCollection >> value: object1 value: object2 [
	^object1 <= object2
]

{ #category : #enumerating }
SortedCollection >> withIndexCollect: aBlock [
	^self withIndexCollect: aBlock in: (OrderedCollection new: self size)
]

