'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:38 pm'!
!classDefinition: #LinkedCollection category: #Kernel!
SequenceableCollection subclass: #LinkedCollection
	instanceVariableNames: 'next localSize'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Kernel'!
!LinkedCollection commentStamp: '<historical>' prior: 0!

    Copyright (c) 2020 Aucerna. 
    See (MIT) license in root directory.
!

!LinkedCollection methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
add: anObject
	^next == nil
		ifTrue: [
			localSize = self basicSize
				ifTrue: [
					self createNextLink.
					next add: anObject]
				ifFalse: [self basicAdd: anObject]]
		ifFalse: [next add: anObject]
! !

!LinkedCollection methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
at: anInteger
	(0 < anInteger and: [anInteger <= self basicSize])
		ifTrue: [^self basicAt: anInteger].
	next == nil
		ifTrue: [self outOfBoundsIndex: anInteger]
		ifFalse: [^next at: anInteger - localSize]
! !

!LinkedCollection methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
at: anInteger put: anObject
	(0 < anInteger and: [anInteger <= localSize])
		ifTrue: [^self basicAt: anInteger put: anObject].
	next == nil
		ifTrue: [self outOfBoundsIndex: anInteger]
		ifFalse: [^next at: anInteger - localSize put: anObject]
! !

!LinkedCollection methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:38'!
basicAdd: anObject
	localSize := localSize + 1.
	self basicAt: localSize put: anObject
! !

!LinkedCollection methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
copyFrom: beginning to: end
	| total copy |
	total := end - beginning + 1.
	total negative ifTrue: [self outOfBoundsIndex: total].
	copy := self species new: total.
	copy localSize: total.
	^copy replaceFrom: 1 to: total with: self startingAt: beginning
! !

!LinkedCollection methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
createNextLink
	next := self species new: self basicSize * 2
! !

!LinkedCollection methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
do: aBlock
	| index |
	index := 0.
	[
		index := index + 1.
		index <= localSize]
		whileTrue: [aBlock evaluateWith: (self basicAt: index)].
	next == nil ifFalse: [next do: aBlock]
! !

!LinkedCollection methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
hasIndexedSlots
	^true
! !

!LinkedCollection methodsFor:  'initialization' stamp: 'KenD 28/Jun/2026 13:27:38'!
initialize
	localSize := 0
! !

!LinkedCollection methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
localSize: anInteger
	localSize := anInteger
! !

!LinkedCollection methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
size
	| extra |
	extra := next == nil ifTrue: [0] ifFalse: [next size].
	^localSize + extra
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'LinkedCollection class' category: #Kernel!
LinkedCollection class
	instanceVariableNames: ''!

!LinkedCollection class methodsFor:  'instances' stamp: 'KenD 28/Jun/2026 13:27:38'!
new
	^self new: 50
! !

!LinkedCollection class methodsFor:  'instances' stamp: 'KenD 28/Jun/2026 13:27:38'!
new: anInteger
	| instance |
	instance := super new: anInteger.
	instance initialize.
	^instance
! !


LinkedCollection initialize!

