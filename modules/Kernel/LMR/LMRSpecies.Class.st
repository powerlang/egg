'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:38 pm'!
!classDefinition: #LMRSpecies category: #Kernel!
ProtoObject subclass: #LMRSpecies
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Kernel'!
!LMRSpecies commentStamp: '<historical>' prior: 0!

	Copyright (c) 2022, Javier Pimás.
	See (MIT) license in root directory.
!

!LMRSpecies methodsFor:  'Primitives' stamp: 'KenD 28/Jun/2026 13:27:38'!
allocate: byteSize size: size
	| headerSize totalSize buffer object extended |
	extended := size > 255.
	headerSize := extended ifTrue: [16] ifFalse: [8].
	totalSize := headerSize + byteSize.
	buffer := self memory allocate: totalSize.
	object := (buffer + headerSize _asPointer) _asObject.
	object
		_basicULongAt: _Behavior put: self instanceBehavior;
		initializeExtended: extended contentSize: size.
	^object
! !

!LMRSpecies methodsFor:  'Primitives' stamp: 'KenD 28/Jun/2026 13:27:38'!
basicNew
	^self _instancesAreArrayed
		ifTrue: [self primitiveNew: 0]
		ifFalse: [self primitiveNew]! !

!LMRSpecies methodsFor:  'Primitives' stamp: 'KenD 28/Jun/2026 13:27:38'!
basicNew: anInteger
	^self primitiveNew: anInteger
! !

!LMRSpecies methodsFor:  'Primitives' stamp: 'KenD 28/Jun/2026 13:27:38'!
memory
	^Memory current
! !

!LMRSpecies methodsFor:  'Primitives' stamp: 'KenD 28/Jun/2026 13:27:38'!
new
	^self _instancesAreArrayed
		ifTrue: [self primitiveNew: 0]
		ifFalse: [self primitiveNew]
! !

!LMRSpecies methodsFor:  'Primitives' stamp: 'KenD 28/Jun/2026 13:27:38'!
new: anInteger
	^self primitiveNew: anInteger
! !

!LMRSpecies methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:27:38'!
nil: size slotsOf: object
	object _nilSlots: size
! !

!LMRSpecies methodsFor:  'Primitives' stamp: 'KenD 28/Jun/2026 13:27:38'!
primitiveNew
	^self memory newPointers: instanceBehavior size: self instSize
! !

!LMRSpecies methodsFor:  'Primitives' stamp: 'KenD 28/Jun/2026 13:27:38'!
primitiveNew: size
	size _isSmallInteger ifFalse: [self error: 'invalid size'].
	self _instancesAreArrayed ifFalse: [self errorNotIndexable].
	^self _instancesHavePointers
		ifTrue: [self primitiveNewPointers: size + self instSize]
		ifFalse: [self primitiveNewBytes: size]
! !

!LMRSpecies methodsFor:  'Primitives' stamp: 'KenD 28/Jun/2026 13:27:38'!
primitiveNewBytes: size
	^self memory newArrayedBytes: instanceBehavior size: size
! !

!LMRSpecies methodsFor:  'Primitives' stamp: 'KenD 28/Jun/2026 13:27:38'!
primitiveNewPointers: size
	^self memory
		newArrayedPointers: instanceBehavior
		size: size
		named: self instSize > 0
! !

!LMRSpecies methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:27:38'!
zero: size bytesOf: object
	object _zeroSlots: (size bitShift: 0 - WordSizeShift)
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'LMRSpecies class' category: #Kernel!
LMRSpecies class
	instanceVariableNames: ''!


