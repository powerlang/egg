Class {
	#name : #EggRecursiveInterpreter,
	#superclass : #EggEvaluator,
	#category : #'Powerlang-Core-Execution'
}

{ #category : #visiting }
EggRecursiveInterpreter >> evaluateClosure: receiver whileFalse: arg [
	| result |
	[ result := self evaluateClosure: receiver.
	self booleanFrom: result ]
		whileFalse: [ self evaluateClosure: arg ].
	^ receiver
]

{ #category : #visiting }
EggRecursiveInterpreter >> evaluateClosure: receiver whileTrue: arg [
	| result |
	[ result := self evaluateClosure: receiver.
	self booleanFrom: result ] whileTrue: [ self evaluateClosure: arg ].
	^ receiver
]

{ #category : #private }
EggRecursiveInterpreter >> evaluateClosure: closure withArgs: arguments [
	| frame sblock result |
	frame := closure builder.
	sblock := closure executionTree.
	context := frame copy
		beBlock;
		parent: context;
		initializeForBlock: sblock args: arguments closure: closure.
	result := nilObj.
	sblock statements do: [ :node | result := node acceptVisitor: self ].
	^ result
]

{ #category : #services }
EggRecursiveInterpreter >> evaluateMethodStatements: anSMethod [
	| last result |
	last := nil.
	anSMethod statements
		do: [ :node | 
			last := node.
			result := node acceptVisitor: self ].
	^ (last notNil and: [ last isReturn ])
		ifTrue: [ result ]
		ifFalse: [ context self ]
]

{ #category : #visiting }
EggRecursiveInterpreter >> hasFinished [
	^context isNil
]

{ #category : #visiting }
EggRecursiveInterpreter >> initializeExecutableCodeOf: method [

	^self initializeRecursiveExecutableCodeOf: method
]

{ #category : #visiting }
EggRecursiveInterpreter >> initializePrimitives [ 
	super initializePrimitives.
	primitives 
		at: #ClosureWhileTrue put: self primitiveClosureWhileTrue;
		at: #ClosureWhileFalse put: self primitiveClosureWhileFalse
]

{ #category : #initializing }
EggRecursiveInterpreter >> linearizer [

	self shouldNotImplement
]

{ #category : #visiting }
EggRecursiveInterpreter >> primitiveClosureWhileFalse [
	^ [ self
		evaluateClosure: context self
		whileFalse: context arguments first ]
]

{ #category : #visiting }
EggRecursiveInterpreter >> primitiveClosureWhileTrue [
	^ [ self
		evaluateClosure: context self
		whileTrue: context arguments first ]
]

{ #category : #initializing }
EggRecursiveInterpreter >> runtime: aPowertalkRuntime [
	super runtime: aPowertalkRuntime.
	aPowertalkRuntime
		override: #Closure -> #whileTrue: withPrimitive: 'ClosureWhileTrue';
		override: #Closure -> #whileFalse: withPrimitive: 'ClosureWhileFalse'
]

{ #category : #visiting }
EggRecursiveInterpreter >> send: aSymbol to: receiver with: arguments super: aBoolean [
	^self send: aSymbol to: receiver with: arguments super: aBoolean sendSite: SMessage new

]

{ #category : #visiting }
EggRecursiveInterpreter >> send: aSymbol to: receiver with: arguments super: aBoolean sendSite: anSMessage [
	| behavior method environment size |
	anSMessage cachedUndermessage
		ifNotNil: [ :block | ^ block value: receiver value: arguments ].
	behavior := aBoolean
		ifTrue: [ runtime superBehaviorOf: context classBinding ]
		ifFalse: [ runtime behaviorOf: receiver ].
	method := self
		lookup: aSymbol
		startingAt: behavior
		sendSite: anSMessage.
	method isBlock
		ifTrue: [ ^ method value: receiver value: arguments ].
	self ASSERT: method notNil.
	size := runtime methodEnvironmentSize: method.
	environment := runtime newEnvironmentSized: size.
	context := RecursiveLinkedEvaluationContext new
		self: receiver;
		arguments: arguments;
		environment: environment;
		parent: context;
		method: method;
		system: runtime.
	^ context evaluateFor: self
]

{ #category : #visiting }
EggRecursiveInterpreter >> sendLocal: aSymbol to: receiver with: anArray [
	| symbol res |
	symbol := runtime symbolFromLocal: aSymbol.
	res := self
		send: symbol
		to: receiver
		with: anArray
		super: false.
	^ res
]

{ #category : #visiting }
EggRecursiveInterpreter >> visitAssignment: anSAssignment [

	| result assignees binding |
	result := anSAssignment expression acceptVisitor: self.
	assignees := anSAssignment assignees.
	assignees do: [ :identifier | 
		binding := identifier binding.
		binding assign: result within: context ifUnbound: [self unboundAssignment: binding with: assignees]].
	^ result
]

{ #category : #visiting }
EggRecursiveInterpreter >> visitBlock: anSBlock [
	^ context captureClosure: anSBlock
]

{ #category : #visiting }
EggRecursiveInterpreter >> visitCascade: anSCascade [
	| recv args  last |
	recv := anSCascade receiver acceptVisitor: self.
	anSCascade messages
		do: [ :msg | 
			args := msg arguments collect: [ :code | code acceptVisitor: self ].
			last := self
				send: msg selector
				to: recv
				with: args
				super: anSCascade receiver isSuper
				sendSite: msg ].
	^ last
]

{ #category : #visiting }
EggRecursiveInterpreter >> visitIdentifier: anSIdentifier [
	| binding |
	binding := anSIdentifier binding.
	^ binding valueWithin: context ifUnbound: [ self doesNotKnow: binding name ]
]

{ #category : #visiting }
EggRecursiveInterpreter >> visitLiteral: anSLiteral [
	^ runtime literalFor: anSLiteral value
]

{ #category : #visiting }
EggRecursiveInterpreter >> visitMessage: anSMessage [
	| recv args |
	recv := anSMessage receiver acceptVisitor: self.
	args := anSMessage arguments
		collect: [ :code | code acceptVisitor: self ].
	^ self
		send: anSMessage selector
		to: recv
		with: args
		super: anSMessage receiver isSuper
		sendSite: anSMessage
]

{ #category : #visiting }
EggRecursiveInterpreter >> visitMethod: anSMethod [
	| primitive |
	primitive := anSMethod pragma.
	primitive ifNil: [ ^ self evaluateMethodStatements: anSMethod ].
	primitive class == SPragma
		ifTrue: [ primitive := self primitiveFor: anSMethod primitive.
			anSMethod pragma: primitive ].
	^ primitive value
]

{ #category : #visiting }
EggRecursiveInterpreter >> visitReturn: anSReturn [
	| value |
	value := anSReturn expression acceptVisitor: self.
	^context return: value
]
