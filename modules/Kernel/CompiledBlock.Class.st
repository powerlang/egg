'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:38 pm'!
!classDefinition: #CompiledBlock category: #Kernel!
Object subclass: #CompiledBlock
	instanceVariableNames: 'format optimizedCode method'
	classVariableNames: 'Flags'
	poolDictionaries: ''
	category: 'Kernel'!
!CompiledBlock commentStamp: '<historical>' prior: 0!

    Copyright (c) 2020 Aucerna. 
    Copyright (c) 2020 LabWare. 
    See (MIT) license in root directory.
!

!CompiledBlock methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
argumentCount
	^format bitsAt: ArgCount
! !

!CompiledBlock methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
argumentCount: anInteger
	format := format bitsAt: ArgCount put: anInteger
! !

!CompiledBlock methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
arity
	^self argumentCount
! !

!CompiledBlock methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
aspects
	^#(#arity
		#blockNumber
		#method
		#hasMethodEnvironment
		#tempCount
		#templateIndex)
! !

!CompiledBlock methodsFor:  'comparing' stamp: 'KenD 28/Jun/2026 13:27:38'!
basicPrintOn: aStream
	method printOn: aStream.
	aStream
		nextPutAll: '. Block number: ';
		nextPutAll: self blockNumber printString;
		nextPutAll: ', ';
		nextPutAll: self argumentCount printString;
		nextPutAll: ' args, ';
		nextPutAll: self tempCount printString;
		nextPutAll: ' temps. '
! !

!CompiledBlock methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
bindMethod: aCompiledMethod
	method := aCompiledMethod
! !

!CompiledBlock methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
blockCode
	^optimizedCode code
! !

!CompiledBlock methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
blockExecutableCode
	"
	required to let the optimizing compiler inline this code
	without confusing with CompiledMethod>>#executableCode
	"
	^optimizedCode
! !

!CompiledBlock methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
blockOptimizedCode
	"
	required to let the optimizing compiler inline this code
	without confusing with CompiledMethod>>#optimizedCode
	"
	^optimizedCode
! !

!CompiledBlock methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
blockNumber
	^format bitsAt: Id
! !

!CompiledBlock methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
blockNumber: anInteger
	format := format bitsAt: Id put: anInteger
! !

!CompiledBlock methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
capturesHome: aBoolean
	format := aBoolean
				ifTrue: [ format bitOr: CapturesHome ]
				ifFalse: [ format bitClear: CapturesHome ]
! !

!CompiledBlock methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
capturesSelf: aBoolean
	format := aBoolean
				ifTrue: [ format bitOr: CapturesSelf ]
				ifFalse: [ format bitClear: CapturesSelf ]
! !

!CompiledBlock methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
environmentCount
	^format bitsAt: EnvCount
! !

!CompiledBlock methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
environmentCount: anInteger
	format := format bitsAt: EnvCount put: anInteger
! !

!CompiledBlock methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
format
	^format
! !

!CompiledBlock methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
format: anInteger
	format := anInteger
! !

!CompiledBlock methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:38'!
hasMethodEnvironment
	^self size >= 2 and: [(self at: 2) notNil]
! !

!CompiledBlock methodsFor:  'comparing' stamp: 'KenD 28/Jun/2026 13:27:38'!
hasReceiver
	| index |
	index := Closure receiverIndex.
	^self size >= index andNot: [(self at: index) isNil]
! !

!CompiledBlock methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
initialize
	super initialize.
	format := 0
! !

!CompiledBlock methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
invalidateOptimizedCode
	optimizedCode := nil
! !

!CompiledBlock methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:38'!
isBlock
	^true
! !

!CompiledBlock methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:38'!
isCallback
	^method isCallback
! !

!CompiledBlock methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:38'!
isDebuggable
	^method isDebuggable
! !

!CompiledBlock methodsFor:  'comparing' stamp: 'KenD 28/Jun/2026 13:27:38'!
loadFrom: anArray
	method := anArray at: 1.
	format := anArray at: 2.
	3 to: anArray size do: [:i | | ai |
		ai := anArray at: i.
		self at: i - 2 put: ai]
! !

!CompiledBlock methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:38'!
maxArity
	^(1 bitShift: ArgCount length) - 1
! !

