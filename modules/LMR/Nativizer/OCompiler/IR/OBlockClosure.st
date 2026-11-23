"
    Copyright (c) 2020 Aucerna.
    See (MIT) license in root directory.
"

Class {
	#name : #OBlockClosure,
	#superclass : #OInstruction,
	#instVars : [
		'firstBlock',
		'arguments'
	],
	#category : #IR
}

{ #category : #unclassified }
OBlockClosure class >> containing: initialBlock [
	^self new firstBlock: initialBlock
]

{ #category : #accessing }
OBlockClosure >> arguments [
	^arguments
]

{ #category : #accessing }
OBlockClosure >> arguments: aCollection [
	arguments := aCollection
]

{ #category : #unclassified }
OBlockClosure >> firstBlock [
	^firstBlock
]

{ #category : #unclassified }
OBlockClosure >> firstBlock: basicBlock [
	firstBlock := basicBlock
]

{ #category : #unclassified }
OBlockClosure >> isBlockClosure [
	^true
]

{ #category : #unclassified }
OBlockClosure >> lastBlock [
	^firstBlock lastBlock
]

{ #category : #unclassified }
OBlockClosure >> lastValue [
	^firstBlock lastBlock lastValue
]

{ #category : #private }
OBlockClosure >> operandsDo: aBlock [
	
]

