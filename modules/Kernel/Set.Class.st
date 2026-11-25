'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:38 pm'!
!classDefinition: #Set category: #Kernel!
HashedCollection subclass: #Set
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Kernel'!
!Set commentStamp: '<historical>' prior: 0!

    Copyright (c) 2020 Aucerna. 
    See (MIT) license in root directory.
!

!Set methodsFor:  'comparing' stamp: 'KenD 28/Jun/2026 13:27:38'!
= aSet
	self == aSet ifTrue: [^true].
	(aSet isKindOf: Set) ifFalse: [^false].
	self size = aSet size ifFalse: [^false].
	self do: [:element | (aSet includes: element) ifFalse: [^false]].
	^true
! !

!Set methodsFor:  'copying' stamp: 'KenD 28/Jun/2026 13:27:38'!
copyWithout: anObject
	^self copy remove: anObject ifAbsent: nil; yourself
! !

!Set methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:38'!
includes: element
	tally = 0 ifTrue: [^false].
	table lookupKey: element ifAbsent: [^false].
	^true
! !

!Set methodsFor:  'operations' stamp: 'KenD 28/Jun/2026 13:27:38'!
intersection: aCollection
	| n set |
	n := self size min: aCollection size.
	set := self class new: n.
	^aCollection select: [:each | self includes: each] in: set
! !

!Set methodsFor:  'inquiries' stamp: 'KenD 28/Jun/2026 13:27:38'!
lookup: anObject
	^table lookupKey: anObject
! !

!Set methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:38'!
rebuildOn: aSet
	self basicDo: [:element | aSet basicAdd: element].
	table := aSet contents.
	tally := aSet size
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Set class' category: #Kernel!
Set class
	instanceVariableNames: ''!


