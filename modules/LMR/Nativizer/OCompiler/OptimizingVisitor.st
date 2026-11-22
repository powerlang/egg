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
		'classBinding'
	],
	#category : #OCompiler
}

{ #category : #unclassified }
OptimizingVisitor class >> new [
	^self basicNew initialize
]

{ #category : #private }
OptimizingVisitor >> argumentsOf: aBlockNode [
	aBlockNode isInlined ifFalse: [^#()].
	^aBlockNode inlinedArgs asArray collect: [:index | self inlinedArgument: index]
]

{ #category : #private }
OptimizingVisitor >> bindingOf: anIdentifierNode [
	| binding |
	binding := anIdentifierNode binding.
	(binding isArgument and: [binding isInlined]) ifFalse: [^binding].
	^self inlinedArgument: binding index
]

{ #category : #unclassified }
OptimizingVisitor >> initialize [
	firstBlock := OBasicBlock new.
	currentBlock := firstBlock.
	isReceiver := true
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

{ #category : #unclassified }
OptimizingVisitor >> isReceiver [
	^isReceiver
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

{ #category : #unclassified }
OptimizingVisitor >> store: operation into: anIdentifierNode [
	| instruction |
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
	| binding load |
	binding := self bindingOf: anIdentifierNode.
	load := OReadVariable binding: binding.
	currentBlock add: load.
	^load
]

{ #category : #unclassified }
OptimizingVisitor >> visitLiteral: aLiteralNode [
	| load |
	load := OLoadConstant valued: aLiteralNode value.
	currentBlock add: load.
	^load
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

