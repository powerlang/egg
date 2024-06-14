"
Copyright (c) 2020-2023 Quorum Software.
	See (MIT) license in root directory.
"
Class {
	#name : 'OBinaryVariableOperation',
	#superclass : 'OBinaryOperation',
	#category : 'OCompiler-Core-IR',
	#package : 'OCompiler-Core-IR'
}

{ #category : 'unclassified' }
OBinaryVariableOperation >> basicAcceptVisitor: aVisitor [
	^aVisitor visitBinaryWithVariable: self
]

{ #category : 'unclassified' }
OBinaryVariableOperation >> basicPrintString [
	^'[' , left primitivePrintString , ' ' , name , ' '
		, right primitivePrintString
		, ']'
]

{ #category : 'unclassified' }
OBinaryVariableOperation >> isBinaryVariableOperation [
	^true
]

{ #category : 'unclassified' }
OBinaryVariableOperation >> operandsDo: aBlock [
	aBlock value: left.
	aBlock value: right
]

{ #category : 'unclassified' }
OBinaryVariableOperation >> printStringUsing: names [
	^(names at: left ifAbsent: ['?']) , ' ' , name , ' '
		, (names at: right ifAbsent: ['?'])
]
