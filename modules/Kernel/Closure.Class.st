'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:38 pm'!
!classDefinition: #Closure category: #Kernel!
Object subclass: #Closure
	instanceVariableNames: 'block homeFrame'
	classVariableNames: 'Indexes'
	poolDictionaries: ''
	category: 'Kernel'!
!Closure commentStamp: '<historical>' prior: 0!

    Copyright (c) 2020 Aucerna. 
    See (MIT) license in root directory.
!

!Closure methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
argumentCount
	^block argumentCount
! !

!Closure methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
arity
	^block arity
! !

!Closure methodsFor:  'errors' stamp: 'KenD 28/Jun/2026 13:27:38'!
arityError: anInteger
	| arity msg count |
	arity := block argumentCount.
	count := anInteger = 0 ifTrue: ['none'] ifFalse: [anInteger asString].
	msg := 'The ' , self class name , ' expects ' , arity printString
		, (' argument' pluralize: arity > 1)
		, ', but was called with '
		, count.
	^self error: msg
! !

!Closure methodsFor:  'ffi' stamp: 'KenD 28/Jun/2026 13:27:38'!
asCallback
	#ClosureAsCallback.
	^self errorVMSpecific
! !

!Closure methodsFor:  'errors' stamp: 'KenD 28/Jun/2026 13:27:38'!
basicAt: anInteger
	anInteger _isSmallInteger ifFalse: [^self outOfBoundsIndex: anInteger].
	(1 <= anInteger and: [anInteger <= self _size])
		ifFalse: [^self outOfBoundsIndex: anInteger].
	^self _basicAt: anInteger
! !

!Closure methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:38'!
block
	^block
! !

!Closure methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
blockNumber
	^block blockNumber
! !

!Closure methodsFor:  'evaluating' stamp: 'KenD 28/Jun/2026 13:27:38'!
cull: a
	^self argumentCount < 1
		ifTrue: [self value]
		ifFalse: [self value: a]
! !

!Closure methodsFor:  'evaluating' stamp: 'KenD 28/Jun/2026 13:27:38'!
cull: a cull: b
	^self argumentCount < 2
		ifTrue: [self cull: a]
		ifFalse: [self value: a value: b]
! !

!Closure methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:38'!
do: aClosure
	1 to: self size do: [:index | | slot |
		slot := self at: index.
		aClosure value: slot]
! !

!Closure methodsFor:  'handling' stamp: 'KenD 28/Jun/2026 13:27:38'!
ensure: aBlock
	^Processor activeProcess evaluate: self ensuring: aBlock
! !

!Closure methodsFor:  'handling' stamp: 'KenD 28/Jun/2026 13:27:38'!
evaluate
	^self value
! !

!Closure methodsFor:  'handling' stamp: 'KenD 28/Jun/2026 13:27:38'!
evaluateAtomically
	self errorVMSpecific
! !

!Closure methodsFor:  'handling' stamp: 'KenD 28/Jun/2026 13:27:38'!
evaluateFor: anObject
	^self value: anObject
! !

!Closure methodsFor:  'handling' stamp: 'KenD 28/Jun/2026 13:27:38'!
evaluateWith: value
	self errorVMSpecific
! !

!Closure methodsFor:  'handling' stamp: 'KenD 28/Jun/2026 13:27:38'!
evaluateWith: anObject with: anotherObject
	self errorVMSpecific
! !

!Closure methodsFor:  'evaluating' stamp: 'KenD 28/Jun/2026 13:27:38'!
evaluateWithArguments: anArray
	| n args |
	n := self argumentCount.
	n = 0 ifTrue: [^self value].
	args := anArray size > n
		ifTrue: [anArray copyFrom: 1 to: n]
		ifFalse: [anArray].
	^self valueWithArguments: args
! !

!Closure methodsFor:  'handling' stamp: 'KenD 28/Jun/2026 13:27:38'!
fork
	^self newProcess fork
! !

!Closure methodsFor:  'handling' stamp: 'KenD 28/Jun/2026 13:27:38'!
forkAt: aNumber
	^self forkAt: aNumber named: 'forked from block'
! !

!Closure methodsFor:  'handling' stamp: 'KenD 28/Jun/2026 13:27:38'!
forkAt: aNumber named: aString
	^self newProcess name: aString; priority: aNumber; fork
! !

!Closure methodsFor:  'handling' stamp: 'KenD 28/Jun/2026 13:27:38'!
forkNamed: aString
	^self forkAt: Processor activePriority named: aString
! !

!Closure methodsFor:  'handling' stamp: 'KenD 28/Jun/2026 13:27:38'!
forkThread
	^Thread newOn: self
! !

!Closure methodsFor:  'handling' stamp: 'KenD 28/Jun/2026 13:27:38'!
hasMethodEnvironment
	^self size >= ParentEnvironmentIndex
! !

!Closure methodsFor:  'evaluating' stamp: 'KenD 28/Jun/2026 13:27:38'!
ifCurtailed: exceptionClosure
	| success |
	success := false.
	^[
		self value.
		success := true]
		ensure: [success ifFalse: [exceptionClosure value]]
! !

!Closure methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:38'!
isBlockClosure
	"
	FIXME: fix senders and remove me
	"
	^true
! !

!Closure methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:38'!
isClosure
	^true
! !

!Closure methodsFor:  'handling' stamp: 'KenD 28/Jun/2026 13:27:38'!
method
	^block method
! !

!Closure methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
method: aCompiledMethod
	block := aCompiledMethod at: block templateIndex
! !

!Closure methodsFor:  'handling' stamp: 'KenD 28/Jun/2026 13:27:38'!
methodEnvironment
	^self at: ParentEnvironmentIndex
! !

