'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:39 pm'!
!classDefinition: #CriticalStack category: #Kernel!
SequenceableCollection subclass: #CriticalStack
	instanceVariableNames: 'head limit top buffers bufferIndex'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Kernel'!
!CriticalStack commentStamp: '<historical>' prior: 0!

	Copyright (c) 2020-2022 Quorum Software.
	See (MIT) license in root directory.
!

!CriticalStack methodsFor:  'adding/removing' stamp: 'KenD 28/Jun/2026 13:27:39'!
addBuffer: size
	| address |
	address := Kernel os reserveAndCommit: size * WordSize.
	buffers
		push: size;
		push: address // 2
! !

!CriticalStack methodsFor:  'actions' stamp: 'KenD 28/Jun/2026 13:27:39'!
at: anInteger
	^self errorNotIndexable
! !

!CriticalStack methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
buffers: aCriticalArray initialSize: anInteger
	buffers := aCriticalArray.
	self addBuffer: anInteger.
	top := 0.
	bufferIndex := 2.
	head := buffers at: bufferIndex.
	limit := anInteger
! !

!CriticalStack methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:39'!
grow
	bufferIndex = buffers size ifTrue: [self addBuffer: limit * 2].
	bufferIndex := bufferIndex + 2.
	head := buffers at: bufferIndex.
	limit := buffers at: bufferIndex - 1.
	top := 0
! !

!CriticalStack methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:39'!
isEmpty
	^top = 0 and: [bufferIndex = 2]
! !

!CriticalStack methodsFor:  'adding/removing' stamp: 'KenD 28/Jun/2026 13:27:39'!
pop
	| answer |
	top = 0 ifTrue: [self shrink].
	answer := head _asObject _basicAt: top.
	top := top - 1.
	^answer
! !

!CriticalStack methodsFor:  'adding/removing' stamp: 'KenD 28/Jun/2026 13:27:39'!
push: anObject
	top = limit ifTrue: [self grow].
	top := top + 1.
	^head _asObject _basicAt: top put: anObject
! !

!CriticalStack methodsFor:  'finalization' stamp: 'KenD 28/Jun/2026 13:27:39'!
release
	2 to: buffers size by: 2 do: [:i | | address |
		address := buffers at: i.
		Kernel os release: address * 2].
	buffers reset
! !

!CriticalStack methodsFor:  'actions' stamp: 'KenD 28/Jun/2026 13:27:39'!
reset
	[buffers size > 2] whileTrue: [| address |
		address := buffers pop.
		buffers pop.
		Kernel os release: address * 2].
	bufferIndex := 2.
	head := buffers at: bufferIndex.
	limit := buffers at: bufferIndex - 1.
	top := 0
! !

!CriticalStack methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:39'!
shrink
	bufferIndex < 2 ifTrue: [self error: 'cannot shrink empty stack'].
	bufferIndex := bufferIndex - 2.
	head := buffers at: bufferIndex.
	limit := top := buffers at: bufferIndex - 1
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'CriticalStack class' category: #Kernel!
CriticalStack class
	instanceVariableNames: ''!

!CriticalStack class methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:27:39'!
emptyReserving: anInteger
	| buffers |
	buffers := CriticalArray new growTo: 40.
	^self new buffers: buffers initialSize: anInteger
! !


