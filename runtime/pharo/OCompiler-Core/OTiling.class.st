"
Copyright (c) 2020-2023 Quorum Software.
	See (MIT) license in root directory.
"
Class {
	#name : 'OTiling',
	#superclass : 'Object',
	#instVars : [
		'action',
		'cost',
		'used',
		'instruction'
	],
	#category : 'OCompiler-Core-IR',
	#package : 'OCompiler-Core',
	#tag : 'IR'
}

{ #category : 'unclassified' }
OTiling class >> for: instruction [
	^self new instruction: instruction
]

{ #category : 'unclassified' }
OTiling >> beUsed [
	used := true
]

{ #category : 'unclassified' }
OTiling >> initialize [
	used := false
]

{ #category : 'unclassified' }
OTiling >> instruction [
	^instruction
]

{ #category : 'unclassified' }
OTiling >> instruction: anInstruction [
	instruction := anInstruction
]

{ #category : 'unclassified' }
OTiling >> isUsed [
	^used = true
]

{ #category : 'unclassified' }
OTiling >> printOn: aStream [
	aStream nextPutAll: self printString
]

{ #category : 'unclassified' }
OTiling >> printString [
	^'<tiling of ' , instruction printString , ' >'
]
