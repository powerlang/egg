"
Copyright (c) 2020-2023 Quorum Software.
	See (MIT) license in root directory.
"
Class {
	#name : 'OBinaryConstantOperation',
	#superclass : 'OBinaryOperation',
	#category : 'OCompiler-Core-IR',
	#package : 'OCompiler-Core',
	#tag : 'IR'
}

{ #category : 'unclassified' }
OBinaryConstantOperation >> basicAcceptVisitor: aVisitor [
	^aVisitor visitBinaryWithConstant: self
]

{ #category : 'unclassified' }
OBinaryConstantOperation >> basicPrintString [
	^'[' , left primitivePrintString , ' ' , name , ' '
		, right primitivePrintString
		, ']'
]

{ #category : 'unclassified' }
OBinaryConstantOperation >> isBinaryConstantOperation [
	^true
]

{ #category : 'unclassified' }
OBinaryConstantOperation >> operandsDo: aBlock [
	aBlock value: left
]

{ #category : 'printing' }
OBinaryConstantOperation >> printStringUsing: names [
	^(names at: left ifAbsent: ['?']) , ' ' , name , ' ' , right printString
]

{ #category : 'accessing' }
OBinaryConstantOperation >> right: anInteger [
	right := anInteger
]
