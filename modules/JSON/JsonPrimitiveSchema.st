"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #JsonPrimitiveSchema,
	#superclass : #JsonSchema,
	#instVars : [
		'format'
	],
	#category : #JSON
}

{ #category : #accessing }
JsonPrimitiveSchema >> defaultFormat [
	^self subclassResponsibility
]

{ #category : #accessing }
JsonPrimitiveSchema >> format [
	^format ifNil: [self defaultFormat]
]

{ #category : #accessing }
JsonPrimitiveSchema >> format: anObject [
	format := anObject
]

{ #category : #testing }
JsonPrimitiveSchema >> isPrimitiveSchema [
	^true
]

{ #category : #validation }
JsonPrimitiveSchema >> targetClass [
	^Smalltalk at: self typeName asProperNoun asSymbol
]