!Closure methodsFor:  'handling' stamp: 'KenD 28/Jun/2026 13:27:38'!
methodEnvironment: environment
	self at: ParentEnvironmentIndex put: environment
! !

!Closure methodsFor:  'handling' stamp: 'KenD 28/Jun/2026 13:27:38'!
needsArgument
	^self argumentCount > 0
! !

!Closure methodsFor:  'handling' stamp: 'KenD 28/Jun/2026 13:27:38'!
newProcess
	^Process sending: #value to: self
! !

!Closure methodsFor:  'handling' stamp: 'KenD 28/Jun/2026 13:27:38'!
newProcessWith: anArray
	| message |
	message := MessageSend
		receiver: self
		selector: #valueWithArguments:
		argument: anArray.
	^Process evaluating: message
! !

!Closure methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
numArgs
	^self argumentCount
! !

!Closure methodsFor:  'handling' stamp: 'KenD 28/Jun/2026 13:27:38'!
on: aClass do: aClosure
	^ExceptionHandler handle: aClass with: aClosure during: self
! !

!Closure methodsFor:  'handling' stamp: 'KenD 28/Jun/2026 13:27:38'!
on: exception1 do: closure1 on: exception2 do: closure2
	^self on: exception1 , exception2 do: [:ex | | handler |
		handler := (exception1 includesException: ex)
			ifTrue: [closure1]
			ifFalse: [closure2].
		handler evaluateWith: ex]
! !

!Closure methodsFor:  'handling' stamp: 'KenD 28/Jun/2026 13:27:38'!
printOn: aStream
	self class printOn: aStream.
	aStream nextPut: $(.
	block basicPrintOn: aStream.
	(1 to: self size)
		do: [:i | | field |
			field := self at: i.
			field printOn: aStream]
		separatedBy: [aStream space].
	aStream nextPut: $)
! !

!Closure methodsFor:  'handling' stamp: 'KenD 28/Jun/2026 13:27:38'!
receiver
	^self at: ReceiverIndex
! !

!Closure methodsFor:  'handling' stamp: 'KenD 28/Jun/2026 13:27:38'!
receiver: anObject
	self at: ReceiverIndex put: anObject
! !

!Closure methodsFor:  'handling' stamp: 'KenD 28/Jun/2026 13:27:38'!
repeat
	[true] whileTrue: [self value]
! !

!Closure methodsFor:  'handling' stamp: 'KenD 28/Jun/2026 13:27:38'!
repeatUntil: aBlock
	[
		self value.
		aBlock value] whileFalse
! !

!Closure methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:38'!
return: result
	^Processor activeProcess nonLocalReturn: result home: homeFrame
! !

!Closure methodsFor:  'handling' stamp: 'KenD 28/Jun/2026 13:27:38'!
spawnAndWait
	| s result |
	s := Semaphore new.
	[result := self ensure: [s signal]] fork.
	s wait.
	^result
! !

!Closure methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
tempCount
	^block tempCount
! !

!Closure methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
templateIndex
	^block templateIndex
! !

!Closure methodsFor:  'handling' stamp: 'KenD 28/Jun/2026 13:27:38'!
value
	self errorVMSpecific
! !

!Closure methodsFor:  'handling' stamp: 'KenD 28/Jun/2026 13:27:38'!
value: value
	self errorVMSpecific
! !

!Closure methodsFor:  'handling' stamp: 'KenD 28/Jun/2026 13:27:38'!
value: first value: second
	self errorVMSpecific
! !

!Closure methodsFor:  'handling' stamp: 'KenD 28/Jun/2026 13:27:38'!
value: first value: second value: third
	self errorVMSpecific
! !

!Closure methodsFor:  'evaluating' stamp: 'KenD 28/Jun/2026 13:27:38'!
value: arg1 value: arg2 value: arg3 value: arg4
	^self valueWithArguments: {arg1. arg2. arg3. arg4}
! !

!Closure methodsFor:  'evaluating' stamp: 'KenD 28/Jun/2026 13:27:38'!
valueSelector
	^block valueSelector
! !

!Closure methodsFor:  'handling' stamp: 'KenD 28/Jun/2026 13:27:38'!
valueWithArguments: arguments
	self errorVMSpecific
! !

!Closure methodsFor:  'handling' stamp: 'KenD 28/Jun/2026 13:27:38'!
whileFalse
	^[self value] whileFalse: []
! !

!Closure methodsFor:  'handling' stamp: 'KenD 28/Jun/2026 13:27:38'!
whileFalse: aBlock
	self errorVMSpecific
! !

!Closure methodsFor:  'handling' stamp: 'KenD 28/Jun/2026 13:27:38'!
whileTrue
	^[self value] whileTrue: []
! !

!Closure methodsFor:  'handling' stamp: 'KenD 28/Jun/2026 13:27:38'!
whileTrue: aBlock
	self errorVMSpecific
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Closure class' category: #Kernel!
Closure class
	instanceVariableNames: 'Indexes'!

!Closure class methodsFor:  'initialization' stamp: 'KenD 28/Jun/2026 13:27:38'!
initializeIndexes
	Indexes := self addNamespace
		at: 'ReceiverIndex' put: 1;
		at: 'ParentEnvironmentIndex' put: 2;
		yourself
! !

!Closure class methodsFor:  'gs' stamp: 'KenD 28/Jun/2026 13:27:38'!
newFrom: aBlock
	| size closure |
	size := aBlock environmentCount + self instSize.
	closure := self allocate: size * WordSize size: size.
	closure _beNamed; _beArrayed.
	self nil: size slotsOf: closure.
	closure _basicAt: 1 put: aBlock.
	^closure
! !

!Closure class methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:38'!
receiverIndex
	^ReceiverIndex
! !


