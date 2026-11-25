'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:38 pm'!
!classDefinition: #SortedCollection category: #Kernel!
OrderedCollection subclass: #SortedCollection
	instanceVariableNames: 'sortBlock'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Kernel'!
!SortedCollection commentStamp: '<historical>' prior: 0!

    Copyright (c) 2020 Aucerna. 
    See (MIT) license in root directory.
!

!SortedCollection methodsFor:  'adding' stamp: 'KenD 28/Jun/2026 13:27:38'!
add: anObject
	| idx |
	idx := self indexFor: anObject.
	self add: anObject at: idx
! !

!SortedCollection methodsFor:  'adding' stamp: 'KenD 28/Jun/2026 13:27:38'!
addAll: aCollection
	aCollection size > (self size // 3)
		ifTrue: [
			aCollection do: [:each | self addLast: each].
			self reSort]
		ifFalse: [aCollection do: [:each | self add: each]].
	^aCollection
! !

!SortedCollection methodsFor:  'converting' stamp: 'KenD 28/Jun/2026 13:27:38'!
asOrderedCollection
	^OrderedCollection withAll: self
! !

!SortedCollection methodsFor:  'converting' stamp: 'KenD 28/Jun/2026 13:27:38'!
asSortedCollection
	^self
! !

!SortedCollection methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
at: anInteger put: anObject
	^self shouldNotImplement
! !

!SortedCollection methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:38'!
blockForCopy: copy
	(sortBlock isMessage and: [sortBlock receiver == self])
		ifTrue: [^sortBlock copy receiver: copy].
	^sortBlock
! !

!SortedCollection methodsFor:  'copying' stamp: 'KenD 28/Jun/2026 13:27:38'!
copyFrom: startIndex to: endIndex
	| copy block |
	copy := super copyFrom: startIndex to: endIndex.
	block := self blockForCopy: copy.
	copy sortBlock: block.
	^copy
! !

!SortedCollection methodsFor:  'copying' stamp: 'KenD 28/Jun/2026 13:27:38'!
deepCopy
	| copy block |
	copy := self species new.
	block := self blockForCopy: copy.
	copy sortBlock: block.
	self do: [:element | copy add: element copy].
	^copy
! !

!SortedCollection methodsFor:  'adding' stamp: 'KenD 28/Jun/2026 13:27:38'!
indexFor: newObject
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
! !

!SortedCollection methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:38'!
reSort
	self sort: start to: end
! !

!SortedCollection methodsFor:  'enumerating' stamp: 'KenD 28/Jun/2026 13:27:38'!
select: aBlock
	| collection block |
	collection := self species new.
	block := self blockForCopy: collection.
	collection sortBlock: block.
	self
		do: [:element | (aBlock evaluateWith: element)
			ifTrue: [collection add: element]].
	^collection
! !

!SortedCollection methodsFor:  'enumerating' stamp: 'KenD 28/Jun/2026 13:27:38'!
select: n satisfying: aBlock
	| collection block |
	collection := super select: n satisfying: aBlock.
	block := self blockForCopy: collection.
	collection sortBlock: block.
	^collection
! !

!SortedCollection methodsFor:  'sorting' stamp: 'KenD 28/Jun/2026 13:27:38'!
sort: left to: right
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
! !

!SortedCollection methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:38'!
sortBlock
	^sortBlock
! !

!SortedCollection methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
sortBlock: aBlock
	sortBlock := aBlock.
	self reSort
! !

!SortedCollection methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
sortBy: criteria
	sortBlock := criteria.
	self reSort
! !

!SortedCollection methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:38'!
value: object1 value: object2
	^object1 <= object2
! !

!SortedCollection methodsFor:  'enumerating' stamp: 'KenD 28/Jun/2026 13:27:38'!
withIndexCollect: aBlock
	^self withIndexCollect: aBlock in: (OrderedCollection new: self size)
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'SortedCollection class' category: #Kernel!
SortedCollection class
	instanceVariableNames: ''!

!SortedCollection class methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:27:38'!
sortBlock: aBlock
	| instance |
	instance := super new: 10.
	^instance sortBlock: aBlock
! !

!SortedCollection class methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:27:38'!
withAll: aCollection sortingBy: aBlock
	| collection |
	collection := self new: aCollection size.
	collection sortBlock: aBlock; addAll: aCollection.
	^collection
! !


