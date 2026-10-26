'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:39 pm'!
!classDefinition: #NativeWriter category: #Native!
Writer subclass: #NativeWriter
	instanceVariableNames: 'importStrings offsets size base wordSize'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Native'!
!NativeWriter commentStamp: '<historical>' prior: 0!

    Copyright (c) 2022-2024, Javier Pimás.
    See (MIT) license in root directory.
!

!NativeWriter methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
base
	"
		Return preferred base address for this segment
	"
	^ base
! !

!NativeWriter methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
base: anInteger
	"
	 Set the preferred base address for this segment. 
	 This is a hint only, loaders may load a segment
	 at a different address but then they must relocate.
	"
	base := anInteger
! !

!NativeWriter methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
closure: anObjectClosure
	super closure: anObjectClosure.
! !

!NativeWriter methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:39'!
addImportString: aSymbol
	(importStrings includesKey: aSymbol) ifTrue: [^self].
	importStrings at: aSymbol put: importStrings size.
! !

!NativeWriter methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:39'!
computeImportStrings
	imports do: [:import |
		self addImportString: import linker.
		import token ifNotNil: [:token |
			token isString
				ifTrue: [self addImportString: token]
				ifFalse: [token do: [:s | self addImportString: s]]]
	]
! !

!NativeWriter methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
encodedReferenceTo: anObject
	| key offset |
	anObject _isSmallInteger
		ifTrue: [ ^ anObject value * 2 + 1 ].
	
	key := HashTable nilToken == anObject ifTrue: [closure nilToken] ifFalse: [anObject].
	offset := offsets at: key.
	
	(offset bitAnd: 0x2) == 0x2 ifTrue: [^offset].
	^base + offset
! !

!NativeWriter methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
image
	^stream contents
! !

!NativeWriter methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
initialize
	base := 0x1000000.
	wordSize := 8.
	importStrings := Dictionary new.
	offsets := IdentityDictionary new.
	stream := #[] writeStream
! !

!NativeWriter methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
objectHeaderSizeInBytes: anObject
	^anObject _isLarge ifTrue: [16] ifFalse: [8]
! !

!NativeWriter methodsFor:  'header access' stamp: 'KenD 28/Jun/2026 13:27:39'!
objectIsBytes: anObject
	^(anObject _basicFlags bitAnd: IsBytes) = IsBytes
! !

!NativeWriter methodsFor:  '*header access' stamp: 'KenD 28/Jun/2026 13:27:39'!
objectSize: anObject
	^anObject _isLarge
		ifTrue: [anObject _largeSize]
		ifFalse: [anObject _smallSize]
! !

!NativeWriter methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
objectSizeInBytes: anObject
	| total |
	total := self objectSize: anObject.
	^(self objectIsBytes: anObject)
		ifTrue: [total + wordSize - 1 bitAnd: 0 - wordSize]
		ifFalse: [total * wordSize]
! !

!NativeWriter methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:39'!
layoutImport: anObject at: anInteger
	| encoded |
	encoded := anInteger << 2 | 0x2.
	offsets at: anObject put: encoded.
! !

!NativeWriter methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:39'!
layoutObject: obj at: offset
	| oop |
	oop := offset + (self objectHeaderSizeInBytes: obj).
	offsets at: obj put: oop.
	^oop + (self objectSizeInBytes: obj).
! !

!NativeWriter methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:39'!
layoutObjects
	| offset subscript |
	offset := self objectsOffset.
	objects
		do: [ :obj |
			obj _isSmallInteger ifFalse: [ 
				offset := self layoutObject: obj at: offset]].
	size := offset.
	subscript := 0.
	imports keysDo: [ :obj | self layoutImport: obj at: subscript. subscript := subscript + 1].	
	mapping keysAndValuesDo: [:obj :surrogate |
		offsets at: surrogate ifPresent: [:o | offsets at: obj put: o]].
! !

!NativeWriter methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
objectsOffset
	^self class objectsOffset
! !

!NativeWriter methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
offsetOf: anObject
	^ offsets at: anObject
! !

!NativeWriter methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
wordSize: anInteger
		wordSize := anInteger
! !

!NativeWriter methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
write
	self
		computeImportStrings;
		layoutObjects;
		writeSignature;
		writeHeader;
		writeObjects;
		writeImportStrings;
		writeImports;
		writeExports
! !

!NativeWriter methodsFor:  'own services' stamp: 'KenD 28/Jun/2026 13:27:39'!
writeExports
	stream nextULongPut: exports size.
	exports keys
		do: [ :name | | object encoded |
			object := exports at: name.
			encoded := self encodedReferenceTo: object.
			stream
				nextULargePut: encoded;
				nextULargePut: name size;
				nextPutAll: name]
! !

!NativeWriter methodsFor:  'own services' stamp: 'KenD 28/Jun/2026 13:27:39'!
writeHeader
	"See ImageSegment.h in runtimes/cpp for structure of a segment header"
	stream nextULargePut: base; nextULargePut: size; nextULargePut: size + 16r20000.
	self writeReferenceTo: closure module
