"
Copyright (c) 2020-2023 Quorum Software.
	See (MIT) license in root directory.
"
Class {
	#name : #OStoreOperation,
	#superclass : #OMemoryOperation,
	#instVars : [
		'value'
	],
	#category : #'OCompiler-Core-IR'
}

{ #category : #'instance creation' }
OStoreOperation class >> base: anInstruction byteAt: indexInstruction put: anotherInstruction [
	^self new
		name: #_byteAt:put:;
		base: anInstruction;
		index: indexInstruction;
		value: anotherInstruction
]

{ #category : #'instance creation' }
OStoreOperation class >> base: anInstruction byteAtImm: anInteger put: anotherInstruction [
	^self new
		name: #_byteAt:put:;
		base: anInstruction;
		indexImm: anInteger;
		value: anotherInstruction
]

{ #category : #'instance creation' }
OStoreOperation class >> base: anInstruction longSlotAt: indexInstruction put: anotherInstruction [
	^self new
		name: #_longSlotAt:put:;
		base: anInstruction;
		index: indexInstruction;
		value: anotherInstruction
]

{ #category : #'instance creation' }
OStoreOperation class >> base: anInstruction longSlotAtImm: indexInstruction put: anotherInstruction [
	^self new
		name: #_longSlotAt:put:;
		base: anInstruction;
		indexImm: indexInstruction;
		value: anotherInstruction
]

{ #category : #'instance creation' }
OStoreOperation class >> base: anInstruction slotAt: anInteger put: anotherInstruction [
	^self new
		name: #_basicAt:put:;
		base: anInstruction;
		index: anInteger;
		value: anotherInstruction
]

{ #category : #'instance creation' }
OStoreOperation class >> base: anInstruction slotAtImm: anInteger put: anotherInstruction [
	^self new
		name: #_basicAt:put:;
		base: anInstruction;
		indexImm: anInteger;
		value: anotherInstruction
]

{ #category : #'instance creation' }
OStoreOperation class >> base: anInstruction uLongAt: anInteger put: anotherInstruction [
	^self new
		name: #_uLongAt:put:;
		base: anInstruction;
		index: anInteger;
		value: anotherInstruction
]

{ #category : #'instance creation' }
OStoreOperation class >> base: anInstruction uLongAtImm: indexInstruction put: anotherInstruction [
	^self new
		name: #_uLongAt:put:;
		base: anInstruction;
		indexImm: indexInstruction;
		value: anotherInstruction
]

{ #category : #accessing }
OStoreOperation >> atOperand: operandName [
	operandName = #value ifTrue: [^value].
	^super atOperand: operandName
]

{ #category : #accessing }
OStoreOperation >> atOperand: operandName put: instruction [
	operandName = #value
		ifTrue: [value := instruction]
		ifFalse: [super atOperand: operandName put: instruction]
]

{ #category : #private }
OStoreOperation >> basicAcceptVisitor: aVisitor [
	^aVisitor visitStore: self
]

{ #category : #private }
OStoreOperation >> basicPrintString [
	| b |
	b := base isInstruction
		ifTrue: [base primitivePrintString]
		ifFalse: [base printString].
	^'[' , b , ' ' , name , ' ' , index primitivePrintString , ', '
		, value primitivePrintString
		, ']'
]

{ #category : #private }
OStoreOperation >> copyTo: copy with: map [
	| v |
	super copyTo: copy with: map.
	v := value isInstruction
		ifTrue: [value duplicateWith: map]
		ifFalse: [value].
	copy value: v
]

{ #category : #testing }
OStoreOperation >> isStore [
	^true
]

{ #category : #private }
OStoreOperation >> operandsDo: aBlock [
	aBlock value: base.
	index isInstruction ifTrue: [aBlock value: index].
	aBlock value: value
]

{ #category : #private }
OStoreOperation >> printStringUsing: names [
	| b i v |
	b := names at: base ifAbsent: '?'.
	i := index isInstruction
		ifTrue: [names at: index ifAbsent: '?']
		ifFalse: [index printString].
	v := value isInstruction
		ifTrue: [names at: value ifAbsent: '?']
		ifFalse: [value printString].
	^'{#' , b , ' ' , name , ', ' , i , ',' , v , '}'
]

{ #category : #testing }
OStoreOperation >> usesResultOf: anInstruction [
	^value == anInstruction or: [super usesResultOf: anInstruction]
]

{ #category : #evaluating }
OStoreOperation >> value [
	^value
]

{ #category : #evaluating }
OStoreOperation >> value: anInstruction [
	value := anInstruction.
	anInstruction addUse: self at: #value
]

{ #category : #evaluating }
OStoreOperation >> valueImm: anObject [
	value := anObject
]
