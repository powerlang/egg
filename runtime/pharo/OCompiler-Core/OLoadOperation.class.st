"
Copyright (c) 2020-2023 Quorum Software.
	See (MIT) license in root directory.
"
Class {
	#name : #OLoadOperation,
	#superclass : #OMemoryOperation,
	#category : #'OCompiler-Core-IR'
}

{ #category : #'instance creation' }
OLoadOperation class >> base: anInstruction byteAt: anInteger [
	^self new
		name: #_byteAt:;
		base: anInstruction;
		index: anInteger
]

{ #category : #'instance creation' }
OLoadOperation class >> base: anInstruction byteAtImm: anInteger [
	^self new
		name: #_byteAt:;
		base: anInstruction;
		indexImm: anInteger
]

{ #category : #'instance creation' }
OLoadOperation class >> base: anInstruction longSlotAt: anInteger [
	^self new
		name: #_longSlotAt:;
		base: anInstruction;
		index: anInteger
]

{ #category : #'instance creation' }
OLoadOperation class >> base: anInstruction longSlotAtImm: anInteger [
	^self new
		name: #_longSlotAt:;
		base: anInstruction;
		indexImm: anInteger
]

{ #category : #'instance creation' }
OLoadOperation class >> base: anInstruction slotAt: anInteger [
	^self new
		name: #_basicAt:;
		base: anInstruction;
		index: anInteger
]

{ #category : #'instance creation' }
OLoadOperation class >> base: anInstruction slotAtImm: anInteger [
	^self new
		name: #_basicAt:;
		base: anInstruction;
		indexImm: anInteger
]

{ #category : #'instance creation' }
OLoadOperation class >> base: anInstruction uLongAtImm: anInteger [
	^self new
		name: #_uLongAt:;
		base: anInstruction;
		indexImm: anInteger
]

{ #category : #private }
OLoadOperation >> basicAcceptVisitor: aVisitor [
	^aVisitor visitLoad: self
]

{ #category : #private }
OLoadOperation >> basicPrintString [
	^'[' , base primitivePrintString , ' ' , name , ' '
		, index primitivePrintString
		, ']'
]

{ #category : #private }
OLoadOperation >> canHaveSideEffects [
	^false
]

{ #category : #private }
OLoadOperation >> isLoad [
	^true
]

{ #category : #private }
OLoadOperation >> operandsDo: aBlock [
	aBlock value: base.
	index isInstruction ifTrue: [aBlock value: index]
]

{ #category : #private }
OLoadOperation >> printStringUsing: names [
	| b i |
	b := names at: base ifAbsent: ['?'].
	i := index isInstruction
		ifTrue: [names at: index ifAbsent: ['?']]
		ifFalse: [index printString].
	^'{#' , b , ' ' , name , ', ' , i , '}'
]
