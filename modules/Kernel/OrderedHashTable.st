"
    Copyright (c) 2020 Aucerna. 
    See (MIT) license in root directory.
"

Class {
	#name : #OrderedHashTable,
	#superclass : #OpenHashTable,
	#type : #variable,
	#instVars : [
		'values'
	],
	#category : #Kernel
}

{ #category : #'instance creation' }
OrderedHashTable class >> new: anInteger [
	^(super new: anInteger) initialize
]

{ #category : #accessing }
OrderedHashTable >> at: index [
	| i |
	i := super at: index.
	i ifNil: [^nil].
	^values at: i
]

{ #category : #accessing }
OrderedHashTable >> at: index put: anObject [
	| i element |
	i := self basicAt: index.
	element := anObject ifNil: [NilToken].
	(i == nil or: [i == self emptySlot])
		ifTrue: [
			values add: element.
			super at: index put: values size]
		ifFalse: [values at: i put: element].
	^anObject
]

{ #category : #services }
OrderedHashTable >> at: index tally: tally [
	| n i count vi |
	n := values size.
	index * 2 <= n
		ifTrue: [
			i := 1.
			count := 0.
			[
				vi := values at: i.
				vi == nil ifFalse: [count := count + 1].
				count = index ifTrue: [^vi == NilToken ifFalse: [vi]].
				i := i + 1.
				i <= n] whileTrue]
		ifFalse: [
			i := n.
			count := tally + 1.
			[
				vi := values at: i.
				vi == nil ifFalse: [count := count - 1].
				count = index ifTrue: [^vi == NilToken ifFalse: [vi]].
				i := i - 1.
				0 < i] whileTrue]
]

{ #category : #removing }
OrderedHashTable >> clearSlot: anInteger with: emptySlot [
	| i |
	i := self basicAt: anInteger.
	self basicAt: anInteger put: emptySlot.
	values at: i put: emptySlot
]

{ #category : #services }
OrderedHashTable >> compressTo: tally [
	| relocations compressed |
	values size = tally ifTrue: [^self].
	relocations := Array new: values size.
	compressed := OrderedCollection new: tally.
	values withIndexDo: [:value :index | 
		value notNil ifTrue: [
			compressed add: value.
			relocations at: index put: compressed size]].
	1 to: self size do: [:index | | old new |
		old := super at: index.
		old notNil ifTrue: [
			new := relocations at: old.
			super at: index put: new]].
	values := compressed
]

{ #category : #enumerating }
OrderedHashTable >> elementAt: index [
	^values at: index
]

{ #category : #enumerating }
OrderedHashTable >> elementsDo: aBlock [
	values
		select: [:value | value !== nil]
		thenDo: [:value | aBlock evaluateWith: (value == NilToken ifFalse: [value])]
]

{ #category : #enumerating }
OrderedHashTable >> elementsDo: aBlock count: n [
	| i |
	n = 0 ifTrue: [^self].
	i := 0.
	self elementsDo: [:value | 
		aBlock evaluateWith: value.
		i := i + 1.
		i = n ifTrue: [^self]]
]

{ #category : #accessing }
OrderedHashTable >> first [
	values do: [:v | v notNil ifTrue: [^v]].
	^nil
]

{ #category : #private }
OrderedHashTable >> indexAtKey: key [
	| index |
	index := self indexOfKey: key.
	^self basicAt: index
]

{ #category : #accessing }
OrderedHashTable >> indexOfElement: anObject [
	| i |
	i := 1.
	self elementsDo: [:assoc | 
		assoc value == anObject ifTrue: [^i].
		i := i + 1].
	^0
]

{ #category : #initialization }
OrderedHashTable >> initialize [
	super initialize.
	values := OrderedCollection new
]

{ #category : #enumerating }
OrderedHashTable >> keysAndValuesDo: aBlock [
	self elementsDo: [:assoc | aBlock value: assoc key value: assoc value]
]

{ #category : #accessing }
OrderedHashTable >> last [
	values reverseDo: [:v | v notNil ifTrue: [^v]].
	^nil
]

{ #category : #private }
OrderedHashTable >> move: anAssociation to: anInteger [
	| a min max |
	a := values indexOf: anAssociation.
	min := a min: anInteger.
	max := a max: anInteger.
	1 to: self size do: [:i | | index |
		index := self basicAt: i.
		index notNil ifTrue: [
			(index between: min and: max) ifTrue: [
				index <= a
					ifTrue: [self basicAt: i put: index + 1]
					ifFalse: [self basicAt: i put: index - 1]].
			index = a ifTrue: [self basicAt: i put: anInteger]]].
	values move: values last to: anInteger
]

{ #category : #private }
OrderedHashTable >> moveLastTo: anInteger [
	| last |
	last := values size.
	1 to: self size do: [:i | | index |
		index := self basicAt: i.
		index notNil ifTrue: [
			index >= anInteger ifTrue: [self basicAt: i put: index + 1].
			index = last ifTrue: [self basicAt: i put: anInteger]]].
	values move: values last to: anInteger
]

{ #category : #copying }
OrderedHashTable >> postCopy [
	super postCopy.
	values := values copy
]

{ #category : #enumerating }
OrderedHashTable >> privateDo: aBlock [
	values do: [:value | aBlock evaluateWith: value]
]

{ #category : #removing }
OrderedHashTable >> removeAll [
	super removeAll.
	values removeAll
]

{ #category : #removing }
OrderedHashTable >> removeObject: anObject ifAbsent: aBlock [
	| association |
	association := values
		detect: [:assoc | assoc value == anObject]
		ifNone: [^aBlock value].
	^self removeKey: association key ifAbsent: aBlock
]

{ #category : #accessing }
OrderedHashTable >> totalSize [
	^values size
]

{ #category : #accessing }
OrderedHashTable >> valueAt: index ifAbsent: aBlock [
	| i value |
	i := self basicAt: index.
	i == nil ifTrue: [^aBlock value].
	i == self emptySlot ifTrue: [^aBlock value].
	value := values at: i ifAbsent: [^aBlock value].
	^value == NilToken ifFalse: [value]
]

{ #category : #enumerating }
OrderedHashTable >> valuesReverseDo: aBlock [
	values reverseDo: [:assoc | 
		assoc == nil
			ifFalse: [aBlock evaluateWith: (assoc == NilToken ifFalse: [assoc]) value]]
]

