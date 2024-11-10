"
    Copyright (c) 2020 Aucerna. 
    Copyright (c) 2020 LabWare. 
    See (MIT) license in root directory.
"

Class {
	#name : #CompiledBlock,
	#superclass : #Object,
	#type : #variable,
	#instVars : [
		'format',
		'optimizedCode',
		'method'
	],
	#classVars : [
		'Flags'
	],
	#category : #Kernel
}

{ #category : #initialization }
CompiledBlock class >> ensureFormatCorrectness [
	self
		ASSERT: Id end <= SmallInteger maximum;
		ASSERT: ArgCount end <= SmallInteger maximum;
		ASSERT: TempCount end <= SmallInteger maximum;
		DENY: (Id intersects: ArgCount);
		DENY: (Id intersects: TempCount);
		DENY: (ArgCount intersects: TempCount)
]

{ #category : #'instance creation' }
CompiledBlock class >> fromArray: anArray [
	| block |
	block := self new: anArray size - 2.
	^block loadFrom: anArray
]

{ #category : #initialization }
CompiledBlock class >> initializeFormatFlags [
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
]

{ #category : #initialization }
CompiledBlock class >> maxArgCount [
	^(2 raisedTo: ArgCount length) - 1
]

{ #category : #initialization }
CompiledBlock class >> maxTempCount [
	^(2 raisedTo: TempCount length) - 1
]

{ #category : #accessing }
CompiledBlock >> argumentCount [
	^format bitsAt: ArgCount
]

{ #category : #accessing }
CompiledBlock >> argumentCount: anInteger [
	format := format bitsAt: ArgCount put: anInteger
]

{ #category : #accessing }
CompiledBlock >> arity [
	^self argumentCount
]

{ #category : #accessing }
CompiledBlock >> aspects [
	^#(#arity
		#blockNumber
		#method
		#hasMethodEnvironment
		#tempCount
		#templateIndex)
]

{ #category : #comparing }
CompiledBlock >> basicPrintOn: aStream [
	method printOn: aStream.
	aStream
		nextPutAll: '. Block number: ';
		nextPutAll: self blockNumber printString;
		nextPutAll: ', ';
		nextPutAll: self argumentCount printString;
		nextPutAll: ' args, ';
		nextPutAll: self tempCount printString;
		nextPutAll: ' temps. '
]

{ #category : #accessing }
CompiledBlock >> bindMethod: aCompiledMethod [
	method := aCompiledMethod
]

{ #category : #accessing }
CompiledBlock >> blockCode [
	^optimizedCode code
]

{ #category : #accessing }
CompiledBlock >> blockExecutableCode [
	"
	required to let the optimizing compiler inline this code
	without confusing with CompiledMethod>>#executableCode
	"
	^optimizedCode
]

{ #category : #accessing }
CompiledBlock >> blockOptimizedCode [
	"
	required to let the optimizing compiler inline this code
	without confusing with CompiledMethod>>#optimizedCode
	"
	^optimizedCode
]

{ #category : #accessing }
CompiledBlock >> blockNumber [
	^format bitsAt: Id
]

{ #category : #accessing }
CompiledBlock >> blockNumber: anInteger [
	format := format bitsAt: Id put: anInteger
]

{ #category : #accessing }
CompiledBlock >> capturesHome: aBoolean [
	format := aBoolean
				ifTrue: [ format bitOr: CapturesHome ]
				ifFalse: [ format bitClear: CapturesHome ]
]

{ #category : #accessing }
CompiledBlock >> capturesSelf: aBoolean [
	format := aBoolean
				ifTrue: [ format bitOr: CapturesSelf ]
				ifFalse: [ format bitClear: CapturesSelf ]
]

{ #category : #accessing }
CompiledBlock >> environmentCount [
	^format bitsAt: EnvCount
]

{ #category : #accessing }
CompiledBlock >> environmentCount: anInteger [
	format := format bitsAt: EnvCount put: anInteger
]

{ #category : #accessing }
CompiledBlock >> format [
	^format
]

{ #category : #accessing }
CompiledBlock >> format: anInteger [
	format := anInteger
]

{ #category : #testing }
CompiledBlock >> hasMethodEnvironment [
	^self size >= 2 and: [(self at: 2) notNil]
]

{ #category : #comparing }
CompiledBlock >> hasReceiver [
	| index |
	index := Closure receiverIndex.
	^self size >= index andNot: [(self at: index) isNil]
]

{ #category : #accessing }
CompiledBlock >> initialize [
	super initialize.
	format := 0
]

{ #category : #accessing }
CompiledBlock >> invalidateOptimizedCode [
	optimizedCode := nil
]

{ #category : #testing }
CompiledBlock >> isBlock [
	^true
]

{ #category : #testing }
CompiledBlock >> isCallback [
	^method isCallback
]

{ #category : #testing }
CompiledBlock >> isDebuggable [
	^method isDebuggable
]

{ #category : #comparing }
CompiledBlock >> loadFrom: anArray [
	method := anArray at: 1.
	format := anArray at: 2.
	3 to: anArray size do: [:i | | ai |
		ai := anArray at: i.
		self at: i - 2 put: ai]
]

{ #category : #private }
CompiledBlock >> maxArity [
	^(1 bitShift: ArgCount length) - 1
]

{ #category : #private }
CompiledBlock >> maxBlockNumber [
	^(1 bitShift: Id length) - 1
]

{ #category : #accessing }
CompiledBlock >> method [
	^method
]

{ #category : #accessing }
CompiledBlock >> method: aCompiledMethod [
	method := aCompiledMethod
]

{ #category : #services }
CompiledBlock >> newClosure [
	^Closure newFrom: self
]

{ #category : #comparing }
CompiledBlock >> optimizedCode [
	^optimizedCode
]

{ #category : #comparing }
CompiledBlock >> optimizedCode: anObject [
	anObject block: self.
	optimizedCode := anObject
]

{ #category : #comparing }
CompiledBlock >> printOn: aStream [
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
]

{ #category : #accessing }
CompiledBlock >> tempCount [
	^format bitsAt: TempCount
]

{ #category : #accessing }
CompiledBlock >> tempCount: anInteger [
	format := format bitsAt: TempCount put: anInteger
]

{ #category : #accessing }
CompiledBlock >> templateIndex [
	| n |
	n := self blockNumber.
	^method literals
		findFirst: [:literal | literal isBlock and: [literal blockNumber = n]]
		ifAbsent: [self ASSERT: false]
]

{ #category : #private }
CompiledBlock >> temporaryLimit [
	^(1 bitShift: TempCount length) - 1
]

{ #category : #isEvaluating }
CompiledBlock >> valueSelector [
	| arity |
	arity := self arity.
	arity = 0 ifTrue: [^#value].
	arity = 1 ifTrue: [^#value:].
	arity = 2 ifTrue: [^#value:value:].
	arity = 3 ifTrue: [^#value:value:value:].
	arity = 4 ifTrue: [^#value:value:value:value:].
	self ASSERT: false.
	^#valueWithArguments:
]

