"
    Copyright (c) 2020 Aucerna. 
    See (MIT) license in root directory.
"

Class {
	#name : #ProtoObject,
	#superclass : nil,
	#category : #Kernel
}

{ #category : #initialization }
ProtoObject class >> initializeBitMasks [
	"
	self initializeBitMasks
	"
	self addNamespaceAs: #ObjectBitsMasks.
	ObjectBitsMasks
		at: #IsBytes put: 16r1;
		at: #IsArrayed put: 16r2;
		at: #IsNamed put: 16r4;
		at: #IsRemembered put: 16r8;
		at: #IsSpecial put: 16r10;
		at: #Bit1 put: 16r20;
		at: #IsSecondGeneration put: 16r40;
		at: #IsSmall put: 16r80;
		at: #HasBeenSeen put: 16r20.
	ObjectBitsMasks keys
		do: [:key | ObjectBitsMasks
			at: key , 'Mask'
			put: 16rFF - (ObjectBitsMasks at: key)]
]

{ #category : #initialization }
ProtoObject class >> initializeConstants [
	"
	ProtoObject initializeConstants
	"
	self addNamespaceAs: #ObjectFieldsOffset.
	ObjectFieldsOffset
		at: #_Behavior put: 0;
		at: #_Reserved put: -2;
		at: #_ExtendedSize put: -3;
		at: #_Flags put: -5;
		at: #_SmallSize put: -6;
		at: #_Hash put: -8
]

{ #category : #'instance creation' }
ProtoObject class >> new [
	^self basicNew initialize
]

{ #category : #comparing }
ProtoObject >> !== anObject [
	^self == anObject ifTrue: [false] ifFalse: [true]
]

{ #category : #underprimitives }
ProtoObject >> _basicAt: anInteger [
	^self errorVMSpecific
]

{ #category : #'header access' }
ProtoObject >> _copyBasicHeaderFrom: other [
	self errorVMSpecific
]

{ #category : #'header access' }
ProtoObject >> _copyHeaderSized: byteSize from: anObject [
	self errorVMSpecific
]

{ #category : #'header access' }
ProtoObject >> _doesNotUnderstand: selector with: arguments [
	"
		Only the VM sends this. To adapt a message send with arguments in the
		stack onto a Message object with a selector and an array of arguments
	"
	| message result |
	message := Message selector: selector arguments: arguments.
	result := self doesNotUnderstand: message.
	^result _returnPoppingArguments: 2
]

{ #category : #'header access' }
ProtoObject >> _hash [
	^self errorVMSpecific
]

{ #category : #'header access' }
ProtoObject >> _isBytes [
	^self errorVMSpecific
]

{ #category : #'header access' }
ProtoObject >> _pointersSize [
	^self errorVMSpecific
]

{ #category : #'header access' }
ProtoObject >> _size [
	^self errorVMSpecific
]

{ #category : #comparing }
ProtoObject >> ~~ anObject [
	^self == anObject ifTrue: [false] ifFalse: [true]
]

{ #category : #comparing }
ProtoObject >> = other [
	^self == other
]

{ #category : #system }
ProtoObject >> == anObject [
	^self errorVMSpecific
]

{ #category : #system }
ProtoObject >> allReferences [
	^self errorVMSpecific
]

{ #category : #accessing }
ProtoObject >> basicAt: anInteger [
	^self primitiveAt: anInteger
]

{ #category : #private }
ProtoObject >> basicAt: anInteger put: anObject [
	^self primitiveAt: anInteger put: anObject
]

{ #category : #unclassified }
ProtoObject >> basicByteAt: index [
	index _isSmallInteger ifFalse: [^self outOfBoundsIndex: index].
	(1 <= index and: [index <= self _size])
		ifFalse: [self outOfBoundsIndex: index].
	^self byteAtValid: index
]

{ #category : #unclassified }
ProtoObject >> basicByteAt: index put: value [
	index _isSmallInteger ifFalse: [^self outOfBoundsIndex: index].
	(1 <= index and: [index <= self _size])
		ifFalse: [self outOfBoundsIndex: index].
	value _isSmallInteger
		ifFalse: [^self error: 'value does not fit in a byte'].
	(0 <= value and: [value < 256])
		ifFalse: [^self error: 'value does not fit in a byte'].
	^self byteAtValid: index put: value
]

{ #category : #system }
ProtoObject >> basicHash [
	^self errorVMSpecific
]

{ #category : #system }
ProtoObject >> basicHash: anInteger [
	self errorVMSpecific
]

{ #category : #private }
ProtoObject >> basicInstVarAt: index [
	index _isSmallInteger ifFalse: [^self outOfBoundsIndex: index].
	(1 <= index and: [index <= self _size]) ifFalse: [^self outOfBoundsIndex: index].
	^self _isBytes ifTrue: [self _byteAt: index] ifFalse: [self objectAtValid: index]
]

{ #category : #private }
ProtoObject >> basicInstVarAt: index put: anObject [
	index _isSmallInteger ifFalse: [^self outOfBoundsIndex: index].
	(1 <= index and: [index <= self _size]) ifFalse: [self outOfBoundsIndex: index].
	^self _isBytes
		ifTrue: [self byteAtValid: index put: anObject]
		ifFalse: [self objectAtValid: index put: anObject]
]

{ #category : #unclassified }
ProtoObject >> basicObjectAt: grossIndex [
	| index |
	index := self basicObjectIndexOf: grossIndex.
	^self _basicAt: index
]

{ #category : #unclassified }
ProtoObject >> basicObjectAt: grossIndex put: anObject [
	| index |
	index := self basicObjectIndexOf: grossIndex.
	^self objectAtValid: index put: anObject
]

{ #category : #unclassified }
ProtoObject >> basicObjectIndexOf: grossIndex [
	| instVars index |
	grossIndex _isSmallInteger ifFalse: [^self outOfBoundsIndex: grossIndex].
	instVars := (self _hasNamedSlots and: [self _isArrayed])
		ifTrue: [self class instSize]
		ifFalse: [0].
	(1 <= grossIndex and: [grossIndex <= (self _size - instVars)])
		ifFalse: [^self outOfBoundsIndex: grossIndex].
	index := grossIndex + instVars.
	^index
]


{ #category : #private }
ProtoObject >> basicSize [
	^self primitiveSize
]

{ #category : #services }
ProtoObject >> become: anotherObject [
	^self errorVMSpecific
]

{ #category : #'meta accessing' }
ProtoObject >> behavior [
	^self errorVMSpecific
]

{ #category : #'meta accessing' }
ProtoObject >> behavior: aBehavior [
	^self errorVMSpecific
]

{ #category : #system }
ProtoObject >> class [
	^self behavior classBinding
]

{ #category : #system }
ProtoObject >> doesNotUnderstand: aMessage [
	^MessageNotUnderstood message: aMessage
]

{ #category : #errors }
ProtoObject >> error: aString [
	^Error signal: aString
]

{ #category : #errors }
ProtoObject >> errorVMSpecific [
	^self error: 'this method should have been overriden by the current VM'
]

{ #category : #finalization }
ProtoObject >> finalizationRegistry [
	^Smalltalk finalizer
]

{ #category : #finalization }
ProtoObject >> finalize [
	
]

{ #category : #system }
ProtoObject >> halt [
	Halt signal
]

{ #category : #accessing }
ProtoObject >> hash [
	^self basicHash
]

{ #category : #testing }
ProtoObject >> hasIndexedSlots [
	^self class _instancesAreArrayed
]

{ #category : #comparing }
ProtoObject >> identityHash [
	^self basicHash
]

{ #category : #services }
ProtoObject >> ifNil: aBlock [
	^self
]

{ #category : #services }
ProtoObject >> ifNotNil: aBlock [
	^aBlock argumentCount = 1
		ifTrue: [aBlock evaluateWith: self]
		ifFalse: [aBlock evaluate]
]

{ #category : #finalization }
ProtoObject >> ignoreFinalization [
	self finalizationRegistry remove: self ifAbsent: nil
]

{ #category : #'header access' }
ProtoObject >> initializeExtended: aBoolean contentSize: size [
	^self errorVMSpecific
]

{ #category : #system }
ProtoObject >> instVarAt: i [
	self _isSmallInteger ifTrue: [^self shouldNotImplement].
	^self _isBytes
		ifTrue: [self basicByteAt: i]
		ifFalse: [self basicInstVarAt: i]
]

{ #category : #system }
ProtoObject >> instVarAt: i put: anObject [
	self _isSmallInteger ifTrue: [^self shouldNotImplement].
	^self _isBytes
		ifTrue: [self basicByteAt: i put: anObject]
		ifFalse: [self basicInstVarAt: i put: anObject]
]

{ #category : #system }
ProtoObject >> isNil [
	^false
]

{ #category : #testing }
ProtoObject >> isSmallInteger [
	^false
]

{ #category : #accessing }
ProtoObject >> literalString [
	^nil
]

{ #category : #system }
ProtoObject >> notNil [
	^true
]

{ #category : #private }
ProtoObject >> objectAtValid: index [
	^self _basicAt: index
]

{ #category : #private }
ProtoObject >> objectAtValid: index put: anObject [
	anObject _holdRefererIfNeeded: self.
	^self _basicAt: index put: anObject
]

{ #category : #system }
ProtoObject >> perform: aSymbol [
	^self perform: aSymbol withArguments: #()
]

{ #category : #system }
ProtoObject >> perform: aSymbol with: anObject [
	^self perform: aSymbol withArguments: {anObject}
]

{ #category : #system }
ProtoObject >> perform: aSymbol withArguments: anArray [
	^self errorVMSpecific
]

{ #category : #accessing }
ProtoObject >> primitiveAt: i [
	^self errorVMSpecific
]

{ #category : #unclassified }
ProtoObject >> primitiveAt: i put: anObject [
	^self errorVMSpecific
]

{ #category : #underprimitives }
ProtoObject >> primitiveSize [
	^self errorVMSpecific
]

{ #category : #printing }
ProtoObject >> printOn: aStream [
	| string article |
	string := self class name.
	article := string first isVowel ifTrue: ['an '] ifFalse: ['a '].
	aStream nextPutAll: article; nextPutAll: string
]

{ #category : #printing }
ProtoObject >> printString [
	| stream |
	stream := '' writeStream.
	self printOn: stream.
	^stream contents
]

{ #category : #finalization }
ProtoObject >> requireFinalization [
	self finalizationRegistry add: self
]

{ #category : #testing }
ProtoObject >> requiresFinalization [
	^self finalizationRegistry includes: self
]

{ #category : #interrupts }
ProtoObject >> signalStep [
	Processor activeProcess handleStepSignal
]

{ #category : #interrupts }
ProtoObject >> signalStep: aSymbol [
	Processor activeProcess handleStepSignal
]

{ #category : #system }
ProtoObject >> yourself [
	^self
]

