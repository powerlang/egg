'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:38 pm'!
!classDefinition: #ProtoObject category: #Kernel!
nil subclass: #ProtoObject
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Kernel'!
!ProtoObject commentStamp: '<historical>' prior: 0!

    Copyright (c) 2020 Aucerna. 
    See (MIT) license in root directory.
!

!ProtoObject methodsFor:  'comparing' stamp: 'KenD 28/Jun/2026 13:27:38'!
!!== anObject
	^self == anObject ifTrue: [false] ifFalse: [true]
! !

!ProtoObject methodsFor:  'underprimitives' stamp: 'KenD 28/Jun/2026 13:27:38'!
_basicAt: anInteger
	^self errorVMSpecific
! !

!ProtoObject methodsFor:  'underprimitives' stamp: 'KenD 28/Jun/2026 13:27:38'!
_beSpecial
	#UnderBeSpecial. "hack to avoid missing symbol error during bootstrap"
	^self errorVMSpecific
! !

!ProtoObject methodsFor:  'header access' stamp: 'KenD 28/Jun/2026 13:27:38'!
_copyBasicHeaderFrom: other
	self errorVMSpecific
! !

!ProtoObject methodsFor:  'header access' stamp: 'KenD 28/Jun/2026 13:27:38'!
_copyHeaderSized: byteSize from: anObject
	self errorVMSpecific
! !

!ProtoObject methodsFor:  'header access' stamp: 'KenD 28/Jun/2026 13:27:38'!
_doesNotUnderstand: selector with: arguments
	"
		Only the VM sends this. To adapt a message send with arguments in the
		stack onto a Message object with a selector and an array of arguments
	"
	| message result |
	message := Message selector: selector arguments: arguments.
	result := self doesNotUnderstand: message.
	^result _returnPoppingArguments: 2
! !

!ProtoObject methodsFor:  'header access' stamp: 'KenD 28/Jun/2026 13:27:38'!
_hash
	^self errorVMSpecific
! !

!ProtoObject methodsFor:  'header access' stamp: 'KenD 28/Jun/2026 13:27:38'!
_isBytes
	^self errorVMSpecific
! !

!ProtoObject methodsFor:  'header access' stamp: 'KenD 28/Jun/2026 13:27:38'!
_pointersSize
	^self errorVMSpecific
! !

!ProtoObject methodsFor:  'header access' stamp: 'KenD 28/Jun/2026 13:27:38'!
_size
	^self errorVMSpecific
! !

!ProtoObject methodsFor:  'raw access' stamp: 'KenD 28/Jun/2026 13:27:38'!
_uLongAtOffset: offset
	^self _primitiveULongAtOffset: offset
! !

!ProtoObject methodsFor:  'raw access' stamp: 'KenD 28/Jun/2026 13:27:38'!
_uLongAtValidOffset: offset put: anInteger
	self _primitiveULongAtOffset: offset put: anInteger.
	^anInteger
! !

!ProtoObject methodsFor:  'comparing' stamp: 'KenD 28/Jun/2026 13:27:38'!
~~ anObject
	^self == anObject ifTrue: [false] ifFalse: [true]
! !

!ProtoObject methodsFor:  'comparing' stamp: 'KenD 28/Jun/2026 13:27:38'!
= other
	^self == other
! !

!ProtoObject methodsFor:  'system' stamp: 'KenD 28/Jun/2026 13:27:38'!
== anObject
	^self errorVMSpecific
! !

!ProtoObject methodsFor:  'system' stamp: 'KenD 28/Jun/2026 13:27:38'!
allReferences
	^self errorVMSpecific
! !

!ProtoObject methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
basicAt: anInteger
	^self primitiveAt: anInteger
! !

!ProtoObject methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:38'!
basicAt: anInteger put: anObject
	^self primitiveAt: anInteger put: anObject
! !

!ProtoObject methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:38'!
basicByteAt: index
	index _isSmallInteger ifFalse: [^self outOfBoundsIndex: index].
	(1 <= index and: [index <= self _size])
		ifFalse: [self outOfBoundsIndex: index].
	^self byteAtValid: index
! !

!ProtoObject methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:38'!
basicByteAt: index put: value
	index _isSmallInteger ifFalse: [^self outOfBoundsIndex: index].
	(1 <= index and: [index <= self _size])
		ifFalse: [self outOfBoundsIndex: index].
	value _isSmallInteger
		ifFalse: [^self error: 'value does not fit in a byte'].
	(0 <= value and: [value < 256])
		ifFalse: [^self error: 'value does not fit in a byte'].
	^self byteAtValid: index put: value