! !

!NativeWriter methodsFor:  '*snapshotting' stamp: 'KenD 28/Jun/2026 13:27:39'!
writeImportLinker: linker
	"
		linker can be 
	"
	linker ifNil: [^stream nextULongPut: 0].
	stream nextULongPut: 1; nextULongPut: linker size; nextPutAll: linker
! !

!NativeWriter methodsFor:  '*snapshotting' stamp: 'KenD 28/Jun/2026 13:27:39'!
writeImportToken: token
	"
		token can be a string or a collection of strings. In first case, a
		type 0 is put first, then strings. Else collection size (>0) is put
		first. Then the strings.
	"
	token isString ifTrue: [^stream nextULongPut: 0; nextULongPut: token size; nextPutAll: token].
	stream nextULongPut: token size.
	token
		do: [:str | stream nextULongPut: str size; nextPutAll: str]
! !

!NativeWriter methodsFor:  'writing' stamp: 'KenD 28/Jun/2026 13:27:39'!
writeImport: aSymbolicReference

	| descriptor subscript |
	descriptor := OrderedCollection with: aSymbolicReference linker.
	aSymbolicReference token ifNotNil: [:token |
						token isString 
							ifTrue: [descriptor add: token]
							ifFalse: [descriptor addAll: token]].

	stream nextULongPut: descriptor size.
	descriptor do: [:str |
		subscript := importStrings at: str.
		stream nextULongPut: subscript].
! !

!NativeWriter methodsFor:  'own services' stamp: 'KenD 28/Jun/2026 13:27:39'!
writeImports
	stream nextULongPut: imports size.
	imports do: [ :symref | self writeImport: symref]
! !

!NativeWriter methodsFor:  'own services' stamp: 'KenD 28/Jun/2026 13:27:39'!
writeImportStrings
	| sorted |
	sorted := Array new: importStrings size.
	importStrings keysAndValuesDo: [:symref :subscript | sorted at: subscript + 1 put: symref].

	stream nextULongPut: importStrings size.
	sorted do: [ :string |
		stream nextULongPut: string size; nextPutAll: string ]
! !

!NativeWriter methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
writeObjectBody: obj
	(self objectIsBytes: obj)
		ifTrue: [ self writeObjectBytes: obj ]
		ifFalse: [ self writeObjectSlots: obj ]
! !

!NativeWriter methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
writeObjectBytes: obj
	| initial written size misalignment padding |
	initial := stream position.
	stream nextPutAll: obj.
	written := stream position - initial.

	size := self objectSize: obj.
	size - written timesRepeat: [ stream nextPut: 0 ].

	misalignment := size bitAnd: wordSize - 1.
	misalignment = 0 ifTrue: [^self].
	
	padding := wordSize - misalignment.
	padding timesRepeat: [ stream nextPut: 0 ]
! !

!NativeWriter methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
writeObjectHeader: obj
	| smallsize behavior |
	obj _isLarge
		ifTrue: [
			stream
				nextULongPut: obj _largeSize;
				nextULongPut: 0.
			smallsize := 0]
		ifFalse: [
			smallsize := obj _smallSize].
	behavior := self encodedReferenceTo: obj behavior.
	stream
		nextUShortPut: obj _basicHash;
		nextPut: smallsize;
		nextPut: obj _basicFlags;
		nextULongPut: behavior.
	self ASSERT: stream position == (self offsetOf: obj)
! !

!NativeWriter methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
writeObjectSlots: obj
	1 to: (self objectSize: obj) do: [ :i | self writeReferenceTo: (obj _basicAt: i) ].
! !

!NativeWriter methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
writeObjects
	self ASSERT: stream position == self objectsOffset.
	objects do: [ :obj |
		obj _isSmallInteger ifFalse: [ self writeObjectHeader: obj; writeObjectBody: obj ]]
! !

!NativeWriter methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
writeReferenceTo: slot
	| encoded |
	encoded := self encodedReferenceTo: slot.
	wordSize = 8
		ifFalse: [ self ASSERT: false ].
	stream nextULargePut: encoded
! !

!NativeWriter methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
writeSignature
	stream
		nextPutAll: 'EGG_IS' asByteArray;
		nextPut: Character lf asInteger;
		nextPut: 0
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'NativeWriter class' category: #Native!
NativeWriter class
	instanceVariableNames: ''!

!NativeWriter class methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
behaviorOffset
	"
		The offset at which the behavior is from the oop (negated)
	"

	^ -4
! !

!NativeWriter class methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
nilOffset
	^self objectsOffset + 8
! !

!NativeWriter class methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
objectsOffset
	"
		The offset at which header terminates and objects are stored.
		See ImageSegment.h in runtime/cpp for structure of a segment header
	"
	^40
! !


NativeWriter initialize!

