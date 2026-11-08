"
    Copyright (c) 2020 Aucerna.
    See (MIT) license in root directory.
"

Class {
	#name : #ImageSegment,
	#superclass : #Object,
	#instVars : [
		'name',
		'bytes',
		'segmentSize',
		'codeSize',
		'importStrings',
		'importDescriptors',
		'exports',
		'imports'
	],
	#category : #Kernel
}

{ #category : #accessing }
ImageSegment class >> load: filename [
	| contents |
	contents := Kernel host readFile: filename.
	^(self on: contents) install
]

{ #category : #'instance creation' }
ImageSegment class >> on: aString [
	^self new parse: aString
]

{ #category : #accessing }
ImageSegment >> codeSize [
	^codeSize
]

{ #category : #accessing }
ImageSegment >> exports [
	^exports
]

{ #category : #accessing }
ImageSegment >> importDescriptors [
	^importDescriptors
]

{ #category : #accessing }
ImageSegment >> importStrings [
	^importStrings
]

{ #category : #accessing }
ImageSegment >> name [
	^name
]

{ #category : #accessing }
ImageSegment >> name: aString [
	name := aString
]

{ #category : #parsing }
ImageSegment >> parse: aString [
	| offset |
	bytes := aString.
	(bytes copyFrom: 1 to: 7) = 'EGG_IS
' ifFalse: [^self error: 'wrong image segment signature'].
	segmentSize := bytes pointerAtOffset: self sizeOffset.
	codeSize := bytes pointerAtOffset: self codeSizeOffset.
	offset := self readImportStringsAt: self storedSize.
	offset := self readImportDescriptorsAt: offset.
	self readExportsAt: offset
]

{ #category : #parsing }
ImageSegment >> readExportsAt: anInteger [
	| count offset |
	count := bytes uLongAtOffset: anInteger.
	offset := anInteger + self countSize.
	exports := Dictionary new.
	count timesRepeat: [| address length export |
		address := bytes pointerAtOffset: offset.
		length := bytes pointerAtOffset: offset + self exportFieldSize.
		export := bytes copyFrom: offset + self exportHeaderSize + 1 to: offset + self exportHeaderSize + length.
		exports at: export put: address.
		offset := offset + self exportHeaderSize + length]
]

{ #category : #parsing }
ImageSegment >> readImportDescriptorsAt: anInteger [
	| count offset |
	count := bytes uLongAtOffset: anInteger.
	offset := anInteger + self countSize.
	importDescriptors := (1 to: count) collect: [:i | | length descriptor |
		length := bytes uLongAtOffset: offset.
		descriptor := (1 to: length) collect: [:j | bytes uLongAtOffset: offset + (j * self countSize)].
		offset := offset + self countSize + (length * self countSize).
		descriptor].
	^offset
]

{ #category : #parsing }
ImageSegment >> readImportStringsAt: anInteger [
	| count offset |
	count := bytes uLongAtOffset: anInteger.
	offset := anInteger + self countSize.
	importStrings := (1 to: count) collect: [:i | | length string |
		length := bytes uLongAtOffset: offset.
		string := bytes copyFrom: offset + self countSize + 1 to: offset + self countSize + length.
		offset := offset + self countSize + length.
		string].
	^offset
]

{ #category : #accessing }
ImageSegment >> reservedSize [
	^bytes pointerAtOffset: self reservedSizeOffset
]

{ #category : #accessing }
ImageSegment >> segmentSize [
	^segmentSize
]

{ #category : #parsing }
ImageSegment >> storedSize [
	codeSize = 0 ifTrue: [^segmentSize].
	^self codeStart + codeSize
]

{ #category : #accessing }
ImageSegment >> imports [
	^imports
]

{ #category : #linking }
ImageSegment >> link: anArray [
	| descriptor token reference |
	descriptor := anArray collect: [:index | (importStrings at: index + 1) asSymbol].
	descriptor size = 2 ifTrue: [token := descriptor second].
	descriptor size > 2 ifTrue: [token := descriptor allButFirst].
	reference := SymbolicReference linker: descriptor first token: token.
	^reference link
]

{ #category : #linking }
ImageSegment >> linkImports [
	imports := importDescriptors collect: [:descriptor | self link: descriptor].
	^imports
]

{ #category : #accessing }
ImageSegment >> baseAddress [
	^bytes pointerAtOffset: self baseOffset
]

{ #category : #accessing }
ImageSegment >> module [
	^bytes pointerAtOffset: self moduleOffset
]

{ #category : #accessing }
ImageSegment >> codeStart [
	^segmentSize alignedTo: self codeAlignment
]

{ #category : #objects }
ImageSegment >> objectsDo: aBlock [
	self objectsFrom: self headerSize to: segmentSize do: aBlock.
	codeSize = 0 ifFalse: [self objectsFrom: self codeStart to: self codeStart + codeSize do: aBlock]
]

{ #category : #objects }
ImageSegment >> objectsFrom: anInteger to: anotherInteger do: aBlock [
	| offset object |
	offset := anInteger.
	[offset < anotherInteger] whileTrue: [
		object := self objectAt: offset.
		aBlock value: object.
		offset := object + (self bodySizeOf: object)]
]

{ #category : #objects }
ImageSegment >> objectAt: anInteger [
	| flags |
	flags := bytes byteAt: anInteger + self flagsPosition.
	^(flags bitAnd: self smallFlag) = 0
		ifTrue: [anInteger + self largeHeaderSize]
		ifFalse: [anInteger + self smallHeaderSize]
]

{ #category : #objects }
ImageSegment >> flagsOf: anInteger [
	^bytes byteAt: anInteger - self flagsPosition
]

{ #category : #objects }
ImageSegment >> sizeOf: anInteger [
	((self flagsOf: anInteger) bitAnd: self smallFlag) = 0
		ifTrue: [^bytes uLongAtOffset: anInteger - self largeHeaderSize].
	^bytes byteAt: anInteger - self smallSizePosition
]

{ #category : #objects }
ImageSegment >> isBytes: anInteger [
	^((self flagsOf: anInteger) bitAnd: self bytesFlag) = self bytesFlag
]

{ #category : #objects }
ImageSegment >> bodySizeOf: anInteger [
	| size |
	size := self sizeOf: anInteger.
	^(self isBytes: anInteger)
		ifTrue: [size alignedTo: WordSize]
		ifFalse: [size * WordSize]
]

{ #category : #objects }
ImageSegment >> behaviorOf: anInteger [
	^bytes uLongAtOffset: anInteger - self behaviorPosition
]

{ #category : #objects }
ImageSegment >> behaviorOf: anInteger put: anotherInteger [
	bytes uLongAtOffset: anInteger - self behaviorPosition put: anotherInteger
]

{ #category : #objects }
ImageSegment >> slotsOf: anInteger do: aBlock [
	| size |
	(self isBytes: anInteger) ifTrue: [^self].
	size := self sizeOf: anInteger.
	0 to: size - 1 do: [:index | aBlock value: anInteger + (index * WordSize)]
]

{ #category : #relocation }
ImageSegment >> relocateTo: anInteger [
	| base delta block |
	base := self baseAddress.
	delta := anInteger - base.
	block := base - (base bitAnd: self behaviorMask).
	self objectsDo: [:object | self relocate: object by: delta behaviorBlock: block].
	bytes
		pointerAtOffset: self moduleOffset put: self module + delta;
		pointerAtOffset: self baseOffset put: anInteger
]

{ #category : #relocation }
ImageSegment >> relocate: anInteger by: aDelta behaviorBlock: anAddress [
	| behavior relocated |
	behavior := self behaviorOf: anInteger.
	(self isReference: behavior) ifTrue: [
		relocated := anAddress + behavior + aDelta bitAnd: self behaviorMask.
		self behaviorOf: anInteger put: relocated].
	self slotsOf: anInteger do: [:slot | | reference |
		reference := bytes pointerAtOffset: slot.
		(self isReference: reference) ifTrue: [bytes pointerAtOffset: slot put: reference + aDelta]]
]

{ #category : #layout }
ImageSegment >> baseOffset [
	^8
]

{ #category : #layout }
ImageSegment >> sizeOffset [
	^16
]

{ #category : #layout }
ImageSegment >> reservedSizeOffset [
	^24
]

{ #category : #layout }
ImageSegment >> moduleOffset [
	^32
]

{ #category : #layout }
ImageSegment >> codeSizeOffset [
	^40
]

{ #category : #layout }
ImageSegment >> headerSize [
	^48
]

{ #category : #layout }
ImageSegment >> codeAlignment [
	^16r10000
]

{ #category : #layout }
ImageSegment >> smallHeaderSize [
	^8
]

{ #category : #layout }
ImageSegment >> largeHeaderSize [
	^16
]

{ #category : #layout }
ImageSegment >> flagsPosition [
	^4
]

{ #category : #layout }
ImageSegment >> behaviorPosition [
	^4
]

{ #category : #layout }
ImageSegment >> smallSizePosition [
	^5
]

{ #category : #layout }
ImageSegment >> smallFlag [
	^16r80
]

{ #category : #layout }
ImageSegment >> bytesFlag [
	^1
]

{ #category : #layout }
ImageSegment >> behaviorMask [
	^16rFFFFFFFF
]

{ #category : #layout }
ImageSegment >> isReference: anInteger [
	^(anInteger bitAnd: 3) = 0
]

{ #category : #layout }
ImageSegment >> countSize [
	^4
]

{ #category : #layout }
ImageSegment >> exportFieldSize [
	^8
]

{ #category : #layout }
ImageSegment >> exportHeaderSize [
	^16
]

{ #category : #linking }
ImageSegment >> bindImports: anArray [
	self objectsDo: [:object | self bind: object to: anArray]
]

{ #category : #linking }
ImageSegment >> bind: anInteger to: anArray [
	| behavior reference |
	behavior := self behaviorOf: anInteger.
	(self isImport: behavior) ifTrue: [
		reference := self referenceAt: behavior in: anArray.
		self behaviorOf: anInteger put: (reference bitAnd: self behaviorMask)].
	self slotsOf: anInteger do: [:slot | | external |
		external := bytes pointerAtOffset: slot.
		(self isImport: external) ifTrue: [
			reference := self referenceAt: external in: anArray.
			bytes pointerAtOffset: slot put: reference]]
]

{ #category : #linking }
ImageSegment >> referenceAt: anInteger in: anArray [
	| import |
	import := anArray at: (self importIndexOf: anInteger).
	^import _isSmallInteger ifTrue: [import * 2 + 1] ifFalse: [import _oop]
]

{ #category : #layout }
ImageSegment >> isImport: anInteger [
	^(anInteger bitAnd: 3) = 2
]

{ #category : #layout }
ImageSegment >> importIndexOf: anInteger [
	^(anInteger bitShift: -2) + 1
]

{ #category : #installing }
ImageSegment >> install [
	| host address |
	host := Kernel host.
	address := Kernel os reserveAndCommit: self reservedSize.
	self
		relocateTo: address;
		linkImports;
		bindImports: imports.
	host libc memcpy: address from: bytes size: self storedSize.
	codeSize = 0 ifFalse: [host makeExecutable: address + self codeStart size: codeSize].
	^(self module // 2) _asObject
]