!CompiledBlock methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:38'!
maxBlockNumber
	^(1 bitShift: Id length) - 1
! !

!CompiledBlock methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
method
	^method
! !

!CompiledBlock methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
method: aCompiledMethod
	method := aCompiledMethod
! !

!CompiledBlock methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:38'!
newClosure
	^Closure newFrom: self
! !

!CompiledBlock methodsFor:  'comparing' stamp: 'KenD 28/Jun/2026 13:27:38'!
optimizedCode
	^optimizedCode
! !

!CompiledBlock methodsFor:  'comparing' stamp: 'KenD 28/Jun/2026 13:27:38'!
optimizedCode: anObject
	anObject block: self.
	optimizedCode := anObject
! !

!CompiledBlock methodsFor:  'comparing' stamp: 'KenD 28/Jun/2026 13:27:38'!
printOn: aStream
	self class printOn: aStream.
	aStream nextPut: $(.
	self basicPrintOn: aStream.
	(1 to: self size)
		do: [:i | | field tag rest |
			field := self at: i.
			field ifNil: [aStream nextPutAll: 'nil'] ifNotNil: [
				tag := field bitShift: -27.
				rest := field bitAnd: 16r7FFFFFF.
				aStream
					nextPut: $[;
					nextPutAll: tag asString;
					space;
					nextPutAll: rest asString;
					nextPut: $]]]
		separatedBy: [aStream space].
	aStream nextPut: $)
! !

!CompiledBlock methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
tempCount
	^format bitsAt: TempCount
! !

!CompiledBlock methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
tempCount: anInteger
	format := format bitsAt: TempCount put: anInteger
! !

!CompiledBlock methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
templateIndex
	| n |
	n := self blockNumber.
	^method literals
		findFirst: [:literal | literal isBlock and: [literal blockNumber = n]]
		ifAbsent: [self ASSERT: false]
! !

!CompiledBlock methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:38'!
temporaryLimit
	^(1 bitShift: TempCount length) - 1
! !

!CompiledBlock methodsFor:  'isEvaluating' stamp: 'KenD 28/Jun/2026 13:27:38'!
valueSelector
	| arity |
	arity := self arity.
	arity = 0 ifTrue: [^#value].
	arity = 1 ifTrue: [^#value:].
	arity = 2 ifTrue: [^#value:value:].
	arity = 3 ifTrue: [^#value:value:value:].
	arity = 4 ifTrue: [^#value:value:value:value:].
	self ASSERT: false.
	^#valueWithArguments:
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'CompiledBlock class' category: #Kernel!
CompiledBlock class
	instanceVariableNames: 'Flags'!

!CompiledBlock class methodsFor:  'initialization' stamp: 'KenD 28/Jun/2026 13:27:38'!
ensureFormatCorrectness
	self
		ASSERT: Id end <= SmallInteger maximum;
		ASSERT: ArgCount end <= SmallInteger maximum;
		ASSERT: TempCount end <= SmallInteger maximum;
		DENY: (Id intersects: ArgCount);
		DENY: (Id intersects: TempCount);
		DENY: (ArgCount intersects: TempCount)
! !

!CompiledBlock class methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:27:38'!
fromArray: anArray
	| block |
	block := self new: anArray size - 2.
	^block loadFrom: anArray
! !

!CompiledBlock class methodsFor:  'initialization' stamp: 'KenD 28/Jun/2026 13:27:38'!
initializeFormatFlags
	"
	self initializeFormatFlags.
	self compileAll.
	self class compileAll
	"
	Flags := self addNamespace
		at: #ArgCount put: (1 thru: 6);
		at: #TempCount put: (7 thru: 14);
		at: #Id put: (15 thru: 22);
		at: #CapturesSelf put: (1 bitShift: 23 - 1);
		at: #CapturesHome put: (1 bitShift: 24 - 1);
		at: #EnvCount put: (25 thru: 31);
		yourself.
! !

!CompiledBlock class methodsFor:  'initialization' stamp: 'KenD 28/Jun/2026 13:27:38'!
maxArgCount
	^(2 raisedTo: ArgCount length) - 1
! !

!CompiledBlock class methodsFor:  'initialization' stamp: 'KenD 28/Jun/2026 13:27:38'!
maxTempCount
	^(2 raisedTo: TempCount length) - 1
! !


CompiledBlock initialize!

