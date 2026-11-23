"
    Copyright (c) 2020 Aucerna.
    See (MIT) license in root directory.
"

Class {
	#name : #OptimizingVisitor,
	#superclass : #Object,
	#instVars : [
		'firstBlock',
		'currentBlock',
		'isReceiver',
		'argumentsCount',
		'classBinding',
		'environment'
	],
	#pools : [
		'ClosureElementTypes'
	],
	#category : #OCompiler
}

{ #category : #unclassified }
OptimizingVisitor class >> new [
	^self basicNew initialize
]

{ #category : #private }
OptimizingVisitor >> argumentsOf: aBlockNode [
	^aBlockNode inlinedArgs asArray collect: [:index | self inlinedArgument: index]
]

{ #category : #private }
OptimizingVisitor >> bindingOf: anIdentifierNode [
	| binding |
	binding := anIdentifierNode binding.
	(binding isArgument and: [binding isInlined]) ifFalse: [^binding].
	^self inlinedArgument: binding index
]

{ #category : #private }
OptimizingVisitor >> captureNext: aStream into: closure at: anInteger [
	"a block that only returns from home captures an environment its method does not have"
	| value index |
	value := self decodeNextCapture: aStream.
	value ifNil: [^self].
	index := self constant: anInteger.
	self send: #_basicAt:put: to: closure with: {index. value}
]

{ #category : #private }
OptimizingVisitor >> closureFor: aBlockNode [
	| block closure variables slot |
	block := self constant: aBlockNode compiledCode.
	closure := self send: #newClosure to: block with: #().
	variables := aBlockNode capturedVariables readStream.
	slot := Closure instSize.
	[variables atEnd] whileFalse: [
		slot := slot + 1.
		self captureNext: variables into: closure at: slot].
	aBlockNode capturesHome ifTrue: [self send: #saveHomeFrame to: closure with: #()].
	^closure
]

{ #category : #private }
OptimizingVisitor >> constant: anObject [
	| load |
	load := OLoadConstant valued: anObject.
	currentBlock add: load.
	^load
]

{ #category : #private }
OptimizingVisitor >> decodeNextCapture: aStream [
	| type |
	type := aStream next.
	type = Self ifTrue: [^self read: SSelfBinding new].
	type = LocalArgument ifTrue: [^self read: (SArgumentBinding new index: aStream next)].
	type = Environment ifTrue: [^environment].
	type = EnvironmentValue ifTrue: [^self environmentAt: aStream next].
	type = InlinedArgument ifTrue: [^self read: (self inlinedArgument: aStream next)].
	self error: 'unknown capture type: ' , type printString
]

{ #category : #private }
OptimizingVisitor >> environmentAt: anInteger [
	| index |
	index := self constant: anInteger.
	^self send: #_basicAt: to: environment with: {index}
]

{ #category : #private }
OptimizingVisitor >> environmentAt: anInteger put: operation [
	| index store |
	index := self constant: anInteger.
	store := self send: #_basicAt:put: to: environment with: {index. operation}.
	self send: #holdRefererIfNeeded: to: operation with: {environment}.
	^store
]

{ #category : #unclassified }
OptimizingVisitor >> initialize [
	firstBlock := OBasicBlock new.
	currentBlock := firstBlock.
	isReceiver := true
]

{ #category : #private }
OptimizingVisitor >> initializeEnvironmentFor: aCompiledMethod [
	| array size |
	aCompiledMethod hasEnvironment ifFalse: [^self].
	array := self constant: Array.
	size := self constant: aCompiledMethod environmentCount.
	environment := self send: #new: to: array with: {size}
]

{ #category : #private }
OptimizingVisitor >> inlinedArgument: anInteger [
	^STemporaryBinding new index: anInteger; environment: -1; yourself
]

{ #category : #unclassified }
OptimizingVisitor >> insertDefineArgument: name [
	| instruction |
	instruction := ODefineArgument named: name.
	currentBlock add: instruction.
	^instruction
]

{ #category : #unclassified }
OptimizingVisitor >> insertReturnSelf [
	| receiver frame instruction |
	receiver := firstBlock firstInstruction next.
	frame := firstBlock firstInstruction.
	instruction := OReturn new
		source: receiver;
		frame: frame;
		argumentsCount: argumentsCount.
	receiver addUse: instruction at: #source.
	frame addUse: instruction at: #frame.
	currentBlock add: instruction.
	^instruction
]

{ #category : #private }
OptimizingVisitor >> isInEnvironment: aBinding [
	^aBinding isTemporary and: [aBinding environment = 0]
]

{ #category : #unclassified }
OptimizingVisitor >> isReceiver [
	^isReceiver
]

{ #category : #private }
OptimizingVisitor >> read: aBinding [
	| read |
	read := OReadVariable binding: aBinding.
	currentBlock add: read.
	^read
]

{ #category : #unclassified }
OptimizingVisitor >> send: aMessageNode to: anInstruction [
	| arguments send block |
	block := currentBlock.
	arguments := aMessageNode arguments
		collect: [:node | node acceptVisitor: self].
	send := OMessageSend
		receiver: anInstruction
		selector: aMessageNode selector value asSymbol
		arguments: arguments.
	aMessageNode receiver isSuper ifTrue: [send beSuperFrom: classBinding].
	anInstruction addUse: send at: #receiver.
	arguments
		withIndexDo: [:argument :i | argument isInstruction
			ifTrue: [argument addUse: send at: i]].
	block add: send.
	^send
]

{ #category : #private }
OptimizingVisitor >> send: aSymbol to: receiver with: arguments [
	| send |
	send := OMessageSend receiver: receiver selector: aSymbol arguments: arguments.
	receiver addUse: send at: #receiver.
	arguments withIndexDo: [:argument :i | argument addUse: send at: i].
	currentBlock add: send.
	^send
]

{ #category : #unclassified }
OptimizingVisitor >> store: operation into: anIdentifierNode [
	| instruction |
	(self isInEnvironment: anIdentifierNode binding)
		ifTrue: [^self environmentAt: anIdentifierNode binding index put: operation].
	instruction := OWriteVariable
		binding: anIdentifierNode binding
		valued: operation.
	operation addUse: instruction at: #source.
	currentBlock add: instruction.
	^instruction
]

{ #category : #unclassified }
OptimizingVisitor >> visit: aParseNode [
	aParseNode acceptVisitor: self.
	^firstBlock
]

{ #category : #unclassified }
OptimizingVisitor >> visitAssignment: anAssignmentNode [
	| result |
	result := anAssignmentNode expression acceptVisitor: self.
	anAssignmentNode assignees do: [:node | self store: result into: node].
	^result
]

{ #category : #unclassified }
OptimizingVisitor >> visitBlock: aBlockNode [
	| previous cfg arguments |
	aBlockNode isInlined ifFalse: [^self closureFor: aBlockNode].
	previous := currentBlock.
	cfg := OBasicBlock new.
	currentBlock := cfg.
	self visitScript: aBlockNode.
	currentBlock := previous.
	arguments := self argumentsOf: aBlockNode.
	^(OBlockClosure containing: cfg) arguments: arguments
]

{ #category : #unclassified }
OptimizingVisitor >> visitCascade: aCascadeNode [
	| receiver result |
	receiver := aCascadeNode receiver acceptVisitor: self.
	aCascadeNode messages do: [:node | result := self send: node to: receiver].
	^result
]

{ #category : #unclassified }
OptimizingVisitor >> visitCascadeReceiver: aCascadeReceiverNode [
	^aCascadeReceiverNode receiver acceptVisitor: self
]

{ #category : #unclassified }
OptimizingVisitor >> visitIdentifier: anIdentifierNode [
	| binding |
	binding := self bindingOf: anIdentifierNode.
	(self isInEnvironment: binding) ifTrue: [^self environmentAt: binding index].
	^self read: binding
]

{ #category : #unclassified }
OptimizingVisitor >> visitLiteral: aLiteralNode [
	^self constant: aLiteralNode value
]

{ #category : #unclassified }
OptimizingVisitor >> visitMessage: aMessageNode [
	| receiver |
	receiver := aMessageNode receiver acceptVisitor: self.
	^self send: aMessageNode to: receiver
]

{ #category : #unclassified }
OptimizingVisitor >> visitMethod: aMethodNode [
	| last |
	self insertDefineArgument: #activationRecord; insertDefineArgument: #self.
	argumentsCount := aMethodNode compiledCode argumentCount.
	classBinding := aMethodNode compiledCode classBinding.
	1 to: argumentsCount do: [:i | self insertDefineArgument: ('arg', i printString) asSymbol].
	self initializeEnvironmentFor: aMethodNode compiledCode.
	self visitScript: aMethodNode.
	last := currentBlock lastValue.
	last isReturn ifFalse: [self insertReturnSelf]
]

{ #category : #unclassified }
OptimizingVisitor >> visitNumericLiteral: aNumericLiteralNode [
	^self visitLiteral: aNumericLiteralNode
]

{ #category : #unclassified }
OptimizingVisitor >> visitReturn: aReturnNode [
	| source frame instruction |
	source := aReturnNode expression acceptVisitor: self.
	frame := firstBlock firstInstruction.
	instruction := OReturn new
		source: source;
		frame: frame;
		argumentsCount: argumentsCount.
	source addUse: instruction at: #source.
	frame addUse: instruction at: #frame.
	currentBlock add: instruction.
	^instruction
]

{ #category : #unclassified }
OptimizingVisitor >> visitScript: aScriptNode [
	[
		aScriptNode arguments do: [:node | node acceptVisitor: self].
		aScriptNode temporaries do: [:node | node acceptVisitor: self]].
	aScriptNode statements do: [:node | node acceptVisitor: self]
]

{ #category : #unclassified }
OptimizingVisitor >> visitSelector: aSelectorNode [
	
]

