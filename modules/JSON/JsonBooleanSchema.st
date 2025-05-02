"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #JsonBooleanSchema,
	#superclass : #JsonPrimitiveSchema,
	#category : #JSON
}

{ #category : #testing }
JsonBooleanSchema >> isBooleanSchema [
	^true
]

