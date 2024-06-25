"
    Copyright (c) 2020 Aucerna. 
    See (MIT) license in root directory.
"

Class {
	#name : #StackFrameCursor,
	#superclass : #Object,
	#instVars : [
		'current',
		'previous'
	],
	#category : #Kernel
}

{ #category : #'instance creation' }
StackFrameCursor class >> at: position [
	^self new pointTo: position
]

{ #category : #'instance creation' }
StackFrameCursor class >> caller [
	^self at: (self _framePointer _basicAt: 1) _asPointer
]

{ #category : #'instance creation' }
StackFrameCursor class >> classFor: aStackWrapper [
	^aStackWrapper isNative
		ifTrue: [StackFrameCursor]
		ifFalse: [ReifiedStackFrameCursor]
]

{ #category : #'instance creation' }
StackFrameCursor class >> on: aStackWrapper [
	| class |
	class := self classFor: aStackWrapper.
	^class new current: aStackWrapper lastFrame previous: aStackWrapper top
]

{ #category : #'instance creation' }
StackFrameCursor class >> top [
	^self at: self _framePointer _asPointer
]

{ #category : #accessing }
StackFrameCursor >> addObjectsTo: aCollection [
	self slotCount - 2
		to: 1
		by: -1
		do: [:i | aCollection add: (self slotAt: i)]
]

{ #category : #accessing }
StackFrameCursor >> argumentAt: index [
	^current _asObject _basicAt: 3 + index - 1
]

{ #category : #accessing }
StackFrameCursor >> argumentAt: index put: argument [
	current _asObject _basicAt: 3 + index - 1 put: argument
]

{ #category : #accessing }
StackFrameCursor >> arguments [
	| arity arguments |
	arity := self method arity.
	arguments := Array new: arity.
	self copy: arity argumentsInto: arguments.
	^arguments
]

{ #category : #accessing }
StackFrameCursor >> argumentsWithArity: arity [
	| arguments |
	arguments := Array new: arity.
	self copy: arity argumentsInto: arguments.
	^arguments
]

{ #category : #accessing }
StackFrameCursor >> caller [
	^(current _asObject _basicAt: 1) _asPointer
]

{ #category : #accessing }
StackFrameCursor >> callerFrame [
	^self moveNext
]

{ #category : #accessing }
StackFrameCursor >> context [
	^current _asObject _basicAt: -2
]

{ #category : #accessing }
StackFrameCursor >> context: aContext [
	current _asObject _basicAt: -2 put: aContext
]

{ #category : #accessing }
StackFrameCursor >> copy: arity argumentsInto: arguments [
	1
		to: arity
		do: [:i | arguments at: arity - i + 1 put: (self argumentAt: i)]
]

{ #category : #accessing }
StackFrameCursor >> copyTo: basePointer [
	| size |
	size := self slotCount - 1.
	1 to: size do: [:i | | slot |
		slot := self slotAt: i.
		basePointer _asObject _basicAt: 1 - i put: slot].
	^basePointer - (size * WordSize) _asPointer
]

{ #category : #accessing }
StackFrameCursor >> current [
	^current
]

{ #category : #actions }
StackFrameCursor >> current: bp previous: sp [
	previous := sp.
	current := bp
]

{ #category : #testing }
StackFrameCursor >> ended [
	^current == 0 _asPointer
]

{ #category : #accessing }
StackFrameCursor >> environment [
	^current _asObject _basicAt: -3
]

{ #category : #accessing }
StackFrameCursor >> firstTemporary: temp [
	current _asObject _basicAt: -2 put: temp
]

{ #category : #testing }
StackFrameCursor >> hasBlocks [
	| m |
	m := self method.
	^m isBlock or: [m hasBlocks]
]

{ #category : #actions }
StackFrameCursor >> initialize [
	
]

{ #category : #accessing }
StackFrameCursor >> method [
	^current _asObject _basicAt: -1
]

{ #category : #accessing }
StackFrameCursor >> methodEnvironment [
	^self method isBlock
		ifTrue: [self environment methodEnvironment]
		ifFalse: [self environment]
]

{ #category : #accessing }
StackFrameCursor >> methodFrame [
	^self method isBlock ifTrue: [self environment methodFrame] ifFalse: [self]
]

{ #category : #actions }
StackFrameCursor >> moveLast [
	[self caller _asPointer == 0] whileFalse: [self moveNext]
]

{ #category : #actions }
StackFrameCursor >> moveNext [
	previous := current.
	current := self caller
]

{ #category : #accessing }
StackFrameCursor >> objectsDo: aBlock [
	self slotCount - 2 to: 1 by: -1 do: [:i | aBlock value: (self slotAt: i)]
]

{ #category : #actions }
StackFrameCursor >> pointTo: base [
	current := base
]

{ #category : #accessing }
StackFrameCursor >> previous [
	^previous
]

{ #category : #accessing }
StackFrameCursor >> receiver [
	^current _asObject _basicAt: 0
]

{ #category : #accessing }
StackFrameCursor >> receiver: object [
	current _asObject _basicAt: 0 put: object
]

{ #category : #accessing }
StackFrameCursor >> savedEnvironment [
	^current _asObject _basicAt: -2
]

{ #category : #actions }
StackFrameCursor >> slideSlots: amount [
	current := current + (amount * WordSize _asPointer)
]

{ #category : #accessing }
StackFrameCursor >> slotAt: index [
	^current _asObject _basicAt: 1 - index
]

{ #category : #accessing }
StackFrameCursor >> slotCount [
	^current - previous // WordSize _asPointer
]

{ #category : #accessing }
StackFrameCursor >> stackPointer [
	^current
]

