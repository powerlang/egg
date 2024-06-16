Class {
	#name : #EggLinkedTreeInterpreter,
	#superclass : #EggIterativeLinkedInterpreter,
	#category : 'Powerlang-Core-Execution'
}

{ #category : #accessing }
EggLinkedTreeInterpreter >> dropToS [
	context pushOperation: SOpDropToS new
]

{ #category : #accessing }
EggLinkedTreeInterpreter >> evaluate [
	| operation |
	[ context hasWork ]
		whileTrue: [ operation := context popOperation.
			operation acceptVisitor: self ].
	Transcript print: 'MessageCount: ' , messageCount asString; cr.
	^ regR
]

{ #category : #accessing }
EggLinkedTreeInterpreter >> evaluationContextClass [
	^ LinkedTreeEvaluationContext
]

{ #category : #accessing }
EggLinkedTreeInterpreter >> initializeExecutableCodeOf: method [

	^self initializeRecursiveExecutableCodeOf: method
]

{ #category : #accessing }
EggLinkedTreeInterpreter >> linearizer [

	self shouldNotImplement
]

{ #category : #accessing }
EggLinkedTreeInterpreter >> loadRfromStack: anInteger [
	| load |
	load := SOpLoadRfromStack new index: anInteger.
		context pushOperation: load
]

{ #category : #accessing }
EggLinkedTreeInterpreter >> loadRwithSelf [
		context pushOperation:SOpLoadRwithSelf new
]

{ #category : #accessing }
EggLinkedTreeInterpreter >> prepareDispatch: dispatch [
	context pushOperation: dispatch
]

{ #category : #accessing }
EggLinkedTreeInterpreter >> prepareForBlock: sblock [
	| statements |
	statements := sblock statements.
	(statements isEmpty orNot: [ statements last isReturn ])
		ifTrue: [ context pushOperation: SOpReturn new ].
	statements reverseDo: [ :exp | context pushOperation: exp ].
	^ nilObj
]

{ #category : #accessing }
EggLinkedTreeInterpreter >> prepareForExecuting: method [

	| work |
	work := super prepareForExecuting: method.
	self push: work
]

{ #category : #accessing }
EggLinkedTreeInterpreter >> push: anSExpression [
		context pushOperation: anSExpression
]

{ #category : #accessing }
EggLinkedTreeInterpreter >> pushOpAssign: aCollection [
	| op |
	op := SOpAssign new assignees: aCollection.
		context pushOperation: op
]

{ #category : #accessing }
EggLinkedTreeInterpreter >> pushOpReturn [
		context pushOperation: SOpReturn new
]

{ #category : #accessing }
EggLinkedTreeInterpreter >> pushOpReturn: aBoolean [
	| class |
	class := (aBoolean andNot: [ context isBlock ])
		ifTrue: [ SOpReturn ]
		ifFalse: [ SOpNonLocalReturn ].
	context pushOperation: class new
]

{ #category : #accessing }
EggLinkedTreeInterpreter >> pushR [
		context pushOperation: SOpPushR new
]

{ #category : #initializing }
EggLinkedTreeInterpreter >> underprimitiveRestart [

	^ [ :receiver :arguments | 
	  
	  context
		  restart.
		self prepareForExecuting: context method.
	  
		   ]
]

{ #category : #accessing }
EggLinkedTreeInterpreter >> visitAssignment: anSAssignment [
	self
		pushOpAssign: anSAssignment assignees;		push: anSAssignment expression

]

{ #category : #accessing }
EggLinkedTreeInterpreter >> visitCascade: anSCascade [
	| dispatch args argsize |
	self dropToS.
	anSCascade messages
		reverseDo: [ :msg | 
			dispatch := SOpDispatchMessage new message: msg.
			self push: dispatch.
			args := msg arguments.
			argsize := args size.
			self loadRfromStack: argsize.
			args
				reverseDo: [ :arg | 
					self
						pushR;
						push: arg ] ].
	self
		pushR;
		push: anSCascade receiver
]

{ #category : #accessing }
EggLinkedTreeInterpreter >> visitMessage: anSMessage [
	| dispatch args argsize |
	messageCount := messageCount + 1.
	dispatch := SOpDispatchMessage new message: anSMessage.
	self push: dispatch.
	args := anSMessage arguments.
	argsize := args size.
	argsize > 0
		ifTrue: [ self loadRfromStack: argsize ].
	args
		reverseDo: [ :arg | 
			self
				pushR;
				push: arg ].
	argsize > 0
		ifTrue: [ self pushR ].
	self push: anSMessage receiver
]

{ #category : #accessing }
EggLinkedTreeInterpreter >> visitMethod: anSMethod [
	| primitive statements |
	primitive := anSMethod pragma.
	primitive
		ifNotNil: [ primitive class == SPragma
				ifTrue: [ primitive := self primitiveFor: anSMethod primitive.
					anSMethod pragma: primitive ].
			self pushOpReturn.
			^ regR := primitive value ].
	statements := anSMethod statements.
	(statements isEmpty orNot: [ statements last isReturn ])
		ifTrue: [ self
				pushOpReturn;
				loadRwithSelf ].
	statements reverseDo: [ :node | self push: node ]
]

{ #category : #accessing }
EggLinkedTreeInterpreter >> visitOpRestart: anSOpRestart [

 self prepareForExecuting: context method
]

{ #category : #accessing }
EggLinkedTreeInterpreter >> visitReturn: anSReturn [
	self
		pushOpReturn: anSReturn local;
		push: anSReturn expression
]
