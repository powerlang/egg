Class {
	#name : 'EggEvaluator',
	#superclass : 'Object',
	#instVars : [
		'runtime',
		'falseObj',
		'trueObj',
		'nilObj',
		'context',
		'undermessages',
		'primitives',
		'messageCount',
		'stacks'
	],
	#pools : [
		'ClosureElementTypes'
	],
	#category : 'Powerlang-Core-Execution',
	#package : 'Powerlang-Core',
	#tag : 'Execution'
}

{ #category : 'as yet unclassified' }
EggEvaluator class >> undermessages [
	^#(_basicAt: #_basicAt:put: _bitShiftLeft: _byteAt: #_byteAt:put: _smallSize _largeSize _isSmallInteger _basicHash _basicHash: _smallIntegerByteAt: _uShortAtOffset: #_uShortAtOffset:put:)
]

{ #category : 'services' }
EggEvaluator >> booleanFor: aBoolean [
	^ aBoolean
		ifTrue: [ trueObj ]
		ifFalse: [ falseObj ]
]

{ #category : 'services' }
EggEvaluator >> booleanFrom: anObject [
	anObject == falseObj
		ifTrue: [ ^ false ].
	anObject == trueObj
		ifTrue: [ ^ true ].
	self error: 'not a boolean'
]

{ #category : 'accessing' }
EggEvaluator >> context [
	^ context 
]

{ #category : 'accessing' }
EggEvaluator >> context: anEvaluationContext [ 
	context := anEvaluationContext
]

{ #category : 'primitives' }
EggEvaluator >> contextSwitchTo: vmStack [

^self subclassResponsibility 
]

{ #category : 'initializing' }
EggEvaluator >> convertPrimitives [
	| original |
	original := primitives.
	primitives := IdentityDictionary new.
	original
		keysAndValuesDo:
			[ :symbol :block | primitives at: (runtime symbolFromLocal: symbol) put: block ]
]

{ #category : 'initializing' }
EggEvaluator >> convertUndermessages [
	| original |
	original := undermessages.
	undermessages := IdentityDictionary new.
	original keysAndValuesDo: [ :symbol :block | undermessages at: (runtime symbolFromLocal: symbol) put: block ]

]

{ #category : 'accessing' }
EggEvaluator >> evaluateClosure: receiver [
	^ self evaluateClosure: receiver withArgs: #()
]

{ #category : 'visiting' }
EggEvaluator >> evaluateClosure: aPClosure with: anObject [
	 ^self evaluateClosure: aPClosure withArgs: { anObject }
]

{ #category : 'visiting' }
EggEvaluator >> evaluateClosure: aPClosure with: anObject with: anotherObject [
	^ self evaluateClosure: aPClosure withArgs: {anObject. anotherObject}
]

{ #category : 'private' }
EggEvaluator >> evaluateClosure: receiver withArgs: arguments [
	^self subclassResponsibility
]

{ #category : 'primitives' }
EggEvaluator >> evaluatePerform: aSymbol in: receiver withArgs: arguments [
	| behavior method |
	behavior := runtime behaviorOf: receiver.
	method := runtime lookup: aSymbol startingAt: behavior.
	arguments slots do: [ :arg | context pushOperand: arg ].
	^self invoke: method with: receiver
]

{ #category : 'accessing' }
EggEvaluator >> evaluatePrimitiveHash: receiver [
	| hash |
	hash := receiver headerHash.
	hash = 0
		ifTrue: [ hash := self nextHash.
			receiver headerHash: hash ].
	^ runtime newInteger: hash
]

{ #category : 'initialization' }
EggEvaluator >> false [
	^ falseObj
]

{ #category : 'initialization' }
EggEvaluator >> initialize [

	messageCount := 0.
	stacks := IdentityDictionary new
]

{ #category : 'accessing' }
EggEvaluator >> initializeExecutableCodeOf: method [

	^self subclassResponsibility
]

{ #category : 'accessing' }
EggEvaluator >> initializeLinearExecutableCodeOf: method [

	| sexpressions executable |
	sexpressions := runtime sexpressionsOf: method.
	(runtime methodIsCallout: method) 
		ifTrue: [ self linearizer visitFFIMethod: sexpressions]
		ifFalse: [ self linearizer visitMethod: sexpressions].
	executable := runtime newExecutableCodeFor:
		              self linearizer operations asArray.
	^runtime methodExecutableCode: method put: executable
]

{ #category : 'initializing' }
EggEvaluator >> initializePrimitives [

	primitives := IdentityDictionary new.
	primitives
		at: #Behavior put: self primitiveBehavior;
		at: #SetBehavior put: self primitiveSetBehavior;
		at: #Class put: self primitiveClass;
		at: #UnderHash put: self primitiveUnderHash;
		at: #UnderIsBytes put: self primitiveUnderIsBytes;
		at: #UnderPointersSize put: self primitiveUnderPointersSize;
		at: #UnderSize put: self primitiveUnderSize;
		at: #Size put: self primitiveSize;
		at: #Hash put: self primitiveHash;
		at: #At put: self primitiveAt;
		at: #AtPut put: self primitiveAtPut;
		at: #New put: self primitiveNew;
		at: #NewSized put: self primitiveNewSized;
		at: #NewBytes put: self primitiveNewBytes;
		at: #Equal put: self primitiveEqual;
		at: #SMIPlus put: self primitiveSMIPlus;
		at: #SMIMinus put: self primitiveSMIMinus;
		at: #SMITimes put: self primitiveSMITimes;
		at: #SMIIntDiv put: self primitiveSMIIntDiv;
		at: #SMIIntQuot put: self primitiveSMIIntQuot;
		at: #SMIBitAnd put: self primitiveSMIBitAnd;
		at: #SMIBitOr put: self primitiveSMIBitOr;
		at: #SMIBitXor put: self primitiveSMIBitXor;
		at: #SMIBitShift put: self primitiveSMIBitShift;
		at: #SMIHighBit put: self primitiveSMIHighBit;
		at: #SMIGreaterThan put: self primitiveSMIGreaterThan;
		at: #SMIGreaterEqualThan put: self primitiveSMIGreaterEqualThan;
		at: #SMIEqual put: self primitiveSMIEqual;
		at: #SMINotEqual put: self primitiveSMINotEqual;
		at: #SMISize put: self primitiveSMISize;
		at: #ClosureValue put: self primitiveClosureValue;
		at: #ClosureValueWithArgs put: self primitiveClosureValueWithArgs;
		at: #ClosureArgumentCount put: self primitiveClosureArgumentCount;
		at: #PerformWithArguments put: self primitivePerformWithArguments;
		at: #StringReplaceFromToWithStartingAt
		put: self primitiveStringReplaceFromToWithStartingAt;
		at: #FloatNew put: self primitiveFloatNew;
		at: #DictionaryNew put: self primitiveBootstrapDictNew;
		at: #FlushDispatchCaches put: self primitiveFlushDispatchCaches;
		at: #BootstrapDictBeConstant
		put: self primitiveBootstrapDictBeConstant;
		at: #BootstrapDictKeys put: self primitiveBootstrapDictKeys;
		at: #BootstrapDictAt put: self primitiveBootstrapDictAt;
		at: #BootstrapDictAtPut put: self primitiveBootstrapDictAtPut;
		at: #HostSuspendedBecause put: self primitiveHostSuspendedBecause;
		at: #HostCurrentMilliseconds put: self primitiveHostCurrentMilliseconds;
		at: #HostLoadModule put: self primitiveHostLoadModule;
		at: #HostReadFile put: self primitiveHostReadFile;
		at: #HostPlatformName put: self primitiveHostPlatformName;
		at: #HostFixOverrides put: self primitiveHostFixOverrides;
		at: #PrimeFor put: self primitivePrimeFor;
		at: #FlushFromCaches put: self primitiveFlushFromCaches;
		at: #PrepareForExecution put: self primitivePrepareForExecution;
		at: #ProcessVMStackInitialize
		put: self primitiveProcessVMStackInitialize;
		at: #ProcessVMStackAt put: self primitiveProcessVMStackAt;
		at: #ProcessVMStackAtPut put: self primitiveProcessVMStackAtPut;
		at: #ProcessVMStackBpAtPut put: self primitiveProcessVMStackBpAtPut;
		at: #ProcessVMStackPcAtPut put: self primitiveProcessVMStackPcAtPut;
		at: #ProcessVMStackBP put: self primitiveProcessVMStackBP;
		at: #ProcessVMStackBufferSize
		put: self primitiveProcessVMStackBufferSize;
		at: #ProcessVMStackContextSwitchTo
		put: self primitiveProcessVMStackContextSwitchTo
]

{ #category : 'accessing' }
EggEvaluator >> initializeRecursiveExecutableCodeOf: method [

	| sexpressions executable |
	sexpressions := runtime sexpressionsOf: method.
	executable := runtime newExecutableCodeFor: sexpressions.
	^runtime methodExecutableCode: method put: executable
]

{ #category : 'initializing' }
EggEvaluator >> initializeUndermessages [
	undermessages := IdentityDictionary new.
	undermessages
		at: #_isSmallInteger put: self underprimitiveIsSmallInteger;
		at: #_isLarge put: self underprimitiveIsLarge;
		at: #_smallSize put: self underprimitiveSmallSize;
		at: #_largeSize put: self underprimitiveLargeSize;
		at: #_basicFlags put: self underprimitiveBasicFlags;
		at: #_basicAt: put: self underprimitiveBasicAt;
		at: #_basicAt:put: put: self underprimitiveBasicAtPut;
		at: #_byteAt: put: self underprimitiveByteAt;
		at: #_byteAt:put: put: self underprimitiveByteAtPut;
		at: #_basicHash put: self underprimitiveBasicHash;
		at: #_basicHash: put: self underprimitiveBasicHashPut;
		at: #_smallIntegerByteAt:
			put: self underprimitiveSmallIntegerByteAt;
		at: #_bitShiftLeft: put: self underprimitiveBitShiftLeft;
		at: #_primitiveULongAtOffset: put: self underprimitiveULongAtOffset;
		at: #_primitiveULongAtOffset:put:
			put: self underprimitiveULongAtOffsetPut;
		at: #_uShortAtOffset: put: self underprimitiveUShortAtOffset;
		at: #_uShortAtOffset:put: put: self underprimitiveUShortAtOffsetPut;
		at: #_smiPlus: put: self underprimitiveSMIPlus;
		at: #_smiMinus: put: self underprimitiveSMIMinus;
		at: #_smiTimes: put: self underprimitiveSMITimes;
		at: #_smiLowerThan: put: self underprimitiveSMILowerThan;
		at: #_smiLowerEqualThan: put: self underprimitiveSMILowerEqualThan;
		at: #_smiGreaterThan: put: self underprimitiveSMIGreaterThan;
		at: #_smiGreaterEqualThan:
			put: self underprimitiveSMIGreaterEqualThan;
		at: #_smiEquals: put: self underprimitiveSMIEquals;
		at: #_identityEquals: put: self underprimitiveIdentityEquals;
		at: #_leadingZeroBitCount
			put: self underprimitiveLeadingZeroBitCount;
		at: #_quotientTowardZero:
			put: self underprimitiveSMIQuotientTowardZero;
		at: #_remainderTowardZero:
			put: self underprimitiveSMIRemainderTowardZero;
		at: #_bitShiftLeft: put: self underprimitiveSMIBitShiftLeft;
		at: #_bitShiftRight: put: self underprimitiveSMIBitShiftRight;
		at: #_smiBitAnd: put: self underprimitiveSMIBitAnd;
		at: #_smiBitOr: put: self underprimitiveSMIBitOr;
		at: #_halt put: self underprimitiveHalt
]

{ #category : 'primitives' }
EggEvaluator >> invoke: method with: receiver [
	^self subclassResponsibility
]

{ #category : 'accessing' }
EggEvaluator >> isIdentical: anObject to: anotherObject [
	^ anObject == anotherObject
		or: [ anObject isImmediate
				and: [ anotherObject isImmediate
						and: [ anObject value = anotherObject value ] ] ]
]

{ #category : 'accessing' }
EggEvaluator >> linearizer [
	^self subclassResponsibility
]

{ #category : 'accessing' }
EggEvaluator >> lookup: aSymbol startingAt: aBehavior sendSite: anSMessage [
	| method symbol |
	method := anSMessage methodFor: aBehavior.
	method
		ifNil: [ undermessages
				at: aSymbol
				ifPresent: [ :block | 
					anSMessage cacheUndermessage: block.
					^ block ].
			symbol := runtime symbolFrom: aSymbol.
			method := runtime lookup: symbol startingAt: aBehavior.
			method ifNil: [self messageNotUnderstood: anSMessage. ^nil].
			anSMessage
				registerCacheWith: runtime;
				cache: method when: aBehavior ].
	^ method
]

{ #category : 'initialization' }
EggEvaluator >> nil [
	^nilObj
	
]

{ #category : 'accessing' }
EggEvaluator >> prepareExecutableCode: method [

	| code |
	code := runtime methodExecutableCode: method.
	(runtime isExecutableCode: code) ifTrue: [ ^ code ].
	^ self initializeExecutableCodeOf: method
]

{ #category : 'visiting' }
EggEvaluator >> prepareForExecuting: method [

	| code |
	code := self prepareExecutableCode: method.
	^ runtime executableCodeWork: code
]

{ #category : 'primitives' }
EggEvaluator >> primitiveAt [
	| receiver index value |
	^ [ receiver := context self.
	index := context firstArgument value.
	value := receiver at: index.
	receiver isBytes
		ifTrue: [ runtime newInteger: value ]
		ifFalse: [ value ] ]
]

{ #category : 'primitives' }
EggEvaluator >> primitiveAtPut [
	| index |
	^ [ index := context firstArgument value.
	context self at: index put: context secondArgument ]
]

{ #category : 'primitives' }
EggEvaluator >> primitiveBehavior [
	| receiver |
	^ [ receiver := context self.
	receiver isImmediate
		ifTrue: [ runtime smallIntegerBehavior ]
		ifFalse: [ receiver behavior ] ]
]

{ #category : 'primitives' }
EggEvaluator >> primitiveBootstrapDictAt [
	| string |
	^ [ string := context firstArgument asString.
	context self at: string ]
]

{ #category : 'primitives' }
EggEvaluator >> primitiveBootstrapDictAtPut [
	| string |
	^ [ string := context firstArgument asString.
	context self at: string put: context secondArgument ]
]

{ #category : 'primitives' }
EggEvaluator >> primitiveBootstrapDictBeConstant [
	^ [ context self beConstant ]
]

{ #category : 'primitives' }
EggEvaluator >> primitiveBootstrapDictKeys [
	^ [ context self keys ]
]

{ #category : 'primitives' }
EggEvaluator >> primitiveBootstrapDictNew [
	^ [ runtime newBootstrapDictionaryOf: context self ]
]

{ #category : 'primitives' }
EggEvaluator >> primitiveClass [
	^ [ runtime speciesFor: context self ]
]

{ #category : 'primitives' }
EggEvaluator >> primitiveClosureArgumentCount [
	^ [ runtime newInteger: (runtime blockArgumentCount: (runtime closureBlock: context self)) ]
]

{ #category : 'primitives' }
EggEvaluator >> primitiveClosureValue [
	^ [ self evaluateClosure: context self ]
]

{ #category : 'primitives' }
EggEvaluator >> primitiveClosureValueWithArgs [
	^ [ self
		evaluateClosure: context self
		withArgs: context methodArguments ]
]

{ #category : 'primitives' }
EggEvaluator >> primitiveEqual [
	^ [ runtime booleanFor: context self = context firstArgument ]
]

{ #category : 'primitives' }
EggEvaluator >> primitiveFloatNew [
	^ [ runtime newBytesOf: context self sized: 8 ]
]

{ #category : 'primitives' }
EggEvaluator >> primitiveFlushDispatchCaches [
	^ [ runtime
		flushDispatchCache: context self
		in: context firstArgument ]
]

{ #category : 'primitives' }
EggEvaluator >> primitiveFlushFromCaches [

	^ [ runtime flushDispatchCache: (runtime methodSelector: context self)]
]

{ #category : 'accessing' }
EggEvaluator >> primitiveFor: aSymbol [
	^primitives at: aSymbol
]

{ #category : 'primitives' }
EggEvaluator >> primitiveHash [
	^ [ runtime newInteger: (runtime hashFor: context self) ]
]

{ #category : 'primitives' }
EggEvaluator >> primitiveHostCurrentMilliseconds [

	^ [ runtime newInteger: runtime bootstrapper millisecondClockValue ]
]

{ #category : 'primitives' }
EggEvaluator >> primitiveHostFixOverrides [
	^ [ runtime fixOverrides ]
]

{ #category : 'primitives' }
EggEvaluator >> primitiveHostLoadModule [
	^ [ runtime loadModule: context firstArgument]
]

{ #category : 'primitives' }
EggEvaluator >> primitiveHostPlatformName [

	^ [ runtime newString: runtime bootstrapper architectureName ]
]

{ #category : 'primitives' }
EggEvaluator >> primitiveHostReadFile [
	^ [ runtime readFile: context firstArgument ]
]

{ #category : 'primitives' }
EggEvaluator >> primitiveHostSuspendedBecause [

	^ [ self signalSuspension]
]

{ #category : 'primitives' }
EggEvaluator >> primitiveNew [
	^ [ runtime newSlotsOf: context self ]
]

{ #category : 'primitives' }
EggEvaluator >> primitiveNewBytes [
	| size |
	^ [ size := context firstArgument value.
	runtime newBytesOf: context self sized: size ]
]

{ #category : 'primitives' }
EggEvaluator >> primitiveNewSized [
	| size |
	^ [ size := context firstArgument value.
	runtime newOf: context self sized: size ]
]

{ #category : 'primitives' }
EggEvaluator >> primitivePerformWithArguments [
	^ [ self
		evaluatePerform: context firstArgument in: context self
		withArgs: context secondArgument ]
]

{ #category : 'primitives' }
EggEvaluator >> primitivePrepareForExecution [

	^ [ self prepareForExecuting: context self ]
]

{ #category : 'primitives' }
EggEvaluator >> primitivePrimeFor [
	^ [ self primitivePrimeFor: context firstArgument value ]
]

{ #category : 'accessing' }
EggEvaluator >> primitivePrimeFor: anInteger [
	| result |

	result := #(2 3 5 7 11 13 17 19 23 29 31 37 41 43 47 53 59 61 67 71 73 79 83 89 97 101 103 107 109 113 127 131 137 139 149 151 157 163 167 173 179 181 191 193 197 199 211 223 227 229 233 239 241 251 269 359 479 641 857 1151 1549 2069 2237 2423 2617 2797 2999 3167 3359 3539 3727 3911 4441 4787 5119 5471 5801 6143 6521 6827 7177 7517 7853 8783 9601 10243 10867 11549 12239 12919 13679 14293 15013 15731 17569 19051 20443 21767 23159 24611 25847 27397 28571 30047 31397 35771 38201 40841 43973 46633 48989 51631 54371 57349 60139 62969)
		detect: [ :i | i >= anInteger ].
	^ runtime newInteger: result
]

{ #category : 'primitives' }
EggEvaluator >> primitiveProcessVMStackAt [

	^ [ 
	  (stacks at: context receiver) stack
		  at: context firstArgument value
		 ]
]

{ #category : 'primitives' }
EggEvaluator >> primitiveProcessVMStackAtPut [

	^ [ (stacks at: context receiver) stack at: context firstArgument value put: context secondArgument ]
]

{ #category : 'primitives' }
EggEvaluator >> primitiveProcessVMStackBP [

	^ [ runtime newSmallInteger: context regBP ]
]

{ #category : 'primitives' }
EggEvaluator >> primitiveProcessVMStackBpAtPut [

	^ [ 
	  (stacks at: context receiver) stack
		  at: context firstArgument value
		  put: context secondArgument value ]
]

{ #category : 'primitives' }
EggEvaluator >> primitiveProcessVMStackBufferSize [

	^ [ runtime newInteger: (stacks at: context receiver) stackSize ]
]

{ #category : 'primitives' }
EggEvaluator >> primitiveProcessVMStackContextSwitchTo [

	^ [ 
	  self contextSwitchTo: context firstArgument ]
]

{ #category : 'primitives' }
EggEvaluator >> primitiveProcessVMStackInitialize [

	^ [ 
	  | new |
	  new := stacks isEmpty
		         ifTrue: [ context ]
		         ifFalse: [ self newEvaluationContext ].
	  stacks at: context self put: new ]
]

{ #category : 'primitives' }
EggEvaluator >> primitiveProcessVMStackPcAtPut [

	^ [ 
	  (stacks at: context receiver) stack
		  at: context firstArgument value
		  put: context secondArgument value ]
]

{ #category : 'primitives' }
EggEvaluator >> primitiveSMIBitAnd [
	^ [ runtime
		newInteger:
			(context self value
				bitAnd: (runtime integerFrom: context firstArgument)) ]
]

{ #category : 'primitives' }
EggEvaluator >> primitiveSMIBitOr [
	^ [ runtime
		newInteger:
			(context self value
				bitOr: (runtime integerFrom: context firstArgument)) ]
]

{ #category : 'primitives' }
EggEvaluator >> primitiveSMIBitShift [
	^ [ runtime
		newInteger:
			(context self value
				bitShift: (runtime integerFrom: context firstArgument)) ]
]

{ #category : 'primitives' }
EggEvaluator >> primitiveSMIBitXor [
	^ [ runtime
		newInteger:
			(context self value
				bitXor: (runtime integerFrom: context firstArgument)) ]
]

{ #category : 'primitives' }
EggEvaluator >> primitiveSMIEqual [
	^ [ runtime
		booleanFor: (
			context self value = 
				context firstArgument value) ]
]

{ #category : 'primitives' }
EggEvaluator >> primitiveSMIGreaterEqualThan [
	^ [ runtime
		booleanFor:
			context self value
				>= (runtime integerFrom: context firstArgument) ]
]

{ #category : 'primitives' }
EggEvaluator >> primitiveSMIGreaterThan [
	^ [ runtime
		booleanFor: context self value > (runtime integerFrom: context firstArgument) ]
]

{ #category : 'primitives' }
EggEvaluator >> primitiveSMIHighBit [
	^ [ runtime newInteger: context self value highBit ]
]

{ #category : 'primitives' }
EggEvaluator >> primitiveSMIIntDiv [
	^ [ runtime
		newInteger:
			context self value
				// (runtime integerFrom: context firstArgument ) ]
]

{ #category : 'primitives' }
EggEvaluator >> primitiveSMIIntQuot [
	^ [ runtime
		newInteger:
			context self value
				\\ (runtime integerFrom: context firstArgument) ]
]

{ #category : 'primitives' }
EggEvaluator >> primitiveSMIMinus [
	^ [ runtime
		newInteger:
			context self value
				- (runtime integerFrom: context firstArgument) ]
]

{ #category : 'primitives' }
EggEvaluator >> primitiveSMINotEqual [
	^ [ runtime
		booleanFor:
			context self value
				!= (runtime integerFrom: context firstArgument) ]
]

{ #category : 'primitives' }
EggEvaluator >> primitiveSMIPlus [
	^ [ runtime
		newInteger:
			context self value
				+ (runtime integerFrom: context firstArgument) ]
]

{ #category : 'primitives' }
EggEvaluator >> primitiveSMISize [
	^ [ runtime newInteger: context self value bytesCount ]
]

{ #category : 'primitives' }
EggEvaluator >> primitiveSMITimes [
	^ [ runtime
		newInteger:
			context self value
				* (runtime integerFrom: context firstArgument) ]
]

{ #category : 'primitives' }
EggEvaluator >> primitiveSetBehavior [
	| receiver |
	^ [ receiver := context self.
	receiver behavior: context firstArgument.
	receiver ]
]

{ #category : 'primitives' }
EggEvaluator >> primitiveSize [
	^ [ runtime newInteger: (runtime arrayedSizeOf: context self) ]
]

{ #category : 'primitives' }
EggEvaluator >> primitiveStringReplaceFromToWithStartingAt [
	| receiver |
	^ [ receiver := context self.
	receiver bytes
		replaceFrom: context firstArgument value
		to: context secondArgument value
		with: context thirdArgument bytes
		startingAt: context fourthArgument value.
	receiver ]
]

{ #category : 'primitives' }
EggEvaluator >> primitiveUnderHash [
	^ [ runtime newInteger: context self headerHash ]
]

{ #category : 'primitives' }
EggEvaluator >> primitiveUnderIsBytes [
	^ [ runtime booleanFor: context self isBytes ]
]

{ #category : 'primitives' }
EggEvaluator >> primitiveUnderPointersSize [
	^ [ runtime newInteger: context self pointersSize ]
]

{ #category : 'primitives' }
EggEvaluator >> primitiveUnderSize [
	^ [ runtime newInteger: context self size ]
]

{ #category : 'initializing' }
EggEvaluator >> runtime [
	^runtime

]

{ #category : 'initializing' }
EggEvaluator >> runtime: anEggRuntime [
	runtime := anEggRuntime.
	nilObj := runtime nil.
	trueObj := runtime true.
	falseObj := runtime false.
	self
		initializeUndermessages;
		initializePrimitives; convertUndermessages ; convertPrimitives 
]

{ #category : 'accessing' }
EggEvaluator >> sendLocal: aSymbol to: receiver [
	^ self sendLocal: aSymbol to: receiver with: {}
]

{ #category : 'accessing' }
EggEvaluator >> signalSuspension [
	| originator error |
	originator := self contextForProcess: context firstArgument.
	error := EggProcessSuspended new
		process: context firstArgument;
		exception: context secondArgument;
		context: originator.
	error signal
]

{ #category : 'accessing' }
EggEvaluator >> stackSize [
	^context framesCount
]

{ #category : 'initialization' }
EggEvaluator >> true [
	^ trueObj
]

{ #category : 'underprimitives' }
EggEvaluator >> underprimitiveBasicAt [
	^ [ :receiver :arguments | receiver slots at: arguments first value ]
]

{ #category : 'underprimitives' }
EggEvaluator >> underprimitiveBasicAtPut [

	^ [ :receiver :arguments | 
	  receiver slots
		  at: arguments first value
		  put: arguments second.
	  arguments second ]
]

{ #category : 'accessing' }
EggEvaluator >> underprimitiveBasicFlags [
	^ [ :receiver :arguments | runtime newInteger: receiver headerFlags ]
]

{ #category : 'accessing' }
EggEvaluator >> underprimitiveBasicHash [
	^ [ :receiver :arguments | runtime newInteger: receiver headerHash ]
]

{ #category : 'accessing' }
EggEvaluator >> underprimitiveBasicHashPut [
	^ [ :receiver :arguments | receiver headerHash: arguments first value ]
]

{ #category : 'accessing' }
EggEvaluator >> underprimitiveBitShiftLeft [
	| result |
	^ [ :receiver :arguments | 
	result := receiver value bitShift: arguments first value.
	runtime newInteger: result ]
]

{ #category : 'accessing' }
EggEvaluator >> underprimitiveByteAt [
	| result |
	^ [ :receiver :arguments | 
	result := receiver bytes at: arguments first value.
	runtime newInteger: result ]
]

{ #category : 'accessing' }
EggEvaluator >> underprimitiveByteAtPut [

	^ [ :receiver :arguments | 
	receiver bytes
		at: arguments first value
		put: arguments second value.
	arguments second ]
]

{ #category : 'accessing' }
EggEvaluator >> underprimitiveHalt [
	^ [ :receiver :arguments | receiver halt ]
]

{ #category : 'accessing' }
EggEvaluator >> underprimitiveIdentityEquals [
	^ [ :receiver :arguments | runtime booleanFor: (self isIdentical: receiver to: arguments first)]
]

{ #category : 'accessing' }
EggEvaluator >> underprimitiveIsLarge [
	^ [ :receiver :arguments | runtime booleanFor: receiver isSmall not ]
]

{ #category : 'accessing' }
EggEvaluator >> underprimitiveIsSmallInteger [
	^ [ :receiver :arguments | runtime booleanFor: receiver isImmediate ]
]

{ #category : 'accessing' }
EggEvaluator >> underprimitiveLargeSize [
	^ [ :receiver :arguments | 
	receiver isSmall
		ifTrue: [ self error ].
	runtime newInteger: receiver size ]
]

{ #category : 'accessing' }
EggEvaluator >> underprimitiveLeadingZeroBitCount [
	^ [ :receiver :arguments | 
	runtime
		newInteger: (self
		underprimitiveLeadingZeroBitCount: receiver value) ]
]

{ #category : 'accessing' }
EggEvaluator >> underprimitiveLeadingZeroBitCount: anInteger [
	^ anInteger < 0
		ifTrue: [ 0 ]
		ifFalse: [ runtime wordSize * 8 - anInteger highBit ]
]

{ #category : 'accessing' }
EggEvaluator >> underprimitiveSMIBitAnd [
	^ [ :receiver :arguments | runtime newInteger: (receiver value bitAnd: arguments first value) ]
]

{ #category : 'accessing' }
EggEvaluator >> underprimitiveSMIBitOr [
	^ [ :receiver :arguments | runtime newInteger: (receiver value bitOr: arguments first value) ]
]

{ #category : 'accessing' }
EggEvaluator >> underprimitiveSMIBitShiftLeft [
	^ [ :receiver :arguments | runtime newInteger: receiver value << arguments first value ]
]

{ #category : 'accessing' }
EggEvaluator >> underprimitiveSMIBitShiftRight [
	^ [ :receiver :arguments | 
	runtime
		newInteger: (receiver value >> arguments first value) ]
]

{ #category : 'accessing' }
EggEvaluator >> underprimitiveSMIEquals [
	^ [ :receiver :arguments | runtime booleanFor: receiver value = arguments first value ]
]

{ #category : 'accessing' }
EggEvaluator >> underprimitiveSMIGreaterEqualThan [
	^ [ :receiver :arguments | runtime booleanFor: receiver value >= arguments first value ]
]

{ #category : 'accessing' }
EggEvaluator >> underprimitiveSMIGreaterThan [
	^ [ :receiver :arguments | runtime booleanFor: receiver value > arguments first value ]
]

{ #category : 'accessing' }
EggEvaluator >> underprimitiveSMILowerEqualThan [
	^ [ :receiver :arguments | runtime booleanFor: receiver value <= arguments first value ]
]

{ #category : 'accessing' }
EggEvaluator >> underprimitiveSMILowerThan [
	^ [ :receiver :arguments | runtime booleanFor: receiver value < arguments first value ]
]

{ #category : 'accessing' }
EggEvaluator >> underprimitiveSMIMinus [
	^ [ :receiver :arguments | runtime newInteger: receiver value - arguments first value ]
]

{ #category : 'accessing' }
EggEvaluator >> underprimitiveSMIPlus [
	^ [ :receiver :arguments | runtime newInteger: receiver value + arguments first value ]
]

{ #category : 'accessing' }
EggEvaluator >> underprimitiveSMIQuotientTowardZero [
	^ [ :receiver :arguments | runtime newInteger: (receiver value quo: arguments first value) ]
]

{ #category : 'accessing' }
EggEvaluator >> underprimitiveSMIRemainderTowardZero [
	^ [ :receiver :arguments | runtime newInteger: (receiver value \\ arguments first value) ]
]

{ #category : 'accessing' }
EggEvaluator >> underprimitiveSMITimes [
	^ [ :receiver :arguments | runtime newInteger: receiver value * arguments first value ]
]

{ #category : 'accessing' }
EggEvaluator >> underprimitiveSmallIntegerByteAt [
	| result |
	^ [ :receiver :arguments | 
	result := receiver value byteAt: arguments first value.
	runtime newInteger: result ]
]

{ #category : 'accessing' }
EggEvaluator >> underprimitiveSmallSize [
	^ [ :receiver :arguments | 
	receiver isSmall
		ifFalse: [ self error ].
	runtime newInteger: receiver size ]
]

{ #category : 'accessing' }
EggEvaluator >> underprimitiveULongAtOffset [
	| result |
	^ [ :receiver :arguments | 
	result := receiver bytes unsignedLongAt: arguments second value + 1.
	runtime newInteger: result ]
]

{ #category : 'accessing' }
EggEvaluator >> underprimitiveULongAtOffsetPut [
	| value |
	^ [ :receiver :arguments | 
	value := arguments second.
	receiver bytes
		unsignedLongAt: arguments first value + 1
		put: value value.
	value ]
]

{ #category : 'accessing' }
EggEvaluator >> underprimitiveUShortAtOffset [
	| result |
	^ [ :receiver :arguments | 
	result := receiver bytes
		unsignedShortAt: arguments second value + 1.
	runtime newInteger: result ]
]

{ #category : 'accessing' }
EggEvaluator >> underprimitiveUShortAtOffsetPut [
	| value |
	^ [ :receiver :arguments | 
	value := arguments second.
	receiver bytes
		unsignedShortAt: arguments first value + 1
		put: value value.
	value ]
]
