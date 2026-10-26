'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:38 pm'!
!classDefinition: #OrderedHashTable category: #Kernel!
OpenHashTable subclass: #OrderedHashTable
	instanceVariableNames: 'values'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Kernel'!
!OrderedHashTable commentStamp: '<historical>' prior: 0!

    Copyright (c) 2020 Aucerna. 
    See (MIT) license in root directory.
!

!OrderedHashTable methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
at: index
	| i |
	i := super at: index.
	i ifNil: [^nil].
	^values at: i
! !

!OrderedHashTable methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
at: index put: anObject
	| i element |
	i := self basicAt: index.
	element := anObject ifNil: [NilToken].
	(i == nil or: [i == self emptySlot])
		ifTrue: [
			values add: element.
			super at: index put: values size]
		ifFalse: [values at: i put: element].
	^anObject
! !

!OrderedHashTable methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:38'!
at: index tally: tally
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
! !

!OrderedHashTable methodsFor:  'removing' stamp: 'KenD 28/Jun/2026 13:27:38'!
clearSlot: anInteger with: emptySlot
	| i |
	i := self basicAt: anInteger.
	self basicAt: anInteger put: emptySlot.
	values at: i put: emptySlot
! !

!OrderedHashTable methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:38'!
compressTo: tally
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
! !

!OrderedHashTable methodsFor:  'enumerating' stamp: 'KenD 28/Jun/2026 13:27:38'!
elementAt: index
	^values at: index
! !

!OrderedHashTable methodsFor:  'enumerating' stamp: 'KenD 28/Jun/2026 13:27:38'!
elementsDo: aBlock
	values
		select: [:value | value !!== nil]
		thenDo: [:value | aBlock evaluateWith: (value == NilToken ifFalse: [value])]
! !

!OrderedHashTable methodsFor:  'enumerating' stamp: 'KenD 28/Jun/2026 13:27:38'!
elementsDo: aBlock count: n
	| i |
	n = 0 ifTrue: [^self].
	i := 0.
	self elementsDo: [:value | 
		aBlock evaluateWith: value.
		i := i + 1.
		i = n ifTrue: [^self]]
! !

!OrderedHashTable methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
first
	values do: [:v | v notNil ifTrue: [^v]].
	^nil
! !

!OrderedHashTable methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:38'!
indexAtKey: key
	| index |
	index := self indexOfKey: key.
	^self basicAt: index
! !

!OrderedHashTable methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
indexOfElement: anObject
	| i |
	i := 1.
	self elementsDo: [:assoc | 
		assoc value == anObject ifTrue: [^i].
		i := i + 1].
	^0
! !

!OrderedHashTable methodsFor:  'initialization' stamp: 'KenD 28/Jun/2026 13:27:38'!
initialize
	super initialize.
	values := OrderedCollection new
! !

!OrderedHashTable methodsFor:  'enumerating' stamp: 'KenD 28/Jun/2026 13:27:38'!
keysAndValuesDo: aBlock
	self elementsDo: [:assoc | aBlock value: assoc key value: assoc value]
! !

!OrderedHashTable methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
last
	values reverseDo: [:v | v notNil ifTrue: [^v]].
	^nil
! !

!OrderedHashTable methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:38'!
move: anAssociation to: anInteger
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
! !

!OrderedHashTable methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:38'!
moveLastTo: anInteger
	| last |
	last := values size.
	1 to: self size do: [:i | | index |
		index := self basicAt: i.
		index notNil ifTrue: [
			index >= anInteger ifTrue: [self basicAt: i put: index + 1].
			index = last ifTrue: [self basicAt: i put: anInteger]]].
	values move: values last to: anInteger
! !

!OrderedHashTable methodsFor:  'copying' stamp: 'KenD 28/Jun/2026 13:27:38'!
postCopy
	super postCopy.
	values := values copy
! !

!OrderedHashTable methodsFor:  'enumerating' stamp: 'KenD 28/Jun/2026 13:27:38'!
privateDo: aBlock
	values do: [:value | aBlock evaluateWith: value]
! !

!OrderedHashTable methodsFor:  'removing' stamp: 'KenD 28/Jun/2026 13:27:38'!
removeAll
	super removeAll.
	values removeAll
! !

!OrderedHashTable methodsFor:  'removing' stamp: 'KenD 28/Jun/2026 13:27:38'!
removeObject: anObject ifAbsent: aBlock
	| association |
	association := values
		detect: [:assoc | assoc value == anObject]
		ifNone: [^aBlock value].
	^self removeKey: association key ifAbsent: aBlock
! !

!OrderedHashTable methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
totalSize
	^values size
! !

!OrderedHashTable methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
valueAt: index ifAbsent: aBlock
	| i value |
	i := self basicAt: index.
	i == nil ifTrue: [^aBlock value].
	i == self emptySlot ifTrue: [^aBlock value].
	value := values at: i ifAbsent: [^aBlock value].
	^value == NilToken ifFalse: [value]
! !

!OrderedHashTable methodsFor:  'enumerating' stamp: 'KenD 28/Jun/2026 13:27:38'!
valuesReverseDo: aBlock
	values reverseDo: [:assoc | 
		assoc == nil
			ifFalse: [aBlock evaluateWith: (assoc == NilToken ifFalse: [assoc]) value]]
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'OrderedHashTable class' category: #Kernel!
OrderedHashTable class
	instanceVariableNames: ''!

!OrderedHashTable class methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:27:38'!
new: anInteger
	^(super new: anInteger) initialize
! !


OrderedHashTable initialize!

