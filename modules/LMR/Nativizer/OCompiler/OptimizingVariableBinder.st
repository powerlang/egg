"
    Copyright (c) 2020 Aucerna.
    See (MIT) license in root directory.
"

Class {
	#name : #OptimizingVariableBinder,
	#superclass : #Object,
	#instVars : [
		'definitions',
		'currentBlock',
		'dominanceFrontiers',
		'pendingReads',
		'pendingParameters',
		'parameterNames',
		'abi',
		'method'
	],
	#category : #OCompiler
}

{ #category : #unclassified }
OptimizingVariableBinder class >> new [
	^self basicNew initialize
]

{ #category : #accessing }
OptimizingVariableBinder >> abi: anAbi [
	abi := anAbi
]

{ #category : #private }
OptimizingVariableBinder >> define: aParameter named: aString in: aBasicBlock [
	aBasicBlock predecessors do: [:predecessor | | definition |
		definition := self definitionOf: aString from: predecessor.
		aParameter addVariable: definition from: predecessor]
]

{ #category : #unclassified }
OptimizingVariableBinder >> insertParameterOf: name at: block [
	| parameter |
	(self definitionOf: name in: block) ifNotNil: [^self].
	parameter := block newParameter.
	parameterNames at: parameter put: name.
	pendingParameters add: parameter -> block.
	self define: parameter as: name in: block.
	(dominanceFrontiers at: block)
		do: [:frontier | self insertParameterOf: name at: frontier]
]

{ #category : #accessing }
OptimizingVariableBinder >> method: aCompiledMethod [
	method := aCompiledMethod
]

{ #category : #unclassified }
OptimizingVariableBinder >> resolve: aReadVariable asDynamic: binding [
	| name instVarIndex receiver load assoc global read folded |
	name := binding name.
	folded := self foldableConstantValueFor: name.
	folded == self ifFalse: [
		^aReadVariable dissolveReplacingWith: (OLoadConstant valued: folded)].
	instVarIndex := method classBinding allInstVarNames indexOf: name.
	instVarIndex > 0 ifTrue: [
		receiver := self definitionOf: #self.
		load := OBinaryConstantOperation left: receiver right: instVarIndex name: #_basicAt:.
		receiver addUse: load at: #left.
		^aReadVariable dissolveReplacingWith: load].
	assoc := self associationFor: name.
	assoc ifNotNil: [
		global := OLoadConstant valued: assoc.
		read := OBinaryConstantOperation left: global right: self associationValueIndex name: #_basicAt:.
		global addUse: read at: #left.
		^aReadVariable beforeInsert: global; dissolveReplacingWith: read].
	self error: 'unresolved dynamic binding read: ', name
]

{ #category : #private }
OptimizingVariableBinder >> associationFor: name [
	| current symbol assoc |
	symbol := name asSymbol.
	current := method classBinding.
	[current notNil] whileTrue: [
		current namespaces do: [:ns |
			assoc := ns associationAt: symbol ifAbsent: [nil].
			assoc ifNotNil: [^assoc]].
		current := current superclass].
	^method module namespace associationAt: symbol ifAbsent: [nil]
]

{ #category : #unclassified }
OptimizingVariableBinder >> define: value as: name [
	self define: value as: name in: currentBlock
]

{ #category : #private }
OptimizingVariableBinder >> define: value as: name in: block [
	| here |
	here := definitions at: block ifAbsentPut: [Dictionary new].
	here at: name put: value
]

{ #category : #private }
OptimizingVariableBinder >> defineLiveParameters [
	| live |
	live := pendingParameters select: [:association | self isLive: association].
	pendingParameters removeAll: live.
	live do: [:association | self defineParameter: association].
	^live notEmpty
]

{ #category : #private }
OptimizingVariableBinder >> defineParameter: anAssociation [
	| parameter name |
	parameter := anAssociation key.
	name := parameterNames at: parameter.
	self define: parameter named: name in: anAssociation value
]

{ #category : #unclassified }
OptimizingVariableBinder >> definitionOf: name [
	^self definitionOf: name from: currentBlock
]

{ #category : #unclassified }
OptimizingVariableBinder >> definitionOf: name before: block [
	| current |
	block parametersDo: [:parameter |
		(parameterNames at: parameter ifAbsent: nil) = name ifTrue: [^parameter]].
	current := block.
	[
		current := current immediateDominator.
		current notNil]
		whileTrue: [
			definitions
				at: current
				ifPresent: [:here | here at: name ifPresent: [:value | ^value]]].
	self error: 'undefined variable <' , name , '>'
]

{ #category : #unclassified }
OptimizingVariableBinder >> definitionOf: name from: block [
	| current |
	current := block.
	[current notNil] whileTrue: [
		definitions
			at: current
			ifPresent: [:here | here at: name ifPresent: [:value | ^value]].
		current := current immediateDominator].
	^block lastValue
]

{ #category : #unclassified }
OptimizingVariableBinder >> definitionOf: name in: block [
	definitions
		at: block
		ifPresent: [:here | here at: name ifPresent: [:value | ^value]].
	^nil
]

{ #category : #unclassified }
OptimizingVariableBinder >> doBindingFrom: firstBlock [
	firstBlock computeDominance.
	dominanceFrontiers := firstBlock dominanceFrontiers.
	firstBlock reversePostOrderDo: [:block | 
		currentBlock := block.
		block firstInstruction acceptVisitor: self].
	self resolvePendingReads; rewriteParameters
]

{ #category : #unclassified }
OptimizingVariableBinder >> initialize [
	definitions := Dictionary new.
	pendingReads := OrderedCollection new.
	pendingParameters := OrderedCollection new.
	parameterNames := IdentityDictionary new
]

{ #category : #unclassified }
OptimizingVariableBinder >> instructionsForWriting: aWriteVariable [
	| binding |
	binding := aWriteVariable binding.
	binding isTemporary
		ifTrue: [^self instructionsForWriting: aWriteVariable toTemporary: binding].
	binding isInstVar
		ifTrue: [^self
			instructionsForWriting: aWriteVariable
			toInstanceVariable: binding].
	binding isDynamic
		ifTrue: [^self
			instructionsForWriting: aWriteVariable
			toDynamic: binding].
	self halt
]

{ #category : #unclassified }
OptimizingVariableBinder >> instructionsForWriting: aWriteVariable toDynamic: binding [
	| name instVarIndex this write assoc global |
	name := binding name.
	instVarIndex := method classBinding allInstVarNames indexOf: name.
	instVarIndex > 0 ifTrue: [
		this := self definitionOf: #self.
		write := OTernaryOperation
			receiver: this
			left: instVarIndex
			right: aWriteVariable source
			name: #_basicAt:put:.
		this addUse: write at: #receiver.
		aWriteVariable source addUse: write at: #right.
		^aWriteVariable dissolveReplacingWith: write].
	assoc := self associationFor: name.
	assoc ifNotNil: [
		global := OLoadConstant valued: assoc.
		write := OTernaryOperation
			receiver: global
			left: self associationValueIndex
			right: aWriteVariable source
			name: #_basicAt:put:.
		global addUse: write at: #receiver.
		aWriteVariable source addUse: write at: #right.
		^aWriteVariable beforeInsert: global; dissolveReplacingWith: write].
	self error: 'unresolved dynamic binding write: ', name
]

{ #category : #unclassified }
OptimizingVariableBinder >> instructionsForWriting: aWriteVariable toAssociation: binding [
	| global write |
	global := OLoadConstant valued: binding association.
	write := OTernaryOperation
		receiver: global
		left: self associationValueIndex
		right: aWriteVariable source
		name: #_basicAt:put:.
	global addUse: write at: #receiver.
	aWriteVariable source addUse: write at: #right.
	aWriteVariable beforeInsert: global; dissolveReplacingWith: write
]

{ #category : #unclassified }
OptimizingVariableBinder >> instructionsForWriting: aWriteVariable toInstanceVariable: binding [
	| this write |
	this := self definitionOf: #self.
	write := OTernaryOperation
		receiver: this
		left: binding index
		right: aWriteVariable source
		name: #_basicAt:put:.
	this addUse: write at: #receiver.
	aWriteVariable source addUse: write at: #right.
	aWriteVariable dissolveReplacingWith: write
]

{ #category : #unclassified }
OptimizingVariableBinder >> instructionsForWriting: aWriteVariable toTemporary: binding [
	self define: aWriteVariable source as: binding name asSymbol.
	aWriteVariable replaceAllUsesWith: aWriteVariable source; dissolve.
	(dominanceFrontiers at: currentBlock)
		do: [:block | self insertParameterOf: binding name asSymbol at: block]
]

{ #category : #private }
OptimizingVariableBinder >> isLive: anAssociation [
	| block |
	block := anAssociation value.
	^anAssociation key livesAfter: block orOutOf: block
]

{ #category : #private }
OptimizingVariableBinder >> redefine: aReadVariable as: anInstruction [
	definitions do: [:here | self redefine: aReadVariable as: anInstruction in: here]
]

{ #category : #private }
OptimizingVariableBinder >> redefine: aReadVariable as: anInstruction in: aDictionary [
	aDictionary keysAndValuesDo: [:name :value |
		value == aReadVariable ifTrue: [aDictionary at: name put: anInstruction]]
]

{ #category : #unclassified }
OptimizingVariableBinder >> resolve: aReadVariable asArgument: binding [
	| source |
	source := self definitionOf: binding name asSymbol.
	aReadVariable replaceAllUsesWith: source; dissolve
]

{ #category : #private }
OptimizingVariableBinder >> associationValueIndex [
	^Association indexOfSlot: 'value'
]

{ #category : #private }
OptimizingVariableBinder >> resolve: aReadVariable asAssociationValue: binding [
	| global read value name load |
	name := binding association key.
	(name == #WordSize or: [name == #WordSizeShift]) ifTrue: [
		value := name == #WordSize
			ifTrue: [abi wordSize]
			ifFalse: [abi wordSizeShift].
		load := OLoadConstant valued: value.
		^aReadVariable dissolveReplacingWith: load].
	binding isPoolVariableBinding
		ifTrue: [
			load := OLoadConstant valued: binding association value.
			aReadVariable dissolveReplacingWith: load]
		ifFalse: [
			global := OLoadConstant valued: binding association.
			read := OBinaryConstantOperation left: global right: self associationValueIndex name: #_basicAt:.
			global addUse: read at: #left.
			aReadVariable beforeInsert: global; dissolveReplacingWith: read]
]

{ #category : #private }
OptimizingVariableBinder >> foldableConstantValueFor: aName [
	^abi foldableConstants at: aName asSymbol ifAbsent: [self]
]

{ #category : #unclassified }
OptimizingVariableBinder >> resolve: aReadVariable asInstanceVar: binding [
	| receiver index load |
	receiver := self definitionOf: #self.
	"	index := method classField indexOfSlot: name."
	index := binding index.
	load := OBinaryConstantOperation
		left: receiver
		right: index
		name: #_basicAt:.
	receiver addUse: load at: #left.
	aReadVariable dissolveReplacingWith: load
]

{ #category : #unclassified }
OptimizingVariableBinder >> resolve: aReadVariable asLiteral: binding [
	| constant |
	constant := OLoadConstant valued: binding value.
	aReadVariable dissolveReplacingWith: constant
]

{ #category : #unclassified }
OptimizingVariableBinder >> resolve: aReadVariable asTemporary: binding [
	| source |
	source := self definitionOf: binding name asSymbol in: currentBlock.
	source
		ifNil: [pendingReads add: aReadVariable -> currentBlock]
		ifNotNil: [aReadVariable replaceAllUsesWith: source; dissolve]
]

{ #category : #unclassified }
OptimizingVariableBinder >> resolvePendingReads [
	pendingReads do: [:association | | read block source resolved |
		read := association key.
		block := association value.
		source := self definitionOf: read binding name asSymbol before: block.
		resolved := read replaceWithCopyOf: source.
		self redefine: read as: resolved]
]

{ #category : #unclassified }
OptimizingVariableBinder >> resolveSelf: aReadVariable [
	| receiver |
	receiver := self definitionOf: #self.
	^aReadVariable replaceAllUsesWith: receiver; dissolve
]

{ #category : #unclassified }
OptimizingVariableBinder >> rewriteParameters [
	[self defineLiveParameters] whileTrue.
	pendingParameters do: [:association | association key remove]
]

{ #category : #unclassified }
OptimizingVariableBinder >> visitBinaryWithConstant: instruction [
	
]

{ #category : #unclassified }
OptimizingVariableBinder >> visitBinaryWithVariable: instruction [
	
]

{ #category : #unclassified }
OptimizingVariableBinder >> visitDefineArgument: instruction [
	self define: instruction as: instruction name
]

{ #category : #unclassified }
OptimizingVariableBinder >> visitJump: aJumpInstruction [
	
]

{ #category : #unclassified }
OptimizingVariableBinder >> visitJumpFalse: aJumpInstruction [
	
]

{ #category : #unclassified }
OptimizingVariableBinder >> visitJumpTrue: aJumpInstruction [
	
]

{ #category : #unclassified }
OptimizingVariableBinder >> visitLoadConstant: aLoadImplicit [
	
]

{ #category : #unclassified }
OptimizingVariableBinder >> visitMessageSend: aMessageSend [
	
]

{ #category : #unclassified }
OptimizingVariableBinder >> visitReadVariable: aReadVariable [
	| binding |
	binding := aReadVariable binding.
	binding isTemporary
		ifTrue: [^self resolve: aReadVariable asTemporary: binding].
	binding isArgument
		ifTrue: [^self resolve: aReadVariable asArgument: binding].
	binding isSelf ifTrue: [^self resolveSelf: aReadVariable].
	binding isSuper ifTrue: [^self resolveSelf: aReadVariable].
	binding isLiteral ifTrue: [^self resolve: aReadVariable asLiteral: binding].
	binding isInstVar
		ifTrue: [^self resolve: aReadVariable asInstanceVar: binding].
	binding isDynamic
		ifTrue: [^self resolve: aReadVariable asDynamic: binding].
	self error: 'unhandled binding type: ', binding printString
]

{ #category : #unclassified }
OptimizingVariableBinder >> visitReturn: aReturnInstruction [
	
]

{ #category : #unclassified }
OptimizingVariableBinder >> visitTernary: instruction [
	
]

{ #category : #unclassified }
OptimizingVariableBinder >> visitUnary: instruction [
	
]

{ #category : #unclassified }
OptimizingVariableBinder >> visitWriteVariable: aWriteVariable [
	self instructionsForWriting: aWriteVariable
]

{ #category : #accessing }
OptimizingVariableBinder >> wordSize [
	^abi wordSize
]

{ #category : #accessing }
OptimizingVariableBinder >> wordSizeShift [
	^abi wordSizeShift
]

