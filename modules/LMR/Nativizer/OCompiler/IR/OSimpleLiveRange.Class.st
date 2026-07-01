'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:39 pm'!
!classDefinition: #OSimpleLiveRange category: #IR!
OLiveRange subclass: #OSimpleLiveRange
	instanceVariableNames: 'definition uses definitionBlock usesBlocks isSpilled'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'IR'!
!OSimpleLiveRange commentStamp: '<historical>' prior: 0!

    Copyright (c) 2020 Aucerna.
    See (MIT) license in root directory.
!

!OSimpleLiveRange methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
addUseFrom: operation at: block
	uses add: operation -> block
! !

!OSimpleLiveRange methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
allDefinitions
	^OrderedCollection with: definition
! !

!OSimpleLiveRange methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
allUses
	^uses collect: #key
! !

!OSimpleLiveRange methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
anyDefinition
	^definition
! !

!OSimpleLiveRange methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
beSpilled
	isSpilled := true
! !

!OSimpleLiveRange methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
clearUses
	uses := OrderedCollection new
! !

!OSimpleLiveRange methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
definedAt: operation in: block
	definition := operation.
	definitionBlock := block
! !

!OSimpleLiveRange methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
definition: operation
	definition := operation
! !

!OSimpleLiveRange methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
definitionAndUses
	^OrderedCollection with: definition -> definitionBlock withAll: uses
! !

!OSimpleLiveRange methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
definitionsWithBlocksDo: aBlock
	aBlock value: definition value: definitionBlock
! !

!OSimpleLiveRange methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
endsAt: operation
	^uses isEmpty
! !

!OSimpleLiveRange methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
expirationPoints
	| associations |
	associations := uses
		reject: [:operation | definition
			livesAfter: operation key
			orOutOf: operation value].
	^associations collect: #key
! !

!OSimpleLiveRange methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
initialize
	uses := OrderedCollection new.
	isSpilled := false
! !

!OSimpleLiveRange methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
isLiveAt: aBlock
	^definition livesAfter: aBlock firstInstruction prev orOutOf: aBlock
! !

!OSimpleLiveRange methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
isSpilled
	^isSpilled
! !

!OSimpleLiveRange methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
isUnused
	^uses isEmpty
! !

!OSimpleLiveRange methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
printOn: aStream
	aStream nextPutAll: 'LR of: ' , definition printString
! !

!OSimpleLiveRange methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
simpleRanges
	^OrderedCollection with: self
! !

!OSimpleLiveRange methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
startsAt: operation
	^definition == operation
! !

!OSimpleLiveRange methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
uses
	^uses
! !

!OSimpleLiveRange methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
usesWithBlocks
	^uses
! !

!OSimpleLiveRange methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
usesWithBlocksDo: aBlock
	uses
		do: [:association | aBlock value: association key value: association value]
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'OSimpleLiveRange class' category: #IR!
OSimpleLiveRange class
	instanceVariableNames: ''!


OSimpleLiveRange initialize!

