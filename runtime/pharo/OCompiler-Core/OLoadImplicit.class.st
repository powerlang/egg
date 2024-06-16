"
Copyright (c) 2020-2023 Quorum Software.
	See (MIT) license in root directory.
"
Class {
	#name : 'OLoadImplicit',
	#superclass : 'OInstruction',
	#instVars : [
		'name',
		'register'
	],
	#category : 'OCompiler-Core-IR',
	#package : 'OCompiler-Core-IR'
}

{ #category : 'unclassified' }
OLoadImplicit class >> named: aSymbol [
	^self new name: aSymbol
]

{ #category : 'unclassified' }
OLoadImplicit class >> self [
	^self new name: #self
]

{ #category : 'unclassified' }
OLoadImplicit >> basicAcceptVisitor: aVisitor [
	^aVisitor visitLoadImplicit: self
]

{ #category : 'unclassified' }
OLoadImplicit >> basicPrintString [
	^'[load implicit #' , name printString , ']'
]

{ #category : 'private' }
OLoadImplicit >> copyTo: copy with: map [
	super copyTo: copy with: map.
	copy name: name; register: register
]

{ #category : 'unclassified' }
OLoadImplicit >> isLoadImplicit [
	^true
]

{ #category : 'unclassified' }
OLoadImplicit >> name [
	^name
]

{ #category : 'unclassified' }
OLoadImplicit >> name: aSymbol [
	name := aSymbol
]

{ #category : 'unclassified' }
OLoadImplicit >> operandsDo: aBlock [
	
]

{ #category : 'unclassified' }
OLoadImplicit >> primitivePrintString [
	"
	^'<#' , source value printString , '>'
	"
	^'{#' , name printString , '}'
]

{ #category : 'unclassified' }
OLoadImplicit >> printStringUsing: names [
	^'#' , name printString
]

{ #category : 'accessing' }
OLoadImplicit >> register [
	^register
]

{ #category : 'accessing' }
OLoadImplicit >> register: aRegister [
	register := aRegister.
	register isInstruction ifTrue: [self halt]
]

{ #category : 'unclassified' }
OLoadImplicit >> usesResultOf: anInstruction [
	^false
]