! !

!ProtoObject methodsFor:  'system' stamp: 'KenD 28/Jun/2026 13:27:38'!
basicHash
	^self errorVMSpecific
! !

!ProtoObject methodsFor:  'system' stamp: 'KenD 28/Jun/2026 13:27:38'!
basicHash: anInteger
	self errorVMSpecific
! !

!ProtoObject methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:38'!
basicInstVarAt: index
	index _isSmallInteger ifFalse: [^self outOfBoundsIndex: index].
	(1 <= index and: [index <= self _size]) ifFalse: [^self outOfBoundsIndex: index].
	^self _isBytes ifTrue: [self _byteAt: index] ifFalse: [self objectAtValid: index]
! !

!ProtoObject methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:38'!
basicInstVarAt: index put: anObject
	index _isSmallInteger ifFalse: [^self outOfBoundsIndex: index].
	(1 <= index and: [index <= self _size]) ifFalse: [self outOfBoundsIndex: index].
	^self _isBytes
		ifTrue: [self byteAtValid: index put: anObject]
		ifFalse: [self objectAtValid: index put: anObject]
! !

!ProtoObject methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:38'!
basicObjectAt: grossIndex
	| index |
	index := self basicObjectIndexOf: grossIndex.
	^self _basicAt: index
! !

!ProtoObject methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:38'!
basicObjectAt: grossIndex put: anObject
	| index |
	index := self basicObjectIndexOf: grossIndex.
	^self objectAtValid: index put: anObject
! !

!ProtoObject methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:38'!
basicObjectIndexOf: grossIndex
	| instVars index |
	grossIndex _isSmallInteger ifFalse: [^self outOfBoundsIndex: grossIndex].
	instVars := (self _hasNamedSlots and: [self _isArrayed])
		ifTrue: [self class instSize]
		ifFalse: [0].
	(1 <= grossIndex and: [grossIndex <= (self _size - instVars)])
		ifFalse: [^self outOfBoundsIndex: grossIndex].
	index := grossIndex + instVars.
	^index
! !

!ProtoObject methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:38'!
basicSize
	^self primitiveSize
! !

!ProtoObject methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:38'!
become: anotherObject
	^self errorVMSpecific
! !

!ProtoObject methodsFor:  'meta accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
behavior
	^self errorVMSpecific
! !

!ProtoObject methodsFor:  'meta accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
behavior: aBehavior
	^self errorVMSpecific
! !

!ProtoObject methodsFor:  'system' stamp: 'KenD 28/Jun/2026 13:27:38'!
class
	^self behavior classBinding
! !

!ProtoObject methodsFor:  'system' stamp: 'KenD 28/Jun/2026 13:27:38'!
doesNotUnderstand: aMessage
	^MessageNotUnderstood message: aMessage receiver: self
! !

!ProtoObject methodsFor:  'errors' stamp: 'KenD 28/Jun/2026 13:27:38'!
error: aString
	^Error signal: aString
! !

!ProtoObject methodsFor:  'errors' stamp: 'KenD 28/Jun/2026 13:27:38'!
errorVMSpecific
	^self error: 'this method should have been overriden by the current VM'
! !

!ProtoObject methodsFor:  'finalization' stamp: 'KenD 28/Jun/2026 13:27:38'!
finalizationRegistry
	^Kernel finalizer
! !

!ProtoObject methodsFor:  'finalization' stamp: 'KenD 28/Jun/2026 13:27:38'!
finalize
	
! !

!ProtoObject methodsFor:  'system' stamp: 'KenD 28/Jun/2026 13:27:38'!
halt
	Halt signal
! !

!ProtoObject methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
hash
	^self basicHash
! !

!ProtoObject methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:38'!
hasIndexedSlots
	^self class _instancesAreArrayed
! !

!ProtoObject methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:38'!
_holdRefererIfNeeded: referent

! !

!ProtoObject methodsFor:  'comparing' stamp: 'KenD 28/Jun/2026 13:27:38'!
identityHash
	^self basicHash
! !

!ProtoObject methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:38'!
ifNil: aBlock
	^self
! !

!ProtoObject methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:38'!
ifNotNil: aBlock
	^aBlock argumentCount = 1
		ifTrue: [aBlock evaluateWith: self]
		ifFalse: [aBlock evaluate]
! !

