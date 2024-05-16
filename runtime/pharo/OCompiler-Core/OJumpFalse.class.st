"
Copyright (c) 2020-2023 Quorum Software.
	See (MIT) license in root directory.
"
Class {
	#name : #OJumpFalse,
	#superclass : #OJumpConditional,
	#category : #'OCompiler-Core-IR'
}

{ #category : #unclassified }
OJumpFalse >> basicAcceptVisitor: aVisitor [
	^aVisitor visitJumpFalse: self
]

{ #category : #unclassified }
OJumpFalse >> basicPrintString [
	^'[jump false ' , variable primitivePrintString , ' to ' , target name
		, ' or fall to '
		, implicitTarget name
		, ']'
]

{ #category : #unclassified }
OJumpFalse >> isJumpFalse [
	^true
]

{ #category : #unclassified }
OJumpFalse >> isJumpTrue [
	^false
]

{ #category : #unclassified }
OJumpFalse >> primitivePrintString [
	^'{jump false}'
]

{ #category : #printing }
OJumpFalse >> printStringUsing: names [
	^'jump false ' , (names at: variable ifAbsent: ['?']) , ' to '
		, (names at: target ifAbsent: ['?'])
		, ' or fall to '
		, (names at: implicitTarget ifAbsent: ['?'])
]
