"
Copyright (c) 2020-2023 Quorum Software.
	See (MIT) license in root directory.
"
Class {
	#name : 'OPrimitiveOperation',
	#superclass : 'OInstruction',
	#instVars : [
		'name'
	],
	#category : 'OCompiler-Core-IR',
	#package : 'OCompiler-Core',
	#tag : 'IR'
}

{ #category : 'unclassified' }
OPrimitiveOperation >> basicPrintString [
	^self primitivePrintString
]

{ #category : 'accessing' }
OPrimitiveOperation >> copyTo: copy with: map [
	super copyTo: copy with: map.
	copy name: name
]

{ #category : 'testing' }
OPrimitiveOperation >> isPrimitiveOperation [
	^true
]

{ #category : 'unclassified' }
OPrimitiveOperation >> name [
	^name
]

{ #category : 'unclassified' }
OPrimitiveOperation >> name: selector [
	name := selector
]

{ #category : 'unclassified' }
OPrimitiveOperation >> primitivePrintString [
	^'{#' , name , '}'
]

{ #category : 'unclassified' }
OPrimitiveOperation >> printStringUsing: names [
	^self primitivePrintString
]