!ProtoObject methodsFor:  'finalization' stamp: 'KenD 28/Jun/2026 13:27:38'!
ignoreFinalization
	self finalizationRegistry remove: self ifAbsent: nil
! !

!ProtoObject methodsFor:  'header access' stamp: 'KenD 28/Jun/2026 13:27:38'!
initializeExtended: aBoolean contentSize: size
	^self errorVMSpecific
! !

!ProtoObject methodsFor:  'system' stamp: 'KenD 28/Jun/2026 13:27:38'!
instVarAt: i
	self _isSmallInteger ifTrue: [^self shouldNotImplement].
	^self _isBytes
		ifTrue: [self basicByteAt: i]
		ifFalse: [self basicInstVarAt: i]
! !

!ProtoObject methodsFor:  'system' stamp: 'KenD 28/Jun/2026 13:27:38'!
instVarAt: i put: anObject
	self _isSmallInteger ifTrue: [^self shouldNotImplement].
	^self _isBytes
		ifTrue: [self basicByteAt: i put: anObject]
		ifFalse: [self basicInstVarAt: i put: anObject]
! !

!ProtoObject methodsFor:  'system' stamp: 'KenD 28/Jun/2026 13:27:38'!
isNil
	^false
! !

!ProtoObject methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:38'!
isSmallInteger
	^false
! !

!ProtoObject methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
literalString
	^nil
! !

!ProtoObject methodsFor:  'system' stamp: 'KenD 28/Jun/2026 13:27:38'!
notNil
	^true
! !

!ProtoObject methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:38'!
objectAtValid: index
	^self _basicAt: index
! !

!ProtoObject methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:38'!
objectAtValid: index put: anObject
	anObject _holdRefererIfNeeded: self.
	^self _basicAt: index put: anObject
! !

!ProtoObject methodsFor:  'system' stamp: 'KenD 28/Jun/2026 13:27:38'!
perform: aSymbol
	^self perform: aSymbol withArguments: #()
! !

!ProtoObject methodsFor:  'system' stamp: 'KenD 28/Jun/2026 13:27:38'!
perform: aSymbol with: anObject
	^self perform: aSymbol withArguments: {anObject}
! !

!ProtoObject methodsFor:  'system' stamp: 'KenD 28/Jun/2026 13:27:38'!
perform: aSymbol withArguments: anArray
	^self errorVMSpecific
! !

!ProtoObject methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
primitiveAt: i
	^self errorVMSpecific
! !

!ProtoObject methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:38'!
primitiveAt: i put: anObject
	^self errorVMSpecific
! !

!ProtoObject methodsFor:  'underprimitives' stamp: 'KenD 28/Jun/2026 13:27:38'!
primitiveSize
	^self errorVMSpecific
! !

!ProtoObject methodsFor:  'printing' stamp: 'KenD 28/Jun/2026 13:27:38'!
printOn: aStream
	| string article |
	string := self class name.
	article := string first isVowel ifTrue: ['an '] ifFalse: ['a '].
	aStream nextPutAll: article; nextPutAll: string
! !

!ProtoObject methodsFor:  'printing' stamp: 'KenD 28/Jun/2026 13:27:38'!
printString
	| stream |
	stream := '' writeStream.
	self printOn: stream.
	^stream contents
! !

!ProtoObject methodsFor:  'finalization' stamp: 'KenD 28/Jun/2026 13:27:38'!
requireFinalization
	self finalizationRegistry add: self
! !

!ProtoObject methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:38'!
requiresFinalization
	^self finalizationRegistry includes: self
! !

!ProtoObject methodsFor:  'interrupts' stamp: 'KenD 28/Jun/2026 13:27:38'!
signalStep
	Processor activeProcess handleStepSignal
! !

!ProtoObject methodsFor:  'interrupts' stamp: 'KenD 28/Jun/2026 13:27:38'!
signalStep: aSymbol
	Processor activeProcess handleStepSignal
! !

!ProtoObject methodsFor:  'system' stamp: 'KenD 28/Jun/2026 13:27:38'!
yourself
	^self
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'ProtoObject class' category: #Kernel!
ProtoObject class
	instanceVariableNames: ''!

!ProtoObject class methodsFor:  'initialization' stamp: 'KenD 28/Jun/2026 13:27:38'!
initializeBitMasks
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
! !

!ProtoObject class methodsFor:  'initialization' stamp: 'KenD 28/Jun/2026 13:27:38'!
initializeConstants
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
! !

!ProtoObject class methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:27:38'!
new
	^self basicNew initialize
! !


