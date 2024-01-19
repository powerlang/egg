"
    Copyright (c) 2024, Javier Pimás.
    See (MIT) license in root directory.
"

Class {
	#name : #ProcessNativeStack,
	#superclass : #ProcessStack,
	#instVars : [
		'base',
		'limit',
		'topChunk',
		'locked',
		'ffiStream'
	],
	#category : #Kernel
}

{ #category : #private }
ProcessNativeStack >> bp [
	^topChunk bp
]

{ #category : #private }
ProcessNativeStack >> bp: anInteger [
	topChunk bp: anInteger
]

{ #category : #private }
ProcessNativeStack >> bpIndex [
	^self stackIndexFromPointer: topChunk bp
]

{ #category : #private }
ProcessNativeStack >> bpIndex: anInteger [
	| pointer |
	pointer := self stackPointerFromIndex: anInteger.
	topChunk bp: pointer
]

ProcessNativeStack >> ffiStream [
	"
		ffi stream is reused and lazily initialized for performance. When being used,
		ffiStream ivar is niled out so that recursive uses (which are extremely rare)
		do not overwrite the contents of the stream.
	"
	| result |
	result := ffiStream ifNil: [(ByteArray new: 1024) writeStream].
	ffiStream := nil.
	^result
]

ProcessNativeStack >> ffiStream: aWriteStream [
	ffiStream := aWriteStream
]

ProcessNativeStack >> frameIndex [
	self errorVMSpecific
]

ProcessNativeStack >> initialize [
	super initialize.
	locked := false.
	topChunk := ProcessStackChunk new.
	self allocateStack
]

ProcessNativeStack >> invalidate [
	base := limit := topChunk := process := thread := nil
]

ProcessNativeStack >> isLocked [
	^locked
]

ProcessNativeStack >> isNative [
	^true
]

ProcessNativeStack >> isValid [
	^base notNil
]

ProcessNativeStack >> limit [
	^limit
]

ProcessNativeStack >> lock [
	"
	We have to be very careful updating the stack pointers of a process.
	When already locked, updates will be ignored. There are (at least) two important
	places: (1) GC and (2) FFI calls.
	(1) At the beginning of GC we lock the active process' stack to be able to
	scan its pointers. FFI calls during GC won't re-update the stack pointers (which
	is what we want) because the stack is locked.
	(2) Before an FFI call we lock the stack. It will be unlocked either on exit or
	either on reentry if the FFI call causes a callback.
	"
	| prev |
	prev := locked.
	locked := true.
	^prev
]

ProcessNativeStack >> printOn: aStream [
	aStream nextPutAll: 'NativeStack of ' , process printString
]

ProcessStack >> release [
	self isValid ifFalse: [^self].
	Kernel critical: [
		OS release: (self bufferLimit * 2) asParameter.
		self invalidate; unregister]
]

ProcessStack >> relocate: anInteger [
	base := base + anInteger.
	limit := limit + anInteger
]

ProcessStack >> size [
	^base - limit // (WordSize // 2)
]

{ #category : #private }
ProcessNativeStack >> sp [
	^topChunk sp
]

{ #category : #private }
ProcessNativeStack >> sp: anInteger [
	topChunk sp: anInteger
]

{ #category : #private }
ProcessNativeStack >> spIndex [
	^self stackIndexFromPointer: topChunk sp
]

{ #category : #private }
ProcessNativeStack >> spIndex: anInteger [
	| pointer |
	pointer := self stackPointerFromIndex: anInteger.
	topChunk sp: pointer
]

{ #category : #private }
ProcessNativeStack >> stackIndexFromPointer: address [
	^address == 0
		ifTrue: [0]
		ifFalse: [address - limit // WordSize _asPointer + 1]
]

{ #category : #private }
ProcessNativeStack >> stackPointerFromIndex: index [
	^limit + (index - 1 * WordSize _asPointer)
]

{ #category : #private }
ProcessNativeStack >> unlock [
	locked := false
]

{ #category : #private }
ProcessNativeStack >> usedSize [
	^base - topChunk sp // (WordSize // 2)
]
