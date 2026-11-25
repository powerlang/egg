'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:39 pm'!
!classDefinition: #ODominatorTree category: #IR!
Object subclass: #ODominatorTree
	instanceVariableNames: 'block dominators dominated'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'IR'!
!ODominatorTree commentStamp: '<historical>' prior: 0!

    Copyright (c) 2020 Aucerna.
    See (MIT) license in root directory.
!

!ODominatorTree methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
addDominated: aTree
	dominated add: aTree
! !

!ODominatorTree methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
allImmediateDominators
	| result remaining |
	result := Dictionary new.
	remaining := OrderedCollection with: self.
	[remaining isEmpty] whileFalse: [| current |
		current := remaining removeLast.
		current dominated do: [:child | result at: child block put: current block].
		remaining addAll: current dominated].
	^result
! !

!ODominatorTree methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
block
	^block
! !

!ODominatorTree methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
block: aBasicBlock
	block := aBasicBlock
! !

!ODominatorTree methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
dominated
	^dominated
! !

!ODominatorTree methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
dominators
	^dominators
! !

!ODominatorTree methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
dominators: aTreeCollection
	dominators := aTreeCollection
! !

!ODominatorTree methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
initialize
	dominated := OrderedCollection new
! !

!ODominatorTree methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
isImmediateDominatorOf: aBasicBlock
	^block == self or: [block successors includes: aBasicBlock]
! !

!ODominatorTree methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
noticeDominators
	dominators
		select: [:tree | tree isImmediateDominatorOf: self]
		thenDo: [:dominator | dominator addDominated: self]
! !

!ODominatorTree methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
printAtLevel: level on: aStream
	level > 8 ifTrue: [self halt].
	level timesRepeat: [aStream nextPutAll: '--'].
	aStream nextPutAll: block name , String cr.
	dominated
		reject: [:tree | tree == self]
		thenDo: [:tree | tree printAtLevel: level + 1 on: aStream]
! !

!ODominatorTree methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
printOn: aStream
	self printAtLevel: 1 on: aStream
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'ODominatorTree class' category: #IR!
ODominatorTree class
	instanceVariableNames: ''!

!ODominatorTree class methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
from: root with: aBlocksCollection dominators: dominators
	| trees |
	trees := Array
		withAll: (aBlocksCollection collect: [:block | self new block: block]).
	(dominators copyFrom: 2)
		withIndexDo: [:dominator :correspondingIndex | | imm child |
			imm := trees at: dominator.
			child := trees at: correspondingIndex + 1.
			imm addDominated: child].
	^trees first
! !

!ODominatorTree class methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
new
	^self basicNew initialize
! !


ODominatorTree initialize!

