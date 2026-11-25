'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:39 pm'!
!classDefinition: #OptimizingVisitor category: #OCompiler!
ParseTreeVisitor subclass: #OptimizingVisitor
	instanceVariableNames: 'firstBlock currentBlock isReceiver argumentsCount'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'OCompiler'!
!OptimizingVisitor commentStamp: '<historical>' prior: 0!

    Copyright (c) 2020 Aucerna.
    See (MIT) license in root directory.
!

!OptimizingVisitor methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
initialize
	firstBlock := OBasicBlock new.
	currentBlock := firstBlock.
	isReceiver := true
! !

!OptimizingVisitor methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
insertDefineArgument: name
	| instruction |
	instruction := ODefineArgument named: name.
	currentBlock add: instruction.
	^instruction
! !

!OptimizingVisitor methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
insertReturnSelf
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
! !

!OptimizingVisitor methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
isReceiver
	^isReceiver
! !

!OptimizingVisitor methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
store: operation into: anIdentifierNode
	| instruction |
	instruction := OWriteVariable
		binding: anIdentifierNode binding
		valued: operation.
	operation addUse: instruction at: #source.
	currentBlock add: instruction.
	^instruction
! !

!OptimizingVisitor methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
visit: aParseNode
	super visit: aParseNode.
	^firstBlock
! !

!OptimizingVisitor methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
visitAssignment: anAssignmentNode
	| result |
	result := anAssignmentNode expression acceptVisitor: self.
	anAssignmentNode assignees do: [:node | self store: result into: node]
! !

!OptimizingVisitor methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
visitBlock: aBlockNode
	| previous cfg |
	previous := currentBlock.
	cfg := OBasicBlock new.
	currentBlock := cfg.
	self visitScript: aBlockNode.
	currentBlock := previous.
	^OBlockClosure containing: cfg
! !

!OptimizingVisitor methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
visitCascade: aCascadeNode
	| result |
	aCascadeNode receiver acceptVisitor: self.
	aCascadeNode messages do: [:node | result := node acceptVisitor: self].
	^result
! !

!OptimizingVisitor methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
visitCascadeReceiver: aCascadeReceiverNode
	^aCascadeReceiverNode receiver acceptVisitor: self
! !

!OptimizingVisitor methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
visitIdentifier: anIdentifierNode
	| load |
	load := OReadVariable binding: anIdentifierNode binding.
	currentBlock add: load.
	^load
! !

!OptimizingVisitor methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
visitLiteral: aLiteralNode
	| load |
	load := OLoadConstant valued: aLiteralNode value.
	currentBlock add: load.
	^load
! !

!OptimizingVisitor methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
visitMessage: aMessageNode
	| receiver arguments send block |
	block := currentBlock.
	receiver := aMessageNode receiver acceptVisitor: self.
	arguments := aMessageNode arguments
		collect: [:node | node acceptVisitor: self].
	send := OMessageSend
		receiver: receiver
		selector: aMessageNode selector value asSymbol
		arguments: arguments.
	receiver addUse: send at: #receiver.
	arguments
		withIndexDo: [:argument :i | argument isInstruction
			ifTrue: [argument addUse: send at: i]].
	block add: send.
	^send
! !

!OptimizingVisitor methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
visitMethod: aMethodNode
	| last |
	self insertDefineArgument: #activationRecord; insertDefineArgument: #self.
	aMethodNode arguments
		do: [:node | self insertDefineArgument: node value asSymbol].
	argumentsCount := aMethodNode arguments size.
	self visitScript: aMethodNode.
	last := currentBlock lastValue.
	last isReturn ifFalse: [self insertReturnSelf]
! !

!OptimizingVisitor methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
visitNumericLiteral: aNumericLiteralNode
	^self visitLiteral: aNumericLiteralNode
! !

!OptimizingVisitor methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
visitReturn: aReturnNode
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
! !

!OptimizingVisitor methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
visitScript: aScriptNode
	[
		aScriptNode arguments do: [:node | node acceptVisitor: self].
		aScriptNode temporaries do: [:node | node acceptVisitor: self]].
	aScriptNode statements do: [:node | node acceptVisitor: self]
! !

!OptimizingVisitor methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
visitSelector: aSelectorNode
	
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'OptimizingVisitor class' category: #OCompiler!
OptimizingVisitor class
	instanceVariableNames: ''!

!OptimizingVisitor class methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
new
	^self basicNew initialize
! !


OptimizingVisitor initialize!

