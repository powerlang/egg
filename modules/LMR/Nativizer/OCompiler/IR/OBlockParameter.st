"
    Copyright (c) 2020 Aucerna.
    See (MIT) license in root directory.
"

Class {
	#name : #OBlockParameter,
	#superclass : #OInstruction,
	#instVars : [
		'basicBlock'
	],
	#category : #IR
}

{ #category : #unclassified }
OBlockParameter >> addVariable: value from: block [
	self atOperand: block put: value.
	value addUse: self at: block
]

{ #category : #unclassified }
OBlockParameter >> atOperand: block [
	^(self jumpFrom: block) argumentFor: self
]

{ #category : #unclassified }
OBlockParameter >> atOperand: block put: instruction [
	(self jumpFrom: block) argumentFor: self put: instruction
]

{ #category : #unclassified }
OBlockParameter >> basicAcceptVisitor: aVisitor [
	^aVisitor visitBlockParameter: self
]

{ #category : #accessing }
OBlockParameter >> basicBlock [
	^basicBlock
]

{ #category : #accessing }
OBlockParameter >> basicBlock: aBasicBlock [
	basicBlock := aBasicBlock
]

{ #category : #unclassified }
OBlockParameter >> basicPrintString [
	| sources |
	sources := self predecessors size > 0
		ifTrue: [
			(self predecessors collect: [:block | block name , '->' , (self atOperand: block) primitivePrintString])
				gather: [:x | x , ', ']]
		ifFalse: ['  '].
	^'[phi(' , (sources allButLast: 2) , ')]'
]

{ #category : #unclassified }
OBlockParameter >> dissolve [
	| values |
	values := self variables.
	self remove.
	values do: [:value | value removeUseBy: self]
]

{ #category : #unclassified }
OBlockParameter >> dissolveReplacingWith: anInstruction [
	basicBlock afterInsert: anInstruction.
	self replaceAllUsesWith: anInstruction; dissolve
]

{ #category : #enumerating }
OBlockParameter >> do: aBlock [
	aBlock value: self.
	basicBlock do: aBlock
]

{ #category : #unclassified }
OBlockParameter >> index [
	^basicBlock indexOfParameter: self
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
OBlockParameter >> nextDetect: aBlock ifNone: absentBlock [
	^basicBlock nextDetect: aBlock ifNone: absentBlock
]

{ #category : #unclassified }
OBlockParameter >> operandsDo: aBlock [
	self predecessors do: [:block | | value |
		value := self atOperand: block.
		aBlock value: value]
]

{ #category : #enumerating }
OBlockParameter >> predecessors [
	^basicBlock predecessors
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
	sources := self predecessors size > 0
		ifTrue: [
			(self predecessors collect: [:block | self printEdge: block using: names])
				gather: [:x | x , ', ']]
		ifFalse: ['  '].
	^'phi(' , (sources allButLast: 2) , ')'
]

{ #category : #unclassified }
OBlockParameter >> remove [
	basicBlock removeParameter: self.
	basicBlock := nil
]

{ #category : #unclassified }
OBlockParameter >> removeBlock: removed [
	| last |
	(self atOperand: removed) removeUse: self at: removed.
	self atOperand: removed put: nil.
	self predecessors size = 1 ifFalse: [^self].
	last := self atOperand: self predecessors first.
	self replaceAllUsesWith: last; dissolve
]

{ #category : #enumerating }
OBlockParameter >> replaceBlock: original with: new [
	(self atOperand: new) updateUser: self named: original with: new
]

{ #category : #printing }
OBlockParameter >> shortPrintString [
	| sources |
	sources := self predecessors size > 0
		ifTrue: [(self predecessors collect: [:block | (self atOperand: block) primitivePrintString]) gather: [:x | x , ', ']]
		ifFalse: ['  '].
	^'[phi(' , (sources allButLast: 2) , ')]'
]

{ #category : #unclassified }
OBlockParameter >> trackArgumentFrom: predecessor [
	(self atOperand: predecessor) addUse: self at: predecessor
]

{ #category : #unclassified }
OBlockParameter >> untrackArgumentFrom: predecessor [
	(self atOperand: predecessor) removeUse: self at: predecessor
]

{ #category : #unclassified }
OBlockParameter >> usesResultOf: anInstruction [
	^self variables includes: anInstruction
]

{ #category : #unclassified }
OBlockParameter >> variables [
	^self predecessors collect: [:block | self atOperand: block]
]

{ #category : #unclassified }
OBlockParameter >> variablesWithBlocksDo: aBlock [
	self variables with: self predecessors copy do: aBlock
]

