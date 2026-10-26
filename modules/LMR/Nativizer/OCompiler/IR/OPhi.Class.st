'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:39 pm'!
!classDefinition: #OPhi category: #IR!
OInstruction subclass: #OPhi
	instanceVariableNames: 'variables blocks'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'IR'!
!OPhi commentStamp: '<historical>' prior: 0!

    Copyright (c) 2020 Aucerna.
    See (MIT) license in root directory.
!

!OPhi methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
addVariable: value from: block
	self DENY: (blocks includes: block).
	variables add: value.
	blocks add: block.
	value addUse: self at: block
! !

!OPhi methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
atOperand: name
	| index |
	index := blocks indexOf: name.
	^variables at: index
! !

!OPhi methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
atOperand: name put: instruction
	| index |
	index := blocks indexOf: name.
	variables at: index put: instruction
! !

!OPhi methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
basicAcceptVisitor: aVisitor
	^aVisitor visitPhi: self
! !

!OPhi methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
basicPrintString
	| sources |
	sources := variables size > 0
		ifTrue: [
			(variables
				with: blocks
				collect: [:var :block | block name , '->' , var primitivePrintString])
				gather: [:x | x , ', ']]
		ifFalse: ['  '].
	^'[phi(' , (sources allButLast: 2) , ')]'
! !

!OPhi methodsFor:  'enumerating' stamp: 'KenD 28/Jun/2026 13:27:39'!
blocks
	^blocks
! !

!OPhi methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
blocks: aCollection
	blocks := aCollection
! !

!OPhi methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
clearVariables
	variables := OrderedCollection new.
	blocks := OrderedCollection new
! !

!OPhi methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
initialize
	variables := OrderedCollection new.
	blocks := OrderedCollection new
! !

!OPhi methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
isPhi
	^true
! !

!OPhi methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
operandsDo: aBlock
	variables do: aBlock
! !

!OPhi methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
primitivePrintString
	^'{#phi}'
! !

!OPhi methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
printStringUsing: names
	| sources |
	sources := variables size > 0
		ifTrue: [
			(variables
				with: blocks
				collect: [:var :block | (names at: block ifAbsent: ['missing']) , '->'
					, (names at: var ifAbsent: ['missing'])])
				gather: [:x | x , ', ']]
		ifFalse: ['  '].
	^'phi(' , (sources allButLast: 2) , ')'
! !

!OPhi methodsFor:  'enumerating' stamp: 'KenD 28/Jun/2026 13:27:39'!
realReverseDo: aBlock
	
! !

!OPhi methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
removeBlock: removed
	| index variable |
	index := blocks indexOf: removed.
	variable := variables at: index.
	variable removeUse: self at: removed.
	variables removeIndex: index.
	blocks removeIndex: index.
	variables size = 1 ifTrue: [
		self replaceAllUsesWith: variables first; dissolve.
		^variables first].
	^self
! !

!OPhi methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
removeVariable: removed at: index
	| block |
	block := blocks at: index.
	removed removeUse: self at: block.
	variables removeIndex: index.
	blocks removeIndex: index.
	variables size = 1
		ifTrue: [self replaceAllUsesWith: variables first; dissolve]
! !

!OPhi methodsFor:  'enumerating' stamp: 'KenD 28/Jun/2026 13:27:39'!
replaceBlock: original with: new
	blocks withIndexDo: [:block :i | | source |
		block == original ifTrue: [
			source := variables at: i.
			source updateUser: self named: original with: new.
			blocks at: i put: new]]
! !

!OPhi methodsFor:  'printing' stamp: 'KenD 28/Jun/2026 13:27:39'!
shortPrintString
	| sources |
	sources := variables size > 0
		ifTrue: [(variables collect: #primitivePrintString) gather: [:x | x , ', ']]
		ifFalse: ['  '].
	^'[phi(' , (sources allButLast: 2) , ')]'
! !

!OPhi methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
sortAfter: predecessors
	| indices |
	indices := predecessors collect: [:pred | blocks indexOf: pred].
	variables := indices collect: [:index | variables at: index].
	blocks := predecessors copy
! !

!OPhi methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
usesResultOf: anInstruction
	^variables includes: anInstruction
! !

!OPhi methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
variables
	^variables
! !

!OPhi methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
variables: aCollection
	variables := aCollection
! !

!OPhi methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
variablesWithBlocksDo: aBlock
	variables with: blocks do: aBlock
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'OPhi class' category: #IR!
OPhi class
	instanceVariableNames: ''!

!OPhi class methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
new
	^self basicNew initialize
! !

!OPhi class methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
with: operation1 from: block1 with: operation2 from: block2
	^self new
		addVariable: operation1 from: block1;
		addVariable: operation2 from: block2
! !

!OPhi class methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
withAll: operations in: blocks
	^self new variables: operations; blocks: blocks copy
! !


OPhi initialize!

