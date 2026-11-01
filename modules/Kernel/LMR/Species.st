"
	Copyright (c) 2022, Javier Pimás.
	See (MIT) license in root directory.
"

Class {
	#name : #LMRSpecies,
	#superclass : #Species,
	#category : #Kernel
}

{ #category : 'Primitives' }
LMRSpecies >> allocate: byteSize size: size [
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
]

{ #category : 'Primitives' }
LMRSpecies >> basicNew [
	^self _instancesAreArrayed
		ifTrue: [self primitiveNew: 0]
		ifFalse: [self primitiveNew]]

{ #category : 'Primitives' }
LMRSpecies >> basicNew: anInteger [
	^self primitiveNew: anInteger
]

{ #category : 'Primitives' }
LMRSpecies >> memory [
	^Memory current
]

{ #category : 'Primitives' }
LMRSpecies >> new [
	^self _instancesAreArrayed
		ifTrue: [self primitiveNew: 0]
		ifFalse: [self primitiveNew]
]

{ #category : 'Primitives' }
LMRSpecies >> new: anInteger [
	^self primitiveNew: anInteger
]

{ #category : #'instance creation' }
LMRSpecies >> nil: size slotsOf: object [
	object _nilSlots: size
]

{ #category : 'Primitives' }
LMRSpecies >> primitiveNew [
	^self primitiveNewPointers: self instSize arrayed: false
]

{ #category : 'Primitives' }
LMRSpecies >> primitiveNew: size [
	size _isSmallInteger ifFalse: [self error: 'invalid size'].
	self _instancesAreArrayed ifFalse: [self errorNotIndexable].
	^self _instancesHavePointers
		ifTrue: [self primitiveNewPointers: size + self instSize]
		ifFalse: [self primitiveNewBytes: size]
]

{ #category : 'Primitives' }
LMRSpecies >> primitiveNewBytes: size [
	| byteSize object |
	byteSize := size + WordSize - 1 bitAnd: 0 - WordSize.
	object := self allocate: byteSize size: size.
	self zero: byteSize bytesOf: object.
	object _beBytes; _beArrayed.
	^object
]

{ #category : 'Primitives' }
LMRSpecies >> primitiveNewPointers: size [
	"size counts the named slots too"
	^self primitiveNewPointers: size arrayed: true
]

{ #category : 'Primitives' }
LMRSpecies >> primitiveNewPointers: size arrayed: aBoolean [
	| object |
	object := self allocate: size * WordSize size: size.
	self nil: size slotsOf: object.
	aBoolean ifTrue: [object _beArrayed].
	self instSize > 0 ifTrue: [object _beNamed].
	^object
]

{ #category : #'instance creation' }
LMRSpecies >> zero: size bytesOf: object [
	object _zeroSlots: (size bitShift: 0 - WordSizeShift)
]

