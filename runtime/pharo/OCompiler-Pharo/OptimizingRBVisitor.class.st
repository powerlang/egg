"
Copyright (c) 2020-2023 Quorum Software.
	See (MIT) license in root directory.
"
Class {
	#name : 'OptimizingRBVisitor',
	#superclass : 'RBProgramNodeVisitor',
	#instVars : [
		'method',
		'firstBlock',
		'currentBlock',
		'locals',
		'abi',
		'sendInliner',
		'activation'
	],
	#category : 'OCompiler-Pharo',
	#package : 'OCompiler-Pharo'
}

{ #category : 'emitting - load' }
OptimizingRBVisitor >> activation [
	^activation
]

{ #category : 'emitting - load' }
OptimizingRBVisitor >> allActivations [
	^firstBlock nodesSelect: [:node | node class == OActivationContext]
]

{ #category : 'private' }
OptimizingRBVisitor >> defineActivationRecord [
	activation := OActivationContext named: #activationRecord.
	activation temporaries: method tempNames size.
	currentBlock add: activation
]

{ #category : 'private' }
OptimizingRBVisitor >> defineSelf [
	| definition |
	definition := OLoadImplicit named: #self.
	currentBlock add: definition
]

{ #category : 'accessing' }
OptimizingRBVisitor >> environment: aNativizationEnvironment [
	abi := aNativizationEnvironment abi
]

{ #category : 'initialization' }
OptimizingRBVisitor >> initialize [
	firstBlock := OBasicBlock new.
	currentBlock := firstBlock.
	locals := OrderedCollection new
]

{ #category : 'private' }
OptimizingRBVisitor >> insertReturnSelf [
	| instruction |
	instruction := OReturn new source: activation receiver; frame: activation.
	currentBlock add: instruction.
	^instruction
]

{ #category : 'emitting - load' }
OptimizingRBVisitor >> loadArgument: name [
	| load |
	load := OLoadOperation base: self activation slotAtImm: name.
	currentBlock add: load.
	^load
]

{ #category : 'emitting - load' }
OptimizingRBVisitor >> loadAssociation: anAssociation [
	| global read name |
	name := anAssociation key asString asSymbol.
	name == #WordSize ifTrue: [^self loadLiteral: abi wordSize].
	name == #WordSizeShift ifTrue: [^self loadLiteral: abi wordSizeShift].
	global := OLoadConstant valued: anAssociation.
	read := OLoadOperation base: global slotAtImm: 1.
	currentBlock add: global; add: read.
	^read
]

{ #category : 'emitting - load' }
OptimizingRBVisitor >> loadEnvironment: envIndex [
	| result |
	result := self activation environment.
	envIndex ifNotNil: [
		result := OLoadOperation base: result slotAtImm: envIndex.
		currentBlock add: result].
	^result
]

{ #category : 'emitting - load' }
OptimizingRBVisitor >> loadEnvironmentTemporary: tempIndex environment: envIndex [
	| load environment |
	self error: 'non-inlined closure arguments not yet supported'.
	environment := self loadEnvironment: envIndex.
	load := OLoadOperation base: environment slotAtImm: tempIndex.
	currentBlock add: load.
	^load
]

{ #category : 'emitting - load' }
OptimizingRBVisitor >> loadFalse [
	^self loadLiteral: false
]

{ #category : 'emitting - load' }
OptimizingRBVisitor >> loadInstance: index [
	| receiver load |
	receiver := self activation receiver.
	load := OLoadOperation base: receiver slotAtImm: index.
	currentBlock add: load.
	^load
]

{ #category : 'emitting - load' }
OptimizingRBVisitor >> loadLiteral: value [
	| constant |
	constant := OLoadConstant valued: value.
	currentBlock add: constant.
	^constant
]

{ #category : 'emitting - load' }
OptimizingRBVisitor >> loadNil [
	^self loadLiteral: nil
]

{ #category : 'emitting - load' }
OptimizingRBVisitor >> loadSelf [
	^self activation receiver
]

{ #category : 'emitting - load' }
OptimizingRBVisitor >> loadTemporary: name [
	| load |
	load := OLoadOperation base: self activation slotAtImm: name.
	currentBlock add: load.
	^ load
]

{ #category : 'emitting - load' }
OptimizingRBVisitor >> loadTrue [
	^self loadLiteral: true
]

{ #category : 'private' }
OptimizingRBVisitor >> lowerSpecialABI: aMethodNode [
	| literals i actual next load names |
	literals := method literals.
	literals size = 0 ifTrue: [^self].
	(literals at: 1) == #savePreviousSelf ifTrue: [
		activation doSavePreviousSelf.
		load := firstBlock detect: [:inst | inst isConstant].
		load dissolve.
		literals := literals copyFrom: 2].
	literals size = 0 ifTrue: [^self].
	(literals at: 1) == #specialABIBegin ifFalse: [^self].
	i := 2.
	names := aMethodNode arguments collect: [:arg | arg name asSymbol].
	[(literals at: i) == #specialABIEnd]
		whileFalse: [| name register implicit regname index offset |
			name := literals at: i.
			regname := literals at: i + 1.
			register := self registerNamed: regname.
			name = #self ifTrue: [activation receiver register: register] ifFalse: [
				index := names indexOf: name.
				offset := method argumentCount - index + 3.
				self allActivations do: [:frame | 
					implicit := (OLoadImplicit named: name) register: register.
					frame receiver afterInsert: implicit.
					frame arguments
						select: [:arg | arg index == offset]
						thenDo: [:arg | arg replaceAllUsesWith: implicit; dissolve]]].
			i := i + 2].
	actual := firstBlock detect: [:inst | inst isConstant].
	[
		next := actual next.
		actual dissolve.
		actual isConstant and: [actual value == #specialABIEnd]]
		whileFalse: [actual := next]
]

{ #category : 'accessing' }
OptimizingRBVisitor >> method: aCompiledMethod [
	method := aCompiledMethod
]

{ #category : 'emitting - load' }
OptimizingRBVisitor >> pushInstVar: index [
	| name |
	name := method classBinding value allInstVarNames at: index. 
	^self loadInstance: name

	
]

{ #category : 'inquiries' }
OptimizingRBVisitor >> registerNamed: regname [
	^abi perform: regname
]

{ #category : 'emitting - store' }
OptimizingRBVisitor >> storeAssociation: association with: value [
	| global write |
	global := OLoadConstant valued: association.
	write := OStoreOperation base: global slotAtImm: 1 put: value.
	currentBlock add: global; add: write
]

{ #category : 'emitting - store' }
OptimizingRBVisitor >> storeEnvironmentTemporary: tempIndex environment: envIndex with: value [
	| environment store |
	self error: 'non-inlined closure arguments not yet supported'.
	environment := self loadEnvironment: envIndex.
	store := OStoreOperation base: environment slotAtImm: tempIndex put: value.
	currentBlock add: store
]

{ #category : 'emitting - store' }
OptimizingRBVisitor >> storeInstance: index with: value [
	| write |
	write := OStoreOperation
		base: self activation receiver
		slotAtImm: index
		put: value.
	currentBlock add: write
]

{ #category : 'emitting - store' }
OptimizingRBVisitor >> storeTemporary: anInteger with: value [
	| store index |
	index := -1 - anInteger.
	store := OStoreOperation base: self activation slotAtImm: index put: value.
	currentBlock add: store
]

{ #category : 'visiting' }
OptimizingRBVisitor >> visit [
	self visitMethodNode: method parseTree doSemanticAnalysis.
	^ firstBlock
]

{ #category : 'visiting' }
OptimizingRBVisitor >> visit: aParseNode [
	super visit: aParseNode.
	^firstBlock
]

{ #category : 'emitting - load' }
OptimizingRBVisitor >> visitArgumentNode: anArgumentNode [
	^ self loadArgument: anArgumentNode name
]

{ #category : 'visiting' }
OptimizingRBVisitor >> visitAssignmentNode: anAssignmentNode [
	| result |
	result := anAssignmentNode expression acceptVisitor: self.
	anAssignmentNode assignees
		do: [:node | node binding store: result using: self]
]

{ #category : 'visiting' }
OptimizingRBVisitor >> visitBlockNode: anRBBlockNode [
	| previous cfg |
	previous := currentBlock.
	cfg := OBasicBlock new.
	currentBlock := cfg.
	self visitScript: anRBBlockNode.
	currentBlock := previous.
	^OBlockClosure containing: cfg
]

{ #category : 'visiting' }
OptimizingRBVisitor >> visitCascadeNode: aCascadeNode [
	| receiver arguments send block |
	block := currentBlock.
	receiver := aCascadeNode receiver acceptVisitor: self.
	aCascadeNode messages do: [:msg | 
		arguments := msg arguments collect: [:node | node acceptVisitor: self].
		send := OMessageSend
			receiver: receiver
			selector: msg selector value asSymbol
			arguments: arguments.
		block add: send].
	^send
]

{ #category : 'visiting' }
OptimizingRBVisitor >> visitIdentifier: anIdentifierNode [
	^anIdentifierNode binding loadUsing: self
]

{ #category : 'emitting - load' }
OptimizingRBVisitor >> visitInstanceVariableNode: aVariableNode [
^ self loadInstance: aVariableNode name
]

{ #category : 'visiting' }
OptimizingRBVisitor >> visitLiteralValueNode: aLiteralNode [
	| load |
	load := OLoadConstant valued: aLiteralNode value.
	currentBlock add: load.
	^ load
]

{ #category : 'visiting' }
OptimizingRBVisitor >> visitMessageNode: aMessageNode [
	| receiver arguments selector send |
	receiver := aMessageNode receiver acceptVisitor: self.
	arguments := aMessageNode arguments
		collect: [:node | node acceptVisitor: self].
	selector := aMessageNode selector.
	send := OMessageSend
		receiver: receiver
		selector: selector
		arguments: arguments.
	currentBlock add: send.
	^send
]

{ #category : 'visiting' }
OptimizingRBVisitor >> visitMethodNode: anRBMethodNode [
	| last |
	self visitScript: anRBMethodNode.
	last := currentBlock lastValue.
	last isReturn ifFalse: [self insertReturnSelf].
	self lowerSpecialABI: anRBMethodNode
]

{ #category : 'visiting' }
OptimizingRBVisitor >> visitReturnNode: aReturnNode [
	| source instruction |
	source := aReturnNode value acceptVisitor: self.
	instruction := OReturn new
		source: source;
		frame: activation.
	currentBlock add: instruction.
	^ instruction
]

{ #category : 'visiting' }
OptimizingRBVisitor >> visitScript: aScriptNode [
	| previous |
	previous := activation.
	self defineActivationRecord; defineSelf.
	aScriptNode statements do: [:node | node acceptVisitor: self].
	previous ifNotNil: [activation := previous]
]

{ #category : 'visiting' }
OptimizingRBVisitor >> visitSelector: aSelectorNode [
	
]

{ #category : 'visiting' }
OptimizingRBVisitor >> visitSelfNode: aVariableNode [
	^ self loadSelf
]

{ #category : 'emitting - load' }
OptimizingRBVisitor >> visitTemporaryNode: aTemporaryNode [
	^ self loadTemporary: aTemporaryNode name
]

{ #category : 'visiting' }
OptimizingRBVisitor >> visitVariableNode: aVariableNode [
	^ aVariableNode binding emitValue: self
]
