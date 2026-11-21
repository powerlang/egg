"
    Copyright (c) 2020 Aucerna.
    See (MIT) license in root directory.
"

Class {
	#name : #OPhi,
	#superclass : #OInstruction,
	#instVars : [
		'blocks'
	],
	#category : #IR
}

{ #category : #unclassified }
OPhi class >> new [
	^self basicNew initialize
]

{ #category : #unclassified }
OPhi >> addEdgeFrom: predecessor [
	(blocks includes: predecessor) ifTrue: [^self].
	blocks add: predecessor.
	(self atOperand: predecessor) addUse: self at: predecessor
]

{ #category : #unclassified }
OPhi >> addVariable: value from: block [
	self DENY: (blocks includes: block).
	blocks add: block.
	self atOperand: block put: value.
	value addUse: self at: block
]

{ #category : #unclassified }
OPhi >> atOperand: name [
	^(self jumpFrom: name) argumentFor: self
]

{ #category : #unclassified }
OPhi >> atOperand: name put: instruction [
	(self jumpFrom: name) argumentFor: self put: instruction
]

{ #category : #unclassified }
OPhi >> basicAcceptVisitor: aVisitor [
	^aVisitor visitPhi: self
]

{ #category : #unclassified }
OPhi >> basicPrintString [
	| sources |
	sources := blocks size > 0
		ifTrue: [
			(blocks collect: [:block | block name , '->' , (self atOperand: block) primitivePrintString])
				gather: [:x | x , ', ']]
		ifFalse: ['  '].
	^'[phi(' , (sources allButLast: 2) , ')]'
]

{ #category : #enumerating }
OPhi >> blocks [
	^blocks
]

{ #category : #unclassified }
OPhi >> blocks: aCollection [
	blocks := aCollection
]

{ #category : #unclassified }
OPhi >> dissolve [
	| values |
	values := self leaveBlock.
	super dissolve.
	values do: [:value | value removeUseBy: self]
]

{ #category : #unclassified }
OPhi >> dissolveReplacingWith: anInstruction [
	| values |
	values := self leaveBlock.
	super dissolveReplacingWith: anInstruction.
	values do: [:value | value removeUseBy: self]
]

{ #category : #unclassified }
OPhi >> forgetEdgeFrom: predecessor [
	(self atOperand: predecessor) removeUse: self at: predecessor.
	blocks remove: predecessor
]

{ #category : #unclassified }
OPhi >> index [
	^self basicBlock indexOfPhi: self
]

{ #category : #unclassified }
OPhi >> initialize [
	blocks := OrderedCollection new
]

{ #category : #unclassified }
OPhi >> isPhi [
	^true
]

{ #category : #unclassified }
OPhi >> jumpFrom: block [
	^block lastInstruction
]

{ #category : #unclassified }
OPhi >> leaveBlock [
	| values |
	values := OrderedCollection new.
	self operandsDo: [:value | values add: value].
	self basicBlock removeParameter: self.
	blocks := OrderedCollection new.
	^values
]

{ #category : #unclassified }
OPhi >> operandsDo: aBlock [
	blocks do: [:block | | value |
		value := self atOperand: block.
		aBlock value: value]
]

{ #category : #unclassified }
OPhi >> primitivePrintString [
	^'{#phi}'
]

{ #category : #printing }
OPhi >> printEdge: aBasicBlock using: names [
	| operand |
	operand := self atOperand: aBasicBlock.
	^(names at: aBasicBlock ifAbsent: ['missing']) , '->' , (names at: operand ifAbsent: ['missing'])
]

{ #category : #unclassified }
OPhi >> printStringUsing: names [
	| sources |
	sources := blocks size > 0
		ifTrue: [
			(blocks collect: [:block | self printEdge: block using: names])
				gather: [:x | x , ', ']]
		ifFalse: ['  '].
	^'phi(' , (sources allButLast: 2) , ')'
]

{ #category : #enumerating }
OPhi >> realReverseDo: aBlock [
	
]

{ #category : #unclassified }
OPhi >> removeBlock: removed [
	| index variable last |
	index := blocks indexOf: removed.
	variable := self atOperand: removed.
	variable removeUse: self at: removed.
	(self jumpFrom: removed) argumentFor: self put: nil.
	blocks removeIndex: index.
	blocks size = 1 ifTrue: [
		last := self atOperand: blocks first.
		self replaceAllUsesWith: last; dissolve.
		^last].
	^self
]

{ #category : #unclassified }
OPhi >> removeVariable: removed at: index [
	| block last |
	block := blocks at: index.
	removed removeUse: self at: block.
	(self jumpFrom: block) argumentFor: self put: nil.
	blocks removeIndex: index.
	blocks size = 1 ifFalse: [^self].
	last := self atOperand: blocks first.
	self replaceAllUsesWith: last; dissolve
]

{ #category : #enumerating }
OPhi >> replaceBlock: original with: new [
	blocks withIndexDo: [:block :i |
		block == original ifTrue: [
			(self atOperand: new) updateUser: self named: original with: new.
			blocks at: i put: new]]
]

{ #category : #printing }
OPhi >> shortPrintString [
	| sources |
	sources := blocks size > 0
		ifTrue: [(blocks collect: [:block | (self atOperand: block) primitivePrintString]) gather: [:x | x , ', ']]
		ifFalse: ['  '].
	^'[phi(' , (sources allButLast: 2) , ')]'
]

{ #category : #unclassified }
OPhi >> sortAfter: predecessors [
	blocks := predecessors copy
]

{ #category : #unclassified }
OPhi >> usesResultOf: anInstruction [
	^self variables includes: anInstruction
]

{ #category : #unclassified }
OPhi >> variables [
	^blocks collect: [:block | self atOperand: block]
]

{ #category : #unclassified }
OPhi >> variablesWithBlocksDo: aBlock [
	self variables with: blocks copy do: aBlock
]

