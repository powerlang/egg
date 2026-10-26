'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:39 pm'!
!classDefinition: #StackFrameCursor category: #Kernel!
Object subclass: #StackFrameCursor
	instanceVariableNames: 'current previous'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Kernel'!
!StackFrameCursor commentStamp: '<historical>' prior: 0!

    Copyright (c) 2020 Aucerna. 
    See (MIT) license in root directory.
!

!StackFrameCursor methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
addObjectsTo: aCollection
	self slotCount - 2
		to: 1
		by: -1
		do: [:i | aCollection add: (self slotAt: i)]
! !

!StackFrameCursor methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
argumentAt: index
	^current _asObject _basicAt: 3 + index - 1
! !

!StackFrameCursor methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
argumentAt: index put: argument
	current _asObject _basicAt: 3 + index - 1 put: argument
! !

!StackFrameCursor methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
arguments
	| arity arguments |
	arity := self method arity.
	arguments := Array new: arity.
	self copy: arity argumentsInto: arguments.
	^arguments
! !

!StackFrameCursor methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
argumentsWithArity: arity
	| arguments |
	arguments := Array new: arity.
	self copy: arity argumentsInto: arguments.
	^arguments
! !

!StackFrameCursor methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
caller
	^(current _asObject _basicAt: 1) _asPointer
! !

!StackFrameCursor methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
callerFrame
	^self moveNext
! !

!StackFrameCursor methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
context
	^current _asObject _basicAt: -2
! !

!StackFrameCursor methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
context: aContext
	current _asObject _basicAt: -2 put: aContext
! !

!StackFrameCursor methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
copy: arity argumentsInto: arguments
	1
		to: arity
		do: [:i | arguments at: arity - i + 1 put: (self argumentAt: i)]
! !

!StackFrameCursor methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
copyTo: basePointer
	| size |
	size := self slotCount - 1.
	1 to: size do: [:i | | slot |
		slot := self slotAt: i.
		basePointer _asObject _basicAt: 1 - i put: slot].
	^basePointer - (size * WordSize) _asPointer
! !

!StackFrameCursor methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
current
	^current
! !

!StackFrameCursor methodsFor:  'actions' stamp: 'KenD 28/Jun/2026 13:27:39'!
current: bp previous: sp
	previous := sp.
	current := bp
! !

!StackFrameCursor methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:39'!
ended
	^current == 0 _asPointer
! !

!StackFrameCursor methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
environment
	^current _asObject _basicAt: -3
! !

!StackFrameCursor methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
firstTemporary: temp
	current _asObject _basicAt: -2 put: temp
! !

!StackFrameCursor methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:39'!
hasBlocks
	| m |
	m := self method.
	^m isBlock or: [m hasBlocks]
! !

!StackFrameCursor methodsFor:  'actions' stamp: 'KenD 28/Jun/2026 13:27:39'!
initialize
	
! !

!StackFrameCursor methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
method
	^current _asObject _basicAt: -1
! !

!StackFrameCursor methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
methodEnvironment
	^self method isBlock
		ifTrue: [self environment methodEnvironment]
		ifFalse: [self environment]
! !

!StackFrameCursor methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
methodFrame
	^self method isBlock ifTrue: [self environment methodFrame] ifFalse: [self]
! !

!StackFrameCursor methodsFor:  'actions' stamp: 'KenD 28/Jun/2026 13:27:39'!
moveLast
	[self caller _asPointer == 0] whileFalse: [self moveNext]
! !

!StackFrameCursor methodsFor:  'actions' stamp: 'KenD 28/Jun/2026 13:27:39'!
moveNext
	previous := current.
	current := self caller
! !

!StackFrameCursor methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
objectsDo: aBlock
	self slotCount - 2 to: 1 by: -1 do: [:i | aBlock value: (self slotAt: i)]
! !

!StackFrameCursor methodsFor:  'actions' stamp: 'KenD 28/Jun/2026 13:27:39'!
pointTo: base
	current := base
! !

!StackFrameCursor methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
previous
	^previous
! !

!StackFrameCursor methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
receiver
	^current _asObject _basicAt: 0
! !

!StackFrameCursor methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
receiver: object
	current _asObject _basicAt: 0 put: object
! !

!StackFrameCursor methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
savedEnvironment
	^current _asObject _basicAt: -2
! !

!StackFrameCursor methodsFor:  'actions' stamp: 'KenD 28/Jun/2026 13:27:39'!
slideSlots: amount
	current := current + (amount * WordSize _asPointer)
! !

!StackFrameCursor methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
slotAt: index
	^current _asObject _basicAt: 1 - index
! !

!StackFrameCursor methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
slotCount
	^current - previous // WordSize _asPointer
! !

!StackFrameCursor methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
stackPointer
	^current
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'StackFrameCursor class' category: #Kernel!
StackFrameCursor class
	instanceVariableNames: ''!

!StackFrameCursor class methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:27:39'!
at: position
	^self new pointTo: position
! !

!StackFrameCursor class methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:27:39'!
caller
	^self at: (self _framePointer _basicAt: 1) _asPointer
! !

!StackFrameCursor class methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:27:39'!
classFor: aProcessStack
	^aProcessStack isNative
		ifTrue: [StackFrameCursor]
		ifFalse: [ReifiedStackFrameCursor]
! !

!StackFrameCursor class methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:27:39'!
on: aProcessStack
	| class |
	class := self classFor: aProcessStack.
	^class new current: aProcessStack lastFrame previous: aProcessStack top
! !

!StackFrameCursor class methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:27:39'!
top
	^self at: self _framePointer _asPointer
! !


StackFrameCursor initialize!

