Class {
	#name : #EggIterativeStackedInterpreter,
	#superclass : #EggIterativeInterpreter,
	#instVars : [
		'linearizer',
		'work'
	],
	#category : #'Powerlang-Core-Execution'
}

{ #category : #initialization }
EggIterativeStackedInterpreter >> contextSwitchTo: vmStack [

	| sp |
	context := stacks at: vmStack.
	sp := runtime processStackSP: vmStack.
	context regSP: sp value.
	context
		environment: context pop;
		regBP: context regSP.
	self popFrameAndPrepare.
	^ trueObj
]

{ #category : #initialization }
EggIterativeStackedInterpreter >> evaluate [
	| operation |
	[ operation := self nextOperation.
	operation notNil ] whileTrue: [ operation acceptVisitor: self ].
	^ regR
]

{ #category : #private }
EggIterativeStackedInterpreter >> evaluateClosure: closure withArgs: arguments [

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
EggIterativeStackedInterpreter >> evaluateUndermessage: message with: block [
	| argcount arguments |
	argcount := message argumentCount.
	arguments := context popOperands: argcount.
	regR := block value: regR value: arguments.
	context reserveStackSlots: argcount
]

{ #category : #initialization }
EggIterativeStackedInterpreter >> initialize [
	super initialize.
	linearizer := SExpressionLinearizer new
]

{ #category : #private }
EggIterativeStackedInterpreter >> initializeExecutableCodeOf: method [

	^ self initializeLinearExecutableCodeOf: method
]

{ #category : #initialization }
EggIterativeStackedInterpreter >> initializePrimitives [
	super initializePrimitives.
	linearizer primitives: primitives
]

{ #category : #initialization }
EggIterativeStackedInterpreter >> invoke: method with: receiver [
	| size environment |
	size := runtime methodEnvironmentSize: method.
	environment := runtime newEnvironmentSized: size.
	work := self prepareForExecuting: method.
	context
		buildMethodFrameFor: receiver
		code: method
		environment: environment.
	^regR
]

{ #category : #private }
EggIterativeStackedInterpreter >> linearizer [
	^linearizer
]

{ #category : #initialization }
EggIterativeStackedInterpreter >> messageNotUnderstood: anSMessage [

	"
	Having the adaptor causes argument popping work transparently. The adaptor frame's
	PC is pointed to the instant after the send, so it just pops the message and continues
"

	| count args array dnu |
	count := anSMessage arguments size.
	args := (1 to: count) collect: [ :i | context operandAt: count - i ].
	array := runtime newArray: args.
	context
		push: anSMessage selector;
		push: array.
	dnu := runtime doesNotUnderstandMethod.
	self invoke: dnu with: regR
]

{ #category : #initialization }
EggIterativeStackedInterpreter >> newEvaluationContext [

	^StackedEvaluationContext new runtime: runtime
]

{ #category : #initialization }
EggIterativeStackedInterpreter >> nextOperation [
 | pc |
pc := context incRegPC.
	pc <= work size
		ifFalse: [ ^ nil ].
	^ work at: pc
]

{ #category : #initialization }
EggIterativeStackedInterpreter >> popFrameAndPrepare [
	| code |
	context popFrame.
	code := runtime methodExecutableCode: context regM.
	work := runtime executableCodeWork: code
]

{ #category : #private }
EggIterativeStackedInterpreter >> prepareBlockExecutableCode: block [

	| code method |
	code := runtime blockExecutableCode: block.
	(runtime isExecutableCode: code) ifTrue: [ ^ code ].
	method := runtime blockMethod: block.
	self initializeExecutableCodeOf: method.
	code := runtime blockExecutableCode: block.
	self ASSERT: (runtime isExecutableCode: code).
	^ code
]

{ #category : #initializing }
EggIterativeStackedInterpreter >> runtime: anEggRuntime [

	super runtime: anEggRuntime.
	linearizer
		runtime: anEggRuntime;
		dropsArguments.
	context := self newEvaluationContext
]

{ #category : #initialization }
EggIterativeStackedInterpreter >> sendLocal: aSymbol to: receiver with: anArray [
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
EggIterativeStackedInterpreter >> underprimitiveRestart [
	^ [ :receiver :arguments | context restart ]
]

{ #category : #initialization }
EggIterativeStackedInterpreter >> visitOpDispatchMessage: anSOpDispatchMessage [

	| message behavior method |
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
	method ifNil: [ ^self messageNotUnderstood: message ].
	method isBlock ifTrue: [ 
		^ self evaluateUndermessage: message with: method ].
	^ self invoke: method with: regR
]

{ #category : #initialization }
EggIterativeStackedInterpreter >> visitOpJump: anSOpJump [
	context regPC: anSOpJump target
]

{ #category : #initialization }
EggIterativeStackedInterpreter >> visitOpJumpFalse: anSOpJumpFalse [
	regR == falseObj
		ifTrue: [ context regPC: anSOpJumpFalse target ]
]

{ #category : #initialization }
EggIterativeStackedInterpreter >> visitOpJumpTrue: anSOpJumpTrue [
	regR == trueObj
		ifTrue: [ context regPC: anSOpJumpTrue target ]
]

{ #category : #initialization }
EggIterativeStackedInterpreter >> visitOpNonLocalReturn: anSOpReturn [

	| code |
	context unwind.
	code := runtime methodExecutableCode: context regM.
	work := runtime executableCodeWork: code
]

{ #category : #initialization }
EggIterativeStackedInterpreter >> visitOpPopR: anSOpPopR [
	regR := context pop
]

{ #category : #initialization }
EggIterativeStackedInterpreter >> visitOpPrimitive: anSOpPrimtive [
	regR := anSOpPrimtive block value
]

{ #category : #initialization }
EggIterativeStackedInterpreter >> visitOpReturn: anSOpReturn [

	self popFrameAndPrepare
]
