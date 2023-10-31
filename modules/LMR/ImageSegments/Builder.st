"
    Copyright (c) 2022, Javier Pimás.
    See (MIT) license in root directory.
"

Class {
	#name : #Builder,
	#superclass : #Object,
	#instVars : [
		'stream',
		'objects',
		'space',
		'nextHash',
		'offsets',
		'size',
		'base',
		'module',
		'wordSize',
		'roots',
		'index'
	],
	#category : #'Builder'
}

{ #category : #accessing }
Builder class >> behaviorOffset [
	"
		The offset at which the behavior is from the oop (negated)
	"

	^ -4
]

{ #category : #accessing }
Builder class >> nilOffset [
	^self objectsOffset + 8
]

{ #category : #accessing }
Builder class >> objectsOffset [
	"
		The offset at which header terminates and objects are stored.
		See ImageSegment.h for structure of a segment header
	"
	^40
]

{ #category : #services }
Builder >> add: anObject [
	offsets at: anObject put: nil.
	objects add: anObject
]

{ #category : #closure }
Builder >> addClosure [
	closure := ModuleClosure new module: module; builder: self.
	closure traverse: roots.
]

{ #category : #querying }
Builder >> alreadyAdded: anObject [
	^offsets includesKey: b
]

{ #category : #accessing }
Builder >> base [
	"
		Return preferred base address for this segment
	"
	^ base
]

{ #category : #accessing }
Builder >> base: anInteger [
	"
	 Set the preferred base address for this segment. 
	 This is a hint only, loaders may load a segment
	 at a different address but then they must relocate.
	"
	base := anInteger
]

{ #category : #accessing }
Builder >> configureSpace [
	| basemap free limit |
	basemap := base // 2.
	free := base + size // 2.
	limit := base + size + 16r20000 // 2.
	space
		base: basemap;
		nextFree: free;
		softLimit: limit;
		commitedLimit: limit;
		reservedLimit: limit
]

{ #category : #accessing }
Builder >> encodedReferenceTo: anObject [
	| offset |
	anObject _isSmallInteger
		ifTrue: [ ^ anObject value * 2 + 1 ].
	offset := offsets at: anObject.
	^base + offset
]

{ #category : #accessing }
Builder >> image [
	^stream contents
]

{ #category : #accessing }
Builder >> initialize [
	offsets := IdentityDictionary new.
	objects := OrderedCollection new.
	stream := ByteArray new writeStream.
	nextHash := 1.
	base := 0
]

{ #category : #accessing }
Builder >> layoutObjects [
	| offset oop |
	offset := self objectsOffset.
	objects
		do: [ :obj | 
			oop := offset + obj headerSizeInBytes.
			offsets at: obj put: oop.
			offset := oop + obj bodySizeInBytes ].
	size := offset
]

{ #category : #initialization }
Builder >> module: aModule [
	module := aModule
]

{ #category : #accessing }
Builder >> nextHash [
	"
		Local version of ProtoObject>>basicHash
	"
	
	| result shifted |
	result := nextHash.	
	shifted := nextHash bitShift: -1.
	nextHash := (nextHash bitAnd: 1) = 0
		ifTrue: [shifted]
		ifFalse: [shifted bitXor: 16rB9C8].
	^result
]

{ #category : #initialization }
Builder >> objects [
	^ objects
]

{ #category : #accessing }
Builder >> objectsOffset [
	^self class objectsOffset
]

{ #category : #accessing }
Builder >> offsetOf: anObject [
	^ offsets at: anObject
]

{ #category : #initialization }
Builder >> roots: aCollection [
	roots := aCollection
]

{ #category : #initialization }
Builder >> space: aGCSpace [
	space := aGCSpace
]

{ #category : #accessing }
Builder >> stream: aWriteStream [
	stream := aWriteStream
]

{ #category : #accessing }
Builder >> wordSize: anInteger [
	wordSize := anInteger
]

{ #category : #accessing }
Builder >> write [
	module prepareForSnapshot: self.
	self
		addClosure;
		layoutObjects;
		configureSpace;
		writeSignature;
		writeHeader;
		writeObjects
]

{ #category : #'own services' }
Builder >> writeHeader [
	"See ImageSegment.h for structure of a segment header"
	| reserved |
	reserved := (space reservedLimit value - space base value) * 2.
	stream uint64le: base; uint64le: size; uint64le: reserved.
	self writeReferenceTo: module
]

{ #category : #accessing }
Builder >> writeObjectBody: obj [
	obj isBytes
		ifTrue: [ self writeObjectBytes: obj ]
		ifFalse: [ self writeObjectSlots: obj ]
]

{ #category : #accessing }
Builder >> writeObjectBytes: obj [
	| current aligned |
	stream nextPutAll: obj bytes.
	current := stream position.
	aligned := current alignedTo: wordSize.
	aligned - current timesRepeat: [ stream nextPut: 0 ]

]

{ #category : #accessing }
Builder >> writeObjectHeader: obj [
	| behavior |
	obj isSmall
		ifFalse: [ stream
				uint32le: obj size;
				uint32le: 0 ].
	behavior := self encodedReferenceTo: obj behavior.
	stream
		uint16le: obj headerHash;
		nextPut: obj headerSmallSize;
		nextPut: obj headerFlags;
		uint32le: behavior.
	self ASSERT: stream position == (self offsetOf: obj)
]

{ #category : #accessing }
Builder >> writeObjectSlots: obj [
	obj slots do: [ :slot | self writeReferenceTo: slot ].

]

{ #category : #accessing }
Builder >> writeObjects [
	self ASSERT: stream position == self objectsOffset.
	objects
		do: [ :obj | 
			self
				writeObjectHeader: obj;
				writeObjectBody: obj ]
]

{ #category : #accessing }
Builder >> writeReferenceTo: slot [
	| encoded |
	encoded := self encodedReferenceTo: slot.
	wordSize = 8
		ifFalse: [ self ASSERT: false ].
	stream uint64le: encoded
]

{ #category : #accessing }
Builder >> writeSignature [
	stream
		nextPutAll: 'P_IM_S' asByteArray;
		nextPut: Character lf asInteger;
		nextPut: 0
]

{ #category : #writing }
Builder >> writeTo: aStream [
	self stream: aStream; write.

]

{ #category : #writing }
Builder >> writeToFile: filename [
	filename binaryWriteStreamDo: [ :s | self writeTo: byteStream ]
]

