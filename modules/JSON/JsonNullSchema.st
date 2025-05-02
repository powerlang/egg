"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #JsonNullSchema,
	#superclass : #JsonPrimitiveSchema,
	#category : #JSON
}

{ #category : #testing }
JsonNullSchema >> isNullSchema [
	^true
]

{ #category : #validation }
JsonNullSchema >> targetClass [
	^UndefinedObject
]

