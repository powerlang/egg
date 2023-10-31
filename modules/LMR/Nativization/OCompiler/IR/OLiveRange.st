"
    Copyright (c) 2020 Aucerna.
    See (MIT) license in root directory.
"

Class {
	#name : #OLiveRange,
	#superclass : #Object,
	#category : #IR
}

{ #category : #unclassified }
OLiveRange class >> new [
	^self basicNew initialize
]

{ #category : #testing }
OLiveRange >> isUsedBy: anInstruction [
	^self allDefinitions
		anySatisfy: [:definition | anInstruction usesResultOf: definition]
]

