"
Copyright (c) 2020-2023 Quorum Software.
	See (MIT) license in root directory.
"
Class {
	#name : 'OJumpTrue',
	#superclass : 'OJumpConditional',
	#category : 'OCompiler-Core-IR',
	#package : 'OCompiler-Core',
	#tag : 'IR'
}

{ #category : 'unclassified' }
OJumpTrue >> basicAcceptVisitor: aVisitor [
	^aVisitor visitJumpTrue: self
]

{ #category : 'unclassified' }
OJumpTrue >> basicPrintString [
	^'[jump true ' , variable primitivePrintString , ' to ' , target name
		, ' or fall to '
		, implicitTarget name
		, ']'
]

{ #category : 'unclassified' }
OJumpTrue >> isJumpFalse [
	^false
]

{ #category : 'unclassified' }
OJumpTrue >> isJumpTrue [
	^true
]

{ #category : 'unclassified' }
OJumpTrue >> primitivePrintString [
	^'{jump true}'
]

{ #category : 'printing' }
OJumpTrue >> printStringUsing: names [
	^'jump true ' , (names at: variable ifAbsent: ['?']) , ' to '
		, (names at: target ifAbsent: ['?'])
		, ' or fall to '
		, (names at: implicitTarget ifAbsent: ['?'])
]
