Class {
	#name : #PowertalkIterativeStackedInterpreter,
	#superclass : #PowertalkIterativeInterpreter,
	#instVars : [
		'linearizer',
		'work'
	],
	#category : #'Powerlang-Core-Execution'
}

{ #category : #initialization }
PowertalkIterativeStackedInterpreter >> evaluate [
	| operation |
	[ operation := self nextOperation.
	operation notNil ] whileTrue: [ operation acceptVisitor: self ].
	^ regR
]

{ #category : #private }
PowertalkIterativeStackedInterpreter >> evaluateClosure: closure withArgs: arguments [

	| block code receiver |
	block := runtime closureBlock: closure.
	code := self prepareBlockExecutableCode: block.
	work := runtime executableCodeWork: code.
	receiver := (runtime blockCapturesSelf: block)
		            ifTrue: [ closure at: 1 ]
		            ifFalse: [ nilObj ].
	context
		popFrame;
		buildClosureFrameFor: receiver code: block environment: closure.
	^ regR
]

{ #category : #initialization }
PowertalkIterativeStackedInterpreter >> evaluateUndermessage: message with: block [
	| argcount arguments |
	argcount := message argumentCount.
	arguments := context popOperands: argcount.
	regR := block value: regR value: arguments.
	context reserveStackSlots: argcount
]

{ #category : #initialization }
PowertalkIterativeStackedInterpreter >> initialize [
	super initialize.
	context := StackedEvaluationContext new.
	linearizer := SExpressionLinearizer new
]

{ #category : #private }
PowertalkIterativeStackedInterpreter >> initializeExecutableCodeOf: method [

	^ self initializeLinearExecutableCodeOf: method
]

{ #category : #initialization }
PowertalkIterativeStackedInterpreter >> initializePrimitives [
	super initializePrimitives.
	linearizer primitives: primitives
]

{ #category : #private }
PowertalkIterativeStackedInterpreter >> linearizer [
	^linearizer
]

{ #category : #initialization }
PowertalkIterativeStackedInterpreter >> nextOperation [
 | pc |
pc := context incRegPC.
	pc <= work size
		ifFalse: [ ^ nil ].
	^ work at: pc
]

{ #category : #private }
PowertalkIterativeStackedInterpreter >> prepareBlockExecutableCode: block [

	| code method |
	code := runtime blockOptimizedCode: block.
	(runtime isExecutableCode: code) ifTrue: [ ^ code ].
	method := runtime blockMethod: block.
	self initializeExecutableCodeOf: method.
	code := runtime blockOptimizedCode: block.
	self ASSERT: (runtime isExecutableCode: code).
	^ code
]

{ #category : #initializing }
PowertalkIterativeStackedInterpreter >> runtime: aPowertalkRuntime [
	super runtime: aPowertalkRuntime.
	linearizer
		runtime: aPowertalkRuntime;
		dropsArguments.
	context system: runtime
]

{ #category : #initialization }
PowertalkIterativeStackedInterpreter >> sendLocal: aSymbol to: receiver with: anArray [
	| symbol literal dummy message dispatch prevWork prevPC |
	symbol := runtime symbolFromLocal: aSymbol.
	literal := SLiteral new value: nilObj.
	dummy := Array new: anArray size withAll: nil.
	message := SMessage new
		selector: symbol;
		receiver: literal;
		arguments: dummy.
	dispatch := SOpDispatchMessage new message: message.
	prevWork := work.
	prevPC := context regPC.
	context buildLaunchFrame.
	regR := receiver.
	anArray isEmpty
		ifFalse: [ context pushOperand: receiver ].
	anArray do: [ :arg | context pushOperand: arg ].
	work := {dispatch}.
	context regPC: 0.
	self evaluate.
	context popLaunchFrame.
	work := prevWork.
	context regPC: prevPC.
	^ regR
]

{ #category : #initialization }
PowertalkIterativeStackedInterpreter >> underprimitiveRestart [
	^ [ :receiver :arguments | context restart ]
]

{ #category : #initialization }
PowertalkIterativeStackedInterpreter >> visitOpDispatchMessage: anSOpDispatchMessage [

	| message behavior method size environment work1 |
	message := anSOpDispatchMessage message.
	message cachedUndermessage ifNotNil: [ :block | 
		^ self evaluateUndermessage: message with: block ].
	behavior := message receiver isSuper
		            ifTrue: [ runtime superBehaviorOf: context classBinding ]
		            ifFalse: [ runtime behaviorOf: regR ].
	method := self
		          lookup: message selector
		          startingAt: behavior
		          sendSite: message.
	method isBlock ifTrue: [ 
		^ self evaluateUndermessage: message with: method ].
	size := runtime methodEnvironmentSize: method.
	environment := runtime newEnvironmentSized: size.
	work1 := self prepareForExecuting: method.
	self assert: work1 notNil.
	work := work1.
	context
		buildMethodFrameFor: regR
		code: method
		environment: environment
]

{ #category : #initialization }
PowertalkIterativeStackedInterpreter >> visitOpJump: anSOpJump [
	context regPC: anSOpJump target
]

{ #category : #initialization }
PowertalkIterativeStackedInterpreter >> visitOpJumpFalse: anSOpJumpFalse [
	regR == falseObj
		ifTrue: [ context regPC: anSOpJumpFalse target ]
]

{ #category : #initialization }
PowertalkIterativeStackedInterpreter >> visitOpJumpTrue: anSOpJumpTrue [
	regR == trueObj
		ifTrue: [ context regPC: anSOpJumpTrue target ]
]

{ #category : #initialization }
PowertalkIterativeStackedInterpreter >> visitOpNonLocalReturn: anSOpReturn [

	| code |
	context unwind.
	code := runtime methodOptimizedCode: context regM.
	work := runtime executableCodeWork: code
]

{ #category : #initialization }
PowertalkIterativeStackedInterpreter >> visitOpPopR: anSOpPopR [
	regR := context pop
]

{ #category : #initialization }
PowertalkIterativeStackedInterpreter >> visitOpPrimitive: anSOpPrimtive [
	regR := anSOpPrimtive block value
]

{ #category : #initialization }
PowertalkIterativeStackedInterpreter >> visitOpReturn: anSOpReturn [

	| code |
	context popFrame.
	code := runtime methodOptimizedCode: context regM.
		work := runtime executableCodeWork: code.
]
