"
Copyright (c) 2020-2023 Quorum Software.
	See (MIT) license in root directory.
"
Class {
	#name : 'OBlockClosure',
	#superclass : 'OInstruction',
	#instVars : [
		'firstBlock'
	],
	#category : 'OCompiler-Core-IR',
	#package : 'OCompiler-Core-IR'
}

{ #category : 'unclassified' }
OBlockClosure class >> containing: initialBlock [
	^self new firstBlock: initialBlock
]

{ #category : 'private' }
OBlockClosure >> copyTo: copy with: map [
	| first |
	super copyTo: copy with: map.
	first := firstBlock duplicateWith: map.
	copy firstBlock: first
]

{ #category : 'unclassified' }
OBlockClosure >> dissolveDeep [
	firstBlock withSuccessorsDo: [:block | block dissolveAllInstructions].
	super dissolveDeep
]

{ #category : 'unclassified' }
OBlockClosure >> firstBlock [
	^firstBlock
]

{ #category : 'unclassified' }
OBlockClosure >> firstBlock: basicBlock [
	firstBlock := basicBlock
]

{ #category : 'unclassified' }
OBlockClosure >> isBlockClosure [
	^true
]

{ #category : 'unclassified' }
OBlockClosure >> isUseless [
	^firstUse isNil
]

{ #category : 'unclassified' }
OBlockClosure >> lastBlock [
	^firstBlock lastBlock
]

{ #category : 'unclassified' }
OBlockClosure >> lastValue [
	^firstBlock lastBlock lastValue
]

{ #category : 'private' }
OBlockClosure >> operandsDo: aBlock [
	
]
