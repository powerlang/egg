'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:39 pm'!
!classDefinition: #Allocator category: #Kernel!
Object subclass: #Allocator
	instanceVariableNames: 'memory'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Kernel'!
!Allocator commentStamp: '<historical>' prior: 0!

	Copyright (c) 2020-2022 Quorum Software.
	See (MIT) license in root directory.
!

!Allocator methodsFor:  'copying' stamp: 'KenD 28/Jun/2026 13:27:39'!
allocate: anInteger
	^memory allocate: anInteger
! !

!Allocator methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
initialize
	memory := Memory current
! !

!Allocator methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
memory: aMemory
	memory := aMemory
! !

!Allocator methodsFor:  'copying' stamp: 'KenD 28/Jun/2026 13:27:39'!
shallowCopy: array growingTo: newSize
	| headerSize total buffer copy |
	headerSize := 16.
	total := headerSize + (newSize * WordSize).
	buffer := self allocate: total.
	copy := (buffer + headerSize _asPointer) _asObject.
	copy _copyBasicHeaderFrom: array; _makeExtendedSize: newSize; _beUnseen.
	1 to: array _size do: [:index | | original |
		original := array _basicAt: index.
		copy _basicAt: index put: original].
	array _size + 1 to: newSize do: [:i | copy _basicAt: i put: nil].
	(array _isRemembered
		or: [(memory isYoung: copy) not and: [memory pointsToYoungObjects: array]])
		ifTrue: [memory remember: copy]
		ifFalse: [copy _beNotRemembered].
	^copy
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Allocator class' category: #Kernel!
Allocator class
	instanceVariableNames: ''!


Allocator initialize!

