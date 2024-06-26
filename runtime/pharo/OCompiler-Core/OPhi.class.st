"
Copyright (c) 2020-2023 Quorum Software.
	See (MIT) license in root directory.
"
Class {
	#name : 'OPhi',
	#superclass : 'OInstruction',
	#instVars : [
		'variables',
		'blocks'
	],
	#category : 'OCompiler-Core-IR',
	#package : 'OCompiler-Core',
	#tag : 'IR'
}

{ #category : 'unclassified' }
OPhi class >> with: operation1
from: block1
with: operation2
from: block2 [
	^self new
		addVariable: operation1 from: block1;
		addVariable: operation2 from: block2
]

{ #category : 'unclassified' }
OPhi >> addVariable: value from: block [
	self DENY: (blocks includes: block).
	variables add: value.
	blocks add: block.
	value addUse: self at: block
]

{ #category : 'unclassified' }
OPhi >> atOperand: name [
	| index |
	index := blocks indexOf: name.
	^variables at: index
]

{ #category : 'unclassified' }
OPhi >> atOperand: name put: instruction [
	| index |
	index := blocks indexOf: name.
	variables at: index put: instruction
]

{ #category : 'unclassified' }
OPhi >> basicAcceptVisitor: aVisitor [
	^aVisitor visitPhi: self
]

{ #category : 'unclassified' }
OPhi >> basicPrintString [
	| sources |
	sources := variables size > 0
		ifTrue: [
			(variables
				with: blocks
				collect: [:var :block | block name , '->' , var primitivePrintString])
				gather: [:x | x , ', ']]
		ifFalse: ['  '].
	^'[phi(' , (sources allButLast: 2) , ')]'
]

{ #category : 'private' }
OPhi >> basicVariables: aCollection blocks: anotherCollection [
	blocks := anotherCollection.
	variables := aCollection
]

{ #category : 'enumerating' }
OPhi >> blocks [
	^blocks
]

{ #category : 'testing' }
OPhi >> canHaveSideEffects [
	^false
]

{ #category : 'unclassified' }
OPhi >> clearVariables [
	variables := OrderedCollection new.
	blocks := OrderedCollection new
]

{ #category : 'private' }
OPhi >> copyTo: copy with: map [
	| b v |
	super copyTo: copy with: map.
	b := blocks collect: [:block | block duplicateWith: map].
	v := variables collect: [:variable | variable duplicateWith: map].
	copy variables: v blocks: b
]

{ #category : 'unclassified' }
OPhi >> initialize [
	variables := OrderedCollection new.
	blocks := OrderedCollection new
]

{ #category : 'private' }
OPhi >> isBoolean [
	^variables conform: [:v | v isBoolean]
]

{ #category : 'unclassified' }
OPhi >> isPhi [
	^true
]

{ #category : 'unclassified' }
OPhi >> operandsDo: aBlock [
	variables do: aBlock
]

{ #category : 'unclassified' }
OPhi >> primitivePrintString [
	^'{#phi}'
]

{ #category : 'printing' }
OPhi >> printStringUsing: names [
	| sources |
	sources := variables size = 0 ifTrue: ['  '] ifFalse: [
		String streamContents: [:strm | 
			variables with: blocks do: [:var :block | 
				strm
					nextPutAll: (names at: block ifAbsent: '?');
					nextPutAll: '->';
					nextPutAll: (names at: var ifAbsent: '?');
					nextPutAll: ', ']]].
	^'phi(' , (sources allButLast: 2) , ')'
]

{ #category : 'enumerating' }
OPhi >> realReverseDo: aBlock [
	
]

{ #category : 'unclassified' }
OPhi >> removeBlock: removed [
	| index variable |
	index := blocks indexOf: removed.
	variable := variables at: index.
	variable removeUse: self at: removed.
	variables removeIndex: index.
	blocks removeIndex: index.
	self removeIfPossible
]

{ #category : 'unclassified' }
OPhi >> removeIfPossible [
	variables size = 1
		ifTrue: [self replaceAllUsesWith: variables first; dissolve]
]

{ #category : 'unclassified' }
OPhi >> removeVariable: removed at: index [
	| block |
	block := blocks at: index.
	removed removeUse: self at: block.
	variables removeIndex: index.
	blocks removeIndex: index.
	variables size = 1
		ifTrue: [self replaceAllUsesWith: variables first; dissolve]
]

{ #category : 'enumerating' }
OPhi >> replaceBlock: original with: new [
	blocks withIndexDo: [:block :i | | source |
		block == original ifTrue: [
			source := variables at: i.
			source updateUser: self named: original with: new.
			blocks at: i put: new]]
]

{ #category : 'printing' }
OPhi >> shortPrintString [
	| sources |
	sources := variables size > 0
		ifTrue: [(variables collect: #primitivePrintString) gather: [:x | x , ', ']]
		ifFalse: ['  '].
	^'[phi(' , (sources allButLast: 2) , ')]'
]

{ #category : 'unclassified' }
OPhi >> sortAfter: predecessors [
	| indices |
	indices := predecessors collect: [:pred | blocks indexOf: pred].
	variables := indices collect: [:index | variables at: index].
	blocks := predecessors copy
]

{ #category : 'unclassified' }
OPhi >> usesResultOf: anInstruction [
	^variables includes: anInstruction
]

{ #category : 'unclassified' }
OPhi >> variables [
	^variables
]

{ #category : 'unclassified' }
OPhi >> variables: aCollection blocks: anotherCollection [
	blocks := anotherCollection.
	variables := aCollection.
	variables with: blocks do: [:var :block | var addUse: self at: block]
]

{ #category : 'unclassified' }
OPhi >> variablesWithBlocksDo: aBlock [
	variables with: blocks do: aBlock
]
