"
    Copyright (c) 2020 Aucerna.
    See (MIT) license in root directory.
"

Class {
	#name : #OBlockParameter,
	#superclass : #OInstruction,
	#instVars : [
		'blocks'
	],
	#category : #IR
}

{ #category : #unclassified }
OBlockParameter class >> new [
	^self basicNew initialize
]

{ #category : #unclassified }
OBlockParameter >> addEdgeFrom: predecessor [
	(blocks includes: predecessor) ifTrue: [^self].
	blocks add: predecessor.
	(self atOperand: predecessor) addUse: self at: predecessor
]

{ #category : #unclassified }
OBlockParameter >> addVariable: value from: block [
	self DENY: (blocks includes: block).
	blocks add: block.
	self atOperand: block put: value.
	value addUse: self at: block
]

{ #category : #unclassified }
OBlockParameter >> atOperand: name [
	^(self jumpFrom: name) argumentFor: self
]

{ #category : #unclassified }
OBlockParameter >> atOperand: name put: instruction [
	(self jumpFrom: name) argumentFor: self put: instruction
]

{ #category : #unclassified }
OBlockParameter >> basicAcceptVisitor: aVisitor [
	^aVisitor visitPhi: self
]

{ #category : #unclassified }
OBlockParameter >> basicPrintString [
	| sources |
	sources := blocks size > 0
		ifTrue: [
			(blocks collect: [:block | block name , '->' , (self atOperand: block) primitivePrintString])
				gather: [:x | x , ', ']]
		ifFalse: ['  '].
	^'[phi(' , (sources allButLast: 2) , ')]'
]

{ #category : #enumerating }
OBlockParameter >> blocks [
	^blocks
]

{ #category : #unclassified }
OBlockParameter >> blocks: aCollection [
	blocks := aCollection
]

{ #category : #unclassified }
OBlockParameter >> dissolve [
	| values |
	values := self leaveBlock.
	super dissolve.
	values do: [:value | value removeUseBy: self]
]

{ #category : #unclassified }
OBlockParameter >> dissolveReplacingWith: anInstruction [
	| values |
	values := self leaveBlock.
	super dissolveReplacingWith: anInstruction.
	values do: [:value | value removeUseBy: self]
]

{ #category : #unclassified }
OBlockParameter >> forgetEdgeFrom: predecessor [
	(self atOperand: predecessor) removeUse: self at: predecessor.
	blocks remove: predecessor
]

{ #category : #unclassified }
OBlockParameter >> index [
	^self basicBlock indexOfParameter: self
]

{ #category : #unclassified }
OBlockParameter >> initialize [
	blocks := OrderedCollection new
]

{ #category : #unclassified }
OBlockParameter >> isBlockParameter [
	^true
]

{ #category : #unclassified }
OBlockParameter >> jumpFrom: block [
	^block lastInstruction
]

{ #category : #unclassified }
OBlockParameter >> leaveBlock [
	| values |
	values := OrderedCollection new.
	self operandsDo: [:value | values add: value].
	self basicBlock removeParameter: self.
	blocks := OrderedCollection new.
	^values
]

{ #category : #unclassified }
OBlockParameter >> operandsDo: aBlock [
	blocks do: [:block | | value |
		value := self atOperand: block.
		aBlock value: value]
]

{ #category : #unclassified }
OBlockParameter >> primitivePrintString [
	^'{#phi}'
]

{ #category : #printing }
OBlockParameter >> printEdge: aBasicBlock using: names [
	| operand |
	operand := self atOperand: aBasicBlock.
	^(names at: aBasicBlock ifAbsent: ['missing']) , '->' , (names at: operand ifAbsent: ['missing'])
]

{ #category : #unclassified }
OBlockParameter >> printStringUsing: names [
	| sources |
	sources := blocks size > 0
		ifTrue: [
			(blocks collect: [:block | self printEdge: block using: names])
				gather: [:x | x , ', ']]
		ifFalse: ['  '].
	^'phi(' , (sources allButLast: 2) , ')'
]

{ #category : #enumerating }
OBlockParameter >> realReverseDo: aBlock [
	
]

{ #category : #unclassified }
OBlockParameter >> removeBlock: removed [
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
OBlockParameter >> removeVariable: removed at: index [
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
OBlockParameter >> replaceBlock: original with: new [
	blocks withIndexDo: [:block :i |
		block == original ifTrue: [
			(self atOperand: new) updateUser: self named: original with: new.
			blocks at: i put: new]]
]

{ #category : #printing }
OBlockParameter >> shortPrintString [
	| sources |
	sources := blocks size > 0
		ifTrue: [(blocks collect: [:block | (self atOperand: block) primitivePrintString]) gather: [:x | x , ', ']]
		ifFalse: ['  '].
	^'[phi(' , (sources allButLast: 2) , ')]'
]

{ #category : #unclassified }
OBlockParameter >> sortAfter: predecessors [
	blocks := predecessors copy
]

{ #category : #unclassified }
OBlockParameter >> usesResultOf: anInstruction [
	^self variables includes: anInstruction
]

{ #category : #unclassified }
OBlockParameter >> variables [
	^blocks collect: [:block | self atOperand: block]
]

{ #category : #unclassified }
OBlockParameter >> variablesWithBlocksDo: aBlock [
	self variables with: blocks copy do: aBlock
]

