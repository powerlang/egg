'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:39 pm'!
!classDefinition: #RememberedSet category: #Kernel!
Object subclass: #RememberedSet
	instanceVariableNames: 'base tally maxSize'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Kernel'!
!RememberedSet commentStamp: '<historical>' prior: 0!

	Copyright (c) 2020-2022 Quorum Software.
	See (MIT) license in root directory.
!

!RememberedSet methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:39'!
add: anObject
	"
	We first check if grow is needed, then increment the tally and 
	finally grow. If not done this way, if growing adds something to
	the remembered set it could cause an infinite recursion
	"
	| grow |
	grow := tally + 10 = maxSize.
	tally := tally + 1.
	base _asObject _basicAt: tally put: anObject.
	grow ifTrue: [self grow: maxSize * 2]
! !

!RememberedSet methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:39'!
at: anInteger
	^base _asObject _basicAt: anInteger
! !

!RememberedSet methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:39'!
at: anInteger put: anObject
	^base _asObject _basicAt: anInteger put: anObject
! !

!RememberedSet methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:39'!
base
	^base
! !

!RememberedSet methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:39'!
base: anInteger
	base := anInteger
! !

!RememberedSet methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:39'!
grow: anInteger
	| new old |
	new := (Kernel os reserveAndCommit: anInteger * WordSize) // 2.
	1
		to: tally
		do: [:i | new _asObject _basicAt: i put: (base _asObject _basicAt: i)].
	old := base.
	base := new.
	maxSize := anInteger.
	Kernel os release: old * 2
! !

!RememberedSet methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:39'!
includesIdentical: anObject
	1 to: maxSize do: [:i | anObject == (self at: i) ifTrue: [^true]].
	^false
! !

!RememberedSet methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:39'!
initialize: anInteger
	tally := 0.
	base := (Kernel os reserveAndCommit: anInteger * WordSize) // 2.
	maxSize := anInteger
! !

!RememberedSet methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:39'!
maxSize
	^maxSize
! !

!RememberedSet methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:39'!
release
	Kernel os release: base * 2.
	base := nil.
	tally := maxSize := 0
! !

!RememberedSet methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:39'!
size
	^tally
! !

!RememberedSet methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:39'!
size: anInteger
	tally := anInteger
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'RememberedSet class' category: #Kernel!
RememberedSet class
	instanceVariableNames: ''!


