"
    Copyright (c) 2020 Aucerna. 
    See (MIT) license in root directory.
"

Class {
	#name : #Closure,
	#superclass : #Object,
	#type : #variable,
	#instVars : [
		'block',
		'homeFrame'
	],
	#classVars : [
		'Indexes'
	],
	#category : #Kernel
}

{ #category : #initialization }
Closure class >> initializeIndexes [
	Indexes := self addNamespace
		at: 'ReceiverIndex' put: 1;
		at: 'ParentEnvironmentIndex' put: 2;
		yourself
]

{ #category : #gs }
Closure class >> newFrom: aBlock [
	| size closure |
	size := aBlock environmentCount + self instSize.
	closure := self allocate: size * WordSize size: size.
	closure _beNamed; _beArrayed.
	self nil: size slotsOf: closure.
	closure _basicAt: 1 put: aBlock.
	^closure
]

{ #category : #private }
Closure class >> receiverIndex [
	^ReceiverIndex
]

{ #category : #handling }
Closure >> _return: result [
	self canReturn ifFalse: [^self cannotReturn].
	^ActiveProcess returnTo: homeFrame methodFrame with: result
]

{ #category : #accessing }
Closure >> argumentCount [
	^block argumentCount
]

{ #category : #accessing }
Closure >> arity [
	^block arity
]

{ #category : #errors }
Closure >> arityError: anInteger [
	| arity msg count |
	arity := block argumentCount.
	count := anInteger = 0 ifTrue: ['none'] ifFalse: [anInteger asString].
	msg := 'The ' , self class name , ' expects ' , arity printString
		, (' argument' pluralize: arity > 1)
		, ', but was called with '
		, count.
	^self error: msg
]

{ #category : #errors }
Closure >> basicAt: anInteger [
	anInteger _isSmallInteger ifFalse: [^self outOfBoundsIndex: anInteger].
	(1 <= anInteger and: [anInteger <= self _size])
		ifFalse: [^self outOfBoundsIndex: anInteger].
	^self _basicAt: anInteger
]

{ #category : #private }
Closure >> block [
	^block
]

{ #category : #accessing }
Closure >> blockNumber [
	^block blockNumber
]

{ #category : #converting }
Closure >> canReturn [
	| env |
	homeFrame == nil ifTrue: [^false].
	homeFrame stackPointer < self _thisContext ifTrue: [^false].
	homeFrame hasBlocks ifFalse: [^false].
	env := self methodEnvironment.
	homeFrame environment == env ifTrue: [^true].
	^homeFrame methodEnvironment == env
]

{ #category : #evaluating }
Closure >> cull: a cull: b [
	^self argumentCount < 2
		ifTrue: [self cull: a]
		ifFalse: [self value: a value: b]
]

{ #category : #services }
Closure >> do: aClosure [
	1 to: self size do: [:index | | slot |
		slot := self at: index.
		aClosure value: slot]
]

{ #category : #handling }
Closure >> ensure: aBlock [
	^ActiveProcess evaluate: self ensuring: aBlock
]

{ #category : #handling }
Closure >> evaluate [
	^self value
]

{ #category : #handling }
Closure >> evaluateAtomically [
	self errorVMSpecific
]

{ #category : #handling }
Closure >> evaluateFor: anObject [
	^self value: anObject
]

{ #category : #handling }
Closure >> evaluateWith: value [
	self errorVMSpecific
]

{ #category : #handling }
Closure >> evaluateWith: anObject with: anotherObject [
	self errorVMSpecific
]

{ #category : #evaluating }
Closure >> evaluateWithArguments: anArray [
	| n args |
	n := self argumentCount.
	n = 0 ifTrue: [^self value].
	args := anArray size > n
		ifTrue: [anArray copyFrom: 1 to: n]
		ifFalse: [anArray].
	^self valueWithArguments: args
]

{ #category : #handling }
Closure >> fork [
	^self newProcess fork
]

{ #category : #handling }
Closure >> forkAt: aNumber [
	^self forkAt: aNumber named: 'forked from block'
]

{ #category : #handling }
Closure >> forkAt: aNumber named: aString [
	^self newProcess name: aString; priority: aNumber; fork
]

{ #category : #handling }
Closure >> forkNamed: aString [
	^self forkAt: Processor activePriority named: aString
]

{ #category : #handling }
Closure >> forkThread [
	^Thread newOn: self
]

{ #category : #handling }
Closure >> hasMethodEnvironment [
	^self size >= ParentEnvironmentIndex
]

{ #category : #evaluating }
Closure >> ifCurtailed: exceptionClosure [
	| success |
	success := false.
	^[
		self value.
		success := true]
		ensure: [success ifFalse: [exceptionClosure value]]
]

{ #category : #testing }
Closure >> isBlockClosure [
	"
	FIXME: fix senders and remove me
	"
	^true
]

{ #category : #testing }
Closure >> isClosure [
	^true
]

{ #category : #handling }
Closure >> method [
	^block method
]

{ #category : #accessing }
Closure >> method: aCompiledMethod [
	block := aCompiledMethod at: block templateIndex
]

{ #category : #handling }
Closure >> methodEnvironment [
	^self at: ParentEnvironmentIndex
]

{ #category : #handling }
Closure >> methodEnvironment: environment [
	self at: ParentEnvironmentIndex put: environment
]

{ #category : #accessing }
Closure >> methodFrame [
	^homeFrame methodFrame
]

{ #category : #handling }
Closure >> needsArgument [
	^self argumentCount > 0
]

{ #category : #handling }
Closure >> newProcess [
	^Process sending: #value to: self
]

{ #category : #handling }
Closure >> newProcessWith: anArray [
	| message |
	message := MessageSend
		receiver: self
		selector: #valueWithArguments:
		argument: anArray.
	^Process evaluating: message
]

{ #category : #accessing }
Closure >> numArgs [
	^self argumentCount
]

{ #category : #handling }
Closure >> on: aClass do: aClosure [
	^ExceptionHandler handle: aClass with: aClosure during: self
]

{ #category : #handling }
Closure >> on: exception1
do: closure1
on: exception2
do: closure2 [
	^self on: exception1 , exception2 do: [:ex | | handler |
		handler := (exception1 includesException: ex)
			ifTrue: [closure1]
			ifFalse: [closure2].
		handler evaluateWith: ex]
]

{ #category : #handling }
Closure >> printOn: aStream [
	self class printOn: aStream.
	aStream nextPut: $(.
	block basicPrintOn: aStream.
	(1 to: self size)
		do: [:i | | field |
			field := self at: i.
			field printOn: aStream]
		separatedBy: [aStream space].
	aStream nextPut: $)
]

{ #category : #handling }
Closure >> receiver [
	^self at: ReceiverIndex
]

{ #category : #handling }
Closure >> receiver: anObject [
	self at: ReceiverIndex put: anObject
]

{ #category : #handling }
Closure >> repeat [
	[true] whileTrue: [self value]
]

{ #category : #handling }
Closure >> repeatUntil: aBlock [
	[
		self value.
		aBlock value] whileFalse
]

{ #category : #handling }
Closure >> spawnAndWait [
	| s result |
	s := Semaphore new.
	[result := self ensure: [s signal]] fork.
	s wait.
	^result
]

{ #category : #accessing }
Closure >> tempCount [
	^block tempCount
]

{ #category : #accessing }
Closure >> templateIndex [
	^block templateIndex
]

{ #category : #handling }
Closure >> value [
	self errorVMSpecific
]

{ #category : #handling }
Closure >> value: value [
	self errorVMSpecific
]

{ #category : #handling }
Closure >> value: first value: second [
	self errorVMSpecific
]

{ #category : #handling }
Closure >> value: first value: second value: third [
	self errorVMSpecific
]

{ #category : #evaluating }
Closure >> value: arg1
value: arg2
value: arg3
value: arg4 [
	^self valueWithArguments: {arg1. arg2. arg3. arg4}
]

{ #category : #evaluating }
Closure >> valueSelector [
	^block valueSelector
]

{ #category : #handling }
Closure >> valueWithArguments: arguments [
	self errorVMSpecific
]

{ #category : #handling }
Closure >> whileFalse [
	^[self value] whileFalse: []
]

{ #category : #handling }
Closure >> whileFalse: aBlock [
	self errorVMSpecific
]

{ #category : #handling }
Closure >> whileTrue [
	^[self value] whileTrue: []
]

{ #category : #handling }
Closure >> whileTrue: aBlock [
	self errorVMSpecific
]

