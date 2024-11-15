"
    Copyright (c) 2022-2024, Javier Pimás.
    See (MIT) license in root directory.
"

Class {
	#name : #NativeWriter,
	#superclass : #Writer,
	#instVars : [
		'importStrings',
		'offsets',
		'size',
		'base',
		'wordSize'
	],
	#category : #'Native'
}

{ #category : #accessing }
NativeWriter class >> behaviorOffset [
	"
		The offset at which the behavior is from the oop (negated)
	"

	^ -4
]

{ #category : #accessing }
NativeWriter class >> nilOffset [
	^self objectsOffset + 8
]

{ #category : #accessing }
NativeWriter class >> objectsOffset [
	"
		The offset at which header terminates and objects are stored.
		See ImageSegment.h in runtime/cpp for structure of a segment header
	"
	^40
]


{ #category : #accessing }
NativeWriter >> base [
	"
		Return preferred base address for this segment
	"
	^ base
]

{ #category : #accessing }
NativeWriter >> base: anInteger [
	"
	 Set the preferred base address for this segment. 
	 This is a hint only, loaders may load a segment
	 at a different address but then they must relocate.
	"
	base := anInteger
]

{ #category : #accessing }
NativeWriter >> closure: anObjectClosure [
	super closure: anObjectClosure.
]

{ #category : #private }
NativeWriter >> addImportString: aSymbol [
	(importStrings includesKey: aSymbol) ifTrue: [^self].
	importStrings at: aSymbol put: importStrings size.
]

{ #category : #private }
NativeWriter >> computeImportStrings [
	imports do: [:import |
		self addImportString: import linker.
		import token ifNotNil: [:token |
			(token isString or: [token isSymbol])
				ifTrue: [self addImportString: token]
				ifFalse: [token do: [:s | self addImportString: s]]]
	]
]

{ #category : #accessing }
NativeWriter >> encodedReferenceTo: anObject [
	| key offset |
	anObject _isSmallInteger
		ifTrue: [ ^ anObject value * 2 + 1 ].
	
	key := HashTable nilToken == anObject ifTrue: [closure nilToken] ifFalse: [anObject].
	offset := offsets at: key.
	
	(offset bitAnd: 0x2) == 0x2 ifTrue: [^offset].
	^base + offset
]

{ #category : #accessing }
NativeWriter >> image [
	^stream contents
]

{ #category : #accessing }
NativeWriter >> initialize [
	base := 0x1000000.
	wordSize := 8.
	importStrings := Dictionary new.
	offsets := IdentityDictionary new.
	stream := #[] writeStream
]

{ #category : #accessing }
NativeWriter >> objectHeaderSizeInBytes: anObject [
	^anObject _isLarge ifTrue: [16] ifFalse: [8]
]

{ #category : #'header access' }
NativeWriter >> objectIsBytes: anObject [
	^(anObject _basicFlags bitAnd: IsBytes) = IsBytes
]

{ #category : #'*header access' }
NativeWriter >> objectSize: anObject [
	^anObject _isLarge
		ifTrue: [anObject _largeSize]
		ifFalse: [anObject _smallSize]
]

{ #category : #accessing }
NativeWriter >> objectSizeInBytes: anObject [
	| total |
	total := self objectSize: anObject.
	^(self objectIsBytes: anObject)
		ifTrue: [total + wordSize - 1 bitAnd: 0 - wordSize]
		ifFalse: [total * wordSize]
]

{ #category : #private }
NativeWriter >> layoutImport: anObject at: anInteger [
	| encoded |
	encoded := anInteger << 2 | 0x2.
	offsets at: anObject put: encoded.
]

{ #category : #private }
NativeWriter >> layoutObject: obj at: offset [
	| oop |
	oop := offset + (self objectHeaderSizeInBytes: obj).
	offsets at: obj put: oop.
	^oop + (self objectSizeInBytes: obj).
]

{ #category : #private }
NativeWriter >> layoutObjects [
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
]

{ #category : #accessing }
NativeWriter >> objectsOffset [
	^self class objectsOffset
]

{ #category : #accessing }
NativeWriter >> offsetOf: anObject [
	^ offsets at: anObject
]

{ #category : #accessing }
NativeWriter >> wordSize: anInteger [
		wordSize := anInteger
]

{ #category : #accessing }
NativeWriter >> write [
	self
		computeImportStrings;
		layoutObjects;
		writeSignature;
		writeHeader;
		writeObjects;
		writeImportStrings;
		writeImports;
		writeExports
]

{ #category : #'own services' }
NativeWriter >> writeExports [
	stream nextULongPut: exports size.
	exports keys
		do: [ :name | | object encoded |
			object := exports at: name.
			encoded := self encodedReferenceTo: object.
			stream
				nextULargePut: encoded;
				nextULargePut: name size;
				nextPutAll: name]
]

{ #category : #'own services' }
NativeWriter >> writeHeader [
	"See ImageSegment.h in runtimes/cpp for structure of a segment header"
	stream nextULargePut: base; nextULargePut: size; nextULargePut: size + 16r20000.
	self writeReferenceTo: closure module
]

{ #category : #'*snapshotting' }
NativeWriter >> writeImportLinker: linker [
	"
		linker can be 
	"
	linker ifNil: [^stream nextULongPut: 0].
	stream nextULongPut: 1; nextULongPut: linker size; nextPutAll: linker
]

{ #category : #'*snapshotting' }
NativeWriter >> writeImportToken: token [
	"
		token can be a string or a collection of strings. In first case, a
		type 0 is put first, then strings. Else collection size (>0) is put
		first. Then the strings.
	"
	token isString ifTrue: [^stream nextULongPut: 0; nextULongPut: token size; nextPutAll: token].
	stream nextULongPut: token size.
	token
		do: [:str | stream nextULongPut: str size; nextPutAll: str]
]

{ #category : #writing }
NativeWriter >> writeImport: aSymbolicReference [

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
]

{ #category : #'own services' }
NativeWriter >> writeImports [
	stream nextULongPut: imports size.
	imports do: [ :symref | self writeImport: symref]
]

{ #category : #'own services' }
NativeWriter >> writeImportStrings [
	| sorted |
	sorted := Array new: importStrings size.
	importStrings keysAndValuesDo: [:symref :subscript | sorted at: subscript + 1 put: symref].

	stream nextULongPut: importStrings size.
	sorted do: [ :string |
		stream nextULongPut: string size; nextPutAll: string ]
]

{ #category : #accessing }
NativeWriter >> writeObjectBody: obj [
	(self objectIsBytes: obj)
		ifTrue: [ self writeObjectBytes: obj ]
		ifFalse: [ self writeObjectSlots: obj ]
]

{ #category : #accessing }
NativeWriter >> writeObjectBytes: obj [
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
]

{ #category : #accessing }
NativeWriter >> writeObjectHeader: obj [
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
]

{ #category : #accessing }
NativeWriter >> writeObjectSlots: obj [
	1 to: (self objectSize: obj) do: [ :i | self writeReferenceTo: (obj _basicAt: i) ].
]

{ #category : #accessing }
NativeWriter >> writeObjects [
	self ASSERT: stream position == self objectsOffset.
	objects do: [ :obj |
		obj _isSmallInteger ifFalse: [ self writeObjectHeader: obj; writeObjectBody: obj ]]
]

{ #category : #accessing }
NativeWriter >> writeReferenceTo: slot [
	| encoded |
	encoded := self encodedReferenceTo: slot.
	wordSize = 8
		ifFalse: [ self ASSERT: false ].
	stream nextULargePut: encoded
]

{ #category : #accessing }
NativeWriter >> writeSignature [
	stream
		nextPutAll: 'EGG_IS' asByteArray;
		nextPut: Character lf asInteger;
		nextPut: 0
]
