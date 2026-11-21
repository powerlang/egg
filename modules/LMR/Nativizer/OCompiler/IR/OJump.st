"
    Copyright (c) 2020 Aucerna.
    See (MIT) license in root directory.
"

Class {
	#name : #OJump,
	#superclass : #OInstruction,
	#instVars : [
		'target',
		'arguments'
	],
	#category : #IR
}

{ #category : #unclassified }
OJump class >> to: aDestination [
	^self new target: aDestination
]

{ #category : #'jump arguments' }
OJump >> argumentFor: aPhi [
	| passed |
	passed := self argumentsTo: aPhi basicBlock.
	^passed at: aPhi index
]

{ #category : #'jump arguments' }
OJump >> argumentFor: aPhi put: value [
	| passed |
	passed := self argumentsTo: aPhi basicBlock.
	passed at: aPhi index put: value
]

{ #category : #'jump arguments' }
OJump >> argumentsTo: aBasicBlock [
	aBasicBlock == target ifFalse: [^self error: 'not a target of the jump'].
	^arguments
]

{ #category : #'jump arguments' }
OJump >> argumentsTo: aBasicBlock put: aCollection [
	aBasicBlock == target ifFalse: [^self error: 'not a target of the jump'].
	arguments := aCollection
]

{ #category : #unclassified }
OJump >> basicAcceptVisitor: aVisitor [
	^aVisitor visitJump: self
]

{ #category : #unclassified }
OJump >> basicPrintString [
	^'[jump to ' , target name , ']'
]

{ #category : #'jump arguments' }
OJump >> dissolveReplacingWith: aJump [
	self passArgumentsTo: aJump.
	super dissolveReplacingWith: aJump
]

{ #category : #initialization }
OJump >> initialize [
	arguments := OrderedCollection new
]

{ #category : #unclassified }
OJump >> isJump [
	^true
]

{ #category : #'jump arguments' }
OJump >> moveArgumentsTo: aJump for: aBasicBlock [
	| passed |
	passed := self argumentsTo: aBasicBlock.
	aJump argumentsTo: aBasicBlock put: passed
]

{ #category : #private }
OJump >> operandsDo: aBlock [
	
]

{ #category : #'jump arguments' }
OJump >> passArgumentsTo: aJump [
	| targets |
	targets := self targets.
	aJump successorsDo: [:block | (targets includes: block) ifTrue: [self passArgumentsTo: aJump for: block]]
]

{ #category : #'jump arguments' }
OJump >> passArgumentsTo: aJump for: aBasicBlock [
	| passed |
	passed := (self argumentsTo: aBasicBlock) copy.
	aJump argumentsTo: aBasicBlock put: passed
]

{ #category : #unclassified }
OJump >> primitivePrintString [
	^'{jump}'
]

{ #category : #unclassified }
OJump >> printStringUsing: names [
	^'jump to ' , (names at: target)
]

{ #category : #unclassified }
OJump >> retargetFrom: aBasicBlock to: otherBasicBlock [
	self target: otherBasicBlock
]

{ #category : #private }
OJump >> successorsDo: aBlock [
	aBlock value: target
]

{ #category : #unclassified }
OJump >> target [
	^target
]

{ #category : #unclassified }
OJump >> target: aBasicBlock [
	target == aBasicBlock ifFalse: [arguments := aBasicBlock newArguments].
	target := aBasicBlock
]

{ #category : #unclassified }
OJump >> targets [
	^OrderedCollection with: target
]

{ #category : #unclassified }
OJump >> usesResultOf: anInstruction [
	^false
]

